import requests
import json
import time
import os
import sys
from datetime import datetime

# Принудительно используем UTF-8 для вывода в консоль. Без этого в средах
# с кодировкой cp1251 (Windows-консоль по умолчанию) падают print с
# эмодзи/спецсимволами (✓, 📊). Это критично и для GitHub Actions.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

API_URL = "https://market.apineural.com/api/v2/store/items/all"
OUTPUT_FILE = "prices.json"
BACKUP_FILE = "prices_backup.json"

# Снимок текущего прогона. Каждый запуск = свежий сбор: база стартует с нуля,
# а снимок позволяет восстановиться после внезапного обрыва ТОГО ЖЕ запуска
# (в конце опубликовывается в prices.json и удаляется).
SNAPSHOT_FILE = "prices_snapshot.json"

AMOUNT = 72
MAX_PAGES_PER_QUERY = 120      # 120 за сессию
DELAY = 2.0
PAUSE_EVERY_30 = 30
RATE_LIMIT_PAUSE = 300
SAVE_EVERY = 20
HTTP_400_STREAK_STOP = 3

HEADERS = {
    "Content-Type": "application/json",
    "Accept": "*/*",
    "Accept-Language": "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7",
    "Origin": "https://starpets.gg",
    "Referer": "https://starpets.gg/",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36",
}

ALL_RARITIES = ["common", "uncommon", "rare", "ultra_rare", "legendary"]

# ==== ЗАПРОСЫ ====
# Простые типы (без вариантов)
SIMPLE_TYPES = ["egg", "potion", "transport", "stroller", "toy", "petwear", "gift"]

# Комбинации для петов (levels, flyable, rideable)
PET_COMBINATIONS = [
    ("default",   False, False),
    ("default",   True,  False),
    ("default",   False, True),
    ("default",   True,  True),
    ("neon",      False, False),
    ("neon",      True,  False),
    ("neon",      False, True),
    ("neon",      True,  True),
    ("mega_neon", False, False),
    ("mega_neon", True,  False),
    ("mega_neon", False, True),
    ("mega_neon", True,  True),
]

# Возраста обычных питомцев (для "default" уровня). Каждый возраст имеет свою
# цену, поэтому минимальная (актуальная) цена берётся по всем возрастам.
AGES = ["newborn", "junior", "pre_teen", "teen", "post_teen", "full_grown"]

# Состояния неона. У неонов нет возрастов (они не растут), но есть
# "уровни света" неона: flare, luminous, reborn, sparkle, sunshine, twinkle.
# Каждое состояние имеет свою цену — как возрасты у обычных питомцев.
# Для актуального минимума их тоже перебираем (фильтр "ages" их принимает).
NEON_STATES = ["flare", "luminous", "reborn", "sparkle", "sunshine", "twinkle"]

# Уровни, для которых перебираем возраста (default — обычные растут).
AGE_LEVELS = {"default"}

# Уровни, для которых перебираем состояния неона (neon растёт по "уровням света").
NEON_LEVELS = {"neon"}

# mega_neon — не перебираем ни возраста, ни состояния, у него их нет.


def build_key(name, pumping, flyable, rideable):
    key = name
    if pumping == "neon":
        key += "|Neon"
    elif pumping == "mega_neon":
        key += "|Mega"
    if flyable is True:
        key += "|Fly"
    if rideable is True:
        key += "|Ride"
    return key


def build_simple_payload(page, item_type):
    return {
        "amount": AMOUNT,
        "currency": "rub",
        "filter": {
            "types": [{"type": item_type, "rarities": ALL_RARITIES}]
        },
        "page": page,
        "sort": {"popularity": "desc"},
    }


def build_pet_payload(page, level, flyable, rideable, age=None):
    types_entry = {
        "type": "pet",
        "rarities": ALL_RARITIES,
        "levels": [level],
        "properties": {
            "missing": False,
            "flyable": flyable,
            "rideable": rideable,
        }
    }
    # Возраст/состояние добавляем ТОЛЬКО если он реально передан.
    # Для mega_neon age всегда None — фильтр не добавляется.
    if age:
        types_entry["ages"] = [age]

    return {
        "amount": AMOUNT,
        "currency": "rub",
        "filter": {
            "types": [types_entry]
        },
        "page": page,
        "sort": {"popularity": "desc"},
    }


def save_json(data, path):
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def load_json(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}


def fetch_page(session, payload):
    try:
        r = session.post(API_URL, json=payload, headers=HEADERS, timeout=30)
        if r.status_code == 429:
            return "RATE_LIMIT"
        if r.status_code != 200:
            return f"HTTP_{r.status_code}"
        return r.json()
    except Exception as e:
        return f"ERROR_{e}"


def merge_and_save(existing, fresh, path):
    """Сливает свежие данные, сохраняя МИНИМАЛЬНУЮ цену по каждому ключу.

    Цель: цена питомца = самая низкая цена среди всех возрастов и всех
    наблюдаемых лотов. Если свежая цена >= уже сохранённой, она пропускается.
    """
    merged = dict(existing)
    for k, v in fresh.items():
        if k in merged and isinstance(merged[k], dict) and isinstance(v, dict):
            old_price = merged[k].get("price")
            new_price = v.get("price")
            if old_price is not None and new_price is not None and new_price >= old_price:
                continue  # новая цена не ниже — оставляем минимум
        merged[k] = v
    save_json(merged, path)
    return merged


def parse_query(session, existing, label, payload_builder):
    """Парсит одну комбинацию. Возвращает обновлённый existing."""
    print(f"\n===== {label} =====")
    
    fresh = {}
    page = 1
    http_400_streak = 0
    rate_limit_count = 0
    empty_streak = 0
    total_lots = 0
    
    while page <= MAX_PAGES_PER_QUERY:
        payload = payload_builder(page)
        data = fetch_page(session, payload)
        
        if data == "RATE_LIMIT":
            if fresh:
                existing = merge_and_save(existing, fresh, SNAPSHOT_FILE)
                fresh = {}
            rate_limit_count += 1
            http_400_streak = 0
            print(f"  [429] Пауза {RATE_LIMIT_PAUSE} сек")
            time.sleep(RATE_LIMIT_PAUSE)
            if rate_limit_count >= 5:
                break
            continue
        
        if isinstance(data, str):
            http_400_streak += 1
            print(f"  [!] {data[:40]} стр.{page} (стрик {http_400_streak})")
            if http_400_streak >= HTTP_400_STREAK_STOP:
                print(f"  [!] Стоп на {label}")
                break
            page += 1
            time.sleep(5)
            continue
        
        http_400_streak = 0
        rate_limit_count = 0
        items = data.get("items") or []
        
        if not items:
            empty_streak += 1
            if empty_streak >= 2:
                break
            page += 1
            continue
        else:
            empty_streak = 0
        
        total_lots += len(items)
        
        for it in items:
            name = it.get("name")
            if not name: continue
            price = it.get("price")
            if price is None: continue
            
            key = build_key(
                name,
                it.get("pumping"),
                it.get("flyable"),
                it.get("rideable")
            )

            entry = {
                "price": price,
                "avgPrice": it.get("avgPrice"),
                "type": it.get("type"),
                "rare": it.get("rare"),
                "pumping": it.get("pumping"),
                "flyable": it.get("flyable"),
                "rideable": it.get("rideable"),
                "imageUri": it.get("imageUri"),
                # realName — внутреннее имя питомца на сайте. Оно совпадает с
                # internal_name в icons.json, что позволяет merge.py СВЯЗЫВАТЬ
                # ассет игры <-> имя на сайте АВТОМАТИЧЕСКИ, без ручных алиасов.
                "realName": it.get("realName"),
                "updatedAt": datetime.now().isoformat(),
            }

            # Минимум внутри запуска: если по ключу уже есть цена ниже/равная — пропускаем.
            if key in fresh and isinstance(fresh[key], dict):
                old_price = fresh[key].get("price")
                if old_price is not None and price is not None and price >= old_price:
                    continue

            fresh[key] = entry
        
        if page % 20 == 0:
            print(f"  [стр. {page}] лотов: {total_lots} | ключей: {len(fresh)}")
        
        page += 1
        
        if page % 30 == 0:
            time.sleep(PAUSE_EVERY_30)
        else:
            time.sleep(DELAY)
    
    if fresh:
        existing = merge_and_save(existing, fresh, SNAPSHOT_FILE)
        print(f"  [✓] {label}: +{len(fresh)} ключей | всего: {len(existing)}")
    
    return existing


def main():
    session = requests.Session()
    
    # ---- Каждый запуск = СВЕЖИЙ СБОР ----
    # Чтобы цена всегда была АКТУАЛЬНОЙ (соответствовала текущему рынку StarPets),
    # каждый запуск парсера начинается с ПУСТОЙ базы. Минимум берётся только
    # по возрастам ВНУТРИ этого прогона. Никакого залипания на прошлых минимумах.
    # prices_snapshot.json служит лишь точкой восстановления при внезапном обрыве
    # ТОГО ЖЕ запуска (в конце он удаляется).
    existing = {}
    for f in (SNAPSHOT_FILE,):
        if os.path.exists(f):
            os.remove(f)

    print(f"[*] Свежий сбор (каждый запуск — актуальные цены)")
    print(f"    - простых типов: {len(SIMPLE_TYPES)}")
    print(f"    - комбинаций петов: {len(PET_COMBINATIONS)}")
    print(f"    - возрастов (для обычных): {len(AGES)}")
    print(f"    - состояний неона: {len(NEON_STATES)}")
    # Обычные: 4 default-комбинации x 6 возрастов.
    # Неон: 4 neon-комбинации x 6 состояний.
    # Мега: 4 mega_neon-комбинации x 1 запрос (без возрастов/состояний).
    default_combos = sum(1 for l, _, _ in PET_COMBINATIONS if l in AGE_LEVELS)
    neon_combos = sum(1 for l, _, _ in PET_COMBINATIONS if l in NEON_LEVELS)
    mega_combos = len(PET_COMBINATIONS) - default_combos - neon_combos
    est = default_combos * len(AGES) + neon_combos * len(NEON_STATES) + mega_combos
    print(f"[*] Оценка: ~{est} запросов к API")
    print()
    
    try:
        # ==== ПРОСТЫЕ ТИПЫ ====
        for item_type in SIMPLE_TYPES:
            existing = parse_query(
                session, existing,
                f"type={item_type}",
                lambda p, t=item_type: build_simple_payload(p, t)
            )
            save_json(existing, SNAPSHOT_FILE)
        
        # ==== ПЕТЫ ПО КОМБИНАЦИЯМ ====
        for level, flyable, rideable in PET_COMBINATIONS:
            if level in AGE_LEVELS:
                # Обычные питомцы: перебираем все возраста и берём минимум цены.
                for age in AGES:
                    label = f"pet|{level}|age={age}|fly={flyable}|ride={rideable}"
                    existing = parse_query(
                        session, existing,
                        label,
                        lambda p, l=level, f=flyable, r=rideable, a=age:
                            build_pet_payload(p, l, f, r, a)
                    )
                    save_json(existing, SNAPSHOT_FILE)
            elif level in NEON_LEVELS:
                # neon: нет возрастов, но есть состояния неона.
                # Перебираем их, чтобы взять актуальный минимум, как у обычных.
                for state in NEON_STATES:
                    label = f"pet|{level}|neon_state={state}|fly={flyable}|ride={rideable}"
                    existing = parse_query(
                        session, existing,
                        label,
                        lambda p, l=level, f=flyable, r=rideable, s=state:
                            build_pet_payload(p, l, f, r, s)
                    )
                    save_json(existing, SNAPSHOT_FILE)
            else:
                # mega_neon: ни возрастов, ни состояний — один запрос на комбинацию.
                label = f"pet|{level}|fly={flyable}|ride={rideable}"
                existing = parse_query(
                    session, existing,
                    label,
                    lambda p, l=level, f=flyable, r=rideable:
                        build_pet_payload(p, l, f, r, None)
                )
                save_json(existing, SNAPSHOT_FILE)
    
    except KeyboardInterrupt:
        print("\n[!] Прервано")
    
    finally:
        # Публикуем свежий результат прогона в prices.json и убираем временный снимок.
        final = load_json(SNAPSHOT_FILE)
        save_json(final, OUTPUT_FILE)
        if os.path.exists(SNAPSHOT_FILE):
            os.remove(SNAPSHOT_FILE)
        
        print()
        print("=" * 50)
        print(f"📊 ИТОГО: {len(final)}")
        print("=" * 50)
        
        # Статистика
        types_count = {}
        for k, v in final.items():
            t = v.get("type", "?") if isinstance(v, dict) else "?"
            types_count[t] = types_count.get(t, 0) + 1
        print("\nПо типам:")
        for t, c in sorted(types_count.items(), key=lambda x: -x[1]):
            print(f"  {t}: {c}")
        
        mega = sum(1 for k in final if "Mega" in k)
        neon = sum(1 for k in final if "Neon" in k and "Mega" not in k)
        fr = sum(1 for k in final if "Fly|Ride" in k)
        print(f"\nMega: {mega} | Neon: {neon} | Fly|Ride: {fr}")
        
        print("\nПримеры:")
        for ex in ["Cat", "Cat|Neon", "Cat|Mega|Fly|Ride", "Frost Dragon", "Bat Dragon|Fly|Ride"]:
            if ex in final:
                print(f"  {ex} = {final[ex].get('price')} ₽")


if __name__ == "__main__":
    main()