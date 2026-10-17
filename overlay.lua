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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1141.88, ["Ride"] = 1050, ["Fly|Ride"] = 1682.4, ["Neon"] = 6682.93, ["Neon|Fly|Ride"] = 5118.75}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.12, ["Fly"] = 637.28, ["Ride"] = 498.35, ["Fly|Ride"] = 538.13, ["Neon"] = 2076.71, ["Neon|Fly|Ride"] = 3182.75, ["Mega"] = 11933.78, ["Mega|Fly|Ride"] = 6960.86}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Ride"] = 5250, ["Fly|Ride"] = 4921.88, ["Neon|Fly|Ride"] = 22432.45, ["Mega|Fly|Ride"] = 70099.53}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 156.19, ["Ride"] = 220.83, ["Fly|Ride"] = 310.21, ["Neon"] = 982.1, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1031.52, ["Mega|Fly|Ride"] = 4318.48}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 543.14, ["Fly"] = 841.2, ["Ride"] = 505.31, ["Fly|Ride"] = 565.11, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6449.84}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.37, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 70.47, ["Neon|Fly"] = 280.76, ["Neon|Ride"] = 84.14, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 347.01, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.84, ["Fly"] = 40.6, ["Ride"] = 28.24, ["Fly|Ride"] = 64.32, ["Neon"] = 31.38, ["Neon|Fly"] = 99.75, ["Neon|Ride"] = 50.4, ["Neon|Fly|Ride"] = 126, ["Mega"] = 141.96, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 273.4}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 111.09, ["Ride"] = 185.07, ["Neon"] = 561.51, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2745.45}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.41, ["Fly"] = 97.76, ["Ride"] = 46.67, ["Fly|Ride"] = 95.76, ["Neon"] = 257.62, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 386.68, ["Mega"] = 1402.7, ["Mega|Ride"] = 1114.63, ["Mega|Fly|Ride"] = 918.73}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.14, ["Fly"] = 56.8, ["Ride"] = 27.44, ["Fly|Ride"] = 70.75, ["Neon"] = 207.66, ["Neon|Ride"] = 120.94, ["Neon|Fly|Ride"] = 78.75, ["Mega|Ride"] = 420.56, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.47, ["Fly"] = 126.19, ["Ride"] = 65.63, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 267.09, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 1248.13, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.28, ["Fly"] = 399, ["Ride"] = 326.81, ["Fly|Ride"] = 398.99, ["Neon"] = 1253.39, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 5046.11}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 65.63, ["Fly"] = 137.81, ["Ride"] = 127.56, ["Fly|Ride"] = 169.32, ["Neon|Fly"] = 689.79, ["Neon|Ride"] = 573.57, ["Neon|Fly|Ride"] = 578.33, ["Mega|Fly|Ride"] = 3063.41}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.44, ["Fly"] = 34.13, ["Ride"] = 17.92, ["Fly|Ride"] = 131.25, ["Neon"] = 22.32, ["Neon|Ride"] = 47.76, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 144.38, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 238.7}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.77, ["Fly"] = 223.13, ["Ride"] = 170.63, ["Fly|Ride"] = 213.93, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 692.9, ["Mega|Fly|Ride"] = 2992.4}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.62, ["Fly"] = 25.32, ["Ride"] = 16.2, ["Fly|Ride"] = 37.87, ["Neon"] = 30.51, ["Neon|Fly"] = 126.19, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 204.75, ["Mega|Fly"] = 358.03, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 405.77}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.45, ["Fly"] = 159.93, ["Ride"] = 123.44, ["Fly|Ride"] = 232.39, ["Neon"] = 259.88, ["Neon|Ride"] = 375.81, ["Neon|Fly|Ride"] = 426.16, ["Mega"] = 1682.4, ["Mega|Ride"] = 1419.5, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 38.49}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 168.25, ["Fly|Ride"] = 262.88, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 2102.99, ["Mega|Fly|Ride"] = 1964.19}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.28, ["Fly"] = 54.7, ["Ride"] = 32.82, ["Fly|Ride"] = 132.5, ["Neon"] = 315, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2744.78, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 140.44, ["Ride"] = 45.93, ["Fly|Ride"] = 103.68, ["Neon"] = 701.36, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 1670.74, ["Mega|Ride"] = 1009.44, ["Mega|Fly|Ride"] = 937.2}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 37.3, ["Ride"] = 111.56, ["Fly|Ride"] = 262.88, ["Neon"] = 210.31, ["Neon|Fly"] = 396.21, ["Neon|Ride"] = 380.72, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1273.35}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.19, ["Ride"] = 33.42, ["Fly|Ride"] = 83.91, ["Neon"] = 120.65, ["Neon|Ride"] = 209.26, ["Neon|Fly|Ride"] = 251.32, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 136.71, ["Ride"] = 57.66, ["Fly|Ride"] = 140.91, ["Neon"] = 325.5, ["Neon|Ride"] = 220.84, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.92, ["Fly"] = 26.17, ["Ride"] = 23.62, ["Fly|Ride"] = 49.24, ["Neon"] = 31.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 157.5, ["Mega|Fly"] = 27000.57, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 420, ["Fly|Ride"] = 567.82, ["Neon"] = 1997.84, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 9069.68}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 10.39, ["Ride"] = 32.82, ["Fly|Ride"] = 122.84, ["Neon"] = 214.81, ["Neon|Fly|Ride"] = 252.37, ["Mega|Ride"] = 799.15, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.94, ["Fly"] = 37.3, ["Ride"] = 20.96, ["Fly|Ride"] = 42.4, ["Neon"] = 52.47, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 124.72, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 74.85, ["Fly"] = 105.07, ["Ride"] = 92.25, ["Fly|Ride"] = 126.96, ["Neon"] = 374.35, ["Neon|Fly"] = 369.08, ["Neon|Ride"] = 372.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 6323.72, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.6, ["Ride"] = 32.23, ["Fly|Ride"] = 75.21, ["Neon"] = 89.83, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 201.21, ["Mega"] = 701.36, ["Mega|Ride"] = 716.04}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.42, ["Fly"] = 262.5, ["Ride"] = 205.64, ["Fly|Ride"] = 291.38, ["Neon"] = 780.49, ["Neon|Ride"] = 692.18, ["Neon|Fly|Ride"] = 735.38, ["Mega"] = 6308.94, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 21.95}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 32.81, ["Ride"] = 21.05, ["Fly|Ride"] = 55.12, ["Neon"] = 25.8, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 853.13, ["Fly"] = 2625, ["Ride"] = 890.7, ["Fly|Ride"] = 918.75, ["Neon"] = 6307.89, ["Neon|Ride"] = 4767.46, ["Neon|Fly|Ride"] = 4204.91, ["Mega|Ride"] = 53701.98, ["Mega|Fly|Ride"] = 16823.82}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.13, ["Fly"] = 49.41, ["Ride"] = 37.93, ["Fly|Ride"] = 91.88, ["Neon"] = 155.64, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 787.5, ["Mega|Ride"] = 1076.74, ["Mega|Fly|Ride"] = 795.99}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Fly"] = 358.03, ["Ride"] = 237.53, ["Fly|Ride"] = 277.61, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.75, ["Fly"] = 126.19, ["Ride"] = 42.08, ["Fly|Ride"] = 140.91, ["Neon"] = 85.03, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 336.49, ["Mega"] = 351.21, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 590.75}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 101.07, ["Ride"] = 144.24, ["Fly|Ride"] = 268.14, ["Neon"] = 477.37, ["Neon|Ride"] = 524.7, ["Neon|Fly|Ride"] = 496.12, ["Mega|Fly|Ride"] = 1902.38}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 101.22, ["Fly"] = 157.49, ["Ride"] = 143.53, ["Fly|Ride"] = 274.49, ["Neon"] = 387.19, ["Neon|Fly"] = 561.51, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 493.48, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 41.88}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 70.26, ["Fly"] = 79.26, ["Ride"] = 59.07, ["Fly|Ride"] = 63.92, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4205.96, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.16, ["Fly"] = 42.08, ["Ride"] = 42, ["Fly|Ride"] = 157.5, ["Neon"] = 42.08, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 236.59, ["Mega"] = 170.62, ["Mega|Fly"] = 358.03, ["Mega|Ride"] = 271.3, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 551.04, ["Fly"] = 614.95, ["Ride"] = 478.7, ["Fly|Ride"] = 548.15, ["Neon|Fly"] = 3785.37, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1756.12, ["Mega|Ride"] = 14720.84, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 94.85, ["Fly"] = 157.74, ["Ride"] = 127.71, ["Fly|Ride"] = 167.62, ["Neon"] = 477.37, ["Neon|Ride"] = 553.09, ["Neon|Fly|Ride"] = 491.07, ["Mega|Ride"] = 2523.59, ["Mega|Fly|Ride"] = 2532}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4205.96, ["Ride"] = 3885, ["Fly|Ride"] = 3784.31, ["Neon|Fly|Ride"] = 14719.79}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 54.99, ["Fly"] = 119.89, ["Ride"] = 57.51, ["Fly|Ride"] = 137.81, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1890.59, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1620.94}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 72.19, ["Ride"] = 70.88, ["Fly|Ride"] = 140.91, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6169.09, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 1737.33}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 57.07, ["Ride"] = 44.18, ["Fly|Ride"] = 91.88, ["Neon"] = 169.32, ["Neon|Fly"] = 286.42, ["Neon|Ride"] = 139.88, ["Neon|Fly|Ride"] = 191.33, ["Mega"] = 982.1, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.72, ["Ride"] = 75.72, ["Fly|Ride"] = 71.61, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 420.6, ["Mega|Ride"] = 1273.35, ["Mega|Fly|Ride"] = 1496.29}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 49.88}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.12, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1108.29, ["Neon|Fly|Ride"] = 1089.36, ["Mega|Fly|Ride"] = 4534.03}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 623.7, ["Fly|Ride"] = 783.57, ["Neon"] = 2362.5, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10820.37}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.12}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.1, ["Fly"] = 59.06, ["Ride"] = 36.18, ["Fly|Ride"] = 70.88, ["Neon"] = 218.72, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 217.88, ["Mega"] = 2102.99, ["Mega|Ride"] = 1145.55, ["Mega|Fly|Ride"] = 761.23}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17504.47, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36597.3}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.45, ["Fly"] = 55.11, ["Ride"] = 24.68, ["Fly|Ride"] = 59.76, ["Neon"] = 76.13, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 221.81, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 580.56}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.75, ["Fly"] = 137.76, ["Ride"] = 28.41, ["Fly|Ride"] = 84.14, ["Neon"] = 98.85, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 735, ["Mega|Ride"] = 807.23, ["Mega|Fly|Ride"] = 982.1}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 57.79, ["Fly"] = 280.76, ["Ride"] = 58.7, ["Fly|Ride"] = 90.44, ["Neon|Ride"] = 390.12, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4205.96}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.06, ["Fly"] = 70.47, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 56.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 1402.7, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.68, ["Fly"] = 2033.59, ["Ride"] = 1638, ["Fly|Ride"] = 1573.69, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 33647.61, ["Ride"] = 52500, ["Fly|Ride"] = 27300.24, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72875.98, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21.38, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 126.19, ["Neon"] = 280.76, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 315, ["Mega"] = 953.72, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1370.01}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.77, ["Fly"] = 63, ["Ride"] = 42, ["Fly|Ride"] = 145.95, ["Neon"] = 23.62, ["Neon|Fly"] = 131.23, ["Neon|Ride"] = 56.13, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 140.33, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 483.7}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.99}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.81, ["Ride"] = 21.05, ["Fly|Ride"] = 131.25, ["Neon"] = 57.75, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 213.54, ["Mega"] = 420.6, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 680.33}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.93, ["Fly"] = 795.99, ["Ride"] = 689.07, ["Fly|Ride"] = 795.99, ["Neon"] = 2733.89, ["Neon|Ride"] = 2625.45, ["Neon|Fly|Ride"] = 2580.37, ["Mega|Fly|Ride"] = 9391.9}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 840, ["Fly"] = 974.74, ["Ride"] = 938.33, ["Fly|Ride"] = 971.25, ["Neon"] = 3785.37, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11496.98}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.26, ["Fly"] = 119.36, ["Ride"] = 29.97, ["Fly|Ride"] = 78.75, ["Neon"] = 85.3, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 161.11, ["Mega"] = 1204.13, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 68.24, ["Fly"] = 89.24, ["Ride"] = 85.29, ["Fly|Ride"] = 112.52, ["Neon"] = 590.75, ["Neon|Ride"] = 420.6, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 19687.5, ["Mega|Ride"] = 2058.83, ["Mega|Fly|Ride"] = 2076.71}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Ride"] = 102.89, ["Fly|Ride"] = 183.75, ["Neon"] = 420, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 1394.77, ["Mega|Fly|Ride"] = 1909.42}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 32.16, ["Ride"] = 18.35, ["Fly|Ride"] = 42.63, ["Neon"] = 45.94, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 168, ["Mega|Fly|Ride"] = 652.8}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 141.75, ["Fly"] = 161.18, ["Ride"] = 140.91, ["Fly|Ride"] = 223.13, ["Neon"] = 600.64, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 5047.16, ["Mega|Fly|Ride"] = 2487.19}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.42, ["Ride"] = 47.06, ["Fly|Ride"] = 182.97, ["Neon"] = 30.51, ["Neon|Fly"] = 168.25, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 210.33, ["Mega"] = 183.75, ["Mega|Fly"] = 334.39, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.63, ["Fly"] = 63.56, ["Ride"] = 32.71, ["Fly|Ride"] = 81, ["Neon"] = 78.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 659.29, ["Mega|Ride"] = 813.86, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.74, ["Ride"] = 59.07, ["Fly|Ride"] = 156.19, ["Neon"] = 216.57, ["Neon|Ride"] = 282.19, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 923.25}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.87, ["Fly"] = 210.31, ["Ride"] = 35.77, ["Fly|Ride"] = 47.16, ["Neon"] = 105, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1109.34}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5767.12, ["Neon"] = 35050.3, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 25654.2}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 223.13, ["Fly"] = 242.16, ["Ride"] = 227.63, ["Fly|Ride"] = 292.69, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 45.92, ["Fly"] = 140.91, ["Ride"] = 95.49, ["Fly|Ride"] = 197.69, ["Neon"] = 153.57, ["Neon|Fly"] = 237.66, ["Neon|Ride"] = 162.3, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 423.94, ["Mega|Fly"] = 615.8, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.59, ["Fly"] = 88.33, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 17.07, ["Neon|Fly"] = 69.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 191.39, ["Mega"] = 168.25, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 356.84}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 58.47, ["Fly"] = 164.07, ["Ride"] = 106.2, ["Fly|Ride"] = 199.87, ["Neon"] = 196.87, ["Neon|Fly"] = 436.38, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 387.17, ["Mega"] = 564.38, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 681.17}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 12401.82, ["Neon|Fly|Ride"] = 27050.29, ["Mega|Fly|Ride"] = 112159.02}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 252, ["Ride"] = 312.94, ["Fly|Ride"] = 415.35, ["Neon|Ride"] = 1398.5, ["Neon|Fly|Ride"] = 1598.28, ["Mega|Fly|Ride"] = 6799.98}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 45.94, ["Fly"] = 80.59, ["Ride"] = 69.56, ["Fly|Ride"] = 91.87, ["Neon"] = 1050, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 378.55, ["Mega|Fly|Ride"] = 3243.85}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.79, ["Ride"] = 19.99, ["Fly|Ride"] = 69.42, ["Neon"] = 67.46, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 154.35, ["Mega"] = 393.75, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 628.81}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 368.81, ["Fly"] = 841.2, ["Ride"] = 420, ["Fly|Ride"] = 504.36, ["Neon"] = 1584.61, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1567.78, ["Mega|Fly|Ride"] = 5024.02}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 10.5, ["Ride"] = 39.98, ["Fly|Ride"] = 185.27, ["Neon"] = 34.1, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 137.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 190.95, ["Mega|Fly|Ride"] = 520.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.91, ["Fly"] = 222.93, ["Ride"] = 133.59, ["Fly|Ride"] = 195.56, ["Neon"] = 380.62, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.37, ["Neon|Fly|Ride"] = 518.44, ["Mega|Fly|Ride"] = 2419.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.82, ["Fly"] = 18.15, ["Ride"] = 18.69, ["Fly|Ride"] = 39.15, ["Neon"] = 159.93, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 2523.59, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.31, ["Fly"] = 140.91, ["Ride"] = 59.06, ["Fly|Ride"] = 420.6, ["Neon"] = 420.6, ["Neon|Fly"] = 419.55, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 795.99, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1591.97}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.92, ["Fly"] = 77.82, ["Ride"] = 31.39, ["Fly|Ride"] = 77.44, ["Neon"] = 98.43, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 596.71, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 49.79, ["Fly"] = 140.91, ["Ride"] = 105.16, ["Fly|Ride"] = 223.13, ["Neon"] = 280.76, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 1591.97, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.81, ["Ride"] = 29.22, ["Fly|Ride"] = 136.06, ["Neon"] = 15.65, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 136.57, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 301.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 56.44, ["Ride"] = 32.61, ["Fly|Ride"] = 85.22, ["Neon"] = 159.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 188.24, ["Mega"] = 561.51, ["Mega|Ride"] = 630.91, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 488.57, ["Fly"] = 562.56, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.14, ["Fly"] = 98.85, ["Ride"] = 57.6, ["Fly|Ride"] = 131.25, ["Neon"] = 178.75, ["Neon|Ride"] = 210.97, ["Neon|Fly|Ride"] = 328.08, ["Mega"] = 776.43, ["Mega|Ride"] = 659.29, ["Mega|Fly|Ride"] = 535.4}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.12, ["Fly"] = 119.89, ["Ride"] = 70.42, ["Fly|Ride"] = 118.84, ["Neon"] = 232.39, ["Neon|Ride"] = 236.15, ["Neon|Fly|Ride"] = 295.32, ["Mega|Fly|Ride"] = 929.53}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20, ["Fly"] = 84.14, ["Ride"] = 65.63, ["Fly|Ride"] = 120.86, ["Neon"] = 98.34, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 354.37, ["Mega"] = 301.88, ["Mega|Fly"] = 525, ["Mega|Ride"] = 425.25, ["Mega|Fly|Ride"] = 587.79}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8119.78, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1378.13, ["Fly"] = 1486.83, ["Ride"] = 1443.74, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 16544.11}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 587.79, ["Ride"] = 625.07, ["Fly|Ride"] = 630.91, ["Neon"] = 4457.28, ["Neon|Fly|Ride"] = 3506.62, ["Mega"] = 21029.76, ["Mega|Fly|Ride"] = 8433.62}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.49, ["Fly"] = 23.21, ["Ride"] = 22.75, ["Fly|Ride"] = 39.38, ["Neon"] = 68.04, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 115.9, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.25, ["Fly"] = 78.74, ["Ride"] = 32.23, ["Fly|Ride"] = 163, ["Neon"] = 24.94, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 1432.07, ["Mega"] = 155.24, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 262.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.4, ["Fly"] = 50.94, ["Ride"] = 47.76, ["Fly|Ride"] = 94.47, ["Neon"] = 199.8, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 182.44, ["Mega|Ride"] = 736.05, ["Mega|Fly|Ride"] = 635.92}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.52, ["Fly"] = 21.05, ["Ride"] = 15.75, ["Fly|Ride"] = 37.59, ["Neon"] = 48.38, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 280.76, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328, ["Fly"] = 369.5, ["Ride"] = 317.58, ["Fly|Ride"] = 392.74, ["Neon"] = 1591.97, ["Neon|Ride"] = 1314.37, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3653.85}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 16.7, ["Fly"] = 59.07, ["Ride"] = 30.85, ["Fly|Ride"] = 80.79, ["Neon"] = 199.16, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 659.29, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 687.65}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 8.86, ["Fly"] = 19.69, ["Ride"] = 19.19, ["Fly|Ride"] = 42, ["Neon"] = 82.03, ["Neon|Fly"] = 119.89, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 601.48, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 561.51, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 3364.78, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1058.4, ["Ride"] = 1148.44, ["Fly|Ride"] = 1384.85, ["Neon"] = 4907.31, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 137.82, ["Fly"] = 137.76, ["Ride"] = 94.91, ["Fly|Ride"] = 117.16, ["Neon"] = 580.43, ["Neon|Ride"] = 578.33, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2522.54}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 173.92, ["Fly"] = 212.13, ["Ride"] = 157.2, ["Fly|Ride"] = 236.25, ["Neon"] = 852.77, ["Neon|Ride"] = 760.24, ["Neon|Fly|Ride"] = 648.64, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2897.91}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.41, ["Fly"] = 56.8, ["Ride"] = 32.45, ["Fly|Ride"] = 112.25, ["Neon"] = 236.24, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 1064.12}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 237.66, ["Ride"] = 315, ["Fly|Ride"] = 406.93, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 6308.94}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2215.49, ["Ride"] = 1666.88, ["Fly|Ride"] = 1837.48, ["Neon|Fly|Ride"] = 10514.88, ["Mega|Fly|Ride"] = 29437.05}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 210.31, ["Ride"] = 52.4, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 1402.7, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 704.47, ["Ride"] = 631.02, ["Fly|Ride"] = 670.17, ["Neon|Ride"] = 1909.42, ["Neon|Fly|Ride"] = 1193.07, ["Mega|Fly|Ride"] = 3451.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.11, ["Fly"] = 59.07, ["Ride"] = 51.1, ["Fly|Ride"] = 74.82, ["Neon"] = 262.5, ["Neon|Ride"] = 233.91, ["Neon|Fly|Ride"] = 232.59, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.77, ["Fly"] = 36.82, ["Ride"] = 22.37, ["Fly|Ride"] = 55.13, ["Neon"] = 26.25, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 155.64, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 336.49}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 49.79, ["Ride"] = 127.71, ["Fly|Ride"] = 204.01, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 1537.29, ["Mega|Ride"] = 1535.19}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 771.75, ["Fly"] = 1092, ["Ride"] = 787.5, ["Fly|Ride"] = 909.03, ["Neon|Ride"] = 3254.99, ["Neon|Fly|Ride"] = 2948.49, ["Mega|Fly|Ride"] = 11915.48}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 634.23, ["Ride"] = 523.69, ["Fly|Ride"] = 813.86, ["Neon"] = 10795.64, ["Neon|Fly|Ride"] = 4196.51, ["Mega|Fly|Ride"] = 15280.23}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.89, ["Fly"] = 22.32, ["Ride"] = 21.05, ["Fly|Ride"] = 45.47, ["Neon"] = 157.74, ["Neon|Ride"] = 130.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 795.99, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.4, ["Ride"] = 26.25, ["Fly|Ride"] = 79.93, ["Neon"] = 141.9, ["Neon|Ride"] = 153.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 794.07, ["Mega|Ride"] = 656.14, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.25, ["Fly"] = 61.64, ["Ride"] = 26.24, ["Fly|Ride"] = 111.46, ["Neon"] = 21.72, ["Neon|Fly"] = 318.55, ["Neon|Ride"] = 64.45, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 175.88, ["Mega|Fly"] = 541.82, ["Mega|Ride"] = 202.39, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.26, ["Fly"] = 51.19, ["Ride"] = 47.25, ["Fly|Ride"] = 102.05, ["Neon"] = 293.02, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 233.06, ["Mega|Fly|Ride"] = 1273.27}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 73.5, ["Ride"] = 129.94, ["Fly|Ride"] = 477.37, ["Neon"] = 428.35, ["Neon|Ride"] = 561.51, ["Neon|Fly|Ride"] = 637.28, ["Mega"] = 1964.19, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.48, ["Fly"] = 45.94, ["Ride"] = 42.08, ["Fly|Ride"] = 90.03, ["Neon"] = 99.06, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 84.46, ["Neon|Fly|Ride"] = 147, ["Mega"] = 425.39, ["Mega|Ride"] = 405.75, ["Mega|Fly|Ride"] = 451.19}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.61, ["Fly"] = 60.88, ["Ride"] = 45.94, ["Fly|Ride"] = 78.49, ["Neon"] = 242.82, ["Neon|Fly"] = 1402.7, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.6}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.51, ["Fly"] = 27.18, ["Ride"] = 17.4, ["Fly|Ride"] = 42.08, ["Neon"] = 19.69, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 736.05, ["Mega|Ride"] = 477.37, ["Mega|Fly|Ride"] = 504.73}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 49.87, ["Ride"] = 41.91, ["Fly|Ride"] = 63.58, ["Neon"] = 37.41, ["Neon|Fly"] = 109.37, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 176.64, ["Mega"] = 416.06, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 140.91, ["Fly"] = 56.18, ["Ride"] = 53.82, ["Fly|Ride"] = 95.75, ["Neon"] = 579.38, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 209.89, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1397.82, ["Fly"] = 1410.93, ["Ride"] = 1443.75, ["Fly|Ride"] = 1494.94, ["Neon|Fly|Ride"] = 3790.49, ["Mega|Fly|Ride"] = 17105.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.99, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 2733.89, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14720.84, ["Mega|Fly|Ride"] = 9253.11}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Ride"] = 249.38, ["Fly|Ride"] = 446.25, ["Neon"] = 1311.19, ["Neon|Ride"] = 1535.19, ["Neon|Fly|Ride"] = 1668.73}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.35}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 22.94, ["Ride"] = 45.05, ["Fly|Ride"] = 97.12, ["Neon"] = 322.83, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1542.54, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 36451.92, ["Fly"] = 23132.74, ["Ride"] = 23867.55, ["Fly|Ride"] = 17981.25, ["Neon|Fly|Ride"] = 36093.75, ["Mega"] = 210297.48, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 249.11, ["Fly"] = 282.19, ["Ride"] = 301.88, ["Fly|Ride"] = 334.69, ["Neon"] = 1074.06, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 937, ["Neon|Fly|Ride"] = 890.84, ["Mega"] = 3680.21, ["Mega|Ride"] = 4204.91, ["Mega|Fly|Ride"] = 3396.85}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 209.26, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1750.7}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.62, ["Fly"] = 210.31, ["Ride"] = 150.94, ["Fly|Ride"] = 231.54, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2860.06}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.32, ["Fly"] = 63, ["Ride"] = 26.25, ["Fly|Ride"] = 70.47, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 233.44, ["Mega"] = 713.66, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 840.15}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3871.88, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon"] = 27338.69, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.04, ["Fly"] = 45.93, ["Ride"] = 28.88, ["Fly|Ride"] = 52.5, ["Neon"] = 337.81, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 1121.96, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 715.03}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 40.69, ["Fly"] = 126.19, ["Ride"] = 58.9, ["Fly|Ride"] = 103.7, ["Neon"] = 314.26, ["Neon|Fly"] = 1402.7, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 442.32, ["Fly"] = 551.25, ["Ride"] = 472.5, ["Fly|Ride"] = 581.17, ["Neon"] = 1312.5, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 2201.82, ["Mega|Fly|Ride"] = 7160.28}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.72, ["Fly"] = 23.38, ["Ride"] = 23.63, ["Fly|Ride"] = 40.49, ["Neon"] = 118.13, ["Neon|Fly"] = 158.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 771.81, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.56, ["Ride"] = 26.24, ["Fly|Ride"] = 79.97, ["Neon"] = 98.43, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 828.58, ["Mega|Fly|Ride"] = 716.04}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 105, ["Ride"] = 124.69, ["Fly|Ride"] = 230.29, ["Neon"] = 1010.63, ["Neon|Ride"] = 1005.24, ["Neon|Fly|Ride"] = 1114.63, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.43, ["Fly"] = 128.09, ["Ride"] = 80.07, ["Fly|Ride"] = 255.94, ["Neon"] = 43.19, ["Neon|Ride"] = 109.18, ["Neon|Fly|Ride"] = 224.43, ["Mega"] = 304.96, ["Mega|Fly"] = 729.75, ["Mega|Ride"] = 294.67, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3806.25, ["Fly"] = 6205.58, ["Ride"] = 3883.66, ["Fly|Ride"] = 4160.62, ["Neon"] = 14720.84, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42058.46, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.48, ["Fly"] = 42, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 393.27, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 393.84, ["Mega"] = 771.81, ["Mega|Ride"] = 1750.7, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7844.11, ["Fly"] = 7570.73, ["Ride"] = 6857.82, ["Fly|Ride"] = 6286.88, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 22.31, ["Ride"] = 15.91, ["Fly|Ride"] = 36.75, ["Neon"] = 24.68, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 196.64, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 252.37}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.23, ["Fly"] = 25.99, ["Ride"] = 21.05, ["Fly|Ride"] = 52.5, ["Neon"] = 140.91, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 161.44, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 914.81}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.55, ["Ride"] = 31.48, ["Fly|Ride"] = 116.03, ["Neon"] = 98.44, ["Neon|Ride"] = 87.25, ["Neon|Fly|Ride"] = 202.9, ["Mega"] = 1049.9, ["Mega|Ride"] = 882.2, ["Mega|Fly|Ride"] = 789.68}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.51, ["Fly"] = 190.37, ["Ride"] = 42, ["Fly|Ride"] = 99.73, ["Neon"] = 156.35, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 238.7, ["Mega"] = 945, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.7, ["Fly"] = 25.37, ["Ride"] = 19.11, ["Fly|Ride"] = 38.48, ["Neon|Fly"] = 1048.35, ["Neon|Ride"] = 116.72, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2523.59, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8552.82}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.03, ["Ride"] = 385.91, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.44, ["Fly"] = 132.9, ["Ride"] = 32.41, ["Fly|Ride"] = 126.19, ["Neon"] = 98.85, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 525, ["Mega|Ride"] = 526.3, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.9}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 31.56, ["Fly|Ride"] = 84.14, ["Neon|Ride"] = 249.38, ["Mega"] = 1542.54}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2628.43}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 170.63, ["Fly"] = 296.54, ["Ride"] = 215.25, ["Fly|Ride"] = 420.6, ["Neon"] = 918.75, ["Neon|Ride"] = 840.15, ["Neon|Fly|Ride"] = 982.1, ["Mega|Ride"] = 4066.12, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 63.95, ["Ride"] = 91.49, ["Fly|Ride"] = 210.31, ["Neon"] = 655.09, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 926.38, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 152.79, ["Fly"] = 232.39, ["Ride"] = 185.07, ["Fly|Ride"] = 223.13, ["Neon"] = 944.98, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3258.94, ["Mega|Fly|Ride"] = 3041.24}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3224.93, ["Ride"] = 2231.25, ["Fly|Ride"] = 2264.07, ["Neon"] = 14769.21, ["Neon|Ride"] = 8353.65, ["Neon|Fly|Ride"] = 7808.36, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.53, ["Fly"] = 70.47, ["Ride"] = 56.8, ["Fly|Ride"] = 100.08, ["Neon"] = 127.32, ["Neon|Fly"] = 159.93, ["Neon|Ride"] = 152.77, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 945.3, ["Mega|Ride"] = 1312.74, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 813.86, ["Fly"] = 2100, ["Ride"] = 787.5, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4137.45}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.51}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Ride"] = 51.97, ["Fly|Ride"] = 336.55, ["Neon"] = 94.4, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 448.88, ["Mega|Fly"] = 954.72, ["Mega|Ride"] = 477.4, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.29, ["Fly"] = 73.62, ["Ride"] = 27.45, ["Fly|Ride"] = 98.85, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 446.34, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.97}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 28.65, ["Fly"] = 105.68, ["Ride"] = 21.3, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 113.38, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 1522.5}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.94, ["Fly"] = 39.37, ["Ride"] = 33.53, ["Fly|Ride"] = 70.47, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1432.07, ["Mega|Ride"] = 1790.08, ["Mega|Fly|Ride"] = 978.95}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.5, ["Fly"] = 10237.5, ["Ride"] = 7875, ["Fly|Ride"] = 5223.75, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.85, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 74.67, ["Neon"] = 49.37, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 205.06, ["Mega"] = 314.41, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.63}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 101.35, ["Fly"] = 372.25, ["Ride"] = 140.91, ["Fly|Ride"] = 160.09, ["Neon"] = 416.4, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2879.59, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 2058.83}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.72, ["Fly"] = 140.91, ["Ride"] = 74.81, ["Fly|Ride"] = 168.25, ["Neon"] = 284.82, ["Neon|Ride"] = 272.35, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2386.77, ["Mega|Ride"] = 2839.04, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.63, ["Fly"] = 70.47, ["Ride"] = 28.85, ["Fly|Ride"] = 64.32, ["Neon"] = 128.77, ["Neon|Fly"] = 227.14, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 201.41, ["Mega"] = 1016.21, ["Mega|Ride"] = 859.24, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.92, ["Fly"] = 68.25, ["Ride"] = 27.36, ["Fly|Ride"] = 61, ["Neon"] = 32.82, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 137.82, ["Mega|Fly"] = 7010.19, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 285.59}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.99, ["Fly"] = 42.08, ["Ride"] = 25.61, ["Fly|Ride"] = 96.96, ["Neon"] = 91.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 190.95, ["Mega|Ride"] = 541.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 24.66, ["Fly"] = 32.24, ["Ride"] = 24.05, ["Fly|Ride"] = 46.45, ["Neon"] = 364.88, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.91, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 208.21}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 48.38, ["Ride"] = 131.23, ["Fly|Ride"] = 280.76, ["Neon"] = 168.25, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 603.57, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.26, ["Ride"] = 241.86, ["Fly|Ride"] = 630.91, ["Neon|Ride"] = 16823.82, ["Neon|Fly|Ride"] = 28040.03}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.81, ["Fly"] = 212.84, ["Ride"] = 86.51, ["Fly|Ride"] = 180.09, ["Neon"] = 251.99, ["Neon|Ride"] = 321.54, ["Neon|Fly|Ride"] = 456.36, ["Mega"] = 851.9, ["Mega|Ride"] = 1034.66, ["Mega|Fly|Ride"] = 1147.18}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 983.07, ["Fly"] = 1332.24, ["Ride"] = 925.8, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 4218.6, ["Neon|Fly|Ride"] = 3551.42, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 391.13, ["Fly"] = 701.36, ["Ride"] = 380.62, ["Fly|Ride"] = 420, ["Neon"] = 1968.75, ["Neon|Ride"] = 2574.06, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 11933.78, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 63}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.61}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.88, ["Fly"] = 23, ["Ride"] = 27.2, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.34, ["Neon|Fly|Ride"] = 137.74, ["Mega"] = 437.26, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 524.7}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.94, ["Fly"] = 210, ["Ride"] = 266.7, ["Fly|Ride"] = 326.69, ["Neon"] = 1121.96, ["Neon|Ride"] = 1051.5, ["Neon|Fly|Ride"] = 1046.25, ["Mega|Fly|Ride"] = 2802.89}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.06}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 110.1, ["Fly"] = 285.24, ["Ride"] = 168.35, ["Fly|Ride"] = 287.73, ["Neon"] = 511.88, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2231.43, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.29, ["Fly"] = 210.31, ["Ride"] = 129.45, ["Fly|Ride"] = 155.64, ["Neon"] = 1121.96, ["Neon|Fly"] = 721.88, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 905.79, ["Mega|Fly|Ride"] = 2523.59}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.57, ["Ride"] = 27.33, ["Fly|Ride"] = 52.5, ["Neon"] = 37.8, ["Neon|Ride"] = 85.94, ["Neon|Fly|Ride"] = 237.66, ["Mega"] = 336.49, ["Mega|Ride"] = 189.83}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.18, ["Fly"] = 71.54, ["Ride"] = 25.75, ["Fly|Ride"] = 78.64, ["Neon"] = 177.19, ["Neon|Ride"] = 147.23, ["Neon|Fly|Ride"] = 316.28, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 510.57}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.11, ["Fly"] = 102.36, ["Ride"] = 32.24, ["Fly|Ride"] = 104.51, ["Neon"] = 85.2, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 557.32}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.8, ["Fly"] = 98.18, ["Ride"] = 58.9, ["Fly|Ride"] = 183.75, ["Neon"] = 25.66, ["Neon|Ride"] = 62.64, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 144.38, ["Mega|Fly"] = 270.92, ["Mega|Ride"] = 194.96, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 240.35, ["Ride"] = 261.19, ["Fly|Ride"] = 380.63, ["Neon"] = 1570.94, ["Neon|Ride"] = 1358.07, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5579.2}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 93.5, ["Fly"] = 157.5, ["Ride"] = 135.18, ["Fly|Ride"] = 241.5, ["Neon"] = 498.75, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 63, ["Fly"] = 167.45, ["Ride"] = 70.14, ["Fly|Ride"] = 131.25, ["Neon"] = 380.63, ["Neon|Ride"] = 242.29, ["Neon|Fly|Ride"] = 407.77, ["Mega|Ride"] = 1750.7, ["Mega|Fly|Ride"] = 1801.15}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.92, ["Fly"] = 78.75, ["Ride"] = 28.41, ["Fly|Ride"] = 280.76, ["Neon"] = 115.5, ["Neon|Ride"] = 606.24, ["Neon|Fly|Ride"] = 491.07}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.75, ["Fly"] = 35.4, ["Ride"] = 31.56, ["Fly|Ride"] = 90.96, ["Neon"] = 77.43, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 374.07, ["Mega|Fly"] = 525, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.64, ["Fly"] = 52.47, ["Ride"] = 18.38, ["Fly|Ride"] = 56.8, ["Neon"] = 20.9, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 53.65, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 141.7, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 748.12, ["Fly"] = 911.66, ["Ride"] = 851.82, ["Fly|Ride"] = 906.95, ["Neon"] = 2944.18, ["Neon|Fly"] = 3240.03, ["Neon|Ride"] = 8411.91, ["Neon|Fly|Ride"] = 2754.94}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 420.6, ["Fly"] = 477.4, ["Ride"] = 393.65, ["Fly|Ride"] = 343.86, ["Neon"] = 1193.39, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1222.71, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 6307.89}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.58, ["Fly"] = 126.19, ["Ride"] = 108.94, ["Fly|Ride"] = 182.97, ["Neon"] = 340.7, ["Neon|Fly"] = 477.37, ["Neon|Ride"] = 322.83, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1528.88, ["Mega|Fly|Ride"] = 1542.54}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 192.44, ["Fly"] = 283.5, ["Ride"] = 205.13, ["Fly|Ride"] = 251.29, ["Neon|Ride"] = 1273.35, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 4907.31}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.61, ["Fly"] = 32.82, ["Ride"] = 28.28, ["Fly|Ride"] = 74.61, ["Neon"] = 169.32, ["Neon|Ride"] = 181.13, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 795.99}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 255.68, ["Fly|Ride"] = 463.73, ["Neon"] = 786.19, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.65, ["Mega|Ride"] = 4626.56, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.14, ["Fly"] = 125.98, ["Ride"] = 79.42, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 477.37, ["Mega|Fly|Ride"] = 1528.88}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1955.63, ["Ride"] = 2034.38, ["Fly|Ride"] = 1925.44, ["Neon|Ride"] = 11138.99, ["Neon|Fly|Ride"] = 9113.25, ["Mega"] = 50471.4, ["Mega|Fly|Ride"] = 23867.55}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 22.68, ["Fly"] = 73.62, ["Ride"] = 42.08, ["Fly|Ride"] = 96.07, ["Neon"] = 69.57, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 115.88, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 249.38, ["Mega|Fly"] = 564.58, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 440.08}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 54.32, ["Fly"] = 119.36, ["Ride"] = 70.47, ["Fly|Ride"] = 134.51, ["Neon"] = 223.13, ["Neon|Ride"] = 280.76, ["Neon|Fly|Ride"] = 561.51, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1051.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 84, ["Fly"] = 91.86, ["Ride"] = 78.12, ["Fly|Ride"] = 97.54, ["Neon"] = 525, ["Neon|Ride"] = 255.4, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3341.47, ["Fly"] = 1591.97, ["Ride"] = 1069.68, ["Fly|Ride"] = 1076.77, ["Neon|Ride"] = 5092.16, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 485.63, ["Fly"] = 525, ["Ride"] = 841.2, ["Fly|Ride"] = 626.7, ["Neon|Fly|Ride"] = 3182.75, ["Mega|Fly|Ride"] = 11216.23}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.68, ["Fly"] = 170.63, ["Ride"] = 101.93, ["Fly|Ride"] = 196.88, ["Neon"] = 442.98, ["Neon|Ride"] = 342.54, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 5608.65, ["Mega|Ride"] = 2546.69, ["Mega|Fly|Ride"] = 1497.64}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.19, ["Ride"] = 32.43, ["Fly|Ride"] = 63, ["Neon"] = 74.33, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 603.75, ["Mega|Ride"] = 761.29}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.16, ["Fly"] = 53.65, ["Ride"] = 42, ["Fly|Ride"] = 78.75, ["Neon"] = 280.76, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 2243.9, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1097.92, ["Ride"] = 734.99, ["Fly|Ride"] = 787.49, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.94}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 5610.94, ["Fly|Ride"] = 5248.69, ["Neon|Ride"] = 30136.7, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 89727.64}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 249.38, ["Fly"] = 394.32, ["Ride"] = 328.13, ["Fly|Ride"] = 415.3, ["Neon"] = 1682.4, ["Neon|Ride"] = 1823.3, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6307.89, ["Mega|Fly|Ride"] = 6308.94}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 280.76, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 419.55, ["Neon|Ride"] = 785.48, ["Neon|Fly|Ride"] = 626.7, ["Mega|Fly|Ride"] = 2131.38}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.4, ["Fly"] = 42.08, ["Ride"] = 30.09, ["Fly|Ride"] = 52.31, ["Neon"] = 156.92, ["Neon|Fly"] = 1273.35, ["Neon|Ride"] = 125.99, ["Neon|Fly|Ride"] = 203.94, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 753.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.81, ["Fly"] = 26.23, ["Ride"] = 21, ["Fly|Ride"] = 48.63, ["Neon"] = 104.11, ["Neon|Ride"] = 318.65, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.48, ["Fly"] = 280.76, ["Ride"] = 30.15, ["Fly|Ride"] = 84.93, ["Neon"] = 118.46, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 222.93, ["Mega"] = 645.75, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.54, ["Fly"] = 77.82, ["Ride"] = 19.69, ["Fly|Ride"] = 48.56, ["Neon"] = 31.38, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 126, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 273.4}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.48, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 139.13, ["Neon|Fly"] = 841.2, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 624.6, ["Mega|Ride"] = 771.81}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 420, ["Fly"] = 538.12, ["Ride"] = 483, ["Fly|Ride"] = 538.44, ["Neon"] = 1577.24, ["Neon|Ride"] = 1542.54, ["Neon|Fly|Ride"] = 1376.82, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5327.89}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 19.46, ["Ride"] = 14.43, ["Fly|Ride"] = 35.77, ["Neon"] = 23.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 81, ["Mega"] = 170.63, ["Mega|Ride"] = 222.93, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42, ["Fly"] = 110.06, ["Ride"] = 78.65, ["Fly|Ride"] = 127.28, ["Neon"] = 183.75, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 208.68, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 523.69, ["Mega|Ride"] = 502.74, ["Mega|Fly|Ride"] = 556.49}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 794.07, ["Ride"] = 774.27, ["Fly|Ride"] = 807.18, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 90.56, ["Ride"] = 44.62, ["Fly|Ride"] = 78.65, ["Neon"] = 252.37, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1193.39, ["Mega|Fly|Ride"] = 851.8}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 357, ["Fly"] = 393.27, ["Ride"] = 281.39, ["Fly|Ride"] = 337.22, ["Neon"] = 1542.54, ["Neon|Ride"] = 1823.3, ["Neon|Fly|Ride"] = 1332.24, ["Mega|Fly|Ride"] = 6365.49}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 182.96, ["Fly"] = 178.49, ["Ride"] = 170.63, ["Fly|Ride"] = 223.13, ["Neon"] = 982.1, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 841.2, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3659.19}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 869.59, ["Ride"] = 783.57, ["Fly|Ride"] = 879.62, ["Neon|Fly|Ride"] = 3364.78, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.27, ["Fly"] = 84.14, ["Ride"] = 44.29, ["Fly|Ride"] = 110.25, ["Neon"] = 82.69, ["Neon|Fly"] = 286.42, ["Neon|Ride"] = 83.29, ["Neon|Fly|Ride"] = 157.74, ["Mega"] = 354.38, ["Mega|Ride"] = 418.5, ["Mega|Fly|Ride"] = 524.84}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3150, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 23867.55}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 102.38, ["Fly"] = 131.25, ["Ride"] = 131.24, ["Fly|Ride"] = 184.17, ["Neon"] = 459.38, ["Neon|Fly"] = 658.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2664.47, ["Mega|Fly|Ride"] = 2775.94}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.24, ["Fly"] = 28.3, ["Ride"] = 15.75, ["Fly|Ride"] = 38.55, ["Neon"] = 19.69, ["Neon|Fly"] = 59.79, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 151.43, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 196.64, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.65, ["Ride"] = 24.56, ["Fly|Ride"] = 57.71, ["Neon"] = 22.31, ["Neon|Fly"] = 116.96, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 152.12, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.45, ["Fly"] = 38.45, ["Ride"] = 30.85, ["Fly|Ride"] = 56.44, ["Neon"] = 286.42, ["Neon|Ride"] = 182.97, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1085.16}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 780.94, ["Fly"] = 1235.16, ["Ride"] = 826.88, ["Fly|Ride"] = 1145.66, ["Neon"] = 4486.72, ["Neon|Fly|Ride"] = 4094.51}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 7008.75, ["Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 72915.94}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.99, ["Fly"] = 45.23, ["Ride"] = 22.35, ["Fly|Ride"] = 43.98, ["Neon"] = 452.13, ["Neon|Ride"] = 155.64, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.2, ["Fly"] = 57.65, ["Ride"] = 26.25, ["Fly|Ride"] = 80.98, ["Neon"] = 71.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 158, ["Mega"] = 317.45, ["Mega|Ride"] = 491.07, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 90.55, ["Fly"] = 157.5, ["Ride"] = 87.84, ["Fly|Ride"] = 137.82, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1964.19}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.47, ["Fly"] = 241.5, ["Ride"] = 221.82, ["Fly|Ride"] = 336, ["Neon"] = 918.75, ["Neon|Ride"] = 1073.91, ["Neon|Fly|Ride"] = 1018.7, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 3498.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.18, ["Ride"] = 20, ["Fly|Ride"] = 93.19, ["Neon"] = 21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 52.59, ["Mega"] = 148.12, ["Mega|Fly"] = 235.76, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 180.92, ["Fly"] = 231.7, ["Ride"] = 204.75, ["Fly|Ride"] = 280.76, ["Neon"] = 795.99, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.02, ["Fly"] = 25.46, ["Ride"] = 20, ["Fly|Ride"] = 56.44, ["Neon"] = 23.63, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.84, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 274.02}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 338.59, ["Ride"] = 210.34, ["Fly|Ride"] = 225.04, ["Neon|Ride"] = 1193.39, ["Neon|Fly|Ride"] = 775.07, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 5410.79}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.19, ["Fly"] = 77.44, ["Ride"] = 27.76, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 303.13, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 498.42, ["Mega|Ride"] = 471.08, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 5.52, ["Fly"] = 70.47, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 138.81, ["Mega"] = 80.07, ["Mega|Ride"] = 108.8, ["Mega|Fly|Ride"] = 190.95}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Mega"] = 17.59, ["Mega|Ride"] = 150.38, ["Mega|Fly|Ride"] = 166.15}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.31, ["Fly"] = 52.49, ["Ride"] = 20, ["Fly|Ride"] = 111.47, ["Neon"] = 6.22, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.41, ["Mega|Fly"] = 159117.75, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.69, ["Fly"] = 105, ["Ride"] = 111.57, ["Fly|Ride"] = 140.91, ["Neon"] = 313.88, ["Neon|Fly"] = 399.58, ["Neon|Ride"] = 278.24, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.63, ["Ride"] = 15.74, ["Fly|Ride"] = 78.75, ["Neon"] = 4.79, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 95.49, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 14.32, ["Ride"] = 79.97, ["Neon"] = 116.72, ["Neon|Fly"] = 238.7, ["Neon|Ride"] = 245.85, ["Mega"] = 357.53, ["Mega|Ride"] = 533.12, ["Mega|Fly|Ride"] = 580.43}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 56.8, ["Neon"] = 2.62, ["Neon|Ride"] = 54.5, ["Neon|Fly|Ride"] = 124.74, ["Mega"] = 15.8, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 158.85}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 67.66, ["Ride"] = 11.82, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 13.55, ["Neon|Fly|Ride"] = 28.79, ["Mega"] = 14.58, ["Mega|Fly"] = 25.28, ["Mega|Ride"] = 20.51, ["Mega|Fly|Ride"] = 64.22}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 15.8, ["Fly|Ride"] = 63.62, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.08, ["Mega"] = 27.36, ["Mega|Fly"] = 159.93, ["Mega|Ride"] = 32.79, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 70.47, ["Neon"] = 2.1, ["Neon|Ride"] = 37.1, ["Mega"] = 9.56, ["Mega|Ride"] = 134.61}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.04, ["Fly|Ride"] = 107.62, ["Neon"] = 2.63, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 23.63, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 414.64, ["Mega"] = 17.46, ["Mega|Fly"] = 136.71, ["Mega|Ride"] = 73.62, ["Mega|Fly|Ride"] = 212.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.91, ["Fly"] = 36.75, ["Ride"] = 30.19, ["Fly|Ride"] = 155.64, ["Neon"] = 18.26, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 127.32, ["Mega|Fly"] = 281.95, ["Mega|Ride"] = 129.72, ["Mega|Fly|Ride"] = 255.54}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 318.65, ["Mega"] = 12.93, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.92, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Ride"] = 141.96, ["Fly|Ride"] = 140.91, ["Neon"] = 18.13, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.41, ["Neon"] = 18.38, ["Neon|Ride"] = 70.47, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 21.05, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.11, ["Ride"] = 14.17, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 14.03, ["Neon|Fly|Ride"] = 36.94, ["Mega"] = 13.11, ["Mega|Fly"] = 32.61, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4.23, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 36.75, ["Neon|Ride"] = 140.95, ["Mega"] = 189.29, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 29.64, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 35.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.32, ["Mega|Ride"] = 45.86, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.81, ["Neon"] = 12.77, ["Mega"] = 84, ["Mega|Ride"] = 159.85, ["Mega|Fly|Ride"] = 238.71}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.29, ["Fly"] = 72.19, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 23.88, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 190.95}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 10.5, ["Fly|Ride"] = 31.47, ["Neon"] = 2.1, ["Neon|Fly"] = 15.62, ["Neon|Ride"] = 12.71, ["Neon|Fly|Ride"] = 28.77, ["Mega"] = 12.68, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 18.94, ["Mega|Fly|Ride"] = 78.87}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 21.38, ["Ride"] = 27.4, ["Fly|Ride"] = 140.91, ["Neon"] = 10.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 159.93, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.9, ["Fly"] = 112.52, ["Ride"] = 39.4, ["Fly|Ride"] = 52.5, ["Neon"] = 45.49, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.52, ["Ride"] = 13.71, ["Fly|Ride"] = 28.76, ["Neon"] = 2.63, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.02, ["Neon|Fly|Ride"] = 35.77, ["Mega"] = 19.83, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.62, ["Fly"] = 175.62, ["Ride"] = 31.5, ["Neon"] = 6.06, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 167.2, ["Mega"] = 63, ["Mega|Fly"] = 168.25, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 65.62, ["Neon"] = 6.56, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 35.77, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 25.72, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 14.95, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 140.91}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 14.22, ["Fly|Ride"] = 46.54, ["Neon"] = 4.79, ["Neon|Fly"] = 53.64, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 59.17, ["Mega"] = 79.97, ["Mega|Ride"] = 84.14, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Ride"] = 63.1, ["Mega"] = 34.32, ["Mega|Fly"] = 238.7, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.01, ["Fly|Ride"] = 72.19, ["Neon"] = 10.54, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 20.9, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 105, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 122.14}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.93, ["Ride"] = 38.58, ["Neon"] = 31.11, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 14.44, ["Fly|Ride"] = 32.03, ["Neon"] = 9.19, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 30.59, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 263.82, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.67, ["Fly"] = 147.61, ["Ride"] = 16.89, ["Fly|Ride"] = 63, ["Neon"] = 13.02, ["Neon|Fly"] = 65.91, ["Neon|Ride"] = 33.01, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 168.25, ["Mega|Fly"] = 159.85, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 111.47, ["Fly|Ride"] = 140.91, ["Neon"] = 34.13, ["Neon|Ride"] = 103.84, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 179.52, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.71, ["Ride"] = 56.44, ["Neon"] = 131.25, ["Neon|Ride"] = 280.76, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 561.51, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 798.1}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.18, ["Ride"] = 54.14, ["Neon"] = 45.94, ["Neon|Ride"] = 106.55, ["Mega"] = 238.71, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 317.45}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 15.49, ["Ride"] = 31.49, ["Fly|Ride"] = 120.75, ["Neon"] = 47.25, ["Neon|Ride"] = 56.8, ["Mega"] = 280.76, ["Mega|Ride"] = 418.5, ["Mega|Fly|Ride"] = 377.52}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.54, ["Neon|Ride"] = 65.01, ["Mega"] = 19.11, ["Mega|Fly"] = 120.94, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 140.91}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 44.78}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.44, ["Fly"] = 23.61, ["Ride"] = 19.19, ["Fly|Ride"] = 40.06, ["Neon"] = 44.63, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 78.65, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 64.32, ["Neon"] = 2.62, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 157.54, ["Mega"] = 24.68, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 3.8, ["Neon|Ride"] = 35.99, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 31.5, ["Mega|Ride"] = 84.14, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.75, ["Fly|Ride"] = 45.73, ["Neon"] = 6.33, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 140.91, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 232.29}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.58, ["Fly"] = 28.41, ["Ride"] = 42.45, ["Fly|Ride"] = 57.75, ["Neon"] = 40.89, ["Neon|Ride"] = 50.48, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 159.93, ["Mega|Ride"] = 352.26, ["Mega|Fly|Ride"] = 314.41}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 3.8, ["Mega"] = 13.02, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 168.96, ["Mega|Fly|Ride"] = 119.89}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.68, ["Fly|Ride"] = 34.28, ["Neon"] = 3.56, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 95.49, ["Mega"] = 25.76, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 37.86, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.63, ["Fly|Ride"] = 41.99, ["Neon"] = 5.04, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 34.11, ["Mega"] = 47.95, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 113.38}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 35.77, ["Fly|Ride"] = 128.52, ["Neon"] = 3.59, ["Neon|Ride"] = 39.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 52.5, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 153705.79, ["Mega"] = 31.04, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 68.24, ["Mega|Fly|Ride"] = 136.45}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.7, ["Fly|Ride"] = 66.94, ["Neon"] = 2.62, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.49, ["Mega|Fly"] = 63.1, ["Mega|Ride"] = 36.98, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 2.62, ["Neon|Ride"] = 32.24, ["Mega"] = 19.69, ["Mega|Ride"] = 133.77, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.9, ["Neon|Ride"] = 318.65, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.25, ["Mega|Ride"] = 181.75, ["Mega|Fly|Ride"] = 260.78}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 50.39, ["Neon"] = 3.94, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 42, ["Mega"] = 41.7, ["Mega|Fly"] = 45.23, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.19, ["Ride"] = 59.06, ["Fly|Ride"] = 210.31, ["Neon"] = 126, ["Neon|Ride"] = 174.57, ["Mega"] = 420, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.82, ["Fly"] = 6562.5, ["Ride"] = 56.79, ["Neon"] = 32.82, ["Neon|Ride"] = 208.21, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 4.78, ["Ride"] = 31.56, ["Fly|Ride"] = 178.77, ["Neon"] = 21.49, ["Neon|Ride"] = 70.88, ["Mega"] = 248.07, ["Mega|Ride"] = 450.06, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 12.49, ["Fly|Ride"] = 27.26, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 11.9, ["Neon|Fly|Ride"] = 24.45, ["Mega"] = 13.65, ["Mega|Fly"] = 19.15, ["Mega|Ride"] = 19.16, ["Mega|Fly|Ride"] = 42.12}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.12, ["Ride"] = 58.9, ["Neon"] = 6.49, ["Neon|Fly"] = 67.32, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 77.41, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.44, ["Neon|Fly|Ride"] = 84.14, ["Mega"] = 13.12, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 126.19}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 15.74, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 159.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.08, ["Ride"] = 16.67, ["Fly|Ride"] = 41.03, ["Neon"] = 11.82, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 37.99, ["Neon|Fly|Ride"] = 75.8, ["Mega"] = 169.31, ["Mega|Ride"] = 399.58, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 154.88, ["Ride"] = 182.97, ["Fly|Ride"] = 405.77, ["Neon"] = 919.02, ["Neon|Fly|Ride"] = 961.07, ["Mega"] = 8411.91, ["Mega|Ride"] = 3224.93, ["Mega|Fly|Ride"] = 3307.99}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 23.88, ["Neon"] = 8.05, ["Neon|Ride"] = 64.31, ["Mega"] = 68.16, ["Mega|Ride"] = 182.97, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 62.19, ["Neon"] = 32.34, ["Neon|Ride"] = 168.25, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 381.82, ["Mega|Ride"] = 524.7, ["Mega|Fly|Ride"] = 637.28}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 15.37, ["Fly|Ride"] = 28.41, ["Neon"] = 7.87, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.4, ["Mega"] = 46.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 140.91}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 17.92, ["Fly|Ride"] = 92.59, ["Neon"] = 7.17, ["Neon|Ride"] = 60.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 66.27, ["Mega|Ride"] = 190.95, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.12, ["Fly"] = 25.72, ["Ride"] = 15.65, ["Fly|Ride"] = 36.82, ["Neon"] = 26.27, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 77.97, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 238.7}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.63, ["Ride"] = 28.41, ["Fly|Ride"] = 254.48, ["Neon"] = 45.21, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 312.82, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.6, ["Fly"] = 21.49, ["Ride"] = 16.09, ["Fly|Ride"] = 36.51, ["Neon"] = 24.76, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 36.24, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 262.5, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 54.51, ["Fly"] = 98.63, ["Ride"] = 87.17, ["Fly|Ride"] = 148.31, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1430.04}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 192.94, ["Fly"] = 420.6, ["Ride"] = 225.05, ["Fly|Ride"] = 308.43, ["Neon"] = 1193.39, ["Neon|Ride"] = 1121.96, ["Neon|Fly|Ride"] = 953.72, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 4904.15}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.33, ["Fly"] = 140.91, ["Ride"] = 76.4, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 252.37, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 1261.8, ["Mega|Ride"] = 1348.03, ["Mega|Fly|Ride"] = 1369.1}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.88, ["Fly"] = 42.08, ["Ride"] = 23.28, ["Fly|Ride"] = 105, ["Neon"] = 35.79, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 121.99, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.12, ["Fly"] = 70.47, ["Ride"] = 19.69, ["Fly|Ride"] = 71.61, ["Neon"] = 81.37, ["Neon|Ride"] = 54.84, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 355.69, ["Mega|Ride"] = 272.77, ["Mega|Fly|Ride"] = 1261.8}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.17, ["Ride"] = 15.32, ["Fly|Ride"] = 44.67, ["Neon"] = 3.21, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 119.35, ["Mega|Fly"] = 145.61, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 370.32}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.39, ["Fly"] = 65.63, ["Ride"] = 23.26, ["Fly|Ride"] = 81.29, ["Neon"] = 398.61, ["Neon|Fly"] = 351.21, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 1837.5, ["Mega|Ride"] = 477.37, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.7, ["Fly|Ride"] = 35.77, ["Neon"] = 9.81, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 31.04, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 168.25, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 186.33}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.78, ["Ride"] = 30.51, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.77, ["Mega"] = 182.97, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.49, ["Mega|Ride"] = 42.08, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 18.38, ["Fly|Ride"] = 42.08, ["Neon"] = 15.65, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 159.93}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 25.72, ["Ride"] = 18.51, ["Fly|Ride"] = 62.05, ["Neon"] = 15.78, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 77.82, ["Mega"] = 131.17, ["Mega|Ride"] = 238.71, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 104.9, ["Fly"] = 143.07, ["Ride"] = 125.75, ["Fly|Ride"] = 189.7, ["Neon"] = 477.37, ["Neon|Ride"] = 448.88, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4205.96, ["Mega|Ride"] = 2705.4, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.86, ["Ride"] = 37.01, ["Fly|Ride"] = 127.71, ["Neon"] = 77.97, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 267.09, ["Mega"] = 326.82, ["Mega|Ride"] = 421.89, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 13.13, ["Neon|Ride"] = 33.67, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 238.7, ["Mega|Ride"] = 263.75, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.05, ["Ride"] = 58.01, ["Fly|Ride"] = 170.63, ["Neon"] = 130.29, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 575.82, ["Mega|Fly"] = 841.2, ["Mega|Ride"] = 683.82, ["Mega|Fly|Ride"] = 620.57}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.45}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.57, ["Ride"] = 28.84, ["Fly|Ride"] = 125.14, ["Neon"] = 46.47, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 119.36, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 420.6, ["Mega|Ride"] = 502.63, ["Mega|Fly|Ride"] = 875.96}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 20.99, ["Fly"] = 41.99, ["Ride"] = 28.13, ["Fly|Ride"] = 42.62, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.93, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 1357.48, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.27, ["Fly|Ride"] = 65.63, ["Neon"] = 3.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 29.45, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 58.95, ["Mega|Fly|Ride"] = 228.8}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 7.39, ["Fly"] = 28.41, ["Ride"] = 19.81, ["Fly|Ride"] = 39.38, ["Neon"] = 56.11, ["Neon|Ride"] = 63.1, ["Mega"] = 280.76, ["Mega|Fly"] = 398.61, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 418.5}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 15.8, ["Ride"] = 13.54, ["Fly|Ride"] = 47.39, ["Neon"] = 17.92, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 138.9, ["Mega|Ride"] = 186.27, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 210.31, ["Neon"] = 2.63, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 32.7, ["Mega"] = 27.36, ["Mega|Ride"] = 59.57, ["Mega|Fly|Ride"] = 121.78}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 21.19, ["Ride"] = 41.91, ["Fly|Ride"] = 94.49, ["Neon"] = 173.3, ["Neon|Ride"] = 230.29, ["Neon|Fly|Ride"] = 533.12, ["Mega"] = 787.5, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.6, ["Fly"] = 28.41, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 94.75, ["Mega"] = 140.91, ["Mega|Ride"] = 336.49}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.63, ["Fly"] = 28.8, ["Ride"] = 19.58, ["Fly|Ride"] = 47.76, ["Neon"] = 17.07, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 25.7, ["Neon|Fly|Ride"] = 74.05, ["Mega"] = 283.91, ["Mega|Ride"] = 283.91, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.25, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.49, ["Neon"] = 367.5, ["Neon|Ride"] = 312.38, ["Mega"] = 4457.28, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2468.91}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.46, ["Fly"] = 44.94, ["Ride"] = 21.05, ["Fly|Ride"] = 57.66, ["Neon"] = 38.91, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 116.72, ["Mega"] = 248.16, ["Mega|Ride"] = 204.02, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.57, ["Fly"] = 143.06, ["Ride"] = 105, ["Fly|Ride"] = 157.47, ["Neon"] = 234.49, ["Neon|Fly"] = 319.67, ["Neon|Ride"] = 246.65, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 946.35, ["Mega|Ride"] = 920.18, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 21, ["Fly"] = 31.49, ["Ride"] = 42.61, ["Fly|Ride"] = 207.66, ["Neon"] = 79.73, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 354.38, ["Mega|Ride"] = 333.65, ["Mega|Fly|Ride"] = 337.91}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.9, ["Fly"] = 41.36, ["Ride"] = 28.41, ["Fly|Ride"] = 70.13, ["Neon"] = 90.57, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 379.52, ["Mega"] = 210.31, ["Mega|Ride"] = 1577.24, ["Mega|Fly|Ride"] = 533.12}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.71, ["Fly"] = 69.42, ["Ride"] = 49.88, ["Fly|Ride"] = 159.93, ["Neon"] = 56.7, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.92, ["Mega|Ride"] = 323.07, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.03, ["Ride"] = 29.89, ["Fly|Ride"] = 84.14, ["Neon"] = 32.45, ["Neon|Ride"] = 57.17, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 263.75, ["Mega|Ride"] = 245.33, ["Mega|Fly|Ride"] = 344.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 70.1, ["Neon"] = 2.1, ["Neon|Fly"] = 93.78, ["Neon|Ride"] = 99.9, ["Mega"] = 18.95, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.59, ["Ride"] = 58.36, ["Neon"] = 28.65, ["Neon|Ride"] = 182.86, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 224.37, ["Mega|Ride"] = 273.4, ["Mega|Fly|Ride"] = 415.35}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.09, ["Ride"] = 28.04, ["Neon"] = 28.77, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 182.97, ["Mega|Ride"] = 279.62, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.94, ["Ride"] = 32.8, ["Fly|Ride"] = 119.36, ["Neon"] = 30.51, ["Neon|Ride"] = 82.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 507.38, ["Ride"] = 531.42, ["Fly|Ride"] = 551.25, ["Neon"] = 1753.89, ["Neon|Ride"] = 1794.91, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.08, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 56.34, ["Neon"] = 40.95, ["Neon|Ride"] = 69.42, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 170.63, ["Mega|Ride"] = 366.38, ["Mega|Fly|Ride"] = 348.06}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.02, ["Fly"] = 66.94, ["Ride"] = 16.95, ["Fly|Ride"] = 51.55, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 90.44, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 331.87, ["Mega|Ride"] = 474.23, ["Mega|Fly|Ride"] = 374.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.57, ["Fly"] = 24.93, ["Ride"] = 20.24, ["Fly|Ride"] = 50.78, ["Neon"] = 13.11, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.35, ["Fly|Ride"] = 52.5, ["Neon"] = 9.09, ["Neon|Ride"] = 31.11, ["Neon|Fly|Ride"] = 74.67, ["Mega"] = 60.16, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 89.65, ["Mega|Fly|Ride"] = 214.78}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 16.95, ["Neon"] = 2.37, ["Neon|Ride"] = 23.59, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 21.97, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 222.93}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.06, ["Ride"] = 30.19, ["Fly|Ride"] = 328.08, ["Neon"] = 60.87, ["Neon|Ride"] = 85.32, ["Mega"] = 394.32, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 5.02, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 35.81, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 248.16}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.15, ["Fly"] = 28.02, ["Ride"] = 64.04, ["Fly|Ride"] = 74.67, ["Neon"] = 33.32, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 203.44, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 1051.5}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 437.92, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 2290.07, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8752.25, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.56, ["Fly"] = 196.88, ["Ride"] = 56.8, ["Fly|Ride"] = 420.6, ["Neon"] = 31.04, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 190.95, ["Mega"] = 386.96, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 732.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.1, ["Ride"] = 28.23, ["Fly|Ride"] = 118.13, ["Neon"] = 6.56, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 140.9, ["Mega"] = 39.23, ["Mega|Fly"] = 144, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.09, ["Neon|Ride"] = 135.31, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 31.91, ["Mega|Ride"] = 138.92, ["Mega|Fly|Ride"] = 389.05}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.12, ["Fly"] = 107.63, ["Ride"] = 52.5, ["Fly|Ride"] = 87.29, ["Neon"] = 168, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.17, ["Ride"] = 71.31, ["Neon"] = 82.03, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 477.37, ["Mega"] = 398.61, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 620.4}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 31.5, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 652.8, ["Mega|Ride"] = 771.81, ["Mega|Fly|Ride"] = 1261.8}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.69, ["Ride"] = 23.86, ["Fly|Ride"] = 236.25, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 242.91, ["Mega"] = 629.9, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 377.5, ["Fly|Ride"] = 510.78, ["Neon"] = 1706.25, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.57, ["Fly"] = 13.13, ["Ride"] = 26.25, ["Fly|Ride"] = 64.4, ["Neon"] = 84.14, ["Neon|Ride"] = 131.25, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 865.39}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.75, ["Ride"] = 30.51, ["Fly|Ride"] = 127.32, ["Neon"] = 56.8, ["Neon|Ride"] = 221.82, ["Mega"] = 166.15, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.57, ["Ride"] = 80.07, ["Fly|Ride"] = 149.26, ["Neon"] = 65.63, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 312.38, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42.08, ["Fly|Ride"] = 210.31, ["Neon"] = 7.4, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 271.3, ["Mega"] = 38.07, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 208.21}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.29, ["Ride"] = 90.44, ["Neon"] = 356.84, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 504.73, ["Mega"] = 1611.08, ["Mega|Ride"] = 2069.32, ["Mega|Fly|Ride"] = 1330.72}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Fly|Ride"] = 196.88, ["Neon"] = 7.38, ["Neon|Fly"] = 182.97, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 63, ["Mega|Ride"] = 94.85, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.24, ["Fly"] = 26.23, ["Ride"] = 28.55, ["Fly|Ride"] = 98.89, ["Neon"] = 4.08, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.96, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 31.49, ["Mega|Fly"] = 112.2, ["Mega|Ride"] = 77.87, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 127.62, ["Neon"] = 6.57, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 84, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.65, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 184.02, ["Neon"] = 248.98, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 477.37, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 210.37, ["Ride"] = 242.91, ["Fly|Ride"] = 420.6, ["Neon"] = 1461.58, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9547.04, ["Mega|Fly|Ride"] = 4677.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 2.1, ["Neon"] = 26.17, ["Neon|Fly"] = 350.44, ["Mega"] = 139.11, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 20.1, ["Fly|Ride"] = 159.93, ["Neon"] = 6.46, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 38.07, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.83, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.3, ["Fly"] = 26.25, ["Ride"] = 28.41, ["Fly|Ride"] = 79.97, ["Neon"] = 32.81, ["Mega"] = 140.91, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 30.05, ["Fly|Ride"] = 374.35, ["Neon"] = 16.7, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 138.9, ["Mega"] = 124.69, ["Mega|Fly"] = 233.44, ["Mega|Ride"] = 141.58, ["Mega|Fly|Ride"] = 343.86}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.93, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 26.04, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 36.82, ["Ride"] = 17.92, ["Fly|Ride"] = 52.49, ["Neon"] = 5.2, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 39.41, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.24, ["Ride"] = 17.8, ["Fly|Ride"] = 46.56, ["Neon"] = 15.08, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 38.9, ["Neon|Fly|Ride"] = 95.49, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 168.16}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 29.79, ["Ride"] = 32.43, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 318.47, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 525.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.82, ["Ride"] = 84.33, ["Fly|Ride"] = 139.12, ["Neon"] = 336.49, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1964.19, ["Mega|Ride"] = 1528.88, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.75, ["Fly|Ride"] = 144.38, ["Neon"] = 3.75, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 44.18, ["Mega|Fly"] = 672, ["Mega|Ride"] = 91.49, ["Mega|Fly|Ride"] = 246.06}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.23, ["Ride"] = 15.65, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 35.81, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 125.14}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.17, ["Fly"] = 42.08, ["Ride"] = 28.77, ["Neon"] = 48.37, ["Neon|Ride"] = 135.19, ["Mega"] = 524.7, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4205.96, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.65, ["Fly"] = 98.85, ["Ride"] = 47.76, ["Fly|Ride"] = 94.65, ["Neon"] = 210.31, ["Neon|Ride"] = 177.71, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 765.05, ["Mega|Fly|Ride"] = 1273.35}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 281.33, ["Neon"] = 7.88, ["Neon|Ride"] = 47.92, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 102.38, ["Mega|Ride"] = 144.32, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.62, ["Fly|Ride"] = 65.63, ["Neon"] = 41.81, ["Neon|Ride"] = 72.34}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.63, ["Fly"] = 169.3, ["Ride"] = 37.59, ["Fly|Ride"] = 88.2, ["Neon"] = 194.25, ["Neon|Ride"] = 266.14, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 2523.59, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1261.8}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 91.88, ["Fly"] = 119.34, ["Ride"] = 113.43, ["Fly|Ride"] = 189.29, ["Neon"] = 430.1, ["Neon|Ride"] = 477.37, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.7, ["Ride"] = 259.88, ["Fly|Ride"] = 360.51, ["Neon"] = 1020.34, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3506.72}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 27.56, ["Ride"] = 61.6, ["Fly|Ride"] = 143.21, ["Neon"] = 84.33, ["Neon|Fly"] = 119.36, ["Neon|Ride"] = 90.09, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 389.8, ["Mega|Ride"] = 404.8, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 14.6, ["Fly|Ride"] = 43.22, ["Neon"] = 7.25, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 91.49, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 9.19, ["Fly"] = 45.05, ["Ride"] = 18.37, ["Fly|Ride"] = 56.44, ["Neon"] = 31.39, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 87.04, ["Mega"] = 357.53, ["Mega|Ride"] = 409.34, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 370.13, ["Ride"] = 367.5, ["Fly|Ride"] = 637.28, ["Neon"] = 1549.42, ["Mega"] = 10094.3, ["Mega|Fly|Ride"] = 5067.57}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.61, ["Neon"] = 5.08, ["Neon|Ride"] = 280.76, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 27.68, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.63, ["Fly"] = 42.08, ["Ride"] = 16.02, ["Fly|Ride"] = 39.37, ["Neon"] = 37.87, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 233.44, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 182.97, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.37, ["Ride"] = 65.33, ["Neon"] = 89.41, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 406.93, ["Mega"] = 459.37, ["Mega|Ride"] = 555.41, ["Mega|Fly|Ride"] = 636.91}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 91.88, ["Fly"] = 140.91, ["Ride"] = 109.62, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 525.75, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.46, ["Fly"] = 35.77, ["Ride"] = 26.17, ["Fly|Ride"] = 51.65, ["Neon"] = 126.19, ["Neon|Ride"] = 89.29, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 701.36, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 520.5}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.05, ["Neon"] = 3.41, ["Neon|Ride"] = 63, ["Mega"] = 25.62, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.54, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 82.15, ["Mega"] = 24.93, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 15.79, ["Fly"] = 13.13, ["Ride"] = 56.41, ["Fly|Ride"] = 182.97, ["Neon"] = 32.82, ["Neon|Ride"] = 86.23, ["Neon|Fly|Ride"] = 228.59, ["Mega"] = 159.91, ["Mega|Ride"] = 190.31, ["Mega|Fly|Ride"] = 300.98}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Ride"] = 1155, ["Fly|Ride"] = 1379.44, ["Neon"] = 4376.12, ["Neon|Ride"] = 4205.96, ["Neon|Fly|Ride"] = 4343.72, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 429.19, ["Ride"] = 419.99, ["Fly|Ride"] = 560.44, ["Neon"] = 1663.2, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 16823.82, ["Mega|Fly|Ride"] = 7122.78}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 305.82, ["Fly"] = 416.4, ["Ride"] = 328.13, ["Fly|Ride"] = 419.26, ["Neon"] = 787.5, ["Neon|Fly"] = 1114.63, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 734.69, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 240.18, ["Fly"] = 336.49, ["Ride"] = 299.41, ["Fly|Ride"] = 367.04, ["Neon"] = 708.75, ["Neon|Ride"] = 603.73, ["Neon|Fly|Ride"] = 656.24, ["Mega|Fly|Ride"] = 2958.9}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.21, ["Ride"] = 14.21, ["Fly|Ride"] = 39.12, ["Neon"] = 3.93, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.54, ["Mega|Fly"] = 111.47, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 304.5, ["Fly"] = 393.27, ["Ride"] = 351.21, ["Fly|Ride"] = 498.75, ["Neon"] = 1311.22, ["Neon|Ride"] = 1243.93, ["Neon|Fly|Ride"] = 1114.32, ["Mega"] = 21310.51, ["Mega|Ride"] = 5047.16, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.93, ["Fly"] = 157.5, ["Ride"] = 70.26, ["Fly|Ride"] = 91.87, ["Neon"] = 22.99, ["Neon|Ride"] = 419.99, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.81, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 366.38}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.49, ["Fly|Ride"] = 38.98, ["Neon"] = 10.53, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.9, ["Mega|Ride"] = 192.94}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 3.94, ["Neon|Ride"] = 45.94, ["Mega"] = 32.45, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 27.57, ["Ride"] = 52.59, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 351.21, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7956.26, ["Ride"] = 26.25, ["Fly|Ride"] = 67.57, ["Neon"] = 23.88, ["Mega"] = 353.31, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.49, ["Mega|Ride"] = 69.42, ["Mega|Fly|Ride"] = 166.15}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 5.13, ["Fly"] = 41.02, ["Ride"] = 27.46, ["Fly|Ride"] = 65.62, ["Neon"] = 17.07, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 80.12, ["Mega"] = 136.49, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.13, ["Fly"] = 56.8, ["Ride"] = 18.95, ["Fly|Ride"] = 50.33, ["Neon"] = 35.77, ["Neon|Fly"] = 143.21, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 17.05, ["Ride"] = 51.32, ["Neon"] = 92.9, ["Neon|Ride"] = 182.97, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 317.45, ["Mega|Ride"] = 787.58}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 4.23, ["Fly"] = 6329.86, ["Ride"] = 19.69, ["Neon"] = 47.7, ["Neon|Fly"] = 48.57, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 328.13, ["Mega|Ride"] = 415.35, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.89, ["Ride"] = 18.36, ["Fly|Ride"] = 45.93, ["Neon"] = 3.82, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 98.85, ["Mega"] = 44.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.95, ["Fly"] = 256.58, ["Ride"] = 164, ["Fly|Ride"] = 229.69, ["Neon"] = 840.15, ["Neon|Ride"] = 896.24, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 3464.35}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 13.55, ["Fly|Ride"] = 35.43, ["Neon"] = 3.9, ["Neon|Fly"] = 35.77, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 25.47, ["Mega|Ride"] = 52.77, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.59, ["Ride"] = 42.57, ["Fly|Ride"] = 196.88, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 313.69, ["Mega|Fly"] = 795.99, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.12, ["Ride"] = 81.38, ["Fly|Ride"] = 170.63, ["Neon"] = 154.34, ["Neon|Ride"] = 273.4, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 786.19, ["Mega|Ride"] = 580.75, ["Mega|Fly|Ride"] = 841.2}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 191.94, ["Fly"] = 303.13, ["Ride"] = 238.77, ["Fly|Ride"] = 269.59, ["Neon"] = 796.23, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3444.7}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.63, ["Ride"] = 159.91, ["Fly|Ride"] = 143.21, ["Neon"] = 91.88, ["Neon|Ride"] = 280.76, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 5.78, ["Ride"] = 57.74, ["Fly|Ride"] = 182.97, ["Neon"] = 105.16, ["Neon|Fly"] = 159.93, ["Neon|Ride"] = 203.06, ["Neon|Fly|Ride"] = 149.05, ["Mega"] = 771.81, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 908.25, ["Ride"] = 929.86, ["Fly|Ride"] = 1034.66, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4625.51, ["Mega|Fly|Ride"] = 17504.47}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 13.13, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 93.1, ["Neon"] = 44.59, ["Neon|Fly"] = 54.14, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 226.75, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 334.39}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.07, ["Fly"] = 78.75, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 38.52, ["Neon|Ride"] = 83.08, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 521.55, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.14, ["Ride"] = 21.05, ["Fly|Ride"] = 69.57, ["Neon"] = 9.85, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 78.75, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.53, ["Fly"] = 54.7, ["Ride"] = 39.38, ["Fly|Ride"] = 88.62, ["Neon"] = 68.23, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 437.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.47, ["Ride"] = 15.75, ["Fly|Ride"] = 49.43, ["Neon"] = 17.05, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 64.45, ["Mega"] = 133.88, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.21, ["Fly"] = 32.75, ["Ride"] = 26.15, ["Fly|Ride"] = 32.82, ["Neon"] = 11.46, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 196.64, ["Mega"] = 124.48, ["Mega|Ride"] = 199.31, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Fly"] = 234.49, ["Ride"] = 262.5, ["Fly|Ride"] = 225.04, ["Neon"] = 911.66, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 28.41, ["Fly|Ride"] = 108.94, ["Neon"] = 6.17, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 64.31, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 121.99, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 6.09, ["Ride"] = 82.02, ["Fly|Ride"] = 88.86, ["Neon"] = 27.57, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.07, ["Fly"] = 98.85, ["Ride"] = 24.94, ["Neon"] = 10.15, ["Neon|Ride"] = 84.14, ["Mega"] = 94.35, ["Mega|Ride"] = 120.51, ["Mega|Fly|Ride"] = 459.16}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 78.94, ["Ride"] = 127.21, ["Fly|Ride"] = 315, ["Neon"] = 420, ["Neon|Ride"] = 607.78, ["Neon|Fly|Ride"] = 637.28, ["Mega"] = 2523.59, ["Mega|Ride"] = 4205.96, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 36.66, ["Fly"] = 90.76, ["Ride"] = 42.52, ["Fly|Ride"] = 252.37, ["Neon"] = 150.93, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 634.33, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.36, ["Fly"] = 57.49, ["Ride"] = 32.82, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 238.61, ["Mega"] = 590.63, ["Mega|Ride"] = 392.77, ["Mega|Fly|Ride"] = 439.03}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 231.55, ["Mega"] = 78.75, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 40.69, ["Fly"] = 74.78, ["Ride"] = 88.35, ["Fly|Ride"] = 156.35, ["Neon"] = 303.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 286.78, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 52.49, ["Neon"] = 3.84, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.52, ["Fly"] = 108.62, ["Ride"] = 33.44, ["Fly|Ride"] = 95.7, ["Neon"] = 69.3, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.6, ["Fly"] = 203.44, ["Ride"] = 76.04, ["Fly|Ride"] = 157.17, ["Neon"] = 159.93, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1365.9, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.15, ["Fly|Ride"] = 31.5, ["Neon"] = 2.63, ["Neon|Fly"] = 24.2, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 14.6, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.62, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 20.37, ["Neon|Fly"] = 63.1, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 190.95, ["Mega|Ride"] = 280.46, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.49, ["Fly"] = 140.91, ["Ride"] = 39.38, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 442.97, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 630.91}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.24, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.68, ["Mega|Ride"] = 77.82, ["Mega|Fly|Ride"] = 208.21}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 23.03, ["Fly"] = 201.52, ["Ride"] = 68.21, ["Fly|Ride"] = 118.02, ["Neon"] = 118.22, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 639.19, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 512.71, ["Mega|Fly|Ride"] = 628.81}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 42.08, ["Ride"] = 26.25, ["Fly|Ride"] = 98.44, ["Neon"] = 64.45, ["Neon|Ride"] = 117, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.25, ["Ride"] = 46.78, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 230.35, ["Mega|Ride"] = 258.64, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.22, ["Fly"] = 69.3, ["Ride"] = 56.79, ["Fly|Ride"] = 196.88, ["Neon"] = 48.6, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 129.92, ["Mega"] = 241.45, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Fly"] = 42.08, ["Ride"] = 19.69, ["Fly|Ride"] = 196.88, ["Neon"] = 6.56, ["Neon|Ride"] = 32.61, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 277.61}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.29, ["Neon"] = 3.94, ["Mega"] = 22.32, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 14.43}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.53, ["Fly"] = 98.85, ["Ride"] = 52.49, ["Fly|Ride"] = 80.07, ["Neon"] = 184.57, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1823.3, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Ride"] = 27.45, ["Mega"] = 18.38, ["Mega|Ride"] = 119.6, ["Mega|Fly|Ride"] = 315.46}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 477.37, ["Fly"] = 498.75, ["Ride"] = 491.07, ["Fly|Ride"] = 891.48, ["Neon"] = 2804.33, ["Neon|Ride"] = 1991.53, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 16823.82, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.6, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 66.26, ["Neon"] = 35.39, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 112.52, ["Mega"] = 93.58, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.89, ["Fly"] = 28.41, ["Ride"] = 19.69, ["Fly|Ride"] = 84.66, ["Neon"] = 19.45, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 111.47, ["Mega|Ride"] = 152.29, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.2, ["Fly"] = 70.47, ["Ride"] = 42.17, ["Fly|Ride"] = 70.82, ["Neon"] = 55.53, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 666.66, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.79, ["Fly"] = 56.8, ["Ride"] = 28.41, ["Fly|Ride"] = 701.36, ["Neon"] = 17.22, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Ride"] = 238.7, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.8, ["Fly"] = 140.91, ["Ride"] = 94.65, ["Fly|Ride"] = 157.5, ["Neon"] = 64.6, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 376.45, ["Mega"] = 292.81, ["Mega|Ride"] = 375.92, ["Mega|Fly|Ride"] = 624.6}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.94, ["Fly"] = 105, ["Ride"] = 25.6, ["Fly|Ride"] = 91.88, ["Neon"] = 30.19, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 138.81, ["Mega"] = 244.98, ["Mega|Ride"] = 279.57, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 41.78, ["Ride"] = 13.55, ["Fly|Ride"] = 72.71, ["Neon"] = 2.1, ["Neon|Fly"] = 59.95, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 75.72, ["Mega"] = 15.1, ["Mega|Fly"] = 64.45, ["Mega|Ride"] = 34.27, ["Mega|Fly|Ride"] = 70.47}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.66, ["Fly"] = 53.65, ["Ride"] = 39.38, ["Fly|Ride"] = 105.16, ["Neon"] = 36.75, ["Neon|Fly"] = 119.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 183.75, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 301.2, ["Ride"] = 318.6, ["Fly|Ride"] = 380.29, ["Neon"] = 1823.3, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9260.62, ["Mega|Fly|Ride"] = 4612.89}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 86.63, ["Ride"] = 114.19, ["Fly|Ride"] = 284.82, ["Neon"] = 356.57, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2243.9, ["Mega|Ride"] = 1819.09, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.44, ["Fly|Ride"] = 34.61, ["Neon"] = 4.6, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 33.67, ["Neon|Fly|Ride"] = 56.8, ["Mega"] = 42.08, ["Mega|Fly"] = 64.45, ["Mega|Ride"] = 104.11, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.57, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 6.32, ["Neon|Fly"] = 46.28, ["Neon|Ride"] = 26.56, ["Neon|Fly|Ride"] = 56.33, ["Mega"] = 65.63, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Fly"] = 98.85, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 385.91, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 269.07, ["Ride"] = 252, ["Fly|Ride"] = 288.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1558.32, ["Mega|Ride"] = 8411.91, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 23.15, ["Ride"] = 16.85, ["Fly|Ride"] = 40.27, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 33.67, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 255.93, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 630.91}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.33, ["Fly"] = 318.65, ["Ride"] = 77.97, ["Fly|Ride"] = 210.31, ["Neon"] = 26.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 196.88, ["Mega|Ride"] = 300.09, ["Mega|Fly|Ride"] = 450.06}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.88, ["Neon"] = 6.29, ["Neon|Ride"] = 155.92, ["Mega"] = 65.54, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.96, ["Fly"] = 47.76, ["Ride"] = 17.75, ["Fly|Ride"] = 103.06, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.84, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.93, ["Ride"] = 75.51, ["Fly|Ride"] = 280.76, ["Neon"] = 156.59, ["Neon|Fly"] = 210.31, ["Neon|Ride"] = 169.31, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 426.57, ["Mega|Fly"] = 2208.14, ["Mega|Ride"] = 467.25, ["Mega|Fly|Ride"] = 574.06}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 24.22, ["Fly"] = 62.05, ["Ride"] = 46.94, ["Fly|Ride"] = 84.14, ["Neon"] = 157.31, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 306.01, ["Mega"] = 841.2, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 14.95, ["Fly|Ride"] = 41.78, ["Neon"] = 2.1, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 15.8, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 16.83, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 242.91, ["Fly"] = 257.79, ["Ride"] = 230.99, ["Fly|Ride"] = 272.97, ["Neon"] = 2397.38, ["Neon|Ride"] = 911.66, ["Neon|Fly|Ride"] = 980, ["Mega|Fly|Ride"] = 3924.17}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.97, ["Fly"] = 65.63, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 107.63, ["Neon|Ride"] = 206.11, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 425.25, ["Mega|Ride"] = 423.2, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 18.74, ["Fly|Ride"] = 42.08, ["Neon"] = 7.88, ["Neon|Fly"] = 39.4, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 59.21, ["Mega|Ride"] = 77.93, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.56, ["Ride"] = 16.14, ["Fly|Ride"] = 45.48, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 119.89, ["Mega"] = 21.06, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 62.62, ["Mega|Fly|Ride"] = 137.76}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.93, ["Ride"] = 21.05, ["Fly|Ride"] = 72.19, ["Neon"] = 15.44, ["Neon|Fly"] = 716.04, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 14.44, ["Fly"] = 38.74, ["Ride"] = 22.39, ["Fly|Ride"] = 62.91, ["Neon"] = 48.27, ["Neon|Fly"] = 267.09, ["Neon|Ride"] = 55.12, ["Neon|Fly|Ride"] = 117.98, ["Mega"] = 355.59, ["Mega|Ride"] = 369.58, ["Mega|Fly|Ride"] = 355.36}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.39, ["Ride"] = 56.22, ["Fly|Ride"] = 72.19, ["Neon"] = 54.57, ["Neon|Fly|Ride"] = 315, ["Mega"] = 253.32, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 398.61}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 41.79, ["Neon"] = 2.1, ["Neon|Ride"] = 31.56, ["Neon|Fly|Ride"] = 99.26, ["Mega"] = 56.11, ["Mega|Ride"] = 83.39, ["Mega|Fly|Ride"] = 292.34}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.68, ["Fly"] = 28.88, ["Ride"] = 27.18, ["Fly|Ride"] = 131.25, ["Neon"] = 30.86, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 248.16, ["Mega|Ride"] = 211.98, ["Mega|Fly|Ride"] = 299.56}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 83.77, ["Neon"] = 3.49, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.32, ["Mega"] = 23.9, ["Mega|Ride"] = 104.11, ["Mega|Fly|Ride"] = 137.76}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.99, ["Ride"] = 17.64, ["Fly|Ride"] = 40.26, ["Neon"] = 5.16, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 106.55, ["Mega"] = 54.51, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 78.46, ["Mega|Fly|Ride"] = 140.81}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.13, ["Ride"] = 702.19, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Ride"] = 4889.43, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12571.05}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.33, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 35.77, ["Neon|Fly|Ride"] = 73.62, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.85, ["Ride"] = 45.93, ["Fly|Ride"] = 280.76, ["Neon"] = 10.5, ["Neon|Fly"] = 736.05, ["Neon|Ride"] = 95.49, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.1, ["Mega|Fly"] = 147.23, ["Mega|Ride"] = 138.81, ["Mega|Fly|Ride"] = 257.22}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 10.5, ["Fly"] = 40.67, ["Ride"] = 23.1, ["Fly|Ride"] = 45.92, ["Neon"] = 42.08, ["Neon|Fly"] = 190.95, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 330.4}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.21, ["Fly|Ride"] = 41.03, ["Neon"] = 6.57, ["Neon|Fly"] = 147.23, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 65.62, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 29.87, ["Fly"] = 105, ["Ride"] = 56.8, ["Fly|Ride"] = 280.76, ["Neon"] = 169.2, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 687.38, ["Mega|Ride"] = 617.24, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.75, ["Fly|Ride"] = 64.46, ["Neon"] = 6.57, ["Neon|Fly"] = 130.67, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 131.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.7, ["Fly"] = 73.41, ["Ride"] = 23.31, ["Fly|Ride"] = 63.1, ["Neon"] = 9.87, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 84.17, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 27.36, ["Mega"] = 95.49, ["Mega|Ride"] = 157.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 16.85, ["Fly|Ride"] = 49.95, ["Neon"] = 3.81, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.83, ["Mega"] = 39.27, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11, ["Fly"] = 17.07, ["Ride"] = 17.92, ["Fly|Ride"] = 38.2, ["Neon"] = 104.99, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 136.71, ["Mega|Ride"] = 460.57, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 734.99, ["Fly"] = 890.63, ["Ride"] = 733.69, ["Fly|Ride"] = 835.42, ["Neon"] = 1823.3, ["Neon|Ride"] = 1517.9, ["Neon|Fly|Ride"] = 1911.21, ["Mega"] = 4654.13, ["Mega|Fly|Ride"] = 6169.09}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.42, ["Fly|Ride"] = 34.12, ["Neon"] = 5.25, ["Neon|Ride"] = 17.17, ["Neon|Fly|Ride"] = 42.29, ["Mega"] = 60.38, ["Mega|Ride"] = 55.35, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 11.47, ["Ride"] = 32.81, ["Fly|Ride"] = 238.7, ["Neon"] = 48.57, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 398.61, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 50.29, ["Fly"] = 105, ["Ride"] = 74.81, ["Fly|Ride"] = 105, ["Neon|Ride"] = 378.55, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1646.87}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.77, ["Ride"] = 50.13, ["Fly|Ride"] = 105, ["Neon"] = 157.5, ["Neon|Ride"] = 220.83, ["Mega"] = 1273.35, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.27, ["Ride"] = 26.23, ["Fly|Ride"] = 140.91, ["Neon"] = 42.53, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 147.13, ["Mega"] = 302.29, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 35.44, ["Ride"] = 52.59, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 310.21, ["Mega"] = 281.3, ["Mega|Fly"] = 517.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 318.65}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.46, ["Ride"] = 77.44, ["Fly|Ride"] = 153.67, ["Neon"] = 120.56, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Ride"] = 630.91, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 17.07}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.17, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 84, ["Neon"] = 37.58, ["Neon|Ride"] = 39.41, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.27, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 233.44, ["Mega|Fly|Ride"] = 278.78}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.51, ["Ride"] = 46.85, ["Neon"] = 10.16, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 133.55, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 32.71, ["Fly"] = 126.19, ["Ride"] = 38.67, ["Fly|Ride"] = 79.16, ["Neon"] = 201.48, ["Neon|Ride"] = 167.2, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 843.74, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 733.68}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.94, ["Fly"] = 18.09, ["Ride"] = 15.89, ["Fly|Ride"] = 45.76, ["Neon"] = 23.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 198.19, ["Mega|Fly"] = 419.55, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.62, ["Fly"] = 37.37, ["Ride"] = 26.25, ["Fly|Ride"] = 56.26, ["Neon"] = 23.88, ["Neon|Ride"] = 42.25, ["Neon|Fly|Ride"] = 126.52, ["Mega"] = 143.21, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.32, ["Mega"] = 52.4, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 25.86, ["Fly"] = 78.74, ["Ride"] = 49.03, ["Fly|Ride"] = 120.74, ["Neon"] = 210.31, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 420.6, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 65.63, ["Neon"] = 3.8, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.41, ["Mega"] = 81.81, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 461.86}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 8.23, ["Ride"] = 79.97, ["Fly|Ride"] = 279.71, ["Neon"] = 59.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Ride"] = 430.5, ["Mega|Fly|Ride"] = 546.79}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 45.92, ["Ride"] = 14.44, ["Fly|Ride"] = 41.91, ["Neon"] = 93.6, ["Neon|Ride"] = 35.77, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 255.4}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 22.68, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 291.38, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.38, ["Ride"] = 73.7, ["Neon"] = 68.25, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 954.72, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 45.09, ["Ride"] = 132.38, ["Neon"] = 368.03, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 630}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.5, ["Ride"] = 105.16, ["Neon"] = 98.85, ["Neon|Ride"] = 183.75, ["Mega"] = 288.75, ["Mega|Ride"] = 378.55, ["Mega|Fly|Ride"] = 601.47}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 16.99, ["Ride"] = 125.9, ["Fly|Ride"] = 131.25, ["Neon"] = 63.4, ["Neon|Fly"] = 210.31, ["Neon|Ride"] = 420.6, ["Mega|Ride"] = 840.15, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.32, ["Ride"] = 69.57, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 617.4, ["Mega|Fly"] = 2102.99, ["Mega|Ride"] = 716.04, ["Mega|Fly|Ride"] = 739.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.04, ["Neon"] = 13.57, ["Neon|Ride"] = 79.97, ["Mega"] = 180.87, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 318.65}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.36, ["Ride"] = 14.32, ["Fly|Ride"] = 42.08, ["Neon"] = 5.24, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 68.54, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 32.51, ["Fly|Ride"] = 69.57, ["Neon"] = 11.05, ["Neon|Ride"] = 88.33, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 84.52, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.75, ["Fly|Ride"] = 56.8, ["Neon"] = 5.75, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 48.57, ["Mega|Fly"] = 112.52, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 204.01}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.15, ["Fly|Ride"] = 118.13, ["Neon"] = 14.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 84.14, ["Mega"] = 252.35, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.12, ["Fly"] = 32.82, ["Ride"] = 24.39, ["Fly|Ride"] = 420.6, ["Neon"] = 28.4, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 298.64, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1051.5}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.3, ["Fly"] = 131.25, ["Ride"] = 21.95, ["Fly|Ride"] = 71.31, ["Neon"] = 19.68, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 19.38, ["Fly|Ride"] = 49.88, ["Neon"] = 15.75, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 252.37, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.89, ["Fly"] = 39.38, ["Ride"] = 44.01, ["Fly|Ride"] = 91.88, ["Neon"] = 11.82, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 46.53, ["Neon|Fly|Ride"] = 127.71, ["Mega"] = 97.02, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 123.81, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.5, ["Fly"] = 99.89, ["Ride"] = 131.25, ["Fly|Ride"] = 262.5, ["Neon"] = 112.52, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 531.57, ["Mega|Ride"] = 566.2, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.85, ["Fly"] = 147.23, ["Ride"] = 79.97, ["Fly|Ride"] = 180.87, ["Neon"] = 200.43, ["Neon|Ride"] = 252.37, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1318.57, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.21, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.93, ["Mega|Ride"] = 47.65, ["Mega|Fly|Ride"] = 145.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.06, ["Ride"] = 52.5, ["Mega"] = 686.56, ["Mega|Ride"] = 672.97, ["Mega|Fly|Ride"] = 1048.35}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.4, ["Ride"] = 72.19, ["Neon"] = 307.77, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 840.15, ["Mega"] = 1723.4, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1364.85}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.34, ["Fly"] = 190.32, ["Ride"] = 27.57, ["Fly|Ride"] = 133.88, ["Neon"] = 39.38, ["Neon|Fly"] = 127.71, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 148.32, ["Mega|Ride"] = 225.04, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.58, ["Ride"] = 68.8, ["Neon"] = 12.5, ["Neon|Ride"] = 58.98, ["Neon|Fly|Ride"] = 168.25, ["Mega"] = 105, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 25.76, ["Ride"] = 15.75, ["Fly|Ride"] = 56.44, ["Neon"] = 11.42, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 88.33, ["Mega"] = 159.87, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 127.71, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.06, ["Fly|Ride"] = 41.9, ["Neon"] = 2.63, ["Neon|Fly"] = 29.61, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Fly|Ride"] = 45.23, ["Neon"] = 3.82, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.36, ["Mega|Fly"] = 164.7, ["Mega|Ride"] = 62.05, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 2.5, ["Neon|Ride"] = 145.07, ["Mega"] = 27.93, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.23, ["Ride"] = 157.5, ["Neon"] = 35.93, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 182.97, ["Mega|Fly|Ride"] = 318.65}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.65, ["Ride"] = 34.12, ["Fly|Ride"] = 207.66, ["Neon"] = 53.62, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.16, ["Fly"] = 20.79, ["Ride"] = 19.59, ["Fly|Ride"] = 37.86, ["Neon"] = 41.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 82.47, ["Mega"] = 311.07, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 341.91}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 59.67, ["Ride"] = 159.93, ["Fly|Ride"] = 262.5, ["Neon"] = 472.5, ["Neon|Ride"] = 561.51, ["Mega"] = 2386.77, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.74, ["Fly"] = 82.69, ["Ride"] = 43.32, ["Fly|Ride"] = 84.14, ["Neon"] = 132.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 637.28, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.8, ["Fly|Ride"] = 38, ["Neon"] = 2.63, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 32.24, ["Mega|Ride"] = 91.58, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 14.33, ["Fly|Ride"] = 35.44, ["Neon"] = 3.94, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 20, ["Neon|Fly|Ride"] = 53.65, ["Mega"] = 39.38, ["Mega|Fly"] = 120.94, ["Mega|Ride"] = 63.1, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Ride"] = 439.68, ["Fly|Ride"] = 505.32, ["Neon|Fly|Ride"] = 1886.38}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.92, ["Fly"] = 105.16, ["Ride"] = 70.47, ["Fly|Ride"] = 112.52, ["Neon"] = 39.36, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 14.04, ["Fly|Ride"] = 32.16, ["Neon"] = 5.25, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 48.38, ["Mega|Ride"] = 77.82, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.75, ["Ride"] = 94.02, ["Fly|Ride"] = 261.19, ["Neon"] = 231.2, ["Neon|Ride"] = 322.1, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 735, ["Mega|Ride"] = 761.24, ["Mega|Fly|Ride"] = 847.94}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 52.76, ["Neon"] = 10.36, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.1, ["Neon|Fly|Ride"] = 70.65, ["Mega"] = 111.57, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 302.79, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 26.25, ["Fly|Ride"] = 196.88, ["Neon"] = 2.63, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 17.07, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.33, ["Fly"] = 126.41, ["Ride"] = 78.71, ["Fly|Ride"] = 213.56, ["Neon"] = 160.13, ["Neon|Ride"] = 157.29, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 795.99, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 719.23}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 18.06, ["Fly|Ride"] = 146.99, ["Neon"] = 6.33, ["Neon|Ride"] = 39.98, ["Neon|Fly|Ride"] = 77.82, ["Mega"] = 25.6, ["Mega|Ride"] = 150.64, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.77, ["Ride"] = 69.45, ["Fly|Ride"] = 119.89, ["Neon"] = 336.49, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1661.36, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.93, ["Fly"] = 70.47, ["Ride"] = 131.24, ["Fly|Ride"] = 159.85, ["Neon"] = 17.07, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 491.07, ["Mega"] = 170.63, ["Mega|Ride"] = 189.29, ["Mega|Fly|Ride"] = 315.46}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 70.47, ["Ride"] = 71.29, ["Fly|Ride"] = 70.47, ["Neon"] = 8.64, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.62, ["Mega"] = 103.06, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 42.92, ["Fly"] = 140.91, ["Ride"] = 56.82, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 701.36, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1954.74}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 417.22, ["Ride"] = 38.07, ["Fly|Ride"] = 946.35, ["Neon"] = 6.3, ["Neon|Ride"] = 39.98, ["Neon|Fly|Ride"] = 156.35, ["Mega"] = 45.94, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 95.49, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 19.2, ["Fly|Ride"] = 102.87, ["Neon"] = 10.07, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 56.8, ["Mega"] = 95.49, ["Mega|Fly"] = 146.81, ["Mega|Ride"] = 99.58, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.07, ["Fly"] = 57.91, ["Ride"] = 32.38, ["Fly|Ride"] = 104.1, ["Neon"] = 79.48, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 300.46, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.36, ["Fly"] = 42.08, ["Ride"] = 28.41, ["Fly|Ride"] = 70.54, ["Neon"] = 61.68, ["Neon|Ride"] = 60.48, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 736.05, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 557.38}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.34, ["Fly"] = 28.41, ["Ride"] = 27.57, ["Fly|Ride"] = 55, ["Neon"] = 72.19, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 121.99, ["Mega"] = 390.12, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.29, ["Ride"] = 127.71, ["Fly|Ride"] = 210.31, ["Neon"] = 346.48, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 561.51, ["Mega"] = 1193.39, ["Mega|Ride"] = 1288.86, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.32, ["Ride"] = 66.05, ["Neon"] = 52.37, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 234.31, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 412.2}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.36, ["Ride"] = 26.99, ["Fly|Ride"] = 78.74, ["Neon"] = 19.09, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 163, ["Mega|Ride"] = 155.64, ["Mega|Fly|Ride"] = 252.37}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.54, ["Fly"] = 287.55, ["Ride"] = 28.74, ["Fly|Ride"] = 155.36, ["Neon"] = 63.1, ["Neon|Ride"] = 104.9, ["Mega"] = 446.34, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.53, ["Fly|Ride"] = 37.21, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.47, ["Mega|Ride"] = 26.77, ["Mega|Fly|Ride"] = 95.75}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 42, ["Ride"] = 112.56, ["Fly|Ride"] = 280.76, ["Neon"] = 236.24, ["Neon|Fly"] = 2383.74, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1050.45, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 140.91, ["Neon"] = 4.13, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.17, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 17.07, ["Fly|Ride"] = 59.06, ["Neon"] = 19.69, ["Neon|Ride"] = 31.56, ["Neon|Fly|Ride"] = 90.04, ["Mega"] = 257.25, ["Mega|Ride"] = 155.64, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.59, ["Ride"] = 98.85, ["Fly|Ride"] = 190.95, ["Neon"] = 321.57, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 533.12, ["Mega"] = 940.74, ["Mega|Ride"] = 1355.69, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.35, ["Neon"] = 5.39, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 65.19, ["Mega"] = 65.52, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.94}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.58, ["Fly|Ride"] = 490.01, ["Neon"] = 6.55, ["Neon|Ride"] = 51.87, ["Neon|Fly|Ride"] = 121.99, ["Mega"] = 47.25, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.76, ["Ride"] = 162.92, ["Fly|Ride"] = 236.25, ["Neon"] = 701.36, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 795.99, ["Mega"] = 3364.78, ["Mega|Ride"] = 2520, ["Mega|Fly|Ride"] = 2660.27}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.31, ["Ride"] = 36.47, ["Fly|Ride"] = 210.31, ["Neon"] = 19.69, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 99.46, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 168.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.77, ["Neon"] = 3.94, ["Neon|Ride"] = 20.86, ["Mega"] = 31.4, ["Mega|Ride"] = 56.8, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 8.43, ["Fly"] = 39.38, ["Ride"] = 21.76, ["Fly|Ride"] = 49.88, ["Neon"] = 53.37, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 159.93, ["Mega"] = 406.93, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 625.65}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.68, ["Fly"] = 41.42, ["Ride"] = 17.92, ["Fly|Ride"] = 56.57, ["Neon"] = 72.17, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.8, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 398.61}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.1, ["Ride"] = 54.92, ["Fly|Ride"] = 196.64, ["Neon"] = 132.96, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 477.37, ["Mega"] = 560.44, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 104.99, ["Fly"] = 196.88, ["Ride"] = 161.44, ["Fly|Ride"] = 183.65, ["Neon"] = 565.13, ["Neon|Fly"] = 841.2, ["Neon|Ride"] = 590.51, ["Neon|Fly|Ride"] = 656.15, ["Mega|Fly|Ride"] = 2452.08}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.15, ["Fly"] = 18.38, ["Ride"] = 21.04, ["Fly|Ride"] = 43.67, ["Neon"] = 36.82, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.4, ["Fly"] = 131.23, ["Ride"] = 21.49, ["Fly|Ride"] = 131.24, ["Neon"] = 16.69, ["Neon|Ride"] = 32.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 137.76, ["Mega|Ride"] = 136.71, ["Mega|Fly|Ride"] = 318.65}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.66, ["Fly"] = 98.44, ["Ride"] = 29.03, ["Fly|Ride"] = 91.88, ["Neon"] = 48.54, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 67.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 392.44, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.08, ["Fly"] = 98.85, ["Ride"] = 68.03, ["Fly|Ride"] = 157.99, ["Neon"] = 202.13, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 224.89, ["Mega"] = 982.1, ["Mega|Ride"] = 911.66, ["Mega|Fly|Ride"] = 1002.05}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 31.5, ["Ride"] = 63.35, ["Neon"] = 105, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 463.73, ["Mega"] = 701.32, ["Mega|Ride"] = 573.34}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.77, ["Ride"] = 477.37, ["Neon|Ride"] = 3182.75, ["Mega|Fly|Ride"] = 5551.87}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.3, ["Fly"] = 35.07, ["Ride"] = 32.92, ["Fly|Ride"] = 65.63, ["Neon"] = 418.5, ["Neon|Ride"] = 158.03, ["Neon|Fly|Ride"] = 318.65, ["Mega"] = 761.25, ["Mega|Ride"] = 729.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.2, ["Ride"] = 13.69, ["Fly|Ride"] = 42.19, ["Neon"] = 2.1, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 20.6, ["Mega|Fly"] = 103.06, ["Mega|Ride"] = 37.7, ["Mega|Fly|Ride"] = 105.98}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.16, ["Neon"] = 8.88, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 140.91, ["Mega|Ride"] = 109.19, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.76, ["Ride"] = 32.82, ["Fly|Ride"] = 50.48, ["Neon"] = 19.56, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 83.07, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 121.68, ["Mega|Fly"] = 491.07, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 423.94, ["Fly"] = 491.07, ["Ride"] = 405.84, ["Fly|Ride"] = 463.73, ["Neon"] = 1524.67, ["Neon|Ride"] = 2068.5, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 5188.05}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.93, ["Fly"] = 31.5, ["Ride"] = 15.08, ["Fly|Ride"] = 61, ["Neon"] = 26.25, ["Neon|Ride"] = 47.76, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 183.54, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 567.73}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.04, ["Fly"] = 20, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 16.96, ["Neon|Fly"] = 32.61, ["Neon|Ride"] = 58.9, ["Neon|Fly|Ride"] = 87.27, ["Mega|Ride"] = 277.61, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.94, ["Fly"] = 32.81, ["Ride"] = 21.27, ["Fly|Ride"] = 78.75, ["Neon"] = 11.82, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 84, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 25.49, ["Fly"] = 46.56, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 314.41, ["Mega"] = 561.51, ["Mega|Ride"] = 546.79, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 52.58, ["Ride"] = 34.12, ["Fly|Ride"] = 49.77, ["Neon"] = 9.19, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1009.44}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.48, ["Fly"] = 65.6, ["Ride"] = 28.88, ["Fly|Ride"] = 91.77, ["Neon"] = 168.9, ["Neon|Ride"] = 109.75, ["Neon|Fly|Ride"] = 289.17, ["Mega|Ride"] = 771.81, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.85, ["Neon"] = 3.76, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 51.1, ["Mega|Ride"] = 119.89, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 10.42, ["Ride"] = 140.91, ["Neon"] = 50.79, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.48, ["Ride"] = 86.24, ["Neon"] = 84.96, ["Neon|Ride"] = 477.37, ["Mega"] = 310.21, ["Mega|Ride"] = 545.74, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 12.63, ["Fly"] = 26.01, ["Ride"] = 24.55, ["Fly|Ride"] = 48.36, ["Neon"] = 44.63, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 79.76, ["Mega"] = 560.9, ["Mega|Ride"] = 310.21, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 341.16, ["Fly"] = 590.75, ["Ride"] = 412.53, ["Fly|Ride"] = 429.09, ["Neon"] = 1642.41, ["Neon|Ride"] = 1743.52, ["Neon|Fly|Ride"] = 1636.14, ["Mega|Fly|Ride"] = 7430.88}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.54, ["Fly|Ride"] = 50.48, ["Neon"] = 15.65, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 32.28, ["Mega"] = 210.31, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 299.56}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.61, ["Fly"] = 112.52, ["Ride"] = 45.47, ["Fly|Ride"] = 131.25, ["Neon"] = 73.5, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 281.81, ["Mega"] = 351.21, ["Mega|Fly"] = 701.36, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 495.27}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 21, ["Ride"] = 71.51, ["Fly|Ride"] = 276.52, ["Neon"] = 98.73, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 347.82, ["Mega|Ride"] = 347.2, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 54.24, ["Fly"] = 146.86, ["Ride"] = 70.26, ["Fly|Ride"] = 196.88, ["Neon"] = 320.25, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 380.62, ["Mega"] = 2492.09, ["Mega|Ride"] = 1892.69, ["Mega|Fly|Ride"] = 1626.66}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.99, ["Fly"] = 105.16, ["Ride"] = 64.32, ["Fly|Ride"] = 131.25, ["Neon"] = 45.5, ["Neon|Ride"] = 103.59, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 191.63, ["Mega|Ride"] = 245.85, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 13.02, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.25, ["Ride"] = 56.44, ["Neon"] = 19.69, ["Neon|Ride"] = 104.11, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 88.34, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 42, ["Fly"] = 137.82, ["Ride"] = 65.44, ["Fly|Ride"] = 202.13, ["Neon"] = 108.31, ["Neon|Ride"] = 141, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 393.75, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 6.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 52.5, ["Mega|Fly"] = 159.93, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 25.27, ["Ride"] = 210.31, ["Fly|Ride"] = 175.62, ["Neon"] = 143.07, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 841.2, ["Mega"] = 516.99, ["Mega|Fly|Ride"] = 658.31}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1017.19, ["Fly"] = 1004.07, ["Ride"] = 1050, ["Fly|Ride"] = 1152.38, ["Neon|Ride"] = 3617.14, ["Neon|Fly|Ride"] = 3281.23, ["Mega|Fly|Ride"] = 10235.19}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.13, ["Fly"] = 53.65, ["Ride"] = 56.79, ["Fly|Ride"] = 140.91, ["Neon"] = 54.7, ["Neon|Fly"] = 700.31, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 419.55, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.63, ["Fly"] = 49.37, ["Ride"] = 21.21, ["Fly|Ride"] = 83.44, ["Neon"] = 14.21, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 70.74, ["Mega|Ride"] = 89.55, ["Mega|Fly|Ride"] = 167.9}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.49, ["Ride"] = 56.8, ["Fly|Ride"] = 140.91, ["Neon"] = 55.37, ["Neon|Fly"] = 83.08, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 236.25, ["Mega|Ride"] = 411.71, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 35.81, ["Fly|Ride"] = 61, ["Neon"] = 2.1, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 23.88, ["Neon|Fly|Ride"] = 91.49, ["Mega"] = 15.93, ["Mega|Ride"] = 38.18, ["Mega|Fly|Ride"] = 176.54}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 48.57, ["Ride"] = 96.87, ["Fly|Ride"] = 236.23, ["Neon"] = 229.59, ["Neon|Ride"] = 287.25, ["Neon|Fly|Ride"] = 378.55, ["Mega"] = 918.75, ["Mega|Ride"] = 1038.52, ["Mega|Fly|Ride"] = 913.14}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.58, ["Ride"] = 62.91, ["Fly|Ride"] = 277.95, ["Neon"] = 83.91, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 561.51, ["Mega|Ride"] = 491.07, ["Mega|Fly|Ride"] = 628.81}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 7.87, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 463.73}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 39.37, ["Fly"] = 52.5, ["Ride"] = 42.95, ["Fly|Ride"] = 111.47, ["Neon"] = 50.95, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 1039.49, ["Mega|Ride"] = 399.58, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 4.23, ["Fly"] = 32.61, ["Ride"] = 31.49, ["Fly|Ride"] = 79.97, ["Neon"] = 109.73, ["Neon|Ride"] = 77.82, ["Neon|Fly|Ride"] = 123.94, ["Mega"] = 420.6, ["Mega|Ride"] = 525.75, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 33.27, ["Ride"] = 208.69, ["Neon"] = 163, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2102.99, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1682.4}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.7, ["Ride"] = 48.28, ["Neon"] = 22.68, ["Neon|Ride"] = 84.62, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 112.52, ["Mega|Ride"] = 98.85, ["Mega|Fly|Ride"] = 225.74}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 14.42, ["Ride"] = 20.01, ["Fly|Ride"] = 89.25, ["Neon"] = 73.62, ["Neon|Fly"] = 182.97, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 116.72, ["Mega"] = 295.32, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 672.97}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 101.24, ["Fly"] = 208.21, ["Ride"] = 167.61, ["Fly|Ride"] = 264.47, ["Neon"] = 441, ["Neon|Ride"] = 452.23, ["Neon|Fly|Ride"] = 685.58, ["Mega|Ride"] = 2664.47, ["Mega|Fly|Ride"] = 1945.79}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.56, ["Ride"] = 14.83, ["Fly|Ride"] = 55.13, ["Neon"] = 11.12, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 31.56, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 196.54, ["Mega|Ride"] = 224.95, ["Mega|Fly|Ride"] = 206.28}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 14.78, ["Fly"] = 201.42, ["Ride"] = 39.38, ["Fly|Ride"] = 105, ["Neon"] = 82.25, ["Neon|Ride"] = 101.82, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.82, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 522.47}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 15.8, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 15.14, ["Neon|Fly|Ride"] = 39.62, ["Mega"] = 15.63, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.8, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 130.39, ["Mega"] = 22.32, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.81}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.19, ["Fly"] = 35.77, ["Ride"] = 23.64, ["Fly|Ride"] = 133.88, ["Neon"] = 12.51, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 85.32, ["Mega|Ride"] = 267.09, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.19, ["Ride"] = 54.7, ["Fly|Ride"] = 131.25, ["Neon"] = 181.73, ["Neon|Ride"] = 336.49, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 715.03}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 5.25, ["Fly"] = 20, ["Ride"] = 15.64, ["Fly|Ride"] = 36.82, ["Neon"] = 11.69, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 55.18, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 124.09, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.04, ["Fly"] = 29.89, ["Ride"] = 24.69, ["Fly|Ride"] = 86.5, ["Neon"] = 28.58, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 38.84, ["Neon|Fly|Ride"] = 112.25, ["Mega"] = 229.48, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 302.82}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.36, ["Ride"] = 18.09, ["Fly|Ride"] = 71.52, ["Neon"] = 8.87, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 25.25, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 77.82, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 126.73}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.35, ["Fly"] = 158.8, ["Ride"] = 23, ["Fly|Ride"] = 217.2, ["Neon"] = 37.29, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 377.5, ["Mega|Fly|Ride"] = 439.18}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.92, ["Ride"] = 36.02, ["Neon"] = 65.63, ["Neon|Ride"] = 262.4, ["Mega"] = 392.44, ["Mega|Fly|Ride"] = 982.1}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.23, ["Fly"] = 19.69, ["Ride"] = 16.74, ["Fly|Ride"] = 49.01, ["Neon"] = 27.61, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 262.49, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 491.07}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.63, ["Fly"] = 24.75, ["Ride"] = 14.25, ["Fly|Ride"] = 52.45, ["Neon"] = 16.78, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 184.02, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 279.71}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 178.5, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1051.5, ["Neon|Ride"] = 1121.96, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4137.61}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.92, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.56, ["Fly"] = 104.9, ["Ride"] = 22.46, ["Fly|Ride"] = 84.14, ["Neon"] = 23.39, ["Neon|Fly"] = 238.71, ["Neon|Ride"] = 58.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 207.69, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 486.85}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.33, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 222.93, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.54, ["Mega|Ride"] = 378.55, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.16, ["Ride"] = 15.08, ["Fly|Ride"] = 32.34, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 77.82, ["Mega|Ride"] = 40.85, ["Mega|Fly|Ride"] = 88.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 8.4, ["Fly"] = 26.24, ["Ride"] = 16.51, ["Fly|Ride"] = 42.08, ["Neon"] = 13.95, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 100, ["Mega"] = 116.85, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.42, ["Ride"] = 140.91, ["Neon"] = 8.55, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 84.14, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.47, ["Fly"] = 105, ["Ride"] = 99.65, ["Fly|Ride"] = 168, ["Neon"] = 381.89, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 467.93, ["Mega|Ride"] = 3506.72, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.69, ["Fly"] = 94.5, ["Ride"] = 26.23, ["Fly|Ride"] = 98.85, ["Neon"] = 23.12, ["Neon|Ride"] = 64.26, ["Mega"] = 167.99, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 357.53}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.37, ["Fly"] = 21, ["Ride"] = 32.75, ["Neon"] = 5.07, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 535.75, ["Mega"] = 63.59, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 185.08, ["Neon"] = 144.38, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 584.07, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 13.13, ["Fly|Ride"] = 32.04, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 19.57, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 112.2}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 105.16, ["Neon"] = 3.29, ["Neon|Ride"] = 41.65, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 24.94, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 176.05}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.38, ["Ride"] = 45.36, ["Neon"] = 10.12, ["Neon|Fly"] = 51.19, ["Neon|Ride"] = 61.89, ["Neon|Fly|Ride"] = 135.98, ["Mega"] = 64.32, ["Mega|Fly"] = 182.97, ["Mega|Ride"] = 139.01, ["Mega|Fly|Ride"] = 202.35}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.04, ["Fly"] = 79.93, ["Ride"] = 50.18, ["Fly|Ride"] = 128.33, ["Neon"] = 18.95, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 103.58, ["Mega|Fly"] = 342.51, ["Mega|Ride"] = 171.39, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 14.1, ["Fly|Ride"] = 42.08, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 17.92, ["Neon|Fly|Ride"] = 44.35, ["Mega"] = 18.17, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 78.4}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.77, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Fly|Ride"] = 105.16, ["Neon"] = 70.47, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 499.47, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 732.75}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2519.37, ["Fly"] = 3150, ["Ride"] = 2231.24, ["Fly|Ride"] = 2462.25, ["Neon"] = 10514.88, ["Neon|Fly|Ride"] = 9394.01, ["Mega|Fly|Ride"] = 42058.46}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.65, ["Fly|Ride"] = 42.08, ["Neon"] = 9, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 78.2, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 93.55, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 88.33, ["Neon"] = 8.17, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.84, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.01, ["Fly"] = 42.08, ["Ride"] = 25.09, ["Fly|Ride"] = 119.36, ["Neon"] = 73.47, ["Neon|Ride"] = 118.84, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 446.25, ["Mega|Ride"] = 392.74, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.17, ["Fly"] = 90.44, ["Ride"] = 60.67, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 400.52, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 207.66, ["Fly"] = 210.31, ["Ride"] = 148.36, ["Fly|Ride"] = 251.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 6308.94, ["Mega|Fly|Ride"] = 3660.09}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.56, ["Ride"] = 32.61, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 83.68, ["Neon|Fly|Ride"] = 155.15, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 223.18, ["Mega|Fly|Ride"] = 357.53}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.25, ["Ride"] = 35.44, ["Neon"] = 26.24, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.49, ["Fly"] = 144.38, ["Ride"] = 26.24, ["Fly|Ride"] = 131.25, ["Neon"] = 6.39, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 40.04, ["Mega"] = 60.38, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.54, ["Ride"] = 84.14, ["Neon"] = 98.44, ["Neon|Ride"] = 172.47, ["Neon|Fly|Ride"] = 495.27, ["Mega"] = 381.89, ["Mega|Ride"] = 463.73, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.08, ["Neon"] = 2.1, ["Neon|Ride"] = 33.67, ["Mega"] = 18.95, ["Mega|Fly"] = 119.36, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.25, ["Fly"] = 104.11, ["Ride"] = 104.9, ["Fly|Ride"] = 140.91, ["Neon"] = 301.46, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 399.58, ["Neon|Fly|Ride"] = 330.88, ["Mega"] = 3154.48, ["Mega|Fly|Ride"] = 1676.09}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 91.83, ["Neon"] = 3.94, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 59.07, ["Mega|Ride"] = 279.71, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 37.3, ["Fly"] = 100.95, ["Ride"] = 62.98, ["Fly|Ride"] = 183.75, ["Neon"] = 243.14, ["Neon|Ride"] = 242.91, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 3575.07}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 21.06, ["Fly|Ride"] = 51.32, ["Neon"] = 3.56, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.51, ["Fly|Ride"] = 104.01, ["Neon"] = 11.7, ["Neon|Ride"] = 98.44, ["Mega"] = 106.32, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 520.41}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.63, ["Fly"] = 77.43, ["Ride"] = 32.24, ["Neon"] = 28.41, ["Neon|Ride"] = 86.52, ["Mega"] = 315, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 559.41}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 359.63, ["Ride"] = 402.94, ["Fly|Ride"] = 499.38, ["Neon"] = 946.74, ["Neon|Ride"] = 964.68, ["Neon|Fly|Ride"] = 1076.25, ["Mega|Ride"] = 2802.09, ["Mega|Fly|Ride"] = 3330.08}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 24.84, ["Fly"] = 56.8, ["Ride"] = 45.45, ["Fly|Ride"] = 126.93, ["Neon"] = 161.44, ["Neon|Ride"] = 209.26, ["Neon|Fly|Ride"] = 314.3, ["Mega"] = 1400.6, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1682.4}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.56, ["Fly|Ride"] = 84.14, ["Neon"] = 12.49, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 97.55, ["Mega"] = 128.24, ["Mega|Ride"] = 196.64, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.83, ["Fly"] = 39.29, ["Ride"] = 47.25, ["Fly|Ride"] = 140.91, ["Neon"] = 69.47, ["Neon|Fly"] = 159.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 183.74, ["Mega"] = 248.07, ["Mega|Fly"] = 982.16, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 11.58, ["Ride"] = 25.87, ["Neon"] = 101.35, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 420.6, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Ride"] = 52.5, ["Neon"] = 20.48, ["Mega"] = 90.37, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 308.11}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 8.43, ["Fly"] = 86.63, ["Ride"] = 20.74, ["Fly|Ride"] = 58.7, ["Neon"] = 32.05, ["Neon|Ride"] = 50.16, ["Mega"] = 111.57, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 92.15, ["Ride"] = 129.94, ["Fly|Ride"] = 175.63, ["Neon"] = 788.63, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3501.39, ["Mega|Fly|Ride"] = 3154.48}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.62, ["Ride"] = 38.58, ["Fly|Ride"] = 91.88, ["Neon"] = 105, ["Neon|Ride"] = 225.04, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 539.34, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2058.97, ["Ride"] = 2060.63, ["Fly|Ride"] = 2155.04, ["Neon"] = 11216.23, ["Neon|Fly|Ride"] = 6954.94, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.4, ["Fly"] = 65625, ["Ride"] = 56.8, ["Fly|Ride"] = 196.87, ["Neon"] = 14.23, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 630.91, ["Mega"] = 115.5, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.63, ["Ride"] = 36.28, ["Fly|Ride"] = 127.71, ["Neon"] = 29.08, ["Neon|Fly"] = 57.69, ["Neon|Ride"] = 90.57, ["Mega"] = 138.37, ["Mega|Ride"] = 318.65, ["Mega|Fly|Ride"] = 406.93}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1023.75, ["Fly"] = 1107.73, ["Ride"] = 822.93, ["Fly|Ride"] = 866.23, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 13874.39, ["Mega|Fly|Ride"] = 11170.02}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 28.6, ["Ride"] = 49.79, ["Fly|Ride"] = 173.35, ["Neon"] = 182.97, ["Neon|Ride"] = 152.77, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 840.96, ["Mega|Ride"] = 616.19, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.44, ["Fly|Ride"] = 124.09, ["Neon"] = 6.54, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 313.36, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 140.91, ["Neon"] = 3.87, ["Neon|Ride"] = 48.93, ["Neon|Fly|Ride"] = 100.26, ["Mega"] = 19.03, ["Mega|Ride"] = 77.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.34, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 420.6, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 630.91, ["Mega"] = 2386.77, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.89, ["Ride"] = 36.26, ["Fly|Ride"] = 74.03, ["Neon"] = 11.75, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 107.63, ["Mega|Ride"] = 120.94, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.61, ["Fly"] = 98.85, ["Ride"] = 126, ["Fly|Ride"] = 238.71, ["Neon"] = 459.38, ["Neon|Ride"] = 419.55, ["Mega|Fly|Ride"] = 1682.4}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.49, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.24, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 315, ["Mega"] = 299.15, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.94, ["Fly"] = 354.38, ["Ride"] = 286.89, ["Fly|Ride"] = 322.01, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 9.18, ["Fly"] = 91.88, ["Ride"] = 16.58, ["Fly|Ride"] = 48.57, ["Neon"] = 28.41, ["Neon|Ride"] = 57.65, ["Neon|Fly|Ride"] = 112.2, ["Mega"] = 321.47, ["Mega|Ride"] = 318.94, ["Mega|Fly|Ride"] = 683.48}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.37, ["Ride"] = 15.65, ["Fly|Ride"] = 36.75, ["Neon"] = 3.86, ["Neon|Fly"] = 37.87, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 54.7, ["Mega"] = 40.69, ["Mega|Ride"] = 63.1, ["Mega|Fly|Ride"] = 122.51}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1255.5, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7711.62, ["Neon|Fly|Ride"] = 6589.69, ["Mega"] = 23390.2, ["Mega|Fly|Ride"] = 28040.03}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 12.79, ["Fly"] = 168.25, ["Ride"] = 72.19, ["Neon"] = 57.75, ["Neon|Ride"] = 311.76, ["Mega"] = 244.59, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.88, ["Fly"] = 28.88, ["Ride"] = 45.23, ["Fly|Ride"] = 100.17, ["Neon"] = 19.69, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 163.25, ["Mega|Ride"] = 250.26, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 31.8, ["Fly"] = 33.95, ["Ride"] = 32.37, ["Fly|Ride"] = 75.7, ["Neon"] = 420.6, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 2523.59, ["Mega|Ride"] = 1114.63, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 16.85, ["Fly"] = 90.44, ["Ride"] = 27.57, ["Fly|Ride"] = 78.75, ["Neon"] = 57.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 224.98, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.24, ["Ride"] = 99.9, ["Fly|Ride"] = 410.1, ["Neon"] = 194.25, ["Neon|Ride"] = 310.21, ["Neon|Fly|Ride"] = 533.12, ["Mega"] = 841.2, ["Mega|Ride"] = 831.75, ["Mega|Fly|Ride"] = 798.1}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 280.76, ["Neon"] = 2.46, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 105.07, ["Mega"] = 17.07, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 92.3, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 78.63, ["Fly"] = 126.19, ["Ride"] = 90.57, ["Fly|Ride"] = 178.36, ["Neon"] = 446.24, ["Neon|Fly"] = 663.51, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 486.94, ["Mega"] = 3364.78, ["Mega|Fly|Ride"] = 1666.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 6.33, ["Fly"] = 107.62, ["Ride"] = 24.94, ["Fly|Ride"] = 67.37, ["Neon"] = 84.14, ["Neon|Ride"] = 95.49, ["Neon|Fly|Ride"] = 168.25, ["Mega"] = 773.07, ["Mega|Ride"] = 429.62, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 18.38, ["Fly|Ride"] = 38.16, ["Neon"] = 19.59, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.75, ["Neon|Fly"] = 138.81, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 199.8, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 51.23, ["Ride"] = 190.95, ["Fly|Ride"] = 301.88, ["Neon"] = 328.12, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 727.12, ["Mega"] = 1682.4, ["Mega|Ride"] = 1444.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.62, ["Fly|Ride"] = 420.6, ["Neon"] = 18.57, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 277.52}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 36.66, ["Neon"] = 2.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 16.86, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 35.6, ["Fly|Ride"] = 140.91, ["Neon"] = 2.1, ["Neon|Ride"] = 23.05, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 18.32, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 15.94, ["Fly|Ride"] = 49.43, ["Neon"] = 6.08, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.45}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.52, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 10.07, ["Neon|Fly"] = 210.2, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.63, ["Mega|Ride"] = 159.93, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.46, ["Ride"] = 101.72, ["Fly|Ride"] = 276.55, ["Neon"] = 210.31, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1051.5, ["Mega"] = 695.63, ["Mega|Ride"] = 756.97, ["Mega|Fly|Ride"] = 1121.96}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 14.74, ["Ride"] = 15.74, ["Fly|Ride"] = 40.49, ["Neon"] = 3.94, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 42.17, ["Mega"] = 31.4, ["Mega|Ride"] = 118.16, ["Mega|Fly|Ride"] = 79.97}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.59, ["Fly"] = 78.87, ["Ride"] = 30.73, ["Fly|Ride"] = 90.44, ["Neon"] = 31.4, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.95, ["Mega"] = 300.57, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.94, ["Fly"] = 56.8, ["Ride"] = 40.59, ["Fly|Ride"] = 105, ["Neon"] = 139.13, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 136.54, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 787.5, ["Mega|Ride"] = 769.71, ["Mega|Fly|Ride"] = 576.21}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 4.72, ["Fly"] = 196.88, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.07, ["Fly|Ride"] = 32.82, ["Neon"] = 3.92, ["Neon|Fly"] = 24.2, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 34.13, ["Mega|Ride"] = 53.8, ["Mega|Fly|Ride"] = 108.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.12, ["Fly"] = 77.82, ["Ride"] = 37.97, ["Fly|Ride"] = 51.64, ["Neon"] = 24.98, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 112.52, ["Mega"] = 164.07, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 263.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1353.31, ["Ride"] = 1018.5, ["Fly|Ride"] = 1056.57, ["Neon"] = 2839.04, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2445.19, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 133.7, ["Ride"] = 225.04, ["Fly|Ride"] = 630.91, ["Neon"] = 587.79, ["Neon|Ride"] = 588.84, ["Neon|Fly|Ride"] = 892.49, ["Mega"] = 3153.43, ["Mega|Ride"] = 3502.52, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.8, ["Fly|Ride"] = 392.44, ["Neon"] = 13.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 204.01, ["Mega"] = 78.4, ["Mega|Fly|Ride"] = 1121.96}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 84, ["Ride"] = 168.16, ["Fly|Ride"] = 262.49, ["Neon"] = 392.44, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 682.17, ["Mega"] = 1964.19, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1767.05}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.56, ["Ride"] = 21.05, ["Neon"] = 17.53, ["Neon|Fly"] = 56.11, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 118.13, ["Mega|Ride"] = 353.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 259.1, ["Fly"] = 330.19, ["Ride"] = 248.06, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1353.28, ["Neon|Fly|Ride"] = 1273.35, ["Mega|Fly|Ride"] = 4738.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.63, ["Fly"] = 77.18, ["Ride"] = 41.03, ["Fly|Ride"] = 213.99, ["Neon"] = 31.5, ["Neon|Fly"] = 49.43, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 328.08, ["Mega|Ride"] = 561.51}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 18.95, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 23.56, ["Ride"] = 61.07, ["Fly|Ride"] = 151.57, ["Neon"] = 115.4, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 116.52, ["Mega"] = 450.06, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 859.24}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.74, ["Fly|Ride"] = 280.76, ["Neon"] = 21.05, ["Neon|Ride"] = 196.87, ["Mega"] = 217.22, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 12.63, ["Fly|Ride"] = 28.41, ["Neon"] = 2.49, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 17.92, ["Neon|Fly|Ride"] = 35, ["Mega"] = 24.5, ["Mega|Ride"] = 48.75, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5263.13, ["Ride"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon"] = 31544.63, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 159117.75}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.33, ["Fly"] = 84.14, ["Ride"] = 56.43, ["Neon"] = 53.44, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 192.94, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 403.78}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.93, ["Fly|Ride"] = 42, ["Neon"] = 12.91, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 175.62, ["Mega|Fly|Ride"] = 180.86}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 435.64, ["Fly"] = 547.77, ["Ride"] = 454.78, ["Fly|Ride"] = 536.46, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1262.8, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.06, ["Ride"] = 33.5, ["Neon"] = 22.31, ["Neon|Ride"] = 291.38, ["Mega"] = 187.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.56, ["Fly"] = 4204.91, ["Ride"] = 36.74, ["Neon"] = 37.01, ["Neon|Fly"] = 116.72, ["Neon|Ride"] = 51.33, ["Neon|Fly|Ride"] = 301.79, ["Mega"] = 419.55, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.07}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 17.64, ["Neon"] = 3.71, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 17.1, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 40.69, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Fly"] = 853.82, ["Ride"] = 735, ["Fly|Ride"] = 677.25, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2383.74, ["Mega|Fly|Ride"] = 9113.25}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.73, ["Fly"] = 131.25, ["Ride"] = 57.5, ["Fly|Ride"] = 420.6, ["Neon"] = 34.64, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 143.21, ["Mega"] = 191.63, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.24, ["Fly"] = 236.25, ["Ride"] = 41.91, ["Fly|Ride"] = 76.56, ["Neon"] = 27.2, ["Neon|Ride"] = 59.01, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 420.6, ["Mega|Fly"] = 795.99, ["Mega|Ride"] = 248.46, ["Mega|Fly|Ride"] = 270.39}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.62, ["Fly"] = 34.12, ["Ride"] = 15.91, ["Fly|Ride"] = 58.9, ["Neon"] = 13.55, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 79.99, ["Mega"] = 183.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 228.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.69, ["Ride"] = 34.12, ["Fly|Ride"] = 55.6, ["Neon"] = 117.58, ["Neon|Fly|Ride"] = 315.46, ["Mega"] = 840.15, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 542.59}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 420.6, ["Neon"] = 6.46, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 34.12, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 525, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9308.36, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 105.16, ["Ride"] = 80.07, ["Neon"] = 15.23, ["Neon|Ride"] = 77.38, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 90.44, ["Mega|Ride"] = 218.72, ["Mega|Fly|Ride"] = 334.16}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.67, ["Neon"] = 4.51, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 214.81, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 41.03, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 42.08, ["Neon"] = 3.94, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 45.23, ["Mega|Fly"] = 155.64, ["Mega|Ride"] = 116.45, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 26.25, ["Neon"] = 13.13, ["Neon|Ride"] = 48.18, ["Mega"] = 210.31, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.25, ["Fly"] = 64.32, ["Ride"] = 51.19, ["Fly|Ride"] = 105, ["Neon"] = 103.68, ["Neon|Fly"] = 210.31, ["Neon|Ride"] = 149.63, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 596.71, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 541.58}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.78, ["Fly"] = 39.38, ["Ride"] = 67.94, ["Fly|Ride"] = 98.85, ["Neon"] = 74.05, ["Neon|Ride"] = 129.49, ["Neon|Fly|Ride"] = 262.29, ["Mega"] = 381.84, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.71, ["Ride"] = 15.64, ["Fly|Ride"] = 32.47, ["Neon"] = 22.6, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 87.29, ["Mega"] = 226.75, ["Mega|Ride"] = 356.48, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.69, ["Ride"] = 56.04, ["Fly|Ride"] = 132.5, ["Neon"] = 28.41, ["Neon|Ride"] = 140.91, ["Mega|Ride"] = 730.8}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Fly|Ride"] = 87.18, ["Neon"] = 9.44, ["Neon|Ride"] = 56.22, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 64.32, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.64, ["Fly"] = 112.2, ["Ride"] = 26.25, ["Fly|Ride"] = 42.97, ["Neon"] = 109.15, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 828.58}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 56.79, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 39.52, ["Fly"] = 153.58, ["Ride"] = 81.37, ["Fly|Ride"] = 132.5, ["Neon"] = 322.83, ["Neon|Ride"] = 325.59, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1687.46, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 39.38, ["Fly"] = 85.44, ["Ride"] = 76.73, ["Fly|Ride"] = 131.24, ["Neon"] = 182.97, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 535.5, ["Mega|Ride"] = 667.71, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 26.25, ["Ride"] = 56.8, ["Neon"] = 103.69, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 795.99, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.25, ["Fly"] = 81.73, ["Ride"] = 70.87, ["Fly|Ride"] = 193.49, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 238.71, ["Mega"] = 469.06, ["Mega|Ride"] = 565.26, ["Mega|Fly|Ride"] = 646.64}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.92, ["Ride"] = 14.42, ["Fly|Ride"] = 32.73, ["Neon"] = 3.92, ["Neon|Fly"] = 27.07, ["Neon|Ride"] = 31.04, ["Neon|Fly|Ride"] = 53.65, ["Mega"] = 38.03, ["Mega|Fly"] = 318.65, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.5, ["Fly"] = 477.37, ["Ride"] = 97.46, ["Fly|Ride"] = 157.5, ["Neon"] = 350.38, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 553.09, ["Mega"] = 1255.5, ["Mega|Ride"] = 1491.03, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.75, ["Neon"] = 2.1, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 294.44, ["Mega"] = 27.56, ["Mega|Ride"] = 79.93, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 19.38, ["Ride"] = 61, ["Fly|Ride"] = 142.65, ["Neon"] = 118.13, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.94, ["Mega|Ride"] = 493.4, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Mega"] = 26.16}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Mega"] = 22.32, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.77, ["Fly"] = 223.13, ["Ride"] = 145.69, ["Fly|Ride"] = 360.42, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 603.57, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 2098.42}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 95.49, ["Neon"] = 7.8, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Fly|Ride"] = 51.66, ["Neon"] = 2.63, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 30.75, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.16, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 231.55, ["Mega"] = 78.75, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 477.37}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.88, ["Neon"] = 6.29, ["Neon|Ride"] = 155.92, ["Mega"] = 65.54, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 73.5, ["Ride"] = 129.94, ["Fly|Ride"] = 477.37, ["Neon"] = 428.35, ["Neon|Ride"] = 561.51, ["Neon|Fly|Ride"] = 637.28, ["Mega"] = 1964.19, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.38, ["Ride"] = 73.7, ["Neon"] = 68.25, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 954.72, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.75, ["Ride"] = 377.5, ["Fly|Ride"] = 510.78, ["Neon"] = 1706.25, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 90.57}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.85}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 140.91}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.79}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.17}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.15}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 183.74}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 11.86}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.73}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.5}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.43}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.29}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.23}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.13}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.49}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.63}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 565.48}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.45}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1299.38}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.08}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.69}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.36}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.01}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.93}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.38}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.47}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.56}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.92}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.6}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.23}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.04}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2874.78}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 33.65}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.93}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.42}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.52}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.76}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 112.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.62}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 12.25}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 238.71}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 33.05}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 29.3}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 31.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.93}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 35.1}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.79}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.68}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.62}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.32}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.73}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 30.19}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.62}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.92}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.87}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 16.7}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22731.47}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.92}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.74}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 27.03}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 77.44}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 200.33}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 36.66}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.93}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.55}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 12.9}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.83}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.49}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 108.65}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.19}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 5.25}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 13.09}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.45}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 15.79}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.46}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 19.67}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 16.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 27.2}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.62}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 13.13}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.72}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.94}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.94}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.81}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.62}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.26}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 176.81}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 196.64}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 11.67}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.78}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.01}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 39.39}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.24}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.56}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.03}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.39}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 76.27}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.41}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.9}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 7.96}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 4.99}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 7.17}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 4.23}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.42}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.75}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8433.47}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 33.66}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.97}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 9.08}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.23}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 33.49}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 13.02}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.13}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 8.4}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 39.36}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.31}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 104.99}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.88}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4415.51}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.42}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.11}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.6}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.6}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.79}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.15}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 99.75}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.74}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.92}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.66}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.46}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.54}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.3}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.8}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.81}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.88}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.34}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.13}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 78.58}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.65}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.23}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.43}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.89}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 26.22}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.54}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 4.23}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.75}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.32}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.17}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.36}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 13.59}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.5}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 16.04}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.79}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.33}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.62}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.62}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 8.42}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 9.89}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.18}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.68}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.56}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.07}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.92}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 82.02}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 37.2}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 18.95}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.14}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 79.42}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 139.34}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.15}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1154.76}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 177.19}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.12}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.34}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 12.91}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.57}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.26}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.25}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.06}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 3.94}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.82}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.32}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.48}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.51}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.36}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.79}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.59}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.48}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 32.45}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.69}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.82}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 81.38}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.78}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.19}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 49.86}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.15}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.14}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.59}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 371.23}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.8}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.18}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.21}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.92}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.75}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.42}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.03}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 8.33}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.73}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 12.99}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.24}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 35.32}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 85.2}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 27.35}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 40.03}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.17}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 39.97}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.68}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.16}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.65}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 328.13}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.83}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.86}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.27}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.43}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 56.89}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.17}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.31}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 188.99}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.47}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.25}},
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