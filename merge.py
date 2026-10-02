import json
import re
import sys

# UTF-8 для вывода (иначе emoji/кириллица падают в cp1251-консолях)
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# ===== АЛИАСЫ (ручные соответствия) =====
ALIASES = {
    "trex": "T-Rex",
    "bull_icon": "Bull",
    "orangutan_icon": "Orangutan",
    "rabbit_icon": "Rabbit",
    "moon_egg_icon": "Moon Egg",
    "robot_chicken": "Robot Chicken",
    "huntsrobin": "Huntsman Robin",
    "blind_mice": "Three Blind Mice",
    "shark_doggo": "Shark Puppy",
    "hotdog_dog": "Hot Doggo",
    "2d_dog": "2D Doggy",
    "golden_chow_chow": "Golden Chow-Chow",
    "black_chow_chow": "Black Chow-Chow",
    "chocolate_chow_chow": "Chocolate Chow-Chow",
    "moon_2025_royal_egg": "Royal Moon Egg",
    "desert_2024_royal_egg": "Royal Desert Egg",
    "lny_2022_dragon": "Dancing Dragon",
    "halloween_2021_ghost_dragon": "Halloween White Ghost Dragon",
    "2d_refresh_2026_2d_dog": "2D Doggy",
    "summerfest_2023_hotdog_dog": "Hot Doggo",
    "fairytale_egg_2026_blind_mice": "Three Blind Mice",
    "fairytale_egg_2026_huntsrobin": "Huntsman Robin",
    "seasia_2023_egg": "Southeast Asia Egg",
    "summerfest_2023_shark_doggo": "Shark Puppy",
    "vip_2022_chow_chow_gold": "Golden Chow-Chow",
    "vip_2022_chow_chow_dark_brown": "Chocolate Chow-Chow",
    "vip_2022_chow_chow_black": "Black Chow-Chow",
    "lny_2023_qiongchi": "Winged Tiger",
    "admin_abuse_egg_2026_egg": "Admin Abuse Egg",
    "lny_2023_moon_moon_bear": "Lunar Moon Bear",
    "sanctuary_2022_green_premium_butterfly": "Green Butterfly",
    "winter_2023_chocolate_chip_bat_dragon": "Chocolate Chip Bat Dragon",
    "winter_2022_strawberry_shortcake_bat_dragon": "Strawberry Shortcake Bat Dragon",
    "subscription_2026_red_dutch_guinea_pig": "Red Dutch Guinea Pig",
    "gru_2022_zodiac_egg": "Zodiac Minion Egg",
    "lny_2022_tiger_gold": "Lunar Gold Tiger",
    "winter_2022_shetland_pony_light_brown": "Shetland Pony Light Brown",
    "sanctuary_2022_diamond_premium_butterfly": "Diamond Butterfly",
    "roblox_anniversary_2026_blue_cat": "Blue Cat",
    "salon_revamp_2026_moonbeam_peacock": "Moonbeam Peacock",
    "sky_ux_2023_cuddly_candle": "Cuddly Candle",
    "aztec_egg_2025_winged_snake": "Winged Snake",
    "aztec_egg_2025_royal_aztec_egg": "Royal Aztec Egg",
    "aztec_egg_2025_aztec_egg": "Aztec Egg",
    "butterfly_2025_orchid_butterfly": "Orchid Butterfly",
    "moon_2025_egg": "Moon Egg",
    "camping_2025_papa_moose": "Papa Moose",
    "2d_tuesdays_2025_2d_kitty": "2D Kitty",
    "spring_2025_spiked_kaijunior": "Spiked Kaijunior",
    "halloween_2025_bat_cat": "Kitty Bat",
    "seasia_2023_tree_kangaroo": "Tree Kangaroo",
    "admin_abuse_egg_2026_robot_chicken": "Robot Chicken",
    "summer_2026_lake_monster": "Lake Monster",
    "rgb_chameleon": "Chameleon",
    "summer_2026_acorn_wizard": "Acorn Wizard",
    "bfriday_2023_mecha_meow": "Mecha Meow",
    "gorilla_fair_2023_emperor_gorilla": "Emperor Gorilla",
    "subscription_2026_tortoise_shell_guinea_pig": "Tortoise Shell Guinea Pig",
    "halloween_2021_golden_mummy_cat": "Halloween Golden Mummy Cat",
    "halloween_2025_spider_4": "Spider 4",
    "urban_2023_egg": "Urban Egg",
    "desert_2022_gold_scarab": "Gold Scarab",
    "seasia_2023_naga_dragon": "Naga Dragon",
    "camping_2025_moose_calf": "Moose Calf",
    "safari_egg": "Safari Egg",
    "japan_2022_egg": "Japan Egg",
    "garden_2024_egg": "Garden Egg",
    "salon_revamp_2026_peahen": "Peahen",
    "camping_2023_firefly": "Firefly",
    "danger_2023_egg": "Danger Egg",
    "desert_2024_egg": "Desert Egg",
    "gru_2022_zodiac_chick": "Zodiac Minion Chick",
    "jungle_egg": "Jungle Egg",
    "royal_egg": "Royal Egg",
    "mythic_egg": "Mythic Egg",
    "fossil_egg": "Fossil Egg",
    "ocean_egg": "Ocean Egg",
    "aussie_egg": "Aussie Egg",
    "farm_egg": "Farm Egg",
    "christmas_egg": "Christmas Egg",
    "woodland_2022_woodland_egg": "Woodland Egg",
    "regular_pet_egg": "Pet Egg",
    "starter_egg": "Starter Egg",
    "basic_egg_2022_ant": "Ant",
    "basic_egg_2022_swordfish": "Swordfish",
    "basic_egg_2022_camel": "Camel",
    "basic_egg_2022_zebra": "Zebra",
    "basic_egg_2022_donkey": "Donkey",
    "basic_egg_2022_poodle": "Poodle",
    "basic_egg_2022_robot": "Robot",
    "basic_egg_2022_parakeet": "Parakeet",
    "basic_egg_2022_corgi": "Corgi",
    "basic_egg_2022_dragonfly": "Dragonfly",
    "basic_egg_2022_mouse": "Mouse",
    "basic_egg_2022_orangutan": "Orangutan",
    "basic_egg_2022_alicorn": "Alicorn",
    "basic_egg_2022_ancient_dragon": "Ancient Dragon",
    # ===== НОВЫЕ алиасы из сбора логов =====
    "fall_2022_badger": "Badger",
    "rgb_squid": "Squid",
    "spring_2025_spiked_kaijunior": "Kaijunior",
    "lny_2022_tiger_white": "Lunar White Tiger",
    "lny_2022_tiger": "Lunar Tiger",
    "fairytale_egg_2026_thumbellina_caterpillar": "Caterpillar",
    "ice_dimension_2025_chilly_penguin": "Penguin",
    "fairytale_egg_2026_miss_muffet": "Ms. Muffet",
    "lny_2023_moon_bear": "Lunar Moon Bear",
    "shiba": "Shiba Inu",
    "dailies_2025_shih_tzu": "Shih Tzu",
    "fennec": "Fennec Fox",
    "royal_palace_2022_spaniel": "Royal Palace Spaniel",
    "sanctuary_2022_yellow_bucks_butterfly": "Yellow Butterfly",
    "journey_pass_2026_gecko_duck": "Gecko",
    "aztec_egg_2025_golden_lynx": "Lynx",
    "halloween_2023_cuteacabra": "Cute-A-Cabra",
}

# ===== ПРЕФИКСЫ =====
PREFIXES = [
    "winter_2024_", "winter_2023_", "winter_2022_", "winter_2021_", "winter_2025_",
    "summerfest_2024_", "summerfest_2023_", "summerfest_2025_",
    "summer_2026_", "summer_2025_", "spring_2025_", "springfest_2023_",
    "halloween_2024_", "halloween_2023_", "halloween_2022_", "halloween_2021_", "halloween_2025_",
    "valentines_2025_", "valentines_2026_",
    "lny_2022_", "lny_2023_", "lny_2026_",
    "lunar_2024_", "lunar_2025_",
    "basic_egg_2022_", "danger_2023_", "desert_2024_", "desert_2022_",
    "fossil_2024_", "urban_2023_", "japan_2022_", "jungle_2023_",
    "garden_2024_", "farm_2023_", "ocean_2024_", "pool_2023_",
    "woodland_2022_", "rain_2023_", "space_house_2022_", "random_pets_2022_",
    "random_pets_sept_2023_", "snow_2022_", "sugarfest_2026_",
    "ice_dimension_2025_", "fire_dimension_2024_", "moon_2025_",
    "star_rewards_2022_", "star_rewards_2026_",
    "sanctuary_2022_", "celestial_2024_", "endangered_2026_",
    "penguins_2025_", "butterfly_2025_", "hamstertime_2024_",
    "gorilla_fair_2023_", "gibbon_2025_", "capuchin_2024_",
    "scottish_2023_", "aussie_2024_",
    "roblox_anniversary_2026_", "roblox_classic_2024_",
    "food_pets_2026_", "fairytale_egg_2026_", "fairytale_2026_",
    "cat_cafe_2026_", "ice_cream_refresh_2022_",
    "april_fools_2022_", "april_fools_2023_",
    "dolls_2023_", "lures_2023_", "meme_2023_", "chiprac_2023_",
    "admin_abuse_2025_", "admin_abuse_egg_2026_",
    "soggy_spring_2026_", "journey_2026_", "bees_wagon_2026_",
    "what_the_fork_2026_", "inspector_shepherd_2026_",
    "house_pets_2025_", "releaser_refresh_2026_",
    "st_patricks_2025_", "beach_2024_",
    "birthday_2023_", "birthday_2024_", "birthday_2025_", "birthday_2026_",
    "sunshine_2024_", "modular_castles_2023_",
    "royal_palace_2022_", "jan_refresh_2023_",
    "ugc_refresh_2023_", "ugc_refresh_2024_",
    "ugc_rewards_2022_", "ugc_rewards_2023_",
    "ddlm_2024_", "easter_2024_", "easter_2022_",
    "sofahog_2024_", "kiwi_2023_", "pib_2022_", "gosh_2022_",
    "subscription_2024_", "subscription_2026_", "lss_2026_",
    "gifthat_november_2024_", "pet_recycler_2025_", "pet_progression_2026_",
    "salon_revamp_2026_", "sky_ux_2023_", "aztec_egg_2025_",
    "2d_tuesdays_2025_", "bfriday_2023_",
    "camping_2025_", "camping_2023_",
    "clay_2024_", "stone_2024_", "gru_2022_",
    "journey_pass_2026_", "dailies_2025_",
    "halloween_2025_",
]


def normalize(s):
    return s.lower().replace("_", " ").replace("-", " ").strip()


def strip_prefixes(name):
    result = name.lower()
    for prefix in PREFIXES:
        if result.startswith(prefix):
            result = result[len(prefix):]
            break
    result = re.sub(r"^\d+_", "", result)
    return result


def main():
    with open("icons.json", "r", encoding="utf-8") as f:
        icons = json.load(f)

    with open("prices.json", "r", encoding="utf-8") as f:
        prices_raw = json.load(f)

    # ---- ОСНОВНАЯ БАЗА: adoptme_pets_final.json + adoptme_items.json ----
    # Полная база Adopt Me: pets ({"id","icon","displayName"}) и items ({"id","icon"}).
    # Это главный мост "иконка в игре <-> имя на сайте". Для питомцев используем
    # displayName, для предметов — id -> realName (из prices.json) -> display name.
    BASE_FILES = ["adoptme_pets_final.json", "adoptme_items.json"]
    base_records = []
    for bf in BASE_FILES:
        try:
            with open(bf, "r", encoding="utf-8") as f:
                raw = json.load(f)
            recs = raw if isinstance(raw, list) else list(raw.values())
            base_records.extend(recs)
            print("[*] База %s: %d записей" % (bf, len(recs)))
        except (FileNotFoundError, json.JSONDecodeError) as e:
            print("[!] Не могу загрузить %s: %s" % (bf, e))

    # Индексы базы: по rbxassetid (icon) и по внутреннему имени (id)
    base_by_icon = {}   # rbxassetid -> displayName (если есть) ИЛИ id (fallback)
    base_id_required = {}  # rbxassetid -> True, если displayName не было (нужен realName)
    base_by_id = {}     # id -> displayName (если есть)
    for rec in base_records:
        if not isinstance(rec, dict):
            continue
        icon = rec.get("icon")
        dn = rec.get("displayName")
        bid = rec.get("id")
        if icon and dn and icon not in base_by_icon:
            base_by_icon[icon] = dn
        elif icon and not dn and icon not in base_id_required:
            # у предмета нет displayName — запомним, что цену надо искать через id->realName
            base_id_required[icon] = bid
        if bid and dn and bid not in base_by_id:
            base_by_id[bid] = dn

    prices_by_name = {}
    for key, data in prices_raw.items():
        parts = key.split("|")
        name = parts[0]
        if name not in prices_by_name:
            prices_by_name[name] = {}
        variant = "|".join(parts[1:]) if len(parts) > 1 else "default"
        if isinstance(data, dict):
            prices_by_name[name][variant] = {
                "price": data.get("price"),
                "avgPrice": data.get("avgPrice"),
                "type": data.get("type"),
                "rare": data.get("rare"),
            }

    prices_norm = {}
    for name, variants in prices_by_name.items():
        n = normalize(name)
        if n not in prices_norm:
            prices_norm[n] = (name, variants)

    # ---- ЗАПАСНОЙ МОСТ: realName -> display name ----
    realname_map = {}
    for key, data in prices_raw.items():
        name_part = key.split("|")[0]
        rn = data.get("realName") if isinstance(data, dict) else None
        if rn and rn not in realname_map:
            realname_map[rn] = name_part

    matched = {}
    unmatched = []
    base_linked = []   # has icon in base, but no price on site (для отчёта)
    total_variants = 0
    by_base = 0
    by_realname = 0
    by_alias = 0
    by_prefix = 0

    def push(target, bucket):
        nonlocal total_variants
        variants = prices_by_name[target]
        total_variants += len(variants)
        return variants

    for asset_id, internal_name in icons.items():
        candidates = []
        source = None

        # 1) ОСНОВНАЯ БАЗА по rbxassetid (icon) — самый точный мост
        if asset_id in base_by_icon:
            target = base_by_icon[asset_id]
            if target in prices_by_name:
                candidates.append(target); by_base += 1; source = "base@icon"
            elif normalize(target) in prices_norm:
                candidates.append(prices_norm[normalize(target)][0]); by_base += 1; source = "base@icon"

        # 1.5) ПРЕДМЕТ из adoptme_items: нет displayName, цену ищем через id -> realName
        if not candidates and asset_id in base_id_required:
            item_id = base_id_required[asset_id]
            if item_id in realname_map:
                target = realname_map[item_id]
                if target in prices_by_name:
                    candidates.append(target); by_base += 1; source = "base@item-realName"
                elif normalize(target) in prices_norm:
                    candidates.append(prices_norm[normalize(target)][0]); by_base += 1; source = "base@item-realName"

        # 2) ОСНОВНАЯ БАЗА по внутреннему имени (id)
        if not candidates and internal_name in base_by_id:
            target = base_by_id[internal_name]
            if target in prices_by_name:
                candidates.append(target); by_base += 1; source = "base@id"
            elif normalize(target) in prices_norm:
                candidates.append(prices_norm[normalize(target)][0]); by_base += 1; source = "base@id"

        # 3) realName-мост (если нет в основной базе)
        if not candidates and internal_name in realname_map:
            target = realname_map[internal_name]
            if target in prices_by_name:
                candidates.append(target); by_realname += 1; source = "realName"
            elif normalize(target) in prices_norm:
                candidates.append(prices_norm[normalize(target)][0]); by_realname += 1; source = "realName"

        # 4) Ручной алиас
        if not candidates and internal_name in ALIASES:
            target = ALIASES[internal_name]
            if target in prices_by_name:
                candidates.append(target); by_alias += 1; source = "alias"
            elif normalize(target) in prices_norm:
                candidates.append(prices_norm[normalize(target)][0]); by_alias += 1; source = "alias"

        # 5) Прямое имя
        if not candidates and internal_name in prices_by_name:
            candidates.append(internal_name); source = "exact"

        # 6) Префиксы (снятие временных префиксов)
        if not candidates:
            stripped = strip_prefixes(internal_name)
            if stripped in realname_map:
                target = realname_map[stripped]
                if target in prices_by_name:
                    candidates.append(target); by_realname += 1; source = "realName+prefix"
                elif normalize(target) in prices_norm:
                    candidates.append(prices_norm[normalize(target)][0]); by_realname += 1; source = "realName+prefix"
            elif stripped in prices_by_name:
                candidates.append(stripped); by_prefix += 1; source = "prefix"
            else:
                n = normalize(stripped)
                if n in prices_norm:
                    candidates.append(prices_norm[n][0]); by_prefix += 1; source = "prefix"

        if not candidates:
            # Различаем: есть в основной базе, но нет цены на сайте (важно для отчёта)
            if asset_id in base_by_icon or internal_name in base_by_id:
                base_linked.append((asset_id, internal_name, base_by_icon.get(asset_id) or base_by_id.get(internal_name)))
            else:
                unmatched.append((asset_id, internal_name, "нет ни в базе, ни в ценах"))
            continue

        real_name = candidates[0]
        variants = prices_by_name[real_name]

        matched[asset_id] = {
            "name": real_name,
            "source": source,
            "prices": {v: d["price"] for v, d in variants.items()}
        }
        total_variants += len(variants)

    # ---- ПРЕДМЕТЫ из adoptme_items.json, которых нет в icons.json ----
    # Предметы имеют только {id, icon} (без displayName). Связываем с ценой
    # через id -> realName (из prices.json). Добавляем только имеющие цену,
    # чтобы не плодить "?" у не продаваемых предметов.
    items_added = 0
    items_noprice = 0
    for rec in base_records:
        if not isinstance(rec, dict):
            continue
        icon = rec.get("icon")
        pname = rec.get("displayName")
        pid = rec.get("id")
        if not icon or icon in matched:
            continue
        # префикс records: только items (имеют icon и id, но НЕ displayName,
        # либо displayName есть но это уже питомец из pets). Обрабатываем всех,
        # кого ещё нет в matched.
        if pname and pname in prices_by_name:
            matched[icon] = {
                "name": pname,
                "source": "items@displayName",
                "prices": {v: d["price"] for v, d in prices_by_name[pname].items()}
            }
            total_variants += len(prices_by_name[pname])
            items_added += 1
            continue
        if pid and pid in realname_map:
            target = realname_map[pid]
            if target in prices_by_name:
                matched[icon] = {
                    "name": target,
                    "source": "items@realName",
                    "prices": {v: d["price"] for v, d in prices_by_name[target].items()}
                }
                total_variants += len(prices_by_name[target])
                items_added += 1
                continue
        # нет цены на сайте (не продаётся) — пропускаем (не добавляем в скрипт)
        items_noprice += 1

    print(f"✅ Совпало: {len(matched)} всего (питомцы + предметы)")
    print(f"   - питомцев из icons.json: {len(icons)} обработано")
    print(f"   - предметов добавлено из adoptme_items: {items_added}")
    print(f"   - предметов без цены на сайте (пропущено): {items_noprice}")
    print(f"   - по базе: {by_base}")
    print(f"   - по realName: {by_realname}")
    print(f"   - по алиасам: {by_alias}")
    print(f"   - по префиксам: {by_prefix}")
    print(f"❌ Не совпало (нет цены на сайте): {len(base_linked)}")
    print(f"❌ Не совпало (нет ни в базе, ни в ценах): {len(unmatched)}")
    print(f"📊 Всего вариантов цен: {total_variants}")
    print()

    # ---- ОТЧЁТ о несопоставленных ----
    with open("unmatched_report.txt", "w", encoding="utf-8") as f:
        f.write("=== Питомцы в базе adoptme_pets_final.json, но БЕЗ цены на StarPets ===\n")
        for asset, internal, dn in sorted(base_linked, key=lambda x: x[1]):
            f.write("  id=%s | rbxassetid=%s | displayName=%s\n" % (internal, asset, dn))
        f.write("\n=== Питомцы НЕ найденные ни в базе, ни в ценах ===\n")
        for asset, internal, _ in sorted(unmatched, key=lambda x: x[1]):
            f.write("  id=%s | rbxassetid=%s\n" % (internal, asset))
    print(f"📄 Отчёт о несопоставленных: unmatched_report.txt ({len(base_linked)} в базе без цены, {len(unmatched)} нигде)")

    if unmatched:
        print("\nНЕ найдено ни в базе, ни в ценах (первые 30):")
        for asset, internal, _ in unmatched[:30]:
            print(f"  {internal}")

    with open("icons_priced.json", "w", encoding="utf-8") as f:
        json.dump(matched, f, ensure_ascii=False, indent=2)

    print(f"✅ Сохранено в icons_priced.json")


if __name__ == "__main__":
    main()