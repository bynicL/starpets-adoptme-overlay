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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.38, ["Ride"] = 1179.92, ["Fly|Ride"] = 1327.03, ["Neon"] = 7041.2, ["Neon|Fly|Ride"] = 5160.99, ["Mega"] = 22116.89, ["Mega|Fly|Ride"] = 22116.89}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 653.57, ["Fly"] = 595.61, ["Ride"] = 472.5, ["Fly|Ride"] = 662.81, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 11059.76, ["Mega|Fly|Ride"] = 8625.61}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 5250, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 20935.86, ["Mega|Fly|Ride"] = 78146.72}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 203.44, ["Ride"] = 274.26, ["Fly|Ride"] = 413.65, ["Neon"] = 1174.16, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5028.47}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 884.69, ["Ride"] = 609.68, ["Fly|Ride"] = 616.88, ["Neon|Fly|Ride"] = 1753.5, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.69, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 97.33, ["Neon|Fly"] = 295.28, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 221.21, ["Mega"] = 357.33, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.93, ["Fly"] = 47.3, ["Ride"] = 31.8, ["Fly|Ride"] = 65.62, ["Neon"] = 30.19, ["Neon|Fly"] = 134.5, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 251.04, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 884.69}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 99.74, ["Fly"] = 168.44, ["Ride"] = 141.74, ["Fly|Ride"] = 236.25, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 1767.36}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 33.98, ["Fly"] = 66.36, ["Ride"] = 43.82, ["Fly|Ride"] = 106.17, ["Neon"] = 275.63, ["Neon|Ride"] = 234.3, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2100, ["Mega|Ride"] = 1179.95, ["Mega|Fly|Ride"] = 890.48}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 25.1, ["Fly"] = 72.19, ["Ride"] = 39.38, ["Fly|Ride"] = 76.94, ["Neon"] = 262.5, ["Neon|Ride"] = 220.11, ["Neon|Fly|Ride"] = 210, ["Mega"] = 663.6, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 77.66, ["Ride"] = 110.6, ["Fly|Ride"] = 188.69, ["Neon"] = 402.81, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 1400.73, ["Mega"] = 1575}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 73.97}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 369.1, ["Fly"] = 397.45, ["Ride"] = 357.61, ["Fly|Ride"] = 404.25, ["Neon|Fly|Ride"] = 1548.2, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 137.75, ["Fly"] = 168.44, ["Ride"] = 131.25, ["Fly|Ride"] = 191.63, ["Neon"] = 442.35, ["Neon|Fly"] = 703.84, ["Neon|Ride"] = 590.54, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.94, ["Fly"] = 80.66, ["Ride"] = 65.62, ["Fly|Ride"] = 3281.25, ["Neon"] = 31.5, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 147, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 327.6, ["Mega|Fly|Ride"] = 447.45}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 234.98, ["Fly"] = 314.35, ["Ride"] = 221.92, ["Fly|Ride"] = 265.08, ["Neon|Fly"] = 883.59, ["Neon|Ride"] = 1173.89, ["Neon|Fly|Ride"] = 883.59, ["Mega|Fly|Ride"] = 2695.98}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.84, ["Fly"] = 39.48, ["Ride"] = 19.19, ["Fly|Ride"] = 52.49, ["Neon"] = 29.87, ["Neon|Fly"] = 132.71, ["Neon|Ride"] = 72.84, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 148.32, ["Fly"] = 333.62, ["Ride"] = 195.57, ["Fly|Ride"] = 353.9, ["Neon"] = 525, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 677.51, ["Mega"] = 1843.77, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 87.76, ["Ride"] = 159.26, ["Fly|Ride"] = 251.37, ["Neon"] = 420, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1852.53}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 41.58, ["Fly"] = 81.85, ["Ride"] = 58.46, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 383.74, ["Mega"] = 2894.05, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1032.87}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.27, ["Fly"] = 109.5, ["Ride"] = 56.49, ["Fly|Ride"] = 114.58, ["Neon"] = 216.45, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 277.81, ["Mega"] = 1760.32, ["Mega|Fly|Ride"] = 951.87}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 29.87, ["Fly"] = 148.19, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 413.65, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1967.44, ["Mega|Ride"] = 1769.37, ["Mega|Fly|Ride"] = 1592.61}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.82, ["Ride"] = 59.09, ["Fly|Ride"] = 126.1, ["Neon"] = 210, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 50.67, ["Fly"] = 82.95, ["Ride"] = 65.54, ["Fly|Ride"] = 137.16, ["Neon"] = 258.32, ["Neon|Ride"] = 409.23, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1174.16, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.41, ["Fly"] = 33.77, ["Ride"] = 24.94, ["Fly|Ride"] = 61.9, ["Neon"] = 27.57, ["Neon|Fly"] = 81.85, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 100.95, ["Mega"] = 183.75, ["Mega|Fly"] = 236.25, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 279.44}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.82, ["Fly"] = 551.83, ["Ride"] = 433.13, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 11059.76, ["Mega|Fly|Ride"] = 9975.86}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.11, ["Ride"] = 31.49, ["Fly|Ride"] = 137.15, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 451.2, ["Mega|Ride"] = 413.65, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 43.22, ["Ride"] = 22.32, ["Fly|Ride"] = 45.47, ["Neon"] = 65.62, ["Neon|Ride"] = 61.74, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 393.75, ["Mega|Ride"] = 383.79}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.15, ["Fly"] = 85.32, ["Ride"] = 96.24, ["Fly|Ride"] = 124.06, ["Neon"] = 441.25, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 6667.62, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1622.29}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.01, ["Ride"] = 32.08, ["Fly|Ride"] = 66.94, ["Neon"] = 82.68, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 270.57, ["Mega"] = 720.57, ["Mega|Ride"] = 754.28, ["Mega|Fly|Ride"] = 557.36}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 233.97, ["Fly"] = 300.68, ["Ride"] = 267.21, ["Fly|Ride"] = 411.39, ["Neon"] = 773, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 2875.21, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2966.11}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.44, ["Fly"] = 27.91, ["Ride"] = 24.77, ["Fly|Ride"] = 59.07, ["Neon"] = 27.57, ["Neon|Fly"] = 148.22, ["Neon|Ride"] = 46.23, ["Neon|Fly|Ride"] = 132.71, ["Mega"] = 176.96, ["Mega|Fly"] = 503.33, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.63}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1076.24, ["Fly"] = 2625, ["Ride"] = 1143.21, ["Fly|Ride"] = 1168.13, ["Neon"] = 9187.5, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 6413.91, ["Mega|Ride"] = 56622.46, ["Mega|Fly|Ride"] = 20688.64}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 20.89, ["Fly"] = 84.23, ["Ride"] = 51.97, ["Fly|Ride"] = 105.99, ["Neon"] = 210.13, ["Neon|Ride"] = 272.08, ["Neon|Fly|Ride"] = 244.37, ["Mega"] = 1043.44, ["Mega|Ride"] = 1135.72, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 226.09, ["Fly"] = 377.14, ["Ride"] = 249.38, ["Fly|Ride"] = 311.85, ["Neon"] = 945, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4044.5}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.64, ["Fly"] = 86.8, ["Ride"] = 119.44, ["Fly|Ride"] = 148.22, ["Neon"] = 104.99, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 419.96, ["Mega"] = 592.55, ["Mega|Ride"] = 590.54, ["Mega|Fly|Ride"] = 671.32}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 118.33, ["Fly"] = 165.55, ["Ride"] = 144.08, ["Fly|Ride"] = 203.44, ["Neon"] = 442.35, ["Neon|Ride"] = 546.67, ["Neon|Fly|Ride"] = 753.19, ["Mega|Ride"] = 2348.31, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 116.76, ["Fly"] = 250.08, ["Ride"] = 158.31, ["Fly|Ride"] = 237.13, ["Neon"] = 427.8, ["Neon|Fly"] = 838.67, ["Neon|Ride"] = 439.19, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1442.77}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.37}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.51, ["Fly"] = 62.99, ["Ride"] = 51.44, ["Fly|Ride"] = 77.94, ["Neon|Ride"] = 357.33, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 4423.39, ["Mega|Fly|Ride"] = 1509.27}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.76, ["Ride"] = 57.66, ["Fly|Ride"] = 212.36, ["Neon"] = 48.67, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 242.17, ["Mega"] = 287.44, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 251.04, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Ride"] = 620.82, ["Fly|Ride"] = 656.25, ["Neon"] = 1968.75, ["Neon|Fly"] = 3981.05, ["Neon|Ride"] = 3888.14, ["Neon|Fly|Ride"] = 2118.38, ["Mega|Ride"] = 15481.83, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 118.11, ["Fly"] = 157.61, ["Ride"] = 124.68, ["Fly|Ride"] = 203.34, ["Neon"] = 525, ["Neon|Ride"] = 575.07, ["Neon|Fly|Ride"] = 581.68, ["Mega"] = 2875.21, ["Mega|Fly|Ride"] = 2416.32}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3793.13, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 77.44, ["Fly"] = 236.7, ["Ride"] = 91.86, ["Fly|Ride"] = 201.68, ["Neon|Ride"] = 502.86, ["Neon|Fly|Ride"] = 335.61, ["Mega|Ride"] = 2211.96, ["Mega|Fly|Ride"] = 2084.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 79.79, ["Fly"] = 328.13, ["Ride"] = 81.12, ["Fly|Ride"] = 131.64, ["Neon"] = 575.75, ["Neon|Ride"] = 295.28, ["Neon|Fly|Ride"] = 442.35, ["Mega"] = 6488.76, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2556.73}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.54, ["Fly"] = 57.21, ["Ride"] = 45.94, ["Fly|Ride"] = 98.13, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 137.81, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2625, ["Mega|Ride"] = 945.62, ["Mega|Fly|Ride"] = 598.49}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 43.32, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 134.53, ["Neon|Ride"] = 335.67, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1341.04, ["Mega|Fly|Ride"] = 1395.59}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.11}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 143.07, ["Ride"] = 196.88, ["Fly|Ride"] = 282.19, ["Neon"] = 1180.09, ["Neon|Ride"] = 1174.16, ["Neon|Fly|Ride"] = 1324.82, ["Mega|Fly|Ride"] = 5027.31}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 799.32, ["Fly"] = 829.39, ["Ride"] = 656.25, ["Fly|Ride"] = 308.96, ["Neon"] = 2625, ["Neon|Ride"] = 3095.28, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12239.82}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.07}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.19, ["Fly"] = 58.47, ["Ride"] = 43.31, ["Fly|Ride"] = 65.59, ["Neon"] = 192.94, ["Neon|Fly"] = 287.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 220.5, ["Mega|Ride"] = 1204.2, ["Mega|Fly|Ride"] = 766.49}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 24.86}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 7372.67, ["Ride"] = 8110.28, ["Fly|Ride"] = 4882.5, ["Neon|Ride"] = 18439.35, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32156.25}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.83, ["Fly"] = 56.64, ["Ride"] = 27.57, ["Fly|Ride"] = 57.66, ["Neon"] = 90.57, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 561.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.51, ["Fly"] = 74.11, ["Ride"] = 40.23, ["Fly|Ride"] = 139.35, ["Neon"] = 95.82, ["Neon|Ride"] = 143.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 995.28, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 66.94, ["Fly"] = 117.24, ["Ride"] = 78.66, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 490.73, ["Mega"] = 4423.91, ["Mega|Fly|Ride"] = 1843.77}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.08, ["Fly"] = 74.1, ["Ride"] = 36.75, ["Fly|Ride"] = 78.74, ["Neon"] = 101.07, ["Neon|Fly"] = 221.21, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 566.28, ["Mega|Ride"] = 822.18, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.25, ["Fly"] = 2165.63, ["Ride"] = 2176.31, ["Fly|Ride"] = 1756.13, ["Neon|Fly|Ride"] = 3261.56, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 24937.5, ["Fly"] = 35316.75, ["Ride"] = 33857.25, ["Fly|Ride"] = 24176.25, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.24, ["Fly"] = 393.75, ["Ride"] = 19.92, ["Fly|Ride"] = 120.75, ["Neon"] = 295.28, ["Neon|Ride"] = 134.53, ["Neon|Fly|Ride"] = 265.41, ["Mega"] = 773, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 773}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.81, ["Fly"] = 74.1, ["Ride"] = 50.88, ["Fly|Ride"] = 163.7, ["Neon"] = 26.25, ["Neon|Fly"] = 236.7, ["Neon|Ride"] = 74.12, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 135.19, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.53, ["Ride"] = 37.26, ["Fly|Ride"] = 157.5, ["Neon"] = 72.75, ["Neon|Ride"] = 103.97, ["Neon|Fly|Ride"] = 385.18, ["Mega"] = 440.2, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 560.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 719.93, ["Ride"] = 656.25, ["Fly|Ride"] = 719.25, ["Neon"] = 3188.49, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9732.59}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 955.5, ["Fly"] = 951.57, ["Ride"] = 853.13, ["Fly|Ride"] = 972.12, ["Neon|Ride"] = 3391.64, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 14079.68}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.2, ["Fly"] = 125.74, ["Ride"] = 32.8, ["Fly|Ride"] = 77.97, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 515.4, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.73}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 88.48, ["Fly"] = 117.24, ["Ride"] = 91.85, ["Fly|Ride"] = 118.13, ["Neon"] = 588.34, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2065.97, ["Mega|Fly|Ride"] = 2166.36}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.88, ["Ride"] = 114.85, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1439.31, ["Mega|Fly|Ride"] = 2180.76}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.39, ["Fly"] = 32.82, ["Ride"] = 18.89, ["Fly|Ride"] = 59.73, ["Neon"] = 51.1, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 116.65, ["Mega"] = 295.28, ["Mega|Fly|Ride"] = 367.27}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 203.42, ["Fly"] = 224.44, ["Ride"] = 223.12, ["Fly|Ride"] = 288.74, ["Neon"] = 773, ["Neon|Ride"] = 648.38, ["Neon|Fly|Ride"] = 735, ["Mega"] = 5308.07, ["Mega|Fly|Ride"] = 2743.13}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.97, ["Ride"] = 51.19, ["Fly|Ride"] = 141.75, ["Neon"] = 47.25, ["Neon|Ride"] = 173.46, ["Neon|Fly|Ride"] = 118.08, ["Mega"] = 186.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.02, ["Mega|Fly|Ride"] = 588.34}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.07, ["Fly"] = 65.63, ["Ride"] = 32.81, ["Fly|Ride"] = 90.95, ["Neon"] = 131.24, ["Neon|Fly"] = 335.73, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.77, ["Mega|Ride"] = 653.57, ["Mega|Fly|Ride"] = 839.45}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.2, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 251.04, ["Neon|Ride"] = 215.65, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.12, ["Fly"] = 90.69, ["Ride"] = 41.98, ["Fly|Ride"] = 85.32, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 353.94, ["Mega"] = 1289.43, ["Mega|Fly|Ride"] = 883.59}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 5643.75, ["Fly|Ride"] = 5767.13, ["Neon"] = 33179.21, ["Neon|Fly|Ride"] = 32290.67, ["Mega|Fly|Ride"] = 104686.98}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 225.75, ["Fly"] = 315, ["Ride"] = 229.69, ["Fly|Ride"] = 300.57, ["Neon|Fly|Ride"] = 645.8, ["Mega|Fly|Ride"] = 2231.24}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 66.94, ["Fly"] = 161.44, ["Ride"] = 127.8, ["Fly|Ride"] = 258.56, ["Neon"] = 213.94, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 594.35, ["Mega|Ride"] = 549.64, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.5, ["Fly"] = 65.63, ["Ride"] = 35.09, ["Fly|Ride"] = 81.37, ["Neon"] = 24.94, ["Neon|Ride"] = 53.1, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 63, ["Fly"] = 215.34, ["Ride"] = 118.13, ["Fly|Ride"] = 222.18, ["Neon"] = 220.5, ["Neon|Ride"] = 250.82, ["Neon|Fly|Ride"] = 434.83, ["Mega"] = 502.28, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16931.25, ["Ride"] = 13415.07, ["Fly|Ride"] = 11550, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 110450.26}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 374.07, ["Ride"] = 392.44, ["Fly|Ride"] = 504, ["Neon|Ride"] = 1657.68, ["Neon|Fly|Ride"] = 1676.61, ["Mega|Fly|Ride"] = 8846.77}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.06, ["Fly"] = 90.5, ["Ride"] = 59.06, ["Fly|Ride"] = 113.19, ["Neon"] = 301.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 387.07, ["Mega|Fly|Ride"] = 2063.76}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.56, ["Ride"] = 23.62, ["Fly|Ride"] = 72.12, ["Neon"] = 68.52, ["Neon|Fly"] = 285.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 473.32, ["Mega|Ride"] = 754.1, ["Mega|Fly|Ride"] = 534.14}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Ride"] = 433.12, ["Fly|Ride"] = 477.75, ["Neon"] = 1731.78, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.35, ["Ride"] = 38.73, ["Fly|Ride"] = 183.75, ["Neon"] = 27.57, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 119.44, ["Mega|Ride"] = 206.8, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 114.19, ["Fly"] = 219.17, ["Ride"] = 164.73, ["Fly|Ride"] = 212.63, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 550.99, ["Mega|Fly|Ride"] = 2472.23}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.84, ["Fly"] = 21.55, ["Ride"] = 19.59, ["Fly|Ride"] = 42.75, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 2654.35, ["Mega|Fly|Ride"] = 637.22}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 83.99, ["Fly"] = 598.23, ["Ride"] = 87.06, ["Fly|Ride"] = 176.98, ["Neon"] = 244.13, ["Neon|Fly"] = 551.83, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 442.4, ["Mega|Ride"] = 2063.52, ["Mega|Fly|Ride"] = 1768.27}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 16.34, ["Fly"] = 301.73, ["Ride"] = 38.96, ["Fly|Ride"] = 94.28, ["Neon"] = 85.32, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 557.36, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1327.03}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 86, ["Fly"] = 148.22, ["Ride"] = 131.25, ["Fly|Ride"] = 442.35, ["Neon"] = 392.44, ["Neon|Ride"] = 445.44, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1676.61, ["Mega|Fly|Ride"] = 2056.02}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 6.45, ["Neon"] = 29.87, ["Neon|Ride"] = 144.89, ["Neon|Fly|Ride"] = 295.28, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.78, ["Fly"] = 56.42, ["Ride"] = 34.3, ["Fly|Ride"] = 94.9, ["Neon"] = 145.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.07, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 551.83, ["Ride"] = 529.11, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2874.1, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 43.32, ["Ride"] = 80.75, ["Fly|Ride"] = 107.54, ["Neon"] = 195.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 836.66}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.87, ["Fly"] = 147.95, ["Ride"] = 82.38, ["Fly|Ride"] = 147.4, ["Neon"] = 270.38, ["Neon|Ride"] = 234.51, ["Neon|Fly|Ride"] = 244.86, ["Mega|Ride"] = 1103.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 17.91, ["Fly"] = 72.19, ["Ride"] = 43.68, ["Fly|Ride"] = 145.29, ["Neon"] = 85.32, ["Neon|Ride"] = 228.31, ["Neon|Fly|Ride"] = 210, ["Mega"] = 485.63, ["Mega|Fly"] = 525, ["Mega|Ride"] = 551.83, ["Mega|Fly|Ride"] = 583.97}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9843.75, ["Fly"] = 10500, ["Ride"] = 8861.99, ["Fly|Ride"] = 8354.06, ["Neon|Fly|Ride"] = 15092.44, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1298.07, ["Fly"] = 1517.02, ["Ride"] = 1312.5, ["Fly|Ride"] = 1461.93, ["Neon|Fly|Ride"] = 3726.18, ["Mega|Fly|Ride"] = 16091.06}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 417.37, ["Ride"] = 459.38, ["Fly|Ride"] = 718.81, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 22119.49, ["Mega|Fly|Ride"] = 9975}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.74, ["Fly"] = 29.59, ["Ride"] = 22.3, ["Fly|Ride"] = 43.19, ["Neon"] = 59.07, ["Neon|Ride"] = 88.5, ["Neon|Fly|Ride"] = 128.21, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.48, ["Fly"] = 78.75, ["Ride"] = 33.91, ["Fly|Ride"] = 148.19, ["Neon"] = 24.94, ["Neon|Ride"] = 63.9, ["Mega"] = 145.61, ["Mega|Ride"] = 210.03, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.04, ["Fly"] = 61.03, ["Ride"] = 59.72, ["Fly|Ride"] = 102.22, ["Neon"] = 565.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 185.2, ["Mega|Fly|Ride"] = 660.09}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.83, ["Fly"] = 31.7, ["Ride"] = 17.57, ["Fly|Ride"] = 39.36, ["Neon"] = 33.2, ["Neon|Fly"] = 83.02, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 331.78, ["Mega|Ride"] = 369.41, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 296.42, ["Fly"] = 430.5, ["Ride"] = 315, ["Fly|Ride"] = 420, ["Neon"] = 1104.75, ["Neon|Ride"] = 1223.48, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4571.58}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.36, ["Fly"] = 72.34, ["Ride"] = 44.63, ["Fly|Ride"] = 78.74, ["Neon"] = 144.38, ["Neon|Fly"] = 411.41, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 168.23, ["Mega"] = 884.8, ["Mega|Fly"] = 939.08, ["Mega|Ride"] = 580.68, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.06, ["Fly"] = 21.93, ["Ride"] = 21, ["Fly|Ride"] = 49.87, ["Neon"] = 97.33, ["Neon|Fly"] = 124.98, ["Neon|Ride"] = 124.49, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 459.38, ["Fly"] = 1048.69, ["Ride"] = 459.38, ["Fly|Ride"] = 884.69, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.52, ["Fly"] = 1475.21, ["Ride"] = 1155, ["Fly|Ride"] = 1238.57, ["Neon"] = 5395.31, ["Neon|Ride"] = 4866.3, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 107.62, ["Fly"] = 148.22, ["Ride"] = 118.13, ["Fly|Ride"] = 124.69, ["Neon"] = 608.23, ["Neon|Ride"] = 671.18, ["Neon|Fly|Ride"] = 505.31, ["Mega|Ride"] = 2639.66, ["Mega|Fly|Ride"] = 2933.44}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.37, ["Fly"] = 196.88, ["Ride"] = 197.51, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 648.04, ["Neon|Fly|Ride"] = 662.42, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.88, ["Fly"] = 127.21, ["Ride"] = 55.12, ["Fly|Ride"] = 95.64, ["Neon"] = 262.49, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2211.96, ["Mega|Fly|Ride"] = 1111.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 272.05, ["Ride"] = 646.14, ["Fly|Ride"] = 590.61, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1327.03, ["Mega|Fly|Ride"] = 5899.27}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2211.7, ["Ride"] = 2216.45, ["Fly|Ride"] = 2094.65, ["Neon"] = 11059.76, ["Neon|Fly|Ride"] = 11058.45, ["Mega|Fly|Ride"] = 50868.84}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 57.66, ["Fly"] = 221.21, ["Ride"] = 52.5, ["Fly|Ride"] = 196.88, ["Neon"] = 196.86, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1224.19, ["Mega|Fly|Ride"] = 1475.21}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.74, ["Fly"] = 636.57, ["Ride"] = 619.49, ["Fly|Ride"] = 656.24, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1286.24, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.94, ["Fly"] = 65.62, ["Ride"] = 50.19, ["Fly|Ride"] = 103.58, ["Neon"] = 442.4, ["Neon|Ride"] = 265.46, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.69, ["Fly"] = 33.49, ["Ride"] = 20.97, ["Fly|Ride"] = 72.1, ["Neon"] = 48.57, ["Neon|Fly"] = 129.94, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 95.31, ["Mega"] = 157.49, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 273.17}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.4, ["Ride"] = 60.37, ["Fly|Ride"] = 157.5, ["Neon"] = 288.75, ["Neon|Ride"] = 486.34, ["Neon|Fly|Ride"] = 737.69, ["Mega"] = 1622.48, ["Mega|Ride"] = 1769.58, ["Mega|Fly|Ride"] = 1755}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1135.32, ["Fly"] = 1215.34, ["Ride"] = 1050, ["Fly|Ride"] = 1127.44, ["Neon|Ride"] = 3538.73, ["Neon|Fly|Ride"] = 3495.19, ["Mega|Fly|Ride"] = 14451.19}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 689.07, ["Ride"] = 829.39, ["Fly|Ride"] = 928.93, ["Neon|Fly|Ride"] = 4422.29, ["Mega|Fly|Ride"] = 20645.22}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.37, ["Fly"] = 31.5, ["Ride"] = 22.76, ["Fly|Ride"] = 44.62, ["Neon"] = 144.38, ["Neon|Ride"] = 114.8, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 18.38, ["Ride"] = 43.32, ["Fly|Ride"] = 111.57, ["Neon"] = 249.38, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1224.45, ["Mega|Ride"] = 1459.74, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.36, ["Fly"] = 70.88, ["Ride"] = 47.14, ["Fly|Ride"] = 105, ["Neon"] = 26.17, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 175.75, ["Mega"] = 188.62, ["Mega|Fly"] = 587.08, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 50.88, ["Fly"] = 60.27, ["Ride"] = 48.85, ["Fly|Ride"] = 118.13, ["Neon"] = 326.25, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 1074.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.29, ["Ride"] = 189, ["Fly|Ride"] = 369.41, ["Neon"] = 458.07, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2651.25}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.84, ["Fly"] = 59.05, ["Ride"] = 32.81, ["Fly|Ride"] = 83.64, ["Neon"] = 110.6, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 202.99, ["Mega"] = 442.4, ["Mega|Ride"] = 385.88, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.82, ["Fly"] = 64.32, ["Ride"] = 44.6, ["Fly|Ride"] = 78.09, ["Neon"] = 242.82, ["Neon|Ride"] = 207.9, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 2100, ["Mega|Ride"] = 1150.23, ["Mega|Fly|Ride"] = 1341.04}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.83, ["Fly"] = 50.94, ["Ride"] = 18.37, ["Fly|Ride"] = 44.67, ["Neon"] = 34.04, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 116.18, ["Mega"] = 434.74, ["Mega|Ride"] = 502.74, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.66, ["Fly"] = 58.23, ["Ride"] = 30.11, ["Fly|Ride"] = 109.36, ["Neon"] = 60.29, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.66, ["Neon|Fly|Ride"] = 220.07, ["Mega"] = 552.93, ["Mega|Ride"] = 481.32, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.15, ["Fly"] = 72.18, ["Ride"] = 53.92, ["Fly|Ride"] = 102.37, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 1525.79, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1312.49, ["Fly"] = 1575, ["Ride"] = 1430.63, ["Fly|Ride"] = 1418.82, ["Neon|Ride"] = 5027.31, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 581.68, ["Ride"] = 523.69, ["Fly|Ride"] = 572.24, ["Neon|Ride"] = 3323.82, ["Neon|Fly|Ride"] = 2332.32, ["Mega"] = 15481.83, ["Mega|Fly|Ride"] = 9952.61}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Ride"] = 328.13, ["Fly|Ride"] = 328.02, ["Neon"] = 1575, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1868.89, ["Mega|Fly|Ride"] = 8110.28}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.29}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 39.74, ["Ride"] = 49.79, ["Fly|Ride"] = 148.19, ["Neon"] = 329.44, ["Neon|Fly"] = 590.61, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1216.44, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 90562.5, ["Ride"] = 38551.89, ["Fly|Ride"] = 20993.44, ["Neon|Fly|Ride"] = 33468.75, ["Mega"] = 221168.84, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.45, ["Fly"] = 284.82, ["Ride"] = 275.63, ["Fly|Ride"] = 354.38, ["Neon"] = 1023.75, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 1005.47, ["Neon|Fly|Ride"] = 912.19, ["Mega"] = 6635.85, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 146.35, ["Fly"] = 525, ["Ride"] = 165.83, ["Fly|Ride"] = 295.32}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 85.32, ["Fly"] = 221.21, ["Ride"] = 110.86, ["Fly|Ride"] = 182.44, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 627.86, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.42, ["Fly"] = 63.56, ["Ride"] = 35.32, ["Fly|Ride"] = 65.63, ["Neon"] = 84.23, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 159.26, ["Neon|Fly|Ride"] = 242.2, ["Mega"] = 1968.75, ["Mega|Ride"] = 737.69, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5346.53, ["Ride"] = 4058.25, ["Fly|Ride"] = 4200, ["Neon"] = 22119.49, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 83885.54}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.39, ["Fly"] = 52.31, ["Ride"] = 34.85, ["Fly|Ride"] = 57.75, ["Neon"] = 131.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 190.21, ["Mega|Ride"] = 1475.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 30.18, ["Fly"] = 108.39, ["Ride"] = 59.07, ["Fly|Ride"] = 91.88, ["Neon"] = 317.43, ["Neon|Fly"] = 1475.21, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 351.67, ["Mega|Fly|Ride"] = 1475.21}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 434.78, ["Fly"] = 563.07, ["Ride"] = 446.25, ["Fly|Ride"] = 544.69, ["Neon"] = 1174.69, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1364.53, ["Mega|Fly|Ride"] = 4411.22}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.02, ["Fly"] = 30.86, ["Ride"] = 29.72, ["Fly|Ride"] = 44.63, ["Neon"] = 131.25, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 671.18}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.72, ["Fly"] = 295.28, ["Ride"] = 35.43, ["Fly|Ride"] = 82.99, ["Neon"] = 126.09, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 217.7, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 754.1}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.43, ["Ride"] = 104.99, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 706.74, ["Mega|Fly|Ride"] = 4192.49}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.56, ["Fly"] = 88.45, ["Ride"] = 76.13, ["Fly|Ride"] = 150.94, ["Neon"] = 85.31, ["Neon|Ride"] = 140.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 383.25, ["Mega|Fly"] = 354.38, ["Mega|Ride"] = 287.97, ["Mega|Fly|Ride"] = 904.93}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4331.25, ["Ride"] = 4923.19, ["Fly|Ride"] = 4593.75, ["Neon"] = 19687.5, ["Neon|Ride"] = 13403.38, ["Neon|Fly|Ride"] = 11811.19, ["Mega"] = 66350.66, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 35.43, ["Fly"] = 75.22, ["Ride"] = 52.5, ["Fly|Ride"] = 144.38, ["Neon"] = 233.62, ["Neon|Ride"] = 265.41, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1254.05, ["Mega|Ride"] = 1845.9, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7875, ["Ride"] = 6168.75, ["Fly|Ride"] = 6168.74, ["Neon"] = 23461.11, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.24, ["Fly"] = 24.88, ["Ride"] = 15.08, ["Fly|Ride"] = 33.87, ["Neon"] = 28.76, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 103.76, ["Mega"] = 242.82, ["Mega|Ride"] = 219.01, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 16.69, ["Fly"] = 33.99, ["Ride"] = 32.82, ["Fly|Ride"] = 52.5, ["Neon"] = 91.94, ["Neon|Fly"] = 244.43, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 166.19, ["Mega|Ride"] = 880.04, ["Mega|Fly|Ride"] = 884.8}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.8}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.63, ["Fly"] = 47.57, ["Ride"] = 33.39, ["Fly|Ride"] = 91.82, ["Neon"] = 131.24, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1049.9, ["Mega|Ride"] = 1178.99, ["Mega|Fly|Ride"] = 1153.41}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.99, ["Fly"] = 190.37, ["Ride"] = 62.72, ["Fly|Ride"] = 157.07, ["Neon"] = 148.19, ["Neon|Ride"] = 292.62, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2046.07, ["Mega|Ride"] = 884.69, ["Mega|Fly|Ride"] = 838.31}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.63, ["Fly"] = 27.57, ["Ride"] = 21.37, ["Fly|Ride"] = 42, ["Neon|Fly"] = 1102.67, ["Neon|Ride"] = 110.61, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 2654.35, ["Mega|Fly|Ride"] = 648.11}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8840.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.68}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 267.75, ["Ride"] = 203.44, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1242.04}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.58, ["Fly"] = 52.5, ["Ride"] = 36.93, ["Fly|Ride"] = 97.13, ["Neon"] = 168.51, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 568.41, ["Mega|Ride"] = 2105.19, ["Mega|Fly|Ride"] = 573.95}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 14.04}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.67, ["Ride"] = 25.98, ["Fly|Ride"] = 88.5, ["Neon"] = 148.22, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2493.75}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 250.59, ["Fly"] = 442.35, ["Ride"] = 262.5, ["Fly|Ride"] = 754.28, ["Neon"] = 1174.16, ["Neon|Ride"] = 1107.27, ["Neon|Fly|Ride"] = 1104.75, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 65.63, ["Fly"] = 221.21, ["Ride"] = 96.46, ["Fly|Ride"] = 525, ["Neon"] = 427.33, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2209.75}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 147.86, ["Fly"] = 269.05, ["Ride"] = 183.75, ["Fly|Ride"] = 247.22, ["Neon"] = 945, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3760.32, ["Mega|Fly|Ride"] = 3279.94}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2436, ["Fly"] = 3391.64, ["Ride"] = 2756.25, ["Fly|Ride"] = 2585.63, ["Neon"] = 15534.52, ["Neon|Fly|Ride"] = 8847.8, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 19.66, ["Fly"] = 109.51, ["Ride"] = 57.75, ["Fly|Ride"] = 86.47, ["Neon"] = 127.32, ["Neon|Ride"] = 160.89, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 994.29, ["Mega|Ride"] = 1216.44, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 838.31, ["Fly"] = 2231.25, ["Ride"] = 838.31, ["Fly|Ride"] = 1179.95, ["Neon|Fly|Ride"] = 5528.13}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 43.32}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 24.94, ["Ride"] = 48.67, ["Fly|Ride"] = 203.44, ["Neon"] = 115.5, ["Neon|Ride"] = 137.15, ["Neon|Fly|Ride"] = 269.88, ["Mega"] = 483, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 10.06, ["Fly"] = 52.78, ["Ride"] = 30.11, ["Fly|Ride"] = 77.96, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 470.17, ["Mega|Ride"] = 284.07, ["Mega|Fly|Ride"] = 380.47}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.61}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21.56, ["Fly"] = 66.38, ["Ride"] = 32.8, ["Fly|Ride"] = 78.53, ["Neon"] = 146.02, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1327.18, ["Mega|Fly|Ride"] = 1005.47}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 50.88, ["Ride"] = 32.48, ["Fly|Ride"] = 62.99, ["Neon"] = 148.19, ["Neon|Fly"] = 244.4, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 294.18, ["Mega"] = 1475.21, ["Mega|Ride"] = 1887.43, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7075.21, ["Fly"] = 5643.75, ["Ride"] = 6613.95, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.09, ["Fly"] = 50.88, ["Ride"] = 34.04, ["Fly|Ride"] = 88.49, ["Neon"] = 57.18, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 240.12, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 637.22}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.3}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.95, ["Fly"] = 391.53, ["Ride"] = 118.13, ["Fly|Ride"] = 209.92, ["Neon"] = 531.57, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 526.23, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 59.07, ["Fly"] = 194.81, ["Ride"] = 85.94, ["Fly|Ride"] = 176.49, ["Neon"] = 308.44, ["Neon|Fly"] = 402.21, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 590.61, ["Mega"] = 2514.72, ["Mega|Ride"] = 1005.47, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 24.43, ["Fly"] = 84.07, ["Ride"] = 29.87, ["Fly|Ride"] = 65.62, ["Neon"] = 174.57, ["Neon|Fly"] = 238.9, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.21, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 1061.63}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.83, ["Fly"] = 78.74, ["Ride"] = 29.79, ["Fly|Ride"] = 106.32, ["Neon"] = 35.95, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 221.19, ["Mega"] = 250.69, ["Mega|Fly"] = 7372.67, ["Mega|Ride"] = 229.09, ["Mega|Fly|Ride"] = 354.25}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.01, ["Fly"] = 65.63, ["Ride"] = 31.53, ["Fly|Ride"] = 95.12, ["Neon"] = 87.44, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 234.46, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 551.83}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21.94, ["Fly"] = 32.46, ["Ride"] = 29.87, ["Fly|Ride"] = 52.5, ["Neon"] = 188.03, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 146.9, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 192.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.92, ["Ride"] = 164.07, ["Fly|Ride"] = 339.94, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 436.87, ["Mega"] = 866.25, ["Mega|Ride"] = 787.37, ["Mega|Fly|Ride"] = 743.05}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["Ride"] = 1475.21, ["Neon|Fly|Ride"] = 73731.94}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 55.13, ["Ride"] = 91.88, ["Fly|Ride"] = 140.45, ["Neon"] = 216.57, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1173.38, ["Mega|Ride"] = 1325.91, ["Mega|Fly|Ride"] = 1626.34}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1155, ["Fly"] = 1233.75, ["Ride"] = 1232.44, ["Fly|Ride"] = 1442.44, ["Neon"] = 4838.78, ["Neon|Fly"] = 4838.78, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 419.99, ["Fly"] = 838.31, ["Ride"] = 479.07, ["Fly|Ride"] = 596.19, ["Neon"] = 3244.56, ["Neon|Ride"] = 2211.7, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 13271.69, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 58.28}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.9, ["Fly"] = 32.8, ["Ride"] = 24.82, ["Fly|Ride"] = 42.66, ["Neon"] = 84.23, ["Neon|Fly"] = 163.7, ["Neon|Ride"] = 86.27, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 437.26, ["Mega|Ride"] = 671.94, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 243.49, ["Fly"] = 361.64, ["Ride"] = 274.17, ["Fly|Ride"] = 370.32, ["Neon"] = 1206.58, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3669.21}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.63}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 116.82, ["Ride"] = 181.25, ["Fly|Ride"] = 262.5, ["Neon"] = 761.25, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2809.03, ["Mega|Ride"] = 2505.5, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 295.32, ["Ride"] = 131.15, ["Fly|Ride"] = 262.5, ["Neon"] = 884.8, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2347.76}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.78, ["Ride"] = 28.58, ["Fly|Ride"] = 221.19, ["Neon"] = 32.34, ["Neon|Ride"] = 69.62, ["Neon|Fly|Ride"] = 265.41, ["Mega"] = 170.63, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 388.17}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.41, ["Fly"] = 50.93, ["Ride"] = 29.57, ["Fly|Ride"] = 72.19, ["Neon"] = 110.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 236.66, ["Mega|Ride"] = 774.11, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.12, ["Fly"] = 102.36, ["Ride"] = 34.51, ["Fly|Ride"] = 131.25, ["Neon"] = 85.31, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.91, ["Fly"] = 176.96, ["Ride"] = 51.19, ["Fly|Ride"] = 162.22, ["Neon"] = 31.5, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 190.32, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 298.2}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 275.42, ["Ride"] = 324.19, ["Fly|Ride"] = 317.71, ["Neon"] = 1470.79, ["Neon|Ride"] = 1443.18, ["Neon|Fly|Ride"] = 1409.82, ["Mega|Ride"] = 5172.44, ["Mega|Fly|Ride"] = 7343.63}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 95.79, ["Fly"] = 585.21, ["Ride"] = 124.69, ["Fly|Ride"] = 196.88, ["Neon"] = 459.37, ["Neon|Ride"] = 485.52, ["Neon|Fly|Ride"] = 514.48, ["Mega"] = 2022.57, ["Mega|Ride"] = 2078.79, ["Mega|Fly|Ride"] = 2732.56}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.55, ["Fly"] = 167.45, ["Ride"] = 78.43, ["Fly|Ride"] = 122.14, ["Neon"] = 369.41, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 429.54, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1374.18}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Fly"] = 127.32, ["Ride"] = 55.31, ["Neon|Ride"] = 639.22, ["Neon|Fly|Ride"] = 335.67}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.44, ["Ride"] = 32.69, ["Fly|Ride"] = 99.82, ["Neon"] = 72.85, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 807.19, ["Mega|Ride"] = 537.95, ["Mega|Fly|Ride"] = 590.54}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 43.32, ["Ride"] = 25.16, ["Fly|Ride"] = 51.9, ["Neon"] = 22.32, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 236.66, ["Mega|Ride"] = 186.88, ["Mega|Fly|Ride"] = 288.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1049.99, ["Fly"] = 1050, ["Ride"] = 967.32, ["Fly|Ride"] = 972.57, ["Neon"] = 4423.91, ["Neon|Fly"] = 3403.73, ["Neon|Ride"] = 8846.77, ["Neon|Fly|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 249.34, ["Fly"] = 357.25, ["Ride"] = 299.31, ["Fly|Ride"] = 343.88, ["Neon"] = 1104.75, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1179.95, ["Mega"] = 11059.76, ["Mega|Fly|Ride"] = 5195.71}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 101.06, ["Fly"] = 174.17, ["Ride"] = 116.94, ["Fly|Ride"] = 137.82, ["Neon"] = 524.19, ["Neon|Ride"] = 421.52, ["Neon|Fly|Ride"] = 572.84, ["Mega"] = 1575, ["Mega|Ride"] = 1799.44, ["Mega|Fly|Ride"] = 1917.55}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 232.32, ["Fly"] = 283.5, ["Ride"] = 219.18, ["Fly|Ride"] = 240.19, ["Neon"] = 1048.69, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 11059.76, ["Mega|Fly|Ride"] = 4192.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.22, ["Fly"] = 59.73, ["Ride"] = 33.88, ["Fly|Ride"] = 52.5, ["Neon"] = 170.63, ["Neon|Ride"] = 145.99, ["Neon|Fly|Ride"] = 206.8, ["Mega|Ride"] = 781.85, ["Mega|Fly|Ride"] = 1032.87}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 204.75, ["Ride"] = 262.5, ["Fly|Ride"] = 418.69, ["Neon"] = 1105.86, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 1254.05, ["Mega"] = 4402.1, ["Mega|Fly|Ride"] = 5160.99}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 96.14, ["Fly"] = 126, ["Ride"] = 98.44, ["Fly|Ride"] = 131.22, ["Neon|Ride"] = 1677.33, ["Mega|Ride"] = 2359.89, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2730, ["Ride"] = 2377.75, ["Fly|Ride"] = 2835, ["Neon|Ride"] = 11733.9, ["Neon|Fly|Ride"] = 7481.25, ["Mega"] = 53086.73, ["Mega|Fly|Ride"] = 31504.76}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.5, ["Fly"] = 106.16, ["Ride"] = 46.57, ["Fly|Ride"] = 116.81, ["Neon"] = 57.16, ["Neon|Fly"] = 105, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 168.44, ["Mega"] = 268.63, ["Mega|Ride"] = 335.6, ["Mega|Fly|Ride"] = 450.62}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 29.84, ["Ride"] = 72.18, ["Fly|Ride"] = 148.32, ["Neon"] = 216.57, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 413.44, ["Mega|Ride"] = 883.59, ["Mega|Fly|Ride"] = 995.28}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 102.25, ["Ride"] = 65.63, ["Fly|Ride"] = 78.75, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2231.25, ["Fly"] = 1677.33, ["Ride"] = 1073.62, ["Fly|Ride"] = 1039.5, ["Neon|Ride"] = 5868.09, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 42022.1, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 441.94, ["Fly"] = 882.58, ["Ride"] = 481.05, ["Fly|Ride"] = 534.19, ["Mega"] = 11612.73}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 65.63, ["Fly"] = 124.69, ["Ride"] = 126, ["Fly|Ride"] = 195.57, ["Neon"] = 453.48, ["Neon|Ride"] = 345.84, ["Neon|Fly|Ride"] = 502.74, ["Mega"] = 2654.05, ["Mega|Ride"] = 2682.07, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.69, ["Fly"] = 42.75, ["Ride"] = 25.35, ["Fly|Ride"] = 63.26, ["Neon"] = 76.4, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 150.65, ["Mega"] = 656.25, ["Mega|Ride"] = 823.93}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 42.9, ["Fly"] = 68.25, ["Ride"] = 55.31, ["Fly|Ride"] = 118.36, ["Neon"] = 163.7, ["Neon|Ride"] = 287.57, ["Neon|Fly|Ride"] = 335.61, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1156.78, ["Ride"] = 892.5, ["Fly|Ride"] = 887.58, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 721.88}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5381.25, ["Ride"] = 5313, ["Fly|Ride"] = 5381.25, ["Neon"] = 15750, ["Neon|Ride"] = 31694.61, ["Neon|Fly|Ride"] = 27405, ["Mega|Fly|Ride"] = 85709.23}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 242.82, ["Fly"] = 414.32, ["Ride"] = 320.71, ["Fly|Ride"] = 437.49, ["Neon"] = 1769.37, ["Neon|Fly|Ride"] = 2211.7, ["Mega"] = 6634.76, ["Mega|Fly|Ride"] = 6635.08}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 94.5, ["Ride"] = 157.4, ["Fly|Ride"] = 166.45, ["Neon"] = 2210.6, ["Neon|Ride"] = 295.28, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 1990.54}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.63, ["Fly"] = 74.1, ["Ride"] = 40.67, ["Fly|Ride"] = 96.15, ["Neon"] = 295.32, ["Neon|Ride"] = 175.96, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 671.18, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.06, ["Fly"] = 32.82, ["Ride"] = 26.81, ["Fly|Ride"] = 52.49, ["Neon"] = 148.22, ["Neon|Fly"] = 295.28, ["Neon|Ride"] = 132.71, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 4407.12}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.75, ["Fly"] = 167.02, ["Ride"] = 39.79, ["Fly|Ride"] = 105.91, ["Neon"] = 124.69, ["Neon|Ride"] = 122.14, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 670.69, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 662.42}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 37.63, ["Ride"] = 23.63, ["Fly|Ride"] = 50.19, ["Neon"] = 41.2, ["Neon|Fly"] = 364.95, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 139.35, ["Mega"] = 675, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 269.62}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.29, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 111.57, ["Neon|Fly"] = 884.69, ["Neon|Ride"] = 145.01, ["Neon|Fly|Ride"] = 330.72, ["Mega"] = 630, ["Mega|Ride"] = 737.61, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 572.25, ["Fly"] = 577.5, ["Ride"] = 662.84, ["Fly|Ride"] = 681.19, ["Neon|Ride"] = 2098.69, ["Neon|Fly|Ride"] = 2206.79, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 7667.93}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.36, ["Fly"] = 19.69, ["Ride"] = 13.81, ["Fly|Ride"] = 37.58, ["Neon"] = 28.93, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 43.3, ["Fly"] = 105, ["Ride"] = 78.72, ["Fly|Ride"] = 133.82, ["Neon"] = 190.32, ["Neon|Fly"] = 430.71, ["Neon|Ride"] = 196.65, ["Neon|Fly|Ride"] = 307.13, ["Mega"] = 557.82, ["Mega|Fly"] = 884.8, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.49, ["Ride"] = 804.32, ["Fly|Ride"] = 833.44, ["Neon|Fly"] = 2284.69, ["Neon|Ride"] = 2802.23, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4517.61}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 34.12, ["Fly"] = 70.87, ["Ride"] = 49.82, ["Fly|Ride"] = 97.46, ["Neon"] = 249.38, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1257.37, ["Mega|Ride"] = 927.94, ["Mega|Fly|Ride"] = 885.91}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 325.39, ["Fly"] = 442.35, ["Ride"] = 295.32, ["Fly|Ride"] = 334.69, ["Neon|Fly|Ride"] = 1181.25}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 273.92, ["Fly"] = 587.08, ["Ride"] = 327.92, ["Fly|Ride"] = 373.42, ["Neon"] = 656.25, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 938.43, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 4970.78}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 774.38, ["Ride"] = 737.63, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 3688.43, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.48, ["Fly"] = 88.49, ["Ride"] = 54.06, ["Fly|Ride"] = 107.47, ["Neon"] = 61.69, ["Neon|Fly"] = 301.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 168.44, ["Mega"] = 275.63, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 441.25}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3714.38, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3478.13, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19686.19}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 131.14, ["Fly"] = 178.47, ["Ride"] = 131.25, ["Fly|Ride"] = 209.83, ["Neon"] = 535.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 3317.54, ["Mega|Fly|Ride"] = 3481.62}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.13, ["Fly"] = 31.43, ["Ride"] = 19.55, ["Fly|Ride"] = 43.32, ["Neon"] = 22.32, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 236.66, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 291.27, ["Mega|Fly|Ride"] = 300.95}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 25.66, ["Neon|Fly"] = 123.23, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 190.32, ["Mega|Ride"] = 394.49, ["Mega|Fly|Ride"] = 389.82}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 49.87, ["Fly"] = 64.15, ["Ride"] = 56.35, ["Fly|Ride"] = 67.25, ["Neon"] = 301.67, ["Neon|Ride"] = 420.28, ["Neon|Fly|Ride"] = 274.17, ["Mega|Fly|Ride"] = 1280.58}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 918.75, ["Fly"] = 1206.85, ["Ride"] = 1035.57, ["Fly|Ride"] = 1105.13, ["Neon|Ride"] = 11736.15, ["Neon|Fly|Ride"] = 5018.41}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 9244.87, ["Fly|Ride"] = 10434.38}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.31, ["Fly"] = 30.11, ["Ride"] = 27.57, ["Fly|Ride"] = 47.25, ["Neon"] = 176.98, ["Neon|Ride"] = 142.79, ["Neon|Fly|Ride"] = 170.61, ["Mega"] = 2520, ["Mega|Ride"] = 888.79, ["Mega|Fly|Ride"] = 811.11}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.12, ["Fly"] = 48.67, ["Ride"] = 28.83, ["Fly|Ride"] = 61.41, ["Neon"] = 123.61, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 164.68, ["Mega"] = 675.63, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 95.47, ["Ride"] = 107.04, ["Fly|Ride"] = 156.18, ["Neon|Ride"] = 641.41, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.17, ["Fly"] = 1105.98, ["Ride"] = 245.43, ["Fly|Ride"] = 314.99, ["Neon"] = 1305.94, ["Neon|Ride"] = 934.76, ["Neon|Fly|Ride"] = 754.17, ["Mega"] = 11059.76, ["Mega|Fly|Ride"] = 4364.78}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 35.4, ["Fly|Ride"] = 65.63, ["Neon"] = 32.48, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 72.19, ["Mega"] = 136.5, ["Mega|Fly"] = 246.65, ["Mega|Ride"] = 154.62, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.09, ["Fly"] = 257.25, ["Ride"] = 217.92, ["Fly|Ride"] = 262.5, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 701.67, ["Mega|Fly|Ride"] = 3078.69}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.12, ["Fly"] = 31.49, ["Ride"] = 16.88, ["Fly|Ride"] = 61.94, ["Neon"] = 24.68, ["Neon|Fly"] = 132.71, ["Neon|Ride"] = 44.25, ["Neon|Fly|Ride"] = 121.67, ["Mega"] = 413.65, ["Mega|Fly"] = 295.32, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 297.94, ["Fly"] = 354.38, ["Ride"] = 341.25, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1436.25, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 11058.45, ["Mega|Fly|Ride"] = 5698.44}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13, ["Fly"] = 104.98, ["Ride"] = 28.45, ["Fly|Ride"] = 52.5, ["Neon"] = 90.55, ["Neon|Fly"] = 319.38, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 590.54, ["Mega|Ride"] = 455.67, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 74.11, ["Ride"] = 23.14, ["Neon"] = 8.78, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 168.51, ["Mega"] = 94.39, ["Mega|Ride"] = 155, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.87, ["Mega"] = 23.15, ["Mega|Ride"] = 159.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 331.8, ["Fly|Ride"] = 205.71, ["Neon"] = 9.19, ["Neon|Ride"] = 67.91, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 61.02, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 139.35, ["Mega|Fly|Ride"] = 256.41}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 72.19, ["Fly"] = 168.47, ["Ride"] = 101.07, ["Fly|Ride"] = 170.63, ["Neon"] = 236.25, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 2211.96}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.99, ["Ride"] = 16.41, ["Fly|Ride"] = 34.36, ["Neon"] = 5.24, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 73.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 8.56, ["Ride"] = 62.99, ["Neon"] = 82.28, ["Neon|Fly"] = 335.67, ["Neon|Ride"] = 314.9, ["Neon|Fly|Ride"] = 369.37, ["Mega"] = 420, ["Mega|Ride"] = 588.34, ["Mega|Fly|Ride"] = 556.88}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.62, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 203.48, ["Mega"] = 26.25, ["Mega|Ride"] = 58.4, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.55, ["Ride"] = 16.61, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 44.25, ["Neon|Ride"] = 15.86, ["Neon|Fly|Ride"] = 42, ["Mega"] = 14.32, ["Mega|Fly"] = 36.92, ["Mega|Ride"] = 22.09, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 16.57, ["Fly|Ride"] = 51.99, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 17.35, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 19.69, ["Mega|Fly"] = 168.51, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 92.85}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 44.25, ["Neon"] = 2.63, ["Neon|Fly"] = 28.77, ["Neon|Ride"] = 65.63, ["Mega"] = 19.69, ["Mega|Ride"] = 110.6, ["Mega|Fly|Ride"] = 218.71}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.93, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 5.25, ["Neon|Fly"] = 126.09, ["Neon|Ride"] = 23.68, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.94, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 89.06, ["Neon|Fly|Ride"] = 442.35, ["Mega"] = 17.85, ["Mega|Ride"] = 97.13}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 9.08, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 97.13, ["Neon"] = 52.5, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 197.3, ["Mega"] = 236.24, ["Mega|Fly"] = 353.9, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 378.31}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.75, ["Neon|Fly|Ride"] = 210.13, ["Mega"] = 28.55, ["Mega|Fly"] = 153.39, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Fly|Ride"] = 52.5, ["Neon"] = 23.63, ["Mega"] = 120.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 44.25, ["Neon"] = 22.98, ["Mega"] = 134.96, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 148.22, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 22.31, ["Mega|Ride"] = 38.85, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.77, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.72, ["Neon|Fly|Ride"] = 44.25, ["Mega"] = 14.42, ["Mega|Fly"] = 26.24, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 54.52}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.13, ["Neon"] = 39.81, ["Neon|Ride"] = 143.78, ["Neon|Fly|Ride"] = 737.61, ["Mega"] = 206.8, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 3.7, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 32.18, ["Mega|Ride"] = 59.73, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.74, ["Neon"] = 13.13, ["Neon|Ride"] = 105, ["Mega"] = 106.32, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 80.54, ["Ride"] = 28.87, ["Fly|Ride"] = 48.57, ["Neon"] = 11.58, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 168.44, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 14.44, ["Fly|Ride"] = 38.73, ["Neon"] = 2.1, ["Neon|Fly"] = 20.4, ["Neon|Ride"] = 13.75, ["Neon|Fly|Ride"] = 42, ["Mega"] = 14.43, ["Mega|Fly"] = 28.19, ["Mega|Ride"] = 22.13, ["Mega|Fly|Ride"] = 52.49}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27.43, ["Fly|Ride"] = 52.5, ["Neon"] = 13.2, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.66, ["Mega|Ride"] = 162.42, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.7, ["Fly"] = 118.13, ["Ride"] = 148.22, ["Fly|Ride"] = 93.19, ["Neon"] = 74.1, ["Neon|Ride"] = 73.43, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 330.66, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 59.73, ["Ride"] = 14.42, ["Fly|Ride"] = 41.65, ["Neon"] = 2.1, ["Neon|Fly"] = 20.07, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 24.94, ["Mega|Fly"] = 35.65, ["Mega|Ride"] = 36.61, ["Mega|Fly|Ride"] = 88.49}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 184.7, ["Ride"] = 22.13, ["Neon"] = 5.76, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 57.74, ["Mega|Fly"] = 168.51, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 216.53}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 3.71, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 51.98, ["Mega"] = 32.79, ["Mega|Ride"] = 88.49, ["Mega|Fly|Ride"] = 194.92}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 21.04, ["Fly|Ride"] = 48.55, ["Neon"] = 2.1, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 132.74, ["Mega"] = 15.42, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 74.1, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 24.35, ["Ride"] = 20.83, ["Fly|Ride"] = 55.42, ["Neon"] = 7.69, ["Neon|Fly"] = 59.18, ["Neon|Ride"] = 44.64, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 105.24, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 151.92}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.77, ["Neon"] = 6.3, ["Neon|Ride"] = 58.11, ["Mega"] = 56.31, ["Mega|Fly"] = 218.75, ["Mega|Ride"] = 118.34, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.69, ["Ride"] = 18.87, ["Fly|Ride"] = 40.68, ["Neon"] = 6.2, ["Neon|Fly"] = 79.66, ["Neon|Ride"] = 26.18, ["Neon|Fly|Ride"] = 59.73, ["Mega"] = 114.19, ["Mega|Ride"] = 117.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 33.95, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 663.6}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.02, ["Ride"] = 21.49, ["Fly|Ride"] = 51.19, ["Neon"] = 6.54, ["Neon|Fly"] = 50.29, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 78.75, ["Mega|Fly"] = 420, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 192.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 18.38, ["Fly|Ride"] = 72.12, ["Neon"] = 19.45, ["Neon|Fly"] = 32.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 62.34, ["Mega"] = 170.34, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 360.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 117.24, ["Fly|Ride"] = 148.22, ["Neon"] = 19.48, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 259.88, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.57, ["Ride"] = 98.44, ["Neon"] = 88.5, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.29, ["Ride"] = 26.25, ["Neon"] = 57.2, ["Neon|Ride"] = 132.71, ["Mega"] = 238.88, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.81, ["Ride"] = 73.5, ["Fly|Ride"] = 104.99, ["Neon"] = 52.45, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 233.83, ["Mega|Ride"] = 334.14, ["Mega|Fly|Ride"] = 448.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.05, ["Mega"] = 19.68, ["Mega|Fly"] = 220.11, ["Mega|Ride"] = 132.74, ["Mega|Fly|Ride"] = 261}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.86}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.49, ["Fly"] = 33.2, ["Ride"] = 23.31, ["Fly|Ride"] = 51.09, ["Neon"] = 45.94, ["Neon|Fly"] = 189, ["Neon|Ride"] = 49.62, ["Neon|Fly|Ride"] = 122.78, ["Mega"] = 286.47, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 266.52}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Neon"] = 6.58, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 27.57, ["Mega|Fly"] = 148.19, ["Mega|Ride"] = 74.1, ["Mega|Fly|Ride"] = 129.55}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.43, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 74.42, ["Mega"] = 34.13, ["Mega|Ride"] = 64.8, ["Mega|Fly|Ride"] = 174.45}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 46.12, ["Ride"] = 16.14, ["Fly|Ride"] = 46.19, ["Neon"] = 9.59, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164.01, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 168.47}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.29, ["Fly"] = 57.52, ["Ride"] = 32.82, ["Fly|Ride"] = 125.85, ["Neon"] = 48.49, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 232.32, ["Mega|Ride"] = 348.95, ["Mega|Fly|Ride"] = 349.46}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.55, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 163.7, ["Mega"] = 18.9, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 165.89}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.89, ["Ride"] = 17.18, ["Fly|Ride"] = 65.63, ["Neon"] = 6.64, ["Neon|Fly"] = 115.04, ["Neon|Ride"] = 20.86, ["Neon|Fly|Ride"] = 100.21, ["Mega"] = 40.46, ["Mega|Fly"] = 148.19, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 139.35}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 18.32, ["Fly|Ride"] = 53.68, ["Neon"] = 6.29, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 21.86, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 95.12, ["Mega|Fly"] = 148.19, ["Mega|Ride"] = 68.58, ["Mega|Fly|Ride"] = 129.95}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.94, ["Fly"] = 91.88, ["Ride"] = 57.46, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 98.44, ["Mega|Ride"] = 154.61, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.39, ["Neon|Ride"] = 109.81, ["Neon|Fly|Ride"] = 162064.77, ["Mega"] = 16.67, ["Mega|Fly"] = 106.18, ["Mega|Ride"] = 44.46, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.77, ["Neon"] = 3.33, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.8, ["Neon|Fly|Ride"] = 67.69, ["Mega"] = 19.5, ["Mega|Fly"] = 74.11, ["Mega|Ride"] = 41.25, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.34, ["Neon|Fly"] = 50.3, ["Mega"] = 28.88, ["Mega|Ride"] = 134.17}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.6, ["Mega|Ride"] = 292.69, ["Mega|Fly|Ride"] = 168.47}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.37, ["Fly|Ride"] = 69.56, ["Neon"] = 3.92, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 18.84, ["Neon|Fly|Ride"] = 48.9, ["Mega"] = 34.13, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.7, ["Ride"] = 78.75, ["Fly|Ride"] = 221.19, ["Neon"] = 84.23, ["Neon|Ride"] = 77.97, ["Mega"] = 389.82, ["Mega|Ride"] = 502.06, ["Mega|Fly|Ride"] = 619.28}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 53.81, ["Neon"] = 43.14, ["Neon|Ride"] = 157.5, ["Mega"] = 251.37, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.95, ["Fly|Ride"] = 131.25, ["Neon"] = 25.71, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 294.66, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.75, ["Fly|Ride"] = 39.83, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 33.91, ["Mega"] = 15.23, ["Mega|Fly"] = 105, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 107.67}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 61.69, ["Neon"] = 12.57, ["Neon|Fly"] = 74.11, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 737.61, ["Mega"] = 57.52, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.44, ["Mega|Fly"] = 148.22, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.21, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 148.19, ["Ride"] = 20.45, ["Fly|Ride"] = 47.61, ["Neon"] = 8.77, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 31.78, ["Neon|Fly|Ride"] = 96.47, ["Mega"] = 153.2, ["Mega|Ride"] = 192.44, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 226.38, ["Ride"] = 225.75, ["Fly|Ride"] = 884.69, ["Neon|Ride"] = 693, ["Neon|Fly|Ride"] = 979.08, ["Mega"] = 8847.8, ["Mega|Fly|Ride"] = 3419.29}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.89, ["Neon|Fly"] = 58.16, ["Neon|Ride"] = 64.32, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.69, ["Ride"] = 25.22, ["Fly|Ride"] = 65.63, ["Neon"] = 28.77, ["Neon|Ride"] = 135.18, ["Neon|Fly|Ride"] = 176.96, ["Mega"] = 391.13, ["Mega|Ride"] = 330.66, ["Mega|Fly|Ride"] = 350.7}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 19.66, ["Ride"] = 14.33, ["Fly|Ride"] = 36.75, ["Neon"] = 4.87, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 27, ["Neon|Fly|Ride"] = 58.03, ["Mega"] = 49.79, ["Mega|Ride"] = 103.97, ["Mega|Fly|Ride"] = 148.22}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 73.05, ["Ride"] = 19.69, ["Fly|Ride"] = 142.62, ["Neon"] = 10.5, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 118.36, ["Mega"] = 87.57, ["Mega|Ride"] = 221.19, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 16.96, ["Fly|Ride"] = 43.32, ["Neon"] = 32.82, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 983.22, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 35.4, ["Fly|Ride"] = 259.91, ["Neon"] = 58, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 259.87, ["Mega|Ride"] = 326.25, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 25.08, ["Ride"] = 16.45, ["Fly|Ride"] = 35.07, ["Neon"] = 35.06, ["Neon|Fly"] = 129.09, ["Neon|Ride"] = 26.3, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 262.5, ["Mega|Ride"] = 383.79, ["Mega|Fly|Ride"] = 284.71}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 75.5, ["Ride"] = 86.55, ["Fly|Ride"] = 157.49, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 450.19, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 240.19, ["Fly"] = 442.35, ["Ride"] = 234.94, ["Fly|Ride"] = 210, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 13271.69, ["Mega|Fly|Ride"] = 3834.43}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 57.75, ["Fly"] = 109.6, ["Ride"] = 67.96, ["Fly|Ride"] = 102.92, ["Neon"] = 502.86, ["Neon|Fly"] = 374.94, ["Neon|Ride"] = 311.07, ["Neon|Fly|Ride"] = 324.19, ["Mega|Fly|Ride"] = 1182.82}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.77, ["Fly"] = 288.42, ["Ride"] = 27.57, ["Fly|Ride"] = 123.19, ["Neon"] = 25.57, ["Neon|Ride"] = 98.42, ["Mega"] = 234.46, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.06, ["Fly"] = 52.5, ["Ride"] = 30.03, ["Fly|Ride"] = 65.63, ["Neon"] = 56.42, ["Neon|Ride"] = 101.98, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.9, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 39.18, ["Ride"] = 17.07, ["Fly|Ride"] = 51.99, ["Neon"] = 3.94, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 22.61, ["Neon|Fly|Ride"] = 74.1, ["Mega"] = 40.9, ["Mega|Fly"] = 153.41, ["Mega|Ride"] = 82.95, ["Mega|Fly|Ride"] = 572}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 8.92, ["Fly"] = 70.8, ["Ride"] = 34.11, ["Fly|Ride"] = 67.9, ["Neon"] = 109.5, ["Neon|Fly"] = 295.32, ["Neon|Ride"] = 118.34, ["Neon|Fly|Ride"] = 327.16, ["Mega"] = 530.82, ["Mega|Ride"] = 570.63, ["Mega|Fly|Ride"] = 547.4}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.68, ["Ride"] = 18.9, ["Fly|Ride"] = 45.94, ["Neon"] = 19.68, ["Neon|Fly"] = 53.09, ["Neon|Ride"] = 28.93, ["Neon|Fly|Ride"] = 93.05, ["Mega"] = 144.24, ["Mega|Ride"] = 270.31, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Fly"] = 39.82, ["Ride"] = 21.62, ["Fly|Ride"] = 328.13, ["Neon"] = 40.24, ["Neon|Ride"] = 74.1, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.49, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 14.43, ["Mega|Ride"] = 30.34, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 19.13, ["Fly|Ride"] = 44.63, ["Neon"] = 11.32, ["Neon|Fly"] = 110.61, ["Neon|Ride"] = 37.63, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly"] = 110.6, ["Mega|Ride"] = 132.71, ["Mega|Fly|Ride"] = 148.19}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 61.69, ["Ride"] = 22.28, ["Fly|Ride"] = 78.82, ["Neon"] = 22.13, ["Neon|Ride"] = 42, ["Mega"] = 144.37, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 107.61, ["Fly"] = 442.4, ["Ride"] = 162.04, ["Fly|Ride"] = 199.96, ["Neon"] = 420, ["Neon|Ride"] = 515.24, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 2514.72, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.27, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 43.32, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 24.04, ["Fly|Ride"] = 50.43, ["Neon"] = 15.65, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.04, ["Ride"] = 39.26, ["Fly|Ride"] = 170.63, ["Neon"] = 99.29, ["Neon|Ride"] = 168.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 554.28, ["Mega|Fly"] = 884.8, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 781.85}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.86}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 131.61, ["Neon"] = 59.07, ["Neon|Ride"] = 94.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 590.63, ["Mega|Ride"] = 648.11, ["Mega|Fly|Ride"] = 884.8}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.09, ["Fly"] = 28.34, ["Ride"] = 27.13, ["Fly|Ride"] = 49.38, ["Neon"] = 91.88, ["Neon|Fly"] = 132.71, ["Neon|Ride"] = 139.56, ["Neon|Fly|Ride"] = 150.91, ["Mega"] = 1427.66, ["Mega|Fly|Ride"] = 594.38}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 5.06, ["Neon|Ride"] = 44.61, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 28.82, ["Mega|Fly"] = 189, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 249.94}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 21.24, ["Fly|Ride"] = 65.63, ["Neon"] = 66.36, ["Mega"] = 288.62, ["Mega|Fly"] = 419.96, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 530.82}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 19.69, ["Fly|Ride"] = 40.6, ["Neon"] = 16.3, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.84, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 194.31, ["Mega|Ride"] = 158.51, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Fly"] = 280.9, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 59.73, ["Mega"] = 74.82, ["Mega|Ride"] = 118.34, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.15, ["Fly"] = 72.18, ["Ride"] = 64.52, ["Fly|Ride"] = 131.25, ["Neon"] = 185.05, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 884.69, ["Mega|Fly"] = 656.36, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 766.74}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 123.23, ["Neon"] = 100.65, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 331.8}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.94, ["Fly"] = 25.46, ["Ride"] = 21.7, ["Fly|Ride"] = 57.52, ["Neon"] = 12.41, ["Neon|Fly"] = 88.5, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 117.09, ["Mega"] = 120.1, ["Mega|Ride"] = 142.79, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.69, ["Fly"] = 145.01, ["Ride"] = 130.52, ["Neon"] = 442.35, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 540.28, ["Mega"] = 4695.32, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2513.66}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.8, ["Fly"] = 47.09, ["Ride"] = 22.37, ["Fly|Ride"] = 57.88, ["Neon"] = 35.48, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 145.99, ["Mega"] = 272.89, ["Mega|Ride"] = 239.7, ["Mega|Fly|Ride"] = 330.66}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 73.5, ["Fly"] = 186.38, ["Ride"] = 118.13, ["Fly|Ride"] = 221.19, ["Neon"] = 262.4, ["Neon|Ride"] = 264.42, ["Neon|Fly|Ride"] = 322.93, ["Mega"] = 1076.25, ["Mega|Ride"] = 1658.77, ["Mega|Fly|Ride"] = 1082.82}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.57, ["Ride"] = 55.13, ["Fly|Ride"] = 167.62, ["Neon"] = 76.13, ["Neon|Ride"] = 108.75, ["Neon|Fly|Ride"] = 216.98, ["Mega"] = 349.13, ["Mega|Ride"] = 386.84, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.45, ["Fly"] = 39.38, ["Ride"] = 26.55, ["Fly|Ride"] = 72.43, ["Neon"] = 148.19, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 671.18, ["Mega|Ride"] = 588.39, ["Mega|Fly|Ride"] = 649.15}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.15, ["Ride"] = 61.59, ["Fly|Ride"] = 202.16, ["Neon"] = 64.96, ["Neon|Ride"] = 149.3, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 468.84, ["Mega|Fly"] = 538.57, ["Mega|Ride"] = 387.85, ["Mega|Fly|Ride"] = 424.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.74, ["Ride"] = 33.77, ["Fly|Ride"] = 76.13, ["Neon"] = 39.47, ["Neon|Ride"] = 57.63, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 223.13, ["Mega|Ride"] = 291.93, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 103.97, ["Neon|Ride"] = 118.34, ["Mega"] = 19.49, ["Mega|Ride"] = 148.19}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.73, ["Ride"] = 70.8, ["Fly|Ride"] = 325.9, ["Neon"] = 45, ["Neon|Ride"] = 245.52, ["Mega"] = 239.55, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 851.61}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 131.61, ["Ride"] = 29.87, ["Neon"] = 26.22, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 252.67, ["Mega|Ride"] = 431.29, ["Mega|Fly|Ride"] = 335.6}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.93, ["Ride"] = 32.8, ["Neon"] = 17.07, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 532.71, ["Ride"] = 557.71, ["Fly|Ride"] = 603.65, ["Neon"] = 1769.37, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1664.25, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.06, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 64.32, ["Neon"] = 43.15, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.24, ["Mega"] = 206.83, ["Mega|Ride"] = 386.03, ["Mega|Fly|Ride"] = 369.41}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.2, ["Fly"] = 66.94, ["Ride"] = 26.25, ["Fly|Ride"] = 55.21, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 65.42, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 331.88, ["Mega|Ride"] = 404.75, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 25.46, ["Fly|Ride"] = 50.8, ["Neon|Ride"] = 32.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 265.41}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.35, ["Fly|Ride"] = 90.57, ["Neon"] = 8.85, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 100.43, ["Mega|Ride"] = 112.59, ["Mega|Fly|Ride"] = 214.02}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 24.12, ["Fly|Ride"] = 52.5, ["Neon"] = 2.62, ["Neon|Ride"] = 32.33, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 22.05, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.13}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.39, ["Ride"] = 59.73, ["Fly|Ride"] = 118.13, ["Neon"] = 46.75, ["Neon|Ride"] = 74.1, ["Neon|Fly|Ride"] = 370.86, ["Mega"] = 288.75, ["Mega|Ride"] = 370.77, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.55, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1032.99, ["Mega"] = 39.38, ["Mega|Ride"] = 88.5, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 10.47, ["Fly"] = 441.3, ["Ride"] = 131.25, ["Fly|Ride"] = 70.4, ["Neon"] = 46.31, ["Neon|Ride"] = 111.83, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 274.56, ["Mega|Ride"] = 383.74, ["Mega|Fly|Ride"] = 501.48}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 415.79, ["Ride"] = 452.82, ["Fly|Ride"] = 535.49, ["Neon"] = 1734.43, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1246.88, ["Mega"] = 8294.81, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.13, ["Fly"] = 196.88, ["Ride"] = 42, ["Neon"] = 29.54, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 201.2, ["Mega"] = 367.2, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 118.11, ["Neon"] = 2.27, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 105, ["Mega|Fly"] = 118.36, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Fly|Ride"] = 97.13, ["Neon"] = 3.14, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 294.59, ["Mega"] = 25.99, ["Mega|Ride"] = 105.08, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 30.85, ["Fly"] = 29.87, ["Ride"] = 108.99, ["Fly|Ride"] = 176.96, ["Neon"] = 131.25, ["Neon|Fly"] = 201.11, ["Neon|Ride"] = 441.25, ["Neon|Fly|Ride"] = 441.31, ["Mega"] = 696.29, ["Mega|Ride"] = 723.33, ["Mega|Fly|Ride"] = 778.54}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.76, ["Neon"] = 99.75, ["Neon|Ride"] = 144.89, ["Neon|Fly|Ride"] = 884.69, ["Mega"] = 586.95, ["Mega|Ride"] = 483, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.55, ["Ride"] = 76, ["Neon"] = 101.07, ["Neon|Ride"] = 176.96, ["Mega"] = 687.67, ["Mega|Ride"] = 654.76, ["Mega|Fly|Ride"] = 1327.18}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.37, ["Ride"] = 56.36, ["Fly|Ride"] = 236.25, ["Neon"] = 144.38, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 723.19, ["Mega|Ride"] = 1769.37, ["Mega|Fly|Ride"] = 653.62}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.75, ["Fly|Ride"] = 751.99, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1199.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 10.5, ["Ride"] = 60.38, ["Fly|Ride"] = 147.07, ["Neon"] = 148.19, ["Neon|Ride"] = 196.17, ["Neon|Fly|Ride"] = 287.55, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.86, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 31.5, ["Neon|Ride"] = 142.11, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 58.95, ["Ride"] = 426.55, ["Fly|Ride"] = 452.82, ["Neon"] = 150.94, ["Neon|Ride"] = 258.79, ["Neon|Fly|Ride"] = 543.8, ["Mega"] = 433.13, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 72.19, ["Fly|Ride"] = 221.19, ["Neon"] = 7.6, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 286.47, ["Mega"] = 55.31, ["Mega|Ride"] = 176.96, ["Mega|Fly|Ride"] = 288.48}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 46.34, ["Ride"] = 99.75, ["Fly|Ride"] = 218.75, ["Neon"] = 262.42, ["Neon|Ride"] = 353.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1603.68, ["Mega|Ride"] = 2928.63, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 109.5, ["Ride"] = 28.24, ["Neon"] = 10.29, ["Neon|Fly"] = 192.44, ["Neon|Ride"] = 44.25, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 70.72, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 215.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.49, ["Fly|Ride"] = 110.61, ["Neon"] = 5.25, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 42, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 295.28}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 26.18, ["Fly|Ride"] = 134.55, ["Neon"] = 12.89, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 90.57, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 65.43, ["Fly"] = 105, ["Ride"] = 73.5, ["Fly|Ride"] = 134.53, ["Neon"] = 367.5, ["Neon|Ride"] = 362.92, ["Neon|Fly|Ride"] = 502.86, ["Mega|Ride"] = 1157.97, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.71, ["Neon"] = 22.24, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 50.88, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 74.55, ["Mega|Fly"] = 295.28, ["Mega|Ride"] = 209.63, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 74.11, ["Ride"] = 22.13, ["Neon"] = 8.54, ["Neon|Ride"] = 78.75, ["Mega"] = 54.49, ["Mega|Fly"] = 210, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 110.61, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 168.51, ["Mega"] = 369.37, ["Mega|Ride"] = 355.11, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 4.97, ["Fly"] = 78.75, ["Ride"] = 59.18, ["Fly|Ride"] = 331.63, ["Neon"] = 36.33, ["Neon|Ride"] = 116.82, ["Mega"] = 190.97, ["Mega|Ride"] = 221.19, ["Mega|Fly|Ride"] = 473.32}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 5.97, ["Neon|Ride"] = 106.18, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 43.14, ["Mega|Ride"] = 140.47, ["Mega|Fly|Ride"] = 295.28}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 19.34, ["Fly|Ride"] = 62.86, ["Neon"] = 4.38, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.51, ["Neon|Fly|Ride"] = 103.49, ["Mega"] = 39.37, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 23.56, ["Fly|Ride"] = 57.74, ["Neon"] = 18.1, ["Neon|Fly"] = 105.08, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 118.34, ["Mega"] = 168.44, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 293.35}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.23, ["Fly"] = 74.11, ["Ride"] = 29.08, ["Fly|Ride"] = 91.81, ["Neon"] = 144.38, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 287.57, ["Mega"] = 485.63, ["Mega|Fly"] = 442.4, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 630.05}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.31, ["Ride"] = 90.56, ["Fly|Ride"] = 146.61, ["Neon"] = 370.21, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2211.7, ["Mega|Ride"] = 2008.22, ["Mega|Fly|Ride"] = 1517.83}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Neon"] = 4.77, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 35.84, ["Mega|Fly"] = 672, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 259.34}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.63, ["Ride"] = 15.43, ["Fly|Ride"] = 44.25, ["Neon"] = 2.63, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 51.87, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 44.25, ["Ride"] = 38.03, ["Fly|Ride"] = 110.6, ["Neon"] = 40.69, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 560.75, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 472.5, ["Ride"] = 618.93, ["Fly|Ride"] = 584.07, ["Neon"] = 4423.39, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.25, ["Fly"] = 113.74, ["Ride"] = 47.24, ["Fly|Ride"] = 144.37, ["Neon"] = 150.47, ["Neon|Ride"] = 245.18, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 720.57, ["Mega|Ride"] = 860.36, ["Mega|Fly|Ride"] = 924.5}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.88, ["Fly|Ride"] = 91.87, ["Neon"] = 10.28, ["Neon|Ride"] = 57.39, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 59.73, ["Mega|Ride"] = 128.54, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 64.96, ["Fly|Ride"] = 262.03, ["Neon"] = 73.46, ["Mega"] = 166.69}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 22.3, ["Fly"] = 169.32, ["Ride"] = 47.38, ["Fly|Ride"] = 83.81, ["Neon"] = 194.25, ["Neon|Ride"] = 260.54, ["Neon|Fly|Ride"] = 294.2, ["Mega"] = 2654.35, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 103.98, ["Ride"] = 131.25, ["Fly|Ride"] = 190.32, ["Neon"] = 433.98, ["Neon|Fly"] = 840.46, ["Neon|Ride"] = 547.4, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3244.56, ["Mega|Fly|Ride"] = 2578.85}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 253.74, ["Ride"] = 304.5, ["Fly|Ride"] = 339.52, ["Neon"] = 922.52, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 8.99, ["Ride"] = 67.9, ["Fly|Ride"] = 246.91, ["Neon"] = 81.38, ["Neon|Ride"] = 88.49, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 498.75, ["Mega|Ride"] = 404.38, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 17.56, ["Fly|Ride"] = 39.06, ["Neon"] = 7.08, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 66.36, ["Mega"] = 78.65, ["Mega|Ride"] = 118.36, ["Mega|Fly|Ride"] = 163.7}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 50.42, ["Ride"] = 23.39, ["Fly|Ride"] = 52.5, ["Neon"] = 26.24, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 293.08, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 353.9}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 262.5, ["Ride"] = 370.58, ["Fly|Ride"] = 576.03, ["Neon"] = 1401.29, ["Mega"] = 11058.45, ["Mega|Fly|Ride"] = 6269.82}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 34.3, ["Neon"] = 10.4, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 36.49, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 453.42}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Fly"] = 25.15, ["Ride"] = 17.06, ["Fly|Ride"] = 43.14, ["Neon"] = 24.44, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 118.13, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 16.2, ["Fly"] = 6562.5, ["Ride"] = 57.29, ["Neon"] = 103.01, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 557.82, ["Mega|Ride"] = 716.6, ["Mega|Fly|Ride"] = 614.92}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 120.64, ["Fly"] = 78.75, ["Ride"] = 168.12, ["Fly|Ride"] = 184.7, ["Neon|Ride"] = 838.31, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2184.07}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.42, ["Fly"] = 39.29, ["Ride"] = 27.98, ["Fly|Ride"] = 56.44, ["Neon"] = 103.95, ["Neon|Ride"] = 103.98, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 487.75, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 485.31}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.51, ["Neon|Ride"] = 65.63, ["Mega"] = 27.23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 18.25, ["Fly|Ride"] = 86.16, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 23.63, ["Mega|Fly"] = 103.98, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 234.48}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.47, ["Fly"] = 103.28, ["Ride"] = 103.07, ["Fly|Ride"] = 271.81, ["Neon"] = 38.98, ["Neon|Ride"] = 100.69, ["Neon|Fly|Ride"] = 227.56, ["Mega"] = 228.38, ["Mega|Ride"] = 246.71, ["Mega|Fly|Ride"] = 359.63}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Ride"] = 1312.49, ["Fly|Ride"] = 1378.13, ["Neon"] = 3543.75, ["Neon|Ride"] = 4090.53, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 393.75, ["Ride"] = 531.57, ["Fly|Ride"] = 540.53, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1573.68, ["Mega"] = 15483.64, ["Mega|Fly|Ride"] = 6784.05}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 308.44, ["Fly"] = 424.71, ["Ride"] = 367.5, ["Fly|Ride"] = 437.17, ["Neon"] = 759.94, ["Neon|Fly"] = 884.69, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 724.5, ["Mega|Ride"] = 3688.43, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 246.75, ["Fly"] = 288.75, ["Ride"] = 291.36, ["Fly|Ride"] = 380.63, ["Neon"] = 662.68, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 677.15, ["Mega|Fly|Ride"] = 3616.51}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 43.85, ["Ride"] = 20.81, ["Fly|Ride"] = 49.87, ["Neon"] = 5.24, ["Neon|Ride"] = 34.97, ["Neon|Fly|Ride"] = 110.61, ["Mega"] = 57.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 291.36, ["Fly"] = 1475.38, ["Ride"] = 374.07, ["Fly|Ride"] = 375.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1076.25, ["Neon|Fly|Ride"] = 1087.46, ["Mega"] = 22412.16, ["Mega|Ride"] = 6341.67, ["Mega|Fly|Ride"] = 4160.07}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 7.88, ["Fly"] = 183.74, ["Ride"] = 31.5, ["Neon"] = 38.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 294.18, ["Mega"] = 230.24, ["Mega|Ride"] = 335.6, ["Mega|Fly|Ride"] = 838.24}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.56, ["Ride"] = 16.48, ["Fly|Ride"] = 35.94, ["Neon"] = 6.63, ["Neon|Ride"] = 55.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 168.08}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 22.32, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 43.32, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.09}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8381.19, ["Ride"] = 22.32, ["Fly|Ride"] = 68.25, ["Neon"] = 18.57, ["Mega"] = 367.15, ["Mega|Ride"] = 303.57, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 44.25, ["Neon"] = 2.57, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 23.13, ["Mega|Ride"] = 67.9, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.43, ["Fly"] = 88.49, ["Ride"] = 66.36, ["Fly|Ride"] = 91.88, ["Neon"] = 26.25, ["Neon|Fly"] = 110.6, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 213.05, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 335.12}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.08, ["Fly"] = 32.43, ["Ride"] = 18.37, ["Fly|Ride"] = 56.7, ["Neon"] = 163.7, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.86, ["Mega|Ride"] = 244.18, ["Mega|Fly|Ride"] = 1321.95}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.97, ["Ride"] = 39.37, ["Fly|Ride"] = 168.47, ["Neon"] = 68.25, ["Neon|Ride"] = 176.96, ["Neon|Fly|Ride"] = 335.6, ["Mega"] = 524.99, ["Mega|Ride"] = 570.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6706.73, ["Ride"] = 24.7, ["Fly|Ride"] = 190.32, ["Neon"] = 69.57, ["Neon|Ride"] = 215.41, ["Neon|Fly|Ride"] = 754.28, ["Mega"] = 420, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 71.4, ["Ride"] = 16.36, ["Fly|Ride"] = 42.94, ["Neon"] = 3.94, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 132.74, ["Mega"] = 49.88, ["Mega|Fly|Ride"] = 251.44}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 203.74, ["Fly"] = 244.4, ["Ride"] = 190.31, ["Fly|Ride"] = 196.88, ["Neon"] = 1003.13, ["Neon|Ride"] = 1057.2, ["Neon|Fly|Ride"] = 1473.01, ["Mega"] = 8847.8, ["Mega|Fly|Ride"] = 4523.32}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 25.75, ["Ride"] = 16.19, ["Fly|Ride"] = 36.89, ["Neon"] = 3.57, ["Neon|Fly"] = 37.73, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 55.31, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 148.19}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.21, ["Ride"] = 44.31, ["Fly|Ride"] = 235.1, ["Neon"] = 64.97, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 804.57, ["Mega"] = 427.33, ["Mega|Ride"] = 309.37, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 30.18, ["Ride"] = 88.49, ["Fly|Ride"] = 183.75, ["Neon"] = 216.55, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 780.13, ["Mega|Ride"] = 1029.06, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 217.88, ["Fly"] = 274.36, ["Ride"] = 240.45, ["Fly|Ride"] = 316.33, ["Neon"] = 838.31, ["Neon|Fly"] = 1677.01, ["Neon|Ride"] = 801.94, ["Neon|Fly|Ride"] = 732.12, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 18.83, ["Fly"] = 134.55, ["Ride"] = 168.51, ["Neon"] = 141.38, ["Neon|Ride"] = 192.44, ["Mega"] = 281.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 437.98}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 4.54, ["Ride"] = 58.45, ["Fly|Ride"] = 147.9, ["Neon"] = 168, ["Neon|Fly"] = 168.47, ["Neon|Ride"] = 330.66, ["Neon|Fly|Ride"] = 221.19, ["Mega"] = 1769.37, ["Mega|Ride"] = 1475.38, ["Mega|Fly|Ride"] = 815.85}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.02, ["Fly"] = 1807.33, ["Ride"] = 945, ["Fly|Ride"] = 1028.99, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 18091.63}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.45, ["Fly"] = 28.29, ["Ride"] = 19.67, ["Fly|Ride"] = 45.93, ["Neon"] = 49.63, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 84.23, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 251.44, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.73, ["Fly"] = 262.5, ["Ride"] = 41.14, ["Fly|Ride"] = 135.19, ["Neon"] = 36.1, ["Neon|Ride"] = 125.7, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 335.67, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 87.68, ["Ride"] = 29.3, ["Fly|Ride"] = 81.85, ["Neon"] = 11.7, ["Neon|Ride"] = 50.88, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 83.21, ["Mega|Ride"] = 369.41, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.87, ["Ride"] = 35.44, ["Fly|Ride"] = 124.83, ["Neon"] = 65.62, ["Neon|Ride"] = 126.1, ["Neon|Fly|Ride"] = 179.34, ["Mega"] = 446.25, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 461.76}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 19.87, ["Fly|Ride"] = 42.78, ["Neon"] = 15.74, ["Neon|Fly"] = 58.65, ["Neon|Ride"] = 31.76, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.31, ["Mega|Fly|Ride"] = 194.24}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.65, ["Ride"] = 32.12, ["Fly|Ride"] = 131.25, ["Neon"] = 16.61, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 51.32, ["Neon|Fly|Ride"] = 107.57, ["Mega"] = 152.15, ["Mega|Ride"] = 221.19, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 248.75, ["Ride"] = 339.52, ["Fly|Ride"] = 442.35, ["Neon"] = 1215.34, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3520.61}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 27.57, ["Fly|Ride"] = 105.59, ["Neon"] = 8.68, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 79.63, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 353.94}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 88.86, ["Neon"] = 18.23, ["Neon|Fly"] = 196.88, ["Mega"] = 195.57, ["Mega|Ride"] = 353.9}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 21, ["Neon"] = 10.39, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 74.1, ["Mega"] = 101.61, ["Mega|Ride"] = 140.2, ["Mega|Fly|Ride"] = 585.21}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 84, ["Ride"] = 131.25, ["Fly|Ride"] = 260.4, ["Neon"] = 442.35, ["Neon|Ride"] = 516.45, ["Neon|Fly|Ride"] = 488.31, ["Mega"] = 2654.35, ["Mega|Ride"] = 1547.27, ["Mega|Fly|Ride"] = 1591.32}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.3, ["Fly"] = 89.87, ["Ride"] = 52.5, ["Fly|Ride"] = 287.57, ["Neon"] = 103.93, ["Neon|Ride"] = 442.4, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.44, ["Fly"] = 263.44, ["Ride"] = 46.76, ["Fly|Ride"] = 118.13, ["Neon"] = 98.04, ["Neon|Fly"] = 151.01, ["Neon|Ride"] = 114.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 433.13, ["Mega|Ride"] = 452.42, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 6.55, ["Neon"] = 43.32, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 199.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 36.74, ["Fly"] = 97.12, ["Ride"] = 78.74, ["Fly|Ride"] = 157.5, ["Neon"] = 183.75, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 290.07, ["Mega|Fly|Ride"] = 957.89}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 22.13, ["Fly|Ride"] = 105, ["Neon"] = 6.33, ["Neon|Fly|Ride"] = 131.62, ["Mega"] = 91.88, ["Mega|Ride"] = 295.28, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.84, ["Fly"] = 39.38, ["Ride"] = 25.96, ["Fly|Ride"] = 72.33, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 67.9, ["Neon|Fly|Ride"] = 168.47, ["Mega"] = 364.34, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 397.06, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.93, ["Fly"] = 203.42, ["Ride"] = 77.44, ["Fly|Ride"] = 137.82, ["Neon"] = 282.19, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 358.32, ["Mega|Ride"] = 1512.98, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.74, ["Ride"] = 16.11, ["Fly|Ride"] = 43.85, ["Neon"] = 2.62, ["Neon|Fly"] = 25.46, ["Neon|Ride"] = 16.57, ["Neon|Fly|Ride"] = 50.16, ["Mega"] = 19.67, ["Mega|Ride"] = 41.36, ["Mega|Fly|Ride"] = 90.33}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 6.57, ["Fly"] = 105, ["Ride"] = 50.76, ["Fly|Ride"] = 64.97, ["Neon"] = 16.61, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 168, ["Mega"] = 176.96, ["Mega|Fly"] = 236.25, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.44, ["Ride"] = 42, ["Fly|Ride"] = 117.25, ["Neon"] = 118.25, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 272.87, ["Mega"] = 536.82, ["Mega|Ride"] = 432.04, ["Mega|Fly|Ride"] = 570.64}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 2.1, ["Neon|Ride"] = 19.56, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.31, ["Mega|Ride"] = 50.18, ["Mega|Fly|Ride"] = 442.94}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 34.11, ["Fly"] = 210, ["Ride"] = 72.17, ["Fly|Ride"] = 288.75, ["Neon"] = 165.94, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 754.1, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 698.65, ["Mega|Fly|Ride"] = 933.02}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.37, ["Fly"] = 44.25, ["Ride"] = 26.48, ["Fly|Ride"] = 101.07, ["Neon"] = 241.08, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 170.31, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.63, ["Ride"] = 62.35, ["Neon"] = 59.03, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 89.94, ["Neon|Fly|Ride"] = 218.98, ["Mega"] = 248.73, ["Mega|Ride"] = 377.5, ["Mega|Fly|Ride"] = 502.74}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.45, ["Fly"] = 74.1, ["Ride"] = 84.19, ["Fly|Ride"] = 247.11, ["Neon"] = 43.25, ["Neon|Ride"] = 103.48, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 287.44, ["Mega|Fly"] = 295.32, ["Mega|Ride"] = 442.4, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 37.62, ["Fly|Ride"] = 196.88, ["Neon"] = 6.41, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.38, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 91.82, ["Mega|Fly|Ride"] = 295.28}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 87.94, ["Neon"] = 3.5, ["Neon|Ride"] = 37.62, ["Neon|Fly|Ride"] = 168.47, ["Mega"] = 39.37, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 18.5}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 44.31, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 96.45, ["Neon"] = 196.88, ["Neon|Ride"] = 221.19, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.56}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 65.63, ["Fly|Ride"] = 110.6, ["Neon"] = 2.51, ["Neon|Ride"] = 27.19, ["Mega"] = 32.01, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 331.8}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 524.19, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 3981.52, ["Neon|Ride"] = 2359.89, ["Mega"] = 13271.69, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 49.38, ["Ride"] = 34.13, ["Fly|Ride"] = 58.27, ["Neon"] = 72.97, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 118.19, ["Mega"] = 335.6, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 649.15}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.1, ["Ride"] = 18.36, ["Fly|Ride"] = 46.73, ["Neon"] = 14.43, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 164.07, ["Mega|Fly"] = 221.19, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.86, ["Fly"] = 56.41, ["Ride"] = 52.49, ["Fly|Ride"] = 590.61, ["Neon"] = 114.19, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 537.95, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 44.25, ["Ride"] = 38.57, ["Fly|Ride"] = 74.11, ["Neon"] = 47.45, ["Neon|Fly"] = 74.1, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 294.2, ["Mega|Fly|Ride"] = 516.45}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.49, ["Ride"] = 32.7, ["Fly|Ride"] = 196.88, ["Neon"] = 85.31, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 118.34, ["Mega"] = 551.83, ["Mega|Ride"] = 419.9, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.35, ["Ride"] = 55.31, ["Fly|Ride"] = 129.94, ["Neon"] = 34.12, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 99.38, ["Neon|Fly|Ride"] = 284.64, ["Mega"] = 207.93, ["Mega|Ride"] = 370.86, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 50.3, ["Ride"] = 16.61, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 14.44, ["Mega|Fly"] = 84.25, ["Mega|Ride"] = 31.47, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 56.44, ["Fly|Ride"] = 110.6, ["Neon"] = 95.6, ["Neon|Fly"] = 125.7, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.19, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 424.6}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 249.38, ["Ride"] = 304.5, ["Fly|Ride"] = 420, ["Neon"] = 1307.12, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 5024.52, ["Mega|Ride"] = 9757.07, ["Mega|Fly|Ride"] = 4558.31}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.73, ["Ride"] = 104.97, ["Fly|Ride"] = 262.5, ["Neon"] = 458.07, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 1622.48, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 18.87, ["Fly|Ride"] = 57.52, ["Neon"] = 7.66, ["Neon|Fly"] = 103.98, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 59.73, ["Mega|Fly"] = 220.11, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 248.73}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.86, ["Fly|Ride"] = 37.29, ["Neon"] = 7.77, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 59.71, ["Mega"] = 69.36, ["Mega|Fly"] = 295.32, ["Mega|Ride"] = 109.5, ["Mega|Fly|Ride"] = 152.04}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 103.97, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 448.25, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 210, ["Ride"] = 236.25, ["Fly|Ride"] = 328.33, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8846.77, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.61, ["Fly|Ride"] = 50.09, ["Neon"] = 20.35, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.62, ["Ride"] = 78.75, ["Fly|Ride"] = 118.36, ["Neon"] = 31.26, ["Neon|Ride"] = 112.82, ["Mega"] = 299.25, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 442.35}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 9.78, ["Neon|Ride"] = 137.82, ["Mega"] = 120.75, ["Mega|Ride"] = 339.54}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 58.12, ["Ride"] = 25.7, ["Fly|Ride"] = 69.54, ["Neon"] = 95.85, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 205.71, ["Mega"] = 393.75, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.26, ["Ride"] = 86.17, ["Fly|Ride"] = 583.75, ["Neon"] = 114.47, ["Neon|Fly"] = 656.04, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 459.37, ["Mega|Fly"] = 2322.56, ["Mega|Ride"] = 528.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.57, ["Fly"] = 103.97, ["Ride"] = 44.25, ["Fly|Ride"] = 118.13, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 245.43, ["Mega"] = 884.69, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 16.41, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 32.65, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 17.73, ["Mega|Fly"] = 40.99, ["Mega|Ride"] = 39.71, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 216.44, ["Ride"] = 262.24, ["Fly|Ride"] = 288.75, ["Neon"] = 3488.84, ["Neon|Ride"] = 1282.8, ["Neon|Fly|Ride"] = 1401.12, ["Mega|Fly|Ride"] = 5407.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.53, ["Fly"] = 101.19, ["Ride"] = 27.58, ["Fly|Ride"] = 111.57, ["Neon"] = 78.74, ["Neon|Ride"] = 145.99, ["Neon|Fly|Ride"] = 458.95, ["Mega"] = 385.88, ["Mega|Ride"] = 502.13, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 37.63, ["Ride"] = 19.03, ["Fly|Ride"] = 59.07, ["Neon"] = 6.27, ["Neon|Fly"] = 38.98, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 45.94, ["Mega|Fly"] = 236.7, ["Mega|Ride"] = 88.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 24.11, ["Fly|Ride"] = 87.66, ["Neon"] = 2.26, ["Neon|Fly"] = 81.99, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 113.17, ["Mega"] = 26.97, ["Mega|Fly"] = 144.21, ["Mega|Ride"] = 43.1, ["Mega|Fly|Ride"] = 186.11}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 37.59, ["Fly|Ride"] = 98.44, ["Neon"] = 16.41, ["Neon|Fly"] = 754.43, ["Neon|Ride"] = 63.12, ["Mega"] = 125.7, ["Mega|Ride"] = 163.12, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.97, ["Fly"] = 38.75, ["Ride"] = 19.69, ["Fly|Ride"] = 69.56, ["Neon"] = 46.1, ["Neon|Fly"] = 317.43, ["Neon|Ride"] = 48.12, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 288.15, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.16, ["Ride"] = 32.82, ["Neon"] = 43.09, ["Neon|Ride"] = 152.62, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 59.59, ["Neon"] = 2.56, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 118.34, ["Mega"] = 20.74, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 192.44}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.35, ["Fly"] = 83.99, ["Ride"] = 33.87, ["Fly|Ride"] = 176.96, ["Neon"] = 41.77, ["Neon|Fly"] = 148.19, ["Neon|Ride"] = 96.87, ["Neon|Fly|Ride"] = 144.41, ["Mega"] = 181.37, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 369.37}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 4.67, ["Neon|Fly"] = 118.36, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 30.16, ["Mega|Ride"] = 144.36, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 57.83, ["Ride"] = 19.2, ["Fly|Ride"] = 45.94, ["Neon"] = 3.85, ["Neon|Ride"] = 26.21, ["Neon|Fly|Ride"] = 120.18, ["Mega"] = 45.94, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 284.53}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Fly"] = 862.58, ["Ride"] = 682.17, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3519.94, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 15.1, ["Neon|Fly"] = 44.25, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly"] = 65.63, ["Mega|Fly|Ride"] = 335.6}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 46.82, ["Neon"] = 8.81, ["Neon|Fly"] = 774.2, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 88.27, ["Mega|Fly"] = 182.84, ["Mega|Ride"] = 294.66, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.79, ["Fly"] = 26.25, ["Ride"] = 20.77, ["Fly|Ride"] = 51.19, ["Neon"] = 38.97, ["Neon|Fly"] = 198.41, ["Neon|Ride"] = 56.27, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 44.25, ["Ride"] = 16.4, ["Fly|Ride"] = 34.23, ["Neon"] = 8.39, ["Neon|Fly"] = 154.85, ["Neon|Ride"] = 27.22, ["Neon|Fly|Ride"] = 72.71, ["Mega"] = 71.13, ["Mega|Ride"] = 95.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 40.69, ["Ride"] = 59.18, ["Neon"] = 236.25, ["Neon|Ride"] = 336.45, ["Mega"] = 1006.45, ["Mega|Ride"] = 795.21, ["Mega|Fly|Ride"] = 825.48}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 73.23, ["Neon"] = 7.54, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 118.36, ["Mega"] = 46.75, ["Mega|Fly"] = 148.19, ["Mega|Ride"] = 109.28, ["Mega|Fly|Ride"] = 279.09}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 21.83, ["Fly|Ride"] = 90.04, ["Neon"] = 10.91, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 114.19, ["Mega|Ride"] = 199.06, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 44.25, ["Fly|Ride"] = 65.84, ["Neon"] = 12.28, ["Neon|Fly|Ride"] = 110.6, ["Mega"] = 103.69, ["Mega|Ride"] = 165.89, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.5, ["Ride"] = 19.65, ["Fly|Ride"] = 59.73, ["Neon"] = 4.35, ["Neon|Fly"] = 72.39, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 107.73, ["Mega"] = 40.61, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 77.44}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.49, ["Fly"] = 21.4, ["Ride"] = 18.26, ["Fly|Ride"] = 38.06, ["Neon"] = 124.69, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 73.96, ["Neon|Fly|Ride"] = 144.89, ["Mega|Ride"] = 554.28, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 725.79, ["Ride"] = 792.83, ["Fly|Ride"] = 984.38, ["Neon"] = 1584.19, ["Neon|Ride"] = 1569.65, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 8633.84, ["Mega|Ride"] = 4656.75, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 23.38, ["Ride"] = 17.69, ["Fly|Ride"] = 47.53, ["Neon"] = 2.52, ["Neon|Fly"] = 37.63, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 37.8, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 210.13}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.25, ["Ride"] = 36.74, ["Fly|Ride"] = 46.13, ["Neon"] = 41.79, ["Neon|Ride"] = 205.11, ["Neon|Fly|Ride"] = 250.69, ["Mega"] = 442.35, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.94, ["Fly"] = 156.19, ["Ride"] = 73.1, ["Fly|Ride"] = 110.83, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 2475.65, ["Mega|Fly|Ride"] = 1919.98}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 24.94, ["Fly"] = 146.85, ["Ride"] = 52.5, ["Fly|Ride"] = 103.97, ["Neon"] = 214.57, ["Neon|Ride"] = 175.85, ["Mega"] = 1508.2, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 775.27}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 12.21, ["Ride"] = 22.13, ["Fly|Ride"] = 65.63, ["Neon"] = 64.2, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 308.44, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 467.78}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.37, ["Ride"] = 72.94, ["Fly|Ride"] = 148.19, ["Neon"] = 113.13, ["Neon|Ride"] = 201.28, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 390.48, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.62, ["Ride"] = 163.36, ["Neon"] = 148.19, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 383.79, ["Mega"] = 547.4, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 634.85}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 8.99}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.24, ["Ride"] = 28.87, ["Fly|Ride"] = 101.14, ["Neon"] = 26.13, ["Neon|Ride"] = 100.58, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 178.5, ["Mega|Fly"] = 462.9, ["Mega|Ride"] = 183.25, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 20.99, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 28.88, ["Fly"] = 63, ["Ride"] = 33.53, ["Fly|Ride"] = 86.63, ["Neon"] = 192.44, ["Neon|Fly"] = 295.28, ["Neon|Ride"] = 211.23, ["Neon|Fly|Ride"] = 251.04, ["Mega"] = 1296.04, ["Mega|Ride"] = 783.53, ["Mega|Fly|Ride"] = 713.74}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.41, ["Fly|Ride"] = 34.13, ["Neon"] = 21.97, ["Neon|Fly"] = 42.94, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.33, ["Mega"] = 223.74, ["Mega|Fly"] = 442.4, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 107.29, ["Ride"] = 26.25, ["Fly|Ride"] = 43.22, ["Neon"] = 26.21, ["Neon|Ride"] = 63.29, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 157.49, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 255.96}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 52.81, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 27.57, ["Ride"] = 44.42, ["Fly|Ride"] = 385.86, ["Neon"] = 945, ["Neon|Ride"] = 306.81, ["Neon|Fly|Ride"] = 369.41, ["Mega"] = 682.5, ["Mega|Ride"] = 1769.58, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 35.09, ["Fly|Ride"] = 58.15, ["Neon"] = 7.86, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 141.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.35, ["Ride"] = 45.94, ["Fly|Ride"] = 294.2, ["Neon"] = 57.75, ["Neon|Ride"] = 118.34, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 397.69, ["Mega|Fly"] = 590.54, ["Mega|Ride"] = 419.89, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.93, ["Ride"] = 15.8, ["Neon"] = 10.5, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 194.25, ["Mega|Ride"] = 155.28, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.62, ["Fly"] = 52.49, ["Ride"] = 19.73, ["Fly|Ride"] = 52.97, ["Neon"] = 51.19, ["Neon|Fly"] = 73.01, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 280.93, ["Mega|Ride"] = 398.12, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 72.19, ["Neon"] = 78.14, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 59.07, ["Ride"] = 118.16, ["Neon"] = 294.61, ["Neon|Ride"] = 406.59, ["Neon|Fly|Ride"] = 884.69, ["Mega"] = 1448.84, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.37, ["Ride"] = 59.78, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Neon|Ride"] = 149.3, ["Mega"] = 422.63, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 689.73}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 3.5, ["Ride"] = 116.43, ["Neon"] = 149.63, ["Neon|Fly"] = 221.21, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 25.9, ["Ride"] = 131.62, ["Fly|Ride"] = 367.49, ["Neon"] = 161.01, ["Neon|Fly"] = 269.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 736.52, ["Mega|Fly"] = 2211.96, ["Mega|Ride"] = 661.31, ["Mega|Fly|Ride"] = 851.44}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 24.74, ["Mega"] = 196.88, ["Mega|Ride"] = 261.54, ["Mega|Fly|Ride"] = 334.55}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 16.77, ["Fly|Ride"] = 55.31, ["Neon"] = 3.8, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 65.1, ["Mega"] = 62.86, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 26.25, ["Fly|Ride"] = 85.5, ["Neon"] = 14.34, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 91.62, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 148.19, ["Ride"] = 19.69, ["Fly|Ride"] = 72.01, ["Neon"] = 6.45, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 55.12, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 21.05, ["Fly|Ride"] = 82.95, ["Neon"] = 23.23, ["Neon|Ride"] = 148.19, ["Neon|Fly|Ride"] = 221.67, ["Mega"] = 328.02, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.25, ["Fly"] = 65.33, ["Ride"] = 26.17, ["Fly|Ride"] = 442.35, ["Neon"] = 29.85, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 314.08, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1105.98}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.04, ["Fly"] = 131.24, ["Ride"] = 24.55, ["Fly|Ride"] = 60.32, ["Neon"] = 35.82, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 114.84, ["Mega"] = 216.57, ["Mega|Ride"] = 360.52, ["Mega|Fly|Ride"] = 496.55}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 18.9, ["Fly|Ride"] = 52.41, ["Neon"] = 29.37, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 154.85, ["Mega"] = 280.93, ["Mega|Ride"] = 167, ["Mega|Fly|Ride"] = 189.97}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 288.74, ["Ride"] = 47.21, ["Neon"] = 15.65, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 89.25, ["Mega"] = 106.17, ["Mega|Fly"] = 216.8, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 275.47}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.74, ["Ride"] = 95.53, ["Fly|Ride"] = 258.57, ["Neon"] = 63, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 367.5, ["Mega|Ride"] = 791.2, ["Mega|Fly|Ride"] = 618.19}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.2, ["Fly"] = 164.07, ["Ride"] = 82.2, ["Fly|Ride"] = 187.69, ["Neon"] = 240.8, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1621.18, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 53.1, ["Neon"] = 2.1, ["Neon|Ride"] = 21.72, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 33.97, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.28, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 723.33, ["Mega|Fly|Ride"] = 1165.7}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.46, ["Ride"] = 68.25, ["Neon"] = 249.37, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 884.8, ["Mega"] = 1822.66, ["Mega|Ride"] = 1005.47, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 7.17, ["Fly"] = 190.32, ["Ride"] = 30.19, ["Fly|Ride"] = 133.88, ["Neon"] = 38.93, ["Neon|Fly"] = 134.65, ["Neon|Ride"] = 88.5, ["Neon|Fly|Ride"] = 163.7, ["Mega"] = 270.17, ["Mega|Fly"] = 760.01, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 285.86}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.8, ["Ride"] = 59.73, ["Neon"] = 12.78, ["Neon|Ride"] = 71.37, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 84.9, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 270.57}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 29.81, ["Ride"] = 24.22, ["Fly|Ride"] = 45.94, ["Neon"] = 10.5, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 37.61, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 115.5, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 105}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 21.45, ["Ride"] = 15.18, ["Fly|Ride"] = 52.4, ["Neon"] = 2.1, ["Neon|Fly"] = 130.08, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 24.82, ["Mega|Ride"] = 75.45, ["Mega|Fly|Ride"] = 164.81}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Fly|Ride"] = 93.08, ["Neon"] = 4.19, ["Neon|Ride"] = 24.24, ["Neon|Fly|Ride"] = 97.44, ["Mega"] = 39.38, ["Mega|Fly"] = 168, ["Mega|Ride"] = 51.89, ["Mega|Fly|Ride"] = 163.96}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.3, ["Neon|Ride"] = 29.87, ["Mega"] = 24.94, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.81, ["Ride"] = 40.94, ["Neon"] = 50.19, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 419.96, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.23, ["Ride"] = 42.06, ["Fly|Ride"] = 221.21, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 286.79, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 17.06, ["Fly|Ride"] = 42, ["Neon"] = 52.77, ["Neon|Ride"] = 41.57, ["Neon|Fly|Ride"] = 101.05, ["Mega"] = 369.37, ["Mega|Ride"] = 296.93, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 66.94, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 487.7, ["Neon|Fly|Ride"] = 737.61, ["Mega"] = 2514.24, ["Mega|Ride"] = 1670.03, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.68, ["Fly"] = 57.75, ["Ride"] = 59.07, ["Neon"] = 1034.15, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1090.05}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.69, ["Fly|Ride"] = 41.57, ["Neon"] = 2.63, ["Neon|Fly"] = 43.86, ["Neon|Ride"] = 23.27, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 36.75, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 15.39, ["Fly|Ride"] = 36.71, ["Neon"] = 4.13, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 43.04, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 114.34}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 446.25, ["Fly"] = 590.71, ["Ride"] = 479.05, ["Fly|Ride"] = 524.97, ["Neon"] = 2507.26, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 8212.1}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.71, ["Ride"] = 64.1, ["Neon"] = 48.56, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 427.97, ["Mega|Ride"] = 737.61, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 17.07, ["Fly|Ride"] = 38.99, ["Neon"] = 7.43, ["Neon|Fly"] = 25.46, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.79, ["Mega|Ride"] = 70.8, ["Mega|Fly|Ride"] = 117.24}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 45.94, ["Ride"] = 109.5, ["Fly|Ride"] = 212.63, ["Neon"] = 157.5, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 737.63, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 817.56}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 44.62, ["Ride"] = 18.83, ["Fly|Ride"] = 54.44, ["Neon"] = 9.77, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 32.09, ["Neon|Fly|Ride"] = 77.84, ["Mega"] = 131.25, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 249.94}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 21.91, ["Neon"] = 2.1, ["Neon|Fly"] = 103.98, ["Neon|Ride"] = 74.1, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 19.85, ["Mega|Ride"] = 52.9, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 32.82, ["Fly"] = 129.94, ["Ride"] = 78.66, ["Fly|Ride"] = 215.25, ["Neon"] = 148.19, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 441.25, ["Mega"] = 734.39, ["Mega|Ride"] = 653.59, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.54, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 88.49, ["Mega"] = 64.15, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 72.4, ["Fly|Ride"] = 124.69, ["Neon"] = 283.23, ["Neon|Fly"] = 295.28, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 330.66, ["Mega"] = 1181.25, ["Mega|Ride"] = 1327.18, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 442.4, ["Neon"] = 32.44, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 515.24, ["Mega"] = 148.32, ["Mega|Ride"] = 427.97, ["Mega|Fly|Ride"] = 427.58}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 33.95, ["Ride"] = 81.35, ["Fly|Ride"] = 59.73, ["Neon"] = 10.06, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 117.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 52.5, ["Fly"] = 192.46, ["Ride"] = 183.61, ["Fly|Ride"] = 196.88, ["Neon"] = 359.63, ["Mega|Ride"] = 1289.43, ["Mega|Fly|Ride"] = 2065.73}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 35.4, ["Neon"] = 4.66, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 118.34, ["Mega"] = 45.68, ["Mega|Fly"] = 221.21, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 27.9, ["Ride"] = 24.34, ["Fly|Ride"] = 102.89, ["Neon"] = 5.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 59.73, ["Mega|Fly"] = 154.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 226.26}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.14, ["Fly"] = 58.5, ["Ride"] = 38.93, ["Fly|Ride"] = 201.2, ["Neon"] = 81.87, ["Neon|Fly"] = 134.53, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 328.13, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 5.6, ["Fly"] = 44.25, ["Ride"] = 26.24, ["Fly|Ride"] = 72.7, ["Neon"] = 53.12, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 134.5, ["Mega"] = 354.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 431.64}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.26, ["Fly"] = 28.88, ["Ride"] = 34.3, ["Fly|Ride"] = 51.99, ["Neon"] = 66.93, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 164.68, ["Mega"] = 413.6, ["Mega|Ride"] = 331.34, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 70.88, ["Ride"] = 110.25, ["Fly|Ride"] = 255.94, ["Neon"] = 315, ["Neon|Ride"] = 321.56, ["Neon|Fly|Ride"] = 517.81, ["Mega"] = 1445.35, ["Mega|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 8.34, ["Ride"] = 118.27, ["Fly|Ride"] = 434.12, ["Neon"] = 61.89, ["Neon|Fly"] = 125.74, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 357.27, ["Mega"] = 275.63, ["Mega|Ride"] = 442.35, ["Mega|Fly|Ride"] = 628.43}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.33, ["Ride"] = 25.57, ["Fly|Ride"] = 78.73, ["Neon"] = 22.21, ["Neon|Ride"] = 44.63, ["Mega"] = 174.26, ["Mega|Ride"] = 176.96, ["Mega|Fly|Ride"] = 365.54}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.29, ["Fly"] = 135.19, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 44.15, ["Neon|Fly"] = 105, ["Neon|Ride"] = 44.15, ["Neon|Fly|Ride"] = 379.83, ["Mega"] = 317.63, ["Mega|Ride"] = 884.8, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.01, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 15.56, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.83, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.54, ["Fly"] = 164.07, ["Ride"] = 107.63, ["Fly|Ride"] = 164.07, ["Neon"] = 231.55, ["Neon|Fly"] = 2507.26, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 497.64, ["Mega"] = 1105.86, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 892.49}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.46, ["Fly|Ride"] = 144.09, ["Neon"] = 5.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 33.44, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.35, ["Fly|Ride"] = 45.93, ["Neon"] = 19.67, ["Neon|Ride"] = 20.84, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 257.25, ["Mega|Ride"] = 202.71}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 55.01, ["Ride"] = 91.88, ["Fly|Ride"] = 129.94, ["Neon"] = 236.24, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 909.57, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 6.05, ["Neon|Ride"] = 39.38, ["Mega"] = 46.64, ["Mega|Ride"] = 131.69, ["Mega|Fly|Ride"] = 446.22}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.96}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 116.57, ["Fly|Ride"] = 139.59, ["Neon"] = 5.25, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 82.69, ["Mega|Ride"] = 109.15, ["Mega|Fly|Ride"] = 281.95}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 136.5, ["Ride"] = 210, ["Fly|Ride"] = 313.69, ["Neon"] = 663.6, ["Neon|Ride"] = 629.99, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6635.85, ["Mega|Ride"] = 3352.73, ["Mega|Fly|Ride"] = 2444.65}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.77, ["Ride"] = 141.36, ["Fly|Ride"] = 221.19, ["Neon"] = 33.48, ["Neon|Fly"] = 148.22, ["Neon|Ride"] = 103.58, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 227.85, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 2.63, ["Neon|Ride"] = 21.78, ["Mega"] = 45.89, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 68.58, ["Mega|Fly|Ride"] = 428.51}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.29, ["Ride"] = 36.74, ["Fly|Ride"] = 131.25, ["Neon"] = 65.52, ["Neon|Ride"] = 109.51, ["Neon|Fly|Ride"] = 163.7, ["Mega"] = 516.51, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 693.38}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.88, ["Fly"] = 60.92, ["Ride"] = 22.32, ["Fly|Ride"] = 64.16, ["Neon"] = 101.04, ["Neon|Ride"] = 132.72, ["Neon|Fly|Ride"] = 221.19, ["Mega"] = 640.5, ["Mega|Ride"] = 441.25, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.89, ["Ride"] = 56.77, ["Fly|Ride"] = 176.53, ["Neon"] = 154.88, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 344.24, ["Mega"] = 552.57, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 148.19, ["Fly"] = 196.88, ["Ride"] = 186.39, ["Fly|Ride"] = 236.24, ["Neon"] = 639.3, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2492.59}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.92, ["Fly"] = 20.99, ["Ride"] = 18.38, ["Fly|Ride"] = 44.23, ["Neon"] = 95.34, ["Neon|Fly"] = 164.7, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 77.44, ["Mega|Ride"] = 342.83, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 74.11, ["Ride"] = 29.59, ["Fly|Ride"] = 131.25, ["Neon"] = 18.78, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 118.19, ["Mega"] = 161.47, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.27, ["Fly"] = 43.19, ["Ride"] = 40.69, ["Fly|Ride"] = 76.13, ["Neon"] = 45.47, ["Neon|Fly"] = 74.11, ["Neon|Ride"] = 51.43, ["Neon|Fly|Ride"] = 151.25, ["Mega"] = 464.37, ["Mega|Ride"] = 407.54, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 49.62, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 130.52, ["Neon"] = 182.44, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1158.94, ["Mega|Ride"] = 786.19, ["Mega|Fly|Ride"] = 964.68}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.07, ["Fly"] = 57.75, ["Ride"] = 267.66, ["Neon"] = 196.87, ["Neon|Ride"] = 192.44, ["Mega"] = 751.34, ["Mega|Ride"] = 723.24, ["Mega|Fly|Ride"] = 804.39}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.12, ["Ride"] = 350.44, ["Fly|Ride"] = 420, ["Neon"] = 1312.5, ["Neon|Ride"] = 1677.01, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.67, ["Fly"] = 58.65, ["Ride"] = 26.91, ["Fly|Ride"] = 69.46, ["Neon"] = 256.57, ["Neon|Ride"] = 161.47, ["Neon|Fly|Ride"] = 280.9, ["Mega"] = 761.25, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 14.44, ["Fly|Ride"] = 128.3, ["Neon"] = 2.1, ["Neon|Ride"] = 16.09, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 23.63, ["Mega|Fly"] = 117.24, ["Mega|Ride"] = 103.97, ["Mega|Fly|Ride"] = 123.1}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.5, ["Neon"] = 22.08, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 168.47, ["Mega"] = 148.19, ["Mega|Ride"] = 168.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 59.73, ["Neon"] = 13.13, ["Neon|Ride"] = 65.26, ["Neon|Fly|Ride"] = 1181.24, ["Mega"] = 144.87, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 398.12, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 380.63, ["Fly"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 485.63, ["Neon"] = 1968.75, ["Neon|Ride"] = 2065.97, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5698.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.41, ["Fly|Ride"] = 48.56, ["Neon"] = 19.68, ["Neon|Ride"] = 37.62, ["Neon|Fly|Ride"] = 117.23, ["Mega"] = 246.65, ["Mega|Ride"] = 154.63, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.49, ["Fly"] = 28.77, ["Ride"] = 19.99, ["Fly|Ride"] = 44.37, ["Neon"] = 50.7, ["Neon|Fly"] = 47.57, ["Neon|Ride"] = 65.26, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 378.26, ["Mega|Ride"] = 295.28, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.09, ["Fly"] = 42, ["Ride"] = 28.77, ["Fly|Ride"] = 67.11, ["Neon"] = 15.59, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.25, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 94.5, ["Mega|Fly"] = 129.94, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 67.9, ["Ride"] = 34.01, ["Fly|Ride"] = 132.74, ["Neon"] = 220.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1327.18, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 794.01}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.07, ["Fly|Ride"] = 51.85, ["Neon"] = 12.57, ["Neon|Ride"] = 67.8, ["Neon|Fly|Ride"] = 210, ["Mega"] = 167.08, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 748.79}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 14.44, ["Fly"] = 93.13, ["Ride"] = 56.44, ["Neon"] = 170.63, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 115.5, ["Neon"] = 7.05, ["Neon|Ride"] = 38.73, ["Neon|Fly|Ride"] = 84, ["Mega"] = 72.19, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 7.55, ["Ride"] = 24.28, ["Neon"] = 60.99, ["Mega"] = 137.4, ["Mega|Ride"] = 322.93, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.15, ["Ride"] = 59.73, ["Fly|Ride"] = 95.55, ["Neon"] = 45.5, ["Neon|Ride"] = 66.36, ["Mega"] = 884.8, ["Mega|Ride"] = 590.61, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.76, ["Fly"] = 34.13, ["Ride"] = 32.31, ["Fly|Ride"] = 60.34, ["Neon"] = 55.13, ["Neon|Fly"] = 118.19, ["Neon|Ride"] = 62.98, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 551.9, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 431.82, ["Fly"] = 628.43, ["Ride"] = 444.91, ["Fly|Ride"] = 538.13, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 3570, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7608.22}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.99, ["Fly|Ride"] = 40.69, ["Neon"] = 15.65, ["Neon|Fly"] = 84.26, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 269.83, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 10.13, ["Fly"] = 85.99, ["Ride"] = 59.61, ["Fly|Ride"] = 192.44, ["Neon"] = 73.42, ["Neon|Ride"] = 206.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 419.99, ["Mega|Fly"] = 737.69, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 555.21}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 29.93, ["Ride"] = 78.75, ["Fly|Ride"] = 219.17, ["Neon"] = 82.42, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 385.95, ["Mega"] = 328.13, ["Mega|Ride"] = 325.38, ["Mega|Fly|Ride"] = 508.13}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 61.78, ["Fly"] = 220.07, ["Ride"] = 110.61, ["Fly|Ride"] = 131.25, ["Neon"] = 358.31, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.62, ["Mega"] = 2685.18, ["Mega|Fly|Ride"] = 2007.13}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.56, ["Ride"] = 58.45, ["Fly|Ride"] = 295.28, ["Neon"] = 38.51, ["Neon|Ride"] = 107.4, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 197.09, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 360.55}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 126.09, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.68, ["Ride"] = 72.68, ["Neon"] = 24.17, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 202.13, ["Mega|Fly"] = 263.23, ["Mega|Ride"] = 192.44, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 49.18, ["Fly"] = 183.73, ["Ride"] = 81.98, ["Fly|Ride"] = 195.99, ["Neon"] = 118.13, ["Neon|Ride"] = 147.86, ["Neon|Fly|Ride"] = 271.03, ["Mega"] = 421.32, ["Mega|Ride"] = 455.43, ["Mega|Fly|Ride"] = 482}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 7.79, ["Neon|Ride"] = 103.98, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 66.94, ["Mega|Ride"] = 190.24}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 16.61, ["Ride"] = 220.68, ["Neon"] = 116.82, ["Neon|Ride"] = 382.28, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 878.06}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 956.81, ["Fly"] = 1194.38, ["Ride"] = 1018.5, ["Fly|Ride"] = 1111.32, ["Neon"] = 3688, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2884.88, ["Mega"] = 10174.98, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.86, ["Fly"] = 118.13, ["Ride"] = 65.63, ["Fly|Ride"] = 194.25, ["Neon"] = 85.32, ["Neon|Fly"] = 736.32, ["Neon|Ride"] = 192.44, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 466.74, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.89, ["Ride"] = 21.93, ["Fly|Ride"] = 86.5, ["Neon"] = 9.99, ["Neon|Fly"] = 74.1, ["Neon|Ride"] = 34.49, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 76.55, ["Mega|Ride"] = 100.49, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.54, ["Ride"] = 131.24, ["Fly|Ride"] = 148.19, ["Neon"] = 74.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 389.8, ["Mega"] = 288.74, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 503.33}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 192.46, ["Neon"] = 2.1, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 18.25, ["Mega|Ride"] = 45.93, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.42, ["Fly"] = 145.99, ["Ride"] = 97.13, ["Fly|Ride"] = 275.92, ["Neon"] = 227.06, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.17, ["Neon|Fly|Ride"] = 379.32, ["Mega"] = 1023.75, ["Mega|Ride"] = 980.44, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 14.12, ["Ride"] = 62.9, ["Fly|Ride"] = 295.32, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 251.07, ["Mega"] = 576.19, ["Mega|Ride"] = 1030.66, ["Mega|Fly|Ride"] = 1032.87}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.67, ["Ride"] = 30.11, ["Fly|Ride"] = 45.94, ["Neon"] = 9.24, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 221.19, ["Mega"] = 99.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 495.44}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.07, ["Fly"] = 163.7, ["Ride"] = 32.82, ["Fly|Ride"] = 98.62, ["Neon"] = 89.38, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 96.24, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 328.13, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 811.71}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.83, ["Fly"] = 99.56, ["Ride"] = 29.08, ["Fly|Ride"] = 64.32, ["Neon"] = 33.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 160.92, ["Mega"] = 262.4, ["Mega|Ride"] = 552.93, ["Mega|Fly|Ride"] = 375.65}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 41.48, ["Ride"] = 65.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 590.61, ["Mega"] = 2581.37, ["Mega|Ride"] = 1879.96, ["Mega|Fly|Ride"] = 1844.2}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.63, ["Ride"] = 43.32, ["Fly|Ride"] = 199.06, ["Neon"] = 16.31, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 662.82, ["Mega"] = 62.62, ["Mega|Ride"] = 114.08, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.48, ["Fly"] = 37.63, ["Ride"] = 22.31, ["Fly|Ride"] = 52.49, ["Neon"] = 39.38, ["Neon|Fly"] = 192.44, ["Neon|Ride"] = 62.86, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 336, ["Mega|Ride"] = 281.69, ["Mega|Fly|Ride"] = 346.9}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.68, ["Fly"] = 213.68, ["Ride"] = 184.78, ["Fly|Ride"] = 200.82, ["Neon"] = 500.07, ["Neon|Ride"] = 547.32, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2003.64}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 19.17, ["Fly|Ride"] = 48.68, ["Neon"] = 27.53, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 23.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 144.27, ["Mega|Ride"] = 176.98, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 27.55, ["Fly"] = 59.73, ["Ride"] = 75.51, ["Fly|Ride"] = 131.25, ["Neon"] = 192.84, ["Neon|Ride"] = 227.07, ["Neon|Fly|Ride"] = 340.7, ["Mega"] = 713.14, ["Mega|Ride"] = 862.58, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 15.73, ["Fly|Ride"] = 64.3, ["Neon"] = 2.1, ["Neon|Fly"] = 30.26, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 42.06, ["Mega"] = 15.49, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 59.59, ["Neon"] = 3.61, ["Neon|Fly|Ride"] = 137.15, ["Mega"] = 18.38, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 37.62, ["Ride"] = 31.76, ["Fly|Ride"] = 173.37, ["Neon"] = 20.11, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 35.33, ["Fly|Ride"] = 131.25, ["Neon"] = 132.57, ["Neon|Ride"] = 168.51, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 525.72, ["Mega|Ride"] = 663.53}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 16.67, ["Fly|Ride"] = 34.39, ["Neon"] = 15.25, ["Neon|Fly"] = 28.65, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 54.3, ["Mega"] = 104.99, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 9.97, ["Fly"] = 59.73, ["Ride"] = 38.97, ["Fly|Ride"] = 102.58, ["Neon"] = 51.85, ["Neon|Fly"] = 114.38, ["Neon|Ride"] = 63.95, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 390.11, ["Mega|Fly"] = 452.47, ["Mega|Ride"] = 299.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.04, ["Ride"] = 18.26, ["Fly|Ride"] = 69.3, ["Neon"] = 8.52, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 54.89, ["Mega|Fly"] = 106.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.57, ["Fly"] = 165.46, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 44.24, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 295.28, ["Mega|Ride"] = 436.87, ["Mega|Fly|Ride"] = 486.61}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.71, ["Ride"] = 64.97, ["Fly|Ride"] = 196.88, ["Neon"] = 63.18, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 305.82, ["Mega|Ride"] = 317.39, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 44.25, ["Ride"] = 18.19, ["Fly|Ride"] = 52.5, ["Neon"] = 21.36, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 249.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 25.93, ["Ride"] = 16.57, ["Fly|Ride"] = 53.1, ["Neon"] = 16.15, ["Neon|Fly"] = 65.26, ["Neon|Ride"] = 26.7, ["Neon|Fly|Ride"] = 86.27, ["Mega"] = 148.19, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 289.75}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 220.49, ["Fly"] = 393.75, ["Ride"] = 301.67, ["Fly|Ride"] = 441.47, ["Neon"] = 1312.66, ["Neon|Ride"] = 1459.74, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4358.42, ["Mega|Fly|Ride"] = 4021.84}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.92, ["Ride"] = 114.17, ["Neon"] = 35.4, ["Mega"] = 123.38, ["Mega|Ride"] = 671.44, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 110.61, ["Ride"] = 26.25, ["Fly|Ride"] = 57.52, ["Neon"] = 32.4, ["Neon|Fly"] = 251.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 150.9, ["Mega"] = 250.3, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 5.24, ["Fly|Ride"] = 737.69, ["Neon"] = 35.97, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 501.48, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 16.61, ["Fly|Ride"] = 32.43, ["Neon"] = 2.1, ["Neon|Fly"] = 29.87, ["Neon|Ride"] = 17.81, ["Neon|Fly|Ride"] = 44.25, ["Mega"] = 19.43, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 77.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.94, ["Fly"] = 58.23, ["Ride"] = 22.73, ["Fly|Ride"] = 90.57, ["Neon"] = 21.93, ["Neon|Ride"] = 37.62, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 155.05, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.24, ["Ride"] = 121.07, ["Neon"] = 10.24, ["Neon|Ride"] = 295.28, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 52.5, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.58, ["Fly"] = 105, ["Ride"] = 96.39, ["Fly|Ride"] = 154.72, ["Neon"] = 315, ["Neon|Ride"] = 370.47, ["Neon|Fly|Ride"] = 400.32, ["Mega"] = 2949.31, ["Mega|Ride"] = 3688.43, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.33, ["Fly"] = 103.97, ["Ride"] = 23.61, ["Fly|Ride"] = 141.74, ["Neon"] = 25.15, ["Neon|Ride"] = 69.57, ["Mega"] = 169.31, ["Mega|Ride"] = 295.87, ["Mega|Fly|Ride"] = 331.78}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 44.25, ["Neon"] = 5.81, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 564.99, ["Mega"] = 61.73, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 74.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.62, ["Fly"] = 131.25, ["Ride"] = 80.07, ["Fly|Ride"] = 201.34, ["Neon"] = 150.93, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 472.5, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 74.1, ["Ride"] = 14.31, ["Fly|Ride"] = 38.07, ["Neon"] = 2.17, ["Neon|Fly"] = 22.74, ["Neon|Ride"] = 16.61, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 16.8, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 86.7}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 99.56, ["Neon"] = 2.6, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.91, ["Neon|Fly|Ride"] = 163.7, ["Mega"] = 26.24, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 93.02, ["Mega|Fly|Ride"] = 256.47}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.6, ["Ride"] = 45.92, ["Fly|Ride"] = 161.44, ["Neon"] = 7.79, ["Neon|Ride"] = 86.29, ["Neon|Fly|Ride"] = 295.28, ["Mega"] = 69.49, ["Mega|Fly"] = 192.44, ["Mega|Ride"] = 128.77, ["Mega|Fly|Ride"] = 216.87}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.93, ["Fly"] = 99.65, ["Ride"] = 59.09, ["Fly|Ride"] = 106.84, ["Neon"] = 19.05, ["Neon|Fly"] = 81.85, ["Neon|Ride"] = 110.61, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 110.25, ["Mega|Fly"] = 336.45, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.4, ["Ride"] = 15.72, ["Fly|Ride"] = 38.99, ["Neon"] = 2.1, ["Neon|Fly"] = 25.46, ["Neon|Ride"] = 22.62, ["Neon|Fly|Ride"] = 59.73, ["Mega"] = 22.32, ["Mega|Ride"] = 61.82, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.32, ["Fly"] = 130.52, ["Ride"] = 85.31, ["Neon"] = 188.81, ["Neon|Ride"] = 190.24, ["Neon|Fly|Ride"] = 383.74, ["Mega"] = 817.23, ["Mega|Fly|Ride"] = 840.55}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2296.88, ["Fly"] = 3150, ["Ride"] = 2381.69, ["Fly|Ride"] = 2425.5, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 45897.91}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.45, ["Fly|Ride"] = 40.69, ["Neon"] = 10.37, ["Neon|Fly"] = 73.01, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 125.15, ["Mega|Fly"] = 295.28, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 171.41}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 11.32, ["Neon|Ride"] = 72.19, ["Mega"] = 107.02, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 502.74}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.86, ["Fly"] = 105, ["Ride"] = 32.7, ["Fly|Ride"] = 148.19, ["Neon"] = 81.67, ["Neon|Ride"] = 168.12, ["Neon|Fly|Ride"] = 282.72, ["Mega"] = 431.81, ["Mega|Ride"] = 442.35, ["Mega|Fly|Ride"] = 723.66}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 26.25, ["Fly"] = 148.22, ["Ride"] = 73.49, ["Neon"] = 187.69, ["Mega"] = 707.76, ["Mega|Ride"] = 706.65, ["Mega|Fly|Ride"] = 796.22}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.48, ["Fly"] = 548.42, ["Ride"] = 190.32, ["Fly|Ride"] = 274.32, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6635.85, ["Mega|Fly|Ride"] = 3125.14}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.94, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 146.86, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 388.17}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.63, ["Ride"] = 25.16, ["Neon"] = 17.72, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.81, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 27.57, ["Fly|Ride"] = 64.63, ["Neon"] = 7.13, ["Neon|Fly"] = 130.51, ["Neon|Ride"] = 33.77, ["Neon|Fly|Ride"] = 148.19, ["Mega"] = 76.11, ["Mega|Ride"] = 113.02, ["Mega|Fly|Ride"] = 264.97}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.5, ["Ride"] = 72.19, ["Fly|Ride"] = 131.25, ["Neon"] = 130.94, ["Neon|Ride"] = 1262.06, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 590.61, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 26.55, ["Neon"] = 2.1, ["Neon|Ride"] = 30.18, ["Mega"] = 21, ["Mega|Ride"] = 565.95}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.99, ["Fly"] = 259.92, ["Ride"] = 97.93, ["Fly|Ride"] = 170.52, ["Neon"] = 343.04, ["Neon|Fly"] = 473.38, ["Neon|Ride"] = 398.12, ["Neon|Fly|Ride"] = 516.51, ["Mega"] = 3317.93, ["Mega|Ride"] = 1179.95, ["Mega|Fly|Ride"] = 1432.08}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 42.77, ["Ride"] = 91.86, ["Neon"] = 15.59, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 221.21, ["Mega"] = 64.71, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 47.22, ["Fly"] = 235.14, ["Ride"] = 85.32, ["Fly|Ride"] = 162.45, ["Neon"] = 255.94, ["Neon|Ride"] = 383.54, ["Neon|Fly|Ride"] = 428.04, ["Mega"] = 2625, ["Mega|Ride"] = 1475.21, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.21, ["Ride"] = 17.91, ["Fly|Ride"] = 43.66, ["Neon"] = 3.94, ["Neon|Fly"] = 88.04, ["Neon|Ride"] = 74.1, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 42, ["Mega|Fly"] = 168.44, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 87.94, ["Mega"] = 41.51, ["Mega|Ride"] = 427.97, ["Mega|Fly|Ride"] = 552.93}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.26, ["Fly"] = 74.11, ["Ride"] = 24.54, ["Fly|Ride"] = 90.57, ["Neon"] = 23.63, ["Neon|Fly"] = 110.61, ["Neon|Ride"] = 72.47, ["Mega"] = 141.74, ["Mega|Ride"] = 335.73, ["Mega|Fly|Ride"] = 590.54}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 360.94, ["Fly"] = 754.28, ["Ride"] = 393.75, ["Fly|Ride"] = 511.88, ["Neon"] = 918.74, ["Neon|Ride"] = 981.75, ["Neon|Fly|Ride"] = 1065.75, ["Mega"] = 3184.39, ["Mega|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 3353.93}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.62, ["Fly"] = 65.63, ["Ride"] = 81.37, ["Fly|Ride"] = 91.85, ["Neon"] = 200.73, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly"] = 2836.17, ["Mega|Ride"] = 1896.54, ["Mega|Fly|Ride"] = 1090.38}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.62, ["Ride"] = 44.25, ["Fly|Ride"] = 132.74, ["Neon"] = 28.37, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 63.06, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 144.89, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 20.9, ["Fly"] = 219.19, ["Ride"] = 69.7, ["Fly|Ride"] = 137.61, ["Neon"] = 81.38, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 206.05, ["Mega"] = 266.44, ["Mega|Fly"] = 1034.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.9, ["Ride"] = 22.32, ["Neon"] = 101.37, ["Neon|Ride"] = 125.74, ["Mega"] = 671.32, ["Mega|Ride"] = 251.37, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 13.12, ["Neon|Ride"] = 157.49, ["Mega"] = 108.93, ["Mega|Ride"] = 442.4, ["Mega|Fly|Ride"] = 339.54}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 74.11, ["Ride"] = 19.69, ["Fly|Ride"] = 62.97, ["Neon"] = 64.65, ["Neon|Ride"] = 146.86, ["Neon|Fly|Ride"] = 218.71, ["Mega"] = 393.75, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 111.57, ["Fly"] = 251.48, ["Ride"] = 122.13, ["Fly|Ride"] = 194.24, ["Neon"] = 775.39, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2205}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.88, ["Ride"] = 56.72, ["Fly|Ride"] = 85.32, ["Neon"] = 128.52, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 551.25, ["Mega|Ride"] = 633.29, ["Mega|Fly|Ride"] = 811.71}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.36, ["Fly"] = 2514.24, ["Ride"] = 1837.5, ["Fly|Ride"] = 1903.13, ["Neon"] = 11796.05, ["Neon|Ride"] = 8052.98, ["Neon|Fly|Ride"] = 6037.5, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.81, ["Fly"] = 131250, ["Ride"] = 48.67, ["Fly|Ride"] = 196.87, ["Neon"] = 32.42, ["Mega"] = 216.56, ["Mega|Ride"] = 264.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.02, ["Fly"] = 59.88, ["Ride"] = 59.07, ["Fly|Ride"] = 111.06, ["Neon"] = 20.79, ["Neon|Ride"] = 93.12, ["Mega"] = 188.01, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1110, ["Ride"] = 904.12, ["Fly|Ride"] = 945, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.49, ["Mega|Ride"] = 14248.15, ["Mega|Fly|Ride"] = 10344.88}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.87, ["Ride"] = 57.83, ["Fly|Ride"] = 105, ["Neon"] = 144.38, ["Neon|Ride"] = 328.79, ["Neon|Fly|Ride"] = 383.74, ["Mega"] = 874.56, ["Mega|Ride"] = 809.49, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.05, ["Fly|Ride"] = 128.15, ["Neon"] = 13.07, ["Neon|Fly"] = 168.51, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 148.19, ["Neon"] = 5.25, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 21.04, ["Neon|Fly|Ride"] = 115.04, ["Mega"] = 29.51, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.42, ["Fly"] = 442.35, ["Ride"] = 144.37, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 516.51, ["Neon|Fly|Ride"] = 646.98, ["Mega"] = 2514.72, ["Mega|Fly|Ride"] = 2459.71}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 38.73, ["Fly|Ride"] = 77.44, ["Neon"] = 12.5, ["Neon|Ride"] = 37.62, ["Mega"] = 91.87, ["Mega|Ride"] = 168.51, ["Mega|Fly|Ride"] = 249.58}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.75, ["Fly"] = 154.85, ["Ride"] = 106.32, ["Neon"] = 628.43, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 502.13, ["Mega"] = 2211.7, ["Mega|Fly|Ride"] = 1693.06}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.9, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 360.66, ["Mega|Ride"] = 317.7}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 270.14, ["Fly"] = 428.04, ["Ride"] = 294, ["Fly|Ride"] = 353.06, ["Neon"] = 1148.82, ["Neon|Ride"] = 1445.35, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 34.3, ["Ride"] = 18.38, ["Fly|Ride"] = 144.14, ["Neon"] = 33.2, ["Neon|Ride"] = 53.7, ["Neon|Fly|Ride"] = 115.04, ["Mega"] = 250.11, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.75, ["Ride"] = 17.07, ["Fly|Ride"] = 42, ["Neon"] = 4.85, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.13, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 48.3, ["Mega|Ride"] = 114.72, ["Mega|Fly|Ride"] = 125.22}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1382.32, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 8111.22, ["Neon|Fly|Ride"] = 7365.8, ["Mega"] = 25147.06, ["Mega|Fly|Ride"] = 27720.21}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 12.87, ["Ride"] = 84.25, ["Neon"] = 91.73, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 551.9, ["Mega"] = 438.38, ["Mega|Ride"] = 469.5, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.45, ["Fly"] = 53.46, ["Ride"] = 39.78, ["Fly|Ride"] = 104.89, ["Neon"] = 15.75, ["Neon|Ride"] = 59.18, ["Neon|Fly|Ride"] = 116.81, ["Mega"] = 180.45, ["Mega|Ride"] = 187.68, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.42, ["Fly"] = 38.07, ["Ride"] = 32.81, ["Fly|Ride"] = 68.23, ["Neon"] = 163.53, ["Neon|Ride"] = 221.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2654.35, ["Mega|Ride"] = 1174.39, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.5, ["Fly"] = 62.91, ["Ride"] = 29.51, ["Fly|Ride"] = 72.19, ["Neon"] = 58.37, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 590.54}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 81.38, ["Ride"] = 227.39, ["Fly|Ride"] = 644.01, ["Neon"] = 442.35, ["Neon|Fly"] = 590.54, ["Neon|Ride"] = 516.51, ["Neon|Fly|Ride"] = 737.61, ["Mega"] = 1032.87, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 110.61, ["Mega"] = 16.8, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 105, ["Fly"] = 170.62, ["Ride"] = 146.03, ["Fly|Ride"] = 218.52, ["Neon"] = 607.69, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 3538.73, ["Mega|Fly|Ride"] = 2596.53}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 748.35, ["Ride"] = 33.2, ["Fly|Ride"] = 68.74, ["Neon"] = 229.67, ["Neon|Ride"] = 83.99, ["Mega"] = 773.71, ["Mega|Ride"] = 446.92, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 39.36, ["Neon"] = 13.13, ["Neon|Fly"] = 84.26, ["Neon|Ride"] = 88.5, ["Neon|Fly|Ride"] = 74.11, ["Mega"] = 110.61, ["Mega|Ride"] = 280.67}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 145.99, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.86}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 98.32, ["Fly"] = 247.55, ["Ride"] = 203.44, ["Fly|Ride"] = 424.67, ["Neon"] = 551.83, ["Neon|Ride"] = 590.54, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 1837.5, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Neon"] = 28.87, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 161.48, ["Mega|Fly|Ride"] = 335.67}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.26, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.46, ["Mega"] = 17.67, ["Mega|Ride"] = 219.71, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 26.19, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 205.71, ["Mega"] = 18.38, ["Mega|Fly"] = 58.53, ["Mega|Ride"] = 45.54, ["Mega|Fly|Ride"] = 120.65}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 16.19, ["Fly|Ride"] = 52.49, ["Neon"] = 5.07, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 148.22}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Fly"] = 29.87, ["Ride"] = 28.88, ["Fly|Ride"] = 118.34, ["Neon"] = 10.4, ["Mega"] = 137.82, ["Mega|Ride"] = 154.85, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 16.14, ["Fly|Ride"] = 42.79, ["Neon"] = 16.45, ["Neon|Fly"] = 88.5, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 103.97, ["Mega"] = 261.19, ["Mega|Ride"] = 104.34, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 58.22, ["Ride"] = 91.88, ["Fly|Ride"] = 290.51, ["Neon"] = 203.44, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 376.39, ["Mega"] = 643.13, ["Mega|Ride"] = 772.35, ["Mega|Fly|Ride"] = 884.69}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 16.45, ["Fly|Ride"] = 49.23, ["Neon"] = 2.1, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 17.98, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 16.8, ["Mega|Fly"] = 44.23, ["Mega|Ride"] = 55.31, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.62, ["Fly"] = 58.49, ["Ride"] = 41.64, ["Fly|Ride"] = 75.9, ["Neon"] = 41.58, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 135.18, ["Mega"] = 242.82, ["Mega|Fly"] = 590.61, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 25.86, ["Fly"] = 58.94, ["Ride"] = 52.49, ["Fly|Ride"] = 114.35, ["Neon"] = 173.24, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 184.7, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1327.03, ["Mega|Ride"] = 884.69, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.86, ["Fly"] = 209.98, ["Neon"] = 90.95, ["Neon|Ride"] = 105, ["Mega"] = 671.18, ["Mega|Ride"] = 579.36, ["Mega|Fly|Ride"] = 878.16}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.44, ["Ride"] = 16, ["Fly|Ride"] = 43.14, ["Neon"] = 4.23, ["Neon|Fly"] = 81.27, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 40.42, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 15.38, ["Ride"] = 35.44, ["Neon"] = 91.83, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 320.25, ["Mega|Fly"] = 587.22, ["Mega|Ride"] = 587.22, ["Mega|Fly|Ride"] = 649.15}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1312.66, ["Ride"] = 1022.44, ["Fly|Ride"] = 1035.57, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2295.57, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 246.75, ["Ride"] = 249.38, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 884.69, ["Neon|Fly|Ride"] = 989.75, ["Mega"] = 3687.53, ["Mega|Ride"] = 3980.41, ["Mega|Fly|Ride"] = 3582.95}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 10.18, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 264.34, ["Mega"] = 60.38, ["Mega|Fly|Ride"] = 1180.09}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 136.49, ["Fly"] = 196.88, ["Ride"] = 236.14, ["Fly|Ride"] = 325.5, ["Neon"] = 736.15, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 935.55, ["Mega|Ride"] = 2284.38, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Fly"] = 42.06, ["Ride"] = 24.02, ["Fly|Ride"] = 96.24, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 320.71, ["Mega"] = 115.96, ["Mega|Ride"] = 143.29, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 257.25, ["Fly"] = 442.35, ["Ride"] = 286.5, ["Fly|Ride"] = 330.75, ["Neon|Ride"] = 1382.32, ["Neon|Fly|Ride"] = 1194.77, ["Mega|Fly|Ride"] = 3821.06}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 232.79, ["Neon"] = 17.07, ["Neon|Ride"] = 57.99, ["Mega"] = 393.75, ["Mega|Fly"] = 370.47, ["Mega|Ride"] = 590.54}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 41.87, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 48.67, ["Ride"] = 52.5, ["Fly|Ride"] = 148.19, ["Neon"] = 118, ["Neon|Fly"] = 442.35, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 847.75, ["Mega|Ride"] = 593.92, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Fly|Ride"] = 295.28, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 251.37, ["Mega|Ride"] = 267.71, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.42, ["Ride"] = 15.62, ["Fly|Ride"] = 38.07, ["Neon"] = 2.52, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 18.83, ["Neon|Fly|Ride"] = 56.4, ["Mega"] = 27.66, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 36.67, ["Mega|Fly|Ride"] = 107.62}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3839.06, ["Ride"] = 4578, ["Fly|Ride"] = 4721.07, ["Neon"] = 33179.21, ["Neon|Fly|Ride"] = 20755.83, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.87, ["Ride"] = 41.99, ["Neon"] = 88.5, ["Neon|Fly"] = 393.74, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 168.44, ["Mega"] = 210, ["Mega|Ride"] = 277.25, ["Mega|Fly|Ride"] = 441.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 20.97, ["Fly|Ride"] = 47.24, ["Neon"] = 15.53, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 37.38, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.38, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 492.08, ["Fly"] = 547.78, ["Ride"] = 590.52, ["Fly|Ride"] = 557.82, ["Neon"] = 2065.97, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1183.86, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.52, ["Ride"] = 50.35, ["Neon"] = 22.32, ["Neon|Ride"] = 291.38, ["Mega"] = 141.85, ["Mega|Ride"] = 175.87, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.1, ["Fly"] = 145.69, ["Ride"] = 19.69, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 74.1, ["Ride"] = 19.97, ["Fly|Ride"] = 65.62, ["Neon"] = 6.68, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 25.35, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 100.69, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 900.27, ["Ride"] = 767.82, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8293.84}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.88, ["Ride"] = 74.1, ["Fly|Ride"] = 131.25, ["Neon"] = 38.98, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 176.59, ["Mega"] = 223.13, ["Mega|Fly"] = 442.35, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 419.88}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 2.1, ["Fly"] = 106.2, ["Ride"] = 49.86, ["Fly|Ride"] = 210, ["Neon"] = 22.31, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 155.92, ["Mega|Fly"] = 839.28, ["Mega|Ride"] = 191.39, ["Mega|Fly|Ride"] = 278.69}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 24.56, ["Fly|Ride"] = 65.63, ["Neon"] = 14.44, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 86.4, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 239.78}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.07, ["Fly"] = 39.38, ["Ride"] = 39.8, ["Fly|Ride"] = 65.63, ["Neon"] = 118.36, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 295.28, ["Mega"] = 653.58, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 295.32, ["Neon"] = 3.05, ["Neon|Ride"] = 59.19, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.82, ["Mega|Fly"] = 159.26, ["Mega|Ride"] = 101.34, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 693.38, ["Ride"] = 685.64, ["Fly|Ride"] = 710.07, ["Neon"] = 2589.57, ["Neon|Ride"] = 2357.67, ["Neon|Fly|Ride"] = 2415.78, ["Mega|Ride"] = 9805.49, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 254.68, ["Neon"] = 11.81, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 461.16, ["Mega"] = 64.15, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 50.81, ["Fly|Ride"] = 196.88, ["Neon"] = 6.49, ["Neon|Fly"] = 295.32, ["Neon|Ride"] = 226.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 40.69, ["Mega|Ride"] = 154.61, ["Mega|Fly|Ride"] = 442.35}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 61.69, ["Neon"] = 3.94, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7376.99, ["Mega"] = 81.85, ["Mega|Fly"] = 153.41, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 13.02, ["Mega"] = 253.29, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.74, ["Fly"] = 78.75, ["Ride"] = 42, ["Fly|Ride"] = 220.01, ["Neon"] = 155.91, ["Neon|Ride"] = 148.19, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 590.54, ["Mega|Ride"] = 544.18, ["Mega|Fly|Ride"] = 587.87}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.74, ["Ride"] = 52.41, ["Fly|Ride"] = 190.32, ["Neon"] = 85.32, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 590.54, ["Mega|Fly|Ride"] = 755.47}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 30.18, ["Neon|Ride"] = 36.62, ["Neon|Fly|Ride"] = 87.39, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 10.07, ["Ride"] = 29.87, ["Fly|Ride"] = 150.55, ["Neon"] = 70.88, ["Neon|Ride"] = 163.7}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 110.6, ["Neon"] = 14.63, ["Neon|Ride"] = 59.73, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 92.72, ["Mega|Fly"] = 125.72, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 251.44}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.69, ["Fly"] = 28.88, ["Ride"] = 25.12, ["Fly|Ride"] = 55.11, ["Neon"] = 116.93, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 905.63, ["Mega|Fly|Ride"] = 883.59}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 30.19, ["Fly"] = 97.13, ["Neon"] = 118.13, ["Mega"] = 281.71, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 735.67}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.98, ["Fly"] = 85.3, ["Ride"] = 85.32, ["Fly|Ride"] = 259.88, ["Neon"] = 268.97, ["Neon|Ride"] = 345.18, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 2010.93, ["Mega|Fly|Ride"] = 1351.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 34.8, ["Fly"] = 148.22, ["Ride"] = 85.32, ["Fly|Ride"] = 236.66, ["Neon"] = 131.13, ["Neon|Ride"] = 148.19, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 497.82, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 702.92}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 12.85, ["Ride"] = 64.32, ["Neon"] = 140.21, ["Neon|Ride"] = 223.13, ["Mega"] = 502.69, ["Mega|Ride"] = 643.65, ["Mega|Fly|Ride"] = 853.73}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 35.32, ["Fly"] = 393.75, ["Ride"] = 104.98, ["Fly|Ride"] = 265.41, ["Neon"] = 233.4, ["Neon|Ride"] = 301.67, ["Neon|Fly|Ride"] = 704.82, ["Mega"] = 780.11, ["Mega|Ride"] = 809.21, ["Mega|Fly|Ride"] = 890.11}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 23.69, ["Ride"] = 15.94, ["Fly|Ride"] = 32.82, ["Neon"] = 4.29, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 58.59, ["Mega"] = 40.11, ["Mega|Fly"] = 335.67, ["Mega|Ride"] = 55.18, ["Mega|Fly|Ride"] = 146.9}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 918.74}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 115.39, ["Ride"] = 275.63, ["Fly|Ride"] = 374.22, ["Neon"] = 513.24, ["Neon|Ride"] = 527.63, ["Neon|Fly|Ride"] = 870.32, ["Mega"] = 1640.63, ["Mega|Ride"] = 1755, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 83.91, ["Neon"] = 4.29, ["Neon|Fly"] = 103.98, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 306.86, ["Mega"] = 50.29, ["Mega|Ride"] = 141, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.5, ["Ride"] = 78.75, ["Neon"] = 91.88, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 591.93, ["Mega|Ride"] = 736.52, ["Mega|Fly|Ride"] = 618.18}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.3, ["Neon|Fly|Ride"] = 148.22, ["Mega"] = 23.63}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.05, ["Mega"] = 24.47, ["Mega|Ride"] = 145.4, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 111.57, ["Fly"] = 1844.78, ["Ride"] = 148.22, ["Fly|Ride"] = 303.19, ["Neon"] = 671.32, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6920.54, ["Mega|Fly|Ride"] = 2056.91}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.92, ["Fly|Ride"] = 72.45, ["Neon"] = 7.88, ["Neon|Fly"] = 44.25, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 19.69, ["Fly|Ride"] = 66.94, ["Neon"] = 5.79, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 35.25, ["Mega|Ride"] = 132.74, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 6.55, ["Neon"] = 43.32, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 199.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 9.78, ["Neon|Ride"] = 137.82, ["Mega"] = 120.75, ["Mega|Ride"] = 339.54}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.29, ["Ride"] = 189, ["Fly|Ride"] = 369.41, ["Neon"] = 458.07, ["Neon|Ride"] = 603.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2651.25}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 72.19, ["Neon"] = 78.14, ["Mega"] = 422.29, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 393.75, ["Fly|Ride"] = 751.99, ["Neon"] = 918.75, ["Neon|Ride"] = 1485.91, ["Neon|Fly|Ride"] = 1199.63, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 77.44}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.59}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.69}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.59}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.82}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 18.26}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.09}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.92}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 16.96}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.91}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.28}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 1010.62}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.78}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.6}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.3}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 41.51}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 737.61}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 502.03}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.49}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1435.1}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.54}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 33.96}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 64.29}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 13.11}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.27}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.28}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 62.91}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.62}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 12.26}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.55}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.38}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2018.63}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 91.91}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 302.3}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.02}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 23.6}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 31.46}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.48}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.99}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 164.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 43.32}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.29}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 14.4}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 104.99}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 31.97}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.42}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 25.79}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.88}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 94.29}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 326.25}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.07}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 335.73}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 108.28}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21.41}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 25021.34}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.53}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 40.51}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 52.42}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.84}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 129.66}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 82.32}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 108.93}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.54}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 44.63}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.55}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.06}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.49}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 148.19}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.07}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.75}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 228.38}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.38}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.87}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.39}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.3}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.18}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 230.35}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.63}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.11}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.75}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 43.14}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 68.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 17.06}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.09}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.45}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.27}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.36}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.93}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 195.33}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 47.57}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 216.57}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.22}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.46}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.07}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 27.57}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 66.94}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.92}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.93}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.17}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 28.73}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.31}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 2.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.58}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.13}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.68}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.51}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7218.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.64}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.54}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.96}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.99}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.09}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.92}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.13}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.6}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.75}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.46}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 43.84}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.92}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.42}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.88}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.37}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 45.36}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.94}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 80.76}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.86}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 131.14}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.82}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.56}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.28}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 7.76}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.65}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.77}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.25}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.84}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 29.01}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.19}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.5}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 115.45}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 70.55}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.97}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1407}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 85.99}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 3.56}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 57.74}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 32.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.56}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 19.67}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.79}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 15.37}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.1}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 8.79}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.16}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.58}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.66}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 15.53}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.55}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 78.75}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 23.33}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 15.65}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 441.25}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.84}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.84}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.02}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.63}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.21}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.96}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.82}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.91}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 148.19}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 160.99}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 13.96}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1036.75}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 11.46}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.96}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.91}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.13}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.81}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 4.39}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 5.06}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.41}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.86}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.62}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.16}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.15}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.26}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.92}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 12.91}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.92}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 10.97}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.13}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.24}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 51.19}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 59.43}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 55.13}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 97.44}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.2}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 58.46}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.59}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 151.66}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.94}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.44}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 37.93}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 63.63}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.89}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 37.62}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.83}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.96}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.55}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 17.75}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 80.07}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 59.07}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.59}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.33}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 37.53}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.37}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.49}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 93.03}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.4}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.9}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 18.5}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 16.46}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.45}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 20.1}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.91}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 33.74}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.27}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 19.57}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 345.19}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 55.11}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 46.65}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.98}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 164.05}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 98.44}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1132.02}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.75}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.87}},
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