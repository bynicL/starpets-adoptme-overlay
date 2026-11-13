-- ============================================
--  Adopt Me Price Overlay — ПУБЛИЧНАЯ ВЕРСИЯ
--  Один файл: логика + встроенные актуальные цены
--  Игрок запускает: loadstring(game:HttpGet("URL"))()
-- ============================================
-- Ждём полной загрузки игры (иначе LocalPlayer/PlayerGui могут быть nil -> скрипт упадёт)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("===== ADOPT ME PRICE OVERLAY (public) =====")

-- Надёжный поиск PlayerGui с ожиданием LocalPlayer при необходимости
local function get_player_gui()
    local p = game.Players.LocalPlayer
    if not p then
        game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        p = game.Players.LocalPlayer
    end
    if not p then return nil end
    return p:FindFirstChild("PlayerGui")
end
local PG = get_player_gui()
local DISCORD_URL = "https://discord.gg/QsxA7ybDa"

-- ===== ВСТРОЕННЫЕ ДАННЫЕ (заполняет генератор / GitHub Actions) =====
-- Структура: ["rbxassetid://..."] = { name="...", prices={ ["default"]=цена, ... } }
-- =====BEGIN_PRICES=====
local PRICES_DATA = {
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 961.1, ["Fly"] = 1127.55, ["Ride"] = 1133.55, ["Fly|Ride"] = 1312.5, ["Neon"] = 6610.93, ["Neon|Ride"] = 4931.75, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 21174.57}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 413.44, ["Fly"] = 512.42, ["Ride"] = 442.86, ["Fly|Ride"] = 421.64, ["Neon|Fly|Ride"] = 1973.98, ["Mega"] = 9863.49, ["Mega|Fly|Ride"] = 8212.89}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 5250, ["Fly|Ride"] = 4749.94, ["Neon"] = 26066.29, ["Neon|Fly|Ride"] = 20463.69, ["Mega|Fly|Ride"] = 66926.75}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 154.28, ["Ride"] = 170.71, ["Fly|Ride"] = 224.44, ["Neon"] = 1416.63, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 3804.23, ["Mega|Fly|Ride"] = 2793.65}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 662.59, ["Ride"] = 538.12, ["Fly|Ride"] = 565.04, ["Neon|Ride"] = 1954.97, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 7019.67}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.83, ["Ride"] = 32.82, ["Fly|Ride"] = 141.62, ["Neon"] = 60.25, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 280.88, ["Mega|Ride"] = 466.98, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.25, ["Fly"] = 33.84, ["Ride"] = 23.26, ["Fly|Ride"] = 63.41, ["Neon"] = 19.69, ["Neon|Fly"] = 105.83, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 108.54, ["Mega"] = 156.71, ["Mega|Fly"] = 315.16, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 236.13}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 107.72, ["Fly"] = 183.89, ["Ride"] = 156.41, ["Fly|Ride"] = 178.5, ["Neon"] = 418.48, ["Neon|Ride"] = 489.22, ["Neon|Fly|Ride"] = 629.83, ["Mega"] = 1888.59, ["Mega|Fly|Ride"] = 1900.01}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.06, ["Fly"] = 142.68, ["Ride"] = 48.62, ["Fly|Ride"] = 87.51, ["Neon"] = 223.13, ["Neon|Ride"] = 198.09, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 2100, ["Mega|Ride"] = 1157.14, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.21, ["Fly"] = 75.17, ["Ride"] = 31.88, ["Fly|Ride"] = 69.57, ["Neon"] = 211.36, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 696.4, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 46.83, ["Fly"] = 287.44, ["Ride"] = 69.42, ["Fly|Ride"] = 119.37, ["Neon"] = 315.98, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 280.98, ["Mega|Ride"] = 2043.72, ["Mega|Fly|Ride"] = 1369.23}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 81.38}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 362.25, ["Fly"] = 406.88, ["Ride"] = 413.19, ["Fly|Ride"] = 437.07, ["Neon"] = 1473.09, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5636.59, ["Mega|Fly|Ride"] = 5806.74}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 104.99, ["Fly"] = 111.57, ["Ride"] = 105, ["Fly|Ride"] = 157.08, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 2613.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 35.95, ["Ride"] = 33.79, ["Fly|Ride"] = 141.62, ["Neon"] = 11.82, ["Neon|Ride"] = 78.22, ["Neon|Fly|Ride"] = 76.1, ["Mega"] = 82.45, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 131.2, ["Fly"] = 155.87, ["Ride"] = 149.62, ["Fly|Ride"] = 200.8, ["Neon"] = 704.85, ["Neon|Ride"] = 627.72, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1837.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.1, ["Fly"] = 25.38, ["Ride"] = 19.59, ["Fly|Ride"] = 45.46, ["Neon"] = 35.44, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 54.55, ["Fly"] = 153.49, ["Ride"] = 99.36, ["Fly|Ride"] = 227.17, ["Neon"] = 190.32, ["Neon|Ride"] = 215.7, ["Neon|Fly|Ride"] = 401.5, ["Mega"] = 819.61, ["Mega|Ride"] = 902, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 45.93}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 72.07, ["Ride"] = 138.45, ["Neon"] = 280.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.82, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 106.32, ["Neon"] = 128.93, ["Neon|Ride"] = 79.27, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2714.83, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1690.78}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 32.81, ["Fly"] = 63.41, ["Ride"] = 47.24, ["Fly|Ride"] = 99.75, ["Neon"] = 226.15, ["Neon|Fly"] = 314.92, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1681.32, ["Mega|Ride"] = 845.39, ["Mega|Fly|Ride"] = 828.14}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 155.76, ["Fly|Ride"] = 139.5, ["Neon"] = 208.68, ["Neon|Fly"] = 391.95, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 315.98, ["Mega"] = 1690.78, ["Mega|Ride"] = 1263.87, ["Mega|Fly|Ride"] = 1254.35}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.38, ["Fly"] = 63.76, ["Ride"] = 35.95, ["Fly|Ride"] = 126.82, ["Neon"] = 183.89, ["Neon|Ride"] = 158.21, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1207.92, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1104.41}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 44.63, ["Fly"] = 648.85, ["Ride"] = 83.5, ["Fly|Ride"] = 131.25, ["Neon"] = 247.29, ["Neon|Ride"] = 309.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 845.39}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.91, ["Fly"] = 26.24, ["Ride"] = 21.84, ["Fly|Ride"] = 41.99, ["Neon"] = 21, ["Neon|Fly"] = 70.88, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 84, ["Mega"] = 131.25, ["Mega|Fly"] = 306.46, ["Mega|Ride"] = 169.3, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 262.5, ["Fly"] = 369.87, ["Ride"] = 311.75, ["Fly|Ride"] = 362.25, ["Neon"] = 1475.25, ["Neon|Ride"] = 1973.98, ["Neon|Fly|Ride"] = 1409.69, ["Mega"] = 10567.28, ["Mega|Fly|Ride"] = 5980.88}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 11.81, ["Ride"] = 19.69, ["Fly|Ride"] = 137.39, ["Neon"] = 493.5, ["Neon|Ride"] = 303.3, ["Neon|Fly|Ride"] = 413.19, ["Mega"] = 831.67, ["Mega|Fly|Ride"] = 796.79}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 2.63, ["Fly"] = 38.06, ["Ride"] = 22.74, ["Fly|Ride"] = 52.07, ["Neon"] = 49.88, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 377.73, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 419.43}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 105.69, ["Fly"] = 126.34, ["Ride"] = 113.08, ["Fly|Ride"] = 131.25, ["Neon"] = 417.42, ["Neon|Ride"] = 443.84, ["Neon|Fly|Ride"] = 460.69, ["Mega"] = 6254.73, ["Mega|Ride"] = 1472.94, ["Mega|Fly|Ride"] = 1762.63}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Fly"] = 35.95, ["Ride"] = 28.41, ["Fly|Ride"] = 115.49, ["Neon"] = 97.23, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 708.23, ["Mega|Ride"] = 564.31}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 157.5, ["Fly"] = 352.96, ["Ride"] = 196.88, ["Fly|Ride"] = 236.25, ["Neon"] = 774.38, ["Neon|Ride"] = 802.07, ["Neon|Fly|Ride"] = 773.07, ["Mega"] = 6340.38, ["Mega|Fly|Ride"] = 2973.65}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 46.51}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.18, ["Fly"] = 35.95, ["Ride"] = 27.49, ["Fly|Ride"] = 49.83, ["Neon"] = 20.97, ["Neon|Fly"] = 92.09, ["Neon|Ride"] = 54.76, ["Neon|Fly|Ride"] = 153.48, ["Mega"] = 131.25, ["Mega|Fly"] = 236.6, ["Mega|Ride"] = 249.41, ["Mega|Fly|Ride"] = 299.83}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 656.25, ["Fly"] = 959.53, ["Ride"] = 984.88, ["Fly|Ride"] = 1017.19, ["Neon"] = 4961.35, ["Neon|Ride"] = 5248.69, ["Neon|Fly|Ride"] = 3150, ["Mega"] = 9712.5, ["Mega|Ride"] = 53116.06, ["Mega|Fly|Ride"] = 9843.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 8.93, ["Fly"] = 28.49, ["Ride"] = 22.93, ["Fly|Ride"] = 72.19, ["Neon"] = 107.81, ["Neon|Ride"] = 113.08, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 511.88, ["Mega|Ride"] = 607.64, ["Mega|Fly|Ride"] = 599.54}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 91.88, ["Ride"] = 115.5, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 631.95, ["Neon|Fly|Ride"] = 685.13, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2634.19}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 34.99}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 17.64, ["Fly"] = 68.85, ["Ride"] = 55.13, ["Fly|Ride"] = 144.38, ["Neon"] = 131.25, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 549.52, ["Mega|Ride"] = 723.19, ["Mega|Fly|Ride"] = 775.65}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.61}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.25, ["Ride"] = 171.94, ["Neon"] = 420, ["Neon|Ride"] = 495.85, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 131.25, ["Ride"] = 156.09, ["Fly|Ride"] = 216.57, ["Neon"] = 438.38, ["Neon|Ride"] = 366.18, ["Neon|Fly|Ride"] = 590.61, ["Mega"] = 1378.13, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1553.42}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 59.05}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.07, ["Fly"] = 65.63, ["Ride"] = 57.74, ["Fly|Ride"] = 64.32, ["Neon"] = 606.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 4225.87, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.16, ["Ride"] = 31.5, ["Fly|Ride"] = 159.58, ["Neon"] = 31.5, ["Neon|Ride"] = 67.65, ["Neon|Fly|Ride"] = 235.67, ["Mega"] = 205.02, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 262.5, ["Fly"] = 420, ["Ride"] = 341.25, ["Fly|Ride"] = 401.58, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1235.07, ["Mega|Fly|Ride"] = 4753.18}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 84, ["Fly"] = 99.75, ["Ride"] = 78.75, ["Fly|Ride"] = 122.59, ["Neon"] = 359.3, ["Neon|Ride"] = 362.44, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 1409.69, ["Mega|Ride"] = 1900.01, ["Mega|Fly|Ride"] = 1832.38}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4009.24, ["Ride"] = 3961.13, ["Fly|Ride"] = 3017.43, ["Neon|Fly|Ride"] = 14088.3}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 51.19, ["Fly"] = 113.08, ["Ride"] = 56.44, ["Fly|Ride"] = 95.82, ["Neon"] = 392.44, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 376.98, ["Mega|Ride"] = 2113.48, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 45.94, ["Ride"] = 57.07, ["Fly|Ride"] = 139.33, ["Neon"] = 479.07, ["Neon|Ride"] = 793.15, ["Neon|Fly|Ride"] = 493.5, ["Mega"] = 6340.38, ["Mega|Fly|Ride"] = 1719.31}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.79, ["Fly"] = 77.93, ["Ride"] = 52.47, ["Fly|Ride"] = 99.36, ["Neon"] = 197.63, ["Neon|Fly"] = 280.88, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 704.85, ["Mega|Ride"] = 928.95, ["Mega|Fly|Ride"] = 647.82}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.4}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 69.97, ["Ride"] = 76.13, ["Fly|Ride"] = 117.32, ["Neon"] = 354.02, ["Neon|Ride"] = 472.24, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 1409.69, ["Mega|Fly|Ride"] = 1731.6}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 233.56, ["Ride"] = 211.36, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 3487.21, ["Neon|Fly|Ride"] = 1489.89}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 721.88, ["Ride"] = 728.44, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 3241, ["Neon|Fly|Ride"] = 2900.63, ["Mega|Fly|Ride"] = 11812.5}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.2}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.77, ["Fly"] = 52.42, ["Ride"] = 39.38, ["Fly|Ride"] = 69.3, ["Neon"] = 162.75, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 169.1, ["Neon|Fly|Ride"] = 216.22, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 709.87}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 10.59}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4987.5, ["Ride"] = 6340.38, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 9821.44, ["Mega|Fly|Ride"] = 35224.94}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.28, ["Fly"] = 74.64, ["Ride"] = 24.94, ["Fly|Ride"] = 44.6, ["Neon"] = 70.88, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 137.39, ["Mega"] = 420, ["Mega|Ride"] = 452.29, ["Mega|Fly|Ride"] = 479.77}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.81, ["Fly"] = 196.56, ["Ride"] = 32.82, ["Fly|Ride"] = 116.89, ["Neon"] = 85.32, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 231, ["Mega"] = 446.25, ["Mega|Ride"] = 519.92, ["Mega|Fly|Ride"] = 691.11}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 126.82, ["Fly"] = 139.21, ["Ride"] = 28.54, ["Fly|Ride"] = 140.44, ["Neon"] = 1409.69, ["Neon|Fly|Ride"] = 420, ["Mega"] = 4226.93}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.12, ["Ride"] = 31.61, ["Fly|Ride"] = 139.13, ["Neon"] = 49.69, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 111.17, ["Mega"] = 1409.69, ["Mega|Ride"] = 417.03, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2100, ["Fly"] = 2471.44, ["Ride"] = 1968.75, ["Fly|Ride"] = 2008.13, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 15071.04}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 30293.2, ["Fly"] = 35262.02, ["Ride"] = 35224.94, ["Fly|Ride"] = 23231.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61687.5, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 197250.74}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 13.1, ["Fly"] = 393.75, ["Ride"] = 42, ["Fly|Ride"] = 63.74, ["Neon"] = 134.59, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 174.57, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 628.77, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 845.39}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 42.29, ["Fly|Ride"] = 126.82, ["Neon"] = 15.86, ["Neon|Fly"] = 134.38, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 105, ["Mega|Fly"] = 215.58, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.6}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 4.24, ["Ride"] = 41.34, ["Fly|Ride"] = 111.57, ["Neon"] = 45.94, ["Neon|Ride"] = 105.25, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 393.75, ["Mega|Ride"] = 471.71, ["Mega|Fly|Ride"] = 472.16}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 737.31, ["Ride"] = 845.39, ["Fly|Ride"] = 786.52, ["Neon"] = 2991.45, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 11017.47}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 984.38, ["Fly|Ride"] = 1054.37, ["Neon|Fly|Ride"] = 3071.25}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 24.82, ["Fly"] = 118.08, ["Ride"] = 61.3, ["Fly|Ride"] = 113.08, ["Neon"] = 162.75, ["Neon|Ride"] = 181.82, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 1023.96, ["Mega|Fly|Ride"] = 1409.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.55, ["Fly"] = 65.63, ["Ride"] = 79.11, ["Fly|Ride"] = 137.25, ["Neon"] = 787.42, ["Neon|Ride"] = 564.31, ["Neon|Fly|Ride"] = 389.82, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 59.07, ["Fly"] = 84.56, ["Ride"] = 84, ["Fly|Ride"] = 110.99, ["Neon"] = 395.24, ["Neon|Ride"] = 324.43, ["Neon|Fly|Ride"] = 507.25, ["Mega"] = 2129.55, ["Mega|Fly|Ride"] = 1504.79}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.1, ["Fly"] = 32.78, ["Ride"] = 21.15, ["Fly|Ride"] = 45.94, ["Neon"] = 24.36, ["Neon|Fly"] = 315.21, ["Neon|Ride"] = 68.65, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 315, ["Mega|Ride"] = 438.56, ["Mega|Fly|Ride"] = 371.44}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 70.75, ["Fly"] = 57.74, ["Ride"] = 85.32, ["Fly|Ride"] = 141.49, ["Neon"] = 815.81, ["Neon|Ride"] = 315.74, ["Neon|Fly|Ride"] = 310.28, ["Mega|Fly|Ride"] = 935.2}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Fly|Ride"] = 262.5, ["Neon"] = 21.19, ["Neon|Fly"] = 268.43, ["Neon|Ride"] = 114.14, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 91.95, ["Mega|Fly"] = 986.99, ["Mega|Ride"] = 211.36, ["Mega|Fly|Ride"] = 383.1}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.74, ["Fly"] = 65.63, ["Ride"] = 30.65, ["Fly|Ride"] = 99.36, ["Neon"] = 141.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 138.44, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 22.3, ["Ride"] = 39.37, ["Fly|Ride"] = 156.19, ["Neon"] = 206.08, ["Neon|Ride"] = 349.46, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 703.29}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 85.01, ["Ride"] = 31.88, ["Fly|Ride"] = 82.69, ["Neon"] = 103.69, ["Neon|Fly"] = 422.7, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 211.36, ["Mega|Ride"] = 939.44, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7045.22, ["Ride"] = 5906.25, ["Fly|Ride"] = 4725, ["Neon"] = 30999.09, ["Neon|Fly|Ride"] = 23797.51}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 220.5, ["Fly"] = 239.89, ["Ride"] = 223.13, ["Fly|Ride"] = 293.42, ["Neon|Ride"] = 694.18, ["Neon|Fly|Ride"] = 520.27, ["Mega|Fly|Ride"] = 2149.88}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 28.64, ["Fly"] = 104.11, ["Ride"] = 79.11, ["Fly|Ride"] = 112.64, ["Neon"] = 65.63, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 286.11, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 312.22, ["Mega|Fly|Ride"] = 373.55}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 41.34, ["Ride"] = 20.9, ["Fly|Ride"] = 99.36, ["Neon"] = 21, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 94.46, ["Mega"] = 179.82}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 30.77, ["Fly"] = 99.36, ["Ride"] = 89.25, ["Fly|Ride"] = 154.17, ["Neon"] = 66.94, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 283.22, ["Mega"] = 435.75, ["Mega|Ride"] = 448.02, ["Mega|Fly|Ride"] = 531.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18317.32, ["Ride"] = 10893.75, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 91578.06}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 156.49, ["Ride"] = 191.63, ["Fly|Ride"] = 248.34, ["Neon"] = 843.28, ["Neon|Ride"] = 843.28, ["Neon|Fly|Ride"] = 986.99, ["Mega|Fly|Ride"] = 7045.22}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 76.08, ["Fly"] = 459.38, ["Ride"] = 60.38, ["Fly|Ride"] = 102.23, ["Neon|Fly"] = 472.23, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 2007.79}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Fly"] = 31.88, ["Ride"] = 21.2, ["Fly|Ride"] = 65.54, ["Neon"] = 59.07, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 479.77, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 474.2}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 845.39, ["Ride"] = 431.82, ["Fly|Ride"] = 491.74, ["Neon"] = 1639.32, ["Neon|Ride"] = 1311.19, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4724.98, ["Mega|Fly|Ride"] = 4935}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.72, ["Fly"] = 87.39, ["Ride"] = 35.44, ["Fly|Ride"] = 105.69, ["Neon"] = 28.06, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 239.89, ["Mega"] = 118.13, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 274.77}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 135.28, ["Fly"] = 393.75, ["Ride"] = 219.81, ["Fly|Ride"] = 278.25, ["Neon"] = 528.38, ["Neon|Ride"] = 669.38, ["Neon|Fly|Ride"] = 720.57, ["Mega|Ride"] = 2597.45, ["Mega|Fly|Ride"] = 2604.92}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.59, ["Fly"] = 20.97, ["Ride"] = 21, ["Fly|Ride"] = 28.02, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 669.98}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.71}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 61.69, ["Ride"] = 72.19, ["Fly|Ride"] = 525, ["Neon"] = 206.08, ["Neon|Fly"] = 1690.78, ["Neon|Ride"] = 369.87, ["Neon|Fly|Ride"] = 470.26, ["Mega"] = 1265.98, ["Mega|Ride"] = 1416.44, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.49, ["Fly"] = 104.63, ["Ride"] = 31.49, ["Fly|Ride"] = 84, ["Neon"] = 94.84, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 475.47, ["Mega|Ride"] = 501.48, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 26.22, ["Fly"] = 109.33, ["Ride"] = 60.38, ["Fly|Ride"] = 235.67, ["Neon"] = 170.62, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 239.89, ["Mega"] = 669.98, ["Mega|Ride"] = 704.85, ["Mega|Fly|Ride"] = 866.4}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.1, ["Ride"] = 37, ["Fly|Ride"] = 131.25, ["Neon"] = 23.39, ["Neon|Ride"] = 106.26, ["Neon|Fly|Ride"] = 124.71, ["Mega"] = 109.07, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13, ["Ride"] = 30.19, ["Fly|Ride"] = 97.13, ["Neon"] = 118.13, ["Neon|Ride"] = 112.49, ["Neon|Fly|Ride"] = 224.03, ["Mega"] = 704.85, ["Mega|Ride"] = 472.16, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 409.5, ["Fly"] = 437.75, ["Ride"] = 328.13, ["Fly|Ride"] = 406.88, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7750.04}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 49.69, ["Ride"] = 77.87, ["Fly|Ride"] = 131.25, ["Neon"] = 253.31, ["Neon|Ride"] = 205.02, ["Neon|Fly|Ride"] = 211.36, ["Mega"] = 704.96, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.83, ["Fly"] = 84.27, ["Ride"] = 52.5, ["Fly|Ride"] = 141.04, ["Neon"] = 197.65, ["Neon|Ride"] = 184.94, ["Neon|Fly|Ride"] = 397.35, ["Mega"] = 1259.46, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1092.68}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 30.65, ["Fly"] = 21.15, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 71.87, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 418.69, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 522.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 9843.75, ["Ride"] = 11334.1, ["Fly|Ride"] = 8032.5, ["Neon|Fly|Ride"] = 16203.32, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1869.09, ["Fly"] = 1706.25, ["Ride"] = 1745.63, ["Fly|Ride"] = 1798.13, ["Neon|Fly|Ride"] = 4921.88, ["Mega|Fly|Ride"] = 22050}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 388.5, ["Ride"] = 464.97, ["Fly|Ride"] = 446.25, ["Neon"] = 2113.48, ["Neon|Ride"] = 1728.82, ["Neon|Fly|Ride"] = 1479.43, ["Mega"] = 16907.64, ["Mega|Fly|Ride"] = 6481.98}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.84, ["Fly"] = 31.71, ["Ride"] = 21.2, ["Fly|Ride"] = 40.17, ["Neon"] = 108.86, ["Neon|Ride"] = 113.08, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.24, ["Fly"] = 39.38, ["Ride"] = 37, ["Neon"] = 23.63, ["Neon|Ride"] = 47.23, ["Mega"] = 143.73, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 220.74}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.44, ["Fly"] = 50.74, ["Ride"] = 39.38, ["Fly|Ride"] = 89.25, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 179.46, ["Mega|Fly|Ride"] = 551.6}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 22.14, ["Ride"] = 15.85, ["Fly|Ride"] = 39.26, ["Neon"] = 20.09, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 42.47, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 360.94, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.8, ["Fly"] = 314.93, ["Ride"] = 354.38, ["Fly|Ride"] = 367.36, ["Neon|Ride"] = 1770.84, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 7185.75}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 28.5, ["Fly"] = 48.19, ["Ride"] = 38.07, ["Fly|Ride"] = 70.82, ["Neon"] = 126.82, ["Neon|Fly"] = 282.17, ["Neon|Ride"] = 139.5, ["Neon|Fly|Ride"] = 181.79, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.81, ["Fly"] = 24.36, ["Ride"] = 23.26, ["Fly|Ride"] = 42, ["Neon"] = 84.56, ["Neon|Fly"] = 126.82, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 528.38, ["Mega|Ride"] = 582.26, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.31, ["Fly"] = 787.5, ["Ride"] = 459.38, ["Fly|Ride"] = 480.82, ["Neon|Ride"] = 2747.51, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1050, ["Fly"] = 1416.71, ["Ride"] = 1173.24, ["Fly|Ride"] = 1175.99, ["Neon"] = 4945.49, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 15639.58}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 85.32, ["Fly"] = 126.34, ["Ride"] = 93.19, ["Fly|Ride"] = 112.66, ["Neon"] = 503.02, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 183.75, ["Fly"] = 237.78, ["Ride"] = 183.75, ["Fly|Ride"] = 224.44, ["Neon"] = 656.25, ["Neon|Fly"] = 887.66, ["Neon|Ride"] = 631.97, ["Neon|Fly|Ride"] = 625.61, ["Mega|Ride"] = 2958.85, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 21, ["Fly"] = 131.25, ["Ride"] = 41.99, ["Fly|Ride"] = 131.25, ["Neon"] = 183.75, ["Neon|Fly"] = 422.7, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 324.43, ["Mega|Ride"] = 944.3, ["Mega|Fly|Ride"] = 866.4}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 141.52, ["Ride"] = 210.74, ["Fly|Ride"] = 597.19, ["Neon"] = 1056.75, ["Mega|Fly|Ride"] = 2927.3}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2113.48, ["Fly"] = 2527.7, ["Ride"] = 2297.34, ["Fly|Ride"] = 2244.5, ["Neon|Fly|Ride"] = 7185.75, ["Mega|Fly|Ride"] = 48609.44}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.14, ["Ride"] = 36.72, ["Fly|Ride"] = 156.41, ["Neon"] = 290.62, ["Neon|Fly"] = 211.36, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 295.89, ["Mega"] = 2113.48, ["Mega|Ride"] = 2324.81, ["Mega|Fly|Ride"] = 1747.85}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 632.55, ["Fly"] = 675.94, ["Ride"] = 603.75, ["Fly|Ride"] = 590.63, ["Neon|Ride"] = 1266.57, ["Neon|Fly|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 2947.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 60.38, ["Ride"] = 57.75, ["Fly|Ride"] = 98.44, ["Neon"] = 249.38, ["Neon|Ride"] = 365.99, ["Neon|Fly|Ride"] = 220.74, ["Mega|Fly|Ride"] = 1456.88}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.92, ["Fly"] = 32.82, ["Ride"] = 20.79, ["Fly|Ride"] = 42.29, ["Neon"] = 20.09, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.85, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 138.55, ["Mega|Ride"] = 139.5, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 40.17, ["Ride"] = 52.43, ["Fly|Ride"] = 105, ["Neon"] = 262.08, ["Neon|Ride"] = 264.2, ["Neon|Fly|Ride"] = 311.75, ["Mega|Ride"] = 1409.69, ["Mega|Fly|Ride"] = 944.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 563.96, ["Fly"] = 899.07, ["Ride"] = 622.12, ["Fly|Ride"] = 564.38, ["Neon"] = 1902.12, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 507.97, ["Ride"] = 525, ["Fly|Ride"] = 656.25, ["Neon"] = 5283.65, ["Neon|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10566.23}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.04, ["Fly"] = 42.29, ["Ride"] = 24.34, ["Fly|Ride"] = 39.3, ["Neon"] = 211.36, ["Neon|Ride"] = 99.36, ["Neon|Fly|Ride"] = 105, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 581.21}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.55, ["Ride"] = 22.32, ["Fly|Ride"] = 78.75, ["Neon"] = 141.6, ["Neon|Ride"] = 123.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1688.67, ["Mega|Ride"] = 447.01, ["Mega|Fly|Ride"] = 384.66}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 31.71, ["Fly|Ride"] = 98.43, ["Neon"] = 19.69, ["Neon|Fly"] = 113.08, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 136.94, ["Mega|Fly"] = 406.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 330.74}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 35.43, ["Fly"] = 57.06, ["Ride"] = 44.51, ["Fly|Ride"] = 94.35, ["Neon"] = 236.13, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 270.69, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 283.34, ["Neon|Ride"] = 352.96, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1390.67, ["Mega|Ride"] = 1550.24, ["Mega|Fly|Ride"] = 1550.24}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 17.07, ["Fly"] = 39.38, ["Ride"] = 27.57, ["Fly|Ride"] = 87.09, ["Neon"] = 110.92, ["Neon|Fly"] = 146.4, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 422.7, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 631.95}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.48, ["Fly"] = 99.36, ["Ride"] = 45.94, ["Fly|Ride"] = 82.67, ["Neon"] = 408.97, ["Neon|Ride"] = 182.1, ["Neon|Fly|Ride"] = 226.54, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1180.37}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.92, ["Fly"] = 31.49, ["Ride"] = 17.07, ["Fly|Ride"] = 39.37, ["Neon"] = 31.5, ["Neon|Ride"] = 40.3, ["Neon|Fly|Ride"] = 84.71, ["Mega"] = 183.75, ["Mega|Ride"] = 211.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 2.63, ["Fly"] = 35.95, ["Ride"] = 28.35, ["Fly|Ride"] = 79.11, ["Neon"] = 26.17, ["Neon|Fly"] = 158.21, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 235.67, ["Mega|Fly"] = 479.77, ["Mega|Ride"] = 285.87, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.78, ["Fly"] = 60.38, ["Ride"] = 55.13, ["Fly|Ride"] = 88.57, ["Neon"] = 228.26, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 211.36, ["Neon|Fly|Ride"] = 222.59, ["Mega|Fly|Ride"] = 918.64}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1903.13, ["Fly"] = 2171.59, ["Ride"] = 1640.63, ["Fly|Ride"] = 1795.5, ["Neon|Fly|Ride"] = 3871.88, ["Mega|Fly|Ride"] = 16471.22}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 446.25, ["Fly"] = 503, ["Ride"] = 501.96, ["Fly|Ride"] = 550.85, ["Neon"] = 3148.47, ["Neon|Ride"] = 3100.44, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9694.42}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 242.82, ["Fly"] = 338.17, ["Ride"] = 267.75, ["Fly|Ride"] = 393.75, ["Neon"] = 1202.53, ["Neon|Ride"] = 1179.94, ["Neon|Fly|Ride"] = 1507.96, ["Mega"] = 6763.08, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 18.38, ["Fly"] = 65.63, ["Ride"] = 47.24, ["Fly|Ride"] = 103.69, ["Neon"] = 206.07, ["Neon|Ride"] = 253.63, ["Neon|Fly|Ride"] = 420.61, ["Mega|Ride"] = 1550.24, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 33815.28, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 18086.85, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 288.75, ["Fly"] = 345.56, ["Ride"] = 348.3, ["Fly|Ride"] = 362.1, ["Neon"] = 1056.75, ["Neon|Fly"] = 1605.53, ["Neon|Ride"] = 1017.64, ["Neon|Fly|Ride"] = 916.65, ["Mega"] = 6340.38, ["Mega|Ride"] = 6610.01, ["Mega|Fly|Ride"] = 3149.99}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 126.34, ["Fly"] = 141.62, ["Ride"] = 188.11, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 704.85, ["Neon|Fly|Ride"] = 1056.75, ["Mega|Fly|Ride"] = 4086.38}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 122.05, ["Ride"] = 135.49, ["Fly|Ride"] = 195.93, ["Neon"] = 535.97, ["Neon|Ride"] = 523.09, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 14090.42, ["Mega|Fly|Ride"] = 2531.93}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.05, ["Fly"] = 70.82, ["Ride"] = 32.86, ["Fly|Ride"] = 98.44, ["Neon"] = 126.33, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 704.85, ["Mega|Fly|Ride"] = 620.31}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5087.6, ["Ride"] = 4678.14, ["Fly|Ride"] = 4418.09, ["Neon|Ride"] = 16907.64, ["Neon|Fly|Ride"] = 17599.8, ["Mega|Fly|Ride"] = 70448.82}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.24, ["Fly"] = 48.56, ["Ride"] = 32.82, ["Fly|Ride"] = 53.17, ["Neon"] = 333.94, ["Neon|Ride"] = 220.78, ["Neon|Fly|Ride"] = 157.5, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.23, ["Fly"] = 141.62, ["Ride"] = 39.38, ["Fly|Ride"] = 107.63, ["Neon"] = 260.92, ["Neon|Fly"] = 1409.69, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1044.06}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 611.63, ["Fly"] = 760.86, ["Ride"] = 653.63, ["Fly|Ride"] = 721.88, ["Neon"] = 1690.78, ["Neon|Ride"] = 1582.91, ["Neon|Fly|Ride"] = 1535.63, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 10.49, ["Fly"] = 28.23, ["Ride"] = 19.69, ["Fly|Ride"] = 41.99, ["Neon"] = 98.44, ["Neon|Fly"] = 158.21, ["Neon|Ride"] = 102.72, ["Neon|Fly|Ride"] = 117.93, ["Mega"] = 775.65, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.44, ["Ride"] = 28.54, ["Fly|Ride"] = 65.63, ["Neon"] = 91.88, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 377.73}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 102.38, ["Fly"] = 315.23, ["Ride"] = 139.14, ["Fly|Ride"] = 203.44, ["Neon"] = 703.8, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 564.31, ["Mega|Fly|Ride"] = 2193.18}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.42, ["Fly"] = 131.25, ["Ride"] = 105.69, ["Fly|Ride"] = 141.62, ["Neon"] = 94.5, ["Neon|Ride"] = 137.39, ["Neon|Fly|Ride"] = 376.21, ["Mega"] = 273.12, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 287.49, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3253.69, ["Ride"] = 3215.63, ["Fly|Ride"] = 3281.24, ["Neon"] = 13125, ["Neon|Ride"] = 10074.84, ["Neon|Fly|Ride"] = 8505, ["Mega"] = 63403.61, ["Mega|Fly|Ride"] = 33049.99}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 28.54, ["Fly"] = 57.07, ["Ride"] = 70.82, ["Fly|Ride"] = 105.69, ["Neon"] = 211.36, ["Neon|Ride"] = 197.63, ["Neon|Fly|Ride"] = 366.71, ["Mega|Ride"] = 951.07, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7087.5, ["Ride"] = 7467.9, ["Fly|Ride"] = 5903.63, ["Neon|Fly|Ride"] = 16723.95, ["Mega|Fly|Ride"] = 63327.54}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.6, ["Fly"] = 23.26, ["Ride"] = 17.07, ["Fly|Ride"] = 36.75, ["Neon"] = 28.54, ["Neon|Fly"] = 91.8, ["Neon|Ride"] = 40.22, ["Neon|Fly|Ride"] = 69.76, ["Mega"] = 281.1, ["Mega|Ride"] = 312.81, ["Mega|Fly|Ride"] = 324.43}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.04, ["Fly"] = 31.88, ["Ride"] = 19.69, ["Fly|Ride"] = 58.69, ["Neon"] = 70.84, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 559.37, ["Neon|Fly|Ride"] = 352.96, ["Mega|Ride"] = 1542.85, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.75}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.43, ["Ride"] = 37.79, ["Fly|Ride"] = 126.82, ["Neon"] = 158.21, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 138.45, ["Mega"] = 703.8, ["Mega|Ride"] = 986.99, ["Mega|Fly|Ride"] = 866.4}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.46, ["Fly"] = 262.5, ["Ride"] = 63.31, ["Fly|Ride"] = 141.62, ["Neon"] = 182.43, ["Neon|Ride"] = 154.09, ["Neon|Fly|Ride"] = 281.69, ["Mega"] = 840, ["Mega|Ride"] = 944.3, ["Mega|Fly|Ride"] = 787.32}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 9.01, ["Fly"] = 23.94, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 141.61, ["Neon|Ride"] = 110.99, ["Neon|Fly|Ride"] = 169.44, ["Mega"] = 820.32, ["Mega|Ride"] = 589.01, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8362.95}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3148.69}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 156.72, ["Fly"] = 174.57, ["Ride"] = 189, ["Fly|Ride"] = 352.96, ["Neon|Ride"] = 704.85}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 25.38, ["Fly"] = 133.17, ["Ride"] = 47.34, ["Fly|Ride"] = 105, ["Neon"] = 141.62, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 158.21, ["Mega"] = 810.52, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.83}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 9.49, ["Neon"] = 82.45, ["Neon|Ride"] = 84.56, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 183.89, ["Ride"] = 236.25, ["Fly|Ride"] = 10498.95, ["Neon"] = 918.75, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 790.46, ["Mega|Ride"] = 3509.4, ["Mega|Fly|Ride"] = 3001.11}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 139.5, ["Ride"] = 156.41, ["Fly|Ride"] = 282.17, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1052.89, ["Mega|Ride"] = 2324.81, ["Mega|Fly|Ride"] = 2107.13}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 177.18, ["Ride"] = 164.07, ["Fly|Ride"] = 221.29, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 842.03, ["Mega"] = 4649.6, ["Mega|Fly|Ride"] = 3100.44}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1181.25, ["Fly"] = 2536.15, ["Ride"] = 1194.38, ["Fly|Ride"] = 1286.25, ["Neon"] = 5354.45, ["Neon|Ride"] = 5340.71, ["Neon|Fly|Ride"] = 4462.5, ["Mega|Fly|Ride"] = 22190.22}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.36, ["Fly"] = 82.87, ["Ride"] = 39.38, ["Fly|Ride"] = 99.36, ["Neon"] = 141.62, ["Neon|Ride"] = 297.51, ["Neon|Fly|Ride"] = 422.63, ["Mega"] = 844.34, ["Mega|Fly|Ride"] = 916.2}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 733.39, ["Fly|Ride"] = 1050}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 93.19}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.86, ["Fly"] = 393.75, ["Ride"] = 43.32, ["Fly|Ride"] = 98.44, ["Neon"] = 90.57, ["Neon|Ride"] = 104.63, ["Neon|Fly|Ride"] = 493.5, ["Mega"] = 363.57, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 845.39}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.74, ["Fly"] = 131.25, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 60.25, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 200.16, ["Mega"] = 422.7, ["Mega|Ride"] = 472.16, ["Mega|Fly|Ride"] = 619.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.17}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21, ["Fly"] = 108.92, ["Ride"] = 27.55, ["Fly|Ride"] = 65.54, ["Neon"] = 116.82, ["Neon|Ride"] = 158.53, ["Neon|Fly|Ride"] = 598.56, ["Mega"] = 818.98, ["Mega|Ride"] = 845.39, ["Mega|Fly|Ride"] = 1260.78}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.57, ["Fly"] = 48.62, ["Ride"] = 30.19, ["Fly|Ride"] = 57.07, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 274.32, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5563.69, ["Fly"] = 11272.12, ["Ride"] = 4666.2, ["Fly|Ride"] = 4725, ["Neon|Ride"] = 15500.08, ["Neon|Fly|Ride"] = 10077.38, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.19, ["Fly"] = 34.13, ["Ride"] = 32.82, ["Fly|Ride"] = 99.36, ["Neon"] = 57.2, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 352.96, ["Mega"] = 528.81, ["Mega|Ride"] = 282.17, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 25.4}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 101.07, ["Fly"] = 374.09, ["Ride"] = 105, ["Fly|Ride"] = 233.56, ["Neon"] = 418.69, ["Neon|Ride"] = 481.69, ["Neon|Fly|Ride"] = 452.82, ["Mega|Ride"] = 4226.93, ["Mega|Fly|Ride"] = 1900.01}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 76.13, ["Ride"] = 105, ["Fly|Ride"] = 153.57, ["Neon"] = 315, ["Neon|Ride"] = 346.62, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1621.03, ["Mega|Fly|Ride"] = 1743.61}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.31, ["Fly"] = 72.17, ["Ride"] = 32.76, ["Fly|Ride"] = 63.58, ["Neon"] = 169.1, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 691.11, ["Mega|Ride"] = 873.93, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.23, ["Fly"] = 49.26, ["Ride"] = 35.95, ["Fly|Ride"] = 70.96, ["Neon"] = 19.69, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 145.78, ["Mega"] = 124.69, ["Mega|Fly"] = 7034.11, ["Mega|Ride"] = 175.11, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.12, ["Fly"] = 64.32, ["Ride"] = 33.84, ["Fly|Ride"] = 74.82, ["Neon"] = 78.22, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 158.39, ["Mega"] = 362.48, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.62, ["Fly"] = 26.5, ["Ride"] = 24.94, ["Fly|Ride"] = 43.32, ["Neon"] = 208.69, ["Neon|Ride"] = 138.96, ["Neon|Fly|Ride"] = 127.05, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 212.62}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 27.44, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 139.5, ["Neon|Ride"] = 164.07, ["Mega"] = 1190.95, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1465.7}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 126.82, ["Ride"] = 141.62, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 742.9}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 39.37, ["Fly"] = 211.99, ["Ride"] = 100.79, ["Neon"] = 196.88, ["Neon|Fly"] = 352.96, ["Neon|Ride"] = 311.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 944.3, ["Mega|Ride"] = 1118.03, ["Mega|Fly|Ride"] = 1102.19}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 708.75, ["Fly"] = 780.94, ["Ride"] = 668.07, ["Fly|Ride"] = 721.87, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 7869.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 261.19, ["Fly"] = 288.75, ["Ride"] = 346.5, ["Fly|Ride"] = 315, ["Neon"] = 1550.24, ["Neon|Ride"] = 2047.1, ["Neon|Fly|Ride"] = 1322.24, ["Mega"] = 8313.29, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 74.79}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.49, ["Fly"] = 31.49, ["Ride"] = 24.81, ["Fly|Ride"] = 56.44, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 117.96, ["Mega"] = 404.74, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.49, ["Fly"] = 986.99, ["Ride"] = 315, ["Fly|Ride"] = 419.3, ["Neon"] = 1086.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3692.85}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.72}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.58, ["Fly"] = 590.63, ["Ride"] = 175.44, ["Fly|Ride"] = 255.94, ["Neon"] = 525, ["Neon|Fly"] = 1409.69, ["Neon|Ride"] = 628.69, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 2817.25, ["Mega|Ride"] = 1973.98, ["Mega|Fly|Ride"] = 1844.11}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 144.38, ["Ride"] = 170.63, ["Fly|Ride"] = 282.17, ["Neon"] = 986.99, ["Neon|Fly"] = 1055.7, ["Neon|Ride"] = 887.66}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 28.39, ["Fly|Ride"] = 94.47, ["Neon"] = 53.81, ["Neon|Ride"] = 70.95, ["Mega"] = 222.99, ["Mega|Ride"] = 438.56, ["Mega|Fly|Ride"] = 366.71}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.8, ["Fly"] = 62.99, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 128.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 261.19, ["Mega|Ride"] = 704.85, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 20.11, ["Fly"] = 126.82, ["Ride"] = 62.36, ["Fly|Ride"] = 141.39, ["Neon"] = 171.21, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 391.01, ["Mega|Ride"] = 520.55, ["Mega|Fly|Ride"] = 945.67}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.36, ["Fly"] = 72.17, ["Ride"] = 52.5, ["Fly|Ride"] = 95.12, ["Neon"] = 23.16, ["Neon|Ride"] = 62.25, ["Neon|Fly|Ride"] = 173.61, ["Mega"] = 128.6, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 263.16, ["Fly"] = 918.75, ["Ride"] = 338.17, ["Fly|Ride"] = 415.41, ["Neon"] = 1479.43, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 6229.41}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 90.56, ["Fly"] = 1050, ["Ride"] = 156.41, ["Fly|Ride"] = 209.98, ["Neon"] = 456.74, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 549.52, ["Mega"] = 1792.88, ["Mega|Ride"] = 1935.81, ["Mega|Fly|Ride"] = 1693.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 45.92, ["Fly"] = 167.45, ["Ride"] = 84, ["Fly|Ride"] = 126.82, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 418.69, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 19.04, ["Ride"] = 33.84, ["Fly|Ride"] = 282.17, ["Neon|Ride"] = 599.74, ["Neon|Fly|Ride"] = 493.5, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.38, ["Fly"] = 75.62, ["Ride"] = 40.69, ["Fly|Ride"] = 95.12, ["Neon"] = 90.9, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 417.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 396.29, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.81, ["Fly"] = 27.49, ["Ride"] = 25.38, ["Fly|Ride"] = 65.63, ["Neon"] = 17.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 117.32, ["Mega"] = 102.18, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1409.69, ["Ride"] = 1040.73, ["Fly|Ride"] = 997.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8715}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 388.06, ["Ride"] = 404.74, ["Fly|Ride"] = 490.88, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 10567.28, ["Mega|Fly|Ride"] = 5489.72}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 93.19, ["Ride"] = 112.87, ["Fly|Ride"] = 169.1, ["Neon"] = 282.19, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 314.5, ["Mega|Fly|Ride"] = 1648.52}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 259.97, ["Fly"] = 338.17, ["Ride"] = 274.49, ["Fly|Ride"] = 313.3, ["Neon|Ride"] = 1014.48, ["Neon|Fly|Ride"] = 1036.66, ["Mega"] = 10567.28, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 27.46, ["Fly"] = 52.5, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 126.57, ["Neon|Ride"] = 129.99, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 1409.69, ["Mega|Ride"] = 704.85, ["Mega|Fly|Ride"] = 618.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 422.7, ["Ride"] = 274.32, ["Fly|Ride"] = 431.16, ["Neon"] = 1584.98, ["Neon|Ride"] = 1106.41, ["Neon|Fly|Ride"] = 2395.62, ["Mega"] = 5250}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 110.25, ["Fly"] = 126, ["Ride"] = 65.63, ["Fly|Ride"] = 156.41, ["Neon"] = 422.7, ["Neon|Ride"] = 505.13, ["Neon|Fly|Ride"] = 564.31, ["Mega|Fly|Ride"] = 1397.82}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1378.13, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 6199.83, ["Mega"] = 50722.89, ["Mega|Fly|Ride"] = 24516.08}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.75, ["Fly"] = 63, ["Ride"] = 45.1, ["Fly|Ride"] = 93.01, ["Neon"] = 51.89, ["Neon|Fly"] = 164.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 253.32, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 373.88}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 47.25, ["Ride"] = 84, ["Fly|Ride"] = 161.44, ["Neon"] = 304.35, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 548.45, ["Mega|Ride"] = 1388.55, ["Mega|Fly|Ride"] = 1408.65}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 60.37, ["Fly"] = 80.33, ["Ride"] = 66.93, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 366.19, ["Mega|Fly|Ride"] = 1416.44}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1575, ["Ride"] = 1014.48, ["Fly|Ride"] = 999.27, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 520.65, ["Fly"] = 843.28, ["Ride"] = 564.31, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1984.55, ["Mega|Fly|Ride"] = 14164.29}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 94.5, ["Fly"] = 315.23, ["Ride"] = 131.25, ["Fly|Ride"] = 209.61, ["Neon"] = 627.72, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 505.13, ["Mega"] = 4226.93, ["Mega|Ride"] = 2677.76, ["Mega|Fly|Ride"] = 2113.48}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 24.36, ["Fly|Ride"] = 61.69, ["Neon"] = 75.05, ["Neon|Ride"] = 113.08, ["Neon|Fly|Ride"] = 233.63, ["Mega"] = 761.25, ["Mega|Ride"] = 634.06, ["Mega|Fly|Ride"] = 986.99}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 35.41, ["Fly"] = 69.76, ["Ride"] = 48.57, ["Fly|Ride"] = 94.4, ["Neon"] = 204.75, ["Neon|Fly"] = 421.64, ["Neon|Ride"] = 221.96, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 1832.38, ["Mega|Ride"] = 1043.44, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 748.13, ["Fly|Ride"] = 873.97, ["Neon|Ride"] = 2828.44, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 24657.68}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 859.68}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4593.75, ["Ride"] = 4396.88, ["Fly|Ride"] = 4378.39, ["Neon|Ride"] = 30286.87, ["Neon|Fly|Ride"] = 21661.86, ["Mega|Fly|Ride"] = 90174.73}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 282.17, ["Ride"] = 211.36, ["Fly|Ride"] = 422.7, ["Neon"] = 1690.78, ["Neon|Ride"] = 845.39, ["Neon|Fly|Ride"] = 1409.69, ["Mega"] = 5917.69, ["Mega|Fly|Ride"] = 5636.59}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 59.07, ["Fly"] = 282.17, ["Ride"] = 77.44, ["Fly|Ride"] = 336, ["Neon"] = 986.99, ["Neon|Ride"] = 486.11, ["Neon|Fly|Ride"] = 986.99, ["Mega|Fly|Ride"] = 2810.92}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 12.92, ["Fly"] = 57.07, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 94.5, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 703.8, ["Mega|Ride"] = 535.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.11, ["Fly"] = 28.35, ["Ride"] = 26.25, ["Fly|Ride"] = 45.93, ["Neon"] = 91.88, ["Neon|Ride"] = 99.36, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 835.89}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 22.32, ["Fly"] = 70.82, ["Ride"] = 44.88, ["Fly|Ride"] = 65.63, ["Neon"] = 141.62, ["Neon|Ride"] = 122.59, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.28, ["Fly"] = 57.07, ["Ride"] = 22.32, ["Fly|Ride"] = 63.45, ["Neon"] = 42.29, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 141.62, ["Mega|Ride"] = 202.91, ["Mega|Fly|Ride"] = 283.31}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 26.23, ["Ride"] = 57.07, ["Fly|Ride"] = 169.1, ["Neon"] = 147.95, ["Neon|Fly"] = 845.39, ["Neon|Ride"] = 184.17, ["Neon|Fly|Ride"] = 251.06, ["Mega"] = 693.23, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 855.98}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 236.25, ["Fly"] = 331.83, ["Ride"] = 295.32, ["Fly|Ride"] = 327.29, ["Neon"] = 1050, ["Neon|Fly"] = 951.07, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 808.04, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 2956.74}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 14.9, ["Fly|Ride"] = 36.75, ["Neon"] = 19.69, ["Neon|Ride"] = 28.04, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 223.13, ["Mega|Ride"] = 158.18, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 32.7, ["Fly"] = 99.32, ["Ride"] = 65.49, ["Fly|Ride"] = 108.94, ["Neon"] = 137.7, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 247.17, ["Mega"] = 564.27, ["Mega|Ride"] = 547.31, ["Mega|Fly|Ride"] = 529.12}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 802.68, ["Fly"] = 1409.69, ["Ride"] = 728.43, ["Fly|Ride"] = 817.97, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1526.44, ["Mega|Fly|Ride"] = 3941.44}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.25, ["Fly"] = 107.63, ["Ride"] = 44.1, ["Fly|Ride"] = 66.94, ["Neon|Fly"] = 472.23, ["Neon|Ride"] = 176.13, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1575, ["Mega|Ride"] = 1127.55, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 196.88, ["Fly"] = 341.25, ["Ride"] = 231, ["Fly|Ride"] = 311.92, ["Neon|Ride"] = 911.97, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4918.03}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 141.74, ["Fly"] = 179.82, ["Ride"] = 131.24, ["Fly|Ride"] = 167.3, ["Neon"] = 634.06, ["Neon|Fly"] = 642.51, ["Neon|Ride"] = 523.09, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2255.7}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 525, ["Ride"] = 577.47, ["Fly|Ride"] = 678.57, ["Neon|Fly|Ride"] = 2005.26, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Ride"] = 53.17, ["Fly|Ride"] = 130.26, ["Neon"] = 91.62, ["Neon|Fly"] = 283.34, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 183.89, ["Mega"] = 354.37, ["Mega|Ride"] = 314.77, ["Mega|Fly|Ride"] = 501.94}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4006.89, ["Fly"] = 4007.09, ["Ride"] = 3017.44, ["Fly|Ride"] = 3084.38, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 87.94, ["Fly"] = 178.5, ["Ride"] = 105, ["Fly|Ride"] = 141.62, ["Neon"] = 472.23, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 409.5, ["Mega|Fly|Ride"] = 1888.59}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.59, ["Fly"] = 28.54, ["Ride"] = 16.93, ["Fly|Ride"] = 49.79, ["Neon"] = 19.69, ["Neon|Fly"] = 42.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 134.73, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.72, ["Ride"] = 27.48, ["Fly|Ride"] = 62.99, ["Neon"] = 23.67, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 181.77, ["Mega|Ride"] = 182.13, ["Mega|Fly|Ride"] = 278.2}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.54, ["Fly"] = 57.07, ["Ride"] = 42.34, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 282.17, ["Mega|Fly|Ride"] = 1338.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 971.14, ["Ride"] = 1018.5, ["Fly|Ride"] = 1206.48, ["Neon"] = 5072.3, ["Neon|Fly|Ride"] = 5165.3}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5165.3, ["Ride"] = 5903.19, ["Fly|Ride"] = 5165.3}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 15.74, ["Fly"] = 33.84, ["Ride"] = 27.49, ["Fly|Ride"] = 48.62, ["Neon"] = 261.86, ["Neon|Ride"] = 105.69, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 21, ["Ride"] = 32.08, ["Fly|Ride"] = 80.07, ["Neon"] = 94.5, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 933.52, ["Mega|Ride"] = 354.37, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 49.88, ["Fly"] = 85.31, ["Ride"] = 54.47, ["Fly|Ride"] = 87.73, ["Neon"] = 223.49, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 1050, ["Mega|Ride"] = 1055.7, ["Mega|Fly|Ride"] = 928.39}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 221.81, ["Fly"] = 282.17, ["Ride"] = 225.47, ["Fly|Ride"] = 281.63, ["Neon"] = 1212.08, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 945, ["Mega"] = 11174.45, ["Mega|Fly|Ride"] = 3503.07}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.24, ["Ride"] = 32.48, ["Fly|Ride"] = 105, ["Neon"] = 19.04, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 245.57, ["Mega"] = 144.38, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 368.28}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 182.44, ["Fly"] = 211.36, ["Ride"] = 224.33, ["Fly|Ride"] = 295.89, ["Neon"] = 808.5, ["Neon|Ride"] = 744.19, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 3375.2}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.57, ["Fly"] = 23.62, ["Ride"] = 15.74, ["Fly|Ride"] = 39.11, ["Neon"] = 21.15, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 27.15, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 210, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 315.98}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 219.81, ["Fly"] = 249.38, ["Ride"] = 208.69, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 1298.62, ["Neon|Fly|Ride"] = 885.44, ["Mega"] = 10567.28, ["Mega|Ride"] = 6340.38, ["Mega|Fly|Ride"] = 7672.33}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 8.48, ["Fly"] = 131.25, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 83.5, ["Neon|Fly"] = 299.86, ["Neon|Ride"] = 135.28, ["Neon|Fly|Ride"] = 272.68, ["Mega"] = 522.41, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 466.04}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Neon"] = 13.13, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 84, ["Mega"] = 76.11, ["Mega|Ride"] = 115.35, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.02, ["Mega"] = 19.06, ["Mega|Ride"] = 139.3}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.83, ["Ride"] = 39.38, ["Fly|Ride"] = 141.62, ["Neon"] = 14.18, ["Neon|Ride"] = 65.52, ["Neon|Fly|Ride"] = 156.41, ["Mega"] = 68.16, ["Mega|Fly"] = 157381.68, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 190.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 59.07, ["Fly"] = 102.38, ["Ride"] = 105, ["Fly|Ride"] = 154.77, ["Neon"] = 262.5, ["Neon|Fly"] = 263.17, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1133.43}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 12.7, ["Fly|Ride"] = 43.32, ["Neon"] = 10.63, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 105, ["Mega"] = 86.62, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.19, ["Ride"] = 91.88, ["Fly|Ride"] = 196.56, ["Neon"] = 74.82, ["Neon|Ride"] = 103.69, ["Mega"] = 485.63, ["Mega|Ride"] = 634.06, ["Mega|Fly|Ride"] = 775.65}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 30.65, ["Neon"] = 2.45, ["Neon|Ride"] = 31.68, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 17.07, ["Mega|Ride"] = 47.31, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 19.04, ["Fly|Ride"] = 31.88, ["Neon"] = 2.1, ["Neon|Fly"] = 16.93, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 40.22, ["Mega"] = 15.73, ["Mega|Fly"] = 28.54, ["Mega|Ride"] = 27.49, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 12.71, ["Fly|Ride"] = 34.55, ["Neon"] = 3.87, ["Neon|Fly"] = 15.54, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 42.29, ["Mega|Fly"] = 59.04, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Fly|Ride"] = 125.73, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 70.82, ["Mega"] = 28.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 306.46}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 19.69, ["Fly|Ride"] = 104.71, ["Neon"] = 3.94, ["Neon|Fly"] = 135.03, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 86, ["Mega"] = 42.51, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 75.21, ["Mega|Fly|Ride"] = 163.8}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 15.02, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 47.16, ["Ride"] = 26.03, ["Fly|Ride"] = 47.41, ["Neon"] = 6.36, ["Neon|Fly"] = 37.07, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 42, ["Mega|Fly"] = 195.96, ["Mega|Ride"] = 64.22, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 48.62, ["Neon"] = 2.1, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 313.84, ["Mega"] = 15.99, ["Mega|Ride"] = 63.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 35.95, ["Ride"] = 52.5, ["Fly|Ride"] = 525, ["Neon"] = 22.23, ["Mega"] = 202.91, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 282.17}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Mega"] = 139.13, ["Mega|Fly|Ride"] = 380.43}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 70.82, ["Neon"] = 6.36, ["Neon|Ride"] = 37.71, ["Neon|Fly|Ride"] = 76.1, ["Mega"] = 21, ["Mega|Ride"] = 42.29, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 30.72, ["Ride"] = 18.84, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 25.98, ["Neon|Ride"] = 17.73, ["Neon|Fly|Ride"] = 41.88, ["Mega"] = 15.59, ["Mega|Fly"] = 52.85, ["Mega|Ride"] = 21.15, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 42, ["Fly|Ride"] = 114.14, ["Neon"] = 32.82, ["Neon|Ride"] = 39.83, ["Mega"] = 253.63, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 688.99}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Fly|Ride"] = 78.73, ["Neon"] = 6.2, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 158.06, ["Mega"] = 23.08, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 156.16}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 7.12, ["Neon"] = 12.7, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 74.82, ["Mega|Ride"] = 164.87, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 12.7, ["Ride"] = 32.81, ["Fly|Ride"] = 192.34, ["Neon"] = 10.58, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 126.82, ["Mega"] = 84.72, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.79, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 15.74, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 28.54, ["Mega"] = 15.49, ["Mega|Fly"] = 40.17, ["Mega|Ride"] = 23.26, ["Mega|Fly|Ride"] = 52.36}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 23.94, ["Ride"] = 19.65, ["Fly|Ride"] = 48.57, ["Neon"] = 15.61, ["Neon|Ride"] = 113.34, ["Neon|Fly|Ride"] = 75.05, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.25, ["Fly"] = 41.91, ["Ride"] = 30.72, ["Fly|Ride"] = 141.39, ["Neon"] = 70.55, ["Neon|Ride"] = 108.86, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 279.46, ["Mega|Ride"] = 277.55, ["Mega|Fly|Ride"] = 387.85}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 15.86, ["Fly|Ride"] = 26.17, ["Neon"] = 3.93, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 60.25, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 63.75, ["Mega|Fly|Ride"] = 120.09}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 176.49, ["Ride"] = 31.5, ["Neon"] = 9.47, ["Neon|Fly"] = 77.53, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 59.96, ["Mega|Fly"] = 564.31, ["Mega|Ride"] = 105}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 141.68, ["Mega"] = 32.81, ["Mega|Ride"] = 148.74, ["Mega|Fly|Ride"] = 205.4}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 46.51, ["Neon"] = 2.1, ["Neon|Fly"] = 41.24, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 14.34, ["Mega|Ride"] = 52.08}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 88.78, ["Ride"] = 19.04, ["Fly|Ride"] = 59.07, ["Neon"] = 7.88, ["Neon|Fly"] = 46.51, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 221.92, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 226.15}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 10.59, ["Neon|Ride"] = 63.76, ["Mega"] = 102.38, ["Mega|Ride"] = 118.06, ["Mega|Fly|Ride"] = 236.09}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 16.93, ["Fly|Ride"] = 141.75, ["Neon"] = 7.87, ["Neon|Fly"] = 15.89, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 65.63, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 4.73, ["Ride"] = 82.6, ["Neon"] = 22.42, ["Mega"] = 282.17, ["Mega|Fly|Ride"] = 844.06}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 24.31, ["Ride"] = 21.27, ["Fly|Ride"] = 5430.93, ["Neon"] = 14.44, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 25.38, ["Neon|Fly|Ride"] = 113.08, ["Mega"] = 190.95, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 28.6, ["Fly|Ride"] = 141.62, ["Neon"] = 19.69, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 63.55, ["Mega"] = 158.53, ["Mega|Ride"] = 126.95, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.93, ["Fly"] = 79.47, ["Fly|Ride"] = 106.14, ["Neon"] = 23, ["Neon|Ride"] = 158.21, ["Mega"] = 202.06, ["Mega|Ride"] = 380.43, ["Mega|Fly|Ride"] = 252.57}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.19, ["Ride"] = 78.22, ["Mega"] = 577.5, ["Mega|Ride"] = 535.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.36, ["Ride"] = 47.11, ["Neon"] = 87.26, ["Neon|Ride"] = 105, ["Mega"] = 212.62, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 15.1, ["Ride"] = 41.66, ["Fly|Ride"] = 55.51, ["Neon"] = 59.07, ["Neon|Ride"] = 117.32, ["Neon|Fly|Ride"] = 183.89, ["Mega"] = 205.02, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 324.43}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 92.28, ["Mega"] = 19.69, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.29}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.55, ["Fly"] = 21.18, ["Ride"] = 21.15, ["Fly|Ride"] = 65.63, ["Neon"] = 49.23, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 249.38, ["Mega|Ride"] = 315.16, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 15.75, ["Fly|Ride"] = 70.82, ["Neon"] = 2.86, ["Neon|Ride"] = 28.24, ["Mega"] = 66.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.6, ["Ride"] = 23.26, ["Fly|Ride"] = 140.27, ["Neon"] = 5.25, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 158.18, ["Mega"] = 38.07, ["Mega|Ride"] = 79.16, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.63, ["Fly"] = 45.94, ["Ride"] = 12.7, ["Fly|Ride"] = 78.22, ["Neon"] = 16.44, ["Neon|Ride"] = 28.6, ["Neon|Fly|Ride"] = 90, ["Mega"] = 133.96, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.92, ["Neon"] = 38.66, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 156.41, ["Mega"] = 328.13, ["Mega|Ride"] = 279.57}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 79.11, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.82}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 57.07, ["Neon"] = 3.94, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 17.75, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 30.19, ["Mega|Fly"] = 200.67, ["Mega|Ride"] = 57.42, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 12.7, ["Ride"] = 18.38, ["Fly|Ride"] = 26.25, ["Neon"] = 7.65, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 31.88, ["Mega"] = 65.63, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.23, ["Fly|Ride"] = 53.82, ["Neon"] = 3.68, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 36.68, ["Neon|Fly|Ride"] = 83.5, ["Mega"] = 26.71, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 6.18, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 19.69, ["Mega|Fly"] = 146.35, ["Mega|Ride"] = 88.78, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 28.4, ["Fly|Ride"] = 77.37, ["Neon"] = 4.25, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 24.66, ["Mega|Ride"] = 63.41, ["Mega|Fly|Ride"] = 126.82}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 18.38, ["Mega|Ride"] = 230.37}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.91, ["Neon|Ride"] = 158.21, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 25.4, ["Mega|Fly"] = 118.06, ["Mega|Ride"] = 113.08}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Fly"] = 72.01, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 99.53, ["Mega"] = 63.41, ["Mega|Ride"] = 60.25, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 17.05, ["Ride"] = 65.63, ["Neon"] = 91.88, ["Neon|Ride"] = 236.13, ["Mega"] = 389.2, ["Mega|Ride"] = 468.15, ["Mega|Fly|Ride"] = 704.85}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.49, ["Ride"] = 38.66, ["Fly|Ride"] = 131.25, ["Neon"] = 78.22, ["Mega"] = 210.31, ["Mega|Ride"] = 351.1, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 6.36, ["Ride"] = 28.41, ["Fly|Ride"] = 422.7, ["Neon"] = 32.82, ["Mega"] = 139.5, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 293.35}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 15.61, ["Ride"] = 10.5, ["Fly|Ride"] = 27.49, ["Neon"] = 2.1, ["Neon|Fly"] = 17.22, ["Neon|Ride"] = 12.71, ["Neon|Fly|Ride"] = 27.71, ["Mega"] = 17.84, ["Mega|Fly"] = 24.63, ["Mega|Ride"] = 22.77, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 10.59, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 31.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 158.53, ["Mega|Ride"] = 141.62}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 70.82, ["Mega"] = 15.65, ["Mega|Fly"] = 78.22, ["Mega|Ride"] = 28.54, ["Mega|Fly|Ride"] = 103.58}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Fly"] = 60.9, ["Mega"] = 19.04, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 52.95, ["Neon"] = 12.71, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 143.21, ["Mega|Ride"] = 197.63, ["Mega|Fly|Ride"] = 256.72}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 190.51, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 1547.1, ["Neon|Ride"] = 942.52, ["Neon|Fly|Ride"] = 930.99, ["Mega"] = 8453.83, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Fly"] = 57.07, ["Neon|Ride"] = 68.25, ["Mega"] = 65.42, ["Mega|Ride"] = 183.89, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.08, ["Fly"] = 103.68, ["Ride"] = 24.31, ["Fly|Ride"] = 140.2, ["Neon"] = 19.69, ["Neon|Ride"] = 169.1, ["Neon|Fly|Ride"] = 147.95, ["Mega"] = 464.4, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 15.85, ["Fly|Ride"] = 34.81, ["Neon"] = 6.36, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 65.63, ["Mega|Fly"] = 94.45, ["Mega|Ride"] = 59.7, ["Mega|Fly|Ride"] = 104.63}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 24.94, ["Fly|Ride"] = 120.89, ["Neon"] = 11.8, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 80.96, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 119.43, ["Mega|Ride"] = 123.38}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.35, ["Fly"] = 18.61, ["Ride"] = 16.2, ["Fly|Ride"] = 32.82, ["Neon"] = 28.41, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 57.07, ["Mega"] = 209.18, ["Mega|Ride"] = 281.1, ["Mega|Fly|Ride"] = 254.16}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.8, ["Fly"] = 28.54, ["Ride"] = 39.38, ["Fly|Ride"] = 247.07, ["Neon"] = 26.25, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 627.72, ["Mega"] = 317.04, ["Mega|Ride"] = 293.78, ["Mega|Fly|Ride"] = 398.35}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.1, ["Fly|Ride"] = 31.47, ["Neon"] = 23.63, ["Neon|Fly"] = 83.5, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 196.88, ["Mega|Fly"] = 371.98, ["Mega|Ride"] = 281.51, ["Mega|Fly|Ride"] = 188.45}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 62.36, ["Fly"] = 73.5, ["Ride"] = 85.32, ["Fly|Ride"] = 154.28, ["Neon"] = 395.24, ["Neon|Fly"] = 404.92, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 466.04, ["Mega|Fly|Ride"] = 1532.33}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 322.17, ["Ride"] = 223.13, ["Fly|Ride"] = 261.55, ["Neon"] = 901.92, ["Neon|Ride"] = 986.99, ["Neon|Fly|Ride"] = 1098.57, ["Mega"] = 10567.28, ["Mega|Fly|Ride"] = 4226.93}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 68.23, ["Fly"] = 148.77, ["Ride"] = 84.56, ["Fly|Ride"] = 93.19, ["Neon"] = 379.25, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 351.93, ["Mega|Fly|Ride"] = 1249.5}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.55, ["Ride"] = 26.24, ["Fly|Ride"] = 84.56, ["Neon"] = 22.83, ["Neon|Fly"] = 47.73, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 141.68, ["Mega"] = 590.73, ["Mega|Ride"] = 417.86, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.43, ["Fly"] = 68.14, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 206.08, ["Mega"] = 353.07, ["Mega|Ride"] = 392.06, ["Mega|Fly|Ride"] = 413.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 20.83, ["Fly|Ride"] = 55.32, ["Neon"] = 3.72, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 69.06, ["Mega|Fly"] = 210.11, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 195.93}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.56, ["Fly"] = 68.49, ["Ride"] = 28.54, ["Fly|Ride"] = 131.25, ["Neon"] = 23.83, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 789.38, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 15.94, ["Ride"] = 16.95, ["Fly|Ride"] = 42, ["Neon"] = 15.65, ["Neon|Fly"] = 131.18, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 131.25, ["Mega|Ride"] = 141.62, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.75, ["Ride"] = 21.15, ["Fly|Ride"] = 91.88, ["Neon"] = 23.63, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 236.13, ["Mega"] = 207.37, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 244.12}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.84, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 44.88, ["Mega"] = 15.75, ["Mega|Ride"] = 50.74, ["Mega|Fly|Ride"] = 198.02}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.93, ["Fly"] = 45.93, ["Ride"] = 20.89, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Fly"] = 105.69, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 108.93, ["Mega|Ride"] = 96.49, ["Mega|Fly|Ride"] = 189.67}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.75, ["Ride"] = 17.75, ["Fly|Ride"] = 39.29, ["Neon"] = 63.76, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 63, ["Mega"] = 268.43, ["Mega|Ride"] = 205.4, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 112.46, ["Fly"] = 238.84, ["Ride"] = 201.62, ["Fly|Ride"] = 196.87, ["Neon"] = 594.51, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 524.92, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2166.48}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.55, ["Ride"] = 30.19, ["Fly|Ride"] = 206.07, ["Neon"] = 43.32, ["Neon|Ride"] = 81.29, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 294.5, ["Mega|Ride"] = 282.17, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 31.88, ["Ride"] = 27.56, ["Fly|Ride"] = 70.82, ["Neon"] = 26.25, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.82, ["Mega|Ride"] = 281.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.3, ["Fly"] = 59.07, ["Ride"] = 85.32, ["Fly|Ride"] = 178.5, ["Neon"] = 106.2, ["Neon|Ride"] = 126.82, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 419.88, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 475.55}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.93}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.28, ["Ride"] = 21.15, ["Fly|Ride"] = 39.38, ["Neon"] = 68.25, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 634.06, ["Mega"] = 283.5, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 549.52}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.32, ["Fly"] = 26.21, ["Ride"] = 23.62, ["Fly|Ride"] = 43.32, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 158.74, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 2113.48, ["Mega|Ride"] = 694.07, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.71, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 3.92, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 31.5, ["Mega|Ride"] = 73.48, ["Mega|Fly|Ride"] = 183.89}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 5.1, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 86.67, ["Neon"] = 30.58, ["Neon|Ride"] = 99.36, ["Mega"] = 265.13, ["Mega|Fly"] = 394.26, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 45.76, ["Ride"] = 12.7, ["Fly|Ride"] = 78.22, ["Neon"] = 15.73, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 136.43, ["Mega|Ride"] = 124.95, ["Mega|Fly|Ride"] = 240.19}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 28.03, ["Mega"] = 30.19, ["Mega|Ride"] = 63.75, ["Mega|Fly|Ride"] = 205.06}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.62, ["Ride"] = 69.57, ["Neon"] = 199.01, ["Neon|Ride"] = 314.05, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 859, ["Mega|Ride"] = 774.38, ["Mega|Fly|Ride"] = 884.01}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.7, ["Ride"] = 70.82, ["Fly|Ride"] = 210, ["Neon"] = 69.55, ["Neon|Ride"] = 79.27, ["Neon|Fly|Ride"] = 211.36, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 13.12, ["Fly"] = 131.15, ["Ride"] = 50.74, ["Fly|Ride"] = 196.88, ["Neon"] = 75.9, ["Neon|Fly"] = 211.36, ["Neon|Ride"] = 84.69, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 429.19, ["Mega|Ride"] = 528.38, ["Mega|Fly|Ride"] = 491.23}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 47.23, ["Fly"] = 141.62, ["Ride"] = 52.5, ["Fly|Ride"] = 262.44, ["Neon"] = 208.69, ["Neon|Ride"] = 393.75, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2260.35}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 16.93, ["Fly"] = 131.25, ["Ride"] = 59.7, ["Fly|Ride"] = 141.62, ["Neon"] = 196.88, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 845.39, ["Mega"] = 523.09, ["Mega|Ride"] = 464.46, ["Mega|Fly|Ride"] = 1126.49}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 74.76, ["Fly"] = 145.69, ["Ride"] = 124.71, ["Fly|Ride"] = 170.63, ["Neon"] = 202.92, ["Neon|Ride"] = 228.38, ["Neon|Fly|Ride"] = 348.28, ["Mega"] = 938.44, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 876.85}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.58, ["Ride"] = 66.26, ["Fly|Ride"] = 162.75, ["Neon"] = 76.06, ["Neon|Ride"] = 124, ["Neon|Fly|Ride"] = 253.63, ["Mega"] = 466.26, ["Mega|Ride"] = 310.72, ["Mega|Fly|Ride"] = 407.14}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 13.13, ["Fly"] = 69.5, ["Ride"] = 21.15, ["Neon"] = 81.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 335.24, ["Mega|Ride"] = 1056.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 26.25, ["Ride"] = 75.23, ["Fly|Ride"] = 189.53, ["Neon"] = 81.67, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 523.09, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 692.35}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 9.76, ["Ride"] = 34.13, ["Fly|Ride"] = 139.5, ["Neon"] = 53.91, ["Neon|Ride"] = 92.67, ["Mega"] = 311.75, ["Mega|Ride"] = 361.41, ["Mega|Fly|Ride"] = 391.84}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 56.44, ["Mega"] = 18.38, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 70.81, ["Mega|Fly|Ride"] = 169.1}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.93, ["Ride"] = 210, ["Neon"] = 18.38, ["Neon|Ride"] = 83.83, ["Mega"] = 121.41, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 448.54}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.63, ["Ride"] = 57.07, ["Neon"] = 22.32, ["Neon|Ride"] = 105.69, ["Mega"] = 181.79}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.36, ["Ride"] = 31.44, ["Fly|Ride"] = 116.89, ["Neon"] = 28.54, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 472.4, ["Ride"] = 539.78, ["Fly|Ride"] = 589.31, ["Neon|Ride"] = 1584.05, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.88, ["Fly"] = 57.07, ["Ride"] = 25.18, ["Fly|Ride"] = 57.07, ["Neon"] = 42.29, ["Neon|Ride"] = 78.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 239.89, ["Mega|Ride"] = 274.77, ["Mega|Fly|Ride"] = 366.71}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 28.54, ["Fly|Ride"] = 84.56, ["Neon"] = 55.13, ["Neon|Fly"] = 315, ["Neon|Ride"] = 64.32, ["Mega"] = 228.26, ["Mega|Ride"] = 206.08, ["Mega|Fly|Ride"] = 393.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.14, ["Fly"] = 28.54, ["Ride"] = 22.44, ["Fly|Ride"] = 141.62, ["Neon"] = 21.19, ["Neon|Ride"] = 196.87, ["Mega"] = 223.13, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.15, ["Fly|Ride"] = 941.48, ["Neon"] = 10.28, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 30.71, ["Neon|Fly|Ride"] = 120.39, ["Mega"] = 81.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 158.45}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 70.82, ["Neon"] = 3.84, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 158.18, ["Mega"] = 26.64, ["Mega|Ride"] = 107.43, ["Mega|Fly|Ride"] = 211.36}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1532.27}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.35, ["Ride"] = 51.61, ["Neon"] = 52.85, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 88.78, ["Mega"] = 648.85, ["Mega|Ride"] = 845.39, ["Mega|Fly|Ride"] = 674}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Neon"] = 8.43, ["Neon|Ride"] = 42.29, ["Mega"] = 141.62, ["Mega|Ride"] = 137.62, ["Mega|Fly|Ride"] = 236.09}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 42.29, ["Ride"] = 21.15, ["Fly|Ride"] = 525, ["Neon"] = 11.08, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 183.75, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 368.8, ["Ride"] = 448.06, ["Fly|Ride"] = 452.82, ["Neon"] = 1372.71, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1703.55, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.91, ["Fly"] = 196.88, ["Ride"] = 72.19, ["Neon"] = 86.63, ["Neon|Ride"] = 131.25, ["Mega"] = 378.25, ["Mega|Ride"] = 400.52, ["Mega|Fly|Ride"] = 395.24}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Neon"] = 4.52, ["Neon|Ride"] = 40.71, ["Neon|Fly|Ride"] = 94.45, ["Mega"] = 39.03, ["Mega|Fly"] = 189, ["Mega|Ride"] = 78.14, ["Mega|Fly|Ride"] = 187.2}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 98.28, ["Neon|Fly|Ride"] = 268.43, ["Mega"] = 19.69, ["Mega|Ride"] = 78.22, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.5, ["Fly"] = 56.27, ["Ride"] = 35.44, ["Fly|Ride"] = 148.26, ["Neon"] = 83.5, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 328.13, ["Mega|Ride"] = 417.42, ["Mega|Fly|Ride"] = 372.75}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.98, ["Ride"] = 109.92, ["Neon"] = 92.09, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 630.32, ["Mega|Ride"] = 561.29, ["Mega|Fly|Ride"] = 1082.18}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.63, ["Ride"] = 26.25, ["Fly|Ride"] = 99.36, ["Neon"] = 141.62, ["Neon|Ride"] = 200.82, ["Mega"] = 582.75, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15.89, ["Ride"] = 43.32, ["Fly|Ride"] = 141.7, ["Neon"] = 110.98, ["Neon|Ride"] = 156.13, ["Neon|Fly|Ride"] = 787.44, ["Mega"] = 535.78, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 448.54}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 369.13, ["Ride"] = 367.5, ["Fly|Ride"] = 524.11, ["Neon"] = 1268.09, ["Neon|Ride"] = 1268.09, ["Neon|Fly|Ride"] = 1268.09, ["Mega|Ride"] = 3790.49, ["Mega|Fly|Ride"] = 3193}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.01, ["Fly"] = 28.3, ["Ride"] = 30.65, ["Fly|Ride"] = 83.85, ["Neon"] = 38.07, ["Neon|Ride"] = 134.59, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 525, ["Mega|Ride"] = 535.5, ["Mega|Fly|Ride"] = 541.06}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 7.88, ["Ride"] = 116.94, ["Mega"] = 1268.09, ["Mega|Fly|Ride"] = 1690.78}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.43, ["Ride"] = 55.85, ["Fly|Ride"] = 162.75, ["Neon"] = 37.79, ["Neon|Ride"] = 91.88, ["Mega"] = 198.83, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.47, ["Ride"] = 42, ["Fly|Ride"] = 110.99, ["Neon"] = 14.43, ["Neon|Ride"] = 45.46, ["Mega"] = 40.17, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 236.09}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.85, ["Ride"] = 82.45, ["Neon"] = 272.6, ["Neon|Ride"] = 244.39, ["Neon|Fly|Ride"] = 408.97, ["Mega"] = 1054.62, ["Mega|Ride"] = 1124.38, ["Mega|Fly|Ride"] = 1121.57}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 3.28, ["Fly"] = 590.3, ["Ride"] = 30.72, ["Fly|Ride"] = 63.76, ["Neon"] = 11.82, ["Neon|Fly"] = 156.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 51.18, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 28.54, ["Fly|Ride"] = 70.82, ["Neon"] = 6.46, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 32.82, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 70.96, ["Mega|Fly|Ride"] = 170.92}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 3.82, ["Ride"] = 57.75, ["Fly|Ride"] = 262.5, ["Neon"] = 21, ["Neon|Ride"] = 158.21, ["Neon|Fly|Ride"] = 200.71, ["Mega"] = 116.82, ["Mega|Fly"] = 634.06, ["Mega|Ride"] = 190.22, ["Mega|Fly|Ride"] = 562.2}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 93.28, ["Ride"] = 105.69, ["Fly|Ride"] = 201.86, ["Neon"] = 352.96, ["Neon|Ride"] = 582.75, ["Neon|Fly|Ride"] = 627.38, ["Mega|Fly|Ride"] = 1023.39}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 243, ["Ride"] = 270.38, ["Fly|Ride"] = 324.43, ["Neon"] = 845.39, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1095.94, ["Mega"] = 7045.22, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.55, ["Neon"] = 37.88, ["Neon|Ride"] = 78.75, ["Mega"] = 91.88, ["Mega|Ride"] = 167.53, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 10.59, ["Ride"] = 33.43, ["Fly|Ride"] = 210.31, ["Neon"] = 26.23, ["Mega"] = 94.66, ["Mega|Ride"] = 126.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.83, ["Fly"] = 155.57, ["Ride"] = 27.57, ["Neon"] = 34.13, ["Mega"] = 508.6, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 394.26}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 20.98, ["Fly|Ride"] = 65.63, ["Neon"] = 6.36, ["Neon|Ride"] = 30.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 32.81, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.63, ["Ride"] = 36.64, ["Fly|Ride"] = 282.17, ["Neon"] = 6.57, ["Mega"] = 52.5, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 206.08, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.36, ["Fly|Ride"] = 41.94, ["Neon"] = 3.93, ["Neon|Fly"] = 47.23, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 39.38, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 141.66}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.94, ["Fly|Ride"] = 63.41, ["Neon"] = 8.97, ["Neon|Fly"] = 47.23, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 40.17, ["Mega"] = 170.63, ["Mega|Ride"] = 200.8, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 41.99, ["Ride"] = 42.29, ["Fly|Ride"] = 83.65, ["Neon"] = 186.38, ["Neon|Ride"] = 282.17, ["Mega"] = 380.63, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 78.72, ["Fly"] = 582.75, ["Ride"] = 98.68, ["Fly|Ride"] = 422.7, ["Neon"] = 366.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 471.19, ["Mega"] = 3148.02, ["Mega|Ride"] = 2240.27, ["Mega|Fly|Ride"] = 1508.67}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 131.25, ["Neon"] = 4.24, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 56.35, ["Mega|Ride"] = 79.1}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 19.04, ["Fly|Ride"] = 30.15, ["Neon"] = 4.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 32.73, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 108.86}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 7.88, ["Ride"] = 51.19, ["Neon"] = 122.59, ["Neon|Ride"] = 158.21, ["Neon|Fly|Ride"] = 156.41, ["Mega"] = 631.73, ["Mega|Ride"] = 352.4, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 262.5, ["Fly"] = 413.44, ["Ride"] = 422.63, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1127.55, ["Neon|Fly|Ride"] = 1584.05, ["Mega|Fly|Ride"] = 5283.65}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.53, ["Fly"] = 141.62, ["Ride"] = 56.6, ["Fly|Ride"] = 106.32, ["Neon"] = 196.88, ["Neon|Ride"] = 234.78, ["Neon|Fly|Ride"] = 264.37, ["Mega"] = 1081.06, ["Mega|Ride"] = 963.69, ["Mega|Fly|Ride"] = 904.43}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 42.29, ["Neon"] = 6.55, ["Neon|Ride"] = 33.84, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 82.69, ["Mega|Ride"] = 111.12, ["Mega|Fly|Ride"] = 198.77}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.41, ["Fly"] = 211.36, ["Ride"] = 28.88, ["Fly|Ride"] = 142.7, ["Neon"] = 31.71, ["Neon|Ride"] = 201.86, ["Mega"] = 211.3}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.87, ["Fly"] = 78.22, ["Ride"] = 42.29, ["Fly|Ride"] = 84.56, ["Neon|Fly|Ride"] = 187.04, ["Mega"] = 2536.15, ["Mega|Ride"] = 955.5, ["Mega|Fly|Ride"] = 1102.47}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 78.22, ["Ride"] = 141.91, ["Fly|Ride"] = 141.62, ["Neon"] = 426.57, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 438.56, ["Mega"] = 3100.44, ["Mega|Fly|Ride"] = 2124.66}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 210.91, ["Ride"] = 236.25, ["Fly|Ride"] = 345.48, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1156.07, ["Mega|Fly|Ride"] = 2958.85}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 19.65, ["Ride"] = 60.37, ["Fly|Ride"] = 217.25, ["Neon"] = 85.45, ["Neon|Ride"] = 144.16, ["Mega"] = 381.62, ["Mega|Ride"] = 362.38, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.49, ["Ride"] = 16.93, ["Fly|Ride"] = 35.95, ["Neon"] = 8.48, ["Neon|Ride"] = 25.38, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 90.57, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 19.3, ["Fly|Ride"] = 70.82, ["Neon"] = 28.61, ["Neon|Fly"] = 147.95, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 236.25, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 285.92}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 301.88, ["Fly"] = 493.5, ["Ride"] = 262.5, ["Fly|Ride"] = 406.88, ["Neon"] = 2060.63, ["Neon|Ride"] = 1369.53, ["Neon|Fly|Ride"] = 1832.38, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.51, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 39.38, ["Mega|Ride"] = 147.95, ["Mega|Fly|Ride"] = 268.43}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.24, ["Fly"] = 17.73, ["Ride"] = 21.15, ["Fly|Ride"] = 47.24, ["Neon"] = 21.15, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 170.22, ["Mega|Ride"] = 211.36, ["Mega|Fly|Ride"] = 277.94}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 22.32, ["Ride"] = 141.62, ["Neon"] = 104.83, ["Neon|Fly"] = 282.17, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 564.31, ["Mega"] = 466.48, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 152.86, ["Fly"] = 172.26, ["Ride"] = 129.94, ["Fly|Ride"] = 141.62, ["Neon"] = 421.64, ["Neon|Ride"] = 704.85, ["Neon|Fly|Ride"] = 670.69, ["Mega|Fly|Ride"] = 2508.69}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.93, ["Fly"] = 45.05, ["Ride"] = 30.18, ["Fly|Ride"] = 49.79, ["Neon"] = 78.22, ["Neon|Ride"] = 96.33, ["Neon|Fly|Ride"] = 139.14, ["Mega"] = 703.8, ["Mega|Ride"] = 438.56, ["Mega|Fly|Ride"] = 413.15}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 704.85, ["Mega"] = 25.41, ["Mega|Ride"] = 105.69, ["Mega|Fly|Ride"] = 252.57}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 158.21, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 27.55, ["Mega|Fly"] = 140.47, ["Mega|Ride"] = 47.31, ["Mega|Fly|Ride"] = 103.36}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.43, ["Fly"] = 91.88, ["Ride"] = 52.49, ["Fly|Ride"] = 158.82, ["Neon"] = 32.82, ["Neon|Fly"] = 99.36, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.89, ["Mega"] = 141.43, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 311.75}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1279.69, ["Ride"] = 1312.5, ["Fly|Ride"] = 1308.57, ["Neon|Ride"] = 7045.22, ["Neon|Fly|Ride"] = 4010.16, ["Mega"] = 18175.71, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 512.56, ["Fly"] = 613.95, ["Ride"] = 599.82, ["Fly|Ride"] = 608.6, ["Neon"] = 2818.3, ["Mega"] = 14164.29, ["Mega|Fly|Ride"] = 7084.87}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 293.2, ["Fly"] = 422.7, ["Ride"] = 340.96, ["Fly|Ride"] = 408.19, ["Neon"] = 735, ["Neon|Ride"] = 801.02, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 2677.76}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 313.38, ["Fly"] = 452.29, ["Ride"] = 352.96, ["Fly|Ride"] = 467.25, ["Neon"] = 1023.75, ["Neon|Fly"] = 3148.47, ["Neon|Ride"] = 1014.48, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 3638.33}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 17, ["Fly|Ride"] = 44.62, ["Neon"] = 5.25, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 57.2, ["Mega"] = 71.37, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 393.75, ["Fly"] = 590.62, ["Ride"] = 452.29, ["Fly|Ride"] = 564.38, ["Neon"] = 853.13, ["Neon|Ride"] = 1088.07, ["Neon|Fly|Ride"] = 1140.57, ["Mega"] = 6340.38, ["Mega|Fly|Ride"] = 4219.69}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 25.33, ["Fly|Ride"] = 39.38, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 113.08, ["Mega"] = 61.3, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 218.09}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.76, ["Ride"] = 21.15, ["Fly|Ride"] = 49.88, ["Neon"] = 14.2, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 91.88, ["Mega|Ride"] = 169.1, ["Mega|Fly|Ride"] = 314.62}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 4.03, ["Neon|Fly"] = 79.11, ["Neon|Ride"] = 24.31, ["Mega"] = 13.13, ["Mega|Fly"] = 70.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 39.3, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 315.53, ["Mega"] = 1690.78, ["Mega|Fly|Ride"] = 944.3}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 3.93, ["Fly"] = 65.61, ["Ride"] = 23.63, ["Fly|Ride"] = 43.32, ["Neon"] = 15.86, ["Mega"] = 328.13, ["Mega|Ride"] = 233.89}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 3.68, ["Neon|Fly"] = 105.69, ["Neon|Ride"] = 36.39, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 26.17, ["Mega|Fly"] = 704.85, ["Mega|Ride"] = 50.65, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 23.99, ["Fly|Ride"] = 49.69, ["Neon"] = 6.57, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 71.99, ["Mega"] = 60.38, ["Mega|Fly"] = 175.14, ["Mega|Ride"] = 77.59, ["Mega|Fly|Ride"] = 163.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.91, ["Fly"] = 20.14, ["Ride"] = 31.88, ["Fly|Ride"] = 51.45, ["Neon"] = 70.82, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 237.57, ["Mega|Ride"] = 268.43, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 52.41, ["Neon"] = 78.22, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 305.72, ["Mega"] = 352.96, ["Mega|Ride"] = 336.06, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 7.87, ["Ride"] = 26.25, ["Neon"] = 42.29, ["Neon|Ride"] = 79.11, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 452.29, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 16.86, ["Ride"] = 19.06, ["Fly|Ride"] = 55.51, ["Neon"] = 3.94, ["Neon|Ride"] = 47.16, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 317.04}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 205.4, ["Fly"] = 295.89, ["Ride"] = 211.36, ["Fly|Ride"] = 278.64, ["Neon|Ride"] = 1139.16, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10567.28, ["Mega|Fly|Ride"] = 4463.63}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.2, ["Ride"] = 12.7, ["Fly|Ride"] = 31.88, ["Neon"] = 4.24, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 38.06, ["Mega|Ride"] = 73.03, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.5, ["Ride"] = 42.51, ["Fly|Ride"] = 180.03, ["Neon"] = 74.05, ["Neon|Ride"] = 104.51, ["Mega"] = 349.02, ["Mega|Ride"] = 336.71, ["Mega|Fly|Ride"] = 421.64}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 31.95, ["Fly"] = 131.25, ["Ride"] = 50.82, ["Fly|Ride"] = 141.62, ["Neon"] = 209.25, ["Neon|Ride"] = 231.42, ["Neon|Fly|Ride"] = 366.71, ["Mega"] = 894.73, ["Mega|Ride"] = 832.08, ["Mega|Fly|Ride"] = 772.48}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 141.62, ["Fly"] = 308.44, ["Ride"] = 210.61, ["Fly|Ride"] = 305.72, ["Neon"] = 841.32, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 866.25, ["Mega|Ride"] = 3381.54, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.57, ["Fly"] = 168.88, ["Neon"] = 70.82, ["Neon|Ride"] = 282.17, ["Mega"] = 281.54, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 704.85}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 28.88, ["Ride"] = 278.99, ["Fly|Ride"] = 158.82, ["Neon"] = 210.31, ["Neon|Fly|Ride"] = 845.39, ["Mega"] = 1416.44, ["Mega|Fly|Ride"] = 1268.09}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1207.49, ["Fly"] = 1441.13, ["Ride"] = 1198.35, ["Fly|Ride"] = 1197.79, ["Neon|Ride"] = 4509.07, ["Neon|Fly|Ride"] = 4335.74, ["Mega|Fly|Ride"] = 17190.85}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.97, ["Fly"] = 25.38, ["Ride"] = 20.57, ["Fly|Ride"] = 62.99, ["Neon"] = 53.91, ["Neon|Fly"] = 75.06, ["Neon|Ride"] = 46.51, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 224.49, ["Mega|Ride"] = 257.33, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.35, ["Fly"] = 13948.8, ["Ride"] = 28.54, ["Neon"] = 36.62, ["Neon|Ride"] = 140.39, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 169.1, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 472.16}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.02, ["Fly"] = 191.27, ["Ride"] = 28.3, ["Fly|Ride"] = 57.39, ["Neon"] = 36.64, ["Neon|Ride"] = 118.07, ["Mega"] = 103.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.35, ["Fly"] = 704.85, ["Ride"] = 39.38, ["Fly|Ride"] = 422.7, ["Neon"] = 86.62, ["Neon|Ride"] = 98.98, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 398.48, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 7.74, ["Fly"] = 21.15, ["Ride"] = 15.85, ["Fly|Ride"] = 31.77, ["Neon"] = 22.13, ["Neon|Fly"] = 57.07, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 87.72, ["Mega|Ride"] = 158.18, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 417.42, ["Neon"] = 11.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.9, ["Neon|Fly|Ride"] = 110.99, ["Mega"] = 233.24, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 387.83}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 211.36, ["Ride"] = 333.38, ["Fly|Ride"] = 282.17, ["Neon|Ride"] = 1693.13, ["Neon|Fly|Ride"] = 1453.02, ["Mega|Ride"] = 5250, ["Mega|Fly|Ride"] = 4721.45}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.59, ["Ride"] = 27.9, ["Fly|Ride"] = 51.97, ["Neon"] = 10.96, ["Neon|Ride"] = 42.15, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 112.88, ["Mega|Ride"] = 103.43, ["Mega|Fly|Ride"] = 424.94}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.38, ["Ride"] = 412.14, ["Neon"] = 42, ["Neon|Ride"] = 313.85, ["Mega"] = 278.99, ["Mega|Ride"] = 267.25}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 7.87, ["Fly"] = 58.27, ["Ride"] = 34.13, ["Neon"] = 19.26, ["Neon|Ride"] = 57.07, ["Mega"] = 104.56, ["Mega|Fly"] = 422.7, ["Mega|Ride"] = 193.59, ["Mega|Fly|Ride"] = 349.79}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 164.07, ["Fly"] = 338.17, ["Ride"] = 301.88, ["Fly|Ride"] = 262.5, ["Neon"] = 661.11, ["Neon|Ride"] = 634.06, ["Neon|Fly|Ride"] = 945, ["Mega|Ride"] = 5072.3, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.63, ["Fly"] = 57.07, ["Ride"] = 149.63, ["Fly|Ride"] = 109.92, ["Neon"] = 84.56, ["Neon|Ride"] = 145.84, ["Neon|Fly|Ride"] = 321.26, ["Mega"] = 701.69, ["Mega|Fly|Ride"] = 813.96}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.94, ["Ride"] = 63.41, ["Fly|Ride"] = 1268.09, ["Neon"] = 102.37, ["Neon|Ride"] = 110.99, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 487.17, ["Mega|Ride"] = 482.05, ["Mega|Fly|Ride"] = 547.32}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.34, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.25, ["Mega"] = 33.45, ["Mega|Ride"] = 277.09, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 52.5, ["Fly"] = 63.41, ["Ride"] = 83.87, ["Fly|Ride"] = 141.62, ["Neon"] = 408.97, ["Neon|Fly"] = 324.43, ["Neon|Ride"] = 332.07, ["Neon|Fly|Ride"] = 383.25, ["Mega|Fly|Ride"] = 1175.1}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Neon"] = 6.57, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 588, ["Mega"] = 37, ["Mega|Ride"] = 141.62}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.96, ["Fly"] = 36.11, ["Ride"] = 23.63, ["Fly|Ride"] = 61.69, ["Neon"] = 91.95, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 380.63, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 367.85}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.23, ["Fly"] = 80.01, ["Ride"] = 84.56, ["Fly|Ride"] = 125.77, ["Neon"] = 238.84, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1234.27, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 12.7, ["Ride"] = 15.86, ["Fly|Ride"] = 32.48, ["Neon"] = 2.6, ["Neon|Fly"] = 16.93, ["Neon|Ride"] = 12.69, ["Neon|Fly|Ride"] = 42.51, ["Mega"] = 17.73, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.11, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.92, ["Ride"] = 32.18, ["Fly|Ride"] = 105, ["Neon"] = 14.96, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Ride"] = 282.17, ["Mega|Fly|Ride"] = 211.36}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.94, ["Ride"] = 78.89, ["Neon"] = 150.94, ["Neon|Ride"] = 209.25, ["Neon|Fly|Ride"] = 358.99, ["Mega"] = 586.69, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.49, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 137.39, ["Mega"] = 15.74, ["Mega|Ride"] = 78.56}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 6.56, ["Fly"] = 210, ["Ride"] = 23.63, ["Fly|Ride"] = 105, ["Neon"] = 64.58, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 219.81, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 230.37, ["Mega|Fly|Ride"] = 315.98}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.5, ["Fly"] = 42.31, ["Ride"] = 26.17, ["Fly|Ride"] = 46.59, ["Neon"] = 117.03, ["Neon|Ride"] = 64.56, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 672.81}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.91, ["Ride"] = 59.05, ["Fly|Ride"] = 78.75, ["Neon"] = 25.7, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 170.63, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 20.11, ["Fly"] = 2113.48, ["Ride"] = 85.56, ["Neon"] = 500.91, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 564.31, ["Mega"] = 733.39, ["Mega|Ride"] = 1024.42, ["Mega|Fly|Ride"] = 1125.49}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 125.58, ["Fly|Ride"] = 196.87, ["Neon"] = 8.9, ["Neon|Fly"] = 50.74, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 99.08, ["Mega"] = 74.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 136.94, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 23.63, ["Mega|Ride"] = 141.62, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 47.23, ["Fly"] = 102.38, ["Ride"] = 65.63, ["Fly|Ride"] = 207.13, ["Neon"] = 1050, ["Neon|Ride"] = 228.26, ["Neon|Fly|Ride"] = 1056.75, ["Mega"] = 1113.8, ["Mega|Ride"] = 700.63, ["Mega|Fly|Ride"] = 787.32}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 81.38, ["Fly|Ride"] = 141.62, ["Neon"] = 2.23, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 18.36, ["Mega|Fly"] = 137.82, ["Mega|Ride"] = 99.56, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 551.25, ["Ride"] = 713.12, ["Fly|Ride"] = 656.25, ["Neon"] = 2391.39, ["Neon|Fly|Ride"] = 2395.62, ["Mega"] = 16907.64, ["Mega|Fly|Ride"] = 14084.07}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.7, ["Fly"] = 26.17, ["Ride"] = 42.29, ["Fly|Ride"] = 79.27, ["Neon|Ride"] = 278.99, ["Mega"] = 82.45, ["Mega|Ride"] = 141.62, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 158.22, ["Ride"] = 21.15, ["Fly|Ride"] = 52.5, ["Neon"] = 22.32, ["Neon|Ride"] = 35.74, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 138.45, ["Mega|Ride"] = 155.24, ["Mega|Fly|Ride"] = 193.39}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.88, ["Ride"] = 76.13, ["Fly|Ride"] = 106.31, ["Neon"] = 105.42, ["Neon|Ride"] = 55.51, ["Mega"] = 393.75, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 466.04}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 39.38, ["Ride"] = 31.5, ["Fly|Ride"] = 141.62, ["Neon"] = 41.24, ["Neon|Ride"] = 47.23, ["Mega"] = 293.78}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 104.98, ["Ride"] = 57.07, ["Fly|Ride"] = 157.4, ["Neon"] = 73.98, ["Neon|Ride"] = 165.01, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 352.1, ["Mega|Ride"] = 348.73, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 10.5, ["Fly"] = 98.44, ["Ride"] = 39.38, ["Fly|Ride"] = 787.5, ["Neon"] = 31.88, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 168, ["Mega|Fly"] = 490.34, ["Mega|Ride"] = 266.32, ["Mega|Fly|Ride"] = 369.87}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 27.49, ["Ride"] = 15.86, ["Fly|Ride"] = 39.29, ["Neon"] = 2.1, ["Neon|Fly"] = 28.54, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 69.76, ["Mega"] = 16.42, ["Mega|Fly"] = 79.11, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.64, ["Ride"] = 27.57, ["Fly|Ride"] = 158.22, ["Neon"] = 36.75, ["Neon|Fly"] = 118.07, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 317.04, ["Mega"] = 167.88, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 248.07, ["Ride"] = 304.5, ["Fly|Ride"] = 338.17, ["Neon"] = 1480.5, ["Neon|Ride"] = 1102.65, ["Neon|Fly|Ride"] = 1268.09, ["Mega|Fly|Ride"] = 3961.89}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.31, ["Fly"] = 156.41, ["Ride"] = 142.68, ["Fly|Ride"] = 262.5, ["Neon"] = 549.52, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 4226.93, ["Mega|Ride"] = 1826.04, ["Mega|Fly|Ride"] = 1627.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.7, ["Ride"] = 12.7, ["Fly|Ride"] = 39.34, ["Neon"] = 12.71, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 90.9, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 91.95, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 12.7, ["Ride"] = 15.63, ["Fly|Ride"] = 31.47, ["Neon"] = 6.36, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.08, ["Neon|Fly|Ride"] = 48.62, ["Mega"] = 73.95, ["Mega|Fly"] = 352.96, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 152.15}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.6, ["Ride"] = 18.9, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 1127.55}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 251.48, ["Fly|Ride"] = 345.56, ["Neon|Ride"] = 1291.54, ["Neon|Fly|Ride"] = 1232.16, ["Mega|Ride"] = 8453.83, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 23.63, ["Ride"] = 17.52, ["Fly|Ride"] = 35.44, ["Neon"] = 23.63, ["Neon|Fly"] = 158.21, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 74.91, ["Mega"] = 290.62, ["Mega|Ride"] = 253.63, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.92, ["Fly"] = 141.68, ["Ride"] = 40.16, ["Fly|Ride"] = 211.36, ["Neon"] = 40.16, ["Neon|Ride"] = 74.64, ["Mega"] = 251.99, ["Mega|Ride"] = 236.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.7, ["Fly"] = 70.82, ["Ride"] = 21.26, ["Fly|Ride"] = 59.07, ["Neon"] = 124.71, ["Neon|Ride"] = 90.9, ["Neon|Fly|Ride"] = 179.66, ["Mega"] = 728.34, ["Mega|Ride"] = 421.64, ["Mega|Fly|Ride"] = 386.93}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.5, ["Fly"] = 116.82, ["Ride"] = 102.74, ["Fly|Ride"] = 230, ["Neon"] = 141.67, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 459.38, ["Mega|Fly"] = 2219.14, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 601.96}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.61, ["Fly"] = 63.76, ["Ride"] = 42.11, ["Fly|Ride"] = 96.55, ["Neon"] = 118.13, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 139.17, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 704.85, ["Mega|Ride"] = 787.05, ["Mega|Fly|Ride"] = 662.53}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.02, ["Fly"] = 17.07, ["Ride"] = 15.85, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 62.36, ["Mega"] = 20.72, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 45.46, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 190.63, ["Fly"] = 278.24, ["Ride"] = 223.13, ["Fly|Ride"] = 316.32, ["Neon"] = 892.5, ["Neon|Ride"] = 958.13, ["Neon|Fly|Ride"] = 981.62, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.17, ["Fly"] = 140.39, ["Ride"] = 42.2, ["Fly|Ride"] = 131.51, ["Neon"] = 116.82, ["Neon|Ride"] = 211.36, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 25.38, ["Ride"] = 18.38, ["Fly|Ride"] = 38.07, ["Neon"] = 9.47, ["Neon|Fly"] = 28.59, ["Neon|Ride"] = 31.88, ["Mega"] = 49.24, ["Mega|Fly"] = 79.27, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 94.45}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 16.93, ["Fly|Ride"] = 70.82, ["Neon"] = 3.42, ["Neon|Fly"] = 47.23, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 23.26, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 52.85, ["Mega|Fly|Ride"] = 135.14}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 21.19, ["Fly|Ride"] = 141.75, ["Neon"] = 7.88, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 7045.22, ["Mega"] = 92.93, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 380.43}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.86, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 63.56, ["Neon"] = 57.75, ["Neon|Ride"] = 60.25, ["Neon|Fly|Ride"] = 112.82, ["Mega"] = 348.22, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 11.71, ["Ride"] = 26.25, ["Neon"] = 36.01, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 236.25, ["Mega|Ride"] = 306.46, ["Mega|Fly|Ride"] = 435.39}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 44.76, ["Neon"] = 3.94, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 94.46, ["Mega"] = 26.13, ["Mega|Fly"] = 105.69, ["Mega|Ride"] = 76.68, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.2, ["Fly"] = 42.29, ["Ride"] = 36.01, ["Fly|Ride"] = 84.56, ["Neon"] = 24.94, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 48.62, ["Neon|Fly|Ride"] = 141.89, ["Mega"] = 157.5, ["Mega|Fly"] = 268.43, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 126.82, ["Fly|Ride"] = 99.36, ["Neon"] = 8.48, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 54.32, ["Neon|Fly|Ride"] = 158.21, ["Mega"] = 32.75, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 24.62, ["Ride"] = 19.04, ["Fly|Ride"] = 65.63, ["Neon"] = 7.87, ["Neon|Ride"] = 28.46, ["Neon|Fly|Ride"] = 84.99, ["Mega"] = 79.1, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 158.18}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.88, ["Ride"] = 693, ["Fly|Ride"] = 729.1, ["Neon"] = 3339.27, ["Neon|Ride"] = 3381.54, ["Neon|Fly|Ride"] = 4555.57, ["Mega|Fly|Ride"] = 12462.19}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.93, ["Fly|Ride"] = 36, ["Neon"] = 24.26, ["Neon|Fly"] = 50.74, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 69.76, ["Mega"] = 189.16, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.02, ["Ride"] = 45.94, ["Fly|Ride"] = 105.51, ["Neon"] = 7.85, ["Neon|Fly"] = 845.39, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 48.57, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 100.99, ["Mega|Fly|Ride"] = 303.18}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.58, ["Fly"] = 28.54, ["Ride"] = 24.31, ["Fly|Ride"] = 50.74, ["Neon"] = 49.88, ["Neon|Fly"] = 112.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 311.75, ["Mega|Ride"] = 305.01, ["Mega|Fly|Ride"] = 335.99}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 16.93, ["Fly|Ride"] = 33.92, ["Neon"] = 8.34, ["Neon|Fly"] = 131.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 63.31, ["Mega|Fly"] = 349.84, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 172.7}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 49.87, ["Ride"] = 62.36, ["Neon"] = 282.17, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 360.94, ["Mega"] = 887.48, ["Mega|Ride"] = 1056.75}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21.15, ["Fly|Ride"] = 88.78, ["Neon"] = 6.57, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 63.66, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.56, ["Fly"] = 73.5, ["Ride"] = 23.63, ["Fly|Ride"] = 61.3, ["Neon"] = 11.64, ["Neon|Fly"] = 141.67, ["Neon|Ride"] = 30.65, ["Neon|Fly|Ride"] = 452.29, ["Mega"] = 126.82, ["Mega|Ride"] = 296.51, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 65.85, ["Neon"] = 15.75, ["Neon|Fly"] = 63.76, ["Mega"] = 112.23}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.08, ["Fly|Ride"] = 98.44, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 34.13, ["Mega|Fly"] = 156.41, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 170.24}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 35.89, ["Fly"] = 21.11, ["Ride"] = 16.94, ["Fly|Ride"] = 40.69, ["Neon"] = 128.93, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 845.39, ["Mega|Ride"] = 472.16, ["Mega|Fly|Ride"] = 426.8}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 761.25, ["Fly"] = 903.52, ["Ride"] = 840, ["Fly|Ride"] = 787.5, ["Neon"] = 1938.57, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 1998.94, ["Mega|Ride"] = 5643.75, ["Mega|Fly|Ride"] = 5664.58}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 12.7, ["Fly|Ride"] = 41.88, ["Neon"] = 2.1, ["Neon|Fly"] = 70.94, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 45.85, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.13}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.25, ["Ride"] = 27.57, ["Fly|Ride"] = 92.18, ["Neon"] = 46.25, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 248.11, ["Mega"] = 282.17, ["Mega|Ride"] = 351.75}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 57.74, ["Fly"] = 105.69, ["Ride"] = 86.63, ["Fly|Ride"] = 134.61, ["Neon"] = 394.34, ["Neon|Ride"] = 380.43, ["Neon|Fly|Ride"] = 1240.32, ["Mega"] = 1367.42, ["Mega|Ride"] = 1550.24, ["Mega|Fly|Ride"] = 1348.75}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 42.42, ["Ride"] = 49.69, ["Fly|Ride"] = 84.56, ["Neon"] = 320.25, ["Neon|Ride"] = 183.89, ["Neon|Fly|Ride"] = 239.89, ["Mega"] = 919.36, ["Mega|Ride"] = 718.59, ["Mega|Fly|Ride"] = 1017.64}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.25, ["Ride"] = 30.19, ["Fly|Ride"] = 141.62, ["Neon"] = 58.59, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 401.58, ["Mega"] = 295.89, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 34.12, ["Ride"] = 99.36, ["Neon"] = 72.19, ["Neon|Fly"] = 348.27, ["Neon|Ride"] = 362.44, ["Mega"] = 315.98, ["Mega|Ride"] = 340.74, ["Mega|Fly|Ride"] = 408.97}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 26.06, ["Fly"] = 113.08, ["Ride"] = 82.45, ["Neon"] = 110.99, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 525, ["Mega"] = 656.25, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 843.29}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 15.7}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.4, ["Fly"] = 75.57, ["Ride"] = 32.16, ["Fly|Ride"] = 104.63, ["Neon"] = 32.82, ["Neon|Ride"] = 79.11, ["Neon|Fly|Ride"] = 177.55, ["Mega"] = 251.52, ["Mega|Fly"] = 236.09, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 293.78}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 6.29, ["Ride"] = 47.24, ["Neon"] = 31.2, ["Mega"] = 348.22, ["Mega|Fly|Ride"] = 951.07}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.63, ["Fly"] = 393.74, ["Ride"] = 86.61, ["Fly|Ride"] = 117.47, ["Neon"] = 273.72, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 337.97, ["Mega|Ride"] = 878.07, ["Mega|Fly|Ride"] = 824.01}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.89, ["Fly"] = 20.11, ["Ride"] = 16.93, ["Fly|Ride"] = 43.32, ["Neon"] = 19.69, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 77.12, ["Mega"] = 262.5, ["Mega|Fly"] = 422.7, ["Mega|Ride"] = 274.18, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.92, ["Fly"] = 84.56, ["Ride"] = 31.29, ["Fly|Ride"] = 72.19, ["Neon"] = 20.41, ["Neon|Fly"] = 63.76, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 126.83, ["Mega"] = 140.1, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 252.45}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 201.89, ["Mega"] = 34.13, ["Mega|Ride"] = 79.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 37.79, ["Fly"] = 84.56, ["Ride"] = 61.04, ["Fly|Ride"] = 78.72, ["Neon"] = 211.36, ["Neon|Ride"] = 239.89, ["Neon|Fly|Ride"] = 394.26, ["Mega"] = 1127.55, ["Mega|Ride"] = 792.57, ["Mega|Fly|Ride"] = 850.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 23.78, ["Fly|Ride"] = 84.56, ["Neon"] = 10.59, ["Neon|Fly"] = 174.57, ["Neon|Ride"] = 70.82, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 141.62, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 11.65, ["Ride"] = 44.4, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 352.96, ["Mega"] = 288.75, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 18.87, ["Ride"] = 16.93, ["Fly|Ride"] = 28.88, ["Neon"] = 15.86, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 78.21, ["Mega"] = 197.63, ["Mega|Ride"] = 232.98, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.09, ["Fly"] = 52.5, ["Ride"] = 24.31, ["Fly|Ride"] = 52.5, ["Neon"] = 67.65, ["Neon|Ride"] = 177.19, ["Mega"] = 276.88, ["Mega|Ride"] = 247.29, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 139.5, ["Neon"] = 28.33, ["Neon|Ride"] = 110.99, ["Mega"] = 91.88, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.38, ["Ride"] = 91.88, ["Neon"] = 196.88, ["Neon|Ride"] = 293.78, ["Mega"] = 1055.7, ["Mega|Ride"] = 1409.69, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 19.95, ["Ride"] = 281.6, ["Neon"] = 210, ["Neon|Ride"] = 183.89, ["Mega"] = 511.47, ["Mega|Fly|Ride"] = 570.29}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.87, ["Fly"] = 38.06, ["Ride"] = 105, ["Neon"] = 99.36, ["Neon|Ride"] = 393.75, ["Mega"] = 591.78, ["Mega|Ride"] = 556.9, ["Mega|Fly|Ride"] = 1690.78}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.76, ["Ride"] = 76.1, ["Fly|Ride"] = 422.03, ["Neon"] = 141.62, ["Neon|Ride"] = 634.06, ["Mega"] = 790.46, ["Mega|Ride"] = 845.39, ["Mega|Fly|Ride"] = 960.83}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.2, ["Neon"] = 42.56, ["Neon|Ride"] = 422.7, ["Mega"] = 239.89, ["Mega|Fly|Ride"] = 315.16}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 15.86, ["Fly|Ride"] = 41.91, ["Neon"] = 6.03, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 45.94, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 186.8}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.83, ["Ride"] = 42.29, ["Fly|Ride"] = 91.95, ["Neon"] = 28.54, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 210.71, ["Mega|Ride"] = 188.36, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 17.05, ["Fly|Ride"] = 55.13, ["Neon"] = 6.28, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 44.45, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 154.37}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 63.76, ["Fly|Ride"] = 99.36, ["Neon"] = 39.31, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 113.08, ["Mega"] = 224.03, ["Mega|Ride"] = 156.29, ["Mega|Fly|Ride"] = 472.16}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.86, ["Ride"] = 32.81, ["Fly|Ride"] = 103.69, ["Neon"] = 42.29, ["Neon|Ride"] = 96.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 236.09, ["Mega|Ride"] = 416.8, ["Mega|Fly|Ride"] = 944.3}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.13, ["Fly"] = 21.15, ["Ride"] = 28.35, ["Fly|Ride"] = 57.07, ["Neon"] = 32.82, ["Neon|Fly"] = 104.77, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 99.85, ["Mega"] = 219.45, ["Mega|Ride"] = 251.99, ["Mega|Fly|Ride"] = 371.97}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 20.09, ["Fly|Ride"] = 63.41, ["Neon"] = 19.93, ["Neon|Fly"] = 84.56, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 79.11, ["Mega"] = 141.62, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 315.16}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.72, ["Fly"] = 26.25, ["Ride"] = 47.25, ["Fly|Ride"] = 179.82, ["Neon"] = 22.09, ["Neon|Fly"] = 436.94, ["Neon|Ride"] = 99.36, ["Neon|Fly|Ride"] = 141.85, ["Mega"] = 103.69, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 311.16}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.07, ["Fly"] = 105, ["Ride"] = 84.73, ["Fly|Ride"] = 273, ["Neon"] = 78.75, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 486.11, ["Mega"] = 367.5, ["Mega|Ride"] = 440.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.49, ["Fly"] = 220.79, ["Ride"] = 97.23, ["Fly|Ride"] = 158.22, ["Neon"] = 259.88, ["Neon|Ride"] = 297.21, ["Neon|Fly|Ride"] = 373.27, ["Mega"] = 1050, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 977.65}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 25.38, ["Fly|Ride"] = 65.54, ["Neon"] = 4.25, ["Neon|Ride"] = 37.95, ["Neon|Fly|Ride"] = 58.35, ["Mega"] = 27.19, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 114.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 15.61, ["Neon"] = 281.59, ["Mega"] = 422.7, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1268.09}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 56.35, ["Fly"] = 105, ["Ride"] = 116.82, ["Neon"] = 276.94, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 417.42, ["Mega|Ride"] = 1973.98, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 30.19, ["Fly"] = 190.32, ["Ride"] = 42.51, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 77.44, ["Mega"] = 214.86, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 23.26, ["Ride"] = 19.69, ["Fly|Ride"] = 80.33, ["Neon"] = 6.57, ["Neon|Fly"] = 40.2, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 70.82, ["Mega"] = 31.88, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 155.1}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.93, ["Fly|Ride"] = 49.23, ["Neon"] = 14.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 156.41, ["Mega|Fly"] = 352.96, ["Mega|Ride"] = 198.68, ["Mega|Fly|Ride"] = 245.67}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 15.83, ["Fly|Ride"] = 32.76, ["Neon"] = 2.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 59.19, ["Mega"] = 34.13, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 155.93}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 25.99, ["Fly|Ride"] = 93.19, ["Neon"] = 4.59, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 37.85, ["Mega|Fly"] = 168, ["Mega|Ride"] = 63.76, ["Mega|Fly|Ride"] = 184.26}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 126.27, ["Mega"] = 19.56, ["Mega|Ride"] = 105.89, ["Mega|Fly|Ride"] = 257.86}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10.58, ["Ride"] = 31.4, ["Fly|Ride"] = 262.5, ["Neon"] = 40.15, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 209.25, ["Mega"] = 201.86, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 11.64, ["Ride"] = 32.76, ["Neon"] = 124.68, ["Neon|Ride"] = 61.71, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 315, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.97, ["Fly"] = 23.67, ["Ride"] = 20.73, ["Fly|Ride"] = 47.34, ["Neon"] = 47.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 35.95, ["Neon|Fly|Ride"] = 70.88, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 96.83, ["Ride"] = 144.37, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 997.5, ["Mega"] = 3148.02, ["Mega|Fly|Ride"] = 1554.46}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 25.83, ["Fly"] = 72.43, ["Ride"] = 42.29, ["Fly|Ride"] = 59.07, ["Neon"] = 57.75, ["Mega"] = 630.66, ["Mega|Ride"] = 617.54, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 15.67, ["Fly|Ride"] = 36.72, ["Neon"] = 3.15, ["Neon|Fly"] = 28.54, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 41.18, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 16.93, ["Fly|Ride"] = 28.54, ["Neon"] = 4.11, ["Neon|Fly"] = 23.5, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 40.16, ["Mega"] = 47.25, ["Mega|Ride"] = 54.96, ["Mega|Fly|Ride"] = 96.85}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 397.68, ["Ride"] = 430.01, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 1751.96, ["Neon|Fly|Ride"] = 1509.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.21, ["Ride"] = 196.56, ["Fly|Ride"] = 118.13, ["Neon"] = 79.11, ["Mega"] = 564.31, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1267.03}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.86, ["Ride"] = 15.86, ["Fly|Ride"] = 39.38, ["Neon"] = 4.25, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 39.19, ["Mega"] = 43.32, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 102.27}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 74.8, ["Ride"] = 129.68, ["Fly|Ride"] = 315, ["Neon"] = 242.82, ["Neon|Ride"] = 303.14, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 737.63, ["Mega|Ride"] = 661.02, ["Mega|Fly|Ride"] = 903.52}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 18.85, ["Fly|Ride"] = 46.51, ["Neon"] = 10.59, ["Neon|Fly"] = 91.95, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 75.7, ["Mega|Fly"] = 160.13, ["Mega|Ride"] = 108.57, ["Mega|Fly|Ride"] = 203.84}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.82, ["Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 283.29, ["Mega"] = 23.67, ["Mega|Fly"] = 126.82, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 224.03}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 63, ["Fly"] = 141.62, ["Ride"] = 72.19, ["Fly|Ride"] = 282.17, ["Neon"] = 174.56, ["Neon|Ride"] = 250.76, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1270.69, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 812.43}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 20.09, ["Fly|Ride"] = 39.38, ["Neon"] = 5.24, ["Neon|Ride"] = 54.96, ["Mega"] = 103.79, ["Mega|Ride"] = 121.73, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.75, ["Fly"] = 158.22, ["Ride"] = 53.45, ["Neon"] = 266.32, ["Neon|Ride"] = 196.56, ["Neon|Fly|Ride"] = 422.7, ["Mega|Ride"] = 1690.78, ["Mega|Fly|Ride"] = 1054.62}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 6.57, ["Fly|Ride"] = 211.36, ["Neon"] = 41.91, ["Neon|Ride"] = 203.44, ["Mega"] = 175.88, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 551.92}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.61, ["Fly"] = 70.82, ["Ride"] = 70.82, ["Fly|Ride"] = 65.63, ["Neon"] = 7.88, ["Neon|Fly"] = 78.22, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 108.63, ["Mega"] = 78.75, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 31.48, ["Ride"] = 82.45, ["Fly|Ride"] = 104.81, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 2040.94, ["Mega|Fly|Ride"] = 1110.38}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 144.82, ["Ride"] = 41.24, ["Fly|Ride"] = 908.98, ["Neon"] = 3.89, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 45.94, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 115.68, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 57.07, ["Ride"] = 28.53, ["Fly|Ride"] = 102.85, ["Neon"] = 5.92, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 84.56, ["Mega"] = 105.69, ["Mega|Ride"] = 156.41, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.59, ["Ride"] = 50.74, ["Fly|Ride"] = 188.92, ["Neon"] = 77.18, ["Neon|Ride"] = 120.75, ["Mega"] = 311.07, ["Mega|Ride"] = 472.16, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 28.87, ["Fly"] = 141.62, ["Ride"] = 78.73, ["Fly|Ride"] = 141.62, ["Neon"] = 154.61, ["Neon|Fly"] = 274.77, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 352.85, ["Mega"] = 656.24, ["Mega|Ride"] = 643.61, ["Mega|Fly|Ride"] = 724.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 27.57, ["Fly"] = 28.88, ["Ride"] = 35.38, ["Fly|Ride"] = 77.44, ["Neon"] = 103.69, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 620.57, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 340.74}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 80.05, ["Fly"] = 96.83, ["Ride"] = 137.82, ["Fly|Ride"] = 196.85, ["Neon"] = 273, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 569.79, ["Mega"] = 1416.44, ["Mega|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.14, ["Ride"] = 35.44, ["Fly|Ride"] = 288.75, ["Neon"] = 18.26, ["Neon|Ride"] = 58.8, ["Neon|Fly|Ride"] = 305.76, ["Mega"] = 125.77, ["Mega|Ride"] = 169.1, ["Mega|Fly|Ride"] = 330.1}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 7.01, ["Ride"] = 23.26, ["Fly|Ride"] = 105, ["Neon"] = 23.63, ["Neon|Ride"] = 49.88, ["Mega"] = 203.44, ["Mega|Ride"] = 211.36}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 11.81, ["Fly"] = 28.88, ["Ride"] = 44.01, ["Fly|Ride"] = 157.5, ["Neon"] = 124.71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 295.89, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.74, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 17.05, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 15.7, ["Mega|Fly"] = 70.82, ["Mega|Ride"] = 23.51, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.25, ["Fly"] = 78.22, ["Ride"] = 141.62, ["Fly|Ride"] = 303.01, ["Neon"] = 231.9, ["Neon|Fly"] = 2395.62, ["Neon|Ride"] = 293.99, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 930.99, ["Mega|Ride"] = 807.19, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 16.96, ["Fly|Ride"] = 109.92, ["Neon"] = 5.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 42.51, ["Mega|Fly|Ride"] = 211.77}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 16.96, ["Fly|Ride"] = 63.41, ["Neon"] = 15.44, ["Neon|Fly"] = 141.62, ["Neon|Ride"] = 32.44, ["Neon|Fly|Ride"] = 84.73, ["Mega"] = 157.5, ["Mega|Ride"] = 395.24, ["Mega|Fly|Ride"] = 282.35}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 76.64, ["Ride"] = 116.81, ["Fly|Ride"] = 320.31, ["Neon"] = 310.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 511.88, ["Mega"] = 1019.82, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1009.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 42.29, ["Neon"] = 4.67, ["Neon|Ride"] = 42.75, ["Mega"] = 47.28, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 274.77}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 13.77}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Fly|Ride"] = 321.9, ["Neon"] = 8.48, ["Neon|Ride"] = 63.41, ["Neon|Fly|Ride"] = 164.87, ["Mega"] = 42, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 176.49}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 118.13, ["Ride"] = 181.36, ["Fly|Ride"] = 236.25, ["Neon"] = 538.13, ["Neon|Ride"] = 655.18, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2676.41}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 25.5, ["Neon"] = 69.76, ["Neon|Ride"] = 61.69, ["Mega"] = 165.37, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 452.29}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 4.6, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.17, ["Ride"] = 30.72, ["Neon"] = 51.1, ["Neon|Ride"] = 113.08, ["Neon|Fly|Ride"] = 156.41, ["Mega"] = 420.59, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 26.25, ["Ride"] = 20.08, ["Fly|Ride"] = 42.29, ["Neon"] = 79.75, ["Neon|Ride"] = 90.9, ["Neon|Fly|Ride"] = 146.41, ["Mega"] = 459.38, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 43.29, ["Neon"] = 170.62, ["Neon|Ride"] = 269.48, ["Neon|Fly|Ride"] = 479.77, ["Mega"] = 700.63, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 141.8, ["Fly"] = 144.38, ["Ride"] = 183.89, ["Fly|Ride"] = 210, ["Neon"] = 538.12, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.58, ["Fly"] = 19.66, ["Ride"] = 20.09, ["Fly|Ride"] = 39.38, ["Neon"] = 39.38, ["Neon|Fly"] = 422.7, ["Neon|Ride"] = 53.97, ["Neon|Fly|Ride"] = 94.39, ["Mega|Ride"] = 299.04, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 3.84, ["Fly"] = 131.23, ["Ride"] = 18.9, ["Fly|Ride"] = 131.25, ["Neon"] = 27.17, ["Neon|Ride"] = 78.22, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 137.82, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.87, ["Fly"] = 210, ["Ride"] = 42, ["Neon"] = 104.63, ["Neon|Ride"] = 137.39, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 648.85}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Fly"] = 113.08, ["Ride"] = 74.82, ["Neon"] = 223.13, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 941.56, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.62, ["Ride"] = 81.85, ["Neon"] = 120.48, ["Neon|Ride"] = 126.62, ["Mega"] = 643.13, ["Mega|Ride"] = 739.72, ["Mega|Fly|Ride"] = 986.99}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.87, ["Ride"] = 391.01, ["Neon"] = 2395.62, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1013.41, ["Mega|Fly|Ride"] = 4226.93}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 39.38, ["Fly"] = 65.63, ["Ride"] = 34.64, ["Fly|Ride"] = 63.41, ["Neon"] = 197.63, ["Neon|Ride"] = 215.58, ["Neon|Fly|Ride"] = 326.16, ["Mega"] = 984.38, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 855.14}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 15.75, ["Fly|Ride"] = 28.53, ["Neon"] = 2.1, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 55.04, ["Mega"] = 22.14, ["Mega|Fly"] = 107.81, ["Mega|Ride"] = 44.46, ["Mega|Fly|Ride"] = 103.86}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 211.02, ["Neon"] = 21.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.97, ["Mega"] = 141.62, ["Mega|Fly"] = 124.69, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 373.42}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 6.07, ["Ride"] = 28.6, ["Fly|Ride"] = 129.94, ["Neon"] = 17.07, ["Neon|Fly"] = 95.12, ["Neon|Ride"] = 78.26, ["Neon|Fly|Ride"] = 169.1, ["Mega"] = 119.43, ["Mega|Fly"] = 253.63, ["Mega|Ride"] = 282.17, ["Mega|Fly|Ride"] = 236.09}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 354.38, ["Fly"] = 630.47, ["Ride"] = 393.74, ["Fly|Ride"] = 511.1, ["Neon"] = 1550.24, ["Neon|Ride"] = 1605.56, ["Neon|Fly|Ride"] = 1406.52, ["Mega|Fly|Ride"] = 4814.45}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.56, ["Fly"] = 47.59, ["Ride"] = 19.47, ["Fly|Ride"] = 35.95, ["Neon"] = 24.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.75, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.98, ["Fly"] = 31.71, ["Ride"] = 17.73, ["Fly|Ride"] = 39.38, ["Neon"] = 27.49, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 67.65, ["Mega"] = 422.7, ["Mega|Ride"] = 704.85, ["Mega|Fly|Ride"] = 226.15}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 7.74, ["Fly"] = 35.95, ["Ride"] = 27.49, ["Fly|Ride"] = 65.63, ["Neon"] = 17.73, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 119.26, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.93, ["Fly"] = 210, ["Ride"] = 63.41, ["Fly|Ride"] = 61.69, ["Neon"] = 118.13, ["Neon|Fly"] = 145.84, ["Neon|Ride"] = 183.89, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 951.07, ["Mega|Ride"] = 843.28, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.35, ["Ride"] = 28.5, ["Fly|Ride"] = 52.9, ["Neon"] = 19.04, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 137.82, ["Mega|Ride"] = 183.89, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.77, ["Fly"] = 104.15, ["Ride"] = 24.12, ["Fly|Ride"] = 91.88, ["Neon"] = 153.04, ["Neon|Ride"] = 105.69, ["Mega|Ride"] = 599.82, ["Mega|Fly|Ride"] = 730.21}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 40.69, ["Neon"] = 3.65, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.51, ["Mega"] = 36.75, ["Mega|Ride"] = 121.7, ["Mega|Fly|Ride"] = 315.16}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.59, ["Ride"] = 57.07, ["Neon"] = 59.07, ["Mega"] = 314.92, ["Mega|Fly|Ride"] = 845.39}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 15.73, ["Ride"] = 70.96, ["Fly|Ride"] = 190.22, ["Neon"] = 81.33, ["Mega"] = 311.75, ["Mega|Ride"] = 557.97, ["Mega|Fly|Ride"] = 496.68}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 6.51, ["Fly"] = 33.84, ["Ride"] = 20.98, ["Fly|Ride"] = 49.96, ["Neon"] = 28.88, ["Neon|Fly"] = 118.07, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 98.18, ["Mega"] = 408.97, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 368.55}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 184.58, ["Fly"] = 205.24, ["Ride"] = 209.25, ["Fly|Ride"] = 226.15, ["Neon"] = 862.31, ["Neon|Ride"] = 869.7, ["Neon|Fly|Ride"] = 880.78, ["Mega|Fly|Ride"] = 4199.45}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Fly"] = 27.49, ["Ride"] = 12.7, ["Fly|Ride"] = 63.76, ["Neon"] = 12.39, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.85, ["Mega"] = 220.5, ["Mega|Ride"] = 164.87, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.91, ["Fly"] = 42.29, ["Ride"] = 31.71, ["Fly|Ride"] = 103.78, ["Neon"] = 20.97, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 232.36, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 44.1, ["Fly"] = 126, ["Ride"] = 63.41, ["Fly|Ride"] = 367.5, ["Neon"] = 152.81, ["Neon|Ride"] = 204.67, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 408.19, ["Mega|Ride"] = 464.97, ["Mega|Fly|Ride"] = 524.48}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 83.86, ["Fly"] = 105.69, ["Ride"] = 105.69, ["Fly|Ride"] = 261.18, ["Neon"] = 523.09, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 535.78, ["Mega"] = 1690.78, ["Mega|Ride"] = 1388.55, ["Mega|Fly|Ride"] = 1553.43}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 28.86, ["Ride"] = 100.41, ["Fly|Ride"] = 196, ["Neon"] = 94.5, ["Neon|Ride"] = 149.56, ["Neon|Fly|Ride"] = 277.33, ["Mega"] = 252, ["Mega|Ride"] = 321.44, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.22, ["Fly|Ride"] = 46.5, ["Neon"] = 15.86, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 57.46, ["Mega|Ride"] = 183.89, ["Mega|Fly|Ride"] = 352.96}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 14.44, ["Ride"] = 42.29, ["Fly|Ride"] = 9158.67, ["Neon"] = 84.76, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 209.48, ["Mega|Ride"] = 278.27, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 73.48, ["Ride"] = 119.52, ["Fly|Ride"] = 169.1, ["Neon"] = 183.75, ["Neon|Ride"] = 262.53, ["Neon|Fly|Ride"] = 472.23, ["Mega"] = 433.12, ["Mega|Ride"] = 539.49, ["Mega|Fly|Ride"] = 523.68}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 57.75, ["Neon"] = 7.8, ["Neon|Fly"] = 28.54, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 49.88, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 421.64}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.63, ["Ride"] = 47.24, ["Neon"] = 46.51, ["Neon|Ride"] = 630.44, ["Mega"] = 373.87, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 977.8, ["Fly"] = 1246.7, ["Ride"] = 1175.51, ["Fly|Ride"] = 1185.06, ["Neon"] = 3275.87, ["Neon|Ride"] = 3937.15, ["Neon|Fly|Ride"] = 3096.97, ["Mega|Fly|Ride"] = 11090.63}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 40.16, ["Ride"] = 103.69, ["Fly|Ride"] = 236.25, ["Neon"] = 211.36, ["Neon|Ride"] = 531.57, ["Mega"] = 562.2, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 6.25, ["Fly"] = 49.12, ["Ride"] = 31.68, ["Fly|Ride"] = 114.14, ["Neon"] = 15.74, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 78.72, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 290.62}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.42, ["Ride"] = 131.22, ["Neon"] = 106.32, ["Neon|Ride"] = 156.41, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 22.44, ["Fly|Ride"] = 422.7, ["Neon"] = 2.6, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 95.12, ["Mega"] = 19.69, ["Mega|Fly"] = 125.77, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.63, ["Ride"] = 422.7, ["Fly|Ride"] = 317.04, ["Neon"] = 305.01, ["Neon|Ride"] = 282.17, ["Mega"] = 1136.41, ["Mega|Ride"] = 1005.96, ["Mega|Fly|Ride"] = 1049.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.86, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 84.56, ["Neon"] = 35.25, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 352.96, ["Mega|Ride"] = 294.79, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 4.9, ["Fly"] = 65.63, ["Ride"] = 21, ["Neon"] = 9.19, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 158.18, ["Mega|Ride"] = 231.44, ["Mega|Fly|Ride"] = 374.09}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 61.57, ["Ride"] = 96.13, ["Fly|Ride"] = 166.99, ["Neon"] = 170.63, ["Neon|Fly"] = 280.65, ["Neon|Ride"] = 235.12, ["Neon|Fly|Ride"] = 634.06, ["Mega"] = 535.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 730.21}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 15.75, ["Ride"] = 57.07, ["Fly|Ride"] = 196.88, ["Neon"] = 98.44, ["Neon|Ride"] = 211.36, ["Neon|Fly|Ride"] = 315, ["Mega"] = 616.88, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1090.46}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 49.23, ["Ride"] = 99.36, ["Neon"] = 774.38, ["Neon|Ride"] = 564.31, ["Neon|Fly|Ride"] = 952.23, ["Mega"] = 2466.41, ["Mega|Ride"] = 1832.38, ["Mega|Fly|Ride"] = 2117.57}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 7.41, ["Ride"] = 63.76, ["Neon"] = 24.36, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 91.88, ["Mega|Ride"] = 135.09, ["Mega|Fly|Ride"] = 311.63}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.86, ["Fly"] = 33.84, ["Ride"] = 28.54, ["Fly|Ride"] = 57.07, ["Neon"] = 58.57, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 141.9, ["Mega"] = 399, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 471.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 140.39, ["Ride"] = 205.44, ["Fly|Ride"] = 236.25, ["Neon"] = 498.75, ["Neon|Fly"] = 634.06, ["Neon|Ride"] = 555.52, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly"] = 2818.3, ["Mega|Ride"] = 2113.48, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 16.93, ["Ride"] = 15.74, ["Fly|Ride"] = 41.92, ["Neon"] = 12.34, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 77.35, ["Mega"] = 140.44, ["Mega|Ride"] = 153.46, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 3.93, ["Fly"] = 35.95, ["Ride"] = 23.62, ["Fly|Ride"] = 42.29, ["Neon"] = 35.44, ["Neon|Fly"] = 281.17, ["Neon|Ride"] = 51.17, ["Neon|Fly|Ride"] = 125.77, ["Mega"] = 220.5, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 288.98}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 15.96, ["Fly|Ride"] = 35.95, ["Neon"] = 2.63, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 15.68, ["Mega|Ride"] = 31.77, ["Mega|Fly|Ride"] = 92.08}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 31.71, ["Neon"] = 3.93, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 40.17, ["Mega"] = 19.48, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 141.62}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.63, ["Fly"] = 131.25, ["Ride"] = 27.49, ["Fly|Ride"] = 45.94, ["Neon"] = 22.32, ["Neon|Ride"] = 47.23, ["Mega"] = 134.23, ["Mega|Ride"] = 152.3, ["Mega|Fly|Ride"] = 315.16}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 57.11, ["Ride"] = 84, ["Neon"] = 253.63, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 564.31, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 662.59}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.15, ["Fly"] = 18.69, ["Ride"] = 17.07, ["Fly|Ride"] = 38.07, ["Neon"] = 9.18, ["Neon|Fly"] = 28.6, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 63.67, ["Mega"] = 91.59, ["Mega|Fly"] = 164.06, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.92, ["Fly"] = 26.24, ["Ride"] = 22.32, ["Fly|Ride"] = 42.29, ["Neon"] = 10.5, ["Neon|Fly"] = 28.54, ["Neon|Ride"] = 29.79, ["Neon|Fly|Ride"] = 78.59, ["Mega"] = 129.06, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 211.42}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.81, ["Fly"] = 19.69, ["Ride"] = 18.21, ["Fly|Ride"] = 98.44, ["Neon"] = 8.49, ["Neon|Fly"] = 47.23, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 41.24, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 93.01}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.17, ["Fly"] = 281.1, ["Ride"] = 24.34, ["Neon"] = 23.63, ["Neon|Ride"] = 84.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 299.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 275.31, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.87, ["Fly"] = 154.29, ["Ride"] = 65.98, ["Neon"] = 99.75, ["Neon|Ride"] = 91.95, ["Mega"] = 317.04, ["Mega|Ride"] = 564.31, ["Mega|Fly|Ride"] = 317.04}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.94, ["Fly"] = 35.44, ["Ride"] = 20.14, ["Fly|Ride"] = 47.25, ["Neon"] = 28.3, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 69.81, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 141.62, ["Mega|Ride"] = 239.89, ["Mega|Fly|Ride"] = 352.96}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.91, ["Ride"] = 16.93, ["Fly|Ride"] = 52.5, ["Neon"] = 15.86, ["Neon|Fly"] = 37, ["Neon|Ride"] = 48.62, ["Neon|Fly|Ride"] = 67.76, ["Mega"] = 174.71, ["Mega|Ride"] = 234.9, ["Mega|Fly|Ride"] = 224.49}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 185.07, ["Fly"] = 393.75, ["Ride"] = 223.1, ["Fly|Ride"] = 305.82, ["Neon"] = 984.38, ["Neon|Ride"] = 916.2, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3524.19, ["Mega|Fly|Ride"] = 3236.78}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.67, ["Ride"] = 30.72, ["Neon"] = 30.85, ["Neon|Fly|Ride"] = 282.17, ["Mega"] = 123.38, ["Mega|Ride"] = 239.89, ["Mega|Fly|Ride"] = 493.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.35, ["Ride"] = 20.11, ["Fly|Ride"] = 118.13, ["Neon"] = 27.54, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 36.06, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 203.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 1180.37}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 8.48, ["Fly|Ride"] = 158.22, ["Neon"] = 45.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 158.18, ["Mega"] = 470.98, ["Mega|Ride"] = 866.4, ["Mega|Fly|Ride"] = 1033.6}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.86, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 21.15, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 28.54, ["Mega|Fly"] = 70.82, ["Mega|Ride"] = 37, ["Mega|Fly|Ride"] = 67.65}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.25, ["Fly"] = 56.37, ["Ride"] = 24.31, ["Fly|Ride"] = 56.44, ["Neon"] = 16.69, ["Neon|Fly"] = 42.29, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 83.5, ["Mega"] = 141.39, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 274.77}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 5.66, ["Ride"] = 54.96, ["Fly|Ride"] = 77.44, ["Neon"] = 16.53, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 68.25, ["Mega|Ride"] = 158.18, ["Mega|Fly|Ride"] = 205.02}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 102.74, ["Ride"] = 105, ["Fly|Ride"] = 147.49, ["Neon"] = 564.31, ["Neon|Ride"] = 401.58, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 3524.19, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.46, ["Fly"] = 99.36, ["Ride"] = 33.84, ["Fly|Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Ride"] = 57.07, ["Mega"] = 215.58, ["Mega|Ride"] = 209.65, ["Mega|Fly|Ride"] = 669.98}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.71, ["Ride"] = 52.5, ["Fly|Ride"] = 164.87, ["Neon"] = 10.5, ["Neon|Ride"] = 57.07, ["Neon|Fly|Ride"] = 169.1, ["Mega"] = 76.1, ["Mega|Fly"] = 412.14, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 239.89}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 58.53, ["Fly"] = 126.34, ["Ride"] = 97.13, ["Fly|Ride"] = 209.99, ["Neon"] = 141.75, ["Neon|Ride"] = 156.41, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 557.97, ["Mega|Ride"] = 760.86, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 11.82, ["Fly|Ride"] = 37.07, ["Neon"] = 2.1, ["Neon|Fly"] = 38.06, ["Neon|Ride"] = 14.48, ["Neon|Fly|Ride"] = 32.76, ["Mega"] = 23.92, ["Mega|Fly"] = 42.29, ["Mega|Ride"] = 38.27, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 71.1, ["Mega"] = 31.71, ["Mega|Fly"] = 126.82, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 179.78}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 11.46, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 70.82, ["Mega|Ride"] = 141.04, ["Mega|Fly|Ride"] = 303.3}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 57.2, ["Ride"] = 52.5, ["Fly|Ride"] = 87.28, ["Neon"] = 26.17, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 71.87, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 110.25, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 164.49, ["Mega|Fly|Ride"] = 288.46}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.05, ["Fly|Ride"] = 36.62, ["Neon"] = 2.1, ["Neon|Fly"] = 28.35, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 19.02, ["Mega|Ride"] = 44.4, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 11.8, ["Ride"] = 42.29, ["Fly|Ride"] = 200.72, ["Neon"] = 70.88, ["Neon|Ride"] = 166.99, ["Neon|Fly|Ride"] = 196.23, ["Mega"] = 294.84, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 393.12}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2493.75, ["Fly"] = 3012.75, ["Ride"] = 2737.49, ["Fly|Ride"] = 2493.75, ["Neon|Fly"] = 9509.5, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 42269.08}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 20.9, ["Fly|Ride"] = 45.94, ["Neon"] = 6.57, ["Neon|Fly"] = 69.12, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 73.48, ["Mega|Fly"] = 141.62, ["Mega|Ride"] = 93.49, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 5.25, ["Fly|Ride"] = 74.82, ["Neon"] = 13.13, ["Mega"] = 99.36, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 634.06}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 23.6, ["Ride"] = 31.97, ["Fly|Ride"] = 157.5, ["Neon"] = 80.61, ["Neon|Ride"] = 279.57, ["Neon|Fly|Ride"] = 262.59, ["Mega"] = 472.16, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 38.06, ["Ride"] = 78.75, ["Neon"] = 161.43, ["Neon|Ride"] = 388.89, ["Neon|Fly|Ride"] = 422.7, ["Mega"] = 540.75, ["Mega|Ride"] = 730.66, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 144.3, ["Fly"] = 282.17, ["Ride"] = 221.92, ["Fly|Ride"] = 203.44, ["Neon"] = 589.66, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 747.05, ["Mega"] = 6340.38, ["Mega|Ride"] = 3029.65, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.77, ["Ride"] = 52.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.48, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 223.13, ["Mega|Fly"] = 178.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.09}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 8.48, ["Neon|Fly"] = 99.36, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 527.33, ["Mega"] = 99.36, ["Mega|Ride"] = 261.03, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.91, ["Fly"] = 101.99, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 12.48, ["Neon|Ride"] = 44.63, ["Mega"] = 84, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 268.43}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.75, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 1165.81, ["Neon|Fly|Ride"] = 291.67, ["Mega"] = 504.69, ["Mega|Ride"] = 422.7, ["Mega|Fly|Ride"] = 630.32}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 70.82, ["Neon"] = 2.1, ["Neon|Ride"] = 57.75, ["Mega"] = 18.38, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 352.96}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Ride"] = 101.47, ["Fly|Ride"] = 137.82, ["Neon"] = 323.37, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 1365, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1409.69}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.25, ["Neon|Ride"] = 104.63, ["Mega"] = 47.23, ["Mega|Ride"] = 141.1}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 63, ["Ride"] = 70.82, ["Fly|Ride"] = 99.36, ["Neon"] = 295.32, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 564.33, ["Mega"] = 2625, ["Mega|Ride"] = 1268.09, ["Mega|Fly|Ride"] = 1256.07}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 33.84, ["Ride"] = 24.31, ["Fly|Ride"] = 49.69, ["Neon"] = 5.2, ["Neon|Fly"] = 121.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 42, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 123.98}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 47.6, ["Neon"] = 11.69, ["Neon|Ride"] = 118.13, ["Mega"] = 76.13, ["Mega|Ride"] = 169.1, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.82, ["Ride"] = 52.5, ["Fly|Ride"] = 210.31, ["Neon"] = 78.75, ["Neon|Fly"] = 291.38, ["Neon|Fly|Ride"] = 422.7, ["Mega"] = 204.63, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 397.69, ["Ride"] = 455.44, ["Fly|Ride"] = 513.77, ["Neon"] = 1150.11, ["Neon|Ride"] = 1307.23, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4509.07, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 3914.09}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.89, ["Fly"] = 57.07, ["Ride"] = 49.88, ["Fly|Ride"] = 64.32, ["Neon"] = 141.62, ["Neon|Fly"] = 315.21, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 209.25, ["Mega"] = 696.4, ["Mega|Fly|Ride"] = 860.2}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 27.17, ["Ride"] = 19.04, ["Fly|Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 39.38, ["Mega|Ride"] = 70.82, ["Mega|Fly|Ride"] = 448.06}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 10.47, ["Fly"] = 72.17, ["Ride"] = 36.12, ["Fly|Ride"] = 105, ["Neon"] = 47.25, ["Neon|Fly"] = 197.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 159.58, ["Mega"] = 227.07, ["Mega|Fly"] = 396.04, ["Mega|Ride"] = 273.54, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.34, ["Ride"] = 19.69, ["Fly|Ride"] = 70.82, ["Neon"] = 84, ["Neon|Ride"] = 124.71, ["Mega|Ride"] = 472.7, ["Mega|Fly|Ride"] = 349.8}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 4.25, ["Neon"] = 15.49, ["Mega"] = 52.5, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.23, ["Fly"] = 86.63, ["Ride"] = 19.08, ["Fly|Ride"] = 69.76, ["Neon"] = 19.69, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 215.58, ["Mega"] = 551.24, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 472.16}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105.69, ["Fly"] = 131.25, ["Ride"] = 105.69, ["Fly|Ride"] = 183.75, ["Neon"] = 535.78, ["Neon|Ride"] = 535.78, ["Neon|Fly|Ride"] = 633, ["Mega"] = 2512.92, ["Mega|Ride"] = 2564.69, ["Mega|Fly|Ride"] = 3007.46}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.16, ["Fly"] = 95.82, ["Ride"] = 63.76, ["Fly|Ride"] = 156.41, ["Neon"] = 192.94, ["Neon|Ride"] = 183.89, ["Mega"] = 703.8, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 689.16}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2362.5, ["Fly"] = 2349.23, ["Ride"] = 2165.63, ["Fly|Ride"] = 2315.25, ["Neon"] = 12680.74, ["Neon|Fly|Ride"] = 7608.44, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 41.89, ["Fly|Ride"] = 170.63, ["Neon"] = 11.82, ["Neon|Ride"] = 66.6, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 116.96, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 422.7}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 13.12, ["Ride"] = 156.41, ["Fly|Ride"] = 156.19, ["Neon"] = 58.99, ["Neon|Ride"] = 105.69, ["Neon|Fly|Ride"] = 169.1, ["Mega"] = 255.94, ["Mega|Ride"] = 398.98, ["Mega|Fly|Ride"] = 582.4}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 837.38, ["Fly"] = 1409.69, ["Ride"] = 918.75, ["Fly|Ride"] = 990.94, ["Neon"] = 2598.75, ["Neon|Ride"] = 2821.88, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 12188.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 49.88, ["Ride"] = 45.55, ["Fly|Ride"] = 262.5, ["Neon"] = 253.63, ["Neon|Ride"] = 291.72, ["Mega"] = 656.25, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 758.1}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.93, ["Ride"] = 23.63, ["Fly|Ride"] = 64.32, ["Neon"] = 15.65, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 133.17, ["Mega|Fly|Ride"] = 306.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.19, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Mega"] = 27.57, ["Mega|Fly"] = 52.85, ["Mega|Ride"] = 69.76, ["Mega|Fly|Ride"] = 134.23}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 99.48, ["Ride"] = 125.99, ["Fly|Ride"] = 141.62, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2675.65}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 7.35, ["Neon"] = 24.35, ["Neon|Ride"] = 141.62, ["Mega"] = 212.63}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.17, ["Ride"] = 127.09, ["Neon"] = 514.64, ["Neon|Ride"] = 452.29, ["Mega"] = 1832.38, ["Mega|Fly|Ride"] = 1747.19}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 8.44, ["Fly"] = 105, ["Fly|Ride"] = 91.88, ["Neon"] = 33.16, ["Neon|Fly|Ride"] = 315, ["Mega"] = 226.15, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 257.25, ["Ride"] = 311.75, ["Fly|Ride"] = 322.88, ["Neon"] = 950.01, ["Neon|Fly"] = 1102.63, ["Neon|Ride"] = 972.2, ["Neon|Fly|Ride"] = 896.57, ["Mega|Fly|Ride"] = 4044.11}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.03, ["Fly"] = 91.86, ["Ride"] = 15.9, ["Fly|Ride"] = 42.39, ["Neon"] = 37.07, ["Neon|Ride"] = 56.05, ["Neon|Fly|Ride"] = 104.96, ["Mega"] = 229.68, ["Mega|Ride"] = 293.78, ["Mega|Fly|Ride"] = 424.71}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.14, ["Ride"] = 15.91, ["Fly|Ride"] = 34.13, ["Neon"] = 4.24, ["Neon|Fly"] = 37, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 57.75, ["Mega|Fly"] = 104.87, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 790.13, ["Fly"] = 1180.66, ["Ride"] = 903, ["Fly|Ride"] = 1029.26, ["Neon|Ride"] = 4958.34, ["Neon|Fly|Ride"] = 4332.59, ["Mega"] = 28328.57, ["Mega|Fly|Ride"] = 28179.75}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.32, ["Fly"] = 986.99, ["Ride"] = 210, ["Neon"] = 31.82, ["Neon|Ride"] = 57.18, ["Mega"] = 160.57, ["Mega|Ride"] = 217.7, ["Mega|Fly|Ride"] = 370.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.82, ["Fly"] = 32.82, ["Ride"] = 63.41, ["Neon"] = 20.55, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 61.3, ["Neon|Fly|Ride"] = 138.37, ["Mega"] = 157.5, ["Mega|Ride"] = 183.89, ["Mega|Fly|Ride"] = 282.17}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.8, ["Fly"] = 34.13, ["Ride"] = 30.19, ["Fly|Ride"] = 49.83, ["Neon"] = 98.44, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 2113.48, ["Mega|Fly|Ride"] = 741.09}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.82, ["Fly"] = 79.27, ["Ride"] = 21, ["Fly|Ride"] = 78.75, ["Neon"] = 53.8, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 156.41, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 23.63, ["Ride"] = 210, ["Fly|Ride"] = 341.34, ["Neon"] = 90.9, ["Neon|Ride"] = 183.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 448.06, ["Mega|Ride"] = 468.15, ["Mega|Fly|Ride"] = 591.78}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Fly"] = 63.41, ["Ride"] = 116.59, ["Fly|Ride"] = 236.15, ["Neon"] = 2.1, ["Neon|Ride"] = 33.91, ["Mega"] = 19.93, ["Mega|Fly"] = 85, ["Mega|Ride"] = 141.62, ["Mega|Fly|Ride"] = 120.48}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 34.1, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Fly|Ride"] = 89.2, ["Neon"] = 150.94, ["Neon|Fly"] = 307.53, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 3381.54, ["Mega|Fly|Ride"] = 1025.25}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.93, ["Fly"] = 89.74, ["Ride"] = 19.62, ["Fly|Ride"] = 47.24, ["Neon"] = 38.06, ["Neon|Ride"] = 141.88, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 773.07, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 26.14, ["Ride"] = 19.99, ["Fly|Ride"] = 36.75, ["Neon"] = 19, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 1055.7, ["Mega|Ride"] = 282.17, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.2, ["Ride"] = 103.69, ["Neon"] = 15.86, ["Neon|Fly|Ride"] = 105.69, ["Mega"] = 295.89, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 472.16}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 22.32, ["Fly"] = 262.23, ["Ride"] = 46.82, ["Fly|Ride"] = 262.5, ["Neon"] = 116.81, ["Neon|Fly"] = 311.75, ["Neon|Ride"] = 175.03, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 656.25, ["Mega|Ride"] = 619.25, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.88, ["Ride"] = 98.44, ["Neon"] = 21.15, ["Neon|Ride"] = 73.98, ["Neon|Fly|Ride"] = 113.08, ["Mega"] = 104.87, ["Mega|Fly"] = 70.82, ["Mega|Fly|Ride"] = 315.16}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 16.42, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Mega"] = 21.15, ["Mega|Ride"] = 52.38, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 20.09, ["Fly|Ride"] = 84.56, ["Neon"] = 2.1, ["Neon|Fly"] = 393.59, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 177.55, ["Mega"] = 18.38, ["Mega|Fly"] = 73.86, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 25.89, ["Ride"] = 16.96, ["Fly|Ride"] = 49.26, ["Neon"] = 11.64, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.3, ["Neon|Fly|Ride"] = 85.01, ["Mega"] = 98.18, ["Mega|Ride"] = 158.18, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.54, ["Fly|Ride"] = 57.07, ["Neon"] = 15.86, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 148.24, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.07, ["Fly|Ride"] = 45.46, ["Neon"] = 15.15, ["Neon|Fly"] = 52.85, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 282.85, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 366.18}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 81.24, ["Ride"] = 206.08, ["Fly|Ride"] = 395.24, ["Neon"] = 210.31, ["Neon|Ride"] = 298.91, ["Neon|Fly|Ride"] = 1056.75, ["Mega"] = 787.5, ["Mega|Fly"] = 1014.48, ["Mega|Ride"] = 845.4, ["Mega|Fly|Ride"] = 1025.05}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.19, ["Ride"] = 21.15, ["Fly|Ride"] = 28.54, ["Neon"] = 3.84, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 62.36, ["Mega|Ride"] = 53.96, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.88, ["Fly"] = 62.91, ["Ride"] = 35.95, ["Fly|Ride"] = 78.22, ["Neon"] = 57.22, ["Neon|Fly"] = 76.16, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 109.19, ["Mega"] = 520.55, ["Mega|Ride"] = 250.06, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 12.99, ["Fly"] = 49.69, ["Ride"] = 28.61, ["Fly|Ride"] = 57.18, ["Neon"] = 72.07, ["Neon|Fly"] = 135.28, ["Neon|Ride"] = 79.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 413.19, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 420.59}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 9, ["Fly"] = 140.38, ["Ride"] = 47.24, ["Neon"] = 22.44, ["Neon|Ride"] = 70.82, ["Mega"] = 196.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 352.96}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.38, ["Fly|Ride"] = 42.29, ["Neon"] = 4.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 47.22, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 174.56}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.14, ["Fly"] = 78.07, ["Ride"] = 28.54, ["Fly|Ride"] = 141.39, ["Neon"] = 13.13, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 158.53, ["Mega"] = 106.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 156.72, ["Mega|Fly|Ride"] = 395.24}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 983.07, ["Ride"] = 1050, ["Fly|Ride"] = 1048.69, ["Neon"] = 2625, ["Neon|Fly"] = 2889.11, ["Neon|Ride"] = 2837.52, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7434}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.16, ["Ride"] = 106.32, ["Neon"] = 260.24, ["Neon|Ride"] = 278.99, ["Neon|Fly|Ride"] = 315.98, ["Mega"] = 1478.37, ["Mega|Ride"] = 1367.42, ["Mega|Fly|Ride"] = 1295.44}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 68.39, ["Neon"] = 5.71, ["Neon|Ride"] = 75.08, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 69.76}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 28.54, ["Ride"] = 47.24, ["Fly|Ride"] = 122.59, ["Neon"] = 169.2, ["Neon|Ride"] = 193.66, ["Neon|Fly|Ride"] = 280.88, ["Mega"] = 1023.75, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 9.98, ["Ride"] = 33.48, ["Fly|Ride"] = 156.19, ["Neon"] = 64.2, ["Neon|Ride"] = 71.87, ["Neon|Fly|Ride"] = 281.1, ["Mega"] = 472.16, ["Mega|Fly|Ride"] = 1056.75}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 257.86, ["Fly"] = 317.04, ["Ride"] = 315.19, ["Fly|Ride"] = 344.74, ["Neon"] = 984.38, ["Neon|Ride"] = 1254.35, ["Neon|Fly|Ride"] = 1111.69, ["Mega|Fly|Ride"] = 4057.85}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.37, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 19.69, ["Neon|Ride"] = 53.9, ["Mega"] = 403.69, ["Mega|Fly"] = 282.17}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Neon|Ride"] = 141.62}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 62.99, ["Ride"] = 118.13, ["Fly|Ride"] = 282.96, ["Neon"] = 213.47, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 401.63, ["Mega"] = 1103.55, ["Mega|Ride"] = 717.29, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 48.54, ["Fly|Ride"] = 141.7, ["Neon"] = 13.13, ["Mega"] = 224.03, ["Mega|Ride"] = 295.89, ["Mega|Fly|Ride"] = 211.36}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.69, ["Fly|Ride"] = 28.3, ["Neon"] = 3.81, ["Neon|Fly"] = 31.92, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 33.84, ["Mega"] = 27.46, ["Mega|Fly"] = 63.75, ["Mega|Ride"] = 40.43, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4329.94, ["Ride"] = 4331.25, ["Fly|Ride"] = 4199.99, ["Neon"] = 26348.44, ["Neon|Fly|Ride"] = 21359.63, ["Mega|Fly|Ride"] = 56359.48}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.39, ["Ride"] = 46.51, ["Neon"] = 90.57, ["Neon|Ride"] = 49.69, ["Mega"] = 418.69, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 16.93, ["Fly|Ride"] = 42.29, ["Neon"] = 14.39, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 66.6, ["Mega"] = 266.32, ["Mega|Ride"] = 137.28, ["Mega|Fly|Ride"] = 205.4}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 403.05, ["Fly"] = 493.5, ["Ride"] = 460.69, ["Fly|Ride"] = 528.13, ["Neon"] = 1312.5, ["Neon|Ride"] = 1358.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6059.28}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.45, ["Ride"] = 28.54, ["Neon"] = 17.07, ["Neon|Ride"] = 158.21, ["Mega"] = 124.69, ["Mega|Fly|Ride"] = 317.04}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 5.25, ["Fly"] = 122.05, ["Ride"] = 950.01, ["Neon"] = 94.46, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 14090.42, ["Mega"] = 380.63, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 17.97, ["Fly|Ride"] = 82.55, ["Neon"] = 3.94, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 33.9, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 47.12, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 179.66}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 629.99, ["Ride"] = 624.05, ["Fly|Ride"] = 695.63, ["Neon"] = 2493.89, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.92, ["Ride"] = 52.5, ["Fly|Ride"] = 114.91, ["Neon"] = 19.67, ["Neon|Ride"] = 99.36, ["Neon|Fly|Ride"] = 644.44, ["Mega"] = 125.99, ["Mega|Ride"] = 189.31, ["Mega|Fly|Ride"] = 305.31}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 15.75, ["Fly"] = 235.94, ["Ride"] = 65.44, ["Neon"] = 43.32, ["Neon|Ride"] = 99.53, ["Neon|Fly|Ride"] = 126.82, ["Mega"] = 225.75, ["Mega|Ride"] = 227.67, ["Mega|Fly|Ride"] = 348.89}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 28.54, ["Ride"] = 18.69, ["Fly|Ride"] = 55.51, ["Neon"] = 15.54, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 57.07, ["Mega"] = 233.56, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 32.73, ["Ride"] = 57.07, ["Neon"] = 104.63, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 126.82, ["Neon|Fly|Ride"] = 315.23, ["Mega"] = 497.73, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 528.38}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 4.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.29, ["Mega|Fly"] = 84.56, ["Mega|Ride"] = 87.26, ["Mega|Fly|Ride"] = 218.66}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 420, ["Ride"] = 466.98, ["Fly|Ride"] = 630.47, ["Neon"] = 1837.5, ["Neon|Ride"] = 2320.58, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9206.8, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.69, ["Neon"] = 4.25, ["Neon|Ride"] = 36.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 31.71, ["Mega|Ride"] = 133.44, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 21.17, ["Neon"] = 3.94, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 212.51, ["Mega"] = 40.17, ["Mega|Fly"] = 82.45, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.37, ["Neon"] = 3.81, ["Neon|Ride"] = 45.91, ["Mega"] = 34.13, ["Mega|Fly"] = 156.41, ["Mega|Ride"] = 90.9}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.76, ["Ride"] = 131.25, ["Neon"] = 25.44, ["Neon|Ride"] = 70.82, ["Mega"] = 112.16, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 52.48, ["Fly"] = 158.22, ["Ride"] = 85.31, ["Fly|Ride"] = 232.32, ["Neon"] = 211.78, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 352.96, ["Mega"] = 606.57, ["Mega|Ride"] = 482.99, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 25.68, ["Fly"] = 69.57, ["Ride"] = 64.31, ["Neon"] = 95.49, ["Neon|Ride"] = 141.62, ["Mega"] = 348.81, ["Mega|Ride"] = 452.42, ["Mega|Fly|Ride"] = 506.26}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.94, ["Fly"] = 34.65, ["Ride"] = 16.92, ["Fly|Ride"] = 42.29, ["Neon"] = 27.57, ["Neon|Fly"] = 70.82, ["Neon|Ride"] = 35.05, ["Neon|Fly|Ride"] = 76.64, ["Mega"] = 394.42, ["Mega|Ride"] = 238.04, ["Mega|Fly|Ride"] = 246.48}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.66, ["Ride"] = 64.32, ["Fly|Ride"] = 113.36, ["Neon"] = 70.82, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 233.56, ["Mega"] = 333.95, ["Mega|Ride"] = 787.32, ["Mega|Fly|Ride"] = 564.31}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 27.49, ["Fly|Ride"] = 362.25, ["Neon"] = 19.69, ["Neon|Ride"] = 70.24, ["Mega"] = 155.24, ["Mega|Ride"] = 143.73, ["Mega|Fly|Ride"] = 253.63}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.99, ["Fly"] = 69.67, ["Ride"] = 23.26, ["Fly|Ride"] = 45.94, ["Neon"] = 228.74, ["Neon|Ride"] = 162.75, ["Neon|Fly|Ride"] = 169.1, ["Mega"] = 950.01, ["Mega|Ride"] = 944.3, ["Mega|Fly|Ride"] = 704.85}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 39.26, ["Fly"] = 874.13, ["Neon|Ride"] = 472.24, ["Mega"] = 353.07, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.6, ["Fly"] = 115.5, ["Ride"] = 81.38, ["Fly|Ride"] = 110.99, ["Neon"] = 297.94, ["Neon|Fly"] = 324.43, ["Neon|Ride"] = 276.92, ["Neon|Fly|Ride"] = 374.81, ["Mega"] = 1162.41, ["Mega|Ride"] = 1156.07, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 49.88, ["Fly"] = 92.79, ["Ride"] = 77.6, ["Fly|Ride"] = 282.17, ["Neon"] = 137.39, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 496.63, ["Mega|Ride"] = 618.5, ["Mega|Fly|Ride"] = 593.85}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.89, ["Ride"] = 52.85, ["Neon"] = 108.94, ["Mega"] = 704.85, ["Mega|Ride"] = 634.06, ["Mega|Fly|Ride"] = 716.48}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 8.48, ["Fly"] = 27.18, ["Ride"] = 28.54, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Fly"] = 169.1, ["Neon|Ride"] = 84.78, ["Neon|Fly|Ride"] = 116.28, ["Mega"] = 349.11, ["Mega|Ride"] = 324.43, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 15.86, ["Fly|Ride"] = 39.38, ["Neon"] = 3.89, ["Neon|Fly"] = 24.89, ["Neon|Ride"] = 21.26, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 41.4, ["Mega|Fly"] = 704.85, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1458.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 23.82, ["Ride"] = 55.51, ["Fly|Ride"] = 131.25, ["Neon"] = 122.59, ["Neon|Fly"] = 233.56, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 285.33, ["Mega"] = 404.74, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Neon"] = 5.25, ["Neon|Ride"] = 37, ["Neon|Fly|Ride"] = 295.89, ["Mega"] = 33.13, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 541.8}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 28.61, ["Ride"] = 70.82, ["Neon"] = 171.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 324.43, ["Mega"] = 633.94, ["Mega|Ride"] = 917.25, ["Mega|Fly|Ride"] = 915.14}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 4.25, ["Neon|Ride"] = 105, ["Mega"] = 25.38, ["Mega|Fly|Ride"] = 704.85}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.25, ["Neon|Ride"] = 158.21, ["Mega"] = 23.63, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 128.99, ["Ride"] = 131.25, ["Fly|Ride"] = 249.37, ["Neon"] = 422.7, ["Neon|Fly"] = 510, ["Neon|Ride"] = 515.83, ["Neon|Fly|Ride"] = 570.94, ["Mega|Ride"] = 6491.98, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.11, ["Ride"] = 19.69, ["Fly|Ride"] = 70.86, ["Neon"] = 12.89, ["Neon|Fly"] = 63.41, ["Neon|Ride"] = 35.38, ["Neon|Fly|Ride"] = 90.9, ["Mega"] = 99.36, ["Mega|Ride"] = 133.17, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 131.25, ["Fly|Ride"] = 86.63, ["Neon"] = 6.36, ["Neon|Ride"] = 21.15, ["Neon|Fly|Ride"] = 100.41, ["Mega"] = 27.53, ["Mega|Ride"] = 101.64, ["Mega|Fly|Ride"] = 116.82}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.34, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.25, ["Mega"] = 33.45, ["Mega|Ride"] = 277.09, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.25, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 141.62, ["Mega"] = 40.69, ["Mega|Ride"] = 95.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 449.61, ["Neon"] = 283.34, ["Neon|Ride"] = 352.96, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1390.67, ["Mega|Ride"] = 1550.24, ["Mega|Fly|Ride"] = 1550.24}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 139.5, ["Neon"] = 28.33, ["Neon|Ride"] = 110.99, ["Mega"] = 91.88, ["Mega|Ride"] = 771.1}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 369.13, ["Ride"] = 367.5, ["Fly|Ride"] = 524.11, ["Neon"] = 1268.09, ["Neon|Ride"] = 1268.09, ["Neon|Fly|Ride"] = 1268.09, ["Mega|Ride"] = 3790.49, ["Mega|Fly|Ride"] = 3193}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 73.24}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 43.17}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.86}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 20.79}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 36.75}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 39.38}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.19}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 234.94}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 56.43}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.95}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 3.56}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 853.13}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.36}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.24}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 20.94}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 475.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 661.86}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 14.2}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1378.13}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 64.32}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.63}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 19.69}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 72.07}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 41.99}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 15.75}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 5.25}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 15.67}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 7.35}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.04}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 26.84}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.5}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.47}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1575}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 162.75}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.23}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.13}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.37}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 26.18}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 152.25}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.93}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 5.92}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 168}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 910}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 18.38}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.91}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 23.21}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 6.17}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.77}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 125.77}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 22.32}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.15}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.55}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 221.49}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 31.5}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 133.26}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 159.12}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.93}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 32.76}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 70.9}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 57.18}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 21839.39}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 183.73}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 65.6}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 39.37}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 54.69}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 83.54}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 94.31}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 39.37}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 31.17}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 77.44}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 341.25}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 3.93}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 7.85}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.57}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 32.12}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.6}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.41}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 6.56}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 215.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1050}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.46}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.5}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 44.63}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 380.63}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 43.26}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 92.25}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 41.82}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 57.07}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 141.62}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 18.72}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.93}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.9}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.28}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.91}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 30.19}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.13}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.19}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 153.57}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 153.82}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.74}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.95}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 3.73}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.17}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 52.45}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.71}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.63}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.77}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.64}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.75}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 102.38}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 31.91}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 8.44}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.59}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.93}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.99}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 5.97}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5670}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 12.99}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.17}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.5}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.87}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.29}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.48}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 131.25}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 19.69}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.59}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.93}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.2}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 2627.03}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 4.3}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 36.74}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.61}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 6.71}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.35}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 281.1}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.92}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.86}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 28.6}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.65}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.07}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.13}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 3.89}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 5.2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.2}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 4.74}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 32.81}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.61}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 65.37}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.19}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.63}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.21}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 89.14}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 9.48}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 14.42}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.12}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.57}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10.97}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 26.17}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.37}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 17.04}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 6.57}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 52.49}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 16.78}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.92}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 38.07}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.93}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 73.05}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 141.7}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 10.48}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 32.86}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 11.22}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 4.77}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.74}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 25.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.93}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 104.93}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 7.8}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 8.54}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.6}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 9.47}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.85}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 17.8}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 86.63}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 5.8}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.9}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.63}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 108.89}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1135.32}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.86}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.48}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 47.24}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.6}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.61}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.38}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 7.88}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.28}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.49}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 65.62}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.54}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 53.8}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 19.69}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.48}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.92}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.49}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.42}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 7.87}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 23.21}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 104.99}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.75}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 28.46}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 68.03}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 39.37}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 341.16}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 90.48}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 158.38}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.81}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 20.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 41.88}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.7}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.35}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.17}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.54}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.69}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 6.39}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 6.55}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.73}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.31}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.86}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.41}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 102.92}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.6}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 48.04}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 37.07}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1584.05}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 46.5}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 28.6}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 271.63}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 6.23}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 42.45}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 170.62}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 43.08}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.24}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 61.69}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 104.64}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 105.69}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1048.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 188.61}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.82}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 420}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.84}},
}
-- =====END_PRICES=====

-- ===== ФУНКЦИИ =====
local colors = {
    ok = Color3.fromRGB(0, 255, 136),
    unknown = Color3.fromRGB(255, 120, 120),
    bg_ok = Color3.fromRGB(10, 30, 20),
    bg_unknown = Color3.fromRGB(40, 10, 10),
}

-- ===== ПОИСК ЦЕНЫ (каскад) =====
local function find_price(info, variant_key)
    if not info or not info.prices then return nil end
    local prices = info.prices

    local cascade = {
        variant_key,
        variant_key:gsub("|Ride", ""),
        variant_key:gsub("|Fly", ""),
        variant_key:gsub("|Fly", ""):gsub("|Ride", ""),
        "Mega|Fly|Ride", "Mega",
        "Neon|Fly|Ride", "Neon",
        "Fly|Ride", "Fly", "Ride",
        "default",
    }

    for _, key in ipairs(cascade) do
        if key and key ~= "" and prices[key] then
            return prices[key]
        end
    end
    return nil
end

-- ===== ВАРИАНТ СЛОТА =====
local function get_variant_key(slot)
    local parts = {}
    local mega = slot:FindFirstChild("mega_neon", true)
    local neon = slot:FindFirstChild("neon", true)

    if mega and mega.Visible then table.insert(parts, "Mega")
    elseif neon and neon.Visible then table.insert(parts, "Neon") end

    local fly = slot:FindFirstChild("flyable", true)
    if fly and fly.Visible then table.insert(parts, "Fly") end

    local ride = slot:FindFirstChild("rideable", true)
    if ride and ride.Visible then table.insert(parts, "Ride") end

    if #parts == 0 then return "default" end
    return table.concat(parts, "|")
end

-- ===== STACK COUNT =====
local function get_stack_count(slot)
    local stack = slot:FindFirstChild("StackCount", true)
    if stack and stack:IsA("TextLabel") and stack.Text ~= "" then
        local num = stack.Text:match("x(%d+)")
        if num then return tonumber(num) end
    end
    return 1
end

-- ===== ПЛАШКА =====
local function make_label(parent, text, is_unknown)
    local existing = parent:FindFirstChild("PriceOverlay")
    if existing then existing:Destroy() end

    local label = Instance.new("TextLabel")
    label.Name = "PriceOverlay"
    label.AnchorPoint = Vector2.new(0, 1)
    label.Size = UDim2.new(0, 400, 0, 20)
    label.Position = UDim2.new(0, 2, 1, -2)
    label.BackgroundTransparency = 1
    label.TextColor3 = is_unknown and colors.unknown or colors.ok
    label.TextStrokeTransparency = 0.25
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextScaled = false
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.ZIndex = 50
    label.Text = text
    label.Parent = parent

    local textW = label.TextBounds.X
    label.Size = UDim2.new(0, textW, 0, 20)
end

-- ===== ФОРМАТ =====
local function format_price(p)
    if not p then return "?" end
    if p >= 1000000 then return string.format("%.2fM", p / 1000000)
    elseif p >= 1000 then return string.format("%.1fK", p / 1000)
    elseif p >= 100 then return tostring(math.floor(p))
    else return string.format("%.2f", p) end
end

-- ===== СКАНИРОВАНИЕ =====
local function scan_container(container, results)
    if not container then return end

    for _, obj in pairs(container:GetDescendants()) do
        if obj:IsA("ImageLabel") and obj.Name == "ItemImageTemplate" and obj.Visible then
            local slot = obj.Parent
            if slot then
                local asset_id = obj.Image
                local info = PRICES_DATA[asset_id]

                if info then
                    local variant = get_variant_key(slot)
                    local price = find_price(info, variant)

                    if price then
                        local stack = get_stack_count(slot)
                        local total = price * stack
                        local text = (stack > 1) and ("x" .. stack .. " = " .. format_price(total) .. "₽") or (format_price(price) .. "₽")
                        make_label(slot, text, false)

                        if results then
                            results.total = (results.total or 0) + total
                            results.count = (results.count or 0) + 1
                        end
                    else
                        make_label(slot, "?", true)
                        if results then
                            results.unknown = (results.unknown or 0) + 1
                        end
                    end
                else
                    make_label(slot, "?", true)
                    if results then
                        results.unknown = (results.unknown or 0) + 1
                    end
                end
            end
        end
    end
end

-- ===== ИНВЕНТАРЬ =====
local function scan_backpack()
    local backpack = PG:FindFirstChild("BackpackApp")
    if not backpack or not backpack.Enabled then return end
    local pets = nil
    for _, obj in pairs(backpack:GetDescendants()) do
        if obj.Name == "pets" then pets = obj; break end
    end
    if pets then scan_container(pets, nil) end
end

-- ===== ПАНЕЛЬ ТРЕЙДА =====
local panel = nil

local function create_panel(body)
    local existing = body:FindFirstChild("VerdictPanel")
    if existing then existing:Destroy() end

    local p = Instance.new("Frame")
    p.Name = "VerdictPanel"
    p.Size = UDim2.new(0, 360, 0, 180)
    p.Position = UDim2.new(0.5, -180, 0, -160)
    p.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    p.BackgroundTransparency = 0.05
    p.BorderSizePixel = 0
    p.ZIndex = 100
    p.Active = true
    p.Parent = body

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = p

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Transparency = 0.4
    stroke.Parent = p

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18)),
    }
    gradient.Parent = p

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 18)
    title.Position = UDim2.new(0, 60, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "АНАЛИЗ ТРЕЙДА"
    title.TextColor3 = Color3.fromRGB(220, 220, 240)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 102
    title.Parent = p

    local verdict = Instance.new("TextLabel")
    verdict.Name = "Verdict"
    verdict.Size = UDim2.new(1, -24, 0, 38)
    verdict.Position = UDim2.new(0, 12, 0, 35)
    verdict.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    verdict.BackgroundTransparency = 0.3
    verdict.Text = "⚖️  РАВНО"
    verdict.TextColor3 = Color3.fromRGB(255, 220, 100)
    verdict.TextSize = 20
    verdict.Font = Enum.Font.GothamBlack
    verdict.ZIndex = 102
    verdict.Parent = p

    local vc = Instance.new("UICorner")
    vc.CornerRadius = UDim.new(0, 8)
    vc.Parent = verdict

    local my = Instance.new("TextLabel")
    my.Name = "MySum"
    my.Size = UDim2.new(0.5, -18, 0, 20)
    my.Position = UDim2.new(0, 12, 0, 78)
    my.BackgroundTransparency = 1
    my.Text = "💰 Ты: 0 ₽"
    my.TextColor3 = Color3.fromRGB(120, 200, 255)
    my.TextSize = 14
    my.Font = Enum.Font.GothamBold
    my.TextXAlignment = Enum.TextXAlignment.Left
    my.ZIndex = 102
    my.Parent = p

    local partner = Instance.new("TextLabel")
    partner.Name = "PartnerSum"
    partner.Size = UDim2.new(0.5, -18, 0, 20)
    partner.Position = UDim2.new(0.5, 6, 0, 78)
    partner.BackgroundTransparency = 1
    partner.Text = "👤 Партнёр: 0 ₽"
    partner.TextColor3 = Color3.fromRGB(255, 170, 100)
    partner.TextSize = 14
    partner.Font = Enum.Font.GothamBold
    partner.TextXAlignment = Enum.TextXAlignment.Right
    partner.ZIndex = 102
    partner.Parent = p

    local result = Instance.new("TextLabel")
    result.Name = "Result"
    result.Size = UDim2.new(1, -24, 0, 22)
    result.Position = UDim2.new(0, 12, 0, 101)
    result.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    result.BackgroundTransparency = 0.25
    result.Text = "📊  Общая выгода: 0 ₽"
    result.TextColor3 = Color3.fromRGB(255, 220, 100)
    result.TextSize = 15
    result.Font = Enum.Font.GothamBlack
    result.TextXAlignment = Enum.TextXAlignment.Center
    result.ZIndex = 102
    result.Parent = p

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = result

    -- ===== КЛИКАБЕЛЬНАЯ ССЫЛКА НА DISCORD =====
    local discord = Instance.new("TextButton")
    discord.Name = "DiscordLink"
    discord.Size = UDim2.new(1, -24, 0, 28)
    discord.Position = UDim2.new(0, 12, 1, -36)
    discord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discord.BackgroundTransparency = 0.1
    discord.BorderSizePixel = 0
    discord.AutoButtonColor = true
    discord.Text = "💬  Вступить в Discord  •  " .. DISCORD_URL
    discord.TextColor3 = Color3.fromRGB(255, 255, 255)
    discord.TextSize = 12
    discord.Font = Enum.Font.GothamBold
    discord.ZIndex = 103
    discord.Parent = p

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 8)
    dc.Parent = discord

    local function open_discord()
        local opened = false
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(DISCORD_URL)
            opened = true
        end)

        if not opened then
            local copied = pcall(function()
                if setclipboard then
                    setclipboard(DISCORD_URL)
                    return true
                end
                return false
            end)
            if copied then
                discord.Text = "✅  Ссылка скопирована! Вставь в браузер"
                task.delay(2.5, function()
                    if discord and discord.Parent then
                        discord.Text = "💬  Вступить в Discord  •  " .. DISCORD_URL
                    end
                end)
            end
        end
    end

    discord.MouseButton1Click:Connect(open_discord)

    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    p.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = p.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    p.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            p.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return p
end

-- ===== ТРЕЙД =====
local function scan_trade()
    local tradeApp = PG:FindFirstChild("TradeApp")
    if not tradeApp or not tradeApp.Enabled then
        if panel then panel.Visible = false end
        return end

    local frame = tradeApp:FindFirstChild("Frame")
    local neg = frame and frame:FindFirstChild("NegotiationFrame")
    local body = neg and neg:FindFirstChild("Body")
    if not body then return end

    if not panel or not panel.Parent then
        panel = create_panel(body)
    end
    if panel then panel.Visible = true end

    local my_results = {total = 0, count = 0, unknown = 0}
    local pt_results = {total = 0, count = 0, unknown = 0}

    scan_container(body:FindFirstChild("MyOffer"), my_results)
    scan_container(body:FindFirstChild("PartnerOffer"), pt_results)

    panel.MySum.Text = "💰 Ты: " .. format_price(my_results.total) .. " ₽ (" .. my_results.count .. ")"
    panel.PartnerSum.Text = "👤 Партнёр: " .. format_price(pt_results.total) .. " ₽ (" .. pt_results.count .. ")"

    local diff = pt_results.total - my_results.total
    if diff > 5 then
        panel.Verdict.Text = "✅  ВЫГОДНО  +" .. format_price(diff) .. " ₽"
        panel.Verdict.TextColor3 = Color3.fromRGB(100, 255, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(15, 60, 20)
        panel.Result.Text = "📊  Общая выгода: +" .. format_price(diff) .. " ₽"
        panel.Result.TextColor3 = Color3.fromRGB(100, 255, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(15, 60, 20)
    elseif diff < -5 then
        panel.Verdict.Text = "❌  НЕВЫГОДНО  " .. format_price(diff) .. " ₽"
        panel.Verdict.TextColor3 = Color3.fromRGB(255, 100, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
        panel.Result.Text = "📊  Общая выгода: " .. format_price(diff) .. " ₽"
        panel.Result.TextColor3 = Color3.fromRGB(255, 100, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
    else
        panel.Verdict.Text = "⚖️  РАВНО  (" .. format_price(diff) .. " ₽)"
        panel.Verdict.TextColor3 = Color3.fromRGB(255, 220, 100)
        panel.Verdict.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
        panel.Result.Text = "📊  Общая выгода: " .. format_price(diff) .. " ₽"
        panel.Result.TextColor3 = Color3.fromRGB(255, 220, 100)
        panel.Result.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
    end
end

-- ===== ЦИКЛ =====
print("[*] Overlay запущен. Проверка каждые 2 сек.")
task.spawn(function()
    while true do
        task.wait(1)
        pcall(scan_backpack)
        pcall(scan_trade)
    end
end)