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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1141.88, ["Ride"] = 1154.99, ["Fly|Ride"] = 1292.82, ["Neon"] = 6818.21, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 5720.77, ["Mega|Fly|Ride"] = 17812.91}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 498.25, ["Fly|Ride"] = 609.96, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 12144.05, ["Mega|Fly|Ride"] = 7078.56}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5748.75, ["Ride"] = 5250, ["Fly|Ride"] = 4837.23, ["Neon|Fly|Ride"] = 20878.5, ["Mega|Fly|Ride"] = 71500.79}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.13, ["Ride"] = 214.83, ["Fly|Ride"] = 275.63, ["Neon"] = 1004.24, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 1071.45, ["Mega|Fly|Ride"] = 4265.62}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 860.16, ["Ride"] = 530.62, ["Fly|Ride"] = 623.01, ["Neon|Fly|Ride"] = 1719.19, ["Mega|Fly|Ride"] = 7021.88}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.5, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 72.05, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 343.22, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 599.54}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.82, ["Fly"] = 42.7, ["Ride"] = 30.18, ["Fly|Ride"] = 61.67, ["Neon"] = 27.57, ["Neon|Fly"] = 103.68, ["Neon|Ride"] = 57.83, ["Neon|Fly|Ride"] = 105, ["Mega"] = 140.44, ["Mega|Ride"] = 264.08, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 124.69, ["Ride"] = 185.07, ["Fly|Ride"] = 227.54, ["Neon"] = 572.01, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 715.38, ["Mega"] = 1586.82, ["Mega|Ride"] = 1845.92, ["Mega|Fly|Ride"] = 2800.33}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.28, ["Fly"] = 97.76, ["Ride"] = 46.47, ["Fly|Ride"] = 91.96, ["Neon"] = 275.63, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 324.61, ["Mega"] = 1430.75, ["Mega|Ride"] = 1134.28, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.2, ["Fly"] = 58.08, ["Ride"] = 32.74, ["Fly|Ride"] = 62.99, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 185.07, ["Mega|Fly|Ride"] = 685.34}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 57.85, ["Fly"] = 129.04, ["Ride"] = 70.87, ["Fly|Ride"] = 154.2, ["Neon"] = 406.88, ["Neon|Ride"] = 275.62, ["Neon|Fly|Ride"] = 427.94, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.51}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 336.52, ["Fly"] = 476.32, ["Ride"] = 326.8, ["Fly|Ride"] = 360.65, ["Neon|Ride"] = 1430.75, ["Neon|Fly|Ride"] = 1128.75, ["Mega|Fly|Ride"] = 5142.68}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 110.92, ["Fly"] = 137.81, ["Ride"] = 107.12, ["Fly|Ride"] = 167.97, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 765.1, ["Mega|Fly|Ride"] = 3063.38}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.47, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 21, ["Neon|Ride"] = 78.75, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 323.91, ["Mega|Fly|Ride"] = 238.7}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.54, ["Fly"] = 287.44, ["Ride"] = 191.65, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 653.52, ["Mega|Fly|Ride"] = 2729.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.47, ["Fly"] = 23.33, ["Ride"] = 21.19, ["Fly|Ride"] = 39.41, ["Neon"] = 28.86, ["Neon|Fly"] = 129.04, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 204.75, ["Mega|Fly"] = 393.75, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 87.7, ["Fly"] = 284.72, ["Ride"] = 145.52, ["Fly|Ride"] = 124.69, ["Neon"] = 328.12, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1703.79, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.09}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.63, ["Ride"] = 164.9, ["Fly|Ride"] = 215.06, ["Neon"] = 545.13, ["Neon|Fly|Ride"] = 715.38, ["Mega|Fly|Ride"] = 4535.82}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 22.24, ["Fly"] = 55.93, ["Ride"] = 32.81, ["Fly|Ride"] = 322.56, ["Neon"] = 202.96, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 715.38, ["Mega|Fly|Ride"] = 715.38}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 37.17, ["Fly"] = 144.09, ["Ride"] = 55.12, ["Fly|Ride"] = 94.49, ["Neon"] = 717.17, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1700.19, ["Mega|Ride"] = 1430.75, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 42, ["Ride"] = 111.56, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1645.24, ["Mega|Fly|Ride"] = 1247.22}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.87, ["Ride"] = 45.17, ["Fly|Ride"] = 84, ["Neon"] = 210, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Ride"] = 1244.12, ["Mega|Fly|Ride"] = 1144.38}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 30.45, ["Fly"] = 136.75, ["Ride"] = 57.66, ["Fly|Ride"] = 162.87, ["Neon"] = 325.5, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.88, ["Fly"] = 23.09, ["Ride"] = 26.25, ["Fly|Ride"] = 58.45, ["Neon"] = 32.81, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57.83, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 183.75, ["Mega|Fly"] = 27000.57, ["Mega|Ride"] = 182.43, ["Mega|Fly|Ride"] = 239.25}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 481.47, ["Fly|Ride"] = 523.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 9123.83}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 19.47, ["Ride"] = 32.82, ["Fly|Ride"] = 116.19, ["Neon"] = 212.66, ["Neon|Fly|Ride"] = 257.41, ["Mega|Ride"] = 815.12, ["Mega|Fly|Ride"] = 928.8}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 4.88, ["Fly"] = 53.78, ["Ride"] = 19.45, ["Fly|Ride"] = 44.37, ["Neon"] = 78.75, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 118.25, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 472.99}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 94.5, ["Fly"] = 107.08, ["Ride"] = 91.88, ["Fly|Ride"] = 118.13, ["Neon"] = 382.32, ["Neon|Fly"] = 377.41, ["Neon|Ride"] = 393.63, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6435.14, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1620.03}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.21, ["Ride"] = 31.89, ["Fly|Ride"] = 75.21, ["Neon"] = 131.25, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 710.01, ["Mega|Ride"] = 728.66, ["Mega|Fly|Ride"] = 737.17}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.06, ["Fly"] = 288.75, ["Ride"] = 225.64, ["Fly|Ride"] = 356.97, ["Neon"] = 796.28, ["Neon|Ride"] = 714.31, ["Neon|Fly|Ride"] = 971.54, ["Mega"] = 6435.06, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.77}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.89, ["Fly"] = 35.43, ["Ride"] = 19.09, ["Fly|Ride"] = 55.1, ["Neon"] = 21.2, ["Neon|Fly"] = 141.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.75, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 170.55, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 832.17, ["Fly"] = 2625, ["Ride"] = 891.18, ["Fly|Ride"] = 918.75, ["Neon"] = 6450.03, ["Neon|Ride"] = 6292.41, ["Neon|Fly|Ride"] = 4282.34, ["Mega|Ride"] = 54648.21, ["Mega|Fly|Ride"] = 17045.44}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.13, ["Fly"] = 52.5, ["Ride"] = 34.02, ["Fly|Ride"] = 91.49, ["Neon"] = 131.25, ["Neon|Ride"] = 100.67, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 787.5, ["Mega|Ride"] = 797.96, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 209.9, ["Fly"] = 365.18, ["Ride"] = 214.26, ["Fly|Ride"] = 300.57, ["Neon"] = 830.82, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 1030.32, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4050.05}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.12}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.42, ["Fly"] = 114.31, ["Ride"] = 65.63, ["Fly|Ride"] = 145.69, ["Neon"] = 104.9, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 643.13, ["Mega|Ride"] = 1129.62, ["Mega|Fly|Ride"] = 601.15}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.18, ["Ride"] = 166.69, ["Fly|Ride"] = 262.5, ["Neon"] = 639.19, ["Neon|Ride"] = 485.78, ["Mega|Fly|Ride"] = 2161.13}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 95.46, ["Fly"] = 157.49, ["Ride"] = 149.51, ["Fly|Ride"] = 274.32, ["Neon"] = 360.94, ["Neon|Fly"] = 574.17, ["Neon|Ride"] = 367.48, ["Neon|Fly|Ride"] = 472.49, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.35}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 57.28, ["Fly"] = 74.6, ["Ride"] = 62.9, ["Fly|Ride"] = 73.5, ["Neon|Ride"] = 405.62, ["Neon|Fly|Ride"] = 386.12, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.08, ["Fly"] = 98.44, ["Ride"] = 57.66, ["Fly|Ride"] = 157.5, ["Neon"] = 42, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 241.33, ["Mega"] = 129.82, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 538.13, ["Fly"] = 496.13, ["Ride"] = 477.75, ["Fly|Ride"] = 557.81, ["Neon|Fly"] = 3870.67, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Ride"] = 15015.1, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 94.75, ["Fly"] = 159.14, ["Ride"] = 124.68, ["Fly|Ride"] = 181.15, ["Neon"] = 498.75, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2572.97, ["Mega|Fly|Ride"] = 2548.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4300.74, ["Ride"] = 3885, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 15014.03}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 50.42, ["Fly"] = 119.89, ["Ride"] = 57.74, ["Fly|Ride"] = 131.14, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1928.38, ["Mega|Ride"] = 1830.78, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 52.5, ["Ride"] = 70.88, ["Fly|Ride"] = 83.45, ["Neon"] = 650.18, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega|Ride"] = 2288.74, ["Mega|Fly|Ride"] = 2359.52}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 27.97, ["Fly"] = 61.67, ["Ride"] = 57.74, ["Fly|Ride"] = 87.67, ["Neon"] = 145.69, ["Neon|Ride"] = 132.55, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1001.74, ["Mega|Ride"] = 707.87, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.34}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 57.22, ["Ride"] = 118.13, ["Fly|Ride"] = 71.6, ["Neon|Ride"] = 324.26, ["Neon|Fly|Ride"] = 310.91, ["Mega|Ride"] = 1295.79, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 215.06, ["Ride"] = 236.25, ["Fly|Ride"] = 318.94, ["Neon|Ride"] = 1130.43, ["Neon|Fly|Ride"] = 1111.13, ["Mega|Fly|Ride"] = 4624.67}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1089.44, ["Ride"] = 754.69, ["Fly|Ride"] = 783.57, ["Neon"] = 2362.5, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 10820.36}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.63}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.2, ["Fly"] = 39.38, ["Ride"] = 34.83, ["Fly|Ride"] = 78.74, ["Neon"] = 213.96, ["Neon|Ride"] = 158.74, ["Neon|Fly|Ride"] = 218.27, ["Mega"] = 2145.03, ["Mega|Ride"] = 1160.39, ["Mega|Fly|Ride"] = 770.44}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 17.15}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 5055.75, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 42900.26}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 8.91, ["Fly"] = 55.11, ["Ride"] = 21.57, ["Fly|Ride"] = 65.54, ["Neon"] = 65.51, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 561.75, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 597.89}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.74, ["Fly"] = 139.89, ["Ride"] = 36.75, ["Neon"] = 97.85, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 749.69, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 977.82}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 116.87, ["Ride"] = 55.13, ["Fly|Ride"] = 90.44, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 4290.04}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.42, ["Fly"] = 72.05, ["Ride"] = 26.17, ["Fly|Ride"] = 60.38, ["Neon"] = 26.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 1430.75, ["Mega|Ride"] = 762.03, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.32, ["Fly"] = 2380.46, ["Ride"] = 1638, ["Fly|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 3609.36, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27431.25, ["Fly"] = 34405.84, ["Ride"] = 52500, ["Fly|Ride"] = 27037.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 74160.06, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 18.25, ["Fly"] = 393.75, ["Ride"] = 39.37, ["Fly|Ride"] = 128.14, ["Neon"] = 430.08, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 964.2, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1394.15}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 88.6, ["Ride"] = 43.32, ["Fly|Ride"] = 171.43, ["Neon"] = 17.99, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 193.6, ["Mega"] = 129.91, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.83}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.86, ["Ride"] = 36.75, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 299.24, ["Mega"] = 262.5, ["Mega|Ride"] = 419.35, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 838.65, ["Ride"] = 682.5, ["Fly|Ride"] = 787.49, ["Neon"] = 3085.24, ["Neon|Ride"] = 2574.03, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9581.79}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 814.78, ["Fly"] = 975.19, ["Ride"] = 888.64, ["Fly|Ride"] = 945, ["Neon"] = 4157.74, ["Neon|Ride"] = 3718.4, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 11708.45}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.97, ["Fly"] = 121.74, ["Ride"] = 29.97, ["Fly|Ride"] = 77.97, ["Neon"] = 78.74, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 214.15, ["Mega"] = 1204.13, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 24.94}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 68.25, ["Fly"] = 128.34, ["Ride"] = 82.64, ["Fly|Ride"] = 116.93, ["Neon"] = 420, ["Neon|Ride"] = 429.02, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 19687.5, ["Mega|Ride"] = 2099.98, ["Mega|Fly|Ride"] = 1962.19}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 80.84, ["Ride"] = 138.48, ["Fly|Ride"] = 157.5, ["Neon"] = 420, ["Neon|Ride"] = 551.29, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1395.76, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.19, ["Fly"] = 36.58, ["Ride"] = 22.99, ["Fly|Ride"] = 42.77, ["Neon"] = 45.94, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.65, ["Neon|Fly|Ride"] = 100.06, ["Mega|Fly|Ride"] = 664.29}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 134.95, ["Fly"] = 154.66, ["Ride"] = 149.6, ["Fly|Ride"] = 214.29, ["Neon"] = 612.84, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 578.82, ["Mega|Fly|Ride"] = 2338.09}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 2.1, ["Fly"] = 102.15, ["Ride"] = 47.07, ["Fly|Ride"] = 220.49, ["Neon"] = 32.27, ["Neon|Ride"] = 136.49, ["Neon|Fly|Ride"] = 210.33, ["Mega"] = 174.24, ["Mega|Ride"] = 470, ["Mega|Fly|Ride"] = 439.97}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.4, ["Fly"] = 41.66, ["Ride"] = 32.71, ["Fly|Ride"] = 79.86, ["Neon"] = 78.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 175.91, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 31.96, ["Ride"] = 60.29, ["Fly|Ride"] = 156.19, ["Neon"] = 210, ["Neon|Ride"] = 282.19, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 923.25}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 14.89, ["Fly"] = 210.3, ["Ride"] = 35.77, ["Fly|Ride"] = 64.53, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 243.48, ["Mega|Fly|Ride"] = 1092.9}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 8601.47, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.65, ["Neon"] = 35840.15, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 26167.03}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.14, ["Fly"] = 234.78, ["Ride"] = 243.54, ["Fly|Ride"] = 295.32, ["Neon|Fly|Ride"] = 558.6, ["Mega|Fly|Ride"] = 2263.7}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.88, ["Fly"] = 150.84, ["Ride"] = 93.98, ["Fly|Ride"] = 200.82, ["Neon"] = 141.74, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 415.44, ["Mega|Fly"] = 655.79, ["Mega|Ride"] = 425.25, ["Mega|Fly|Ride"] = 563.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 90.08, ["Ride"] = 27.5, ["Fly|Ride"] = 50.54, ["Neon"] = 22.32, ["Neon|Fly"] = 70.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 195.21, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 39.37, ["Fly"] = 5508.56, ["Ride"] = 102.38, ["Fly|Ride"] = 232.32, ["Neon"] = 196.87, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 387.16, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 628.74}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 11466.59, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 114401.04}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 265.13, ["Ride"] = 328.13, ["Fly|Ride"] = 355.89, ["Neon"] = 1629.99, ["Neon|Ride"] = 1430.75, ["Neon|Fly|Ride"] = 1623.8, ["Mega|Fly|Ride"] = 6421.11}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 49.9, ["Fly"] = 91.88, ["Ride"] = 61.02, ["Fly|Ride"] = 91.88, ["Neon"] = 408.58, ["Neon|Ride"] = 429.02, ["Neon|Fly|Ride"] = 446.18, ["Mega|Fly|Ride"] = 3308.69}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.19, ["Ride"] = 23.63, ["Fly|Ride"] = 65.63, ["Neon"] = 67.46, ["Neon|Fly"] = 276.4, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 643.52}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.08, ["Fly"] = 860.16, ["Ride"] = 393.74, ["Fly|Ride"] = 452.82, ["Neon"] = 1553.06, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1571.45, ["Mega|Fly|Ride"] = 5112.19}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 7.35, ["Fly"] = 104.12, ["Ride"] = 26.24, ["Fly|Ride"] = 138.8, ["Neon"] = 34.13, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 128.63, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 324.26, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 107.63, ["Fly"] = 208.61, ["Ride"] = 123.38, ["Fly|Ride"] = 211.73, ["Neon"] = 631.15, ["Neon|Fly"] = 525, ["Neon|Ride"] = 503.93, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 19.18, ["Ride"] = 23.66, ["Fly|Ride"] = 32.81, ["Neon"] = 163.16, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 2574.03, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.4}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 81.47, ["Ride"] = 78.75, ["Fly|Ride"] = 213.97, ["Neon"] = 393.53, ["Neon|Fly"] = 429.01, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 485.78, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1538.66}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 292.16, ["Ride"] = 33.08, ["Fly|Ride"] = 97.42, ["Neon"] = 107.62, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 185.74, ["Mega"] = 485.78, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 592.9}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.85}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 52.5, ["Fly"] = 144.09, ["Ride"] = 115.5, ["Fly|Ride"] = 282.19, ["Neon"] = 287.1, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1608.77, ["Mega|Ride"] = 1585.18, ["Mega|Fly|Ride"] = 1619.49}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.25, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 21, ["Neon|Ride"] = 114.17, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 123.5, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.67, ["Fly"] = 56.44, ["Ride"] = 28.84, ["Fly|Ride"] = 81.59, ["Neon"] = 163.16, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 213.45, ["Mega|Ride"] = 654.25, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 484.32, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 3217.54, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 33.77, ["Fly"] = 101.08, ["Ride"] = 57.59, ["Fly|Ride"] = 131.24, ["Neon"] = 236.22, ["Neon|Ride"] = 114.77, ["Neon|Fly|Ride"] = 326.21, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 810.03}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 61.3, ["Fly"] = 119.89, ["Ride"] = 70.87, ["Fly|Ride"] = 118.55, ["Neon"] = 237.63, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 945.96}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 21.44, ["Ride"] = 69.57, ["Fly|Ride"] = 120.91, ["Neon"] = 97.12, ["Neon|Ride"] = 177.13, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 433.02, ["Mega|Fly"] = 525, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 575.65}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26250, ["Ride"] = 8862, ["Fly|Ride"] = 8111.25, ["Neon|Fly|Ride"] = 15487.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1422.75, ["Fly"] = 1486.83, ["Ride"] = 1509.38, ["Fly|Ride"] = 1391.25, ["Neon|Ride"] = 5017.89, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 15487.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 674.16, ["Ride"] = 566.05, ["Fly|Ride"] = 538.13, ["Neon"] = 3655.63, ["Neon|Fly|Ride"] = 3217.54, ["Mega|Fly|Ride"] = 8582.21}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.92, ["Fly"] = 23.38, ["Ride"] = 21.42, ["Fly|Ride"] = 39.37, ["Neon"] = 65.76, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 567.15}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.93, ["Fly"] = 78.74, ["Ride"] = 31.05, ["Fly|Ride"] = 183.88, ["Neon"] = 27.57, ["Neon|Ride"] = 56, ["Mega"] = 131.06, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 37.21, ["Fly"] = 47.35, ["Ride"] = 44.96, ["Fly|Ride"] = 94.48, ["Neon"] = 547.91, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 173.81, ["Mega|Fly|Ride"] = 605.07}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 15.96, ["Fly|Ride"] = 37.75, ["Neon"] = 32.81, ["Neon|Fly"] = 122.58, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 87.26, ["Mega"] = 284.19, ["Mega|Ride"] = 645.6, ["Mega|Fly|Ride"] = 427.88}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 304.5, ["Fly"] = 369.5, ["Ride"] = 313.69, ["Fly|Ride"] = 362.24, ["Neon|Ride"] = 1228.27, ["Neon|Fly|Ride"] = 1777.91, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.48, ["Fly"] = 59.06, ["Ride"] = 30.94, ["Fly|Ride"] = 96.2, ["Neon"] = 208.95, ["Neon|Fly"] = 317.2, ["Neon|Ride"] = 141.6, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 858.02, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.77}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.81, ["Fly"] = 22.31, ["Ride"] = 18.38, ["Fly|Ride"] = 32.82, ["Neon"] = 144.09, ["Neon|Fly"] = 138.81, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 612.08, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 574.17, ["Fly"] = 1048.69, ["Ride"] = 537.6, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 2860.39, ["Mega|Fly|Ride"] = 12441.09}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1267.88, ["Ride"] = 1136.63, ["Fly|Ride"] = 1400.34, ["Neon"] = 5017.89, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13439.84}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.24, ["Fly"] = 170.63, ["Ride"] = 134.81, ["Fly|Ride"] = 111.56, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2571.89}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 172.48, ["Fly"] = 212.14, ["Ride"] = 190.31, ["Fly|Ride"] = 236.25, ["Neon"] = 872, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 595.42, ["Mega"] = 2717.74, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2891.21}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 40.05, ["Fly"] = 123.65, ["Ride"] = 32.7, ["Fly|Ride"] = 124.2, ["Neon"] = 236.24, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 1430.75, ["Mega|Fly|Ride"] = 1078.96}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 236.25, ["Ride"] = 315, ["Fly|Ride"] = 416.11, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1360.15, ["Mega|Fly|Ride"] = 6435.06}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2222.41, ["Ride"] = 1647.09, ["Fly|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 29955.73}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 215.06, ["Ride"] = 51.85, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 1430.75, ["Mega|Ride"] = 1144.38, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 661.49, ["Fly|Ride"] = 670.83, ["Neon|Fly|Ride"] = 1214.07, ["Mega|Fly|Ride"] = 3451.64}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42.84, ["Fly"] = 70.88, ["Ride"] = 48.57, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 238.04, ["Neon|Fly|Ride"] = 234.93, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 21, ["Fly|Ride"] = 55, ["Neon"] = 26.25, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 36.64, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 144.36, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 372.18}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.69, ["Ride"] = 128.34, ["Fly|Ride"] = 208.61, ["Neon"] = 259.67, ["Neon|Ride"] = 499.8, ["Neon|Fly|Ride"] = 715.38, ["Mega"] = 1568.02, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 741.12, ["Fly"] = 958.19, ["Ride"] = 879.25, ["Fly|Ride"] = 877.44, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2869.38, ["Mega|Fly|Ride"] = 11550}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 590.63, ["Ride"] = 726.84, ["Fly|Ride"] = 892.5, ["Neon"] = 11038.92, ["Neon|Fly|Ride"] = 4280.39, ["Mega|Fly|Ride"] = 15585.68}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.8, ["Fly"] = 26.25, ["Ride"] = 20.37, ["Fly|Ride"] = 38.82, ["Neon"] = 152.69, ["Neon|Ride"] = 127.64, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 810.03, ["Mega|Fly|Ride"] = 850.11}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 9.12, ["Ride"] = 27.54, ["Fly|Ride"] = 85.32, ["Neon"] = 143.49, ["Neon|Ride"] = 158.74, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 767.82, ["Mega|Ride"] = 429.02, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.19, ["Ride"] = 23.63, ["Fly|Ride"] = 102.27, ["Neon"] = 21.46, ["Neon|Fly"] = 321.61, ["Neon|Ride"] = 61.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.06, ["Mega|Fly"] = 551.35, ["Mega|Ride"] = 285.85, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.03, ["Fly"] = 45.84, ["Ride"] = 45.05, ["Fly|Ride"] = 111.56, ["Neon"] = 240.63, ["Neon|Ride"] = 286.38, ["Neon|Fly|Ride"] = 233.05, ["Mega|Fly|Ride"] = 1287.02}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.51, ["Ride"] = 118.13, ["Fly|Ride"] = 574.17, ["Neon"] = 437.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1608.77, ["Mega|Fly|Ride"] = 1606.62}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.12, ["Fly"] = 43.32, ["Ride"] = 28.93, ["Fly|Ride"] = 79.25, ["Neon"] = 72.19, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 986.72, ["Mega|Ride"] = 395.78, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 39.38, ["Fly"] = 65.63, ["Ride"] = 42.69, ["Fly|Ride"] = 77.44, ["Neon"] = 242.82, ["Neon|Fly"] = 1434.32, ["Neon|Ride"] = 196.76, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.59}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 18.23, ["Fly|Ride"] = 31.49, ["Neon"] = 27.57, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 750.78, ["Mega|Ride"] = 485.78, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.87, ["Fly"] = 49.37, ["Ride"] = 36.58, ["Fly|Ride"] = 61.69, ["Neon"] = 52.37, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 79.96, ["Neon|Fly|Ride"] = 179.74, ["Mega"] = 320.7, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 63.67, ["Fly"] = 56.18, ["Ride"] = 56.44, ["Fly|Ride"] = 94.5, ["Neon"] = 578.44, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 254.5, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1640.63, ["Fly"] = 1652.44, ["Ride"] = 1451.97, ["Fly|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 3567.56}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 650.02, ["Ride"] = 446.25, ["Fly|Ride"] = 478.96, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 275.62, ["Ride"] = 315, ["Fly|Ride"] = 404.25, ["Neon"] = 1181.25, ["Neon|Ride"] = 1501.53, ["Neon|Fly|Ride"] = 1697.79, ["Mega|Fly|Ride"] = 7644}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.93, ["Ride"] = 51.08, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 1572.31, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 37273.36, ["Fly"] = 23654.02, ["Ride"] = 24349.54, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.5, ["Mega"] = 214501.27, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 315, ["Fly"] = 328.13, ["Ride"] = 301.87, ["Fly|Ride"] = 301.88, ["Neon"] = 1115.63, ["Neon|Fly"] = 1090.25, ["Neon|Ride"] = 883.58, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 4290.04, ["Mega|Ride"] = 4288.96, ["Mega|Fly|Ride"] = 3361.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Fly"] = 525, ["Ride"] = 213.97, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1781.54}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 152.84, ["Fly"] = 287.1, ["Ride"] = 144.09, ["Fly|Ride"] = 257.04, ["Neon"] = 752.64, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.6, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 126, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 726.23, ["Mega|Ride"] = 715.38, ["Mega|Fly|Ride"] = 1001.74}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3701.25, ["Ride"] = 3937.5, ["Fly|Ride"] = 3937.5, ["Neon"] = 27954.74, ["Neon|Fly|Ride"] = 17447.55}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 36.58, ["Fly"] = 64.25, ["Ride"] = 34.1, ["Fly|Ride"] = 54.41, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 193.55, ["Mega|Ride"] = 1430.75, ["Mega|Fly|Ride"] = 729.31}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.24, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 96.56, ["Neon"] = 314.26, ["Neon|Fly"] = 1434.32, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.47, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 517.13, ["Fly"] = 656.25, ["Ride"] = 525, ["Fly|Ride"] = 630, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 6133.67}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.3, ["Fly"] = 26.25, ["Ride"] = 22.21, ["Fly|Ride"] = 40.65, ["Neon"] = 118.12, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 141.73, ["Mega|Ride"] = 787.24, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.79, ["Ride"] = 27.57, ["Fly|Ride"] = 80.15, ["Neon"] = 95.82, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 206.98, ["Mega|Ride"] = 752.95}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.41, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 752.64, ["Neon|Ride"] = 766.75, ["Neon|Fly|Ride"] = 1134.28, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.74, ["Fly"] = 128.09, ["Ride"] = 68.88, ["Fly|Ride"] = 131.25, ["Neon"] = 78.75, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 115.37, ["Neon|Fly|Ride"] = 227.11, ["Mega"] = 332.07, ["Mega|Fly"] = 739.46, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 424.77}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Fly"] = 6329.64, ["Ride"] = 3883.66, ["Fly|Ride"] = 4181.63, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42899.2, ["Mega|Fly|Ride"] = 36917.91}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 31.5, ["Fly"] = 143.09, ["Ride"] = 65.64, ["Fly|Ride"] = 130.29, ["Neon"] = 399.26, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 574.23, ["Mega"] = 787.24, ["Mega|Ride"] = 1781.54, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7612.5, ["Fly"] = 8888.55, ["Ride"] = 6857.82, ["Fly|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 17181.94, ["Mega|Fly|Ride"] = 62920.75}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 23.55, ["Ride"] = 15.62, ["Fly|Ride"] = 36.21, ["Neon"] = 24.62, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 244.55, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 358.24}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.88, ["Fly"] = 28.88, ["Ride"] = 32.46, ["Fly|Ride"] = 56.44, ["Neon"] = 187.1, ["Neon|Fly"] = 237.63, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 159.83, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 929.88}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.64, ["Ride"] = 34.13, ["Fly|Ride"] = 116.02, ["Neon"] = 94.5, ["Neon|Ride"] = 98.49, ["Mega"] = 1050, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 1295.79}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.93, ["Fly"] = 190.37, ["Ride"] = 36.75, ["Fly|Ride"] = 99.73, ["Neon"] = 203.44, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 945, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.87, ["Fly"] = 22.89, ["Ride"] = 20.99, ["Fly|Ride"] = 28.01, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2574.03, ["Mega|Ride"] = 606, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8745.55}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.39}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233.31, ["Ride"] = 394.61, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.26, ["Fly"] = 130.25, ["Ride"] = 37.46, ["Fly|Ride"] = 128.4, ["Neon"] = 122.58, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.84}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.49, ["Fly"] = 32.82, ["Ride"] = 31.5, ["Fly|Ride"] = 86.03, ["Neon|Ride"] = 249.38}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2758.93}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 196.88, ["Ride"] = 215.25, ["Fly|Ride"] = 287.1, ["Neon"] = 975.21, ["Neon|Ride"] = 830.13, ["Neon|Fly|Ride"] = 1573.38, ["Mega|Ride"] = 4147.4, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 74.79, ["Ride"] = 125.3, ["Fly|Ride"] = 215.06, ["Neon"] = 789.2, ["Neon|Ride"] = 599.54, ["Neon|Fly|Ride"] = 648.51, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.49, ["Fly"] = 315, ["Ride"] = 168, ["Fly|Ride"] = 213.54, ["Neon"] = 944.98, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3258.94, ["Mega|Fly|Ride"] = 4104.5}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3297.59, ["Ride"] = 2100.02, ["Fly|Ride"] = 2270.63, ["Neon"] = 15102.02, ["Neon|Ride"] = 8921.13, ["Neon|Fly|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 25265.63}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 20.34, ["Fly"] = 72.05, ["Ride"] = 57.75, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Ride"] = 200.58, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 964.2, ["Mega|Ride"] = 1092.98, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 721.88, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 4147.4, ["Neon|Fly|Ride"] = 4210.36, ["Mega|Fly|Ride"] = 17001.68}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.98}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14, ["Ride"] = 51.97, ["Fly|Ride"] = 343.37, ["Neon"] = 81.29, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 257.41, ["Mega"] = 424.12, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 506.33}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.24, ["Fly"] = 262.5, ["Ride"] = 27.45, ["Fly|Ride"] = 106.46, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 48.59, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 454.2, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 55.11}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.48, ["Fly"] = 104.62, ["Ride"] = 36.75, ["Fly|Ride"] = 83.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 1859.74}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23, ["Fly"] = 39.37, ["Ride"] = 26.25, ["Fly|Ride"] = 52.41, ["Neon|Ride"] = 514.92, ["Neon|Fly|Ride"] = 336, ["Mega|Ride"] = 1821.62, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6666.15, ["Fly|Ride"] = 4760.21, ["Neon|Fly|Ride"] = 12468.3, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.76, ["Fly"] = 65.63, ["Ride"] = 34.12, ["Fly|Ride"] = 81.37, ["Neon"] = 43.21, ["Neon|Fly"] = 144.09, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 227.11, ["Mega"] = 514.82, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 533.29}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.57}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 101.34, ["Fly"] = 380.63, ["Ride"] = 137.71, ["Fly|Ride"] = 149.1, ["Neon"] = 525, ["Neon|Ride"] = 430.82, ["Neon|Fly|Ride"] = 755.06, ["Mega|Fly|Ride"] = 2148.13}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 44.63, ["Fly"] = 140.91, ["Ride"] = 74.34, ["Fly|Ride"] = 189.31, ["Neon"] = 291.38, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2428.82, ["Mega|Ride"] = 2895.79, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.31, ["Fly"] = 70.47, ["Ride"] = 26.23, ["Fly|Ride"] = 59.75, ["Neon"] = 116.82, ["Neon|Fly"] = 232.26, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 199.38, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.04, ["Fly"] = 41.24, ["Ride"] = 23.08, ["Fly|Ride"] = 48.64, ["Neon"] = 32.79, ["Neon|Ride"] = 58.08, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 163.96, ["Mega|Fly"] = 7150.41, ["Mega|Ride"] = 196.47, ["Mega|Fly|Ride"] = 272.79}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.73, ["Fly"] = 72.05, ["Ride"] = 28.92, ["Fly|Ride"] = 94.5, ["Neon"] = 91.49, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 430.5, ["Mega|Ride"] = 648.51, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.4, ["Fly"] = 31.61, ["Ride"] = 24.65, ["Fly|Ride"] = 47.86, ["Neon"] = 373.1, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 141.48, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 216.57}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 25.82, ["Ride"] = 131.21, ["Fly|Ride"] = 287.1, ["Neon"] = 172.05, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 587.75, ["Mega"] = 708.75, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.22, ["Ride"] = 695.63, ["Fly|Ride"] = 3869.6, ["Neon|Fly|Ride"] = 28600.55}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.99, ["Fly"] = 212.52, ["Ride"] = 86.51, ["Fly|Ride"] = 249.45, ["Neon"] = 315, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 984.38, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1144.2}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.17, ["Fly"] = 1362.27, ["Ride"] = 984.38, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4292.94, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 388.5, ["Fly"] = 717.17, ["Ride"] = 380.62, ["Fly|Ride"] = 467.98, ["Neon"] = 2139.38, ["Neon|Ride"] = 2437.45, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 8580.07, ["Mega|Ride"] = 8580.07, ["Mega|Fly|Ride"] = 8580.07}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.1, ["Fly"] = 23, ["Ride"] = 24.31, ["Fly|Ride"] = 51.18, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.34, ["Neon|Fly|Ride"] = 143.05, ["Mega"] = 437.26, ["Mega|Ride"] = 715.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 255.84, ["Fly"] = 392.03, ["Ride"] = 278.25, ["Fly|Ride"] = 358.12, ["Neon"] = 1139.71, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 3398.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 115.06, ["Ride"] = 191.39, ["Fly|Ride"] = 262.5, ["Neon"] = 551.15, ["Neon|Ride"] = 750.52, ["Neon|Fly|Ride"] = 728.44, ["Mega"] = 2231.43, ["Mega|Ride"] = 12200.85, ["Mega|Fly|Ride"] = 2090.71}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 111.56, ["Fly"] = 215.06, ["Ride"] = 128.77, ["Fly|Ride"] = 215.06, ["Neon"] = 1147.23, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 2359.52, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2574.03}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.68, ["Ride"] = 29.05, ["Fly|Ride"] = 175.27, ["Neon"] = 39.37, ["Neon|Ride"] = 87.67, ["Neon|Fly|Ride"] = 242.41, ["Mega"] = 264.75, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 856.95}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.43, ["Fly"] = 64.53, ["Ride"] = 23.63, ["Fly|Ride"] = 78.64, ["Neon"] = 177.19, ["Neon|Ride"] = 150.17, ["Neon|Fly|Ride"] = 242.9, ["Mega|Ride"] = 1430.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.07, ["Fly"] = 102.36, ["Ride"] = 35.44, ["Fly|Ride"] = 104.61, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.65, ["Fly"] = 72.05, ["Ride"] = 53.8, ["Fly|Ride"] = 159.14, ["Neon"] = 22.88, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 139.1, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 261.19, ["Ride"] = 290.05, ["Fly|Ride"] = 365.19, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6292.41}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 111.2, ["Fly"] = 570.27, ["Ride"] = 141.74, ["Fly|Ride"] = 241.5, ["Neon"] = 525, ["Neon|Ride"] = 459.36, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 2589.04}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.57, ["Fly"] = 167.45, ["Ride"] = 67.35, ["Fly|Ride"] = 131.25, ["Neon"] = 380.63, ["Neon|Ride"] = 543.38, ["Neon|Fly|Ride"] = 408.19, ["Mega|Fly|Ride"] = 1801.14}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 18.27, ["Fly"] = 78.75, ["Ride"] = 29.05, ["Fly|Ride"] = 287.1, ["Neon"] = 115.5, ["Neon|Ride"] = 616.93}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.08, ["Fly"] = 42.42, ["Ride"] = 32.82, ["Fly|Ride"] = 93.19, ["Neon"] = 77.43, ["Neon|Ride"] = 109.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 379.68, ["Mega|Fly"] = 525, ["Mega|Ride"] = 485.78, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.33, ["Fly"] = 52.46, ["Ride"] = 19.69, ["Fly|Ride"] = 50.54, ["Neon"] = 20.78, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 51.39, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 139.12, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1111.76, ["Fly"] = 1082.72, ["Ride"] = 918.74, ["Fly|Ride"] = 968.62, ["Neon"] = 4157.74, ["Neon|Ride"] = 3154.6, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10010.79}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 354.82, ["Fly"] = 424.71, ["Ride"] = 321.11, ["Fly|Ride"] = 393.75, ["Neon"] = 1277.38, ["Neon|Ride"] = 1505.88, ["Neon|Fly|Ride"] = 1688.14, ["Mega"] = 10725.07, ["Mega|Fly|Ride"] = 6006.06}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.64, ["Fly"] = 172.05, ["Ride"] = 104.69, ["Fly|Ride"] = 189.25, ["Neon"] = 330.09, ["Neon|Ride"] = 326.31, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 1620.03}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 275.63, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 26.25, ["Fly"] = 52.5, ["Ride"] = 26.24, ["Fly|Ride"] = 72.18, ["Neon"] = 169.32, ["Neon|Ride"] = 173.63, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 184.62, ["Ride"] = 228.38, ["Fly|Ride"] = 465.67, ["Neon"] = 786.19, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.75, ["Mega|Ride"] = 4719.04, ["Mega|Fly|Ride"] = 4346.89}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 63.66, ["Fly"] = 125.98, ["Ride"] = 77.79, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 572.74, ["Neon|Fly|Ride"] = 572.74, ["Mega|Fly|Ride"] = 1573.38}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1968.75, ["Ride"] = 2191.88, ["Fly|Ride"] = 2021.14, ["Neon|Ride"] = 11335.27, ["Neon|Fly|Ride"] = 7875, ["Mega"] = 51480.32, ["Mega|Fly|Ride"] = 25168.53}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 20.99, ["Fly"] = 77.25, ["Ride"] = 60.36, ["Fly|Ride"] = 52.5, ["Neon"] = 70.85, ["Neon|Fly"] = 237.57, ["Neon|Ride"] = 109.72, ["Neon|Fly|Ride"] = 211.32, ["Mega"] = 494.82, ["Mega|Fly"] = 561.43, ["Mega|Ride"] = 319.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 45.94, ["Ride"] = 83.98, ["Fly|Ride"] = 140.86, ["Neon"] = 223.13, ["Neon|Ride"] = 382.56, ["Neon|Fly|Ride"] = 572.74, ["Mega"] = 2145.03, ["Mega|Fly|Ride"] = 2690.63}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.85, ["Ride"] = 72.19, ["Fly|Ride"] = 90.84, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.81}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2759.49, ["Fly"] = 1623.81, ["Ride"] = 1048.69, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5181.87, ["Neon|Fly|Ride"] = 5829.15, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 485.63, ["Fly"] = 525, ["Ride"] = 752.64, ["Fly|Ride"] = 619.33, ["Neon|Fly|Ride"] = 3238.82}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 77.7, ["Fly"] = 170.63, ["Ride"] = 99.73, ["Fly|Ride"] = 131.25, ["Neon"] = 444.94, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1716.02, ["Mega|Fly|Ride"] = 1773.94}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.18, ["Ride"] = 22.45, ["Fly|Ride"] = 61.64, ["Neon"] = 86.63, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 603.75, ["Mega|Ride"] = 776.5}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 45.94, ["Fly"] = 68.25, ["Ride"] = 55.13, ["Fly|Ride"] = 107.54, ["Neon"] = 284.82, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 222.25, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 1115.63, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1119.87, ["Ride"] = 734.98, ["Fly|Ride"] = 832.11, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.94}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 7010.2, ["Fly|Ride"] = 6222.49, ["Neon"] = 42000, ["Neon|Ride"] = 30739.12, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 80080.84}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 274.16, ["Fly"] = 400.39, ["Ride"] = 328.13, ["Neon"] = 1720.31, ["Neon|Fly|Ride"] = 2231.25, ["Mega"] = 6433.98, ["Mega|Fly|Ride"] = 6800.69}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.66, ["Fly"] = 287.1, ["Ride"] = 122.05, ["Fly|Ride"] = 336, ["Neon"] = 574.17, ["Neon|Ride"] = 672.48, ["Neon|Fly|Ride"] = 637.88, ["Mega|Fly|Ride"] = 2200.62}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.31, ["Fly"] = 42.09, ["Ride"] = 30.18, ["Fly|Ride"] = 76.35, ["Neon"] = 153.79, ["Neon|Fly"] = 1299.13, ["Neon|Ride"] = 116.85, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 999.59, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 648.51}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.44, ["Fly"] = 26.25, ["Ride"] = 22.99, ["Fly|Ride"] = 46.68, ["Neon"] = 215.06, ["Neon|Ride"] = 324.26, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2288.74}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.43, ["Fly"] = 287.1, ["Ride"] = 26.25, ["Fly|Ride"] = 111.84, ["Neon"] = 112.22, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 645.75, ["Mega|Ride"] = 513.74, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.91, ["Fly"] = 79.58, ["Ride"] = 22.32, ["Fly|Ride"] = 48.57, ["Neon"] = 35.44, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 114.17, ["Mega"] = 321.78, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 324.26}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.46, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 139.13, ["Neon"] = 170.97, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 194.32, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 628.69, ["Mega|Ride"] = 1260}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 469.16, ["Fly"] = 465.94, ["Ride"] = 478.95, ["Fly|Ride"] = 511.88, ["Neon"] = 1948.07, ["Neon|Ride"] = 1495.09, ["Neon|Fly|Ride"] = 1378.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5148.04}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 21.52, ["Ride"] = 17.05, ["Fly|Ride"] = 27.98, ["Neon"] = 19.59, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 231.68, ["Mega|Ride"] = 227.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.38, ["Fly"] = 98.43, ["Ride"] = 79.82, ["Fly|Ride"] = 142.63, ["Neon"] = 172.05, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 208.68, ["Neon|Fly|Ride"] = 262.01, ["Mega"] = 495.71, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.06, ["Ride"] = 763.88, ["Fly|Ride"] = 843.28, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1704.93, ["Mega|Fly|Ride"] = 3936.19}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.46, ["Fly"] = 90.56, ["Ride"] = 44.48, ["Fly|Ride"] = 89.25, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.89, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 357, ["Fly"] = 455.26, ["Ride"] = 290.97, ["Fly|Ride"] = 334.69, ["Neon|Fly|Ride"] = 1358.88}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 181.92, ["Fly"] = 178.47, ["Ride"] = 196.88, ["Fly|Ride"] = 236.23, ["Neon"] = 1004.24, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 858.02, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3561.8}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 860.16, ["Ride"] = 754.69, ["Fly|Ride"] = 813.65, ["Neon|Ride"] = 2995.95, ["Neon|Fly|Ride"] = 3053.03, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 20.26, ["Fly"] = 86.03, ["Ride"] = 42.67, ["Fly|Ride"] = 110.25, ["Neon"] = 87.94, ["Neon|Fly"] = 292.22, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 190.93, ["Mega"] = 354.38, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3936.19, ["Fly|Ride"] = 3087.33, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 106.32, ["Fly"] = 137.82, ["Ride"] = 137.23, ["Fly|Ride"] = 207.9, ["Neon"] = 459.37, ["Neon|Fly"] = 574.17, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2739.2}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 16.37, ["Fly|Ride"] = 38.53, ["Neon"] = 23.63, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 149.3, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 372.18, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.12, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 21, ["Neon|Fly"] = 119.34, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 162.74, ["Mega"] = 141.4, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 415.08}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 43.19, ["Fly"] = 38.45, ["Ride"] = 38.72, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 306.05, ["Mega|Fly|Ride"] = 1072.53}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.37, ["Ride"] = 1050, ["Fly|Ride"] = 1110.38}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.97, ["Fly"] = 44.63, ["Ride"] = 25.86, ["Fly|Ride"] = 41.99, ["Neon"] = 452.13, ["Neon|Ride"] = 158.74, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.57, ["Ride"] = 28.82, ["Fly|Ride"] = 78.75, ["Neon"] = 69.24, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 143.73, ["Mega"] = 936.32, ["Mega|Ride"] = 619.92, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 79.25, ["Fly"] = 157.5, ["Ride"] = 85.19, ["Fly|Ride"] = 128.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 452.82, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 228.32, ["Ride"] = 212.96, ["Fly|Ride"] = 336, ["Neon|Ride"] = 1058.03, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4535.82}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 32.79, ["Fly|Ride"] = 93.09, ["Neon"] = 19.66, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 50.43, ["Mega"] = 160.13, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 1428.59}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 179.81, ["Fly"] = 231.7, ["Ride"] = 207.17, ["Fly|Ride"] = 311.07, ["Neon"] = 1073.87, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 843.94, ["Mega"] = 3288.32, ["Mega|Fly|Ride"] = 3538.21}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 43.02, ["Ride"] = 16.54, ["Fly|Ride"] = 102.29, ["Neon"] = 23.49, ["Neon|Fly"] = 129.04, ["Neon|Ride"] = 28.92, ["Neon|Fly|Ride"] = 104.41, ["Mega"] = 225.75, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 217.88, ["Fly"] = 346.22, ["Ride"] = 223.13, ["Fly|Ride"] = 249.38, ["Neon|Ride"] = 1217.54, ["Neon|Fly|Ride"] = 744.5, ["Mega"] = 10725.07, ["Mega|Fly|Ride"] = 5506.12}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.37, ["Fly"] = 85.32, ["Ride"] = 28.28, ["Fly|Ride"] = 68.25, ["Neon"] = 97.42, ["Neon|Fly"] = 309.27, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 596.29, ["Mega|Ride"] = 480.5, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 72.05, ["Ride"] = 24.36, ["Fly|Ride"] = 72.19, ["Neon"] = 8.87, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 141.59, ["Mega"] = 78.59, ["Mega|Ride"] = 106.47, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.5, ["Neon"] = 3.88, ["Mega"] = 16.04, ["Mega|Ride"] = 145.74, ["Mega|Fly|Ride"] = 321.78}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 34.69, ["Fly|Ride"] = 110.76, ["Neon"] = 4.88, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 72.57, ["Mega|Fly"] = 161921.43, ["Mega|Ride"] = 109.31, ["Mega|Fly|Ride"] = 205.3}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.98, ["Fly"] = 525, ["Ride"] = 102.81, ["Fly|Ride"] = 196.54, ["Neon"] = 308.44, ["Neon|Fly"] = 408.58, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1048.59}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 12.92, ["Ride"] = 15.74, ["Fly|Ride"] = 78.75, ["Neon"] = 9.18, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 97.16, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.48, ["Neon"] = 78.61, ["Neon|Ride"] = 250.18, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.74, ["Mega|Ride"] = 572.74}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 1.79, ["Ride"] = 56.8, ["Neon"] = 2.52, ["Neon|Ride"] = 53.01, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 15.74, ["Mega|Fly"] = 83.67, ["Mega|Ride"] = 49.79, ["Mega|Fly|Ride"] = 321.78}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 64.96, ["Ride"] = 15.75, ["Fly|Ride"] = 24.92, ["Neon"] = 2.1, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 13.17, ["Neon|Fly|Ride"] = 27.74, ["Mega"] = 12.89, ["Mega|Fly"] = 42.91, ["Mega|Ride"] = 20.51, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 1.79, ["Fly"] = 19.57, ["Ride"] = 15.16, ["Fly|Ride"] = 64.79, ["Neon"] = 2.1, ["Neon|Fly"] = 38.18, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 19.68, ["Mega|Fly"] = 162.74, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 1.79, ["Neon"] = 2.1, ["Neon|Ride"] = 63.58, ["Mega"] = 18.38, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 31.59, ["Fly|Ride"] = 107.62, ["Neon"] = 2.1, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.66, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.81, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 406.39, ["Mega"] = 15.73, ["Mega|Fly"] = 128.71, ["Mega|Ride"] = 46.15}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 77.24, ["Ride"] = 32.79, ["Fly|Ride"] = 48.62, ["Neon"] = 17.53, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 148.21, ["Mega|Fly"] = 276.33, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 246.65}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 1.79, ["Ride"] = 27.98, ["Neon"] = 2.37, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 315, ["Mega"] = 15.28, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Ride"] = 144.47, ["Fly|Ride"] = 525, ["Neon"] = 18.13, ["Mega"] = 162.74, ["Mega|Fly"] = 315, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.93, ["Mega"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 572.74}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Ride"] = 32.81, ["Neon"] = 3.93, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 20.99, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.23}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 1.79, ["Fly"] = 19.36, ["Ride"] = 14.31, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 14.48, ["Neon|Fly|Ride"] = 33.77, ["Mega"] = 14.9, ["Mega|Fly"] = 28.93, ["Mega|Ride"] = 19.65, ["Mega|Fly|Ride"] = 70.69}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.35, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 40.48, ["Mega"] = 193.07, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 1.79, ["Fly"] = 32.82, ["Ride"] = 27.85, ["Neon"] = 3.88, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 65.42, ["Mega|Ride"] = 45.86, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 12.75, ["Mega"] = 86.51, ["Mega|Ride"] = 163.04, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 59.07, ["Neon"] = 23.63, ["Neon|Ride"] = 50.43, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.68, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 194.32}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 1.79, ["Fly"] = 20.44, ["Ride"] = 11.79, ["Fly|Ride"] = 28.2, ["Neon"] = 2.1, ["Neon|Fly"] = 15.61, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 37.37, ["Mega"] = 19.68, ["Mega|Fly"] = 26.16, ["Mega|Ride"] = 24.74, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 27.4, ["Fly|Ride"] = 131.25, ["Neon"] = 9.84, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 115.06, ["Ride"] = 27.56, ["Fly|Ride"] = 59.06, ["Neon"] = 42.58, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 261.19, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.34, ["Ride"] = 13.71, ["Fly|Ride"] = 36.75, ["Neon"] = 2.37, ["Neon|Fly"] = 17.21, ["Neon|Ride"] = 14.7, ["Neon|Fly|Ride"] = 51.09, ["Mega"] = 19.81, ["Mega|Ride"] = 31.49, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 179.58, ["Ride"] = 31.5, ["Neon"] = 5.51, ["Neon|Ride"] = 36.47, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 63.95, ["Mega|Fly"] = 171.62, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Neon"] = 5.2, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 324.35, ["Mega"] = 34.12, ["Mega|Fly"] = 143.73, ["Mega|Ride"] = 72.1, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 1.79, ["Fly"] = 36.58, ["Ride"] = 18.27, ["Neon"] = 2.1, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 12.88, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 28.76, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 72.05, ["Ride"] = 14.33, ["Fly|Ride"] = 46.54, ["Neon"] = 4.47, ["Neon|Fly"] = 53.64, ["Neon|Ride"] = 21.42, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 143.48, ["Mega|Ride"] = 87.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 56.6, ["Neon"] = 4.19, ["Neon|Ride"] = 63.3, ["Mega"] = 33.97, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.66, ["Ride"] = 14.78, ["Fly|Ride"] = 47.32, ["Neon"] = 4.69, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 20.47, ["Neon|Fly|Ride"] = 64.97, ["Mega"] = 103.69, ["Mega|Ride"] = 90.55, ["Mega|Fly|Ride"] = 119.69}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 36.58, ["Fly|Ride"] = 50.05, ["Neon"] = 30.48, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 14.43, ["Fly|Ride"] = 57.48, ["Neon"] = 11.64, ["Neon|Fly"] = 48.72, ["Neon|Ride"] = 30.57, ["Neon|Fly|Ride"] = 70.76, ["Mega"] = 263.82, ["Mega|Fly"] = 420, ["Mega|Ride"] = 125.78, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 144.66, ["Ride"] = 16.95, ["Fly|Ride"] = 52.5, ["Neon"] = 34.12, ["Neon|Fly"] = 84, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 168, ["Mega|Fly"] = 161.95, ["Mega|Ride"] = 429.02, ["Mega|Fly|Ride"] = 177.17}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.65, ["Fly|Ride"] = 144.09, ["Neon"] = 26.25, ["Neon|Ride"] = 105.67, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 172.44, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.76, ["Ride"] = 56.44, ["Neon"] = 172.05, ["Mega"] = 572.74, ["Mega|Ride"] = 714.26, ["Mega|Fly|Ride"] = 814.05}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 51.36, ["Neon"] = 45.83, ["Neon|Ride"] = 106.55, ["Mega"] = 237.57, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.24, ["Ride"] = 31.39, ["Fly|Ride"] = 120.75, ["Neon"] = 65.63, ["Neon|Ride"] = 91.87, ["Mega"] = 485.78, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 364.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 65, ["Mega"] = 32.46, ["Mega|Ride"] = 128.71, ["Mega|Fly|Ride"] = 191.99}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 44.91}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.93, ["Fly"] = 23.61, ["Ride"] = 18.14, ["Fly|Ride"] = 43.31, ["Neon"] = 50.54, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 47.65, ["Neon|Fly|Ride"] = 78.64, ["Mega"] = 271.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 14.75, ["Fly|Ride"] = 86.63, ["Neon"] = 5.25, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.42, ["Neon|Fly|Ride"] = 160.32, ["Mega"] = 26.25, ["Mega|Fly"] = 143.73, ["Mega|Ride"] = 71.87, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 1.79, ["Ride"] = 28.88, ["Neon"] = 3.45, ["Neon|Ride"] = 35.21, ["Mega"] = 37.97, ["Mega|Ride"] = 214.52, ["Mega|Fly|Ride"] = 136.23}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.75, ["Fly|Ride"] = 42.83, ["Neon"] = 7.75, ["Neon|Ride"] = 57.75, ["Mega"] = 141.75, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 195.21}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.02, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 36.51, ["Neon|Ride"] = 50.43, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 262.5, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 321.78}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 2.37, ["Mega"] = 20.14, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 62.01, ["Mega|Fly|Ride"] = 119.89}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 14.44, ["Fly|Ride"] = 58.97, ["Neon"] = 2.67, ["Neon|Fly"] = 111.47, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 100.84, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.29, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 16.14, ["Fly|Ride"] = 36.58, ["Neon"] = 5.01, ["Neon|Fly"] = 93.76, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 47.95, ["Mega|Fly"] = 143.73, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 54.62, ["Fly|Ride"] = 115.5, ["Neon"] = 8.6, ["Neon|Ride"] = 33.13, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 49.87, ["Mega|Ride"] = 81.67, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.11, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 156414.11, ["Mega"] = 24.99, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 75.31, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.89, ["Ride"] = 16.4, ["Fly|Ride"] = 81.74, ["Neon"] = 3.92, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.71, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.82, ["Mega|Fly"] = 64.37, ["Mega|Ride"] = 40.63, ["Mega|Fly|Ride"] = 105.67}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 1.79, ["Neon"] = 2.63, ["Neon|Ride"] = 40.78, ["Mega"] = 19.69, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 272.44}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.05, ["Neon"] = 3.83, ["Neon|Ride"] = 324.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.73, ["Mega|Ride"] = 171.62}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 1.79, ["Fly"] = 26.25, ["Ride"] = 14.43, ["Fly|Ride"] = 49.88, ["Neon"] = 3.94, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 48.39, ["Mega"] = 41.28, ["Mega|Fly"] = 45.24, ["Mega|Ride"] = 107.27, ["Mega|Fly|Ride"] = 107.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.09, ["Fly"] = 39.38, ["Ride"] = 59.06, ["Fly|Ride"] = 215.06, ["Neon"] = 105.39, ["Mega"] = 569.51, ["Mega|Ride"] = 467.25, ["Mega|Fly|Ride"] = 715.38}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.78, ["Neon"] = 45.93, ["Neon|Ride"] = 212.38, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.5, ["Fly|Ride"] = 178.76, ["Neon"] = 26.24, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 429.02, ["Mega"] = 250.08, ["Mega|Ride"] = 428.3, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.79, ["Fly"] = 14.95, ["Ride"] = 11.82, ["Fly|Ride"] = 23.09, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 14.42, ["Neon|Fly|Ride"] = 29.03, ["Mega"] = 12.33, ["Mega|Fly"] = 28.88, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 41.54}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.23, ["Neon"] = 6.57, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 33.27, ["Neon|Fly|Ride"] = 715.38, ["Mega"] = 71.76, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 1.79, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.43, ["Mega|Ride"] = 71.67, ["Mega|Fly|Ride"] = 128.71}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 1.79, ["Neon"] = 3.28, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 18.26, ["Mega|Fly|Ride"] = 314.98}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 16.05, ["Fly|Ride"] = 47.25, ["Neon"] = 11.24, ["Neon|Ride"] = 37.69, ["Neon|Fly|Ride"] = 75.8, ["Mega"] = 170.62, ["Mega|Ride"] = 407.56, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.06, ["Ride"] = 168.25, ["Fly|Ride"] = 413.98, ["Neon|Fly|Ride"] = 994.23, ["Mega"] = 8580.07, ["Mega|Ride"] = 3289.39, ["Mega|Fly|Ride"] = 4050.05}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.36, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 184.49, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.83, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 61.46, ["Neon"] = 31.11, ["Neon|Ride"] = 170.83, ["Neon|Fly|Ride"] = 143.73, ["Mega"] = 381.82, ["Mega|Ride"] = 535.2, ["Mega|Fly|Ride"] = 648.51}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 15.26, ["Fly|Ride"] = 26.25, ["Neon"] = 4.89, ["Neon|Fly"] = 33.35, ["Neon|Ride"] = 29.77, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 49.76, ["Mega|Ride"] = 82.6, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.05, ["Ride"] = 18.13, ["Fly|Ride"] = 92.58, ["Neon"] = 7.07, ["Neon|Fly"] = 574.17, ["Neon|Ride"] = 56.72, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 194.32, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 25.1, ["Ride"] = 15.65, ["Fly|Ride"] = 37.9, ["Neon"] = 23.63, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 242.9}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 29.05, ["Fly|Ride"] = 259.01, ["Neon"] = 44.27, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.48, ["Mega|Ride"] = 300.48, ["Mega|Fly|Ride"] = 366.81}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.59, ["Fly|Ride"] = 36.22, ["Neon"] = 23.78, ["Neon|Fly"] = 68.24, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 74.01, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 52.87, ["Ride"] = 85.32, ["Fly|Ride"] = 140.63, ["Neon"] = 341.23, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 378.12, ["Mega|Fly|Ride"] = 1430.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 209.99, ["Fly"] = 430.08, ["Ride"] = 249.23, ["Fly|Ride"] = 295.32, ["Neon"] = 1137.2, ["Neon|Ride"] = 1144.38, ["Neon|Fly|Ride"] = 953.71, ["Mega"] = 10725.07, ["Mega|Fly|Ride"] = 5002.18}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.27, ["Fly"] = 124.73, ["Ride"] = 74.01, ["Fly|Ride"] = 102.38, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 343.22, ["Mega|Ride"] = 1374.97, ["Mega|Fly|Ride"] = 1856.76}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.73, ["Fly"] = 288.3, ["Ride"] = 32.82, ["Fly|Ride"] = 70.97, ["Neon"] = 35.77, ["Neon|Fly"] = 86.03, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 179.7, ["Mega"] = 262.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.8, ["Fly"] = 72.05, ["Ride"] = 34.26, ["Fly|Ride"] = 68.06, ["Neon"] = 80.99, ["Neon|Ride"] = 54.84, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 355.68, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 1287.02}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 1.79, ["Fly"] = 31.16, ["Ride"] = 16.44, ["Fly|Ride"] = 44.54, ["Neon"] = 4.32, ["Neon|Fly"] = 32.27, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 65.59, ["Mega"] = 52.23, ["Mega|Fly"] = 148.17, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 366.61}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.88, ["Fly"] = 72.12, ["Ride"] = 23.01, ["Fly|Ride"] = 81.29, ["Neon"] = 399, ["Neon|Fly"] = 359.14, ["Neon|Ride"] = 109.66, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 1837.5, ["Mega|Ride"] = 551.35, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.64, ["Fly|Ride"] = 32.82, ["Neon"] = 13.13, ["Neon|Fly"] = 81.59, ["Neon|Ride"] = 34.34, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 153.09, ["Mega|Fly"] = 162.84, ["Mega|Ride"] = 168.92, ["Mega|Fly|Ride"] = 176.3}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 24.63, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.76, ["Mega"] = 186.63, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 1.79, ["Fly"] = 34.42, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.74, ["Mega|Ride"] = 42.91, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 18.27, ["Fly|Ride"] = 43.02, ["Neon"] = 15.22, ["Neon|Fly"] = 107.54, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.75, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.72, ["Ride"] = 19.68, ["Fly|Ride"] = 62.05, ["Neon"] = 21.42, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 208.08, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 95.48, ["Fly"] = 179.29, ["Ride"] = 135.19, ["Fly|Ride"] = 213.7, ["Neon"] = 572.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 525, ["Mega"] = 4290.04, ["Mega|Fly|Ride"] = 2255.93}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.44, ["Ride"] = 43.02, ["Fly|Ride"] = 130.29, ["Neon"] = 49.47, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 429.02, ["Mega|Ride"] = 413.45, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 12.85, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 242.9, ["Mega|Ride"] = 263.74, ["Mega|Fly|Ride"] = 285.79}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.24, ["Ride"] = 58.01, ["Fly|Ride"] = 170.63, ["Neon"] = 127.31, ["Neon|Ride"] = 271.9, ["Neon|Fly|Ride"] = 714.31, ["Mega"] = 1071.45, ["Mega|Fly"] = 858.02, ["Mega|Ride"] = 629.99, ["Mega|Fly|Ride"] = 643.52}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.09}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.87, ["Ride"] = 28.82, ["Fly|Ride"] = 125.99, ["Neon"] = 47.5, ["Neon|Ride"] = 91.88, ["Mega"] = 285.92, ["Mega|Ride"] = 512.68, ["Mega|Fly|Ride"] = 891.38}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.28, ["Fly"] = 36.66, ["Ride"] = 31.79, ["Fly|Ride"] = 48.38, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 2145.03, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 1.79, ["Ride"] = 18.87, ["Fly|Ride"] = 65.63, ["Neon"] = 3.82, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 28.66, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 57.65, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.1, ["Fly"] = 28.4, ["Ride"] = 19.81, ["Fly|Ride"] = 65.63, ["Neon"] = 55.13, ["Neon|Ride"] = 64.37, ["Mega"] = 285.92, ["Mega|Fly"] = 405.62, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 426.87}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.14, ["Fly|Ride"] = 48.45, ["Neon"] = 17.74, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 53.65, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 281.01}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 215.06, ["Neon"] = 3.85, ["Neon|Fly"] = 37.65, ["Neon|Ride"] = 32.68, ["Mega"] = 26.22, ["Mega|Ride"] = 59.56, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.24, ["Ride"] = 71.84, ["Fly|Ride"] = 144.38, ["Neon"] = 281.72, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.63, ["Mega|Ride"] = 1071.45, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.91, ["Fly"] = 29.05, ["Ride"] = 68.25, ["Fly|Ride"] = 210, ["Neon"] = 92.65, ["Mega"] = 143.73, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 28.8, ["Ride"] = 20.54, ["Fly|Ride"] = 41.91, ["Neon"] = 25.97, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 114.17, ["Mega"] = 473.17, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 65.63, ["Fly"] = 433.12, ["Ride"] = 393.74, ["Fly|Ride"] = 262.47, ["Neon"] = 367.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4535.82, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2359.52}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.66, ["Fly"] = 44.84, ["Ride"] = 23.62, ["Fly|Ride"] = 57.66, ["Neon"] = 48.72, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 242.81, ["Mega|Ride"] = 236.51, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.25, ["Fly"] = 143.06, ["Ride"] = 104.99, ["Fly|Ride"] = 144.95, ["Neon"] = 262.5, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 312.27, ["Mega"] = 1134.28, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 968.62}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.22, ["Ride"] = 55.13, ["Fly|Ride"] = 143.07, ["Neon"] = 80.53, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 314.99, ["Mega|Ride"] = 355.49, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.66, ["Fly"] = 41.36, ["Ride"] = 29.05, ["Fly|Ride"] = 70.13, ["Neon"] = 84.81, ["Neon|Ride"] = 144.16, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 214.52, ["Mega|Ride"] = 1608.77, ["Mega|Fly|Ride"] = 535.2}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 16.78, ["Fly"] = 70.97, ["Ride"] = 65.62, ["Fly|Ride"] = 163.16, ["Neon"] = 69.37, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 236.91, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.76, ["Ride"] = 27.57, ["Fly|Ride"] = 90.33, ["Neon"] = 32.45, ["Neon|Ride"] = 72.05, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 242.9, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 68.7, ["Neon"] = 2.37, ["Neon|Fly"] = 92.84, ["Neon|Ride"] = 85.81, ["Mega"] = 19.27, ["Mega|Ride"] = 136.23, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.53, ["Ride"] = 57.77, ["Neon"] = 24.29, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 270.29, ["Mega|Fly|Ride"] = 426.87}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.89, ["Ride"] = 27.47, ["Neon"] = 28.75, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Mega"] = 182.34, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.03, ["Ride"] = 32.79, ["Fly|Ride"] = 121.77, ["Neon"] = 31.2, ["Neon|Ride"] = 80.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 536.82, ["Fly|Ride"] = 594.01, ["Neon"] = 1827.82, ["Neon|Ride"] = 2145.03, ["Neon|Fly|Ride"] = 1613.78, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.88, ["Fly"] = 45.47, ["Ride"] = 20.43, ["Fly|Ride"] = 56.34, ["Neon"] = 41.94, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 150.94, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 514.82}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.35, ["Fly"] = 66.94, ["Ride"] = 31.2, ["Fly|Ride"] = 51.54, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 166.04, ["Mega"] = 331.86, ["Mega|Ride"] = 432.34, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 27.45, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.05, ["Fly|Ride"] = 73.13, ["Neon"] = 7.8, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 129.44, ["Mega"] = 65.63, ["Mega|Fly"] = 286.38, ["Mega|Ride"] = 88.66, ["Mega|Fly|Ride"] = 214.14}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 72.05, ["Ride"] = 16.95, ["Neon"] = 3.15, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 128.71, ["Mega"] = 21.81, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.74, ["Ride"] = 36.73, ["Fly|Ride"] = 105, ["Neon"] = 52.94, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 324.26, ["Mega"] = 426.87, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.3, ["Neon"] = 6.33, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 6.25, ["Fly"] = 26.35, ["Ride"] = 64.04, ["Neon"] = 29.32, ["Neon|Ride"] = 71.87, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 195.57, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1072.53}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.99, ["Ride"] = 411.3, ["Fly|Ride"] = 459.17, ["Neon|Ride"] = 2384.82, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8906.46, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.9, ["Fly"] = 196.88, ["Ride"] = 58.08, ["Fly|Ride"] = 430.08, ["Neon"] = 30.17, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 194.32, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 745.66}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 91.24, ["Ride"] = 28.22, ["Fly|Ride"] = 118.13, ["Neon"] = 3.63, ["Neon|Ride"] = 35.93, ["Neon|Fly|Ride"] = 129.96, ["Mega"] = 62, ["Mega|Ride"] = 72.18, ["Mega|Fly|Ride"] = 229.53}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 129.92, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 32.68, ["Mega|Fly"] = 161.96, ["Mega|Ride"] = 136.14, ["Mega|Fly|Ride"] = 391.65}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 18.37, ["Fly"] = 107.63, ["Ride"] = 107.54, ["Neon"] = 72.05, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 539.24}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.15, ["Ride"] = 71.31, ["Neon"] = 96.48, ["Neon|Ride"] = 405.62, ["Neon|Fly|Ride"] = 510.53, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 572.74}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.73, ["Ride"] = 31.4, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 664.29, ["Mega|Ride"] = 787.24, ["Mega|Fly|Ride"] = 1287.02}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 9.55, ["Ride"] = 23.85, ["Fly|Ride"] = 262.5, ["Neon"] = 131.25, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 247.76, ["Mega"] = 616.77, ["Mega|Ride"] = 1300.04, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 365.4, ["Ride"] = 386.64, ["Fly|Ride"] = 784.11, ["Neon"] = 1365, ["Neon|Ride"] = 1430.75, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 3117.57}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.3, ["Fly"] = 42, ["Ride"] = 26.25, ["Fly|Ride"] = 82.18, ["Neon"] = 190.32, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 146.88, ["Mega|Ride"] = 768.48, ["Mega|Fly|Ride"] = 882.69}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.67, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 56.22, ["Neon|Ride"] = 221.82, ["Mega"] = 196.88, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.7, ["Ride"] = 52.5, ["Fly|Ride"] = 236.25, ["Neon"] = 81.38, ["Neon|Ride"] = 163.5, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 301.77, ["Mega|Fly"] = 715.38, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 417.37}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.37, ["Ride"] = 43.02, ["Fly|Ride"] = 215.06, ["Neon"] = 7.37, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 38.07, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 41.56, ["Ride"] = 79, ["Neon"] = 315, ["Neon|Ride"] = 359.63, ["Mega"] = 1979.86, ["Mega|Ride"] = 2216.88, ["Mega|Fly|Ride"] = 1243.97}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 24.14, ["Fly|Ride"] = 152.25, ["Neon"] = 5.25, ["Neon|Fly"] = 187.1, ["Neon|Ride"] = 50.43, ["Neon|Fly|Ride"] = 145.74, ["Mega"] = 72.19, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 227.34}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 1.95, ["Ride"] = 28.02, ["Neon"] = 4.56, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 32.82, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 76.61, ["Mega|Fly|Ride"] = 170.43}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 38.07, ["Fly|Ride"] = 127.52, ["Neon"] = 10.77, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 106.2, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 316.41}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.66, ["Fly"] = 65.61, ["Ride"] = 61.68, ["Fly|Ride"] = 157.5, ["Neon"] = 236.25, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 486.15, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 219.19, ["Ride"] = 315, ["Fly|Ride"] = 367.5, ["Neon"] = 1462.13, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9715.26, ["Mega|Fly|Ride"] = 4580.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.29, ["Ride"] = 34.39, ["Neon"] = 36.41, ["Neon|Fly"] = 350.44, ["Mega"] = 110.06, ["Mega|Fly"] = 241.68, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.05, ["Fly"] = 72.05, ["Ride"] = 27.98, ["Neon"] = 6.21, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 140.43, ["Mega"] = 37.95, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.37, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.86, ["Fly"] = 104.99, ["Ride"] = 28.1, ["Fly|Ride"] = 81.59, ["Neon"] = 32.81, ["Mega"] = 122.28, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 28.9, ["Fly|Ride"] = 374.42, ["Neon"] = 14.44, ["Neon|Ride"] = 47.21, ["Neon|Fly|Ride"] = 162.65, ["Mega"] = 124.58, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 143.73, ["Mega"] = 39.27, ["Mega|Ride"] = 143.73, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 1.79, ["Fly"] = 29.05, ["Ride"] = 17.92, ["Fly|Ride"] = 52.49, ["Neon"] = 4.64, ["Neon|Fly"] = 81.59, ["Neon|Ride"] = 27.9, ["Neon|Fly|Ride"] = 58.31, ["Mega"] = 40.32, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 41.32, ["Neon"] = 15.16, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.89, ["Neon|Fly|Ride"] = 97.16, ["Mega"] = 156.15, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 171.62}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.85, ["Fly"] = 52.5, ["Ride"] = 32.45, ["Fly|Ride"] = 78.74, ["Neon"] = 215.06, ["Neon|Fly|Ride"] = 324.35, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 73.5, ["Ride"] = 84.32, ["Fly|Ride"] = 139.13, ["Neon"] = 410.81, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 2003.46, ["Mega|Ride"] = 1542.73, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 18.94, ["Fly|Ride"] = 144.38, ["Neon"] = 3.84, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.71, ["Mega"] = 45.85, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.11}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 15.18, ["Fly|Ride"] = 26.25, ["Neon"] = 4.2, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.47, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 37.98, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 43.02, ["Ride"] = 28.35, ["Fly|Ride"] = 131.25, ["Neon"] = 48.37, ["Neon|Ride"] = 124.69, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 485.78}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 621.48, ["Fly|Ride"] = 577.5, ["Neon"] = 4300.74, ["Neon|Ride"] = 2105.79, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8096.45}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 26.48, ["Fly"] = 101.08, ["Ride"] = 36.58, ["Fly|Ride"] = 107.54, ["Neon"] = 241.5, ["Neon|Ride"] = 225.74, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 765.05, ["Mega|Fly|Ride"] = 1273.34}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.87, ["Fly|Ride"] = 281.33, ["Neon"] = 9.18, ["Neon|Ride"] = 47.4, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 99.75, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.05, ["Fly"] = 91.87, ["Ride"] = 65.62, ["Fly|Ride"] = 145.17, ["Neon"] = 13.38, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 40.69, ["Fly"] = 169.3, ["Ride"] = 35.44, ["Fly|Ride"] = 82.8, ["Neon"] = 194.25, ["Neon|Ride"] = 242.9, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 2574.03, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1287.02}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 82.76, ["Fly"] = 104.9, ["Ride"] = 114.57, ["Fly|Ride"] = 193.55, ["Neon"] = 430.1, ["Neon|Ride"] = 493.37, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8580.07, ["Mega|Fly|Ride"] = 2453.92}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.5, ["Ride"] = 262.5, ["Fly|Ride"] = 358.24, ["Neon"] = 962.3, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.64, ["Ride"] = 61.6, ["Fly|Ride"] = 145.85, ["Neon"] = 85.31, ["Neon|Ride"] = 123.16, ["Neon|Fly|Ride"] = 301.23, ["Mega"] = 389.79, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1070.72}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 7.55, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 93.33, ["Mega"] = 85.81, ["Mega|Ride"] = 100.82, ["Mega|Fly|Ride"] = 170.42}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.3, ["Ride"] = 17.54, ["Fly|Ride"] = 55.97, ["Neon"] = 31.07, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.89, ["Mega"] = 286.38, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 365.39}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 371.76, ["Ride"] = 481.68, ["Fly|Ride"] = 650.18, ["Neon"] = 1575, ["Neon|Ride"] = 2029.3, ["Mega"] = 10296.07, ["Mega|Fly|Ride"] = 4907.74}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.46, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 27.87, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.87, ["Fly"] = 43.02, ["Ride"] = 15.75, ["Fly|Ride"] = 126, ["Neon"] = 49.38, ["Neon|Ride"] = 38.03, ["Neon|Fly|Ride"] = 84, ["Mega"] = 238.11, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 229.53, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 22.85, ["Ride"] = 65.33, ["Neon"] = 93.19, ["Neon|Ride"] = 132.57, ["Mega"] = 459.38, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 600.18}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.94, ["Fly"] = 144.09, ["Ride"] = 100.83, ["Fly|Ride"] = 127.02, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.11, ["Fly"] = 24.33, ["Ride"] = 24.93, ["Fly|Ride"] = 48.88, ["Neon"] = 122.58, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 140.52, ["Mega"] = 715.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 509.74}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.52, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Mega"] = 22.61, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.37, ["Fly|Ride"] = 72.05, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 81.31, ["Mega"] = 26.22, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.34, ["Ride"] = 72.05, ["Fly|Ride"] = 136.42, ["Neon"] = 31.39, ["Neon|Ride"] = 87.34, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 172.73, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 302.03}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.23, ["Ride"] = 1260, ["Fly|Ride"] = 1435.88, ["Neon"] = 4376.12, ["Neon|Ride"] = 7150.41, ["Neon|Fly|Ride"] = 4343.71, ["Mega|Fly|Ride"] = 12586.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Ride"] = 446.25, ["Fly|Ride"] = 595.88, ["Neon"] = 2524.54, ["Neon|Ride"] = 2145.03, ["Neon|Fly|Ride"] = 2574.03, ["Mega"] = 17160.12, ["Mega|Fly|Ride"] = 7215.84}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 300.99, ["Ride"] = 318.26, ["Fly|Ride"] = 393.75, ["Neon"] = 787.5, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 242.82, ["Fly"] = 460.19, ["Ride"] = 393.75, ["Fly|Ride"] = 414.43, ["Neon"] = 708.75, ["Neon|Ride"] = 745.49, ["Neon|Fly|Ride"] = 724.49, ["Mega|Fly|Ride"] = 4290.04}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 18.37, ["Fly|Ride"] = 37.45, ["Neon"] = 5.23, ["Neon|Ride"] = 30.45, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.53, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 421.03, ["Fly"] = 1434.32, ["Ride"] = 419.99, ["Fly|Ride"] = 498.75, ["Neon"] = 1434.32, ["Neon|Ride"] = 1268.79, ["Neon|Fly|Ride"] = 1359.75, ["Mega"] = 21736.51, ["Mega|Ride"] = 5148.04, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.76, ["Fly"] = 157.5, ["Ride"] = 112.53, ["Fly|Ride"] = 91.87, ["Neon"] = 22.18, ["Neon|Ride"] = 214.52, ["Neon|Fly|Ride"] = 252.45, ["Mega"] = 138.01, ["Mega|Ride"] = 237.57, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.12, ["Fly|Ride"] = 32.89, ["Neon"] = 20.44, ["Neon|Ride"] = 40.71, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 2.92, ["Neon|Ride"] = 45.94, ["Mega"] = 28.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 237.04}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.88, ["Ride"] = 178.49, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 417.77, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 8.61, ["Neon|Ride"] = 61.13, ["Mega"] = 363.55, ["Mega|Ride"] = 415.08, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.51, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.87, ["Mega|Ride"] = 69.23, ["Mega|Fly|Ride"] = 166.04}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.01, ["Fly"] = 41.03, ["Ride"] = 27.35, ["Fly|Ride"] = 65.63, ["Neon"] = 19.49, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 79.92, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.39, ["Fly"] = 91.88, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 30.19, ["Neon|Fly"] = 146.11, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.86, ["Ride"] = 48.62, ["Neon"] = 91.88, ["Neon|Ride"] = 171.62, ["Neon|Fly|Ride"] = 308.47, ["Mega"] = 427.07, ["Mega|Ride"] = 803.33, ["Mega|Fly|Ride"] = 715.38}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.86, ["Fly"] = 6203.88, ["Ride"] = 19.69, ["Neon"] = 43.64, ["Neon|Fly"] = 47.92, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 728.66, ["Mega"] = 315, ["Mega|Ride"] = 423.66, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.89, ["Ride"] = 18.38, ["Fly|Ride"] = 43.02, ["Neon"] = 3.94, ["Neon|Fly"] = 32.27, ["Neon|Ride"] = 27.93, ["Neon|Fly|Ride"] = 85.81, ["Mega"] = 43.32, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.61, ["Fly"] = 262.37, ["Ride"] = 164.07, ["Fly|Ride"] = 229.69, ["Neon"] = 859.08, ["Neon|Ride"] = 986.72, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8580.07, ["Mega|Fly|Ride"] = 3556.25}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 13.93, ["Fly|Ride"] = 36.75, ["Neon"] = 3.92, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 24.75, ["Neon|Fly|Ride"] = 70.81, ["Mega"] = 38.06, ["Mega|Ride"] = 52.77, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 4.87, ["Ride"] = 42.37, ["Fly|Ride"] = 196.88, ["Neon"] = 55.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 810.03, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 35.26, ["Ride"] = 81.25, ["Fly|Ride"] = 170.63, ["Neon"] = 201.07, ["Neon|Ride"] = 278.87, ["Mega"] = 1001.74, ["Mega|Ride"] = 557.84, ["Mega|Fly|Ride"] = 858.02}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.72, ["Ride"] = 225.15, ["Fly|Ride"] = 283.87, ["Neon"] = 780.36, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 755.99, ["Mega|Fly|Ride"] = 3432.03}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 39.37, ["Fly|Ride"] = 146.11, ["Neon"] = 90.57, ["Neon|Ride"] = 286.38, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 591.43}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 13.38, ["Ride"] = 57.75, ["Fly|Ride"] = 182.44, ["Neon"] = 105.18, ["Neon|Fly"] = 163.16, ["Neon|Ride"] = 199, ["Neon|Fly|Ride"] = 143.16, ["Mega"] = 771.89, ["Mega|Ride"] = 858.02, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 958.12, ["Fly"] = 1050, ["Ride"] = 976.79, ["Fly|Ride"] = 1214.07, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4991.46, ["Mega|Fly|Ride"] = 17812.91}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 6.04, ["Fly"] = 21, ["Ride"] = 20.78, ["Fly|Ride"] = 52.5, ["Neon"] = 20.36, ["Neon|Fly"] = 51.98, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 230.75, ["Mega|Fly|Ride"] = 229.53}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.1, ["Fly"] = 78.75, ["Ride"] = 35.43, ["Fly|Ride"] = 135.19, ["Neon"] = 37.97, ["Neon|Ride"] = 121.46, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 296.03, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.96, ["Ride"] = 23.76, ["Fly|Ride"] = 69.57, ["Neon"] = 10.85, ["Neon|Ride"] = 45.82, ["Mega"] = 78.75, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 15.11, ["Fly"] = 57.66, ["Ride"] = 32.81, ["Fly|Ride"] = 87.05, ["Neon"] = 83.91, ["Neon|Ride"] = 82.74, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 492.19, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 438.38}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.47, ["Ride"] = 23.66, ["Fly|Ride"] = 39.38, ["Neon"] = 16.53, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 28.97, ["Neon|Fly|Ride"] = 101.53, ["Mega"] = 143.73, ["Mega|Fly"] = 257.41, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 192.77}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.98, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 427.94}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 227.63, ["Ride"] = 299.99, ["Fly|Ride"] = 387.09, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 15.75, ["Fly|Ride"] = 108.94, ["Neon"] = 6.12, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 127.42, ["Mega"] = 65.64, ["Mega|Fly"] = 429.02, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.78, ["Ride"] = 82.01, ["Fly|Ride"] = 88.86, ["Neon"] = 27.57, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 324.26, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.63, ["Fly"] = 98.86, ["Ride"] = 25.36, ["Neon"] = 17.3, ["Neon|Ride"] = 52.5, ["Mega"] = 84.96, ["Mega|Ride"] = 120.51, ["Mega|Fly|Ride"] = 458.75}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 98.26, ["Ride"] = 262.5, ["Fly|Ride"] = 295.32, ["Neon"] = 493.86, ["Neon|Ride"] = 648.51, ["Neon|Fly|Ride"] = 675.69, ["Mega"] = 2761.58, ["Mega|Ride"] = 4290.04, ["Mega|Fly|Ride"] = 2288.74}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.17, ["Ride"] = 51.63, ["Fly|Ride"] = 240.35, ["Neon"] = 149.62, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 634.32, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.64, ["Fly"] = 325.02, ["Ride"] = 40.62, ["Fly|Ride"] = 94.21, ["Neon"] = 109.69, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 242.41, ["Mega"] = 432.16, ["Mega|Ride"] = 435.74, ["Mega|Fly|Ride"] = 439.67}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 77.43, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 415.08}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 51.95, ["Fly"] = 114.19, ["Ride"] = 75.16, ["Fly|Ride"] = 215.06, ["Neon"] = 302.5, ["Neon|Fly"] = 301.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 292.67, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 42.84, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 127.64, ["Mega"] = 61.15, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.1, ["Fly"] = 129.94, ["Ride"] = 32.26, ["Fly|Ride"] = 80.07, ["Neon"] = 68.61, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 291.47, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.41, ["Fly"] = 131.25, ["Ride"] = 94.5, ["Fly|Ride"] = 285.89, ["Neon"] = 229.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1393.2, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 14.46, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.74, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 39.36, ["Mega"] = 17.06, ["Mega|Fly"] = 121.46, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 113.43}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 131.25, ["Neon"] = 18.51, ["Neon|Ride"] = 64.37, ["Neon|Fly|Ride"] = 429.02, ["Mega"] = 170.61, ["Mega|Ride"] = 285.41, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.68, ["Ride"] = 43.22, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 214.52, ["Neon|Fly|Ride"] = 273, ["Mega"] = 425.39, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 1.79, ["Ride"] = 21.56, ["Neon"] = 2.62, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 140.52, ["Mega"] = 19.67, ["Mega|Ride"] = 128.41, ["Mega|Fly|Ride"] = 200.58}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 19.25, ["Fly"] = 199.4, ["Ride"] = 47.78, ["Fly|Ride"] = 178.49, ["Neon"] = 108.28, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 627.99, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 492.33, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 25.71, ["Fly"] = 42.75, ["Ride"] = 26.48, ["Fly|Ride"] = 29.05, ["Neon"] = 357.86, ["Neon|Ride"] = 92.66, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 210.29, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.67, ["Ride"] = 38.19, ["Neon"] = 25.1, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 74.34, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 266.11, ["Mega|Ride"] = 254.63, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 4.73, ["Fly"] = 1994.73, ["Ride"] = 60.38, ["Fly|Ride"] = 196.88, ["Neon"] = 45.85, ["Neon|Ride"] = 367.4, ["Neon|Fly|Ride"] = 6476.44, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 43.02, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 9.65, ["Neon|Ride"] = 32.43, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 201.65, ["Mega|Fly|Ride"] = 283.16}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.86, ["Mega"] = 21.6, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 22.31}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.37, ["Fly"] = 101.08, ["Ride"] = 52.49, ["Neon"] = 184.54, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 1.79, ["Neon"] = 2.58, ["Neon|Ride"] = 27.57, ["Mega"] = 18.36, ["Mega|Ride"] = 8866.43, ["Mega|Fly|Ride"] = 321.78}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 485.63, ["Fly"] = 498.75, ["Ride"] = 551.25, ["Fly|Ride"] = 812.12, ["Neon"] = 4299.66, ["Neon|Fly|Ride"] = 2717.74, ["Mega"] = 17160.12, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.29, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 67.75, ["Neon"] = 35.18, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 86.83, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 22.32, ["Fly|Ride"] = 81.27, ["Neon"] = 18.38, ["Neon|Ride"] = 64.37, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 118.13, ["Mega|Fly"] = 214.52, ["Mega|Ride"] = 152.29, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 135, ["Ride"] = 27.98, ["Fly|Ride"] = 68.86, ["Neon"] = 105.76, ["Neon|Ride"] = 174.83, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 858.02, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.64, ["Fly"] = 58.08, ["Ride"] = 28.86, ["Fly|Ride"] = 721.88, ["Neon"] = 16.49, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.5, ["Ride"] = 43.02, ["Fly|Ride"] = 157.49, ["Neon"] = 64.6, ["Neon|Ride"] = 143.49, ["Mega"] = 497.44, ["Mega|Ride"] = 472.99, ["Mega|Fly|Ride"] = 599.68}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.47, ["Fly"] = 105, ["Ride"] = 34.42, ["Fly|Ride"] = 133.88, ["Neon"] = 34.05, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 135.73, ["Mega"] = 262.5, ["Mega|Ride"] = 321.78, ["Mega|Fly|Ride"] = 648.38}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 1.79, ["Fly"] = 42.62, ["Ride"] = 13.79, ["Fly|Ride"] = 74.03, ["Neon"] = 2.1, ["Neon|Fly"] = 61.3, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 14.85, ["Mega|Fly"] = 32.79, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.94, ["Fly"] = 54.86, ["Ride"] = 39.38, ["Fly|Ride"] = 106.32, ["Neon"] = 28.88, ["Neon|Fly"] = 144.09, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 229.08, ["Mega"] = 196.87, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.69, ["Ride"] = 308.44, ["Fly|Ride"] = 388.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1283.63, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9423.8, ["Mega|Fly|Ride"] = 5405.45}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 88.22, ["Ride"] = 111.57, ["Fly|Ride"] = 284.82, ["Neon"] = 502.13, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2288.74, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1821.15}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 15.54, ["Fly|Ride"] = 33.92, ["Neon"] = 4.59, ["Neon|Fly"] = 26.22, ["Neon|Ride"] = 34.34, ["Neon|Fly|Ride"] = 64.07, ["Mega"] = 143.73, ["Mega|Fly"] = 213.45, ["Mega|Ride"] = 106.2, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 1.79, ["Fly"] = 19.68, ["Ride"] = 15.23, ["Fly|Ride"] = 32.82, ["Neon"] = 6.49, ["Neon|Fly"] = 53.57, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 55.53, ["Mega"] = 65.54, ["Mega|Fly"] = 358.24, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.72, ["Fly"] = 101.08, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 286.38, ["Mega|Ride"] = 429.02, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 257.25, ["Fly"] = 420, ["Ride"] = 252, ["Fly|Ride"] = 277.29, ["Neon"] = 1181.25, ["Neon|Ride"] = 1083.25, ["Neon|Fly|Ride"] = 1589.46, ["Mega|Ride"] = 8580.07, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.44, ["Fly|Ride"] = 48.17, ["Neon"] = 18.15, ["Neon|Fly"] = 105, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.52, ["Fly"] = 325.02, ["Ride"] = 34.13, ["Fly|Ride"] = 215.06, ["Neon"] = 35.6, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 445.11}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.93, ["Neon|Ride"] = 156.19, ["Mega"] = 78.65, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14.43, ["Fly"] = 30.18, ["Ride"] = 17.94, ["Fly|Ride"] = 73.94, ["Neon"] = 118.13, ["Neon|Ride"] = 99.56, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 576.09}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.19, ["Fly"] = 121.74, ["Ride"] = 78.73, ["Fly|Ride"] = 170.63, ["Neon"] = 149.59, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 166.37, ["Neon|Fly|Ride"] = 360.29, ["Mega"] = 400.32, ["Mega|Fly"] = 2252.28, ["Mega|Ride"] = 490.19, ["Mega|Fly|Ride"] = 595.19}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.22, ["Fly"] = 62.05, ["Ride"] = 32.81, ["Fly|Ride"] = 98.44, ["Neon"] = 157.53, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 858.02, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 1.79, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 42.54, ["Neon"] = 2.63, ["Neon|Fly"] = 28.14, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 17.07, ["Mega|Fly"] = 429.02, ["Mega|Ride"] = 32.69, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 201.07, ["Ride"] = 230.9, ["Fly|Ride"] = 296.63, ["Neon"] = 2302.89, ["Neon|Fly|Ride"] = 979.99, ["Mega|Fly|Ride"] = 3932.9}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 24.94, ["Fly"] = 65.63, ["Ride"] = 49.41, ["Fly|Ride"] = 105, ["Neon"] = 106.44, ["Neon|Ride"] = 155.03, ["Neon|Fly|Ride"] = 328.12, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 18.37, ["Fly|Ride"] = 42.09, ["Neon"] = 4.89, ["Neon|Fly"] = 39, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 63.3, ["Mega|Ride"] = 84.74, ["Mega|Fly|Ride"] = 158.74}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.27, ["Ride"] = 16.14, ["Fly|Ride"] = 44.18, ["Neon"] = 2.62, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 19.28, ["Mega|Fly"] = 143.73, ["Mega|Ride"] = 64.37, ["Mega|Fly|Ride"] = 140.52}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 13.13, ["Neon|Fly"] = 730.53, ["Neon|Ride"] = 49.79, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.81, ["Fly"] = 38.75, ["Ride"] = 23.61, ["Fly|Ride"] = 65.63, ["Neon"] = 64.32, ["Neon|Fly"] = 308.6, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 355.69, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 418.81}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.29, ["Ride"] = 58.08, ["Fly|Ride"] = 72.19, ["Neon"] = 55.13, ["Neon|Fly|Ride"] = 314.99, ["Mega"] = 253.32, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 405.62}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 41.89, ["Neon"] = 3.94, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 37.68, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 195.71}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.88, ["Fly"] = 101.08, ["Ride"] = 26.81, ["Fly|Ride"] = 131.25, ["Neon"] = 25.47, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 45.46, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 255.27, ["Mega|Ride"] = 201.98, ["Mega|Fly|Ride"] = 291.47}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 80.59, ["Neon"] = 4.08, ["Neon|Fly"] = 115.06, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.32, ["Mega"] = 23.8, ["Mega|Ride"] = 104.12, ["Mega|Fly|Ride"] = 142.64}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.52, ["Ride"] = 17.29, ["Fly|Ride"] = 55.91, ["Neon"] = 6.47, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.39, ["Mega|Fly"] = 143.73, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.71, ["Ride"] = 702.19, ["Fly|Ride"] = 735, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 15.33, ["Fly|Ride"] = 36.33, ["Neon"] = 13.13, ["Neon|Fly"] = 140.89, ["Neon|Ride"] = 35.79, ["Neon|Fly|Ride"] = 114.17, ["Mega|Fly|Ride"] = 372.18}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 45.93, ["Fly|Ride"] = 210, ["Neon"] = 9.08, ["Neon|Fly"] = 752.64, ["Neon|Ride"] = 88.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 52.5, ["Mega|Fly"] = 214.52, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 5.25, ["Fly"] = 147, ["Ride"] = 20.99, ["Fly|Ride"] = 50.4, ["Neon"] = 65.63, ["Neon|Fly"] = 194.81, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 84.81, ["Mega"] = 601.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 40.69, ["Neon"] = 6.2, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 76.02, ["Mega"] = 65.62, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 214.52}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 50.33, ["Fly"] = 105, ["Ride"] = 84, ["Fly|Ride"] = 317.2, ["Neon"] = 150.53, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 771.15, ["Mega|Ride"] = 787.24}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 64.36, ["Neon"] = 7.88, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 54.62, ["Mega|Ride"] = 124.46, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.05, ["Ride"] = 22.99, ["Fly|Ride"] = 64.53, ["Neon"] = 9.18, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 128.71, ["Mega"] = 95.82, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.61, ["Fly|Ride"] = 78.75, ["Neon"] = 26.25, ["Mega"] = 97.12, ["Mega|Ride"] = 160.9, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.07, ["Fly|Ride"] = 49.87, ["Neon"] = 3.59, ["Neon|Fly"] = 100.68, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 40.69, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.06, ["Fly"] = 21.05, ["Ride"] = 20.98, ["Fly|Ride"] = 37.65, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 128.2, ["Mega|Ride"] = 469.77, ["Mega|Fly|Ride"] = 615.71}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 734.98, ["Fly"] = 910.69, ["Ride"] = 757.32, ["Fly|Ride"] = 905.63, ["Neon"] = 1796.82, ["Neon|Ride"] = 2049.15, ["Neon|Fly|Ride"] = 1968.65, ["Mega"] = 4654.13, ["Mega|Fly|Ride"] = 6725.39}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.07, ["Fly|Ride"] = 37.67, ["Neon"] = 2.1, ["Neon|Ride"] = 23.87, ["Neon|Fly|Ride"] = 48.86, ["Mega"] = 49.79, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 143.06}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 3.94, ["Ride"] = 32.81, ["Fly|Ride"] = 241.65, ["Neon"] = 48.56, ["Neon|Ride"] = 112.41, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 403.57, ["Mega|Ride"] = 351.2, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 50.28, ["Fly"] = 104.9, ["Ride"] = 72.56, ["Fly|Ride"] = 111.57, ["Neon|Ride"] = 428.39, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1573.38}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 32.54, ["Ride"] = 53.9, ["Fly|Ride"] = 104.89, ["Neon"] = 157.5, ["Neon|Ride"] = 225.24, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 1001.74, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1044.64}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.66, ["Ride"] = 26.23, ["Fly|Ride"] = 140.91, ["Neon"] = 56.7, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 126.12, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.14, ["Ride"] = 52.41, ["Neon"] = 103.69, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 236.15, ["Mega|Fly"] = 527.07, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 14.65, ["Fly|Ride"] = 153.71, ["Neon"] = 124.69, ["Neon|Ride"] = 172.05, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 536.27, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.5}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.79, ["Ride"] = 24.82, ["Fly|Ride"] = 72.82, ["Neon"] = 37.89, ["Neon|Ride"] = 85.81, ["Neon|Fly|Ride"] = 213.63, ["Mega"] = 196.27, ["Mega|Fly"] = 484.79, ["Mega|Ride"] = 234.89, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 28.93, ["Neon"] = 10.15, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 485.78}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 62.14, ["Fly"] = 60.41, ["Ride"] = 57.74, ["Fly|Ride"] = 99.75, ["Neon"] = 200.82, ["Neon|Ride"] = 212.38, ["Neon|Fly|Ride"] = 300.32, ["Mega|Ride"] = 681.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.57, ["Fly"] = 21.42, ["Ride"] = 15.74, ["Fly|Ride"] = 37.8, ["Neon"] = 25.92, ["Neon|Fly"] = 58.08, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 76.12, ["Mega"] = 198.19, ["Mega|Ride"] = 243.48, ["Mega|Fly|Ride"] = 307.26}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.62, ["Fly"] = 37.37, ["Ride"] = 26.24, ["Fly|Ride"] = 56.26, ["Neon"] = 20.99, ["Neon|Ride"] = 42.83, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.82, ["Mega|Ride"] = 160.11, ["Mega|Fly|Ride"] = 236.22}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.32, ["Mega"] = 38.48, ["Mega|Ride"] = 196.59, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 36.58, ["Fly"] = 77.96, ["Ride"] = 52.49, ["Fly|Ride"] = 91.88, ["Neon"] = 945, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 321.26, ["Mega|Ride"] = 853.74, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 65.63, ["Neon"] = 3.84, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 28.97, ["Mega"] = 93.33, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 470.24}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.39, ["Ride"] = 81.59, ["Fly|Ride"] = 286.01, ["Neon"] = 60.38, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 426.87, ["Mega|Fly|Ride"] = 715.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 41.06, ["Neon"] = 19.27, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 76.67, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 226.87}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 20.79, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 429.02, ["Mega"] = 291.38, ["Mega|Ride"] = 429.02, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 67.75, ["Neon"] = 42, ["Neon|Ride"] = 227.06, ["Mega"] = 288.75, ["Mega|Ride"] = 972.29}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 42.88, ["Ride"] = 91.88, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 686.42, ["Mega"] = 1781.54, ["Mega|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 61, ["Ride"] = 92.65, ["Neon"] = 105, ["Neon|Ride"] = 183.75, ["Mega"] = 349.13, ["Mega|Ride"] = 567.15, ["Mega|Fly|Ride"] = 601.79}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.81, ["Ride"] = 125.98, ["Fly|Ride"] = 131.25, ["Neon"] = 184.95, ["Neon|Ride"] = 429.02, ["Mega|Ride"] = 856.95}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.38, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 103.35, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 616.88, ["Mega|Fly"] = 2145.03, ["Mega|Ride"] = 728.66, ["Mega|Fly|Ride"] = 787.24}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 13.12, ["Neon|Ride"] = 48.59, ["Mega"] = 157.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 324.26}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.98, ["Ride"] = 14.11, ["Fly|Ride"] = 43.02, ["Neon"] = 4.81, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 43.02, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 66.68, ["Mega|Ride"] = 121.46, ["Mega|Fly|Ride"] = 321.57}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 56.02, ["Fly|Ride"] = 65.63, ["Neon"] = 13.11, ["Neon|Ride"] = 71.55, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 87.72, ["Mega|Ride"] = 162.74, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 19.68, ["Fly|Ride"] = 58.08, ["Neon"] = 4.89, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 107.61, ["Mega"] = 42.86, ["Mega|Ride"] = 83.89, ["Mega|Fly|Ride"] = 201.96}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 63, ["Ride"] = 23.51, ["Fly|Ride"] = 118.13, ["Neon"] = 14.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 338.93, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.14, ["Fly"] = 65.63, ["Ride"] = 26.24, ["Fly|Ride"] = 430.08, ["Neon"] = 26.7, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 23.57, ["Fly|Ride"] = 79.58, ["Neon"] = 16.89, ["Neon|Fly"] = 115.06, ["Neon|Ride"] = 40.78, ["Neon|Fly|Ride"] = 99.03, ["Mega"] = 262.5, ["Mega|Ride"] = 301.19, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 17.63, ["Fly|Ride"] = 51.89, ["Neon"] = 15.65, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 107.27, ["Mega"] = 256.25, ["Mega|Ride"] = 214.52, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 91.86, ["Neon"] = 11.81, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 45.47, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 118.13, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.37, ["Fly"] = 215.06, ["Ride"] = 101.83, ["Fly|Ride"] = 236.25, ["Neon"] = 143.15, ["Neon|Ride"] = 275.68, ["Neon|Fly|Ride"] = 378, ["Mega"] = 582.75, ["Mega|Ride"] = 546, ["Mega|Fly|Ride"] = 687.75}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 46.67, ["Fly"] = 164.07, ["Ride"] = 82.69, ["Fly|Ride"] = 181.13, ["Neon"] = 200.43, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1569.65, ["Mega|Ride"] = 1063.02, ["Mega|Fly|Ride"] = 1115.62}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 65.76, ["Neon"] = 2.1, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 28.21, ["Mega|Ride"] = 47.45, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.07, ["Ride"] = 52.5, ["Neon"] = 287.1, ["Mega"] = 686.56, ["Mega|Ride"] = 686.42, ["Mega|Fly|Ride"] = 1069.3}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.36, ["Ride"] = 91.88, ["Fly|Ride"] = 183.75, ["Neon"] = 290.24, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 856.95, ["Mega"] = 1757.85, ["Mega|Ride"] = 1620.57, ["Mega|Fly|Ride"] = 1344.94}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.89, ["Fly"] = 190.32, ["Ride"] = 28.63, ["Fly|Ride"] = 133.88, ["Neon"] = 36.39, ["Neon|Fly"] = 130.29, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.94, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 179.82, ["Neon"] = 10.44, ["Neon|Ride"] = 67.5, ["Neon|Fly|Ride"] = 171.62, ["Mega"] = 100.68, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 423.84, ["Mega|Fly|Ride"] = 858.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 5.25, ["Fly"] = 40.6, ["Ride"] = 19.23, ["Fly|Ride"] = 37.8, ["Neon"] = 10.39, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 236.15, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 318.19, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 10.49, ["Fly|Ride"] = 31.5, ["Neon"] = 2.62, ["Neon|Fly"] = 25.92, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 46.17, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Fly|Ride"] = 42.74, ["Neon"] = 3.71, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 39.36, ["Mega|Fly"] = 167.6, ["Mega|Ride"] = 100.84, ["Mega|Fly|Ride"] = 189.69}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 1.79, ["Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 145.07, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.35, ["Ride"] = 157.5, ["Neon"] = 30.56, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 643.52, ["Mega"] = 429.02, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 324.26}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.11, ["Ride"] = 34.11, ["Fly|Ride"] = 202.98, ["Neon"] = 53.06, ["Neon|Ride"] = 100.84, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 286.78, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.8, ["Fly"] = 29.05, ["Ride"] = 18.37, ["Fly|Ride"] = 39.79, ["Neon"] = 32.82, ["Neon|Ride"] = 30.11, ["Neon|Fly|Ride"] = 81.64, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 321.2}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 57.29, ["Ride"] = 100.93, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2428.82, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 21.52, ["Fly"] = 82.69, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.79, ["Ride"] = 15.75, ["Fly|Ride"] = 38, ["Neon"] = 3.94, ["Neon|Fly"] = 42.99, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 60.08, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.18, ["Ride"] = 14.43, ["Fly|Ride"] = 35.35, ["Neon"] = 3.56, ["Neon|Fly"] = 24.36, ["Neon|Ride"] = 21.42, ["Neon|Fly|Ride"] = 52.23, ["Mega"] = 39.38, ["Mega|Ride"] = 57.26, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.8, ["Ride"] = 446.24, ["Fly|Ride"] = 569.63, ["Neon|Fly|Ride"] = 1968.75}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.1, ["Fly"] = 107.54, ["Ride"] = 65.62, ["Fly|Ride"] = 535.43, ["Neon"] = 40.69, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 156.6, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 1.79, ["Fly"] = 15.25, ["Ride"] = 19, ["Fly|Ride"] = 32.06, ["Neon"] = 5.2, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 20.44, ["Neon|Fly|Ride"] = 50.43, ["Mega"] = 143.73, ["Mega|Ride"] = 75.09, ["Mega|Fly|Ride"] = 113.99}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 56.02, ["Ride"] = 90.18, ["Fly|Ride"] = 537.6, ["Neon"] = 208.41, ["Neon|Ride"] = 301.77, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 728.44, ["Mega|Ride"] = 761.23, ["Mega|Fly|Ride"] = 851.03}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 17.84, ["Fly|Ride"] = 56.44, ["Neon"] = 11.57, ["Neon|Fly"] = 63.46, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 67.23, ["Mega"] = 111.46, ["Mega|Ride"] = 138.85, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 1.79, ["Fly"] = 70.88, ["Ride"] = 21, ["Neon"] = 3.92, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 17.34, ["Mega|Ride"] = 87.72, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 26.23, ["Fly"] = 129.04, ["Ride"] = 76.13, ["Neon"] = 174.57, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 792.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 17.75, ["Neon"] = 4.89, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 79.37, ["Mega"] = 36.75, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.4, ["Ride"] = 68.06, ["Fly|Ride"] = 122.07, ["Neon"] = 430.08, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1694.58, ["Mega|Ride"] = 1716.02, ["Mega|Fly|Ride"] = 1572.31}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 183.74, ["Neon"] = 22.15, ["Neon|Ride"] = 64.16, ["Neon|Fly|Ride"] = 500.88, ["Mega"] = 170.63, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 69.87, ["Neon"] = 8.64, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 91.09, ["Mega|Ride"] = 171.62, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 37.79, ["Fly"] = 144.09, ["Ride"] = 50.93, ["Fly|Ride"] = 537.6, ["Mega"] = 3216.46, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2003.46}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 400.75, ["Ride"] = 38.07, ["Fly|Ride"] = 908.99, ["Neon"] = 4.89, ["Neon|Ride"] = 86.24, ["Neon|Fly|Ride"] = 284.2, ["Mega"] = 48.57, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 16.85, ["Fly|Ride"] = 98.44, ["Neon"] = 10.92, ["Neon|Fly"] = 48.72, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 100.84, ["Mega"] = 97.16, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 18.27, ["Fly"] = 58.5, ["Ride"] = 31.4, ["Fly|Ride"] = 76.94, ["Neon"] = 81.8, ["Neon|Ride"] = 94.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 328.12, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 4.87, ["Ride"] = 32.27, ["Fly|Ride"] = 70.55, ["Neon"] = 65.76, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 151.68, ["Mega"] = 750.78, ["Mega|Ride"] = 454.55, ["Mega|Fly|Ride"] = 509.19}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.09, ["Fly"] = 51.18, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 74.28, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 77.97, ["Mega"] = 572.74, ["Mega|Ride"] = 323.53, ["Mega|Fly|Ride"] = 414.03}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.37, ["Fly"] = 135.19, ["Ride"] = 114.32, ["Fly|Ride"] = 274.18, ["Neon"] = 318.3, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 583.46, ["Mega|Ride"] = 1499.37, ["Mega|Fly|Ride"] = 1309.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.87, ["Ride"] = 28.88, ["Neon"] = 48.56, ["Neon|Ride"] = 121.72, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 234.3, ["Mega|Ride"] = 388.62, ["Mega|Fly|Ride"] = 415.08}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.58, ["Ride"] = 26.88, ["Fly|Ride"] = 72.05, ["Neon"] = 18.51, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 171.05, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.38, ["Fly"] = 287.55, ["Ride"] = 28.45, ["Fly|Ride"] = 160.13, ["Neon"] = 65.63, ["Neon|Ride"] = 105, ["Mega"] = 454.2, ["Mega|Ride"] = 536.27, ["Mega|Fly|Ride"] = 745.66}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.44, ["Fly|Ride"] = 32.48, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 14.7, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 94.79}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.62, ["Ride"] = 112.56, ["Fly|Ride"] = 287.1, ["Neon"] = 246.75, ["Neon|Fly"] = 2437.45, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 429.02, ["Mega"] = 1071.45, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.59, ["Fly|Ride"] = 36.58, ["Neon"] = 3.59, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49, ["Mega|Ride"] = 143.73, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 16.69, ["Fly|Ride"] = 59.06, ["Neon"] = 18.05, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 88.25, ["Mega"] = 257.25, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.49, ["Fly"] = 157.5, ["Ride"] = 76.77, ["Fly|Ride"] = 258.57, ["Neon"] = 277.65, ["Neon|Ride"] = 393.75, ["Mega"] = 940.74, ["Mega|Ride"] = 1765.32, ["Mega|Fly|Ride"] = 1418.94}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 1.85, ["Ride"] = 25.25, ["Neon"] = 7.56, ["Neon|Ride"] = 28.97, ["Mega"] = 64.32, ["Mega|Fly"] = 211.32, ["Mega|Ride"] = 108.03, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.25}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 1.79, ["Ride"] = 19.66, ["Fly|Ride"] = 497.54, ["Neon"] = 6.37, ["Neon|Ride"] = 51.89, ["Neon|Fly|Ride"] = 103.95, ["Mega"] = 47.24, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 127.32, ["Ride"] = 131.24, ["Fly|Ride"] = 292.22, ["Neon"] = 730.53, ["Neon|Ride"] = 786.19, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3432.03, ["Mega|Ride"] = 2506.88, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.73, ["Ride"] = 32.82, ["Fly|Ride"] = 215.06, ["Neon"] = 19.59, ["Neon|Fly"] = 144.09, ["Neon|Ride"] = 64.32, ["Mega"] = 178.39, ["Mega|Ride"] = 209.35, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 1.79, ["Fly"] = 26.25, ["Ride"] = 36.58, ["Neon"] = 3.93, ["Neon|Ride"] = 20.65, ["Mega"] = 31.4, ["Mega|Ride"] = 214.52, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.81, ["Ride"] = 21.32, ["Fly|Ride"] = 131.25, ["Neon"] = 51.8, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 405.43, ["Mega|Ride"] = 429.02, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.49, ["Fly"] = 75.28, ["Ride"] = 21.36, ["Fly|Ride"] = 56.58, ["Neon"] = 134.54, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 626.07, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 405.62}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.21, ["Ride"] = 64.09, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 485.78, ["Mega"] = 560.44, ["Mega|Ride"] = 658.53, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 132.41, ["Fly"] = 196.88, ["Ride"] = 181.13, ["Fly|Ride"] = 210, ["Neon"] = 565.13, ["Neon|Fly"] = 690.36, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 687.75, ["Mega|Fly|Ride"] = 2423.89}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.87, ["Fly"] = 16.28, ["Ride"] = 16.79, ["Fly|Ride"] = 43.55, ["Neon"] = 39.38, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 47.21, ["Neon|Fly|Ride"] = 78.64, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 15.75, ["Fly|Ride"] = 126.03, ["Neon"] = 16.44, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 139.22, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 323.05}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.03, ["Fly"] = 98.44, ["Ride"] = 27.57, ["Fly|Ride"] = 91.87, ["Neon"] = 114.6, ["Neon|Fly"] = 144.09, ["Neon|Ride"] = 83.55, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 379.32, ["Mega|Fly|Ride"] = 572.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 55.67, ["Fly"] = 160.7, ["Ride"] = 73.84, ["Fly|Ride"] = 166.69, ["Neon"] = 210, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1573.38, ["Mega|Ride"] = 1208.82, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.38, ["Ride"] = 63.84, ["Neon"] = 157.5, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 472.99, ["Mega"] = 714.31, ["Mega|Ride"] = 550.72}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 1575, ["Neon|Ride"] = 3238.82, ["Neon|Fly|Ride"] = 1716.02}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.82, ["Fly"] = 58.08, ["Ride"] = 32.21, ["Fly|Ride"] = 84, ["Neon"] = 199.69, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 324.26, ["Mega"] = 761.25, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 1.79, ["Fly"] = 38.75, ["Ride"] = 13.68, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Ride"] = 17.82, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 20.29, ["Mega|Fly"] = 113.7, ["Mega|Ride"] = 30, ["Mega|Fly|Ride"] = 105.97}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Ride"] = 36.47, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 164.17, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 72.05, ["Neon"] = 18.27, ["Neon|Ride"] = 83.07, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 115.4, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 322.23}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 393.74, ["Fly|Ride"] = 453.48, ["Neon"] = 1535.43, ["Neon|Ride"] = 2060.63, ["Neon|Fly|Ride"] = 1246.87, ["Mega|Fly|Ride"] = 5184.38}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 37.97, ["Ride"] = 15.38, ["Fly|Ride"] = 58.08, ["Neon"] = 19.69, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 170.52, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.23, ["Fly"] = 19.99, ["Ride"] = 15.65, ["Fly|Ride"] = 32.82, ["Neon"] = 20.44, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 72.89, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 273.51, ["Mega|Fly|Ride"] = 321.27}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 14.13, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 111.56, ["Mega|Ride"] = 257.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 32.47, ["Fly"] = 44.88, ["Ride"] = 44.63, ["Fly|Ride"] = 65.63, ["Neon"] = 220.29, ["Neon|Ride"] = 188.71, ["Neon|Fly|Ride"] = 320.7, ["Mega"] = 1312.5, ["Mega|Ride"] = 856.95, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34.11, ["Fly|Ride"] = 49.68, ["Neon"] = 11.82, ["Neon|Ride"] = 32.26, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 8.6, ["Fly"] = 65.59, ["Ride"] = 35.44, ["Fly|Ride"] = 91.87, ["Neon"] = 168.9, ["Neon|Ride"] = 209.99, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 6.18, ["Neon|Ride"] = 35.42, ["Mega"] = 54.37, ["Mega|Ride"] = 122.28, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.5, ["Neon"] = 39.38, ["Mega|Ride"] = 324.26, ["Mega|Fly|Ride"] = 697.6}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.27, ["Ride"] = 48.72, ["Neon"] = 79.85, ["Neon|Ride"] = 485.78, ["Mega"] = 316.41, ["Mega|Ride"] = 556.64, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 8.63, ["Fly"] = 30.19, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 52.5, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 54.49, ["Neon|Fly|Ride"] = 105, ["Mega"] = 602.77, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 321.4, ["Fly"] = 483.84, ["Ride"] = 282.19, ["Fly|Ride"] = 411.55, ["Neon"] = 1642.41, ["Neon|Ride"] = 1651.68, ["Neon|Fly|Ride"] = 1666.69, ["Mega|Fly|Ride"] = 7218.75}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 15.75, ["Neon|Fly"] = 81.59, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 214.52, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 107.54, ["Ride"] = 40.28, ["Fly|Ride"] = 131.25, ["Neon"] = 59.64, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 345.75, ["Mega|Fly"] = 715.38, ["Mega|Ride"] = 411.64, ["Mega|Fly|Ride"] = 503.99}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 35.23, ["Ride"] = 101.77, ["Fly|Ride"] = 315, ["Neon"] = 121.77, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 421.41, ["Mega"] = 422.62, ["Mega|Ride"] = 4290.04, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 62.32, ["Fly"] = 130.27, ["Ride"] = 91.65, ["Fly|Ride"] = 189.06, ["Neon"] = 320.25, ["Neon|Ride"] = 425.25, ["Neon|Fly|Ride"] = 1457.31, ["Mega"] = 2492.09, ["Mega|Ride"] = 1906.04, ["Mega|Fly|Ride"] = 1515.83}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 23.22, ["Fly"] = 107.54, ["Ride"] = 96.78, ["Fly|Ride"] = 142.64, ["Neon"] = 41.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 193.1, ["Mega|Ride"] = 810.03, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 12.8, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 126, ["Mega"] = 65.61, ["Mega|Ride"] = 148.17, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.72, ["Ride"] = 56.35, ["Fly|Ride"] = 64.32, ["Neon"] = 25.69, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 176.77, ["Mega|Ride"] = 162.75}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 53.26, ["Fly"] = 137.82, ["Ride"] = 102.79, ["Fly|Ride"] = 214.39, ["Neon"] = 139.04, ["Neon|Ride"] = 185.28, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 447.33, ["Mega|Ride"] = 446.11, ["Mega|Fly|Ride"] = 542.07}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.42, ["Ride"] = 154.64, ["Neon"] = 4.89, ["Neon|Fly"] = 65.76, ["Neon|Ride"] = 214.52, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 47.92, ["Mega|Ride"] = 187.04, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 20.48, ["Neon"] = 139.13, ["Neon|Ride"] = 502.13, ["Neon|Fly|Ride"] = 858.02, ["Mega"] = 569.67, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 1194.38, ["Ride"] = 1008.32, ["Fly|Ride"] = 1049.88, ["Neon"] = 3438.45, ["Neon|Ride"] = 3689.44, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 10868.79}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.64, ["Fly"] = 54.86, ["Ride"] = 32.78, ["Fly|Ride"] = 143.16, ["Neon"] = 117.97, ["Neon|Fly"] = 707.44, ["Neon|Ride"] = 278.87, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 326.48, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.37, ["Ride"] = 19.46, ["Fly|Ride"] = 80.92, ["Neon"] = 9.34, ["Neon|Ride"] = 34.91, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 84.4, ["Mega|Ride"] = 143.15, ["Mega|Fly|Ride"] = 191.09}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.88, ["Ride"] = 50.34, ["Fly|Ride"] = 144.09, ["Neon"] = 53.82, ["Mega"] = 429.02, ["Mega|Ride"] = 541.86, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.07, ["Fly|Ride"] = 182.97, ["Neon"] = 2.58, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 80.07, ["Mega"] = 17.07, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 190.98}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 54.87, ["Ride"] = 144.09, ["Fly|Ride"] = 236.25, ["Neon"] = 244.02, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 414.39, ["Mega"] = 918.75, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 913.02}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 14.06, ["Ride"] = 59.07, ["Fly|Ride"] = 266.43, ["Neon"] = 81.19, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 572.74, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 27.81, ["Neon"] = 8.57, ["Neon|Ride"] = 30.19, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 472.99}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.49, ["Fly"] = 67.75, ["Ride"] = 54.86, ["Fly|Ride"] = 106.46, ["Neon"] = 134.95, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 1039.49, ["Mega|Ride"] = 391.6, ["Mega|Fly|Ride"] = 444.89}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.87, ["Fly"] = 33.35, ["Ride"] = 26.25, ["Fly|Ride"] = 96.78, ["Neon"] = 110.81, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 123.94, ["Mega"] = 429.02, ["Mega|Ride"] = 536.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.38, ["Ride"] = 208.68, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2103.24, ["Mega|Ride"] = 1645.24, ["Mega|Fly|Ride"] = 2145.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.1, ["Neon"] = 21.33, ["Neon|Ride"] = 100.84, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 86.52, ["Mega|Ride"] = 132.92, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.14, ["Ride"] = 19.59, ["Fly|Ride"] = 32.82, ["Neon"] = 39.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 295.32, ["Mega|Ride"] = 422.62, ["Mega|Fly|Ride"] = 715.38}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 104.41, ["Fly"] = 393.75, ["Ride"] = 161.44, ["Fly|Ride"] = 250.13, ["Neon"] = 446.25, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 786.18, ["Mega|Ride"] = 2431.38, ["Mega|Fly|Ride"] = 1945.79}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 19.69, ["Fly|Ride"] = 45.27, ["Neon"] = 12.98, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 32.19, ["Neon|Fly|Ride"] = 83.09, ["Mega"] = 166.26, ["Mega|Ride"] = 214.52, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 10.5, ["Fly"] = 200.81, ["Ride"] = 44.6, ["Fly|Ride"] = 114.84, ["Neon"] = 122.14, ["Neon|Ride"] = 85.56, ["Neon|Fly|Ride"] = 179.13, ["Mega"] = 452.82, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 496.1}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.18, ["Ride"] = 14.9, ["Fly|Ride"] = 44.63, ["Neon"] = 2.1, ["Neon|Fly"] = 26.99, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 40.04, ["Mega"] = 15.09, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 34.8, ["Mega|Fly|Ride"] = 79.94}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.08, ["Fly|Ride"] = 39.38, ["Neon"] = 2.61, ["Neon|Ride"] = 42.91, ["Neon|Fly|Ride"] = 133.01, ["Mega"] = 20.75, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.58, ["Ride"] = 24.7, ["Fly|Ride"] = 133.88, ["Neon"] = 19.37, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 84, ["Mega|Ride"] = 272.44, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.82, ["Ride"] = 52.5, ["Fly|Ride"] = 131.25, ["Neon"] = 168, ["Neon|Ride"] = 343.22, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 547.31, ["Mega|Ride"] = 729.31, ["Mega|Fly|Ride"] = 953.48}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 20.31, ["Ride"] = 15.78, ["Fly|Ride"] = 36.75, ["Neon"] = 12.18, ["Neon|Fly"] = 32.93, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 56.34, ["Mega"] = 110.25, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 126.57, ["Mega|Fly|Ride"] = 161.43}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.56, ["Fly"] = 26.24, ["Ride"] = 24.91, ["Fly|Ride"] = 82.65, ["Neon"] = 32.16, ["Neon|Fly"] = 53.53, ["Neon|Ride"] = 42.91, ["Neon|Fly|Ride"] = 114.77, ["Mega"] = 228.38, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 235.59, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 18.09, ["Fly|Ride"] = 73.13, ["Neon"] = 8.24, ["Neon|Fly"] = 36.58, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 162.74, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 126.73}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 42.62, ["Fly"] = 162.37, ["Ride"] = 23.83, ["Fly|Ride"] = 217.19, ["Neon"] = 26.17, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 261.74, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 383.35, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 15.74, ["Ride"] = 190.2, ["Neon"] = 74.76, ["Neon|Ride"] = 262.39, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 1001.74}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.53, ["Fly"] = 22.83, ["Ride"] = 20, ["Fly|Ride"] = 45.85, ["Neon"] = 26.81, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 54.71, ["Neon|Fly|Ride"] = 154.2, ["Mega"] = 238.74, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 13.73, ["Fly|Ride"] = 36.53, ["Neon"] = 21.52, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 33.35, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 187.7, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 291.47}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 191.35, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1075.19, ["Neon|Ride"] = 1457.31, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4122.57}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.67, ["Ride"] = 112.88, ["Neon"] = 35.44, ["Neon|Ride"] = 143.73, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.13, ["Fly"] = 107, ["Ride"] = 24.42, ["Fly|Ride"] = 84.14, ["Neon"] = 23.15, ["Neon|Fly"] = 244.08, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.56, ["Mega|Ride"] = 285.31, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 4.86, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 227.38, ["Neon|Fly|Ride"] = 643.52, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.45, ["Fly|Ride"] = 30.51, ["Neon"] = 2.62, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 16.84, ["Neon|Fly|Ride"] = 39.36, ["Mega"] = 21.42, ["Mega|Fly"] = 85.81, ["Mega|Ride"] = 41.67, ["Mega|Fly|Ride"] = 88.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.86, ["Ride"] = 16.67, ["Fly|Ride"] = 41.24, ["Neon"] = 10.4, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 98.76, ["Mega"] = 114.18, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 144.09, ["Neon"] = 7.88, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 107.62, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 67.62, ["Ride"] = 89.11, ["Fly|Ride"] = 141.75, ["Neon"] = 341.25, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 648.51, ["Mega|Ride"] = 3576.83, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Fly|Ride"] = 100.68, ["Neon"] = 23.13, ["Neon|Ride"] = 66.94, ["Mega"] = 167.98, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 578.1}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.47, ["Ride"] = 19.74, ["Neon"] = 5.06, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 545.28, ["Mega"] = 66.94, ["Mega|Fly"] = 315, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.57, ["Fly"] = 210, ["Ride"] = 104.98, ["Fly|Ride"] = 90.57, ["Neon"] = 144.37, ["Neon|Ride"] = 192.83, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 590.63, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 1.79, ["Fly"] = 9.19, ["Ride"] = 14.3, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 42.82, ["Mega"] = 27.96, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Fly|Ride"] = 107.54, ["Neon"] = 3.53, ["Neon|Ride"] = 46.3, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 24.63, ["Mega|Ride"] = 92.69, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 107.63, ["Neon"] = 8.57, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 89.88, ["Neon|Fly|Ride"] = 142.95, ["Mega"] = 77.44, ["Mega|Fly"] = 186.63, ["Mega|Ride"] = 113.3}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.93, ["Fly"] = 78.75, ["Ride"] = 32.48, ["Fly|Ride"] = 128.33, ["Neon"] = 22.8, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 115.39, ["Mega|Fly"] = 348.55, ["Mega|Ride"] = 324.26, ["Mega|Fly|Ride"] = 258.54}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.01, ["Ride"] = 13.98, ["Fly|Ride"] = 45.17, ["Neon"] = 2.5, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 18.04, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.91, ["Fly"] = 131.25, ["Ride"] = 86.94, ["Neon"] = 129.94, ["Neon|Fly"] = 430.08, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 572.74, ["Mega|Ride"] = 564.93, ["Mega|Fly|Ride"] = 697.09}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2425.5, ["Fly|Ride"] = 2623.69, ["Neon|Fly|Ride"] = 9579.64, ["Mega|Fly|Ride"] = 42899.2}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.76, ["Ride"] = 15.75, ["Fly|Ride"] = 44.63, ["Neon"] = 7.21, ["Neon|Fly"] = 64.24, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 86.63, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 177.08}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 7.66, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 214.52}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.38, ["Fly"] = 43.02, ["Ride"] = 23.63, ["Fly|Ride"] = 121.77, ["Neon"] = 72.19, ["Neon|Ride"] = 114.57, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 426.57, ["Mega|Ride"] = 380.69, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 33.29, ["Ride"] = 52.4, ["Neon"] = 161.44, ["Mega"] = 749.69, ["Mega|Ride"] = 607.05, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.94, ["Fly"] = 244.08, ["Ride"] = 209.89, ["Fly|Ride"] = 251.5, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 714.65, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6435.06, ["Mega|Fly|Ride"] = 3529.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.36, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 19.67, ["Neon|Ride"] = 82.01, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 260.64, ["Mega|Fly"] = 13125, ["Mega|Fly|Ride"] = 364.66}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 72.05, ["Neon"] = 26.25, ["Mega"] = 177.19, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 100.04, ["Ride"] = 26.23, ["Fly|Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Fly"] = 126.89, ["Neon|Ride"] = 40.04, ["Mega"] = 104.98, ["Mega|Ride"] = 101.42, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17.22, ["Ride"] = 86.03, ["Neon"] = 98.24, ["Neon|Ride"] = 1218.07, ["Neon|Fly|Ride"] = 505.17, ["Mega"] = 380.63, ["Mega|Ride"] = 475.14, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 1.79, ["Ride"] = 43.02, ["Neon"] = 2.1, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 48.59, ["Mega"] = 21.8, ["Mega|Fly"] = 121.46, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 87.84, ["Fly"] = 105, ["Ride"] = 104.9, ["Fly|Ride"] = 159.14, ["Neon"] = 346.5, ["Neon|Fly"] = 460.19, ["Neon|Ride"] = 405.62, ["Neon|Fly|Ride"] = 330.87, ["Mega"] = 1130.43, ["Mega|Fly|Ride"] = 1878.7}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 7.88, ["Neon|Ride"] = 71.87, ["Neon|Fly|Ride"] = 214.52, ["Mega"] = 77.24, ["Mega|Ride"] = 282.85, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.43, ["Fly"] = 103.24, ["Ride"] = 71.74, ["Fly|Ride"] = 182.44, ["Neon"] = 339.94, ["Neon|Ride"] = 272.44, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2860.39}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.34, ["Fly|Ride"] = 51.32, ["Neon"] = 4.83, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 213.84}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 8.57, ["Neon|Ride"] = 98.43, ["Mega"] = 62.61, ["Mega|Ride"] = 152.46}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.87, ["Fly"] = 77.44, ["Ride"] = 50.54, ["Neon"] = 27.57, ["Neon|Ride"] = 86.63, ["Mega"] = 314.99, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 570.59}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 371.44, ["Ride"] = 389.82, ["Fly|Ride"] = 787.5, ["Neon"] = 1050, ["Neon|Ride"] = 964.67, ["Neon|Fly|Ride"] = 1143.9, ["Mega|Ride"] = 2802.19, ["Mega|Fly|Ride"] = 3916.6}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 27.57, ["Fly"] = 86.03, ["Ride"] = 40.34, ["Fly|Ride"] = 107.57, ["Neon"] = 196.88, ["Neon|Ride"] = 171.29, ["Neon|Fly|Ride"] = 320.7, ["Mega"] = 1428.59, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.68, ["Fly|Ride"] = 86.03, ["Neon"] = 11.68, ["Neon|Fly"] = 139.79, ["Neon|Ride"] = 96.78, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 120.75, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.29, ["Fly"] = 74.81, ["Ride"] = 38.98, ["Fly|Ride"] = 170.63, ["Neon"] = 68.91, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 183.43, ["Mega"] = 279.29, ["Mega|Fly"] = 999.47, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.91, ["Fly"] = 58.08, ["Ride"] = 37.68, ["Fly|Ride"] = 196.88, ["Neon"] = 101.35, ["Neon|Ride"] = 107.69, ["Neon|Fly|Ride"] = 275.68, ["Mega"] = 429.02, ["Mega|Ride"] = 685.35, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.47, ["Neon"] = 17.06, ["Neon|Fly"] = 72.19, ["Mega"] = 91.86, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 277.79}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.52, ["Fly|Ride"] = 65.63, ["Neon"] = 39.29, ["Neon|Ride"] = 45.93, ["Mega"] = 111.57, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 91.25, ["Ride"] = 129.93, ["Fly|Ride"] = 242.82, ["Neon"] = 803.18, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.51, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3217.54}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.09, ["Ride"] = 37.8, ["Fly|Ride"] = 124.69, ["Neon"] = 210, ["Neon|Ride"] = 237.04, ["Neon|Fly|Ride"] = 284.47, ["Mega|Fly|Ride"] = 1144.38}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2030.44, ["Fly"] = 2030.44, ["Ride"] = 1959.02, ["Fly|Ride"] = 2060.63, ["Neon"] = 11468.99, ["Neon|Fly|Ride"] = 6954.94, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 57.66, ["Fly|Ride"] = 196.87, ["Neon"] = 18.92, ["Neon|Fly|Ride"] = 643.52, ["Mega"] = 113.27, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 162.74, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.79, ["Ride"] = 39.38, ["Fly|Ride"] = 111.07, ["Neon"] = 52.5, ["Neon|Ride"] = 76.53, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 182.34, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 858.02}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 874.74, ["Fly"] = 1107.73, ["Ride"] = 903, ["Fly|Ride"] = 990.94, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2485.88, ["Mega"] = 13299.08, ["Mega|Fly|Ride"] = 11496.79}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.5, ["Ride"] = 48.56, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 425.92, ["Neon|Fly|Ride"] = 383.77, ["Mega"] = 774.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 128.15, ["Neon"] = 10.89, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 319.62, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 144.09, ["Neon"] = 3.11, ["Neon|Ride"] = 49.14, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.69, ["Mega|Ride"] = 61.6, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 118.13, ["Ride"] = 128.63, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 607.21, ["Neon|Fly|Ride"] = 643.52, ["Mega"] = 2428.82, ["Mega|Fly|Ride"] = 2145.03}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.56, ["Ride"] = 37.75, ["Fly|Ride"] = 74.01, ["Neon"] = 15.6, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 106.2, ["Mega"] = 143.73, ["Mega|Ride"] = 122.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.59, ["Fly"] = 107.54, ["Ride"] = 126, ["Fly|Ride"] = 91.88, ["Neon"] = 459.37, ["Neon|Ride"] = 429.02, ["Neon|Fly|Ride"] = 572.74, ["Mega|Fly|Ride"] = 1821.14}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.15, ["Fly"] = 105, ["Fly|Ride"] = 129.04, ["Neon"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.4, ["Mega|Ride"] = 323}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.5, ["Fly"] = 354.38, ["Ride"] = 262.5, ["Fly|Ride"] = 326.82, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 4663.28}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 24.85, ["Fly|Ride"] = 45.94, ["Neon"] = 30.18, ["Neon|Ride"] = 57.63, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 280.22, ["Mega|Ride"] = 318.93, ["Mega|Fly|Ride"] = 697.15}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 1.79, ["Fly"] = 19.37, ["Ride"] = 16.92, ["Fly|Ride"] = 32.81, ["Neon"] = 6.36, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 46.12, ["Mega"] = 40.43, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 124.73}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1278.53, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7865.78, ["Neon|Fly|Ride"] = 6721.41, ["Mega"] = 23802.35, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 7.88, ["Fly"] = 994.12, ["Ride"] = 81.59, ["Neon"] = 65.62, ["Neon|Ride"] = 314.98, ["Mega"] = 244.12, ["Mega|Ride"] = 530.92, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.87, ["Fly"] = 39.38, ["Ride"] = 54.63, ["Fly|Ride"] = 91.88, ["Neon"] = 18.27, ["Neon|Fly"] = 46.25, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 275.68, ["Mega|Ride"] = 157.4, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.04, ["Fly"] = 51.33, ["Ride"] = 31.49, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 209.77, ["Neon|Fly|Ride"] = 214.39, ["Mega|Ride"] = 1134.28, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 16.16, ["Fly"] = 86.03, ["Ride"] = 28.87, ["Fly|Ride"] = 77.44, ["Neon"] = 57.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 179.69, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 374}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 45.46, ["Ride"] = 103.69, ["Fly|Ride"] = 419.34, ["Neon"] = 189, ["Neon|Ride"] = 499.8, ["Neon|Fly|Ride"] = 543.77, ["Mega"] = 1050, ["Mega|Ride"] = 672.48, ["Mega|Fly|Ride"] = 696.06}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 1.79, ["Ride"] = 116.61, ["Fly|Ride"] = 287.1, ["Neon"] = 3.29, ["Neon|Ride"] = 114.17, ["Neon|Fly|Ride"] = 107.27, ["Mega"] = 19.23, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 276.29}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 72.19, ["Fly"] = 106.86, ["Ride"] = 87.9, ["Fly|Ride"] = 177.27, ["Neon"] = 446.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 429.02, ["Mega"] = 3432.03, ["Mega|Fly|Ride"] = 1666.24}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 31.67, ["Fly|Ride"] = 72.05, ["Neon"] = 86.03, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 171.62, ["Mega"] = 773.06, ["Mega|Ride"] = 433.79, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 29.05, ["Ride"] = 18.37, ["Fly|Ride"] = 38.16, ["Neon"] = 18.38, ["Neon|Fly"] = 81.59, ["Neon|Ride"] = 96.78, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.92, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 141.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 485.78}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 49.67, ["Ride"] = 114.57, ["Fly|Ride"] = 262.5, ["Neon"] = 326.82, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 727.12, ["Mega"] = 2205, ["Mega|Ride"] = 1577.52, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Fly|Ride"] = 430.08, ["Neon"] = 25.06, ["Mega"] = 126.88, ["Mega|Ride"] = 143.73, ["Mega|Fly|Ride"] = 263.85}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 34.19, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 71.87, ["Mega"] = 20.98, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 1.79, ["Fly"] = 102.94, ["Ride"] = 35.39, ["Fly|Ride"] = 136, ["Neon"] = 2.1, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 71.87, ["Mega"] = 13.12, ["Mega|Ride"] = 142.96, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.04, ["Fly|Ride"] = 49.25, ["Neon"] = 8.57, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 86.24, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.52, ["Neon"] = 24.93, ["Mega"] = 118.09, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon"] = 8.01, ["Neon|Fly"] = 215.06, ["Neon|Ride"] = 28.93, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 241.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 59.77, ["Ride"] = 101.73, ["Fly|Ride"] = 273.11, ["Neon"] = 210, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1072.53, ["Mega"] = 694.32, ["Mega|Ride"] = 1047.38, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.04, ["Ride"] = 15.83, ["Fly|Ride"] = 36.58, ["Neon"] = 2.37, ["Neon|Fly"] = 27.46, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 58.07, ["Mega"] = 27.36, ["Mega|Ride"] = 30.82, ["Mega|Fly|Ride"] = 114.77}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.16, ["Fly"] = 80.21, ["Ride"] = 25.76, ["Fly|Ride"] = 68.25, ["Neon"] = 42.25, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 63.65, ["Neon|Fly|Ride"] = 105, ["Mega"] = 427.28, ["Mega|Ride"] = 236.9, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.58, ["Fly"] = 72.18, ["Ride"] = 39.36, ["Fly|Ride"] = 100.68, ["Neon"] = 130.05, ["Neon|Ride"] = 137.7, ["Neon|Fly|Ride"] = 182.95, ["Mega"] = 787.5, ["Mega|Ride"] = 785.09, ["Mega|Fly|Ride"] = 648.01}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.5, ["Fly"] = 196.88, ["Neon"] = 65.54, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 259.9, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.28, ["Fly|Ride"] = 43.84, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.41, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 39.36, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 106.77}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.55, ["Fly"] = 72.19, ["Ride"] = 38.07, ["Neon"] = 24.96, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 112.53, ["Mega"] = 131.25, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 968.01, ["Ride"] = 957.06, ["Fly|Ride"] = 1008.3, ["Neon|Ride"] = 2421.56, ["Neon|Fly|Ride"] = 2450.22, ["Mega|Fly|Ride"] = 7197.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 157.5, ["Ride"] = 215.06, ["Fly|Ride"] = 636.4, ["Neon"] = 645.12, ["Neon|Ride"] = 600.62, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3216.46, ["Mega|Ride"] = 2288.74, ["Mega|Fly|Ride"] = 2524.7}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 58.08, ["Ride"] = 37.8, ["Neon"] = 6.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 209.14, ["Mega"] = 109.31, ["Mega|Fly|Ride"] = 1144.38}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 85.31, ["Ride"] = 122.33, ["Fly|Ride"] = 157.5, ["Neon"] = 392.41, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 433.12, ["Neon|Fly|Ride"] = 654.7, ["Mega"] = 1964.42, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1706.15}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 21.42, ["Neon"] = 19.69, ["Neon|Fly"] = 57.24, ["Neon|Ride"] = 50.57, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 285.22, ["Mega|Ride"] = 324.26, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 245.78, ["Fly"] = 337.62, ["Ride"] = 285.17, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1381.41, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4755.51}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 43.02, ["Fly|Ride"] = 225.26, ["Neon"] = 31.5, ["Neon|Fly"] = 36.58, ["Neon|Ride"] = 54.37, ["Mega"] = 393.74, ["Mega|Fly"] = 334.63, ["Mega|Ride"] = 648.51}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 43.21, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.17, ["Fly|Ride"] = 154.25, ["Neon"] = 112.94, ["Neon|Fly"] = 430.08, ["Neon|Ride"] = 119.74, ["Mega"] = 463.76, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Fly|Ride"] = 287.1, ["Neon"] = 20.69, ["Neon|Ride"] = 196.87, ["Mega"] = 242.9, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.85, ["Fly|Ride"] = 28.93, ["Neon"] = 2.62, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 34.99, ["Mega"] = 27.93, ["Mega|Ride"] = 37.88, ["Mega|Fly|Ride"] = 162.74}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5263.02, ["Ride"] = 5118.75, ["Fly|Ride"] = 4588.5, ["Neon"] = 32255.47, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 161921.43}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 52.5, ["Fly"] = 86.03, ["Ride"] = 56.43, ["Neon"] = 53.44, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 162.74, ["Mega"] = 210, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 429.02}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.41, ["Fly|Ride"] = 42, ["Neon"] = 11.24, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 179.13, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 456.78, ["Fly"] = 547.77, ["Ride"] = 444.92, ["Fly|Ride"] = 551.25, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1274.9, ["Mega|Fly|Ride"] = 6219.48}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.94, ["Ride"] = 33.78, ["Neon"] = 19.5, ["Mega"] = 140.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.9, ["Fly"] = 45.94, ["Ride"] = 36.74, ["Neon"] = 23.63, ["Neon|Fly"] = 119.36, ["Neon|Ride"] = 48.59, ["Neon|Fly|Ride"] = 316.41, ["Mega"] = 427.94, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.37, ["Ride"] = 18.37, ["Neon"] = 3.92, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.19, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.69, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 205.94}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 700.88, ["Ride"] = 693.93, ["Fly|Ride"] = 762.57, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9295.43}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.76, ["Ride"] = 52.5, ["Fly|Ride"] = 430.08, ["Neon"] = 36.75, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 286.38, ["Mega"] = 131.25, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.51, ["Fly"] = 236.15, ["Ride"] = 34, ["Fly|Ride"] = 144.09, ["Neon"] = 30.89, ["Neon|Ride"] = 59.01, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 354.27, ["Mega|Fly"] = 810.03, ["Mega|Ride"] = 214.18, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 6.47, ["Fly"] = 34.12, ["Ride"] = 16.96, ["Fly|Ride"] = 60.23, ["Neon"] = 11.81, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 183.02, ["Mega|Ride"] = 150.94, ["Mega|Fly|Ride"] = 229.93}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.19, ["Ride"] = 34.12, ["Fly|Ride"] = 58.42, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 321.78, ["Mega"] = 856.95, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 858.02}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 430.08, ["Neon"] = 4.83, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 33.59, ["Mega|Fly"] = 128.71, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 504.16, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2612.65, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9472.38, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 107.54, ["Ride"] = 80.16, ["Fly|Ride"] = 194.81, ["Neon"] = 13.64, ["Neon|Ride"] = 93.09, ["Mega"] = 72.91, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 1.79, ["Ride"] = 33.64, ["Neon"] = 5.23, ["Neon|Fly"] = 107.54, ["Neon|Ride"] = 214.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 53.81, ["Mega|Ride"] = 143.73, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 41.24, ["Neon"] = 3.67, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.73, ["Mega"] = 46.96, ["Mega|Fly"] = 158.74, ["Mega|Ride"] = 106.74, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 13.01, ["Neon|Ride"] = 48.18, ["Mega"] = 234.89, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 29.86, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 102.92, ["Neon"] = 122.06, ["Neon|Ride"] = 139.12, ["Neon|Fly|Ride"] = 285.92, ["Mega"] = 648.51, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.57, ["Ride"] = 66.67, ["Fly|Ride"] = 93.56, ["Neon"] = 83.99, ["Neon|Ride"] = 145.74, ["Neon|Fly|Ride"] = 324.26, ["Mega"] = 381.94, ["Mega|Ride"] = 440.99, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 14.68, ["Fly|Ride"] = 32.81, ["Neon"] = 21.88, ["Neon|Fly"] = 72.05, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 88.1, ["Mega"] = 237.04, ["Mega|Ride"] = 286.38, ["Mega|Fly|Ride"] = 256.35}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 4.89, ["Ride"] = 56.04, ["Neon"] = 28.93, ["Neon|Ride"] = 141.59, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Fly|Ride"] = 87.05, ["Neon"] = 11.82, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 114.77, ["Mega"] = 62.98, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.99, ["Fly"] = 114.43, ["Ride"] = 26.24, ["Fly|Ride"] = 65.06, ["Neon"] = 10751.83, ["Neon|Ride"] = 162.74, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 841.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.45, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.12, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 470.54}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.94, ["Fly"] = 153.58, ["Ride"] = 85.32, ["Fly|Ride"] = 129.87, ["Neon"] = 465.11, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 431.82, ["Mega|Ride"] = 1717.19, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.53, ["Fly"] = 85.44, ["Ride"] = 76.73, ["Fly|Ride"] = 215.06, ["Neon"] = 143.32, ["Neon|Ride"] = 143.73, ["Neon|Fly|Ride"] = 315, ["Mega"] = 535.5, ["Mega|Ride"] = 686.42, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 20.69, ["Ride"] = 75.27, ["Neon"] = 114.27, ["Neon|Ride"] = 428.3, ["Mega"] = 1050, ["Mega|Ride"] = 750.78, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.65, ["Fly"] = 428.3, ["Ride"] = 50.42, ["Fly|Ride"] = 198.09, ["Neon"] = 136.4, ["Neon|Fly"] = 420, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 446.04, ["Mega|Ride"] = 569.81, ["Mega|Fly|Ride"] = 641.63}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 15.75, ["Fly|Ride"] = 32.73, ["Neon"] = 3.94, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 29.13, ["Neon|Fly|Ride"] = 53.65, ["Mega"] = 38.64, ["Mega|Fly"] = 324.26, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.83, ["Fly"] = 486.91, ["Ride"] = 97.12, ["Fly|Ride"] = 260.39, ["Neon"] = 379.19, ["Neon|Ride"] = 371.63, ["Neon|Fly|Ride"] = 493.37, ["Mega"] = 1280.58, ["Mega|Ride"] = 1520.84, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 1.79, ["Ride"] = 79.74, ["Neon"] = 3.93, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 298.05, ["Mega"] = 27.26, ["Mega|Ride"] = 81.53, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 47.25, ["Ride"] = 115.06, ["Fly|Ride"] = 163.16, ["Neon"] = 99.3, ["Neon|Ride"] = 133.95, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 524.99, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 685.35}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 1.79, ["Neon"] = 3.94, ["Mega"] = 24.04}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 40.69, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 103.68, ["Fly"] = 223.13, ["Ride"] = 143.07, ["Fly|Ride"] = 354.13, ["Neon"] = 558.03, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2131.29, ["Mega|Fly|Ride"] = 2037.77}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 27.98, ["Fly|Ride"] = 97.42, ["Neon"] = 6.46, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Fly|Ride"] = 50.93, ["Neon"] = 4.89, ["Neon|Ride"] = 25.75, ["Neon|Fly|Ride"] = 143.42, ["Mega"] = 30.07, ["Mega|Ride"] = 128.5, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 77.43, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 415.08}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 3.93, ["Neon|Ride"] = 156.19, ["Mega"] = 78.65, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.51, ["Ride"] = 118.13, ["Fly|Ride"] = 574.17, ["Neon"] = 437.07, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1608.77, ["Mega|Fly|Ride"] = 1606.62}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 67.75, ["Neon"] = 42, ["Neon|Ride"] = 227.06, ["Mega"] = 288.75, ["Mega|Ride"] = 972.29}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 365.4, ["Ride"] = 386.64, ["Fly|Ride"] = 784.11, ["Neon"] = 1365, ["Neon|Ride"] = 1430.75, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 3117.57}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 89.23}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.87}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 14.43}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 172.05}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 43.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.71}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.87}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 37.78}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 35.77}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.11}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.26}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 1.79}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.44}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 12.89}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.57}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.49}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 1.79}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 572.19}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 61.1}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1246.88}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.19}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.34}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.37}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 23.63}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 51.17}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.93}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 20.46}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.97}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.25}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.87}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 163.13}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 148.39}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.88}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.77}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2698.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 31.97}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 295.7}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.32}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.8}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 7.64}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.89}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.63}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 244.08}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 32.37}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 10.77}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 1.84}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 37.65}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 19.38}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 103.91}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.71}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 36.66}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.83}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.28}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 42.71}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 92.03}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 229.68}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.54}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 324.35}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 76.13}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23185.93}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 63.46}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 163.13}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 31.03}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 38.98}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 82.2}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.3}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 70.88}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 73.1}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 186.6}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.36}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 37.33}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 1.79}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 12.92}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.33}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 8.61}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 42.62}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.34}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.73}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.19}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.8}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 15.57}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1076.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.99}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.79}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.63}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 1.79}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.67}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 105}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.82}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 24.93}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 52.2}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 12.7}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.53}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.71}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 1.79}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 1.79}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.77}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 1.79}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.77}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.64}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 25.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 287.1}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 1.79}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 49.98}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 1.79}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 187.1}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.08}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.64}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.32}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 38.56}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.88}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.51}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.3}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.61}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.2}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 32.87}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.44}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 21.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.9}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.25}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 7.06}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.45}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 6.23}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 1.79}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.17}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8348.82}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 33.23}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.69}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.29}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 27.23}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 1.79}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 25.71}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.98}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.06}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 39.38}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 13.12}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.63}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4503.79}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.61}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.58}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.47}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.6}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.49}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.79}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 7.86}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 100.82}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.73}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.7}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.93}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.11}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.09}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 17.07}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.18}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.67}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 8.9}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.85}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.85}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 1.79}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 1.79}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.8}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 1.79}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.08}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 256.53}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 68.98}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.91}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.27}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1165.07}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 1.79}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 45.48}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 24.94}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 20.79}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.05}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.44}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.25}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.51}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.1}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.28}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.28}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 7.31}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.96}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.11}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.88}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.7}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.67}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.9}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.44}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 56.43}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.9}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.57}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.68}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 86.93}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.17}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.24}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 1.79}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 83.98}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 34.49}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 1.85}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.78}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.13}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.42}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.24}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 2.21}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.86}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 152.15}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.08}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1431.08}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.76}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 208.69}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 8.18}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 1.79}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 7.65}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.98}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.57}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 52.5}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 19.69}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 10.73}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 1.79}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 1.79}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 1.79}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 1.79}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 28.72}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.49}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.14}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 55.42}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.64}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.24}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 129.84}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 80.99}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.11}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 48.49}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 1.89}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 62.36}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.59}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 157.5}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.87}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 3.82}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 124.69}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.45}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 18.19}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 53.82}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 5.08}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.25}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 95.87}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 1.79}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 19.64}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 71.5}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 34.13}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 15.75}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 1.85}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 55.55}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.7}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.46}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.61}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 15.74}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 70.22}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 37.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 30.19}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 11.84}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 9.43}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 321.57}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.88}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.58}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 21.52}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.35}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 302.3}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.56}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.81}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 119.44}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 188.99}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 76.77}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 154.34}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 11.48}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
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