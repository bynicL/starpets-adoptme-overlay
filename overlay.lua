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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1139.2, ["Ride"] = 1050, ["Fly|Ride"] = 1682.4, ["Neon"] = 6684.27, ["Neon|Fly|Ride"] = 5118.75, ["Mega|Fly|Ride"] = 20504.03}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.74, ["Fly"] = 637.42, ["Ride"] = 498.36, ["Fly|Ride"] = 538.13, ["Neon"] = 2076.71, ["Neon|Fly|Ride"] = 2018.88, ["Mega"] = 11936.17, ["Mega|Fly|Ride"] = 6960.86}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6015.43, ["Ride"] = 5250, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 70099.53}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.49, ["Ride"] = 210.31, ["Fly|Ride"] = 213.12, ["Neon"] = 982.1, ["Neon|Ride"] = 967.39, ["Neon|Fly|Ride"] = 1024.16, ["Mega|Fly|Ride"] = 4205.96}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 841.2, ["Ride"] = 505.31, ["Fly|Ride"] = 565.1, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6449.84}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.02, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 70.47, ["Neon|Fly"] = 280.76, ["Neon|Ride"] = 84.14, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 347.01, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 2.62, ["Fly"] = 49.86, ["Ride"] = 26.17, ["Fly|Ride"] = 64.97, ["Neon"] = 31.38, ["Neon|Fly"] = 99.75, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 113.57, ["Mega"] = 161.94, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 168.25, ["Mega|Fly|Ride"] = 294.44}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 110.99, ["Ride"] = 105, ["Neon"] = 561.51, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2741.24}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.48, ["Fly"] = 97.13, ["Ride"] = 41.44, ["Fly|Ride"] = 99.75, ["Neon"] = 257.62, ["Neon|Ride"] = 182.97, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 1402.7, ["Mega|Ride"] = 1114.86, ["Mega|Fly|Ride"] = 918.73}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.9, ["Fly"] = 56.8, ["Ride"] = 27.44, ["Fly|Ride"] = 70.47, ["Neon"] = 207.69, ["Neon|Ride"] = 120.94, ["Neon|Fly|Ride"] = 182.97, ["Mega|Ride"] = 420.56, ["Mega|Fly|Ride"] = 701.32}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.48, ["Fly"] = 126.19, ["Ride"] = 84.48, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 425.25, ["Mega"] = 1248.13, ["Mega|Fly|Ride"] = 1261.8}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 73.39}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 350.49, ["Fly"] = 399, ["Ride"] = 325.5, ["Fly|Ride"] = 378.89, ["Neon"] = 1253.39, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 5046.11}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 137.81, ["Ride"] = 111.57, ["Fly|Ride"] = 164.07, ["Neon|Fly"] = 689.79, ["Neon|Ride"] = 573.57, ["Neon|Fly|Ride"] = 578.33, ["Mega|Fly|Ride"] = 3064.03}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 34.13, ["Ride"] = 56.7, ["Fly|Ride"] = 131.25, ["Neon"] = 23.35, ["Neon|Ride"] = 47.76, ["Mega"] = 146.93, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 238.74}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.88, ["Fly"] = 223.13, ["Ride"] = 177.19, ["Fly|Ride"] = 213.94, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 692.9, ["Mega|Fly|Ride"] = 2992.4}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.39, ["Fly"] = 25.32, ["Ride"] = 20, ["Fly|Ride"] = 37.87, ["Neon"] = 30.51, ["Neon|Fly"] = 126.19, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 205.06, ["Mega|Fly"] = 358.11, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 405.85}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.53, ["Fly"] = 159.95, ["Ride"] = 123.44, ["Fly|Ride"] = 232.39, ["Neon"] = 236.25, ["Neon|Ride"] = 380.76, ["Neon|Fly|Ride"] = 426.16, ["Mega"] = 1682.4, ["Mega|Ride"] = 1419.78, ["Mega|Fly|Ride"] = 1359.26}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.5}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 232.32, ["Fly|Ride"] = 262.88, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 2102.99, ["Mega|Fly|Ride"] = 1964.19}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.07, ["Fly"] = 54.7, ["Ride"] = 32.48, ["Fly|Ride"] = 315.46, ["Neon"] = 318.72, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2745.33, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.73, ["Fly"] = 127.32, ["Ride"] = 51.1, ["Fly|Ride"] = 103.58, ["Neon"] = 303.19, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 249.37, ["Mega"] = 1671.08, ["Mega|Ride"] = 1009.44, ["Mega|Fly|Ride"] = 937.25}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.26, ["Ride"] = 111.56, ["Fly|Ride"] = 262.88, ["Neon"] = 140.91, ["Neon|Fly"] = 396.3, ["Neon|Ride"] = 380.72, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1273.61}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.19, ["Ride"] = 33.42, ["Fly|Ride"] = 83.91, ["Neon"] = 120.65, ["Neon|Ride"] = 209.26, ["Neon|Fly|Ride"] = 251.32, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 136.71, ["Ride"] = 54.86, ["Fly|Ride"] = 177.63, ["Neon"] = 174.28, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.18, ["Fly"] = 26.93, ["Ride"] = 23.37, ["Fly|Ride"] = 47.75, ["Neon"] = 31.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 87.28, ["Mega"] = 170.63, ["Mega|Fly"] = 27000.57, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 420, ["Fly|Ride"] = 510.57, ["Neon"] = 2102.99, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 7430.88}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.69, ["Ride"] = 27.57, ["Fly|Ride"] = 122.85, ["Neon"] = 214.81, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 252.37, ["Mega|Ride"] = 799.15, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.6, ["Fly"] = 37.21, ["Ride"] = 21.4, ["Fly|Ride"] = 46.69, ["Neon"] = 52.47, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 125.98, ["Mega|Ride"] = 393.27, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 75.6, ["Fly"] = 119.34, ["Ride"] = 96.08, ["Fly|Ride"] = 124.69, ["Neon"] = 374.35, ["Neon|Fly"] = 322.83, ["Neon|Ride"] = 372.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 6324.99, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.61, ["Ride"] = 32.23, ["Fly|Ride"] = 75.22, ["Neon"] = 91.67, ["Neon|Ride"] = 112.21, ["Neon|Fly|Ride"] = 201.21, ["Mega"] = 701.36, ["Mega|Ride"] = 716.19}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 203.44, ["Fly"] = 262.5, ["Ride"] = 205.64, ["Fly|Ride"] = 288.75, ["Neon"] = 780.65, ["Neon|Ride"] = 692.36, ["Neon|Fly|Ride"] = 688.45, ["Mega"] = 6308.94, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.52, ["Fly"] = 32.81, ["Ride"] = 21.05, ["Fly|Ride"] = 55.13, ["Neon"] = 25.8, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Fly"] = 477.47, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 818.61, ["Fly"] = 2625, ["Ride"] = 890.7, ["Fly|Ride"] = 918.75, ["Neon"] = 2944.18, ["Neon|Ride"] = 4767.46, ["Neon|Fly|Ride"] = 4697.01, ["Mega|Ride"] = 53712.73, ["Mega|Fly|Ride"] = 16823.82}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.55, ["Fly"] = 49.41, ["Ride"] = 37.94, ["Fly|Ride"] = 91.25, ["Neon"] = 155.64, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1076.74, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 181.02, ["Fly"] = 358.11, ["Ride"] = 247.4, ["Fly|Ride"] = 276.55, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.42, ["Fly"] = 126.19, ["Ride"] = 42.08, ["Fly|Ride"] = 140.91, ["Neon"] = 89.54, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 336.49, ["Mega"] = 351.21, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 590.85}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.57, ["Ride"] = 140.91, ["Fly|Ride"] = 268.14, ["Neon"] = 477.47, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1903.33}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 101.21, ["Fly"] = 157.49, ["Ride"] = 149.51, ["Fly|Ride"] = 262.5, ["Neon"] = 387.19, ["Neon|Fly"] = 561.51, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 493.49, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1240.32}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.95}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.49, ["Fly"] = 79.26, ["Ride"] = 62.98, ["Fly|Ride"] = 63.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4205.96, ["Mega|Fly|Ride"] = 1220.42}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.15, ["Fly"] = 98.44, ["Ride"] = 42.08, ["Fly|Ride"] = 157.5, ["Neon"] = 31.5, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 236.59, ["Mega"] = 170.52, ["Mega|Fly"] = 358.11, ["Mega|Ride"] = 271.3, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 551.04, ["Fly"] = 614.95, ["Ride"] = 478.7, ["Fly|Ride"] = 549.24, ["Neon|Fly"] = 3785.37, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1756.12, ["Mega"] = 8411.91, ["Mega|Ride"] = 14720.84, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 95.82, ["Fly"] = 155.64, ["Ride"] = 127.73, ["Fly|Ride"] = 167.62, ["Neon"] = 477.47, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2523.59, ["Mega|Fly|Ride"] = 2536.21}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4205.96, ["Ride"] = 3885, ["Fly|Ride"] = 3784.31, ["Neon|Fly|Ride"] = 14719.79}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 45.92, ["Fly"] = 119.89, ["Ride"] = 57.51, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1890.59, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1620.94}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 70.47, ["Ride"] = 65.63, ["Fly|Ride"] = 140.91, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6169.09, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 1772.63}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 56.8, ["Ride"] = 41.91, ["Fly|Ride"] = 83.15, ["Neon"] = 169.32, ["Neon|Fly"] = 286.49, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 197.73, ["Mega"] = 982.1, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.32}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.71, ["Ride"] = 37.66, ["Fly|Ride"] = 71.63, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 420.6, ["Mega|Ride"] = 1273.61, ["Mega|Fly|Ride"] = 1497.34}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 40.6}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.12, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1108.29, ["Neon|Fly|Ride"] = 1089.36, ["Mega|Fly|Ride"] = 4534.03}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 635.38, ["Fly|Ride"] = 770.59, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 10822.53}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 29.58, ["Fly"] = 59.06, ["Ride"] = 34.86, ["Fly|Ride"] = 71.31, ["Neon"] = 218.72, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 2102.99, ["Mega|Ride"] = 1146.01, ["Mega|Fly|Ride"] = 761.23}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.56}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17507.98, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36604.64}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.09, ["Fly"] = 55.11, ["Ride"] = 21.05, ["Fly|Ride"] = 60.37, ["Neon"] = 82.68, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 221.81, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 598.15}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13, ["Fly"] = 137.76, ["Ride"] = 30.19, ["Neon"] = 98.85, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 735, ["Mega|Ride"] = 807.23, ["Mega|Fly|Ride"] = 982.1}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 58.97, ["Ride"] = 58.7, ["Fly|Ride"] = 90.44, ["Neon|Ride"] = 390.12, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4205.96}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.16, ["Fly"] = 70.47, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 56.25, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 1402.7, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.68, ["Fly"] = 2033.59, ["Ride"] = 1637.9, ["Fly|Ride"] = 1573.69, ["Neon|Fly|Ride"] = 3149.99, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Ride"] = 52500, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 55125, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.73, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 126.19, ["Neon"] = 280.76, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 315, ["Mega"] = 982.1, ["Mega|Ride"] = 1147.13, ["Mega|Fly|Ride"] = 1370.3}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.39, ["Fly"] = 63, ["Ride"] = 45.23, ["Fly|Ride"] = 145.95, ["Neon"] = 26.25, ["Neon|Fly"] = 131.23, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 140.34, ["Mega|Ride"] = 234.93, ["Mega|Fly|Ride"] = 477.47}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.99}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.16, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 59.07, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 213.54, ["Mega"] = 378.55, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 681.38}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.93, ["Fly"] = 796.17, ["Ride"] = 676.31, ["Fly|Ride"] = 798.1, ["Neon"] = 2733.89, ["Neon|Ride"] = 2625.97, ["Neon|Fly|Ride"] = 2580.37, ["Mega|Fly|Ride"] = 9391.9}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 771.81, ["Fly"] = 974.74, ["Ride"] = 771.81, ["Fly|Ride"] = 971.25, ["Neon"] = 3785.37, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11496.98}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 10.49, ["Fly"] = 119.38, ["Ride"] = 29.96, ["Fly|Ride"] = 72.17, ["Neon"] = 85.3, ["Neon|Ride"] = 100.91, ["Neon|Fly|Ride"] = 161.11, ["Mega"] = 1204.37, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 21.94}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 68.16, ["Fly"] = 89.24, ["Ride"] = 85.28, ["Fly|Ride"] = 126, ["Neon"] = 590.85, ["Neon|Ride"] = 420.6, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2058.83, ["Mega|Fly|Ride"] = 2076.71}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Ride"] = 102.89, ["Fly|Ride"] = 183.75, ["Neon"] = 420, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 1394.77, ["Mega|Fly|Ride"] = 1909.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.74, ["Fly"] = 28.37, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 45.94, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 159.95, ["Mega|Fly|Ride"] = 652.93}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 141.75, ["Fly"] = 161.18, ["Ride"] = 167.9, ["Fly|Ride"] = 222.6, ["Neon"] = 612.84, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5047.16, ["Mega|Fly|Ride"] = 2487.19}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.01, ["Ride"] = 47.07, ["Fly|Ride"] = 182.97, ["Neon"] = 27.36, ["Neon|Fly"] = 168.25, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 168.25, ["Mega"] = 182.97, ["Mega|Fly"] = 334.39, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.46, ["Fly"] = 63.56, ["Ride"] = 32.71, ["Fly|Ride"] = 81, ["Neon"] = 128.63, ["Neon|Ride"] = 90.72, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 659.29, ["Mega|Ride"] = 813.86, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 33.67, ["Ride"] = 59.07, ["Fly|Ride"] = 156.19, ["Neon"] = 207.69, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 923.25}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.87, ["Fly"] = 210.31, ["Ride"] = 35.77, ["Fly|Ride"] = 47.15, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 140.91, ["Mega|Fly|Ride"] = 1105.13}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.75, ["Neon"] = 35050.3, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 25654.2}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 196.88, ["Fly"] = 223.13, ["Ride"] = 234.94, ["Fly|Ride"] = 280.34, ["Neon|Fly|Ride"] = 545.74, ["Mega|Fly|Ride"] = 1817.82}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 44.41, ["Fly"] = 139.94, ["Ride"] = 93.66, ["Fly|Ride"] = 211.08, ["Neon"] = 156.18, ["Neon|Fly"] = 237.66, ["Neon|Ride"] = 162.31, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 428.3, ["Mega|Fly"] = 615.92, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 572.04}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.57, ["Fly"] = 88.34, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 17.85, ["Neon|Fly"] = 69.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 356.91}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61, ["Fly"] = 164.07, ["Ride"] = 101.95, ["Fly|Ride"] = 202.79, ["Neon"] = 196.88, ["Neon|Fly"] = 436.38, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 387.17, ["Mega"] = 545.31, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 679.29}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 12075, ["Neon|Fly|Ride"] = 27055.71, ["Mega|Fly|Ride"] = 112159.02}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 252, ["Ride"] = 316.53, ["Fly|Ride"] = 459.27, ["Neon"] = 1598.28, ["Neon|Ride"] = 1398.5, ["Neon|Fly|Ride"] = 1598.28, ["Mega|Fly|Ride"] = 6912.49}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 46.41, ["Fly"] = 80.59, ["Ride"] = 69.56, ["Fly|Ride"] = 91.88, ["Neon"] = 1050, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 352.13, ["Mega|Fly|Ride"] = 3049.33}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.8, ["Ride"] = 20, ["Fly|Ride"] = 69.42, ["Neon"] = 67.46, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 157.48, ["Mega"] = 393.75, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 628.81}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.08, ["Fly"] = 841.2, ["Ride"] = 420, ["Fly|Ride"] = 511.88, ["Neon"] = 1584.61, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1503.97, ["Mega|Fly|Ride"] = 5024.02}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 39.98, ["Fly|Ride"] = 185.27, ["Neon"] = 33.94, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 140.44, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 204.38, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.91, ["Fly"] = 164.07, ["Ride"] = 132.93, ["Fly|Ride"] = 190.32, ["Neon"] = 380.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 506.34, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.94, ["Fly"] = 18.04, ["Ride"] = 17.33, ["Fly|Ride"] = 39.15, ["Neon"] = 159.95, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 98.85, ["Mega"] = 2523.59, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.48}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.31, ["Fly"] = 140.91, ["Ride"] = 58.97, ["Fly|Ride"] = 210.31, ["Neon"] = 420.6, ["Neon|Fly"] = 419.55, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 954.92, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1592.31}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.94, ["Fly"] = 80.07, ["Ride"] = 31.39, ["Fly|Ride"] = 65.63, ["Neon"] = 98.43, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 183.88, ["Mega"] = 596.82, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.88}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 49.79, ["Fly"] = 140.91, ["Ride"] = 105.16, ["Fly|Ride"] = 223.13, ["Neon"] = 280.76, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 280.76, ["Mega|Ride"] = 1592.31, ["Mega|Fly|Ride"] = 1542.54}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.81, ["Ride"] = 29.22, ["Fly|Ride"] = 136.08, ["Neon"] = 21.16, ["Neon|Ride"] = 112.21, ["Neon|Fly|Ride"] = 147.23, ["Mega"] = 142.23, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.33, ["Fly"] = 140.91, ["Ride"] = 32.61, ["Fly|Ride"] = 85.22, ["Neon"] = 159.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 188.24, ["Mega"] = 561.51, ["Mega|Ride"] = 630.91, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 562.56, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 36.14, ["Fly"] = 106.77, ["Ride"] = 47.77, ["Fly|Ride"] = 107.63, ["Neon"] = 178.75, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 328.08, ["Mega"] = 776.43, ["Mega|Ride"] = 659.29, ["Mega|Fly|Ride"] = 535.4}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.13, ["Fly"] = 140.91, ["Ride"] = 65.63, ["Fly|Ride"] = 120.86, ["Neon"] = 315.46, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 318.72}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.71, ["Ride"] = 71.67, ["Fly|Ride"] = 120.65, ["Neon"] = 98.44, ["Neon|Ride"] = 143.06, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 318.8, ["Mega|Fly"] = 525, ["Mega|Ride"] = 390.12, ["Mega|Fly|Ride"] = 587.79}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 7536.38, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1273.85, ["Fly"] = 1486.7, ["Ride"] = 1443.74, ["Fly|Ride"] = 1375.5, ["Neon|Fly|Ride"] = 3726.19, ["Mega|Fly|Ride"] = 16544.11}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 587.79, ["Ride"] = 609, ["Fly|Ride"] = 630.91, ["Neon"] = 4459.02, ["Neon|Fly|Ride"] = 3506.72, ["Mega"] = 21029.76, ["Mega|Fly|Ride"] = 7711.62}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.01, ["Fly"] = 15.75, ["Ride"] = 21.68, ["Fly|Ride"] = 39.38, ["Neon"] = 68.06, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 112.52, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.44, ["Fly"] = 78.74, ["Ride"] = 32.24, ["Fly|Ride"] = 163, ["Neon"] = 24.94, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 1432.36, ["Mega"] = 155.3, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 262.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.76, ["Fly"] = 52.5, ["Ride"] = 42.32, ["Fly|Ride"] = 94.47, ["Neon"] = 199.8, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 182.34, ["Mega|Ride"] = 736.05, ["Mega|Fly|Ride"] = 656.1}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.32, ["Fly"] = 21.05, ["Ride"] = 15.98, ["Fly|Ride"] = 37.2, ["Neon"] = 45.23, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 45.22, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 225.04, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328, ["Fly"] = 380.63, ["Ride"] = 301.1, ["Fly|Ride"] = 369.49, ["Neon"] = 1592.31, ["Neon|Ride"] = 1206.08, ["Neon|Fly|Ride"] = 1234.46, ["Mega|Fly|Ride"] = 3653.85}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.59, ["Fly"] = 59.07, ["Ride"] = 30.85, ["Fly|Ride"] = 80.79, ["Neon"] = 199.16, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 659.29, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 687.65}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.15, ["Fly"] = 19.69, ["Ride"] = 18.8, ["Fly|Ride"] = 40.68, ["Neon"] = 82.03, ["Neon|Fly"] = 119.89, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 601.6, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 561.51, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 3364.78, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1058.4, ["Ride"] = 1148.44, ["Fly|Ride"] = 1259.25, ["Neon"] = 4907.31, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 11917.58}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 137.82, ["Fly"] = 137.76, ["Ride"] = 91.49, ["Fly|Ride"] = 120.75, ["Neon"] = 580.43, ["Neon|Ride"] = 578.33, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2522.54}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 179.85, ["Fly"] = 212.13, ["Ride"] = 157.2, ["Fly|Ride"] = 236.25, ["Neon"] = 852.77, ["Neon|Ride"] = 760.24, ["Neon|Fly|Ride"] = 648.64, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2874.78}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.85, ["Fly"] = 56.8, ["Ride"] = 32.45, ["Fly|Ride"] = 112.25, ["Neon"] = 236.24, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 1064.12}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 140.91, ["Ride"] = 315, ["Fly|Ride"] = 406.93, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1121.96, ["Mega"] = 5608.65, ["Mega|Fly|Ride"] = 5608.65}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2215.49, ["Ride"] = 1670.71, ["Fly|Ride"] = 1837.48, ["Neon|Fly|Ride"] = 10514.88, ["Mega|Fly|Ride"] = 29442.94}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.82, ["Fly"] = 210.31, ["Ride"] = 52.4, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 1402.7, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 982.1}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 841.2, ["Ride"] = 630, ["Fly|Ride"] = 654.94, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1194.3, ["Mega|Fly|Ride"] = 3451.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.11, ["Fly"] = 59.07, ["Ride"] = 53.69, ["Fly|Ride"] = 74.05, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 232.59, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.5, ["Fly"] = 46.28, ["Ride"] = 22.72, ["Fly|Ride"] = 54.46, ["Neon"] = 26.25, ["Neon|Fly"] = 105, ["Neon|Ride"] = 49.71, ["Neon|Fly|Ride"] = 101.18, ["Mega"] = 161.95, ["Mega|Ride"] = 184.99, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 52.69, ["Ride"] = 127.73, ["Fly|Ride"] = 204.01, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 1537.29, ["Mega|Ride"] = 1535.19}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 774.25, ["Fly"] = 1092, ["Ride"] = 826.88, ["Fly|Ride"] = 909.03, ["Neon|Ride"] = 3085.07, ["Neon|Fly|Ride"] = 2952.03, ["Mega|Fly|Ride"] = 11917.58}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 588.84, ["Ride"] = 523.69, ["Fly|Ride"] = 813.86, ["Neon"] = 10795.64, ["Neon|Fly|Ride"] = 4196.51, ["Mega|Fly|Ride"] = 15280.23}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.03, ["Fly"] = 21, ["Ride"] = 22.41, ["Fly|Ride"] = 45.94, ["Neon"] = 144.38, ["Neon|Ride"] = 130.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 796.17, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.69, ["Ride"] = 26.25, ["Fly|Ride"] = 84.14, ["Neon"] = 141.9, ["Neon|Ride"] = 153.54, ["Neon|Fly|Ride"] = 210, ["Mega"] = 846.57, ["Mega|Ride"] = 656.14, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.67, ["Fly"] = 61.64, ["Ride"] = 26.17, ["Fly|Ride"] = 111.46, ["Neon"] = 21.72, ["Neon|Fly"] = 318.68, ["Neon|Ride"] = 64.46, ["Neon|Fly|Ride"] = 209.26, ["Mega"] = 176.19, ["Mega|Fly"] = 541.91, ["Mega|Ride"] = 202.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.25, ["Fly"] = 51.19, ["Ride"] = 44.72, ["Fly|Ride"] = 106.32, ["Neon"] = 294.44, ["Neon|Ride"] = 199.8, ["Neon|Fly|Ride"] = 233.06, ["Mega|Fly|Ride"] = 1272.55}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 76.56, ["Ride"] = 129.94, ["Fly|Ride"] = 477.47, ["Neon"] = 428.35, ["Neon|Ride"] = 561.51, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1964.19, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.5, ["Fly"] = 45.94, ["Ride"] = 37.96, ["Fly|Ride"] = 85.72, ["Neon"] = 106.32, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 147, ["Mega"] = 425.39, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 451.19}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.6, ["Fly"] = 60.89, ["Ride"] = 45.94, ["Fly|Ride"] = 79.92, ["Neon"] = 242.82, ["Neon|Fly"] = 1402.7, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.6}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.63, ["Fly"] = 27.19, ["Ride"] = 17.03, ["Fly|Ride"] = 44.6, ["Neon"] = 20.99, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 736.05, ["Mega|Ride"] = 477.47, ["Mega|Fly|Ride"] = 520.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.24, ["Fly"] = 49.88, ["Ride"] = 41.91, ["Fly|Ride"] = 63.58, ["Neon"] = 37.41, ["Neon|Fly"] = 109.37, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 124.09, ["Mega"] = 416.06, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 419.55}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 53.65, ["Fly"] = 56.21, ["Ride"] = 52.5, ["Fly|Ride"] = 95.75, ["Neon"] = 525, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 209.89, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1403.07, ["Fly"] = 1410.93, ["Ride"] = 1391.25, ["Fly|Ride"] = 1463.6, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 17105.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 478.86, ["Neon|Ride"] = 2804.33, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14720.84, ["Mega|Fly|Ride"] = 9253.11}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 262.5, ["Fly"] = 378.23, ["Ride"] = 300.57, ["Fly|Ride"] = 454.26, ["Neon"] = 1311.19, ["Neon|Ride"] = 1535.19, ["Neon|Fly|Ride"] = 1640.63}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.09}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.39, ["Ride"] = 45.05, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 280.76, ["Mega|Ride"] = 1542.54, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 36451.92, ["Fly"] = 23132.74, ["Ride"] = 23872.33, ["Fly|Ride"] = 17981.25, ["Neon|Fly|Ride"] = 36093.75, ["Mega"] = 210297.48, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 236.25, ["Fly"] = 262.5, ["Ride"] = 238.88, ["Fly|Ride"] = 334.69, ["Neon"] = 1074.27, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 937, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 3680.21, ["Mega|Ride"] = 4204.91, ["Mega|Fly|Ride"] = 3505.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 209.26, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1751.06}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.61, ["Fly"] = 210.31, ["Ride"] = 150.94, ["Fly|Ride"] = 211.91, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 63, ["Ride"] = 26.25, ["Fly|Ride"] = 73.62, ["Neon"] = 140.91, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 233.44, ["Mega"] = 713.79, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 840.15}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3871.88, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon"] = 27338.69, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.15, ["Fly"] = 45.93, ["Ride"] = 28.73, ["Fly|Ride"] = 53.54, ["Neon"] = 337.81, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 1121.96, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 41.98, ["Fly"] = 126.19, ["Ride"] = 56.11, ["Fly|Ride"] = 103.26, ["Neon"] = 314.26, ["Neon|Fly"] = 1402.7, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 419.98, ["Fly"] = 551.25, ["Ride"] = 474.04, ["Fly|Ride"] = 582.82, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1353.27, ["Mega|Fly|Ride"] = 7161.72}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.73, ["Fly"] = 22.84, ["Ride"] = 22.19, ["Fly|Ride"] = 40.49, ["Neon"] = 123.37, ["Neon|Fly"] = 158.8, ["Neon|Ride"] = 126.54, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 771.81, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.9, ["Ride"] = 26.24, ["Fly|Ride"] = 65.63, ["Neon"] = 95.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 740.07, ["Mega|Fly|Ride"] = 716.19}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.85, ["Ride"] = 126.19, ["Fly|Ride"] = 206.11, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.43, ["Fly"] = 126.19, ["Ride"] = 65.63, ["Fly|Ride"] = 163.7, ["Neon"] = 41.46, ["Neon|Ride"] = 91.82, ["Neon|Fly|Ride"] = 224.43, ["Mega"] = 263.71, ["Mega|Fly"] = 729.75, ["Mega|Ride"] = 294.67, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3806.15, ["Fly"] = 6206.83, ["Ride"] = 3883.66, ["Fly|Ride"] = 4068.44, ["Neon"] = 14720.84, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9318.75, ["Mega"] = 42058.46, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.48, ["Fly"] = 42, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 144.38, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 393.91, ["Mega"] = 771.81, ["Mega|Ride"] = 1751.06, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7847.26, ["Fly"] = 7570.73, ["Ride"] = 6857.82, ["Fly|Ride"] = 5880, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.25, ["Fly"] = 17.88, ["Ride"] = 15.65, ["Fly|Ride"] = 34.21, ["Neon"] = 24.68, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 196.64, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 252.37}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.11, ["Fly"] = 25.99, ["Ride"] = 21.06, ["Fly|Ride"] = 52.73, ["Neon"] = 140.91, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 140.95, ["Neon|Fly|Ride"] = 164.66, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 914.81}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.89}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.56, ["Ride"] = 31.49, ["Fly|Ride"] = 57.66, ["Neon"] = 98.44, ["Neon|Ride"] = 89.02, ["Mega"] = 1049.9, ["Mega|Ride"] = 883.26, ["Mega|Fly|Ride"] = 789.68}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.36, ["Fly"] = 190.37, ["Ride"] = 42, ["Fly|Ride"] = 99.73, ["Neon"] = 156.35, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 945, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.82, ["Fly"] = 25.64, ["Ride"] = 21.05, ["Fly|Ride"] = 35.43, ["Neon|Fly"] = 1048.35, ["Neon|Ride"] = 116.72, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2523.59, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8552.82}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.96}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.04, ["Ride"] = 385.91, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.88, ["Fly"] = 133.55, ["Ride"] = 32.41, ["Fly|Ride"] = 126.19, ["Neon"] = 119.89, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 525, ["Mega|Ride"] = 526.39, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.39}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.25, ["Ride"] = 26.25, ["Fly|Ride"] = 84.14, ["Neon|Ride"] = 249.38, ["Mega"] = 1542.54}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2585.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 128.63, ["Fly"] = 296.54, ["Ride"] = 169.21, ["Fly|Ride"] = 420.6, ["Neon"] = 918.75, ["Neon|Ride"] = 822.28, ["Neon|Fly|Ride"] = 982.1, ["Mega|Ride"] = 4066.12, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 63.95, ["Ride"] = 93.16, ["Fly|Ride"] = 210.31, ["Neon"] = 655.09, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 926.38, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.46, ["Fly"] = 232.39, ["Ride"] = 157.49, ["Fly|Ride"] = 223.02, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3258.94, ["Mega|Fly|Ride"] = 3031.98}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3224.93, ["Ride"] = 2231.25, ["Fly|Ride"] = 2231.25, ["Neon"] = 14769.21, ["Neon|Ride"] = 8355.33, ["Neon|Fly|Ride"] = 7921.92, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.54, ["Fly"] = 70.47, ["Ride"] = 34.55, ["Fly|Ride"] = 100.08, ["Neon"] = 127.32, ["Neon|Fly"] = 159.95, ["Neon|Ride"] = 152.79, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 945.3, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 813.86, ["Fly"] = 2100, ["Ride"] = 869.59, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4138.29}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.34, ["Ride"] = 51.97, ["Fly|Ride"] = 336.61, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 449.39, ["Mega|Fly"] = 954.92, ["Mega|Ride"] = 491.07, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.58, ["Fly"] = 73.62, ["Ride"] = 27.45, ["Fly|Ride"] = 104.11, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 446.42, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.37}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.9, ["Fly"] = 105.68, ["Ride"] = 21.3, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 191, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 1522.5}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.05, ["Fly"] = 39.37, ["Ride"] = 33.53, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 189.29, ["Mega"] = 1432.36, ["Mega|Ride"] = 1790.44, ["Mega|Fly|Ride"] = 978.95}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.5, ["Fly"] = 10237.5, ["Ride"] = 6206.83, ["Fly|Ride"] = 5049.19, ["Neon|Fly|Ride"] = 9318.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.87, ["Fly"] = 65.62, ["Ride"] = 34.13, ["Fly|Ride"] = 81.37, ["Neon"] = 51.98, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 167.2, ["Mega"] = 314.41, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.44}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 101.34, ["Fly"] = 372.25, ["Ride"] = 111.46, ["Fly|Ride"] = 160.09, ["Neon"] = 420.6, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 2879.59, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 2058.83}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.82, ["Fly"] = 140.91, ["Ride"] = 74.81, ["Fly|Ride"] = 181.73, ["Neon"] = 284.82, ["Neon|Ride"] = 272.35, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2387.25, ["Mega|Ride"] = 2839.04, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 70.47, ["Ride"] = 29.8, ["Fly|Ride"] = 64.32, ["Neon"] = 128.77, ["Neon|Fly"] = 227.14, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 191.39, ["Mega"] = 1016.21, ["Mega|Ride"] = 859.42, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.03, ["Fly"] = 68.95, ["Ride"] = 28.3, ["Fly|Ride"] = 61, ["Neon"] = 28.41, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 137.71, ["Mega|Fly"] = 7011.8, ["Mega|Ride"] = 206.35, ["Mega|Fly|Ride"] = 285.75}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.46, ["Fly"] = 38.21, ["Ride"] = 25.62, ["Fly|Ride"] = 96.96, ["Neon"] = 91.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 189.29, ["Mega|Ride"] = 637.42, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 24.66, ["Fly"] = 32.24, ["Ride"] = 24.05, ["Fly|Ride"] = 46.45, ["Neon"] = 364.88, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.91, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.28}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 58.9, ["Ride"] = 131.23, ["Fly|Ride"] = 280.76, ["Neon"] = 168.25, ["Neon|Ride"] = 218.72, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 561.51, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 250.26, ["Ride"] = 695.63, ["Fly|Ride"] = 630.91, ["Neon|Ride"] = 16823.82, ["Neon|Fly|Ride"] = 28040.03}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 43.3, ["Fly"] = 212.84, ["Ride"] = 86.51, ["Fly|Ride"] = 162.75, ["Neon"] = 251.99, ["Neon|Ride"] = 321.54, ["Neon|Fly|Ride"] = 456.36, ["Mega"] = 851.9, ["Mega|Ride"] = 1034.88, ["Mega|Fly|Ride"] = 1142.98}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.27, ["Fly"] = 1332.24, ["Ride"] = 925.8, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 4219.45, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 392.34, ["Fly"] = 701.36, ["Ride"] = 380.62, ["Fly|Ride"] = 426.45, ["Neon"] = 1968.75, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 11936.17, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 69.95}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.21}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.75, ["Fly"] = 23, ["Ride"] = 27.2, ["Fly|Ride"] = 51, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.34, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 437.26, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 525.75}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.24, ["Fly"] = 406.65, ["Ride"] = 245.78, ["Fly|Ride"] = 326.69, ["Neon"] = 1121.96, ["Neon|Ride"] = 1100.92, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 2805.22}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.01}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.68, ["Fly"] = 285.29, ["Ride"] = 139.22, ["Fly|Ride"] = 280.76, ["Neon"] = 524.9, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.23, ["Mega"] = 2231.43, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.22, ["Fly"] = 210.31, ["Ride"] = 129.45, ["Fly|Ride"] = 140.91, ["Neon"] = 1121.96, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 905.98, ["Mega|Fly|Ride"] = 2523.59}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.68, ["Ride"] = 28.27, ["Fly|Ride"] = 52.5, ["Neon"] = 37.8, ["Neon|Ride"] = 85.96, ["Neon|Fly|Ride"] = 237.66, ["Mega"] = 336.49, ["Mega|Ride"] = 189.84}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.33, ["Fly"] = 71.54, ["Ride"] = 25.75, ["Fly|Ride"] = 78.64, ["Neon"] = 175.88, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 316.28, ["Mega|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.12, ["Fly"] = 102.36, ["Ride"] = 31.5, ["Fly|Ride"] = 104.51, ["Neon"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 256.58, ["Mega"] = 419.55, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 557.44}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.73, ["Fly"] = 98.18, ["Ride"] = 42, ["Fly|Ride"] = 137.71, ["Neon"] = 25.77, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 149.94, ["Mega|Fly"] = 270.96, ["Mega|Ride"] = 190.21, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 240.35, ["Ride"] = 261.19, ["Fly|Ride"] = 380.63, ["Neon"] = 1570.94, ["Neon|Ride"] = 1358.35, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5577.1}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 84.16, ["Fly"] = 561.51, ["Ride"] = 124.59, ["Fly|Ride"] = 241.5, ["Neon"] = 525, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 613.53, ["Mega"] = 2244.01, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 60.37, ["Fly"] = 167.45, ["Ride"] = 70.26, ["Fly|Ride"] = 131.25, ["Neon"] = 380.63, ["Neon|Ride"] = 247.23, ["Neon|Fly|Ride"] = 407.77, ["Mega|Ride"] = 1751.06, ["Mega|Fly|Ride"] = 1801.15}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.92, ["Fly"] = 78.75, ["Ride"] = 28.41, ["Fly|Ride"] = 280.76, ["Neon"] = 115.5, ["Neon|Ride"] = 606.37, ["Neon|Fly|Ride"] = 491.07}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.72, ["Fly"] = 35.41, ["Ride"] = 28.87, ["Fly|Ride"] = 78.87, ["Neon"] = 77.43, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 374.35, ["Mega|Fly"] = 525, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.3, ["Fly"] = 52.47, ["Ride"] = 19.69, ["Fly|Ride"] = 56.8, ["Neon"] = 20.99, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 61.95, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 141.7, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.49, ["Fly"] = 1082.73, ["Ride"] = 843.92, ["Fly|Ride"] = 909.44, ["Neon"] = 2944.18, ["Neon|Fly"] = 3240.68, ["Neon|Ride"] = 8411.91, ["Neon|Fly|Ride"] = 2835, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 318.94, ["Fly"] = 477.4, ["Ride"] = 305.82, ["Fly|Ride"] = 420.6, ["Neon"] = 1193.63, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1222.71, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 6307.89}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 85.32, ["Fly"] = 132.5, ["Ride"] = 108.94, ["Fly|Ride"] = 182.97, ["Neon"] = 342.8, ["Neon|Fly"] = 477.47, ["Neon|Ride"] = 322.83, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1570.94, ["Mega|Fly|Ride"] = 1618.25}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 205.13, ["Fly|Ride"] = 238.74, ["Neon|Ride"] = 1273.61, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 4907.31}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.61, ["Fly"] = 32.82, ["Ride"] = 28.87, ["Fly|Ride"] = 74.61, ["Neon"] = 169.32, ["Neon|Ride"] = 181.18, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 796.17}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 222.01, ["Fly|Ride"] = 358.32, ["Neon"] = 786.19, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4186.14, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.07, ["Fly"] = 125.98, ["Ride"] = 76.23, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 477.47, ["Mega|Fly|Ride"] = 1528.88}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1955.63, ["Ride"] = 2034.38, ["Fly|Ride"] = 1925.44, ["Neon|Ride"] = 11141.23, ["Neon|Fly|Ride"] = 9113.25, ["Mega"] = 50471.4, ["Mega|Fly|Ride"] = 23872.33}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 17.11, ["Fly"] = 77.44, ["Ride"] = 41.91, ["Fly|Ride"] = 96.07, ["Neon"] = 108.94, ["Neon|Fly"] = 232.39, ["Neon|Ride"] = 115.89, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 288.74, ["Mega|Fly"] = 561.51, ["Mega|Ride"] = 320.07, ["Mega|Fly|Ride"] = 424.48}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 54.32, ["Fly"] = 119.38, ["Ride"] = 70.47, ["Fly|Ride"] = 140.84, ["Neon"] = 223.13, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 561.51, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1051.5}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 83.9, ["Fly"] = 91.86, ["Ride"] = 78.12, ["Fly|Ride"] = 91.88, ["Neon"] = 525, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3701.16, ["Fly"] = 1592.31, ["Ride"] = 1069.68, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 5093.18, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 525, ["Ride"] = 841.2, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3183.39, ["Mega|Fly|Ride"] = 11216.23}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.69, ["Fly"] = 170.63, ["Ride"] = 78.74, ["Fly|Ride"] = 208.69, ["Neon"] = 442.98, ["Neon|Ride"] = 342.43, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 5608.65, ["Mega|Ride"] = 2547.2, ["Mega|Fly|Ride"] = 1497.64}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.87, ["Ride"] = 25.55, ["Fly|Ride"] = 64.78, ["Neon"] = 74.33, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 656.25, ["Mega|Ride"] = 761.29}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 26.25, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 78.75, ["Neon"] = 210, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 2243.9, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 734.99, ["Fly"] = 1098.15, ["Ride"] = 735, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2230.99, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.94}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 5610.94, ["Fly|Ride"] = 5248.69, ["Neon"] = 42000, ["Neon|Ride"] = 30136.7, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 105008.91}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 249.38, ["Fly"] = 394.32, ["Ride"] = 328.13, ["Fly|Ride"] = 415.38, ["Neon"] = 1312.5, ["Neon|Ride"] = 1823.3, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6307.89, ["Mega|Fly|Ride"] = 6684.27}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.74, ["Fly"] = 280.76, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 419.55, ["Neon|Ride"] = 785.48, ["Neon|Fly|Ride"] = 626.7, ["Mega|Fly|Ride"] = 2160.82}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.35, ["Fly"] = 65.62, ["Ride"] = 30.19, ["Fly|Ride"] = 52.41, ["Neon"] = 156.92, ["Neon|Fly"] = 1273.61, ["Neon|Ride"] = 119.38, ["Neon|Fly|Ride"] = 203.94, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 753.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.83, ["Fly"] = 26.24, ["Ride"] = 21, ["Fly|Ride"] = 48.64, ["Neon"] = 104.11, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.79, ["Fly"] = 280.76, ["Ride"] = 27.47, ["Fly|Ride"] = 85.32, ["Neon"] = 118.13, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 222.93, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.55, ["Fly"] = 77.82, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 273.4}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 31.12, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 841.2, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 624.6, ["Mega|Ride"] = 771.81}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 479.07, ["Fly"] = 533.12, ["Ride"] = 472.5, ["Fly|Ride"] = 545.88, ["Neon"] = 1577.24, ["Neon|Ride"] = 1542.54, ["Neon|Fly|Ride"] = 1376.82, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5188.05}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.6, ["Fly"] = 19.58, ["Ride"] = 15.59, ["Fly|Ride"] = 35.77, ["Neon"] = 23.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 170.63, ["Mega|Ride"] = 222.93, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 34.55, ["Fly"] = 110.06, ["Ride"] = 78.65, ["Fly|Ride"] = 132.49, ["Neon"] = 157.48, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 218.67, ["Neon|Fly|Ride"] = 262.39, ["Mega"] = 524.27, ["Mega|Ride"] = 502.74, ["Mega|Fly|Ride"] = 556.49}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 800.63, ["Ride"] = 735, ["Fly|Ride"] = 795, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.81, ["Fly"] = 90.56, ["Ride"] = 44.62, ["Fly|Ride"] = 65.63, ["Neon"] = 252.37, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 1193.63, ["Mega|Ride"] = 946.35, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 357, ["Fly"] = 477.47, ["Ride"] = 259.88, ["Fly|Ride"] = 337.22, ["Neon"] = 1542.54, ["Neon|Ride"] = 1823.3, ["Neon|Fly|Ride"] = 1402.7, ["Mega|Fly|Ride"] = 6366.76}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 182.96, ["Fly"] = 178.49, ["Ride"] = 177.19, ["Fly|Ride"] = 236.22, ["Neon"] = 982.1, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 883.26, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3659.19}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 869.59, ["Ride"] = 783.57, ["Fly|Ride"] = 866.25, ["Neon|Ride"] = 3927.32, ["Neon|Fly|Ride"] = 3869.5, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.19, ["Fly"] = 84.14, ["Ride"] = 44.27, ["Fly|Ride"] = 110.25, ["Neon"] = 82.69, ["Neon|Fly"] = 286.49, ["Neon|Ride"] = 84.14, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 354.38, ["Mega|Ride"] = 406.93, ["Mega|Fly|Ride"] = 524.84}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3205.34, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 23872.33}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 100.7, ["Fly"] = 155.64, ["Ride"] = 131.11, ["Fly|Ride"] = 182.97, ["Neon"] = 459.38, ["Neon|Fly"] = 711.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2664.47, ["Mega|Fly|Ride"] = 2775.94}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 28.3, ["Ride"] = 15.53, ["Fly|Ride"] = 38.57, ["Neon"] = 19.69, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 36.26, ["Neon|Fly|Ride"] = 63, ["Mega"] = 155.61, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 196.64, ["Mega|Fly|Ride"] = 227.14}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.01, ["Ride"] = 24.52, ["Fly|Ride"] = 57.71, ["Neon"] = 22.31, ["Neon|Fly"] = 117, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 105, ["Mega"] = 152.12, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.45, ["Fly"] = 38.45, ["Ride"] = 30.85, ["Fly|Ride"] = 56.11, ["Neon"] = 286.49, ["Neon|Ride"] = 182.97, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1079.02}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 868.54, ["Fly"] = 1235.4, ["Ride"] = 995.08, ["Fly|Ride"] = 1145.89, ["Neon"] = 4486.72, ["Neon|Fly|Ride"] = 3506.72}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 72915.94}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.81, ["Fly"] = 45.23, ["Ride"] = 17.07, ["Fly|Ride"] = 39.48, ["Neon"] = 452.13, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 135.09, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.21, ["Fly"] = 57.64, ["Ride"] = 26.25, ["Fly|Ride"] = 77.44, ["Neon"] = 71.31, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 317.52, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 86.92, ["Fly"] = 157.5, ["Ride"] = 87.93, ["Fly|Ride"] = 134.63, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1844.07}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.47, ["Fly"] = 241.5, ["Ride"] = 221.79, ["Fly|Ride"] = 336, ["Neon"] = 918.75, ["Neon|Ride"] = 1073.91, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 3442.58}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.17, ["Ride"] = 32.71, ["Fly|Ride"] = 77.82, ["Neon"] = 21, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 52.59, ["Mega"] = 145.91, ["Mega|Fly"] = 234.49, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 166.72, ["Fly"] = 324.69, ["Ride"] = 208.43, ["Fly|Ride"] = 280.76, ["Neon"] = 796.17, ["Neon|Ride"] = 685.73, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.98, ["Fly"] = 21.05, ["Ride"] = 18.41, ["Fly|Ride"] = 50.97, ["Neon"] = 23.63, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 282.08}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 339.65, ["Ride"] = 210.31, ["Fly|Ride"] = 232.39, ["Neon|Ride"] = 1193.63, ["Neon|Fly|Ride"] = 790.82, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 5411.87}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.71, ["Fly"] = 77.44, ["Ride"] = 23.89, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 303.19, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 498.42, ["Mega|Ride"] = 471.08, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.93, ["Ride"] = 19.68, ["Fly|Ride"] = 72.19, ["Neon"] = 10.61, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 138.81, ["Mega"] = 82.03, ["Mega|Ride"] = 98.85, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.52, ["Mega"] = 17.8, ["Mega|Ride"] = 151.43, ["Mega|Fly|Ride"] = 166.15}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 35.33, ["Fly|Ride"] = 112.52, ["Neon"] = 6.23, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 73.41, ["Mega|Fly"] = 159149.63, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.69, ["Fly"] = 105, ["Ride"] = 91.25, ["Fly|Ride"] = 140.91, ["Neon"] = 313.88, ["Neon|Fly"] = 399.58, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.63, ["Ride"] = 15.75, ["Fly|Ride"] = 78.75, ["Neon"] = 4.79, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 127.73, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.96, ["Ride"] = 112.52, ["Neon"] = 115.67, ["Neon|Fly"] = 238.74, ["Neon|Ride"] = 245.9, ["Mega"] = 261.19, ["Mega|Ride"] = 533.12}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 56.8, ["Neon"] = 2.81, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 12.49, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 157.17}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 70.48, ["Ride"] = 11.82, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 13.48, ["Neon|Fly|Ride"] = 28.77, ["Mega"] = 14.86, ["Mega|Fly"] = 25.8, ["Mega|Ride"] = 20.61, ["Mega|Fly|Ride"] = 64.22}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.8, ["Fly|Ride"] = 66.27, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 140.94, ["Mega|Fly"] = 159.95, ["Mega|Ride"] = 32.79, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 70.47, ["Neon"] = 2.15, ["Neon|Ride"] = 37.1, ["Mega"] = 18.95, ["Mega|Ride"] = 130.39}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.05, ["Fly|Ride"] = 107.62, ["Neon"] = 2.63, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.71, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 17.43, ["Mega|Fly"] = 136.71, ["Mega|Ride"] = 112.52, ["Mega|Fly|Ride"] = 212.84}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 4.97, ["Fly"] = 36.75, ["Ride"] = 32.81, ["Fly|Ride"] = 155.64, ["Neon"] = 16.84, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 131.15, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 129.62, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 318.72, ["Mega"] = 12.7, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.98, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.23, ["Ride"] = 141.96, ["Fly|Ride"] = 140.91, ["Neon"] = 18.13, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.41, ["Neon"] = 18.95, ["Neon|Ride"] = 70.47, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Ride"] = 15.8, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 19.11, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.11, ["Ride"] = 14.17, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 15.8, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 36.94, ["Mega"] = 12.16, ["Mega|Fly"] = 32.61, ["Mega|Ride"] = 19.11, ["Mega|Fly|Ride"] = 49.6}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.43, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 40.5, ["Neon|Ride"] = 140.95, ["Mega"] = 189.29, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 29.64, ["Fly|Ride"] = 47.77, ["Neon"] = 6.23, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 35.77, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.98, ["Mega|Ride"] = 45.86, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.71, ["Neon"] = 6.45, ["Mega"] = 68.25, ["Mega|Ride"] = 159.85, ["Mega|Fly|Ride"] = 239.76}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.3, ["Fly"] = 91.88, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 19.02, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 191}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.82, ["Fly|Ride"] = 21.05, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.86, ["Neon|Fly|Ride"] = 28.76, ["Mega"] = 8.43, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 20, ["Mega|Fly|Ride"] = 45.67}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 27.4, ["Fly|Ride"] = 140.91, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 159.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.81, ["Fly"] = 112.52, ["Ride"] = 39.98, ["Fly|Ride"] = 59.07, ["Neon"] = 45.49, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.24, ["Ride"] = 13.71, ["Fly|Ride"] = 28.76, ["Neon"] = 2.63, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 19.83, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.62, ["Fly"] = 175.62, ["Ride"] = 31.5, ["Neon"] = 6.14, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 167.2, ["Mega"] = 63, ["Mega|Fly"] = 168.25, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 65.62, ["Neon"] = 3.3, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 25.72, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 14.95, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 39.4, ["Mega|Fly|Ride"] = 79.98}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 14.22, ["Fly|Ride"] = 46.55, ["Neon"] = 4.79, ["Neon|Fly"] = 53.64, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 79.98, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 45.94, ["Neon"] = 4.73, ["Neon|Ride"] = 63.1, ["Mega"] = 35.03, ["Mega|Fly"] = 238.74, ["Mega|Ride"] = 98.34, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 14.97, ["Ride"] = 15.01, ["Fly|Ride"] = 72.19, ["Neon"] = 5.2, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.08, ["Mega"] = 111.57, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 38.58, ["Neon"] = 41.78, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 159.95, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 14.79, ["Fly|Ride"] = 32.03, ["Neon"] = 9.18, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 30.59, ["Neon|Fly|Ride"] = 70.87, ["Mega"] = 263.82, ["Mega|Fly"] = 420, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.73, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 63.1, ["Neon"] = 13.02, ["Neon|Fly"] = 65.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 94.65, ["Mega"] = 168.25, ["Mega|Fly"] = 159.85, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 111.47, ["Neon"] = 71.37, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 183.18, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.81, ["Ride"] = 56.44, ["Neon"] = 202, ["Neon|Ride"] = 225.04, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 561.51, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 798.1}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.16, ["Ride"] = 54.14, ["Neon"] = 45.76, ["Neon|Ride"] = 106.55, ["Mega"] = 238.71, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 317.52}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 9.56, ["Ride"] = 21.38, ["Fly|Ride"] = 120.75, ["Neon"] = 31.39, ["Neon|Ride"] = 56.8, ["Mega"] = 311.07, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 377.52}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.54, ["Neon|Ride"] = 65.01, ["Mega"] = 15.75, ["Mega|Fly"] = 120.94, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 105.16}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.98}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.45, ["Fly"] = 23.62, ["Ride"] = 19.09, ["Fly|Ride"] = 40.06, ["Neon"] = 43.32, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 64.32, ["Neon"] = 2.63, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 157.58, ["Mega"] = 24.93, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 3.8, ["Neon|Ride"] = 36, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 31.5, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.44, ["Fly|Ride"] = 45.73, ["Neon"] = 6.57, ["Neon|Ride"] = 18.95, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 140.91, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 232.29}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.61, ["Fly"] = 28.41, ["Ride"] = 42.45, ["Fly|Ride"] = 57.75, ["Neon"] = 41.31, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 159.97, ["Mega|Ride"] = 352.26, ["Mega|Fly|Ride"] = 314.41}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.81, ["Mega"] = 20.79, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 64.16, ["Mega|Fly|Ride"] = 119.89}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.68, ["Fly|Ride"] = 34.28, ["Neon"] = 3.36, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 95.51, ["Mega"] = 25.76, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 37.86, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.63, ["Fly|Ride"] = 31.5, ["Neon"] = 5.04, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 34.11, ["Mega"] = 47.95, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 37.87, ["Fly|Ride"] = 128.52, ["Neon"] = 5.06, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 53.83, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 28.4, ["Neon|Fly|Ride"] = 153736.58, ["Mega"] = 22.32, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 39.98, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.59, ["Fly|Ride"] = 26.25, ["Neon"] = 2.63, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.69, ["Mega|Fly"] = 63.1, ["Mega|Ride"] = 36.98, ["Mega|Fly|Ride"] = 86.52}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 2.37, ["Neon|Ride"] = 39.98, ["Mega"] = 15.79, ["Mega|Ride"] = 133.77, ["Mega|Fly|Ride"] = 70.47}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.25, ["Mega|Ride"] = 189.29, ["Mega|Fly|Ride"] = 260.78}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 50.39, ["Neon"] = 4.08, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 42, ["Mega"] = 44.18, ["Mega|Fly"] = 45.23, ["Mega|Ride"] = 105.16, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.89, ["Ride"] = 59.06, ["Fly|Ride"] = 210.31, ["Neon"] = 126, ["Neon|Ride"] = 174.57, ["Mega"] = 420, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.8, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 6.33, ["Ride"] = 31.58, ["Fly|Ride"] = 178.77, ["Neon"] = 18.38, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 312.38, ["Mega|Ride"] = 450.06, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 1.93, ["Fly"] = 16.03, ["Ride"] = 15.23, ["Fly|Ride"] = 27.26, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 12, ["Neon|Fly|Ride"] = 24.34, ["Mega"] = 13.65, ["Mega|Fly"] = 18.16, ["Mega|Ride"] = 19.14, ["Mega|Fly|Ride"] = 39.51}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.93, ["Fly"] = 118.12, ["Ride"] = 58.9, ["Neon"] = 6.39, ["Neon|Fly"] = 67.32, ["Neon|Ride"] = 32.61, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 77.41, ["Mega|Ride"] = 140.95, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.44, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 12.48, ["Mega|Fly"] = 63.1, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 126.19}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 12.99, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.08, ["Ride"] = 16.49, ["Fly|Ride"] = 42.95, ["Neon"] = 13.02, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 37.99, ["Neon|Fly|Ride"] = 75.8, ["Mega"] = 169.32, ["Mega|Ride"] = 399.58, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 154.77, ["Ride"] = 196.64, ["Fly|Ride"] = 405.85, ["Neon"] = 919.02, ["Neon|Fly|Ride"] = 980, ["Mega"] = 8411.91, ["Mega|Ride"] = 3295.38, ["Mega|Fly|Ride"] = 3300.64}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 23.89, ["Neon"] = 8.06, ["Neon|Ride"] = 64.31, ["Mega"] = 68.16, ["Mega|Ride"] = 182.97, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.24, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 62.19, ["Neon"] = 32.34, ["Neon|Ride"] = 168.25, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 381.82, ["Mega|Ride"] = 524.7, ["Mega|Fly|Ride"] = 637.42}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 15.39, ["Fly|Ride"] = 32.8, ["Neon"] = 5.25, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 42.08, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 140.91}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 17.92, ["Fly|Ride"] = 92.59, ["Neon"] = 7.92, ["Neon|Ride"] = 60.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.47, ["Mega|Ride"] = 191, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 25.98, ["Ride"] = 14.35, ["Fly|Ride"] = 31.23, ["Neon"] = 21.05, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 28.4, ["Fly|Ride"] = 254.48, ["Neon"] = 45.21, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 319.17, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.6, ["Fly"] = 18.9, ["Ride"] = 16.09, ["Fly|Ride"] = 36.52, ["Neon"] = 23.42, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 36.24, ["Neon|Fly|Ride"] = 77.87, ["Mega"] = 262.5, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 50.22, ["Fly"] = 98.63, ["Ride"] = 84.13, ["Fly|Ride"] = 148.2, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 406.93, ["Mega|Fly|Ride"] = 1374.32}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 194.71, ["Fly"] = 420.6, ["Ride"] = 237.66, ["Fly|Ride"] = 280.76, ["Neon"] = 1193.63, ["Neon|Ride"] = 1121.96, ["Neon|Fly|Ride"] = 953.72, ["Mega"] = 10514.88, ["Mega|Fly|Ride"] = 4904.15}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.9, ["Fly"] = 140.91, ["Ride"] = 73.31, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 286.8, ["Mega"] = 1261.8, ["Mega|Ride"] = 1348.03, ["Mega|Fly|Ride"] = 1353.28}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 8.32, ["Fly"] = 42.08, ["Ride"] = 23, ["Fly|Ride"] = 65.63, ["Neon"] = 28.88, ["Neon|Ride"] = 121.99, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.3, ["Fly"] = 70.47, ["Ride"] = 20.57, ["Fly|Ride"] = 92.36, ["Neon"] = 81.38, ["Neon|Ride"] = 54.84, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 355.69, ["Mega|Ride"] = 278.33, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.22, ["Fly|Ride"] = 44.68, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 32.24, ["Mega|Fly"] = 145.63, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 370.32}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.38, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 81.2, ["Neon"] = 398.68, ["Neon|Fly"] = 351.21, ["Neon|Ride"] = 113.04, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 1837.5, ["Mega|Ride"] = 477.47, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.61, ["Fly|Ride"] = 35.6, ["Neon"] = 9.51, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 28.92, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 168.25, ["Mega|Ride"] = 175.42, ["Mega|Fly|Ride"] = 190.13}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 30.51, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.77, ["Mega"] = 182.97, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.68, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.16, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 18.38, ["Fly|Ride"] = 42.08, ["Neon"] = 15.61, ["Neon|Fly"] = 105.16, ["Neon|Ride"] = 28.79, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 159.95}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.15, ["Fly"] = 25.72, ["Ride"] = 18.52, ["Fly|Ride"] = 62.05, ["Neon"] = 15.78, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 238.71, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 93.4, ["Fly"] = 143.07, ["Ride"] = 131.01, ["Fly|Ride"] = 170.63, ["Neon"] = 521.07, ["Neon|Ride"] = 441.79, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4205.96, ["Mega|Ride"] = 2705.95, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.46, ["Ride"] = 40.6, ["Fly|Ride"] = 127.73, ["Neon"] = 37.49, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 267.09, ["Mega"] = 326.82, ["Mega|Ride"] = 421.89, ["Mega|Fly|Ride"] = 477.4}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.75, ["Fly|Ride"] = 36.74, ["Neon"] = 13.13, ["Neon|Ride"] = 27.33, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 238.74, ["Mega|Ride"] = 263.8, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.28, ["Ride"] = 58.01, ["Fly|Ride"] = 170.63, ["Neon"] = 130.29, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 587.52, ["Mega|Fly"] = 841.2, ["Mega|Ride"] = 685.16, ["Mega|Fly|Ride"] = 620.7}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.46}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 15.73, ["Ride"] = 28.84, ["Fly|Ride"] = 125.14, ["Neon"] = 46.96, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 119.38, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 420.6, ["Mega|Ride"] = 477.47, ["Mega|Fly|Ride"] = 876.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 20.98, ["Fly"] = 36.88, ["Ride"] = 26.48, ["Fly|Ride"] = 42.41, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.95, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 1357.48, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.27, ["Fly|Ride"] = 70.47, ["Neon"] = 3.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 106.54, ["Mega"] = 29.35, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 228.8}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 7.38, ["Fly"] = 28.41, ["Ride"] = 19.81, ["Fly|Ride"] = 39.38, ["Neon"] = 56.11, ["Neon|Ride"] = 63.1, ["Mega"] = 280.76, ["Mega|Fly"] = 398.68, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.33, ["Fly|Ride"] = 47.39, ["Neon"] = 19.21, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.29, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 138.9, ["Mega|Ride"] = 187.48, ["Mega|Fly|Ride"] = 265.75}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 210.31, ["Neon"] = 3.21, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 32.7, ["Mega"] = 27.36, ["Mega|Ride"] = 59.57, ["Mega|Fly|Ride"] = 121.78}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 22, ["Ride"] = 41.91, ["Fly|Ride"] = 68.25, ["Neon"] = 181.13, ["Neon|Ride"] = 209.68, ["Neon|Fly|Ride"] = 533.12, ["Mega"] = 787.5, ["Mega|Ride"] = 982.1, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.9, ["Fly"] = 28.41, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 94.75, ["Mega"] = 140.91, ["Mega|Ride"] = 336.49}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.24, ["Fly"] = 28.8, ["Ride"] = 19.69, ["Fly|Ride"] = 47.77, ["Neon"] = 21, ["Neon|Fly"] = 84.14, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 74.05, ["Mega"] = 283.91, ["Mega|Ride"] = 283.91, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.86, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.49, ["Neon"] = 367.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4458.17, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2523.59}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.37, ["Fly"] = 44.94, ["Ride"] = 20.9, ["Fly|Ride"] = 57.66, ["Neon"] = 35.78, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 85.05, ["Mega"] = 248.16, ["Mega|Ride"] = 204.02, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.24, ["Fly"] = 143.06, ["Ride"] = 98.85, ["Fly|Ride"] = 157.48, ["Neon"] = 262.4, ["Neon|Fly"] = 319.67, ["Neon|Ride"] = 246.65, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 941.1, ["Mega|Ride"] = 920.18, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.48, ["Ride"] = 42.61, ["Fly|Ride"] = 207.69, ["Neon"] = 80.54, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 315, ["Mega|Ride"] = 333.65, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.9, ["Fly"] = 41.36, ["Ride"] = 28.41, ["Fly|Ride"] = 70.13, ["Neon"] = 91.88, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 379.59, ["Mega"] = 210.31, ["Mega|Ride"] = 1577.24, ["Mega|Fly|Ride"] = 533.12}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.73, ["Fly"] = 69.42, ["Ride"] = 49.88, ["Fly|Ride"] = 159.95, ["Neon"] = 56.7, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 323.07, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 5.94, ["Ride"] = 29.89, ["Fly|Ride"] = 84.14, ["Neon"] = 32.44, ["Neon|Ride"] = 57.17, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 265.56, ["Mega|Ride"] = 245.33, ["Mega|Fly|Ride"] = 347.61}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 93.78, ["Neon|Ride"] = 99.9, ["Mega"] = 18.38, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.6, ["Ride"] = 58.47, ["Neon"] = 30.09, ["Neon|Ride"] = 182.93, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 227.75, ["Mega|Ride"] = 275.5, ["Mega|Fly|Ride"] = 415.35}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.09, ["Ride"] = 28.53, ["Neon"] = 28.77, ["Neon|Fly"] = 77.82, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 182.97, ["Mega"] = 182.97, ["Mega|Ride"] = 279.68, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.83, ["Ride"] = 32.8, ["Fly|Ride"] = 119.38, ["Neon"] = 30.51, ["Neon|Ride"] = 82.03, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 507.38, ["Ride"] = 531.42, ["Fly|Ride"] = 559.02, ["Neon"] = 1753.89, ["Neon|Ride"] = 1794.91, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.08, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 56.35, ["Neon"] = 41.03, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 183.75, ["Mega|Ride"] = 366.47, ["Mega|Fly|Ride"] = 348.06}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.09, ["Fly"] = 66.94, ["Ride"] = 16.95, ["Fly|Ride"] = 51.55, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 159.95, ["Mega"] = 331.87, ["Mega|Ride"] = 477.4, ["Mega|Fly|Ride"] = 374.35}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.31, ["Fly"] = 24.93, ["Ride"] = 20.24, ["Fly|Ride"] = 50.78, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.35, ["Fly|Ride"] = 73.62, ["Neon"] = 7.88, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 60.16, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 94.38, ["Mega|Fly|Ride"] = 217.34}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 22.31, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 222.93}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.42}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.02, ["Ride"] = 30.19, ["Fly|Ride"] = 328.08, ["Neon"] = 64.46, ["Neon|Ride"] = 85.32, ["Mega"] = 334.23, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 5.02, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 35.81, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 248.16}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.2, ["Fly"] = 28.02, ["Ride"] = 64.04, ["Neon"] = 19.69, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 203.44, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 1051.5}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 409.49, ["Ride"] = 414.23, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 2336.58, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8754, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.56, ["Fly"] = 196.88, ["Ride"] = 56.8, ["Fly|Ride"] = 420.6, ["Neon"] = 19.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 191, ["Mega"] = 386.96, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 732.9}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 93.12, ["Ride"] = 19.11, ["Fly|Ride"] = 118.13, ["Neon"] = 6.3, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 35.1, ["Mega|Fly"] = 144, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.74, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 31.91, ["Mega|Ride"] = 138.93, ["Mega|Fly|Ride"] = 389.13}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 20.34, ["Fly"] = 107.63, ["Ride"] = 42.74, ["Fly|Ride"] = 87.29, ["Neon"] = 191.6, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.17, ["Ride"] = 71.31, ["Neon"] = 82.03, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 477.47, ["Mega"] = 398.68, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 630.91}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.73, ["Ride"] = 70.47, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 652.93, ["Mega|Ride"] = 771.81, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.91, ["Ride"] = 23.86, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 242.91, ["Mega"] = 629.9, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 408.68, ["Fly|Ride"] = 510.88, ["Neon"] = 1706.25, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.12, ["Fly"] = 78.75, ["Ride"] = 26.25, ["Fly|Ride"] = 64.4, ["Neon"] = 84.14, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 140.91, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 865.39}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.71, ["Ride"] = 30.51, ["Fly|Ride"] = 127.32, ["Neon"] = 56.8, ["Neon|Ride"] = 221.82, ["Mega"] = 166.15, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 25.87, ["Ride"] = 80.64, ["Fly|Ride"] = 149.26, ["Neon"] = 78.66, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 314.79, ["Mega|Ride"] = 282.09, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.6, ["Ride"] = 42.08, ["Fly|Ride"] = 210.31, ["Neon"] = 7.4, ["Neon|Ride"] = 71.64, ["Neon|Fly|Ride"] = 272.35, ["Mega"] = 38.07, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 232.39}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 34.21, ["Ride"] = 90.44, ["Neon"] = 315, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 504.73, ["Mega"] = 1611.4, ["Mega|Ride"] = 2069.75, ["Mega|Fly|Ride"] = 1330.72}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.24, ["Fly|Ride"] = 196.88, ["Neon"] = 7.18, ["Neon|Fly"] = 182.97, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 58.94, ["Mega|Ride"] = 94.38, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 28.56, ["Fly|Ride"] = 98.89, ["Neon"] = 3.68, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 33.72, ["Mega|Fly"] = 112.21, ["Mega|Ride"] = 77.39, ["Mega|Fly|Ride"] = 183.96}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 127.62, ["Neon"] = 4.2, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 84, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 44.52, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 184.02, ["Neon"] = 248.98, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 477.47, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 210.37, ["Ride"] = 223.21, ["Fly|Ride"] = 418.5, ["Neon"] = 1461.58, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9548.95, ["Mega|Fly|Ride"] = 4767.46}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.18, ["Neon"] = 26.17, ["Neon|Fly"] = 350.44, ["Mega"] = 122.07, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.1, ["Fly|Ride"] = 159.95, ["Neon"] = 6.49, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 36.82, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 91.25, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.3, ["Fly"] = 26.25, ["Ride"] = 28.41, ["Fly|Ride"] = 91.88, ["Neon"] = 21.05, ["Mega"] = 140.91, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 30.35, ["Fly|Ride"] = 116.16, ["Neon"] = 17.43, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 138.79, ["Mega"] = 124.69, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 141.67, ["Mega|Fly|Ride"] = 343.86}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 9.01, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 26.04, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 36.82, ["Ride"] = 19.04, ["Fly|Ride"] = 52.49, ["Neon"] = 4.73, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 39.41, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 46.57, ["Neon"] = 15.18, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.68, ["Neon|Fly|Ride"] = 95.51, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 168.19}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 28.41, ["Ride"] = 32.44, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 318.47, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 74.84, ["Ride"] = 84.33, ["Fly|Ride"] = 139.12, ["Neon"] = 336.49, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1964.19, ["Mega|Ride"] = 1542.73, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.9, ["Fly|Ride"] = 144.38, ["Neon"] = 3.75, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 91.49, ["Mega|Fly|Ride"] = 246.06}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.64, ["Fly|Ride"] = 39.37, ["Neon"] = 3.62, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.06, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 125.14}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.05, ["Fly"] = 42.08, ["Ride"] = 28.77, ["Neon"] = 48.37, ["Neon|Ride"] = 135.19, ["Mega"] = 524.7, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4205.96, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 52.38, ["Fly"] = 98.85, ["Ride"] = 48.99, ["Fly|Ride"] = 84.36, ["Neon"] = 210.31, ["Neon|Ride"] = 175.88, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 670.84, ["Mega|Fly|Ride"] = 1273.61}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Fly|Ride"] = 281.33, ["Neon"] = 7.86, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 102.38, ["Mega|Ride"] = 140.97, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.62, ["Fly|Ride"] = 65.63, ["Neon"] = 41.82, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 314.41}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.94, ["Fly"] = 169.3, ["Ride"] = 37.58, ["Fly|Ride"] = 88.2, ["Neon"] = 194.25, ["Neon|Ride"] = 270.96, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 2523.59, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.34, ["Ride"] = 113.43, ["Fly|Ride"] = 205.06, ["Neon"] = 430.1, ["Neon|Ride"] = 477.47, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Ride"] = 210, ["Fly|Ride"] = 369.36, ["Neon"] = 1020.55, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3364.78}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 26.25, ["Ride"] = 61.6, ["Fly|Ride"] = 140.91, ["Neon"] = 85.19, ["Neon|Fly"] = 119.38, ["Neon|Ride"] = 88.73, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 420, ["Mega|Ride"] = 502.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 14.6, ["Fly|Ride"] = 43.31, ["Neon"] = 7.25, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 91.49, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 45.05, ["Ride"] = 15.43, ["Fly|Ride"] = 56.8, ["Neon"] = 31.4, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.04, ["Mega"] = 384.86, ["Mega|Ride"] = 409.42, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 355.32, ["Ride"] = 393.75, ["Fly|Ride"] = 637.42, ["Neon"] = 1549.42, ["Mega"] = 10094.3, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.61, ["Neon"] = 3.9, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.25, ["Mega|Ride"] = 170.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.7, ["Ride"] = 16.03, ["Fly|Ride"] = 39.37, ["Neon"] = 37.87, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 233.44, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 180.87, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.79, ["Ride"] = 47.77, ["Neon"] = 90.2, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 353.26, ["Mega"] = 459.37, ["Mega|Ride"] = 555.41, ["Mega|Fly|Ride"] = 636.91}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 91.77, ["Fly"] = 140.91, ["Ride"] = 109.52, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.67, ["Fly"] = 24.57, ["Ride"] = 25.4, ["Fly|Ride"] = 53.81, ["Neon"] = 126.19, ["Neon|Ride"] = 89.29, ["Neon|Fly|Ride"] = 134.19, ["Mega"] = 701.36, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 521.55}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.05, ["Neon"] = 2.5, ["Neon|Ride"] = 63, ["Mega"] = 25.53, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.54, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 82.04, ["Mega"] = 26.24, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.42, ["Ride"] = 56.41, ["Fly|Ride"] = 189.29, ["Neon"] = 32.44, ["Neon|Ride"] = 83.31, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 159.5, ["Mega|Ride"] = 191.55, ["Mega|Fly|Ride"] = 300.38}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Ride"] = 1155, ["Fly|Ride"] = 1311.19, ["Neon"] = 4376.12, ["Neon|Ride"] = 4205.96, ["Neon|Fly|Ride"] = 4346.87, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 412.02, ["Ride"] = 419.99, ["Fly|Ride"] = 560.44, ["Neon"] = 1663.2, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 16823.82, ["Mega|Fly|Ride"] = 7122.78}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 288.74, ["Fly"] = 414.21, ["Ride"] = 314.99, ["Fly|Ride"] = 420, ["Neon"] = 787.5, ["Neon|Fly"] = 1114.86, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 734.69, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 240.17, ["Fly"] = 336.49, ["Ride"] = 283.5, ["Fly|Ride"] = 367.4, ["Neon"] = 708.75, ["Neon|Ride"] = 603.73, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2963.1}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 14.21, ["Fly|Ride"] = 39.26, ["Neon"] = 3.94, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.54, ["Mega|Fly"] = 111.47, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 262.5, ["Fly"] = 393.27, ["Ride"] = 326.82, ["Fly|Ride"] = 446.25, ["Neon"] = 1311.22, ["Neon|Ride"] = 1244.98, ["Neon|Fly|Ride"] = 1114.32, ["Mega"] = 21310.51, ["Mega|Ride"] = 5047.16, ["Mega|Fly|Ride"] = 3927.32}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 5.54, ["Fly"] = 157.5, ["Ride"] = 112.53, ["Fly|Ride"] = 91.87, ["Neon"] = 23, ["Neon|Ride"] = 112.77, ["Neon|Fly|Ride"] = 252, ["Mega"] = 138.01, ["Mega|Ride"] = 279.46, ["Mega|Fly|Ride"] = 366.47}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.28, ["Fly|Ride"] = 38.98, ["Neon"] = 21.05, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.9, ["Mega|Ride"] = 192.94}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 3.94, ["Neon|Fly"] = 23.89, ["Neon|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.24, ["Ride"] = 52.59, ["Fly|Ride"] = 459.38, ["Neon"] = 238.74, ["Neon|Ride"] = 351.21, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7957.86, ["Ride"] = 26.25, ["Fly|Ride"] = 67.57, ["Neon"] = 21.05, ["Mega"] = 353.31, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.69, ["Mega|Ride"] = 69.42, ["Mega|Fly|Ride"] = 166.15}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.52, ["Fly"] = 41.02, ["Ride"] = 27.36, ["Fly|Ride"] = 65.63, ["Neon"] = 10.31, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 80.12, ["Mega"] = 136.49, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 236.54}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.14, ["Fly"] = 91.77, ["Ride"] = 18.95, ["Fly|Ride"] = 50.3, ["Neon"] = 35.77, ["Neon|Fly"] = 143.26, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 17.74, ["Ride"] = 63.1, ["Neon"] = 92.9, ["Neon|Ride"] = 182.97, ["Neon|Fly|Ride"] = 309.17, ["Mega"] = 317.52, ["Mega|Ride"] = 787.58}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6366.76, ["Ride"] = 19.69, ["Neon"] = 48.18, ["Neon|Fly"] = 48.57, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 328.13, ["Mega|Ride"] = 415.35, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 15.75, ["Fly|Ride"] = 45.83, ["Neon"] = 3.68, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 98.85, ["Mega"] = 45.94, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.96, ["Fly"] = 256.58, ["Ride"] = 131.25, ["Fly|Ride"] = 229.69, ["Neon"] = 840.15, ["Neon|Ride"] = 896.42, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8411.91, ["Mega|Fly|Ride"] = 3464.35}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.04, ["Ride"] = 13.84, ["Fly|Ride"] = 35.44, ["Neon"] = 3.9, ["Neon|Fly"] = 35.77, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 25.47, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.82, ["Ride"] = 42.57, ["Fly|Ride"] = 196.88, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 313.69, ["Mega|Fly"] = 796.17, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.1, ["Ride"] = 81.38, ["Fly|Ride"] = 170.63, ["Neon"] = 154.34, ["Neon|Ride"] = 355.68, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 786.19, ["Mega|Ride"] = 592.55, ["Mega|Fly|Ride"] = 841.2}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 184.59, ["Fly"] = 304.5, ["Ride"] = 242.17, ["Fly|Ride"] = 269.59, ["Neon"] = 796.23, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3448.9}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.59, ["Ride"] = 159.91, ["Fly|Ride"] = 143.26, ["Neon"] = 91.88, ["Neon|Ride"] = 210.31, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 336.49}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.72, ["Ride"] = 57.75, ["Fly|Ride"] = 182.97, ["Neon"] = 105.16, ["Neon|Fly"] = 159.95, ["Neon|Ride"] = 203.06, ["Neon|Fly|Ride"] = 152.09, ["Mega"] = 771.81, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 905.51, ["Ride"] = 929.86, ["Fly|Ride"] = 1036.87, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4625.51, ["Mega|Fly|Ride"] = 17507.98}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.09, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 93.12, ["Neon"] = 44.6, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 226.8, ["Mega|Ride"] = 209.26, ["Mega|Fly|Ride"] = 334.39}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.26, ["Fly"] = 78.75, ["Ride"] = 35.77, ["Fly|Ride"] = 53.65, ["Neon"] = 38.75, ["Neon|Ride"] = 83.08, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 521.55, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.14, ["Ride"] = 17.92, ["Fly|Ride"] = 94.65, ["Neon"] = 10.02, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 78.75, ["Mega|Ride"] = 318.78, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.68, ["Fly"] = 54.7, ["Ride"] = 39.38, ["Fly|Ride"] = 88.78, ["Neon"] = 66.94, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 437.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 456.36}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.47, ["Ride"] = 15.75, ["Fly|Ride"] = 51.1, ["Neon"] = 17.07, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 108.64, ["Mega"] = 133.55, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 125.14, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.57, ["Fly"] = 32.75, ["Ride"] = 26.15, ["Fly|Ride"] = 32.82, ["Neon"] = 11.46, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 196.64, ["Mega"] = 124.48, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 477.47}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Fly"] = 234.49, ["Ride"] = 262.5, ["Fly|Ride"] = 225.04, ["Neon"] = 911.66, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 28.25, ["Fly|Ride"] = 108.94, ["Neon"] = 6.19, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 72.82, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.6, ["Ride"] = 82.03, ["Fly|Ride"] = 88.86, ["Neon"] = 27.58, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.98, ["Fly"] = 98.87, ["Ride"] = 17.07, ["Neon"] = 10.15, ["Neon|Ride"] = 84.14, ["Mega"] = 94.35, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 75.78, ["Ride"] = 127.36, ["Fly|Ride"] = 315, ["Neon"] = 420.6, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 637.42, ["Mega"] = 2523.59, ["Mega|Ride"] = 4205.96, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.37, ["Fly"] = 90.76, ["Ride"] = 42.52, ["Fly|Ride"] = 252.37, ["Neon"] = 105, ["Neon|Ride"] = 204.01, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 634.33, ["Mega|Ride"] = 603.7, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.8, ["Fly"] = 57.49, ["Ride"] = 32.82, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 238.65, ["Mega"] = 501.34, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 439.24}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 477.4}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 40.42, ["Fly"] = 74.78, ["Ride"] = 77.84, ["Fly|Ride"] = 155.64, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 247.22, ["Neon|Fly|Ride"] = 286.78, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 6.03, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 125.14, ["Mega"] = 58.9, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.42, ["Fly"] = 108.64, ["Ride"] = 33.44, ["Fly|Ride"] = 95.7, ["Neon"] = 69.3, ["Neon|Ride"] = 78.8, ["Neon|Fly|Ride"] = 210, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 415.35}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.15, ["Fly"] = 203.34, ["Ride"] = 72.99, ["Fly|Ride"] = 155.56, ["Neon"] = 234.99, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 1365.9, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.59, ["Ride"] = 14.15, ["Fly|Ride"] = 28.84, ["Neon"] = 2.63, ["Neon|Fly"] = 24.2, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 15.65, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 123.37}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.63, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 20.37, ["Neon|Fly"] = 63.1, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 223.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.19, ["Ride"] = 40.51, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 451.98, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 630.91}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.68, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 208.21}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 23.62, ["Fly"] = 201.52, ["Ride"] = 68.21, ["Fly|Ride"] = 118.02, ["Neon"] = 74.72, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 642.1, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 524.35, ["Mega|Fly|Ride"] = 617.24}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.37, ["Fly"] = 42.08, ["Ride"] = 18.43, ["Fly|Ride"] = 98.44, ["Neon"] = 64.46, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.55, ["Ride"] = 46.78, ["Neon"] = 32.82, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 701.36, ["Mega"] = 231, ["Mega|Ride"] = 261.72, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.28, ["Fly"] = 72.19, ["Ride"] = 56.8, ["Fly|Ride"] = 196.88, ["Neon"] = 48.61, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.69, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 372.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.08, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 5.72, ["Neon|Ride"] = 32.61, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 277.61}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.3, ["Neon"] = 6.56, ["Mega"] = 21.95, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.31}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Fly"] = 98.85, ["Ride"] = 52.5, ["Fly|Ride"] = 80.07, ["Neon"] = 184.57, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1823.3, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Ride"] = 27.57, ["Mega"] = 18.38, ["Mega|Ride"] = 119.81, ["Mega|Fly|Ride"] = 315.46}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 477.47, ["Fly"] = 498.75, ["Ride"] = 561.75, ["Fly|Ride"] = 596.82, ["Neon"] = 2804.33, ["Neon|Ride"] = 1964.19, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 16823.82, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.83, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 66.26, ["Neon"] = 5.25, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 112.52, ["Mega"] = 94.56, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.92, ["Fly"] = 28.41, ["Ride"] = 21.05, ["Fly|Ride"] = 84.68, ["Neon"] = 19.36, ["Neon|Ride"] = 48.38, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 131.25, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 151.43, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.06, ["Fly"] = 70.47, ["Ride"] = 42.17, ["Fly|Ride"] = 70.82, ["Neon"] = 55.53, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 666.66, ["Mega|Ride"] = 558.35, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.68, ["Fly"] = 56.8, ["Ride"] = 38.57, ["Fly|Ride"] = 701.36, ["Neon"] = 17.33, ["Neon|Fly"] = 35.77, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Ride"] = 238.74, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.6, ["Ride"] = 94.65, ["Fly|Ride"] = 173.24, ["Neon"] = 64.6, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 376.45, ["Mega"] = 292.81, ["Mega|Ride"] = 377.93, ["Mega|Fly|Ride"] = 624.6}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.86, ["Fly"] = 105, ["Ride"] = 25.6, ["Fly|Ride"] = 91.88, ["Neon"] = 30.19, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 138.81, ["Mega"] = 262.5, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.77, ["Ride"] = 13.79, ["Fly|Ride"] = 75.72, ["Neon"] = 2.1, ["Neon|Fly"] = 23.15, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 75.72, ["Mega"] = 15.21, ["Mega|Fly"] = 64.46, ["Mega|Ride"] = 34.27, ["Mega|Fly|Ride"] = 70.47}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.55, ["Fly"] = 53.65, ["Ride"] = 39.38, ["Fly|Ride"] = 105.16, ["Neon"] = 28.77, ["Neon|Fly"] = 119.38, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 183.75, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 312.38, ["Ride"] = 318.6, ["Fly|Ride"] = 360.94, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9262.47, ["Mega|Fly|Ride"] = 4612.89}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 91.88, ["Ride"] = 111.57, ["Fly|Ride"] = 284.82, ["Neon"] = 356.57, ["Neon|Ride"] = 391.17, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 2243.9, ["Mega|Ride"] = 1794.91, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.44, ["Fly|Ride"] = 34.55, ["Neon"] = 5.24, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 33.67, ["Neon|Fly|Ride"] = 56.8, ["Mega"] = 56.8, ["Mega|Fly"] = 64.46, ["Mega|Ride"] = 104.11, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.63, ["Fly|Ride"] = 34.75, ["Neon"] = 5.25, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 56.33, ["Mega"] = 65.63, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 75.12, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 98.85, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 98.85, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 385.91, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 269.07, ["Ride"] = 234.94, ["Fly|Ride"] = 283.91, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1032.57, ["Mega|Ride"] = 8411.91, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.61, ["Fly"] = 23.15, ["Ride"] = 14.35, ["Fly|Ride"] = 40.6, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 29.94, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 255.93, ["Mega|Fly"] = 210.31, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.34, ["Ride"] = 77.97, ["Fly|Ride"] = 210.31, ["Neon"] = 26.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 196.88, ["Mega|Ride"] = 300.2, ["Mega|Fly|Ride"] = 450.06}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 84.42, ["Neon"] = 6.47, ["Neon|Ride"] = 156.02, ["Mega"] = 68.25, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 15.65, ["Fly"] = 47.77, ["Ride"] = 19.18, ["Fly|Ride"] = 103.06, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 140.84, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 45.82, ["Ride"] = 75.51, ["Fly|Ride"] = 280.76, ["Neon"] = 153.57, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 439.69, ["Mega|Fly"] = 2208.14, ["Mega|Ride"] = 467.46, ["Mega|Fly|Ride"] = 596.6}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 19.65, ["Fly"] = 62.05, ["Ride"] = 46.94, ["Fly|Ride"] = 84.14, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 306.01, ["Mega"] = 841.2, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 12.63, ["Ride"] = 15.64, ["Fly|Ride"] = 41.78, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 15.07, ["Neon|Fly|Ride"] = 35.77, ["Mega"] = 17.69, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 94.13}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 175.68, ["Fly"] = 257.83, ["Ride"] = 230.98, ["Fly|Ride"] = 272.9, ["Neon"] = 701.36, ["Neon|Ride"] = 911.66, ["Neon|Fly|Ride"] = 953.72, ["Mega|Fly|Ride"] = 3924.17}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.87, ["Fly"] = 65.63, ["Ride"] = 28.88, ["Fly|Ride"] = 104.99, ["Neon"] = 107.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 425.25, ["Mega|Ride"] = 431.81, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 18.74, ["Fly|Ride"] = 42.08, ["Neon"] = 5.24, ["Neon|Fly"] = 39.8, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 59.21, ["Mega|Ride"] = 84.14, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.56, ["Ride"] = 16.14, ["Fly|Ride"] = 52.5, ["Neon"] = 2.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 126.19, ["Mega"] = 22.45, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 62.62, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.93, ["Fly"] = 21, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 13.55, ["Neon|Fly"] = 716.19, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.37, ["Fly"] = 38.74, ["Ride"] = 20.99, ["Fly|Ride"] = 67.05, ["Neon"] = 50.02, ["Neon|Fly"] = 301.79, ["Neon|Ride"] = 55.12, ["Neon|Fly|Ride"] = 117.28, ["Mega"] = 355.59, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 354.89}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.2, ["Ride"] = 56.8, ["Fly|Ride"] = 72.19, ["Neon"] = 55.13, ["Neon|Fly|Ride"] = 315, ["Mega"] = 253.32, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 398.68}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 41.79, ["Neon"] = 2.5, ["Neon|Ride"] = 31.56, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 26.25, ["Mega|Ride"] = 83.47, ["Mega|Fly|Ride"] = 212.52}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.69, ["Fly"] = 28.88, ["Ride"] = 27.18, ["Fly|Ride"] = 131.25, ["Neon"] = 31.18, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 248.16, ["Mega|Ride"] = 211.98, ["Mega|Fly|Ride"] = 299.61}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 84.14, ["Neon"] = 3.5, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.35, ["Mega"] = 23.9, ["Mega|Ride"] = 104.12, ["Mega|Fly|Ride"] = 137.76}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.99, ["Ride"] = 17.64, ["Fly|Ride"] = 40.69, ["Neon"] = 3.74, ["Neon|Ride"] = 21.53, ["Neon|Fly|Ride"] = 106.55, ["Mega"] = 54.51, ["Mega|Fly"] = 140.91, ["Mega|Ride"] = 78.46, ["Mega|Fly|Ride"] = 140.84}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.12, ["Ride"] = 685.12, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Ride"] = 4889.43, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12573.58}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 15.33, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 27.01, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 9.21, ["Neon|Fly"] = 736.05, ["Neon|Ride"] = 114.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.09, ["Mega|Fly"] = 147.23, ["Mega|Ride"] = 138.81, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 11.7, ["Fly"] = 40.6, ["Ride"] = 23.12, ["Fly|Ride"] = 45.85, ["Neon"] = 42.08, ["Neon|Fly"] = 191, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.32, ["Fly|Ride"] = 41.98, ["Neon"] = 6.18, ["Neon|Fly"] = 147.23, ["Neon|Ride"] = 25.25, ["Neon|Fly|Ride"] = 55.55, ["Mega"] = 59.04, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 29.87, ["Fly"] = 105, ["Ride"] = 56.8, ["Fly|Ride"] = 280.76, ["Neon"] = 169.2, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 687.39, ["Mega|Ride"] = 617.24, ["Mega|Fly|Ride"] = 715.03}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 16.88, ["Fly|Ride"] = 64.36, ["Neon"] = 5.2, ["Neon|Fly"] = 130.67, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 131.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.17, ["Fly"] = 73.41, ["Ride"] = 23.31, ["Fly|Ride"] = 54.02, ["Neon"] = 9.87, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 70.47, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 157.74, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.65, ["Fly|Ride"] = 49.95, ["Neon"] = 3.8, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 111.2, ["Mega"] = 39.53, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 13.13, ["Fly"] = 19.69, ["Ride"] = 17.91, ["Fly|Ride"] = 39.36, ["Neon"] = 104.99, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 136.71, ["Mega|Ride"] = 460.57, ["Mega|Fly|Ride"] = 387.7}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 709.85, ["Fly"] = 890.63, ["Ride"] = 733.69, ["Fly|Ride"] = 861.84, ["Neon"] = 1823.3, ["Neon|Ride"] = 1548.72, ["Neon|Fly|Ride"] = 1911.21, ["Mega"] = 4654.13, ["Mega|Fly|Ride"] = 5188.05}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 17.98, ["Ride"] = 14.44, ["Fly|Ride"] = 37.68, ["Neon"] = 2.63, ["Neon|Fly"] = 35.77, ["Neon|Ride"] = 17.15, ["Neon|Fly|Ride"] = 28.41, ["Mega"] = 60.82, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 11.46, ["Ride"] = 32.81, ["Fly|Ride"] = 238.74, ["Neon"] = 48.57, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 398.68, ["Mega|Ride"] = 351.29, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 50.29, ["Fly"] = 104.9, ["Ride"] = 70.48, ["Fly|Ride"] = 105, ["Neon|Ride"] = 378.55, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 1682.4, ["Mega|Fly|Ride"] = 1647.21}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.06, ["Ride"] = 58.47, ["Fly|Ride"] = 104.9, ["Neon"] = 157.5, ["Neon|Ride"] = 220.83, ["Mega"] = 1273.61, ["Mega|Ride"] = 883.26, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.61, ["Ride"] = 26.23, ["Fly|Ride"] = 140.91, ["Neon"] = 56.8, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 147.16, ["Mega"] = 302.29, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.7, ["Ride"] = 52.59, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 310.21, ["Mega"] = 279.71, ["Mega|Fly"] = 518.04, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 318.72}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.48, ["Ride"] = 77.44, ["Neon"] = 120.65, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 733.95}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 17.26}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.88, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 71.52, ["Neon"] = 37.58, ["Neon|Ride"] = 40.22, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.27, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 234.49, ["Mega|Fly|Ride"] = 278.78}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.85, ["Neon"] = 10.48, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 133.55, ["Mega|Fly|Ride"] = 477.47}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 34.13, ["Fly"] = 126.19, ["Ride"] = 30.97, ["Fly|Ride"] = 78.87, ["Neon"] = 202.02, ["Neon|Ride"] = 167.2, ["Neon|Fly|Ride"] = 210.03, ["Mega"] = 843.91, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 733.68}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.61, ["Fly"] = 18.09, ["Ride"] = 15.89, ["Fly|Ride"] = 40.51, ["Neon"] = 18.8, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 198.19, ["Mega|Fly"] = 419.55, ["Mega|Ride"] = 144.89, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.69, ["Fly"] = 36.82, ["Ride"] = 27.54, ["Fly|Ride"] = 69.42, ["Neon"] = 14.44, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 143.26, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 140.91, ["Neon"] = 3.94, ["Mega"] = 52.4, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.27, ["Fly"] = 78.74, ["Ride"] = 49.93, ["Fly|Ride"] = 105, ["Neon"] = 210.31, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 314.41, ["Mega|Ride"] = 900.1, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 65.63, ["Neon"] = 3.8, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 49.43, ["Mega"] = 78.75, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.02, ["Ride"] = 79.98, ["Fly|Ride"] = 279.71, ["Neon"] = 59.82, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Ride"] = 430.5, ["Mega|Fly|Ride"] = 681.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 14.32, ["Fly|Ride"] = 41.91, ["Neon"] = 19.79, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 255.45}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 22.7, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 291.38, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.39, ["Ride"] = 73.7, ["Neon"] = 78.75, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 954.92, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 45.54, ["Ride"] = 132.38, ["Neon"] = 401.68, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 630}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.68, ["Ride"] = 108.04, ["Neon"] = 98.85, ["Neon|Ride"] = 183.75, ["Mega"] = 328.02, ["Mega|Ride"] = 378.55, ["Mega|Fly|Ride"] = 601.47}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.02, ["Ride"] = 125.98, ["Fly|Ride"] = 131.25, ["Neon"] = 63.39, ["Neon|Ride"] = 420.6, ["Mega|Ride"] = 840.15, ["Mega|Fly|Ride"] = 561.51}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.32, ["Ride"] = 69.57, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2102.99, ["Mega|Ride"] = 716.19, ["Mega|Fly|Ride"] = 739.19}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 13.13, ["Neon|Ride"] = 79.98, ["Mega"] = 180.87, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 318.72}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.36, ["Ride"] = 14.33, ["Fly|Ride"] = 42.08, ["Neon"] = 5.8, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 70.47, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 156.08}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.63, ["Fly"] = 50.48, ["Ride"] = 28.87, ["Fly|Ride"] = 69.57, ["Neon"] = 11.05, ["Neon|Ride"] = 88.34, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 84.52, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 15.75, ["Fly|Ride"] = 56.8, ["Neon"] = 5.25, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 47.16, ["Mega|Fly"] = 112.52, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 204.01}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.15, ["Fly|Ride"] = 118.13, ["Neon"] = 14.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 84.14, ["Mega"] = 252.35, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.13, ["Fly"] = 39.38, ["Ride"] = 24.39, ["Fly|Ride"] = 420.6, ["Neon"] = 28.4, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 298.64, ["Mega|Ride"] = 287.47}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.97, ["Fly"] = 131.25, ["Ride"] = 16, ["Fly|Ride"] = 71.31, ["Neon"] = 19.37, ["Neon|Fly"] = 112.52, ["Neon|Ride"] = 28.26, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 262.5, ["Mega|Ride"] = 252, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 19.38, ["Fly|Ride"] = 49.88, ["Neon"] = 15.75, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 189, ["Mega"] = 252.37, ["Mega|Ride"] = 148.25, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.93, ["Fly"] = 63, ["Ride"] = 44.01, ["Fly|Ride"] = 91.88, ["Neon"] = 8.71, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 46.54, ["Neon|Fly|Ride"] = 127.73, ["Mega"] = 112.21, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 128.41, ["Mega|Fly|Ride"] = 225.04}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 30.18, ["Fly"] = 210.31, ["Ride"] = 108.94, ["Fly|Ride"] = 375.16, ["Neon"] = 136.39, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 459.38, ["Mega|Ride"] = 566.2, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 38.21, ["Fly"] = 164.07, ["Ride"] = 77.82, ["Fly|Ride"] = 180.87, ["Neon"] = 200.49, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1318.57, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.24, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.93, ["Mega|Ride"] = 47.66, ["Mega|Fly|Ride"] = 145.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.53, ["Ride"] = 52.5, ["Mega"] = 686.56, ["Mega|Ride"] = 672.97, ["Mega|Fly|Ride"] = 1048.35}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 42.68, ["Ride"] = 72.19, ["Neon"] = 314.04, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 840.15, ["Mega"] = 1724.45, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1365.9}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.99, ["Fly"] = 190.32, ["Ride"] = 27.45, ["Fly|Ride"] = 133.88, ["Neon"] = 40.26, ["Neon|Fly"] = 127.73, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 161.44, ["Mega|Ride"] = 225.04, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.25, ["Ride"] = 68.8, ["Neon"] = 11.46, ["Neon|Ride"] = 58.69, ["Neon|Fly|Ride"] = 168.25, ["Mega"] = 106.42, ["Mega|Ride"] = 146.28, ["Mega|Fly|Ride"] = 420.61}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 25.76, ["Ride"] = 15.65, ["Fly|Ride"] = 56.8, ["Neon"] = 7.88, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 159.87, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 127.73, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 15.06, ["Fly|Ride"] = 41.91, ["Neon"] = 2.62, ["Neon|Fly"] = 29.61, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 46.1, ["Neon"] = 3.9, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.37, ["Mega|Fly"] = 103.45, ["Mega|Ride"] = 47.77, ["Mega|Fly|Ride"] = 182.97}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 145.07, ["Mega"] = 28.23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.2, ["Ride"] = 157.5, ["Neon"] = 35.93, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 183.01, ["Mega|Fly|Ride"] = 318.72}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.29, ["Ride"] = 34.12, ["Fly|Ride"] = 210.31, ["Neon"] = 53.62, ["Neon|Ride"] = 98.85, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.04, ["Fly"] = 20.58, ["Ride"] = 16.97, ["Fly|Ride"] = 37.86, ["Neon"] = 30.08, ["Neon|Fly"] = 57.3, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 82.37, ["Mega"] = 311.07, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 351.32}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 60.17, ["Ride"] = 159.95, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 561.51, ["Mega"] = 2387.25, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.74, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 84.14, ["Neon"] = 132.5, ["Neon|Fly|Ride"] = 630, ["Mega"] = 637.42, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 701.36}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 14.85, ["Ride"] = 15.65, ["Fly|Ride"] = 38, ["Neon"] = 2.1, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 32.24, ["Mega|Ride"] = 91.58, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 14.23, ["Fly|Ride"] = 35.15, ["Neon"] = 4.09, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 19.79, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 36.75, ["Mega|Fly"] = 120.94, ["Mega|Ride"] = 69.44, ["Mega|Fly|Ride"] = 91.77}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Ride"] = 439.68, ["Fly|Ride"] = 485, ["Neon|Fly|Ride"] = 1871.66}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.82, ["Fly"] = 105.16, ["Ride"] = 56.8, ["Fly|Ride"] = 112.52, ["Neon"] = 39.04, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 159.95, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 13.95, ["Fly|Ride"] = 32.16, ["Neon"] = 10.31, ["Neon|Fly"] = 18.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 49.43, ["Mega|Ride"] = 74.67, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.65, ["Ride"] = 94.02, ["Fly|Ride"] = 261.19, ["Neon"] = 231.2, ["Neon|Ride"] = 322.1, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 735, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 871.58}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.52, ["Fly"] = 19.69, ["Ride"] = 14.81, ["Fly|Ride"] = 46.11, ["Neon"] = 10.39, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 113.4, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 31.5, ["Fly|Ride"] = 196.88, ["Neon"] = 2.24, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 74.76, ["Mega"] = 8.43, ["Mega|Ride"] = 70.47, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.32, ["Fly"] = 126.47, ["Ride"] = 78.71, ["Fly|Ride"] = 213.56, ["Neon"] = 160.13, ["Neon|Ride"] = 157.29, ["Neon|Fly|Ride"] = 420.66, ["Mega"] = 796.17, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.49}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.06, ["Fly|Ride"] = 146.99, ["Neon"] = 6.61, ["Neon|Ride"] = 39.98, ["Neon|Fly|Ride"] = 77.82, ["Mega"] = 25.99, ["Mega|Ride"] = 150.64, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.3, ["Ride"] = 69.45, ["Fly|Ride"] = 119.89, ["Neon"] = 336.49, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1661.36, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.29, ["Fly"] = 70.47, ["Ride"] = 131.24, ["Fly|Ride"] = 420.6, ["Neon"] = 17.06, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 491.07, ["Mega"] = 170.63, ["Mega|Ride"] = 189.29, ["Mega|Fly|Ride"] = 315.46}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 72.76, ["Fly|Ride"] = 70.47, ["Neon"] = 6.57, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.73, ["Mega"] = 103.06, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 42.92, ["Fly"] = 140.91, ["Ride"] = 56.82, ["Fly|Ride"] = 131.25, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1954.74}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 425.72, ["Ride"] = 38.07, ["Neon"] = 4.73, ["Neon|Ride"] = 40.71, ["Neon|Fly|Ride"] = 156.38, ["Mega"] = 41.91, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 106.89, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 19.2, ["Fly|Ride"] = 102.87, ["Neon"] = 10.07, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 56.8, ["Mega"] = 159.95, ["Mega|Fly"] = 146.83, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.07, ["Fly"] = 58.5, ["Ride"] = 32.4, ["Fly|Ride"] = 104.11, ["Neon"] = 79.37, ["Neon|Ride"] = 84.14, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 300.46, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.17, ["Ride"] = 28.41, ["Fly|Ride"] = 70.56, ["Neon"] = 61.68, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 60.48, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 477.4, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 553.9}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 24.6, ["Fly"] = 28.41, ["Ride"] = 27.57, ["Fly|Ride"] = 53.34, ["Neon"] = 74.28, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 121.99, ["Mega"] = 391.17, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 390.17}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 58.69, ["Ride"] = 112.52, ["Fly|Ride"] = 210.31, ["Neon"] = 346.48, ["Neon|Ride"] = 280.76, ["Neon|Fly|Ride"] = 557.44, ["Mega|Ride"] = 1486.82, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.39, ["Fly"] = 21, ["Ride"] = 65.94, ["Neon"] = 52.37, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 234.31, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 412.2}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.67, ["Ride"] = 26.99, ["Fly|Ride"] = 70.47, ["Neon"] = 19.09, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 163, ["Mega|Ride"] = 182.97, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.56, ["Fly"] = 287.55, ["Ride"] = 28.75, ["Fly|Ride"] = 155.36, ["Neon"] = 41.03, ["Neon|Ride"] = 104.9, ["Mega"] = 446.42, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 732.9}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.54, ["Fly|Ride"] = 37.97, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 13.2, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 12.9, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 95.75}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 46.4, ["Ride"] = 112.56, ["Fly|Ride"] = 280.76, ["Neon"] = 236.24, ["Neon|Fly"] = 2383.74, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1050.45, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 140.91, ["Neon"] = 4.75, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 18.42, ["Fly|Ride"] = 59.06, ["Neon"] = 19.49, ["Neon|Ride"] = 27.47, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 257.25, ["Mega|Ride"] = 155.64, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 52.58, ["Ride"] = 90.44, ["Fly|Ride"] = 223.21, ["Neon"] = 242.82, ["Neon|Fly"] = 304.96, ["Neon|Ride"] = 261.19, ["Mega"] = 940.74, ["Mega|Ride"] = 1355.96, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.36, ["Neon"] = 5.3, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 65.19, ["Mega"] = 68.25, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.91}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 490.01, ["Neon"] = 6.57, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 42.86, ["Mega|Ride"] = 98.85, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 124.57, ["Ride"] = 162.92, ["Fly|Ride"] = 351.21, ["Neon"] = 701.36, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 796.17, ["Mega"] = 3364.78, ["Mega|Fly|Ride"] = 2660.27}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.37, ["Ride"] = 36.47, ["Fly|Ride"] = 210.31, ["Neon"] = 20.26, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 99.46, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 168.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.77, ["Neon"] = 2.1, ["Neon|Ride"] = 20.86, ["Mega"] = 31.4, ["Mega|Ride"] = 56.8, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.84, ["Fly"] = 39.38, ["Ride"] = 21.76, ["Fly|Ride"] = 49.88, ["Neon"] = 53.37, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 159.95, ["Mega"] = 406.93, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 625.65}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.61, ["Fly"] = 42.27, ["Ride"] = 21.05, ["Fly|Ride"] = 56.58, ["Neon"] = 72.19, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.8, ["Mega|Ride"] = 588.84, ["Mega|Fly|Ride"] = 398.68}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.91, ["Ride"] = 58.93, ["Fly|Ride"] = 196.64, ["Neon"] = 132.96, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 477.47, ["Mega"] = 560.44, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 100.77, ["Fly"] = 196.77, ["Ride"] = 140.91, ["Fly|Ride"] = 210.38, ["Neon"] = 565.13, ["Neon|Fly"] = 841.2, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 656.15, ["Mega|Ride"] = 2523.59, ["Mega|Fly|Ride"] = 2762.27}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.22, ["Fly"] = 17.46, ["Ride"] = 17.07, ["Fly|Ride"] = 43.67, ["Neon"] = 38.07, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 75.41, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 336.49}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.41, ["Fly"] = 131.23, ["Ride"] = 16.93, ["Fly|Ride"] = 131.24, ["Neon"] = 15.44, ["Neon|Ride"] = 32.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 138.81, ["Mega|Ride"] = 137.76, ["Mega|Fly|Ride"] = 398.68}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.34, ["Fly"] = 98.44, ["Ride"] = 36.74, ["Fly|Ride"] = 91.88, ["Neon"] = 48.54, ["Neon|Ride"] = 68.79, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.12, ["Fly"] = 98.85, ["Ride"] = 70.87, ["Fly|Ride"] = 157.99, ["Neon"] = 202.13, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 224.89, ["Mega"] = 954.19, ["Mega|Ride"] = 911.66, ["Mega|Fly|Ride"] = 1038.78}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.18, ["Fly"] = 57.75, ["Ride"] = 63.1, ["Neon"] = 105, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 463.73, ["Mega"] = 701.32, ["Mega|Ride"] = 584.99, ["Mega|Fly|Ride"] = 1120.9}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.77, ["Ride"] = 477.47, ["Neon|Ride"] = 3183.39, ["Mega|Fly|Ride"] = 5551.87}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 20.79, ["Fly"] = 35.07, ["Ride"] = 31.56, ["Fly|Ride"] = 50.4, ["Neon"] = 419.55, ["Neon|Ride"] = 141.69, ["Neon|Fly|Ride"] = 318.72, ["Mega"] = 761.25, ["Mega|Ride"] = 730.96, ["Mega|Fly|Ride"] = 1034.88}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.11, ["Ride"] = 13.7, ["Fly|Ride"] = 42.29, ["Neon"] = 2.1, ["Neon|Ride"] = 15.17, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 10.53, ["Mega|Fly"] = 103.06, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.41, ["Neon"] = 8.97, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 138.81, ["Mega"] = 140.91, ["Mega|Ride"] = 109.19, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 25.99, ["Fly|Ride"] = 144.21, ["Neon"] = 19.56, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 981.05, ["Mega"] = 121.7, ["Mega|Fly"] = 491.07, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 423.94, ["Fly"] = 491.07, ["Ride"] = 405.84, ["Fly|Ride"] = 463.73, ["Neon"] = 1524.67, ["Neon|Ride"] = 3154.48, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 5188.05}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.15, ["Fly|Ride"] = 61, ["Neon"] = 22.94, ["Neon|Ride"] = 26.46, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 183.54, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 252.37}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.94, ["Fly"] = 20, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 16.96, ["Neon|Fly"] = 32.61, ["Neon|Ride"] = 58.9, ["Neon|Fly|Ride"] = 89.04, ["Mega|Ride"] = 277.61, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.19, ["Fly"] = 41.91, ["Ride"] = 21.26, ["Fly|Ride"] = 84.14, ["Neon"] = 11.82, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 107.33, ["Mega"] = 104.74, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 25.94, ["Fly"] = 47.77, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.64, ["Neon|Fly|Ride"] = 314.41, ["Mega"] = 561.51, ["Mega|Ride"] = 841.2, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 52.59, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 9.19, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1009.44}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.86, ["Fly"] = 65.6, ["Ride"] = 27.12, ["Fly|Ride"] = 96.5, ["Neon"] = 168.9, ["Neon|Ride"] = 109.75, ["Neon|Fly|Ride"] = 289.17, ["Mega|Ride"] = 771.81}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 3.76, ["Neon|Ride"] = 140.91, ["Mega"] = 51.1, ["Mega|Ride"] = 119.89, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.23, ["Ride"] = 140.91, ["Neon"] = 50.79, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.39, ["Ride"] = 86.24, ["Neon"] = 89.43, ["Neon|Ride"] = 477.47, ["Mega"] = 310.21, ["Mega|Ride"] = 582.49, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.53, ["Fly"] = 26.01, ["Ride"] = 24.46, ["Fly|Ride"] = 48.37, ["Neon"] = 34.23, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 54.35, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 561.01, ["Mega|Ride"] = 310.21, ["Mega|Fly|Ride"] = 293.29}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.49, ["Fly"] = 590.85, ["Ride"] = 393.27, ["Fly|Ride"] = 429.09, ["Neon"] = 1642.41, ["Neon|Ride"] = 1573.51, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 7430.88}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.54, ["Fly|Ride"] = 50.48, ["Neon"] = 15.65, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 32.28, ["Mega"] = 210.31, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 299.61}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.86, ["Fly"] = 112.52, ["Ride"] = 45.85, ["Fly|Ride"] = 131.25, ["Neon"] = 82.29, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 281.81, ["Mega"] = 351.21, ["Mega|Fly"] = 701.36, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 495.36}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 19.52, ["Fly"] = 118.13, ["Ride"] = 68.64, ["Fly|Ride"] = 276.52, ["Neon"] = 87.72, ["Neon|Ride"] = 152.91, ["Neon|Fly|Ride"] = 414.21, ["Mega"] = 422.63, ["Mega|Ride"] = 356.03, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 44.08, ["Fly"] = 146.86, ["Ride"] = 70.26, ["Fly|Ride"] = 169.31, ["Neon"] = 320.25, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.62, ["Mega"] = 2492.09, ["Mega|Ride"] = 1893.05, ["Mega|Fly|Ride"] = 1668.73}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.5, ["Fly"] = 105.16, ["Ride"] = 56.8, ["Fly|Ride"] = 127.73, ["Neon"] = 32.81, ["Neon|Ride"] = 104.2, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 140.91, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 446.15}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 13.02, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 4.69, ["Ride"] = 39.38, ["Neon"] = 19.69, ["Neon|Ride"] = 104.11, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 88.34, ["Mega|Fly|Ride"] = 292.9}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.69, ["Fly"] = 137.82, ["Ride"] = 65.44, ["Fly|Ride"] = 210.97, ["Neon"] = 108.32, ["Neon|Fly"] = 156.19, ["Neon|Ride"] = 141.26, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 396.81, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 6.56, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 199.35, ["Mega"] = 47.77, ["Mega|Fly"] = 159.95, ["Mega|Ride"] = 168.93}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 35.43, ["Ride"] = 210.31, ["Neon"] = 141.75, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 841.2, ["Mega"] = 525, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1017.19, ["Fly"] = 1004.07, ["Ride"] = 1018.5, ["Fly|Ride"] = 1093.56, ["Neon|Ride"] = 3617.14, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 10235.19}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.81, ["Fly"] = 112.25, ["Ride"] = 56.8, ["Fly|Ride"] = 140.91, ["Neon"] = 54.7, ["Neon|Fly"] = 700.31, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 420.6, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 21.3, ["Fly|Ride"] = 86.92, ["Neon"] = 10.22, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 69.77, ["Mega|Ride"] = 73.56, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.65, ["Ride"] = 56.8, ["Fly|Ride"] = 140.91, ["Neon"] = 55.37, ["Neon|Fly"] = 83.08, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 236.25, ["Mega|Ride"] = 545.74, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 182.97, ["Neon"] = 2.63, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 16.19, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 15.54, ["Mega|Ride"] = 38.18, ["Mega|Fly|Ride"] = 176.54}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.97, ["Ride"] = 96.87, ["Fly|Ride"] = 236.23, ["Neon"] = 230.15, ["Neon|Ride"] = 250.69, ["Neon|Fly|Ride"] = 358.83, ["Mega"] = 918.75, ["Mega|Ride"] = 953.72, ["Mega|Fly|Ride"] = 913.23}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.75, ["Ride"] = 62.91, ["Fly|Ride"] = 277.99, ["Neon"] = 83.91, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 561.51, ["Mega|Ride"] = 559.41, ["Mega|Fly|Ride"] = 628.81}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 6.04, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 463.73}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 32.16, ["Fly"] = 52.5, ["Ride"] = 32.24, ["Fly|Ride"] = 111.47, ["Neon"] = 50.96, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 415.35, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 8.28, ["Fly"] = 32.61, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 119.44, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 126.47, ["Mega"] = 309.66, ["Mega|Ride"] = 525.75, ["Mega|Fly|Ride"] = 477.47}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 22.68, ["Ride"] = 208.69, ["Neon"] = 163, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2102.99, ["Mega|Ride"] = 1682.4, ["Mega|Fly|Ride"] = 1682.4}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.75, ["Ride"] = 48.27, ["Fly|Ride"] = 184.11, ["Neon"] = 14.34, ["Neon|Ride"] = 68.04, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 113.4, ["Mega|Ride"] = 98.85, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.15, ["Ride"] = 19.69, ["Fly|Ride"] = 89.25, ["Neon"] = 73.62, ["Neon|Fly"] = 182.97, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 116.72, ["Mega"] = 295.32, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 672.97}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 97.18, ["Fly"] = 393.75, ["Ride"] = 167.61, ["Fly|Ride"] = 264.47, ["Neon"] = 441, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 452.23, ["Neon|Fly|Ride"] = 644.18, ["Mega|Fly|Ride"] = 1945.79}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 14.76, ["Fly|Ride"] = 55.04, ["Neon"] = 11.02, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 83.08, ["Mega"] = 145.69, ["Mega|Ride"] = 238.71, ["Mega|Fly|Ride"] = 206.28}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 15.25, ["Fly"] = 200.81, ["Ride"] = 39.38, ["Fly|Ride"] = 116.82, ["Neon"] = 82.25, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.74, ["Mega|Fly|Ride"] = 522.37}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 13.13, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 39.63, ["Mega"] = 15.63, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.8, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 130.39, ["Mega"] = 22.32, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.81}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.77, ["Ride"] = 23.65, ["Fly|Ride"] = 133.88, ["Neon"] = 11.88, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 85.32, ["Mega|Ride"] = 267.09, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.81, ["Ride"] = 54.7, ["Fly|Ride"] = 131.25, ["Neon"] = 181.73, ["Neon|Ride"] = 336.49, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 715.03}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.65, ["Fly|Ride"] = 35.53, ["Neon"] = 11.7, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 28.3, ["Neon|Fly|Ride"] = 55.19, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.63, ["Fly"] = 29.89, ["Ride"] = 23.63, ["Fly|Ride"] = 52.59, ["Neon"] = 28.48, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 112.25, ["Mega"] = 229.59, ["Mega|Fly"] = 280.76, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 303.09}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 33.86, ["Ride"] = 18.09, ["Fly|Ride"] = 71.52, ["Neon"] = 8.87, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 77.82, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 125.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.46, ["Fly"] = 158.8, ["Ride"] = 23.05, ["Fly|Ride"] = 217.19, ["Neon"] = 37.29, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 225.12, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 377.5, ["Mega|Fly|Ride"] = 439.26}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.76, ["Fly"] = 42.08, ["Ride"] = 36.75, ["Neon"] = 65.63, ["Neon|Ride"] = 144.38, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 982.1}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.94, ["Fly"] = 19.59, ["Ride"] = 18.4, ["Fly|Ride"] = 49.01, ["Neon"] = 21.95, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 104.11, ["Mega"] = 262.49, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 491.07}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.63, ["Fly"] = 16.8, ["Ride"] = 12.6, ["Fly|Ride"] = 52.45, ["Neon"] = 16.78, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 27.22, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 184.02, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 140.91}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 191.35, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1051.5, ["Neon|Ride"] = 1121.96, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4137.61}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.81, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 420.6, ["Mega"] = 122.07, ["Mega|Ride"] = 420.72, ["Mega|Fly|Ride"] = 351.21}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.15, ["Fly"] = 104.9, ["Ride"] = 22.58, ["Fly|Ride"] = 84.14, ["Neon"] = 23.39, ["Neon|Ride"] = 58.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 207.69, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 486.97}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.23, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 222.93, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.54, ["Mega|Ride"] = 378.55, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.16, ["Ride"] = 14.99, ["Fly|Ride"] = 30.73, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.57, ["Mega"] = 18.21, ["Mega|Fly"] = 77.82, ["Mega|Ride"] = 40.85, ["Mega|Fly|Ride"] = 88.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 8.42, ["Fly"] = 26.24, ["Ride"] = 15.8, ["Fly|Ride"] = 46.28, ["Neon"] = 13.34, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 100, ["Mega"] = 116.94, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 140.91, ["Neon"] = 8.13, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.47, ["Fly"] = 105, ["Ride"] = 99.64, ["Fly|Ride"] = 158.36, ["Neon"] = 381.97, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 450.06, ["Mega|Ride"] = 3506.72, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.66, ["Fly"] = 94.5, ["Ride"] = 26.23, ["Fly|Ride"] = 98.85, ["Neon"] = 5.35, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 357.53}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.37, ["Fly"] = 21, ["Ride"] = 34.12, ["Neon"] = 5.16, ["Neon|Ride"] = 79.98, ["Neon|Fly|Ride"] = 535.96, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.05, ["Fly"] = 210, ["Ride"] = 65.63, ["Fly|Ride"] = 185.08, ["Neon"] = 147, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 271.3, ["Mega"] = 590.63, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 14, ["Fly|Ride"] = 31.95, ["Neon"] = 2.1, ["Neon|Fly"] = 16.69, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 31.06, ["Mega"] = 13.13, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 105.16, ["Neon"] = 2.62, ["Neon|Ride"] = 42.08, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 23.88, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 176.06}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.12, ["Ride"] = 47.16, ["Neon"] = 10.1, ["Neon|Fly"] = 51.19, ["Neon|Ride"] = 88.34, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 53.19, ["Mega|Fly"] = 182.97, ["Mega|Ride"] = 139.02, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 8.11, ["Fly"] = 80.07, ["Ride"] = 50.18, ["Fly|Ride"] = 91.88, ["Neon"] = 17.92, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 88.27, ["Neon|Fly|Ride"] = 134.61, ["Mega"] = 104.68, ["Mega|Fly"] = 342.59, ["Mega|Ride"] = 171.39, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.6, ["Ride"] = 14.11, ["Fly|Ride"] = 32.24, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 44.35, ["Mega"] = 18.17, ["Mega|Ride"] = 62.05, ["Mega|Fly|Ride"] = 78.4}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.76, ["Fly"] = 131.25, ["Ride"] = 45.94, ["Neon"] = 129.94, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 499.47, ["Mega|Ride"] = 588.99, ["Mega|Fly|Ride"] = 732.9}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 3150, ["Ride"] = 2208.93, ["Fly|Ride"] = 2362.5, ["Neon"] = 10514.88, ["Neon|Fly|Ride"] = 9394.01, ["Mega|Fly|Ride"] = 42058.46}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.65, ["Fly|Ride"] = 33.67, ["Neon"] = 8.95, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 57.65, ["Mega"] = 78.1, ["Mega|Fly"] = 420.6, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 8.3, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.95, ["Mega|Fly|Ride"] = 280.76}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.38, ["Fly"] = 42.08, ["Ride"] = 25.09, ["Fly|Ride"] = 119.38, ["Neon"] = 73.47, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 459.38, ["Mega|Ride"] = 393.65, ["Mega|Fly|Ride"] = 380.52}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.12, ["Fly"] = 90.44, ["Ride"] = 60.67, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 408.66, ["Mega|Ride"] = 419.55, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 150.93, ["Fly"] = 210.31, ["Ride"] = 142.42, ["Fly|Ride"] = 210.31, ["Neon"] = 1312.5, ["Neon|Ride"] = 714.65, ["Neon|Fly|Ride"] = 686.98, ["Mega"] = 6308.94, ["Mega|Fly|Ride"] = 3660.84}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.57, ["Ride"] = 32.61, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 83.68, ["Neon|Fly|Ride"] = 155.18, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 223.21, ["Mega|Fly|Ride"] = 357.53}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.25, ["Ride"] = 35.44, ["Neon"] = 26.25, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 144.38, ["Ride"] = 26.24, ["Fly|Ride"] = 131.25, ["Neon"] = 6.47, ["Neon|Fly"] = 91.49, ["Neon|Ride"] = 40.04, ["Neon|Fly|Ride"] = 208.21, ["Mega"] = 48.38, ["Mega|Ride"] = 103.59, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.8, ["Ride"] = 84.14, ["Fly|Ride"] = 91.88, ["Neon"] = 98.44, ["Neon|Ride"] = 172.47, ["Neon|Fly|Ride"] = 495.27, ["Mega"] = 381.97, ["Mega|Ride"] = 463.73, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.08, ["Neon"] = 2.24, ["Neon|Ride"] = 33.67, ["Mega"] = 18.95, ["Mega|Fly"] = 119.38, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 104.9, ["Ride"] = 104.9, ["Fly|Ride"] = 140.91, ["Neon"] = 301.46, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 399.58, ["Neon|Fly|Ride"] = 296.22, ["Mega"] = 3154.48, ["Mega|Fly|Ride"] = 1676.09}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 91.83, ["Neon"] = 3.57, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 210.31, ["Mega"] = 70.88, ["Mega|Ride"] = 279.71, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.75, ["Fly"] = 100.95, ["Ride"] = 62.99, ["Fly|Ride"] = 185.4, ["Neon"] = 243.14, ["Neon|Ride"] = 252.37, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 3575.07}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 21.06, ["Fly|Ride"] = 51.35, ["Neon"] = 3.56, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210.31}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Fly|Ride"] = 104.01, ["Neon"] = 9.85, ["Neon|Ride"] = 98.44, ["Mega"] = 106.32, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 520.5}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.76, ["Fly"] = 77.43, ["Ride"] = 32.61, ["Neon"] = 23.63, ["Neon|Ride"] = 86.52, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 315, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 559.41}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 353.07, ["Ride"] = 391.84, ["Fly|Ride"] = 465.49, ["Neon"] = 971.25, ["Neon|Ride"] = 964.68, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3223.88, ["Mega|Ride"] = 2802.19, ["Mega|Fly|Ride"] = 2728.3}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 28.88, ["Fly"] = 56.8, ["Ride"] = 44.77, ["Fly|Ride"] = 126.93, ["Neon"] = 161.44, ["Neon|Ride"] = 209.26, ["Neon|Fly|Ride"] = 267.09, ["Mega"] = 1400.6, ["Mega|Ride"] = 1121.96, ["Mega|Fly|Ride"] = 1682.4}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.58, ["Fly|Ride"] = 84.14, ["Neon"] = 12.5, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 98.15, ["Mega"] = 128.24, ["Mega|Ride"] = 196.64, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 22.19, ["Fly"] = 37.71, ["Ride"] = 49.87, ["Fly|Ride"] = 163, ["Neon"] = 70.14, ["Neon|Fly"] = 159.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 186.27, ["Mega"] = 249.38, ["Mega|Fly"] = 982.36, ["Mega|Ride"] = 378.55, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.77, ["Ride"] = 25.8, ["Neon"] = 101.35, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 252.37, ["Mega"] = 420.6, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.63, ["Neon"] = 19.29, ["Neon|Fly"] = 72.19, ["Mega"] = 91.59, ["Mega|Ride"] = 314.41, ["Mega|Fly|Ride"] = 342.8}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.25, ["Fly"] = 70.88, ["Ride"] = 20.74, ["Fly|Ride"] = 58.8, ["Neon"] = 32.06, ["Neon|Ride"] = 50.16, ["Mega"] = 159.95, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 92.15, ["Fly"] = 207.69, ["Ride"] = 129.94, ["Fly|Ride"] = 175.63, ["Neon"] = 785.48, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3502.09, ["Mega|Fly|Ride"] = 3154.48}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.93, ["Ride"] = 42, ["Fly|Ride"] = 91.88, ["Neon"] = 105, ["Neon|Ride"] = 225.04, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 550.3, ["Mega|Ride"] = 701.36, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2034.38, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 2100, ["Neon"] = 11216.23, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.4, ["Fly"] = 65625, ["Ride"] = 56.8, ["Fly|Ride"] = 196.87, ["Neon"] = 14.13, ["Neon|Fly|Ride"] = 630.91, ["Mega"] = 116.74, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.71, ["Ride"] = 36.66, ["Fly|Ride"] = 143.26, ["Neon"] = 28.51, ["Neon|Ride"] = 90.56, ["Mega"] = 138.36, ["Mega|Ride"] = 182.97, ["Mega|Fly|Ride"] = 406.93}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 813.65, ["Fly"] = 1107.73, ["Ride"] = 822.93, ["Fly|Ride"] = 866.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2493.75, ["Mega"] = 13874.39, ["Mega|Fly|Ride"] = 11356.08}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.34, ["Ride"] = 49.79, ["Fly|Ride"] = 173.35, ["Neon"] = 182.97, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 351.21, ["Mega"] = 841.31, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.08, ["Ride"] = 23.44, ["Fly|Ride"] = 124.09, ["Neon"] = 6.54, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 314.41, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 140.91, ["Neon"] = 3.96, ["Neon|Ride"] = 48.93, ["Neon|Fly|Ride"] = 103.06, ["Mega"] = 19.09, ["Mega|Ride"] = 77.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.34, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 420.6, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 630.91, ["Mega"] = 2387.25, ["Mega|Fly|Ride"] = 2102.99}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Ride"] = 34.01, ["Fly|Ride"] = 74.03, ["Neon"] = 11.75, ["Neon|Ride"] = 63.1, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 107.62, ["Mega|Ride"] = 122.05, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.61, ["Fly"] = 98.85, ["Ride"] = 114.7, ["Fly|Ride"] = 238.71, ["Neon"] = 459.38, ["Neon|Ride"] = 419.55, ["Mega|Fly|Ride"] = 1613}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.49, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.25, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 314.9, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.93, ["Fly"] = 354.38, ["Ride"] = 286.89, ["Fly|Ride"] = 322.84, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 9.19, ["Fly"] = 91.88, ["Ride"] = 16.49, ["Fly|Ride"] = 49.76, ["Neon"] = 28.77, ["Neon|Ride"] = 57.65, ["Neon|Fly|Ride"] = 112.21, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 265.79}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 15.65, ["Fly|Ride"] = 30.45, ["Neon"] = 5.25, ["Neon|Fly"] = 37.87, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 56.8, ["Mega"] = 40.69, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 125.98}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1234.46, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7711.62, ["Neon|Fly|Ride"] = 6589.69, ["Mega"] = 23394.89, ["Mega|Fly|Ride"] = 28040.03}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.07, ["Fly"] = 982.1, ["Ride"] = 72.19, ["Neon"] = 65.63, ["Neon|Ride"] = 311.76, ["Mega"] = 244.59, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.19, ["Fly"] = 39.38, ["Ride"] = 48.38, ["Fly|Ride"] = 107.63, ["Neon"] = 19.67, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 52.96, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 140.6, ["Mega|Ride"] = 253.99, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.12, ["Fly"] = 33.95, ["Ride"] = 32.39, ["Fly|Ride"] = 63.99, ["Neon"] = 420.6, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2523.59, ["Mega|Ride"] = 1114.86, ["Mega|Fly|Ride"] = 799.21}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.49, ["Fly"] = 90.44, ["Ride"] = 28.86, ["Fly|Ride"] = 78.75, ["Neon"] = 57.85, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 224.99, ["Mega"] = 367.4, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.25, ["Ride"] = 99.9, ["Fly|Ride"] = 410.1, ["Neon"] = 159.95, ["Neon|Ride"] = 310.21, ["Neon|Fly|Ride"] = 533.12, ["Mega"] = 841.2, ["Mega|Ride"] = 831.75, ["Mega|Fly|Ride"] = 810.71}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 280.76, ["Neon"] = 2.47, ["Neon|Fly"] = 56.8, ["Neon|Ride"] = 112.21, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 15.54, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 92.55, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 73.4, ["Fly"] = 126.19, ["Ride"] = 90.57, ["Fly|Ride"] = 178.36, ["Neon"] = 578.82, ["Neon|Fly"] = 663.51, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 489.57, ["Mega"] = 3364.78, ["Mega|Fly|Ride"] = 1666.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 107.62, ["Ride"] = 24.94, ["Fly|Ride"] = 67.37, ["Neon"] = 84.14, ["Neon|Ride"] = 95.51, ["Neon|Fly|Ride"] = 168.25, ["Mega"] = 773.07, ["Mega|Ride"] = 429.73, ["Mega|Fly|Ride"] = 420.6}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 18.38, ["Fly|Ride"] = 38.16, ["Neon"] = 19.11, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 70.47, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.75, ["Neon|Fly"] = 138.81, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 199.8, ["Mega|Fly|Ride"] = 477.47}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 53.74, ["Ride"] = 191, ["Fly|Ride"] = 301.88, ["Neon"] = 328.12, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 727.12, ["Mega"] = 1682.4, ["Mega|Ride"] = 1444.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.62, ["Fly|Ride"] = 420.6, ["Neon"] = 17.97, ["Neon|Ride"] = 58.97, ["Mega"] = 126.88, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 277.57}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 36.66, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 16.75, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 35.6, ["Fly|Ride"] = 140.91, ["Neon"] = 2.1, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 19.4, ["Mega|Ride"] = 60.6, ["Mega|Fly|Ride"] = 137.17}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.04, ["Fly|Ride"] = 49.43, ["Neon"] = 5.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.45}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.52, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 15.65, ["Fly|Ride"] = 36.75, ["Neon"] = 10.07, ["Neon|Fly"] = 210.29, ["Neon|Ride"] = 28.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.63, ["Mega|Ride"] = 159.95, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.37, ["Ride"] = 101.72, ["Fly|Ride"] = 276.55, ["Neon"] = 210.31, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1051.5, ["Mega"] = 695.63, ["Mega|Ride"] = 756.97, ["Mega|Fly|Ride"] = 1114.86}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.74, ["Fly|Ride"] = 40.5, ["Neon"] = 2.63, ["Neon|Fly"] = 28.2, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 42.17, ["Mega"] = 30.14, ["Mega|Ride"] = 118.16, ["Mega|Fly|Ride"] = 95.51}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.49, ["Fly"] = 78.88, ["Ride"] = 23.83, ["Fly|Ride"] = 40.51, ["Neon"] = 26.87, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.96, ["Mega"] = 300.57, ["Mega|Ride"] = 301.77, ["Mega|Fly|Ride"] = 277.61}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 20.99, ["Fly"] = 56.8, ["Ride"] = 40.43, ["Fly|Ride"] = 105, ["Neon"] = 141.95, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 787.5, ["Mega|Ride"] = 666.66, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 4.8, ["Fly"] = 196.88, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 471.08}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.08, ["Fly|Ride"] = 32.82, ["Neon"] = 3.92, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 34, ["Mega|Ride"] = 53.8, ["Mega|Fly|Ride"] = 108.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.76, ["Fly"] = 77.83, ["Ride"] = 37.97, ["Fly|Ride"] = 51.64, ["Neon"] = 25.25, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 112.52, ["Mega"] = 164.07, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 263.94}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 931.4, ["Fly"] = 1353.58, ["Ride"] = 931.86, ["Fly|Ride"] = 1045.71, ["Neon"] = 2839.04, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 135.03, ["Ride"] = 232.39, ["Fly|Ride"] = 630.91, ["Neon"] = 588.84, ["Neon|Ride"] = 588.84, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 3153.43, ["Mega|Ride"] = 3502.52, ["Mega|Fly|Ride"] = 2496.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.8, ["Fly|Ride"] = 392.44, ["Neon"] = 3.82, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 204.01, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1121.96}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 84.95, ["Ride"] = 157.87, ["Fly|Ride"] = 262.49, ["Neon"] = 392.44, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 682.17, ["Mega"] = 1964.19, ["Mega|Ride"] = 1846.55, ["Mega|Fly|Ride"] = 1767.14}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.32, ["Ride"] = 21.05, ["Neon"] = 17.53, ["Neon|Fly"] = 56.11, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 118.12, ["Mega|Ride"] = 353.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 249.37, ["Fly"] = 330.19, ["Ride"] = 248.06, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1093.56, ["Neon|Fly|Ride"] = 1273.61, ["Mega|Fly|Ride"] = 4767.46}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.03, ["Fly|Ride"] = 213.99, ["Neon"] = 31.5, ["Neon|Fly"] = 49.43, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 328.08, ["Mega|Ride"] = 561.51}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.41, ["Ride"] = 18.95, ["Neon"] = 42.08, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 19.59, ["Ride"] = 61.07, ["Fly|Ride"] = 151.6, ["Neon"] = 115.4, ["Neon|Fly"] = 420.6, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 191, ["Mega"] = 450.06, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 859.42}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 21.05, ["Neon|Ride"] = 196.87, ["Mega"] = 217.25, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.85, ["Fly|Ride"] = 28.41, ["Neon"] = 2.49, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 17.92, ["Neon|Fly|Ride"] = 35, ["Mega"] = 21.05, ["Mega|Ride"] = 35.77, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.64, ["Ride"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon"] = 31544.63, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 159149.63}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.76, ["Fly"] = 84.14, ["Ride"] = 56.43, ["Neon"] = 53.44, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 192.94, ["Mega|Ride"] = 214.85, ["Mega|Fly|Ride"] = 403.78}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.85, ["Fly|Ride"] = 42, ["Neon"] = 13.44, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 437.06, ["Fly"] = 547.77, ["Ride"] = 454.78, ["Fly|Ride"] = 536.46, ["Neon"] = 1584.61, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1287.8, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.06, ["Ride"] = 33.5, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 140.95, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.3, ["Fly"] = 4204.91, ["Ride"] = 36.74, ["Neon"] = 31.56, ["Neon|Fly"] = 116.72, ["Neon|Ride"] = 64.46, ["Neon|Fly|Ride"] = 301.79, ["Mega"] = 419.55, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.07}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 70.47, ["Ride"] = 17.75, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.75, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 40.69, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.23, ["Fly"] = 853.82, ["Ride"] = 612.9, ["Fly|Ride"] = 677.24, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2383.74, ["Mega|Fly|Ride"] = 9113.25}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.64, ["Fly"] = 131.25, ["Ride"] = 57.5, ["Fly|Ride"] = 420.6, ["Neon"] = 36.66, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 143.26, ["Mega"] = 180.48, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.29, ["Fly"] = 236.15, ["Ride"] = 28.4, ["Fly|Ride"] = 76.56, ["Neon"] = 23.05, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 420.6, ["Mega|Fly"] = 796.17, ["Mega|Ride"] = 248.46, ["Mega|Fly|Ride"] = 272.88}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.51, ["Fly"] = 34.12, ["Ride"] = 16.85, ["Fly|Ride"] = 43.29, ["Neon"] = 14, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 79.99, ["Mega"] = 182.97, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 228.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 24.83, ["Ride"] = 34.12, ["Fly|Ride"] = 55.6, ["Neon"] = 117.58, ["Mega"] = 840.15, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 542.59}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 420.6, ["Neon"] = 6.46, ["Neon|Ride"] = 45.23, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 32.44, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9310.22, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 105.16, ["Ride"] = 54.36, ["Fly|Ride"] = 336.49, ["Neon"] = 15.43, ["Neon|Ride"] = 77.38, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 71.69, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 496.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.67, ["Neon"] = 3.94, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 75.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42.08, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.43, ["Neon"] = 3.94, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 47.25, ["Mega|Fly"] = 155.64, ["Mega|Ride"] = 116.66, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 26.25, ["Neon"] = 37.87, ["Neon|Ride"] = 48.18, ["Mega"] = 210.31, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.16, ["Fly"] = 64.32, ["Ride"] = 42, ["Fly|Ride"] = 144.37, ["Neon"] = 103.68, ["Neon|Fly"] = 210.31, ["Neon|Ride"] = 156.38, ["Neon|Fly|Ride"] = 238.74, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 540.9}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.06, ["Ride"] = 73.96, ["Fly|Ride"] = 103.06, ["Neon"] = 77.96, ["Neon|Ride"] = 128.16, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 381.84, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 15.64, ["Fly|Ride"] = 32.47, ["Neon"] = 22.7, ["Neon|Fly"] = 140.91, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 87.29, ["Mega"] = 226.8, ["Mega|Ride"] = 280.76, ["Mega|Fly|Ride"] = 310.21}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.69, ["Ride"] = 56.04, ["Fly|Ride"] = 132.5, ["Neon"] = 38.05, ["Neon|Ride"] = 140.91, ["Mega|Ride"] = 730.8}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.16, ["Fly|Ride"] = 105.16, ["Neon"] = 10.12, ["Neon|Ride"] = 37.83, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.84, ["Fly"] = 112.21, ["Ride"] = 26.24, ["Fly|Ride"] = 42.98, ["Neon"] = 109.15, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 832.8}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 56.79, ["Neon"] = 133.88, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 39.53, ["Fly"] = 153.58, ["Ride"] = 78.63, ["Fly|Ride"] = 169.51, ["Neon"] = 322.83, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1687.8, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 44.62, ["Fly"] = 85.44, ["Ride"] = 76.74, ["Fly|Ride"] = 128.63, ["Neon"] = 140.43, ["Neon|Ride"] = 142.92, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 551.25, ["Mega|Ride"] = 671.91, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 13.13, ["Ride"] = 56.8, ["Neon"] = 103.69, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 796.17, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.62, ["Fly"] = 81.73, ["Ride"] = 70.87, ["Fly|Ride"] = 189, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 238.71, ["Mega"] = 478.59, ["Mega|Ride"] = 565.26, ["Mega|Fly|Ride"] = 646.64}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.92, ["Ride"] = 13.13, ["Fly|Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Fly"] = 27.07, ["Neon|Ride"] = 31.05, ["Neon|Fly|Ride"] = 53.65, ["Mega"] = 38.05, ["Mega|Fly"] = 105, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 61.71, ["Fly"] = 477.47, ["Ride"] = 70.47, ["Fly|Ride"] = 262.39, ["Neon"] = 350.38, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 553.09, ["Mega"] = 1255.5, ["Mega|Ride"] = 1491.03, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.75, ["Neon"] = 3.1, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 294.44, ["Mega"] = 27.56, ["Mega|Ride"] = 79.93, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 19.28, ["Ride"] = 112.52, ["Fly|Ride"] = 142.65, ["Neon"] = 126.19, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 561.51, ["Mega|Ride"] = 493.4, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.46, ["Neon|Fly|Ride"] = 112.52, ["Mega"] = 26.17}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 22.32, ["Mega|Ride"] = 140.91, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.77, ["Fly"] = 223.13, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Ride"] = 318.72, ["Neon|Fly|Ride"] = 630.96, ["Mega|Ride"] = 2243.9, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 95.51, ["Neon"] = 7.8, ["Neon|Fly"] = 42.08, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Fly|Ride"] = 53.82, ["Neon"] = 3.14, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 30.85, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.29, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 477.4}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 84.42, ["Neon"] = 6.47, ["Neon|Ride"] = 156.02, ["Mega"] = 68.25, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 76.56, ["Ride"] = 129.94, ["Fly|Ride"] = 477.47, ["Neon"] = 428.35, ["Neon|Ride"] = 561.51, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1964.19, ["Mega|Ride"] = 2102.99, ["Mega|Fly|Ride"] = 1680.3}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.39, ["Ride"] = 73.7, ["Neon"] = 78.75, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 954.92, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 408.68, ["Fly|Ride"] = 510.88, ["Neon"] = 1706.25, ["Neon|Ride"] = 1402.7, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 91.69}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.87}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.22}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 140.91}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.8}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.17}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 9.15}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 183.74}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 11.87}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.45}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.01}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.5}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.3}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.23}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.52}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.49}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 581.15}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.45}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1286.25}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 53.47}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.17}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.02}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 16.2}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.12}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 48.56}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.94}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.39}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.19}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.56}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.12}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.92}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.89}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.02}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.11}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 5.01}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2874.78}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 39.8}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.05}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.42}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.52}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.53}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.76}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.62}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 12.25}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 33.38}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 29.3}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 31.84}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.93}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.31}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 35.1}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.68}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.06}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.62}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.24}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.84}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.48}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.62}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.91}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.65}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 17.21}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.86}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.67}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22736.01}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.92}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 27.03}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 40.57}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.47}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 200.33}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 37.24}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.94}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.17}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.55}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 12.91}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.83}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.49}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 108.45}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 4.2}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 9.09}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.84}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 13.09}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.45}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.75}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.46}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 19.67}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.74}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 16.05}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 27.36}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.4}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.6}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.15}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.81}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.82}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.68}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.15}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.81}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.62}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.96}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 183.74}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.62}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 196.64}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 11.67}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.79}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.46}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 40.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.24}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.83}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.65}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.57}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 22.19}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 77.14}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 6.34}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.91}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.12}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 7.19}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.42}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.76}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8691.61}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.58}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.88}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 9.08}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.23}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.37}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 33.49}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.14}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 8.42}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 39.36}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4416.39}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.42}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.44}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.6}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 75.84}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.15}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 104.98}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.74}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.59}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.71}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.46}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.98}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.83}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.2}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.93}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
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
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.15}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 140.91}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.67}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 75.43}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.86}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.54}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.89}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 26.17}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.54}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.76}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.39}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.36}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.26}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.5}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.35}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.96}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.62}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.62}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 8.33}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.69}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.19}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.92}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.69}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.29}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.11}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.83}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 47.77}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 37.2}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 18.8}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.04}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 79.71}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.51}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 139.34}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1154.76}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 189.29}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.12}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 4.41}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 55.34}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 12.91}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.57}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 78.26}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.16}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.07}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 7.67}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.82}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.32}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.4}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 54.74}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 7.56}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.79}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.49}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.29}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.24}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.25}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.69}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.82}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.41}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 80.76}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 4.7}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.19}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 50}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.15}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.15}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.59}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 371.15}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.8}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.39}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.28}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.21}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.91}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.76}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 55.12}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.03}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 8.33}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.73}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 12.99}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.15}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 35.42}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 85.2}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 27.35}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.72}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 11.43}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 75.51}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 40.85}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.6}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.15}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.65}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 354.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.84}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.28}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.43}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 10.29}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 56.9}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.05}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.08}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.98}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 188.99}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.48}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.94}},
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