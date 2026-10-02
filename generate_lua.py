"""generate_lua.py — встраивает актуальные цены (icons_priced.json) в overlay.lua.

GitHub Actions запускает этот скрипт после парсера+merge, и он позволяет
игроку получать свежие цены через простой loadstring(game:HttpGet(...))().
"""
import json
import os
import sys

# UTF-8 для вывода (иначе emoji/кириллица падают в cp1251-консолях)
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_FILE = "overlay.lua"
PRICES_FILE = "icons_priced.json"
BEGIN = "=====BEGIN_PRICES====="
END = "=====END_PRICES====="


def lua_value(v):
    """Рекурсивно конвертирует Python-значение в корректный Lua-литерал."""
    if v is None:
        return "nil"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        # Целые без дроби — как числа; иначе с плавающей точкой
        if isinstance(v, float) and v.is_integer():
            return str(int(v))
        return repr(v)
    if isinstance(v, str):
        return '"%s"' % v.replace("\\", "\\\\").replace('"', '\\"')
    if isinstance(v, list):
        return "{" + ", ".join(lua_value(x) for x in v) + "}"
    if isinstance(v, dict):
        parts = []
        for k, val in v.items():
            kk = lua_key(k)
            parts.append("[%s] = %s" % (kk, lua_value(val)))
        return "{" + ", ".join(parts) + "}"
    return "nil"


def lua_key(k):
    if isinstance(k, str):
        # Ключи-строки, совместимые с идентификатором, можно без скобок,
        # но безопаснее всегда в кавычках через [""].
        return '"%s"' % k
    return str(k)


def main():
    if not os.path.exists(PRICES_FILE):
        print("Нет %s — пропускаю генерацию" % PRICES_FILE)
        return

    with open(PRICES_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not data:
        print("icons_priced.json пуст — пропускаю")
        return

    # Формируем Lua-таблицу: ["rbxassetid://..."] = {name=..., prices={...}}
    lines = ["local PRICES_DATA = {"]
    for asset_id, info in data.items():
        name = info.get("name", "")
        prices = info.get("prices", {})
        price_str = ", ".join(
            '["%s"] = %s' % (v, lua_value(p)) for v, p in prices.items()
        )
        lines.append('    ["%s"] = {name = %s, prices = {%s}},' % (
            asset_id, lua_value(name), price_str))
    lines.append("}")
    data_block = "\n".join(lines)

    with open(SCRIPT_FILE, "r", encoding="utf-8") as f:
        content = f.read()

    # Заменяем блок между маркерами
    start = content.find(BEGIN)
    end = content.find(END)
    if start == -1 or end == -1:
        raise SystemExit("Маркеры BEGIN/END не найдены в %s" % SCRIPT_FILE)

    start_content = content[: start + len(BEGIN)] + "\n"
    end_content = content[end:]
    new_content = start_content + data_block + "\n" + end_content

    with open(SCRIPT_FILE, "w", encoding="utf-8") as f:
        f.write(new_content)

    print("✅ Встроено цен: %d питомцев в %s" % (len(data), SCRIPT_FILE))


if __name__ == "__main__":
    main()
