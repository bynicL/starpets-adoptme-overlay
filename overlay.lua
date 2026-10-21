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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1045.05, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6647.72, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17401.27}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 373.96, ["Ride"] = 515.15, ["Fly|Ride"] = 544.46, ["Neon|Fly|Ride"] = 1967.44, ["Mega|Fly|Ride"] = 6905.98}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 4606.94, ["Fly|Ride"] = 4953.38, ["Neon|Fly|Ride"] = 21067.4, ["Mega|Fly|Ride"] = 69757.64}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 222, ["Fly|Ride"] = 275.25, ["Neon"] = 1424.52, ["Neon|Ride"] = 907.2, ["Neon|Fly|Ride"] = 1045.33, ["Mega|Fly|Ride"] = 4184.25}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 837.72, ["Ride"] = 538.13, ["Fly|Ride"] = 643.13, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6643.53}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.54, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 83.11, ["Neon|Fly"] = 279.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 349.5, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 585.98}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.4, ["Fly"] = 32.71, ["Ride"] = 24.57, ["Fly|Ride"] = 42.02, ["Neon"] = 26.25, ["Neon|Fly"] = 103.67, ["Neon|Ride"] = 56.58, ["Neon|Fly|Ride"] = 115.76, ["Mega"] = 157.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 209.42, ["Ride"] = 146.6, ["Fly|Ride"] = 238.91, ["Neon"] = 525, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 656.08, ["Mega"] = 2063.43, ["Mega|Fly|Ride"] = 2732.06}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 40.36, ["Fly"] = 83.11, ["Ride"] = 44.62, ["Fly|Ride"] = 103.28, ["Neon"] = 275.63, ["Neon|Ride"] = 237.57, ["Neon|Fly|Ride"] = 308.46, ["Mega"] = 1395.85, ["Mega|Ride"] = 1265.84, ["Mega|Fly|Ride"] = 1233.81}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.85, ["Fly"] = 83.76, ["Ride"] = 28.88, ["Fly|Ride"] = 69.34, ["Neon"] = 145.55, ["Neon|Ride"] = 308.69, ["Neon|Fly|Ride"] = 186.26, ["Mega|Fly|Ride"] = 1102.4}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 48.55, ["Fly"] = 111, ["Ride"] = 70.87, ["Fly|Ride"] = 177.19, ["Neon"] = 443.7, ["Neon|Ride"] = 236.31, ["Neon|Fly|Ride"] = 419.97}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.07}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.5, ["Fly"] = 391.63, ["Ride"] = 326.8, ["Fly|Ride"] = 376.31, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4938.83}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly"] = 135.06, ["Ride"] = 78.75, ["Fly|Ride"] = 174.43, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 697.93, ["Mega|Fly|Ride"] = 3045.35}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.61, ["Ride"] = 54.51, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 118.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 316.01, ["Mega|Fly|Ride"] = 308.83}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 170.62, ["Fly"] = 237.57, ["Ride"] = 190.2, ["Fly|Ride"] = 196.88, ["Neon"] = 865.89, ["Neon|Ride"] = 865.35, ["Neon|Fly|Ride"] = 830.46, ["Mega"] = 3209.19, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.56, ["Fly"] = 19.69, ["Ride"] = 17.75, ["Fly|Ride"] = 37.7, ["Neon"] = 35.62, ["Neon|Fly"] = 125.57, ["Neon|Ride"] = 92.09, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 78.75, ["Fly"] = 284.72, ["Ride"] = 140.03, ["Fly|Ride"] = 192.75, ["Neon"] = 279.57, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1674.19, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 47.25, ["Ride"] = 99.48, ["Fly|Ride"] = 178.01, ["Neon"] = 278.52, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 16.69, ["Fly"] = 393.75, ["Ride"] = 26.25, ["Fly|Ride"] = 308.87, ["Neon"] = 321.44, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2728.6, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 627.82}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 40.53, ["Fly"] = 140.34, ["Ride"] = 59.78, ["Fly|Ride"] = 100.48, ["Neon"] = 279.57, ["Neon|Ride"] = 295.09, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1660.89, ["Mega|Ride"] = 1395.85, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 19.69, ["Fly"] = 72.19, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 393.88, ["Neon|Ride"] = 366.95, ["Neon|Fly|Ride"] = 447.86, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1265.84}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.91, ["Ride"] = 40.38, ["Fly|Ride"] = 84, ["Neon"] = 174.87, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 298.97, ["Mega"] = 887.33, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 37.49, ["Fly"] = 136.75, ["Ride"] = 57.66, ["Fly|Ride"] = 127.03, ["Neon"] = 196.88, ["Neon|Fly"] = 232.31, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 941.07}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.92, ["Fly"] = 27.12, ["Ride"] = 19.28, ["Fly|Ride"] = 46.73, ["Neon"] = 21.95, ["Neon|Fly"] = 101.05, ["Neon|Ride"] = 48.04, ["Neon|Fly|Ride"] = 95.69, ["Mega"] = 157.5, ["Mega|Fly"] = 274.32, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 446.25, ["Ride"] = 425.98, ["Fly|Ride"] = 505.85, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1898.16, ["Mega|Fly|Ride"] = 7658.32}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.55, ["Ride"] = 32.33, ["Fly|Ride"] = 107.34, ["Neon"] = 210.54, ["Mega|Ride"] = 795.24, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.64, ["Fly"] = 34.71, ["Ride"] = 20.52, ["Fly|Ride"] = 39.86, ["Neon"] = 69.41, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 113.24, ["Mega"] = 418.56, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86, ["Fly"] = 111.61, ["Ride"] = 102.66, ["Fly|Ride"] = 129.09, ["Neon"] = 262.5, ["Neon|Fly"] = 357, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4059.89, ["Mega|Ride"] = 7955.48, ["Mega|Fly|Ride"] = 1584.2}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.8, ["Ride"] = 26.24, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 697.93, ["Mega|Ride"] = 798.38, ["Mega|Fly|Ride"] = 837.1}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.94, ["Fly"] = 353.91, ["Ride"] = 140.31, ["Fly|Ride"] = 275.62, ["Neon"] = 672.79, ["Neon|Ride"] = 726.18, ["Neon|Fly|Ride"] = 781.62, ["Mega"] = 6278.16, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3006.2}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.33, ["Fly"] = 32.07, ["Ride"] = 23.46, ["Fly|Ride"] = 54, ["Neon"] = 20.46, ["Neon|Fly"] = 135.71, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 127.09, ["Mega"] = 151.85, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 276.05}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.48, ["Fly"] = 2625, ["Ride"] = 889.45, ["Fly|Ride"] = 1100.61, ["Neon"] = 10207.32, ["Neon|Ride"] = 6139, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 53385.36, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.87, ["Fly"] = 70.17, ["Ride"] = 24.86, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 231.26, ["Mega"] = 763.86, ["Mega|Ride"] = 1066.26, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 186.38, ["Ride"] = 246.17, ["Fly|Ride"] = 248.07, ["Neon"] = 1815.51, ["Neon|Ride"] = 813.65, ["Neon|Fly|Ride"] = 977.82, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.96, ["Fly"] = 112.04, ["Ride"] = 65.54, ["Fly|Ride"] = 140.31, ["Neon"] = 99.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 697.93, ["Mega|Ride"] = 1103.93, ["Mega|Fly|Ride"] = 587.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 123.9, ["Ride"] = 136.5, ["Fly|Ride"] = 236.25, ["Neon"] = 614.6, ["Neon|Ride"] = 446.92, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 115.49, ["Fly"] = 157.49, ["Ride"] = 164.06, ["Fly|Ride"] = 274.31, ["Neon"] = 360.94, ["Neon|Fly"] = 558.77, ["Neon|Ride"] = 342.5, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1555.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.31, ["Fly"] = 64.63, ["Ride"] = 52.26, ["Fly|Ride"] = 73.36, ["Neon|Ride"] = 387.95, ["Neon|Fly|Ride"] = 376.77, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly"] = 70.17, ["Ride"] = 35.38, ["Fly|Ride"] = 157.49, ["Neon"] = 35.35, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 125.57, ["Neon|Fly|Ride"] = 558.77, ["Mega"] = 182.72, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.31, ["Fly"] = 479.07, ["Ride"] = 472.5, ["Fly|Ride"] = 524.98, ["Neon|Ride"] = 1835.29, ["Neon|Fly|Ride"] = 1673.69, ["Mega|Ride"] = 14649.04, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 104.9, ["Fly"] = 150.99, ["Ride"] = 118.12, ["Fly|Ride"] = 184.73, ["Neon"] = 420, ["Neon|Fly"] = 837.1, ["Neon|Ride"] = 558.77, ["Neon|Fly|Ride"] = 659.22, ["Mega|Ride"] = 2510.23, ["Mega|Fly|Ride"] = 2232.95}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3281.25, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14648}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.43, ["Fly"] = 118.13, ["Ride"] = 56.56, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 322.88, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 1568.51, ["Mega|Ride"] = 1786.16, ["Mega|Fly|Ride"] = 1367.61}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 79.56, ["Ride"] = 85.32, ["Fly|Ride"] = 136.71, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 710.49, ["Mega|Ride"] = 2232.95, ["Mega|Fly|Ride"] = 2059.71}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.74, ["Fly"] = 56.25, ["Ride"] = 45.93, ["Fly|Ride"] = 89.25, ["Neon"] = 209.28, ["Neon|Fly"] = 195.68, ["Neon|Ride"] = 140.21, ["Neon|Fly|Ride"] = 192.96, ["Mega"] = 2625, ["Mega|Ride"] = 684.33, ["Mega|Fly|Ride"] = 653.22}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 38.11, ["Fly"] = 393.75, ["Ride"] = 56.63, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 418.56, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.71}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 229.69, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1088.24, ["Neon|Fly|Ride"] = 1084.05, ["Mega|Fly|Ride"] = 4511.92}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 943.69, ["Fly|Ride"] = 977.91, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3163.99, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 4.78}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 23.62, ["Fly"] = 56.37, ["Ride"] = 38.07, ["Fly|Ride"] = 58.97, ["Neon"] = 251.14, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 209.65, ["Mega|Ride"] = 1138.9, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 16.9}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4593.75, ["Ride"] = 6156.38, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41918.19}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.32, ["Fly"] = 74.36, ["Ride"] = 24.93, ["Fly|Ride"] = 54.1, ["Neon"] = 96.14, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 697.93, ["Mega|Ride"] = 1514.52, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.21, ["Fly"] = 139.89, ["Ride"] = 36.66, ["Neon"] = 95.29, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 918.75, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 279.6, ["Ride"] = 58.95, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4185.44}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.2, ["Fly"] = 70.17, ["Ride"] = 25.8, ["Fly|Ride"] = 132.64, ["Neon"] = 70.11, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 1395.85, ["Mega|Ride"] = 744.61, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.87, ["Fly"] = 2058.44, ["Ride"] = 1767.15, ["Fly|Ride"] = 1613.07, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27424.69, ["Fly"] = 33503.98, ["Ride"] = 32548.95, ["Fly|Ride"] = 26250, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72446.3, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.47, ["Fly"] = 393.75, ["Ride"] = 67.7, ["Fly|Ride"] = 165.83, ["Neon"] = 314.11, ["Neon|Ride"] = 209.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 837.1, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1356.09}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.42, ["Fly"] = 75.13, ["Ride"] = 32.44, ["Fly|Ride"] = 155.39, ["Neon"] = 20.47, ["Neon|Fly"] = 150.68, ["Neon|Ride"] = 63.56, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 141.75, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.25, ["Ride"] = 38.28, ["Fly|Ride"] = 124.67, ["Neon"] = 89.09, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 470.88, ["Mega"] = 317.93, ["Mega|Ride"] = 380.52, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 871.43, ["Ride"] = 682.5, ["Fly|Ride"] = 733.69, ["Neon"] = 3008.1, ["Neon|Fly|Ride"] = 2616.6, ["Mega|Fly|Ride"] = 11073.33}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 827.94, ["Fly|Ride"] = 905.31, ["Neon|Ride"] = 3627.73, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10603.82}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.02, ["Fly"] = 118.72, ["Ride"] = 28.29, ["Fly|Ride"] = 65.63, ["Neon"] = 72.18, ["Neon|Ride"] = 107.79, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 1197.03, ["Mega|Ride"] = 480.38, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.84}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 69.43, ["Fly"] = 111.01, ["Ride"] = 78.44, ["Fly|Ride"] = 112.26, ["Neon"] = 420, ["Neon|Ride"] = 404.96, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2048.79, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.18, ["Ride"] = 123.55, ["Fly|Ride"] = 213.69, ["Neon"] = 450.19, ["Neon|Ride"] = 359.28, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1361.73, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 35.43, ["Ride"] = 21.95, ["Fly|Ride"] = 40.68, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 65.13, ["Neon|Fly|Ride"] = 90.96, ["Mega|Fly|Ride"] = 536.24}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 120.65, ["Fly"] = 161.44, ["Ride"] = 150.92, ["Fly|Ride"] = 196.88, ["Neon"] = 725.81, ["Neon|Ride"] = 576.07, ["Neon|Fly|Ride"] = 530.25, ["Mega|Fly|Ride"] = 2028.87}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 36.39, ["Fly|Ride"] = 140.31, ["Neon"] = 42, ["Neon|Ride"] = 82.69, ["Mega"] = 196.88, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.35, ["Fly"] = 41.65, ["Ride"] = 32.69, ["Fly|Ride"] = 77.49, ["Neon"] = 98.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.22, ["Mega|Fly|Ride"] = 790.11}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 29.42, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 183.75, ["Neon|Ride"] = 282.19, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1114.31}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13, ["Fly"] = 174.27, ["Ride"] = 35.76, ["Fly|Ride"] = 67.38, ["Neon"] = 91.87, ["Neon|Ride"] = 137.63, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 995.1}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7301.38, ["Ride"] = 6555.94, ["Fly|Ride"] = 5501.9, ["Neon"] = 34900.68, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 27749.46}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 205.08, ["Fly"] = 265.4, ["Ride"] = 242.82, ["Fly|Ride"] = 294, ["Neon"] = 525, ["Neon|Ride"] = 711.82, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1797.98}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.75, ["Fly"] = 94.99, ["Ride"] = 85.32, ["Fly|Ride"] = 144.36, ["Neon"] = 103.95, ["Neon|Fly"] = 253.89, ["Neon|Ride"] = 164.94, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 442.89, ["Mega|Fly"] = 572.38, ["Mega|Ride"] = 419.87, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.42, ["Fly"] = 87.86, ["Ride"] = 28.25, ["Fly|Ride"] = 52.5, ["Neon"] = 31.43, ["Neon|Fly"] = 60.69, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 190.45, ["Mega"] = 341.25, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 354.74}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.18, ["Fly"] = 5381.09, ["Ride"] = 96.88, ["Fly|Ride"] = 104.71, ["Neon"] = 222.81, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 277.15, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 517.97, ["Mega|Ride"] = 633.52, ["Mega|Fly|Ride"] = 608.4}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13387.5, ["Fly|Ride"] = 12206.25, ["Neon|Fly|Ride"] = 24937.5, ["Mega|Fly|Ride"] = 111612}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.78, ["Ride"] = 255.94, ["Fly|Ride"] = 321.44, ["Neon"] = 1256.41, ["Neon|Ride"] = 1395.85, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5959.04}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.21, ["Fly"] = 87.28, ["Ride"] = 57.98, ["Fly|Ride"] = 111.57, ["Neon"] = 397.88, ["Neon|Ride"] = 311.72, ["Neon|Fly|Ride"] = 418.56, ["Mega|Fly|Ride"] = 3138.05}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.4, ["Fly"] = 27.67, ["Ride"] = 27.24, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 269.32, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 475.07, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.21, ["Fly"] = 839.9, ["Ride"] = 392.44, ["Fly|Ride"] = 498.75, ["Neon"] = 1568.76, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 1535.02, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.95, ["Fly"] = 103.72, ["Ride"] = 37.94, ["Fly|Ride"] = 111.57, ["Neon"] = 31.5, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 191.49, ["Mega"] = 131.24, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 209.23, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.38, ["Fly"] = 194.76, ["Ride"] = 129.84, ["Fly|Ride"] = 188.9, ["Neon"] = 626.07, ["Neon|Fly"] = 525, ["Neon|Ride"] = 524.9, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2413.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.4, ["Fly"] = 19.05, ["Ride"] = 18.8, ["Fly|Ride"] = 30.61, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 2511.27, ["Mega|Fly|Ride"] = 949.09}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.69}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 58.35, ["Fly|Ride"] = 418.82, ["Neon"] = 421.32, ["Neon|Fly"] = 417.52, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 502.27, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1814.39}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.48, ["Fly"] = 103.67, ["Ride"] = 32.75, ["Fly|Ride"] = 97.46, ["Neon"] = 91.88, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 228.55, ["Mega"] = 626.79, ["Mega|Fly|Ride"] = 564.2}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 33.5}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.84, ["Fly"] = 210, ["Ride"] = 109.79, ["Fly|Ride"] = 85.32, ["Neon"] = 283.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1569.56, ["Mega|Ride"] = 2092.73, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 6.24, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 20.6, ["Neon|Ride"] = 103.23, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 124.69, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.33, ["Fly"] = 52.49, ["Ride"] = 28.25, ["Fly|Ride"] = 79.55, ["Neon"] = 159.09, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 209.28, ["Mega|Ride"] = 638.29, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.71, ["Ride"] = 495.15, ["Fly|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1954.61, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 26.25, ["Ride"] = 57.58, ["Fly|Ride"] = 131.25, ["Neon"] = 174.87, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.63, ["Fly"] = 119.37, ["Ride"] = 70.87, ["Fly|Ride"] = 118.02, ["Neon"] = 312.22, ["Neon|Ride"] = 326.48, ["Neon|Fly|Ride"] = 458.1, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.65, ["Fly"] = 73.27, ["Ride"] = 45.94, ["Fly|Ride"] = 119.55, ["Neon"] = 97, ["Neon|Ride"] = 155.64, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 414.74, ["Mega|Fly"] = 525, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 633.52}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 13612.37, ["Fly|Ride"] = 8400, ["Neon|Fly|Ride"] = 16493.93, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1366.66, ["Fly"] = 1487.07, ["Ride"] = 1509.36, ["Fly|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 3896.81, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 585.36, ["Ride"] = 759.75, ["Fly|Ride"] = 538.12, ["Neon"] = 2542.76, ["Neon|Fly|Ride"] = 2372.11, ["Mega|Fly|Ride"] = 6976.09}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.31, ["Fly"] = 20.29, ["Ride"] = 21.62, ["Fly|Ride"] = 41.99, ["Neon"] = 67.68, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.76, ["Fly"] = 78.74, ["Ride"] = 28.29, ["Fly|Ride"] = 48.18, ["Neon"] = 20.5, ["Neon|Ride"] = 55.01, ["Mega"] = 158.99, ["Mega|Ride"] = 189.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 33.77, ["Fly"] = 53.8, ["Ride"] = 47.8, ["Fly|Ride"] = 79.97, ["Neon"] = 194.76, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 198.19, ["Mega|Fly|Ride"] = 586.59}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.81, ["Fly"] = 23.05, ["Ride"] = 15.18, ["Fly|Ride"] = 31.08, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 261.19, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.59, ["Fly"] = 369.49, ["Ride"] = 321.55, ["Fly|Ride"] = 360.94, ["Neon"] = 1535.97, ["Neon|Fly|Ride"] = 1672.1, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 12.91, ["Fly"] = 59.37, ["Ride"] = 30.94, ["Fly|Ride"] = 105, ["Neon"] = 208.95, ["Neon|Fly"] = 308.69, ["Neon|Ride"] = 142.61, ["Neon|Fly|Ride"] = 287.44, ["Mega"] = 795.24, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.89, ["Fly"] = 20.98, ["Ride"] = 20.9, ["Fly|Ride"] = 45.04, ["Neon"] = 98.94, ["Neon|Fly"] = 135.27, ["Neon|Ride"] = 129.32, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.86, ["Fly"] = 1048.69, ["Ride"] = 519.33, ["Fly|Ride"] = 536.08, ["Neon|Fly|Ride"] = 2092.73, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1447.15, ["Ride"] = 1260, ["Fly|Ride"] = 1384.59, ["Neon"] = 4886.37, ["Neon|Ride"] = 4297.41, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 88.1, ["Fly"] = 136.13, ["Ride"] = 103.69, ["Fly|Ride"] = 108.61, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2372.11}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 129.74, ["Fly"] = 196.87, ["Ride"] = 183.15, ["Fly|Ride"] = 242.33, ["Neon"] = 849.14, ["Neon|Fly"] = 696.89, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 610.71, ["Mega"] = 2651.49, ["Mega|Ride"] = 3070.03, ["Mega|Fly|Ride"] = 2810.54}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.95, ["Fly"] = 120.43, ["Ride"] = 53.81, ["Fly|Ride"] = 121.1, ["Neon"] = 391.35, ["Neon|Ride"] = 272.98, ["Neon|Fly|Ride"] = 105, ["Mega|Ride"] = 2092.73, ["Mega|Fly|Ride"] = 1046.37}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 208.69, ["Ride"] = 315, ["Fly|Ride"] = 335.06, ["Neon|Fly"] = 949.09, ["Neon|Fly|Ride"] = 1328.72, ["Mega|Fly|Ride"] = 4185.44}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2058.65, ["Fly"] = 2255.49, ["Ride"] = 2483.25, ["Fly|Ride"] = 2230.62, ["Neon|Fly|Ride"] = 10463.6, ["Mega|Fly|Ride"] = 28472.19}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 209.42, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 1116.48, ["Mega|Fly|Ride"] = 2511.27}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 616.88, ["Ride"] = 618.09, ["Fly|Ride"] = 733.49, ["Neon|Fly|Ride"] = 1214.12, ["Mega|Fly|Ride"] = 3360}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.26, ["Fly"] = 68.92, ["Ride"] = 51.09, ["Fly|Ride"] = 93.79, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.09, ["Fly"] = 43.18, ["Ride"] = 16.37, ["Fly|Ride"] = 45.94, ["Neon"] = 18.8, ["Neon|Fly"] = 139.13, ["Neon|Ride"] = 45.5, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 138.25, ["Mega|Fly"] = 249.27, ["Mega|Ride"] = 142.53, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 55.71, ["Ride"] = 128.34, ["Fly|Ride"] = 253.32, ["Neon"] = 346.4, ["Neon|Ride"] = 465, ["Neon|Fly|Ride"] = 697.93, ["Mega"] = 1529.79, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 892.7, ["Ride"] = 835.96, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.87, ["Ride"] = 1027.09, ["Fly|Ride"] = 971.63, ["Neon|Fly|Ride"] = 4176.04, ["Mega|Fly|Ride"] = 15205.71}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.33, ["Fly"] = 25.71, ["Ride"] = 23.6, ["Fly|Ride"] = 38.68, ["Neon"] = 85.32, ["Neon|Ride"] = 98.37, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.49, ["Ride"] = 19.69, ["Fly|Ride"] = 70.17, ["Neon"] = 140.31, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 570.94, ["Mega|Ride"] = 730.37, ["Mega|Fly|Ride"] = 605.87}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.35, ["Ride"] = 26.24, ["Fly|Ride"] = 102.38, ["Neon"] = 19.57, ["Neon|Fly"] = 316.77, ["Neon|Ride"] = 54.48, ["Neon|Fly|Ride"] = 170.57, ["Mega"] = 162.46, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 280.26, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 27.67, ["Fly"] = 59.07, ["Ride"] = 39.1, ["Fly|Ride"] = 105.69, ["Neon"] = 265.95, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 233, ["Mega|Fly|Ride"] = 1094.51}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 60.37, ["Ride"] = 135.19, ["Fly|Ride"] = 448.13, ["Neon"] = 437.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1569.56, ["Mega|Fly|Ride"] = 1535.02}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.95, ["Fly"] = 43.31, ["Ride"] = 35.42, ["Fly|Ride"] = 63, ["Neon"] = 98.44, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 626.79, ["Mega|Ride"] = 352.97, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.78, ["Ride"] = 39.37, ["Fly|Ride"] = 75.28, ["Neon"] = 328.78, ["Neon|Fly"] = 1395.85, ["Neon|Ride"] = 190.11, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2100, ["Mega|Ride"] = 1043.24, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.3, ["Fly"] = 20.89, ["Ride"] = 16.93, ["Fly|Ride"] = 41.79, ["Neon"] = 29.53, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 732.46, ["Mega|Ride"] = 311.83, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.03, ["Fly"] = 46.41, ["Ride"] = 32.71, ["Fly|Ride"] = 32108.34, ["Neon"] = 37.41, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 142.37, ["Mega"] = 300.32, ["Mega|Ride"] = 315}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.54, ["Fly"] = 65.63, ["Ride"] = 53.34, ["Fly|Ride"] = 96.41, ["Neon"] = 411.94, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1574.9, ["Fly"] = 1575, ["Ride"] = 1417.29, ["Fly|Ride"] = 1493.63, ["Neon|Fly|Ride"] = 3858.75, ["Mega|Fly|Ride"] = 14370.64}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 455.82, ["Ride"] = 472.5, ["Fly|Ride"] = 474.85, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 10463.6}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 273, ["Ride"] = 342.57, ["Fly|Ride"] = 1125.9, ["Neon"] = 1207.5, ["Neon|Ride"] = 1535.02, ["Neon|Fly|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 7654.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.29}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.99, ["Ride"] = 46.95, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 418.56, ["Mega|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 72601.53, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 209271.83, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 278.95, ["Fly"] = 611.63, ["Ride"] = 292.38, ["Fly|Ride"] = 388.5, ["Neon"] = 945, ["Neon|Fly"] = 1108.06, ["Neon|Ride"] = 873.71, ["Neon|Fly|Ride"] = 891.45, ["Mega"] = 3976.18, ["Mega|Ride"] = 4184.41, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 195.83, ["Fly"] = 525, ["Ride"] = 209.95, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1740.38}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.19, ["Fly"] = 279.57, ["Ride"] = 157.5, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 644.53, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.45, ["Fly"] = 94.5, ["Ride"] = 26.25, ["Fly|Ride"] = 70.17, ["Neon"] = 70.88, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 709.45, ["Mega|Ride"] = 697.93, ["Mega|Fly|Ride"] = 748.16}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4827.83, ["Neon"] = 27221.99, ["Neon|Fly|Ride"] = 27903.27}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.88, ["Fly"] = 62.84, ["Ride"] = 28.14, ["Fly|Ride"] = 48.09, ["Neon"] = 279.57, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 223.94, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.38, ["Fly"] = 106.51, ["Ride"] = 56.59, ["Fly|Ride"] = 74.82, ["Neon"] = 406.25, ["Neon|Fly"] = 1395.85, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 241.5, ["Mega|Fly|Ride"] = 1372.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.88, ["Ride"] = 712.59, ["Fly|Ride"] = 786.09, ["Neon"] = 2485.59, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2034.38, ["Mega"] = 8161.61, ["Mega|Fly"] = 8161.61, ["Mega|Fly|Ride"] = 7612.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.48, ["Fly"] = 19.69, ["Ride"] = 20.14, ["Fly|Ride"] = 39.69, ["Neon"] = 116.82, ["Neon|Fly"] = 158.01, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.96, ["Mega|Fly|Ride"] = 858.03}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.19, ["Ride"] = 27.56, ["Fly|Ride"] = 79.55, ["Neon"] = 81.68, ["Neon|Ride"] = 118.64, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 730.37}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.69, ["Ride"] = 128.62, ["Fly|Ride"] = 156.19, ["Neon"] = 1010.63, ["Neon|Ride"] = 698.29, ["Neon|Fly|Ride"] = 806.76, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.72, ["Fly"] = 41.91, ["Ride"] = 62.79, ["Fly|Ride"] = 131.06, ["Neon"] = 72.1, ["Neon|Ride"] = 91.72, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 307.13, ["Mega|Fly"] = 726.18, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 416.17}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 3883.65, ["Fly|Ride"] = 3937.5, ["Neon"] = 18845.99, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 11550, ["Mega"] = 36622.58, ["Mega|Fly|Ride"] = 36064.79}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 23.55, ["Fly"] = 140.31, ["Ride"] = 65.33, ["Fly|Ride"] = 154.96, ["Neon"] = 1605.13, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 571.6, ["Mega"] = 768.04, ["Mega|Ride"] = 1038, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7251.57, ["Fly"] = 8655.56, ["Ride"] = 6857.82, ["Fly|Ride"] = 6167.34, ["Neon|Ride"] = 22323.04, ["Neon|Fly|Ride"] = 16564.56, ["Mega|Fly|Ride"] = 82064.91}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.37, ["Fly"] = 22.32, ["Ride"] = 14.41, ["Fly|Ride"] = 31.08, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 218.3, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 346.36}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.94, ["Fly"] = 37.68, ["Ride"] = 32.07, ["Fly|Ride"] = 50.66, ["Neon"] = 182.2, ["Neon|Fly"] = 231.26, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 156.53, ["Mega|Ride"] = 985.04, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.02}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 9.08, ["Ride"] = 31.9, ["Fly|Ride"] = 116.02, ["Neon"] = 89.14, ["Neon|Ride"] = 139.12, ["Mega"] = 1049.9, ["Mega|Ride"] = 877.91, ["Mega|Fly|Ride"] = 677.92}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 111.01, ["Ride"] = 43.31, ["Fly|Ride"] = 99.75, ["Neon"] = 203.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 317.06, ["Mega"] = 945, ["Mega|Ride"] = 949.09, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.02, ["Fly"] = 19.94, ["Ride"] = 19.51, ["Fly|Ride"] = 34.99, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2511.27, ["Mega|Ride"] = 591.99, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8516.3}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 17.49}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 232.21, ["Ride"] = 251.29, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 5853.43}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.75, ["Fly"] = 131.94, ["Ride"] = 37.45, ["Fly|Ride"] = 125.9, ["Neon"] = 183.24, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 523.2, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.96}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.83, ["Ride"] = 26.25, ["Fly|Ride"] = 83.77, ["Neon|Ride"] = 182.07}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.64}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 167.55, ["Fly"] = 418.82, ["Ride"] = 211.32, ["Fly|Ride"] = 328.13, ["Neon"] = 907.76, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 4046.28, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 70.16, ["Ride"] = 111.61, ["Fly|Ride"] = 209.42, ["Neon"] = 559.12, ["Neon|Ride"] = 321.25, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2092.73, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 118.13, ["Fly"] = 204.73, ["Ride"] = 196.8, ["Fly|Ride"] = 208.53, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3226.13, ["Mega|Fly|Ride"] = 3348.36}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 1968.75, ["Ride"] = 1967.44, ["Fly|Ride"] = 2208.94, ["Neon|Ride"] = 8704.67, ["Neon|Fly|Ride"] = 7219.89, ["Mega|Fly|Ride"] = 31251.62}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.44, ["Fly"] = 98.44, ["Ride"] = 56.8, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 195.68, ["Mega"] = 940.69, ["Mega|Ride"] = 1028.57, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 748.13, ["Fly|Ride"] = 963.25, ["Neon|Ride"] = 3070.03, ["Neon|Fly|Ride"] = 4113.05, ["Mega|Fly|Ride"] = 16608.79}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.76}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.18, ["Ride"] = 52.36, ["Fly|Ride"] = 279.57, ["Neon"] = 81.29, ["Neon|Ride"] = 125.57, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 418.56, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 505.32}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.39, ["Fly"] = 165.55, ["Ride"] = 27.56, ["Fly|Ride"] = 100.52, ["Neon"] = 53.42, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.82}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.19, ["Fly"] = 108.92, ["Ride"] = 30.89, ["Fly|Ride"] = 81.68, ["Neon"] = 94.98, ["Neon|Ride"] = 251.14, ["Neon|Fly|Ride"] = 254.62, ["Mega|Fly|Ride"] = 2216.1}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.62, ["Fly"] = 39.37, ["Ride"] = 39.29, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 418.56, ["Neon|Fly|Ride"] = 317.06, ["Mega|Ride"] = 1779.52, ["Mega|Fly|Ride"] = 975.22}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6561.19, ["Fly"] = 10237.5, ["Ride"] = 6793.5, ["Fly|Ride"] = 5247.9, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.57, ["Fly"] = 65.62, ["Ride"] = 33.52, ["Fly|Ride"] = 81.37, ["Neon"] = 44.56, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 177.97, ["Mega"] = 532.88, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 478.62}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 21.17}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 95.23, ["Fly"] = 370.65, ["Ride"] = 132.6, ["Neon"] = 525, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 697.93, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1960.45}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 46.9, ["Fly"] = 142.48, ["Ride"] = 69.69, ["Fly|Ride"] = 175.42, ["Neon"] = 257.24, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 320.74, ["Mega"] = 2372.7, ["Mega|Ride"] = 2825.19, ["Mega|Fly|Ride"] = 1535.02}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.34, ["Fly"] = 70.47, ["Ride"] = 29.86, ["Fly|Ride"] = 59.73, ["Neon"] = 156.19, ["Neon|Ride"] = 142.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1016.21, ["Mega|Ride"] = 870.79, ["Mega|Fly|Ride"] = 774.37}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.81, ["Fly"] = 65.44, ["Ride"] = 21.95, ["Fly|Ride"] = 98.6, ["Neon"] = 26.04, ["Neon|Fly"] = 70.11, ["Neon|Ride"] = 50.9, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 169.21, ["Mega|Fly"] = 6976.09, ["Mega|Ride"] = 178.1, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.18, ["Ride"] = 27.57, ["Fly|Ride"] = 92.15, ["Neon"] = 86.63, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 525, ["Mega|Ride"] = 633.52, ["Mega|Fly|Ride"] = 753.94}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.59, ["Fly"] = 24.83, ["Ride"] = 24.83, ["Fly|Ride"] = 47.16, ["Neon"] = 363.33, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 144.3}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.32}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.91, ["Ride"] = 101.07, ["Fly|Ride"] = 279.57, ["Neon"] = 170.63, ["Neon|Ride"] = 279.39, ["Neon|Fly|Ride"] = 573.42, ["Mega"] = 1255.64, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 210, ["Ride"] = 443.63, ["Fly|Ride"] = 1583.59}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.88, ["Fly"] = 212.31, ["Ride"] = 102.38, ["Fly|Ride"] = 211, ["Neon"] = 256.49, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 1035.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1079.16}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 971.25, ["Fly"] = 1354.84, ["Ride"] = 1007.98, ["Fly|Ride"] = 1030.21, ["Neon|Fly"] = 4104.76, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 3439, ["Mega|Fly|Ride"] = 11735.06}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 431.43, ["Fly"] = 698.37, ["Ride"] = 413.44, ["Fly|Ride"] = 544.69, ["Neon"] = 2139.38, ["Neon|Ride"] = 2092.73, ["Neon|Fly|Ride"] = 3557.64, ["Mega"] = 12556.31, ["Mega|Fly|Ride"] = 8370.88}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 71.52}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.77, ["Fly"] = 22.11, ["Ride"] = 21.24, ["Fly|Ride"] = 43.32, ["Neon"] = 78.75, ["Neon|Fly"] = 167.43, ["Neon|Ride"] = 92.14, ["Neon|Fly|Ride"] = 166.69, ["Mega|Ride"] = 697.93, ["Mega|Fly|Ride"] = 522.15}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 231.27, ["Fly"] = 392.03, ["Ride"] = 303.03, ["Fly|Ride"] = 341.25, ["Neon"] = 1103.55, ["Neon|Ride"] = 1058.23, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3282.57}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.2}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 139.13, ["Ride"] = 187.67, ["Fly|Ride"] = 292.14, ["Neon"] = 585.38, ["Neon|Ride"] = 557.82, ["Neon|Fly|Ride"] = 728.43, ["Mega"] = 2651.49, ["Mega|Ride"] = 3053.29, ["Mega|Fly|Ride"] = 3243.73}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110.25, ["Ride"] = 128.56, ["Fly|Ride"] = 136.53, ["Neon"] = 837.62, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 888.57, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 5581.29, ["Mega|Fly|Ride"] = 2511.27}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.07, ["Ride"] = 27.92, ["Fly|Ride"] = 170.68, ["Neon"] = 27.57, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 167.51, ["Mega"] = 320.2, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 836.06}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.25, ["Fly"] = 62.85, ["Ride"] = 27.13, ["Fly|Ride"] = 75.51, ["Neon"] = 140.31, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 316.77, ["Mega|Ride"] = 815.13, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 9.97, ["Fly"] = 56.56, ["Ride"] = 43.99, ["Fly|Ride"] = 104.61, ["Neon"] = 65.63, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 837.1}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.12, ["Fly"] = 98.18, ["Ride"] = 52.48, ["Fly|Ride"] = 165.55, ["Neon"] = 21.15, ["Neon|Ride"] = 69.02, ["Neon|Fly|Ride"] = 203.01, ["Mega"] = 136.49, ["Mega|Ride"] = 179.8, ["Mega|Fly|Ride"] = 285.48}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 196.77, ["Fly"] = 418.87, ["Ride"] = 261.84, ["Fly|Ride"] = 359.42, ["Neon"] = 1647.99, ["Neon|Ride"] = 1350.06, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5524.79}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 137.2, ["Fly"] = 322.94, ["Ride"] = 140.12, ["Fly|Ride"] = 241.5, ["Neon"] = 706.11, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 787.75, ["Mega|Fly|Ride"] = 2362.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.57, ["Ride"] = 69.34, ["Fly|Ride"] = 125.65, ["Neon"] = 393.75, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 416.07, ["Mega"] = 1814.39, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.63, ["Ride"] = 58.24, ["Fly|Ride"] = 279.57, ["Neon|Ride"] = 602.67, ["Neon|Fly|Ride"] = 488.66, ["Mega|Fly|Ride"] = 1954.61}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.66, ["Fly"] = 58.47, ["Ride"] = 34.13, ["Fly|Ride"] = 81.69, ["Neon"] = 77.42, ["Neon|Fly"] = 279.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 148.6, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 462.69, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.26, ["Fly"] = 26.25, ["Ride"] = 18.67, ["Fly|Ride"] = 44.61, ["Neon"] = 17.75, ["Neon|Fly"] = 66.92, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 136.4, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1017.65, ["Fly"] = 911.66, ["Ride"] = 914.82, ["Fly|Ride"] = 958.13, ["Neon|Fly"] = 3243.48, ["Neon|Ride"] = 8370.88, ["Neon|Fly|Ride"] = 2624.88, ["Mega|Fly|Ride"] = 10289.91}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.16, ["Ride"] = 393.75, ["Fly|Ride"] = 475.35, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1582.6, ["Mega"] = 10463.6, ["Mega|Fly|Ride"] = 5859.62}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.2, ["Fly"] = 140.31, ["Ride"] = 121.1, ["Fly|Ride"] = 207.33, ["Neon"] = 283.08, ["Neon|Ride"] = 319.81, ["Neon|Fly|Ride"] = 492.34, ["Mega"] = 1312.5, ["Mega|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 1674.19}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 198.14, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 207.32, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 11.82, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 68.62, ["Neon"] = 150.94, ["Neon|Ride"] = 96.48, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 567.78, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.24, ["Ride"] = 236.25, ["Fly|Ride"] = 615.21, ["Neon"] = 940.64, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 4164.81, ["Mega|Ride"] = 4603.99, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 45.85, ["Fly"] = 125.98, ["Ride"] = 76.21, ["Fly|Ride"] = 100.11, ["Neon|Ride"] = 597.93, ["Neon|Fly|Ride"] = 558.77, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1890, ["Ride"] = 1968.75, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 11073.33, ["Neon|Fly|Ride"] = 12556.31, ["Mega"] = 50225.24, ["Mega|Fly|Ride"] = 24415.76}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.39, ["Fly"] = 76.36, ["Ride"] = 34.41, ["Fly|Ride"] = 70.75, ["Neon"] = 52.41, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 103.6, ["Neon|Fly|Ride"] = 192.09, ["Mega"] = 418.56, ["Mega|Fly"] = 763.03, ["Mega|Ride"] = 414.38, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53, ["Ride"] = 83.68, ["Fly|Ride"] = 126.95, ["Neon"] = 315, ["Neon|Ride"] = 349.5, ["Neon|Fly|Ride"] = 558.5, ["Mega"] = 1735.93, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 83.81, ["Fly"] = 74.67, ["Ride"] = 78, ["Fly|Ride"] = 97.13, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.72, ["Mega|Fly|Ride"] = 1879.8}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2135.97, ["Fly"] = 1583.59, ["Ride"] = 1050, ["Fly|Ride"] = 1117.16, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 525, ["Ride"] = 657.66, ["Fly|Ride"] = 605.18, ["Neon|Fly|Ride"] = 3321.15}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 67.93, ["Fly"] = 317, ["Ride"] = 86, ["Fly|Ride"] = 207.38, ["Neon"] = 416.72, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2651.49, ["Mega|Fly|Ride"] = 2790.65}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.35, ["Ride"] = 19.48, ["Fly|Ride"] = 41.9, ["Neon"] = 69.16, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.38, ["Fly"] = 68.25, ["Ride"] = 54.01, ["Fly|Ride"] = 104.68, ["Neon"] = 209.28, ["Neon|Fly"] = 328.57, ["Neon|Ride"] = 217.11, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 776.46, ["Fly"] = 1092.13, ["Ride"] = 759.94, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 760.46}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6282.01, ["Fly|Ride"] = 5884.03, ["Neon"] = 42000, ["Neon|Ride"] = 29989.71, ["Neon|Fly|Ride"] = 23439.03, ["Mega|Fly|Ride"] = 89290.02}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 496.12, ["Ride"] = 393.75, ["Fly|Ride"] = 454.41, ["Neon"] = 1675.21, ["Neon|Fly|Ride"] = 2197.37, ["Mega"] = 6277.13, ["Mega|Fly|Ride"] = 6643.53}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 84, ["Fly"] = 279.6, ["Ride"] = 121.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 719.91, ["Neon|Fly|Ride"] = 623.65, ["Mega|Fly|Ride"] = 2151.35}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.1, ["Fly"] = 65.62, ["Ride"] = 27.9, ["Fly|Ride"] = 85.52, ["Neon"] = 111.98, ["Neon|Fly"] = 1265.84, ["Neon|Ride"] = 125.53, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 975.22, ["Mega|Ride"] = 837.1, ["Mega|Fly|Ride"] = 837.1}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.77, ["Fly"] = 33.52, ["Ride"] = 23.63, ["Fly|Ride"] = 44.36, ["Neon"] = 209.42, ["Neon|Ride"] = 316.77, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2232.95}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 12.74, ["Ride"] = 26.24, ["Fly|Ride"] = 116.71, ["Neon"] = 130.73, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 231.26, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Fly"] = 77.51, ["Ride"] = 19.91, ["Fly|Ride"] = 48.47, ["Neon"] = 35.43, ["Neon|Ride"] = 55.77, ["Neon|Fly|Ride"] = 138.13, ["Mega"] = 316.01, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.23, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 837.1, ["Neon|Ride"] = 174.76, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 630, ["Mega|Ride"] = 1246.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 420, ["Fly"] = 538.12, ["Ride"] = 447.14, ["Fly|Ride"] = 494.82, ["Neon"] = 1570.51, ["Neon|Ride"] = 1464.91, ["Neon|Fly|Ride"] = 1147.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5438.98}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.31, ["Fly|Ride"] = 31.5, ["Neon"] = 18.38, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 68.93, ["Mega"] = 837.1, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.19, ["Fly"] = 100.63, ["Ride"] = 72.19, ["Fly|Ride"] = 127.33, ["Neon"] = 192.94, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 255.81, ["Mega"] = 575.05, ["Mega|Ride"] = 582.65, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Fly"] = 1006.78, ["Ride"] = 800.42, ["Fly|Ride"] = 853.12, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1674.74, ["Mega|Fly|Ride"] = 3934.88}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.37, ["Fly"] = 70.18, ["Ride"] = 45.94, ["Fly|Ride"] = 78.75, ["Neon"] = 282.59, ["Neon|Ride"] = 158.09, ["Neon|Fly|Ride"] = 237.56, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 384.3, ["Fly"] = 384.56, ["Ride"] = 288.74, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1814.39, ["Neon|Fly|Ride"] = 1116.48}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 274.37, ["Ride"] = 194.85, ["Fly|Ride"] = 196.77, ["Neon"] = 977.91, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 819.31, ["Mega|Fly|Ride"] = 3460.33}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.68, ["Fly|Ride"] = 939.39, ["Neon|Fly|Ride"] = 2999.92, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.57, ["Fly"] = 83.77, ["Ride"] = 41.67, ["Fly|Ride"] = 110.25, ["Neon"] = 104.71, ["Neon|Fly"] = 284.73, ["Neon|Ride"] = 106.74, ["Neon|Fly|Ride"] = 150.69, ["Mega"] = 354.38, ["Mega|Ride"] = 335.65, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Ride"] = 3936.19, ["Fly|Ride"] = 3587.01, ["Neon"] = 13960.7, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 24911.74}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 111.09, ["Fly"] = 166.28, ["Ride"] = 135.99, ["Fly|Ride"] = 161.32, ["Neon"] = 472.5, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.01, ["Fly"] = 27.24, ["Ride"] = 19.7, ["Fly|Ride"] = 43.99, ["Neon"] = 16.78, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 140.22, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 363.11, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.62, ["Ride"] = 24.55, ["Fly|Ride"] = 57.71, ["Neon"] = 20.35, ["Neon|Fly"] = 116.28, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 151.11, ["Mega|Ride"] = 203.11, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 25.99, ["Fly"] = 83.78, ["Ride"] = 39.37, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1118.25}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 974.52, ["Ride"] = 985.13, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7115.42, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.46, ["Fly"] = 36.01, ["Ride"] = 25.08, ["Fly|Ride"] = 39.35, ["Neon"] = 452.12, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 199.17, ["Mega"] = 2511.27, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.81, ["Fly"] = 70.26, ["Ride"] = 24.94, ["Fly|Ride"] = 74.46, ["Neon"] = 85.31, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 127.66, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 662.17, ["Mega|Ride"] = 604.82, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 73.49, ["Fly"] = 157.49, ["Ride"] = 72.18, ["Fly|Ride"] = 104.9, ["Neon|Ride"] = 452.81, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 1695.36}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 229.69, ["Fly|Ride"] = 335.06, ["Neon|Ride"] = 977.8, ["Neon|Fly|Ride"] = 977.73, ["Mega|Fly|Ride"] = 4587.59}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.72, ["Ride"] = 32.78, ["Fly|Ride"] = 93.09, ["Neon"] = 19.69, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 94.18, ["Mega"] = 145.27, ["Mega|Fly"] = 226.4, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 284.63}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.61, ["Fly"] = 237.71, ["Ride"] = 209.27, ["Fly|Ride"] = 288.75, ["Neon"] = 900.46, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1102.88, ["Mega"] = 3208.15, ["Mega|Fly|Ride"] = 3471.84}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.78, ["Fly"] = 41.9, ["Ride"] = 14.44, ["Fly|Ride"] = 35.28, ["Neon"] = 17.64, ["Neon|Fly"] = 125.57, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 223.13, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 279.6, ["Ride"] = 210, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 870.58, ["Mega"] = 10463.6, ["Mega|Ride"] = 4708.64, ["Mega|Fly|Ride"] = 4880.23}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.26, ["Fly"] = 74.37, ["Ride"] = 28.25, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 301.34, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 487.62, ["Mega|Ride"] = 530.53, ["Mega|Fly|Ride"] = 447.86}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 23.77, ["Neon"] = 28.88, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 65.63, ["Mega|Ride"] = 115.02, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Mega"] = 18, ["Mega|Ride"] = 140.01, ["Mega|Fly|Ride"] = 313.92}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 107.85, ["Neon"] = 10.48, ["Neon|Ride"] = 34.92, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 70.44, ["Mega|Fly"] = 158179.6, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 75.5, ["Fly"] = 149.97, ["Ride"] = 105.45, ["Fly|Ride"] = 128.63, ["Neon"] = 249.27, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 361.23, ["Mega|Fly|Ride"] = 1196.6}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.43, ["Ride"] = 15.73, ["Fly|Ride"] = 111, ["Neon"] = 9.15, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 94.91, ["Mega|Ride"] = 154.87, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.13, ["Neon"] = 78.61, ["Neon|Ride"] = 259.88, ["Mega|Ride"] = 319.45, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.23, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 15.38, ["Mega|Ride"] = 55.84, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 61.74, ["Ride"] = 15.72, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 13.89, ["Neon|Fly|Ride"] = 37.97, ["Mega"] = 12.75, ["Mega|Fly"] = 41.88, ["Mega|Ride"] = 19.05, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 17.82, ["Ride"] = 12.71, ["Fly|Ride"] = 62.84, ["Neon"] = 3.33, ["Neon|Fly"] = 39.29, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 140.22, ["Mega|Fly"] = 158.99, ["Mega|Ride"] = 39.77, ["Mega|Fly|Ride"] = 77.6}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 64.88, ["Mega"] = 41.88, ["Mega|Ride"] = 121.38, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 20.95, ["Fly|Ride"] = 107.62, ["Neon"] = 3.67, ["Neon|Fly"] = 167.97, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.09, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 15.6, ["Mega|Fly"] = 94.91, ["Mega|Ride"] = 791.31, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.33, ["Fly"] = 77.44, ["Ride"] = 32.78, ["Fly|Ride"] = 70.17, ["Neon"] = 12.36, ["Neon|Fly"] = 69.27, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 119.17, ["Mega"] = 104.99, ["Mega|Fly"] = 279.56, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 12.38, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 60.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 141.36, ["Fly|Ride"] = 525, ["Neon"] = 16.64, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 542.04}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.7, ["Mega"] = 78.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.76, ["Neon|Ride"] = 27.23, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 19.14, ["Mega|Ride"] = 59.33, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.58, ["Fly|Ride"] = 45.94, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 32.24, ["Mega"] = 13.13, ["Mega|Fly"] = 60.52, ["Mega|Ride"] = 19.65, ["Mega|Fly|Ride"] = 50.06}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Fly|Ride"] = 118.11, ["Neon"] = 37.4, ["Neon|Ride"] = 140.95, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 167.43, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 26.45, ["Neon"] = 2.63, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 19.69, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 171.62}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.34, ["Neon"] = 14.07, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 94.4, ["Mega|Ride"] = 167.43, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 46.09, ["Fly|Ride"] = 28.88, ["Neon"] = 21.86, ["Neon|Ride"] = 49.19, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 1.79, ["Fly"] = 12.5, ["Ride"] = 11.12, ["Fly|Ride"] = 26.58, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 13.14, ["Neon|Fly|Ride"] = 27.23, ["Mega"] = 14.8, ["Mega|Fly"] = 26.04, ["Mega|Ride"] = 15.22, ["Mega|Fly|Ride"] = 51.09}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.24, ["Fly"] = 28.29, ["Ride"] = 27.39, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.58, ["Fly"] = 112.03, ["Ride"] = 23.3, ["Fly|Ride"] = 59.06, ["Neon"] = 44.07, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 234.94, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.23, ["Ride"] = 13.01, ["Fly|Ride"] = 43.19, ["Neon"] = 2.5, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 35.2, ["Mega"] = 21, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 1.79, ["Fly"] = 174.87, ["Ride"] = 29.32, ["Neon"] = 5.29, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 166.39, ["Mega"] = 63.92, ["Mega|Fly"] = 167.43, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 65.63, ["Neon"] = 4.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.47, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 34.7, ["Mega|Fly"] = 140.22, ["Mega|Ride"] = 140.3, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 1.79, ["Fly"] = 35.62, ["Ride"] = 18.38, ["Neon"] = 2.1, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 359.4, ["Mega"] = 13.12, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 167.43}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.18, ["Ride"] = 23.63, ["Fly|Ride"] = 41.9, ["Neon"] = 5.15, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 137.61, ["Mega|Ride"] = 91.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 54.91, ["Fly|Ride"] = 45.94, ["Neon"] = 6.07, ["Neon|Ride"] = 62.07, ["Mega"] = 40.58, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 249.26}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.05, ["Ride"] = 15.31, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.6, ["Ride"] = 36.27, ["Fly|Ride"] = 50.05, ["Neon"] = 41.56, ["Neon|Fly"] = 244.86, ["Neon|Ride"] = 75.35, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.29, ["Fly|Ride"] = 57.48, ["Neon"] = 12.77, ["Neon|Fly"] = 56.52, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 315, ["Mega|Fly"] = 420, ["Mega|Ride"] = 151.34}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.52, ["Ride"] = 21.58, ["Fly|Ride"] = 52.49, ["Neon"] = 13.13, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 167.43, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 223.94}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 7.87, ["Fly"] = 111, ["Neon"] = 71.31, ["Mega"] = 236.23, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 7.88, ["Ride"] = 56.44, ["Neon"] = 209.51, ["Neon|Ride"] = 237.28, ["Mega|Ride"] = 697.93, ["Mega|Fly|Ride"] = 794.2}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.64, ["Ride"] = 27.78, ["Neon"] = 41.9, ["Neon|Ride"] = 126, ["Mega"] = 236.15, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.67, ["Ride"] = 30.95, ["Fly|Ride"] = 120.75, ["Neon"] = 50.82, ["Neon|Ride"] = 66.64, ["Mega"] = 474.55, ["Mega|Ride"] = 313.92, ["Mega|Fly|Ride"] = 361.6}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 64.99, ["Mega"] = 21, ["Mega|Fly"] = 62.79, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 40.46}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.48, ["Fly"] = 23.61, ["Ride"] = 20.6, ["Fly|Ride"] = 41.15, ["Neon"] = 53.47, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.62, ["Mega"] = 271.44, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 286.79}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.01, ["Fly|Ride"] = 44.63, ["Neon"] = 2.63, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 26.41, ["Neon|Fly|Ride"] = 156.61, ["Mega"] = 24.68, ["Mega|Fly"] = 140.22, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 48.18, ["Neon"] = 3.94, ["Neon|Ride"] = 33.11, ["Neon|Fly|Ride"] = 95.23, ["Mega"] = 38.3, ["Mega|Ride"] = 73.78, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.23, ["Ride"] = 16.28, ["Fly|Ride"] = 55.65, ["Neon"] = 6.56, ["Neon|Ride"] = 19.9, ["Neon|Fly|Ride"] = 126.95, ["Mega"] = 125.57, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 170.02}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 8.39, ["Ride"] = 36.75, ["Fly|Ride"] = 57.75, ["Neon"] = 35.04, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 124.69, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 312.87}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 31.82, ["Neon"] = 2.2, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 334.85}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 16.49, ["Fly|Ride"] = 32.71, ["Neon"] = 2.63, ["Neon|Fly"] = 110.93, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 28.62, ["Mega|Fly"] = 143.15, ["Mega|Ride"] = 38.68, ["Mega|Fly|Ride"] = 129.76}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 15.75, ["Fly|Ride"] = 42, ["Neon"] = 4.86, ["Neon|Fly"] = 91.37, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 56.52, ["Mega|Fly"] = 140.22, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 52.91, ["Fly|Ride"] = 131.25, ["Neon"] = 3.6, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 32.36, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 220.65}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 152799.54, ["Mega"] = 23.79, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 110.29}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 1.79, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 79.58, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.2, ["Mega|Fly"] = 62.79, ["Mega|Ride"] = 41.41, ["Mega|Fly|Ride"] = 98.46}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 1.79, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Mega"] = 60.52, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.61, ["Neon"] = 2.62, ["Neon|Ride"] = 316.77, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.71, ["Mega|Ride"] = 153.62}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.32, ["Fly|Ride"] = 49.87, ["Neon"] = 3.94, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 125.57, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.58, ["Ride"] = 77.96, ["Neon"] = 125.98, ["Mega"] = 454.54, ["Mega|Ride"] = 3163.99}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 42}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.34, ["Fly|Ride"] = 178.01, ["Neon"] = 25.99, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 397.95, ["Mega|Ride"] = 404.96, ["Mega|Fly|Ride"] = 375.27}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 15.65, ["Fly|Ride"] = 25.3, ["Neon"] = 2.1, ["Neon|Fly"] = 20.9, ["Neon|Ride"] = 10.49, ["Neon|Fly|Ride"] = 25.91, ["Mega"] = 12.89, ["Mega|Fly"] = 22.81, ["Mega|Ride"] = 20.63, ["Mega|Fly|Ride"] = 40.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Fly|Ride"] = 157.07, ["Neon"] = 5.25, ["Neon|Fly"] = 66.97, ["Neon|Ride"] = 32.46, ["Neon|Fly|Ride"] = 697.93, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 1.79, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.41, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 125.57}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 18.05, ["Mega|Fly|Ride"] = 167.43}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.97, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 11.18, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 183.75, ["Mega|Ride"] = 197.91, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 163.86, ["Fly"] = 183.75, ["Ride"] = 210, ["Fly|Ride"] = 837.62, ["Neon|Fly|Ride"] = 939.65, ["Mega"] = 8370.88, ["Mega|Ride"] = 3209.19, ["Mega|Fly|Ride"] = 3313.84}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.1, ["Neon"] = 7.88, ["Neon|Ride"] = 64.32, ["Mega"] = 77.8, ["Mega|Ride"] = 167.43, ["Mega|Fly|Ride"] = 622.59}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.2, ["Fly"] = 64.97, ["Ride"] = 26.13, ["Fly|Ride"] = 58.47, ["Neon"] = 24.86, ["Neon|Ride"] = 94.91, ["Neon|Fly|Ride"] = 167.43, ["Mega"] = 381.82, ["Mega|Ride"] = 420.97, ["Mega|Fly|Ride"] = 417.52}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 1.79, ["Fly"] = 14.9, ["Ride"] = 13.6, ["Fly|Ride"] = 32.79, ["Neon"] = 3.94, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 40.36, ["Mega"] = 49.68, ["Mega|Ride"] = 81.29, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.18, ["Ride"] = 19.69, ["Fly|Ride"] = 92.57, ["Neon"] = 6.85, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 189.82}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 6.57, ["Fly"] = 23.73, ["Ride"] = 15.01, ["Fly|Ride"] = 36, ["Neon"] = 28.62, ["Neon|Fly"] = 98.37, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 4.97, ["Ride"] = 34.32, ["Fly|Ride"] = 251.29, ["Neon"] = 79.24, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 406.26, ["Mega|Fly|Ride"] = 1046.37}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 4.16, ["Fly"] = 15.65, ["Ride"] = 15.24, ["Fly|Ride"] = 35.17, ["Neon"] = 20.27, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 28.8, ["Neon|Fly|Ride"] = 69.66, ["Mega"] = 131.25, ["Mega|Ride"] = 209.28, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 66.93, ["Ride"] = 72.19, ["Fly|Ride"] = 131.23, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.12, ["Fly"] = 335.06, ["Ride"] = 236.67, ["Fly|Ride"] = 280.72, ["Neon|Ride"] = 1116.48, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10463.6, ["Mega|Fly|Ride"] = 4838.37}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.55, ["Fly"] = 140.31, ["Ride"] = 70.88, ["Fly|Ride"] = 99.2, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1750.88}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.44, ["Fly"] = 287.6, ["Ride"] = 23.63, ["Fly|Ride"] = 137.45, ["Neon"] = 28.38, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 309.72, ["Mega|Ride"] = 376.7, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.64, ["Fly"] = 70.17, ["Ride"] = 20.35, ["Fly|Ride"] = 62.76, ["Neon"] = 81.38, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 195.68, ["Mega"] = 352.8, ["Mega|Ride"] = 390.75, ["Mega|Fly|Ride"] = 1255.64}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 12.62, ["Fly|Ride"] = 44.51, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 49.89, ["Mega|Ride"] = 130.1, ["Mega|Fly|Ride"] = 83.61}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.7, ["Fly"] = 72.12, ["Ride"] = 21.41, ["Fly|Ride"] = 81.38, ["Neon"] = 125.82, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 173.71, ["Mega"] = 393.75, ["Mega|Ride"] = 832.92, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 13.13, ["Fly|Ride"] = 32.81, ["Neon"] = 11.82, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 131.25, ["Mega|Ride"] = 217.68, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 21.18, ["Fly|Ride"] = 328.13, ["Neon"] = 22.28, ["Neon|Ride"] = 35.6, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 474.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 33.52, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.43, ["Mega|Ride"] = 41.88, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 18.38, ["Fly|Ride"] = 41.9, ["Neon"] = 13.58, ["Neon|Fly"] = 104.65, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 147, ["Mega"] = 108.94, ["Mega|Ride"] = 194.63, ["Mega|Fly|Ride"] = 209.28}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.17, ["Ride"] = 16.96, ["Fly|Ride"] = 61.53, ["Neon"] = 26.25, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 203.01, ["Mega|Fly|Ride"] = 223.94}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 116.83, ["Fly"] = 154.34, ["Ride"] = 140.81, ["Fly|Ride"] = 214.04, ["Neon"] = 676.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 617.61, ["Mega"] = 4185.44, ["Mega|Ride"] = 2720.54, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.33, ["Ride"] = 32.47, ["Fly|Ride"] = 127.03, ["Neon"] = 45.96, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 328.13, ["Mega|Ride"] = 397.63, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.52, ["Fly"] = 41.91, ["Ride"] = 15.59, ["Fly|Ride"] = 35.62, ["Neon"] = 19.69, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 237.28, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 316.77}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.69, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 192.33, ["Neon|Fly|Ride"] = 614.98, ["Mega"] = 660.77, ["Mega|Fly"] = 837.1, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 617.37}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 11.59}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 117.41, ["Neon"] = 41.9, ["Neon|Ride"] = 102.56, ["Neon|Fly|Ride"] = 349.5, ["Mega"] = 629.9, ["Mega|Ride"] = 572.38, ["Mega|Fly|Ride"] = 870.79}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.58, ["Fly"] = 26.2, ["Ride"] = 31.36, ["Fly|Ride"] = 49.24, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2092.73, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 1.79, ["Ride"] = 19.27, ["Fly|Ride"] = 69.12, ["Neon"] = 3.52, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 25.67, ["Neon|Fly|Ride"] = 106.3, ["Mega"] = 28.3, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.21, ["Fly"] = 28.29, ["Ride"] = 24.1, ["Fly|Ride"] = 62.84, ["Neon"] = 52.41, ["Neon|Ride"] = 237.28, ["Mega"] = 279.55, ["Mega|Fly"] = 396.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 380.89}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.78, ["Fly|Ride"] = 47.08, ["Neon"] = 17.34, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 1.79, ["Ride"] = 32.45, ["Fly|Ride"] = 209.42, ["Neon"] = 3.15, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 23.94, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.21, ["Ride"] = 74.45, ["Fly|Ride"] = 142.47, ["Neon"] = 280.54, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 808.07, ["Mega|Ride"] = 949.09, ["Mega|Fly|Ride"] = 1116.48}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.34, ["Ride"] = 28.29, ["Fly|Ride"] = 210, ["Neon"] = 92.14, ["Neon|Ride"] = 140.22, ["Mega"] = 140.22, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.65, ["Fly"] = 33.52, ["Ride"] = 18.8, ["Fly|Ride"] = 47.15, ["Neon"] = 18.72, ["Neon|Fly"] = 84, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 183.75, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.05, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 544.13, ["Mega"] = 4431, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 8.91, ["Fly"] = 32.71, ["Ride"] = 23.55, ["Fly|Ride"] = 57.64, ["Neon"] = 46.07, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 47.46, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 224.44, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 694.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 59.07, ["Fly"] = 140.31, ["Ride"] = 87.72, ["Fly|Ride"] = 150.93, ["Neon"] = 266.44, ["Neon|Ride"] = 241.5, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1255.64, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1091.27}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 15.49, ["Ride"] = 43.31, ["Fly|Ride"] = 140.6, ["Neon"] = 72.18, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 223.97, ["Mega"] = 415.24, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.25, ["Fly"] = 40.94, ["Ride"] = 28.29, ["Fly|Ride"] = 62.84, ["Neon"] = 77.49, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 377.27, ["Mega"] = 209.28, ["Mega|Ride"] = 1569.56, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.21, ["Ride"] = 39.36, ["Fly|Ride"] = 162.54, ["Neon"] = 66.99, ["Neon|Ride"] = 111.98, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 299.57, ["Mega|Ride"] = 321.46, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 3.59, ["Ride"] = 24.81, ["Fly|Ride"] = 90.17, ["Neon"] = 30.75, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.88, ["Mega|Ride"] = 288.09, ["Mega|Fly|Ride"] = 402.06}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 56.52, ["Mega"] = 26.25, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.42, ["Neon"] = 23.79, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 105, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.61, ["Neon"] = 28.74, ["Mega"] = 170.55, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.14, ["Ride"] = 32.79, ["Fly|Ride"] = 118.72, ["Neon"] = 30.38, ["Neon|Ride"] = 78.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.88, ["Ride"] = 624.75, ["Fly|Ride"] = 603.75, ["Neon"] = 1815.51, ["Neon|Ride"] = 1843.58, ["Neon|Fly|Ride"] = 1939.96, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.94, ["Fly"] = 28.29, ["Ride"] = 20.01, ["Fly|Ride"] = 56.34, ["Neon"] = 40.85, ["Neon|Ride"] = 60.69, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 215.56, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 475.07}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.16, ["Fly"] = 524.69, ["Ride"] = 31.12, ["Fly|Ride"] = 51.54, ["Neon"] = 48.56, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 331.86, ["Mega|Ride"] = 445.77, ["Mega|Fly|Ride"] = 400.21}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 27.09, ["Fly|Ride"] = 314.11, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 70.11}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 1.79, ["Fly"] = 65.59, ["Ride"] = 21.95, ["Fly|Ride"] = 90.57, ["Neon"] = 6.57, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 87.8, ["Mega"] = 52.41, ["Mega|Fly"] = 279.39, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 210.5}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 1.79, ["Fly"] = 70.17, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 20.87, ["Mega|Fly"] = 195.68, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.95}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.55, ["Ride"] = 140.31, ["Fly|Ride"] = 326.67, ["Neon"] = 65.63, ["Neon|Ride"] = 91.75, ["Mega"] = 459.38, ["Mega|Ride"] = 579.7, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.38, ["Neon"] = 5.16, ["Neon|Ride"] = 56.44, ["Mega"] = 39.38, ["Mega|Ride"] = 102.56, ["Mega|Fly|Ride"] = 251.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 385.81, ["Ride"] = 65.63, ["Neon"] = 22.97, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1046.37}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 485.63, ["Fly|Ride"] = 542.97, ["Neon|Ride"] = 2092.67, ["Neon|Fly|Ride"] = 2092.72, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.55, ["Fly"] = 196.88, ["Ride"] = 56.56, ["Fly|Ride"] = 418.82, ["Neon"] = 36.4, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 189.82, ["Mega"] = 522.15, ["Mega|Ride"] = 474.55, ["Mega|Fly|Ride"] = 696.4}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 1.79, ["Fly"] = 90.33, ["Ride"] = 23.12, ["Fly|Ride"] = 118.13, ["Neon"] = 6.24, ["Neon|Ride"] = 36.16, ["Neon|Fly|Ride"] = 99.04, ["Mega"] = 37.06, ["Mega|Fly"] = 125.57, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 278.43}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 1.79, ["Neon"] = 2.2, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 30.51, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.28, ["Fly"] = 107.63, ["Ride"] = 80.06, ["Neon"] = 127.75, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 544.13, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.05, ["Ride"] = 71.31, ["Neon"] = 80.33, ["Neon|Ride"] = 158.99, ["Neon|Fly|Ride"] = 535.05, ["Mega"] = 496.13, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 488.66}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 7.51, ["Ride"] = 31.38, ["Neon"] = 131.25, ["Neon|Ride"] = 178.34, ["Mega"] = 648.95, ["Mega|Ride"] = 1074.63, ["Mega|Fly|Ride"] = 1255.64}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 19.03, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 616.77, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 697.93}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 508.09, ["Neon"] = 1115.63, ["Neon|Ride"] = 1395.85, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4009.85}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.56, ["Fly"] = 78.75, ["Ride"] = 19.9, ["Fly|Ride"] = 64.4, ["Neon"] = 145.69, ["Neon|Ride"] = 158.99, ["Neon|Fly|Ride"] = 195.82, ["Mega"] = 837.1, ["Mega|Ride"] = 731.41, ["Mega|Fly|Ride"] = 723.05}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.58, ["Ride"] = 126, ["Fly|Ride"] = 127.32, ["Neon"] = 63.03, ["Neon|Ride"] = 157.5, ["Mega"] = 367.5, ["Mega|Ride"] = 349.5, ["Mega|Fly|Ride"] = 1046.37}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 9.65, ["Fly"] = 140.31, ["Ride"] = 96.03, ["Fly|Ride"] = 111.61, ["Neon"] = 69.47, ["Neon|Ride"] = 149.48, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 272.87, ["Mega|Fly"] = 697.93, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 41.9, ["Fly|Ride"] = 140.31, ["Neon"] = 6.47, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 36.5, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 228.37}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.28, ["Ride"] = 77.16, ["Neon"] = 315, ["Neon|Ride"] = 417.52, ["Neon|Fly|Ride"] = 461.46, ["Mega"] = 2511.27, ["Mega|Ride"] = 2770.78, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 1.79, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 7.29, ["Neon|Fly"] = 182.07, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 125.56, ["Mega"] = 70.88, ["Mega|Ride"] = 70.11, ["Mega|Fly|Ride"] = 215.91}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 1.79, ["Fly"] = 26.22, ["Ride"] = 27.51, ["Neon"] = 4.67, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 40.69, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 1.79, ["Ride"] = 37.97, ["Fly|Ride"] = 125.85, ["Neon"] = 14.44, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 87.94, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 130.71, ["Mega|Fly|Ride"] = 308.69}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.9, ["Fly"] = 77.51, ["Ride"] = 60.26, ["Fly|Ride"] = 169.32, ["Neon"] = 341.25, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 475.04, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.85, ["Ride"] = 295.32, ["Fly|Ride"] = 417.77, ["Neon"] = 1455.35, ["Neon|Ride"] = 1157.88, ["Neon|Fly|Ride"] = 1304.99, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.72, ["Neon"] = 27.57, ["Neon|Fly"] = 350.44, ["Mega"] = 108.83, ["Mega|Ride"] = 212.52}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.14, ["Neon"] = 8.34, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 61.68, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.45, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 30.89, ["Ride"] = 27.57, ["Fly|Ride"] = 47.5, ["Neon"] = 32.8, ["Mega"] = 136.83, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 391.35}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 90.96, ["Ride"] = 35.62, ["Fly|Ride"] = 372.75, ["Neon"] = 11.22, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 124.29, ["Mega|Ride"] = 161.15, ["Mega|Fly|Ride"] = 256.27}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 1.79, ["Ride"] = 59.07, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 191.49, ["Mega"] = 52.5, ["Mega|Ride"] = 141.27, ["Mega|Fly|Ride"] = 346.36}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 17.91, ["Fly|Ride"] = 51.19, ["Neon"] = 4.11, ["Neon|Fly"] = 79.5, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 39.38, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.71, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 41.9, ["Neon"] = 15.14, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 94.91, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 23.5, ["Ride"] = 31.8, ["Fly|Ride"] = 78.66, ["Neon|Ride"] = 265.79, ["Neon|Fly|Ride"] = 317.71, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.82, ["Ride"] = 78.66, ["Fly|Ride"] = 137.73, ["Neon"] = 519.33, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3163.99, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 140.31, ["Neon"] = 2.7, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 38.31, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 1.79, ["Fly"] = 14.11, ["Ride"] = 14.17, ["Fly|Ride"] = 28.27, ["Neon"] = 5.25, ["Neon|Fly"] = 28.26, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.73, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.72, ["Ride"] = 73.5, ["Neon"] = 36.75, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 527.62, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 633.52}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1898.16, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 7909.35}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.41, ["Fly"] = 101.33, ["Ride"] = 40.68, ["Fly|Ride"] = 84.73, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.8, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 1898.16}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 20.96, ["Fly|Ride"] = 281.31, ["Neon"] = 7.88, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 169.53, ["Mega"] = 84.35, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 272.43}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.82}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.59, ["Fly"] = 169.3, ["Ride"] = 35.89, ["Fly|Ride"] = 52.41, ["Neon"] = 194.25, ["Neon|Ride"] = 355.78, ["Neon|Fly|Ride"] = 185.07, ["Mega"] = 2511.27, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1203.34}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.16, ["Fly"] = 91.88, ["Ride"] = 111.16, ["Fly|Ride"] = 188.48, ["Neon"] = 434.44, ["Neon|Ride"] = 556.68, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8370.88, ["Mega|Fly|Ride"] = 2270.62}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.57, ["Ride"] = 269.16, ["Fly|Ride"] = 504.1, ["Neon"] = 1050, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.4, ["Fly"] = 56.56, ["Ride"] = 35.06, ["Fly|Ride"] = 96.17, ["Neon"] = 83.26, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 349.5, ["Mega"] = 388.5, ["Mega|Ride"] = 418, ["Mega|Fly|Ride"] = 508.95}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 13.8, ["Fly|Ride"] = 41.9, ["Neon"] = 11.7, ["Neon|Ride"] = 21.98, ["Neon|Fly|Ride"] = 91.04, ["Mega"] = 63, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 15.32, ["Fly|Ride"] = 77.6, ["Neon"] = 30.77, ["Neon|Fly"] = 105, ["Neon|Ride"] = 36.05, ["Neon|Fly|Ride"] = 73.83, ["Mega"] = 381.09, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 295.32, ["Fly"] = 489.02, ["Ride"] = 391.11, ["Fly|Ride"] = 466.97, ["Neon"] = 1575, ["Neon|Ride"] = 2029.3, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 10045.06, ["Mega|Fly|Ride"] = 5870.21}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 30.85, ["Mega|Ride"] = 170.98}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Ride"] = 15.73, ["Fly|Ride"] = 55.13, ["Neon"] = 26.13, ["Neon|Ride"] = 36.41, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 231.38, ["Mega|Ride"] = 194.35, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.74, ["Ride"] = 71.24, ["Neon"] = 129.94, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 236.25, ["Mega"] = 590.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.78, ["Fly"] = 157.5, ["Ride"] = 103.58, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.43, ["Fly"] = 43.19, ["Ride"] = 23.12, ["Fly|Ride"] = 56.56, ["Neon"] = 104.71, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 697.93, ["Mega|Ride"] = 471.19, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 20.96, ["Neon"] = 2.1, ["Neon|Ride"] = 140.22, ["Mega"] = 24.92, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 272.07}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 1.79, ["Fly"] = 39.37, ["Ride"] = 13.13, ["Fly|Ride"] = 70.17, ["Neon"] = 2.24, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 77.59, ["Mega"] = 25.85, ["Mega|Fly"] = 92.26, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.13, ["Ride"] = 52.42, ["Fly|Ride"] = 141.93, ["Neon"] = 30.44, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 206.94, ["Mega"] = 140.22, ["Mega|Ride"] = 204.65, ["Mega|Fly|Ride"] = 308.34}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1638.37, ["Ride"] = 1443.75, ["Fly|Ride"] = 1302, ["Neon"] = 4200, ["Neon|Ride"] = 4108.13, ["Neon|Fly|Ride"] = 4121.71, ["Mega|Fly|Ride"] = 12598.69}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 393.75, ["Ride"] = 479.07, ["Fly|Ride"] = 633.23, ["Neon"] = 2458.37, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 2511.27, ["Mega"] = 16741.75, ["Mega|Fly|Ride"] = 7046.2}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 284.82, ["Ride"] = 315, ["Fly|Ride"] = 462.32, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 230.82, ["Fly"] = 334.69, ["Ride"] = 318.32, ["Fly|Ride"] = 388.49, ["Neon"] = 777, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 851.75}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.64, ["Fly|Ride"] = 37.68, ["Neon"] = 3.82, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.42, ["Mega|Fly"] = 103.6, ["Mega|Ride"] = 111.98, ["Mega|Fly|Ride"] = 135.07}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 334.69, ["Fly"] = 1396.71, ["Ride"] = 420, ["Fly|Ride"] = 519.23, ["Neon"] = 1575, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 3498.53, ["Mega"] = 21206.57, ["Mega|Ride"] = 6696.71, ["Mega|Fly|Ride"] = 4272.19}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.85, ["Fly"] = 183.75, ["Ride"] = 41.9, ["Fly|Ride"] = 159.09, ["Neon"] = 18.33, ["Neon|Ride"] = 207.34, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.81, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 497.04}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 17.93, ["Ride"] = 15.12, ["Fly|Ride"] = 31.98, ["Neon"] = 11.82, ["Neon|Ride"] = 32.85, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 104.9, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 150.69}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Neon"] = 2.49, ["Neon|Ride"] = 39.36, ["Mega"] = 40.36, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.95, ["Ride"] = 55.49, ["Fly|Ride"] = 459.37, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 25.99, ["Fly|Ride"] = 68.24, ["Neon"] = 34.43, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 404.96, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 1.79, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 100.85, ["Mega"] = 20.79, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 161.15}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 18.34, ["Fly|Ride"] = 64.46, ["Neon"] = 12.95, ["Neon|Fly"] = 111.98, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 129.62, ["Mega|Fly"] = 474.55, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.09, ["Fly"] = 56.56, ["Ride"] = 15.8, ["Fly|Ride"] = 52.5, ["Neon"] = 35.76, ["Neon|Fly"] = 142.37, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 238.82, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.13, ["Ride"] = 62.84, ["Neon"] = 115.5, ["Neon|Fly|Ride"] = 269.32, ["Mega"] = 514.88, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.48, ["Fly"] = 6331.95, ["Ride"] = 19.59, ["Neon"] = 19.69, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 711.82, ["Mega"] = 301.88, ["Mega|Ride"] = 413.33, ["Mega|Fly|Ride"] = 402.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.37, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.03, ["Mega"] = 39.29, ["Mega|Ride"] = 179.16, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 156.19, ["Ride"] = 164.07, ["Fly|Ride"] = 254.63, ["Neon|Ride"] = 899.89, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8370.88, ["Mega|Ride"] = 4185.44, ["Mega|Fly|Ride"] = 3486}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 1.79, ["Fly"] = 19.04, ["Ride"] = 14.44, ["Fly|Ride"] = 28.61, ["Neon"] = 2.38, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 56.26, ["Mega"] = 44.61, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.41, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 89.15, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 791.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.41, ["Ride"] = 104.71, ["Fly|Ride"] = 170.63, ["Neon"] = 137.8, ["Neon|Ride"] = 272.07, ["Mega"] = 977.31, ["Mega|Ride"] = 688.26, ["Mega|Fly|Ride"] = 837.1}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.92, ["Ride"] = 181.91, ["Fly|Ride"] = 316.03, ["Neon"] = 753.64, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3376.62}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 21.52, ["Ride"] = 158.3, ["Fly|Ride"] = 140.31, ["Neon"] = 91.88, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 697.93}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.87, ["Ride"] = 65.63, ["Fly|Ride"] = 182.2, ["Neon"] = 103.95, ["Neon|Fly"] = 158.99, ["Neon|Ride"] = 199, ["Mega"] = 771.89, ["Mega|Ride"] = 837.1, ["Mega|Fly|Ride"] = 977.31}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1036.88, ["Fly"] = 1050, ["Ride"] = 1050, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4745.37, ["Neon|Fly|Ride"] = 4464.83, ["Mega|Fly|Ride"] = 19880.83}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.38, ["Fly"] = 19.69, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 65.98, ["Neon|Fly"] = 41.97, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 225.43, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.34, ["Fly"] = 51.19, ["Ride"] = 26.25, ["Fly|Ride"] = 135.19, ["Neon"] = 35.62, ["Neon|Ride"] = 82.67, ["Mega"] = 228.12, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 264.13}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 1.79, ["Fly"] = 82.73, ["Ride"] = 27.21, ["Fly|Ride"] = 94.24, ["Neon"] = 11.69, ["Neon|Ride"] = 44.94, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 968.94}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.63, ["Fly"] = 57.84, ["Ride"] = 32.11, ["Fly|Ride"] = 83.83, ["Neon"] = 77.42, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.44, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 437.07, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 15.72, ["Fly"] = 20.45, ["Ride"] = 23.77, ["Fly|Ride"] = 51.19, ["Neon"] = 16.77, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 98.48, ["Mega|Fly"] = 251.14, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Neon"] = 10.11, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.97, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Ride"] = 243.34, ["Fly|Ride"] = 349.72, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3684.24}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 15.81, ["Fly|Ride"] = 98.44, ["Neon"] = 6.49, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 124.87, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.12, ["Ride"] = 82.02, ["Fly|Ride"] = 88.86, ["Neon"] = 27.57, ["Neon|Ride"] = 251.14, ["Mega"] = 140.22, ["Mega|Ride"] = 237.28}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.14, ["Fly"] = 98.42, ["Ride"] = 20.9, ["Neon"] = 25.76, ["Neon|Ride"] = 52.5, ["Mega"] = 84.95, ["Mega|Ride"] = 174.57}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 259.77, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1563.28, ["Neon|Fly|Ride"] = 1255.64, ["Mega|Ride"] = 4185.44, ["Mega|Fly|Ride"] = 2847.24}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.22, ["Fly"] = 118.73, ["Ride"] = 47.5, ["Fly|Ride"] = 224.07, ["Neon"] = 181.22, ["Neon|Fly|Ride"] = 324.82, ["Mega"] = 564.38, ["Mega|Ride"] = 837.1, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.54, ["Fly"] = 83.77, ["Ride"] = 31.61, ["Fly|Ride"] = 90.57, ["Neon"] = 97.67, ["Neon|Ride"] = 124.67, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 432.16, ["Mega|Ride"] = 435.2, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Ride"] = 61.74, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.11, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 39.38, ["Fly"] = 5936.07, ["Ride"] = 73.22, ["Fly|Ride"] = 150.92, ["Neon"] = 293.18, ["Neon|Fly"] = 258.8, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 1184.5}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 35.62, ["Neon"] = 5, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 124.52, ["Mega"] = 58.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 23.55, ["Fly"] = 127.29, ["Ride"] = 20.83, ["Fly|Ride"] = 85.49, ["Neon"] = 66.2, ["Neon|Ride"] = 125.15, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 38.1, ["Fly"] = 65.63, ["Ride"] = 96.99, ["Fly|Ride"] = 149.12, ["Neon"] = 183.65, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 417.52, ["Mega|Ride"] = 1954.61, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 16.7, ["Ride"] = 12.1, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 16.76, ["Neon|Fly|Ride"] = 32.71, ["Mega"] = 16.7, ["Mega|Fly"] = 118.64, ["Mega|Ride"] = 32.66, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.22, ["Ride"] = 45.12, ["Fly|Ride"] = 131.15, ["Neon"] = 16.98, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 131.25, ["Mega|Ride"] = 277.61, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.76, ["Ride"] = 51.59, ["Fly|Ride"] = 85.32, ["Neon"] = 110.15, ["Mega"] = 536.71, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 1.79, ["Ride"] = 21.63, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.78, ["Mega|Ride"] = 65.42, ["Mega|Fly|Ride"] = 175.81}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.45, ["Fly"] = 193.36, ["Ride"] = 65.45, ["Fly|Ride"] = 171.73, ["Neon"] = 61.13, ["Neon|Ride"] = 171.62, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 535.76, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 614.23}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.1, ["Fly"] = 41.91, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.97, ["Neon|Ride"] = 108.7, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.31, ["Neon"] = 24.04, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 196.88, ["Mega|Ride"] = 246.68, ["Mega|Fly|Ride"] = 413.33}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6, ["Fly"] = 72.19, ["Ride"] = 70.88, ["Fly|Ride"] = 279.57, ["Neon"] = 53.72, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6326.77, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 940.69}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 19.28, ["Fly|Ride"] = 196.88, ["Neon"] = 6.56, ["Neon|Ride"] = 32.43, ["Mega"] = 69.55, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 148.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 1.79, ["Ride"] = 55.53, ["Neon"] = 6.29, ["Mega"] = 20.9, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 384.39}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.79}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.66, ["Fly"] = 98.43, ["Ride"] = 52.48, ["Fly|Ride"] = 82.66, ["Neon"] = 238.73, ["Neon|Ride"] = 280.13, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.26, ["Mega"] = 17.98, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.25, ["Fly"] = 498.75, ["Ride"] = 511.88, ["Fly|Ride"] = 641.82, ["Neon"] = 2089.83, ["Neon|Fly|Ride"] = 2330.26, ["Mega"] = 16741.75, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.01, ["Fly"] = 26.25, ["Ride"] = 25.47, ["Fly|Ride"] = 65.98, ["Neon"] = 34.26, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 89.51, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 21.65, ["Fly|Ride"] = 69.33, ["Neon"] = 19.04, ["Neon|Ride"] = 40.27, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 140.6, ["Mega|Ride"] = 142.37, ["Mega|Fly|Ride"] = 245.56}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.5, ["Fly"] = 70.18, ["Ride"] = 50.27, ["Fly|Ride"] = 68.86, ["Neon"] = 100.74, ["Neon|Ride"] = 170.57, ["Mega"] = 823.5, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 56.56, ["Ride"] = 28.28, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Neon|Ride"] = 118.13, ["Mega"] = 275.63}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.18, ["Fly"] = 36.66, ["Ride"] = 140.31, ["Fly|Ride"] = 173.24, ["Neon"] = 64.58, ["Neon|Ride"] = 99.75, ["Mega"] = 418.56, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 530.53}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.65, ["Ride"] = 52.99, ["Fly|Ride"] = 133.88, ["Neon"] = 32.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 208.24, ["Mega"] = 393.75, ["Mega|Fly"] = 558.77, ["Mega|Ride"] = 349.99, ["Mega|Fly|Ride"] = 386.94}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 1.79, ["Fly"] = 40.38, ["Ride"] = 13.54, ["Fly|Ride"] = 68.25, ["Neon"] = 2.05, ["Neon|Fly"] = 59.66, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 15.75, ["Mega|Fly"] = 32.04, ["Mega|Ride"] = 25.51, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.97, ["Fly"] = 53.42, ["Ride"] = 19, ["Fly|Ride"] = 104.71, ["Neon"] = 28.64, ["Neon|Fly"] = 118.64, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 223.94, ["Mega"] = 196.84, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Fly"] = 415.53, ["Ride"] = 301.88, ["Fly|Ride"] = 518.28, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9206.03, ["Mega|Fly|Ride"] = 5148.1}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.22, ["Ride"] = 140.31, ["Fly|Ride"] = 279.57, ["Neon"] = 616.88, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2232.95, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1697.64}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.32, ["Fly|Ride"] = 47.5, ["Neon"] = 8.4, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 64.05, ["Mega"] = 62.79, ["Mega|Fly"] = 208.24, ["Mega|Ride"] = 103.6, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 1.79, ["Fly"] = 18.51, ["Ride"] = 13.39, ["Fly|Ride"] = 34.55, ["Neon"] = 6.56, ["Neon|Fly"] = 52.33, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 60.8, ["Mega"] = 65.54, ["Mega|Fly"] = 279.39, ["Mega|Ride"] = 104.65, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.72, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 52.5, ["Mega"] = 272.07, ["Mega|Ride"] = 349.5}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.6, ["Fly"] = 420, ["Ride"] = 245.44, ["Fly|Ride"] = 377.51, ["Neon|Ride"] = 2092.73, ["Neon|Fly|Ride"] = 1548.63, ["Mega|Ride"] = 8370.88, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Ride"] = 15.65, ["Fly|Ride"] = 35.12, ["Neon"] = 17.07, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 110.99, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 417.52}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.32, ["Ride"] = 94.56, ["Fly|Ride"] = 209.42, ["Neon"] = 59.06, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 299.25, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 401.82}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 1.79, ["Ride"] = 82.69, ["Neon"] = 6.15, ["Neon|Ride"] = 155.92, ["Mega"] = 59.07, ["Mega|Ride"] = 209.28}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.15, ["Fly"] = 25.99, ["Ride"] = 19.76, ["Fly|Ride"] = 102.6, ["Neon"] = 80.76, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 510.46, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.63, ["Ride"] = 105.13, ["Fly|Ride"] = 349.72, ["Neon"] = 137.29, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 203.2, ["Neon|Fly|Ride"] = 337.39, ["Mega"] = 402.94, ["Mega|Fly"] = 2197.37, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 577.01}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.05, ["Fly"] = 63, ["Ride"] = 48, ["Fly|Ride"] = 96.34, ["Neon"] = 141.82, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 1.79, ["Fly"] = 20.86, ["Ride"] = 14.94, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.64, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 17.75, ["Mega|Fly"] = 418.56, ["Mega|Ride"] = 36.79, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.27, ["Ride"] = 256.27, ["Fly|Ride"] = 318.93, ["Neon"] = 3108.1, ["Neon|Fly|Ride"] = 1250.41, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.6, ["Fly"] = 101.18, ["Ride"] = 42.36, ["Fly|Ride"] = 105, ["Neon"] = 112.04, ["Neon|Ride"] = 205.1, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 544.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 1.79, ["Fly"] = 32.29, ["Ride"] = 17.67, ["Fly|Ride"] = 42.08, ["Neon"] = 5.92, ["Neon|Fly"] = 38.6, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 110.93, ["Mega"] = 61.74, ["Mega|Fly"] = 279.39, ["Mega|Ride"] = 76.81, ["Mega|Fly|Ride"] = 284.73}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 1.79, ["Fly"] = 31.43, ["Ride"] = 19.81, ["Fly|Ride"] = 43.73, ["Neon"] = 2.58, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 25.32, ["Mega|Fly"] = 140.22, ["Mega|Ride"] = 39.77, ["Mega|Fly|Ride"] = 163.42}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 8.88, ["Neon|Fly"] = 711.82, ["Neon|Ride"] = 48.16, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.68, ["Mega|Ride"] = 191.35, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.65, ["Fly"] = 38.75, ["Ride"] = 23.3, ["Fly|Ride"] = 41.9, ["Neon"] = 44.8, ["Neon|Fly"] = 300.32, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 338.34, ["Mega|Ride"] = 236.23, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.59, ["Ride"] = 56.22, ["Fly|Ride"] = 72.19, ["Neon"] = 38.59, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 316.77, ["Mega|Fly|Ride"] = 349.99}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 1.79, ["Ride"] = 43.32, ["Neon"] = 3.94, ["Neon|Ride"] = 28.61, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 35.15, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.52, ["Ride"] = 26.27, ["Fly|Ride"] = 131.25, ["Neon"] = 24.55, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 106.74, ["Mega"] = 237.28, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.13}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 79.69, ["Neon"] = 3.65, ["Neon|Fly"] = 111.98, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 15.7, ["Mega|Ride"] = 102.56, ["Mega|Fly|Ride"] = 136.04}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.74, ["Ride"] = 17.52, ["Fly|Ride"] = 39.38, ["Neon"] = 4.72, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 120.6, ["Mega"] = 53.67, ["Mega|Fly"] = 140.22, ["Mega|Ride"] = 84.35, ["Mega|Fly|Ride"] = 195.68}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.71, ["Ride"] = 721.88, ["Fly|Ride"] = 913.49, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.23, ["Fly|Ride"] = 31.43, ["Neon"] = 18.35, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 111.54, ["Mega|Fly|Ride"] = 359.97}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 22.57, ["Fly|Ride"] = 279.57, ["Neon"] = 7.02, ["Neon|Fly"] = 732.46, ["Neon|Ride"] = 88.55, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 54.5, ["Mega|Fly"] = 195.68, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 237.54}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.7, ["Fly"] = 47.5, ["Ride"] = 18.01, ["Fly|Ride"] = 36.01, ["Neon"] = 50.6, ["Neon|Fly"] = 189.82, ["Neon|Ride"] = 64.22, ["Neon|Fly|Ride"] = 95.82, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 281.31}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 1.79, ["Fly"] = 20.95, ["Ride"] = 14.38, ["Fly|Ride"] = 32.07, ["Neon"] = 6.69, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 69.21, ["Mega"] = 65.51, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 181.42}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 37.32, ["Ride"] = 83.16, ["Fly|Ride"] = 279.57, ["Neon"] = 281.19, ["Neon|Ride"] = 184.21, ["Mega"] = 974.17, ["Mega|Ride"] = 768.04}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 64.05, ["Neon"] = 5.25, ["Neon|Fly"] = 135.27, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 32.82, ["Mega|Ride"] = 124.94, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 125.9, ["Ride"] = 20.48, ["Fly|Ride"] = 65.63, ["Neon"] = 9.05, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 114.19, ["Mega|Ride"] = 267.88, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Neon"] = 26.25, ["Mega"] = 93.74, ["Mega|Ride"] = 156.97, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 1.79, ["Fly"] = 42, ["Ride"] = 15.72, ["Fly|Ride"] = 49.87, ["Neon"] = 4.75, ["Neon|Ride"] = 24.26, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 38.74, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 63.2}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.73, ["Fly"] = 19.69, ["Ride"] = 17.41, ["Fly|Ride"] = 34.13, ["Neon"] = 316.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 98.44, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 461.49}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 708.11, ["Ride"] = 786.19, ["Fly|Ride"] = 926.63, ["Neon"] = 1765.08, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 2163, ["Mega"] = 4654.5, ["Mega|Ride"] = 6641.25, ["Mega|Fly|Ride"] = 5572.02}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 15.21, ["Fly|Ride"] = 33.79, ["Neon"] = 2.1, ["Neon|Ride"] = 16.87, ["Neon|Fly|Ride"] = 50.96, ["Mega"] = 42.37, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 140.31}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.4, ["Ride"] = 36.75, ["Fly|Ride"] = 202.02, ["Neon"] = 43.31, ["Neon|Fly"] = 71.19, ["Neon|Ride"] = 112.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 366.18, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 533.67}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.12, ["Fly"] = 104.9, ["Ride"] = 53.73, ["Fly|Ride"] = 110.25, ["Neon"] = 514.1, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 382.02, ["Mega"] = 3209.19, ["Mega|Fly|Ride"] = 2040.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.92, ["Ride"] = 41.52, ["Fly|Ride"] = 104.89, ["Neon"] = 210, ["Neon|Ride"] = 219.75, ["Neon|Fly|Ride"] = 308.69, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1014.99}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.47, ["Ride"] = 25.97, ["Fly|Ride"] = 140.31, ["Neon"] = 70.17, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 116.16, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.03, ["Ride"] = 56.55, ["Neon"] = 103.68, ["Neon|Ride"] = 139.61, ["Mega"] = 314.35, ["Mega|Fly"] = 514.88, ["Mega|Ride"] = 373.72, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.48, ["Fly"] = 126.9, ["Fly|Ride"] = 152.17, ["Neon"] = 251.29, ["Neon|Ride"] = 316.77, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 627.82, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.3}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.29, ["Fly"] = 131248.69, ["Ride"] = 20.25, ["Fly|Ride"] = 58.65, ["Neon"] = 31.43, ["Neon|Ride"] = 79.5, ["Neon|Fly|Ride"] = 182.07, ["Mega"] = 196.27, ["Mega|Fly"] = 472.98, ["Mega|Ride"] = 206.45, ["Mega|Fly|Ride"] = 474.55}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.56, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 140.22, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 42, ["Fly"] = 56.56, ["Ride"] = 56.56, ["Fly|Ride"] = 101.29, ["Neon"] = 262.5, ["Neon|Ride"] = 206.67, ["Neon|Fly|Ride"] = 949.09, ["Mega|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 689.07}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.29, ["Fly"] = 17.58, ["Ride"] = 15.23, ["Fly|Ride"] = 33.27, ["Neon"] = 23.18, ["Neon|Fly"] = 61.74, ["Neon|Ride"] = 31.37, ["Neon|Fly|Ride"] = 73.36, ["Mega"] = 196.88, ["Mega|Fly"] = 417.52, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 211.58}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.59, ["Fly"] = 36.66, ["Ride"] = 21.95, ["Fly|Ride"] = 55.7, ["Neon"] = 14.44, ["Neon|Ride"] = 41.48, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 135.83, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 260.3}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 1.79, ["Neon"] = 7.88, ["Mega"] = 38.35, ["Mega|Ride"] = 195.68}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.67, ["Fly"] = 77.17, ["Ride"] = 52.5, ["Fly|Ride"] = 89.15, ["Neon"] = 210, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.81, ["Mega|Ride"] = 13952.16}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 1.93, ["Ride"] = 20.36, ["Fly|Ride"] = 65.63, ["Neon"] = 6.3, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.26, ["Mega"] = 74.81, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 462.31}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.06, ["Ride"] = 79.55, ["Fly|Ride"] = 278.52, ["Neon"] = 106.85, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 391.75, ["Mega|Fly|Ride"] = 601.49}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.59, ["Fly|Ride"] = 50.27, ["Neon"] = 18.78, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.88, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 77.49, ["Neon"] = 35.44, ["Neon|Ride"] = 418.56, ["Mega"] = 291.38, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 65.98, ["Neon"] = 39.36, ["Neon|Ride"] = 227.07, ["Mega"] = 474.55, ["Mega|Ride"] = 950.06}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.88, ["Ride"] = 91.88, ["Neon"] = 242.82, ["Neon|Ride"] = 651.91, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 2232.95, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.64, ["Ride"] = 279.57, ["Neon"] = 103.67, ["Neon|Ride"] = 262.5, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.09, ["Ride"] = 125.98, ["Neon"] = 171.62, ["Neon|Fly"] = 209.28, ["Neon|Ride"] = 418.56, ["Mega"] = 140.22, ["Mega|Ride"] = 836.06}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.68, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 732.46, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 604.54, ["Mega|Fly"] = 2092.73, ["Mega|Fly|Ride"] = 1108.06}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.46, ["Neon"] = 18.86, ["Mega"] = 183.75, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 316.77}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.51, ["Ride"] = 17.83, ["Fly|Ride"] = 41.9, ["Neon"] = 3.73, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 59.07, ["Mega|Ride"] = 80.15, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 41.9, ["Fly|Ride"] = 65.63, ["Neon"] = 16.89, ["Neon|Ride"] = 68.61, ["Neon|Fly|Ride"] = 118.64, ["Mega"] = 105, ["Mega|Ride"] = 131.7, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.63, ["Fly|Ride"] = 56.44, ["Neon"] = 3.86, ["Neon|Ride"] = 25.61, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 32.7, ["Mega|Fly"] = 167.43, ["Mega|Ride"] = 76.56, ["Mega|Fly|Ride"] = 189.11}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 17.99, ["Fly|Ride"] = 112.04, ["Neon"] = 15.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 328.02, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 474.55}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.48, ["Fly"] = 65.63, ["Ride"] = 19.59, ["Fly|Ride"] = 103.69, ["Neon"] = 25.62, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 287.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.06, ["Fly"] = 131.25, ["Ride"] = 25.34, ["Fly|Ride"] = 61.65, ["Neon"] = 19.47, ["Neon|Fly"] = 111.98, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 99.04, ["Mega"] = 196.88, ["Mega|Ride"] = 447.86, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 19.68, ["Fly|Ride"] = 51.77, ["Neon"] = 18.8, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 104.65, ["Mega"] = 237.54, ["Mega|Ride"] = 209.28}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 19.58, ["Neon|Fly"] = 437.04, ["Neon|Ride"] = 56.03, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 98.44, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.09, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.74, ["Fly"] = 106.56, ["Ride"] = 99.45, ["Fly|Ride"] = 231.53, ["Neon"] = 111.45, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 527.94, ["Mega"] = 558.77, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.17, ["Fly"] = 164.07, ["Ride"] = 79.58, ["Fly|Ride"] = 489.09, ["Neon"] = 221.8, ["Neon|Ride"] = 266.84, ["Neon|Fly|Ride"] = 486.42, ["Mega"] = 1154.56, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1284.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 1.79, ["Fly"] = 50.97, ["Ride"] = 18.35, ["Fly|Ride"] = 73.41, ["Neon"] = 2.63, ["Neon|Ride"] = 23.73, ["Mega"] = 31.4, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.69, ["Mega|Fly|Ride"] = 1026.5}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.13, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 299.14, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 836.06, ["Mega"] = 1715}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.89, ["Fly"] = 190.32, ["Ride"] = 36.66, ["Fly|Ride"] = 133.87, ["Neon"] = 36.63, ["Neon|Ride"] = 83.72, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Ride"] = 65.36, ["Fly|Ride"] = 141.75, ["Neon"] = 9.01, ["Neon|Ride"] = 65.62, ["Mega"] = 83.97, ["Mega|Ride"] = 136.43, ["Mega|Fly|Ride"] = 361.01}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 14.14, ["Fly|Ride"] = 39.37, ["Neon"] = 9.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 236.15, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 140.22, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 1.79, ["Fly"] = 16.74, ["Ride"] = 14.44, ["Fly|Ride"] = 41.2, ["Neon"] = 2.63, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 28.87, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 118.14}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 17.83, ["Fly|Ride"] = 90.85, ["Neon"] = 3.94, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 38.73, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 118.72, ["Neon"] = 2.59, ["Neon|Ride"] = 145.08, ["Mega"] = 21.37, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.77, ["Ride"] = 104.98, ["Neon"] = 30.45, ["Neon|Ride"] = 237.57, ["Neon|Fly|Ride"] = 627.82, ["Mega"] = 316.77, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 316.77}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.77, ["Ride"] = 31.61, ["Fly|Ride"] = 98.43, ["Neon"] = 52.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.22, ["Mega|Ride"] = 401.82, ["Mega|Fly|Ride"] = 1034.86}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.27, ["Fly"] = 20.9, ["Ride"] = 16.48, ["Fly|Ride"] = 39, ["Neon"] = 29.5, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 91.76, ["Mega|Ride"] = 397.63, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.2, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 447.86, ["Mega"] = 2372.7, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.28, ["Fly"] = 82.68, ["Ride"] = 31.4, ["Fly|Ride"] = 140.31, ["Neon"] = 279.57, ["Neon|Fly|Ride"] = 630, ["Mega"] = 633.52, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 1.79, ["Fly"] = 25.79, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.27, ["Ride"] = 12.71, ["Fly|Ride"] = 28.25, ["Neon"] = 3.94, ["Neon|Fly"] = 27.2, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 42.82, ["Mega|Fly"] = 91.04, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.81, ["Fly"] = 554.38, ["Ride"] = 534.19, ["Fly|Ride"] = 551.24, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.45, ["Ride"] = 56.44, ["Fly|Ride"] = 535.42, ["Neon"] = 32.71, ["Neon|Ride"] = 80.31, ["Mega"] = 363.11, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 279029.46}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 1.79, ["Fly"] = 14.78, ["Ride"] = 15.75, ["Fly|Ride"] = 27.92, ["Neon"] = 2.63, ["Neon|Fly"] = 23.73, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 35.66, ["Mega"] = 140.22, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.41, ["Ride"] = 140.31, ["Fly|Ride"] = 524.9, ["Neon"] = 262.4, ["Neon|Ride"] = 269.52, ["Neon|Fly|Ride"] = 461.46, ["Mega"] = 719.25, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 939.75}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.71, ["Ride"] = 16.21, ["Fly|Ride"] = 44.63, ["Neon"] = 15.72, ["Neon|Fly"] = 61.74, ["Neon|Ride"] = 14.83, ["Neon|Fly|Ride"] = 70.85, ["Mega"] = 111.38, ["Mega|Ride"] = 124.85, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 1.79, ["Fly"] = 70.17, ["Ride"] = 41.9, ["Neon"] = 2.1, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 18.52, ["Mega|Ride"] = 56.14, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.94, ["Fly"] = 123.44, ["Ride"] = 66.88, ["Fly|Ride"] = 213.94, ["Neon"] = 193.39, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 837.1, ["Mega|Fly|Ride"] = 831.28}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 23.05, ["Neon"] = 3.88, ["Neon|Ride"] = 39.99, ["Mega"] = 36.75, ["Mega|Ride"] = 195.43, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 23.61, ["Ride"] = 53.42, ["Fly|Ride"] = 140.31, ["Neon"] = 335.06, ["Neon|Ride"] = 321.25, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1653.26, ["Mega|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 1506.78}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.14, ["Ride"] = 183.74, ["Neon"] = 21.94, ["Neon|Ride"] = 79.5, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 157.49, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 71.29, ["Fly|Ride"] = 70.17, ["Neon"] = 7.39, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 44.8, ["Ride"] = 104.98, ["Fly|Ride"] = 523.51, ["Mega"] = 2092.73, ["Mega|Ride"] = 2790.65}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 324.38, ["Ride"] = 20.96, ["Fly|Ride"] = 60.15, ["Neon"] = 6.57, ["Neon|Ride"] = 38.87, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 43.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 83.25, ["Mega|Fly|Ride"] = 183.65}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.48, ["Ride"] = 15.02, ["Fly|Ride"] = 101.82, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 118.64, ["Mega|Fly|Ride"] = 265.79}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.49, ["Fly"] = 58.49, ["Ride"] = 23.67, ["Fly|Ride"] = 75.78, ["Neon"] = 81.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 437.39, ["Mega|Ride"] = 626.79, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.35, ["Fly"] = 57.11, ["Ride"] = 20.96, ["Fly|Ride"] = 71.31, ["Neon"] = 118.12, ["Neon|Ride"] = 135.94, ["Neon|Fly|Ride"] = 196.73, ["Mega"] = 354.25, ["Mega|Ride"] = 418.29, ["Mega|Fly|Ride"] = 498.14}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.89, ["Fly"] = 51.19, ["Ride"] = 26.17, ["Fly|Ride"] = 64.25, ["Neon"] = 56.6, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 138.13, ["Mega"] = 558.77, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 431.11}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 57.75, ["Fly"] = 139.36, ["Ride"] = 104.85, ["Fly|Ride"] = 249.38, ["Neon"] = 285.86, ["Neon|Ride"] = 386.53, ["Neon|Fly|Ride"] = 474.55, ["Mega|Ride"] = 1228.43, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.96, ["Fly"] = 140.31, ["Ride"] = 56.56, ["Neon"] = 24.04, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 167.43, ["Mega"] = 223.13, ["Mega|Fly|Ride"] = 523.2}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.67, ["Ride"] = 26.25, ["Fly|Ride"] = 78.74, ["Neon"] = 10.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 125.57, ["Mega"] = 262.4, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.85, ["Ride"] = 24.04, ["Fly|Ride"] = 110.95, ["Neon"] = 47.59, ["Neon|Ride"] = 138.13, ["Neon|Fly|Ride"] = 237.28, ["Mega"] = 461.46, ["Mega|Ride"] = 488.66, ["Mega|Fly|Ride"] = 732.46}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 1.79, ["Fly"] = 15.33, ["Ride"] = 12.58, ["Fly|Ride"] = 31.18, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.4, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.75, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 93.83}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 43.3, ["Fly"] = 221.99, ["Ride"] = 91.88, ["Neon"] = 264.46, ["Neon|Fly"] = 2372.11, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3139.08, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 20.79, ["Fly|Ride"] = 35.62, ["Neon"] = 3.18, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 35.6, ["Mega|Ride"] = 137.01, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 16.49, ["Fly|Ride"] = 59.07, ["Neon"] = 41.9, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 89.93, ["Mega"] = 257.25, ["Mega|Ride"] = 138.92, ["Mega|Fly|Ride"] = 237.28}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.51, ["Fly"] = 157.5, ["Ride"] = 101.88, ["Fly|Ride"] = 258.57, ["Neon"] = 437.06, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 1255.64, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1618.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 5.44, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 63.73, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.08}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 1.79, ["Ride"] = 24.94, ["Fly|Ride"] = 297.36, ["Neon"] = 4.45, ["Neon|Ride"] = 50.3, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 44.5, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 214.53}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 113.18, ["Ride"] = 151.59, ["Fly|Ride"] = 301.53, ["Neon"] = 836.07, ["Neon|Ride"] = 696.4, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3348.36, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.6, ["Ride"] = 41.91, ["Fly|Ride"] = 72.19, ["Neon"] = 19.58, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 633.52}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.62, ["Neon"] = 6.57, ["Neon|Ride"] = 20.02, ["Mega"] = 28.61, ["Mega|Ride"] = 102.56, ["Mega|Fly|Ride"] = 140.22}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.84, ["Ride"] = 19.52, ["Fly|Ride"] = 131.25, ["Neon"] = 50.23, ["Neon|Ride"] = 64.08, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 488.66, ["Mega|Ride"] = 418.56, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.99, ["Fly"] = 56.74, ["Ride"] = 21, ["Fly|Ride"] = 55.81, ["Neon"] = 99, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 616.88, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 396.25}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.08, ["Ride"] = 63.67, ["Fly|Ride"] = 125.9, ["Neon"] = 131.25, ["Neon|Ride"] = 162.2, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 781.65, ["Mega|Ride"] = 576.37, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 129.94, ["Fly"] = 196.76, ["Ride"] = 144.38, ["Fly|Ride"] = 157.5, ["Neon"] = 593.15, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2420.14}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 74.67, ["Ride"] = 78.89, ["Fly|Ride"] = 118.11, ["Neon"] = 471.16, ["Neon|Ride"] = 1255.64, ["Neon|Fly|Ride"] = 249.27, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.71, ["Fly"] = 131.15, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.81, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.51, ["Fly"] = 98.43, ["Ride"] = 35.11, ["Fly|Ride"] = 180.1, ["Neon"] = 173.82, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 156.97, ["Mega"] = 379.32, ["Mega|Ride"] = 498.08, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 40.69, ["Fly"] = 142.47, ["Ride"] = 76.64, ["Neon"] = 219.19, ["Neon|Ride"] = 275.21, ["Neon|Fly|Ride"] = 334.85, ["Mega"] = 1108.06, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.32, ["Ride"] = 70.17, ["Neon"] = 105, ["Neon|Ride"] = 181.86, ["Neon|Fly|Ride"] = 461.46, ["Mega"] = 684.33, ["Mega|Ride"] = 714.67}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3163.99, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.89, ["Fly"] = 56.56, ["Ride"] = 32.8, ["Fly|Ride"] = 65.44, ["Neon"] = 224.26, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 318.43, ["Mega"] = 1213.78, ["Mega|Ride"] = 996.55, ["Mega|Fly|Ride"] = 1038}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 1.79, ["Fly"] = 38.64, ["Ride"] = 12.58, ["Fly|Ride"] = 121.47, ["Neon"] = 2.1, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 42.78, ["Mega"] = 19.36, ["Mega|Fly"] = 100.46, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 7.61, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 146.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.01, ["Ride"] = 39.8, ["Fly|Ride"] = 144.21, ["Neon"] = 18.27, ["Neon|Ride"] = 87.3, ["Neon|Fly|Ride"] = 977.31, ["Mega"] = 108.84, ["Mega|Fly"] = 514.88, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 433.13, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1563.28, ["Neon|Fly|Ride"] = 1531.88, ["Mega|Fly|Ride"] = 5304.51}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 20.62, ["Ride"] = 16.58, ["Fly|Ride"] = 41.9, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.86, ["Mega"] = 168, ["Mega|Ride"] = 279.39, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.69, ["Fly"] = 22.32, ["Ride"] = 17.56, ["Fly|Ride"] = 35.44, ["Neon"] = 39.36, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 266.84, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.88, ["Fly"] = 32.45, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 10.83, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 140.22, ["Mega|Ride"] = 251.14, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 31.19, ["Fly"] = 41.91, ["Ride"] = 41.89, ["Fly|Ride"] = 65.63, ["Neon"] = 140.31, ["Neon|Ride"] = 173.39, ["Neon|Fly|Ride"] = 312.87, ["Mega"] = 1312.5, ["Mega|Ride"] = 836.06, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.28, ["Fly|Ride"] = 50.3, ["Neon"] = 11.7, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.73, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.14, ["Fly"] = 64.28, ["Ride"] = 25.59, ["Fly|Ride"] = 91.88, ["Neon"] = 175.7, ["Neon|Fly"] = 158.99, ["Neon|Ride"] = 140.22, ["Mega"] = 1674.19, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 1.88, ["Ride"] = 19.37, ["Neon"] = 5.75, ["Neon|Ride"] = 35.11, ["Mega"] = 52.5, ["Mega|Ride"] = 112.03, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.96, ["Neon"] = 50.57}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.91, ["Ride"] = 77.49, ["Neon"] = 78.91, ["Neon|Ride"] = 474.55, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 308.69, ["Mega|Ride"] = 543.08, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.46, ["Fly"] = 27.92, ["Ride"] = 16.89, ["Fly|Ride"] = 45.93, ["Neon"] = 34.53, ["Neon|Fly"] = 70.11, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 588.08, ["Mega|Ride"] = 323.54, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.82, ["Fly"] = 396.51, ["Ride"] = 388.42, ["Fly|Ride"] = 465.47, ["Neon"] = 1659, ["Neon|Ride"] = 1131.53, ["Neon|Fly|Ride"] = 1392.71}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 35.62, ["Neon"] = 13.01, ["Neon|Fly"] = 79.5, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 209.28, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.67, ["Fly"] = 70.17, ["Ride"] = 44.12, ["Fly|Ride"] = 65.63, ["Neon"] = 45.03, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 383.65, ["Mega|Fly"] = 697.93, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 27.61, ["Ride"] = 102.23, ["Fly|Ride"] = 315, ["Neon"] = 112.83, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 348.2, ["Mega"] = 422.62, ["Mega|Ride"] = 350.62, ["Mega|Fly|Ride"] = 539.83}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 100.51, ["Fly"] = 169.32, ["Ride"] = 140.31, ["Fly|Ride"] = 196.88, ["Neon"] = 389.5, ["Neon|Ride"] = 1464.91, ["Neon|Fly|Ride"] = 941.74, ["Mega"] = 2367.47, ["Mega|Ride"] = 5551.88}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 52.5, ["Ride"] = 119.6, ["Fly|Ride"] = 131.11, ["Neon"] = 97.44, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 275.52, ["Mega|Ride"] = 474.55, ["Mega|Fly|Ride"] = 442.04}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 12.47, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 70.11, ["Mega"] = 65.61, ["Mega|Ride"] = 144.76, ["Mega|Fly|Ride"] = 237.28}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.55, ["Ride"] = 34.33, ["Neon"] = 23.24, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 158.99, ["Mega|Ride"] = 179.99, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 52.89, ["Fly"] = 183.75, ["Ride"] = 84.08, ["Fly|Ride"] = 206.75, ["Neon"] = 150.94, ["Neon|Ride"] = 157.35, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 417.82, ["Mega|Ride"] = 690.61, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 1.79, ["Ride"] = 131.25, ["Fly|Ride"] = 140.31, ["Neon"] = 10.38, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 209.28, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 55.13, ["Mega|Ride"] = 172.45, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.72, ["Neon"] = 123.38, ["Neon|Ride"] = 401.03, ["Mega"] = 585.98, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.38, ["Fly"] = 2094.01, ["Ride"] = 1040.58, ["Fly|Ride"] = 1086.75, ["Neon"] = 3331.56, ["Neon|Ride"] = 3599.5, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11547.86}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.09, ["Fly"] = 82.41, ["Ride"] = 57.31, ["Fly|Ride"] = 143.16, ["Neon"] = 202.13, ["Neon|Fly"] = 696.89, ["Neon|Ride"] = 209.28, ["Mega"] = 396.25, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.34, ["Ride"] = 21.44, ["Fly|Ride"] = 80.89, ["Neon"] = 10.28, ["Neon|Fly"] = 56.52, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 94.91, ["Mega"] = 82.74, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 249.04}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.86, ["Ride"] = 47.79, ["Fly|Ride"] = 140.31, ["Neon"] = 141.75, ["Mega"] = 787.5, ["Mega|Ride"] = 421.94, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.06, ["Fly|Ride"] = 182.2, ["Neon"] = 2.63, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 15.65, ["Mega|Fly"] = 125.57, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 157.92}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 51.45, ["Ride"] = 88.36, ["Fly|Ride"] = 236.25, ["Neon"] = 260.75, ["Neon|Ride"] = 315, ["Mega"] = 1056.85, ["Mega|Ride"] = 924, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.55, ["Ride"] = 62.99, ["Fly|Ride"] = 157.83, ["Neon"] = 65.44, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 262.19, ["Mega"] = 576.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 556.68}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.81, ["Ride"] = 27.24, ["Neon"] = 13.13, ["Neon|Ride"] = 65.62, ["Mega"] = 156.97, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 468.79}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 22.44, ["Fly"] = 65.99, ["Ride"] = 41.08, ["Fly|Ride"] = 117.52, ["Neon"] = 140.31, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 1039.49, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.41, ["Ride"] = 30.23, ["Fly|Ride"] = 68.25, ["Neon"] = 55.04, ["Neon|Ride"] = 207.32, ["Neon|Fly|Ride"] = 117.69, ["Mega"] = 382.98, ["Mega|Ride"] = 518.22, ["Mega|Fly|Ride"] = 447.86}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.08, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 907.2, ["Mega"] = 2103.24, ["Mega|Ride"] = 1674.19, ["Mega|Fly|Ride"] = 1672.1}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.89, ["Fly|Ride"] = 255.34, ["Neon"] = 32.82, ["Neon|Ride"] = 83.72, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 100.95, ["Mega|Ride"] = 139.65, ["Mega|Fly|Ride"] = 226.94}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.77, ["Ride"] = 18.92, ["Fly|Ride"] = 81.68, ["Neon"] = 60.8, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 301.67, ["Mega|Ride"] = 376.7, ["Mega|Fly|Ride"] = 598.54}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 118.13, ["Fly"] = 174.87, ["Ride"] = 160.79, ["Fly|Ride"] = 229.69, ["Neon"] = 577.6, ["Neon|Ride"] = 692.84, ["Neon|Fly|Ride"] = 689.07, ["Mega"] = 2327.07, ["Mega|Ride"] = 2330.26, ["Mega|Fly|Ride"] = 1847.87}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.35, ["Ride"] = 17.72, ["Fly|Ride"] = 39.29, ["Neon"] = 12.21, ["Neon|Fly"] = 57.52, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 74.11, ["Mega"] = 140.22, ["Mega|Ride"] = 237.28, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 7.6, ["Fly"] = 195.43, ["Ride"] = 39.14, ["Fly|Ride"] = 92.86, ["Neon"] = 79.55, ["Neon|Fly"] = 316.77, ["Neon|Ride"] = 82.85, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 452.81, ["Mega|Ride"] = 480.3, ["Mega|Fly|Ride"] = 411.5}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.05, ["Fly"] = 18.37, ["Ride"] = 14.7, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 26.57, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.59, ["Mega|Fly"] = 49.85, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 68.25}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 1.79, ["Ride"] = 56.56, ["Fly|Ride"] = 39.38, ["Neon"] = 3.67, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 129.76, ["Mega"] = 12.99, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 163.25}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 28.29, ["Ride"] = 26.04, ["Fly|Ride"] = 110.52, ["Neon"] = 16.99, ["Neon|Ride"] = 60.52, ["Neon|Fly|Ride"] = 206.45, ["Mega"] = 77.44, ["Mega|Ride"] = 265.79, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.19, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 144.38, ["Neon|Ride"] = 355.92, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 684.33}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 13.98, ["Fly|Ride"] = 30.72, ["Neon"] = 12.58, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 103.59, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 120.91, ["Mega|Fly|Ride"] = 157.24}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.21, ["Fly"] = 41.28, ["Ride"] = 24.35, ["Fly|Ride"] = 84.78, ["Neon"] = 25.55, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 219.19, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 65.63, ["Neon"] = 7.96, ["Neon|Fly"] = 35.6, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 158.99, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 74.93, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 6.49, ["Fly"] = 158.13, ["Ride"] = 23.71, ["Fly|Ride"] = 217.19, ["Neon"] = 26.25, ["Neon|Ride"] = 78.83, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 275.21, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 375.66}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.49, ["Ride"] = 140.31, ["Neon"] = 39.38, ["Neon|Ride"] = 126.95, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 977.31}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 7.8, ["Fly"] = 41.9, ["Ride"] = 16.7, ["Fly|Ride"] = 44.82, ["Neon"] = 6.57, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.64, ["Mega"] = 255.84, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.09, ["Ride"] = 17.06, ["Fly|Ride"] = 71.22, ["Neon"] = 16.12, ["Neon|Fly"] = 47.46, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 237.28, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 202.13, ["Fly"] = 314.11, ["Ride"] = 299.17, ["Fly|Ride"] = 392.44, ["Neon"] = 1119.45, ["Neon|Ride"] = 1388.03, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4006.38}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.8, ["Ride"] = 109.51, ["Neon"] = 60.75, ["Neon|Ride"] = 140.22, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 104.71, ["Ride"] = 21.53, ["Fly|Ride"] = 79.07, ["Neon"] = 22.18, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.65, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.37, ["Fly|Ride"] = 212.89, ["Neon"] = 36.63, ["Neon|Ride"] = 221.84, ["Neon|Fly|Ride"] = 627.82, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 16.06, ["Ride"] = 13.86, ["Fly|Ride"] = 29.59, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 35.43, ["Mega"] = 18.86, ["Mega|Fly"] = 83.72, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 17.83, ["Fly|Ride"] = 112.04, ["Neon"] = 8.12, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 95.79, ["Mega"] = 102.78, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 220.66}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 39.8, ["Neon"] = 13.13, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 118.11, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.86, ["Fly"] = 98.43, ["Ride"] = 98.43, ["Fly|Ride"] = 167.54, ["Neon"] = 556.49, ["Neon|Ride"] = 372.52, ["Neon|Fly|Ride"] = 558.77, ["Mega|Ride"] = 3489.63, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 98.43, ["Ride"] = 28.59, ["Fly|Ride"] = 141.65, ["Neon"] = 22.79, ["Neon|Ride"] = 62.33, ["Neon|Fly|Ride"] = 418.56, ["Mega"] = 157.49, ["Mega|Ride"] = 184.24, ["Mega|Fly|Ride"] = 564.01}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 1.79, ["Fly"] = 48.18, ["Ride"] = 33.09, ["Neon"] = 6.56, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 532.69, ["Mega"] = 42, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.88, ["Fly"] = 210, ["Ride"] = 96.06, ["Fly|Ride"] = 183.81, ["Neon"] = 131.24, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 590.63, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 594.57}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.33, ["Fly|Ride"] = 28.58, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 14.79, ["Neon|Fly|Ride"] = 32.69, ["Mega"] = 18.18, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 52.21, ["Mega|Fly|Ride"] = 86.08}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 1.79, ["Ride"] = 33.65, ["Neon"] = 3.84, ["Neon|Fly"] = 32.46, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 209.37, ["Mega"] = 20.78, ["Mega|Ride"] = 82.56, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 8.37, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 97.06, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 101.07, ["Mega|Fly"] = 182.07, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.02, ["Fly"] = 55.99, ["Ride"] = 37.69, ["Fly|Ride"] = 132.98, ["Neon"] = 15.33, ["Neon|Fly"] = 90, ["Neon|Ride"] = 77.76, ["Neon|Fly|Ride"] = 191.71, ["Mega"] = 102.21, ["Mega|Fly"] = 340.5, ["Mega|Ride"] = 190.25, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 1.79, ["Fly"] = 20.69, ["Ride"] = 12.5, ["Fly|Ride"] = 36.66, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 17.19, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.07, ["Fly"] = 131.25, ["Ride"] = 125.65, ["Neon"] = 128.63, ["Neon|Fly"] = 418.56, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 577.77, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 642.49}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.56, ["Fly"] = 3150, ["Ride"] = 2493.74, ["Fly|Ride"] = 2493.75, ["Neon|Fly|Ride"] = 9626.51, ["Mega|Fly|Ride"] = 36622.58}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 1.79, ["Fly"] = 16.59, ["Ride"] = 14.16, ["Fly|Ride"] = 44.63, ["Neon"] = 5.25, ["Neon|Fly"] = 55.84, ["Neon|Ride"] = 16.76, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 76.04, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 4.38, ["Mega"] = 140.22, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.99, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13, ["Fly"] = 112.04, ["Ride"] = 28.8, ["Fly|Ride"] = 70.17, ["Neon"] = 70.17, ["Neon|Ride"] = 102.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 367.5, ["Mega|Ride"] = 445.1, ["Mega|Fly|Ride"] = 627.82}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.19, ["Ride"] = 50.74, ["Neon"] = 187.69, ["Mega"] = 641.46, ["Mega|Ride"] = 600.62, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 129.92, ["Fly"] = 1396.71, ["Ride"] = 188.9, ["Fly|Ride"] = 251.98, ["Neon"] = 768.51, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6278.16, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.7, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Ride"] = 140.22, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 308.69, ["Mega|Fly|Ride"] = 355.78}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.62, ["Fly|Ride"] = 70.17, ["Neon"] = 22.74, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 843.51}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 72.77, ["Mega|Ride"] = 99, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.1, ["Ride"] = 50.34, ["Neon"] = 180.07, ["Neon|Ride"] = 1189.92, ["Mega"] = 374.07, ["Mega|Ride"] = 463.56, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.9, ["Neon"] = 2.1, ["Neon|Ride"] = 47.67, ["Mega"] = 19.85, ["Mega|Fly"] = 118.64, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.15, ["Fly"] = 159.5, ["Ride"] = 103.53, ["Fly|Ride"] = 159.09, ["Neon"] = 366.19, ["Neon|Ride"] = 408.1, ["Neon|Fly|Ride"] = 324.28, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.28, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 71.19, ["Mega|Ride"] = 278.35}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.7, ["Fly"] = 100.53, ["Ride"] = 74.68, ["Fly|Ride"] = 157.48, ["Neon"] = 278.11, ["Neon|Ride"] = 418.56, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 1.79, ["Fly"] = 52.5, ["Ride"] = 20.9, ["Fly|Ride"] = 51.1, ["Neon"] = 3.93, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 41.97, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 180.52}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 7.55, ["Neon|Ride"] = 98.44, ["Mega"] = 88.26, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 475.58}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.67, ["Fly"] = 77.44, ["Ride"] = 38.57, ["Fly|Ride"] = 209.42, ["Neon"] = 27.75, ["Neon|Ride"] = 120.35, ["Mega"] = 262.5, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 558.77}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 350.43, ["Ride"] = 402.94, ["Fly|Ride"] = 525.23, ["Neon"] = 1048.69, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1170.72, ["Mega|Ride"] = 4185.44, ["Mega|Fly|Ride"] = 4185.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 28.3, ["Fly"] = 83.78, ["Ride"] = 52.5, ["Fly|Ride"] = 100.16, ["Neon"] = 196.88, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 395.54, ["Mega"] = 1393.76, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 18.15, ["Fly|Ride"] = 72.19, ["Neon"] = 10.26, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 120.65, ["Mega|Ride"] = 109.44, ["Mega|Fly|Ride"] = 265.79}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13, ["Fly"] = 54.59, ["Ride"] = 43.98, ["Fly|Ride"] = 170.63, ["Neon"] = 68.24, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 182.2, ["Mega"] = 315, ["Mega|Fly"] = 976.37, ["Mega|Ride"] = 379.64, ["Mega|Fly|Ride"] = 416.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.57, ["Fly"] = 35.62, ["Ride"] = 20.76, ["Fly|Ride"] = 196.88, ["Neon"] = 141.36, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 269.32, ["Mega"] = 313.92, ["Mega|Ride"] = 320.2, ["Mega|Fly|Ride"] = 555.63}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 14.25, ["Mega"] = 78.75, ["Mega|Fly"] = 157.4, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 295.09}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.89, ["Fly|Ride"] = 56.56, ["Neon"] = 41.91, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 217.66, ["Mega"] = 86.63, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Ride"] = 117.93, ["Fly|Ride"] = 236.25, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 2965.87}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 29.09, ["Ride"] = 45.99, ["Fly|Ride"] = 91.88, ["Neon"] = 142.95, ["Neon|Ride"] = 209.28, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 1116.48, ["Mega|Ride"] = 633.52, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2085.57, ["Neon"] = 11168.36, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.11, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 18.18, ["Mega"] = 97.46, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 168.72, ["Mega|Fly|Ride"] = 475.07}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.86, ["Ride"] = 47.25, ["Neon"] = 25.9, ["Neon|Ride"] = 76.56, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 157.5, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 1046.37}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1048.43, ["Fly"] = 1452.2, ["Ride"] = 879.38, ["Fly|Ride"] = 971.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2361.19, ["Mega"] = 12277.99, ["Mega|Fly|Ride"] = 11300.69}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.57, ["Ride"] = 52.48, ["Fly|Ride"] = 173.35, ["Neon"] = 176.82, ["Neon|Ride"] = 418.56, ["Neon|Fly|Ride"] = 374.91, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.29, ["Ride"] = 23.61, ["Fly|Ride"] = 128.15, ["Neon"] = 19.69, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 265.79, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 140.31, ["Neon"] = 2.83, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 92.09, ["Mega"] = 19.59, ["Mega|Ride"] = 255.32, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.86, ["Ride"] = 91.88, ["Fly|Ride"] = 170.63, ["Neon"] = 418.82, ["Neon|Ride"] = 593.18, ["Neon|Fly|Ride"] = 630, ["Mega"] = 8370.88, ["Mega|Fly|Ride"] = 2092.73}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Fly|Ride"] = 83.91, ["Neon"] = 11.95, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 118.57, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.5, ["Ride"] = 102.38, ["Fly|Ride"] = 123.56, ["Neon"] = 393.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 513.78, ["Mega|Fly|Ride"] = 1776.74}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.85, ["Fly"] = 105, ["Fly|Ride"] = 125.65, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 180.89, ["Mega|Ride"] = 308.69}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 232.15, ["Ride"] = 280.27, ["Fly|Ride"] = 334.69, ["Neon"] = 1137.32, ["Neon|Ride"] = 1061.79, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 87.94, ["Ride"] = 19.36, ["Fly|Ride"] = 103.95, ["Neon"] = 28.88, ["Neon|Fly"] = 158.99, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 100.7, ["Mega"] = 210, ["Mega|Ride"] = 656.23}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 14.53, ["Fly|Ride"] = 31.77, ["Neon"] = 5.38, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 16.94, ["Neon|Fly|Ride"] = 46.09, ["Mega"] = 48.56, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 124.41}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1238.57, ["Ride"] = 1050, ["Fly|Ride"] = 1187.1, ["Neon|Ride"] = 7674.01, ["Neon|Fly|Ride"] = 6278.16, ["Mega"] = 23726.83}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.47, ["Fly"] = 977.91, ["Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 131.85, ["Mega"] = 320.24, ["Mega|Ride"] = 380.89, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.3, ["Fly"] = 50.27, ["Ride"] = 41.73, ["Fly|Ride"] = 79.55, ["Neon"] = 22.78, ["Neon|Fly"] = 158.99, ["Neon|Ride"] = 52.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 170.63, ["Mega|Ride"] = 191.16, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.07, ["Fly"] = 39.29, ["Ride"] = 31.49, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 190.32, ["Mega|Ride"] = 1108.06, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.29, ["Fly"] = 83.77, ["Ride"] = 24.76, ["Fly|Ride"] = 85.31, ["Neon"] = 69.43, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.69, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.49, ["Ride"] = 111.61, ["Fly|Ride"] = 408.35, ["Neon"] = 183.16, ["Neon|Ride"] = 378, ["Mega"] = 1050, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 586.26}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Ride"] = 116.61, ["Fly|Ride"] = 118.72, ["Neon"] = 2.27, ["Neon|Ride"] = 15.7, ["Mega"] = 15.75, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.5, ["Fly"] = 123.57, ["Ride"] = 72.16, ["Fly|Ride"] = 111.09, ["Neon"] = 446.24, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 447.56, ["Mega"] = 3348.36, ["Mega|Ride"] = 1722.33, ["Mega|Fly|Ride"] = 1586.64}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 18.8, ["Fly|Ride"] = 70.88, ["Neon"] = 65.54, ["Neon|Ride"] = 110.93, ["Neon|Fly|Ride"] = 167.43, ["Mega"] = 773.06, ["Mega|Ride"] = 396.25}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 37.4, ["Neon"] = 17.16, ["Neon|Fly"] = 83.72, ["Neon|Ride"] = 56.52, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.21, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 138.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 195.68, ["Mega"] = 374.61, ["Mega|Fly|Ride"] = 474.55}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 56.55, ["Ride"] = 77.49, ["Fly|Ride"] = 262.5, ["Neon"] = 287.34, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 555.63, ["Mega|Ride"] = 1360.28, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.68, ["Neon"] = 16.7, ["Mega"] = 123.26, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 316.77}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 1.79, ["Ride"] = 33.52, ["Neon"] = 2.1, ["Neon|Ride"] = 116.21, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 16.54, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 523.2}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.26, ["Fly|Ride"] = 58.9, ["Neon"] = 3.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 167.43, ["Mega"] = 18.17, ["Mega|Ride"] = 52.19, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 8.48, ["Neon|Ride"] = 28.27, ["Neon|Fly|Ride"] = 84.25, ["Mega"] = 63, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 182.27}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.04, ["Neon"] = 39.38, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 14.97, ["Fly|Ride"] = 32.37, ["Neon"] = 15.72, ["Neon|Fly"] = 209.28, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Ride"] = 166.39, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.38, ["Ride"] = 91.51, ["Fly|Ride"] = 265.95, ["Neon"] = 196.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1046.37, ["Mega"] = 694.32, ["Mega|Ride"] = 1046.37, ["Mega|Fly|Ride"] = 1108.06}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.57, ["Fly|Ride"] = 35.44, ["Neon"] = 4.2, ["Neon|Fly"] = 23.06, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 47.86, ["Mega"] = 19.69, ["Mega|Ride"] = 23.93, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.23, ["Fly"] = 129.93, ["Ride"] = 25.89, ["Fly|Ride"] = 57.1, ["Neon"] = 26.22, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 122.33, ["Mega"] = 362.5, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 202.82, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.29, ["Fly"] = 47.54, ["Ride"] = 26.17, ["Fly|Ride"] = 84.48, ["Neon"] = 125.64, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 182.43, ["Mega"] = 787.5, ["Mega|Ride"] = 726.18, ["Mega|Fly|Ride"] = 606.38}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 5.14, ["Fly"] = 196.88, ["Neon"] = 52.31, ["Mega"] = 366.19, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 1.79, ["Fly"] = 15.75, ["Ride"] = 14.94, ["Fly|Ride"] = 45.12, ["Neon"] = 3.92, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 58.46, ["Mega"] = 44.01, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 117.47}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.89, ["Fly"] = 71.44, ["Ride"] = 37.97, ["Neon"] = 22.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 209.28, ["Mega|Fly"] = 735, ["Mega|Ride"] = 223.94, ["Mega|Fly|Ride"] = 391.35}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1049.9, ["Fly"] = 1377.04, ["Ride"] = 1050, ["Fly|Ride"] = 1110.27, ["Neon"] = 3062.71, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.39, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.79, ["Ride"] = 181.9, ["Fly|Ride"] = 411.94, ["Neon"] = 627.17, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 813.75, ["Mega"] = 3138.05, ["Mega|Fly|Ride"] = 2347.01}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.24, ["Fly"] = 56.56, ["Neon"] = 5.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 204.05, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1116.48}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 68.16, ["Ride"] = 129.93, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1728.57}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.76, ["Ride"] = 20.96, ["Fly|Ride"] = 91.1, ["Neon"] = 14, ["Neon|Fly"] = 55.77, ["Neon|Ride"] = 48.77, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 279.39, ["Mega|Ride"] = 316.77, ["Mega|Fly|Ride"] = 404.96}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.13, ["Fly"] = 418.82, ["Ride"] = 271.69, ["Fly|Ride"] = 375.89, ["Neon|Ride"] = 1194.97, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4590.39}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.85, ["Fly|Ride"] = 217.43, ["Neon"] = 31.49, ["Neon|Fly"] = 35.6, ["Neon|Ride"] = 54.37, ["Mega"] = 414.38, ["Mega|Fly"] = 326.48, ["Mega|Ride"] = 633.52}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Neon"] = 28.6, ["Mega"] = 334.85, ["Mega|Ride"] = 358.92}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 22.32, ["Ride"] = 72.1, ["Fly|Ride"] = 131.15, ["Neon"] = 105, ["Neon|Ride"] = 140.22, ["Mega"] = 640.64, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.24, ["Neon|Ride"] = 140.22, ["Mega"] = 237.28, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 463.87}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.77, ["Ride"] = 14.44, ["Fly|Ride"] = 23.63, ["Neon"] = 2.63, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 28.5, ["Mega"] = 27.23, ["Mega|Ride"] = 42.72, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4828.02, ["Ride"] = 5130.57, ["Fly|Ride"] = 4928.44, ["Neon"] = 31409.98, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 130794.9}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.23, ["Fly"] = 83.77, ["Ride"] = 41.57, ["Neon"] = 52.41, ["Neon|Ride"] = 105, ["Mega"] = 278.35, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 418.56}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 1.79, ["Fly"] = 24.69, ["Ride"] = 16.52, ["Fly|Ride"] = 35.32, ["Neon"] = 13.13, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 63.95, ["Mega"] = 124.69, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 236.5}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.93, ["Fly"] = 547.77, ["Ride"] = 520.99, ["Fly|Ride"] = 570.17, ["Neon"] = 2100, ["Neon|Ride"] = 1519.44, ["Neon|Fly|Ride"] = 1500.65, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.38, ["Ride"] = 32.62, ["Neon"] = 19.23, ["Neon|Ride"] = 291.38, ["Mega"] = 140.6, ["Mega|Ride"] = 209.28, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.83, ["Fly"] = 4188.53, ["Ride"] = 65.63, ["Neon"] = 23.63, ["Neon|Ride"] = 45.1, ["Mega"] = 1137.41, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Ride"] = 18.53, ["Neon"] = 3.28, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 643.09, ["Ride"] = 735, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9068.8}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.7, ["Fly"] = 294.41, ["Ride"] = 51.39, ["Fly|Ride"] = 418.82, ["Neon"] = 26.43, ["Neon|Ride"] = 81.93, ["Neon|Fly|Ride"] = 284.73, ["Mega"] = 164.07, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 388.4}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.12, ["Fly"] = 236.15, ["Ride"] = 31.07, ["Fly|Ride"] = 111.61, ["Neon"] = 27.81, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 144.35, ["Mega"] = 196.77, ["Mega|Fly"] = 791.31, ["Mega|Ride"] = 214.17, ["Mega|Fly|Ride"] = 354.74}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.67, ["Fly|Ride"] = 45.94, ["Neon"] = 11.55, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 279.39, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 202.84}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.57, ["Ride"] = 34.12, ["Fly|Ride"] = 55.49, ["Neon"] = 117.58, ["Neon|Ride"] = 70.11, ["Neon|Fly|Ride"] = 313.92, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.88, ["Fly|Ride"] = 83.77, ["Neon"] = 6.13, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 57.75, ["Mega|Fly"] = 166.1, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 225.87}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 616.87, ["Ride"] = 538.12, ["Fly|Ride"] = 791.8, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9253.48, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.2, ["Ride"] = 76.11, ["Neon"] = 14.34, ["Neon|Ride"] = 85.56, ["Neon|Fly|Ride"] = 474.55, ["Mega"] = 170.63, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 509.15}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 1.79, ["Ride"] = 27.56, ["Neon"] = 6.3, ["Neon|Fly"] = 104.65, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 86.63, ["Mega|Fly|Ride"] = 355.78}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 40.82, ["Neon"] = 3.94, ["Neon|Ride"] = 45.02, ["Neon|Fly|Ride"] = 209.28, ["Mega"] = 39.26, ["Mega|Fly"] = 154.87, ["Mega|Ride"] = 102.1, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 35.62, ["Neon"] = 37.71, ["Mega"] = 209.28, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 29.25, ["Fly"] = 98.44, ["Ride"] = 70.17, ["Fly|Ride"] = 498.74, ["Neon"] = 131.25, ["Neon|Fly"] = 140.22, ["Neon|Ride"] = 137.23, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 918.75, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 561.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.67, ["Ride"] = 48.39, ["Fly|Ride"] = 128.99, ["Neon"] = 65.63, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 279.39, ["Mega"] = 492.18, ["Mega|Ride"] = 544.13, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.69, ["Ride"] = 16.48, ["Fly|Ride"] = 32.82, ["Neon"] = 28.29, ["Neon|Ride"] = 32.05, ["Neon|Fly|Ride"] = 86.86, ["Mega"] = 255.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 249.04}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 32.47, ["Fly|Ride"] = 121.47, ["Neon"] = 54.46, ["Neon|Ride"] = 138.13, ["Mega|Ride"] = 727.58}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 87.04, ["Neon"] = 10.5, ["Neon|Ride"] = 40.34, ["Neon|Fly|Ride"] = 111.98, ["Mega"] = 74.99, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.42, ["Fly"] = 64.12, ["Ride"] = 19.69, ["Fly|Ride"] = 61.9, ["Neon"] = 418.82, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 189.56, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 824.55}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 23.65, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Mega"] = 451, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 495.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.24, ["Fly"] = 153.58, ["Ride"] = 81.18, ["Fly|Ride"] = 160.13, ["Neon"] = 297.94, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 397.63, ["Mega|Ride"] = 1677.51, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.34, ["Fly"] = 83.77, ["Ride"] = 76.74, ["Fly|Ride"] = 204.19, ["Neon"] = 144.35, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 396.59, ["Mega|Ride"] = 607.3, ["Mega|Fly|Ride"] = 618.78}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.05, ["Ride"] = 64.32, ["Neon"] = 131.14, ["Neon|Ride"] = 428.3, ["Mega"] = 1049.99, ["Mega|Ride"] = 791.31}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 14.34, ["Fly"] = 418.87, ["Ride"] = 32.21, ["Fly|Ride"] = 192.94, ["Neon"] = 129.05, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 158.99, ["Mega"] = 464.37, ["Mega|Ride"] = 474.55, ["Mega|Fly|Ride"] = 634.51}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 1.79, ["Fly"] = 17.91, ["Ride"] = 15.25, ["Fly|Ride"] = 32.73, ["Neon"] = 3.92, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 29.02, ["Neon|Fly|Ride"] = 45.97, ["Mega"] = 40.48, ["Mega|Fly"] = 329.62, ["Mega|Ride"] = 80.69, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.49, ["Ride"] = 95.18, ["Fly|Ride"] = 418.82, ["Neon"] = 345.19, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1535.02, ["Mega|Ride"] = 1460.73, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 2.57, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 284.73, ["Mega"] = 30, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 19.99, ["Ride"] = 52.5, ["Fly|Ride"] = 169.63, ["Neon"] = 156.19, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 519.74, ["Mega|Ride"] = 791.31, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 15.75, ["Mega"] = 16.71}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 39.38, ["Mega"] = 21.57, ["Mega|Ride"] = 158.99}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 96.93, ["Fly"] = 223.13, ["Ride"] = 147, ["Fly|Ride"] = 301.53, ["Neon"] = 393.75, ["Neon|Ride"] = 571.69, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6524.89, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.56, ["Ride"] = 21.09, ["Fly|Ride"] = 94.98, ["Neon"] = 4.27, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 279.39}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 70.17, ["Fly|Ride"] = 51.45, ["Neon"] = 3.94, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 140.22, ["Mega"] = 34.13, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 277.61}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Ride"] = 61.74, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.11, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 1.79, ["Ride"] = 82.69, ["Neon"] = 6.15, ["Neon|Ride"] = 155.92, ["Mega"] = 59.07, ["Mega|Ride"] = 209.28}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 60.37, ["Ride"] = 135.19, ["Fly|Ride"] = 448.13, ["Neon"] = 437.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1569.56, ["Mega|Fly|Ride"] = 1535.02}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.14, ["Ride"] = 65.98, ["Neon"] = 39.36, ["Neon|Ride"] = 227.07, ["Mega"] = 474.55, ["Mega|Ride"] = 950.06}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 328.13, ["Fly|Ride"] = 508.09, ["Neon"] = 1115.63, ["Neon|Ride"] = 1395.85, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4009.85}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.91}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 48.3}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 26.21}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 129.12}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.27}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.12}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.16}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.71}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.86}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.39}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.32}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.52}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.83}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.17}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 561.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 788.28}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.91}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1029.11}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 57.75}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.78}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 32.65}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.3}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.44}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 4.77}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.68}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.56}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.36}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.75}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.59}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.36}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.04}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.6}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 28.14}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.18}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.98}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.04}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.54}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.27}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1181.25}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.29}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.24}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 21.94}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.77}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 219.85}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 30.35}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.29}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.59}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 21.71}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.82}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 87.05}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.99}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.22}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.1}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.92}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.22}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.9}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22555.68}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 318.15}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 45.04}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 37.41}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.38}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.55}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 131.72}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 54.56}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 7014.91}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.14}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.08}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 2.63}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.2}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.11}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.14}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.74}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 356}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 944.99}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 10.12}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.46}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.62}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 617.33}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 20.99}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 170.68}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.9}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.2}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.59}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.4}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.25}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.34}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.16}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 282.05}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 628.21}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.21}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.73}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 3.88}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.44}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 15.63}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.49}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.7}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 9.54}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.62}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.6}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.92}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.82}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.39}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.96}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.4}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.58}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8307.92}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.16}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.96}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.49}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.45}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.5}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.43}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 4.92}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 7.14}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.56}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4188.53}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.92}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.96}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 64.61}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.1}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 97.55}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.18}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.23}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.65}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 38.96}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.71}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.33}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.23}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.6}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.85}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.59}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.99}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.72}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.62}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 8.38}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1042.19}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 28.88}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.66}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 18.53}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.04}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.75}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.57}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.86}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.79}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 6.13}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.59}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 8.09}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.39}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.43}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.15}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.33}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.94}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 19.91}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.87}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.94}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 32.45}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.31}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.87}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 48.56}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.02}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 33.95}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.5}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.6}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.89}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.37}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.41}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 6.92}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1422.3}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.39}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.73}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.34}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 54.72}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.28}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.8}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.54}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.47}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.59}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.07}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.5}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.26}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.62}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.3}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.2}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 144.34}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.04}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.53}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.34}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 17.82}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.74}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.44}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 172.94}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.6}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.22}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 120.56}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.51}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.55}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.92}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.01}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 66.68}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.61}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.36}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 40.85}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.17}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 62.26}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.08}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.96}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 69.63}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.81}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.9}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 24.93}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 82.63}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1945.54}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.18}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.68}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 335.22}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.03}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.01}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.47}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.27}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.28}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 59.07}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 165.41}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.87}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1117.3}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 223.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.87}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.14}},
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