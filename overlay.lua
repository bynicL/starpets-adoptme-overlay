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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1039.17, ["Ride"] = 892.5, ["Fly|Ride"] = 1050, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3927, ["Mega|Fly|Ride"] = 32967.43}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 452.82, ["Fly"] = 607.85, ["Ride"] = 494.53, ["Fly|Ride"] = 525, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2060.47, ["Mega"] = 10302.33, ["Mega|Fly|Ride"] = 7723.28}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4528.13, ["Ride"] = 4593.75, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 20467.63, ["Mega|Fly|Ride"] = 68682.48}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 154.77, ["Fly"] = 150.94, ["Ride"] = 155.24, ["Fly|Ride"] = 288.75, ["Neon"] = 772.46, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1099.27, ["Mega"] = 4120.94, ["Mega|Fly|Ride"] = 3346.23}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 549.94, ["Fly"] = 550.16, ["Ride"] = 612.21, ["Fly|Ride"] = 584.06, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.09, ["Ride"] = 27.68, ["Fly|Ride"] = 152.46, ["Neon"] = 56.44, ["Neon|Fly"] = 275.05, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 285.27, ["Mega|Ride"] = 463.39, ["Mega|Fly|Ride"] = 463.39}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.08, ["Fly"] = 31.29, ["Ride"] = 26.22, ["Fly|Ride"] = 79.37, ["Neon"] = 26.25, ["Neon|Fly"] = 115.82, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 114.06, ["Mega"] = 131.06, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.92, ["Ride"] = 147.72, ["Fly|Ride"] = 233.63, ["Neon"] = 521.06, ["Neon|Ride"] = 617.13, ["Neon|Fly|Ride"] = 669.37, ["Mega|Ride"] = 2335.55, ["Mega|Fly|Ride"] = 2656.5}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 28.88, ["Fly"] = 138.06, ["Ride"] = 51.19, ["Fly|Ride"] = 91.88, ["Neon"] = 288.75, ["Neon|Ride"] = 301.87, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 2100, ["Mega|Ride"] = 893.22, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.25, ["Fly"] = 52.5, ["Ride"] = 31.28, ["Fly|Ride"] = 65.62, ["Neon"] = 247.25, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 1338.28, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 62.55, ["Fly"] = 206.07, ["Ride"] = 84.6, ["Fly|Ride"] = 131.25, ["Neon"] = 491.04, ["Neon|Fly"] = 370.9, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 2060.47}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.3}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 295.32, ["Fly"] = 395.01, ["Ride"] = 350.44, ["Fly|Ride"] = 377.41, ["Neon"] = 1305.17, ["Neon|Ride"] = 1236.06, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4849.31}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 111.09, ["Fly"] = 155.24, ["Ride"] = 123.38, ["Fly|Ride"] = 161.86, ["Neon|Fly"] = 687.09, ["Neon|Fly|Ride"] = 550.16, ["Mega|Fly|Ride"] = 2625.02}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.56, ["Fly"] = 114.37, ["Ride"] = 51.85, ["Fly|Ride"] = 131.23, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 189, ["Mega"] = 140.27, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 383.45}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 175.33, ["Fly"] = 200.82, ["Ride"] = 153.57, ["Fly|Ride"] = 209.98, ["Neon"] = 926.47, ["Neon|Fly|Ride"] = 632.63, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.78, ["Fly"] = 21.38, ["Ride"] = 18.56, ["Fly|Ride"] = 39.96, ["Neon"] = 25.94, ["Neon|Ride"] = 62.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 207.38, ["Mega|Fly"] = 347.54, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 393.88}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 102.38, ["Fly"] = 144.38, ["Ride"] = 144.38, ["Fly|Ride"] = 258.28, ["Neon"] = 393.75, ["Neon|Fly"] = 463.39, ["Neon|Ride"] = 373.74, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1504.16, ["Mega|Ride"] = 1194.38, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.28}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 126, ["Fly|Ride"] = 131.25, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 1841.03}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.12, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 223.13, ["Neon"] = 205.86, ["Neon|Ride"] = 179.27, ["Neon|Fly|Ride"] = 206.06, ["Mega|Ride"] = 580.04, ["Mega|Fly|Ride"] = 1648.39}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 44.52, ["Fly"] = 123.96, ["Ride"] = 53.82, ["Fly|Ride"] = 131.25, ["Neon"] = 241.34, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 1621.81, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.86, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 185.43, ["Neon|Fly"] = 384.5, ["Neon|Ride"] = 295.7, ["Neon|Fly|Ride"] = 353.38, ["Mega"] = 1162.12, ["Mega|Ride"] = 1232.18, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 19.69, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 344.08, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 822.13, ["Mega|Ride"] = 2058.42, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.68, ["Fly"] = 136.75, ["Ride"] = 43.64, ["Fly|Ride"] = 138.05, ["Neon"] = 210, ["Neon|Fly"] = 551.13, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 885.44}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.84, ["Fly"] = 30.92, ["Ride"] = 23.62, ["Fly|Ride"] = 52.5, ["Neon"] = 23.18, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 92.8, ["Mega"] = 131.25, ["Mega|Fly"] = 24849.92, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 249.54}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 406.96, ["Fly"] = 362.25, ["Ride"] = 412.11, ["Fly|Ride"] = 441.23, ["Neon"] = 1852.94, ["Neon|Ride"] = 1957.46, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7105.84}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 19.6, ["Ride"] = 32.45, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 177.21, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 514.11, ["Mega|Ride"] = 782.99, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.35, ["Fly"] = 34.19, ["Ride"] = 18.35, ["Fly|Ride"] = 48.2, ["Neon"] = 51.19, ["Neon|Fly"] = 78.1, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 124.72, ["Mega"] = 275.09, ["Mega|Ride"] = 267.61, ["Mega|Fly|Ride"] = 418.94}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 59.07, ["Fly"] = 117.21, ["Ride"] = 85.61, ["Fly|Ride"] = 131.25, ["Neon"] = 347.44, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 410.05, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 3022.72, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2064.57}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 31.95, ["Ride"] = 33.6, ["Fly|Ride"] = 75.22, ["Neon"] = 96.85, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 695.07, ["Mega|Ride"] = 782.99}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.59, ["Fly"] = 348.23, ["Ride"] = 272, ["Fly|Ride"] = 301.88, ["Neon"] = 702.19, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 1248.8, ["Mega"] = 6181.41, ["Mega|Fly|Ride"] = 2925.88}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 32.82}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 5.25, ["Fly"] = 29.81, ["Ride"] = 24.74, ["Fly|Ride"] = 48.88, ["Neon"] = 25.34, ["Neon|Fly"] = 132.07, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 206.06, ["Mega|Fly"] = 501.36, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 879.38, ["Fly"] = 2625, ["Ride"] = 874.12, ["Fly|Ride"] = 1025.09, ["Neon"] = 7158.38, ["Neon|Ride"] = 6044.38, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52129.45, ["Mega|Fly|Ride"] = 20080.28}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.82, ["Fly"] = 69.04, ["Ride"] = 32.8, ["Fly|Ride"] = 85.32, ["Neon"] = 77.6, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 225.63, ["Mega"] = 481.14, ["Mega|Ride"] = 687.19, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 193.47, ["Fly|Ride"] = 210, ["Neon"] = 872.51, ["Neon|Ride"] = 687.19, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2472.11, ["Mega|Fly|Ride"] = 2994.9}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.75, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 145.69, ["Neon"] = 82.41, ["Neon|Ride"] = 155.25, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 726.35}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 114.29, ["Ride"] = 118.13, ["Neon"] = 584.07, ["Neon|Ride"] = 593.13, ["Neon|Fly|Ride"] = 721.18, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 128.63, ["Ride"] = 143.07, ["Fly|Ride"] = 272.85, ["Neon"] = 435.74, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1545.36, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1973.93}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 42.6}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.4, ["Fly"] = 59.16, ["Ride"] = 55.05, ["Fly|Ride"] = 82.95, ["Neon|Ride"] = 477.28, ["Neon|Fly|Ride"] = 315, ["Mega"] = 4120.94, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.46, ["Fly"] = 55.65, ["Ride"] = 41.22, ["Fly|Ride"] = 131.25, ["Neon"] = 39.39, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 231.81, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 426.57, ["Ride"] = 465.51, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 3708.85, ["Neon|Fly|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.68, ["Fly"] = 180.3, ["Ride"] = 105, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Fly"] = 824.11, ["Neon|Ride"] = 574.6, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 2459.18, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3706.25, ["Ride"] = 3433.5, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14422.24}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42.68, ["Fly"] = 110.25, ["Ride"] = 59.72, ["Fly|Ride"] = 128.41, ["Neon"] = 393.75, ["Neon|Ride"] = 288.48, ["Neon|Fly|Ride"] = 339.99, ["Mega|Ride"] = 1182.72, ["Mega|Fly|Ride"] = 1417.61}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 72.19, ["Ride"] = 77.63, ["Fly|Ride"] = 195.57, ["Neon"] = 410.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 683.76, ["Mega"] = 2747.64, ["Mega|Fly|Ride"] = 2765.23}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 37.97, ["Fly"] = 53.29, ["Ride"] = 55.65, ["Fly|Ride"] = 110.25, ["Neon"] = 216.58, ["Neon|Ride"] = 148.22, ["Neon|Fly|Ride"] = 227.17, ["Mega"] = 962.26, ["Mega|Ride"] = 687.19, ["Mega|Fly|Ride"] = 535.75}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.93, ["Fly"] = 393.75, ["Ride"] = 52.5, ["Fly|Ride"] = 63.63, ["Neon"] = 360.55, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 296.57, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.08}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.49, ["Ride"] = 218.43, ["Fly|Ride"] = 315.27, ["Neon|Ride"] = 1390.13, ["Neon|Fly|Ride"] = 1374.35, ["Mega|Fly|Ride"] = 4943.05}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1099.27, ["Ride"] = 962.26, ["Fly|Ride"] = 977.82, ["Neon"] = 2625, ["Neon|Ride"] = 3863.39, ["Neon|Fly|Ride"] = 3018.74}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.54, ["Fly"] = 51.19, ["Ride"] = 39.3, ["Fly|Ride"] = 76.13, ["Neon"] = 138.05, ["Neon|Ride"] = 204.01, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 893.22}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.78}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6305.03, ["Fly|Ride"] = 4725, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40159.39}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 74.82, ["Ride"] = 26.23, ["Fly|Ride"] = 54.57, ["Neon"] = 97.88, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 659.36, ["Mega|Ride"] = 587.33, ["Mega|Fly|Ride"] = 612.94}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.91, ["Fly"] = 41.22, ["Ride"] = 27.83, ["Fly|Ride"] = 114.7, ["Neon"] = 96.85, ["Neon|Ride"] = 132.6, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1031.02, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1027.16}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.7, ["Fly"] = 271.07, ["Ride"] = 72.18, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 382.24, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4120.94}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.76, ["Fly"] = 150.93, ["Ride"] = 26.25, ["Fly|Ride"] = 107.15, ["Neon"] = 74.82, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1374.35, ["Mega|Ride"] = 501.74, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1776.7, ["Fly"] = 2122.32, ["Ride"] = 1854.43, ["Fly|Ride"] = 1781.07, ["Neon|Fly|Ride"] = 3465, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28846.51, ["Fly|Ride"] = 25265.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65249.75, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.55, ["Fly"] = 393.74, ["Ride"] = 54.46, ["Fly|Ride"] = 89.63, ["Neon"] = 261.66, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 962.26, ["Mega|Ride"] = 756.2, ["Mega|Fly|Ride"] = 820.09}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.68, ["Fly"] = 75.68, ["Ride"] = 43.32, ["Fly|Ride"] = 136.5, ["Neon"] = 18.38, ["Neon|Fly"] = 133.93, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 91.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.37}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 9.44, ["Ride"] = 44.31, ["Fly|Ride"] = 124.67, ["Neon"] = 61.82, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 463.62, ["Mega"] = 370.56, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Ride"] = 726.21, ["Fly|Ride"] = 786.19, ["Neon"] = 3159.35, ["Neon|Fly|Ride"] = 2808.75, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 951.81, ["Fly"] = 962.07, ["Ride"] = 1003.47, ["Fly|Ride"] = 1003.47, ["Neon"] = 4120.44, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11330.5}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 17.38, ["Fly"] = 115.86, ["Ride"] = 28.88, ["Fly|Ride"] = 90.57, ["Neon"] = 145.69, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1133.27, ["Mega|Ride"] = 943.7, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 25.91}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.78, ["Fly"] = 93.19, ["Ride"] = 73.5, ["Fly|Ride"] = 108.94, ["Neon"] = 412.06, ["Neon|Ride"] = 406.96, ["Neon|Fly|Ride"] = 412.11, ["Mega|Ride"] = 2017.21, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 57.88, ["Ride"] = 77.22, ["Fly|Ride"] = 155.24, ["Neon"] = 336.86, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2076.16, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 27.83, ["Ride"] = 20, ["Fly|Ride"] = 51.32, ["Neon"] = 36.75, ["Neon|Fly"] = 525, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 322.88, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.38, ["Fly"] = 136.5, ["Ride"] = 118.12, ["Fly|Ride"] = 190.04, ["Neon"] = 367.35, ["Neon|Ride"] = 450.21, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1437.62}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.25, ["Ride"] = 47.4, ["Fly|Ride"] = 110.12, ["Neon"] = 39.38, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 480.1, ["Mega"] = 235.75, ["Mega|Fly"] = 275.09, ["Mega|Ride"] = 397.37, ["Mega|Fly|Ride"] = 506.42}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.07, ["Fly"] = 41.11, ["Ride"] = 27.83, ["Fly|Ride"] = 90.67, ["Neon"] = 108.88, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 162.8, ["Mega|Fly|Ride"] = 756.2}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 33.32, ["Ride"] = 62.57, ["Fly|Ride"] = 156.19, ["Neon"] = 262.69, ["Neon|Ride"] = 329.69, ["Mega"] = 694.25, ["Mega|Ride"] = 772.69, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.48, ["Fly"] = 124.8, ["Ride"] = 28.88, ["Fly|Ride"] = 49.88, ["Neon"] = 91.88, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 824.2, ["Mega|Ride"] = 927.23, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7180.83, ["Ride"] = 7141.32, ["Fly|Ride"] = 6685.88, ["Neon"] = 30903.12, ["Neon|Fly|Ride"] = 27337.22}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 247.27, ["Fly"] = 273, ["Ride"] = 255.94, ["Fly|Ride"] = 296.63, ["Neon|Fly|Ride"] = 543.38, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 36.75, ["Fly"] = 130.92, ["Ride"] = 82.69, ["Fly|Ride"] = 145.99, ["Neon"] = 90.57, ["Neon|Fly"] = 179.25, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 288.75, ["Mega|Ride"] = 407.96, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.68, ["Fly"] = 85.73, ["Ride"] = 23.63, ["Fly|Ride"] = 96.85, ["Neon"] = 23.07, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 187.52, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 44.63, ["Fly"] = 5250.89, ["Ride"] = 97.54, ["Fly|Ride"] = 190.89, ["Neon"] = 184.42, ["Neon|Fly"] = 333.78, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.8, ["Mega|Ride"] = 563.2, ["Mega|Fly|Ride"] = 643.79}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14253.75, ["Ride"] = 13415.07, ["Fly|Ride"] = 12598.59, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 157.5, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 1374.17, ["Neon|Ride"] = 1442.35, ["Neon|Fly|Ride"] = 1442.35, ["Mega|Fly|Ride"] = 5043}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 61.68, ["Fly"] = 101.88, ["Ride"] = 72.19, ["Fly|Ride"] = 86.98, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2573.53}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.19, ["Fly"] = 44.03, ["Ride"] = 26.8, ["Fly|Ride"] = 55.55, ["Neon"] = 85.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 467.75, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 824.2, ["Ride"] = 411.18, ["Fly|Ride"] = 471.7, ["Neon"] = 1706.25, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1545.36, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.76, ["Fly"] = 101.53, ["Ride"] = 37.1, ["Fly|Ride"] = 108.88, ["Neon"] = 27.57, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 133.88, ["Fly"] = 204.01, ["Ride"] = 161.44, ["Fly|Ride"] = 233.88, ["Neon"] = 755.08, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 3156.64}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 7.88, ["Fly"] = 15.47, ["Ride"] = 18.36, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 96.37, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 755.31}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 71.84, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 550.09, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1390.13}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.95, ["Fly"] = 102.01, ["Ride"] = 35.3, ["Fly|Ride"] = 86.52, ["Neon"] = 102.38, ["Neon|Ride"] = 74.26, ["Neon|Fly|Ride"] = 189, ["Mega"] = 514.11, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 547}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 21.52}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 32.82, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1099.27, ["Mega|Ride"] = 954, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.24, ["Ride"] = 29.23, ["Fly|Ride"] = 132.04, ["Neon"] = 22.66, ["Neon|Ride"] = 104.28, ["Neon|Fly|Ride"] = 266.84, ["Mega"] = 118.13, ["Mega|Ride"] = 210.86, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.9, ["Fly"] = 47.25, ["Ride"] = 36.08, ["Fly|Ride"] = 77.55, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 163.26, ["Mega|Ride"] = 574.89, ["Mega|Fly|Ride"] = 772.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 536.26, ["Ride"] = 433.13, ["Fly|Ride"] = 523.69, ["Neon|Fly|Ride"] = 2740.43, ["Mega|Fly|Ride"] = 13737.12}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.74, ["Fly"] = 103.03, ["Ride"] = 55.1, ["Fly|Ride"] = 103.69, ["Neon"] = 233.85, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 822.13}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 50.3, ["Fly"] = 117.49, ["Ride"] = 96.87, ["Fly|Ride"] = 138.05, ["Neon|Ride"] = 317.33, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 721.18, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 23.6, ["Fly"] = 91.52, ["Ride"] = 66.94, ["Fly|Ride"] = 191.62, ["Neon"] = 131.25, ["Neon|Ride"] = 179.27, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 406.96, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 588.28}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 13273.32, ["Fly|Ride"] = 7599.38, ["Neon|Fly|Ride"] = 13778.63, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1706.25, ["Ride"] = 1575, ["Fly|Ride"] = 1506.75, ["Neon|Fly|Ride"] = 4305, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 492.19, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon"] = 2260.55, ["Neon|Fly|Ride"] = 2369.55, ["Mega|Fly|Ride"] = 6727.43}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.45, ["Fly"] = 23.63, ["Ride"] = 23, ["Fly|Ride"] = 45.34, ["Neon"] = 110.24, ["Neon|Ride"] = 94.8, ["Neon|Fly|Ride"] = 138.06, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.65, ["Fly"] = 78.74, ["Ride"] = 31.39, ["Neon"] = 23.86, ["Neon|Ride"] = 68.37, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 133.58, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 43.32, ["Fly"] = 78.74, ["Ride"] = 51.19, ["Fly|Ride"] = 91.88, ["Neon"] = 203.98, ["Neon|Ride"] = 195.56, ["Neon|Fly|Ride"] = 161.17, ["Mega|Fly|Ride"] = 511.35}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 4.87, ["Fly"] = 20.87, ["Ride"] = 16.44, ["Fly|Ride"] = 32.82, ["Neon"] = 27.8, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 84, ["Mega"] = 262.5, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 315.68, ["Fly|Ride"] = 375.29, ["Neon"] = 1004.41, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1169.44}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 20.89, ["Fly"] = 60.08, ["Ride"] = 32.82, ["Fly|Ride"] = 76.48, ["Neon"] = 208.68, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.34, ["Fly"] = 20.99, ["Ride"] = 20.4, ["Fly|Ride"] = 43.39, ["Neon"] = 69.03, ["Neon|Fly"] = 132.04, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 583.86, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 576.94, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 659.36, ["Neon|Ride"] = 2884.67, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1049.99, ["Fly"] = 1390.05, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 114.37, ["Fly"] = 128.63, ["Ride"] = 108.9, ["Fly|Ride"] = 118.12, ["Neon"] = 515.07, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 350.3, ["Mega|Ride"] = 2335.55, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 144.38, ["Fly"] = 157.5, ["Ride"] = 178.5, ["Fly|Ride"] = 245.44, ["Neon"] = 577.5, ["Neon|Ride"] = 695.07, ["Neon|Fly|Ride"] = 597.19, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 1932.28}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.23, ["Ride"] = 61.69, ["Fly|Ride"] = 275.09, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega|Ride"] = 2060.47, ["Mega|Fly|Ride"] = 810.81}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 123.64, ["Ride"] = 206.06, ["Fly|Ride"] = 105, ["Neon|Fly|Ride"] = 1297.46, ["Mega|Fly|Ride"] = 3296.76}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2099.99, ["Fly"] = 2335.55, ["Ride"] = 2239.74, ["Fly|Ride"] = 2610.62, ["Neon|Fly|Ride"] = 10302.33, ["Mega|Fly|Ride"] = 24714.01}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 55.65, ["Ride"] = 68.97, ["Fly|Ride"] = 196.88, ["Neon"] = 350.24, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 440.95, ["Mega|Ride"] = 2266.52, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.46, ["Fly"] = 616.88, ["Ride"] = 620.79, ["Fly|Ride"] = 603.75, ["Neon|Ride"] = 1374.35, ["Neon|Fly|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 3108}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 46.92, ["Fly"] = 60.37, ["Ride"] = 52.5, ["Fly|Ride"] = 96.87, ["Neon|Ride"] = 359.14, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1099.27}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.24, ["Fly"] = 31.29, ["Ride"] = 17.05, ["Fly|Ride"] = 50.68, ["Neon"] = 23.18, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 44.39, ["Neon|Fly|Ride"] = 96.87, ["Mega"] = 144.31, ["Mega|Ride"] = 218.43, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 1506.21, ["Mega|Ride"] = 1374.35, ["Mega|Fly|Ride"] = 1236.3}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.77, ["Fly"] = 1013.58, ["Ride"] = 813.75, ["Fly|Ride"] = 826.87, ["Neon"] = 2472.27, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2214.55, ["Mega|Fly|Ride"] = 8929.04}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 681.19, ["Fly|Ride"] = 872.82, ["Neon"] = 5150.53, ["Neon|Fly|Ride"] = 4111.67, ["Mega|Fly|Ride"] = 15247.45}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 19.55, ["Fly"] = 31.95, ["Ride"] = 23.71, ["Fly|Ride"] = 50.76, ["Neon"] = 185.43, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.08, ["Ride"] = 23.55, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 108.9, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 506.89, ["Mega|Ride"] = 506.89, ["Mega|Fly|Ride"] = 387.39}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.35, ["Ride"] = 25.16, ["Fly|Ride"] = 111.46, ["Neon"] = 20.99, ["Neon|Fly"] = 309.23, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 152.5, ["Mega"] = 141.63, ["Mega|Fly"] = 525.95, ["Mega|Ride"] = 220.4, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 46.39, ["Fly"] = 40.69, ["Ride"] = 45.9, ["Fly|Ride"] = 87.02, ["Neon"] = 210, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 206.06, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 57.75, ["Ride"] = 69.04, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 1545.36, ["Mega|Ride"] = 1545.36, ["Mega|Fly|Ride"] = 1325.93}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.34, ["Fly"] = 55.48, ["Ride"] = 34.04, ["Fly|Ride"] = 78.75, ["Neon"] = 72.19, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 401.99, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 39.26, ["Ride"] = 46.4, ["Fly|Ride"] = 83.16, ["Neon"] = 550.09, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 962.26, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.15, ["Fly"] = 27.83, ["Ride"] = 18.71, ["Fly|Ride"] = 40.68, ["Neon"] = 28.88, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 316.31}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.74, ["Fly"] = 32.49, ["Ride"] = 28.58, ["Fly|Ride"] = 80.88, ["Neon"] = 25.95, ["Neon|Fly"] = 155.25, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 445.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 39.38, ["Fly"] = 65.62, ["Ride"] = 51.17, ["Fly|Ride"] = 89.45, ["Neon"] = 401.86, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1018.87}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1600.89, ["Fly"] = 1854.43, ["Ride"] = 1431.93, ["Fly|Ride"] = 1522.49, ["Neon|Ride"] = 4671.09, ["Neon|Fly|Ride"] = 3739.32, ["Mega|Fly|Ride"] = 13129.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 456.75, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 3022.72, ["Neon|Fly|Ride"] = 2990.78, ["Mega|Fly|Ride"] = 9614.14}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 249.38, ["Fly"] = 287.06, ["Ride"] = 277.86, ["Fly|Ride"] = 433.13, ["Neon|Fly|Ride"] = 1374.35, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.8}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.56, ["Ride"] = 41.9, ["Fly|Ride"] = 91.88, ["Neon"] = 328.91, ["Neon|Fly"] = 412.06, ["Neon|Ride"] = 352.35, ["Neon|Fly|Ride"] = 316.31, ["Mega"] = 1236.06, ["Mega|Ride"] = 962.26, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41209.28, ["Fly"] = 65625, ["Ride"] = 34750.94, ["Fly|Ride"] = 17823.75, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 336, ["Fly"] = 362.09, ["Ride"] = 386.91, ["Fly|Ride"] = 412.11, ["Neon"] = 926.47, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1071.46, ["Mega"] = 6181.41, ["Mega|Fly|Ride"] = 3858.73}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 168, ["Fly"] = 525, ["Ride"] = 165.38, ["Fly|Ride"] = 171.45, ["Mega|Fly|Ride"] = 4120.94}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.59, ["Fly"] = 135.19, ["Ride"] = 122.79, ["Fly|Ride"] = 178.5, ["Neon"] = 694.86, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 550.16, ["Mega|Fly|Ride"] = 2471.55}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 32.48, ["Fly|Ride"] = 104.63, ["Neon"] = 275.05, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 687.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 515.12}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4808.1, ["Ride"] = 4865.8, ["Fly|Ride"] = 4067.44, ["Neon|Fly|Ride"] = 27473.2, ["Mega|Fly|Ride"] = 61783.82}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 48.57, ["Ride"] = 32.82, ["Fly|Ride"] = 53.8, ["Neon"] = 228.69, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1374.35, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.35, ["Fly"] = 138.06, ["Ride"] = 43.32, ["Fly|Ride"] = 101.07, ["Neon"] = 403.96, ["Neon|Ride"] = 267.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1545.36, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 721.88, ["Fly"] = 918.75, ["Ride"] = 780.22, ["Fly|Ride"] = 800.63, ["Neon"] = 2595.88, ["Neon|Ride"] = 2205, ["Neon|Fly|Ride"] = 2211.57, ["Mega"] = 9052.66, ["Mega|Fly|Ride"] = 7217.7}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.5, ["Fly"] = 33.69, ["Ride"] = 26.16, ["Fly|Ride"] = 41.3, ["Neon"] = 131.25, ["Neon|Fly"] = 155.25, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 156, ["Mega|Fly|Ride"] = 618.15}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 15.46, ["Fly"] = 96.87, ["Ride"] = 30.92, ["Fly|Ride"] = 463.24, ["Neon"] = 80.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 179.27, ["Mega|Ride"] = 522.34, ["Mega|Fly|Ride"] = 550.16}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.84, ["Ride"] = 115.5, ["Fly|Ride"] = 294.25, ["Neon"] = 534.64, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 718.25, ["Mega|Fly|Ride"] = 2472.11}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 24.52, ["Fly"] = 105.1, ["Ride"] = 78.45, ["Fly|Ride"] = 131.25, ["Neon"] = 83.01, ["Neon|Ride"] = 128.27, ["Neon|Fly|Ride"] = 263.92, ["Mega"] = 275.63, ["Mega|Fly"] = 735.61, ["Mega|Ride"] = 297.47, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3977.95, ["Ride"] = 3937.5, ["Fly|Ride"] = 3543.75, ["Neon"] = 12361.26, ["Neon|Ride"] = 13901.2, ["Neon|Fly|Ride"] = 9016.88, ["Mega"] = 61811.87, ["Mega|Fly|Ride"] = 32694.42}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 64.3, ["Fly|Ride"] = 108.66, ["Neon"] = 205.01, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 412.11, ["Mega|Ride"] = 1029.23, ["Mega|Fly|Ride"] = 1222.91}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Ride"] = 7829.78, ["Fly|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 16711.56, ["Mega|Fly|Ride"] = 67961.75}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 16.28, ["Fly|Ride"] = 41.54, ["Neon"] = 22.32, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 332.49, ["Mega|Ride"] = 192.67, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.69, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 138.05, ["Neon|Ride"] = 191.64, ["Neon|Fly|Ride"] = 155.58, ["Mega|Fly|Ride"] = 926.77}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.56}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.44, ["Fly"] = 39.38, ["Ride"] = 37.85, ["Fly|Ride"] = 115.5, ["Neon"] = 183.74, ["Neon|Ride"] = 157.68, ["Mega"] = 770.6, ["Mega|Ride"] = 962.26, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 29.46, ["Fly"] = 190.37, ["Ride"] = 44.62, ["Fly|Ride"] = 150.43, ["Neon"] = 185.43, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 279.67, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.6, ["Fly"] = 23.55, ["Ride"] = 20.63, ["Fly|Ride"] = 35.44, ["Neon"] = 82.42, ["Neon|Ride"] = 114.37, ["Neon|Fly|Ride"] = 175.17, ["Mega"] = 786.19, ["Mega|Ride"] = 578.07, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8344.9}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.64}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.24, ["Fly"] = 344.11, ["Ride"] = 155.24, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1030.24}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.16, ["Fly"] = 123.64, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 180.29, ["Neon|Ride"] = 154.54, ["Neon|Fly|Ride"] = 205.03, ["Mega"] = 412.11, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 947.83}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.22}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.46, ["Ride"] = 29.22, ["Fly|Ride"] = 69.03, ["Neon"] = 81.39, ["Neon|Ride"] = 69.04, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3045}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 148.32, ["Fly"] = 282.3, ["Ride"] = 199.5, ["Fly|Ride"] = 196.88, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 756.2, ["Mega|Ride"] = 2884.67, ["Mega|Fly|Ride"] = 3022.72}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 152.91, ["Ride"] = 142.49, ["Fly|Ride"] = 211.32, ["Neon"] = 550.09, ["Neon|Ride"] = 618.15, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2747.64, ["Mega|Fly|Ride"] = 1699.43}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.86, ["Fly"] = 186.62, ["Ride"] = 207.38, ["Fly|Ride"] = 246.89, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 954.35, ["Mega|Fly|Ride"] = 3138.71}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1732.4, ["Fly"] = 2472.58, ["Ride"] = 1708.72, ["Fly|Ride"] = 1777.6, ["Neon"] = 14468.86, ["Neon|Ride"] = 6455.45, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 30891.92}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.01, ["Fly"] = 80.37, ["Ride"] = 39.4, ["Fly|Ride"] = 93.77, ["Neon"] = 155.56, ["Neon|Ride"] = 204.01, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 926.2, ["Mega|Ride"] = 896.32, ["Mega|Fly|Ride"] = 1090}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 590.63, ["Fly|Ride"] = 886.02, ["Neon|Ride"] = 2626.18, ["Neon|Fly|Ride"] = 4016.3}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 37.95}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 16.63, ["Ride"] = 48.44, ["Fly|Ride"] = 138.06, ["Neon"] = 99.75, ["Neon|Ride"] = 123.64, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 406.88, ["Mega|Ride"] = 457.94, ["Mega|Fly|Ride"] = 481.14}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.54, ["Fly"] = 48.44, ["Ride"] = 26.19, ["Fly|Ride"] = 44.18, ["Neon"] = 52.5, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 918.75, ["Mega|Ride"] = 345.14, ["Mega|Fly|Ride"] = 355.65}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 51.07}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.6, ["Fly"] = 108.92, ["Ride"] = 23.18, ["Fly|Ride"] = 55.61, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 918.75, ["Mega|Ride"] = 824.2, ["Mega|Fly|Ride"] = 1390.13}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 30.92, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 52.07, ["Neon|Ride"] = 303.94, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 824.2, ["Mega|Ride"] = 1737.66, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10978.57, ["Ride"] = 4987.5, ["Fly|Ride"] = 5046.57, ["Neon|Fly|Ride"] = 10475.33, ["Mega|Fly|Ride"] = 35372.73}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.48, ["Fly"] = 46.88, ["Ride"] = 35.34, ["Fly|Ride"] = 92.66, ["Neon"] = 64.6, ["Neon|Ride"] = 78.6, ["Mega"] = 518.99, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 127.32, ["Fly"] = 364.72, ["Ride"] = 134.89, ["Fly|Ride"] = 131.25, ["Neon"] = 485.63, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 700.58, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 2008.74}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.18, ["Fly"] = 96.48, ["Ride"] = 69.04, ["Fly|Ride"] = 152.25, ["Neon"] = 231.63, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 463.39, ["Mega"] = 2316.87, ["Mega|Ride"] = 2781.64, ["Mega|Fly|Ride"] = 1511.36}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.43, ["Fly"] = 70.46, ["Ride"] = 32.99, ["Fly|Ride"] = 66.17, ["Neon"] = 161.44, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 1016.21, ["Mega|Ride"] = 810.81, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.45, ["Fly"] = 58.74, ["Ride"] = 27.57, ["Fly|Ride"] = 59.77, ["Neon"] = 32.82, ["Neon|Ride"] = 56.31, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 157.49, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 309.12}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Fly"] = 138.06, ["Ride"] = 27.84, ["Fly|Ride"] = 64.32, ["Neon"] = 82.36, ["Neon|Ride"] = 123.64, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 514.11, ["Mega|Ride"] = 509.99, ["Mega|Fly|Ride"] = 550.16}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.4, ["Fly"] = 30.19, ["Ride"] = 26.86, ["Fly|Ride"] = 50.72, ["Neon"] = 203.98, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 539.44}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 157.5}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 15.46, ["Ride"] = 96.87, ["Neon"] = 177.19, ["Neon|Ride"] = 824.2, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 275.09, ["Fly"] = 463.36, ["Ride"] = 443.63, ["Fly|Ride"] = 1545.27, ["Neon"] = 1099.13}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.38, ["Fly"] = 212.02, ["Ride"] = 91.88, ["Fly|Ride"] = 152.25, ["Neon"] = 249.38, ["Neon|Ride"] = 385.32, ["Neon|Fly|Ride"] = 420, ["Mega"] = 905.51, ["Mega|Ride"] = 2139.64, ["Mega|Fly|Ride"] = 1390.13}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1182.72, ["Ride"] = 935.29, ["Fly|Ride"] = 992.25, ["Neon|Ride"] = 3131.91, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11519.82}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 288.74, ["Fly"] = 463.36, ["Ride"] = 346.5, ["Fly|Ride"] = 393.74, ["Neon"] = 2834.27, ["Neon|Ride"] = 1099.27, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 8132.25, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.72}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 13.26, ["Fly"] = 34.37, ["Ride"] = 23.18, ["Fly|Ride"] = 52.48, ["Neon"] = 78.73, ["Neon|Fly"] = 115.82, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 686.15, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 301.88, ["Fly"] = 762.36, ["Ride"] = 324.84, ["Fly|Ride"] = 428.16, ["Neon"] = 1082.65, ["Neon|Ride"] = 891.19, ["Neon|Fly|Ride"] = 962.26, ["Mega|Ride"] = 3296.76, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 109.22, ["Fly"] = 138.06, ["Ride"] = 211.1, ["Fly|Ride"] = 313.69, ["Neon"] = 674.14, ["Neon|Fly"] = 1718.24, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9890.25, ["Mega|Ride"] = 11719.94, ["Mega|Fly|Ride"] = 2656.56}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 134.53, ["Ride"] = 126, ["Fly|Ride"] = 157.5, ["Neon"] = 673.7, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 927.23, ["Mega|Fly|Ride"] = 2418.99}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 30.85, ["Fly|Ride"] = 72.98, ["Neon"] = 26.8, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 264.75, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 803.6}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.38, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 280.77, ["Mega|Ride"] = 801.53, ["Mega|Fly|Ride"] = 581.07}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 19.69, ["Fly"] = 102.31, ["Ride"] = 44.6, ["Fly|Ride"] = 99.75, ["Neon"] = 123.63, ["Neon|Ride"] = 130.86, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 453.32, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 686.15}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.16, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 137.97, ["Neon"] = 24.93, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 105, ["Mega|Fly"] = 239.04, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.94, ["Ride"] = 261.19, ["Fly|Ride"] = 362.85, ["Neon"] = 1617.28, ["Neon|Ride"] = 1441.1, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5220.21}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 105.1, ["Fly"] = 550.16, ["Ride"] = 183.75, ["Fly|Ride"] = 291.38, ["Neon"] = 809.67, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1077.64, ["Mega"] = 9890.25, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2736.57}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 76.96, ["Fly"] = 167.45, ["Ride"] = 101.73, ["Fly|Ride"] = 181.13, ["Neon"] = 412.06, ["Neon|Ride"] = 398.71, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1359.92}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.81, ["Ride"] = 69.04, ["Fly|Ride"] = 275.05, ["Neon|Ride"] = 588.5, ["Neon|Fly|Ride"] = 481.14, ["Mega|Ride"] = 618.15, ["Mega|Fly|Ride"] = 1648.39}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.3, ["Fly"] = 75.63, ["Ride"] = 40.2, ["Fly|Ride"] = 82.43, ["Neon"] = 77.44, ["Neon|Fly"] = 206.04, ["Neon|Ride"] = 99.47, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 354.41, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.52, ["Fly"] = 47.4, ["Ride"] = 18.38, ["Fly|Ride"] = 81.33, ["Neon"] = 17.07, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 130.76, ["Mega"] = 131.25, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1071.46, ["Ride"] = 947.83, ["Fly|Ride"] = 1004.07, ["Neon"] = 3039.12, ["Neon|Fly"] = 3398.85, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7590.69}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 362.24, ["Ride"] = 389.03, ["Fly|Ride"] = 522.27, ["Neon|Ride"] = 2747.64, ["Neon|Fly|Ride"] = 1924.49, ["Mega"] = 10302.33, ["Mega|Fly|Ride"] = 6561.19}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 77.44, ["Fly"] = 105, ["Ride"] = 103.69, ["Fly|Ride"] = 192.64, ["Neon"] = 249.38, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 386.93, ["Mega"] = 1575.49, ["Mega|Ride"] = 1648.39, ["Mega|Fly|Ride"] = 1765.83}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 282.3, ["Ride"] = 295.42, ["Fly|Ride"] = 274.32, ["Neon|Ride"] = 1390.13, ["Neon|Fly|Ride"] = 1058.07, ["Mega"] = 10302.33, ["Mega|Fly|Ride"] = 5053.13}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 22.65, ["Fly"] = 138.06, ["Ride"] = 31.29, ["Fly|Ride"] = 69.21, ["Neon"] = 124.69, ["Neon|Ride"] = 103.03, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 764.58}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 206.06, ["Ride"] = 275.09, ["Fly|Ride"] = 548.03, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4100.62, ["Mega|Ride"] = 4258.99, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 61.83, ["Fly"] = 76.13, ["Ride"] = 39.38, ["Fly|Ride"] = 130.6, ["Neon|Ride"] = 494.53, ["Neon|Fly|Ride"] = 550.16, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1674.75, ["Ride"] = 1675.16, ["Fly|Ride"] = 1745.23, ["Neon|Ride"] = 10812.82, ["Neon|Fly|Ride"] = 5043, ["Mega"] = 49451.14, ["Mega|Fly|Ride"] = 21840.93}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.54, ["Fly"] = 46.35, ["Ride"] = 54.46, ["Fly|Ride"] = 104.27, ["Neon"] = 55.64, ["Neon|Fly"] = 185.22, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 216.65, ["Mega"] = 233.88, ["Mega|Fly"] = 370.71, ["Mega|Ride"] = 314.62, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 47.48, ["Fly"] = 119.1, ["Ride"] = 74.19, ["Fly|Ride"] = 157.5, ["Neon"] = 274.82, ["Neon|Ride"] = 279.21, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 884.99, ["Mega|Ride"] = 1008.61, ["Mega|Fly|Ride"] = 1004.37}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 82.43, ["Fly"] = 78.75, ["Ride"] = 77.44, ["Fly|Ride"] = 110.25, ["Neon|Ride"] = 454.34, ["Neon|Fly|Ride"] = 387.19, ["Mega|Fly|Ride"] = 1511.36}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 1374.35, ["Ride"] = 2316.75, ["Fly|Ride"] = 1170.75, ["Neon|Fly|Ride"] = 7417.68, ["Mega|Fly|Ride"] = 20697.72}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 616.27, ["Fly"] = 822.13, ["Ride"] = 597.55, ["Fly|Ride"] = 669.56, ["Neon|Fly|Ride"] = 2703.8, ["Mega|Fly|Ride"] = 16991.9}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.88, ["Ride"] = 115.5, ["Fly|Ride"] = 196.88, ["Neon"] = 444.29, ["Neon|Fly"] = 618.08, ["Neon|Ride"] = 454.34, ["Neon|Fly|Ride"] = 550.16, ["Mega"] = 4120.94, ["Mega|Ride"] = 2603.42, ["Mega|Fly|Ride"] = 2335.55}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.49, ["Ride"] = 27.83, ["Fly|Ride"] = 91.68, ["Neon"] = 72.12, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 185.36, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1374.35}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 41.22, ["Fly"] = 101.95, ["Ride"] = 48.42, ["Fly|Ride"] = 106.58, ["Neon"] = 199.5, ["Neon|Fly"] = 412.06, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 311.15, ["Mega|Ride"] = 1195.08, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 714.66, ["Ride"] = 824.2, ["Fly|Ride"] = 915.36, ["Neon"] = 3020.28, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 15111.45}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 853.13}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5905.3, ["Ride"] = 6023.52, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29527.49, ["Neon|Fly|Ride"] = 24039.44, ["Mega|Fly|Ride"] = 87913.81}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 244.13, ["Fly"] = 406.82, ["Ride"] = 303.94, ["Fly|Ride"] = 367.5, ["Neon"] = 1648.19, ["Neon|Fly|Ride"] = 2060.47, ["Mega"] = 5769.31, ["Mega|Fly|Ride"] = 5907.37}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 65.33, ["Fly"] = 275.09, ["Ride"] = 98.91, ["Fly|Ride"] = 336, ["Neon"] = 409.99, ["Neon|Ride"] = 550.16, ["Neon|Fly|Ride"] = 1648.39, ["Mega|Fly|Ride"] = 2870.23}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.07, ["Fly"] = 96.87, ["Ride"] = 36.08, ["Fly|Ride"] = 72.13, ["Neon"] = 110.24, ["Neon|Fly"] = 1235.7, ["Neon|Ride"] = 94.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 658.33, ["Mega|Ride"] = 719.11, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.38, ["Fly"] = 39.38, ["Ride"] = 26.7, ["Fly|Ride"] = 44.34, ["Neon"] = 206.04, ["Neon|Fly"] = 275.05, ["Neon|Ride"] = 309.32, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 1312.5, ["Mega|Ride"] = 1588.63, ["Mega|Fly|Ride"] = 2184.11}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.04, ["Fly"] = 275.09, ["Ride"] = 41.22, ["Fly|Ride"] = 131.25, ["Neon"] = 105, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 148.36, ["Mega"] = 550.16, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 20.99, ["Fly|Ride"] = 52.5, ["Neon"] = 19.57, ["Neon|Fly"] = 339.94, ["Neon|Ride"] = 49.47, ["Neon|Fly|Ride"] = 185.36, ["Mega"] = 275.09, ["Mega|Ride"] = 232.85, ["Mega|Fly|Ride"] = 309.32}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.37, ["Ride"] = 43.31, ["Fly|Ride"] = 183.75, ["Neon"] = 164.83, ["Neon|Fly"] = 824.2, ["Neon|Ride"] = 222.54, ["Neon|Fly|Ride"] = 328.83, ["Mega"] = 661.43, ["Mega|Ride"] = 659.36, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 315, ["Fly"] = 454.34, ["Ride"] = 370.13, ["Fly|Ride"] = 400.32, ["Neon"] = 1181.25, ["Neon|Fly"] = 1458.64, ["Neon|Ride"] = 1222.91, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 7875, ["Mega|Fly"] = 4532.01, ["Mega|Ride"] = 4120.94, ["Mega|Fly|Ride"] = 4533.03}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.6, ["Fly"] = 15.64, ["Ride"] = 15.37, ["Fly|Ride"] = 45.35, ["Neon"] = 19.67, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 463.62, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.22, ["Fly"] = 92.73, ["Ride"] = 84.27, ["Fly|Ride"] = 115.48, ["Neon"] = 201.86, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 260.93, ["Mega"] = 551.25, ["Mega|Fly"] = 824.2, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 615.57}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 777.67, ["Fly"] = 973.04, ["Ride"] = 768.93, ["Fly|Ride"] = 733.69, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1442.44, ["Mega|Fly|Ride"] = 3777.38}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.49, ["Fly"] = 91.88, ["Ride"] = 44.63, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 221.58, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 324.84, ["Ride"] = 275.09, ["Fly|Ride"] = 328.13, ["Neon|Fly|Ride"] = 1098.24, ["Mega|Fly|Ride"] = 13901.2}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.75, ["Fly"] = 240.96, ["Ride"] = 190.3, ["Fly|Ride"] = 198.19, ["Neon"] = 627.29, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 689.07, ["Mega|Fly|Ride"] = 3283.35}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 713.1, ["Ride"] = 682.5, ["Fly|Ride"] = 816, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2857.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.58, ["Ride"] = 43.21, ["Fly|Ride"] = 108.9, ["Neon"] = 78.08, ["Neon|Fly"] = 277.95, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 348.23, ["Mega|Ride"] = 353.96, ["Mega|Fly|Ride"] = 509.99}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3590.9, ["Ride"] = 3863.16, ["Fly|Ride"] = 3022.69, ["Neon|Fly|Ride"] = 5946.91, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 115.5, ["Fly"] = 131.25, ["Ride"] = 138.06, ["Fly|Ride"] = 152.5, ["Neon"] = 548.03, ["Neon|Ride"] = 550.16, ["Neon|Fly|Ride"] = 514.5, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.5, ["Fly"] = 20.56, ["Ride"] = 16.96, ["Fly|Ride"] = 45.48, ["Neon"] = 23.63, ["Neon|Fly"] = 63.5, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 143.96, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 164.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.94, ["Ride"] = 27.83, ["Fly|Ride"] = 57.92, ["Neon"] = 23.99, ["Neon|Ride"] = 69.04, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 159.88, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 38.33, ["Fly"] = 152.5, ["Ride"] = 40.56, ["Fly|Ride"] = 51.97, ["Neon|Ride"] = 288.48, ["Neon|Fly|Ride"] = 303.94, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1056.57, ["Ride"] = 1768.85, ["Fly|Ride"] = 1233.75, ["Neon"] = 5150.53, ["Neon|Fly|Ride"] = 4945.14}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 7027.81, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.87, ["Fly"] = 45.2, ["Ride"] = 23.18, ["Fly|Ride"] = 43.29, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 185.36, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.42, ["Fly"] = 31.4, ["Ride"] = 32.22, ["Fly|Ride"] = 88.51, ["Neon"] = 93.19, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 642.48, ["Mega|Ride"] = 610.51, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.54, ["Fly"] = 157.49, ["Ride"] = 62.9, ["Fly|Ride"] = 111.57, ["Neon"] = 459.38, ["Neon|Ride"] = 342.06, ["Neon|Fly|Ride"] = 305.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 189.52, ["Ride"] = 234.94, ["Fly|Ride"] = 275.09, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10302.33, ["Mega|Fly|Ride"] = 3694.43}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.73, ["Ride"] = 34.13, ["Fly|Ride"] = 60.25, ["Neon"] = 23.18, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 132.57, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 298.78}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 209.63, ["Fly"] = 261.7, ["Ride"] = 245.22, ["Fly|Ride"] = 259.88, ["Neon"] = 890.03, ["Neon|Ride"] = 911.7, ["Neon|Fly|Ride"] = 947.63, ["Mega|Fly|Ride"] = 3570.8}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.94, ["Fly"] = 33.6, ["Ride"] = 17.07, ["Fly|Ride"] = 40.07, ["Neon"] = 23.87, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 31.63, ["Neon|Fly|Ride"] = 107.17, ["Mega"] = 256.03, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 254.69}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 203.44, ["Fly"] = 268.82, ["Ride"] = 223.13, ["Fly|Ride"] = 233.85, ["Neon|Fly|Ride"] = 1112.1, ["Mega"] = 10302.33, ["Mega|Ride"] = 4120.94, ["Mega|Fly|Ride"] = 4094.15}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 70.4, ["Ride"] = 26.79, ["Fly|Ride"] = 52.5, ["Neon"] = 62.68, ["Neon|Fly"] = 294.17, ["Neon|Ride"] = 97.89, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 618.15, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 23.18, ["Fly|Ride"] = 59.07, ["Neon"] = 11.21, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.27, ["Neon|Fly|Ride"] = 247.92, ["Mega"] = 74.36, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 255.29}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.84, ["Neon|Ride"] = 41.22, ["Mega"] = 27.83, ["Mega|Ride"] = 147.95}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.84, ["Fly"] = 52.48, ["Ride"] = 30.14, ["Fly|Ride"] = 214.28, ["Neon"] = 6.14, ["Neon|Ride"] = 39.21, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 57.66, ["Mega|Fly"] = 154458.39, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 159.96}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.25, ["Fly"] = 139.01, ["Ride"] = 114.76, ["Fly|Ride"] = 131.25, ["Neon"] = 264.57, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 367.74, ["Mega|Ride"] = 1318.71, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 98.3, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.99, ["Mega"] = 123.64, ["Mega|Ride"] = 123.36, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.82, ["Ride"] = 157.56, ["Neon"] = 71.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 541.92, ["Mega|Fly|Ride"] = 645.98}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.38, ["Neon|Ride"] = 45.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 19.39, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.22, ["Ride"] = 14.49, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 30.45, ["Mega"] = 13.13, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 20.63, ["Mega|Fly|Ride"] = 47.7}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.56, ["Ride"] = 12.71, ["Fly|Ride"] = 37.3, ["Neon"] = 2.1, ["Neon|Fly"] = 18.47, ["Neon|Ride"] = 15.46, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Fly"] = 155.25, ["Mega|Ride"] = 33.5, ["Mega|Fly|Ride"] = 95.62}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.6, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.43, ["Mega"] = 20.94, ["Mega|Ride"] = 117.03}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 107.63, ["Neon"] = 2.43, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 24.55, ["Mega|Fly"] = 89.64, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 205.03, ["Mega"] = 24.74, ["Mega|Ride"] = 772.69}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Ride"] = 20.11, ["Fly|Ride"] = 70.12, ["Neon"] = 6.57, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 87.84, ["Mega|Fly"] = 167.83, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.4, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 13.55, ["Mega|Ride"] = 37.21, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 138.06, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 11.46, ["Neon|Ride"] = 30.8, ["Mega"] = 105, ["Mega|Ride"] = 103.03, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 5.25, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 136.01, ["Mega"] = 20.37, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.36, ["Fly|Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly"] = 27.83, ["Neon|Ride"] = 12.93, ["Neon|Fly|Ride"] = 24.74, ["Mega"] = 14.44, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 33.15, ["Neon|Ride"] = 140.95, ["Mega"] = 261.7, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 18.38, ["Neon"] = 4.87, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.33, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 53.48, ["Mega|Fly|Ride"] = 123.64}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 10, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 82.51, ["Mega|Ride"] = 150.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.41, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.79, ["Neon|Fly"] = 103.02, ["Neon|Fly|Ride"] = 146.31, ["Mega"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.37, ["Ride"] = 15.46, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 15.37, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 26.78, ["Mega"] = 309.32, ["Mega|Fly"] = 31.29, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 43.32}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 135.99, ["Neon"] = 14.43, ["Neon|Ride"] = 111.22, ["Neon|Fly|Ride"] = 109.22, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.89, ["Ride"] = 21.11, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 48.4, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 236.25, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 12.99, ["Fly|Ride"] = 26.17, ["Neon"] = 3.68, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 45.04, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 42.46, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 172.07, ["Ride"] = 28.73, ["Neon"] = 5.25, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 68.06, ["Mega|Fly"] = 164.85, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 360.6}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.8, ["Fly|Ride"] = 82.42, ["Neon"] = 6.19, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 31.95, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 231.71}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.22, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.87, ["Mega"] = 16.63, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 115.86}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.87, ["Ride"] = 22.57, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 52.55, ["Neon|Ride"] = 20.6, ["Neon|Fly|Ride"] = 55.65, ["Mega"] = 77.35, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 199.87}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.61, ["Neon"] = 3.93, ["Neon|Ride"] = 43.32, ["Mega"] = 39.38, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 3.84, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 6.08, ["Ride"] = 68.01, ["Neon"] = 36.66, ["Mega"] = 128.27, ["Mega|Fly"] = 380.63, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 3.83, ["Ride"] = 16.99, ["Fly|Ride"] = 138.05, ["Neon"] = 30.81, ["Neon|Fly"] = 104.25, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 236.25, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 7.88, ["Fly"] = 22.68, ["Ride"] = 19.59, ["Fly|Ride"] = 39, ["Neon"] = 16.37, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.31, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 274.56, ["Mega|Fly"] = 411.08, ["Mega|Ride"] = 155.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.42, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.12, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 22.32, ["Ride"] = 131.25, ["Neon"] = 110.06, ["Neon|Ride"] = 231.71, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.68, ["Ride"] = 64.89, ["Neon"] = 38.76, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 214.31}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.3, ["Ride"] = 31.5, ["Fly|Ride"] = 120.75, ["Neon"] = 47.76, ["Neon|Ride"] = 156.19, ["Mega"] = 223.13, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Ride"] = 64.98, ["Mega"] = 22.16, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 148.36}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 46.7}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 7.67, ["Fly"] = 22.11, ["Ride"] = 20.63, ["Fly|Ride"] = 40.69, ["Neon"] = 34.04, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 100.8, ["Mega"] = 275.09, ["Mega|Fly"] = 329.69, ["Mega|Ride"] = 278.03, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Ride"] = 26.61, ["Neon|Fly|Ride"] = 69.04, ["Mega"] = 24.94, ["Mega|Fly"] = 138.06, ["Mega|Ride"] = 55.73, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.18, ["Fly|Ride"] = 275.09, ["Neon"] = 3.83, ["Neon|Ride"] = 33.65, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 38.66, ["Mega|Ride"] = 69.97, ["Mega|Fly|Ride"] = 185.29}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.94, ["Fly"] = 48.44, ["Ride"] = 15.67, ["Fly|Ride"] = 47.4, ["Neon"] = 6.08, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.51, ["Ride"] = 275.09, ["Fly|Ride"] = 58.73, ["Neon"] = 35.03, ["Neon|Ride"] = 82.27, ["Neon|Fly|Ride"] = 212.24, ["Mega"] = 328.13, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 15.11, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.63, ["Ride"] = 16.05, ["Fly|Ride"] = 274694.69, ["Neon"] = 6.55, ["Neon|Fly"] = 69.03, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 35.09, ["Mega|Ride"] = 47.93, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 14.44, ["Fly|Ride"] = 34.13, ["Neon"] = 5.16, ["Neon|Fly"] = 69.04, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 36.75, ["Mega|Fly"] = 138.06, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 201.57}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 51.19, ["Fly|Ride"] = 147.1, ["Neon"] = 3.92, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 158.45, ["Mega"] = 23.05, ["Mega|Fly"] = 103.03, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 4.04, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.62, ["Mega"] = 21, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 18.17, ["Fly|Ride"] = 77.27, ["Neon"] = 3.29, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 18.27, ["Mega|Fly"] = 61.83, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 2.1, ["Neon|Ride"] = 69.04, ["Mega"] = 23.63, ["Mega|Ride"] = 185.97}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 155.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 15.86, ["Fly|Ride"] = 49.87, ["Neon"] = 5.07, ["Neon|Fly"] = 55.64, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 136.48, ["Mega"] = 26.25, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 94.49}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.82, ["Ride"] = 139.01, ["Neon"] = 91.88, ["Mega"] = 315, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 51.92, ["Neon|Ride"] = 204.01, ["Mega"] = 1569.06, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.29, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 26.64, ["Mega"] = 295.25, ["Mega|Ride"] = 288.48, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.48, ["Ride"] = 15.46, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 26.8, ["Mega"] = 15.08, ["Mega|Fly"] = 32.99, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.23}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.7, ["Fly|Ride"] = 110.24, ["Neon"] = 3.94, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.95, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 85.31, ["Mega|Ride"] = 114.37, ["Mega|Fly|Ride"] = 155.58}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.92, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 54.51, ["Mega"] = 14.34, ["Mega|Fly"] = 83.16, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.52, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 103.03, ["Mega"] = 19.22, ["Mega|Ride"] = 102.01, ["Mega|Fly|Ride"] = 152.5}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 3.29, ["Fly"] = 34.08, ["Ride"] = 20.58, ["Fly|Ride"] = 45.94, ["Neon"] = 9.17, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 182.03, ["Mega"] = 208.85, ["Mega|Ride"] = 205.03, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 157.5, ["Ride"] = 212, ["Fly|Ride"] = 324.29, ["Neon"] = 1017.76, ["Neon|Ride"] = 822.94, ["Neon|Fly|Ride"] = 1010.67, ["Mega"] = 8241.87, ["Mega|Fly|Ride"] = 3398.85}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.5, ["Ride"] = 27.83, ["Neon"] = 15.44, ["Neon|Ride"] = 82.11, ["Mega"] = 68.09, ["Mega|Ride"] = 114.37, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.45, ["Fly"] = 63.03, ["Ride"] = 24.8, ["Neon"] = 26.8, ["Neon|Ride"] = 92.69, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 350.83, ["Mega|Ride"] = 514.11, ["Mega|Fly|Ride"] = 401.99}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 15.44, ["Fly|Ride"] = 30.19, ["Neon"] = 4.6, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 55.65, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 171.04}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 27.57, ["Fly|Ride"] = 92.55, ["Neon"] = 6.01, ["Neon|Fly"] = 550.09, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.47, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.83, ["Fly"] = 17.99, ["Ride"] = 15.68, ["Fly|Ride"] = 35.42, ["Neon"] = 24.86, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 73.29, ["Mega|Ride"] = 261.7, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.97, ["Fly"] = 41.22, ["Ride"] = 34.12, ["Fly|Ride"] = 275.05, ["Neon"] = 45.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 611.97, ["Mega"] = 337.03, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.56, ["Ride"] = 15.06, ["Fly|Ride"] = 37.31, ["Neon"] = 18.17, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 75.29, ["Mega|Ride"] = 241.08, ["Mega|Fly|Ride"] = 218.22}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 63.54, ["Fly"] = 168.97, ["Ride"] = 91.84, ["Fly|Ride"] = 152.38, ["Neon"] = 328.13, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1648.39}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 329.53, ["Ride"] = 204.01, ["Fly|Ride"] = 271.97, ["Neon"] = 1004.07, ["Neon|Ride"] = 1442.35, ["Neon|Fly|Ride"] = 1184.78, ["Mega"] = 10302.33, ["Mega|Fly|Ride"] = 3970.53}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 66.45, ["Fly"] = 100.93, ["Ride"] = 69.04, ["Fly|Ride"] = 126.42, ["Neon"] = 685.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1235.26, ["Mega|Fly|Ride"] = 1233.15}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.19, ["Fly"] = 26.25, ["Ride"] = 27.83, ["Fly|Ride"] = 49.88, ["Neon"] = 21.84, ["Neon|Ride"] = 69.18, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 158.82, ["Mega|Ride"] = 374.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.82, ["Fly"] = 68.97, ["Ride"] = 32.31, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 151.66, ["Neon|Fly|Ride"] = 247.27, ["Mega"] = 351.75, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 618.62}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.18, ["Fly|Ride"] = 44.49, ["Neon"] = 5.24, ["Neon|Fly"] = 74.59, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 82.43, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 125.7, ["Mega|Fly|Ride"] = 547.07}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.24, ["Fly"] = 27.83, ["Ride"] = 27.83, ["Fly|Ride"] = 293.86, ["Neon"] = 88.4, ["Neon|Fly"] = 344.08, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 1837.5, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.63, ["Fly"] = 41.22, ["Ride"] = 17.29, ["Fly|Ride"] = 53.28, ["Neon"] = 15.62, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.44, ["Neon|Fly|Ride"] = 95.6, ["Mega"] = 187.69, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.9, ["Ride"] = 23.18, ["Fly|Ride"] = 328.13, ["Neon"] = 28.62, ["Neon|Ride"] = 55.65, ["Mega|Ride"] = 192.67, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.46, ["Ride"] = 36.08, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.38, ["Mega"] = 14.42, ["Mega|Fly"] = 41.22, ["Mega|Ride"] = 41.22, ["Mega|Fly|Ride"] = 208517.77}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.94, ["Fly"] = 17.57, ["Ride"] = 18.05, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 103.02, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 84, ["Mega|Ride"] = 109.07, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.83, ["Fly"] = 24.93, ["Ride"] = 18.32, ["Fly|Ride"] = 42, ["Neon"] = 27.83, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.53, ["Mega"] = 283.5, ["Mega|Ride"] = 192.67, ["Mega|Fly|Ride"] = 221.27}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 128.77, ["Fly"] = 247.27, ["Ride"] = 189, ["Fly|Ride"] = 250.07, ["Neon"] = 824.11, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 723.13, ["Mega|Fly|Ride"] = 2745.6}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 11.82, ["Ride"] = 30.92, ["Fly|Ride"] = 205.01, ["Neon"] = 92.66, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 341.02, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.63, ["Fly"] = 15.75, ["Ride"] = 24.39, ["Fly|Ride"] = 43.32, ["Neon"] = 67.94, ["Neon|Ride"] = 27.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.25, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 166.22, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 459.39, ["Mega"] = 453.14, ["Mega|Fly"] = 824.2, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 686.15}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 24.61, ["Neon|Ride"] = 274.95, ["Neon|Fly|Ride"] = 618.15, ["Mega"] = 824.2, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 822.13}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 29.06, ["Fly"] = 35.49, ["Ride"] = 33.18, ["Fly|Ride"] = 58.47, ["Neon"] = 179.25, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 1786.43, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 6.09, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 33.79, ["Mega|Fly"] = 275.09, ["Mega|Ride"] = 80.37, ["Mega|Fly|Ride"] = 206.06}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.11, ["Fly"] = 27.79, ["Ride"] = 23.71, ["Fly|Ride"] = 61.82, ["Neon"] = 45.45, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 231.71, ["Mega"] = 231.48, ["Mega|Fly"] = 386.93, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 303.94}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.37, ["Fly"] = 32.82, ["Ride"] = 17.36, ["Fly|Ride"] = 45.65, ["Neon"] = 11.82, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 32.63, ["Fly|Ride"] = 206.04, ["Neon"] = 4.14, ["Neon|Ride"] = 30.92, ["Neon|Fly|Ride"] = 412.11, ["Mega"] = 31.24, ["Mega|Ride"] = 81.41, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.1, ["Ride"] = 82.25, ["Fly|Ride"] = 110.24, ["Neon"] = 253.41, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 962.26, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.29, ["Ride"] = 53.29, ["Fly|Ride"] = 210, ["Neon"] = 80.29, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 5.25, ["Fly"] = 96.87, ["Ride"] = 24.74, ["Fly|Ride"] = 93.19, ["Neon"] = 30.47, ["Neon|Fly"] = 315, ["Neon|Ride"] = 45.35, ["Neon|Fly|Ride"] = 98.91, ["Mega"] = 463.39, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.13, ["Ride"] = 179.17, ["Fly|Ride"] = 262.44, ["Neon"] = 550.09, ["Neon|Ride"] = 412.11, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.09, ["Fly"] = 45.94, ["Ride"] = 29.34, ["Fly|Ride"] = 62.54, ["Neon"] = 55.37, ["Neon|Ride"] = 66.45, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 322.88, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 263}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 145.69, ["Ride"] = 106.13, ["Fly|Ride"] = 178.36, ["Neon"] = 241.5, ["Neon|Fly"] = 525, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 1099.27, ["Mega|Ride"] = 1071.46, ["Mega|Fly|Ride"] = 906.39}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.05, ["Ride"] = 62.57, ["Fly|Ride"] = 131.24, ["Neon"] = 69.5, ["Neon|Ride"] = 123.97, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 344.11, ["Mega|Ride"] = 305.68, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.24, ["Ride"] = 18.56, ["Fly|Ride"] = 72.43, ["Neon"] = 105, ["Neon|Ride"] = 77.56, ["Neon|Fly|Ride"] = 247.92, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.38, ["Ride"] = 59.99, ["Fly|Ride"] = 156.33, ["Neon"] = 84.9, ["Neon|Ride"] = 110.69, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 255.21, ["Mega|Ride"] = 257.17, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.3, ["Ride"] = 41.1, ["Fly|Ride"] = 138.05, ["Neon"] = 44.62, ["Neon|Ride"] = 69.04, ["Mega"] = 329.69, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 55.65, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 89.64, ["Mega"] = 17.66, ["Mega|Ride"] = 103.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.14, ["Ride"] = 27.65, ["Neon"] = 19.3, ["Neon|Fly"] = 123.63, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.71, ["Mega|Ride"] = 189.57, ["Mega|Fly|Ride"] = 303.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.5, ["Fly"] = 62.57, ["Neon"] = 22.44, ["Mega"] = 196.23, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.94, ["Ride"] = 32.79, ["Fly|Ride"] = 115.82, ["Neon"] = 18.56, ["Neon|Ride"] = 81.41, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.87, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.36, ["Fly"] = 648.71, ["Ride"] = 594.98, ["Fly|Ride"] = 616.88, ["Neon"] = 1786.21, ["Neon|Ride"] = 1614.38, ["Neon|Fly|Ride"] = 1510.34, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.81, ["Fly"] = 27.83, ["Ride"] = 23.18, ["Fly|Ride"] = 62.57, ["Neon"] = 31.28, ["Neon|Ride"] = 94.8, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.25, ["Mega|Ride"] = 355.65, ["Mega|Fly|Ride"] = 481.92}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.45, ["Fly"] = 39.38, ["Ride"] = 23.67, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.17, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 308.05, ["Mega|Ride"] = 318.05, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.82, ["Fly"] = 96.87, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon"] = 15.46, ["Neon|Ride"] = 196.88, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 78.75, ["Neon"] = 7.69, ["Neon|Ride"] = 31.28, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 58.37, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 115.2, ["Mega|Fly|Ride"] = 152.15}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 19.69, ["Neon"] = 3.42, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 26.25, ["Mega|Fly"] = 192.67, ["Mega|Ride"] = 82.43, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.74}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.8, ["Ride"] = 27.82, ["Fly|Ride"] = 323.64, ["Neon"] = 65.63, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 398.71, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.85, ["Neon"] = 6.57, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.65, ["Mega|Ride"] = 154.54, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.7, ["Fly|Ride"] = 99.75, ["Neon"] = 11.11, ["Neon|Fly"] = 123.63, ["Neon|Ride"] = 138, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 183.73, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.92, ["Ride"] = 426.57, ["Fly|Ride"] = 551.25, ["Neon|Ride"] = 1364.98, ["Neon|Fly|Ride"] = 1280.37, ["Mega|Fly|Ride"] = 7693.17}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.56, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 412.06, ["Neon"] = 56.35, ["Neon|Ride"] = 69.93, ["Neon|Fly|Ride"] = 186.63, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 550.16}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Fly|Ride"] = 160.72, ["Neon"] = 6.57, ["Neon|Ride"] = 30.72, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 43.55, ["Mega|Fly"] = 189, ["Mega|Ride"] = 85.58, ["Mega|Fly|Ride"] = 257.57}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 27.46, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 146.28}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.01, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 77.63, ["Neon"] = 102.77, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 329.69, ["Mega"] = 448.33, ["Mega|Ride"] = 398.71, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.25, ["Neon"] = 108.88, ["Neon|Ride"] = 123.64, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 422.41, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.82, ["Fly|Ride"] = 411.03, ["Neon"] = 309.23, ["Neon|Ride"] = 155.25, ["Mega"] = 633.68, ["Mega|Ride"] = 756.2, ["Mega|Fly|Ride"] = 1236.06}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.55, ["Ride"] = 22.67, ["Neon"] = 118.13, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 524.99, ["Mega|Ride"] = 647.73, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 463.36, ["Ride"] = 432.72, ["Fly|Ride"] = 618.15, ["Neon"] = 1648.19, ["Neon|Ride"] = 1648.39, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3805.69}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.56, ["Fly"] = 69.65, ["Ride"] = 27.65, ["Fly|Ride"] = 131.25, ["Neon"] = 106.01, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 171.21, ["Mega"] = 687.19, ["Mega|Ride"] = 410.05, ["Mega|Fly|Ride"] = 850.99}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.92, ["Ride"] = 69.98, ["Neon"] = 35.04, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 772.69}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.74, ["Ride"] = 69.57, ["Fly|Ride"] = 255.95, ["Neon"] = 72.19, ["Neon|Ride"] = 129.68, ["Neon|Fly|Ride"] = 288.09, ["Mega"] = 272.34, ["Mega|Fly"] = 687.19, ["Mega|Ride"] = 288.3, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.3, ["Fly"] = 41.22, ["Ride"] = 42, ["Fly|Ride"] = 138.06, ["Neon"] = 6.35, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 205.03, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 206.04, ["Neon|Ride"] = 220.48, ["Neon|Fly|Ride"] = 656.84, ["Mega"] = 1786.43, ["Mega|Ride"] = 1331.07, ["Mega|Fly|Ride"] = 971.24}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.25, ["Neon"] = 9.19, ["Neon|Fly"] = 179.25, ["Neon|Ride"] = 63.89, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 71.91, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.52, ["Fly"] = 35.84, ["Ride"] = 30.19, ["Fly|Ride"] = 149.76, ["Neon"] = 5.8, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 39.62, ["Neon|Fly|Ride"] = 125.13, ["Mega"] = 39.37, ["Mega|Fly"] = 159.88, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.23, ["Fly"] = 91.88, ["Ride"] = 31.29, ["Fly|Ride"] = 122.78, ["Neon"] = 13.13, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.44, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 102.96, ["Fly"] = 92.69, ["Ride"] = 78.74, ["Fly|Ride"] = 193.47, ["Neon"] = 291.38, ["Neon|Ride"] = 288.51, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1030.24, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 275.09, ["Ride"] = 272.02, ["Fly|Ride"] = 413.44, ["Neon"] = 1431.86, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 6181.41, ["Mega|Fly|Ride"] = 4943.05}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.81, ["Neon"] = 28.93, ["Neon|Ride"] = 138.06, ["Mega"] = 96.73, ["Mega|Ride"] = 179.46, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 28.56, ["Fly|Ride"] = 155.19, ["Neon"] = 9.29, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 59.07, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 336.9}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.78, ["Fly"] = 30.14, ["Ride"] = 27.56, ["Fly|Ride"] = 175.13, ["Neon"] = 36.75, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 58.92, ["Ride"] = 36.08, ["Fly|Ride"] = 130.85, ["Neon"] = 7.76, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 84.36, ["Mega|Fly"] = 146.31, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.93, ["Neon"] = 9.32, ["Mega"] = 37.43, ["Mega|Fly|Ride"] = 172.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 5.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 97.89, ["Mega"] = 96.87, ["Mega|Ride"] = 93.77, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 138.06, ["Ride"] = 24.74, ["Fly|Ride"] = 55.05, ["Neon"] = 9.81, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39.14, ["Neon|Fly|Ride"] = 84, ["Mega"] = 92.73, ["Mega|Ride"] = 232.85, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 48.44, ["Ride"] = 42.61, ["Fly|Ride"] = 77.16, ["Neon"] = 192.64, ["Neon|Fly|Ride"] = 287.31, ["Mega"] = 575.92, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 514.11}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 63, ["Fly"] = 582.75, ["Ride"] = 81.23, ["Fly|Ride"] = 112.83, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 452.82, ["Neon|Fly|Ride"] = 548.09, ["Mega"] = 1470, ["Mega|Ride"] = 1646.33, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 39.16, ["Mega|Fly"] = 672, ["Mega|Ride"] = 64.93, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.47, ["Ride"] = 15.74, ["Fly|Ride"] = 39.36, ["Neon"] = 5.07, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 55.65, ["Mega"] = 61.01, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.25, ["Fly"] = 37.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 247.25, ["Neon|Ride"] = 46.35, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 527.63, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 387.19, ["Fly"] = 413.44, ["Ride"] = 550.16, ["Fly|Ride"] = 492.19, ["Neon"] = 4120.44, ["Neon|Ride"] = 1786.43, ["Mega|Fly|Ride"] = 7211.64}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 39.38, ["Fly"] = 95.81, ["Ride"] = 85.53, ["Fly|Ride"] = 109.2, ["Neon"] = 170.44, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 305.79, ["Mega|Ride"] = 1236.3, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 281.29, ["Neon"] = 7.74, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 123.38, ["Mega|Ride"] = 123.64, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.26, ["Fly"] = 205.82, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 23.71}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 25.51, ["Fly"] = 76.26, ["Ride"] = 43.26, ["Fly|Ride"] = 82.69, ["Neon|Ride"] = 297.94, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2472.58, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1236.06}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.74, ["Fly"] = 117.47, ["Ride"] = 92.73, ["Fly|Ride"] = 155.58, ["Neon"] = 430.1, ["Neon|Ride"] = 467.75, ["Neon|Fly|Ride"] = 475.98, ["Mega"] = 8241.87, ["Mega|Fly|Ride"] = 1877.09}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 228.38, ["Ride"] = 282.66, ["Fly|Ride"] = 514.11, ["Neon"] = 1236.14, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4376.44, ["Mega|Fly|Ride"] = 3570.8}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 12.06, ["Fly"] = 51.18, ["Ride"] = 55.67, ["Fly|Ride"] = 150.94, ["Neon"] = 75.95, ["Neon|Ride"] = 108.55, ["Neon|Fly|Ride"] = 316.31, ["Mega"] = 385.12, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.66, ["Ride"] = 18.26, ["Fly|Ride"] = 40.63, ["Neon"] = 7.88, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.74, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.4, ["Fly"] = 33.5, ["Ride"] = 20.46, ["Fly|Ride"] = 43.32, ["Neon"] = 32.71, ["Neon|Fly"] = 144.23, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 110.75, ["Mega"] = 377.08, ["Mega|Ride"] = 325.57, ["Mega|Fly|Ride"] = 307.02}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 481.14, ["Ride"] = 349.13, ["Fly|Ride"] = 412.11, ["Neon"] = 1443.75, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 5715.72}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.8, ["Neon"] = 9.29, ["Neon|Ride"] = 59.77, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 36.08, ["Mega|Ride"] = 253.45}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.7, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 49.86, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 179.27, ["Mega|Ride"] = 192.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.65, ["Ride"] = 98.44, ["Neon"] = 111.57, ["Neon|Fly"] = 412.11, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 433.28, ["Mega"] = 483.61, ["Mega|Ride"] = 547.07, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 110.25, ["Fly"] = 157.5, ["Ride"] = 110.25, ["Fly|Ride"] = 155.19, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 549.11, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.86, ["Fly"] = 43.29, ["Ride"] = 26.25, ["Fly|Ride"] = 54.44, ["Neon"] = 77.6, ["Neon|Ride"] = 103.68, ["Neon|Fly|Ride"] = 155.58, ["Mega"] = 632.59, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 509.55}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 25.5, ["Neon"] = 2.37, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 20.63, ["Mega|Ride"] = 274.05, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.16, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 3.84, ["Neon|Ride"] = 19.6, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 27.57, ["Mega|Fly"] = 61.18, ["Mega|Ride"] = 51.69, ["Mega|Fly|Ride"] = 113.51}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.45, ["Fly"] = 412.11, ["Ride"] = 76.04, ["Fly|Ride"] = 145.28, ["Neon"] = 34.04, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 80.22, ["Neon|Fly|Ride"] = 169.66, ["Mega"] = 151.45, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 324.19}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1260.92, ["Fly"] = 1529.06, ["Ride"] = 1207.5, ["Fly|Ride"] = 1296.75, ["Neon"] = 4557.07, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 486.93, ["Fly"] = 618.15, ["Ride"] = 480.38, ["Fly|Ride"] = 574.13, ["Neon"] = 1786.21, ["Neon|Ride"] = 1916.25, ["Neon|Fly|Ride"] = 2046.06, ["Mega"] = 16483.72, ["Mega|Fly|Ride"] = 6956.25}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 334.69, ["Fly"] = 406.96, ["Ride"] = 370.13, ["Fly|Ride"] = 439.69, ["Neon"] = 654.78, ["Neon|Fly"] = 1235.7, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 893.22, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 299.25, ["Fly"] = 412.11, ["Ride"] = 365.1, ["Fly|Ride"] = 411.08, ["Neon"] = 918.75, ["Neon|Fly"] = 1374.17, ["Neon|Ride"] = 1173.44, ["Neon|Fly|Ride"] = 1029, ["Mega|Fly|Ride"] = 4516.56}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.06, ["Fly|Ride"] = 38.06, ["Neon"] = 5.8, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.8, ["Mega|Ride"] = 112.86, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 367.5, ["Ride"] = 414.75, ["Fly|Ride"] = 547.32, ["Neon"] = 1680, ["Neon|Ride"] = 1322.28, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6593.5, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.29, ["Fly"] = 183.75, ["Ride"] = 18.38, ["Neon"] = 9.19, ["Neon|Ride"] = 65.96, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 78.75, ["Mega|Ride"] = 181.54, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.83, ["Ride"] = 18.56, ["Fly|Ride"] = 38.98, ["Neon"] = 7.88, ["Neon|Ride"] = 52.56, ["Neon|Fly|Ride"] = 108.21, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 69.53, ["Mega"] = 23.63, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.08, ["Ride"] = 109.22, ["Fly|Ride"] = 459.38, ["Neon"] = 192.64, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7722.83, ["Ride"] = 21.63, ["Fly|Ride"] = 60.44, ["Neon"] = 26.1, ["Neon|Ride"] = 77.63, ["Mega"] = 328.13, ["Mega|Ride"] = 309.08, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.83, ["Neon|Fly"] = 118.1, ["Neon|Ride"] = 37.22, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 21, ["Mega|Fly"] = 103.03, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 118.36}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 22.65, ["Fly|Ride"] = 64.87, ["Neon"] = 14.31, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.27, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 98.44, ["Mega|Fly"] = 172.07, ["Mega|Ride"] = 117.75, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.42, ["Fly"] = 91.77, ["Ride"] = 27.82, ["Fly|Ride"] = 51.45, ["Neon"] = 19.69, ["Neon|Fly"] = 110.24, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 246.11, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.32}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.75, ["Fly"] = 190.32, ["Ride"] = 60.74, ["Neon"] = 44.62, ["Neon|Fly|Ride"] = 262.98, ["Mega"] = 288.48, ["Mega|Ride"] = 771.66, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 8.59, ["Fly"] = 6178.73, ["Ride"] = 26.62, ["Neon"] = 36.02, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 4.14, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.63, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 138.06, ["Fly"] = 227.7, ["Ride"] = 227.7, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 2575.59, ["Neon|Fly|Ride"] = 1081.99, ["Mega"] = 8241.87, ["Mega|Fly|Ride"] = 4170.37}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.22, ["Ride"] = 15.45, ["Fly|Ride"] = 35.06, ["Neon"] = 5.25, ["Neon|Fly"] = 27.83, ["Neon|Ride"] = 22.68, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 40.69, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 14.44, ["Fly"] = 138.06, ["Ride"] = 69.46, ["Fly|Ride"] = 183.74, ["Neon"] = 83.4, ["Neon|Ride"] = 123.38, ["Mega"] = 360.94, ["Mega|Ride"] = 398.71, ["Mega|Fly|Ride"] = 547.07}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 36.75, ["Ride"] = 45.94, ["Fly|Ride"] = 167.23, ["Neon"] = 233.85, ["Neon|Ride"] = 275.09, ["Mega"] = 786.19}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.1, ["Ride"] = 216.57, ["Fly|Ride"] = 321.13, ["Neon"] = 708.73, ["Neon|Fly"] = 1158.1, ["Neon|Ride"] = 896.64, ["Neon|Fly|Ride"] = 842.63, ["Mega|Fly|Ride"] = 3362.77}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.34, ["Fly"] = 168.88, ["Ride"] = 37.43, ["Fly|Ride"] = 139.01, ["Neon"] = 123.38, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1236.3}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 11.51, ["Ride"] = 138.06, ["Fly|Ride"] = 525, ["Neon"] = 96.85, ["Neon|Fly"] = 155.19, ["Neon|Ride"] = 199.5, ["Mega"] = 275.09, ["Mega|Ride"] = 1648.39, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 984.38, ["Ride"] = 1081.5, ["Fly|Ride"] = 1149.75, ["Neon"] = 4632.34, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4524.16, ["Mega"] = 18544.19, ["Mega|Fly|Ride"] = 17170.89}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.57, ["Fly"] = 30.14, ["Ride"] = 19.56, ["Fly|Ride"] = 90.35, ["Neon"] = 26.64, ["Neon|Fly"] = 83.21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 271.09, ["Mega|Ride"] = 233.88, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.94, ["Fly"] = 13599.08, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 30.24, ["Neon|Ride"] = 91.52, ["Mega"] = 206.06, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 398.71}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.41, ["Ride"] = 22.09, ["Fly|Ride"] = 69.57, ["Neon"] = 12.8, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 37.08, ["Mega"] = 95.82, ["Mega|Ride"] = 136.9, ["Mega|Fly|Ride"] = 686.21}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.13, ["Ride"] = 39.12, ["Fly|Ride"] = 81.38, ["Neon"] = 66.94, ["Neon|Ride"] = 91.82, ["Neon|Fly|Ride"] = 173.72, ["Mega"] = 342.57, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.56, ["Fly"] = 20.63, ["Ride"] = 18.47, ["Fly|Ride"] = 41.01, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 92.57, ["Mega"] = 139.02, ["Mega|Ride"] = 158.67, ["Mega|Fly|Ride"] = 262.98}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.82, ["Ride"] = 36.08, ["Neon"] = 11.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 111.57, ["Mega|Fly"] = 275.09, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 327.63}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 387.39, ["Ride"] = 328.13, ["Fly|Ride"] = 391.46, ["Neon|Fly|Ride"] = 1343.81}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.62, ["Fly"] = 25.47, ["Ride"] = 19.37, ["Fly|Ride"] = 72.19, ["Neon"] = 9.98, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 78.75, ["Mega|Fly"] = 412.11, ["Mega|Ride"] = 110.04, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.25, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 77.43, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 138.06, ["Mega|Ride"] = 370.9}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 9.19, ["Fly"] = 92.17, ["Ride"] = 26.17, ["Neon"] = 15.32, ["Neon|Ride"] = 1374.35, ["Mega"] = 83.99, ["Mega|Fly"] = 138.06, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 363.77}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 216.57, ["Ride"] = 315, ["Fly|Ride"] = 412.11, ["Neon"] = 921.96, ["Neon|Fly"] = 962.13, ["Neon|Ride"] = 816.38, ["Mega"] = 3090.71, ["Mega|Ride"] = 4945.14, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.98, ["Fly"] = 60.74, ["Ride"] = 68.01, ["Fly|Ride"] = 158.65, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 1232.18}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 37.79, ["Fly|Ride"] = 89.25, ["Neon"] = 77.49, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 491.07, ["Mega|Ride"] = 508.44, ["Mega|Fly|Ride"] = 564.73}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.43, ["Neon"] = 3.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.6}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.24, ["Fly"] = 106.09, ["Ride"] = 89.52, ["Fly|Ride"] = 178.8, ["Neon"] = 262.48, ["Neon|Fly"] = 411.74, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.16, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 122.62, ["Mega"] = 50.76, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.88, ["Fly"] = 52.5, ["Ride"] = 34.13, ["Fly|Ride"] = 75.78, ["Neon"] = 59.07, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 247.27, ["Mega"] = 275.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 381.21}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.87, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 137.31, ["Neon"] = 244.97, ["Neon|Ride"] = 303.7, ["Neon|Fly|Ride"] = 377.91, ["Mega|Ride"] = 3435.85, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.12, ["Fly|Ride"] = 25.47, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 40.62, ["Mega"] = 15.75, ["Mega|Fly"] = 115.86, ["Mega|Ride"] = 31.29, ["Mega|Fly|Ride"] = 92.69}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 5.25, ["Fly"] = 32.81, ["Ride"] = 44.01, ["Fly|Ride"] = 131.25, ["Neon"] = 14.32, ["Neon|Ride"] = 59.77, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 129.94, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.99, ["Ride"] = 65.96, ["Fly|Ride"] = 90.35, ["Neon"] = 77.6, ["Neon|Ride"] = 123.97, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 823.17}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 133.94, ["Mega"] = 22.16, ["Mega|Ride"] = 137.04}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.34, ["Fly"] = 210, ["Ride"] = 57.9, ["Fly|Ride"] = 99.74, ["Neon"] = 89.32, ["Neon|Ride"] = 109.22, ["Neon|Fly|Ride"] = 344.11, ["Mega"] = 556.06, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.02, ["Fly"] = 67.96, ["Ride"] = 26.25, ["Fly|Ride"] = 45.94, ["Neon"] = 224.58, ["Neon|Ride"] = 118.78, ["Mega"] = 432.72, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 8.14, ["Ride"] = 49.47, ["Neon"] = 26.16, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 210, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 398.71}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.01, ["Fly"] = 2060.47, ["Ride"] = 85.32, ["Fly|Ride"] = 196.83, ["Neon"] = 52.5, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 6177.93, ["Mega"] = 274.96, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 41.22, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 6.49, ["Neon|Fly"] = 55.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 103.03, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.47, ["Neon"] = 3.94, ["Neon|Ride"] = 89.17, ["Mega"] = 29.49, ["Mega|Ride"] = 82.43, ["Mega|Fly|Ride"] = 209.61}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.19}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.59, ["Fly"] = 78.75, ["Ride"] = 46.35, ["Fly|Ride"] = 206.04, ["Neon"] = 1050, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1228.05, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.42, ["Mega"] = 23.07, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 309.08}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 562.52, ["Ride"] = 446.25, ["Fly|Ride"] = 550.16, ["Neon"] = 3018.75, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16483.72, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.24, ["Fly"] = 25.91, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.91, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 78.47, ["Mega|Fly"] = 148.36, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 550.16}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 95.55, ["Ride"] = 19.69, ["Fly|Ride"] = 64.2, ["Neon"] = 16.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 161.44, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Fly"] = 77.27, ["Ride"] = 69.51, ["Fly|Ride"] = 106.32, ["Neon"] = 78.66, ["Neon|Ride"] = 178.42, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 795.36, ["Mega|Ride"] = 522.34, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.49, ["Fly"] = 316.31, ["Ride"] = 32.48, ["Fly|Ride"] = 687.19, ["Mega"] = 255.94, ["Mega|Ride"] = 231.71}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.47, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 107.17, ["Neon|Fly|Ride"] = 364.72, ["Mega"] = 347.28, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 489.38}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.46, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 46.6, ["Neon|Ride"] = 101.75, ["Neon|Fly|Ride"] = 136.01, ["Mega"] = 202.13, ["Mega|Fly"] = 550.16, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 316.75}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.32, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.46, ["Neon|Fly|Ride"] = 122.96, ["Mega"] = 14.11, ["Mega|Ride"] = 35.4, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.81, ["Fly"] = 275.09, ["Ride"] = 27.83, ["Fly|Ride"] = 48.44, ["Neon"] = 28.65, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 88.61, ["Neon|Fly|Ride"] = 133.94, ["Mega"] = 195.57, ["Mega|Ride"] = 206.06, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 295.21, ["Fly"] = 405.44, ["Ride"] = 331.88, ["Fly|Ride"] = 421.32, ["Neon"] = 1450.4, ["Neon|Ride"] = 1215.68, ["Neon|Fly|Ride"] = 1236.3, ["Mega|Fly|Ride"] = 4217.78}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.32, ["Ride"] = 172.07, ["Fly|Ride"] = 215.25, ["Neon"] = 308.44, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 491.32, ["Mega"] = 4120.94, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1699.43}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 27.08, ["Neon"] = 16.49, ["Neon|Fly"] = 30.92, ["Neon|Ride"] = 30.92, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 152.5, ["Mega|Fly"] = 205.03, ["Mega|Ride"] = 123.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.02, ["Ride"] = 13.85, ["Fly|Ride"] = 31.49, ["Neon"] = 6.13, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 59.11, ["Mega"] = 70.07, ["Mega|Fly"] = 344.02, ["Mega|Ride"] = 101.52, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 138.06, ["Mega|Ride"] = 329.69, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 260.38, ["Fly"] = 420, ["Ride"] = 311.85, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1137.6, ["Neon|Fly|Ride"] = 1387.74, ["Mega|Ride"] = 8241.87, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.83, ["Fly"] = 23.18, ["Ride"] = 16.7, ["Fly|Ride"] = 39.38, ["Neon"] = 17.38, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 40.22, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 196.88, ["Mega|Ride"] = 309.32, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.57, ["Fly"] = 155.24, ["Ride"] = 82.11, ["Fly|Ride"] = 206.06, ["Neon"] = 13.13, ["Neon|Ride"] = 126.62, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 252, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.33, ["Fly"] = 43.29, ["Ride"] = 27.57, ["Fly|Ride"] = 57.29, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 172.07, ["Mega"] = 728.44, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 39.38, ["Fly"] = 155.24, ["Ride"] = 92.69, ["Fly|Ride"] = 196.88, ["Neon"] = 104.99, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 212.83, ["Neon|Fly|Ride"] = 379.32, ["Mega"] = 452.82, ["Mega|Fly"] = 2163.5, ["Mega|Ride"] = 506.89, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.84, ["Ride"] = 46.3, ["Fly|Ride"] = 104.52, ["Neon"] = 164.83, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega|Ride"] = 769.6, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 14.89, ["Fly|Ride"] = 32.97, ["Neon"] = 2.1, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 20.04, ["Mega|Ride"] = 47.4, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 256.09, ["Ride"] = 275.09, ["Fly|Ride"] = 295.32, ["Neon"] = 3242.65, ["Neon|Ride"] = 962.26, ["Neon|Fly|Ride"] = 1321.69}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.57, ["Fly"] = 101.18, ["Ride"] = 69.04, ["Fly|Ride"] = 105, ["Neon"] = 123.63, ["Neon|Ride"] = 154.97, ["Neon|Fly|Ride"] = 69.04, ["Mega"] = 412.11, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.69, ["Ride"] = 15.59, ["Fly|Ride"] = 44.31, ["Neon"] = 10.48, ["Neon|Fly"] = 39.4, ["Neon|Ride"] = 26.77, ["Neon|Fly|Ride"] = 109.22, ["Mega"] = 59.09, ["Mega|Fly"] = 275.09, ["Mega|Ride"] = 54.69, ["Mega|Fly|Ride"] = 139.02}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.92, ["Ride"] = 19.6, ["Fly|Ride"] = 35.44, ["Neon"] = 3.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.8, ["Mega"] = 20.63, ["Mega|Fly"] = 138.06, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 155.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 12.21, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 6866.86, ["Mega"] = 126.42, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.11, ["Fly"] = 38.74, ["Ride"] = 26.25, ["Fly|Ride"] = 70.5, ["Neon"] = 50.75, ["Neon|Fly"] = 82.42, ["Neon|Ride"] = 64.93, ["Neon|Fly|Ride"] = 117.47, ["Mega"] = 336.48, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.65, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 52.5, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 216.57, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 370.71}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Neon"] = 3.68, ["Neon|Ride"] = 37.1, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 17.75, ["Mega|Ride"] = 66.61, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.18, ["Fly"] = 96.87, ["Ride"] = 28.88, ["Fly|Ride"] = 118.13, ["Neon"] = 36.22, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 134.97, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 295.7}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 111.99, ["Neon"] = 3.46, ["Neon|Fly"] = 110.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 23.96, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 17.38, ["Fly|Ride"] = 40.74, ["Neon"] = 6.57, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 49.88, ["Mega|Ride"] = 80.37, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 703.5, ["Ride"] = 756, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3231.55, ["Mega"] = 12637.88, ["Mega|Fly|Ride"] = 12745.02}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.68, ["Fly|Ride"] = 34.13, ["Neon"] = 46.34, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 184.43, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.52, ["Ride"] = 36.75, ["Fly|Ride"] = 81.26, ["Neon"] = 9.19, ["Neon|Ride"] = 87.65, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 65.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 123.48, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.56, ["Fly"] = 40.6, ["Ride"] = 27.83, ["Fly|Ride"] = 45.94, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 38.57, ["Neon|Fly|Ride"] = 112.06, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 15.44, ["Fly|Ride"] = 31.62, ["Neon"] = 9.09, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 47.46, ["Mega"] = 55.65, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 138.06}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.07, ["Ride"] = 83.99, ["Fly|Ride"] = 206.06, ["Neon"] = 328.84, ["Neon|Ride"] = 257.44, ["Mega"] = 893.82, ["Mega|Fly|Ride"] = 1153.87}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 138.06, ["Ride"] = 18.57, ["Fly|Ride"] = 63.74, ["Neon"] = 5.25, ["Neon|Fly"] = 132.04, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 59.85, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.77, ["Fly"] = 69.04, ["Ride"] = 22.97, ["Fly|Ride"] = 60.8, ["Neon"] = 41.22, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 236.25, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.44, ["Mega"] = 93.5, ["Mega|Fly"] = 275.09, ["Mega|Ride"] = 171.46, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 63.67, ["Ride"] = 16.48, ["Fly|Ride"] = 49.83, ["Neon"] = 5.25, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 17.39, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 44.62, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 56.31}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.61, ["Fly"] = 23.63, ["Ride"] = 18.55, ["Fly|Ride"] = 39.37, ["Neon"] = 138.05, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 824.2, ["Mega|Fly|Ride"] = 456.78}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 735, ["Ride"] = 780.94, ["Fly|Ride"] = 893.22, ["Neon"] = 1706.25, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 8239.81, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7476.54}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.27, ["Fly|Ride"] = 39.69, ["Neon"] = 3.71, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 63.89, ["Mega"] = 52.5, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.45, ["Ride"] = 27.57, ["Fly|Ride"] = 77.6, ["Neon"] = 45.93, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 292.9, ["Mega|Ride"] = 315}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.65, ["Ride"] = 76.67, ["Fly|Ride"] = 123.27, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 412.11, ["Mega"] = 3159.74, ["Mega|Fly|Ride"] = 1289.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.83, ["Fly"] = 123.96, ["Ride"] = 35.96, ["Fly|Ride"] = 102.79, ["Neon"] = 104.99, ["Neon|Ride"] = 138.06, ["Mega"] = 764.45, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 810.81}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.13, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 137.73, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 421.68, ["Mega|Ride"] = 486.28, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.79, ["Ride"] = 76.26, ["Neon"] = 107.62, ["Neon|Ride"] = 136.01, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 244.52, ["Mega|Fly"] = 502.78, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.6, ["Fly"] = 126.89, ["Ride"] = 314.99, ["Neon"] = 247.85, ["Neon|Ride"] = 303.94, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 618.62, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.57}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.36, ["Fly"] = 131248.69, ["Ride"] = 27.83, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 214.33, ["Neon|Fly|Ride"] = 205.92, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 220.48, ["Mega|Fly|Ride"] = 309.32}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.51, ["Ride"] = 131.25, ["Neon"] = 14.44, ["Mega"] = 865.36, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 43.32, ["Fly"] = 411.8, ["Ride"] = 54.51, ["Fly|Ride"] = 108.88, ["Neon"] = 618.43, ["Neon|Ride"] = 267.75, ["Neon|Fly|Ride"] = 245.97, ["Mega|Ride"] = 865.41, ["Mega|Fly|Ride"] = 848.92}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.78, ["Fly"] = 18.37, ["Ride"] = 17.37, ["Fly|Ride"] = 41.22, ["Neon"] = 23.63, ["Neon|Fly"] = 47.4, ["Neon|Ride"] = 35.13, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 275.09, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.25, ["Fly"] = 82.43, ["Ride"] = 35.04, ["Fly|Ride"] = 105, ["Neon"] = 25.85, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 102.65, ["Mega|Ride"] = 172.2, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.62, ["Neon|Ride"] = 45.94, ["Mega"] = 41.58, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.24, ["Fly"] = 58.7, ["Ride"] = 54.55, ["Fly|Ride"] = 120.75, ["Neon"] = 152.25, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 1099.27, ["Mega|Ride"] = 780.93, ["Mega|Fly|Ride"] = 795.38}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.83, ["Fly|Ride"] = 65.63, ["Neon"] = 8.26, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.06, ["Mega"] = 105, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.29, ["Ride"] = 52.5, ["Fly|Ride"] = 272, ["Neon"] = 82.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.96, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 638.76}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 15.74, ["Fly|Ride"] = 36.2, ["Neon"] = 90.55, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.62, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 62.25, ["Neon"] = 77.6, ["Neon|Ride"] = 410.93, ["Mega"] = 378.11, ["Mega|Ride"] = 389.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.34, ["Neon|Ride"] = 139.02, ["Mega"] = 364.58, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.26, ["Ride"] = 105, ["Fly|Ride"] = 206.06, ["Neon"] = 196.88, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 436.84, ["Mega|Ride"] = 1099.27, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.64, ["Ride"] = 119.01, ["Neon"] = 123.63, ["Neon|Ride"] = 179.27, ["Mega"] = 412.11, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Neon"] = 48.45, ["Neon|Ride"] = 91.88, ["Mega"] = 309.08, ["Mega|Ride"] = 975.64, ["Mega|Fly|Ride"] = 1648.39}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 19.68, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 26.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 824.2, ["Mega|Ride"] = 618.74}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.56, ["Neon"] = 26.76, ["Neon|Ride"] = 275.09, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 309.32}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.68, ["Fly|Ride"] = 38.19, ["Neon"] = 3.86, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 61.83, ["Mega|Ride"] = 93.18, ["Mega|Fly|Ride"] = 171.53}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 5.25, ["Fly"] = 50.19, ["Ride"] = 28.88, ["Fly|Ride"] = 77.88, ["Neon"] = 14.05, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 96.74, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 20.63, ["Fly|Ride"] = 55.95, ["Neon"] = 5.31, ["Neon|Fly"] = 31.28, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 46.93, ["Mega|Ride"] = 74.19, ["Mega|Fly|Ride"] = 138.06}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 69.04, ["Neon"] = 17.39, ["Neon|Ride"] = 97.89, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 241.4, ["Mega|Ride"] = 170.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.42, ["Fly"] = 65.63, ["Ride"] = 30.92, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 463.24, ["Neon|Ride"] = 69.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 303.94, ["Mega|Fly|Ride"] = 1030.24}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 55.64, ["Neon"] = 26.25, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 37.08, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 138.06, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 17.97, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.42, ["Neon|Ride"] = 46.35, ["Neon|Fly|Ride"] = 103.03, ["Mega"] = 168, ["Mega|Ride"] = 227.7}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.34, ["Fly"] = 57.75, ["Ride"] = 42.67, ["Fly|Ride"] = 179.51, ["Neon"] = 19.42, ["Neon|Fly"] = 123.36, ["Neon|Ride"] = 82.43, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 106.31, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 412.11}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.43, ["Fly"] = 138.06, ["Ride"] = 110.25, ["Fly|Ride"] = 305.74, ["Neon"] = 94.5, ["Neon|Fly"] = 206.04, ["Neon|Ride"] = 179.27, ["Neon|Fly|Ride"] = 463.39, ["Mega"] = 480.38, ["Mega|Fly"] = 687.19, ["Mega|Ride"] = 501.6, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.79, ["Ride"] = 103.03, ["Fly|Ride"] = 136.5, ["Neon"] = 283.04, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 918.75, ["Mega|Ride"] = 1085.88, ["Mega|Fly|Ride"] = 1116.26}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 18.37, ["Fly|Ride"] = 51.52, ["Neon"] = 3.82, ["Neon|Ride"] = 38.45, ["Mega"] = 30.14, ["Mega|Ride"] = 68.51, ["Mega|Fly|Ride"] = 165.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 31.29, ["Neon"] = 96.85, ["Mega|Fly|Ride"] = 1236.3}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.74, ["Fly"] = 105, ["Ride"] = 59.07, ["Neon"] = 304.5, ["Neon|Ride"] = 275.09, ["Mega|Ride"] = 1099.27, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.93, ["Fly"] = 190.32, ["Ride"] = 31.4, ["Fly|Ride"] = 126, ["Neon"] = 49.87, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 192.93, ["Mega|Ride"] = 221.81, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.04, ["Ride"] = 82.43, ["Fly|Ride"] = 137.69, ["Neon"] = 8.61, ["Neon|Ride"] = 40.69, ["Mega"] = 61.74, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 91.68, ["Mega|Fly|Ride"] = 241.08}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 11.82, ["Neon|Ride"] = 35.04, ["Neon|Fly|Ride"] = 112.77, ["Mega"] = 164.07, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 15.44, ["Fly|Ride"] = 27.56, ["Neon"] = 2.62, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 57.7, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 74.27, ["Neon"] = 4.65, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 40.05, ["Mega|Fly"] = 168, ["Mega|Ride"] = 68.77, ["Mega|Fly|Ride"] = 150.43}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.19, ["Neon"] = 2.63, ["Neon|Ride"] = 137.96, ["Mega"] = 21.8, ["Mega|Ride"] = 550.16, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 10.12, ["Ride"] = 44.31, ["Neon"] = 30.09, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 618.15, ["Mega"] = 155.25, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 252.76}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.76, ["Ride"] = 26.79, ["Fly|Ride"] = 189.94, ["Neon"] = 55.64, ["Neon|Ride"] = 103.03, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 412.11, ["Mega|Ride"] = 329.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.71, ["Fly"] = 20.87, ["Ride"] = 18.55, ["Fly|Ride"] = 32.82, ["Neon"] = 29.01, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 43.57, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 452.82, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 81.1, ["Ride"] = 262.73, ["Fly|Ride"] = 262.5, ["Neon"] = 275.05, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.55, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 138.05, ["Neon"] = 115.49, ["Neon|Fly|Ride"] = 630, ["Mega"] = 878.1, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.45, ["Fly|Ride"] = 39.16, ["Neon"] = 3.93, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 32.16, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.5, ["Ride"] = 15.74, ["Fly|Ride"] = 30.91, ["Neon"] = 3.94, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 44.63, ["Mega|Fly"] = 82.43, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 85.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 498.75, ["Fly"] = 573.4, ["Ride"] = 516, ["Fly|Ride"] = 524.11, ["Neon|Fly|Ride"] = 1510.34}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.4, ["Ride"] = 90.19, ["Neon"] = 210, ["Neon|Ride"] = 96.87, ["Mega"] = 401.99, ["Mega|Ride"] = 660.32, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.44, ["Ride"] = 14.44, ["Fly|Ride"] = 35.93, ["Neon"] = 2.63, ["Neon|Fly"] = 26.8, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 43.32, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 59.76, ["Ride"] = 124.69, ["Fly|Ride"] = 150.94, ["Neon"] = 255.29, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 509.73, ["Mega"] = 859.07, ["Mega|Ride"] = 824.2, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 68.96, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 13.13, ["Neon|Fly"] = 41.49, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 72.51, ["Mega"] = 84.96, ["Mega|Fly"] = 206.06, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 188.68}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 39.4, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.93, ["Neon|Ride"] = 35.42, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 27.6, ["Mega|Fly"] = 269.94, ["Mega|Ride"] = 84.5, ["Mega|Fly|Ride"] = 185.36}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.37, ["Fly"] = 143.22, ["Ride"] = 92.22, ["Fly|Ride"] = 206.06, ["Neon"] = 186.38, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 4.38, ["Neon|Ride"] = 39.99, ["Mega"] = 41.18, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.8, ["Ride"] = 96.78, ["Fly|Ride"] = 138.05, ["Neon"] = 308.02, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1627.78, ["Mega|Ride"] = 1648.39, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.65, ["Fly|Ride"] = 156.59, ["Neon"] = 21.76, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 481.14, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 69.04, ["Ride"] = 26.25, ["Fly|Ride"] = 65.96, ["Neon"] = 10.28, ["Neon|Ride"] = 51.52, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 119.53, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.3, ["Ride"] = 94.8, ["Fly|Ride"] = 393.75, ["Neon"] = 275.63, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 2058.42, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1165.21}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 239.79, ["Ride"] = 28.88, ["Fly|Ride"] = 908.98, ["Neon"] = 7.25, ["Neon|Ride"] = 37.1, ["Neon|Fly|Ride"] = 151.77, ["Mega"] = 48.44, ["Mega|Fly"] = 249.61, ["Mega|Ride"] = 99.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.38, ["Fly|Ride"] = 102.88, ["Neon"] = 40.69, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 23.71, ["Neon|Fly|Ride"] = 59.07, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.42, ["Fly"] = 45.35, ["Ride"] = 26.25, ["Fly|Ride"] = 77.6, ["Neon"] = 77.27, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 147.13, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 23.18, ["Ride"] = 29.39, ["Fly|Ride"] = 64.7, ["Neon"] = 138.05, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1058.07, ["Mega|Ride"] = 1854.43, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.23, ["Fly"] = 51.18, ["Ride"] = 27.82, ["Fly|Ride"] = 74.11, ["Neon"] = 81.38, ["Neon|Ride"] = 108.91, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.03, ["Fly"] = 82.43, ["Ride"] = 118.49, ["Fly|Ride"] = 241.74, ["Neon"] = 294, ["Neon|Ride"] = 447.14, ["Neon|Fly|Ride"] = 550.16, ["Mega|Ride"] = 1362.88, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.94, ["Ride"] = 44.05, ["Fly|Ride"] = 386.82, ["Neon"] = 24.94, ["Neon|Ride"] = 103.03, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 307.02}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.67, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 73.16, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 171.04, ["Mega|Ride"] = 185.36, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.74, ["Fly"] = 52.5, ["Ride"] = 40.2, ["Fly|Ride"] = 96.85, ["Neon"] = 46.25, ["Neon|Ride"] = 392.43, ["Neon|Fly|Ride"] = 92.69, ["Mega"] = 430.5, ["Mega|Ride"] = 313.21, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.12, ["Fly|Ride"] = 31.95, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.35, ["Mega"] = 15.75, ["Mega|Ride"] = 23.5, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 61.47, ["Fly"] = 138.06, ["Ride"] = 91.88, ["Fly|Ride"] = 296.48, ["Neon"] = 150.94, ["Neon|Fly"] = 2335.27, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1390.13, ["Mega|Ride"] = 1495.91, ["Mega|Fly|Ride"] = 967.4}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.85, ["Neon"] = 6.02, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 69.04, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.83, ["Ride"] = 15.27, ["Fly|Ride"] = 45.93, ["Neon"] = 22.32, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 30.8, ["Neon|Fly|Ride"] = 94.75, ["Mega"] = 261.7, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.68, ["Ride"] = 123.43, ["Fly|Ride"] = 222.6, ["Neon"] = 275.05, ["Neon|Ride"] = 333.64, ["Neon|Fly|Ride"] = 604.76, ["Mega"] = 1233.75, ["Mega|Ride"] = 1297.46, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.68, ["Neon"] = 7.75, ["Neon|Ride"] = 63.67, ["Mega"] = 63.65, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 20.51}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 26.25, ["Fly|Ride"] = 57.71, ["Neon"] = 4.66, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 201.57, ["Mega"] = 48, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 103.69, ["Ride"] = 200.91, ["Fly|Ride"] = 138.06, ["Neon"] = 472.5, ["Neon|Ride"] = 680.02, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 3552.92, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 2831.09}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 37.08, ["Neon"] = 39.25, ["Neon|Ride"] = 54.11, ["Mega"] = 159.93, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.94, ["Ride"] = 22.02, ["Neon"] = 32.82, ["Neon|Ride"] = 108.8, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.49, ["Fly"] = 25.2, ["Ride"] = 20.86, ["Fly|Ride"] = 54.32, ["Neon"] = 81.04, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 550.16, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 467.75}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 28.62, ["Ride"] = 70.79, ["Fly|Ride"] = 122.78, ["Neon"] = 143.38, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 618.62, ["Mega|Ride"] = 544.43, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 157.5, ["Fly"] = 183.74, ["Ride"] = 188.99, ["Fly|Ride"] = 206.06, ["Neon"] = 590.66, ["Neon|Fly"] = 656.64, ["Neon|Ride"] = 577.48, ["Neon|Fly|Ride"] = 597.43, ["Mega|Fly|Ride"] = 2414.99}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 18.38, ["Fly"] = 37.69, ["Ride"] = 26.14, ["Fly|Ride"] = 49.26, ["Neon"] = 133.47, ["Neon|Fly"] = 6177.22, ["Neon|Ride"] = 130.86, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 679.96, ["Mega|Fly|Ride"] = 641.3}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 4.09, ["Fly"] = 118.13, ["Ride"] = 18.52, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.47, ["Mega"] = 127.36, ["Mega|Ride"] = 179.27, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 9.19, ["Fly"] = 231.7, ["Ride"] = 31.91, ["Fly|Ride"] = 117.02, ["Neon"] = 38.07, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 123.64, ["Mega"] = 376.82, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 138.06, ["Ride"] = 87.68, ["Fly|Ride"] = 214.87, ["Neon"] = 195.57, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 380.52, ["Mega"] = 1158, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 21.03, ["Ride"] = 105, ["Neon"] = 155.19, ["Neon|Ride"] = 238, ["Neon|Fly|Ride"] = 454.34, ["Mega"] = 656.24, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 810.81}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 393.75, ["Neon|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 6181.41}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Ride"] = 45.94, ["Fly|Ride"] = 69.57, ["Neon"] = 228.51, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 961.5}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.9, ["Ride"] = 15.36, ["Fly|Ride"] = 102.54, ["Neon"] = 3.84, ["Neon|Ride"] = 17.98, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 21.73, ["Mega|Fly"] = 103.03, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.63, ["Ride"] = 19.69, ["Neon"] = 16.96, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 406.96}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.94, ["Fly|Ride"] = 144.17, ["Neon"] = 23.18, ["Neon|Ride"] = 81.41, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 124.52, ["Mega|Fly"] = 535.75, ["Mega|Ride"] = 239.69, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 387.19, ["Fly"] = 618.59, ["Ride"] = 451.23, ["Fly|Ride"] = 647.07, ["Neon"] = 1493.66, ["Neon|Ride"] = 1374.35, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.52, ["Fly"] = 54.74, ["Ride"] = 16.65, ["Fly|Ride"] = 50.93, ["Neon"] = 29.89, ["Neon|Ride"] = 41.72, ["Neon|Fly|Ride"] = 77.27, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.81, ["Fly"] = 17, ["Ride"] = 17.07, ["Fly|Ride"] = 44.63, ["Neon"] = 31.28, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.52, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 687.19, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.13, ["Fly"] = 26.25, ["Ride"] = 27.56, ["Fly|Ride"] = 103.03, ["Neon"] = 16.49, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.4, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 78.75, ["Mega|Ride"] = 220.48, ["Mega|Fly|Ride"] = 272}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 82.43, ["Neon"] = 138.05, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 96.87, ["Mega"] = 927.23, ["Mega|Ride"] = 824.2, ["Mega|Fly|Ride"] = 640.5}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.29, ["Ride"] = 27.72, ["Fly|Ride"] = 68.34, ["Neon"] = 27.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 427.56, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 787.5, ["Ride"] = 19.69, ["Fly|Ride"] = 85.63, ["Neon"] = 131.25, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 687.19, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.82, ["Neon|Ride"] = 20.63, ["Mega"] = 45.92, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.29, ["Ride"] = 137.82, ["Neon"] = 94.5, ["Mega"] = 165.37, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 14.18, ["Ride"] = 39.38, ["Neon"] = 62.91, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 324.38, ["Mega|Ride"] = 341.76, ["Mega|Fly|Ride"] = 547.07}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 13.51, ["Fly"] = 31.5, ["Ride"] = 30.07, ["Fly|Ride"] = 45.46, ["Neon"] = 59.05, ["Neon|Fly"] = 115.86, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 113.88, ["Mega"] = 579.01, ["Mega|Ride"] = 395.62, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.27, ["Ride"] = 282.19, ["Fly|Ride"] = 389.81, ["Neon"] = 1468.94, ["Neon|Ride"] = 1168.3, ["Neon|Fly|Ride"] = 1218.02, ["Mega|Fly|Ride"] = 5068.75}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 10.29, ["Neon|Fly"] = 77.6, ["Neon|Ride"] = 58.74, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 220.48, ["Mega|Ride"] = 155.25, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.25, ["Fly"] = 27.65, ["Ride"] = 27.81, ["Fly|Ride"] = 80.37, ["Neon"] = 32.82, ["Neon|Ride"] = 69.53, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 385.32}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 104.99, ["Ride"] = 123.96, ["Fly|Ride"] = 340.45, ["Neon"] = 92.66, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.11, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 481.14}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 108.89, ["Fly"] = 393.75, ["Ride"] = 140.44, ["Fly|Ride"] = 274.82, ["Neon"] = 548.03, ["Neon|Fly"] = 1044.54, ["Neon|Ride"] = 463.39, ["Neon|Fly|Ride"] = 684.09, ["Mega"] = 3089.56, ["Mega|Ride"] = 1792.88, ["Mega|Fly|Ride"] = 2201.66}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.46, ["Fly"] = 110.25, ["Ride"] = 95.82, ["Neon"] = 115.82, ["Neon|Ride"] = 188.55, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 249.38, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 51.89, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 50.99, ["Mega|Ride"] = 193.48, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.67, ["Ride"] = 25.99, ["Fly|Ride"] = 81.39, ["Neon"] = 27.69, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 136.92, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 506.89}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 91.88, ["Fly"] = 196.88, ["Ride"] = 111.56, ["Fly|Ride"] = 216.57, ["Neon"] = 141.16, ["Neon|Ride"] = 168.5, ["Neon|Fly|Ride"] = 302.3, ["Mega"] = 446.25, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 65.63, ["Neon"] = 7.38, ["Neon|Ride"] = 205.03, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 59.07, ["Mega|Fly"] = 241.08, ["Mega|Ride"] = 152.5, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 8.26, ["Fly|Ride"] = 274.02, ["Neon"] = 95.82, ["Neon|Ride"] = 401.03, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 776.81}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 787.5, ["Fly"] = 1255.68, ["Ride"] = 1050, ["Fly|Ride"] = 862.32, ["Neon"] = 3022.35, ["Neon|Ride"] = 3863.39, ["Neon|Fly|Ride"] = 2741.82, ["Mega|Fly|Ride"] = 14285.2}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.94, ["Fly"] = 115.86, ["Ride"] = 119.43, ["Fly|Ride"] = 191.63, ["Neon"] = 123.38, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.67, ["Mega"] = 959.16, ["Mega|Ride"] = 515.12, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.7, ["Fly"] = 49.25, ["Ride"] = 25.85, ["Fly|Ride"] = 80.89, ["Neon"] = 14.43, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 78.33, ["Mega|Ride"] = 117.34, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.67, ["Ride"] = 131.22, ["Fly|Ride"] = 138.06, ["Neon"] = 117.41, ["Mega"] = 234.02, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 16.82, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 19.68, ["Mega|Fly"] = 123.64, ["Mega|Ride"] = 48.91, ["Mega|Fly|Ride"] = 138.06}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 65.52, ["Ride"] = 118.49, ["Fly|Ride"] = 224.69, ["Neon"] = 302.76, ["Neon|Ride"] = 273.49, ["Mega"] = 1378.13, ["Mega|Ride"] = 1545.36, ["Mega|Fly|Ride"] = 1273.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.67, ["Fly"] = 174.57, ["Ride"] = 23.62, ["Fly|Ride"] = 86.63, ["Neon"] = 45.94, ["Neon|Ride"] = 96.87, ["Neon|Fly|Ride"] = 77.63, ["Mega"] = 398.71, ["Mega|Ride"] = 455.38, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.68, ["Fly"] = 96.66, ["Ride"] = 26.78, ["Fly|Ride"] = 46.35, ["Neon"] = 16.37, ["Neon|Ride"] = 47.22, ["Mega"] = 92.69, ["Mega|Ride"] = 157.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 45.35, ["Ride"] = 60.8, ["Fly|Ride"] = 196.88, ["Neon"] = 197.79, ["Neon|Ride"] = 118.5, ["Neon|Fly|Ride"] = 279.21, ["Mega"] = 680.77, ["Mega|Ride"] = 1030.24, ["Mega|Fly|Ride"] = 772.69}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 11.69, ["Ride"] = 44.03, ["Fly|Ride"] = 86.24, ["Neon"] = 54.45, ["Neon|Ride"] = 102.01, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 345.31, ["Mega|Ride"] = 502.77, ["Mega|Fly|Ride"] = 461.56}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 50.76, ["Ride"] = 84, ["Neon"] = 386.82, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 1867.7, ["Mega|Ride"] = 1648.39, ["Mega|Fly|Ride"] = 1580.38}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.25, ["Neon"] = 24.2, ["Neon|Ride"] = 81.63, ["Neon|Fly|Ride"] = 618.62, ["Mega"] = 105, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Ride"] = 22.31, ["Fly|Ride"] = 78.74, ["Neon"] = 45.02, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 362.12, ["Mega|Fly|Ride"] = 352.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 129.47, ["Fly"] = 515.12, ["Ride"] = 131.25, ["Fly|Ride"] = 259.8, ["Neon"] = 446.25, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 550.16, ["Mega"] = 3150.47, ["Mega|Ride"] = 2356.15, ["Mega|Fly|Ride"] = 1890}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 23.39, ["Ride"] = 18.37, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 99.64, ["Mega"] = 124.59, ["Mega|Fly"] = 123.97, ["Mega|Ride"] = 144.24, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.68, ["Fly"] = 88.29, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 65.63, ["Neon|Fly"] = 185.36, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 374.64, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 343.75}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 14.43, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 16.5, ["Neon|Fly|Ride"] = 41.22, ["Mega"] = 14.44, ["Mega|Fly"] = 48.67, ["Mega|Ride"] = 30.86, ["Mega|Fly|Ride"] = 77.48}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.65, ["Fly|Ride"] = 65.63, ["Neon"] = 3.54, ["Neon|Ride"] = 39.17, ["Mega"] = 19.69, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 64.97, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.94, ["Fly"] = 35.04, ["Ride"] = 19.66, ["Fly|Ride"] = 82.77, ["Neon"] = 14.97, ["Neon|Ride"] = 59.09, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 157.64, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 36.66, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 412.11, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 666.58}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 17.07, ["Fly|Ride"] = 35.04, ["Neon"] = 11.38, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 114.7, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.8, ["Fly"] = 31.84, ["Ride"] = 23.93, ["Fly|Ride"] = 56.89, ["Neon"] = 29.69, ["Neon|Fly"] = 63.67, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 182.44, ["Mega|Fly"] = 412.11, ["Mega|Ride"] = 178.16, ["Mega|Fly|Ride"] = 216.12}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 22.31, ["Ride"] = 18.09, ["Fly|Ride"] = 74.08, ["Neon"] = 10.49, ["Neon|Fly"] = 85.72, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 69.53, ["Mega|Fly"] = 102.01, ["Mega|Ride"] = 103.03, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.09, ["Fly"] = 36.08, ["Ride"] = 32.95, ["Neon"] = 32.82, ["Neon|Ride"] = 80.31, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 223.09, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.12}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.57, ["Fly"] = 171.04, ["Ride"] = 122.72, ["Fly|Ride"] = 181.32, ["Neon"] = 123.38, ["Neon|Ride"] = 252.04, ["Neon|Fly|Ride"] = 344.11, ["Mega"] = 548.63, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.76, ["Fly"] = 41.88, ["Ride"] = 20.6, ["Fly|Ride"] = 65.54, ["Neon"] = 24.22, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 309.32, ["Mega|Ride"] = 231.71, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.56, ["Fly|Ride"] = 34.94, ["Neon"] = 11.64, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.15, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 181.82, ["Fly"] = 382.05, ["Ride"] = 309.08, ["Fly|Ride"] = 392.43, ["Neon"] = 962.13, ["Neon|Ride"] = 1236.3, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.36, ["Ride"] = 61.76, ["Neon"] = 27.83, ["Neon|Ride"] = 55.65, ["Neon|Fly|Ride"] = 412.11, ["Mega"] = 119.62, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.62, ["Fly"] = 26.25, ["Ride"] = 20.9, ["Fly|Ride"] = 77.27, ["Neon"] = 23.15, ["Neon|Fly"] = 220.46, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 199.4, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.42, ["Ride"] = 27.83, ["Neon"] = 60.38, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 618.15, ["Mega"] = 461.77, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 13.13, ["Fly|Ride"] = 30.92, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.44, ["Neon|Fly|Ride"] = 44.62, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.05, ["Fly|Ride"] = 59.07, ["Neon"] = 9.17, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 69.04, ["Neon"] = 16.49, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 60.22, ["Mega|Ride"] = 205.03, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 73.41, ["Fly"] = 123.64, ["Ride"] = 108.63, ["Fly|Ride"] = 139.13, ["Neon"] = 618.43, ["Neon|Ride"] = 1374.35, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2060.47, ["Mega|Ride"] = 3435.85, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.71, ["Fly"] = 91.88, ["Ride"] = 30.14, ["Fly|Ride"] = 65.63, ["Neon"] = 21.41, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 209.42, ["Mega|Ride"] = 350.3, ["Mega|Fly|Ride"] = 411.08}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.4, ["Fly|Ride"] = 118.48, ["Neon"] = 15.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 206.06}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.7, ["Fly"] = 210, ["Ride"] = 73.37, ["Fly|Ride"] = 204.01, ["Neon"] = 155.96, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 309.32, ["Mega"] = 523.69, ["Mega|Ride"] = 618.62, ["Mega|Fly|Ride"] = 618.3}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 13.9, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 18.56, ["Neon|Ride"] = 15.46, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 17.07, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 93.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 123.64, ["Mega"] = 23.71, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.8, ["Ride"] = 107.63, ["Neon"] = 9.85, ["Neon|Ride"] = 114.37, ["Neon|Fly|Ride"] = 181.34, ["Mega"] = 64.32, ["Mega|Fly"] = 179.27, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 10.85, ["Fly"] = 68.25, ["Ride"] = 38.06, ["Fly|Ride"] = 130.85, ["Neon"] = 21.24, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 69.32, ["Neon|Fly|Ride"] = 231.71, ["Mega"] = 103.69, ["Mega|Fly"] = 332.49, ["Mega|Ride"] = 155.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19.49, ["Ride"] = 13.12, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 48.44, ["Neon|Fly|Ride"] = 67.19, ["Mega"] = 23.18, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.96, ["Fly"] = 72.19, ["Ride"] = 117.47, ["Neon"] = 118.13, ["Neon|Fly"] = 412.06, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 962.26, ["Mega"] = 495.83, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 679.96}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Fly"] = 2884.67, ["Ride"] = 2520.9, ["Fly|Ride"] = 2513.54, ["Neon"] = 9299.79, ["Neon|Fly|Ride"] = 9588.38, ["Mega|Fly|Ride"] = 34615.8}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.4, ["Ride"] = 15.1, ["Fly|Ride"] = 45.23, ["Neon"] = 10.5, ["Neon|Fly"] = 62.49, ["Neon|Ride"] = 23.18, ["Neon|Fly|Ride"] = 52.56, ["Mega"] = 76.26, ["Mega|Fly"] = 454.34, ["Mega|Ride"] = 109.58, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.03, ["Neon"] = 13.91, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 412.13}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 24, ["Ride"] = 34.13, ["Fly|Ride"] = 157.5, ["Neon"] = 105, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 259.64, ["Mega"] = 393.75, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 550.16}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 30.8, ["Ride"] = 66.94, ["Neon"] = 155.07, ["Neon|Ride"] = 206.06, ["Mega"] = 540.65, ["Mega|Ride"] = 769.6, ["Mega|Fly|Ride"] = 810.92}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.31, ["Fly"] = 1374.35, ["Ride"] = 197.74, ["Fly|Ride"] = 308.49, ["Neon"] = 687.09, ["Neon|Ride"] = 687.19, ["Neon|Fly|Ride"] = 748.27, ["Mega"] = 6181.41, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 9.08, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.15, ["Neon|Ride"] = 128.7, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.65, ["Neon"] = 13.13, ["Neon|Fly"] = 103.02, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 515.12, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.86, ["Fly"] = 101.99, ["Ride"] = 40.35, ["Fly|Ride"] = 131.25, ["Neon"] = 9.19, ["Neon|Ride"] = 56.44, ["Mega"] = 85.83, ["Mega|Ride"] = 96.84, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.9, ["Ride"] = 103.03, ["Neon"] = 131.24, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 485.25, ["Mega|Ride"] = 597.55, ["Mega|Fly|Ride"] = 719.11}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.43, ["Mega"] = 17.07, ["Mega|Fly"] = 115.58, ["Mega|Ride"] = 153.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.88, ["Fly"] = 138.06, ["Ride"] = 97.13, ["Fly|Ride"] = 167.95, ["Neon"] = 410.84, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 510.88, ["Mega|Fly|Ride"] = 1725.65}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 10.21, ["Neon|Ride"] = 69.04, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 69.53, ["Mega|Ride"] = 192.67, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.29, ["Fly"] = 103.03, ["Ride"] = 81.2, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 274.37, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1677.38}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.6, ["Fly|Ride"] = 50.8, ["Neon"] = 3.94, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 46.05, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.81}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 11.17, ["Neon|Ride"] = 118.13, ["Mega"] = 60.38, ["Mega|Ride"] = 149.63, ["Mega|Fly|Ride"] = 605.79}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.5, ["Ride"] = 36.65, ["Fly|Ride"] = 157.5, ["Neon"] = 51.05, ["Neon|Ride"] = 94.8, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 155.36, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 917.49}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420, ["Ride"] = 446.25, ["Fly|Ride"] = 525, ["Neon"] = 1231.13, ["Neon|Ride"] = 1349.62, ["Neon|Fly|Ride"] = 1245.57, ["Mega"] = 4633.74, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 31.34, ["Ride"] = 55, ["Fly|Ride"] = 92.73, ["Neon"] = 206.04, ["Neon|Ride"] = 204.58, ["Neon|Fly|Ride"] = 274.05, ["Mega"] = 1374.35, ["Mega|Ride"] = 1215.68, ["Mega|Fly|Ride"] = 1099.27}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 19.46, ["Fly|Ride"] = 91.88, ["Neon"] = 7.27, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 26.66, ["Neon|Fly|Ride"] = 99.64, ["Mega"] = 50.43, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.31, ["Fly"] = 81.19, ["Ride"] = 46.35, ["Fly|Ride"] = 155.19, ["Neon"] = 44.89, ["Neon|Fly"] = 105, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 257.25, ["Mega|Fly"] = 953.4, ["Mega|Ride"] = 244.5, ["Mega|Fly|Ride"] = 344.11}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.12, ["Ride"] = 20.68, ["Fly|Ride"] = 262.69, ["Neon"] = 138.05, ["Neon|Ride"] = 127.76, ["Neon|Fly|Ride"] = 309.32, ["Mega"] = 1099.27, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.88, ["Ride"] = 27.83, ["Neon"] = 15.74, ["Mega"] = 68.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.77, ["Fly"] = 86.62, ["Ride"] = 20.16, ["Fly|Ride"] = 57.64, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.18, ["Mega"] = 138.06, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1648.39}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 108.8, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 714.91, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 695.07, ["Mega|Fly|Ride"] = 2582.81}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21.53, ["Ride"] = 103.03, ["Fly|Ride"] = 138.06, ["Neon"] = 192.94, ["Neon|Ride"] = 192.15, ["Neon|Fly|Ride"] = 274.96, ["Mega"] = 682.5, ["Mega|Ride"] = 720.15, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.71, ["Fly"] = 2471.55, ["Ride"] = 2229.94, ["Fly|Ride"] = 2244.38, ["Neon"] = 10988.13, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.63, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 183.75, ["Neon"] = 8.79, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 192.67, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.77, ["Ride"] = 74.11, ["Fly|Ride"] = 96.87, ["Neon"] = 40.61, ["Neon|Ride"] = 100.58, ["Neon|Fly|Ride"] = 232.31, ["Mega"] = 185.41, ["Mega|Ride"] = 245.36, ["Mega|Fly|Ride"] = 529.56}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 872.82, ["Fly"] = 1156.05, ["Ride"] = 925.74, ["Fly|Ride"] = 984.38, ["Neon"] = 2623.69, ["Neon|Ride"] = 2935.48, ["Neon|Fly|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 31.19, ["Ride"] = 55.65, ["Fly|Ride"] = 173.35, ["Neon"] = 155.19, ["Neon|Ride"] = 291.72, ["Mega"] = 839.9, ["Mega|Ride"] = 772.69, ["Mega|Fly|Ride"] = 687.19}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.96, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 15.44, ["Neon|Ride"] = 41.22, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 194.25, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 138.06, ["Neon"] = 3.94, ["Neon|Fly"] = 41.22, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 77.63, ["Mega"] = 39.37, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 247.27}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.43, ["Ride"] = 127.32, ["Fly|Ride"] = 309.3, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2316.87, ["Mega|Fly|Ride"] = 2472.11}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.6, ["Neon"] = 23.18, ["Neon|Ride"] = 64.88, ["Mega"] = 144.88, ["Mega|Ride"] = 316.31, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.03, ["Ride"] = 136.49, ["Neon"] = 380.63, ["Neon|Ride"] = 463.39, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 15.45, ["Fly"] = 105, ["Fly|Ride"] = 110.25, ["Neon"] = 39.22, ["Neon|Ride"] = 77.63, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 136.5, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 179.27}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.49, ["Ride"] = 301.88, ["Fly|Ride"] = 363.57, ["Neon"] = 1410.28, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.25, ["Fly"] = 87.83, ["Ride"] = 17.38, ["Fly|Ride"] = 55.65, ["Neon"] = 37.08, ["Neon|Ride"] = 64.36, ["Neon|Fly|Ride"] = 114.18, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 345.92}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.38, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 6.46, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 51.08, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 77.84, ["Mega|Fly|Ride"] = 127.8}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.81, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7555.73, ["Neon|Fly|Ride"] = 5495.27, ["Mega"] = 26099.91}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 14.78, ["Fly"] = 962.26, ["Ride"] = 210, ["Neon"] = 48.57, ["Neon|Ride"] = 78.75, ["Mega"] = 236.25, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.49, ["Fly"] = 54.91, ["Ride"] = 35.24, ["Fly|Ride"] = 95.82, ["Neon"] = 31.5, ["Neon|Fly"] = 92.66, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 164.85, ["Mega"] = 179.2, ["Mega|Fly"] = 227.7, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.9, ["Fly"] = 40.78, ["Ride"] = 39.38, ["Fly|Ride"] = 76.13, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2060.47, ["Mega|Ride"] = 1236.3, ["Mega|Fly|Ride"] = 861.84}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.95, ["Fly"] = 59.07, ["Ride"] = 27.42, ["Fly|Ride"] = 89.24, ["Neon"] = 67.36, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.25, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.87, ["Fly"] = 108.9, ["Ride"] = 209.98, ["Fly|Ride"] = 401.81, ["Neon"] = 105.09, ["Neon|Ride"] = 275.09, ["Mega"] = 485.25, ["Mega|Ride"] = 574.89, ["Mega|Fly|Ride"] = 687.19}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 231.7, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 309.32, ["Mega"] = 18.38, ["Mega|Ride"] = 71.07, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.19, ["Fly"] = 102.38, ["Ride"] = 52.5, ["Fly|Ride"] = 130.99, ["Neon"] = 337.89, ["Neon|Ride"] = 301.21, ["Neon|Fly|Ride"] = 371.67, ["Mega"] = 3296.76, ["Mega|Fly|Ride"] = 1167.03}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 19.91, ["Fly|Ride"] = 77.49, ["Neon"] = 31.5, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 334.72, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 16.48, ["Fly|Ride"] = 38.07, ["Neon"] = 14.11, ["Neon|Ride"] = 52.56, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.25, ["Ride"] = 172.07, ["Neon"] = 20.13, ["Neon|Fly|Ride"] = 184.43, ["Mega"] = 261.7, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.26, ["Ride"] = 55.65, ["Fly|Ride"] = 138.06, ["Neon"] = 231.63, ["Neon|Ride"] = 303.94, ["Neon|Fly|Ride"] = 315.27, ["Mega"] = 1017.89, ["Mega|Ride"] = 1017.19, ["Mega|Fly|Ride"] = 934.43}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 6.87, ["Ride"] = 687.19, ["Fly|Ride"] = 412.06, ["Neon"] = 20.88, ["Neon|Ride"] = 77.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 92.69, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 308.6}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Mega"] = 15.65, ["Mega|Ride"] = 55.65, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.04, ["Ride"] = 24.47, ["Fly|Ride"] = 82.42, ["Neon"] = 2.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 21.77, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 22.17, ["Ride"] = 29.9, ["Fly|Ride"] = 38.66, ["Neon"] = 5.15, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 76.26, ["Mega"] = 98.91, ["Mega|Ride"] = 58.49, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 21.74, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.63, ["Fly"] = 39.17, ["Ride"] = 14.7, ["Fly|Ride"] = 47.25, ["Neon"] = 15.65, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 229.04, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 64.22, ["Ride"] = 155.23, ["Fly|Ride"] = 360.55, ["Neon"] = 196.88, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1030.24, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1044.67}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 15.1, ["Fly|Ride"] = 35.43, ["Neon"] = 3.67, ["Neon|Fly"] = 22.66, ["Neon|Ride"] = 19.6, ["Neon|Fly|Ride"] = 49.47, ["Mega"] = 30.11, ["Mega|Ride"] = 55.65, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 11.53, ["Fly"] = 79.5, ["Ride"] = 37.1, ["Fly|Ride"] = 82.13, ["Neon"] = 55.64, ["Neon|Fly"] = 49.88, ["Neon|Ride"] = 62.53, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 236.91, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.75, ["Fly"] = 46.35, ["Ride"] = 28.21, ["Fly|Ride"] = 65.63, ["Neon"] = 108.94, ["Neon|Ride"] = 123.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 787.5, ["Mega|Ride"] = 412.11, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.37, ["Fly"] = 196.88, ["Fly|Ride"] = 51.52, ["Neon"] = 45.94, ["Neon|Ride"] = 82.43, ["Mega"] = 288.48, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 407.99}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 39.16, ["Neon"] = 3.94, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 42.31, ["Mega|Fly"] = 168.97, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.77, ["Fly"] = 39.38, ["Ride"] = 30.19, ["Neon"] = 10.28, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 398.71}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Ride"] = 974.43, ["Fly|Ride"] = 1076.25, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 6891.39}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.07, ["Ride"] = 140.44, ["Fly|Ride"] = 201.52, ["Neon"] = 406.88, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 604.76, ["Mega"] = 3089.67, ["Mega|Ride"] = 2058.42, ["Mega|Fly|Ride"] = 1643.24}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.81, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 206.06, ["Mega"] = 73.9, ["Mega|Fly|Ride"] = 206.06}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.74, ["Ride"] = 82.43, ["Fly|Ride"] = 139.01, ["Neon"] = 288.45, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 496.13, ["Mega"] = 1050, ["Mega|Ride"] = 1235.68, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.77, ["Ride"] = 26.37, ["Fly|Ride"] = 89.63, ["Neon"] = 62.85, ["Neon|Fly"] = 54.47, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 268.55, ["Mega|Ride"] = 346.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 297.07, ["Fly"] = 412.11, ["Ride"] = 275.09, ["Fly|Ride"] = 443.98, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1745.23, ["Mega|Fly|Ride"] = 4324.92}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 39.17, ["Fly|Ride"] = 202.64, ["Neon"] = 24.68, ["Neon|Ride"] = 54.28, ["Mega"] = 138.06, ["Mega|Fly"] = 321.44, ["Mega|Ride"] = 550.16, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.63, ["Neon|Ride"] = 155.25, ["Mega"] = 329.69}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 39.66, ["Ride"] = 65.63, ["Fly|Ride"] = 164.83, ["Neon"] = 164.07, ["Neon|Fly"] = 275.05, ["Neon|Ride"] = 171.46, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 275.05, ["Neon"] = 20.63, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.46, ["Fly|Ride"] = 34.13, ["Neon"] = 3.68, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.93, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 26.78, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4134.38, ["Ride"] = 4396.88, ["Fly|Ride"] = 4436.25, ["Neon"] = 30903.12, ["Neon|Fly|Ride"] = 21703.9, ["Mega|Fly|Ride"] = 85166.18}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.29, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega"] = 275.09, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 22.28, ["Ride"] = 20.66, ["Fly|Ride"] = 41.01, ["Neon"] = 12.75, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 155.25, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 494.61, ["Fly"] = 547.77, ["Ride"] = 478.79, ["Fly|Ride"] = 535.75, ["Neon"] = 1374.17, ["Neon|Ride"] = 1648.39, ["Neon|Fly|Ride"] = 1524.36, ["Mega|Fly|Ride"] = 4945.14}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.87, ["Ride"] = 26.24, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.08, ["Mega|Fly|Ride"] = 687.19}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.11, ["Fly"] = 4110.2, ["Ride"] = 46.35, ["Neon"] = 41.22, ["Neon|Ride"] = 275.09, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 410.05, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.36, ["Ride"] = 23.07, ["Neon"] = 5.12, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.39, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 275.09}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 741.37, ["Fly"] = 865.41, ["Ride"] = 630, ["Fly|Ride"] = 724.5, ["Neon"] = 2362.5, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2208.63}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 8.28, ["Fly"] = 56.44, ["Ride"] = 72.92, ["Neon"] = 30.07, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 152.5, ["Mega"] = 156.19, ["Mega|Ride"] = 199.18, ["Mega|Fly|Ride"] = 350.3}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 9.19, ["Fly"] = 52.5, ["Ride"] = 63.89, ["Neon"] = 36.75, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 155.25, ["Mega"] = 203.43, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 17.07, ["Fly|Ride"] = 52.5, ["Neon"] = 15.46, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 66.94, ["Mega"] = 275.09, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.07, ["Fly"] = 19.69, ["Ride"] = 46.35, ["Fly|Ride"] = 155.19, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 138.06, ["Mega"] = 550.16, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 5.25, ["Neon|Fly"] = 69.03, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 184.43, ["Mega"] = 45.82, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 509.99, ["Ride"] = 544.43, ["Fly|Ride"] = 699.54, ["Neon"] = 2589.57, ["Neon|Ride"] = 2703.8, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.41, ["Ride"] = 61.66, ["Fly|Ride"] = 309.23, ["Neon"] = 14.43, ["Neon|Ride"] = 69.04, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 77.44, ["Mega|Fly"] = 123.64, ["Mega|Ride"] = 164.38, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.25, ["Neon|Fly"] = 138.05, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 46.22, ["Mega|Ride"] = 138.06, ["Mega|Fly|Ride"] = 261.7}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.16, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 138.06, ["Mega"] = 45.94, ["Mega|Fly"] = 152.5, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.63, ["Ride"] = 21.18, ["Neon"] = 18.5, ["Neon|Ride"] = 69.04, ["Mega"] = 192.67}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.43, ["Fly"] = 98.44, ["Ride"] = 62.35, ["Fly|Ride"] = 262.79, ["Neon"] = 143.07, ["Neon|Ride"] = 179.27, ["Neon|Fly|Ride"] = 267.88, ["Mega"] = 630.52, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 707.24}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 21.84, ["Ride"] = 55.39, ["Fly|Ride"] = 138.05, ["Neon"] = 77.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 629.49}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.62, ["Fly"] = 19.16, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 23.18, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 81.41, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 206.06}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 20.55, ["Ride"] = 64.32, ["Fly|Ride"] = 123.94, ["Neon"] = 92.72, ["Mega"] = 301.88, ["Mega|Ride"] = 716.02, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 24.94, ["Fly|Ride"] = 73.08, ["Neon"] = 14.31, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 206.21, ["Mega"] = 86.63, ["Mega|Fly"] = 164.85, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 23.63, ["Ride"] = 23.62, ["Fly|Ride"] = 131.25, ["Neon"] = 228.74, ["Neon|Ride"] = 179.27, ["Neon|Fly|Ride"] = 198.11, ["Mega"] = 926.2, ["Mega|Ride"] = 926.77, ["Mega|Fly|Ride"] = 880.87}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 43.24, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Ride"] = 275.09, ["Mega|Fly|Ride"] = 962.26}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 49.86, ["Fly"] = 111.91, ["Ride"] = 72.35, ["Fly|Ride"] = 147.13, ["Neon"] = 259.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1638.05, ["Mega|Fly|Ride"] = 1507.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 41.98, ["Fly"] = 92.69, ["Ride"] = 84.33, ["Fly|Ride"] = 275.05, ["Neon"] = 129.94, ["Neon|Ride"] = 189.57, ["Neon|Fly|Ride"] = 275.09, ["Mega"] = 609.92, ["Mega|Ride"] = 617.32, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.96, ["Ride"] = 55.68, ["Fly|Ride"] = 138.05, ["Neon"] = 138.98, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Ride"] = 772.69, ["Mega|Fly|Ride"] = 1236.3}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 17.07, ["Fly"] = 428.27, ["Ride"] = 46.09, ["Fly|Ride"] = 65.62, ["Neon"] = 86.15, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 199.87, ["Mega"] = 457.47, ["Mega|Ride"] = 355.65, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 17.06, ["Fly|Ride"] = 26.25, ["Neon"] = 4.14, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 155.25, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1216.28}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 48.57, ["Fly"] = 231.7, ["Ride"] = 126.93, ["Fly|Ride"] = 249.38, ["Neon"] = 288.46, ["Neon|Ride"] = 258.68, ["Neon|Fly|Ride"] = 303.94, ["Mega"] = 790.19, ["Mega|Ride"] = 741.78, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.65, ["Neon"] = 3.27, ["Neon|Fly"] = 96.87, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 288.48, ["Mega"] = 29.9, ["Mega|Ride"] = 80.37, ["Mega|Fly|Ride"] = 152.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 31.28, ["Ride"] = 64.93, ["Neon"] = 128.37, ["Neon|Ride"] = 138.06, ["Neon|Fly|Ride"] = 543.98, ["Mega"] = 772.69, ["Mega|Ride"] = 803.6, ["Mega|Fly|Ride"] = 481.14}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.15, ["Neon|Ride"] = 105, ["Mega"] = 19.69}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Ride"] = 39.38, ["Mega"] = 27.82, ["Mega|Ride"] = 82.43, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 106.6, ["Ride"] = 133.88, ["Fly|Ride"] = 257.25, ["Neon"] = 498.75, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 687.19, ["Mega|Ride"] = 6371.39, ["Mega|Fly|Ride"] = 3863.39}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 92.69, ["Neon"] = 6.49, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 84, ["Mega"] = 90.56, ["Mega|Ride"] = 107.61, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.4, ["Fly|Ride"] = 52.49, ["Neon"] = 3.94, ["Neon|Fly"] = 61.82, ["Neon|Ride"] = 35.04, ["Neon|Fly|Ride"] = 103.03, ["Mega"] = 31.95, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 220.48}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.43, ["Neon"] = 3.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.6}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 63, ["Mega|Ride"] = 200.61}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 57.75, ["Ride"] = 69.04, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 687.19, ["Mega"] = 1545.36, ["Mega|Ride"] = 1545.36, ["Mega|Fly|Ride"] = 1325.93}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.57, ["Ride"] = 59.3, ["Fly|Ride"] = 131.25, ["Neon"] = 46.34, ["Neon|Ride"] = 139.02, ["Mega"] = 364.58, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Fly"] = 463.36, ["Ride"] = 432.72, ["Fly|Ride"] = 618.15, ["Neon"] = 1648.19, ["Neon|Ride"] = 1648.39, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3805.69}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 82.69}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.26}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.37}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.95}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 110.15}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 54.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.59}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.75}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 30.79}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.39}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.33}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 206.06}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.64}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.2}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.28}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 393.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 590.63}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.82}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1039.47}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.1}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.46}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.96}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 39.25}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 8.54}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.19}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.12}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.77}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.8}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.56}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.93}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1854.43}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.34}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.36}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.69}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.22}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.46}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 9.22}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.87}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1372.28}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.61}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 13.13}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.38}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 5.21}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 210}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.48}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.4}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.57}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.84}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 35.35}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 125.88}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 177.19}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.45}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.83}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.17}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.35}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.06}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22061.34}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 133.77}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 86.63}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 92.73}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 68.14}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.07}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 64.59}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 37.68}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 89.64}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 411.59}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.88}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.31}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.57}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.58}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.22}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.84}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 10.23}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.4}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 263.75}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 636.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.66}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 20.63}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.34}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 602.27}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 38.99}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.72}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.8}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 49.88}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 217.65}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.18}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.4}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.74}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.16}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.57}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.27}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.63}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.51}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 179.34}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 65.63}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 14.44}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 39.38}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.07}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 5.82}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 17.09}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.01}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 60.26}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.69}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 9.29}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.03}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.34}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.87}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.14}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6431.25}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 4.66}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 30.92}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.25}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.76}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.44}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.13}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 8.99}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 68.97}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 6.18}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 94.65}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4276.13}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 154.77}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.17}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.5}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 48.45}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 6.57}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.66}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 15.65}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.04}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.87}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.36}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.51}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.32}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 85.32}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 48.36}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.84}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.97}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 18.27}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.48}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 68.55}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.24}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.71}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 20.63}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.6}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.21}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.15}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.54}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.52}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.38}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 5.35}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 8.71}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.15}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.55}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.52}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 46.09}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.14}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.9}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 52.5}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.25}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.59}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 5.86}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 314.89}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 140.44}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1162.88}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.24}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.61}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 31.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.74}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.87}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.82}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.28}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.81}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 6.97}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.76}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 7.88}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.41}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 68.01}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 52.5}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 6.19}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.42}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.26}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 6.48}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 24.76}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 124.59}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.77}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 74.69}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.14}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 6.78}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 98.44}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.16}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 87.28}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 230.98}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.15}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 135.19}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.29}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.06}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 50.98}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.74}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.05}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.88}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 22.22}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.28}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 35.44}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.44}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.65}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.58}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 687.19}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 8.26}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 138.06}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.71}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.08}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 74.82}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.82}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.35}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 15.46}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 48.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 375.17}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 40.2}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 315}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.35}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.63}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.34}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 5.13}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.63}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 115.5}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 73.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 212.24}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.74}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2060.47}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
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