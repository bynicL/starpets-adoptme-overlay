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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 936.25, ["Ride"] = 1123.72, ["Fly|Ride"] = 1610, ["Neon"] = 6500, ["Neon|Ride"] = 6500, ["Neon|Fly|Ride"] = 4828.77, ["Mega"] = 20647.08, ["Mega|Fly|Ride"] = 20647.08}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 510.71, ["Ride"] = 474.81, ["Fly|Ride"] = 584.82, ["Neon|Fly|Ride"] = 1749.99, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 7708.59}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6250, ["Ride"] = 5000, ["Fly|Ride"] = 4874.99, ["Neon|Fly|Ride"] = 16000.46, ["Mega|Fly|Ride"] = 68273.7}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 183.75, ["Fly"] = 218.75, ["Ride"] = 233.32, ["Fly|Ride"] = 311.88, ["Neon"] = 964.23, ["Neon|Ride"] = 964.23, ["Neon|Fly|Ride"] = 812.5, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 602.5, ["Fly"] = 825.89, ["Ride"] = 537.5, ["Fly|Ride"] = 557.5, ["Neon|Fly|Ride"] = 1831.14, ["Mega|Fly|Ride"] = 6125}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.33, ["Ride"] = 50, ["Fly|Ride"] = 123.75, ["Neon"] = 80.82, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 99.99, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 336.9, ["Mega|Ride"] = 495.54, ["Mega|Fly|Ride"] = 577.1}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.69, ["Fly"] = 73.31, ["Ride"] = 27.9, ["Fly|Ride"] = 102.22, ["Neon"] = 123.75, ["Neon|Fly"] = 133.17, ["Neon|Ride"] = 61.96, ["Neon|Fly|Ride"] = 114.99, ["Mega"] = 275.65, ["Mega|Ride"] = 230.62, ["Mega|Fly|Ride"] = 298.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 118.75, ["Fly"] = 206.48, ["Ride"] = 135, ["Neon"] = 499.94, ["Neon|Ride"] = 468.75, ["Neon|Fly|Ride"] = 1377.18, ["Mega"] = 1511.25, ["Mega|Fly"] = 1928.45, ["Mega|Ride"] = 2064.71, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.98, ["Fly"] = 68.9, ["Ride"] = 38.18, ["Fly|Ride"] = 86.45, ["Neon"] = 205.45, ["Neon|Ride"] = 220.93, ["Neon|Fly|Ride"] = 297.5, ["Mega"] = 2000, ["Mega|Ride"] = 1150.05, ["Mega|Fly|Ride"] = 850}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.61, ["Fly"] = 46.73, ["Ride"] = 28, ["Fly|Ride"] = 68.14, ["Neon"] = 145.53, ["Neon|Ride"] = 158.99, ["Neon|Fly|Ride"] = 197.5, ["Mega"] = 619.42, ["Mega|Fly|Ride"] = 1073.66}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 69.18, ["Fly"] = 206.25, ["Ride"] = 105, ["Fly|Ride"] = 186.25, ["Neon"] = 233.2, ["Neon|Ride"] = 259.13, ["Neon|Fly|Ride"] = 394.63, ["Mega|Fly|Ride"] = 1237.81}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.9}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 303.08, ["Fly"] = 344.9, ["Ride"] = 336.06, ["Fly|Ride"] = 348.75, ["Neon|Fly|Ride"] = 1125, ["Mega|Fly|Ride"] = 4900.59}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 125, ["Fly"] = 200.92, ["Ride"] = 140.92, ["Fly|Ride"] = 168.75, ["Neon|Fly"] = 688.59, ["Neon|Ride"] = 545.74, ["Neon|Fly|Ride"] = 511.25, ["Mega"] = 4107.26, ["Mega|Fly|Ride"] = 2350}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.47, ["Fly"] = 75.26, ["Ride"] = 37.5, ["Fly|Ride"] = 125, ["Neon"] = 23.74, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 193.07, ["Mega"] = 152.5, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 344.82}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 200, ["Fly"] = 273.34, ["Ride"] = 233.75, ["Fly|Ride"] = 249.99, ["Neon|Ride"] = 929.12, ["Neon|Fly|Ride"] = 699.88, ["Mega|Fly|Ride"] = 2618.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.65, ["Fly"] = 25.86, ["Ride"] = 20.35, ["Fly|Ride"] = 38.39, ["Neon"] = 21.82, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 54.37, ["Neon|Fly|Ride"] = 83.75, ["Mega"] = 156.25, ["Mega|Ride"] = 246.25, ["Mega|Fly|Ride"] = 402.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 136.25, ["Fly"] = 275.65, ["Ride"] = 162.5, ["Fly|Ride"] = 274.99, ["Neon"] = 362.28, ["Neon|Ride"] = 392.3, ["Neon|Fly|Ride"] = 572.31, ["Mega"] = 1401.68, ["Mega|Ride"] = 1500, ["Mega|Fly|Ride"] = 1377.18}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.7}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 73.75, ["Ride"] = 176.25, ["Fly|Ride"] = 249.9, ["Neon"] = 316.94, ["Neon|Fly|Ride"] = 750, ["Mega"] = 2064.71, ["Mega|Fly|Ride"] = 1513.44}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 28.64, ["Fly"] = 55.76, ["Ride"] = 56.24, ["Fly|Ride"] = 412.95, ["Neon"] = 250, ["Neon|Ride"] = 304.56, ["Neon|Fly|Ride"] = 326.24, ["Mega"] = 750, ["Mega|Ride"] = 1005.52, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 37.39, ["Fly"] = 68.14, ["Ride"] = 55.57, ["Fly|Ride"] = 108.73, ["Neon"] = 220, ["Neon|Fly"] = 201.32, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 268.52, ["Mega"] = 1635.29, ["Mega|Fly|Ride"] = 1025}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 36.25, ["Fly"] = 232.98, ["Ride"] = 81.25, ["Fly|Ride"] = 187.5, ["Neon"] = 237.5, ["Neon|Ride"] = 380.2, ["Neon|Fly|Ride"] = 495, ["Mega"] = 1873.75, ["Mega|Ride"] = 1651.77, ["Mega|Fly|Ride"] = 1485.56}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 32.7, ["Ride"] = 42.58, ["Fly|Ride"] = 97.05, ["Neon"] = 200, ["Neon|Ride"] = 206.48, ["Neon|Fly|Ride"] = 247.77, ["Mega"] = 1150.4, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.91, ["Fly"] = 138.35, ["Ride"] = 68.75, ["Fly|Ride"] = 123.75, ["Neon"] = 310, ["Neon|Fly"] = 390.14, ["Neon|Ride"] = 354.48, ["Neon|Fly|Ride"] = 307.5, ["Mega|Ride"] = 1090.98, ["Mega|Fly|Ride"] = 990}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.05, ["Fly"] = 32.4, ["Ride"] = 24.92, ["Fly|Ride"] = 58.73, ["Neon"] = 43.74, ["Neon|Fly"] = 184.57, ["Neon|Ride"] = 46.23, ["Neon|Fly|Ride"] = 96.2, ["Mega"] = 161.25, ["Mega|Ride"] = 212.5, ["Mega|Fly|Ride"] = 334.9}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 380, ["Ride"] = 395.88, ["Fly|Ride"] = 448.75, ["Neon|Ride"] = 1624.9, ["Neon|Fly|Ride"] = 1872.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 9267.42}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.39, ["Ride"] = 31.25, ["Fly|Ride"] = 62.5, ["Neon"] = 208.74, ["Mega|Ride"] = 784.6, ["Mega|Fly|Ride"] = 639.67}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.78, ["Fly"] = 41.25, ["Ride"] = 20.66, ["Fly|Ride"] = 36.14, ["Neon"] = 60, ["Neon|Ride"] = 70.54, ["Neon|Fly|Ride"] = 102.21, ["Mega"] = 308.61, ["Mega|Ride"] = 425, ["Mega|Fly|Ride"] = 390.14}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 82.78, ["Fly"] = 114.5, ["Ride"] = 80, ["Fly|Ride"] = 131.25, ["Neon"] = 327.06, ["Neon|Ride"] = 358.67, ["Neon|Fly|Ride"] = 381.51, ["Mega"] = 6189.57, ["Mega|Ride"] = 5555, ["Mega|Fly|Ride"] = 2000}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.14, ["Fly"] = 25, ["Ride"] = 34.91, ["Fly|Ride"] = 68.99, ["Neon"] = 63.62, ["Neon|Ride"] = 109.6, ["Neon|Fly|Ride"] = 224.9, ["Mega"] = 686.25, ["Mega|Ride"] = 545.5, ["Mega|Fly|Ride"] = 515.16}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 211.15, ["Fly"] = 275, ["Ride"] = 225, ["Fly|Ride"] = 310.52, ["Neon"] = 618.39, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 662.5, ["Mega"] = 3302.51, ["Mega|Ride"] = 2631.92, ["Mega|Fly|Ride"] = 2847.24}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.42}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.63, ["Fly"] = 36.14, ["Ride"] = 23.75, ["Fly|Ride"] = 67.9, ["Neon"] = 23.75, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 42.49, ["Neon|Fly|Ride"] = 118.75, ["Mega"] = 187.5, ["Mega|Fly"] = 465.23, ["Mega|Ride"] = 371.66, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 687.4, ["Fly"] = 2500, ["Ride"] = 800, ["Fly|Ride"] = 911.25, ["Neon"] = 6194.13, ["Neon|Ride"] = 5230.95, ["Neon|Fly|Ride"] = 4818.01, ["Mega|Ride"] = 52562.79, ["Mega|Fly|Ride"] = 17894.83}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 15.57, ["Fly"] = 97.05, ["Ride"] = 49.46, ["Fly|Ride"] = 100, ["Neon"] = 176.25, ["Neon|Ride"] = 196.16, ["Neon|Fly|Ride"] = 202.35, ["Mega"] = 987.5, ["Mega|Ride"] = 1060.24, ["Mega|Fly|Ride"] = 1090.98}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.74, ["Fly"] = 350.43, ["Ride"] = 224.97, ["Fly|Ride"] = 340, ["Neon"] = 843.74, ["Neon|Ride"] = 850, ["Neon|Fly|Ride"] = 981.24, ["Mega|Ride"] = 5785, ["Mega|Fly|Ride"] = 3713.86}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 43.37}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.31, ["Fly"] = 123.89, ["Ride"] = 69.13, ["Fly|Ride"] = 138.35, ["Neon"] = 62.49, ["Neon|Ride"] = 122.49, ["Neon|Fly|Ride"] = 450, ["Mega"] = 344.82, ["Mega|Ride"] = 548.69, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 106.25, ["Fly"] = 152.96, ["Ride"] = 123.89, ["Fly|Ride"] = 208.75, ["Neon"] = 618.39, ["Neon|Ride"] = 468.7, ["Neon|Fly|Ride"] = 775.6, ["Mega"] = 2270.16, ["Mega|Ride"] = 1790.12, ["Mega|Fly|Ride"] = 1722.49}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 100, ["Fly"] = 149.99, ["Ride"] = 150, ["Fly|Ride"] = 223, ["Neon"] = 370.91, ["Neon|Fly"] = 551.29, ["Neon|Ride"] = 405.97, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1396.25, ["Mega|Fly|Ride"] = 1324.6}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.89}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.91, ["Fly"] = 62.5, ["Ride"] = 57.49, ["Fly|Ride"] = 74.91, ["Neon|Ride"] = 378.88, ["Neon|Fly|Ride"] = 289.07, ["Mega"] = 4129.42, ["Mega|Fly|Ride"] = 1312.3}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.94, ["Fly"] = 97.05, ["Ride"] = 43.75, ["Fly|Ride"] = 150, ["Neon"] = 33.75, ["Neon|Fly"] = 212.5, ["Neon|Ride"] = 67.5, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 181.25, ["Mega|Fly"] = 255, ["Mega|Ride"] = 230.22, ["Mega|Fly|Ride"] = 436.87}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 568.84, ["Fly"] = 688.59, ["Ride"] = 515, ["Fly|Ride"] = 581.25, ["Neon|Fly"] = 3716.48, ["Neon|Ride"] = 1882.5, ["Neon|Fly|Ride"] = 1806.98, ["Mega|Ride"] = 14452.96, ["Mega|Fly|Ride"] = 7125}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 112.5, ["Fly"] = 137.5, ["Ride"] = 125, ["Fly|Ride"] = 187.49, ["Neon"] = 475, ["Neon|Ride"] = 536.84, ["Neon|Fly|Ride"] = 681.37, ["Mega|Ride"] = 2477.66, ["Mega|Fly|Ride"] = 2187.5}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3875, ["Ride"] = 3700, ["Fly|Ride"] = 3750, ["Neon|Fly|Ride"] = 14451.93}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 57.5, ["Fly"] = 125, ["Ride"] = 93.74, ["Fly|Ride"] = 179.63, ["Neon"] = 325, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 450, ["Mega"] = 2064.71, ["Mega|Ride"] = 1928.45, ["Mega|Fly|Ride"] = 1777.5}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 60.62, ["Ride"] = 65, ["Fly|Ride"] = 138.35, ["Neon"] = 548.33, ["Neon|Ride"] = 407.5, ["Neon|Fly|Ride"] = 411.25, ["Mega"] = 6056.84, ["Mega|Ride"] = 2275, ["Mega|Fly|Ride"] = 2333.12}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39.91, ["Fly"] = 68.75, ["Ride"] = 46.25, ["Fly|Ride"] = 121.25, ["Neon"] = 145, ["Neon|Fly"] = 150, ["Neon|Ride"] = 138.34, ["Neon|Fly|Ride"] = 189.99, ["Mega"] = 2500, ["Mega|Ride"] = 857.89, ["Mega|Fly|Ride"] = 549.97}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.14}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 51.64, ["Fly"] = 375, ["Ride"] = 51.25, ["Fly|Ride"] = 93.45, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 578.13, ["Mega|Ride"] = 1246.33, ["Mega|Fly|Ride"] = 1238.83}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 31.25}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 202.49, ["Ride"] = 225, ["Fly|Ride"] = 268.75, ["Neon"] = 1101.53, ["Neon|Ride"] = 1101.53, ["Neon|Fly|Ride"] = 1101.53}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 681.25, ["Fly"] = 696.85, ["Ride"] = 593.75, ["Fly|Ride"] = 625, ["Neon"] = 2500, ["Neon|Fly|Ride"] = 4129.42, ["Mega|Fly|Ride"] = 10728.91}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.39}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.88, ["Fly"] = 53.58, ["Ride"] = 35, ["Fly|Ride"] = 61.22, ["Neon"] = 160.03, ["Neon|Fly"] = 247.77, ["Neon|Ride"] = 136.25, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 2064.71, ["Mega|Ride"] = 1121.35, ["Mega|Fly|Ride"] = 675}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 21.98}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5000, ["Fly"] = 5676.92, ["Ride"] = 6193.1, ["Fly|Ride"] = 4814.9, ["Neon|Ride"] = 17133.14, ["Neon|Fly|Ride"] = 10312, ["Mega|Fly|Ride"] = 42050.24}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.27, ["Fly"] = 55.76, ["Ride"] = 24.79, ["Fly|Ride"] = 52.66, ["Neon"] = 78.75, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 155.9, ["Mega"] = 535, ["Mega|Ride"] = 467.5, ["Mega|Fly|Ride"] = 487.5}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 9.79, ["Fly"] = 135.24, ["Ride"] = 36.14, ["Fly|Ride"] = 115.65, ["Neon"] = 87.5, ["Neon|Ride"] = 118.73, ["Neon|Fly|Ride"] = 250, ["Mega"] = 688.59, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.72, ["Ride"] = 69.18, ["Fly|Ride"] = 81.24, ["Neon|Ride"] = 386.11, ["Neon|Fly|Ride"] = 462.68, ["Mega"] = 4129.42, ["Mega|Fly|Ride"] = 1713.56}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.25, ["Fly"] = 69.18, ["Ride"] = 34.91, ["Fly|Ride"] = 75, ["Neon"] = 87.5, ["Neon|Ride"] = 141.25, ["Neon|Fly|Ride"] = 250, ["Mega"] = 482.12, ["Mega|Ride"] = 732.38, ["Mega|Fly|Ride"] = 762.5}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1698.75, ["Fly"] = 1858.24, ["Ride"] = 1763.75, ["Fly|Ride"] = 1571.25, ["Neon|Fly|Ride"] = 3600, ["Mega|Fly|Ride"] = 11875}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Fly"] = 33035.33, ["Ride"] = 33750, ["Fly|Ride"] = 24912.5, ["Neon|Ride"] = 62500, ["Neon|Fly|Ride"] = 60000, ["Mega|Fly|Ride"] = 174998.75}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 22.72, ["Fly"] = 375, ["Ride"] = 52.49, ["Fly|Ride"] = 123.89, ["Neon"] = 238.86, ["Neon|Ride"] = 198.75, ["Neon|Fly|Ride"] = 555, ["Mega"] = 618.39, ["Mega|Ride"] = 1313.17, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.61, ["Fly"] = 136.18, ["Ride"] = 35.11, ["Fly|Ride"] = 156.25, ["Neon"] = 24.39, ["Neon|Fly"] = 138.23, ["Neon|Ride"] = 61.96, ["Neon|Fly|Ride"] = 180.52, ["Mega"] = 175.5, ["Mega|Ride"] = 217.5, ["Mega|Fly|Ride"] = 249.95}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 21.77}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.13, ["Ride"] = 47.5, ["Fly|Ride"] = 125, ["Neon"] = 53.75, ["Neon|Ride"] = 111.25, ["Neon|Fly|Ride"] = 263.9, ["Mega"] = 275.65, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 730.92}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 750.53, ["Ride"] = 750, ["Fly|Ride"] = 815, ["Neon"] = 2959.87, ["Neon|Ride"] = 2409.52, ["Neon|Fly|Ride"] = 2500, ["Mega|Fly|Ride"] = 10902.69}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 874.9, ["Fly"] = 1024.9, ["Ride"] = 829.9, ["Fly|Ride"] = 875, ["Neon"] = 3992.13, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11058.05}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 21.17, ["Fly"] = 116.82, ["Ride"] = 29.9, ["Fly|Ride"] = 73.5, ["Neon"] = 75.82, ["Neon|Ride"] = 114.6, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 472.88, ["Mega|Ride"] = 458.95, ["Mega|Fly|Ride"] = 437.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.42}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.67, ["Fly"] = 86.67, ["Ride"] = 63.08, ["Fly|Ride"] = 124.9, ["Neon"] = 551.29, ["Neon|Ride"] = 312.5, ["Neon|Fly|Ride"] = 400, ["Mega"] = 18750, ["Mega|Ride"] = 1928.45, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 69.18, ["Ride"] = 89.82, ["Fly|Ride"] = 206.48, ["Neon"] = 428.75, ["Neon|Ride"] = 391.51, ["Neon|Fly|Ride"] = 527.4, ["Mega"] = 1343.5, ["Mega|Ride"] = 1858.24, ["Mega|Fly|Ride"] = 1868.9}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.83, ["Fly"] = 30.88, ["Ride"] = 21.92, ["Fly|Ride"] = 49.9, ["Neon"] = 39.73, ["Neon|Fly"] = 499.99, ["Neon|Ride"] = 94.98, ["Neon|Fly|Ride"] = 103.23, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 160.9, ["Fly"] = 183.73, ["Ride"] = 181.25, ["Fly|Ride"] = 248.49, ["Neon"] = 824.87, ["Neon|Fly"] = 666.91, ["Neon|Ride"] = 617.49, ["Neon|Fly|Ride"] = 637.5, ["Mega"] = 4955.31, ["Mega|Fly|Ride"] = 2497.49}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 7.32, ["Ride"] = 45.58, ["Fly|Ride"] = 135, ["Neon"] = 41.3, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 404.46, ["Mega"] = 237.4, ["Mega|Ride"] = 322.7, ["Mega|Fly|Ride"] = 623.74}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.96, ["Fly"] = 62.5, ["Ride"] = 35.82, ["Fly|Ride"] = 62.18, ["Neon"] = 115, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 150, ["Mega"] = 623.75, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.93, ["Ride"] = 87.5, ["Fly|Ride"] = 141.31, ["Neon"] = 210.29, ["Neon|Ride"] = 268.75, ["Mega"] = 950, ["Mega|Ride"] = 812.5, ["Mega|Fly|Ride"] = 963.66}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.16, ["Fly"] = 55.76, ["Ride"] = 24.99, ["Fly|Ride"] = 74.93, ["Neon"] = 98.75, ["Neon|Ride"] = 121.82, ["Neon|Fly|Ride"] = 312.82, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6423.75, ["Ride"] = 5250, ["Fly|Ride"] = 5000, ["Neon"] = 34412.49, ["Neon|Ride"] = 27500, ["Neon|Fly|Ride"] = 28768.61, ["Mega|Fly|Ride"] = 93444.96}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 200, ["Fly"] = 237.48, ["Ride"] = 233.33, ["Fly|Ride"] = 304.88, ["Neon"] = 779.11, ["Neon|Fly"] = 700.85, ["Neon|Fly|Ride"] = 541.47, ["Mega|Fly|Ride"] = 1875}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 59.3, ["Fly"] = 291.06, ["Ride"] = 78.47, ["Fly|Ride"] = 213.75, ["Neon"] = 175.38, ["Neon|Fly"] = 337.59, ["Neon|Ride"] = 228.73, ["Neon|Fly|Ride"] = 305, ["Mega"] = 554.83, ["Mega|Ride"] = 450, ["Mega|Fly|Ride"] = 562.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.35, ["Fly"] = 86.45, ["Ride"] = 20.18, ["Fly|Ride"] = 77.5, ["Neon"] = 20.59, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 275.65, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 62.49, ["Fly"] = 205.07, ["Ride"] = 187.2, ["Fly|Ride"] = 211.25, ["Neon"] = 190, ["Neon|Ride"] = 242.02, ["Neon|Fly|Ride"] = 475, ["Mega"] = 459.96, ["Mega|Ride"] = 450, ["Mega|Fly|Ride"] = 700}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15830.12, ["Ride"] = 12776.25, ["Fly|Ride"] = 11246.25, ["Neon|Fly|Ride"] = 21875, ["Mega|Fly|Ride"] = 97592.55}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 309.71, ["Ride"] = 387.5, ["Fly|Ride"] = 530, ["Neon|Ride"] = 1501.05, ["Neon|Fly|Ride"] = 3375}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.1, ["Fly"] = 77.43, ["Ride"] = 61.25, ["Fly|Ride"] = 107.78, ["Neon"] = 999.99, ["Neon|Ride"] = 312.48, ["Neon|Fly|Ride"] = 318.75, ["Mega|Fly|Ride"] = 1925}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.03, ["Ride"] = 23.37, ["Fly|Ride"] = 56.25, ["Neon"] = 64.25, ["Neon|Fly"] = 311.88, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 401.25, ["Mega|Ride"] = 700.85, ["Mega|Fly|Ride"] = 482.12}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 373.65, ["Fly"] = 825.89, ["Ride"] = 399.99, ["Fly|Ride"] = 516.18, ["Neon"] = 1610.49, ["Neon|Ride"] = 1373.75, ["Neon|Fly|Ride"] = 1249.99, ["Mega|Fly|Ride"] = 4375}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 9.9, ["Ride"] = 39.17, ["Fly|Ride"] = 189.99, ["Neon"] = 30, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 214.74, ["Mega"] = 151.25, ["Mega|Fly"] = 251.35, ["Mega|Ride"] = 216.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 92.31, ["Fly"] = 159.91, ["Ride"] = 151.25, ["Fly|Ride"] = 188.29, ["Neon"] = 515.16, ["Neon|Fly"] = 500, ["Neon|Ride"] = 437.49, ["Neon|Fly|Ride"] = 497.5, ["Mega|Fly|Ride"] = 2148.32}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.01, ["Fly"] = 20.92, ["Ride"] = 20.81, ["Fly|Ride"] = 36.16, ["Neon"] = 110.47, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 103.56, ["Mega"] = 2477.66, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 75, ["Ride"] = 83.75, ["Fly|Ride"] = 125, ["Neon"] = 309.71, ["Neon|Fly"] = 515.16, ["Neon|Ride"] = 387.5, ["Neon|Fly|Ride"] = 410, ["Mega"] = 1514.47, ["Mega|Ride"] = 1926.38, ["Mega|Fly|Ride"] = 1651.65}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 11.5, ["Fly"] = 76.25, ["Ride"] = 35.3, ["Fly|Ride"] = 90, ["Neon"] = 84.99, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 228.15, ["Mega"] = 556.44, ["Mega|Ride"] = 550, ["Mega|Fly|Ride"] = 699.94}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 33.35}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 71.25, ["Fly"] = 138.35, ["Ride"] = 112.5, ["Fly|Ride"] = 311.88, ["Neon"] = 309.71, ["Neon|Ride"] = 445.98, ["Neon|Fly|Ride"] = 548.19, ["Mega|Fly|Ride"] = 1651.77}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.58, ["Ride"] = 27.84, ["Fly|Ride"] = 131.25, ["Neon"] = 25, ["Neon|Ride"] = 131.12, ["Neon|Fly|Ride"] = 247.77, ["Mega|Fly|Ride"] = 315.63}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.13, ["Fly"] = 53.74, ["Ride"] = 31.57, ["Fly|Ride"] = 90.48, ["Neon"] = 152.5, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 205.45, ["Mega|Ride"] = 400, ["Mega|Fly|Ride"] = 558.75}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 464.57, ["Fly"] = 516.18, ["Ride"] = 494.28, ["Fly|Ride"] = 474.99, ["Neon|Fly|Ride"] = 2683.09, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35, ["Fly"] = 103.23, ["Ride"] = 48.5, ["Fly|Ride"] = 94.96, ["Neon"] = 148.75, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 358.61, ["Mega"] = 739.45, ["Mega|Ride"] = 649, ["Mega|Fly|Ride"] = 683.65}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.13, ["Fly"] = 137.58, ["Ride"] = 66, ["Fly|Ride"] = 137.4, ["Neon"] = 225, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 250, ["Mega|Ride"] = 1015.85, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 21.72, ["Fly"] = 97.05, ["Ride"] = 74.89, ["Fly|Ride"] = 121.84, ["Neon"] = 93.75, ["Neon|Ride"] = 122.51, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 340.69, ["Mega|Fly"] = 500, ["Mega|Ride"] = 495.45, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 10750, ["Fly"] = 10000, ["Ride"] = 8440, ["Fly|Ride"] = 7796.25, ["Neon|Fly|Ride"] = 14000, ["Mega|Fly|Ride"] = 37000}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1435, ["Fly"] = 1430.33, ["Ride"] = 1284.91, ["Fly|Ride"] = 1400, ["Neon|Fly|Ride"] = 4281.33, ["Mega|Fly|Ride"] = 23400.38}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 593.61, ["Ride"] = 545.5, ["Fly|Ride"] = 688.59, ["Neon"] = 2146.26, ["Neon|Fly|Ride"] = 2937.5, ["Mega"] = 20647.08, ["Mega|Fly|Ride"] = 9500}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.9, ["Fly"] = 25, ["Ride"] = 23.13, ["Fly|Ride"] = 37.5, ["Neon"] = 130, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 124.98, ["Mega|Ride"] = 400, ["Mega|Fly|Ride"] = 549.99}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.75, ["Fly"] = 50, ["Ride"] = 36.01, ["Fly|Ride"] = 189.96, ["Neon"] = 23.28, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 179.89, ["Mega|Ride"] = 190.87, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.49, ["Fly"] = 39.91, ["Ride"] = 47.3, ["Fly|Ride"] = 92.5, ["Neon"] = 525.63, ["Neon|Ride"] = 138.75, ["Neon|Fly|Ride"] = 156.54, ["Mega|Fly|Ride"] = 635}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.29, ["Fly"] = 24.79, ["Ride"] = 18.59, ["Fly|Ride"] = 41.2, ["Neon"] = 28.75, ["Neon|Fly"] = 82.5, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 103.74, ["Mega"] = 206.48, ["Mega|Ride"] = 737.5, ["Mega|Fly|Ride"] = 233.74}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 292.16, ["Fly"] = 405.9, ["Ride"] = 303.34, ["Fly|Ride"] = 337.49, ["Neon"] = 1238.83, ["Neon|Ride"] = 1391.62, ["Neon|Fly|Ride"] = 875, ["Mega|Fly|Ride"] = 4129.42}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.24, ["Fly"] = 57.83, ["Ride"] = 40.18, ["Fly|Ride"] = 82.6, ["Neon"] = 137.5, ["Neon|Fly"] = 387.89, ["Neon|Ride"] = 166.19, ["Neon|Fly|Ride"] = 218.87, ["Mega"] = 825.89, ["Mega|Ride"] = 625, ["Mega|Fly|Ride"] = 674.9}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.25, ["Fly"] = 23.75, ["Ride"] = 21.17, ["Fly|Ride"] = 43.75, ["Neon"] = 80.54, ["Neon|Fly"] = 116.66, ["Neon|Ride"] = 115.65, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 1500, ["Mega|Ride"] = 588.71, ["Mega|Fly|Ride"] = 403.75}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 407.79, ["Fly"] = 998.75, ["Ride"] = 516.18, ["Fly|Ride"] = 825.31, ["Mega|Fly|Ride"] = 9496.25}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1062.5, ["Fly"] = 1377.18, ["Ride"] = 1156.25, ["Fly|Ride"] = 1124.99, ["Neon"] = 5012.16, ["Neon|Fly|Ride"] = 3400, ["Mega|Fly|Ride"] = 13075.8}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 100, ["Fly"] = 138.35, ["Ride"] = 94.49, ["Fly|Ride"] = 102.31, ["Neon"] = 925, ["Neon|Ride"] = 567.81, ["Neon|Fly|Ride"] = 468.7, ["Mega|Fly|Ride"] = 2718.09}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 174.9, ["Fly"] = 234.35, ["Ride"] = 218.75, ["Fly|Ride"] = 270.48, ["Neon"] = 964.23, ["Neon|Ride"] = 817.63, ["Neon|Fly|Ride"] = 691.25, ["Mega|Ride"] = 8750, ["Mega|Fly|Ride"] = 2475}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 20.66, ["Fly"] = 55.76, ["Ride"] = 50, ["Fly|Ride"] = 110.47, ["Neon"] = 242.49, ["Neon|Ride"] = 229.09, ["Mega|Ride"] = 2064.71, ["Mega|Fly|Ride"] = 1045.42}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 345, ["Ride"] = 410.62, ["Fly|Ride"] = 468.7, ["Neon"] = 1162.5, ["Neon|Fly|Ride"] = 1238.83, ["Mega|Fly|Ride"] = 5506.58}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1875, ["Ride"] = 1874.9, ["Fly|Ride"] = 2000, ["Neon|Fly|Ride"] = 10323.54, ["Mega|Fly|Ride"] = 35041.86}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 54.91, ["Fly"] = 206.48, ["Ride"] = 47.5, ["Fly|Ride"] = 187.5, ["Neon"] = 206.48, ["Neon|Ride"] = 225, ["Neon|Fly|Ride"] = 327.5, ["Mega|Ride"] = 2271.19, ["Mega|Fly|Ride"] = 1199.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 625, ["Fly"] = 708.21, ["Ride"] = 624.9, ["Fly|Ride"] = 667.95, ["Neon|Ride"] = 1427.5, ["Neon|Fly|Ride"] = 1245, ["Mega|Fly|Ride"] = 4000}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 43.51, ["Fly"] = 68.75, ["Ride"] = 61.96, ["Fly|Ride"] = 105.9, ["Neon|Ride"] = 362.11, ["Neon|Fly|Ride"] = 275, ["Mega|Ride"] = 1032.36, ["Mega|Fly|Ride"] = 1125}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.69, ["Fly"] = 40.28, ["Ride"] = 22.88, ["Fly|Ride"] = 55.41, ["Neon"] = 24.92, ["Neon|Fly"] = 105, ["Neon|Ride"] = 48.74, ["Neon|Fly|Ride"] = 97.5, ["Mega"] = 158.74, ["Mega|Ride"] = 178.36, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 46.73, ["Ride"] = 82.12, ["Fly|Ride"] = 150, ["Neon"] = 262.4, ["Neon|Ride"] = 458.54, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 1511.38, ["Mega|Ride"] = 1651.77, ["Mega|Fly|Ride"] = 1638.35}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 943.54, ["Fly"] = 1031.34, ["Ride"] = 896.03, ["Fly|Ride"] = 937.5, ["Neon|Ride"] = 3153.78, ["Neon|Fly|Ride"] = 2930, ["Mega|Fly|Ride"] = 11012.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 620, ["Ride"] = 771.25, ["Fly|Ride"] = 800.08, ["Neon|Fly|Ride"] = 3096.03, ["Mega|Fly|Ride"] = 15142.57}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.55, ["Fly"] = 25, ["Ride"] = 22.2, ["Fly|Ride"] = 41.3, ["Neon"] = 137.5, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 137.5, ["Mega|Fly|Ride"] = 688.11}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 15.6, ["Ride"] = 38.78, ["Fly|Ride"] = 114.6, ["Neon"] = 160, ["Neon|Ride"] = 186.9, ["Neon|Fly|Ride"] = 238.75, ["Mega"] = 964.23, ["Mega|Ride"] = 941.52, ["Mega|Fly|Ride"] = 675}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.93, ["Ride"] = 53.16, ["Fly|Ride"] = 206.48, ["Neon"] = 22.42, ["Neon|Fly"] = 311.88, ["Neon|Ride"] = 76.4, ["Neon|Fly|Ride"] = 216.8, ["Mega"] = 187.5, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 454.24}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 45.33, ["Fly"] = 41.3, ["Ride"] = 50, ["Fly|Ride"] = 110.3, ["Neon"] = 304.56, ["Neon|Ride"] = 130.09, ["Neon|Fly|Ride"] = 198.05, ["Mega|Ride"] = 1038.42, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 92.8, ["Ride"] = 311.88, ["Fly|Ride"] = 344.82, ["Neon"] = 393.75, ["Neon|Ride"] = 475, ["Neon|Fly|Ride"] = 662.5, ["Mega|Fly|Ride"] = 2464.24}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.39, ["Fly"] = 49.91, ["Ride"] = 34.28, ["Fly|Ride"] = 86.25, ["Neon"] = 81.25, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 256.02, ["Mega"] = 409.23, ["Mega|Ride"] = 334.55, ["Mega|Fly|Ride"] = 491.25}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.75, ["Fly"] = 58.75, ["Ride"] = 40.74, ["Fly|Ride"] = 85.9, ["Neon"] = 231.25, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 237.4, ["Mega"] = 1548.54, ["Mega|Fly|Ride"] = 1124.99}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.58, ["Fly"] = 43.18, ["Ride"] = 19.7, ["Fly|Ride"] = 37.63, ["Neon"] = 25.9, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 87.49, ["Mega"] = 275.65, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 351.25}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.88, ["Fly"] = 51.25, ["Ride"] = 38.75, ["Fly|Ride"] = 84.68, ["Neon"] = 49.91, ["Neon|Fly"] = 110.03, ["Neon|Ride"] = 65, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 396.25, ["Mega|Ride"] = 420.51, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 43.33, ["Fly"] = 68.74, ["Ride"] = 49.48, ["Fly|Ride"] = 97.39, ["Neon"] = 550.89, ["Neon|Fly"] = 201.32, ["Neon|Ride"] = 206.48, ["Neon|Fly|Ride"] = 259.56, ["Mega|Fly|Ride"] = 1023.73}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1330, ["Fly"] = 1343.74, ["Ride"] = 1391.73, ["Fly|Ride"] = 1462.5, ["Neon"] = 4321.84, ["Neon|Ride"] = 4818.01, ["Neon|Fly|Ride"] = 3448.75, ["Mega|Fly|Ride"] = 11977.49}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 449.98, ["Fly"] = 499.99, ["Ride"] = 456.25, ["Fly|Ride"] = 499.98, ["Neon|Ride"] = 3579.18, ["Neon|Fly|Ride"] = 2250, ["Mega"] = 14452.96, ["Mega|Fly|Ride"] = 8258.84}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 293.65, ["Fly"] = 360.21, ["Ride"] = 330.37, ["Fly|Ride"] = 375, ["Neon"] = 1500, ["Neon|Ride"] = 1375, ["Neon|Fly|Ride"] = 1562.5, ["Mega|Fly|Ride"] = 7432.96}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.13}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 31.05, ["Ride"] = 51.91, ["Fly|Ride"] = 95, ["Neon"] = 309.71, ["Neon|Fly"] = 412.95, ["Neon|Ride"] = 237.46, ["Neon|Fly|Ride"] = 371.66, ["Mega|Ride"] = 1135.6, ["Mega|Fly|Ride"] = 987.18}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 67500, ["Fly"] = 25808.86, ["Ride"] = 35820.96, ["Fly|Ride"] = 17485, ["Neon|Fly|Ride"] = 35998.75, ["Mega"] = 206470.77, ["Mega|Fly|Ride"] = 85000}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 221.41, ["Fly"] = 250, ["Ride"] = 237.46, ["Fly|Ride"] = 291.49, ["Neon"] = 860, ["Neon|Ride"] = 928.9, ["Neon|Fly|Ride"] = 906.25, ["Mega"] = 6194.13, ["Mega|Fly|Ride"] = 3125}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 117.5, ["Fly"] = 500, ["Ride"] = 237.5, ["Fly|Ride"] = 249.99}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 112.5, ["Fly"] = 150, ["Ride"] = 105, ["Fly|Ride"] = 173.75, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 3442.91, ["Mega|Fly|Ride"] = 2888.54}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.48, ["Fly"] = 61.96, ["Ride"] = 23.37, ["Fly|Ride"] = 81.56, ["Neon"] = 412.95, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 698.51, ["Mega|Ride"] = 623.75, ["Mega|Fly|Ride"] = 1031.34}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4542.37, ["Ride"] = 3750, ["Fly|Ride"] = 3999.99, ["Neon"] = 20647.08, ["Neon|Fly|Ride"] = 15000, ["Mega|Fly|Ride"] = 77871.2}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.17, ["Fly"] = 39.99, ["Ride"] = 32.9, ["Fly|Ride"] = 54.99, ["Neon"] = 125, ["Neon|Ride"] = 180.67, ["Neon|Fly|Ride"] = 164.88, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 30, ["Ride"] = 50.84, ["Fly|Ride"] = 89, ["Neon"] = 277.78, ["Neon|Fly"] = 1377.18, ["Neon|Ride"] = 193.13, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1348.75}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 413.73, ["Fly"] = 536.24, ["Ride"] = 424.9, ["Fly|Ride"] = 500, ["Neon"] = 1250, ["Neon|Ride"] = 1187.5, ["Neon|Fly|Ride"] = 1368.65, ["Mega|Fly|Ride"] = 4097.65}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.25, ["Fly"] = 27.49, ["Ride"] = 23.27, ["Fly|Ride"] = 38.74, ["Neon"] = 125, ["Neon|Ride"] = 105.88, ["Neon|Fly|Ride"] = 138.34, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 578.04}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 13.75, ["Ride"] = 32.9, ["Fly|Ride"] = 78.27, ["Neon"] = 87.5, ["Neon|Ride"] = 124.9, ["Neon|Fly|Ride"] = 201.15, ["Mega"] = 545.5, ["Mega|Ride"] = 396, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.74, ["Ride"] = 102.22, ["Fly|Ride"] = 233.75, ["Neon"] = 700.85, ["Neon|Ride"] = 487.5, ["Neon|Fly|Ride"] = 1502.09, ["Mega|Fly|Ride"] = 2475.6}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 18.59, ["Fly"] = 110, ["Ride"] = 91.82, ["Fly|Ride"] = 125, ["Neon"] = 89.32, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 249.45, ["Mega"] = 375, ["Mega|Ride"] = 297.79, ["Mega|Fly|Ride"] = 481.54}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4061.25, ["Fly"] = 6073.94, ["Ride"] = 4126.03, ["Fly|Ride"] = 3750, ["Neon"] = 18750, ["Neon|Ride"] = 11750, ["Neon|Fly|Ride"] = 9937.5, ["Mega"] = 46800.74, ["Mega|Fly|Ride"] = 36138.75}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 37.5, ["Fly"] = 138.35, ["Ride"] = 58.75, ["Fly|Ride"] = 137.5, ["Neon"] = 212.67, ["Neon|Ride"] = 246.25, ["Neon|Fly|Ride"] = 237.5, ["Mega"] = 825.89, ["Mega|Ride"] = 824.87, ["Mega|Fly|Ride"] = 747.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6250, ["Fly"] = 7329.73, ["Ride"] = 6531.25, ["Fly|Ride"] = 6250, ["Neon|Fly|Ride"] = 14425, ["Mega|Fly|Ride"] = 44687.5}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.39, ["Fly"] = 19.79, ["Ride"] = 16.9, ["Fly|Ride"] = 37.5, ["Neon"] = 47.48, ["Neon|Fly"] = 59.63, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 92.5, ["Mega"] = 200, ["Mega|Ride"] = 355, ["Mega|Fly|Ride"] = 249.98}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.48, ["Fly"] = 32.37, ["Ride"] = 31.55, ["Fly|Ride"] = 45, ["Neon"] = 179.63, ["Neon|Fly"] = 228.16, ["Neon|Ride"] = 551.29, ["Neon|Fly|Ride"] = 137.76, ["Mega|Ride"] = 950.63, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.8, ["Fly"] = 31.25, ["Ride"] = 28.75, ["Fly|Ride"] = 82.87, ["Neon"] = 74.98, ["Neon|Ride"] = 115, ["Mega"] = 1000, ["Mega|Ride"] = 1031.34, ["Mega|Fly|Ride"] = 775.31}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 21.25, ["Fly"] = 181.3, ["Ride"] = 44.57, ["Fly|Ride"] = 165.19, ["Neon"] = 123.89, ["Neon|Ride"] = 122.51, ["Neon|Fly|Ride"] = 208.75, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 1047.5}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15, ["Fly"] = 27.5, ["Ride"] = 19.98, ["Fly|Ride"] = 39.91, ["Neon|Fly"] = 1029.27, ["Neon|Ride"] = 109.44, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 2477.66, ["Mega|Ride"] = 408.82, ["Mega|Fly|Ride"] = 582.26}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8397.18}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2500}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.73}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 231.7, ["Ride"] = 265.16, ["Fly|Ride"] = 201.32, ["Neon|Fly|Ride"] = 1155.23}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.41, ["Fly"] = 92.44, ["Ride"] = 31.22, ["Fly|Ride"] = 138.35, ["Neon"] = 112.8, ["Neon|Ride"] = 111.25, ["Neon|Fly|Ride"] = 252.5, ["Mega"] = 423.27, ["Mega|Ride"] = 1948.33, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.15}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.04, ["Ride"] = 24.99, ["Fly|Ride"] = 82.6, ["Neon|Ride"] = 237.5, ["Mega"] = 1514.47}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2245}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.9, ["Fly"] = 412.95, ["Ride"] = 250, ["Fly|Ride"] = 350, ["Neon"] = 964.23, ["Neon|Ride"] = 934.46, ["Neon|Fly|Ride"] = 958.04, ["Mega|Ride"] = 3992.13, ["Mega|Fly|Ride"] = 3749}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 61.25, ["Fly"] = 454.38, ["Ride"] = 96.9, ["Fly|Ride"] = 233.63, ["Neon"] = 375, ["Neon|Ride"] = 350, ["Neon|Fly|Ride"] = 536.84, ["Mega|Fly|Ride"] = 1858.24}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 155.81, ["Fly"] = 263.26, ["Ride"] = 175, ["Fly|Ride"] = 220.93, ["Neon"] = 899.99, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 795.61, ["Mega|Fly|Ride"] = 3303.44}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2370, ["Fly"] = 2976.23, ["Ride"] = 2530.32, ["Fly|Ride"] = 2699.17, ["Neon"] = 14500.46, ["Neon|Ride"] = 9344.5, ["Neon|Fly|Ride"] = 7750, ["Mega|Fly|Ride"] = 27529.79}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.31, ["Fly"] = 101.18, ["Ride"] = 51.53, ["Fly|Ride"] = 110.47, ["Neon"] = 121.25, ["Neon|Ride"] = 148.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 928.1, ["Mega|Ride"] = 964.23, ["Mega|Fly|Ride"] = 1000}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 775.31, ["Fly"] = 2000, ["Ride"] = 801.3, ["Fly|Ride"] = 825.88, ["Neon|Fly|Ride"] = 4049.68}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 17.53, ["Ride"] = 41.25, ["Fly|Ride"] = 82.6, ["Neon"] = 100, ["Neon|Ride"] = 130.53, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 423.75, ["Mega|Fly"] = 934.46, ["Mega|Ride"] = 490.05, ["Mega|Fly|Ride"] = 662.5}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.27, ["Fly"] = 46.72, ["Ride"] = 28.74, ["Fly|Ride"] = 122.5, ["Neon"] = 62.5, ["Neon|Fly"] = 300, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 100, ["Mega"] = 436.87, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 378.46}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 47.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 18.38, ["Ride"] = 24.89, ["Fly|Ride"] = 97.05, ["Neon|Ride"] = 203.26, ["Neon|Fly|Ride"] = 193.06, ["Mega|Ride"] = 1032.36}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.48, ["Fly"] = 43.75, ["Ride"] = 40, ["Fly|Ride"] = 60, ["Neon"] = 375, ["Neon|Fly"] = 228.16, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 274.61, ["Mega"] = 1377.18, ["Mega|Ride"] = 1752.1, ["Mega|Fly|Ride"] = 830}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6193.1, ["Fly"] = 6193.1, ["Ride"] = 6193.1, ["Fly|Ride"] = 4873.4, ["Neon|Fly|Ride"] = 9523.75, ["Mega|Fly|Ride"] = 33750}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.27, ["Fly"] = 27.88, ["Ride"] = 31.25, ["Fly|Ride"] = 77.5, ["Neon"] = 52.49, ["Neon|Ride"] = 83.65, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 337.5, ["Mega|Ride"] = 274.99, ["Mega|Fly|Ride"] = 520}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 69.18, ["Fly"] = 365.46, ["Ride"] = 120, ["Fly|Ride"] = 187.5, ["Neon"] = 356.25, ["Neon|Ride"] = 432.95, ["Neon|Fly|Ride"] = 509.99, ["Mega"] = 2742.46, ["Mega|Ride"] = 1680.73, ["Mega|Fly|Ride"] = 2580.89}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.74, ["Fly"] = 180.01, ["Ride"] = 84.9, ["Fly|Ride"] = 150.18, ["Neon"] = 237.5, ["Neon|Ride"] = 315.91, ["Neon|Fly|Ride"] = 436.25, ["Mega"] = 2336.14, ["Mega|Ride"] = 1114.95, ["Mega|Fly|Ride"] = 996.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.42, ["Fly"] = 68.74, ["Ride"] = 29.9, ["Fly|Ride"] = 72.5, ["Neon"] = 166.25, ["Neon|Fly"] = 223, ["Neon|Ride"] = 141.25, ["Neon|Fly|Ride"] = 173.13, ["Mega"] = 967.81, ["Mega|Ride"] = 841.01, ["Mega|Fly|Ride"] = 764.99}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 8.18, ["Fly"] = 74.91, ["Ride"] = 28.75, ["Fly|Ride"] = 110, ["Neon"] = 27.39, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 156.24, ["Mega"] = 156.25, ["Mega|Ride"] = 212.25, ["Mega|Fly|Ride"] = 328.75}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.55, ["Fly"] = 138.35, ["Ride"] = 30, ["Fly|Ride"] = 93.39, ["Neon"] = 86.14, ["Neon|Ride"] = 106.25, ["Neon|Fly|Ride"] = 207.89, ["Mega"] = 490.38, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 586.25}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.22, ["Fly"] = 27.8, ["Ride"] = 26.25, ["Fly|Ride"] = 58.75, ["Neon"] = 265, ["Neon|Fly"] = 137.5, ["Neon|Ride"] = 122.5, ["Neon|Fly|Ride"] = 137.39, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 191.24}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 20.66, ["Ride"] = 133.75, ["Fly|Ride"] = 275.65, ["Neon"] = 162.5, ["Neon|Ride"] = 204.42, ["Neon|Fly|Ride"] = 358.6, ["Mega"] = 825, ["Mega|Fly|Ride"] = 646.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 148.75, ["Fly"] = 225, ["Ride"] = 150.74, ["Fly|Ride"] = 309.71, ["Neon|Fly|Ride"] = 27529.79}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 52.48, ["Fly"] = 200.28, ["Ride"] = 84.99, ["Fly|Ride"] = 154.86, ["Neon"] = 237.49, ["Neon|Ride"] = 325.96, ["Neon|Fly|Ride"] = 376.02, ["Mega"] = 1086.25, ["Mega|Ride"] = 1000, ["Mega|Fly|Ride"] = 1246.33}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1050.22, ["Fly"] = 1125, ["Ride"] = 1000, ["Fly|Ride"] = 997.5, ["Neon|Ride"] = 4205.04, ["Neon|Fly|Ride"] = 3437.5, ["Mega|Fly|Ride"] = 12500}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 325, ["Fly"] = 688.59, ["Ride"] = 397.49, ["Fly|Ride"] = 505.59, ["Neon"] = 2562.5, ["Neon|Ride"] = 1937.82, ["Neon|Fly|Ride"] = 1899.99, ["Mega"] = 12388.25, ["Mega|Fly|Ride"] = 8998.75}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 50}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.15}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.38, ["Fly"] = 29.99, ["Ride"] = 23.72, ["Fly|Ride"] = 49.06, ["Neon"] = 76, ["Neon|Fly"] = 138.75, ["Neon|Ride"] = 81.19, ["Neon|Fly|Ride"] = 136.24, ["Mega"] = 416.43, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 546.25}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 223.57, ["Fly"] = 499.99, ["Ride"] = 259.77, ["Fly|Ride"] = 377.5, ["Neon"] = 866.52, ["Neon|Ride"] = 737.5, ["Neon|Fly|Ride"] = 875, ["Mega|Fly|Ride"] = 2993.07}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.92}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 110, ["Ride"] = 161.25, ["Fly|Ride"] = 206.47, ["Neon"] = 450, ["Neon|Fly"] = 581.25, ["Neon|Ride"] = 539.69, ["Neon|Fly|Ride"] = 612.5, ["Mega"] = 2675.26, ["Mega|Ride"] = 2203.05, ["Mega|Fly|Ride"] = 2203.05}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 112.5, ["Fly"] = 206.48, ["Ride"] = 136.88, ["Fly|Ride"] = 215, ["Neon"] = 619.42, ["Neon|Ride"] = 625, ["Neon|Fly|Ride"] = 825.89, ["Mega|Fly|Ride"] = 2064.71}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.17, ["Fly"] = 76.4, ["Ride"] = 27.88, ["Fly|Ride"] = 168.28, ["Neon"] = 35, ["Neon|Ride"] = 66.08, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 206.48, ["Mega|Ride"] = 180.9, ["Mega|Fly|Ride"] = 280.34}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.27, ["Fly"] = 82.6, ["Ride"] = 30.49, ["Fly|Ride"] = 66.25, ["Neon"] = 168.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 311.88, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 587.5}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.28, ["Fly"] = 97.48, ["Ride"] = 32.5, ["Fly|Ride"] = 111.42, ["Neon"] = 74.99, ["Neon|Ride"] = 96.24, ["Neon|Fly|Ride"] = 256.25, ["Mega"] = 475, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.14, ["Fly"] = 124.98, ["Ride"] = 49.91, ["Fly|Ride"] = 145.52, ["Neon"] = 26.9, ["Neon|Ride"] = 71.55, ["Neon|Fly|Ride"] = 177.5, ["Mega"] = 172.5, ["Mega|Ride"] = 163.62, ["Mega|Fly|Ride"] = 299.95}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 275, ["Ride"] = 278.65, ["Fly|Ride"] = 324.04, ["Neon"] = 1377.18, ["Neon|Ride"] = 1340.95, ["Neon|Fly|Ride"] = 1329.25, ["Mega|Fly|Ride"] = 6297.37}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 93.75, ["Fly"] = 150, ["Ride"] = 156.53, ["Fly|Ride"] = 207.47, ["Neon"] = 400, ["Neon|Ride"] = 462.5, ["Neon|Fly|Ride"] = 488.75, ["Mega"] = 2203.05, ["Mega|Fly|Ride"] = 1787.67}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.39, ["Fly"] = 159.47, ["Ride"] = 78.75, ["Fly|Ride"] = 110.57, ["Neon"] = 300, ["Neon|Ride"] = 308.69, ["Neon|Fly|Ride"] = 396, ["Mega|Ride"] = 1713.56, ["Mega|Fly|Ride"] = 1307.5}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 20, ["Ride"] = 69.18, ["Fly|Ride"] = 275.65, ["Neon|Ride"] = 593.38, ["Neon|Fly|Ride"] = 482.12}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.86, ["Ride"] = 30, ["Fly|Ride"] = 109.44, ["Neon"] = 74.99, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 120, ["Mega"] = 412.95, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 610}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.75, ["Fly"] = 37.5, ["Ride"] = 18.59, ["Fly|Ride"] = 66.25, ["Neon"] = 23, ["Neon|Fly"] = 74.34, ["Neon|Ride"] = 55.68, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 158.75, ["Mega|Ride"] = 172.39, ["Mega|Fly|Ride"] = 264.9}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 842.5, ["Fly"] = 977.65, ["Ride"] = 850, ["Fly|Ride"] = 881.15, ["Neon"] = 2890.6, ["Neon|Fly"] = 3171.3, ["Neon|Ride"] = 8258.84, ["Neon|Fly|Ride"] = 2499.9, ["Mega|Fly|Ride"] = 6877.5}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 263.26, ["Fly"] = 716.47, ["Ride"] = 292.36, ["Fly|Ride"] = 336.55, ["Neon"] = 1225.41, ["Neon|Ride"] = 1210, ["Neon|Fly|Ride"] = 1212.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4816.98}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 87.5, ["Fly"] = 165.19, ["Ride"] = 108.87, ["Fly|Ride"] = 177.55, ["Neon"] = 402.5, ["Neon|Ride"] = 396.77, ["Neon|Fly|Ride"] = 312.5, ["Mega"] = 1250, ["Mega|Ride"] = 1666.23, ["Mega|Fly|Ride"] = 1790.12}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 187.5, ["Fly"] = 270, ["Ride"] = 180.67, ["Fly|Ride"] = 212.5, ["Neon|Ride"] = 950, ["Neon|Fly|Ride"] = 828.75, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 5634.6}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 24.07, ["Fly"] = 41.3, ["Ride"] = 28.73, ["Fly|Ride"] = 65, ["Neon"] = 161.25, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 206.48, ["Mega|Ride"] = 722.55, ["Mega|Fly|Ride"] = 910.55}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 247.77, ["Ride"] = 268.75, ["Fly|Ride"] = 343.75, ["Neon"] = 852.68, ["Neon|Ride"] = 897.5, ["Neon|Fly|Ride"] = 974.17, ["Mega"] = 4108.9, ["Mega|Fly|Ride"] = 4044.97}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 68.9, ["Fly"] = 119.99, ["Ride"] = 62.5, ["Fly|Ride"] = 123.38, ["Neon|Fly|Ride"] = 482.12, ["Mega|Ride"] = 2203.05, ["Mega|Fly|Ride"] = 1547.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2203.05, ["Ride"] = 2336.41, ["Fly|Ride"] = 2355, ["Neon|Ride"] = 8258.84, ["Neon|Fly|Ride"] = 7295.65, ["Mega"] = 49553, ["Mega|Fly|Ride"] = 26290.97}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.4, ["Fly"] = 85.69, ["Ride"] = 33.13, ["Fly|Ride"] = 100, ["Neon"] = 52.6, ["Neon|Fly"] = 118.75, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 165.08, ["Mega"] = 258.59, ["Mega|Ride"] = 479.03, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 70, ["Ride"] = 77.69, ["Fly|Ride"] = 142.5, ["Neon"] = 225, ["Neon|Ride"] = 231.25, ["Neon|Fly|Ride"] = 454.63, ["Mega|Ride"] = 887.5, ["Mega|Fly|Ride"] = 1377.18}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 87.31, ["Fly"] = 87.1, ["Ride"] = 78.5, ["Fly|Ride"] = 84.99, ["Neon"] = 500, ["Neon|Ride"] = 468.7, ["Neon|Fly|Ride"] = 391.23, ["Mega|Fly|Ride"] = 1790.32}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2098.75, ["Fly"] = 1558.21, ["Ride"] = 1018.75, ["Fly|Ride"] = 1125, ["Neon|Ride"] = 5451.35, ["Neon|Fly|Ride"] = 3749.99, ["Mega"] = 35375.68, ["Mega|Fly|Ride"] = 15000}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 405, ["Fly"] = 823.83, ["Ride"] = 722.65, ["Fly|Ride"] = 508.75, ["Mega|Fly|Ride"] = 11012.13}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 67.39, ["Fly"] = 311.88, ["Ride"] = 100, ["Fly|Ride"] = 228.16, ["Neon"] = 347.5, ["Neon|Ride"] = 326.06, ["Neon|Fly|Ride"] = 482.12, ["Mega"] = 2064.71, ["Mega|Ride"] = 1631.13, ["Mega|Fly|Ride"] = 1631.79}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Fly"] = 31.25, ["Ride"] = 23.75, ["Fly|Ride"] = 69.18, ["Neon"] = 74.91, ["Neon|Ride"] = 89.81, ["Neon|Fly|Ride"] = 187.48, ["Mega"] = 527.5, ["Mega|Ride"] = 584.04}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.49, ["Fly"] = 59.68, ["Ride"] = 42.01, ["Fly|Ride"] = 63.75, ["Neon"] = 202.5, ["Neon|Fly"] = 344.82, ["Neon|Ride"] = 268.43, ["Neon|Fly|Ride"] = 330.37, ["Mega|Ride"] = 1131.25, ["Mega|Fly|Ride"] = 964.23}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 712.5, ["Fly"] = 1074.62, ["Ride"] = 832.5, ["Fly|Ride"] = 850, ["Neon|Ride"] = 2500, ["Neon|Fly|Ride"] = 2388.98, ["Mega|Fly|Ride"] = 9260}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 575.69}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 11680.62, ["Ride"] = 5000, ["Fly|Ride"] = 4687.49, ["Neon"] = 40000, ["Neon|Ride"] = 29588.31, ["Neon|Fly|Ride"] = 18750, ["Mega|Fly|Ride"] = 103235.39}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 233.32, ["Fly"] = 387.14, ["Ride"] = 325, ["Fly|Ride"] = 406.5, ["Neon"] = 1250, ["Neon|Ride"] = 1790.12, ["Neon|Fly|Ride"] = 2064.71, ["Mega"] = 6193.1, ["Mega|Ride"] = 5919.53, ["Mega|Fly|Ride"] = 5919.53}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 93.44, ["Ride"] = 125, ["Fly|Ride"] = 275.65, ["Neon"] = 1090.18, ["Neon|Ride"] = 482.12, ["Neon|Fly|Ride"] = 462.5}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.74, ["Fly"] = 97.05, ["Ride"] = 41.16, ["Fly|Ride"] = 93.02, ["Neon"] = 178.09, ["Neon|Ride"] = 123.63, ["Neon|Fly|Ride"] = 200, ["Mega|Ride"] = 688.59, ["Mega|Fly|Ride"] = 750}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.38, ["Fly"] = 27.5, ["Ride"] = 23.63, ["Fly|Ride"] = 46.73, ["Neon"] = 139.52, ["Neon|Ride"] = 123.89, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 1250, ["Mega|Ride"] = 362.5, ["Mega|Fly|Ride"] = 4197.25}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.74, ["Ride"] = 33.75, ["Fly|Ride"] = 101.25, ["Neon"] = 112.5, ["Neon|Ride"] = 117.01, ["Neon|Fly|Ride"] = 150, ["Mega"] = 615.15, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 618.39}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.52, ["Fly"] = 27.88, ["Ride"] = 21.25, ["Fly|Ride"] = 46.25, ["Neon"] = 29.9, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 123.15, ["Mega"] = 636.42, ["Mega|Ride"] = 223.75, ["Mega|Fly|Ride"] = 207.5}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.64, ["Ride"] = 45, ["Fly|Ride"] = 124.68, ["Neon"] = 138.35, ["Neon|Fly"] = 825.89, ["Neon|Ride"] = 223, ["Neon|Fly|Ride"] = 311.88, ["Mega"] = 600, ["Mega|Ride"] = 688.59}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 506.25, ["Fly"] = 512.5, ["Ride"] = 524.9, ["Fly|Ride"] = 562.5, ["Neon|Ride"] = 2000, ["Neon|Fly|Ride"] = 1487.5, ["Mega"] = 7500, ["Mega|Fly|Ride"] = 5987.66}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.64, ["Fly"] = 18.75, ["Ride"] = 16.12, ["Fly|Ride"] = 33.04, ["Neon"] = 19.8, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 67.5, ["Mega"] = 162.5, ["Mega|Ride"] = 218.87, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 50.59, ["Fly"] = 111.15, ["Ride"] = 75, ["Fly|Ride"] = 136.25, ["Neon"] = 203.74, ["Neon|Fly"] = 340.69, ["Neon|Ride"] = 217.49, ["Neon|Fly|Ride"] = 280.33, ["Mega"] = 498.75, ["Mega|Fly"] = 825.89, ["Mega|Ride"] = 537.5, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 703.45, ["Ride"] = 739.9, ["Fly|Ride"] = 800, ["Neon|Ride"] = 2025.43, ["Neon|Fly|Ride"] = 1537.49, ["Mega|Fly|Ride"] = 4083.63}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 33.73, ["Fly"] = 67.79, ["Ride"] = 42.48, ["Fly|Ride"] = 89.89, ["Neon"] = 250, ["Neon|Fly"] = 237.5, ["Neon|Ride"] = 179.9, ["Neon|Fly|Ride"] = 225, ["Mega"] = 1500, ["Mega|Fly|Ride"] = 831.68}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 259.47, ["Fly"] = 412.95, ["Ride"] = 273.75, ["Fly|Ride"] = 324.43, ["Neon"] = 1548.54, ["Neon|Ride"] = 1341.04, ["Neon|Fly|Ride"] = 1230, ["Mega|Fly|Ride"] = 4129.42}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 232.5, ["Fly"] = 350.43, ["Ride"] = 249.99, ["Fly|Ride"] = 312.5, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 750, ["Mega"] = 4802.52, ["Mega|Fly|Ride"] = 3649.38}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 964.23, ["Ride"] = 725, ["Fly|Ride"] = 750, ["Neon|Ride"] = 3674.74, ["Neon|Fly|Ride"] = 2187.5, ["Mega|Fly|Ride"] = 10046.88}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.75, ["Fly"] = 59.89, ["Ride"] = 41.25, ["Fly|Ride"] = 102.35, ["Neon"] = 57.25, ["Neon|Fly"] = 280.34, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 175, ["Mega"] = 250, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 418.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3715.45, ["Fly"] = 3341.25, ["Ride"] = 3125, ["Fly|Ride"] = 3059.98, ["Neon|Fly|Ride"] = 7499.99, ["Mega|Fly|Ride"] = 17991.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 138.35, ["Fly"] = 156.53, ["Ride"] = 125, ["Fly|Ride"] = 198.52, ["Neon"] = 510, ["Neon|Fly"] = 564.71, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 500, ["Mega|Ride"] = 3028.93, ["Mega|Fly|Ride"] = 3062.5}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.1, ["Fly"] = 27.88, ["Ride"] = 21.17, ["Fly|Ride"] = 41.24, ["Neon"] = 18.75, ["Neon|Fly"] = 70.1, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 109.81, ["Mega"] = 220, ["Mega|Fly"] = 193.75, ["Mega|Ride"] = 236.41, ["Mega|Fly|Ride"] = 232.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.41, ["Ride"] = 26.64, ["Fly|Ride"] = 56.25, ["Neon"] = 21.25, ["Neon|Fly"] = 114.48, ["Neon|Ride"] = 61.24, ["Neon|Fly|Ride"] = 125, ["Mega"] = 150.03, ["Mega|Ride"] = 247.77, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.49, ["Fly"] = 37.58, ["Ride"] = 32.5, ["Fly|Ride"] = 46.08, ["Neon"] = 280.34, ["Neon|Ride"] = 303.71, ["Neon|Fly|Ride"] = 258.49, ["Mega|Fly|Ride"] = 1101.53}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 893.75, ["Fly"] = 1246.33, ["Ride"] = 850, ["Fly|Ride"] = 987.5, ["Neon"] = 3992.13, ["Neon|Ride"] = 4362.73, ["Neon|Fly|Ride"] = 4596.34}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7250, ["Fly|Ride"] = 7598.14}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.57, ["Fly"] = 37.5, ["Ride"] = 26.12, ["Fly|Ride"] = 50.47, ["Neon"] = 430.6, ["Neon|Ride"] = 132.5, ["Neon|Fly|Ride"] = 118.73, ["Mega"] = 2400, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 10.59, ["Fly"] = 54.91, ["Ride"] = 27.5, ["Fly|Ride"] = 67.41, ["Neon"] = 97.05, ["Neon|Fly"] = 169.32, ["Neon|Ride"] = 73.66, ["Neon|Fly|Ride"] = 143.75, ["Mega"] = 637.01, ["Mega|Ride"] = 503.74, ["Mega|Fly|Ride"] = 477.5}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 112.4, ["Fly"] = 150, ["Ride"] = 108.36, ["Fly|Ride"] = 144.31, ["Neon"] = 411.92, ["Neon|Ride"] = 431.25, ["Neon|Fly|Ride"] = 550, ["Mega|Fly|Ride"] = 1750}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 212.5, ["Fly"] = 225, ["Ride"] = 179.63, ["Fly|Ride"] = 300, ["Neon"] = 887.84, ["Neon|Ride"] = 1126.6, ["Neon|Fly|Ride"] = 812.5, ["Mega"] = 10323.54, ["Mega|Fly"] = 3895.49, ["Mega|Fly|Ride"] = 3895.49}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.14, ["Ride"] = 28.94, ["Fly|Ride"] = 55, ["Neon"] = 25.9, ["Neon|Fly"] = 625, ["Neon|Ride"] = 64.01, ["Neon|Fly|Ride"] = 99.9, ["Mega"] = 215, ["Mega|Fly"] = 230.22, ["Mega|Ride"] = 167.71, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 175.78, ["Fly"] = 220.68, ["Ride"] = 187.5, ["Fly|Ride"] = 250, ["Neon"] = 687.5, ["Neon|Ride"] = 623.75, ["Neon|Fly|Ride"] = 731.25, ["Mega|Fly|Ride"] = 2647.5}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.93, ["Fly"] = 18.64, ["Ride"] = 15.9, ["Fly|Ride"] = 37.5, ["Neon"] = 23.67, ["Neon|Fly"] = 123.89, ["Neon|Ride"] = 41.81, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 241.59, ["Mega|Ride"] = 208.75, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 250, ["Fly"] = 338.62, ["Ride"] = 262.23, ["Fly|Ride"] = 299.99, ["Neon|Ride"] = 1246.33, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4405.07}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.91, ["Fly"] = 99.98, ["Ride"] = 26.86, ["Fly|Ride"] = 65, ["Neon"] = 70, ["Neon|Fly"] = 296.69, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 150, ["Mega"] = 551.29, ["Mega|Ride"] = 589.48, ["Mega|Fly|Ride"] = 592.58}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2, ["Ride"] = 24.98, ["Fly|Ride"] = 87.94, ["Neon"] = 12.21, ["Neon|Fly"] = 162.34, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 186.25, ["Mega"] = 81.16, ["Mega|Ride"] = 129.65, ["Mega|Fly|Ride"] = 283.75}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2, ["Neon"] = 3.43, ["Mega"] = 24.25, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 130.09}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2, ["Ride"] = 33.41, ["Fly|Ride"] = 109.97, ["Neon"] = 8.04, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 124.97, ["Mega"] = 80.54, ["Mega|Fly"] = 182591.1, ["Mega|Ride"] = 83.75, ["Mega|Fly|Ride"] = 308.68}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 58.2, ["Fly"] = 149.12, ["Ride"] = 100, ["Fly|Ride"] = 172.11, ["Neon"] = 275, ["Neon|Ride"] = 281.24, ["Neon|Fly|Ride"] = 396.25, ["Mega|Fly|Ride"] = 1444.28}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2, ["Fly"] = 36.22, ["Ride"] = 15.76, ["Fly|Ride"] = 79.74, ["Neon"] = 9.35, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 49.9, ["Mega"] = 87.5, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.46, ["Ride"] = 138.35, ["Neon"] = 66.68, ["Neon|Fly"] = 303.7, ["Neon|Ride"] = 202.4, ["Neon|Fly|Ride"] = 343.75, ["Mega"] = 248.75, ["Mega|Ride"] = 534.77}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 41.3, ["Fly|Ride"] = 69.18, ["Neon"] = 3.65, ["Neon|Ride"] = 53.17, ["Neon|Fly|Ride"] = 131.12, ["Mega"] = 16.65, ["Mega|Ride"] = 67.5, ["Mega|Fly|Ride"] = 212.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2, ["Fly"] = 69.17, ["Ride"] = 15.5, ["Fly|Ride"] = 47.5, ["Neon"] = 2, ["Neon|Fly"] = 38.73, ["Neon|Ride"] = 14.65, ["Neon|Fly|Ride"] = 31.24, ["Mega"] = 13.61, ["Mega|Fly"] = 34.09, ["Mega|Ride"] = 17.5, ["Mega|Fly|Ride"] = 41.3}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 14.55, ["Fly|Ride"] = 77.18, ["Neon"] = 2.5, ["Neon|Fly"] = 20.61, ["Neon|Ride"] = 14.02, ["Neon|Fly|Ride"] = 48.53, ["Mega"] = 18.75, ["Mega|Ride"] = 30.22, ["Mega|Fly|Ride"] = 78.19}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2, ["Neon"] = 2.5, ["Mega"] = 18.74, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2, ["Fly"] = 112.29, ["Ride"] = 20, ["Fly|Ride"] = 47.5, ["Neon"] = 2.82, ["Neon|Fly"] = 117.7, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 87.49, ["Mega"] = 39.32, ["Mega|Fly"] = 87.5, ["Mega|Ride"] = 40, ["Mega|Fly|Ride"] = 98.09}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2, ["Ride"] = 27.88, ["Neon"] = 2.5, ["Neon|Ride"] = 75.83, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 18.58, ["Mega|Fly"] = 125, ["Mega|Ride"] = 78.27, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 8.39, ["Fly"] = 73.75, ["Ride"] = 53.75, ["Fly|Ride"] = 151.84, ["Neon"] = 29.08, ["Neon|Fly"] = 123.13, ["Neon|Ride"] = 45.86, ["Neon|Fly|Ride"] = 148.9, ["Mega"] = 175.81, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 268.74}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2, ["Ride"] = 49.5, ["Neon"] = 2, ["Neon|Fly"] = 25, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 311.35, ["Mega"] = 16.46, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2, ["Fly"] = 62.5, ["Ride"] = 25, ["Fly|Ride"] = 50, ["Neon"] = 18.07, ["Mega"] = 100, ["Mega|Ride"] = 261.24, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.38, ["Ride"] = 24.99, ["Neon"] = 16.25, ["Mega"] = 121.25, ["Mega|Ride"] = 152.79, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2, ["Ride"] = 31.24, ["Neon"] = 2.4, ["Neon|Ride"] = 26.63, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 18.58, ["Mega|Ride"] = 42.5, ["Mega|Fly|Ride"] = 93.34}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2, ["Fly"] = 18.67, ["Ride"] = 18.49, ["Fly|Ride"] = 36.25, ["Neon"] = 2, ["Neon|Fly"] = 28.04, ["Neon|Ride"] = 14.7, ["Neon|Fly|Ride"] = 36.25, ["Mega"] = 13.52, ["Mega|Ride"] = 19.8, ["Mega|Fly|Ride"] = 48.75}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.4, ["Fly"] = 68.75, ["Ride"] = 51.69, ["Fly|Ride"] = 112.48, ["Neon"] = 30.62, ["Neon|Ride"] = 69.18, ["Mega"] = 192.94, ["Mega|Ride"] = 230}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2, ["Ride"] = 31.24, ["Neon"] = 5.76, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 30.99, ["Neon|Fly|Ride"] = 93.75, ["Mega"] = 24.96, ["Mega|Ride"] = 57.5, ["Mega|Fly|Ride"] = 110}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.52, ["Neon"] = 12.4, ["Mega"] = 84.01, ["Mega|Ride"] = 160.03, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2, ["Fly"] = 75.17, ["Ride"] = 27.49, ["Fly|Ride"] = 43.75, ["Neon"] = 10.81, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 123.89, ["Mega|Ride"] = 155.62, ["Mega|Fly|Ride"] = 102.22}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2, ["Fly"] = 34.43, ["Ride"] = 15.5, ["Fly|Ride"] = 29.99, ["Neon"] = 2, ["Neon|Fly"] = 18.56, ["Neon|Ride"] = 13.52, ["Neon|Fly|Ride"] = 35, ["Mega"] = 12.86, ["Mega|Ride"] = 22.5, ["Mega|Fly|Ride"] = 45}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2, ["Fly"] = 27.85, ["Ride"] = 26.11, ["Fly|Ride"] = 138.35, ["Neon"] = 12.34, ["Neon|Fly"] = 125, ["Neon|Ride"] = 50, ["Neon|Fly|Ride"] = 187.2, ["Mega"] = 123.47, ["Mega|Ride"] = 153.12, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.73, ["Ride"] = 23.37, ["Fly|Ride"] = 56.25, ["Neon"] = 59.41, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 277.5, ["Mega|Ride"] = 283.34, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2, ["Fly"] = 55.76, ["Ride"] = 13.72, ["Fly|Ride"] = 38.9, ["Neon"] = 2, ["Neon|Fly"] = 18.75, ["Neon|Ride"] = 16.25, ["Neon|Fly|Ride"] = 38.75, ["Mega"] = 19.99, ["Mega|Ride"] = 27.5, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2, ["Fly"] = 172.41, ["Ride"] = 43.72, ["Neon"] = 5.85, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 135, ["Mega"] = 48.75, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 206.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2, ["Ride"] = 33.75, ["Fly|Ride"] = 124.99, ["Neon"] = 3.3, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 49.99, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 27.21, ["Mega|Fly"] = 109.13, ["Mega|Ride"] = 68.75, ["Mega|Fly|Ride"] = 186.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2, ["Fly"] = 31.55, ["Ride"] = 26.24, ["Fly|Ride"] = 82.6, ["Neon"] = 2, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 16.25, ["Mega|Ride"] = 40.06, ["Mega|Fly|Ride"] = 148.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2, ["Fly"] = 22.72, ["Ride"] = 16.25, ["Fly|Ride"] = 50, ["Neon"] = 4.7, ["Neon|Fly"] = 55.52, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 71.24, ["Mega"] = 82.6, ["Mega|Ride"] = 80, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2, ["Ride"] = 21.52, ["Neon"] = 3.43, ["Neon|Ride"] = 55, ["Mega"] = 43.75, ["Mega|Ride"] = 108.75, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2, ["Fly"] = 18.57, ["Ride"] = 15.78, ["Fly|Ride"] = 41.3, ["Neon"] = 6.25, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 79.98, ["Mega"] = 108.75, ["Mega|Fly"] = 109.14, ["Mega|Ride"] = 72.96, ["Mega|Fly|Ride"] = 145.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.23, ["Ride"] = 34.2, ["Neon"] = 27.9, ["Neon|Fly"] = 179.89, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 99.99, ["Mega|Fly"] = 350, ["Mega|Ride"] = 103.24}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2, ["Fly"] = 24.54, ["Ride"] = 17.48, ["Fly|Ride"] = 44.98, ["Neon"] = 11.1, ["Neon|Fly"] = 46.73, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 85.69, ["Mega"] = 225, ["Mega|Fly"] = 400, ["Mega|Fly|Ride"] = 180}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.47, ["Fly"] = 20.09, ["Ride"] = 19.02, ["Fly|Ride"] = 61.66, ["Neon"] = 9.8, ["Neon|Fly"] = 35.11, ["Neon|Ride"] = 27.6, ["Neon|Fly|Ride"] = 71.14, ["Mega"] = 183.77, ["Mega|Ride"] = 124.99, ["Mega|Fly|Ride"] = 185}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2, ["Fly"] = 109.37, ["Ride"] = 69.19, ["Neon"] = 10.33, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 2500, ["Mega"] = 245.02, ["Mega|Ride"] = 307.65}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 4.69, ["Ride"] = 125, ["Neon"] = 125, ["Neon|Ride"] = 162.5, ["Mega"] = 643.17, ["Mega|Ride"] = 693.75, ["Mega|Fly|Ride"] = 934.46}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.84, ["Ride"] = 38.74, ["Neon"] = 41.21, ["Neon|Ride"] = 103.16, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 227.5, ["Mega|Ride"] = 350}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.72, ["Ride"] = 42.43, ["Fly|Ride"] = 123.89, ["Neon"] = 27.88, ["Neon|Ride"] = 61.83, ["Neon|Fly|Ride"] = 121.21, ["Mega"] = 214.91, ["Mega|Ride"] = 344.82, ["Mega|Fly|Ride"] = 425.62}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2, ["Neon"] = 3.68, ["Neon|Ride"] = 50, ["Mega"] = 16.63, ["Mega|Fly"] = 118.73, ["Mega|Ride"] = 60, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.78}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 5.99, ["Fly"] = 20, ["Ride"] = 21.24, ["Fly|Ride"] = 45.42, ["Neon"] = 33.95, ["Neon|Fly"] = 180, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 106.24, ["Mega|Ride"] = 198.74, ["Mega|Fly|Ride"] = 381.98}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2, ["Fly"] = 67.5, ["Ride"] = 18.4, ["Fly|Ride"] = 37.5, ["Neon"] = 3.75, ["Neon|Fly"] = 50.28, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 23.74, ["Mega|Ride"] = 65, ["Mega|Fly|Ride"] = 118.73}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2, ["Ride"] = 24.92, ["Neon"] = 5, ["Neon|Ride"] = 27.86, ["Neon|Fly|Ride"] = 68.74, ["Mega"] = 28.9, ["Mega|Ride"] = 61.96, ["Mega|Fly|Ride"] = 122.86}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2, ["Fly"] = 42.58, ["Ride"] = 15.5, ["Fly|Ride"] = 42.66, ["Neon"] = 9.9, ["Neon|Ride"] = 48.02, ["Neon|Fly|Ride"] = 60.46, ["Mega"] = 103.24, ["Mega|Ride"] = 112.5, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.81, ["Fly"] = 41.3, ["Ride"] = 20.66, ["Fly|Ride"] = 68.75, ["Neon"] = 35.16, ["Neon|Ride"] = 198.21, ["Neon|Fly|Ride"] = 150, ["Mega"] = 138.35, ["Mega|Ride"] = 329, ["Mega|Fly|Ride"] = 308.69}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2, ["Ride"] = 32.49, ["Neon"] = 3.1, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 300, ["Mega"] = 18.23, ["Mega|Ride"] = 51.14, ["Mega|Fly|Ride"] = 118.73}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 21.14, ["Fly|Ride"] = 56.14, ["Neon"] = 3.3, ["Neon|Fly"] = 109.81, ["Neon|Ride"] = 24.79, ["Neon|Fly|Ride"] = 86.25, ["Mega"] = 29.6, ["Mega|Ride"] = 48.74, ["Mega|Fly|Ride"] = 118.73}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 17.42, ["Fly|Ride"] = 34.22, ["Neon"] = 4.03, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 18.28, ["Neon|Fly|Ride"] = 58.3, ["Mega"] = 78.47, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 110.46, ["Mega|Fly|Ride"] = 110.47}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.27, ["Fly"] = 87.5, ["Ride"] = 51.25, ["Fly|Ride"] = 137.5, ["Neon"] = 8.22, ["Neon|Ride"] = 61.24, ["Neon|Fly|Ride"] = 88.75, ["Mega"] = 76.24, ["Mega|Ride"] = 103.24, ["Mega|Fly|Ride"] = 273.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2, ["Ride"] = 25, ["Neon"] = 3.03, ["Neon|Ride"] = 36.27, ["Neon|Fly|Ride"] = 150445.21, ["Mega"] = 17.57, ["Mega|Fly"] = 107.15, ["Mega|Ride"] = 82.5, ["Mega|Fly|Ride"] = 124.89}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2, ["Fly"] = 43.72, ["Ride"] = 18.44, ["Fly|Ride"] = 41.3, ["Neon"] = 3.57, ["Neon|Fly"] = 26.88, ["Neon|Ride"] = 23.03, ["Neon|Fly|Ride"] = 86.3, ["Mega"] = 17.3, ["Mega|Ride"] = 35, ["Mega|Fly|Ride"] = 74.98}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2, ["Neon"] = 2.4, ["Mega"] = 22.72, ["Mega|Ride"] = 137.5}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2, ["Neon"] = 3.44, ["Neon|Fly|Ride"] = 400, ["Mega"] = 21.24, ["Mega|Ride"] = 189.96, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 15.34, ["Fly|Ride"] = 65, ["Neon"] = 3.42, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 16.39, ["Neon|Fly|Ride"] = 43.75, ["Mega"] = 36.24, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 98.09}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 18.75, ["Fly"] = 35.62, ["Ride"] = 75, ["Fly|Ride"] = 206.48, ["Neon"] = 68.75, ["Mega"] = 371.24, ["Mega|Ride"] = 523.42}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2, ["Fly"] = 6250, ["Ride"] = 25, ["Neon"] = 23.52, ["Neon|Ride"] = 150, ["Mega"] = 233.63, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.28, ["Ride"] = 31.54, ["Fly|Ride"] = 169.32, ["Neon"] = 22.78, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 309.71, ["Mega|Ride"] = 283.91, ["Mega|Fly|Ride"] = 364.9}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2, ["Fly"] = 13.38, ["Ride"] = 11.13, ["Fly|Ride"] = 29.5, ["Neon"] = 2, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 14.13, ["Neon|Fly|Ride"] = 29.69, ["Mega"] = 19.61, ["Mega|Ride"] = 22.47, ["Mega|Fly|Ride"] = 61.73}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2, ["Fly"] = 112.49, ["Ride"] = 57.5, ["Neon"] = 7.92, ["Neon|Fly"] = 65.32, ["Neon|Ride"] = 30.99, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 82.59, ["Mega|Ride"] = 102.22}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 25, ["Neon"] = 2, ["Neon|Fly"] = 30.81, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 82.54, ["Mega"] = 13.75, ["Mega|Fly"] = 123.89, ["Mega|Fly|Ride"] = 165.19}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2, ["Neon"] = 3.5, ["Neon|Fly"] = 58, ["Neon|Ride"] = 121.25, ["Mega"] = 18.49, ["Mega|Fly|Ride"] = 349.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2, ["Fly"] = 137.67, ["Ride"] = 17.98, ["Fly|Ride"] = 38.74, ["Neon"] = 8.44, ["Neon|Fly"] = 62.9, ["Neon|Ride"] = 52.66, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 165, ["Mega|Ride"] = 152.5, ["Mega|Fly|Ride"] = 233.75}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 169.86, ["Ride"] = 224.99, ["Fly|Ride"] = 801.11, ["Mega"] = 8258.84, ["Mega|Fly|Ride"] = 3152.82}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2, ["Ride"] = 26.86, ["Neon"] = 7.58, ["Neon|Ride"] = 61.24, ["Mega"] = 62.5, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.5, ["Fly"] = 98.74, ["Ride"] = 23.51, ["Fly|Ride"] = 62.5, ["Neon"] = 31.55, ["Neon|Ride"] = 165.18, ["Neon|Fly|Ride"] = 165.19, ["Mega"] = 367.49, ["Mega|Ride"] = 218.44, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 15.5, ["Fly|Ride"] = 31.14, ["Neon"] = 6.25, ["Neon|Fly"] = 32.01, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 49, ["Mega"] = 47.3, ["Mega|Ride"] = 80, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 18.75, ["Fly|Ride"] = 121.15, ["Neon"] = 10.33, ["Neon|Ride"] = 76.25, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 73.66, ["Mega|Fly|Ride"] = 399.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.63, ["Fly"] = 26.62, ["Ride"] = 16.15, ["Fly|Ride"] = 36.1, ["Neon"] = 30, ["Neon|Fly"] = 96.42, ["Neon|Ride"] = 41.24, ["Neon|Fly|Ride"] = 75, ["Mega"] = 138.35, ["Mega|Ride"] = 825.89, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.16, ["Ride"] = 33.04, ["Fly|Ride"] = 78.27, ["Neon"] = 46.73, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 245, ["Mega|Ride"] = 258.1, ["Mega|Fly|Ride"] = 368.74}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.29, ["Fly"] = 21.24, ["Ride"] = 18.36, ["Fly|Ride"] = 35, ["Neon"] = 33.75, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 31.24, ["Neon|Fly|Ride"] = 91.15, ["Mega"] = 250, ["Mega|Fly"] = 205.45, ["Mega|Ride"] = 358.24, ["Mega|Fly|Ride"] = 259.65}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 67.91, ["Fly"] = 93.96, ["Ride"] = 86.24, ["Fly|Ride"] = 137.5, ["Neon"] = 325, ["Neon|Fly"] = 428.75, ["Neon|Ride"] = 398.75, ["Neon|Fly|Ride"] = 406.25, ["Mega|Fly|Ride"] = 1248.75}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 212.5, ["Fly"] = 412.95, ["Ride"] = 200, ["Fly|Ride"] = 312.5, ["Neon|Ride"] = 1075, ["Neon|Fly|Ride"] = 1062.5, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 4818.01}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.91, ["Fly"] = 103.24, ["Ride"] = 78.27, ["Fly|Ride"] = 108.75, ["Neon"] = 467.24, ["Neon|Fly"] = 349.97, ["Neon|Ride"] = 279.32, ["Neon|Fly|Ride"] = 331.25, ["Mega|Fly|Ride"] = 1340.9}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.78, ["Fly"] = 274.57, ["Ride"] = 26.66, ["Neon"] = 48.04, ["Neon|Fly"] = 96.38, ["Neon|Ride"] = 94.58, ["Mega"] = 232.29, ["Mega|Ride"] = 181.25, ["Mega|Fly|Ride"] = 398.75}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.89, ["Fly"] = 69.18, ["Ride"] = 27.5, ["Fly|Ride"] = 62.41, ["Neon"] = 58.75, ["Neon|Ride"] = 74.34, ["Neon|Fly|Ride"] = 198.75, ["Mega"] = 287.4, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 441.06}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2, ["Fly"] = 32.41, ["Ride"] = 15, ["Fly|Ride"] = 37.62, ["Neon"] = 2.88, ["Neon|Ride"] = 19.19, ["Neon|Fly|Ride"] = 72.27, ["Mega"] = 116.82, ["Mega|Fly"] = 142.51, ["Mega|Ride"] = 206.48, ["Mega|Fly|Ride"] = 446.66}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.05, ["Fly"] = 66.08, ["Ride"] = 35, ["Fly|Ride"] = 63.09, ["Neon"] = 91.25, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 108.75, ["Neon|Fly|Ride"] = 247.77, ["Mega"] = 495.54, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 613.23}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2, ["Fly"] = 39.91, ["Ride"] = 14.99, ["Fly|Ride"] = 43.21, ["Neon"] = 14.78, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 19.53, ["Neon|Fly|Ride"] = 54.91, ["Mega"] = 125, ["Mega|Ride"] = 259.13, ["Mega|Fly|Ride"] = 272.5}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.5, ["Ride"] = 30.99, ["Fly|Ride"] = 303.12, ["Neon"] = 42.5, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 195.08, ["Mega"] = 197.5, ["Mega|Ride"] = 325, ["Mega|Fly|Ride"] = 295.76}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 26.36, ["Ride"] = 18.44, ["Neon"] = 2, ["Neon|Ride"] = 18.57, ["Neon|Fly|Ride"] = 54.99, ["Mega"] = 14.99, ["Mega|Ride"] = 41.3, ["Mega|Fly|Ride"] = 71.25}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.04, ["Fly"] = 16.25, ["Ride"] = 17.62, ["Fly|Ride"] = 41.3, ["Neon"] = 24.24, ["Neon|Fly"] = 103.24, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 140, ["Mega"] = 74.97, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2, ["Fly"] = 52.5, ["Ride"] = 18.17, ["Fly|Ride"] = 67.72, ["Neon"] = 17.59, ["Neon|Ride"] = 45, ["Mega"] = 125, ["Mega|Ride"] = 253.75, ["Mega|Fly|Ride"] = 253.97}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105.5, ["Fly"] = 156.29, ["Ride"] = 152.38, ["Fly|Ride"] = 204.9, ["Neon"] = 466.25, ["Neon|Ride"] = 441.01, ["Neon|Fly|Ride"] = 428.68, ["Mega"] = 3737.8, ["Mega|Fly|Ride"] = 2906.09}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.21, ["Ride"] = 123.89, ["Fly|Ride"] = 125, ["Neon"] = 40.89, ["Neon|Ride"] = 93.73, ["Neon|Fly|Ride"] = 206.25, ["Mega"] = 265.16, ["Mega|Ride"] = 237.5, ["Mega|Fly|Ride"] = 358.87}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2, ["Fly"] = 41.16, ["Ride"] = 18.56, ["Fly|Ride"] = 39.73, ["Neon"] = 19.4, ["Neon|Ride"] = 57.5, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 235, ["Mega|Ride"] = 176.94, ["Mega|Fly|Ride"] = 259.13}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 20.9, ["Ride"] = 37.17, ["Fly|Ride"] = 149.91, ["Neon"] = 87.5, ["Neon|Ride"] = 153.65, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 411.92, ["Mega|Ride"] = 647.29, ["Mega|Fly|Ride"] = 788.46}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.62}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.37, ["Ride"] = 43.75, ["Fly|Ride"] = 122.86, ["Neon"] = 31.25, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 250, ["Mega"] = 420.51, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 857.36}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.55, ["Fly"] = 35, ["Ride"] = 25.95, ["Fly|Ride"] = 68.75, ["Neon"] = 388.18, ["Neon|Fly"] = 96969.69, ["Neon|Ride"] = 154.9, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 1332.77, ["Mega|Fly|Ride"] = 533.79}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2, ["Ride"] = 27.88, ["Fly|Ride"] = 49.88, ["Neon"] = 2.5, ["Neon|Ride"] = 31.52, ["Neon|Fly|Ride"] = 131.12, ["Mega"] = 47.5, ["Mega|Fly"] = 180, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 221.05}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.33, ["Fly"] = 32, ["Ride"] = 20.14, ["Fly|Ride"] = 62.41, ["Neon"] = 55.76, ["Mega"] = 274.6, ["Mega|Fly"] = 390.14, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 548.19}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.4, ["Fly"] = 27.58, ["Ride"] = 20.66, ["Fly|Ride"] = 46.24, ["Neon"] = 10.91, ["Neon|Fly"] = 178, ["Neon|Ride"] = 35.89, ["Neon|Fly|Ride"] = 70.8, ["Mega"] = 175, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 145.17}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2, ["Ride"] = 37.48, ["Neon"] = 4.32, ["Neon|Ride"] = 39.73, ["Mega"] = 30, ["Mega|Ride"] = 66.77, ["Mega|Fly|Ride"] = 175}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.82, ["Ride"] = 82.14, ["Fly|Ride"] = 130, ["Neon"] = 154.99, ["Neon|Ride"] = 193.75, ["Neon|Fly|Ride"] = 547.49, ["Mega"] = 798.75, ["Mega|Ride"] = 656.24, ["Mega|Fly|Ride"] = 934.46}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.64, ["Fly"] = 27.88, ["Ride"] = 61.96, ["Fly|Ride"] = 200, ["Neon"] = 93.45, ["Mega|Ride"] = 309.71, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 8.25, ["Fly"] = 21.25, ["Ride"] = 20.23, ["Fly|Ride"] = 60.62, ["Neon"] = 32.48, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 104.29, ["Mega"] = 147.49, ["Mega|Ride"] = 118.73, ["Mega|Fly|Ride"] = 489.34}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 87.5, ["Fly"] = 412.49, ["Ride"] = 41.3, ["Neon"] = 17444, ["Neon|Ride"] = 625, ["Mega"] = 4362.73, ["Mega|Fly|Ride"] = 2750}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.58, ["Fly"] = 43.57, ["Ride"] = 22.72, ["Fly|Ride"] = 67.76, ["Neon"] = 33.74, ["Neon|Ride"] = 46.25, ["Neon|Fly|Ride"] = 113.75, ["Mega"] = 242.5, ["Mega|Ride"] = 266.15, ["Mega|Fly|Ride"] = 380}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 62.41, ["Fly"] = 124.99, ["Ride"] = 110.25, ["Fly|Ride"] = 196.25, ["Neon"] = 219.95, ["Neon|Ride"] = 212.5, ["Neon|Fly|Ride"] = 339.8, ["Mega"] = 998.75, ["Mega|Ride"] = 1031.34, ["Mega|Fly|Ride"] = 1026.25}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.37, ["Fly"] = 57.5, ["Ride"] = 52.66, ["Fly|Ride"] = 153.75, ["Neon"] = 90.85, ["Neon|Ride"] = 95, ["Neon|Fly|Ride"] = 200, ["Mega"] = 337.5, ["Mega|Ride"] = 360.1, ["Mega|Fly|Ride"] = 412.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.33, ["Fly"] = 51.41, ["Ride"] = 24.79, ["Fly|Ride"] = 68.97, ["Neon"] = 81.25, ["Neon|Fly|Ride"] = 371.45, ["Mega"] = 545.5, ["Mega|Ride"] = 549.22, ["Mega|Fly|Ride"] = 578.13}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.53, ["Fly"] = 95.79, ["Ride"] = 62.5, ["Fly|Ride"] = 98.01, ["Neon"] = 53.57, ["Neon|Ride"] = 107.9, ["Neon|Fly|Ride"] = 234.34, ["Mega"] = 323.9, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.03, ["Ride"] = 37.49, ["Neon"] = 39.63, ["Neon|Ride"] = 54.99, ["Neon|Fly|Ride"] = 132.15, ["Mega"] = 263.65, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 404.97}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2, ["Ride"] = 69.18, ["Neon"] = 2.25, ["Neon|Fly"] = 93.02, ["Neon|Ride"] = 124.99, ["Neon|Fly|Ride"] = 200, ["Mega"] = 18.74, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.28, ["Ride"] = 120.05, ["Neon"] = 33.51, ["Neon|Ride"] = 188.93, ["Neon|Fly|Ride"] = 191.94, ["Mega"] = 227.5, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 515.16}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2, ["Fly"] = 122.86, ["Ride"] = 27.88, ["Neon"] = 27.5, ["Neon|Fly"] = 111.37, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 196.16, ["Mega"] = 200.63, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 1125}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.48, ["Ride"] = 31.23, ["Fly|Ride"] = 116.82, ["Neon"] = 18.46, ["Neon|Ride"] = 81.25, ["Neon|Fly|Ride"] = 250, ["Mega"] = 121.82, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 494.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 460.74, ["Fly"] = 618.39, ["Ride"] = 550, ["Fly|Ride"] = 573.75, ["Neon"] = 1755.01, ["Neon|Fly"] = 1757.08, ["Neon|Ride"] = 1651.77, ["Neon|Fly|Ride"] = 1625, ["Mega|Fly|Ride"] = 4843.75}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6, ["Fly"] = 43.3, ["Ride"] = 20.02, ["Fly|Ride"] = 55.89, ["Neon"] = 40.28, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 304.69, ["Mega"] = 206.48, ["Mega|Ride"] = 358.61, ["Mega|Fly|Ride"] = 344.82}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.93, ["Fly"] = 63.75, ["Ride"] = 19.94, ["Fly|Ride"] = 52.05, ["Neon"] = 90.7, ["Neon|Fly"] = 300, ["Neon|Ride"] = 92.5, ["Neon|Fly|Ride"] = 175, ["Mega"] = 316.06, ["Mega|Ride"] = 307.65, ["Mega|Fly|Ride"] = 649}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.49, ["Fly"] = 23.74, ["Ride"] = 16.24, ["Fly|Ride"] = 48.37, ["Neon"] = 12.49, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 125}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2, ["Fly"] = 41.13, ["Ride"] = 31.24, ["Fly|Ride"] = 86.25, ["Neon"] = 10.91, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 65, ["Mega|Ride"] = 99.99, ["Mega|Fly|Ride"] = 260}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2, ["Ride"] = 18.75, ["Neon"] = 3.55, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 27.88, ["Mega|Fly"] = 193.06, ["Mega|Ride"] = 151.77, ["Mega|Fly|Ride"] = 220.93}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1125}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 20.63, ["Ride"] = 42.41, ["Fly|Ride"] = 173.75, ["Neon"] = 100, ["Neon|Ride"] = 107.49, ["Mega"] = 390.14, ["Mega|Ride"] = 358.24, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2, ["Ride"] = 18.34, ["Neon"] = 5.44, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 959.57, ["Mega"] = 37.5, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 173.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.04, ["Fly"] = 309.69, ["Ride"] = 54.91, ["Neon"] = 18.75, ["Neon|Ride"] = 162.4, ["Neon|Fly|Ride"] = 225, ["Mega"] = 248.92, ["Mega|Ride"] = 344.82, ["Mega|Fly|Ride"] = 383.01}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 376.45, ["Ride"] = 424.99, ["Fly|Ride"] = 489.98, ["Neon"] = 1341.04, ["Neon|Ride"] = 1628.29, ["Neon|Fly|Ride"] = 1300, ["Mega"] = 7742.67, ["Mega|Fly|Ride"] = 5871.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.91, ["Fly"] = 187.5, ["Ride"] = 30, ["Fly|Ride"] = 123.89, ["Neon"] = 55.75, ["Neon|Ride"] = 73.75, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 291.96, ["Mega|Ride"] = 473.86, ["Mega|Fly|Ride"] = 493.48}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2, ["Fly"] = 91.12, ["Ride"] = 31.23, ["Fly|Ride"] = 112.48, ["Neon"] = 5.92, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 40.89, ["Neon|Fly|Ride"] = 92.5, ["Mega"] = 36.63, ["Mega|Fly"] = 138.28, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2, ["Ride"] = 50, ["Neon"] = 4.14, ["Neon|Ride"] = 137.57, ["Neon|Fly|Ride"] = 137.99, ["Mega"] = 24.92, ["Mega|Ride"] = 174.99, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 24.29, ["Fly"] = 102.77, ["Ride"] = 74.91, ["Fly|Ride"] = 309.71, ["Neon"] = 137.5, ["Neon|Ride"] = 218.75, ["Neon|Fly|Ride"] = 416.25, ["Mega"] = 667.95, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 550}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.18, ["Ride"] = 69.18, ["Neon"] = 90.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 825.89, ["Mega"] = 545.5, ["Mega|Ride"] = 456.88, ["Mega|Fly|Ride"] = 812.5}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.55, ["Ride"] = 72.49, ["Neon"] = 125, ["Neon|Ride"] = 191.25, ["Mega"] = 631.81, ["Mega|Ride"] = 619.42, ["Mega|Fly|Ride"] = 779.11}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 15, ["Ride"] = 25.71, ["Fly|Ride"] = 218.25, ["Neon"] = 159.4, ["Neon|Ride"] = 169.05, ["Neon|Fly|Ride"] = 230, ["Mega"] = 612.5, ["Mega|Ride"] = 511.03, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 349.98, ["Ride"] = 406.97, ["Fly|Ride"] = 685.5, ["Neon"] = 1018.75, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 1125, ["Mega|Fly|Ride"] = 3187.49}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.82, ["Fly"] = 41.3, ["Ride"] = 32.5, ["Fly|Ride"] = 110.39, ["Neon"] = 97.05, ["Neon|Ride"] = 185.83, ["Mega|Ride"] = 537.5, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.08, ["Ride"] = 33.04, ["Fly|Ride"] = 121.25, ["Neon"] = 50, ["Neon|Ride"] = 211.25, ["Mega"] = 162.5, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 599.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 31.89, ["Fly"] = 330.37, ["Ride"] = 111.5, ["Neon"] = 142.49, ["Neon|Ride"] = 187.27, ["Neon|Fly|Ride"] = 467.14, ["Mega"] = 394.9, ["Mega|Ride"] = 408.75, ["Mega|Fly|Ride"] = 487.48}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.4, ["Ride"] = 92.92, ["Fly|Ride"] = 73.59, ["Neon"] = 7.45, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 267.39, ["Mega"] = 62.5, ["Mega|Ride"] = 162.5, ["Mega|Fly|Ride"] = 283.75}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 54.81, ["Ride"] = 79.11, ["Neon"] = 250, ["Neon|Ride"] = 342.5, ["Neon|Fly|Ride"] = 375, ["Mega"] = 1576.9, ["Mega|Ride"] = 2733.68, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.23, ["Fly"] = 53.75, ["Ride"] = 24.92, ["Fly|Ride"] = 312.5, ["Neon"] = 11.4, ["Neon|Fly"] = 179.63, ["Neon|Ride"] = 54.64, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 56.91, ["Mega|Ride"] = 86.39, ["Mega|Fly|Ride"] = 215}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 27.5, ["Fly|Ride"] = 95.79, ["Neon"] = 4.14, ["Neon|Fly"] = 60.52, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 100, ["Mega"] = 36.05, ["Mega|Fly"] = 97.01, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2, ["Ride"] = 36.16, ["Fly|Ride"] = 124.82, ["Neon"] = 11.23, ["Neon|Ride"] = 51.38, ["Neon|Fly|Ride"] = 168.75, ["Mega"] = 79.06, ["Mega|Ride"] = 134.22, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.2, ["Fly"] = 62.49, ["Ride"] = 58.64, ["Fly|Ride"] = 235.39, ["Neon"] = 234.23, ["Neon|Ride"] = 344.38, ["Neon|Fly|Ride"] = 467.24, ["Mega|Ride"] = 1101.53, ["Mega|Fly|Ride"] = 1062.5}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2064.71}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.89, ["Neon"] = 21.25, ["Neon|Fly"] = 333.75, ["Mega"] = 122.24, ["Mega|Ride"] = 249.99, ["Mega|Fly|Ride"] = 277.5}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2, ["Ride"] = 32.01, ["Neon"] = 8.26, ["Neon|Ride"] = 68.75, ["Neon|Fly|Ride"] = 165.19, ["Mega"] = 45, ["Mega|Fly"] = 200, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 229.9}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.29, ["Fly"] = 103.24, ["Ride"] = 31.25, ["Fly|Ride"] = 93.75, ["Neon"] = 31.25, ["Mega"] = 296.29, ["Mega|Ride"] = 334.81, ["Mega|Fly|Ride"] = 380}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.75, ["Ride"] = 38.75, ["Fly|Ride"] = 125, ["Neon"] = 23.03, ["Neon|Ride"] = 62.49, ["Neon|Fly|Ride"] = 136.15, ["Mega"] = 165.07, ["Mega|Ride"] = 178.66, ["Mega|Fly|Ride"] = 324.15}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2, ["Ride"] = 68.19, ["Neon"] = 8.27, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 137.5, ["Mega"] = 68.75, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 100, ["Mega|Fly|Ride"] = 391.27}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2, ["Fly"] = 50, ["Ride"] = 21.25, ["Fly|Ride"] = 50, ["Neon"] = 4.95, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 100.14, ["Mega"] = 39.99, ["Mega|Ride"] = 94.93, ["Mega|Fly|Ride"] = 287.5}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2, ["Fly"] = 26.2, ["Ride"] = 19.13, ["Fly|Ride"] = 54.99, ["Neon"] = 17, ["Neon|Fly"] = 98.09, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 148.71, ["Mega|Ride"] = 135, ["Mega|Fly|Ride"] = 205.45}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 43.75, ["Ride"] = 37.27, ["Fly|Ride"] = 75, ["Neon"] = 125, ["Neon|Ride"] = 156.25, ["Mega"] = 623.75, ["Mega|Ride"] = 500, ["Mega|Fly|Ride"] = 620}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 67.68, ["Ride"] = 96.18, ["Fly|Ride"] = 125, ["Neon"] = 356.15, ["Neon|Fly"] = 410.13, ["Neon|Ride"] = 467.24, ["Neon|Fly|Ride"] = 443.75, ["Mega"] = 2051.29, ["Mega|Ride"] = 3100, ["Mega|Fly|Ride"] = 1412.21}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2, ["Ride"] = 18.48, ["Fly|Ride"] = 125, ["Neon"] = 3.62, ["Neon|Fly"] = 75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 31.26, ["Mega|Ride"] = 88.01, ["Mega|Fly|Ride"] = 239.52}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2, ["Fly"] = 16.28, ["Ride"] = 14.86, ["Fly|Ride"] = 41.18, ["Neon"] = 3.59, ["Neon|Fly"] = 35.1, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 58.75, ["Mega"] = 62.49, ["Mega|Ride"] = 47.49, ["Mega|Fly|Ride"] = 87.49}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.13, ["Fly"] = 47.5, ["Ride"] = 36.2, ["Fly|Ride"] = 62.49, ["Neon"] = 38.73, ["Neon|Ride"] = 156.25, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 523.42, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 450, ["Ride"] = 472.84, ["Fly|Ride"] = 425, ["Neon"] = 4129.42, ["Neon|Fly|Ride"] = 1687.5, ["Mega|Fly|Ride"] = 5625}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.18, ["Fly"] = 96.5, ["Ride"] = 41.3, ["Fly|Ride"] = 123.75, ["Neon"] = 204.77, ["Neon|Ride"] = 215, ["Neon|Fly|Ride"] = 246.25, ["Mega|Ride"] = 757.76, ["Mega|Fly|Ride"] = 824.87}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2, ["Ride"] = 24.53, ["Fly|Ride"] = 274.61, ["Neon"] = 9.33, ["Neon|Ride"] = 45.49, ["Neon|Fly|Ride"] = 125, ["Mega"] = 275.65, ["Mega|Ride"] = 122.5, ["Mega|Fly|Ride"] = 273.24}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2, ["Fly"] = 78.24, ["Ride"] = 54.08, ["Fly|Ride"] = 249.49, ["Neon"] = 69.19, ["Mega"] = 118.75, ["Mega|Fly|Ride"] = 308.69}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30, ["Fly"] = 69.18, ["Ride"] = 36.25, ["Fly|Ride"] = 138.35, ["Neon"] = 185, ["Neon|Ride"] = 201.32, ["Neon|Fly|Ride"] = 205.45, ["Mega"] = 2477.66, ["Mega|Ride"] = 2000, ["Mega|Fly|Ride"] = 955}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 87.4, ["Fly"] = 174.24, ["Ride"] = 122.49, ["Fly|Ride"] = 175.81, ["Neon"] = 409.61, ["Neon|Fly"] = 784.6, ["Neon|Ride"] = 489.34, ["Neon|Fly|Ride"] = 581.25, ["Mega"] = 3028.93, ["Mega|Fly|Ride"] = 2580.89}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 217.5, ["Ride"] = 275, ["Fly|Ride"] = 515, ["Neon"] = 893.75, ["Neon|Ride"] = 762.5, ["Neon|Fly|Ride"] = 986.25, ["Mega|Fly|Ride"] = 3437.75}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.72, ["Ride"] = 52.41, ["Fly|Ride"] = 140.18, ["Neon"] = 93.75, ["Neon|Ride"] = 83.73, ["Neon|Fly|Ride"] = 250, ["Mega"] = 688.59, ["Mega|Ride"] = 375.41, ["Mega|Fly|Ride"] = 433.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2, ["Fly"] = 27.58, ["Ride"] = 15.63, ["Fly|Ride"] = 33.66, ["Neon"] = 8.21, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 80, ["Mega"] = 88.75, ["Mega|Ride"] = 99.99, ["Mega|Fly|Ride"] = 150.74}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.06, ["Fly"] = 38.75, ["Ride"] = 20.81, ["Fly|Ride"] = 78.82, ["Neon"] = 26.25, ["Neon|Fly"] = 112.5, ["Neon|Ride"] = 41.29, ["Neon|Fly|Ride"] = 118.16, ["Mega"] = 274.95, ["Mega|Ride"] = 233.32, ["Mega|Fly|Ride"] = 325}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 302.49, ["Ride"] = 333.75, ["Fly|Ride"] = 637.5, ["Neon"] = 1488.13, ["Neon|Ride"] = 1514.47, ["Neon|Fly|Ride"] = 1576.41, ["Mega"] = 10323.54, ["Mega|Fly|Ride"] = 5625}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2, ["Ride"] = 31.87, ["Neon"] = 3.99, ["Neon|Ride"] = 132.77, ["Neon|Fly|Ride"] = 112500, ["Mega"] = 24.97, ["Mega|Ride"] = 87.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.54, ["Ride"] = 17.19, ["Fly|Ride"] = 57.82, ["Neon"] = 34.91, ["Neon|Fly"] = 63.08, ["Neon|Ride"] = 40, ["Neon|Fly|Ride"] = 93.36, ["Mega"] = 118.73, ["Mega|Ride"] = 140, ["Mega|Fly|Ride"] = 217.5}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.89, ["Fly"] = 6250, ["Ride"] = 69.18, ["Fly|Ride"] = 131.12, ["Neon"] = 100, ["Neon|Ride"] = 103.26, ["Neon|Fly|Ride"] = 303.12, ["Mega"] = 525, ["Mega|Ride"] = 618.75, ["Mega|Fly|Ride"] = 679.3}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 99.81, ["Fly"] = 150, ["Ride"] = 118.75, ["Fly|Ride"] = 138.35, ["Neon|Ride"] = 779.11, ["Neon|Fly|Ride"] = 625, ["Mega|Fly|Ride"] = 2500}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.13, ["Fly"] = 32.98, ["Ride"] = 28.43, ["Fly|Ride"] = 56.25, ["Neon"] = 100, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 125, ["Mega"] = 833.75, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2, ["Ride"] = 31.25, ["Neon"] = 3.74, ["Neon|Ride"] = 77.43, ["Mega"] = 32.01, ["Mega|Ride"] = 116.65, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2, ["Ride"] = 16.24, ["Fly|Ride"] = 82.6, ["Neon"] = 3.03, ["Neon|Fly"] = 36.25, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 82.79, ["Mega"] = 34.91, ["Mega|Ride"] = 46.24, ["Mega|Fly|Ride"] = 110}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.4, ["Ride"] = 74.97, ["Fly|Ride"] = 296.29, ["Neon"] = 39.91, ["Neon|Ride"] = 100.69, ["Neon|Fly|Ride"] = 332.5, ["Mega"] = 185.86, ["Mega|Ride"] = 202.26, ["Mega|Fly|Ride"] = 325.19}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1106.25, ["Ride"] = 1250, ["Fly|Ride"] = 1300, ["Neon"] = 4238.86, ["Neon|Ride"] = 4062.32, ["Neon|Fly|Ride"] = 3825.94, ["Mega|Fly|Ride"] = 12000}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 387.4, ["Ride"] = 463.45, ["Fly|Ride"] = 550, ["Neon"] = 1600, ["Neon|Ride"] = 1948.33, ["Neon|Fly|Ride"] = 1498.75, ["Mega"] = 16517.67}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 290, ["Fly"] = 411.92, ["Ride"] = 337.5, ["Fly|Ride"] = 413.75, ["Neon"] = 721.63, ["Neon|Fly"] = 1090.98, ["Neon|Ride"] = 674.9, ["Neon|Fly|Ride"] = 748.75, ["Mega|Fly|Ride"] = 2777.37}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 225.4, ["Ride"] = 274.61, ["Fly|Ride"] = 349.9, ["Neon"] = 616.27, ["Neon|Ride"] = 649.99, ["Neon|Fly|Ride"] = 669.39, ["Mega|Fly|Ride"] = 2890.6}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2, ["Fly"] = 15.5, ["Ride"] = 17.04, ["Fly|Ride"] = 40.83, ["Neon"] = 4.83, ["Neon|Ride"] = 30, ["Neon|Fly|Ride"] = 99.11, ["Mega"] = 70.1, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 237.38, ["Fly"] = 443.87, ["Ride"] = 275, ["Fly|Ride"] = 750, ["Neon"] = 1000, ["Neon|Ride"] = 1300, ["Neon|Fly|Ride"] = 1249.99, ["Mega"] = 20922.73, ["Mega|Ride"] = 5230.95, ["Mega|Fly|Ride"] = 4375}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 8.39, ["Fly"] = 87.5, ["Ride"] = 50, ["Neon"] = 36.96, ["Neon|Ride"] = 121.24, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 162.11, ["Mega|Ride"] = 330.37, ["Mega|Fly|Ride"] = 630.78}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2, ["Fly"] = 18.74, ["Ride"] = 20.66, ["Fly|Ride"] = 37.12, ["Neon"] = 15, ["Neon|Ride"] = 52.66, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 111.5, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 151.54}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2, ["Fly"] = 55, ["Neon"] = 2, ["Mega"] = 31.25, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 169.16}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 29.57, ["Ride"] = 62.5, ["Fly|Ride"] = 437.5, ["Neon"] = 190, ["Neon|Ride"] = 342.6, ["Mega"] = 1000, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 736.25}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2, ["Fly"] = 7787.48, ["Ride"] = 31.25, ["Fly|Ride"] = 65, ["Neon"] = 15.5, ["Mega"] = 342.75, ["Mega|Ride"] = 220.93, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2, ["Ride"] = 52.5, ["Neon"] = 3.35, ["Neon|Ride"] = 53.75, ["Neon|Fly|Ride"] = 135.17, ["Mega"] = 21.04, ["Mega|Ride"] = 77.43, ["Mega|Fly|Ride"] = 74.99}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.15, ["Fly"] = 81.89, ["Ride"] = 33.75, ["Fly|Ride"] = 80.45, ["Neon"] = 29.5, ["Neon|Fly"] = 110.47, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 151.15, ["Mega|Ride"] = 162.4, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.48, ["Fly"] = 43.37, ["Ride"] = 21.24, ["Fly|Ride"] = 42.43, ["Neon"] = 36.14, ["Neon|Fly"] = 140.18, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 125, ["Mega"] = 227.45, ["Mega|Ride"] = 239.11, ["Mega|Fly|Ride"] = 1258.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.02, ["Ride"] = 36.24, ["Fly|Ride"] = 140.18, ["Neon"] = 91.12, ["Neon|Ride"] = 163.12, ["Neon|Fly|Ride"] = 350, ["Mega"] = 412.95, ["Mega|Ride"] = 468.7}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2, ["Fly"] = 6230.45, ["Ride"] = 16.15, ["Neon"] = 49.5, ["Neon|Ride"] = 205.14, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 336.25, ["Mega|Ride"] = 482.12, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2, ["Fly"] = 64.91, ["Ride"] = 15.56, ["Fly|Ride"] = 43.75, ["Neon"] = 3.62, ["Neon|Fly"] = 78.55, ["Neon|Ride"] = 26.83, ["Mega"] = 43.75, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 138.75, ["Fly"] = 251.9, ["Ride"] = 168.75, ["Fly|Ride"] = 250, ["Neon"] = 825.89, ["Neon|Ride"] = 824.87, ["Neon|Fly|Ride"] = 774.28, ["Mega"] = 8258.84, ["Mega|Fly|Ride"] = 4129.42}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2, ["Fly"] = 21.2, ["Ride"] = 16.25, ["Fly|Ride"] = 34.91, ["Neon"] = 3.42, ["Neon|Fly"] = 35.06, ["Neon|Ride"] = 23.67, ["Neon|Fly|Ride"] = 48.75, ["Mega"] = 47.28, ["Mega|Ride"] = 51.06, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.98, ["Ride"] = 69.18, ["Fly|Ride"] = 219.9, ["Neon"] = 61.5, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 747.57, ["Mega"] = 300, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 362.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 27.02, ["Ride"] = 90.99, ["Fly|Ride"] = 175, ["Neon"] = 181.25, ["Neon|Ride"] = 288.03, ["Neon|Fly|Ride"] = 375, ["Mega"] = 748.75, ["Mega|Ride"] = 869, ["Mega|Fly|Ride"] = 875}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 150, ["Fly"] = 212.5, ["Ride"] = 201.25, ["Fly|Ride"] = 330.37, ["Neon"] = 762.5, ["Neon|Ride"] = 668.75, ["Neon|Fly|Ride"] = 775.31, ["Mega|Fly|Ride"] = 3405.74}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 22.02, ["Ride"] = 156.53, ["Fly|Ride"] = 140.18, ["Neon"] = 137.5, ["Neon|Ride"] = 166.54, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 265.53, ["Mega|Ride"] = 387.5, ["Mega|Fly|Ride"] = 378.88}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.02, ["Ride"] = 55, ["Fly|Ride"] = 69.18, ["Neon"] = 136.25, ["Neon|Fly"] = 156.53, ["Neon|Ride"] = 311.88, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 1651.77, ["Mega|Ride"] = 1377.18, ["Mega|Fly|Ride"] = 675}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 895, ["Fly"] = 1222.32, ["Ride"] = 830.39, ["Fly|Ride"] = 1000, ["Neon|Ride"] = 5625, ["Neon|Fly|Ride"] = 5000, ["Mega|Fly|Ride"] = 16243.06}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.7, ["Fly"] = 24.74, ["Ride"] = 18.56, ["Fly|Ride"] = 43.74, ["Neon"] = 45, ["Neon|Fly"] = 72.8, ["Neon|Ride"] = 46.79, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 231.25, ["Mega|Fly|Ride"] = 329.99}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.23, ["Fly"] = 75, ["Ride"] = 36.25, ["Fly|Ride"] = 128.75, ["Neon"] = 18.75, ["Neon|Ride"] = 97.05, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 201.25, ["Mega|Ride"] = 308.69}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2, ["Fly"] = 82.6, ["Ride"] = 23.67, ["Fly|Ride"] = 100, ["Neon"] = 11.25, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 162.5, ["Mega"] = 87.49, ["Mega|Ride"] = 343.18, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.9, ["Ride"] = 31.25, ["Fly|Ride"] = 69.99, ["Neon"] = 59.29, ["Neon|Fly"] = 220.93, ["Neon|Ride"] = 93.15, ["Neon|Fly|Ride"] = 187.49, ["Mega"] = 424.97, ["Mega|Ride"] = 401.25, ["Mega|Fly|Ride"] = 413.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.49, ["Fly"] = 22.9, ["Ride"] = 20, ["Fly|Ride"] = 50.23, ["Neon"] = 41.3, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 30.24, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 138.75, ["Mega|Ride"] = 161.25, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2, ["Ride"] = 18.9, ["Neon"] = 14.61, ["Neon|Fly"] = 12500, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 118.65, ["Mega|Ride"] = 179.63, ["Mega|Fly|Ride"] = 253.97}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 180.67, ["Ride"] = 275.65, ["Fly|Ride"] = 412.5, ["Neon"] = 895.06, ["Neon|Fly|Ride"] = 1126.67, ["Mega|Fly|Ride"] = 3749.52}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.34, ["Fly"] = 31.24, ["Ride"] = 24.91, ["Fly|Ride"] = 138.35, ["Neon"] = 7.4, ["Neon|Ride"] = 56.16, ["Neon|Fly|Ride"] = 125, ["Mega"] = 60.23, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 330.37}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.57, ["Ride"] = 32.01, ["Fly|Ride"] = 84.62, ["Neon"] = 26.86, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 179.3, ["Mega"] = 186.25, ["Mega|Ride"] = 330.37, ["Mega|Fly|Ride"] = 192.03}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.75, ["Fly"] = 90.23, ["Ride"] = 30.31, ["Neon"] = 14.87, ["Neon|Ride"] = 64.95, ["Mega"] = 76.08, ["Mega|Ride"] = 113.62, ["Mega|Fly|Ride"] = 480.19}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 68.74, ["Ride"] = 123.64, ["Fly|Ride"] = 237.5, ["Neon"] = 411.92, ["Neon|Ride"] = 386.25, ["Neon|Fly|Ride"] = 484.75, ["Mega"] = 2477.66, ["Mega|Ride"] = 4129.42, ["Mega|Fly|Ride"] = 1511.48}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 18.45, ["Fly"] = 86.25, ["Ride"] = 67.45, ["Fly|Ride"] = 257.04, ["Neon"] = 130, ["Neon|Ride"] = 200.29, ["Neon|Fly|Ride"] = 325.64, ["Mega"] = 624.99, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.24, ["Fly"] = 55.76, ["Ride"] = 40, ["Fly|Ride"] = 100, ["Neon"] = 88.75, ["Neon|Ride"] = 122.5, ["Neon|Fly|Ride"] = 250, ["Mega"] = 562.5, ["Mega|Ride"] = 415, ["Mega|Fly|Ride"] = 512.5}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Neon"] = 12.5, ["Neon|Fly"] = 250, ["Neon|Ride"] = 219.8, ["Mega"] = 104.49, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42.23, ["Fly"] = 120.8, ["Ride"] = 83.75, ["Fly|Ride"] = 138.34, ["Neon"] = 234.35, ["Neon|Fly"] = 233.63, ["Neon|Ride"] = 218.55, ["Neon|Fly|Ride"] = 276.25, ["Mega|Fly|Ride"] = 878.55}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2, ["Ride"] = 20, ["Fly|Ride"] = 62.5, ["Neon"] = 5.18, ["Neon|Fly|Ride"] = 122.86, ["Mega"] = 58.85, ["Mega|Ride"] = 274.61, ["Mega|Fly|Ride"] = 298.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 14.64, ["Fly"] = 37.5, ["Ride"] = 31.25, ["Fly|Ride"] = 89.82, ["Neon"] = 61.48, ["Neon|Fly"] = 80, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 193.75, ["Mega"] = 343.52, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.86, ["Fly"] = 193.72, ["Ride"] = 72.74, ["Fly|Ride"] = 138.25, ["Neon"] = 250, ["Neon|Fly"] = 412.95, ["Neon|Ride"] = 252.5, ["Neon|Fly|Ride"] = 452.18, ["Mega|Ride"] = 1412.27, ["Mega|Fly|Ride"] = 1195}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2, ["Fly"] = 14.8, ["Ride"] = 15.49, ["Fly|Ride"] = 33.75, ["Neon"] = 2, ["Neon|Fly"] = 26.86, ["Neon|Ride"] = 18.21, ["Neon|Fly|Ride"] = 42.5, ["Mega"] = 19.34, ["Mega|Fly"] = 87.5, ["Mega|Ride"] = 38.65, ["Mega|Fly|Ride"] = 85.69}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.15, ["Ride"] = 20.66, ["Fly|Ride"] = 61.24, ["Neon"] = 26.68, ["Neon|Ride"] = 62.48, ["Neon|Fly|Ride"] = 159.99, ["Mega"] = 288.75, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 373.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 11.63, ["Fly"] = 138.35, ["Ride"] = 47.5, ["Fly|Ride"] = 111.66, ["Neon"] = 105.48, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 259.77, ["Mega"] = 619.42, ["Mega|Ride"] = 433.11, ["Mega|Fly|Ride"] = 623.75}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2, ["Ride"] = 20.35, ["Neon"] = 2, ["Neon|Fly"] = 31.24, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 86.25, ["Mega"] = 20, ["Mega|Ride"] = 51.63, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 34.99, ["Fly"] = 200, ["Ride"] = 62.48, ["Fly|Ride"] = 207.5, ["Neon"] = 149.13, ["Neon|Ride"] = 246.75, ["Neon|Fly|Ride"] = 375, ["Mega"] = 647.6, ["Mega|Ride"] = 598.8, ["Mega|Fly|Ride"] = 955.97}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.1, ["Fly"] = 41.3, ["Ride"] = 25, ["Fly|Ride"] = 85.69, ["Neon"] = 358.75, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 158.99, ["Mega|Ride"] = 203.26, ["Mega|Fly|Ride"] = 493.48}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.03, ["Ride"] = 50, ["Neon"] = 61.25, ["Neon|Fly"] = 666.25, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 222.48, ["Mega|Ride"] = 301.23, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.33, ["Fly"] = 68.75, ["Ride"] = 68.74, ["Fly|Ride"] = 228.34, ["Neon"] = 54.71, ["Neon|Ride"] = 84.67, ["Neon|Fly|Ride"] = 181.24, ["Mega"] = 205.59, ["Mega|Ride"] = 421.25, ["Mega|Fly|Ride"] = 425}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2, ["Fly"] = 41.3, ["Ride"] = 34.91, ["Fly|Ride"] = 187.5, ["Neon"] = 8.2, ["Neon|Ride"] = 35.54, ["Neon|Fly|Ride"] = 100, ["Mega"] = 66.25, ["Mega|Ride"] = 85.69, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2, ["Ride"] = 56.08, ["Neon"] = 4.91, ["Neon|Ride"] = 33.75, ["Neon|Fly|Ride"] = 138.37, ["Mega"] = 31.55, ["Mega|Ride"] = 111.25, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.05}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 46.87, ["Fly"] = 96.25, ["Ride"] = 51.25, ["Fly|Ride"] = 87.5, ["Neon"] = 175.79, ["Neon|Ride"] = 206.48, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 1766.05, ["Mega|Ride"] = 750, ["Mega|Fly|Ride"] = 812.93}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2, ["Fly|Ride"] = 103.24, ["Neon"] = 2.5, ["Neon|Ride"] = 36.14, ["Mega"] = 19.85, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 309.71}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 465.61, ["Fly"] = 551.29, ["Ride"] = 538, ["Fly|Ride"] = 664.84, ["Neon"] = 2753.3, ["Neon|Ride"] = 2580.89, ["Neon|Fly|Ride"] = 2064.71, ["Mega"] = 16517.67, ["Mega|Fly|Ride"] = 10000}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.91, ["Fly"] = 46.53, ["Ride"] = 32.12, ["Fly|Ride"] = 63.08, ["Neon"] = 9.34, ["Neon|Fly"] = 175, ["Neon|Ride"] = 110.38, ["Mega"] = 311.88, ["Mega|Ride"] = 186.25, ["Mega|Fly|Ride"] = 606}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.15, ["Fly"] = 27.73, ["Ride"] = 20, ["Fly|Ride"] = 60.92, ["Neon"] = 24.92, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 95, ["Mega"] = 140, ["Mega|Ride"] = 167.5, ["Mega|Fly|Ride"] = 206.25}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.4, ["Ride"] = 55.68, ["Fly|Ride"] = 516.18, ["Neon"] = 107.49, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 298.75, ["Mega"] = 502.76, ["Mega|Ride"] = 370, ["Mega|Fly|Ride"] = 425}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.19, ["Fly"] = 55.76, ["Ride"] = 36.73, ["Fly|Ride"] = 69.18, ["Neon"] = 35.7, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 100, ["Neon|Fly|Ride"] = 373.75, ["Mega"] = 268.75, ["Mega|Fly|Ride"] = 481.08}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 14.3, ["Ride"] = 70, ["Fly|Ride"] = 187.5, ["Neon"] = 58.74, ["Neon|Ride"] = 93.75, ["Neon|Fly|Ride"] = 132, ["Mega"] = 511.03, ["Mega|Ride"] = 396, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.48, ["Ride"] = 25, ["Fly|Ride"] = 87.5, ["Neon"] = 26.86, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 212.38, ["Mega|Ride"] = 313.78, ["Mega|Fly|Ride"] = 332.5}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2, ["Fly"] = 43.05, ["Ride"] = 12.5, ["Fly|Ride"] = 82.6, ["Neon"] = 2, ["Neon|Fly"] = 39.99, ["Neon|Ride"] = 17.32, ["Neon|Fly|Ride"] = 51.25, ["Mega"] = 14.36, ["Mega|Fly"] = 63.08, ["Mega|Ride"] = 46.73, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5, ["Fly"] = 47.5, ["Ride"] = 53.74, ["Fly|Ride"] = 103.24, ["Neon"] = 34.91, ["Neon|Fly"] = 116.82, ["Neon|Ride"] = 74.99, ["Neon|Fly|Ride"] = 193.91, ["Mega"] = 187.5, ["Mega|Ride"] = 247.4, ["Mega|Fly|Ride"] = 350}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 246.15, ["Fly"] = 308.69, ["Ride"] = 287.5, ["Fly|Ride"] = 365, ["Neon"] = 1246.33, ["Neon|Ride"] = 993.75, ["Neon|Fly|Ride"] = 1000, ["Mega|Ride"] = 9064.17, ["Mega|Fly|Ride"] = 4138.22}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 96.14, ["Ride"] = 100, ["Fly|Ride"] = 246.75, ["Neon"] = 436.25, ["Neon|Fly"] = 883.71, ["Neon|Ride"] = 450, ["Neon|Fly|Ride"] = 613.23, ["Mega"] = 2203.05, ["Mega|Ride"] = 1649.71, ["Mega|Fly|Ride"] = 1740}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2, ["Fly"] = 15.26, ["Ride"] = 14.54, ["Fly|Ride"] = 31.25, ["Neon"] = 6.88, ["Neon|Fly"] = 69.18, ["Neon|Ride"] = 26.86, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 138.35, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 248.75}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2, ["Fly"] = 21.89, ["Ride"] = 14.12, ["Fly|Ride"] = 35, ["Neon"] = 11.13, ["Neon|Fly"] = 31.24, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 53.9, ["Mega"] = 48.75, ["Mega|Fly"] = 275.65, ["Mega|Ride"] = 86.48, ["Mega|Fly|Ride"] = 137.46}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2, ["Fly"] = 97.05, ["Ride"] = 21.25, ["Fly|Ride"] = 93.75, ["Neon"] = 97.05, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 150, ["Mega|Ride"] = 316.23, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 200, ["Fly"] = 311.88, ["Ride"] = 233.32, ["Fly|Ride"] = 318.75, ["Neon"] = 1135.6, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 928.1, ["Mega|Ride"] = 8258.84, ["Mega|Fly|Ride"] = 3579.18}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2, ["Fly"] = 29.8, ["Ride"] = 17.49, ["Fly|Ride"] = 41.03, ["Neon"] = 15, ["Neon|Fly"] = 99.97, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 74.99, ["Mega"] = 250, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 233.32}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.32, ["Ride"] = 74.25, ["Fly|Ride"] = 205.72, ["Neon"] = 44.41, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 187.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 10.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 59.37, ["Mega"] = 98.75}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.57, ["Fly"] = 47.28, ["Ride"] = 25.9, ["Fly|Ride"] = 65.04, ["Neon"] = 152.79, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 143.75, ["Mega"] = 439.79, ["Mega|Ride"] = 477.5, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 40.88, ["Ride"] = 87.5, ["Fly|Ride"] = 278.89, ["Neon"] = 124.81, ["Neon|Fly"] = 625, ["Neon|Ride"] = 181.15, ["Neon|Fly|Ride"] = 279.89, ["Mega"] = 485.61, ["Mega|Fly"] = 545.5, ["Mega|Ride"] = 486.37, ["Mega|Fly|Ride"] = 617.67}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.04, ["Ride"] = 45.44, ["Fly|Ride"] = 87.49, ["Neon"] = 148.24, ["Neon|Fly"] = 272.8, ["Neon|Ride"] = 123.75, ["Neon|Fly|Ride"] = 212.49, ["Mega"] = 825.89, ["Mega|Ride"] = 667.5, ["Mega|Fly|Ride"] = 774.28}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2, ["Fly"] = 16.25, ["Ride"] = 15.4, ["Fly|Ride"] = 31.25, ["Neon"] = 2, ["Neon|Fly"] = 30.9, ["Neon|Ride"] = 17.5, ["Neon|Fly|Ride"] = 37.5, ["Mega"] = 17.49, ["Mega|Ride"] = 37.17, ["Mega|Fly|Ride"] = 85}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 195.46, ["Fly"] = 186.9, ["Ride"] = 200, ["Fly|Ride"] = 250, ["Neon"] = 3270.58, ["Neon|Ride"] = 775.31, ["Neon|Fly|Ride"] = 895.06, ["Mega|Fly|Ride"] = 3579.18}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.81, ["Fly"] = 96.36, ["Ride"] = 22.72, ["Fly|Ride"] = 88.51, ["Neon"] = 75, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 393.75, ["Mega|Ride"] = 551.29, ["Mega|Fly|Ride"] = 400}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2, ["Fly"] = 34.26, ["Ride"] = 17.88, ["Fly|Ride"] = 48.28, ["Neon"] = 8.27, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 95, ["Mega"] = 58.85, ["Mega|Fly"] = 220.93, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 162.5}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2, ["Fly"] = 30.99, ["Ride"] = 17, ["Fly|Ride"] = 76.4, ["Neon"] = 2, ["Neon|Fly"] = 62.5, ["Neon|Ride"] = 21.09, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 22.65, ["Mega|Fly"] = 137.5, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 155.9}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2, ["Ride"] = 27.22, ["Fly|Ride"] = 42.5, ["Neon"] = 11.31, ["Neon|Fly"] = 700.85, ["Neon|Ride"] = 46.07, ["Mega"] = 148.75, ["Mega|Ride"] = 129.4, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.43, ["Fly"] = 44.91, ["Ride"] = 27.49, ["Fly|Ride"] = 67.5, ["Neon"] = 44.98, ["Neon|Fly"] = 262.23, ["Neon|Ride"] = 44.91, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 584.04, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 439.79}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 16.43, ["Ride"] = 97.05, ["Neon"] = 103.24, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 262.5, ["Mega|Ride"] = 311.25, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2, ["Ride"] = 55, ["Neon"] = 2.97, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 18.75, ["Mega|Ride"] = 69.9, ["Mega|Fly|Ride"] = 151.13}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.23, ["Fly"] = 79.99, ["Ride"] = 32.26, ["Fly|Ride"] = 98.09, ["Neon"] = 35.92, ["Neon|Fly"] = 93.45, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 275.64, ["Mega"] = 125, ["Mega|Fly"] = 311.88, ["Mega|Ride"] = 225, ["Mega|Fly|Ride"] = 268.75}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.13, ["Ride"] = 30, ["Neon"] = 3.43, ["Neon|Fly"] = 110.47, ["Neon|Ride"] = 52.46, ["Neon|Fly|Ride"] = 100, ["Mega"] = 24.92, ["Mega|Ride"] = 116.66, ["Mega|Fly|Ride"] = 247.77}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2, ["Fly"] = 48.74, ["Ride"] = 21.04, ["Fly|Ride"] = 42.5, ["Neon"] = 4.91, ["Neon|Ride"] = 25.89, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 43.29, ["Mega|Ride"] = 96.35, ["Mega|Fly|Ride"] = 197.2}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 600, ["Ride"] = 675, ["Fly|Ride"] = 735, ["Neon"] = 2500, ["Mega|Fly|Ride"] = 9162.5}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2, ["Fly"] = 15.69, ["Ride"] = 14.99, ["Fly|Ride"] = 39.24, ["Neon"] = 17.49, ["Neon|Fly"] = 41.08, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 100}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 4.04, ["Ride"] = 48.75, ["Fly|Ride"] = 69.18, ["Neon"] = 12.75, ["Neon|Fly"] = 722.65, ["Neon|Ride"] = 81.67, ["Neon|Fly|Ride"] = 155, ["Mega"] = 71.25, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 277.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.42, ["Fly"] = 42.5, ["Ride"] = 25, ["Fly|Ride"] = 60, ["Neon"] = 46.25, ["Neon|Fly"] = 185.58, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 462.5, ["Mega|Ride"] = 293.74, ["Mega|Fly|Ride"] = 327.5}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2, ["Fly"] = 56.15, ["Ride"] = 18.57, ["Fly|Ride"] = 43.37, ["Neon"] = 6.33, ["Neon|Fly"] = 144.54, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 59.89, ["Mega|Ride"] = 90.04, ["Mega|Fly|Ride"] = 150}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 34.91, ["Ride"] = 56.24, ["Fly|Ride"] = 304.56, ["Neon"] = 187.5, ["Neon|Ride"] = 200, ["Mega"] = 710.27, ["Mega|Ride"] = 757.76, ["Mega|Fly|Ride"] = 687.56}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2, ["Ride"] = 23.48, ["Fly|Ride"] = 138.35, ["Neon"] = 8.74, ["Neon|Fly"] = 133.17, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 110.33, ["Mega"] = 45, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 266.25}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 20.36, ["Fly|Ride"] = 60.01, ["Neon"] = 12.48, ["Neon|Ride"] = 45.32, ["Mega"] = 108.65, ["Mega|Ride"] = 189.13, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2, ["Ride"] = 41.3, ["Fly|Ride"] = 62.69, ["Neon"] = 10.8, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 92.49, ["Mega|Ride"] = 62.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2, ["Fly"] = 41.3, ["Ride"] = 16.95, ["Fly|Ride"] = 65.91, ["Neon"] = 4.06, ["Neon|Fly"] = 68.8, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 103, ["Mega"] = 41.23, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 12.5, ["Fly"] = 21.1, ["Ride"] = 21.46, ["Fly|Ride"] = 40.64, ["Neon"] = 112.5, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 78.29, ["Neon|Fly|Ride"] = 136.28, ["Mega|Ride"] = 412.95, ["Mega|Fly|Ride"] = 413.71}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 743.75, ["Fly"] = 1032.36, ["Ride"] = 734.9, ["Fly|Ride"] = 812.5, ["Neon"] = 1843.75, ["Neon|Ride"] = 1961.48, ["Neon|Fly|Ride"] = 2061.25, ["Mega"] = 7708.59, ["Mega|Ride"] = 5437.42, ["Mega|Fly|Ride"] = 4293.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2, ["Fly"] = 18.65, ["Ride"] = 16.53, ["Fly|Ride"] = 39.5, ["Neon"] = 5.63, ["Neon|Ride"] = 20.81, ["Neon|Fly|Ride"] = 67.5, ["Mega"] = 41.29, ["Mega|Ride"] = 86.25, ["Mega|Fly|Ride"] = 185.83}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.65, ["Ride"] = 35, ["Fly|Ride"] = 69.18, ["Neon"] = 56.08, ["Neon|Ride"] = 206.25, ["Neon|Fly|Ride"] = 225, ["Mega"] = 495.54, ["Mega|Ride"] = 374.99, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.41, ["Fly"] = 99.9, ["Ride"] = 75, ["Fly|Ride"] = 111.15, ["Neon"] = 300, ["Neon|Ride"] = 298.75, ["Neon|Fly|Ride"] = 387.14, ["Mega"] = 2323.64, ["Mega|Fly|Ride"] = 2498.75}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 29.9, ["Fly"] = 139.86, ["Ride"] = 49, ["Fly|Ride"] = 102.8, ["Neon"] = 237.5, ["Neon|Ride"] = 165.19, ["Neon|Fly|Ride"] = 412.95, ["Mega"] = 1401.68, ["Mega|Ride"] = 894.03, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.67, ["Fly"] = 91.12, ["Ride"] = 26.82, ["Fly|Ride"] = 138.35, ["Neon"] = 50.66, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 260, ["Mega"] = 290.81, ["Mega|Ride"] = 399.53, ["Mega|Fly|Ride"] = 440}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.42, ["Ride"] = 56.25, ["Fly|Ride"] = 136.28, ["Neon"] = 99.9, ["Neon|Ride"] = 101.25, ["Neon|Fly|Ride"] = 145, ["Mega"] = 308.6, ["Mega|Fly"] = 506.95, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 378.75}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.8, ["Ride"] = 75, ["Fly|Ride"] = 154.86, ["Neon"] = 138.65, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 500, ["Mega"] = 500, ["Mega|Ride"] = 453.75, ["Mega|Fly|Ride"] = 720.59}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.66}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.43, ["Ride"] = 27.88, ["Fly|Ride"] = 75, ["Neon"] = 33.66, ["Neon|Ride"] = 43.75, ["Neon|Fly|Ride"] = 203.78, ["Mega"] = 200, ["Mega|Fly"] = 436.44, ["Mega|Ride"] = 222.5, ["Mega|Fly|Ride"] = 293.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.13, ["Neon"] = 12.4, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 136.25, ["Mega|Fly|Ride"] = 390}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.08, ["Fly"] = 59.99, ["Ride"] = 39.28, ["Fly|Ride"] = 82.34, ["Neon"] = 210, ["Neon|Fly"] = 275.65, ["Neon|Ride"] = 193.06, ["Neon|Fly|Ride"] = 219.73, ["Mega|Ride"] = 606, ["Mega|Fly|Ride"] = 587.49}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.45, ["Fly"] = 20.64, ["Ride"] = 18.49, ["Fly|Ride"] = 38.75, ["Neon"] = 27.3, ["Neon|Fly"] = 66.25, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 66.25, ["Mega"] = 206.48, ["Mega|Fly"] = 411.92, ["Mega|Ride"] = 175, ["Mega|Fly|Ride"] = 188.74}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.14, ["Fly"] = 30.38, ["Ride"] = 24.91, ["Fly|Ride"] = 69.18, ["Neon"] = 24.75, ["Neon|Ride"] = 52.9, ["Neon|Fly|Ride"] = 122.5, ["Mega"] = 209.67, ["Mega|Ride"] = 169.81, ["Mega|Fly|Ride"] = 333.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2, ["Neon"] = 6.1, ["Mega"] = 38.66, ["Mega|Ride"] = 193.75, ["Mega|Fly|Ride"] = 246.25}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.92, ["Ride"] = 66.58, ["Fly|Ride"] = 76.4, ["Neon"] = 234.35, ["Neon|Ride"] = 200, ["Neon|Fly|Ride"] = 412.95, ["Mega|Ride"] = 817.63, ["Mega|Fly|Ride"] = 800}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2, ["Ride"] = 19.8, ["Fly|Ride"] = 55.76, ["Neon"] = 9.43, ["Neon|Fly"] = 193.75, ["Neon|Ride"] = 39.98, ["Neon|Fly|Ride"] = 100, ["Mega"] = 68.14, ["Mega|Ride"] = 133.27}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.03, ["Ride"] = 83.75, ["Fly|Ride"] = 274.61, ["Neon"] = 53.74, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 309.71, ["Mega"] = 384.05, ["Mega|Ride"] = 381.68, ["Mega|Fly|Ride"] = 688.59}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2, ["Fly"] = 43.73, ["Ride"] = 14.88, ["Fly|Ride"] = 58.75, ["Neon"] = 27.88, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 94.99, ["Mega"] = 185, ["Mega|Ride"] = 197.2, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2, ["Fly"] = 49.99, ["Ride"] = 18.37, ["Fly|Ride"] = 40.24, ["Neon"] = 45.86, ["Neon|Fly"] = 123.89, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 162.5, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 298.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 9.23, ["Neon"] = 109.81, ["Mega"] = 398.15, ["Mega|Ride"] = 348.75, ["Mega|Fly|Ride"] = 614.99}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.9, ["Ride"] = 152.79, ["Fly|Ride"] = 138.34, ["Neon"] = 330.92, ["Neon|Ride"] = 515.12, ["Neon|Fly|Ride"] = 637.5, ["Mega"] = 1342.07, ["Mega|Ride"] = 1445.3, ["Mega|Fly|Ride"] = 1850}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.22, ["Ride"] = 74.9, ["Fly|Ride"] = 153.6, ["Neon"] = 102.49, ["Mega"] = 361.25, ["Mega|Ride"] = 545.5, ["Mega|Fly|Ride"] = 688.59}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.06, ["Ride"] = 120.03, ["Neon"] = 38.44, ["Neon|Fly"] = 206.48, ["Neon|Ride"] = 162.5, ["Mega|Ride"] = 823.83}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.39, ["Ride"] = 100, ["Fly|Ride"] = 349.98, ["Neon"] = 123.93, ["Neon|Ride"] = 249.99, ["Neon|Fly|Ride"] = 312.49, ["Mega"] = 647.29, ["Mega|Ride"] = 700.85, ["Mega|Fly|Ride"] = 774.28}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.25, ["Neon"] = 18.97, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 175.51, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2, ["Fly"] = 125, ["Ride"] = 18.23, ["Fly|Ride"] = 39.9, ["Neon"] = 3.46, ["Neon|Fly"] = 40.97, ["Neon|Ride"] = 42.01, ["Neon|Fly|Ride"] = 93.45, ["Mega"] = 83.75, ["Mega|Ride"] = 72.5, ["Mega|Fly|Ride"] = 137.48}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2, ["Fly"] = 43.75, ["Ride"] = 20.66, ["Fly|Ride"] = 71.89, ["Neon"] = 15.59, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 156.24, ["Mega"] = 78.73, ["Mega|Ride"] = 136.28, ["Mega|Fly|Ride"] = 295}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2, ["Fly"] = 138.34, ["Ride"] = 17.99, ["Fly|Ride"] = 37.5, ["Neon"] = 8.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 87.79, ["Mega"] = 52.48, ["Mega|Ride"] = 80, ["Mega|Fly|Ride"] = 163.12}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.54, ["Fly"] = 62.49, ["Ride"] = 18.7, ["Fly|Ride"] = 69.18, ["Neon"] = 18.65, ["Neon|Ride"] = 103.24, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 316.85, ["Mega|Ride"] = 315.91, ["Mega|Fly|Ride"] = 345}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.59, ["Fly"] = 53.4, ["Ride"] = 18.7, ["Fly|Ride"] = 412.95, ["Neon"] = 28.75, ["Neon|Fly"] = 300, ["Neon|Ride"] = 81.25, ["Mega"] = 293.2, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.39, ["Fly"] = 125, ["Ride"] = 27.88, ["Fly|Ride"] = 66.08, ["Neon"] = 38.75, ["Neon|Fly"] = 123.89, ["Neon|Ride"] = 42.44, ["Neon|Fly|Ride"] = 87.4, ["Mega"] = 291.91, ["Mega|Ride"] = 280, ["Mega|Fly|Ride"] = 387.14}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2, ["Fly"] = 33.79, ["Ride"] = 21.25, ["Fly|Ride"] = 49.91, ["Neon"] = 21.25, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 247.77, ["Mega|Ride"] = 303.13, ["Mega|Fly|Ride"] = 177.31}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2, ["Fly"] = 125, ["Ride"] = 44.97, ["Fly|Ride"] = 125, ["Neon"] = 11.24, ["Neon|Fly"] = 416.24, ["Neon|Ride"] = 63.74, ["Neon|Fly|Ride"] = 163.53, ["Mega"] = 92.47, ["Mega|Ride"] = 156.25, ["Mega|Fly|Ride"] = 257.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.39, ["Fly"] = 108.4, ["Ride"] = 120, ["Fly|Ride"] = 412.95, ["Neon"] = 165.19, ["Neon|Fly"] = 275, ["Neon|Ride"] = 218.44, ["Neon|Fly|Ride"] = 336.93, ["Mega"] = 699.01, ["Mega|Ride"] = 688.49, ["Mega|Fly|Ride"] = 757.76}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 53.74, ["Fly"] = 156.25, ["Ride"] = 80, ["Fly|Ride"] = 155, ["Neon"] = 229.42, ["Neon|Ride"] = 257.5, ["Neon|Fly|Ride"] = 355.45, ["Mega"] = 1513.44, ["Mega|Ride"] = 981.78, ["Mega|Fly|Ride"] = 1168.07}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2, ["Ride"] = 20.54, ["Fly|Ride"] = 112.49, ["Neon"] = 2.19, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 25.71, ["Mega|Ride"] = 67.65, ["Mega|Fly|Ride"] = 138.28}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 7.4, ["Ride"] = 75, ["Neon"] = 100.89, ["Mega"] = 653.86, ["Mega|Fly|Ride"] = 1088.11}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 49.99, ["Ride"] = 87.54, ["Fly|Ride"] = 164.43, ["Neon"] = 250, ["Neon|Ride"] = 340, ["Neon|Fly|Ride"] = 824.87, ["Mega"] = 1701.33, ["Mega|Ride"] = 1168.07, ["Mega|Fly|Ride"] = 1388.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.14, ["Fly"] = 181.25, ["Ride"] = 30.05, ["Fly|Ride"] = 127.5, ["Neon"] = 44.18, ["Neon|Fly"] = 125, ["Neon|Ride"] = 77.5, ["Neon|Fly|Ride"] = 121.82, ["Mega"] = 254.53, ["Mega|Ride"] = 231.15, ["Mega|Fly|Ride"] = 237.5}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.17, ["Fly"] = 83.44, ["Neon"] = 16.55, ["Neon|Ride"] = 65.44, ["Mega"] = 98.75, ["Mega|Ride"] = 187.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2, ["Fly"] = 27.48, ["Ride"] = 18.33, ["Fly|Ride"] = 54.64, ["Neon"] = 18.75, ["Neon|Ride"] = 31.23, ["Neon|Fly|Ride"] = 94.98, ["Mega"] = 165, ["Mega|Ride"] = 124.81, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2, ["Fly"] = 16.8, ["Ride"] = 16.25, ["Fly|Ride"] = 49.81, ["Neon"] = 2.49, ["Neon|Fly"] = 33.04, ["Neon|Ride"] = 18.74, ["Neon|Fly|Ride"] = 49.91, ["Mega"] = 24.97, ["Mega|Ride"] = 66.25, ["Mega|Fly|Ride"] = 147.42}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2, ["Ride"] = 19.6, ["Fly|Ride"] = 63.08, ["Neon"] = 3.75, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 49.84, ["Mega|Fly"] = 147.56, ["Mega|Ride"] = 87.5, ["Mega|Fly|Ride"] = 165}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 2.49, ["Neon|Ride"] = 138.17, ["Mega"] = 39.24, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.69, ["Ride"] = 99.99, ["Neon"] = 62.5, ["Neon|Ride"] = 80, ["Neon|Fly|Ride"] = 135, ["Mega"] = 316.94, ["Mega|Ride"] = 235.77, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.82, ["Ride"] = 28.75, ["Fly|Ride"] = 206.48, ["Neon"] = 55.82, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 250, ["Mega|Ride"] = 222.75, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.53, ["Fly"] = 24.05, ["Ride"] = 19.61, ["Fly|Ride"] = 39.91, ["Neon"] = 22.49, ["Neon|Ride"] = 33.46, ["Neon|Fly|Ride"] = 87.39, ["Mega"] = 334.49, ["Mega|Ride"] = 296.54, ["Mega|Fly|Ride"] = 330.37}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 67.38, ["Ride"] = 75, ["Fly|Ride"] = 118.75, ["Neon"] = 375, ["Neon|Ride"] = 411.92, ["Neon|Fly|Ride"] = 688.59, ["Mega"] = 2336.14, ["Mega|Ride"] = 1555.77, ["Mega|Fly|Ride"] = 1402.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 18.61, ["Fly"] = 78.75, ["Ride"] = 56.16, ["Fly|Ride"] = 110.47, ["Neon"] = 138.35, ["Neon|Fly|Ride"] = 600, ["Mega"] = 412.95, ["Mega|Ride"] = 837.5, ["Mega|Fly|Ride"] = 1032.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2, ["Fly"] = 18.74, ["Ride"] = 14.89, ["Fly|Ride"] = 41.3, ["Neon"] = 2.38, ["Neon|Fly"] = 42.06, ["Neon|Ride"] = 18.75, ["Neon|Fly|Ride"] = 53.75, ["Mega"] = 26.86, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 88.99, ["Mega|Fly|Ride"] = 161.2}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2, ["Fly"] = 15.6, ["Ride"] = 16.15, ["Fly|Ride"] = 31.25, ["Neon"] = 3.77, ["Neon|Fly"] = 26.21, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 41.24, ["Mega"] = 43.7, ["Mega|Ride"] = 47.01, ["Mega|Fly|Ride"] = 93.75}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 387.48, ["Fly"] = 722.23, ["Ride"] = 420.79, ["Fly|Ride"] = 487.4, ["Neon"] = 1900.45, ["Neon|Ride"] = 1937.5, ["Neon|Fly|Ride"] = 1955.29, ["Mega|Fly|Ride"] = 6194.13}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.37, ["Ride"] = 45.43, ["Neon"] = 22.72, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 275, ["Mega"] = 384.28, ["Mega|Ride"] = 685.5, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2, ["Fly"] = 15.49, ["Ride"] = 15, ["Fly|Ride"] = 32.41, ["Neon"] = 3.55, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 17.3, ["Neon|Fly|Ride"] = 41.3, ["Mega"] = 60.92, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 109.7}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 46, ["Ride"] = 106.25, ["Fly|Ride"] = 272.55, ["Neon"] = 188.4, ["Neon|Ride"] = 247.15, ["Neon|Fly|Ride"] = 406.25, ["Mega"] = 702.5, ["Mega|Ride"] = 650, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2, ["Fly"] = 23.68, ["Ride"] = 20.82, ["Fly|Ride"] = 116.82, ["Neon"] = 15.4, ["Neon|Fly"] = 76.4, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 88.64, ["Mega"] = 250, ["Mega|Ride"] = 123.73, ["Mega|Fly|Ride"] = 222.49}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2, ["Ride"] = 51.63, ["Fly|Ride"] = 187.5, ["Neon"] = 2.4, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 106.23, ["Mega"] = 17.39, ["Mega|Ride"] = 49.91, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.52, ["Fly"] = 123.75, ["Ride"] = 74.23, ["Fly|Ride"] = 205.45, ["Neon"] = 140, ["Neon|Ride"] = 197.5, ["Neon|Fly|Ride"] = 275, ["Mega"] = 675.17, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 650}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2, ["Fly"] = 22.5, ["Ride"] = 18.75, ["Fly|Ride"] = 139.99, ["Neon"] = 3.7, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 330.37, ["Mega"] = 59.88, ["Mega|Ride"] = 149.76, ["Mega|Fly|Ride"] = 240}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 26.65, ["Ride"] = 61.66, ["Fly|Ride"] = 100, ["Neon"] = 155.9, ["Neon|Ride"] = 275, ["Neon|Fly|Ride"] = 274.72, ["Mega"] = 1125, ["Mega|Ride"] = 1238.83, ["Mega|Fly|Ride"] = 1270.31}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.26, ["Fly"] = 69.18, ["Ride"] = 125, ["Fly|Ride"] = 412.95, ["Neon"] = 17.4, ["Neon|Ride"] = 220, ["Neon|Fly|Ride"] = 481.77, ["Mega"] = 156.41, ["Mega|Ride"] = 225}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2, ["Fly"] = 69.18, ["Ride"] = 72.16, ["Fly|Ride"] = 55.76, ["Neon"] = 9.9, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 420.51, ["Mega"] = 110.47, ["Mega|Ride"] = 125, ["Mega|Fly|Ride"] = 291.14}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 48.9, ["Fly"] = 154.86, ["Ride"] = 100, ["Fly|Ride"] = 187.5, ["Neon"] = 342.5, ["Neon|Ride"] = 399.43, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 1928.45}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2, ["Fly"] = 559.5, ["Ride"] = 43.67, ["Neon"] = 6.2, ["Neon|Ride"] = 52.66, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 43.74, ["Mega|Ride"] = 114.6, ["Mega|Fly|Ride"] = 264.13}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2, ["Fly"] = 16.72, ["Ride"] = 18.56, ["Fly|Ride"] = 35.11, ["Neon"] = 4.72, ["Neon|Fly"] = 40, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 69.83, ["Mega"] = 56.31, ["Mega|Fly"] = 143.69, ["Mega|Ride"] = 77.5, ["Mega|Fly|Ride"] = 208.98}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.67, ["Fly"] = 55.15, ["Ride"] = 35.48, ["Fly|Ride"] = 186.25, ["Neon"] = 76.3, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 275.65, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 338.62}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 5.94, ["Fly"] = 41.3, ["Ride"] = 23.13, ["Fly|Ride"] = 69.18, ["Neon"] = 69.18, ["Neon|Ride"] = 99.9, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 337.5, ["Mega|Ride"] = 437.5, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.49, ["Fly"] = 46.25, ["Ride"] = 27.32, ["Fly|Ride"] = 62.5, ["Neon"] = 87.92, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 146.73, ["Mega"] = 389.5, ["Mega|Ride"] = 311.84, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 62.5, ["Ride"] = 121.32, ["Fly|Ride"] = 192.9, ["Neon"] = 300, ["Neon|Ride"] = 269.99, ["Neon|Fly|Ride"] = 437.5, ["Mega"] = 1500, ["Mega|Ride"] = 1548.54, ["Mega|Fly|Ride"] = 1581.58}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 9.48, ["Ride"] = 109.9, ["Fly|Ride"] = 193.75, ["Neon"] = 55.6, ["Neon|Ride"] = 99.99, ["Neon|Fly|Ride"] = 416.25, ["Mega"] = 230, ["Mega|Ride"] = 327.06, ["Mega|Fly|Ride"] = 543.02}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.23, ["Ride"] = 26, ["Fly|Ride"] = 74.99, ["Neon"] = 23.13, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 152.79, ["Mega|Ride"] = 232.29, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.42, ["Fly"] = 128.75, ["Ride"] = 34.62, ["Fly|Ride"] = 110, ["Neon"] = 54.88, ["Neon|Ride"] = 57.83, ["Mega"] = 436.87, ["Mega|Fly|Ride"] = 998.75}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2, ["Fly"] = 15, ["Ride"] = 12.4, ["Fly|Ride"] = 43.75, ["Neon"] = 2, ["Neon|Fly"] = 20.57, ["Neon|Ride"] = 13.75, ["Neon|Fly|Ride"] = 52.18, ["Mega"] = 13.55, ["Mega|Fly"] = 40, ["Mega|Ride"] = 26.34, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 53.66, ["Fly"] = 218.87, ["Ride"] = 98.75, ["Fly|Ride"] = 156.53, ["Neon"] = 225, ["Neon|Fly"] = 2340.36, ["Neon|Ride"] = 280, ["Neon|Fly|Ride"] = 464.57, ["Mega"] = 1030.3, ["Mega|Ride"] = 1081.91, ["Mega|Fly|Ride"] = 862.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2, ["Ride"] = 20.66, ["Neon"] = 6.13, ["Neon|Ride"] = 42.5, ["Neon|Fly|Ride"] = 123.74, ["Mega"] = 28.04, ["Mega|Ride"] = 82.94, ["Mega|Fly|Ride"] = 298.74}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 15, ["Fly|Ride"] = 43.75, ["Neon"] = 17.38, ["Neon|Ride"] = 22.2, ["Neon|Fly|Ride"] = 85.69, ["Mega"] = 245, ["Mega|Ride"] = 187.5, ["Mega|Fly|Ride"] = 217.5}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65, ["Fly"] = 103.24, ["Ride"] = 74.99, ["Fly|Ride"] = 246.25, ["Neon"] = 187.5, ["Neon|Ride"] = 247.5, ["Mega"] = 796.25, ["Mega|Ride"] = 1090.98, ["Mega|Fly|Ride"] = 975}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2, ["Ride"] = 68.75, ["Neon"] = 7.85, ["Neon|Ride"] = 27.88, ["Mega"] = 155, ["Mega|Ride"] = 111.24, ["Mega|Fly|Ride"] = 299.89}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.02}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2, ["Ride"] = 24.17, ["Fly|Ride"] = 65.05, ["Neon"] = 7.27, ["Neon|Ride"] = 80.54, ["Neon|Fly|Ride"] = 109.81, ["Mega"] = 78.75, ["Mega|Ride"] = 100.23, ["Mega|Fly|Ride"] = 325}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 123.75, ["Ride"] = 186.73, ["Fly|Ride"] = 324.17, ["Neon"] = 624.93, ["Neon|Ride"] = 582, ["Neon|Fly|Ride"] = 646.25, ["Mega"] = 6194.13, ["Mega|Ride"] = 2890.6, ["Mega|Fly|Ride"] = 2517.92}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2, ["Ride"] = 35.11, ["Fly|Ride"] = 206.48, ["Neon"] = 21.9, ["Neon|Fly"] = 138.35, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 156.25, ["Mega"] = 169.98, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2, ["Fly"] = 25, ["Ride"] = 24.99, ["Neon"] = 3.13, ["Neon|Ride"] = 23.51, ["Mega"] = 30.9, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 330.14}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.97, ["Ride"] = 31.25, ["Fly|Ride"] = 125, ["Neon"] = 54.91, ["Neon|Ride"] = 85.36, ["Neon|Fly|Ride"] = 152.79, ["Mega"] = 412.95, ["Mega|Ride"] = 399.53, ["Mega|Fly|Ride"] = 633.87}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.56, ["Fly"] = 35.53, ["Ride"] = 24.99, ["Fly|Ride"] = 55.75, ["Neon"] = 96.22, ["Neon|Ride"] = 150.62, ["Neon|Fly|Ride"] = 263.13, ["Mega"] = 308.69, ["Mega|Ride"] = 615.29, ["Mega|Fly|Ride"] = 468.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.7, ["Ride"] = 51.25, ["Fly|Ride"] = 184.8, ["Neon"] = 121.25, ["Neon|Ride"] = 198.22, ["Neon|Fly|Ride"] = 315.91, ["Mega"] = 535, ["Mega|Ride"] = 619.42, ["Mega|Fly|Ride"] = 571.25}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 138.21, ["Fly"] = 150, ["Ride"] = 182.47, ["Fly|Ride"] = 233.53, ["Neon"] = 549, ["Neon|Fly"] = 662.3, ["Neon|Ride"] = 515.16, ["Neon|Fly|Ride"] = 612.4, ["Mega|Ride"] = 2477.66, ["Mega|Fly|Ride"] = 2181.95}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 7.85, ["Fly"] = 19.9, ["Ride"] = 20.27, ["Fly|Ride"] = 42.43, ["Neon"] = 46.26, ["Neon|Fly"] = 153.02, ["Neon|Ride"] = 46.73, ["Neon|Fly|Ride"] = 89.66, ["Mega|Ride"] = 350, ["Mega|Fly|Ride"] = 354.81}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.23, ["Fly"] = 124.98, ["Ride"] = 26.17, ["Fly|Ride"] = 62.5, ["Neon"] = 19.3, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 125, ["Mega"] = 152.23, ["Mega|Ride"] = 177.58, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.32, ["Fly"] = 40.74, ["Ride"] = 31.25, ["Fly|Ride"] = 86.25, ["Neon"] = 171.38, ["Neon|Fly"] = 122.5, ["Neon|Ride"] = 60, ["Neon|Fly|Ride"] = 165.19, ["Mega"] = 436.25, ["Mega|Ride"] = 394.67, ["Mega|Fly|Ride"] = 1245.03}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.75, ["Fly"] = 82.6, ["Ride"] = 43.66, ["Fly|Ride"] = 128.02, ["Neon"] = 187.5, ["Neon|Ride"] = 247.5, ["Neon|Fly|Ride"] = 289.07, ["Mega"] = 900, ["Mega|Ride"] = 881.25, ["Mega|Fly|Ride"] = 912.47}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20, ["Fly"] = 55, ["Ride"] = 69.18, ["Neon"] = 187.5, ["Neon|Ride"] = 439.79, ["Neon|Fly|Ride"] = 455.28, ["Mega"] = 770.91, ["Mega|Ride"] = 1840, ["Mega|Fly|Ride"] = 784.6}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 312.4, ["Ride"] = 551.29, ["Neon"] = 1558.21, ["Neon|Ride"] = 3115.23, ["Mega|Fly|Ride"] = 4955.31}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 22.59, ["Fly"] = 55.83, ["Ride"] = 27.86, ["Fly|Ride"] = 66.14, ["Neon"] = 123.75, ["Neon|Ride"] = 123.8, ["Neon|Fly|Ride"] = 189.96, ["Mega"] = 725, ["Mega|Ride"] = 717.4, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2, ["Fly"] = 41.29, ["Ride"] = 9.35, ["Fly|Ride"] = 69.18, ["Neon"] = 2, ["Neon|Ride"] = 12.86, ["Neon|Fly|Ride"] = 51.25, ["Mega"] = 20.88, ["Mega|Fly"] = 109.44, ["Mega|Ride"] = 47.41, ["Mega|Fly|Ride"] = 111.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.82, ["Ride"] = 27.88, ["Neon"] = 13.9, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 110.47, ["Mega|Ride"] = 156.35, ["Mega|Fly|Ride"] = 325}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.74, ["Fly"] = 31.25, ["Ride"] = 29.38, ["Fly|Ride"] = 137.33, ["Neon"] = 20.57, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 1124.98, ["Mega"] = 125.95, ["Mega|Ride"] = 359.26, ["Mega|Fly|Ride"] = 326.25}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 374.99, ["Fly"] = 481.25, ["Ride"] = 398.75, ["Fly|Ride"] = 526.25, ["Neon"] = 1808.08, ["Neon|Ride"] = 1928.45, ["Neon|Fly|Ride"] = 1187.5, ["Mega|Fly|Ride"] = 5366.18}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.34, ["Fly"] = 37.5, ["Ride"] = 16.19, ["Fly|Ride"] = 82.59, ["Neon"] = 19.61, ["Neon|Ride"] = 59.88, ["Neon|Fly|Ride"] = 99.9, ["Mega"] = 206.15, ["Mega|Ride"] = 203.75, ["Mega|Fly|Ride"] = 220}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6, ["Fly"] = 21.25, ["Ride"] = 18.7, ["Fly|Ride"] = 40.89, ["Neon"] = 36.9, ["Neon|Fly"] = 149, ["Neon|Ride"] = 55.76, ["Neon|Fly|Ride"] = 112.5, ["Mega"] = 172.88, ["Mega|Ride"] = 279.78, ["Mega|Fly|Ride"] = 303.12}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.14, ["Fly"] = 40, ["Ride"] = 24.99, ["Fly|Ride"] = 50.41, ["Neon"] = 12.4, ["Neon|Fly"] = 89.98, ["Neon|Ride"] = 40.13, ["Neon|Fly|Ride"] = 106.72, ["Mega"] = 138.35, ["Mega|Ride"] = 123.75, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 28.44, ["Fly"] = 46.73, ["Ride"] = 30, ["Fly|Ride"] = 75, ["Neon"] = 209.9, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 308.69, ["Mega"] = 1238.83, ["Mega|Ride"] = 821.25, ["Mega|Fly|Ride"] = 612.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2, ["Fly"] = 51.63, ["Ride"] = 48.75, ["Fly|Ride"] = 49.28, ["Neon"] = 11.15, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 200, ["Mega"] = 157.52, ["Mega|Ride"] = 435.99, ["Mega|Fly|Ride"] = 875.63}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.15, ["Fly"] = 62.49, ["Ride"] = 68.48, ["Fly|Ride"] = 97.05, ["Neon"] = 212.5, ["Neon|Ride"] = 206.48, ["Mega"] = 712.5, ["Mega|Fly|Ride"] = 751.56}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2, ["Ride"] = 28.75, ["Neon"] = 5.88, ["Neon|Ride"] = 24.69, ["Neon|Fly|Ride"] = 109.81, ["Mega"] = 52.48, ["Mega|Ride"] = 118.73, ["Mega|Fly|Ride"] = 237.5}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.75, ["Fly"] = 68.75, ["Ride"] = 32.01, ["Neon"] = 45.9, ["Mega"] = 129.54, ["Mega|Ride"] = 311.88}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.37, ["Ride"] = 35, ["Neon"] = 61.96, ["Neon|Ride"] = 275.65, ["Neon|Fly|Ride"] = 125, ["Mega"] = 304.56, ["Mega|Ride"] = 535.8, ["Mega|Fly|Ride"] = 441.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.89, ["Fly"] = 36.13, ["Ride"] = 23.36, ["Fly|Ride"] = 53.7, ["Neon"] = 39.14, ["Neon|Fly"] = 109.81, ["Neon|Ride"] = 53.62, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 515.16, ["Mega|Ride"] = 311.25, ["Mega|Fly|Ride"] = 415.55}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 399.53, ["Fly"] = 460.44, ["Ride"] = 410, ["Fly|Ride"] = 458.65, ["Neon"] = 1564.2, ["Neon|Ride"] = 1791.82, ["Neon|Fly|Ride"] = 1562.5, ["Mega|Fly|Ride"] = 7102.6}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2, ["Ride"] = 17.18, ["Fly|Ride"] = 37.49, ["Neon"] = 34.91, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 175.63, ["Mega"] = 220.93, ["Mega|Ride"] = 187.4, ["Mega|Fly|Ride"] = 293.2}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 8.73, ["Fly"] = 61.96, ["Ride"] = 61.96, ["Fly|Ride"] = 179.65, ["Neon"] = 98.74, ["Neon|Ride"] = 117.7, ["Neon|Fly|Ride"] = 437.5, ["Mega"] = 342.5, ["Mega|Ride"] = 400}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 23.4, ["Ride"] = 91.28, ["Fly|Ride"] = 225.64, ["Neon"] = 105.31, ["Neon|Ride"] = 203.75, ["Neon|Fly|Ride"] = 348.65, ["Mega"] = 309.71, ["Mega|Ride"] = 359.69, ["Mega|Fly|Ride"] = 462.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 50, ["Fly"] = 144.2, ["Ride"] = 80, ["Fly|Ride"] = 125, ["Neon"] = 306.24, ["Neon|Ride"] = 300, ["Neon|Fly|Ride"] = 362.5, ["Mega"] = 2397.39, ["Mega|Ride"] = 2753.2, ["Mega|Fly|Ride"] = 1707.48}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 8.79, ["Ride"] = 37.5, ["Fly|Ride"] = 137.5, ["Neon"] = 33.34, ["Neon|Ride"] = 94.99, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 157.29, ["Mega|Ride"] = 184.7, ["Mega|Fly|Ride"] = 385.47}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2, ["Fly"] = 20.66, ["Ride"] = 17.5, ["Fly|Ride"] = 55.11, ["Neon"] = 17.24, ["Neon|Ride"] = 31.93, ["Neon|Fly|Ride"] = 192.5, ["Mega"] = 62.49, ["Mega|Ride"] = 195.08, ["Mega|Fly|Ride"] = 249.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.19, ["Ride"] = 43.3, ["Neon"] = 18.73, ["Neon|Ride"] = 97.5, ["Neon|Fly|Ride"] = 166.25, ["Mega"] = 131.25, ["Mega|Ride"] = 117.7, ["Mega|Fly|Ride"] = 260.44}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 43.63, ["Fly"] = 174.99, ["Ride"] = 99.11, ["Fly|Ride"] = 188.74, ["Neon"] = 137.5, ["Neon|Ride"] = 153.65, ["Neon|Fly|Ride"] = 250, ["Mega"] = 420, ["Mega|Ride"] = 425.09, ["Mega|Fly|Ride"] = 545.5}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.5, ["Ride"] = 81.21, ["Neon"] = 8.63, ["Neon|Ride"] = 72.76, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 48.75, ["Mega|Ride"] = 172.41, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 20.57, ["Ride"] = 176.25, ["Neon"] = 153.75, ["Neon|Ride"] = 356.24, ["Mega"] = 598.75, ["Mega|Ride"] = 726.79, ["Mega|Fly|Ride"] = 729.89}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 906.23, ["Fly"] = 1137.5, ["Ride"] = 962.5, ["Fly|Ride"] = 968.73, ["Neon"] = 4129.42, ["Neon|Ride"] = 3000, ["Neon|Fly|Ride"] = 3508.98, ["Mega|Fly|Ride"] = 10571.31}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.18, ["Fly"] = 106.82, ["Ride"] = 41.3, ["Fly|Ride"] = 165.45, ["Neon"] = 61.25, ["Neon|Fly"] = 687.56, ["Neon|Ride"] = 167.4, ["Neon|Fly|Ride"] = 350, ["Mega"] = 247.5, ["Mega|Ride"] = 250, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2, ["Fly"] = 47.01, ["Ride"] = 26.86, ["Fly|Ride"] = 87.23, ["Neon"] = 12.43, ["Neon|Fly"] = 76.02, ["Neon|Ride"] = 29.99, ["Neon|Fly|Ride"] = 85, ["Mega"] = 75.89, ["Mega|Ride"] = 86.25, ["Mega|Fly|Ride"] = 308.69}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.74, ["Ride"] = 125, ["Fly|Ride"] = 138.35, ["Neon"] = 60, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 374.98, ["Mega"] = 274.98, ["Mega|Ride"] = 410.1, ["Mega|Fly|Ride"] = 880}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2, ["Ride"] = 22.27, ["Fly|Ride"] = 178.75, ["Neon"] = 2.49, ["Neon|Ride"] = 25, ["Neon|Fly|Ride"] = 91.25, ["Mega"] = 19.29, ["Mega|Ride"] = 45.59, ["Mega|Fly|Ride"] = 112.49}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 41.3, ["Fly"] = 123.89, ["Ride"] = 77.43, ["Fly|Ride"] = 253.75, ["Neon"] = 209.99, ["Neon|Ride"] = 247.5, ["Neon|Fly|Ride"] = 413.5, ["Mega"] = 898.14, ["Mega|Ride"] = 837.49, ["Mega|Fly|Ride"] = 881.25}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.39, ["Ride"] = 59.88, ["Fly|Ride"] = 272.92, ["Neon"] = 147.49, ["Neon|Ride"] = 136.28, ["Neon|Fly|Ride"] = 250, ["Mega"] = 398.75, ["Mega|Ride"] = 795.95, ["Mega|Fly|Ride"] = 774.28}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2, ["Ride"] = 22.09, ["Neon"] = 12.27, ["Neon|Ride"] = 38.63, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 93.45, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 358.24}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.28, ["Fly"] = 152.79, ["Ride"] = 37.98, ["Fly|Ride"] = 87.4, ["Neon"] = 75.08, ["Neon|Ride"] = 90.9, ["Neon|Fly|Ride"] = 258.16, ["Mega"] = 389.68, ["Mega|Ride"] = 399.99, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.55, ["Fly"] = 92.92, ["Ride"] = 25.49, ["Fly|Ride"] = 165.19, ["Neon"] = 25.74, ["Neon|Fly"] = 125, ["Neon|Ride"] = 55, ["Neon|Fly|Ride"] = 137.32, ["Mega"] = 412.95, ["Mega|Ride"] = 375, ["Mega|Fly|Ride"] = 410}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 40.28, ["Ride"] = 87.5, ["Neon"] = 241.59, ["Neon|Ride"] = 247.77, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 2203.05, ["Mega|Ride"] = 2336.14, ["Mega|Fly|Ride"] = 2062.66}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.25, ["Ride"] = 45.43, ["Fly|Ride"] = 118.75, ["Neon"] = 14.8, ["Neon|Ride"] = 70, ["Neon|Fly|Ride"] = 179.63, ["Mega"] = 64.86, ["Mega|Ride"] = 106.22, ["Mega|Fly|Ride"] = 225}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 4.59, ["Ride"] = 30.28, ["Fly|Ride"] = 86.25, ["Neon"] = 36.14, ["Neon|Fly"] = 179.63, ["Neon|Ride"] = 66.59, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 250, ["Mega|Ride"] = 328.3, ["Mega|Fly|Ride"] = 276.25}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115, ["Fly"] = 375, ["Ride"] = 149.99, ["Fly|Ride"] = 240.84, ["Neon"] = 456.25, ["Neon|Ride"] = 517.4, ["Neon|Fly|Ride"] = 606.07, ["Mega|Ride"] = 1747.58, ["Mega|Fly|Ride"] = 2038.33}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2, ["Fly"] = 22.27, ["Ride"] = 17.5, ["Fly|Ride"] = 41.25, ["Neon"] = 19.7, ["Neon|Fly"] = 54.49, ["Neon|Ride"] = 24.98, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 131.25, ["Mega|Ride"] = 233.62, ["Mega|Fly|Ride"] = 173.74}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 18.9, ["Fly"] = 81.25, ["Ride"] = 55.75, ["Fly|Ride"] = 125, ["Neon"] = 132.21, ["Neon|Ride"] = 166, ["Neon|Fly|Ride"] = 248.75, ["Mega"] = 551.29, ["Mega|Ride"] = 456.25, ["Mega|Fly|Ride"] = 673.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2, ["Fly"] = 17.5, ["Ride"] = 15, ["Fly|Ride"] = 56.25, ["Neon"] = 2, ["Neon|Fly"] = 27.26, ["Neon|Ride"] = 14.99, ["Neon|Fly|Ride"] = 43.64, ["Mega"] = 18.75, ["Mega|Ride"] = 32.37, ["Mega|Fly|Ride"] = 76.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2, ["Ride"] = 55.76, ["Neon"] = 2.5, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 123.89, ["Mega"] = 19.66, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 151.82}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2, ["Fly"] = 35.09, ["Ride"] = 18.75, ["Fly|Ride"] = 165.1, ["Neon"] = 14.18, ["Neon|Ride"] = 55.63, ["Neon|Fly|Ride"] = 116.66, ["Mega"] = 100, ["Mega|Ride"] = 304.56, ["Mega|Fly|Ride"] = 234.38}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 29.36, ["Ride"] = 61.96, ["Fly|Ride"] = 125, ["Neon"] = 126.23, ["Neon|Ride"] = 330.37, ["Neon|Fly|Ride"] = 400.12, ["Mega"] = 487.5, ["Mega|Ride"] = 618.39, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2, ["Fly"] = 16.53, ["Ride"] = 16.23, ["Fly|Ride"] = 35.1, ["Neon"] = 11.9, ["Neon|Fly"] = 25.71, ["Neon|Ride"] = 24.99, ["Neon|Fly|Ride"] = 65, ["Mega"] = 114.9, ["Mega|Fly"] = 254.49, ["Mega|Ride"] = 120, ["Mega|Fly|Ride"] = 138.35}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.37, ["Fly"] = 44.43, ["Ride"] = 39.24, ["Fly|Ride"] = 246.75, ["Neon"] = 54.31, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 52.32, ["Neon|Fly|Ride"] = 123.75, ["Mega"] = 275.65, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 335.52}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2, ["Fly"] = 15.91, ["Ride"] = 19.62, ["Fly|Ride"] = 64.68, ["Neon"] = 11.28, ["Neon|Fly"] = 93.73, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 62.5, ["Mega"] = 45, ["Mega|Fly"] = 209.9, ["Mega|Ride"] = 56.25, ["Mega|Fly|Ride"] = 136.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.25, ["Fly"] = 155.9, ["Ride"] = 23.74, ["Fly|Ride"] = 206.85, ["Neon"] = 35.89, ["Neon|Ride"] = 93.45, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 309.71, ["Mega|Fly"] = 381.25, ["Mega|Ride"] = 386.11, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5, ["Ride"] = 180.88, ["Fly|Ride"] = 135.62, ["Neon"] = 48.66, ["Neon|Ride"] = 138.35, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 212.49, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 450}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.13, ["Fly"] = 35.99, ["Ride"] = 24.92, ["Fly|Ride"] = 49.5, ["Neon"] = 30.9, ["Neon|Fly"] = 187.5, ["Neon|Ride"] = 37.58, ["Neon|Fly|Ride"] = 138.38, ["Mega"] = 250, ["Mega|Ride"] = 150, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2, ["Fly"] = 15.55, ["Ride"] = 14.9, ["Fly|Ride"] = 50.05, ["Neon"] = 12.4, ["Neon|Fly"] = 67.15, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 165.19, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 205.45}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 187.4, ["Fly"] = 375, ["Ride"] = 247.77, ["Fly|Ride"] = 373.75, ["Neon"] = 1225.41, ["Neon|Ride"] = 1196.51, ["Neon|Fly|Ride"] = 1118.75, ["Mega"] = 4049.68, ["Mega|Fly|Ride"] = 3921.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.45, ["Ride"] = 100, ["Neon"] = 32.73, ["Neon|Ride"] = 43.75, ["Mega"] = 117.5, ["Mega|Ride"] = 623.75, ["Mega|Fly|Ride"] = 499.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.39, ["Fly"] = 103.24, ["Ride"] = 23.75, ["Fly|Ride"] = 82.6, ["Neon"] = 29.71, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 62.5, ["Neon|Fly|Ride"] = 250, ["Mega"] = 222.52, ["Mega|Ride"] = 187.49, ["Mega|Fly|Ride"] = 499.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.62, ["Fly|Ride"] = 206.48, ["Neon"] = 40.58, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 574.99, ["Mega"] = 463.13, ["Mega|Ride"] = 390.14, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2, ["Fly"] = 15.4, ["Ride"] = 13.75, ["Fly|Ride"] = 32.01, ["Neon"] = 2, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 14.38, ["Neon|Fly|Ride"] = 40.28, ["Mega"] = 18.08, ["Mega|Ride"] = 35.11, ["Mega|Fly|Ride"] = 68.74}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.35, ["Fly"] = 42.74, ["Ride"] = 21.78, ["Fly|Ride"] = 54.91, ["Neon"] = 16.84, ["Neon|Ride"] = 32.5, ["Neon|Fly|Ride"] = 85, ["Mega"] = 126.25, ["Mega|Ride"] = 150.74, ["Mega|Fly|Ride"] = 187.4}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.4, ["Ride"] = 114.14, ["Neon"] = 9.74, ["Neon|Ride"] = 274.61, ["Neon|Fly|Ride"] = 375, ["Mega"] = 50, ["Mega|Fly"] = 138.35, ["Mega|Ride"] = 159.99, ["Mega|Fly|Ride"] = 263.75}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75, ["Fly"] = 99.99, ["Ride"] = 107.5, ["Fly|Ride"] = 143.81, ["Neon"] = 300, ["Neon|Fly"] = 623.75, ["Neon|Ride"] = 351.25, ["Neon|Fly|Ride"] = 449.08, ["Mega|Ride"] = 3442.91, ["Mega|Fly|Ride"] = 1625}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.98, ["Fly"] = 69.18, ["Ride"] = 27.5, ["Fly|Ride"] = 134.99, ["Neon"] = 20.9, ["Neon|Ride"] = 64.91, ["Mega"] = 161.23, ["Mega|Ride"] = 203.75}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2, ["Fly"] = 47.5, ["Ride"] = 32.5, ["Neon"] = 6.8, ["Neon|Ride"] = 78.27, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 53.12, ["Mega|Fly"] = 299.99, ["Mega|Ride"] = 120, ["Mega|Fly|Ride"] = 350}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 47.49, ["Fly"] = 125, ["Ride"] = 86.49, ["Fly|Ride"] = 169.92, ["Neon"] = 138.35, ["Neon|Ride"] = 169.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 512.5, ["Mega|Ride"] = 575, ["Mega|Fly|Ride"] = 675}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2, ["Fly"] = 15, ["Ride"] = 15.5, ["Fly|Ride"] = 30.99, ["Neon"] = 2, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 15.5, ["Neon|Fly|Ride"] = 32.5, ["Mega"] = 16.15, ["Mega|Ride"] = 32.5, ["Mega|Fly|Ride"] = 60.02}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2, ["Ride"] = 56.79, ["Fly|Ride"] = 88.8, ["Neon"] = 2, ["Neon|Ride"] = 28.64, ["Neon|Fly|Ride"] = 108.67, ["Mega"] = 22.42, ["Mega|Ride"] = 74.9, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.39, ["Ride"] = 69.18, ["Fly|Ride"] = 153.75, ["Neon"] = 7.73, ["Neon|Ride"] = 116.25, ["Neon|Fly|Ride"] = 274.9, ["Mega"] = 56.25, ["Mega|Ride"] = 119.81}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.17, ["Fly"] = 82.53, ["Ride"] = 51.52, ["Fly|Ride"] = 138.35, ["Neon"] = 24.96, ["Neon|Fly"] = 170.55, ["Neon|Ride"] = 96.25, ["Neon|Fly|Ride"] = 152.08, ["Mega"] = 204.33, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 312.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2, ["Fly"] = 20.57, ["Ride"] = 12.75, ["Fly|Ride"] = 43.37, ["Neon"] = 2, ["Neon|Fly"] = 23.67, ["Neon|Ride"] = 21.25, ["Neon|Fly|Ride"] = 50, ["Mega"] = 18.12, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 112.19}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.53, ["Fly"] = 125, ["Ride"] = 50.73, ["Neon"] = 123.64, ["Neon|Ride"] = 192.92, ["Neon|Fly|Ride"] = 356.25, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 762.91}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2426.04, ["Fly"] = 3000, ["Ride"] = 2118.75, ["Fly|Ride"] = 2110, ["Neon|Fly|Ride"] = 7062.5, ["Mega|Fly|Ride"] = 42842.69}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2, ["Fly"] = 43.73, ["Ride"] = 16.43, ["Fly|Ride"] = 64.01, ["Neon"] = 8.65, ["Neon|Fly"] = 55.67, ["Neon|Ride"] = 26.83, ["Neon|Fly|Ride"] = 60.62, ["Mega"] = 137.5, ["Mega|Ride"] = 117.4, ["Mega|Fly|Ride"] = 143.54}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2, ["Ride"] = 26.86, ["Neon"] = 8.4, ["Mega"] = 98.85, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 467.24}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.9, ["Fly"] = 100, ["Ride"] = 32.01, ["Fly|Ride"] = 150, ["Neon"] = 78.28, ["Neon|Ride"] = 115, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 411.25, ["Mega|Ride"] = 386.11, ["Mega|Fly|Ride"] = 654.12}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 34.63, ["Fly"] = 103.24, ["Ride"] = 63.66, ["Fly|Ride"] = 49.06, ["Neon"] = 133.75, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 515.91, ["Mega|Ride"] = 590.52, ["Mega|Fly|Ride"] = 622.5}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 132.16, ["Fly"] = 1377.18, ["Ride"] = 175, ["Fly|Ride"] = 231.25, ["Neon"] = 616.25, ["Neon|Ride"] = 722.81, ["Neon|Fly|Ride"] = 750, ["Mega"] = 6194.13, ["Mega|Fly|Ride"] = 3975}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.23, ["Ride"] = 62.41, ["Fly|Ride"] = 643.75, ["Neon"] = 25, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 249.99, ["Mega"] = 137.57, ["Mega|Fly|Ride"] = 412.95}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2, ["Ride"] = 35.11, ["Neon"] = 14.45, ["Neon|Fly"] = 89.82, ["Neon|Ride"] = 109.38, ["Neon|Fly|Ride"] = 187.5, ["Mega"] = 171.25, ["Mega|Ride"] = 314.9, ["Mega|Fly|Ride"] = 254.37}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2, ["Fly"] = 97.04, ["Ride"] = 31.9, ["Fly|Ride"] = 69.18, ["Neon"] = 10.99, ["Neon|Fly"] = 121.82, ["Neon|Ride"] = 35, ["Mega"] = 58.75, ["Mega|Ride"] = 117.5, ["Mega|Fly|Ride"] = 218.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.75, ["Ride"] = 67.37, ["Fly|Ride"] = 125, ["Neon"] = 116.03, ["Neon|Ride"] = 170.55, ["Neon|Fly|Ride"] = 486.25, ["Mega"] = 400, ["Mega|Ride"] = 309.71, ["Mega|Fly|Ride"] = 563.13}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2, ["Neon"] = 2.49, ["Neon|Ride"] = 27.88, ["Mega"] = 33.75, ["Mega|Ride"] = 81.23, ["Mega|Fly|Ride"] = 128.75}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.74, ["Fly"] = 193.06, ["Ride"] = 121.25, ["Fly|Ride"] = 131.15, ["Neon"] = 259.13, ["Neon|Fly"] = 441.86, ["Neon|Ride"] = 387.98, ["Neon|Fly|Ride"] = 350, ["Mega"] = 3097.07, ["Mega|Fly|Ride"] = 1237.81}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2, ["Fly"] = 43.37, ["Ride"] = 87.46, ["Neon"] = 9.59, ["Neon|Ride"] = 137.76, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 59.4, ["Mega|Ride"] = 274.61, ["Mega|Fly|Ride"] = 299.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.9, ["Fly"] = 138.35, ["Ride"] = 75, ["Fly|Ride"] = 161.25, ["Neon"] = 218.15, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 373.75, ["Mega"] = 2500, ["Mega|Ride"] = 2064.71}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2, ["Fly"] = 61.25, ["Ride"] = 20.57, ["Fly|Ride"] = 50.23, ["Neon"] = 4.69, ["Neon|Fly"] = 81.77, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 58.75, ["Mega|Ride"] = 98.75, ["Mega|Fly|Ride"] = 187.4}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2, ["Neon"] = 8.27, ["Neon|Ride"] = 110, ["Mega"] = 138.35, ["Mega|Ride"] = 165.19, ["Mega|Fly|Ride"] = 386.11}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.3, ["Fly"] = 73.74, ["Ride"] = 32.01, ["Fly|Ride"] = 86.25, ["Neon"] = 24.25, ["Neon|Ride"] = 69.01, ["Neon|Fly|Ride"] = 118.73, ["Mega"] = 395.4, ["Mega|Ride"] = 275, ["Mega|Fly|Ride"] = 516.18}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 345.82, ["Fly"] = 700.85, ["Ride"] = 400, ["Fly|Ride"] = 607.4, ["Neon"] = 981.78, ["Neon|Ride"] = 925, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 2977.32, ["Mega|Ride"] = 2981.25, ["Mega|Fly|Ride"] = 4088.13}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.71, ["Fly"] = 82.6, ["Ride"] = 44.91, ["Fly|Ride"] = 102.22, ["Neon"] = 147.17, ["Neon|Ride"] = 150.74, ["Neon|Fly|Ride"] = 272.5, ["Mega|Ride"] = 1179.99, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 3.23, ["Fly"] = 58.68, ["Ride"] = 30.29, ["Fly|Ride"] = 116.4, ["Neon"] = 23.51, ["Neon|Fly"] = 81.25, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 124.81, ["Mega"] = 150.74, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 299.99}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 24.18, ["Fly"] = 124.9, ["Ride"] = 59.19, ["Fly|Ride"] = 142.5, ["Neon"] = 74.87, ["Neon|Fly"] = 168.75, ["Neon|Ride"] = 152.4, ["Neon|Fly|Ride"] = 206.48, ["Mega"] = 412.95, ["Mega|Ride"] = 495.54, ["Mega|Fly|Ride"] = 485}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.56, ["Ride"] = 22.48, ["Neon"] = 96.53, ["Neon|Ride"] = 130.09, ["Neon|Fly|Ride"] = 467.24, ["Mega"] = 623.75, ["Mega|Ride"] = 650, ["Mega|Fly|Ride"] = 296.25}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.6, ["Neon"] = 4.14, ["Neon|Ride"] = 150, ["Mega"] = 88.78, ["Mega|Ride"] = 316.94, ["Mega|Fly|Ride"] = 411.92}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.05, ["Fly"] = 69.18, ["Ride"] = 21.25, ["Fly|Ride"] = 59.97, ["Neon"] = 54.91, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 109.44, ["Neon|Fly|Ride"] = 202.03, ["Mega"] = 206.25, ["Mega|Ride"] = 463.75, ["Mega|Fly|Ride"] = 1250}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97, ["Fly"] = 233.63, ["Ride"] = 100.63, ["Fly|Ride"] = 218.44, ["Neon"] = 455.28, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 499.98, ["Mega"] = 2750, ["Mega|Ride"] = 2500, ["Mega|Fly|Ride"] = 3115.23}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 17.7, ["Ride"] = 52.91, ["Fly|Ride"] = 137.74, ["Neon"] = 149.88, ["Neon|Ride"] = 165.19, ["Mega"] = 1101.53, ["Mega|Ride"] = 799.05, ["Mega|Fly|Ride"] = 779.11}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1937.49, ["Fly"] = 2064.71, ["Ride"] = 1875, ["Fly|Ride"] = 1800, ["Neon"] = 11012.13, ["Neon|Fly|Ride"] = 6193.1, ["Mega|Fly|Ride"] = 23500}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.65, ["Fly"] = 62500, ["Ride"] = 22.9, ["Fly|Ride"] = 187.49, ["Neon"] = 21.16, ["Neon|Ride"] = 62.5, ["Mega"] = 148.74, ["Mega|Fly"] = 748.75, ["Mega|Ride"] = 198.22, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.05, ["Ride"] = 55.76, ["Fly|Ride"] = 125, ["Neon"] = 23.41, ["Neon|Ride"] = 85.6, ["Neon|Fly|Ride"] = 220.93, ["Mega"] = 137.49, ["Mega|Fly"] = 275.65, ["Mega|Ride"] = 218.87, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 837.5, ["Fly"] = 1431.88, ["Ride"] = 908.75, ["Fly|Ride"] = 954.9, ["Neon"] = 3115.23, ["Neon|Ride"] = 2450.24, ["Neon|Fly|Ride"] = 2962.5, ["Mega|Ride"] = 13238.83, ["Mega|Fly|Ride"] = 13613.66}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 22.9, ["Ride"] = 50, ["Fly|Ride"] = 165.09, ["Neon"] = 227.5, ["Neon|Ride"] = 311.88, ["Mega"] = 816.38, ["Mega|Ride"] = 810.64, ["Mega|Fly|Ride"] = 795.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.15, ["Ride"] = 20.75, ["Fly|Ride"] = 112.5, ["Neon"] = 11.71, ["Neon|Ride"] = 61.75, ["Neon|Fly|Ride"] = 205.45, ["Mega"] = 150, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2, ["Fly"] = 50, ["Ride"] = 138.35, ["Neon"] = 3.75, ["Neon|Fly"] = 120, ["Neon|Ride"] = 46.91, ["Neon|Fly|Ride"] = 107.38, ["Mega"] = 22.11, ["Mega|Ride"] = 58.39, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.46, ["Ride"] = 120.73, ["Fly|Ride"] = 162.5, ["Neon"] = 437.5, ["Neon|Ride"] = 437.5, ["Neon|Fly|Ride"] = 610, ["Mega"] = 2336.14, ["Mega|Fly|Ride"] = 2271.19}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2, ["Ride"] = 33.04, ["Fly|Ride"] = 72.27, ["Neon"] = 11.15, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 125, ["Mega"] = 86.24, ["Mega|Ride"] = 116.15, ["Mega|Fly|Ride"] = 237.68}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 74.91, ["Fly"] = 138.35, ["Ride"] = 97.23, ["Fly|Ride"] = 275.65, ["Neon"] = 412.95, ["Neon|Ride"] = 687.5, ["Mega"] = 1341.04, ["Mega|Fly|Ride"] = 1684.35}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.09, ["Fly"] = 100, ["Fly|Ride"] = 123.89, ["Neon"] = 56.25, ["Neon|Ride"] = 112.5, ["Neon|Fly|Ride"] = 256.24, ["Mega"] = 312.4, ["Mega|Ride"] = 138.35}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 250, ["Ride"] = 267.39, ["Fly|Ride"] = 306.25, ["Neon"] = 928.1, ["Neon|Ride"] = 878.55, ["Neon|Fly|Ride"] = 718.03, ["Mega|Fly|Ride"] = 3713.86}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.4, ["Fly"] = 50.75, ["Ride"] = 22.35, ["Fly|Ride"] = 110.38, ["Neon"] = 58.26, ["Neon|Ride"] = 62.41, ["Neon|Fly|Ride"] = 108.75, ["Mega|Ride"] = 249.98, ["Mega|Fly|Ride"] = 278.9}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2, ["Fly"] = 22.1, ["Ride"] = 15.75, ["Fly|Ride"] = 39.15, ["Neon"] = 5.48, ["Neon|Fly"] = 36.16, ["Neon|Ride"] = 23.74, ["Neon|Fly|Ride"] = 57.5, ["Mega"] = 46.24, ["Mega|Ride"] = 68.43, ["Mega|Fly|Ride"] = 120}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1189.28, ["Ride"] = 1000, ["Fly|Ride"] = 1195, ["Neon|Ride"] = 7571.29, ["Neon|Fly|Ride"] = 6710.31, ["Mega"] = 23361.24}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.33, ["Ride"] = 68.75, ["Neon"] = 98.62, ["Neon|Ride"] = 299.98, ["Mega"] = 300, ["Mega|Ride"] = 414.34, ["Mega|Fly|Ride"] = 537.4}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.61, ["Fly"] = 52.28, ["Ride"] = 41.25, ["Fly|Ride"] = 76.9, ["Neon"] = 23.64, ["Neon|Fly"] = 98.09, ["Neon|Ride"] = 52.89, ["Neon|Fly|Ride"] = 122.86, ["Mega"] = 170.9, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 269.6}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.88, ["Fly"] = 37.95, ["Ride"] = 38.45, ["Fly|Ride"] = 76.25, ["Neon"] = 186.8, ["Neon|Ride"] = 200.29, ["Neon|Fly|Ride"] = 181.87, ["Mega"] = 2477.66, ["Mega|Ride"] = 1090.98, ["Mega|Fly|Ride"] = 625}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 68.14, ["Ride"] = 28.75, ["Fly|Ride"] = 94.98, ["Neon"] = 56.25, ["Neon|Ride"] = 84.02, ["Neon|Fly|Ride"] = 250, ["Mega"] = 350, ["Mega|Ride"] = 268.75, ["Mega|Fly|Ride"] = 411.15}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 61.78, ["Fly|Ride"] = 515.16, ["Neon"] = 237.4, ["Neon|Fly"] = 466.63, ["Neon|Ride"] = 412.95, ["Mega"] = 3716.48, ["Mega|Fly|Ride"] = 920}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2, ["Ride"] = 111.05, ["Fly|Ride"] = 275.65, ["Neon"] = 2.49, ["Neon|Fly"] = 52.1, ["Neon|Ride"] = 106.51, ["Neon|Fly|Ride"] = 103.24, ["Mega"] = 16.14, ["Mega|Ride"] = 137.5, ["Mega|Fly|Ride"] = 193.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 94.99, ["Fly"] = 118.58, ["Ride"] = 118.65, ["Fly|Ride"] = 168.75, ["Neon"] = 545.73, ["Neon|Fly"] = 467.5, ["Neon|Ride"] = 465.61, ["Neon|Fly|Ride"] = 562.49, ["Mega"] = 2064.71, ["Mega|Fly|Ride"] = 1687.5}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2, ["Fly"] = 102.5, ["Ride"] = 30.38, ["Fly|Ride"] = 63.5, ["Neon"] = 188.75, ["Neon|Ride"] = 79.99, ["Mega"] = 736.86, ["Mega|Ride"] = 420.51, ["Mega|Fly|Ride"] = 467.5}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2, ["Fly"] = 31.25, ["Ride"] = 17.5, ["Fly|Ride"] = 37.46, ["Neon"] = 49.99, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 82.6, ["Neon|Fly|Ride"] = 117, ["Mega|Ride"] = 261.97, ["Mega|Fly|Ride"] = 256.25}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2, ["Ride"] = 120, ["Neon"] = 18.59, ["Neon|Fly"] = 136.28, ["Neon|Ride"] = 75, ["Neon|Fly|Ride"] = 204.53}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 82.4, ["Ride"] = 187.5, ["Fly|Ride"] = 394.37, ["Neon"] = 395, ["Neon|Fly"] = 625, ["Neon|Ride"] = 516.18, ["Neon|Fly|Ride"] = 750, ["Mega"] = 2100, ["Mega|Ride"] = 1600, ["Mega|Fly|Ride"] = 1600}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.6, ["Fly|Ride"] = 412.95, ["Neon"] = 19.32, ["Neon|Ride"] = 56.25, ["Mega"] = 109.81, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2, ["Ride"] = 35.99, ["Neon"] = 2, ["Neon|Ride"] = 97.05, ["Mega"] = 16.25, ["Mega|Ride"] = 200.19, ["Mega|Fly|Ride"] = 516.18}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2, ["Fly"] = 98.03, ["Ride"] = 31.25, ["Fly|Ride"] = 137.56, ["Neon"] = 3.6, ["Neon|Fly"] = 82.09, ["Neon|Ride"] = 30, ["Neon|Fly|Ride"] = 125, ["Mega"] = 20.57, ["Mega|Ride"] = 42.24, ["Mega|Fly|Ride"] = 152.79}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2, ["Fly"] = 34.99, ["Ride"] = 17.5, ["Fly|Ride"] = 49.97, ["Neon"] = 5.59, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 48.5, ["Mega"] = 60, ["Mega|Ride"] = 97.05, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2, ["Ride"] = 27.5, ["Fly|Ride"] = 109.99, ["Neon"] = 23.2, ["Neon|Ride"] = 109.81, ["Mega"] = 112.49, ["Mega|Ride"] = 117.7, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2, ["Fly"] = 37.48, ["Ride"] = 16.43, ["Fly|Ride"] = 35.21, ["Neon"] = 15.29, ["Neon|Fly"] = 82.6, ["Neon|Ride"] = 36.22, ["Neon|Fly|Ride"] = 97.05, ["Mega"] = 175, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.5, ["Ride"] = 105, ["Neon"] = 311.88, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 1032.36, ["Mega"] = 625, ["Mega|Ride"] = 618.39, ["Mega|Fly|Ride"] = 1090.98}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2, ["Fly"] = 16.25, ["Ride"] = 16.25, ["Fly|Ride"] = 39.88, ["Neon"] = 2, ["Neon|Fly"] = 30.8, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 41.25, ["Mega"] = 18.75, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 95.12}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.12, ["Fly"] = 27.5, ["Ride"] = 31.04, ["Fly|Ride"] = 67.51, ["Neon"] = 51.63, ["Neon|Fly"] = 84.67, ["Neon|Ride"] = 62.42, ["Neon|Fly|Ride"] = 126.42, ["Mega"] = 287.49, ["Mega|Ride"] = 312.5, ["Mega|Fly|Ride"] = 241.28}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.59, ["Fly"] = 27.88, ["Ride"] = 48.9, ["Fly|Ride"] = 106.25, ["Neon"] = 137.57, ["Neon|Fly"] = 140, ["Neon|Ride"] = 118.55, ["Neon|Fly|Ride"] = 193.74, ["Mega"] = 688.59, ["Mega|Ride"] = 686.83, ["Mega|Fly|Ride"] = 537.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.42, ["Fly"] = 187.5, ["Fly|Ride"] = 64.01, ["Neon"] = 78.8, ["Neon|Ride"] = 98.75, ["Neon|Fly|Ride"] = 140.18, ["Mega"] = 511.42, ["Mega|Ride"] = 633.87, ["Mega|Fly|Ride"] = 685.5}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2, ["Fly"] = 20, ["Ride"] = 16.24, ["Fly|Ride"] = 32.5, ["Neon"] = 4.84, ["Neon|Fly"] = 26.77, ["Neon|Ride"] = 22.5, ["Neon|Fly|Ride"] = 66.24, ["Mega"] = 43.53, ["Mega|Ride"] = 58.75, ["Mega|Fly|Ride"] = 116.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 6.63, ["Fly"] = 50, ["Ride"] = 36.25, ["Neon"] = 71.21, ["Neon|Ride"] = 128.02, ["Neon|Fly|Ride"] = 1112.5, ["Mega"] = 306.25, ["Mega|Ride"] = 502.76, ["Mega|Fly|Ride"] = 535.8}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 921.49, ["Fly"] = 1213.02, ["Ride"] = 960, ["Fly|Ride"] = 1062.5, ["Neon"] = 2500, ["Neon|Fly"] = 2735.75, ["Neon|Ride"] = 2613.75, ["Neon|Fly|Ride"] = 2304.99, ["Mega|Fly|Ride"] = 6856.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 181.25, ["Ride"] = 250, ["Fly|Ride"] = 375, ["Neon"] = 800, ["Neon|Ride"] = 875, ["Neon|Fly|Ride"] = 986.95, ["Mega"] = 3096.03, ["Mega|Ride"] = 3579.18, ["Mega|Fly|Ride"] = 3028.93}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2, ["Ride"] = 25, ["Fly|Ride"] = 373.75, ["Neon"] = 7.22, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 246.75, ["Mega"] = 74.77, ["Mega|Fly|Ride"] = 205.45}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 118.75, ["Fly"] = 125, ["Ride"] = 187.29, ["Fly|Ride"] = 344.57, ["Neon"] = 551.29, ["Neon|Ride"] = 500, ["Neon|Fly|Ride"] = 731.39, ["Mega"] = 2271.19, ["Mega|Ride"] = 2271.19, ["Mega|Fly|Ride"] = 1812.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.31, ["Ride"] = 21.5, ["Neon"] = 13.2, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 275.65, ["Mega"] = 110.43, ["Mega|Ride"] = 467.24, ["Mega|Fly|Ride"] = 250}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 212.49, ["Fly"] = 274.61, ["Ride"] = 276.25, ["Fly|Ride"] = 375, ["Neon|Ride"] = 1362.72, ["Neon|Fly|Ride"] = 1237.81, ["Mega|Fly|Ride"] = 4672.26}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2, ["Fly"] = 73.5, ["Ride"] = 40.28, ["Fly|Ride"] = 212.61, ["Neon"] = 22.72, ["Neon|Ride"] = 51.78, ["Mega"] = 374.99, ["Mega|Fly"] = 345.84, ["Mega|Ride"] = 150}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2, ["Fly"] = 27.88, ["Ride"] = 35.06, ["Neon"] = 40.32, ["Mega"] = 237.5, ["Mega|Ride"] = 250}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 22.22, ["Ride"] = 64.22, ["Fly|Ride"] = 136.28, ["Neon"] = 117.7, ["Neon|Fly"] = 412.95, ["Neon|Ride"] = 118.75, ["Neon|Fly|Ride"] = 250, ["Mega"] = 746.4, ["Mega|Ride"] = 687.5, ["Mega|Fly|Ride"] = 825.89}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2, ["Ride"] = 47.39, ["Fly|Ride"] = 43.75, ["Neon"] = 20.66, ["Neon|Ride"] = 187.5, ["Mega"] = 233.63, ["Mega|Ride"] = 244.94, ["Mega|Fly|Ride"] = 375}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2, ["Fly"] = 15.31, ["Ride"] = 13.61, ["Fly|Ride"] = 37.39, ["Neon"] = 2.5, ["Neon|Fly"] = 19.8, ["Neon|Ride"] = 18.59, ["Neon|Fly|Ride"] = 42.43, ["Mega"] = 24.79, ["Mega|Ride"] = 37.03, ["Mega|Fly|Ride"] = 68.9}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5161.78, ["Ride"] = 4248.75, ["Fly|Ride"] = 4907.5, ["Neon"] = 30970.62, ["Neon|Fly|Ride"] = 18582.38, ["Mega|Fly|Ride"] = 50000}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.87, ["Fly"] = 82.6, ["Ride"] = 39.91, ["Neon"] = 82.17, ["Neon|Fly"] = 367.53, ["Neon|Ride"] = 101.25, ["Neon|Fly|Ride"] = 156.53, ["Mega"] = 200, ["Mega|Fly"] = 330.37, ["Mega|Ride"] = 204.9, ["Mega|Fly|Ride"] = 399.53}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.4, ["Fly"] = 23.52, ["Ride"] = 18.65, ["Fly|Ride"] = 44.98, ["Neon"] = 17.14, ["Neon|Fly"] = 43.74, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 87.5, ["Mega"] = 125, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 180.67}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 400.11, ["Fly"] = 515.16, ["Ride"] = 425, ["Fly|Ride"] = 547.5, ["Neon"] = 2000, ["Neon|Ride"] = 1231.25, ["Neon|Fly|Ride"] = 1275, ["Mega|Fly|Ride"] = 4641.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.1, ["Ride"] = 46.73, ["Neon"] = 12.79, ["Neon|Ride"] = 277.5, ["Mega"] = 179, ["Mega|Fly|Ride"] = 660}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.15, ["Fly"] = 138.75, ["Ride"] = 125, ["Neon"] = 17.53, ["Neon|Ride"] = 47.5, ["Neon|Fly|Ride"] = 218.75, ["Mega"] = 390.14, ["Mega|Ride"] = 344.82}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2, ["Fly"] = 48.75, ["Ride"] = 18.52, ["Fly|Ride"] = 62.5, ["Neon"] = 6.76, ["Neon|Fly"] = 118.75, ["Neon|Ride"] = 35.06, ["Neon|Fly|Ride"] = 87.37, ["Mega"] = 43.89, ["Mega|Ride"] = 73.74, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 606.24, ["Fly"] = 721.63, ["Ride"] = 688, ["Fly|Ride"] = 702.92, ["Neon|Ride"] = 2025, ["Neon|Fly|Ride"] = 1999.99, ["Mega|Fly|Ride"] = 10323.54}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.56, ["Ride"] = 72.73, ["Fly|Ride"] = 138.25, ["Neon"] = 31.25, ["Neon|Fly"] = 312.49, ["Neon|Ride"] = 99.99, ["Neon|Fly|Ride"] = 205.45, ["Mega"] = 231.25, ["Mega|Ride"] = 220.93, ["Mega|Fly|Ride"] = 367.43}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5, ["Fly"] = 225, ["Ride"] = 36.25, ["Fly|Ride"] = 123.75, ["Neon"] = 50, ["Neon|Ride"] = 56.94, ["Neon|Fly|Ride"] = 143.75, ["Mega"] = 161.25, ["Mega|Ride"] = 170, ["Mega|Fly|Ride"] = 258.1}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.25, ["Fly"] = 32.5, ["Ride"] = 19.8, ["Fly|Ride"] = 39.97, ["Neon"] = 62.5, ["Neon|Fly"] = 190, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 79, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.9, ["Fly"] = 37.5, ["Ride"] = 32.01, ["Fly|Ride"] = 62.5, ["Neon"] = 97.05, ["Neon|Ride"] = 108.74, ["Mega"] = 825.89, ["Mega|Ride"] = 592.5, ["Mega|Fly|Ride"] = 823.83}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2, ["Ride"] = 41.24, ["Fly|Ride"] = 78.27, ["Neon"] = 3.5, ["Neon|Ride"] = 31.25, ["Neon|Fly|Ride"] = 198.75, ["Mega"] = 28.75, ["Mega|Ride"] = 69.18, ["Mega|Fly|Ride"] = 323.75}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 546.25, ["Fly"] = 618.39, ["Ride"] = 600.18, ["Fly|Ride"] = 600, ["Neon"] = 2466.25, ["Neon|Ride"] = 2669.67, ["Neon|Fly|Ride"] = 2277.5, ["Mega|Ride"] = 9110.89, ["Mega|Fly|Ride"] = 7487.5}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.04, ["Ride"] = 63.08, ["Neon"] = 12.29, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 213.75, ["Mega"] = 63.75, ["Mega|Ride"] = 138.35, ["Mega|Fly|Ride"] = 455.28}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2, ["Ride"] = 46.72, ["Neon"] = 4.14, ["Neon|Fly"] = 234.35, ["Neon|Ride"] = 210.26, ["Neon|Fly|Ride"] = 250, ["Mega"] = 51.63, ["Mega|Fly|Ride"] = 275.65}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2, ["Ride"] = 57.57, ["Neon"] = 4.14, ["Neon|Ride"] = 53.49, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 41.3, ["Mega|Ride"] = 120.8, ["Mega|Fly|Ride"] = 179.63}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2, ["Ride"] = 25, ["Neon"] = 13.75, ["Neon|Ride"] = 46.63, ["Mega"] = 226.09, ["Mega|Ride"] = 312.5}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 24.65, ["Fly"] = 68.75, ["Ride"] = 54.9, ["Fly|Ride"] = 137.5, ["Neon"] = 119, ["Neon|Ride"] = 187.5, ["Neon|Fly|Ride"] = 374.99, ["Mega"] = 472.97, ["Mega|Ride"] = 498.26, ["Mega|Fly|Ride"] = 535.23}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 12.24, ["Ride"] = 53.54, ["Fly|Ride"] = 146.61, ["Neon"] = 81.8, ["Neon|Ride"] = 119.99, ["Neon|Fly|Ride"] = 270, ["Mega"] = 515.16, ["Mega|Ride"] = 424.37, ["Mega|Fly|Ride"] = 548.31}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2, ["Fly"] = 21.25, ["Ride"] = 16.15, ["Fly|Ride"] = 33.74, ["Neon"] = 30, ["Neon|Ride"] = 31.15, ["Neon|Fly|Ride"] = 82.48, ["Mega"] = 391.27, ["Mega|Ride"] = 275.65, ["Mega|Fly|Ride"] = 228.15}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 13.75, ["Ride"] = 74.98, ["Fly|Ride"] = 137.84, ["Neon"] = 36.24, ["Neon|Ride"] = 87.5, ["Mega|Ride"] = 536.84}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2, ["Ride"] = 23.75, ["Fly|Ride"] = 104.28, ["Neon"] = 11.23, ["Neon|Ride"] = 48.53, ["Neon|Fly|Ride"] = 138.35, ["Mega"] = 78.63, ["Mega|Ride"] = 110, ["Mega|Fly|Ride"] = 288.03}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 22.42, ["Fly"] = 109.81, ["Ride"] = 29.57, ["Fly|Ride"] = 51.25, ["Neon"] = 105, ["Neon|Ride"] = 137.5, ["Neon|Fly|Ride"] = 202.35, ["Mega"] = 717.5, ["Mega|Fly|Ride"] = 721.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 31.83, ["Fly"] = 832.5, ["Neon"] = 127.5, ["Mega"] = 316.25, ["Mega|Ride"] = 562.5, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.74, ["Fly"] = 82.5, ["Ride"] = 67.2, ["Fly|Ride"] = 138.35, ["Neon"] = 312.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 411.25, ["Mega"] = 1867.74, ["Mega|Fly|Ride"] = 1237.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 37.27, ["Fly"] = 138.35, ["Ride"] = 60, ["Fly|Ride"] = 212.5, ["Neon"] = 122.41, ["Neon|Ride"] = 150, ["Neon|Fly|Ride"] = 295, ["Mega"] = 568.84, ["Mega|Ride"] = 1930, ["Mega|Fly|Ride"] = 881.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.9, ["Ride"] = 35.11, ["Neon"] = 132.5, ["Neon|Ride"] = 212.49, ["Mega"] = 1000, ["Mega|Ride"] = 625, ["Mega|Fly|Ride"] = 780.48}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 24.87, ["Fly"] = 121.17, ["Ride"] = 87.49, ["Fly|Ride"] = 183.77, ["Neon"] = 138.35, ["Neon|Fly"] = 400, ["Neon|Ride"] = 250, ["Neon|Fly|Ride"] = 427.32, ["Mega"] = 644.48, ["Mega|Ride"] = 628.31, ["Mega|Fly|Ride"] = 634.41}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2, ["Fly"] = 17.81, ["Ride"] = 15.4, ["Fly|Ride"] = 31.23, ["Neon"] = 3.75, ["Neon|Fly"] = 31.25, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 55.38, ["Mega"] = 47.47, ["Mega|Fly"] = 311.88, ["Mega|Ride"] = 62.5, ["Mega|Fly|Ride"] = 100}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 824.87}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 89.69, ["Ride"] = 138.75, ["Fly|Ride"] = 339.99, ["Neon"] = 412.7, ["Neon|Ride"] = 450, ["Neon|Fly|Ride"] = 584.04, ["Mega"] = 1375, ["Mega|Ride"] = 1542.35, ["Mega|Fly|Ride"] = 1500}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2, ["Fly"] = 37.5, ["Ride"] = 76.73, ["Neon"] = 3.23, ["Neon|Fly"] = 97.05, ["Neon|Ride"] = 37.5, ["Neon|Fly|Ride"] = 288.85, ["Mega"] = 24.92, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 24.92, ["Ride"] = 64, ["Fly|Ride"] = 206.48, ["Neon"] = 165.19, ["Neon|Ride"] = 149.9, ["Neon|Fly|Ride"] = 518.75, ["Mega"] = 563.74, ["Mega|Ride"] = 482.5, ["Mega|Fly|Ride"] = 687.5}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2, ["Neon"] = 2, ["Neon|Fly|Ride"] = 110.47, ["Mega"] = 22.5, ["Mega|Fly|Ride"] = 187.5}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2, ["Ride"] = 71.25, ["Neon"] = 4.99, ["Mega"] = 21.25, ["Mega|Ride"] = 75, ["Mega|Fly|Ride"] = 260}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 86.24, ["Fly"] = 1250, ["Ride"] = 135, ["Fly|Ride"] = 250, ["Neon"] = 660.71, ["Neon|Ride"] = 437.49, ["Neon|Fly|Ride"] = 606, ["Mega|Ride"] = 2753.3, ["Mega|Fly|Ride"] = 1897.65}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2, ["Fly"] = 86.25, ["Ride"] = 15.5, ["Fly|Ride"] = 95.18, ["Neon"] = 8.75, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 75, ["Mega"] = 87.48, ["Mega|Ride"] = 112.49, ["Mega|Fly|Ride"] = 200}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2, ["Fly"] = 37.5, ["Fly|Ride"] = 58.75, ["Neon"] = 5.76, ["Neon|Fly"] = 41.3, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 399.9, ["Mega"] = 31.24, ["Mega|Ride"] = 123, ["Mega|Fly|Ride"] = 207.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2, ["Neon"] = 12.5, ["Neon|Fly"] = 250, ["Neon|Ride"] = 219.8, ["Mega"] = 104.49, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 551.29}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2, ["Ride"] = 125, ["Neon"] = 10.8, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 59.37, ["Mega"] = 98.75}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 92.8, ["Ride"] = 311.88, ["Fly|Ride"] = 344.82, ["Neon"] = 393.75, ["Neon|Ride"] = 475, ["Neon|Fly|Ride"] = 662.5, ["Mega|Fly|Ride"] = 2464.24}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 9.23, ["Neon"] = 109.81, ["Mega"] = 398.15, ["Mega|Ride"] = 348.75, ["Mega|Fly|Ride"] = 614.99}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 349.98, ["Ride"] = 406.97, ["Fly|Ride"] = 685.5, ["Neon"] = 1018.75, ["Neon|Ride"] = 1000, ["Neon|Fly|Ride"] = 1125, ["Mega|Fly|Ride"] = 3187.49}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 90}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 54.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 16.25}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 30.99}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 48.18}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 111.2}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 38.31}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.43}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 181.23}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 17.39}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 37.8}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 22.5}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 11.17}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 899.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 15}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.78}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 12.39}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.23}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 18.54}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 634.31}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 440}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.7}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1386.34}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.4}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 49.9}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.63}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 41.25}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.04}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 23.48}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.92}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 54.91}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.9}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 15.7}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 22.64}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.01}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 24.92}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.75}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.01}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 187.5}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 95}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.68}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2900}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 77.55}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 302.5}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.61}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 17.5}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 15}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 29.09}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 203.73}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 13.74}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.6}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 125}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 42.49}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.97}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22.49}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.08}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.25}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 100}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.99}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.05}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.29}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 17.28}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 35.1}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.13}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 27.5}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.4}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 86.97}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 244.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 6.2}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.64}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 301.25}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 23.67}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 74.99}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.58}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23244.44}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 118.75}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 40}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 37.82}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 26.24}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 54.9}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 23.38}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 33.73}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 86.7}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 77.91}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 28.2}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 98.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 411.21}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 42.5}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 6916.78}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 223.6}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 24.25}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.99}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.05}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.57}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 136.12}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.09}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.38}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.23}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 18.65}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 217.5}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 791.19}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.1}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 587.28}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.91}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 220}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 94.89}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 29.98}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 62.25}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.29}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.48}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.04}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.74}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 8.43}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.98}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.29}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 4.79}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.02}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 156.06}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 49.6}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 157.62}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 13.51}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 24.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.24}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 23.38}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 18.36}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.88}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.49}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 5}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.13}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 37.5}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 79.91}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.05}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.51}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.8}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 10.18}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.25}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.43}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.18}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9189.15}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 33.04}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.27}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.83}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.88}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 233.63}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.18}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.97}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.3}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 8.75}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 38.29}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.34}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.71}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.02}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.43}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.93}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3750}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.43}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 80.91}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.55}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 68.79}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.9}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 107.16}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.27}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.35}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.35}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.18}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 42.06}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.99}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.25}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 275294.71}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.12}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.53}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.42}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.4}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.13}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.25}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 77.33}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 85}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.14}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1168.97}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 63.66}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.25}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 22.39}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 32.42}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.52}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.65}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 10}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 311483.58}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 35.8}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.24}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.5}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.4}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.45}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.63}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.22}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.05}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 27.88}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.38}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.02}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 12.48}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 296.91}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 87.5}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 11.97}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.75}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 26.9}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.75}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.29}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.81}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.19}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.37}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 118.75}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.05}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 3.35}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 170.11}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.03}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 964.9}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.64}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 8.75}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 49.99}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 7.5}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.7}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 77.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.28}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 44.69}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.37}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.34}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 80.45}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.49}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 77.43}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 15}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.25}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 16.25}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 107.5}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.25}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 7.7}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 4.59}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 74.34}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.5}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 89.82}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 51.23}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 130.09}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.75}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 136.25}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 14.13}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.93}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 299.61}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 56.16}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 7.98}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 50}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 4.91}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.84}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 97.05}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 29.39}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 5.74}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 42.75}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.99}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.75}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.12}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 26.14}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 138.35}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 53.62}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 23.75}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1899.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 15}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.73}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 20}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 250.8}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.25}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.18}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 16.23}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.56}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.9}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 303.75}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 61.23}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 68.9}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.33}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 43.75}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 148.75}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.75}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 919.64}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 172.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.25}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1645}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 543.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.69}},
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