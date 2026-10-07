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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.37, ["Ride"] = 1179.92, ["Fly|Ride"] = 1314, ["Neon"] = 6972.42, ["Neon|Fly|Ride"] = 5147.2, ["Mega"] = 21899.83, ["Mega|Fly|Ride"] = 21899.83}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Fly"] = 755.81, ["Ride"] = 523.94, ["Fly|Ride"] = 723.91, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 8533.38}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4462.5, ["Ride"] = 4725, ["Fly|Ride"] = 4373.25, ["Neon|Fly|Ride"] = 18985.08, ["Mega|Fly|Ride"] = 77379.77}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 146.74, ["Ride"] = 273.73, ["Fly|Ride"] = 409.55, ["Neon"] = 1162.93, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4980.34}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 876, ["Ride"] = 590.63, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 1616.99, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.86, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 93.42, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 357.33, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 568.32}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.94, ["Fly"] = 46.83, ["Ride"] = 30.75, ["Fly|Ride"] = 64.75, ["Neon"] = 29.58, ["Neon|Fly"] = 131.41, ["Neon|Ride"] = 59.72, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 229.43, ["Mega|Ride"] = 218.7, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.73, ["Fly"] = 199.22, ["Ride"] = 131.41, ["Fly|Ride"] = 229.69, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 1749.81}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.82, ["Fly"] = 59.14, ["Ride"] = 59.14, ["Fly|Ride"] = 116.81, ["Neon"] = 275.63, ["Neon|Ride"] = 231.95, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1168.37, ["Mega|Fly|Ride"] = 886.36}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.84, ["Fly"] = 49.03, ["Ride"] = 31.49, ["Fly|Ride"] = 76.93, ["Neon"] = 262.5, ["Neon|Ride"] = 217.91, ["Neon|Fly|Ride"] = 210, ["Mega"] = 657.01, ["Mega|Fly|Ride"] = 610.71}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 77.43, ["Fly"] = 223.13, ["Ride"] = 131.24, ["Fly|Ride"] = 259.88, ["Neon"] = 406.88, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 442.19, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 2336.73}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.31}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 361.49, ["Fly"] = 497.14, ["Ride"] = 358.15, ["Fly|Ride"] = 404.25, ["Neon|Ride"] = 1489.21, ["Neon|Fly|Ride"] = 1286.25, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 166.86, ["Ride"] = 144.38, ["Fly|Ride"] = 183.75, ["Neon|Fly"] = 697.26, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.29, ["Fly"] = 80.66, ["Ride"] = 65.63, ["Fly|Ride"] = 166.87, ["Neon"] = 24.94, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 273.77, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 327.6, ["Mega|Fly|Ride"] = 398.44}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 234.94, ["Fly"] = 292.38, ["Ride"] = 236.25, ["Fly|Ride"] = 279.55, ["Neon|Fly"] = 874.92, ["Neon|Ride"] = 1162.93, ["Neon|Fly|Ride"] = 820.68, ["Mega|Fly|Ride"] = 2695.98}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.42, ["Fly"] = 28.48, ["Ride"] = 18.69, ["Fly|Ride"] = 45.41, ["Neon"] = 25.19, ["Neon|Fly"] = 131.41, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 96.38, ["Mega"] = 170.63, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 144.36, ["Fly"] = 333.38, ["Ride"] = 179.82, ["Fly|Ride"] = 328.51, ["Neon"] = 525, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 656.94, ["Mega"] = 1826.57, ["Mega|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 86.51, ["Ride"] = 183.75, ["Fly|Ride"] = 249.05, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1751.99}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 37.94, ["Fly"] = 59.16, ["Ride"] = 58.46, ["Fly|Ride"] = 105, ["Neon"] = 262.5, ["Neon|Ride"] = 361.45, ["Neon|Fly|Ride"] = 379.98, ["Mega"] = 2864.38, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1020.79}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.07, ["Fly"] = 75.12, ["Ride"] = 55.81, ["Fly|Ride"] = 113.07, ["Neon"] = 216.45, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 277.81, ["Mega"] = 1743.12, ["Mega|Fly|Ride"] = 953.07}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 37.52, ["Fly"] = 146.74, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 409.55, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1967.44, ["Mega|Ride"] = 1751.99, ["Mega|Fly|Ride"] = 1576.8}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 31.82, ["Ride"] = 57.89, ["Fly|Ride"] = 126.1, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 48.2, ["Fly"] = 102.38, ["Ride"] = 65.44, ["Fly|Ride"] = 135.79, ["Neon"] = 210, ["Neon|Ride"] = 347.73, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1162.96, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.11, ["Fly"] = 32.46, ["Ride"] = 24.69, ["Fly|Ride"] = 62.04, ["Neon"] = 57.75, ["Neon|Fly"] = 81.67, ["Neon|Ride"] = 48.18, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 170.63, ["Mega|Fly"] = 27984.21, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.81, ["Fly"] = 546.41, ["Ride"] = 420, ["Fly|Ride"] = 485.63, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 9878.85}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.77, ["Ride"] = 31.49, ["Fly|Ride"] = 135.79, ["Neon"] = 90.57, ["Neon|Fly|Ride"] = 446.77, ["Mega|Ride"] = 409.55, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.28, ["Fly"] = 43.22, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 65.62, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 393.75, ["Mega|Ride"] = 441.3, ["Mega|Fly|Ride"] = 442.55}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.13, ["Fly"] = 85.32, ["Ride"] = 86.93, ["Fly|Ride"] = 124.06, ["Neon"] = 409.49, ["Neon|Ride"] = 471.96, ["Neon|Fly|Ride"] = 400.31, ["Mega"] = 6599.25, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1641.42}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.8, ["Ride"] = 26.25, ["Fly|Ride"] = 78.86, ["Neon"] = 91.88, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 270.57, ["Mega"] = 720.57, ["Mega|Ride"] = 747.07, ["Mega|Fly|Ride"] = 546.35}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 232.14, ["Fly"] = 300.68, ["Ride"] = 278.11, ["Fly|Ride"] = 332.49, ["Neon"] = 765.42, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 2847, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2938.41}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.66, ["Fly"] = 27.91, ["Ride"] = 20.35, ["Fly|Ride"] = 57.88, ["Neon"] = 25.99, ["Neon|Fly"] = 146.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.41, ["Mega"] = 148.32, ["Mega|Fly"] = 498.04, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.63}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1048.69, ["Fly"] = 2625, ["Ride"] = 1141.77, ["Fly|Ride"] = 1312.5, ["Neon"] = 9187.5, ["Neon|Ride"] = 6424.34, ["Neon|Fly|Ride"] = 6131.96, ["Mega|Ride"] = 56041.86, ["Mega|Fly|Ride"] = 18963.03}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 20.73, ["Fly"] = 57.29, ["Ride"] = 51.97, ["Fly|Ride"] = 105.99, ["Neon"] = 208.06, ["Neon|Ride"] = 269.38, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 1043.44, ["Mega|Ride"] = 1124.57, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.77, ["Fly"] = 373.54, ["Ride"] = 236.88, ["Fly|Ride"] = 311.85, ["Neon"] = 945, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4263.91, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4044.5}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.17}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 13.55, ["Fly"] = 86.8, ["Ride"] = 43.92, ["Fly|Ride"] = 146.74, ["Neon"] = 104.98, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 415.87, ["Mega"] = 592.55, ["Mega|Ride"] = 584.74, ["Mega|Fly|Ride"] = 664.9}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 117.17, ["Fly"] = 165.55, ["Ride"] = 144.08, ["Fly|Ride"] = 203.44, ["Neon"] = 438, ["Neon|Ride"] = 542.04, ["Neon|Fly|Ride"] = 664.96, ["Mega|Ride"] = 2325.91, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.19, ["Fly"] = 250.08, ["Ride"] = 146.73, ["Fly|Ride"] = 240.19, ["Neon"] = 423.68, ["Neon|Fly"] = 830.48, ["Neon|Ride"] = 434.79, ["Neon|Fly|Ride"] = 497.44, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1451.38}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.46, ["Fly"] = 62.99, ["Ride"] = 47.09, ["Fly|Ride"] = 77.87, ["Neon|Ride"] = 401.88, ["Neon|Fly|Ride"] = 373.02, ["Mega"] = 4379.99, ["Mega|Fly|Ride"] = 1561.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.45, ["Ride"] = 56.35, ["Fly|Ride"] = 210.26, ["Neon"] = 48.2, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 246.39, ["Mega"] = 234.94, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 258.5, ["Mega|Fly|Ride"] = 569.41}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 735.83, ["Ride"] = 589.77, ["Fly|Ride"] = 630, ["Neon"] = 1968.75, ["Neon|Fly"] = 3941.98, ["Neon|Ride"] = 3888.14, ["Neon|Fly|Ride"] = 2118.38, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 124.68, ["Fly"] = 170.63, ["Ride"] = 124.69, ["Fly|Ride"] = 203.34, ["Neon"] = 664.96, ["Neon|Ride"] = 575.97, ["Neon|Fly|Ride"] = 575.97, ["Mega"] = 2847, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3780, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 76.11, ["Fly"] = 234.35, ["Ride"] = 91.86, ["Fly|Ride"] = 201.68, ["Neon|Ride"] = 424.39, ["Neon|Fly|Ride"] = 875.9, ["Mega|Ride"] = 2190, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 79.79, ["Fly"] = 328.13, ["Ride"] = 81.12, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 547.53, ["Neon|Fly|Ride"] = 438, ["Mega"] = 6424.34, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2531.63}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.54, ["Fly"] = 64.66, ["Ride"] = 45.85, ["Fly|Ride"] = 98.68, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 2625, ["Mega|Ride"] = 936.25, ["Mega|Fly|Ride"] = 597.71}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.39}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 41.12, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 133.25, ["Neon|Ride"] = 332.46, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1328.53, ["Mega|Fly|Ride"] = 1346.7}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.79}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 194.25, ["Fly|Ride"] = 282.19, ["Neon"] = 1168.37, ["Neon|Ride"] = 1162.93, ["Neon|Fly|Ride"] = 1311.82, ["Mega|Fly|Ride"] = 4980.34}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 787.5, ["Fly"] = 819.07, ["Ride"] = 721.88, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Ride"] = 3064.9, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12118.29}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.97}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.19, ["Fly"] = 58.47, ["Ride"] = 42.39, ["Fly|Ride"] = 65.59, ["Neon"] = 192.94, ["Neon|Fly"] = 284.71, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 220.5, ["Mega|Ride"] = 1195.2, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.14}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 7300.33, ["Ride"] = 8030.68, ["Fly|Ride"] = 4812.93, ["Neon|Ride"] = 18263.52, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.02, ["Fly"] = 146.74, ["Ride"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon"] = 90.57, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 561.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.53, ["Fly"] = 143.46, ["Ride"] = 37.25, ["Fly|Ride"] = 123.29, ["Neon"] = 95.82, ["Neon|Ride"] = 140.21, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 985.51, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 65.63, ["Fly"] = 116.08, ["Ride"] = 58.16, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 490.73, ["Mega"] = 4379.99, ["Mega|Fly|Ride"] = 1826.57}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 73.38, ["Ride"] = 36.75, ["Fly|Ride"] = 78.74, ["Neon"] = 100.96, ["Neon|Fly"] = 219.01, ["Neon|Ride"] = 146.73, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 547.53, ["Mega|Ride"] = 814.3, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1673.44, ["Fly"] = 1837.5, ["Ride"] = 2152.77, ["Fly|Ride"] = 1805.71, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 35039.73, ["Ride"] = 33580.12, ["Fly|Ride"] = 25200, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.04, ["Fly"] = 393.75, ["Ride"] = 54.79, ["Fly|Ride"] = 120.75, ["Neon"] = 150.43, ["Neon|Ride"] = 276.81, ["Neon|Fly|Ride"] = 262.81, ["Mega"] = 765.42, ["Mega|Ride"] = 1328.83, ["Mega|Fly|Ride"] = 762.14}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.77, ["Fly"] = 123.76, ["Ride"] = 49.8, ["Fly|Ride"] = 199.24, ["Neon"] = 24.93, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 170.63, ["Mega|Fly"] = 348.64, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.28}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.46, ["Ride"] = 37.25, ["Fly|Ride"] = 157.5, ["Neon"] = 58.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 433.73, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 560.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 712.87, ["Ride"] = 643.13, ["Fly|Ride"] = 724.5, ["Neon"] = 3155.03, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9526.44}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 941.07, ["Fly"] = 951.57, ["Ride"] = 813.75, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3358.36, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13944.94}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.71, ["Fly"] = 124.52, ["Ride"] = 32.79, ["Fly|Ride"] = 77.97, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 510.28, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 65.62, ["Fly"] = 118.13, ["Ride"] = 91.85, ["Fly|Ride"] = 118.13, ["Neon"] = 582.56, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2045.46, ["Mega|Fly|Ride"] = 2145.11}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.76, ["Ride"] = 125.95, ["Fly|Ride"] = 149.63, ["Neon"] = 450.19, ["Neon|Ride"] = 498.36, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1439.31, ["Mega|Fly|Ride"] = 2180.76}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.85, ["Fly"] = 28.88, ["Ride"] = 18.88, ["Fly|Ride"] = 53.52, ["Neon"] = 49.82, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 116.65, ["Mega"] = 292.38, ["Mega|Fly|Ride"] = 358.82}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 190.31, ["Fly"] = 261.52, ["Ride"] = 217.87, ["Fly|Ride"] = 262.49, ["Neon"] = 765.42, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 735, ["Mega"] = 5255.97, ["Mega|Fly|Ride"] = 2619.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.57, ["Ride"] = 49.88, ["Fly|Ride"] = 141.75, ["Neon"] = 45.94, ["Neon|Ride"] = 171.85, ["Mega"] = 274.32, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 581.4}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.13, ["Fly"] = 65.63, ["Ride"] = 32.8, ["Fly|Ride"] = 90.85, ["Neon"] = 126, ["Neon|Fly"] = 332.45, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.21, ["Mega|Fly|Ride"] = 817.97}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.2, ["Ride"] = 56.6, ["Fly|Ride"] = 156.19, ["Neon"] = 248.57, ["Neon|Ride"] = 213.54, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.98, ["Fly"] = 89.8, ["Ride"] = 41.98, ["Fly|Ride"] = 83.24, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 350.41, ["Mega"] = 1276.77, ["Mega|Fly|Ride"] = 869.44}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 5643.75, ["Fly|Ride"] = 5381.25, ["Neon"] = 32849.75, ["Neon|Fly|Ride"] = 30514.14}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 225.65, ["Fly"] = 315, ["Ride"] = 229.69, ["Fly|Ride"] = 299.25, ["Neon|Fly"] = 830.41, ["Neon|Fly|Ride"] = 598.5, ["Mega|Fly|Ride"] = 2231.24}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 64.95, ["Fly"] = 182.86, ["Ride"] = 128.13, ["Fly|Ride"] = 258.55, ["Neon"] = 183.74, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 582.32, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 652.32}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 35.05, ["Fly|Ride"] = 81.37, ["Neon"] = 23.63, ["Neon|Ride"] = 56.96, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 57.75, ["Fly"] = 215.34, ["Ride"] = 120.75, ["Fly|Ride"] = 222.17, ["Neon"] = 220.5, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 429.53, ["Mega"] = 509.08, ["Mega|Fly"] = 744.61, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16641.92, ["Ride"] = 13415.07, ["Fly|Ride"] = 11550, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 109353.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 354.38, ["Ride"] = 392.44, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1641.42, ["Neon|Fly|Ride"] = 2516.31, ["Mega|Fly|Ride"] = 8759.94}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.06, ["Fly"] = 90.5, ["Ride"] = 57.74, ["Fly|Ride"] = 108.94, ["Neon"] = 288.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 389.81, ["Mega|Fly|Ride"] = 2043.27}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.47, ["Ride"] = 23.39, ["Fly|Ride"] = 65.63, ["Neon"] = 67.82, ["Neon|Fly"] = 282.65, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 473.82, ["Mega|Ride"] = 747.07, ["Mega|Fly|Ride"] = 528.89}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 366.19, ["Ride"] = 433.12, ["Fly|Ride"] = 477.75, ["Neon"] = 1741.05, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.05, ["Ride"] = 32.87, ["Fly|Ride"] = 146.73, ["Neon"] = 34.74, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 157.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 111.46, ["Fly"] = 218.99, ["Ride"] = 164.07, ["Fly|Ride"] = 210, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 546, ["Mega|Fly|Ride"] = 2399.72}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.4, ["Fly"] = 20.35, ["Ride"] = 18.18, ["Fly|Ride"] = 32.82, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 89.15, ["Mega"] = 2627.99, ["Mega|Fly|Ride"] = 631.28}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.86}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 72.02, ["Ride"] = 87.94, ["Fly|Ride"] = 175.22, ["Neon"] = 244.12, ["Neon|Fly"] = 546.41, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 438, ["Mega|Ride"] = 2043.27, ["Mega|Fly|Ride"] = 1642.31}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Fly"] = 298.85, ["Ride"] = 38.56, ["Fly|Ride"] = 100.05, ["Neon"] = 85.31, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 551.88, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1314}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 42}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 83.35, ["Fly"] = 146.74, ["Ride"] = 131.25, ["Fly|Ride"] = 438, ["Neon"] = 392.44, ["Neon|Ride"] = 437.96, ["Neon|Fly|Ride"] = 664.9, ["Mega|Ride"] = 1660.96, ["Mega|Fly|Ride"] = 2035.6}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.97, ["Fly|Ride"] = 141.96, ["Neon"] = 24.94, ["Neon|Ride"] = 143.46, ["Neon|Fly|Ride"] = 292.38, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 332.46}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.88, ["Fly"] = 56.42, ["Ride"] = 33.97, ["Fly|Ride"] = 87.94, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 217.91, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 498.12, ["Ride"] = 529.11, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2845.89, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 45.01, ["Fly"] = 109.52, ["Ride"] = 79.13, ["Fly|Ride"] = 107.54, ["Neon"] = 195.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 830.49}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.87, ["Fly"] = 146.64, ["Ride"] = 78.75, ["Fly|Ride"] = 147.4, ["Neon"] = 270.38, ["Neon|Ride"] = 232.05, ["Neon|Fly|Ride"] = 330.78, ["Mega|Ride"] = 1092.82, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.69, ["Fly"] = 87.62, ["Ride"] = 65.61, ["Fly|Ride"] = 145.29, ["Neon"] = 85.32, ["Neon|Ride"] = 148.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Fly"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 584.74}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9843.75, ["Fly"] = 10500, ["Ride"] = 8861.99, ["Fly|Ride"] = 7612.5, ["Neon|Fly|Ride"] = 14424.38, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1517.02, ["Ride"] = 1666.47, ["Fly|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 3726.18, ["Mega|Fly|Ride"] = 15937.62}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 520.14, ["Ride"] = 459.38, ["Fly|Ride"] = 702.79, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21899.83, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.23, ["Fly"] = 28.48, ["Ride"] = 21.92, ["Fly|Ride"] = 43.82, ["Neon"] = 65.63, ["Neon|Ride"] = 65.71, ["Neon|Fly|Ride"] = 128.1, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.41, ["Fly"] = 78.74, ["Ride"] = 28.88, ["Fly|Ride"] = 201.49, ["Neon"] = 25.92, ["Neon|Ride"] = 63.74, ["Mega"] = 164.07, ["Mega|Ride"] = 210.03, ["Mega|Fly|Ride"] = 396}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.03, ["Fly"] = 60.8, ["Ride"] = 49.79, ["Fly|Ride"] = 98.43, ["Neon"] = 242.01, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 177.85, ["Mega|Fly|Ride"] = 660.09}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 31.4, ["Ride"] = 19.62, ["Fly|Ride"] = 39.35, ["Neon"] = 28.88, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 326.41, ["Mega|Ride"] = 365.74, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 327.49, ["Fly"] = 430.5, ["Ride"] = 324.19, ["Fly|Ride"] = 419.99, ["Neon"] = 1093.91, ["Neon|Ride"] = 1212.17, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4480.92}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.85, ["Fly"] = 72.29, ["Ride"] = 44.63, ["Fly|Ride"] = 78.74, ["Neon"] = 144.38, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 187.26, ["Neon|Fly|Ride"] = 166.87, ["Mega"] = 876, ["Mega|Fly"] = 930.09, ["Mega|Ride"] = 575.24, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.97, ["Fly"] = 21.92, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 83.24, ["Neon|Fly"] = 123.76, ["Neon|Ride"] = 123.29, ["Neon|Fly|Ride"] = 120.83, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 485.63, ["Fly|Ride"] = 876, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1460.73, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon"] = 5342.63, ["Neon|Ride"] = 4817.97, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 149.44, ["Fly"] = 146.74, ["Ride"] = 118.13, ["Fly|Ride"] = 118.13, ["Neon"] = 602.26, ["Neon|Ride"] = 664.9, ["Neon|Fly|Ride"] = 505.31, ["Mega|Ride"] = 2613.76, ["Mega|Fly|Ride"] = 2906.04}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.15, ["Fly"] = 196.88, ["Ride"] = 203.44, ["Fly|Ride"] = 261.19, ["Neon|Ride"] = 686.57, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.66, ["Fly"] = 125.95, ["Ride"] = 54.77, ["Fly|Ride"] = 105.13, ["Neon"] = 257.24, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2190, ["Mega|Fly|Ride"] = 1111.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 247.96, ["Ride"] = 646.14, ["Fly|Ride"] = 497.14, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1314, ["Mega|Fly|Ride"] = 5840.7}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2190, ["Ride"] = 2482.27, ["Fly|Ride"] = 2052.75, ["Neon"] = 10949.92, ["Neon|Fly|Ride"] = 10949.92, ["Mega|Fly|Ride"] = 50369.62}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 50.05, ["Fly"] = 219.01, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2409, ["Mega|Fly|Ride"] = 1453.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.74, ["Fly"] = 876, ["Ride"] = 619.48, ["Fly|Ride"] = 656.25, ["Neon"] = 1489.21, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1299.37, ["Mega|Fly|Ride"] = 3648.09}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.94, ["Fly"] = 65.62, ["Ride"] = 57.75, ["Fly|Ride"] = 103.58, ["Neon"] = 438, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.83, ["Fly"] = 41.94, ["Ride"] = 20.96, ["Fly|Ride"] = 71.74, ["Neon"] = 47.58, ["Neon|Fly"] = 128.62, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 186.38, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.63, ["Ride"] = 60.37, ["Fly|Ride"] = 157.5, ["Neon"] = 288.65, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 730.37, ["Mega"] = 1606.37, ["Mega|Fly|Ride"] = 1737.78}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1071.17, ["Fly"] = 1203.43, ["Ride"] = 1048.68, ["Fly|Ride"] = 1127.44, ["Neon|Ride"] = 3503.98, ["Neon|Fly|Ride"] = 3437.15, ["Mega|Fly|Ride"] = 11680.29}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 689.07, ["Ride"] = 821.25, ["Fly|Ride"] = 905.58, ["Neon|Fly|Ride"] = 4378.89, ["Mega|Fly|Ride"] = 20440.22}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.15, ["Fly"] = 26.25, ["Ride"] = 22.31, ["Fly|Ride"] = 43.82, ["Neon"] = 131.25, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 116.82, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 18.36, ["Ride"] = 24.93, ["Fly|Ride"] = 131.41, ["Neon"] = 249.38, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 913.27, ["Mega|Ride"] = 1020.44, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.84, ["Fly"] = 70.88, ["Ride"] = 46.99, ["Fly|Ride"] = 105, ["Neon"] = 25.67, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 190.54, ["Mega"] = 157.5, ["Mega|Fly"] = 581.47, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.72, ["Fly"] = 113.89, ["Ride"] = 51.47, ["Fly|Ride"] = 111.57, ["Neon"] = 323.04, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 196.87, ["Mega|Fly|Ride"] = 1064.36}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.01, ["Ride"] = 183.75, ["Fly|Ride"] = 365.74, ["Neon"] = 458.07, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.43, ["Fly"] = 59.05, ["Ride"] = 23.63, ["Fly|Ride"] = 83.64, ["Neon"] = 109.52, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 202.99, ["Mega"] = 434.04, ["Mega|Ride"] = 385.77, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.2, ["Fly"] = 64.32, ["Ride"] = 42.36, ["Fly|Ride"] = 73.37, ["Neon"] = 242.82, ["Neon|Ride"] = 205.83, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 2100, ["Mega|Ride"] = 1138.8, ["Mega|Fly|Ride"] = 1162.32}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 4.36, ["Fly"] = 50.94, ["Ride"] = 17.07, ["Fly|Ride"] = 43.77, ["Neon"] = 32.71, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 116.08, ["Mega"] = 434.74, ["Mega|Ride"] = 498.04, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 8.5, ["Fly"] = 58.23, ["Ride"] = 32.82, ["Fly|Ride"] = 108.33, ["Neon"] = 60.29, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 216.87, ["Mega"] = 547.53, ["Mega|Ride"] = 481.32, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 49.88, ["Fly"] = 72.18, ["Ride"] = 53.92, ["Fly|Ride"] = 99.63, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 278.1, ["Mega"] = 1511.54, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1273.13, ["Fly"] = 1365, ["Ride"] = 1417.49, ["Fly|Ride"] = 1443.75, ["Neon|Ride"] = 4980.34, ["Neon|Fly|Ride"] = 3443.34, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.73, ["Fly"] = 575.97, ["Ride"] = 523.68, ["Fly|Ride"] = 572.24, ["Neon|Ride"] = 3292.02, ["Neon|Fly|Ride"] = 2332.32, ["Mega"] = 15329.89, ["Mega|Fly|Ride"] = 9854.94}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 288.64, ["Ride"] = 315, ["Fly|Ride"] = 314.9, ["Neon"] = 1575, ["Neon|Ride"] = 1468.69, ["Neon|Fly|Ride"] = 1785, ["Mega|Ride"] = 7471.23, ["Mega|Fly|Ride"] = 8030.68}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.05}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 48.54, ["Ride"] = 49.76, ["Fly|Ride"] = 146.73, ["Neon"] = 328.5, ["Neon|Fly"] = 584.74, ["Neon|Ride"] = 166.73, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1204.5, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 90562.5, ["Ride"] = 38182.99, ["Fly|Ride"] = 19883.07, ["Neon|Fly|Ride"] = 38062.5, ["Mega"] = 218998.24, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.45, ["Fly"] = 284.71, ["Ride"] = 262.5, ["Fly|Ride"] = 346.5, ["Neon"] = 964.69, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 996.08, ["Neon|Fly|Ride"] = 912.18, ["Mega"] = 6569.97, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 144.38, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 80.22, ["Fly"] = 216.9, ["Ride"] = 108.64, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 596.47, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 53.82, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 83.45, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 157.69, ["Neon|Fly|Ride"] = 238.8, ["Mega"] = 1968.75, ["Mega|Ride"] = 730.37, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5289.94, ["Ride"] = 4058.25, ["Fly|Ride"] = 4200, ["Neon"] = 21899.83, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 83005.35}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.14, ["Fly"] = 51.24, ["Ride"] = 34.13, ["Fly|Ride"] = 62.99, ["Neon"] = 131.25, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 186.4, ["Mega|Ride"] = 1460.73, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 36.72, ["Fly"] = 102.95, ["Ride"] = 47.25, ["Fly|Ride"] = 91.88, ["Neon"] = 314.26, ["Neon|Fly"] = 1475.21, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 434.44, ["Fly"] = 563.06, ["Ride"] = 472.5, ["Fly|Ride"] = 538.12, ["Neon"] = 1174.69, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1363.62, ["Mega"] = 4134.38, ["Mega|Fly|Ride"] = 4369.61}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.43, ["Fly"] = 28.48, ["Ride"] = 24.94, ["Fly|Ride"] = 39.38, ["Neon"] = 131.25, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 652.56}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.25, ["Fly"] = 292.38, ["Ride"] = 35.42, ["Fly|Ride"] = 82.2, ["Neon"] = 124.84, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 747.07}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 84, ["Ride"] = 104.99, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 686.57, ["Mega|Fly|Ride"] = 2117.48}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.17, ["Fly"] = 547.53, ["Ride"] = 87.62, ["Fly|Ride"] = 177.21, ["Neon"] = 85.31, ["Neon|Ride"] = 140.93, ["Neon|Fly|Ride"] = 451.16, ["Mega"] = 383.25, ["Mega|Fly"] = 498.04, ["Mega|Ride"] = 273.73, ["Mega|Fly|Ride"] = 490.56}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 5118.75, ["Ride"] = 4790.63, ["Fly|Ride"] = 4593.75, ["Neon"] = 19687.5, ["Neon|Ride"] = 13387.5, ["Neon|Fly|Ride"] = 11681.25, ["Mega"] = 65699.48, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35.41, ["Fly"] = 74.49, ["Ride"] = 52.5, ["Fly|Ride"] = 165.38, ["Neon"] = 233.62, ["Neon|Ride"] = 262.81, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1241.73, ["Mega|Ride"] = 1826.54, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7875, ["Ride"] = 6168.75, ["Fly|Ride"] = 6168.65, ["Neon"] = 23242, ["Neon|Fly|Ride"] = 15223.69, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 24.36, ["Ride"] = 19.68, ["Fly|Ride"] = 28.88, ["Neon"] = 23.63, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 102.79, ["Mega"] = 242.82, ["Mega|Ride"] = 394.46, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.67, ["Fly"] = 33.99, ["Ride"] = 32.81, ["Fly|Ride"] = 43.31, ["Neon"] = 92.04, ["Neon|Fly"] = 242.01, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 166.19, ["Mega|Ride"] = 1022.74, ["Mega|Fly|Ride"] = 876}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.55}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.84, ["Fly"] = 47.1, ["Ride"] = 26.02, ["Fly|Ride"] = 90.9, ["Neon"] = 131.23, ["Neon|Ride"] = 139.11, ["Mega"] = 1049.9, ["Mega|Ride"] = 1167.28, ["Mega|Fly|Ride"] = 1149.75}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.17, ["Fly"] = 190.37, ["Ride"] = 48.2, ["Fly|Ride"] = 155.5, ["Neon"] = 146.74, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2025.76, ["Mega|Ride"] = 876, ["Mega|Fly|Ride"] = 830.49}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.75, ["Fly"] = 27.57, ["Ride"] = 23.5, ["Fly|Ride"] = 41.44, ["Neon"] = 94, ["Neon|Fly"] = 1091.72, ["Neon|Ride"] = 109.52, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 2627.99, ["Mega|Fly|Ride"] = 641.67}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8751.2}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.47}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 267.75, ["Ride"] = 203.44, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1230.2}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.53, ["Fly"] = 45.94, ["Ride"] = 36.66, ["Fly|Ride"] = 97.13, ["Neon"] = 166.85, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 546.55, ["Mega|Ride"] = 2085.72, ["Mega|Fly|Ride"] = 546.35}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.59}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.55, ["Ride"] = 25.98, ["Fly|Ride"] = 87.62, ["Neon"] = 146.74, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2493.75}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 249.38, ["Fly"] = 438, ["Ride"] = 262.5, ["Fly|Ride"] = 747.07, ["Neon"] = 981.75, ["Neon|Ride"] = 1096.94, ["Neon|Fly|Ride"] = 1086.14, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 69.98, ["Fly"] = 219.01, ["Ride"] = 81.02, ["Fly|Ride"] = 525, ["Neon"] = 423.34, ["Neon|Ride"] = 342.48, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2187.81}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 200.55, ["Fly"] = 266.47, ["Ride"] = 131.25, ["Fly|Ride"] = 248.89, ["Neon"] = 944.99, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3722.99, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2362.5, ["Fly"] = 3358.36, ["Ride"] = 2756.25, ["Fly|Ride"] = 2478, ["Neon"] = 15380.27, ["Neon|Ride"] = 10791.17, ["Neon|Fly|Ride"] = 9961.62, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.17, ["Fly"] = 108.42, ["Ride"] = 57.75, ["Fly|Ride"] = 113.89, ["Neon"] = 127.32, ["Neon|Ride"] = 159.39, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 984.41, ["Mega|Ride"] = 1204.5, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 830.57, ["Fly"] = 2100, ["Ride"] = 830.49, ["Fly|Ride"] = 876, ["Neon|Fly|Ride"] = 5473.88}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 24.83, ["Ride"] = 48.18, ["Fly|Ride"] = 203.44, ["Neon"] = 115.5, ["Neon|Ride"] = 135.79, ["Neon|Fly|Ride"] = 267.21, ["Mega"] = 480.05, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.94, ["Fly"] = 43.82, ["Ride"] = 29.9, ["Fly|Ride"] = 77.22, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 465.7, ["Mega|Ride"] = 281.4, ["Mega|Fly|Ride"] = 403.43}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.91}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21.37, ["Fly"] = 32.87, ["Ride"] = 36.65, ["Fly|Ride"] = 59.07, ["Neon"] = 144.56, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1314, ["Mega|Fly|Ride"] = 2190}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.85, ["Fly"] = 47.33, ["Ride"] = 32.15, ["Fly|Ride"] = 61.34, ["Neon"] = 292.38, ["Neon|Fly"] = 241.98, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 291.29, ["Mega"] = 1460.73, ["Mega|Ride"] = 1868.07, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7005.77, ["Fly"] = 4987.5, ["Ride"] = 6613.95, ["Fly|Ride"] = 4856.24, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.18, ["Fly"] = 49.75, ["Ride"] = 31.5, ["Fly|Ride"] = 87.62, ["Neon"] = 57.18, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 237.83, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 631.28}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.36}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.93, ["Fly"] = 387.64, ["Ride"] = 118.13, ["Fly|Ride"] = 207.94, ["Neon"] = 511.31, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 526.22, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 58.93, ["Fly"] = 194.81, ["Ride"] = 84.2, ["Fly|Ride"] = 176.49, ["Neon"] = 308.44, ["Neon|Fly"] = 398.44, ["Neon|Ride"] = 292.35, ["Neon|Fly|Ride"] = 584.74, ["Mega"] = 2490.16, ["Mega|Ride"] = 996.08, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.85, ["Fly"] = 82.14, ["Ride"] = 33.52, ["Fly|Ride"] = 65.61, ["Neon"] = 174.57, ["Neon|Fly"] = 236.54, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.21, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 1051.21}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.17, ["Fly"] = 78.73, ["Ride"] = 27.46, ["Fly|Ride"] = 106.32, ["Neon"] = 34.1, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 219.01, ["Mega|Fly"] = 7300.22, ["Mega|Ride"] = 229.09, ["Mega|Fly|Ride"] = 354.25}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.81, ["Fly"] = 63.67, ["Ride"] = 29.89, ["Fly|Ride"] = 94.18, ["Neon"] = 85.65, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 234.35, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 546.41}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21.84, ["Fly"] = 29.58, ["Ride"] = 31.43, ["Fly|Ride"] = 50.52, ["Neon"] = 186.17, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 146.9, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 32.82, ["Ride"] = 131.25, ["Fly|Ride"] = 339.94, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 432.53, ["Mega"] = 866.25, ["Mega|Ride"] = 779.64, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["Ride"] = 1460.73, ["Neon|Fly|Ride"] = 72999.8}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 53.82, ["Ride"] = 89.25, ["Fly|Ride"] = 139.07, ["Neon"] = 219.19, ["Neon|Ride"] = 365.74, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1166.82, ["Mega|Ride"] = 1342.35, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.99, ["Fly"] = 1246.88, ["Ride"] = 1223.25, ["Fly|Ride"] = 1399.93, ["Neon"] = 4793.59, ["Neon|Fly"] = 4793.59, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 370.32, ["Fly"] = 730.37, ["Ride"] = 433.13, ["Fly|Ride"] = 573.71, ["Neon"] = 3212.72, ["Neon|Ride"] = 2190, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 13271.69, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 60.37}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.88, ["Fly"] = 32.8, ["Ride"] = 24.81, ["Fly|Ride"] = 59.14, ["Neon"] = 83.45, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 437.26, ["Mega|Ride"] = 730.37, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.92, ["Fly"] = 354.38, ["Ride"] = 262.5, ["Fly|Ride"] = 374.07, ["Neon"] = 1195.29, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3617.86}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.1}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.9, ["Ride"] = 175.88, ["Fly|Ride"] = 295.2, ["Neon"] = 694.32, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 748.13, ["Mega"] = 2809.03, ["Mega|Ride"] = 2505.5, ["Mega|Fly|Ride"] = 2338.8}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 292.38, ["Ride"] = 150.94, ["Fly|Ride"] = 262.5, ["Neon"] = 876, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 747, ["Mega|Fly|Ride"] = 2326.05}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.83, ["Ride"] = 21.92, ["Fly|Ride"] = 219.01, ["Neon"] = 31.18, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 262.81, ["Mega"] = 170.63, ["Mega|Ride"] = 230.9, ["Mega|Fly|Ride"] = 381.03}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.9, ["Fly"] = 50.4, ["Ride"] = 25.73, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 292.38, ["Mega|Ride"] = 766.5, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.47, ["Fly"] = 102.36, ["Ride"] = 34.5, ["Fly|Ride"] = 131.25, ["Neon"] = 83.15, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.9, ["Fly"] = 175.22, ["Ride"] = 54.93, ["Fly|Ride"] = 157.49, ["Neon"] = 26.25, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 164.07, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 274.32, ["Ride"] = 324.19, ["Fly|Ride"] = 367.49, ["Neon"] = 1445.75, ["Neon|Ride"] = 1429.38, ["Neon|Fly|Ride"] = 1409.82, ["Mega|Ride"] = 5110.34, ["Mega|Fly|Ride"] = 6745.16}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 93.44, ["Fly"] = 584.74, ["Ride"] = 124.68, ["Fly|Ride"] = 194.91, ["Neon"] = 420, ["Neon|Ride"] = 492.81, ["Neon|Fly|Ride"] = 514.48, ["Mega"] = 2022.57, ["Mega|Ride"] = 2774.72, ["Mega|Fly|Ride"] = 2157.6}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.62, ["Fly"] = 167.45, ["Ride"] = 85.39, ["Fly|Ride"] = 119.69, ["Neon"] = 393.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 425.23, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Fly"] = 127.32, ["Ride"] = 54.77, ["Neon|Ride"] = 632.68, ["Neon|Fly|Ride"] = 332.46}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.33, ["Ride"] = 31.97, ["Fly|Ride"] = 97.71, ["Neon"] = 87.62, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 799.12, ["Mega|Ride"] = 532.91, ["Mega|Fly|Ride"] = 584.74}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.82, ["Fly"] = 43.32, ["Ride"] = 24.92, ["Fly|Ride"] = 51.8, ["Neon"] = 21.95, ["Neon|Fly"] = 86.51, ["Neon|Ride"] = 41.48, ["Neon|Fly|Ride"] = 117.18, ["Mega"] = 210, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 285.57}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1049.98, ["Fly"] = 1050, ["Ride"] = 938.44, ["Fly|Ride"] = 945, ["Neon"] = 3183.16, ["Neon|Fly"] = 3380.73, ["Neon|Ride"] = 8759.94, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 288.75, ["Fly"] = 353.7, ["Ride"] = 299.31, ["Fly|Ride"] = 346.6, ["Neon"] = 1314, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1203.43, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 5147.2}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 99.73, ["Fly"] = 174.17, ["Ride"] = 107.66, ["Fly|Ride"] = 131.25, ["Neon"] = 519.04, ["Neon|Ride"] = 418.36, ["Neon|Fly|Ride"] = 567.14, ["Mega"] = 1575, ["Mega|Ride"] = 1773.9, ["Mega|Fly|Ride"] = 1898.73}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 223.13, ["Fly"] = 282.53, ["Ride"] = 219, ["Fly|Ride"] = 240.27, ["Neon"] = 1048.69, ["Neon|Ride"] = 1022.44, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 4152.38}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 16.87, ["Fly"] = 59.14, ["Ride"] = 33.88, ["Fly|Ride"] = 80.07, ["Neon"] = 170.63, ["Neon|Ride"] = 196.02, ["Neon|Fly|Ride"] = 219.01, ["Mega|Ride"] = 774.17, ["Mega|Fly|Ride"] = 1019.33}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 204.75, ["Ride"] = 262.4, ["Fly|Ride"] = 418.69, ["Neon"] = 1095.02, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1099.76, ["Mega"] = 4358.39, ["Mega|Fly|Ride"] = 4980.34}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 91.33, ["Fly"] = 126, ["Ride"] = 91.88, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 1660.95, ["Mega|Ride"] = 2336.73, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2625, ["Ride"] = 2330.19, ["Fly|Ride"] = 2835, ["Neon|Ride"] = 11621.63, ["Neon|Fly|Ride"] = 7481.25, ["Mega"] = 52559.6, ["Mega|Fly|Ride"] = 31210.53}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.49, ["Fly"] = 89.25, ["Ride"] = 49.87, ["Fly|Ride"] = 105, ["Neon"] = 56.43, ["Neon|Fly"] = 173.02, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 153.3, ["Mega"] = 290.71, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 29.19, ["Ride"] = 72.19, ["Fly|Ride"] = 87.62, ["Neon"] = 216.57, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 405.17, ["Mega|Ride"] = 874.92, ["Mega|Fly|Ride"] = 1368.76}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.35, ["Fly"] = 100.21, ["Ride"] = 85.32, ["Fly|Ride"] = 77.18, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2231.25, ["Fly"] = 1660.95, ["Ride"] = 1073.62, ["Fly|Ride"] = 997.48, ["Neon|Ride"] = 5811.02, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 41609.68, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 430.5, ["Fly"] = 873.81, ["Ride"] = 475.25, ["Fly|Ride"] = 534.19, ["Mega"] = 11497.43}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 118.13, ["Ride"] = 119.57, ["Fly|Ride"] = 195.57, ["Neon"] = 453.47, ["Neon|Ride"] = 345.85, ["Neon|Fly|Ride"] = 511.38, ["Mega"] = 2627.99, ["Mega|Ride"] = 2657.03, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.77, ["Ride"] = 21, ["Fly|Ride"] = 63.25, ["Neon"] = 86.63, ["Neon|Ride"] = 65.44, ["Neon|Fly|Ride"] = 133.41, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.93, ["Fly"] = 68.25, ["Ride"] = 51.49, ["Fly|Ride"] = 91.88, ["Neon"] = 162.09, ["Neon|Fly"] = 365.74, ["Neon|Ride"] = 284.71, ["Neon|Fly|Ride"] = 332.49, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 754.59, ["Fly"] = 1145.48, ["Ride"] = 892.5, ["Fly|Ride"] = 859.56, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2229.94, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 662.82}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5381.25, ["Ride"] = 5906.25, ["Fly|Ride"] = 5381.24, ["Neon"] = 42000, ["Neon|Ride"] = 31383.56, ["Neon|Fly|Ride"] = 27405, ["Mega|Fly|Ride"] = 72999.8}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 410.63, ["Ride"] = 348.23, ["Fly|Ride"] = 433.32, ["Neon"] = 1312.5, ["Neon|Fly|Ride"] = 2190, ["Mega"] = 6568.87, ["Mega|Fly|Ride"] = 6569.97}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 94.5, ["Ride"] = 157.4, ["Fly|Ride"] = 133.25, ["Neon"] = 2190, ["Neon|Ride"] = 584.74, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 1971}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.36, ["Fly"] = 73.38, ["Ride"] = 40.69, ["Fly|Ride"] = 91.88, ["Neon"] = 292.38, ["Neon|Ride"] = 174.33, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 664.9, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 14.44, ["Fly"] = 32.82, ["Ride"] = 26.8, ["Fly|Ride"] = 50.12, ["Neon"] = 219.01, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 131.41, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1094.87}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.73, ["Fly"] = 163.47, ["Ride"] = 39.38, ["Fly|Ride"] = 105.91, ["Neon"] = 124.69, ["Neon|Ride"] = 158.81, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.81, ["Fly"] = 29.58, ["Ride"] = 23.63, ["Fly|Ride"] = 49.82, ["Neon"] = 41.2, ["Neon|Fly"] = 361.36, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 136.69, ["Mega"] = 292.35, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 269.62}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.06, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 111.57, ["Neon|Fly"] = 876, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 327.43, ["Mega"] = 630, ["Mega|Ride"] = 730.37, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 608.68, ["Fly"] = 577.5, ["Ride"] = 636.57, ["Fly|Ride"] = 654.94, ["Neon|Ride"] = 2098.69, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 7445.08}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.26, ["Fly"] = 19.59, ["Ride"] = 13.13, ["Fly|Ride"] = 38.07, ["Neon"] = 28.84, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 157.5, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.93, ["Fly"] = 118.12, ["Ride"] = 78.7, ["Fly|Ride"] = 144.37, ["Neon"] = 183.75, ["Neon|Ride"] = 213.29, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 557.82, ["Mega|Fly"] = 876, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.4, ["Ride"] = 815.14, ["Fly|Ride"] = 787.5, ["Neon|Fly"] = 2262.27, ["Neon|Ride"] = 2774.72, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 4517.61}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 33.9, ["Fly"] = 70.86, ["Ride"] = 49.3, ["Fly|Ride"] = 95.82, ["Neon"] = 280.88, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1245.08, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 885.91}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 318.88, ["Fly"] = 386.93, ["Ride"] = 262.49, ["Fly|Ride"] = 328.12, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4650.84}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 273.92, ["Fly"] = 581.47, ["Ride"] = 262.5, ["Fly|Ride"] = 364.88, ["Neon"] = 1093.91, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 4922}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 761.25, ["Ride"] = 737.62, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 3651.82, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.27, ["Fly"] = 63.51, ["Ride"] = 60.38, ["Fly|Ride"] = 107.47, ["Neon"] = 49.88, ["Neon|Fly"] = 298.85, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 350.83, ["Mega|Ride"] = 286.13, ["Mega|Fly|Ride"] = 438}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3346.88, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3517.5, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19556.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 143.07, ["Fly"] = 178.47, ["Ride"] = 146.99, ["Fly|Ride"] = 209.83, ["Neon"] = 530.25, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 581.44, ["Mega"] = 3284.99, ["Mega|Fly|Ride"] = 3431.31}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 31.77, ["Ride"] = 19.53, ["Fly|Ride"] = 43.32, ["Neon"] = 19.69, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.63, ["Neon|Fly|Ride"] = 102.95, ["Mega"] = 217.89, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.05, ["Ride"] = 23.62, ["Fly|Ride"] = 69.16, ["Neon"] = 25.58, ["Neon|Fly"] = 122.03, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 190.32, ["Mega|Ride"] = 394.21, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 49.87, ["Fly"] = 59.14, ["Ride"] = 47.25, ["Fly|Ride"] = 67.24, ["Neon"] = 298.85, ["Neon|Ride"] = 416.12, ["Neon|Fly|Ride"] = 274.17, ["Mega|Fly|Ride"] = 1263.93}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 954.19, ["Fly"] = 1195.34, ["Ride"] = 918.74, ["Fly|Ride"] = 1105.13, ["Neon|Ride"] = 8301.77, ["Neon|Fly|Ride"] = 4970.56}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 9782.67, ["Fly|Ride"] = 7875}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.22, ["Fly"] = 43.32, ["Ride"] = 27.54, ["Fly|Ride"] = 48.95, ["Neon"] = 175.22, ["Neon|Ride"] = 142.79, ["Neon|Fly|Ride"] = 170.5, ["Mega"] = 2520, ["Mega|Ride"] = 880.32, ["Mega|Fly|Ride"] = 811.11}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.44, ["Fly"] = 58.54, ["Ride"] = 28.84, ["Fly|Ride"] = 61.41, ["Neon"] = 123.61, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 90.46, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 97.42, ["Ride"] = 104.81, ["Fly|Ride"] = 156.17, ["Neon|Ride"] = 628.63, ["Neon|Fly|Ride"] = 497.67, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 173.24, ["Fly"] = 1169.62, ["Ride"] = 210, ["Fly|Ride"] = 314.9, ["Neon"] = 1305.94, ["Neon|Ride"] = 1182.84, ["Neon|Fly|Ride"] = 1039.4, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 4321.94}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.9, ["Ride"] = 35.06, ["Fly|Ride"] = 65.63, ["Neon"] = 31.5, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 70.88, ["Mega"] = 139.13, ["Mega|Fly"] = 244.2, ["Mega|Ride"] = 154.61, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 204.99, ["Fly"] = 257.25, ["Ride"] = 146.74, ["Fly|Ride"] = 291.38, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 701.67, ["Mega|Fly|Ride"] = 3048.48}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 17.04, ["Fly|Ride"] = 48.57, ["Neon"] = 24.68, ["Neon|Fly"] = 131.41, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 121.44, ["Mega"] = 224.19, ["Mega|Fly"] = 292.38, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 297.94, ["Fly"] = 354.38, ["Ride"] = 341.23, ["Fly|Ride"] = 360.94, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 5645.22}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 104.98, ["Ride"] = 29.3, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 316.28, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 584.74, ["Mega|Ride"] = 451.16, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 73.38, ["Ride"] = 18.38, ["Neon"] = 7.88, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.56, ["Neon|Fly|Ride"] = 166.85, ["Mega"] = 94.39, ["Mega|Ride"] = 138.23, ["Mega|Fly|Ride"] = 282.68}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.81, ["Mega"] = 23.16, ["Mega|Ride"] = 146.9, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 328.51, ["Fly|Ride"] = 117.18, ["Neon"] = 5.25, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 85.43, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 131.56, ["Mega|Fly|Ride"] = 254.01}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 67.47, ["Fly"] = 173.01, ["Ride"] = 99.03, ["Fly|Ride"] = 190.54, ["Neon"] = 236.25, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1461.6}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.61, ["Ride"] = 16.41, ["Fly|Ride"] = 34.36, ["Neon"] = 5.24, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 58.86, ["Mega"] = 73.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.38, ["Ride"] = 148.93, ["Neon"] = 82.27, ["Neon|Fly"] = 332.46, ["Neon|Ride"] = 314.9, ["Neon|Fly|Ride"] = 365.74, ["Mega"] = 420, ["Mega|Ride"] = 582.56, ["Mega|Fly|Ride"] = 556.88}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 201.49, ["Mega"] = 21.92, ["Mega|Ride"] = 62.47, ["Mega|Fly|Ride"] = 256.1}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.55, ["Ride"] = 16.45, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 43.82, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 42, ["Mega"] = 15.73, ["Mega|Fly"] = 36.92, ["Mega|Ride"] = 21.41, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 14.44, ["Fly|Ride"] = 51.49, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 17.28, ["Neon|Fly|Ride"] = 44.17, ["Mega"] = 18.38, ["Mega|Fly"] = 166.86, ["Mega|Ride"] = 33.64, ["Mega|Fly|Ride"] = 92.75}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 43.82, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 19.29, ["Mega|Ride"] = 109.52, ["Mega|Fly|Ride"] = 248.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.93, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 5.14, ["Neon|Fly"] = 124.84, ["Neon|Ride"] = 23.68, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.94, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.78, ["Neon|Ride"] = 89.06, ["Neon|Fly|Ride"] = 438, ["Mega"] = 20.82, ["Mega|Ride"] = 96.15, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.99, ["Fly"] = 52.49, ["Ride"] = 26.25, ["Fly|Ride"] = 166.86, ["Neon"] = 51.96, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 196.19, ["Mega"] = 236.22, ["Mega|Ride"] = 266.43, ["Mega|Fly|Ride"] = 365.87}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.34, ["Neon|Fly|Ride"] = 208.06, ["Mega"] = 28.24, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 139.22, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Mega"] = 120.63, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 22.98, ["Mega"] = 134.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 146.74, ["Ride"] = 32.82, ["Neon"] = 3.66, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 22.3, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.16, ["Fly|Ride"] = 40.68, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.7, ["Neon|Fly|Ride"] = 50.38, ["Mega"] = 14.31, ["Mega|Fly"] = 21.92, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 53.99}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.13, ["Neon"] = 39.81, ["Neon|Ride"] = 142.37, ["Neon|Fly|Ride"] = 730.37, ["Mega"] = 204.78, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 3.51, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 29.58, ["Mega|Ride"] = 43.6, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.84, ["Neon"] = 17.9, ["Neon|Ride"] = 195.11, ["Mega"] = 106.21, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 80.54, ["Ride"] = 28.87, ["Fly|Ride"] = 48.57, ["Neon"] = 11.47, ["Neon|Ride"] = 51.49, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 166.84, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.54, ["Ride"] = 11.82, ["Fly|Ride"] = 19.72, ["Neon"] = 2.1, ["Neon|Fly"] = 20.4, ["Neon|Ride"] = 13.01, ["Neon|Fly|Ride"] = 42, ["Mega"] = 14.06, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 51.97}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27.43, ["Fly|Ride"] = 52.5, ["Neon"] = 13.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.66, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.51, ["Fly"] = 118.13, ["Ride"] = 117.31, ["Fly|Ride"] = 93.19, ["Neon"] = 73.38, ["Neon|Ride"] = 73.38, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 327.37, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 59.14, ["Ride"] = 14.41, ["Fly|Ride"] = 41.63, ["Neon"] = 2.1, ["Neon|Fly"] = 20.07, ["Neon|Ride"] = 14.94, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 19.72, ["Mega|Fly"] = 51.49, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 87.62}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 182.87, ["Ride"] = 21.92, ["Neon"] = 11.81, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 166.86, ["Mega"] = 52.5, ["Mega|Fly"] = 166.85, ["Mega|Ride"] = 121.55, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 32.82, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 87.62, ["Mega|Fly|Ride"] = 381.29}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.82, ["Fly|Ride"] = 48.55, ["Neon"] = 2.1, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 109.52, ["Mega"] = 17.07, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 73.37, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 24.11, ["Ride"] = 23.63, ["Fly|Ride"] = 55.42, ["Neon"] = 7.53, ["Neon|Fly"] = 59.14, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.23, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 29.58, ["Neon"] = 6.19, ["Neon|Ride"] = 57.75, ["Mega"] = 56.3, ["Mega|Fly"] = 216.68, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 18.69, ["Fly|Ride"] = 34.13, ["Neon"] = 6.45, ["Neon|Fly"] = 78.86, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 59.76, ["Mega"] = 114.19, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 33.64, ["Neon|Fly"] = 188.88, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 657.01}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 21.48, ["Fly|Ride"] = 51.19, ["Neon"] = 6.36, ["Neon|Fly"] = 49.82, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 65.66, ["Mega"] = 106.32, ["Mega|Fly"] = 420, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 18.38, ["Fly|Ride"] = 73.38, ["Neon"] = 9.97, ["Neon|Fly"] = 32.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 219.01, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 141.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 116.08, ["Fly|Ride"] = 146.74, ["Neon"] = 25.05, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 259.88, ["Mega|Ride"] = 328.48}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.19, ["Ride"] = 94.61, ["Neon"] = 94.18, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 57.2, ["Neon|Ride"] = 117.18, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 9.18, ["Ride"] = 72.19, ["Fly|Ride"] = 104.99, ["Neon"] = 52.44, ["Neon|Ride"] = 76.02, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 226.4, ["Mega|Ride"] = 292.35, ["Mega|Fly|Ride"] = 448.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 19.67, ["Mega|Fly"] = 217.91, ["Mega|Ride"] = 131.41, ["Mega|Fly|Ride"] = 248.55}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.25, ["Fly"] = 31.77, ["Ride"] = 22.83, ["Fly|Ride"] = 49.79, ["Neon"] = 45.94, ["Neon|Fly"] = 189, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 283.62, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 270.2}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Neon"] = 6.39, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 27.57, ["Mega|Fly"] = 146.74, ["Mega|Ride"] = 70.09, ["Mega|Fly|Ride"] = 129.55}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.28, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 74.42, ["Mega"] = 34.13, ["Mega|Ride"] = 62.12, ["Mega|Fly|Ride"] = 174.44}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 46.12, ["Ride"] = 16.14, ["Fly|Ride"] = 46.19, ["Neon"] = 7.88, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164.01, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 166.86}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 56.96, ["Ride"] = 32.81, ["Fly|Ride"] = 124.53, ["Neon"] = 48.49, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 232.32, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 335.16}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 18.37, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.18, ["Fly|Ride"] = 65.63, ["Neon"] = 6.36, ["Neon|Fly"] = 115.04, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 98.63, ["Mega"] = 43.82, ["Mega|Fly"] = 146.74, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 135.79}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.31, ["Fly|Ride"] = 53.44, ["Neon"] = 6.17, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 87.62, ["Mega|Fly"] = 146.74, ["Mega|Ride"] = 124.56, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 6.57, ["Fly"] = 91.88, ["Ride"] = 56.96, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 49.54, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 98.43, ["Mega|Ride"] = 154.5, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 109.52, ["Neon|Fly|Ride"] = 160402.99, ["Mega"] = 21.12, ["Mega|Ride"] = 44, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.77, ["Neon"] = 3.24, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.8, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 19.28, ["Mega|Fly"] = 73.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly"] = 49.82, ["Mega"] = 32.82, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.17, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.6, ["Mega|Ride"] = 214.6, ["Mega|Fly|Ride"] = 166.86}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.37, ["Fly|Ride"] = 69.56, ["Neon"] = 3.91, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 18.51, ["Neon|Fly|Ride"] = 48.89, ["Mega"] = 34.13, ["Mega|Ride"] = 59.14, ["Mega|Fly|Ride"] = 111.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 5.25, ["Ride"] = 199.22, ["Fly|Ride"] = 219.01, ["Neon"] = 81.41, ["Neon|Ride"] = 78.75, ["Mega"] = 382.66, ["Mega|Ride"] = 529.99, ["Mega|Fly|Ride"] = 598.02}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 53.81, ["Neon"] = 42.29, ["Neon|Ride"] = 157.5, ["Mega"] = 249.03, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.47, ["Fly|Ride"] = 105, ["Neon"] = 25.71, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 232.32, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 13.02, ["Fly|Ride"] = 37.29, ["Neon"] = 2.1, ["Neon|Fly"] = 19.59, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 29.28, ["Mega"] = 14.82, ["Mega|Ride"] = 27.4, ["Mega|Fly|Ride"] = 58.97}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 61.34, ["Neon"] = 12.31, ["Neon|Fly"] = 69.39, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 730.37, ["Mega"] = 124.84, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.44, ["Mega|Fly"] = 146.74, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.04, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 17.07, ["Mega|Fly"] = 219.24, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 146.74, ["Ride"] = 19.81, ["Fly|Ride"] = 46.65, ["Neon"] = 8.47, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 34.11, ["Neon|Fly|Ride"] = 92.54, ["Mega"] = 153.11, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 226.48, ["Ride"] = 240.19, ["Fly|Ride"] = 864.96, ["Neon|Ride"] = 693, ["Neon|Fly|Ride"] = 969.93, ["Mega"] = 8759.94, ["Mega|Fly|Ride"] = 3385.73}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.51, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.68, ["Ride"] = 25.22, ["Fly|Ride"] = 65.63, ["Neon"] = 28.48, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 175.22, ["Mega"] = 391.13, ["Mega|Ride"] = 327.43, ["Mega|Fly|Ride"] = 350.41}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 14.33, ["Fly|Ride"] = 36.75, ["Neon"] = 4.55, ["Neon|Fly"] = 33.97, ["Neon|Ride"] = 26.44, ["Neon|Fly|Ride"] = 58.03, ["Mega"] = 49.77, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 146.74}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 73.05, ["Ride"] = 19.69, ["Fly|Ride"] = 139.65, ["Neon"] = 10.49, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 117.18, ["Mega"] = 87.57, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 26.84, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 32.7, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 973.46, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 254.7, ["Neon"] = 58, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 259.87, ["Mega|Ride"] = 323.04, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 24.91, ["Ride"] = 16.34, ["Fly|Ride"] = 34.13, ["Neon"] = 35.06, ["Neon|Fly"] = 129.09, ["Neon|Ride"] = 26.31, ["Neon|Fly|Ride"] = 84.62, ["Mega"] = 262.5, ["Mega|Ride"] = 379.98, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 73.47, ["Ride"] = 86.58, ["Fly|Ride"] = 149.42, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 392.04, ["Neon|Fly|Ride"] = 411.18, ["Mega|Fly|Ride"] = 1468.59}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 240.09, ["Fly"] = 438, ["Ride"] = 234.94, ["Fly|Ride"] = 210, ["Neon|Ride"] = 1162.92, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 13139.91, ["Mega|Fly|Ride"] = 3651.82}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 109.51, ["Ride"] = 67.27, ["Fly|Ride"] = 101.88, ["Neon"] = 498.04, ["Neon|Fly"] = 374.94, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 321.57, ["Mega|Fly|Ride"] = 1182.82}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.5, ["Fly"] = 288.41, ["Ride"] = 26.25, ["Fly|Ride"] = 122.04, ["Neon"] = 17.06, ["Neon|Ride"] = 98.57, ["Neon|Fly|Ride"] = 154.07, ["Mega"] = 238.88, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 12.48, ["Fly"] = 43.32, ["Ride"] = 30.03, ["Fly|Ride"] = 65.63, ["Neon"] = 55.84, ["Neon|Ride"] = 101.98, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.9, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.09, ["Ride"] = 18.26, ["Fly|Ride"] = 51.35, ["Neon"] = 4.29, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.86, ["Mega"] = 40.69, ["Mega|Fly"] = 151.91, ["Mega|Ride"] = 82.15, ["Mega|Fly|Ride"] = 566.53}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.4, ["Fly"] = 70.09, ["Ride"] = 32.81, ["Fly|Ride"] = 67.26, ["Neon"] = 108.42, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 116.08, ["Neon|Fly|Ride"] = 310.8, ["Mega"] = 525.61, ["Mega|Ride"] = 565.29, ["Mega|Fly|Ride"] = 542.04}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.75, ["Fly|Ride"] = 38.07, ["Neon"] = 19.66, ["Neon|Fly"] = 52.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 92.15, ["Mega"] = 144.23, ["Mega|Ride"] = 270.3, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Fly"] = 39.43, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 28.48, ["Neon|Ride"] = 117.18, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 14.43, ["Mega|Ride"] = 30.34, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 19.13, ["Fly|Ride"] = 44.63, ["Neon"] = 10.5, ["Neon|Fly"] = 109.52, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly"] = 109.52, ["Mega|Ride"] = 131.41, ["Mega|Fly|Ride"] = 217.23}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 61.43, ["Ride"] = 22.28, ["Fly|Ride"] = 78.82, ["Neon"] = 23.33, ["Neon|Ride"] = 42, ["Mega"] = 144.37, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 271.58}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105, ["Fly"] = 181.79, ["Ride"] = 157.5, ["Fly|Ride"] = 199.94, ["Neon"] = 406.88, ["Neon|Ride"] = 515.23, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 2490.16, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 3.82, ["Ride"] = 240.93, ["Fly|Ride"] = 131.25, ["Neon"] = 35.43, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.81, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 15.74, ["Fly|Ride"] = 62.87, ["Neon"] = 15.65, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.94, ["Ride"] = 39.38, ["Fly|Ride"] = 170.63, ["Neon"] = 99.29, ["Neon|Ride"] = 166.86, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 513.34, ["Mega|Fly"] = 876, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 873.81}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.85}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 98.57, ["Fly|Ride"] = 130.32, ["Neon"] = 59.07, ["Neon|Ride"] = 94.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 498.16, ["Mega|Ride"] = 641.67, ["Mega|Fly|Ride"] = 876}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.13, ["Fly"] = 28.34, ["Ride"] = 26.57, ["Fly|Ride"] = 55.01, ["Neon"] = 90.57, ["Neon|Fly"] = 131.41, ["Neon|Ride"] = 140.18, ["Neon|Fly|Ride"] = 150.91, ["Mega"] = 1413.65, ["Mega|Fly|Ride"] = 589.99}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.39, ["Neon|Ride"] = 44.6, ["Neon|Fly|Ride"] = 139.08, ["Mega"] = 29.39, ["Mega|Fly"] = 189, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 236.51}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.55, ["Fly"] = 26.22, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 65.71, ["Mega"] = 288.62, ["Mega|Fly"] = 415.87, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 525.61}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 19.69, ["Fly|Ride"] = 40.6, ["Neon"] = 16.29, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.84, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 146.74, ["Mega|Ride"] = 223.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.83, ["Neon|Fly"] = 278.15, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 59.14, ["Mega"] = 74.82, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 25.14, ["Fly"] = 105, ["Ride"] = 79.71, ["Fly|Ride"] = 104.99, ["Neon"] = 181.25, ["Neon|Ride"] = 246.39, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 856.3, ["Mega|Fly"] = 656.36, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 210, ["Neon"] = 95.27, ["Neon|Ride"] = 84.62, ["Mega|Ride"] = 328.51}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 21.48, ["Fly|Ride"] = 43.82, ["Neon"] = 9.19, ["Neon|Fly"] = 87.62, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 109.51, ["Mega"] = 120.1, ["Mega|Ride"] = 142.79, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 145.01, ["Ride"] = 129.23, ["Neon"] = 438, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 540.28, ["Mega"] = 4650.41, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2385.59}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.4, ["Fly"] = 46.61, ["Ride"] = 18.38, ["Fly|Ride"] = 57.28, ["Neon"] = 29.58, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 144.56, ["Mega"] = 262.49, ["Mega|Ride"] = 236.34, ["Mega|Fly|Ride"] = 326.41}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.7, ["Fly"] = 143.07, ["Ride"] = 118.12, ["Fly|Ride"] = 219.01, ["Neon"] = 262.4, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 373.56, ["Mega"] = 1076.25, ["Mega|Ride"] = 1600.89, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.8, ["Ride"] = 57.75, ["Fly|Ride"] = 167.62, ["Neon"] = 77.84, ["Neon|Ride"] = 106.46, ["Neon|Fly|Ride"] = 214.8, ["Mega"] = 349.52, ["Mega|Ride"] = 358.92, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.24, ["Fly"] = 39.38, ["Ride"] = 26.3, ["Fly|Ride"] = 72.43, ["Neon"] = 102.95, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 664.9, ["Mega|Ride"] = 1642.5, ["Mega|Fly|Ride"] = 642.77}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.58, ["Ride"] = 61.48, ["Fly|Ride"] = 200.11, ["Neon"] = 43.31, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 468.84, ["Mega|Fly"] = 533.28, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 424.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.56, ["Ride"] = 43.51, ["Fly|Ride"] = 77.18, ["Neon"] = 39.46, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 147.92, ["Mega"] = 223.13, ["Mega|Ride"] = 292.22, ["Mega|Fly|Ride"] = 448.33}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 102.95, ["Neon|Ride"] = 87.62, ["Mega"] = 18.52, ["Mega|Ride"] = 146.74}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.93, ["Ride"] = 70.09, ["Fly|Ride"] = 325.9, ["Neon"] = 43.31, ["Neon|Ride"] = 243.1, ["Mega"] = 239.55, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 759.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 130.32, ["Ride"] = 29.58, ["Neon"] = 19.69, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 250.04, ["Mega|Ride"] = 424.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.98, ["Ride"] = 32.8, ["Neon"] = 17.07, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 557.82, ["Fly|Ride"] = 603.74, ["Neon"] = 2189.74, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.96, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 64.32, ["Neon"] = 42.72, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.24, ["Mega"] = 204.78, ["Mega|Ride"] = 382.26, ["Mega|Fly|Ride"] = 363.53}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.13, ["Fly"] = 65.6, ["Ride"] = 21.29, ["Fly|Ride"] = 55.21, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 331.87, ["Mega|Ride"] = 400.78, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 25.19, ["Fly|Ride"] = 50.79, ["Neon"] = 17.51, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 262.81}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.36, ["Fly|Ride"] = 90.57, ["Neon"] = 8.65, ["Neon|Ride"] = 32.87, ["Neon|Fly|Ride"] = 164.27, ["Mega"] = 99.65, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 219.26}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 21, ["Neon"] = 2.57, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 199.23, ["Mega"] = 21.95, ["Mega|Ride"] = 83.45, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.12}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.79, ["Ride"] = 59.12, ["Fly|Ride"] = 182.77, ["Neon"] = 46.55, ["Neon|Ride"] = 73.38, ["Neon|Fly|Ride"] = 367.32, ["Mega"] = 334.69, ["Mega|Ride"] = 367.32, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.44, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1022.74, ["Mega"] = 39.38, ["Mega|Ride"] = 87.62, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.72, ["Fly"] = 335.13, ["Ride"] = 99.25, ["Fly|Ride"] = 146.74, ["Neon"] = 40.69, ["Neon|Ride"] = 112.08, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 266.72, ["Mega|Ride"] = 363.64, ["Mega|Fly|Ride"] = 496.8}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.51, ["Ride"] = 446.25, ["Fly|Ride"] = 535.49, ["Neon"] = 1718.24, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1311.45, ["Mega"] = 8212.44, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.63, ["Fly"] = 196.88, ["Ride"] = 40.69, ["Fly|Ride"] = 131.41, ["Neon"] = 72.27, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 199.23, ["Mega"] = 306.57, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 525.61}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 97.14, ["Ride"] = 35.63, ["Fly|Ride"] = 118.11, ["Neon"] = 3.94, ["Neon|Ride"] = 31.1, ["Neon|Fly|Ride"] = 98.56, ["Mega"] = 39.38, ["Mega|Fly"] = 117.18, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 438}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 96.87, ["Neon"] = 3.13, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 27.56, ["Mega|Ride"] = 87.62, ["Mega|Fly|Ride"] = 437.96}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 30.06, ["Fly"] = 115.64, ["Ride"] = 106.81, ["Fly|Ride"] = 175.22, ["Neon"] = 131.25, ["Neon|Fly"] = 167.07, ["Neon|Ride"] = 436.92, ["Neon|Fly|Ride"] = 441.31, ["Mega"] = 700.72, ["Mega|Ride"] = 713.88, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.66, ["Neon"] = 97.76, ["Neon|Ride"] = 143.46, ["Neon|Fly|Ride"] = 876, ["Mega"] = 581.47, ["Mega|Ride"] = 483, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 2.1, ["Ride"] = 76.13, ["Fly|Ride"] = 230.47, ["Neon"] = 101.07, ["Neon|Ride"] = 175.22, ["Mega"] = 681.02, ["Mega|Ride"] = 648.25, ["Mega|Fly|Ride"] = 1200.72}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 14.44, ["Ride"] = 56.36, ["Fly|Ride"] = 231.53, ["Neon"] = 131.25, ["Neon|Ride"] = 173.95, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 722.71, ["Mega|Ride"] = 803.74, ["Mega|Fly|Ride"] = 647.53}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.81, ["Fly|Ride"] = 744.61, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.46, ["Ride"] = 60.27, ["Fly|Ride"] = 147.07, ["Neon"] = 85.31, ["Neon|Ride"] = 196.17, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.85, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 31.5, ["Neon|Ride"] = 146.74, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 45.85, ["Ride"] = 144.99, ["Fly|Ride"] = 452.82, ["Neon"] = 169.31, ["Neon|Ride"] = 258.16, ["Neon|Fly|Ride"] = 547.53, ["Mega"] = 383.32, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 624.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 72.19, ["Fly|Ride"] = 219.01, ["Neon"] = 7.59, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 283.62, ["Mega"] = 51.48, ["Mega|Ride"] = 175.22, ["Mega|Fly|Ride"] = 281.42}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.76, ["Ride"] = 97.76, ["Neon"] = 262.42, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1587.75, ["Mega|Ride"] = 2899.56, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 108.42, ["Ride"] = 28.24, ["Neon"] = 9.65, ["Neon|Fly"] = 190.54, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 72.16, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 206.98}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.49, ["Fly|Ride"] = 102.13, ["Neon"] = 3.72, ["Neon|Fly"] = 59.14, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 41.99, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 70.6, ["Mega|Fly|Ride"] = 292.35}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 24.92, ["Fly|Ride"] = 133.23, ["Neon"] = 11.81, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 166.87, ["Mega"] = 89.25, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 64.1, ["Fly"] = 105, ["Ride"] = 73.49, ["Fly|Ride"] = 151.91, ["Neon"] = 300.57, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 498.04, ["Mega|Ride"] = 1146.48, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.6, ["Ride"] = 33.64, ["Neon"] = 22.22, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 82.6, ["Mega|Ride"] = 217.91, ["Mega|Fly|Ride"] = 375.6}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 73.38, ["Ride"] = 22.31, ["Neon"] = 8.44, ["Neon|Ride"] = 78.75, ["Mega"] = 53.85, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 109.52, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 166.86, ["Mega"] = 348.23, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 6.34, ["Fly"] = 78.75, ["Ride"] = 59.18, ["Fly|Ride"] = 154.87, ["Neon"] = 32.81, ["Neon|Ride"] = 69.91, ["Neon|Fly|Ride"] = 182.33, ["Mega"] = 191.63, ["Mega|Ride"] = 216.79, ["Mega|Fly|Ride"] = 464.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.18, ["Neon|Ride"] = 100.75, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 43.13, ["Mega|Ride"] = 117.18, ["Mega|Fly|Ride"] = 292.38}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.34, ["Fly|Ride"] = 62.86, ["Neon"] = 4.27, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 101.41, ["Mega"] = 41.98, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 260.8}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 21.92, ["Fly|Ride"] = 57.74, ["Neon"] = 18.1, ["Neon|Fly"] = 104.05, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 117.16, ["Mega"] = 166.87, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 293.35}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 24.94, ["Fly"] = 73.38, ["Ride"] = 29.08, ["Fly|Ride"] = 82.14, ["Neon"] = 144.37, ["Neon|Ride"] = 38.34, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 485.63, ["Mega|Fly"] = 438, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 664.9}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.98, ["Ride"] = 90.56, ["Fly|Ride"] = 146.62, ["Neon"] = 363.83, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2175.77, ["Mega|Ride"] = 1970.77, ["Mega|Fly|Ride"] = 1515.32}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.51, ["Fly|Ride"] = 170.63, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 35.25, ["Mega|Fly"] = 672, ["Mega|Ride"] = 94.18, ["Mega|Fly|Ride"] = 257.34}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.53, ["Ride"] = 15.65, ["Fly|Ride"] = 43.72, ["Neon"] = 2.43, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 40.69, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.94, ["Fly"] = 43.82, ["Ride"] = 38.03, ["Fly|Ride"] = 109.52, ["Neon"] = 40.68, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 555.18, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 613.14, ["Fly|Ride"] = 584.07, ["Neon"] = 4379.99, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.99, ["Fly"] = 104.05, ["Ride"] = 47.24, ["Fly|Ride"] = 137.15, ["Neon"] = 150.47, ["Neon|Ride"] = 241.98, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 720.57, ["Mega|Ride"] = 851.91, ["Mega|Fly|Ride"] = 915.43}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.5, ["Fly|Ride"] = 91.87, ["Neon"] = 7.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 85.22, ["Mega"] = 67.26, ["Mega|Ride"] = 128.54, ["Mega|Fly|Ride"] = 292.38}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 90.04, ["Ride"] = 63.66, ["Fly|Ride"] = 261.98, ["Neon"] = 73.38, ["Mega"] = 166.69}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.99, ["Fly"] = 169.32, ["Ride"] = 47.16, ["Fly|Ride"] = 78.75, ["Neon"] = 194.25, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 266.49, ["Mega"] = 2627.99, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.94, ["Ride"] = 128.63, ["Fly|Ride"] = 186.51, ["Neon"] = 434.44, ["Neon|Fly"] = 832.2, ["Neon|Ride"] = 542.04, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3212.72, ["Mega|Fly|Ride"] = 2553.53}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 250.59, ["Ride"] = 304.49, ["Fly|Ride"] = 429.26, ["Neon"] = 913.9, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.8, ["Ride"] = 58.5, ["Fly|Ride"] = 246.91, ["Neon"] = 80.56, ["Neon|Ride"] = 88.27, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 871.5, ["Mega|Ride"] = 404.41, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 16.42, ["Fly|Ride"] = 38.85, ["Neon"] = 7.08, ["Neon|Ride"] = 27.41, ["Neon|Fly|Ride"] = 65.71, ["Mega"] = 78.65, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.5, ["Fly"] = 50.38, ["Ride"] = 22.31, ["Fly|Ride"] = 45.94, ["Neon"] = 26.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 97.12, ["Mega"] = 291.36, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 350.41}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 282.97, ["Ride"] = 374.07, ["Fly|Ride"] = 787.32, ["Neon"] = 1470.67, ["Mega"] = 10949.92, ["Mega|Fly|Ride"] = 6037.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.97, ["Neon"] = 15.74, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 36.49, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 448.95}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 17.06, ["Fly|Ride"] = 43.14, ["Neon"] = 24.03, ["Neon|Ride"] = 39.43, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 162.09, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 217.89}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.89, ["Fly"] = 6562.5, ["Ride"] = 57.29, ["Neon"] = 86.94, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 83.13, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 557.82, ["Mega|Ride"] = 581.4, ["Mega|Fly|Ride"] = 730.37}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 120.64, ["Fly"] = 78.75, ["Ride"] = 154.1, ["Fly|Ride"] = 182.87, ["Neon|Ride"] = 830.49, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2920.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.36, ["Fly"] = 39.29, ["Ride"] = 27.95, ["Fly|Ride"] = 56.44, ["Neon"] = 103.95, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 147, ["Mega"] = 875.44, ["Mega|Ride"] = 401.49, ["Mega|Fly|Ride"] = 489.83}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 38.2, ["Neon"] = 3.5, ["Neon|Ride"] = 65.63, ["Mega"] = 26.2, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 15.75, ["Fly|Ride"] = 86.16, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 23.55, ["Mega|Fly"] = 102.95, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 218.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.98, ["Fly"] = 103.28, ["Ride"] = 84.6, ["Fly|Ride"] = 269.38, ["Neon"] = 38.75, ["Neon|Ride"] = 100.69, ["Neon|Fly|Ride"] = 221.06, ["Mega"] = 167.23, ["Mega|Ride"] = 237.46, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.24, ["Ride"] = 1168.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 3543.75, ["Neon|Ride"] = 4379.99, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 393.74, ["Ride"] = 525, ["Fly|Ride"] = 540.53, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 15329.89, ["Mega|Fly|Ride"] = 6131.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 311.07, ["Fly"] = 420.86, ["Ride"] = 361.43, ["Fly|Ride"] = 438.38, ["Neon"] = 759.94, ["Neon|Fly"] = 876, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 724.5, ["Mega|Ride"] = 3651.82, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 246.88, ["Fly"] = 288.75, ["Ride"] = 284.82, ["Fly|Ride"] = 350.44, ["Neon"] = 654.89, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 663.5, ["Mega|Fly|Ride"] = 3603.64}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 43.81, ["Ride"] = 20.62, ["Fly|Ride"] = 49.87, ["Neon"] = 5.15, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 109.52, ["Mega"] = 59.57, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 286.13, ["Fly"] = 1460.73, ["Ride"] = 341.25, ["Fly|Ride"] = 375.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1453.07, ["Neon|Fly|Ride"] = 1661.63, ["Mega"] = 22192.21, ["Mega|Ride"] = 6278.7, ["Mega|Fly|Ride"] = 4021.2}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.56, ["Fly"] = 183.74, ["Ride"] = 26.25, ["Neon"] = 28.76, ["Neon|Fly|Ride"] = 291.29, ["Mega"] = 229.69, ["Mega|Ride"] = 350.37, ["Mega|Fly|Ride"] = 830.02}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.56, ["Ride"] = 13.13, ["Fly|Ride"] = 35.94, ["Neon"] = 6.42, ["Neon|Ride"] = 54.77, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 131.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93, ["Mega"] = 22.32, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 43.31, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 764.5}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8301.27, ["Ride"] = 22.32, ["Fly|Ride"] = 68.25, ["Neon"] = 18.57, ["Mega"] = 363.55, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 29.58, ["Neon"] = 2.48, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.69, ["Mega|Ride"] = 166.85, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 87.62, ["Ride"] = 66.26, ["Fly|Ride"] = 91.88, ["Neon"] = 25.88, ["Neon|Fly"] = 109.52, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 212.94, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.08, ["Fly"] = 21.92, ["Ride"] = 18.37, ["Fly|Ride"] = 52.5, ["Neon"] = 162.09, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 242.01, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.67, ["Ride"] = 38.07, ["Fly|Ride"] = 166.86, ["Neon"] = 59.07, ["Neon|Ride"] = 175.22, ["Neon|Fly|Ride"] = 332.46, ["Mega"] = 524.99, ["Mega|Ride"] = 565.29}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6641.23, ["Ride"] = 24.7, ["Fly|Ride"] = 190.32, ["Neon"] = 65.63, ["Neon|Ride"] = 215.41, ["Neon|Fly|Ride"] = 747.07, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 563.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 71.31, ["Ride"] = 15.86, ["Fly|Ride"] = 42.94, ["Neon"] = 4.34, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.77, ["Mega"] = 47.25, ["Mega|Fly|Ride"] = 249.04}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 201.2, ["Fly"] = 242.01, ["Ride"] = 190.31, ["Fly|Ride"] = 196.88, ["Neon"] = 876, ["Neon|Ride"] = 1046.82, ["Neon|Fly|Ride"] = 1458.55, ["Mega"] = 8759.94, ["Mega|Fly|Ride"] = 4482.32}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.22, ["Ride"] = 17.54, ["Fly|Ride"] = 29.57, ["Neon"] = 2.63, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 54.77, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.5, ["Ride"] = 44.31, ["Fly|Ride"] = 234.35, ["Neon"] = 64.31, ["Neon|Ride"] = 117.05, ["Neon|Fly|Ride"] = 767.54, ["Mega"] = 365.74, ["Mega|Ride"] = 309.1, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.56, ["Ride"] = 85.43, ["Fly|Ride"] = 183.75, ["Neon"] = 216.55, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 780.13, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 220.4, ["Fly"] = 274.36, ["Ride"] = 238.05, ["Fly|Ride"] = 350.44, ["Neon"] = 830.49, ["Neon|Fly"] = 1661.01, ["Neon|Ride"] = 711.38, ["Neon|Fly|Ride"] = 732.12, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 18.38, ["Fly"] = 133.25, ["Ride"] = 166.85, ["Neon"] = 141.38, ["Neon|Ride"] = 190.54, ["Neon|Fly|Ride"] = 438, ["Mega"] = 281.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 433.63}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 4.29, ["Ride"] = 58.45, ["Fly|Ride"] = 147.9, ["Neon"] = 166.87, ["Neon|Fly"] = 166.86, ["Neon|Ride"] = 327.43, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 1751.99, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 730.29}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 950.25, ["Fly"] = 1790.44, ["Ride"] = 931.88, ["Fly|Ride"] = 1028.99, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 17517.81}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 2.5, ["Fly"] = 28.88, ["Ride"] = 19.66, ["Fly|Ride"] = 45.93, ["Neon"] = 49.63, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 249.03, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.1, ["Fly"] = 262.5, ["Ride"] = 41.14, ["Fly|Ride"] = 135.19, ["Neon"] = 32.82, ["Neon|Ride"] = 124.52, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 332.07, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 87.62, ["Ride"] = 29.09, ["Fly|Ride"] = 81.05, ["Neon"] = 11.46, ["Neon|Ride"] = 50.38, ["Neon|Fly|Ride"] = 73.38, ["Mega"] = 81.23, ["Mega|Ride"] = 365.74, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.33, ["Ride"] = 35.34, ["Fly|Ride"] = 124.83, ["Neon"] = 65.62, ["Neon|Ride"] = 123.26, ["Neon|Fly|Ride"] = 146.73, ["Mega"] = 446.25, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 461.76}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.99, ["Fly|Ride"] = 43.22, ["Neon"] = 19.28, ["Neon|Fly"] = 41.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 73.38, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 184.53}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 15.65, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 50.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 152.14, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 336.17, ["Fly|Ride"] = 438, ["Neon"] = 1203.43, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3486.21}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 27.57, ["Fly|Ride"] = 105.59, ["Neon"] = 7.88, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 73.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 341.19}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 65.61, ["Fly|Ride"] = 88.86, ["Neon"] = 18.22, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 350.41}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 39.38, ["Neon"] = 10.27, ["Neon|Ride"] = 50.93, ["Neon|Fly|Ride"] = 105.13, ["Mega"] = 100.95, ["Mega|Ride"] = 135.06, ["Mega|Fly|Ride"] = 437.96}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 77.87, ["Ride"] = 131.06, ["Fly|Ride"] = 260.4, ["Neon"] = 306.69, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 538.75, ["Mega"] = 2627.99, ["Mega|Ride"] = 1530.82, ["Mega|Fly|Ride"] = 1575.71}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.8, ["Fly"] = 89.87, ["Ride"] = 52.5, ["Fly|Ride"] = 282.59, ["Neon"] = 103.93, ["Neon|Ride"] = 437.75, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.55, ["Fly"] = 258.17, ["Ride"] = 39.38, ["Fly|Ride"] = 116.08, ["Neon"] = 95.09, ["Neon|Ride"] = 114.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 584.74, ["Mega|Ride"] = 454.88, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 6.48, ["Ride"] = 44.14, ["Neon"] = 20.98, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 146.73}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 45.93, ["Fly"] = 95.82, ["Ride"] = 78.66, ["Fly|Ride"] = 155.93, ["Neon"] = 323.01, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 290.05, ["Mega|Fly|Ride"] = 1151.07}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.92, ["Fly|Ride"] = 105, ["Neon"] = 6.19, ["Neon|Fly|Ride"] = 130.32, ["Mega"] = 91.88, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.83, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 69.57, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 166.86, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 393.12, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.47, ["Fly"] = 203.42, ["Ride"] = 87.49, ["Fly|Ride"] = 131.25, ["Neon"] = 275.63, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 351.75, ["Mega|Ride"] = 1497.97, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.74, ["Ride"] = 16.11, ["Fly|Ride"] = 52.57, ["Neon"] = 2.61, ["Neon|Fly"] = 25.19, ["Neon|Ride"] = 19.01, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 19.67, ["Mega|Ride"] = 40.95, ["Mega|Fly|Ride"] = 78.43}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.94, ["Fly"] = 105, ["Ride"] = 29.58, ["Fly|Ride"] = 64.97, ["Neon"] = 16.44, ["Neon|Ride"] = 43.82, ["Neon|Fly|Ride"] = 168, ["Mega"] = 162.99, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.11, ["Ride"] = 41.91, ["Fly|Ride"] = 117.18, ["Neon"] = 118.23, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 270.27, ["Mega"] = 716.16, ["Mega|Ride"] = 432.04, ["Mega|Fly|Ride"] = 565.03}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 16.45, ["Neon"] = 2.1, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 98.18, ["Mega"] = 22.2, ["Mega|Ride"] = 54.77, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 31.17, ["Fly"] = 210, ["Ride"] = 72.19, ["Fly|Ride"] = 282.98, ["Neon"] = 162.61, ["Neon|Ride"] = 280.47, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 744.52, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 744.61, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 7.69, ["Fly"] = 43.82, ["Ride"] = 26.48, ["Fly|Ride"] = 101.07, ["Neon"] = 238.72, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 168.65, ["Mega"] = 468.67, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.17, ["Ride"] = 61.71, ["Neon"] = 57.83, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 83.44, ["Neon|Fly|Ride"] = 216.83, ["Mega"] = 246.75, ["Mega|Ride"] = 368.89, ["Mega|Fly|Ride"] = 498.04}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.24, ["Fly"] = 73.38, ["Ride"] = 84.09, ["Fly|Ride"] = 259.88, ["Neon"] = 43.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 287.44, ["Mega|Ride"] = 438, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 37.25, ["Fly|Ride"] = 196.88, ["Neon"] = 10.04, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.38, ["Mega"] = 69.56, ["Mega|Fly"] = 218.99, ["Mega|Ride"] = 85.78, ["Mega|Fly|Ride"] = 292.38}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 87.55, ["Neon"] = 3.03, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 166.86, ["Mega"] = 57.74, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 260.8}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 43.22, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 97.09, ["Neon"] = 196.88, ["Neon|Ride"] = 219.01, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 830.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 85.32, ["Ride"] = 65.63, ["Fly|Ride"] = 109.52, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 24.88, ["Mega|Ride"] = 175.22, ["Mega|Fly|Ride"] = 328.51}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 498.74, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 3941.98, ["Mega"] = 13139.91, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 16.45, ["Fly|Ride"] = 58.27, ["Neon"] = 72.86, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 117.05, ["Mega"] = 332.46, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 642.77}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.1, ["Ride"] = 19.58, ["Fly|Ride"] = 46.73, ["Neon"] = 13.13, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.07, ["Mega|Fly"] = 190.54, ["Mega|Ride"] = 166.86, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.97, ["Ride"] = 52.49, ["Fly|Ride"] = 584.74, ["Neon"] = 114.45, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 511.38, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 43.82, ["Ride"] = 38.57, ["Fly|Ride"] = 73.38, ["Neon"] = 46.5, ["Neon|Fly"] = 73.38, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 291.29, ["Mega|Fly|Ride"] = 511.38}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 5.25, ["Ride"] = 32.39, ["Fly|Ride"] = 196.88, ["Neon"] = 78.75, ["Neon|Ride"] = 99.65, ["Neon|Fly|Ride"] = 144.56, ["Mega"] = 542.04, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 642.77}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.38, ["Ride"] = 21, ["Fly|Ride"] = 102.95, ["Neon"] = 34.01, ["Neon|Fly"] = 105, ["Neon|Ride"] = 99.38, ["Neon|Fly|Ride"] = 282.53, ["Mega"] = 207.93, ["Mega|Ride"] = 367.32, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 48.58, ["Ride"] = 16.44, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 37.24, ["Mega"] = 15.59, ["Mega|Fly"] = 67.26, ["Mega|Ride"] = 31.47, ["Mega|Fly|Ride"] = 76.04}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.01, ["Fly"] = 55.85, ["Ride"] = 56.43, ["Fly|Ride"] = 109.52, ["Neon"] = 72.1, ["Neon|Fly"] = 124.52, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.18, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 423.78}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.4, ["Ride"] = 269.07, ["Fly|Ride"] = 489.57, ["Neon"] = 1294.92, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 1013.25, ["Mega"] = 4979.1, ["Mega|Ride"] = 9662.2, ["Mega|Fly|Ride"] = 4514.66}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.49, ["Ride"] = 104.97, ["Fly|Ride"] = 260.63, ["Neon"] = 458.07, ["Neon|Fly"] = 937.33, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 1606.37, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 18.69, ["Fly|Ride"] = 56.96, ["Neon"] = 7.54, ["Neon|Fly"] = 102.95, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 59.14, ["Mega|Fly"] = 217.91, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 248.73}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.69, ["Fly|Ride"] = 38.07, ["Neon"] = 7.55, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 67.75, ["Mega|Fly"] = 292.38, ["Mega|Ride"] = 102.17, ["Mega|Fly|Ride"] = 150.52}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 102.95, ["Ride"] = 22.3, ["Fly|Ride"] = 98.44, ["Neon"] = 116.82, ["Neon|Ride"] = 52.27, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 445.66, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 196.88, ["Ride"] = 234.94, ["Fly|Ride"] = 322.88, ["Neon"] = 1204.5, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8759.94, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.44, ["Fly|Ride"] = 49.82, ["Neon"] = 20.25, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 328.51}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.6, ["Ride"] = 78.75, ["Fly|Ride"] = 196.87, ["Neon"] = 30.82, ["Neon|Ride"] = 111.7, ["Mega"] = 248.55, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 438}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Ride"] = 137.82, ["Mega"] = 120.75, ["Mega|Ride"] = 336.17}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.39, ["Fly"] = 58.12, ["Ride"] = 23.39, ["Fly|Ride"] = 55.85, ["Neon"] = 88.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 367.5, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.07, ["Ride"] = 87.61, ["Fly|Ride"] = 262.5, ["Neon"] = 112.17, ["Neon|Fly"] = 656.04, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 459.37, ["Mega|Fly"] = 2299.5, ["Mega|Ride"] = 526.42, ["Mega|Fly|Ride"] = 626.63}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.87, ["Fly"] = 102.95, ["Ride"] = 51.17, ["Fly|Ride"] = 118.12, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.93, ["Neon|Fly|Ride"] = 201.47, ["Mega"] = 876, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 16.4, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 18.16, ["Mega|Fly"] = 43.31, ["Mega|Ride"] = 39.34, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 212.09, ["Ride"] = 248.07, ["Fly|Ride"] = 330.75, ["Neon"] = 3487.07, ["Neon|Ride"] = 1270.2, ["Neon|Fly|Ride"] = 1387.37, ["Mega|Fly|Ride"] = 5255.97}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.88, ["Fly"] = 101.18, ["Ride"] = 24.94, ["Fly|Ride"] = 109.33, ["Neon"] = 76.39, ["Neon|Ride"] = 142.41, ["Neon|Fly|Ride"] = 454.44, ["Mega"] = 385.87, ["Mega|Ride"] = 497.14, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 37.25, ["Ride"] = 19.03, ["Fly|Ride"] = 59.07, ["Neon"] = 6.15, ["Neon|Fly"] = 38.58, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 45.94, ["Mega|Fly"] = 234.35, ["Mega|Ride"] = 87.62, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 24.11, ["Fly|Ride"] = 87.62, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 112.08, ["Mega"] = 27.57, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 194.83}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 37.59, ["Fly|Ride"] = 98.44, ["Neon"] = 16.45, ["Neon|Fly"] = 747.07, ["Neon|Ride"] = 33.62, ["Neon|Fly|Ride"] = 98.57, ["Mega"] = 155.54, ["Mega|Ride"] = 163.11, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6.12, ["Fly"] = 47.23, ["Ride"] = 19.67, ["Fly|Ride"] = 69.57, ["Neon"] = 47.25, ["Neon|Fly"] = 248.57, ["Neon|Ride"] = 48.12, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 395.16}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.04, ["Ride"] = 32.81, ["Neon"] = 43.09, ["Neon|Ride"] = 151.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 59.14, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 117.18, ["Mega"] = 19.69, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 190.53}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 4.87, ["Fly"] = 83.99, ["Ride"] = 32.87, ["Fly|Ride"] = 146.74, ["Neon"] = 39.38, ["Neon|Fly"] = 146.64, ["Neon|Ride"] = 58.64, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 174.57, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 21.92, ["Ride"] = 31.48, ["Neon"] = 3.93, ["Neon|Fly"] = 117.18, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 29.58, ["Mega|Ride"] = 123.76, ["Mega|Fly|Ride"] = 323.04}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 57.24, ["Ride"] = 19.2, ["Fly|Ride"] = 45.94, ["Neon"] = 3.75, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 121.55, ["Mega"] = 45.94, ["Mega|Ride"] = 119.34, ["Mega|Fly|Ride"] = 284.53}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 636.69, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3486.36, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 14.96, ["Neon|Fly"] = 43.82, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly|Ride"] = 332.46}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.48, ["Neon"] = 8.6, ["Neon|Fly"] = 37.17, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 89.93, ["Mega|Fly"] = 166.87, ["Mega|Ride"] = 131, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.52, ["Fly"] = 23.63, ["Ride"] = 20.76, ["Fly|Ride"] = 49.8, ["Neon"] = 32.82, ["Neon|Fly"] = 198.41, ["Neon|Ride"] = 49.8, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 43.72, ["Ride"] = 14.73, ["Fly|Ride"] = 38.07, ["Neon"] = 7.7, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 69.37, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 128.55}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 40.42, ["Ride"] = 59.07, ["Neon"] = 224.44, ["Neon|Ride"] = 336.17, ["Mega"] = 993.41, ["Mega|Ride"] = 783.95, ["Mega|Fly|Ride"] = 825.48}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Fly|Ride"] = 146.74, ["Neon"] = 6.57, ["Neon|Fly"] = 141.96, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 115.7, ["Mega"] = 46.78, ["Mega|Fly"] = 146.74, ["Mega|Ride"] = 108.42, ["Mega|Fly|Ride"] = 276.42}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 21.83, ["Fly|Ride"] = 88.24, ["Neon"] = 10.68, ["Neon|Ride"] = 40.42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 114.09, ["Mega|Ride"] = 197.11, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.82, ["Fly|Ride"] = 65.84, ["Neon"] = 12.27, ["Neon|Fly|Ride"] = 109.52, ["Mega"] = 103.69, ["Mega|Ride"] = 164.27}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2541.63, ["Ride"] = 19.25, ["Fly|Ride"] = 59.73, ["Neon"] = 3.5, ["Neon|Fly"] = 72.39, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 40.61, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 71.52}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.19, ["Fly"] = 21.4, ["Ride"] = 21, ["Fly|Ride"] = 37.67, ["Neon"] = 73.38, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 72.45, ["Neon|Fly|Ride"] = 142.35, ["Mega|Ride"] = 549.14, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 725.78, ["Fly"] = 1095.02, ["Ride"] = 794.07, ["Fly|Ride"] = 826.88, ["Neon"] = 1584.19, ["Neon|Ride"] = 1569.65, ["Neon|Fly|Ride"] = 1929.38, ["Mega"] = 8633.84, ["Mega|Ride"] = 4265.63, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 23.38, ["Ride"] = 15.75, ["Fly|Ride"] = 47.53, ["Neon"] = 2.1, ["Neon|Fly"] = 37.25, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 37.43, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.83, ["Ride"] = 36.75, ["Fly|Ride"] = 46.13, ["Neon"] = 42.29, ["Neon|Ride"] = 138.26, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.82, ["Ride"] = 70.91, ["Fly|Ride"] = 116.71, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2475.65, ["Mega|Fly|Ride"] = 1774.5}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.24, ["Fly"] = 146.74, ["Ride"] = 58.12, ["Fly|Ride"] = 102.95, ["Neon"] = 249.38, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 248.64, ["Mega"] = 821.25, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 775.27}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.44, ["Ride"] = 30.19, ["Fly|Ride"] = 65.63, ["Neon"] = 63.95, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.44, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 467.78}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.27, ["Ride"] = 70.09, ["Fly|Ride"] = 148.19, ["Neon"] = 112.08, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 390.48, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.03, ["Ride"] = 146.74, ["Neon"] = 148.19, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 379.98, ["Mega"] = 542.04, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 628.53}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.87}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.63, ["Ride"] = 28.87, ["Fly|Ride"] = 101.14, ["Neon"] = 25.86, ["Neon|Ride"] = 98.56, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 178.5, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 182.06, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 20.97, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.4, ["Fly"] = 62.99, ["Ride"] = 33.18, ["Fly|Ride"] = 86.62, ["Neon"] = 219.01, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 209.16, ["Neon|Fly|Ride"] = 243.1, ["Mega"] = 1282.75, ["Mega|Ride"] = 783.53, ["Mega|Fly|Ride"] = 690.16}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 23, ["Ride"] = 16.12, ["Fly|Ride"] = 36.53, ["Neon"] = 22.23, ["Neon|Fly"] = 99.66, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.22, ["Mega"] = 221.66, ["Mega|Fly"] = 438, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.71, ["Fly"] = 108.22, ["Ride"] = 27.24, ["Fly|Ride"] = 42.77, ["Neon"] = 25.94, ["Neon|Ride"] = 63.29, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 157.49, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 255.96}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 52.31, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.8, ["Ride"] = 42.19, ["Fly|Ride"] = 382.05, ["Neon"] = 212.44, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 438, ["Mega"] = 616.88, ["Mega|Ride"] = 1751.99, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 35.09, ["Fly|Ride"] = 58.15, ["Neon"] = 7.66, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 141.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.57, ["Ride"] = 45.94, ["Fly|Ride"] = 291.29, ["Neon"] = 57.75, ["Neon|Ride"] = 117.18, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 397.69, ["Mega|Fly"] = 584.74, ["Mega|Ride"] = 409.49, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.65, ["Neon"] = 10.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 100.34, ["Mega"] = 194.25, ["Mega|Ride"] = 155.28, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.73, ["Fly|Ride"] = 52.97, ["Neon"] = 51.19, ["Neon|Fly"] = 72.29, ["Neon|Ride"] = 146.73, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 297.59, ["Mega|Ride"] = 394.21, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.16, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 62.89, ["Ride"] = 118.06, ["Fly|Ride"] = 480.29, ["Neon"] = 292.35, ["Neon|Ride"] = 402.97, ["Neon|Fly|Ride"] = 876, ["Mega"] = 1432.6, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.36, ["Ride"] = 59.77, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Ride"] = 147.86, ["Mega"] = 421.31, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 689.73}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 3.31, ["Ride"] = 115.25, ["Neon"] = 149.63, ["Neon|Fly"] = 219.01, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.92, ["Ride"] = 130.32, ["Fly|Ride"] = 367.49, ["Neon"] = 157.79, ["Neon|Fly"] = 267.21, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 721.52, ["Mega|Fly"] = 2190, ["Mega|Ride"] = 652.79, ["Mega|Fly|Ride"] = 851.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 24.23, ["Mega"] = 196.88, ["Mega|Ride"] = 273.77, ["Mega|Fly|Ride"] = 332.46}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 17.5, ["Fly|Ride"] = 43.82, ["Neon"] = 3.77, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 63.8, ["Mega"] = 65.71, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.9, ["Fly|Ride"] = 84.35, ["Neon"] = 17.83, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 90.57, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 146.74, ["Ride"] = 19.68, ["Fly|Ride"] = 72.01, ["Neon"] = 6.42, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 99.16, ["Mega"] = 55.12, ["Mega|Ride"] = 83.97, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.29, ["Fly"] = 65.63, ["Ride"] = 20.9, ["Fly|Ride"] = 73.38, ["Neon"] = 23, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 328.02, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.52, ["Fly"] = 64.01, ["Ride"] = 26.25, ["Fly|Ride"] = 438, ["Neon"] = 29.85, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 310.99, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1095.02}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.24, ["Ride"] = 24.53, ["Fly|Ride"] = 61.84, ["Neon"] = 19.69, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 216.57, ["Mega|Ride"] = 438, ["Mega|Fly|Ride"] = 490.69}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 18.9, ["Fly|Ride"] = 52.41, ["Neon"] = 29.37, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 153.32, ["Mega"] = 274.98, ["Mega|Ride"] = 323.04, ["Mega|Fly|Ride"] = 189.97}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 288.73, ["Ride"] = 47.22, ["Neon"] = 15.15, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 140.47, ["Mega"] = 124.67, ["Mega|Fly"] = 216.8, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 272.71}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 28.64, ["Ride"] = 82.69, ["Fly|Ride"] = 332.07, ["Neon"] = 72.19, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 365.74, ["Mega|Ride"] = 744.61, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 47.25, ["Fly"] = 164.07, ["Ride"] = 82.2, ["Fly|Ride"] = 187.69, ["Neon"] = 188.9, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 324.19, ["Mega"] = 1605.29, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.57, ["Neon"] = 2.1, ["Neon|Ride"] = 21.72, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 53.82, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.28, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1154.13}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 59.12, ["Ride"] = 68.25, ["Fly|Ride"] = 174.75, ["Neon"] = 249.37, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 876, ["Mega"] = 1804.56, ["Mega|Ride"] = 996.08, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.89, ["Fly"] = 190.32, ["Ride"] = 50.38, ["Fly|Ride"] = 133.88, ["Neon"] = 32.82, ["Neon|Fly"] = 133.27, ["Neon|Ride"] = 87.62, ["Neon|Fly|Ride"] = 162.09, ["Mega"] = 270.17, ["Mega|Fly"] = 752.24, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.5, ["Fly"] = 87.62, ["Fly|Ride"] = 131.41, ["Neon"] = 9.19, ["Neon|Ride"] = 69.95, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 82.68, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 265.46}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 21, ["Fly|Ride"] = 45.93, ["Neon"] = 9.19, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 37.61, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 166.86, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 105}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.18, ["Fly|Ride"] = 52.4, ["Neon"] = 2.1, ["Neon|Fly"] = 130.08, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 24.78, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Fly|Ride"] = 93.09, ["Neon"] = 4.18, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 42, ["Mega|Fly"] = 168, ["Mega|Ride"] = 51.48, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 29.58, ["Mega"] = 24.94, ["Mega|Ride"] = 102.13, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.68, ["Ride"] = 40.94, ["Neon"] = 49.23, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 435.78, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 436.92}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.11, ["Ride"] = 26.24, ["Fly|Ride"] = 219.01, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 286.78, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.22, ["Fly"] = 26.25, ["Ride"] = 17.99, ["Fly|Ride"] = 40.64, ["Neon"] = 52.5, ["Neon|Ride"] = 41.14, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 363.64, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 311.72}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 92.01, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 482.9, ["Neon|Fly|Ride"] = 730.37, ["Mega"] = 2490.17, ["Mega|Ride"] = 1651.08, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 19.85, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Neon"] = 1026.2, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1090.05}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 18.71, ["Fly|Ride"] = 41.56, ["Neon"] = 3.94, ["Neon|Fly"] = 43.82, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 36.75, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.21, ["Fly|Ride"] = 33.6, ["Neon"] = 4.12, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.92, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 39.25, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 114.34}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 420, ["Fly"] = 585.21, ["Ride"] = 469.46, ["Fly|Ride"] = 524.97, ["Neon"] = 2409, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 6642.65}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.69, ["Ride"] = 63.49, ["Neon"] = 48.55, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 409.49, ["Mega|Ride"] = 730.37, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 17.07, ["Fly|Ride"] = 38.61, ["Neon"] = 7.32, ["Neon|Fly"] = 25.19, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.6, ["Mega|Ride"] = 146.73, ["Mega|Fly|Ride"] = 117.18}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.19, ["Ride"] = 108.42, ["Fly|Ride"] = 212.63, ["Neon"] = 157.5, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 737.62, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 796.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 43.73, ["Ride"] = 21.93, ["Fly|Ride"] = 54.44, ["Neon"] = 15.74, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 32.08, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 118.13, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 244.97}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 21.96, ["Fly|Ride"] = 196.88, ["Neon"] = 2.62, ["Neon|Fly"] = 102.95, ["Neon|Ride"] = 144.22, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 19.28, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 32.67, ["Fly"] = 129.94, ["Ride"] = 77.44, ["Fly|Ride"] = 215.25, ["Neon"] = 145.68, ["Neon|Ride"] = 186.79, ["Neon|Fly|Ride"] = 435.93, ["Mega"] = 727.1, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.53, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 87.62, ["Mega"] = 63.52, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.77, ["Ride"] = 70.94, ["Fly|Ride"] = 118.13, ["Neon"] = 283.23, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 1181.25, ["Mega|Ride"] = 1314, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 438, ["Neon"] = 32.44, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 506.2, ["Mega"] = 157.5, ["Mega|Ride"] = 423.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 33.64, ["Ride"] = 81.34, ["Fly|Ride"] = 59.14, ["Neon"] = 9.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 448.26, ["Mega"] = 117.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 205.73}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 51.87, ["Fly"] = 190.54, ["Ride"] = 181.79, ["Fly|Ride"] = 166.79, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2045.46}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.49, ["Ride"] = 35.06, ["Neon"] = 6.14, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 117.18, ["Mega"] = 47.25, ["Mega|Fly"] = 219.01, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 25.97, ["Ride"] = 24.09, ["Fly|Ride"] = 102.89, ["Neon"] = 5.24, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 59.13, ["Mega|Fly"] = 153.17, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 224.14}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 5.95, ["Fly"] = 58.5, ["Ride"] = 38.52, ["Fly|Ride"] = 199.22, ["Neon"] = 81.86, ["Neon|Fly"] = 133.25, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 262.5, ["Mega|Ride"] = 275.5, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 3.82, ["Fly"] = 44.54, ["Ride"] = 25.7, ["Fly|Ride"] = 74.72, ["Neon"] = 53.12, ["Neon|Ride"] = 70.65, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 354.38, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.23, ["Fly"] = 28.88, ["Ride"] = 33.96, ["Fly|Ride"] = 51.49, ["Neon"] = 59.07, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 161.16, ["Mega"] = 409.55, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 70.16, ["Ride"] = 116.82, ["Fly|Ride"] = 255.84, ["Neon"] = 315, ["Neon|Ride"] = 321.56, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1769.37, ["Mega|Fly|Ride"] = 2158.97}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.46, ["Ride"] = 117.08, ["Fly|Ride"] = 262.5, ["Neon"] = 60.12, ["Neon|Fly"] = 124.53, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 356.98, ["Mega"] = 264.99, ["Mega|Ride"] = 409.55, ["Mega|Fly|Ride"] = 652.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 2.35, ["Ride"] = 25.58, ["Fly|Ride"] = 78.73, ["Neon"] = 41.63, ["Neon|Ride"] = 44.63, ["Mega"] = 996.32, ["Mega|Ride"] = 173.07, ["Mega|Fly|Ride"] = 498.09}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.96, ["Fly"] = 135.19, ["Ride"] = 18.69, ["Fly|Ride"] = 115.5, ["Neon"] = 43.32, ["Neon|Fly"] = 105, ["Neon|Ride"] = 43.25, ["Neon|Fly|Ride"] = 372.23, ["Mega"] = 317.63, ["Mega|Ride"] = 876, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.99, ["Fly|Ride"] = 45.01, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.17, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 15.56, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.83, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.5, ["Fly"] = 164.07, ["Ride"] = 107.63, ["Fly|Ride"] = 164.07, ["Neon"] = 229.23, ["Neon|Fly"] = 2482.36, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 492.77, ["Mega"] = 1095.02, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 892.49}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.18, ["Fly|Ride"] = 146.74, ["Neon"] = 2.63, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.35, ["Fly|Ride"] = 45.93, ["Neon"] = 18.38, ["Neon|Ride"] = 21.27, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 257.25, ["Mega|Ride"] = 200.1}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.91, ["Ride"] = 91.88, ["Fly|Ride"] = 177.19, ["Neon"] = 234.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 844.59, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 5.72, ["Neon|Ride"] = 39.38, ["Mega"] = 45.7, ["Mega|Ride"] = 146.73, ["Mega|Fly|Ride"] = 271.65}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.8}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 47.33, ["Fly|Ride"] = 139.59, ["Neon"] = 3.94, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 218.91, ["Mega"] = 98.33, ["Mega|Ride"] = 107.85, ["Mega|Fly|Ride"] = 281.94}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.15, ["Ride"] = 204.75, ["Fly|Ride"] = 313.69, ["Neon"] = 664.96, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6569.97, ["Mega|Ride"] = 3320.77, ["Mega|Fly|Ride"] = 2444.65}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 101.9, ["Fly|Ride"] = 219.01, ["Neon"] = 32.47, ["Neon|Fly"] = 146.74, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 228.9, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.89, ["Neon|Ride"] = 21.78, ["Mega"] = 45.89, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 67.91, ["Mega|Fly|Ride"] = 426.91}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.84, ["Ride"] = 36.74, ["Fly|Ride"] = 131.25, ["Neon"] = 65.52, ["Neon|Ride"] = 94.18, ["Neon|Fly|Ride"] = 162.09, ["Mega"] = 511.38, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 686.57}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.56, ["Fly"] = 57.86, ["Ride"] = 22.32, ["Fly|Ride"] = 63.52, ["Neon"] = 101.04, ["Neon|Ride"] = 131.41, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 640.5, ["Mega|Ride"] = 436.92, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.89, ["Ride"] = 56.76, ["Fly|Ride"] = 175.22, ["Neon"] = 147, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 339.43, ["Mega"] = 552.57, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 148.18, ["Fly"] = 196.88, ["Ride"] = 184.54, ["Fly|Ride"] = 236.23, ["Neon"] = 645.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2540.4}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.66, ["Fly"] = 20.99, ["Ride"] = 17.96, ["Fly|Ride"] = 35.42, ["Neon"] = 70.09, ["Neon|Fly"] = 59.14, ["Neon|Ride"] = 50.37, ["Neon|Fly|Ride"] = 72.19, ["Mega|Ride"] = 423.78, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 73.38, ["Ride"] = 29.58, ["Fly|Ride"] = 131.25, ["Neon"] = 18.77, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 117.05, ["Mega"] = 159.86, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 292.38}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.94, ["Fly"] = 43.19, ["Ride"] = 40.69, ["Fly|Ride"] = 76.13, ["Neon"] = 45.47, ["Neon|Fly"] = 73.38, ["Neon|Ride"] = 51.43, ["Neon|Fly|Ride"] = 151.13, ["Mega"] = 463.93, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 47.55, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 134.7, ["Neon"] = 168, ["Neon|Fly"] = 328.13, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1022.62, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 964.68}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.69, ["Fly"] = 57.75, ["Ride"] = 265, ["Neon"] = 196.87, ["Neon|Ride"] = 232.86, ["Mega"] = 752.75, ["Mega|Ride"] = 694.15, ["Mega|Fly|Ride"] = 832.2}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 365.74, ["Ride"] = 350.44, ["Fly|Ride"] = 420, ["Neon"] = 1312.5, ["Neon|Ride"] = 1660.96, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5228.61}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.67, ["Fly"] = 58.65, ["Ride"] = 27.19, ["Fly|Ride"] = 69.45, ["Neon"] = 254.05, ["Neon|Ride"] = 133.26, ["Neon|Fly|Ride"] = 278.15, ["Mega"] = 761.25, ["Mega|Ride"] = 761.15, ["Mega|Fly|Ride"] = 918.71}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 14.43, ["Fly|Ride"] = 37.17, ["Neon"] = 2.1, ["Neon|Ride"] = 16.92, ["Neon|Fly|Ride"] = 48.88, ["Mega"] = 23.31, ["Mega|Fly"] = 116.08, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 123.09}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.5, ["Neon"] = 22.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 166.86, ["Mega"] = 148.32, ["Mega|Ride"] = 166.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.22, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 13.11, ["Neon|Ride"] = 64.62, ["Neon|Fly|Ride"] = 1181.24, ["Mega"] = 141.54, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 392.11, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 304.5, ["Fly"] = 393.75, ["Ride"] = 407.46, ["Fly|Ride"] = 472.5, ["Neon"] = 1898.49, ["Neon|Ride"] = 2045.46, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5645.22}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.41, ["Fly|Ride"] = 69.75, ["Neon"] = 19.68, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 117.18, ["Mega"] = 246.54, ["Mega|Ride"] = 248.57, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.84, ["Fly"] = 28.48, ["Ride"] = 19.68, ["Fly|Ride"] = 44.37, ["Neon"] = 48.16, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 61.34, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 374.51, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.41, ["Fly"] = 41.91, ["Ride"] = 28.48, ["Fly|Ride"] = 65.77, ["Neon"] = 15.58, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 43.82, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 94.17, ["Mega|Fly"] = 128.64, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.37, ["Fly"] = 58.54, ["Ride"] = 36.74, ["Fly|Ride"] = 131.41, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 327.43, ["Mega"] = 1207.5, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 786.22}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 12.57, ["Neon|Ride"] = 67.26, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 16.84, ["Fly"] = 93.13, ["Ride"] = 55.31, ["Neon"] = 146.99, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Ride"] = 38.34, ["Neon|Fly|Ride"] = 84, ["Mega"] = 72.18, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.16, ["Ride"] = 24.28, ["Neon"] = 60.8, ["Mega"] = 137.4, ["Mega|Ride"] = 319.75, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 7.88, ["Ride"] = 51.49, ["Neon"] = 45.5, ["Neon|Ride"] = 65.71, ["Mega"] = 876, ["Mega|Ride"] = 569.35, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.86, ["Fly"] = 34.13, ["Ride"] = 22.32, ["Fly|Ride"] = 56.79, ["Neon"] = 55.04, ["Neon|Fly"] = 43.82, ["Neon|Ride"] = 56.97, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 546.41, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 431.82, ["Fly"] = 622.57, ["Ride"] = 444.91, ["Fly|Ride"] = 511.88, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3155.35, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7533.56}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.37, ["Fly|Ride"] = 40.69, ["Neon"] = 15.65, ["Neon|Fly"] = 83.45, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 267.21, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 312.54}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.46, ["Fly"] = 72.29, ["Ride"] = 59.14, ["Neon"] = 65.63, ["Neon|Ride"] = 194.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 730.37, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 533.28}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21.95, ["Ride"] = 77.18, ["Fly|Ride"] = 220.4, ["Neon"] = 88.22, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 382.26, ["Mega"] = 307.93, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 513.38}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 55.12, ["Fly"] = 217.91, ["Ride"] = 99.6, ["Fly|Ride"] = 127.94, ["Neon"] = 354.8, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Ride"] = 1938.44, ["Mega|Fly|Ride"] = 1660.96}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.15, ["Ride"] = 55.13, ["Neon"] = 38.12, ["Neon|Ride"] = 99.06, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 193.37, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 58.46, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 119.51, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.51, ["Ride"] = 71.22, ["Neon"] = 24.43, ["Neon|Ride"] = 124.84, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 129.94, ["Mega|Fly"] = 260.63, ["Mega|Ride"] = 265.13, ["Mega|Fly|Ride"] = 278.81}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.88, ["Fly"] = 183.73, ["Ride"] = 81.98, ["Fly|Ride"] = 195.98, ["Neon"] = 131.91, ["Neon|Ride"] = 191.24, ["Neon|Fly|Ride"] = 271.04, ["Mega"] = 421.32, ["Mega|Ride"] = 438, ["Mega|Fly|Ride"] = 481.99}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 6.78, ["Neon|Ride"] = 102.95, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 66.76, ["Mega|Ride"] = 166.77, ["Mega|Fly|Ride"] = 179.58}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 26.25, ["Ride"] = 76.13, ["Neon"] = 124.69, ["Neon|Ride"] = 365.74, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 865.06}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 937.67, ["Fly"] = 1194.38, ["Ride"] = 1018.5, ["Fly|Ride"] = 1100.21, ["Neon"] = 3651.82, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2884.88, ["Mega"] = 10073.94, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.83, ["Fly"] = 118.13, ["Ride"] = 65.63, ["Fly|Ride"] = 190.37, ["Neon"] = 85.22, ["Neon|Fly"] = 729.28, ["Neon|Ride"] = 190.54, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 466.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.89, ["Ride"] = 27.57, ["Fly|Ride"] = 85.86, ["Neon"] = 11.81, ["Neon|Fly"] = 73.38, ["Neon|Ride"] = 33.29, ["Neon|Fly|Ride"] = 87.61, ["Mega"] = 76.01, ["Mega|Ride"] = 99.36, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.54, ["Ride"] = 131.24, ["Fly|Ride"] = 146.74, ["Neon"] = 71.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 389.8, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 498.04}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 190.54, ["Neon"] = 2.1, ["Neon|Ride"] = 26.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.23, ["Mega|Ride"] = 71.91, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 51.89, ["Fly"] = 144.56, ["Ride"] = 103.18, ["Fly|Ride"] = 275.92, ["Neon"] = 224.38, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 378.89, ["Mega"] = 993.24, ["Mega|Ride"] = 980.44, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 12.74, ["Ride"] = 62.89, ["Fly|Ride"] = 292.3, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 576.19, ["Mega|Ride"] = 1019.69, ["Mega|Fly|Ride"] = 1022.74}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.56, ["Ride"] = 23.66, ["Neon"] = 9.17, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 99.62, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 490.56}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.86, ["Fly"] = 162.09, ["Ride"] = 35.43, ["Fly|Ride"] = 106.55, ["Neon"] = 89.39, ["Neon|Ride"] = 95.81, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 389.82, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 765.32}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 2.2, ["Fly"] = 98.57, ["Ride"] = 29.07, ["Fly|Ride"] = 59.07, ["Neon"] = 27.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 149.43, ["Mega"] = 262.4, ["Mega|Ride"] = 547.53, ["Mega|Fly|Ride"] = 372.31}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.73, ["Ride"] = 65.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 584.74, ["Mega"] = 2555.73, ["Mega|Ride"] = 1861.51, ["Mega|Fly|Ride"] = 1826.57}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.5, ["Ride"] = 43.32, ["Fly|Ride"] = 197.11, ["Neon"] = 16.31, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 664.89, ["Mega"] = 59.05, ["Mega|Ride"] = 115.48, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.42, ["Fly"] = 37.25, ["Ride"] = 23.63, ["Fly|Ride"] = 52.49, ["Neon"] = 39.29, ["Neon|Fly"] = 190.54, ["Neon|Ride"] = 62.27, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 328.02, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 118.13, ["Fly"] = 393.75, ["Ride"] = 184.78, ["Fly|Ride"] = 200.82, ["Neon"] = 498.74, ["Neon|Ride"] = 547.19, ["Neon|Fly|Ride"] = 555.19, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2003.64}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.04, ["Ride"] = 15.75, ["Fly|Ride"] = 30.19, ["Neon"] = 26.96, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 23.91, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 144.27, ["Mega|Ride"] = 249.04, ["Mega|Fly|Ride"] = 187.68}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 27.44, ["Fly"] = 267.04, ["Ride"] = 74.82, ["Fly|Ride"] = 150.19, ["Neon"] = 208.68, ["Neon|Ride"] = 220.29, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 706.14, ["Mega|Ride"] = 744.61, ["Mega|Fly|Ride"] = 774.08}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 13.16, ["Fly|Ride"] = 63, ["Neon"] = 2.1, ["Neon|Fly"] = 29.95, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 15.39, ["Mega|Ride"] = 31.08, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 59.14, ["Neon"] = 3.39, ["Neon|Fly|Ride"] = 135.79, ["Mega"] = 18.26, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 37.25, ["Ride"] = 31.5, ["Fly|Ride"] = 173.37, ["Neon"] = 15.35, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 247.42}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 34.02, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 166.86, ["Neon|Fly|Ride"] = 424.47, ["Mega"] = 521.05, ["Mega|Ride"] = 657.01}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 18.37, ["Fly|Ride"] = 34.13, ["Neon"] = 15.09, ["Neon|Fly"] = 28.55, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 57.17, ["Mega"] = 137.58, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.56, ["Fly"] = 59.58, ["Ride"] = 38.57, ["Fly|Ride"] = 100.52, ["Neon"] = 50.19, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 62.67, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 390.11, ["Mega|Fly"] = 448.25, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.77, ["Ride"] = 18.26, ["Fly|Ride"] = 69.3, ["Neon"] = 8.4, ["Neon|Fly"] = 98.41, ["Neon|Ride"] = 29.9, ["Neon|Fly|Ride"] = 61.73, ["Mega"] = 54.89, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.11, ["Fly"] = 165.37, ["Ride"] = 24.94, ["Fly|Ride"] = 217.2, ["Neon"] = 44.24, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 291.29, ["Mega|Ride"] = 455.54, ["Mega|Fly|Ride"] = 479.61}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.69, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 47.25, ["Neon|Ride"] = 73.5, ["Mega"] = 305.82, ["Mega|Ride"] = 314.27, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 18.19, ["Fly|Ride"] = 58.25, ["Neon"] = 19.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 36, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 249.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 223.13}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.93, ["Ride"] = 16.28, ["Fly|Ride"] = 52.56, ["Neon"] = 16.15, ["Neon|Fly"] = 64.62, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 85.43, ["Mega"] = 146.74, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 286.9}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 215.25, ["Fly"] = 393.75, ["Ride"] = 298.85, ["Fly|Ride"] = 438, ["Neon"] = 1299.79, ["Neon|Ride"] = 1445.4, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4316.87, ["Mega|Fly|Ride"] = 3984.27}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.77, ["Ride"] = 114.17, ["Neon"] = 43.22, ["Mega"] = 122.14, ["Mega|Ride"] = 664.91, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 109.52, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 32.39, ["Neon|Fly"] = 248.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 149.43, ["Mega"] = 247.58, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 190.52}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.94, ["Fly|Ride"] = 730.37, ["Neon"] = 35.97, ["Neon|Ride"] = 292.38, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 496.8, ["Mega|Ride"] = 497.07, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.45, ["Ride"] = 16.45, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 21.92, ["Neon|Ride"] = 17.75, ["Neon|Fly|Ride"] = 43.82, ["Mega"] = 19.34, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 51.48, ["Ride"] = 22.32, ["Fly|Ride"] = 53.82, ["Neon"] = 21.69, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 96.46, ["Mega"] = 120.75, ["Mega|Ride"] = 156.62, ["Mega|Fly|Ride"] = 247.8}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.15, ["Ride"] = 121.07, ["Neon"] = 11.01, ["Neon|Ride"] = 292.38, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 52.5, ["Mega|Ride"] = 168.92, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.57, ["Fly"] = 105, ["Ride"] = 99.02, ["Fly|Ride"] = 156.58, ["Neon"] = 315, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2920.36, ["Mega|Ride"] = 3651.82, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 102.95, ["Ride"] = 23.61, ["Fly|Ride"] = 87.62, ["Neon"] = 22.32, ["Neon|Ride"] = 69.57, ["Mega"] = 169.3, ["Mega|Ride"] = 295.66, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 5.02, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 559.19, ["Mega"] = 61.11, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 40.32, ["Fly"] = 131.25, ["Ride"] = 86.63, ["Fly|Ride"] = 179.22, ["Neon"] = 150.94, ["Neon|Ride"] = 178.4, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 471.19, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.14, ["Fly|Ride"] = 38.07, ["Neon"] = 2.1, ["Neon|Fly"] = 22.63, ["Neon|Ride"] = 16.45, ["Neon|Fly|Ride"] = 43.16, ["Mega"] = 16.64, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.69, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 98.57, ["Neon"] = 2.24, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 163.29, ["Mega"] = 26.24, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 92.7, ["Mega|Fly|Ride"] = 197.11}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 161.34, ["Neon"] = 7.6, ["Neon|Ride"] = 102.95, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 68.24, ["Mega|Fly"] = 190.54, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 216.87}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.73, ["Ride"] = 59.05, ["Fly|Ride"] = 106.32, ["Neon"] = 19.68, ["Neon|Fly"] = 109.52, ["Neon|Ride"] = 84.83, ["Neon|Fly|Ride"] = 152.29, ["Mega"] = 110.14, ["Mega|Fly"] = 336.17, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 263.87}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.3, ["Ride"] = 15.62, ["Fly|Ride"] = 33.64, ["Neon"] = 2.1, ["Neon|Fly"] = 25.19, ["Neon|Ride"] = 22.62, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 20.51, ["Mega|Ride"] = 59.14, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.33, ["Fly"] = 129.23, ["Ride"] = 55.13, ["Neon"] = 188.81, ["Neon|Ride"] = 188.35, ["Neon|Fly|Ride"] = 379.98, ["Mega"] = 809.41, ["Mega|Fly|Ride"] = 832.2}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 3150, ["Ride"] = 2382.19, ["Fly|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 45442.15}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.13, ["Fly|Ride"] = 32.82, ["Neon"] = 10.26, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 24.53, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.51, ["Mega|Fly"] = 292.38, ["Mega|Ride"] = 92.25, ["Mega|Fly|Ride"] = 161.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 9.96, ["Neon|Ride"] = 72.19, ["Mega"] = 107.01, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 498.04}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.47, ["Fly"] = 105, ["Ride"] = 26.25, ["Fly|Ride"] = 146.74, ["Neon"] = 78.75, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 282.72, ["Mega"] = 431.81, ["Mega|Ride"] = 498.09, ["Mega|Fly|Ride"] = 722.98}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 26.48, ["Fly"] = 146.74, ["Ride"] = 73.49, ["Neon"] = 187.69, ["Mega"] = 700.81, ["Mega|Ride"] = 699.74, ["Mega|Fly|Ride"] = 665.01}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.48, ["Fly"] = 548.42, ["Ride"] = 188.41, ["Fly|Ride"] = 246.88, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6569.97, ["Mega|Fly|Ride"] = 4152.35}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.7, ["Ride"] = 64.97, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 32.87, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 146.74, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 384.36}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 24.92, ["Neon"] = 17.72, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.81, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 27.28, ["Fly|Ride"] = 64.63, ["Neon"] = 6.43, ["Neon|Fly"] = 129.23, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 75.35, ["Mega|Ride"] = 111.95, ["Mega|Fly|Ride"] = 237.79}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.6, ["Ride"] = 71.47, ["Fly|Ride"] = 131.25, ["Neon"] = 130.94, ["Neon|Ride"] = 1249.15, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 584.74, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 26.3, ["Neon"] = 2.62, ["Neon|Ride"] = 29.9, ["Mega"] = 19.69, ["Mega|Ride"] = 146.74}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 257.34, ["Ride"] = 124.53, ["Fly|Ride"] = 170.52, ["Neon"] = 315, ["Neon|Fly"] = 468.67, ["Neon|Ride"] = 394.21, ["Neon|Fly|Ride"] = 511.38, ["Mega"] = 3284.99, ["Mega|Ride"] = 1168.37, ["Mega|Fly|Ride"] = 1418.03}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 46.01, ["Ride"] = 91.87, ["Neon"] = 14.44, ["Neon|Ride"] = 146.73, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 64.71, ["Mega|Ride"] = 292.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 47.15, ["Fly"] = 232.84, ["Ride"] = 95.82, ["Fly|Ride"] = 182.86, ["Neon"] = 255.94, ["Neon|Ride"] = 364.35, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.21, ["Ride"] = 17.91, ["Fly|Ride"] = 43.66, ["Neon"] = 5.25, ["Neon|Fly"] = 87.17, ["Neon|Ride"] = 73.38, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 42, ["Mega|Fly"] = 166.87, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.6, ["Neon|Ride"] = 86.18, ["Mega"] = 41.74, ["Mega|Ride"] = 423.78, ["Mega|Fly|Ride"] = 365.7}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 2.98, ["Fly"] = 73.38, ["Ride"] = 24.54, ["Fly|Ride"] = 90.57, ["Neon"] = 23.63, ["Neon|Fly"] = 109.52, ["Neon|Ride"] = 72.47, ["Mega"] = 141.74, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 584.74}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 353.72, ["Fly"] = 747.07, ["Ride"] = 410.81, ["Fly|Ride"] = 569.35, ["Neon"] = 918.74, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3160.16, ["Mega|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 3313.46}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.7, ["Fly"] = 65.63, ["Ride"] = 67.26, ["Fly|Ride"] = 83.45, ["Neon"] = 199.22, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly"] = 2807.09, ["Mega|Ride"] = 1751.99, ["Mega|Fly|Ride"] = 1079.67}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.36, ["Ride"] = 44.24, ["Fly|Ride"] = 129.75, ["Neon"] = 28.06, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 117.18, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 22.24, ["Fly"] = 219.01, ["Ride"] = 69.57, ["Fly|Ride"] = 137.61, ["Neon"] = 79.75, ["Neon|Fly"] = 410.57, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 275.63, ["Mega|Fly"] = 1024.72, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 488.34}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.78, ["Ride"] = 22.23, ["Neon"] = 101.36, ["Neon|Ride"] = 124.52, ["Mega"] = 664.9, ["Mega|Ride"] = 249.03, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 10.49, ["Neon|Ride"] = 157.5, ["Mega"] = 108.93, ["Mega|Ride"] = 332.49}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 73.38, ["Ride"] = 19.68, ["Fly|Ride"] = 62.97, ["Neon"] = 63.51, ["Neon|Ride"] = 146.73, ["Neon|Fly|Ride"] = 216.66, ["Mega"] = 393.75, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 104.9, ["Fly"] = 249.03, ["Ride"] = 120.9, ["Fly|Ride"] = 194.24, ["Neon"] = 832.2, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21.46, ["Ride"] = 56.14, ["Fly|Ride"] = 85.32, ["Neon"] = 125.95, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 551.25, ["Mega|Ride"] = 633.29, ["Mega|Fly|Ride"] = 730.37}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1993.67, ["Fly"] = 2490.27, ["Ride"] = 1706.25, ["Fly|Ride"] = 1837.5, ["Neon"] = 11680.29, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.13, ["Fly"] = 131250, ["Ride"] = 124.56, ["Fly|Ride"] = 196.87, ["Neon"] = 31.76, ["Neon|Ride"] = 99.63, ["Mega"] = 203.44, ["Mega|Ride"] = 244.08, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.92, ["Fly"] = 59.88, ["Ride"] = 55.13, ["Fly|Ride"] = 111.06, ["Neon"] = 18.69, ["Neon|Ride"] = 73.38, ["Mega"] = 186.17, ["Mega|Ride"] = 394.21, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 885.63, ["Fly"] = 1110, ["Ride"] = 885.94, ["Fly|Ride"] = 1017.19, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Ride"] = 14112.27, ["Mega|Fly|Ride"] = 13281.33}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 28.76, ["Ride"] = 54.87, ["Fly|Ride"] = 105, ["Neon"] = 136.49, ["Neon|Ride"] = 327.43, ["Mega"] = 869.02, ["Mega|Ride"] = 788.41, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.04, ["Fly|Ride"] = 128.15, ["Neon"] = 12.94, ["Neon|Fly"] = 166.85, ["Neon|Ride"] = 83.99, ["Neon|Fly|Ride"] = 292.35, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 146.74, ["Neon"] = 5.1, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.83, ["Neon|Fly|Ride"] = 113.89, ["Mega"] = 29.19, ["Mega|Ride"] = 51.63, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.42, ["Fly"] = 438, ["Ride"] = 141.48, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 511.38, ["Neon|Fly|Ride"] = 646.98, ["Mega"] = 2490.16, ["Mega|Fly|Ride"] = 2438.56}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 37.25, ["Fly|Ride"] = 76.67, ["Neon"] = 6.59, ["Neon|Ride"] = 64.32, ["Mega"] = 91.87, ["Mega|Ride"] = 166.85, ["Mega|Fly|Ride"] = 236.41}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.66, ["Fly"] = 153.32, ["Ride"] = 104.19, ["Neon"] = 622.57, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 497.14, ["Mega"] = 2190, ["Mega|Fly|Ride"] = 1676.45}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.71, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.84, ["Mega|Ride"] = 323}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.07, ["Fly"] = 423.78, ["Ride"] = 293.99, ["Fly|Ride"] = 341.25, ["Neon"] = 1148.82, ["Neon|Ride"] = 1094.87, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 26.49, ["Fly|Ride"] = 117.18, ["Neon"] = 31.5, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 113.89, ["Mega"] = 247.76, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 44.63, ["Neon"] = 4.83, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.69, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 48.3, ["Mega|Ride"] = 114.72, ["Mega|Fly|Ride"] = 125.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1368.76, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 8030.68, ["Neon|Fly|Ride"] = 7292.65, ["Mega"] = 24901.49, ["Mega|Fly|Ride"] = 25547.52}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 11.69, ["Ride"] = 82.43, ["Neon"] = 73.38, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 546.41, ["Mega"] = 431.82, ["Mega|Ride"] = 472.06, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.78, ["Fly"] = 53.46, ["Ride"] = 38.57, ["Fly|Ride"] = 58.97, ["Neon"] = 20.98, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 116.81, ["Mega"] = 170.63, ["Mega|Ride"] = 146.74, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.41, ["Fly"] = 40.26, ["Ride"] = 31.49, ["Fly|Ride"] = 68.24, ["Neon|Ride"] = 378.89, ["Neon|Fly|Ride"] = 189.09, ["Mega"] = 2627.99, ["Mega|Ride"] = 1162.92, ["Mega|Fly|Ride"] = 779.63}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.46, ["Fly"] = 62.28, ["Ride"] = 29.06, ["Fly|Ride"] = 71.47, ["Neon"] = 66.94, ["Neon|Ride"] = 90.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 584.74}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 83.98, ["Ride"] = 227.39, ["Fly|Ride"] = 644.01, ["Neon"] = 437.99, ["Neon|Fly"] = 584.74, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 730.37, ["Mega"] = 3941.98, ["Mega|Fly|Ride"] = 996.14}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 113, ["Neon|Fly|Ride"] = 109.52, ["Mega"] = 16.8, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 104.98, ["Fly"] = 170.61, ["Ride"] = 147, ["Fly|Ride"] = 217.88, ["Neon"] = 553.88, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 854.11, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 3503.98, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 748.35, ["Ride"] = 32.85, ["Fly|Ride"] = 68.74, ["Neon"] = 227.37, ["Neon|Ride"] = 83.98, ["Mega"] = 773.71, ["Mega|Ride"] = 423.39, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.36, ["Neon"] = 13.13, ["Neon|Fly"] = 83.45, ["Neon|Ride"] = 87.62, ["Neon|Fly|Ride"] = 69.98, ["Mega|Ride"] = 277.86}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 144.56, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 86.43}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 85.32, ["Fly"] = 247.55, ["Ride"] = 203.44, ["Fly|Ride"] = 420.5, ["Neon"] = 541.97, ["Neon|Ride"] = 584.74, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 1749.57, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.6, ["Ride"] = 39.38, ["Fly|Ride"] = 438, ["Neon"] = 26.25, ["Neon|Ride"] = 59.07, ["Mega"] = 118.36, ["Mega|Ride"] = 159.88, ["Mega|Fly|Ride"] = 332.46}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.19, ["Mega"] = 17.67, ["Mega|Ride"] = 219.01, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 26.19, ["Fly|Ride"] = 146.74, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 203.68, ["Mega"] = 19.46, ["Mega|Fly"] = 58.53, ["Mega|Ride"] = 46.09, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.68, ["Fly|Ride"] = 52.49, ["Neon"] = 4.96, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.53, ["Neon"] = 10.39, ["Mega"] = 137.82, ["Mega|Ride"] = 146.73, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 16.13, ["Fly|Ride"] = 40.94, ["Neon"] = 13.13, ["Neon|Fly"] = 87.62, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 102.95, ["Mega"] = 261.19, ["Mega|Ride"] = 105.16, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.74, ["Fly|Ride"] = 290.51, ["Neon"] = 203.44, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 636.26, ["Mega"] = 643.13, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 876}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 16.44, ["Fly|Ride"] = 49.23, ["Neon"] = 2.1, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 17.98, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 16.79, ["Mega|Fly"] = 43.82, ["Mega|Ride"] = 54.77, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.49, ["Fly"] = 57.31, ["Ride"] = 33.24, ["Fly|Ride"] = 75.13, ["Neon"] = 40.22, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 132.47, ["Mega"] = 301.88, ["Mega|Fly"] = 584.74, ["Mega|Ride"] = 283.42, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 24.68, ["Fly"] = 58.7, ["Ride"] = 51.43, ["Fly|Ride"] = 105, ["Neon"] = 168.08, ["Neon|Ride"] = 200.37, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 830.57, ["Mega|Ride"] = 876, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.48, ["Fly"] = 209.98, ["Neon"] = 90.95, ["Neon|Ride"] = 105, ["Mega"] = 664.9, ["Mega|Ride"] = 783.68, ["Mega|Fly|Ride"] = 869.44}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.43, ["Ride"] = 16.45, ["Fly|Ride"] = 37.25, ["Neon"] = 3.84, ["Neon|Fly"] = 81.26, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 74.73, ["Mega"] = 40.67, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 13.13, ["Fly"] = 78.74, ["Ride"] = 35.44, ["Neon"] = 85.32, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 262.5, ["Mega|Fly"] = 581.45, ["Mega|Ride"] = 547.32, ["Mega|Fly|Ride"] = 628.46}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1299.79, ["Ride"] = 1011.94, ["Fly|Ride"] = 1076.24, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 236.15, ["Ride"] = 310.55, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1314, ["Mega"] = 3653.09, ["Mega|Ride"] = 3796.35, ["Mega|Fly|Ride"] = 3547.79}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 9.75, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 261.74, ["Mega"] = 60.38, ["Mega|Fly|Ride"] = 1168.37}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 114.18, ["Fly"] = 196.88, ["Ride"] = 220.4, ["Fly|Ride"] = 413.44, ["Neon"] = 643.13, ["Neon|Ride"] = 651, ["Neon|Fly|Ride"] = 926.2, ["Mega|Ride"] = 2209.99, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Fly"] = 41.63, ["Ride"] = 24.01, ["Fly|Ride"] = 95.28, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 317.56, ["Mega"] = 115.96, ["Mega|Ride"] = 117.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 257.25, ["Fly"] = 438, ["Ride"] = 315, ["Fly|Ride"] = 330.75, ["Neon|Ride"] = 1368.76, ["Neon|Fly|Ride"] = 1180.71, ["Mega|Fly|Ride"] = 4806.04}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 230.42, ["Neon"] = 10.5, ["Neon|Ride"] = 57.99, ["Mega"] = 393.74, ["Mega|Fly"] = 366.83, ["Mega|Ride"] = 437.96}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 41.87, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 25.51, ["Fly"] = 52.5, ["Ride"] = 52.5, ["Fly|Ride"] = 146.74, ["Neon"] = 117.03, ["Neon|Fly"] = 438, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 847.75, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 292.38, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 249.03, ["Mega|Ride"] = 265.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.61, ["Fly|Ride"] = 30.19, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 18.67, ["Neon|Fly|Ride"] = 55.14, ["Mega"] = 28.88, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 39.86, ["Mega|Fly|Ride"] = 96.38}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3839.06, ["Ride"] = 4574.07, ["Fly|Ride"] = 4709.25, ["Neon"] = 32849.75, ["Neon|Fly|Ride"] = 20445.04, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.56, ["Fly"] = 87.62, ["Ride"] = 41.99, ["Neon"] = 87.62, ["Neon|Fly"] = 389.83, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 436.92}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 20.58, ["Fly|Ride"] = 45.93, ["Neon"] = 14.1, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 32.12, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.38, ["Mega|Ride"] = 146.74, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 492.09, ["Fly"] = 547.78, ["Ride"] = 501.38, ["Fly|Ride"] = 590.63, ["Neon"] = 1657.64, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1183.86, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 49.82, ["Neon"] = 22.31, ["Neon|Ride"] = 291.38, ["Mega"] = 131.41, ["Mega|Ride"] = 174.12, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.49, ["Fly"] = 145.69, ["Ride"] = 19.69, ["Neon"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.38, ["Ride"] = 19.97, ["Fly|Ride"] = 65.62, ["Neon"] = 6.37, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 25.35, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 62.43, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 284.71}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 891.34, ["Ride"] = 767.82, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8978.95}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 38.96, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 102.98, ["Neon|Fly|Ride"] = 190.54, ["Mega"] = 207.38, ["Mega|Fly"] = 438, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 515.7}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.71, ["Fly"] = 106.2, ["Ride"] = 49.85, ["Fly|Ride"] = 210, ["Neon"] = 21.83, ["Neon|Ride"] = 56.95, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 218.99, ["Mega|Fly"] = 830.68, ["Mega|Ride"] = 191.1, ["Mega|Fly|Ride"] = 271.55}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 24.56, ["Fly|Ride"] = 65.62, ["Neon"] = 14.14, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.52, ["Mega"] = 165.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 239.78}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.04, ["Fly"] = 39.38, ["Ride"] = 39.8, ["Fly|Ride"] = 65.63, ["Neon"] = 131.99, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 292.38, ["Mega"] = 647.16, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 292.38, ["Neon"] = 3.05, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.81, ["Mega|Fly"] = 157.69, ["Mega|Ride"] = 101.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 686.57, ["Ride"] = 677.82, ["Fly|Ride"] = 682.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2334.54, ["Neon|Fly|Ride"] = 2415.78, ["Mega|Ride"] = 9711.68, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 64.15, ["Fly|Ride"] = 262.49, ["Neon"] = 11.47, ["Neon|Ride"] = 73.4, ["Neon|Fly|Ride"] = 457.72, ["Mega"] = 56.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 50.72, ["Fly|Ride"] = 196.88, ["Neon"] = 6.18, ["Neon|Fly"] = 292.38, ["Neon|Ride"] = 224.14, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.38, ["Mega|Ride"] = 124.84, ["Mega|Fly|Ride"] = 438}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 61.07, ["Neon"] = 3.82, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7300.33, ["Mega"] = 80.76, ["Mega|Fly"] = 151.91, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.02, ["Mega"] = 250.78, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 23, ["Fly"] = 72.19, ["Ride"] = 44.51, ["Fly|Ride"] = 217.9, ["Neon"] = 155.91, ["Neon|Ride"] = 140.46, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 557.84, ["Mega|Ride"] = 539.24, ["Mega|Fly|Ride"] = 581.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.27, ["Ride"] = 52.41, ["Fly|Ride"] = 157.69, ["Neon"] = 87.42, ["Neon|Ride"] = 146.74, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 520.3, ["Mega|Fly|Ride"] = 637.45}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.94, ["Fly|Ride"] = 39.38, ["Neon"] = 28.48, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 4.98, ["Ride"] = 29.58, ["Fly|Ride"] = 149.43, ["Neon"] = 65.63, ["Neon|Ride"] = 162.09, ["Mega|Ride"] = 437.96}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 109.5, ["Neon"] = 14.49, ["Neon|Ride"] = 59.14, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 74.82, ["Mega|Fly"] = 124.52, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 249.03}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.89, ["Fly"] = 28.88, ["Ride"] = 24.82, ["Fly|Ride"] = 55.11, ["Neon"] = 116.93, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 163.42, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 874.04}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 36.69, ["Fly"] = 874.13, ["Neon"] = 117.05, ["Mega"] = 281.71, ["Mega|Fly"] = 657.01, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 735.67}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.49, ["Fly"] = 84, ["Ride"] = 72.19, ["Fly|Ride"] = 246.88, ["Neon"] = 263.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1992.34, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.04, ["Fly"] = 146.74, ["Ride"] = 77.99, ["Fly|Ride"] = 234.35, ["Neon"] = 125.89, ["Neon|Ride"] = 182.7, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 502.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 15.58, ["Ride"] = 64.32, ["Neon"] = 140.21, ["Neon|Ride"] = 223.13, ["Mega"] = 502.69, ["Mega|Ride"] = 637.51, ["Mega|Fly|Ride"] = 845.35}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 31.49, ["Fly"] = 393.75, ["Ride"] = 110.25, ["Fly|Ride"] = 208.94, ["Neon"] = 228.73, ["Neon|Ride"] = 273.77, ["Neon|Fly|Ride"] = 467.77, ["Mega"] = 810.22, ["Mega|Ride"] = 801.27, ["Mega|Fly|Ride"] = 872.76}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.93, ["Fly|Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 40.6, ["Mega|Fly"] = 332.46, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 146.9}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 108.93, ["Ride"] = 229.69, ["Fly|Ride"] = 374.22, ["Neon"] = 513.24, ["Neon|Ride"] = 621.97, ["Neon|Fly|Ride"] = 861.78, ["Mega"] = 1640.63, ["Mega|Ride"] = 1737.78, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 81.4, ["Neon"] = 4.19, ["Neon|Fly"] = 102.95, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 306.62, ["Mega"] = 38.27, ["Mega|Ride"] = 89.65, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.18, ["Ride"] = 78.75, ["Fly|Ride"] = 218.99, ["Neon"] = 78.75, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 395.07, ["Mega"] = 591.93, ["Mega|Ride"] = 584.74, ["Mega|Fly|Ride"] = 626.35}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.3, ["Neon|Fly|Ride"] = 146.74, ["Mega"] = 19.71}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 3.04, ["Mega"] = 19.69, ["Mega|Ride"] = 112.73, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.46, ["Fly"] = 1826.46, ["Ride"] = 152.25, ["Neon"] = 664.9, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6849.57, ["Mega|Fly|Ride"] = 2056.91}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.71, ["Fly|Ride"] = 71.91, ["Neon"] = 3.94, ["Neon|Fly"] = 43.82, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.88, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 36.54, ["Fly|Ride"] = 66.94, ["Neon"] = 5.16, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 34.92, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 6.48, ["Ride"] = 44.14, ["Neon"] = 20.98, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 146.73}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.57, ["Neon|Ride"] = 137.82, ["Mega"] = 120.75, ["Mega|Ride"] = 336.17}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.01, ["Ride"] = 183.75, ["Fly|Ride"] = 365.74, ["Neon"] = 458.07, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.16, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.81, ["Fly|Ride"] = 744.61, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 78.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 47.24}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.59}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 14.42}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 49.48}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.81}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.05}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.45}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.92}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 16.96}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.91}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.76}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.77}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.67}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.2}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 40.69}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 730.37}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 486.27}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.39}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1444.91}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.48}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.54}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 32.24}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 63}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.81}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.2}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 61.64}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.44}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.09}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2732.89}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 91.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 301.77}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.97}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.59}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 29.89}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.08}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.47}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 160.78}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 52.5}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.85}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.02}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 31.5}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.35}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.93}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 319.76}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.26}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 332.45}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 102.86}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21.93}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24776.98}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.53}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 63.52}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 40.5}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 51.18}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 129.83}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 82.22}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 108.93}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.44}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 117.05}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 257.25}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.5}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.45}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 147.86}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.93}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.72}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.64}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 223.81}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.51}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.87}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.18}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 230.35}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.68}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 17.07}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 42.61}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 68.16}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.75}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 11.09}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.32}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.17}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.66}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.6}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.15}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.75}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 190.32}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 32.82}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 212.23}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.94}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.04}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 27.55}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 65.54}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.25}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 10.8}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 28.44}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.44}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.85}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.86}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.42}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.88}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7218.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 15.39}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.24}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.9}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 19.06}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.8}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.19}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.39}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 43.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.81}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.37}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.29}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.27}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.35}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.42}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 80.75}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.34}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.76}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.28}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 7.53}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.83}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.77}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.35}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.5}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 27.2}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.43}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.5}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 70.88}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.71}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.93}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1380.75}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 85.3}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 56.31}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 37.7}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.9}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.49}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 19.68}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.77}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 8.59}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.71}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.74}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 15.22}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.77}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 88.59}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 7.67}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 23.55}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.84}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 84}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 20.82}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.21}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.65}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.81}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 146.64}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 105}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 13.96}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.75}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.2}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.85}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.74}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.82}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.19}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 14.73}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.43}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.59}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.46}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 4.9}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.52}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.16}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 60.27}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 12.47}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.91}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.12}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 51.1}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 49.94}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 52.5}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 95.02}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.2}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 58.31}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 117.08}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.28}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 62.9}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.8}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 37.25}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.12}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.45}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 17.74}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 76.13}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 13.79}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.35}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 32.81}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 85.32}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.39}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.5}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 18.48}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.81}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.99}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.45}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.9}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.77}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 30.44}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.96}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 14.33}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 346.39}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 55.11}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.94}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.97}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 164.05}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 85.32}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.75}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.1}},
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