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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 813.75, ["Ride"] = 916.13, ["Fly|Ride"] = 1130.17, ["Neon"] = 4109.67, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 32881.42}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 452.82, ["Fly"] = 606.27, ["Ride"] = 494.78, ["Fly|Ride"] = 556.49, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2165.63, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 9555.81}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4593.75, ["Ride"] = 4265.63, ["Fly|Ride"] = 4631.82, ["Neon|Ride"] = 20686, ["Neon|Fly|Ride"] = 16954.72, ["Mega|Fly|Ride"] = 68503.29}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 154.77, ["Ride"] = 183.1, ["Fly|Ride"] = 397.63, ["Neon"] = 770.59, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 1096.4, ["Mega"] = 4110.2, ["Mega|Fly|Ride"] = 3396.75}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 822.05, ["Ride"] = 551.15, ["Fly|Ride"] = 599.82, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.65, ["Ride"] = 27.68, ["Fly|Ride"] = 152.07, ["Neon"] = 56.44, ["Neon|Fly"] = 274.34, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 574.42}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.92, ["Fly"] = 36.75, ["Ride"] = 26.73, ["Fly|Ride"] = 60.75, ["Neon"] = 29.78, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 114.08, ["Mega"] = 157.5, ["Mega|Fly"] = 201.14, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 282.63}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 102.92, ["Ride"] = 147.72, ["Fly|Ride"] = 233.24, ["Neon"] = 521.07, ["Neon|Ride"] = 616.46, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 2329.46, ["Mega|Fly|Ride"] = 2658.27}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.89, ["Fly"] = 80.91, ["Ride"] = 52.79, ["Fly|Ride"] = 114.19, ["Neon"] = 252, ["Neon|Ride"] = 260.97, ["Neon|Fly|Ride"] = 236.72, ["Mega"] = 2100, ["Mega|Ride"] = 1387.09, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.86, ["Fly"] = 55, ["Ride"] = 35.6, ["Fly|Ride"] = 64.59, ["Neon"] = 274.34, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 274.37, ["Mega|Ride"] = 1334.8, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.49, ["Fly"] = 206.07, ["Ride"] = 84.6, ["Fly|Ride"] = 166.46, ["Neon"] = 489.86, ["Neon|Fly"] = 397.63, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1541.33}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 328.13, ["Fly"] = 395.01, ["Ride"] = 340.47, ["Fly|Ride"] = 386.33, ["Neon"] = 1417.55, ["Neon|Ride"] = 1232.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 4836.66}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 116.94, ["Fly"] = 154.88, ["Ride"] = 123.38, ["Fly|Ride"] = 170.12, ["Neon|Fly"] = 670.07, ["Neon|Fly|Ride"] = 508.65, ["Mega|Fly|Ride"] = 2740.48}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.07, ["Ride"] = 52.5, ["Fly|Ride"] = 131.23, ["Neon"] = 19.74, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 189, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 382.61}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 179.83, ["Fly"] = 202.71, ["Ride"] = 150.94, ["Fly|Ride"] = 210, ["Neon"] = 924.25, ["Neon|Ride"] = 685.3, ["Neon|Fly|Ride"] = 644.28, ["Mega|Fly|Ride"] = 2229.94}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 22.04, ["Ride"] = 18.51, ["Fly|Ride"] = 40.6, ["Neon"] = 24.85, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 207.38, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 91.88, ["Fly"] = 262.5, ["Ride"] = 150.35, ["Fly|Ride"] = 217.19, ["Neon"] = 288.75, ["Neon|Fly"] = 462.13, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 429.53, ["Mega"] = 1507.43, ["Mega|Ride"] = 1301.9, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.58}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 58.27, ["Ride"] = 219.91, ["Fly|Ride"] = 294.67, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 1096.4, ["Mega|Fly|Ride"] = 1836.23}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18, ["Fly"] = 393.75, ["Ride"] = 28.88, ["Fly|Ride"] = 109.96, ["Neon"] = 205.5, ["Neon|Ride"] = 193.17, ["Neon|Fly|Ride"] = 266.16, ["Mega|Ride"] = 578.52, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 45.46, ["Fly"] = 74, ["Ride"] = 57.05, ["Fly|Ride"] = 131.25, ["Neon"] = 241.34, ["Neon|Ride"] = 233.63, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1618.28, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.86, ["Fly"] = 72.82, ["Ride"] = 189, ["Fly|Ride"] = 137.69, ["Neon"] = 191.02, ["Neon|Fly"] = 383.57, ["Neon|Ride"] = 186.17, ["Neon|Fly|Ride"] = 352.47, ["Mega"] = 1159.09, ["Mega|Ride"] = 1228.96, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 29.47, ["Ride"] = 41.1, ["Fly|Ride"] = 137.17, ["Neon"] = 343.17, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 291.31, ["Mega"] = 820, ["Mega|Ride"] = 2055.11, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 41.43, ["Fly"] = 115.59, ["Ride"] = 62.77, ["Fly|Ride"] = 123.31, ["Neon"] = 227.07, ["Neon|Fly"] = 549.69, ["Neon|Ride"] = 180.09, ["Neon|Fly|Ride"] = 308.63, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 885.44}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.79, ["Fly"] = 20.56, ["Ride"] = 23.36, ["Fly|Ride"] = 54.23, ["Neon"] = 30.83, ["Neon|Fly"] = 105, ["Neon|Ride"] = 45.91, ["Neon|Fly|Ride"] = 93.06, ["Mega"] = 124.69, ["Mega|Fly"] = 26157.81, ["Mega|Ride"] = 181.13, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 410.01, ["Ride"] = 411.03, ["Fly|Ride"] = 454.88, ["Neon"] = 1848.47, ["Neon|Ride"] = 1952.1, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7244.02}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 14.11, ["Ride"] = 31.26, ["Fly|Ride"] = 107.34, ["Neon"] = 219.18, ["Neon|Ride"] = 176.73, ["Neon|Fly|Ride"] = 419.25, ["Mega"] = 512.76, ["Mega|Ride"] = 780.95, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.87, ["Fly"] = 34.54, ["Ride"] = 20.56, ["Fly|Ride"] = 47.92, ["Neon"] = 54.41, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 268.75, ["Mega|Fly|Ride"] = 407.92}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.66, ["Fly"] = 123.32, ["Ride"] = 85.62, ["Fly|Ride"] = 154.88, ["Neon"] = 355.55, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 3014.84, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 2065.61}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 18.51, ["Ride"] = 23.15, ["Fly|Ride"] = 75.22, ["Neon"] = 154.83, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 160.79, ["Mega"] = 479.16, ["Mega|Ride"] = 784.03}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 188.06, ["Fly"] = 347.32, ["Ride"] = 253.16, ["Fly|Ride"] = 291.38, ["Neon"] = 924.69, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 1246.08, ["Mega"] = 6165.28, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2926.46}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.83, ["Fly"] = 26.91, ["Ride"] = 23.63, ["Fly|Ride"] = 50.39, ["Neon"] = 25.43, ["Neon|Fly"] = 131.72, ["Neon|Ride"] = 53.17, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 234.94, ["Mega|Fly"] = 500.43, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 820.32, ["Fly"] = 2625, ["Ride"] = 879.38, ["Fly|Ride"] = 918.75, ["Neon"] = 3871.88, ["Neon|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Ride"] = 52015.4, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.07, ["Fly"] = 68.86, ["Ride"] = 24.85, ["Fly|Ride"] = 85.32, ["Neon"] = 91.55, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 227.11, ["Mega"] = 479.89, ["Mega|Ride"] = 693.61, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 152.07, ["Ride"] = 214.3, ["Fly|Ride"] = 210, ["Neon"] = 870.24, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2466.71, ["Mega|Fly|Ride"] = 3014.84}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 21.92, ["Fly"] = 68.84, ["Ride"] = 52.29, ["Fly|Ride"] = 137.7, ["Neon"] = 82.41, ["Neon|Ride"] = 201.04, ["Neon|Fly|Ride"] = 164.42, ["Mega"] = 670.9, ["Mega|Ride"] = 1101.19, ["Mega|Fly|Ride"] = 724.77}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 115.19, ["Ride"] = 127.32, ["Neon"] = 584.07, ["Neon|Ride"] = 462.13, ["Neon|Fly|Ride"] = 585.72, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 128.91, ["Ride"] = 199.36, ["Fly|Ride"] = 272.85, ["Neon"] = 920.66, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 1541.33, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 2055.11}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 32.39}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.41, ["Fly"] = 61.35, ["Ride"] = 55.06, ["Fly|Ride"] = 82.83, ["Neon|Ride"] = 475.99, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 4110.2, ["Mega|Fly|Ride"] = 1522.5}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.86, ["Fly"] = 55.51, ["Ride"] = 41.08, ["Fly|Ride"] = 131.25, ["Neon"] = 41.11, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 231.21, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 320.61, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 446.25, ["Fly"] = 594.97, ["Ride"] = 393.75, ["Fly|Ride"] = 485.62, ["Neon|Ride"] = 1734.29, ["Neon|Fly|Ride"] = 1506.74, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 82.69, ["Fly"] = 161.81, ["Ride"] = 108.65, ["Fly|Ride"] = 137.69, ["Neon"] = 446.25, ["Neon|Fly"] = 821.94, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 548.72, ["Mega|Ride"] = 2465.1, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3508.05, ["Ride"] = 3255, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14384.61}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 42.76, ["Fly"] = 109.96, ["Ride"] = 52.5, ["Fly|Ride"] = 118.13, ["Neon"] = 393.75, ["Neon|Ride"] = 439.74, ["Neon|Fly|Ride"] = 343.22, ["Mega|Ride"] = 1179.64, ["Mega|Fly|Ride"] = 1219.71}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 69.36, ["Fly|Ride"] = 173.37, ["Neon"] = 410.42, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 683.76, ["Mega"] = 2740.48, ["Mega|Ride"] = 2603.82, ["Mega|Fly|Ride"] = 2774.17}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 30.35, ["Fly"] = 77.09, ["Ride"] = 59.61, ["Fly|Ride"] = 136.55, ["Neon"] = 231.08, ["Neon|Fly"] = 195.23, ["Neon|Ride"] = 163.96, ["Neon|Fly|Ride"] = 194.22, ["Mega"] = 959.75, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 596.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.35, ["Fly"] = 393.75, ["Ride"] = 59.09, ["Fly|Ride"] = 63.63, ["Neon"] = 359.62, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1027.56}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.68}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 195.13, ["Ride"] = 221.82, ["Fly|Ride"] = 314.44, ["Neon|Ride"] = 1386.35, ["Neon|Fly|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 4932.22}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1015.23, ["Ride"] = 1023.75, ["Fly|Ride"] = 1043.44, ["Neon"] = 2625, ["Neon|Ride"] = 3543.26, ["Neon|Fly|Ride"] = 3018.74, ["Mega|Fly|Ride"] = 13358.08}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.13, ["Fly"] = 68.99, ["Ride"] = 42.68, ["Fly|Ride"] = 74.82, ["Neon"] = 229.71, ["Neon|Ride"] = 148.46, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 921.72}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.85}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6288.58, ["Fly"] = 5617.6, ["Fly|Ride"] = 4704, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40071.51}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.38, ["Fly"] = 52.41, ["Ride"] = 24.86, ["Fly|Ride"] = 55.13, ["Neon"] = 116.88, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 657.64, ["Mega|Ride"] = 586.06, ["Mega|Fly|Ride"] = 616.87}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Fly"] = 41.11, ["Ride"] = 39.38, ["Fly|Ride"] = 114.43, ["Neon"] = 65.63, ["Neon|Ride"] = 132.49, ["Neon|Fly|Ride"] = 245.6, ["Mega"] = 1028.76, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 1024.48}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.54, ["Fly"] = 271.07, ["Ride"] = 72.19, ["Fly|Ride"] = 100.7, ["Neon|Ride"] = 381.19, ["Neon|Fly|Ride"] = 471.37, ["Mega"] = 4110.2}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.18, ["Fly"] = 150.93, ["Ride"] = 26.25, ["Fly|Ride"] = 138.72, ["Neon"] = 74.87, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 152.1, ["Mega"] = 1370.76, ["Mega|Ride"] = 500.43, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.65, ["Fly"] = 2122.32, ["Ride"] = 1949.07, ["Fly|Ride"] = 1778.44, ["Neon|Fly|Ride"] = 3429.57, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Ride"] = 28771.24, ["Fly|Ride"] = 25265.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 68503.29, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.74, ["Ride"] = 52.41, ["Fly|Ride"] = 124.68, ["Neon"] = 205.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 308.28, ["Mega"] = 959.75, ["Mega|Ride"] = 754.24, ["Mega|Fly|Ride"] = 817.94}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.81, ["Fly"] = 76.4, ["Ride"] = 40.79, ["Fly|Ride"] = 199.5, ["Neon"] = 18.38, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 124.69, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 20.9}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.49, ["Ride"] = 44.2, ["Fly|Ride"] = 125.24, ["Neon"] = 64.75, ["Neon|Ride"] = 125.32, ["Neon|Fly|Ride"] = 462.41, ["Mega"] = 3120.94, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 643.13, ["Ride"] = 735, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 2808.75, ["Mega|Fly|Ride"] = 8469.57}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 951.81, ["Fly"] = 1076.25, ["Ride"] = 1015.23, ["Fly|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11371.85}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.43, ["Fly"] = 115.59, ["Ride"] = 36.65, ["Fly|Ride"] = 90.57, ["Neon"] = 145.69, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.17}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 62.9, ["Fly"] = 92.48, ["Ride"] = 65.63, ["Fly|Ride"] = 109.96, ["Neon"] = 410.99, ["Neon|Ride"] = 343.17, ["Neon|Fly|Ride"] = 392.54, ["Mega|Ride"] = 2011.94, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 57.88, ["Ride"] = 77.23, ["Fly|Ride"] = 228.38, ["Neon"] = 343.17, ["Neon|Ride"] = 287.28, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2070.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.84, ["Fly"] = 44.63, ["Ride"] = 19.69, ["Fly|Ride"] = 51.33, ["Neon"] = 39.08, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 68.17, ["Neon|Fly|Ride"] = 132.54, ["Mega"] = 288.75, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 109.14, ["Fly"] = 143.88, ["Ride"] = 137.45, ["Fly|Ride"] = 192.94, ["Neon|Ride"] = 450.21, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1487.26}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.08, ["Ride"] = 46.25, ["Fly|Ride"] = 109.96, ["Neon"] = 43.17, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 478.86, ["Mega"] = 229.18, ["Mega|Ride"] = 240.45, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 17.35, ["Fly"] = 41.11, ["Ride"] = 27.76, ["Fly|Ride"] = 90.43, ["Neon"] = 84, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 162.37, ["Mega|Fly|Ride"] = 754.24}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.23, ["Ride"] = 55.51, ["Fly|Ride"] = 156.19, ["Neon"] = 262, ["Neon|Ride"] = 328.79, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 693.55, ["Mega|Ride"] = 771, ["Mega|Fly|Ride"] = 863.16}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.7, ["Fly"] = 145.58, ["Ride"] = 28.88, ["Fly|Ride"] = 52.5, ["Neon"] = 91.88, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 822.05, ["Mega|Ride"] = 924.81, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7164.7, ["Ride"] = 7141.32, ["Fly|Ride"] = 6685.88, ["Neon"] = 30822.48, ["Neon|Fly|Ride"] = 27250.49}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 274.37, ["Fly"] = 273, ["Ride"] = 253.13, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 529.92, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 41.56, ["Fly"] = 150.94, ["Ride"] = 74, ["Fly|Ride"] = 131.14, ["Neon"] = 90.57, ["Neon|Fly"] = 204.47, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.63, ["Mega|Ride"] = 408.34, ["Mega|Fly|Ride"] = 511.45}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 85.54, ["Ride"] = 23.65, ["Fly|Ride"] = 105.15, ["Neon"] = 23.02, ["Neon|Fly"] = 31.86, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 187.03, ["Mega"] = 129.94, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 52.49, ["Fly"] = 5238.94, ["Ride"] = 87.45, ["Fly|Ride"] = 191.91, ["Neon"] = 199.11, ["Neon|Fly"] = 332.9, ["Neon|Ride"] = 226.91, ["Neon|Fly|Ride"] = 328.06, ["Mega"] = 441.79, ["Mega|Ride"] = 462.37, ["Mega|Fly|Ride"] = 578.2}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14385, ["Ride"] = 13387.5, ["Fly|Ride"] = 12468.75, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 164.07, ["Ride"] = 164.07, ["Fly|Ride"] = 164.07, ["Neon"] = 1493.88, ["Neon|Ride"] = 1438.4, ["Neon|Fly|Ride"] = 1438.58, ["Mega|Fly|Ride"] = 5096.64}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 62.99, ["Fly"] = 118.83, ["Ride"] = 74.73, ["Fly|Ride"] = 101.46, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 407.84, ["Mega|Fly|Ride"] = 2566.81}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.28, ["Fly"] = 43.94, ["Ride"] = 23.14, ["Fly|Ride"] = 55.55, ["Neon"] = 85.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 303.14, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 328.02, ["Ride"] = 412.13, ["Fly|Ride"] = 495.96, ["Neon"] = 1643.87, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 3.94, ["Fly"] = 101.53, ["Ride"] = 38.07, ["Fly|Ride"] = 85.22, ["Neon"] = 26, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 129.93, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 217.86}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 133.88, ["Fly"] = 205.52, ["Ride"] = 162.21, ["Fly|Ride"] = 233.26, ["Neon"] = 548.66, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2548.92}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.53, ["Fly"] = 15.43, ["Ride"] = 19.04, ["Fly|Ride"] = 31.98, ["Neon|Ride"] = 96.37, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 874.13, ["Mega|Fly|Ride"] = 1018.37}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 7.55}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.72, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 421.32, ["Neon|Fly"] = 548.66, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1525.79}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.81, ["Fly"] = 101.74, ["Ride"] = 36.39, ["Fly|Ride"] = 96.59, ["Neon"] = 101.73, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 1025.51, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 669.38}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 22.61}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.75, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Fly|Ride"] = 249.38, ["Neon"] = 217.39, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 344.03, ["Mega"] = 1096.4, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.55, ["Ride"] = 29.23, ["Fly|Ride"] = 131.72, ["Neon"] = 22.66, ["Neon|Ride"] = 103.99, ["Neon|Fly|Ride"] = 267.18, ["Mega"] = 122.07, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.12, ["Fly"] = 47.25, ["Ride"] = 35.98, ["Fly|Ride"] = 92.19, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 171.86, ["Mega|Ride"] = 585.72, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 535.05, ["Ride"] = 452.61, ["Fly|Ride"] = 523.69, ["Neon|Fly|Ride"] = 2733.28, ["Mega|Fly|Ride"] = 13701.29}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 40.69, ["Fly"] = 102.77, ["Ride"] = 55.11, ["Fly|Ride"] = 65.63, ["Neon"] = 233.24, ["Neon|Ride"] = 180.07, ["Neon|Fly|Ride"] = 303.14, ["Mega"] = 1011.9, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 51.95, ["Fly"] = 117.49, ["Ride"] = 77.44, ["Fly|Ride"] = 131.25, ["Neon"] = 453.11, ["Neon|Ride"] = 316.46, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 719.3, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.49, ["Fly"] = 87.94, ["Ride"] = 68.25, ["Fly|Ride"] = 116.09, ["Neon"] = 143.85, ["Neon|Ride"] = 123.63, ["Neon|Fly|Ride"] = 237.87, ["Mega"] = 414.74, ["Mega|Ride"] = 409.5, ["Mega|Fly|Ride"] = 605.51}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13252.77, ["Fly|Ride"] = 7873.69, ["Neon|Fly|Ride"] = 14171.05, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.27, ["Fly"] = 1849.19, ["Ride"] = 1575, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 4514.99, ["Mega|Fly|Ride"] = 15356.25}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 518.44, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon"] = 2260.55, ["Mega|Fly|Ride"] = 6710.91}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.46, ["Fly"] = 23.63, ["Ride"] = 20.35, ["Fly|Ride"] = 41.11, ["Neon"] = 109.95, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 96.6, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.54, ["Fly"] = 78.74, ["Ride"] = 32.18, ["Fly|Ride"] = 82.21, ["Neon"] = 23.86, ["Neon|Ride"] = 83.2, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 133.85, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 30.19, ["Fly"] = 78.75, ["Ride"] = 52.63, ["Fly|Ride"] = 91.68, ["Neon"] = 519.89, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 164.22, ["Mega|Fly|Ride"] = 511.67}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.89, ["Fly"] = 26.73, ["Ride"] = 15.1, ["Fly|Ride"] = 42, ["Neon"] = 27.76, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 203.41, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 285.67}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 262.49, ["Fly|Ride"] = 387.19, ["Neon"] = 1171.51, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1169.44, ["Mega|Fly|Ride"] = 4396.88}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.38, ["Fly"] = 82.22, ["Ride"] = 32.82, ["Fly|Ride"] = 76.48, ["Neon"] = 188.03, ["Neon|Fly"] = 407.52, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 822.05, ["Mega|Ride"] = 524.9, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.34, ["Fly"] = 20.99, ["Ride"] = 20.4, ["Fly|Ride"] = 43.83, ["Neon"] = 72.19, ["Neon|Fly"] = 131.72, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 106.6, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 462.26, ["Fly"] = 787.5, ["Ride"] = 435.75, ["Fly|Ride"] = 821.02, ["Neon|Ride"] = 2876.78, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1102.5, ["Fly"] = 1386.9, ["Ride"] = 1154.99, ["Fly|Ride"] = 1278.38, ["Neon"] = 4794.97, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 92.48, ["Fly"] = 129.49, ["Ride"] = 90.96, ["Fly|Ride"] = 123.38, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 155.17, ["Fly"] = 157.5, ["Ride"] = 154.88, ["Fly|Ride"] = 245.44, ["Neon"] = 577.5, ["Neon|Fly"] = 685.3, ["Neon|Ride"] = 693.18, ["Neon|Fly|Ride"] = 604.7, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2311.8}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.54, ["Ride"] = 61.64, ["Fly|Ride"] = 118.58, ["Neon"] = 239.88, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 384.33, ["Mega|Ride"] = 2055.11, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 137.69, ["Ride"] = 273, ["Fly|Ride"] = 128.63, ["Neon|Fly|Ride"] = 1294.62, ["Mega|Fly|Ride"] = 3288.15}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2099.99, ["Fly"] = 2329.46, ["Ride"] = 2233.9, ["Fly|Ride"] = 2329.17, ["Neon|Fly|Ride"] = 10275.45, ["Mega|Fly|Ride"] = 24659.94}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 65.87, ["Ride"] = 68.86, ["Fly|Ride"] = 196.88, ["Neon"] = 349.34, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2260.6, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 616.88, ["Ride"] = 577.5, ["Fly|Ride"] = 636.57, ["Neon|Ride"] = 1507.24, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 3136.88}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 44.63, ["Fly"] = 60.38, ["Ride"] = 52.49, ["Fly|Ride"] = 95.82, ["Neon|Ride"] = 358.15, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 1096.4}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.29, ["Fly"] = 39.38, ["Ride"] = 18.38, ["Fly|Ride"] = 46.24, ["Neon"] = 19.34, ["Neon|Fly"] = 92.45, ["Neon|Ride"] = 44.4, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.31, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 49.92, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 259.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 685.3, ["Mega"] = 1502.28, ["Mega|Ride"] = 1370.76, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 776.66, ["Fly"] = 1011.28, ["Ride"] = 813.63, ["Fly|Ride"] = 826.88, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2263.74, ["Mega|Fly|Ride"] = 9180.09}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 623.7, ["Ride"] = 681.19, ["Fly|Ride"] = 767.49, ["Neon|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.44, ["Fly"] = 26.25, ["Ride"] = 23.14, ["Fly|Ride"] = 51.39, ["Neon"] = 184.95, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 681.29}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 23.55, ["Fly|Ride"] = 45.94, ["Neon"] = 72.02, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 505.57, ["Mega|Ride"] = 505.57, ["Mega|Fly|Ride"] = 408.98}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.82, ["Ride"] = 24.94, ["Fly|Ride"] = 111.46, ["Neon"] = 22.08, ["Neon|Fly"] = 308.47, ["Neon|Ride"] = 53.37, ["Neon|Fly|Ride"] = 152.1, ["Mega"] = 141.63, ["Mega|Fly"] = 524.78, ["Mega|Ride"] = 238.25, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40.08, ["Fly"] = 106.88, ["Ride"] = 52.5, ["Fly|Ride"] = 110.25, ["Neon"] = 229.69, ["Neon|Ride"] = 216.56, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 496.26, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 1233.07, ["Mega|Ride"] = 1541.33, ["Mega|Fly|Ride"] = 1364.6}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.7, ["Fly"] = 55.48, ["Ride"] = 34.04, ["Fly|Ride"] = 73.52, ["Neon"] = 72.19, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.34, ["Fly"] = 136.5, ["Ride"] = 52.41, ["Fly|Ride"] = 83.99, ["Neon"] = 548.66, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.57, ["Fly"] = 27.76, ["Ride"] = 18.04, ["Fly|Ride"] = 40.58, ["Neon"] = 28.14, ["Neon|Ride"] = 41.43, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.44}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.22, ["Fly"] = 35.38, ["Ride"] = 28.58, ["Fly|Ride"] = 85.14, ["Neon"] = 25.97, ["Neon|Fly"] = 138.72, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 162.37, ["Mega"] = 293.25, ["Mega|Ride"] = 302.3, ["Mega|Fly|Ride"] = 378}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 52.49, ["Fly"] = 65.62, ["Ride"] = 58.7, ["Fly|Ride"] = 91.88, ["Neon"] = 400.89, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 1018.98}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1312.5, ["Fly"] = 2614.1, ["Ride"] = 1389.73, ["Fly|Ride"] = 1514.1, ["Neon|Fly"] = 4678.89, ["Neon|Fly|Ride"] = 3846.95, ["Mega|Fly|Ride"] = 13100.96}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 485.63, ["Fly"] = 479.75, ["Ride"] = 459.38, ["Fly|Ride"] = 607.77, ["Neon|Ride"] = 3014.45, ["Neon|Fly|Ride"] = 2992.5, ["Mega|Fly|Ride"] = 9591.11}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 268.17, ["Fly"] = 295.86, ["Ride"] = 280.67, ["Fly|Ride"] = 433.13, ["Neon|Fly|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 43.05}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 29.93, ["Ride"] = 41.87, ["Fly|Ride"] = 96.33, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 351.39, ["Neon|Fly|Ride"] = 315.47, ["Mega"] = 1233.37, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41101.76, ["Fly"] = 65625, ["Ride"] = 34671.9, ["Fly|Ride"] = 17969.44, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 343.17, ["Fly"] = 459.38, ["Ride"] = 322.24, ["Fly|Ride"] = 387.19, ["Neon"] = 1368.53, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1257.63, ["Mega"] = 6165.28, ["Mega|Fly|Ride"] = 3858.74}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 143.93, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4110.2}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 122.07, ["Fly"] = 262.49, ["Ride"] = 122.8, ["Fly|Ride"] = 196.76, ["Neon"] = 693.18, ["Neon|Ride"] = 508.58, ["Neon|Fly|Ride"] = 548.72, ["Mega"] = 7536.01, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.75, ["Fly"] = 94.5, ["Ride"] = 34.02, ["Fly|Ride"] = 107.85, ["Neon"] = 392.44, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 685.38, ["Mega|Ride"] = 601.08, ["Mega|Fly|Ride"] = 614.49}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4861.75, ["Ride"] = 4622.93, ["Fly|Ride"] = 4067.44, ["Neon"] = 20411.69, ["Neon|Fly|Ride"] = 27398.12, ["Mega|Fly|Ride"] = 61648.65}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.76, ["Fly"] = 48.57, ["Ride"] = 37.01, ["Fly|Ride"] = 54.51, ["Neon"] = 228.11, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1370.76, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 35.32, ["Fly"] = 137.7, ["Ride"] = 42, ["Fly|Ride"] = 101.05, ["Neon"] = 343.17, ["Neon|Ride"] = 267.15, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1541.98, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 752.51, ["Fly"] = 918.75, ["Ride"] = 839.99, ["Fly|Ride"] = 832.13, ["Neon"] = 2362.49, ["Neon|Ride"] = 2231.24, ["Neon|Fly|Ride"] = 2231.24, ["Mega"] = 9029.04, ["Mega|Fly|Ride"] = 7218.75}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 33.9, ["Ride"] = 20.56, ["Fly|Ride"] = 41.31, ["Neon"] = 131.25, ["Neon|Fly"] = 154.83, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 154.91, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.84, ["Fly"] = 96.6, ["Ride"] = 30.83, ["Fly|Ride"] = 462.13, ["Neon"] = 68.85, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 128.64, ["Mega|Ride"] = 520.98, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 86.84, ["Ride"] = 128.63, ["Fly|Ride"] = 293.57, ["Neon"] = 533.24, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 750.12, ["Mega|Fly|Ride"] = 2398.3}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.56, ["Ride"] = 61.6, ["Fly|Ride"] = 135.26, ["Neon"] = 78.85, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 275.63, ["Mega|Fly"] = 734.02, ["Mega|Ride"] = 297.47, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4034.7, ["Ride"] = 4110.2, ["Fly|Ride"] = 3345.57, ["Neon"] = 13150.94, ["Neon|Ride"] = 11644.75, ["Neon|Fly|Ride"] = 9318.75, ["Mega"] = 61652.64, ["Mega|Fly|Ride"] = 32609.12}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Ride"] = 64.32, ["Fly|Ride"] = 117.16, ["Neon"] = 220.43, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 411.03, ["Mega|Ride"] = 1026.53, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 7809.35, ["Fly|Ride"] = 6628.13, ["Neon|Fly|Ride"] = 17113.77, ["Mega|Fly|Ride"] = 67813.06}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.97, ["Fly"] = 21, ["Ride"] = 16.57, ["Fly|Ride"] = 44.19, ["Neon"] = 22.11, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 86.52, ["Mega"] = 171.62, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 362.97}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 20.65, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 47.29, ["Neon"] = 137.69, ["Neon|Ride"] = 191.13, ["Neon|Fly|Ride"] = 138.01, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 11.71, ["Fly"] = 39.38, ["Ride"] = 39.25, ["Fly|Ride"] = 115.5, ["Neon"] = 183.75, ["Neon|Ride"] = 157.68, ["Mega"] = 770.6, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 748.89}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 30.03, ["Fly"] = 190.37, ["Ride"] = 44.63, ["Fly|Ride"] = 150.04, ["Neon"] = 189.06, ["Neon|Ride"] = 124.53, ["Neon|Fly|Ride"] = 294.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 13.13, ["Fly"] = 23.55, ["Ride"] = 22.32, ["Fly|Ride"] = 40.43, ["Neon"] = 82.21, ["Neon|Ride"] = 114.06, ["Neon|Fly|Ride"] = 175.17, ["Mega"] = 728.44, ["Mega|Ride"] = 576.81, ["Mega|Fly|Ride"] = 502.69}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8322.08}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2713.35}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.1}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 131.25, ["Ride"] = 196.87, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1027.56}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 17.96, ["Fly"] = 123.32, ["Ride"] = 48.57, ["Fly|Ride"] = 105, ["Neon"] = 179.82, ["Neon|Ride"] = 154.12, ["Neon|Fly|Ride"] = 204.5, ["Mega"] = 405.9, ["Mega|Ride"] = 924.74, ["Mega|Fly|Ride"] = 951.51}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 14.38}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 62.41, ["Neon"] = 52.5, ["Neon|Ride"] = 96.59, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3045}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 150.84, ["Fly"] = 411.03, ["Ride"] = 217.86, ["Fly|Ride"] = 183.75, ["Neon"] = 701.37, ["Neon|Ride"] = 846.83, ["Neon|Fly|Ride"] = 945.36, ["Mega|Ride"] = 3151.49, ["Mega|Fly|Ride"] = 3014.84}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 96.6, ["Ride"] = 109.15, ["Fly|Ride"] = 211.32, ["Neon"] = 607.35, ["Neon|Ride"] = 684.28, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 3288.15, ["Mega|Fly|Ride"] = 3082.79}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 163.87, ["Fly"] = 186.62, ["Ride"] = 207.37, ["Fly|Ride"] = 236.76, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3172.93}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1781.77, ["Fly"] = 2466.12, ["Ride"] = 1707.79, ["Fly|Ride"] = 1837.5, ["Neon"] = 6162.28, ["Neon|Ride"] = 6438.84, ["Neon|Fly|Ride"] = 5248.69, ["Mega|Fly|Ride"] = 33908.26}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.01, ["Fly"] = 96.6, ["Ride"] = 39.32, ["Fly|Ride"] = 93.52, ["Neon"] = 155.16, ["Neon|Fly"] = 115.55, ["Neon|Ride"] = 203.45, ["Neon|Fly|Ride"] = 219.91, ["Mega"] = 923.78, ["Mega|Ride"] = 893.99, ["Mega|Fly|Ride"] = 1087.15}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 796.73, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 883.71, ["Neon|Ride"] = 2619.03, ["Neon|Fly|Ride"] = 4007.51}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 37.7}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.63, ["Ride"] = 48.47, ["Fly|Ride"] = 137.7, ["Neon"] = 99.75, ["Neon|Ride"] = 123.31, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 446.15, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 616.54}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.65, ["Fly"] = 48.3, ["Ride"] = 26.19, ["Fly|Ride"] = 44.18, ["Neon"] = 52.5, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 918.75, ["Mega|Ride"] = 308.28, ["Mega|Fly|Ride"] = 354.88}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.28}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 30.6, ["Fly"] = 108.92, ["Ride"] = 34.69, ["Fly|Ride"] = 55.51, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 918.75, ["Mega|Ride"] = 822.05, ["Mega|Fly|Ride"] = 1387.09}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.25, ["Fly"] = 65.63, ["Ride"] = 32.82, ["Fly|Ride"] = 54.71, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 822.05, ["Mega|Ride"] = 1733.86, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6096.7, ["Fly"] = 10960.83, ["Ride"] = 4987.5, ["Fly|Ride"] = 5118.74, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 9.5, ["Fly"] = 47.29, ["Ride"] = 35.35, ["Fly|Ride"] = 104.82, ["Neon"] = 77.42, ["Neon|Ride"] = 78.6, ["Neon|Fly|Ride"] = 154.91, ["Mega"] = 517.85, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.76}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 128.3, ["Fly"] = 363.77, ["Ride"] = 134.89, ["Fly|Ride"] = 170.63, ["Neon"] = 485.63, ["Neon|Ride"] = 508.58, ["Neon|Fly|Ride"] = 494.48, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 47.24, ["Fly"] = 92.48, ["Ride"] = 92.49, ["Fly|Ride"] = 164.4, ["Neon"] = 231.08, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 712.58, ["Mega"] = 2311.8, ["Mega|Ride"] = 2774.39, ["Mega|Fly|Ride"] = 1630.73}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 25.88, ["Fly"] = 70.46, ["Ride"] = 29.33, ["Fly|Ride"] = 69.65, ["Neon"] = 201.38, ["Neon|Ride"] = 115.4, ["Neon|Fly|Ride"] = 192.56, ["Mega"] = 1016.21, ["Mega|Ride"] = 817.23, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.07, ["Fly"] = 59.61, ["Ride"] = 27.57, ["Fly|Ride"] = 59.07, ["Neon"] = 32.82, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 154.91, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 216.28, ["Mega|Fly|Ride"] = 315.69}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 7.88, ["Fly"] = 137.7, ["Ride"] = 31.36, ["Fly|Ride"] = 61.66, ["Neon"] = 102.76, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 160.13, ["Mega"] = 716.67, ["Mega|Ride"] = 508.65, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.3, ["Fly"] = 26.25, ["Ride"] = 23.2, ["Fly|Ride"] = 50.73, ["Neon"] = 205.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 141.69, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 210}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 26.73, ["Ride"] = 129.94, ["Neon"] = 131.25, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 220.92, ["Fly"] = 462.31, ["Ride"] = 443.63, ["Fly|Ride"] = 1541.76, ["Neon"] = 1232.91}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.66, ["Fly"] = 212.01, ["Ride"] = 91.88, ["Fly|Ride"] = 178.81, ["Neon"] = 233.24, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 480.88, ["Mega"] = 905.62, ["Mega|Ride"] = 2143.04, ["Mega|Fly|Ride"] = 1182.01}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1152.27, ["Ride"] = 935.82, ["Fly|Ride"] = 997.5, ["Neon|Fly"] = 3997.28, ["Neon|Ride"] = 3123.37, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11733.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 386.37, ["Fly"] = 462.31, ["Ride"] = 376.69, ["Fly|Ride"] = 393.75, ["Neon"] = 2834.27, ["Neon|Ride"] = 2054.84, ["Neon|Fly|Ride"] = 1919.47, ["Mega"] = 8117.61, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 59.6}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.5}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.55, ["Fly"] = 55.38, ["Ride"] = 23.65, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 115.55, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 262.39, ["Fly"] = 411.03, ["Ride"] = 329.05, ["Fly|Ride"] = 428.73, ["Neon"] = 1082.91, ["Neon|Ride"] = 883.58, ["Neon|Fly|Ride"] = 1065.99, ["Mega|Ride"] = 3288.15, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.61}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 160.13, ["Ride"] = 219.19, ["Fly|Ride"] = 321.57, ["Neon"] = 674.14, ["Neon|Fly"] = 1713.74, ["Neon|Ride"] = 684.28, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 9864.44, ["Mega|Ride"] = 11689.36, ["Mega|Fly|Ride"] = 2576.06}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 130.52, ["Ride"] = 128.63, ["Fly|Ride"] = 173.31, ["Neon"] = 671.95, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2412.69}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.23, ["Ride"] = 25.89, ["Fly|Ride"] = 167.5, ["Neon"] = 39.34, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 191.62, ["Mega"] = 264.75, ["Mega|Ride"] = 493.24, ["Mega|Fly|Ride"] = 811.78}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.9, ["Fly"] = 63, ["Ride"] = 29.3, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 800.47, ["Mega|Fly|Ride"] = 582.63}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.42, ["Fly"] = 102.31, ["Ride"] = 44.61, ["Fly|Ride"] = 128.84, ["Neon"] = 68.85, ["Neon|Ride"] = 130.49, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 462.31, ["Mega|Ride"] = 493.97, ["Mega|Fly|Ride"] = 684.36}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 7.87, ["Fly"] = 94.5, ["Ride"] = 52.55, ["Fly|Ride"] = 170.6, ["Neon"] = 20.56, ["Neon|Fly"] = 199.34, ["Neon|Ride"] = 64.79, ["Neon|Fly|Ride"] = 155.29, ["Mega"] = 162.75, ["Mega|Fly"] = 307.25, ["Mega|Ride"] = 174.88, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 265.09, ["Ride"] = 262.5, ["Fly|Ride"] = 343.17, ["Neon"] = 1613.06, ["Neon|Ride"] = 1232.91, ["Neon|Fly|Ride"] = 1286.38, ["Mega|Fly|Ride"] = 5206.58}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 129.94, ["Fly"] = 548.72, ["Ride"] = 177.5, ["Fly|Ride"] = 343.22, ["Neon"] = 1438.4, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1233.37, ["Mega"] = 9864.44, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3412.49}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 81.15, ["Fly"] = 167.45, ["Ride"] = 101.73, ["Fly|Ride"] = 184.87, ["Neon"] = 354.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 479.89, ["Mega|Fly|Ride"] = 1466.33}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 68.86, ["Fly|Ride"] = 274.34, ["Neon|Ride"] = 586.9, ["Neon|Fly|Ride"] = 479.89, ["Mega|Ride"] = 408.5, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.6, ["Fly"] = 75.63, ["Ride"] = 39.27, ["Fly|Ride"] = 96.6, ["Neon"] = 77.44, ["Neon|Fly"] = 205.5, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 319.05, ["Mega|Fly"] = 525, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.86, ["Fly"] = 47.29, ["Ride"] = 19.69, ["Fly|Ride"] = 81.99, ["Neon"] = 19.34, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 130.52, ["Mega"] = 131.25, ["Mega|Ride"] = 158.52, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1082.72, ["Ride"] = 1010.63, ["Fly|Ride"] = 1025.43, ["Neon"] = 2927.5, ["Neon|Fly"] = 3389.6, ["Neon|Ride"] = 2852.62, ["Neon|Fly|Ride"] = 2413.68, ["Mega|Fly|Ride"] = 8082.38}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 393.75, ["Ride"] = 453.1, ["Fly|Ride"] = 526.05, ["Neon|Ride"] = 1290.48, ["Neon|Fly|Ride"] = 1919.24, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.43, ["Ride"] = 103.69, ["Fly|Ride"] = 193.17, ["Neon"] = 339.94, ["Neon|Ride"] = 301.46, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1572.04, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 1576.31}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 262.5, ["Fly"] = 356.57, ["Ride"] = 252.79, ["Fly|Ride"] = 274.32, ["Neon|Ride"] = 1386.35, ["Neon|Fly|Ride"] = 1055.31, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.92, ["Fly"] = 137.7, ["Ride"] = 26.29, ["Fly|Ride"] = 69.96, ["Neon"] = 131.25, ["Neon|Ride"] = 212.59, ["Neon|Fly|Ride"] = 229.69, ["Mega|Fly|Ride"] = 617.26}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 220.77, ["Ride"] = 280.74, ["Fly|Ride"] = 489.57, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4102.55, ["Mega|Ride"] = 4247.88, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 57.75, ["Fly"] = 76.13, ["Ride"] = 39.38, ["Fly|Ride"] = 130.6, ["Neon|Ride"] = 513.73, ["Neon|Fly|Ride"] = 548.72, ["Mega|Fly|Ride"] = 1233.37}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1658.48, ["Ride"] = 1684.16, ["Fly|Ride"] = 1767.18, ["Neon|Ride"] = 10783.4, ["Neon|Fly|Ride"] = 5206.58, ["Mega"] = 49322.13, ["Mega|Fly|Ride"] = 23291.36}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.53, ["Fly"] = 102.77, ["Ride"] = 41.11, ["Fly|Ride"] = 98.37, ["Neon"] = 61.6, ["Neon|Fly"] = 184.7, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 310.01, ["Mega|Fly"] = 369.9, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 351.8}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.49, ["Fly"] = 119.1, ["Ride"] = 74, ["Fly|Ride"] = 157.5, ["Neon"] = 270.36, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 882.68, ["Mega|Ride"] = 1005.98, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 82.04, ["Fly"] = 91.85, ["Ride"] = 91.88, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 466.47, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2590.88, ["Ride"] = 2311.47, ["Fly|Ride"] = 1168.13, ["Neon|Fly|Ride"] = 7398.33, ["Mega|Fly|Ride"] = 20652.43}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 539.67, ["Fly"] = 820, ["Ride"] = 672.04, ["Fly|Ride"] = 668.03, ["Neon"] = 2465.38, ["Neon|Fly|Ride"] = 2697.87, ["Mega|Fly|Ride"] = 16954.72}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 65.63, ["Fly"] = 105, ["Ride"] = 184.94, ["Fly|Ride"] = 203.13, ["Neon"] = 444.29, ["Neon|Fly"] = 616.46, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 575.45, ["Mega"] = 4110.2, ["Mega|Ride"] = 2596.61, ["Mega|Fly|Ride"] = 2137.31}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.5, ["Ride"] = 19.69, ["Fly|Ride"] = 91.68, ["Neon"] = 87.94, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 180.87, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1370.76}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.82, ["Ride"] = 48.43, ["Fly|Ride"] = 106.34, ["Neon"] = 196.88, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1191.96, ["Mega|Fly|Ride"] = 952.54}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 874.13, ["Fly|Ride"] = 904.58, ["Neon"] = 3014.45, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2620.43, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 711.81}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5891.95, ["Ride"] = 4987.5, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29446.78, ["Neon|Fly|Ride"] = 23976.72, ["Mega|Fly|Ride"] = 87684.44}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 253.32, ["Fly"] = 406.82, ["Ride"] = 293.57, ["Fly|Ride"] = 367.5, ["Neon"] = 1643.87, ["Neon|Fly|Ride"] = 2055.11, ["Mega"] = 6164.25, ["Mega|Fly|Ride"] = 6165.57}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 80.35, ["Fly"] = 274.37, ["Ride"] = 100.71, ["Fly|Ride"] = 336, ["Neon"] = 410.99, ["Neon|Ride"] = 513.73, ["Neon|Fly|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 2862.75}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.66, ["Fly"] = 96.6, ["Ride"] = 26.24, ["Fly|Ride"] = 39.38, ["Neon"] = 123.63, ["Neon|Fly"] = 1232.69, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.61, ["Mega|Ride"] = 717.24, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.81, ["Fly"] = 27.76, ["Ride"] = 27.54, ["Fly|Ride"] = 45.94, ["Neon"] = 205.5, ["Neon|Fly"] = 274.34, ["Neon|Ride"] = 308.47, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2178.41}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.35, ["Fly"] = 274.37, ["Ride"] = 31.5, ["Fly|Ride"] = 140.44, ["Neon"] = 154.88, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 147.98, ["Mega"] = 670.69, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.05, ["Fly"] = 21, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 22.91, ["Neon|Fly"] = 339.06, ["Neon|Ride"] = 49.33, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 274.37, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 308.63}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.68, ["Ride"] = 43.31, ["Fly|Ride"] = 96.59, ["Neon"] = 178.78, ["Neon|Fly"] = 821.94, ["Neon|Ride"] = 223.99, ["Neon|Fly|Ride"] = 328.82, ["Mega"] = 767.6, ["Mega|Ride"] = 657.64, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 360.51, ["Fly"] = 460, ["Ride"] = 295.32, ["Fly|Ride"] = 411.65, ["Neon"] = 1207.5, ["Neon|Fly"] = 1454.84, ["Neon|Ride"] = 1219.56, ["Neon|Fly|Ride"] = 1239, ["Mega"] = 7875, ["Mega|Fly"] = 4520.18, ["Mega|Ride"] = 4521.2, ["Mega|Fly|Ride"] = 4622.93}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.46, ["Fly"] = 15.64, ["Ride"] = 15.47, ["Fly|Ride"] = 27.81, ["Neon"] = 19.69, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 69.34, ["Mega"] = 131.25, ["Mega|Ride"] = 539.82, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 43.31, ["Fly"] = 84.98, ["Ride"] = 75.39, ["Fly|Ride"] = 115.5, ["Neon"] = 155.93, ["Neon|Fly"] = 289.27, ["Neon|Ride"] = 200.07, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 577.5, ["Mega|Fly"] = 822.05, ["Mega|Ride"] = 572.24, ["Mega|Fly|Ride"] = 590.56}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 812.11, ["Fly"] = 970.82, ["Ride"] = 784.59, ["Fly|Ride"] = 808.5, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1443.74, ["Mega|Fly|Ride"] = 3778.68}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.95, ["Fly"] = 91.88, ["Ride"] = 45.56, ["Fly|Ride"] = 57.14, ["Neon"] = 205.5, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 324.84, ["Ride"] = 288.65, ["Fly|Ride"] = 349.13, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 13870.78}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 150.94, ["Fly"] = 240.41, ["Ride"] = 190.31, ["Fly|Ride"] = 198.38, ["Neon"] = 627.29, ["Neon|Ride"] = 807.19, ["Neon|Fly|Ride"] = 685.38, ["Mega|Fly|Ride"] = 3288.15}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 713.1, ["Ride"] = 677.74, ["Fly|Ride"] = 763.59, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2877.14, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.09, ["Ride"] = 40.08, ["Fly|Ride"] = 108.62, ["Neon"] = 62.41, ["Neon|Fly"] = 277.29, ["Neon|Ride"] = 99.38, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 274.37, ["Mega|Ride"] = 353.72, ["Mega|Fly|Ride"] = 512.76}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3176.25, ["Fly"] = 3590.9, ["Ride"] = 3936.19, ["Fly|Ride"] = 3022.98, ["Neon"] = 13699.58, ["Neon|Fly|Ride"] = 6286.85, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 106.32, ["Fly"] = 131.25, ["Ride"] = 137.7, ["Fly|Ride"] = 154.83, ["Neon"] = 546.59, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 520.98, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 17.07, ["Fly|Ride"] = 45.48, ["Neon"] = 22.24, ["Neon|Fly"] = 63.51, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 143.59, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 142.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.46, ["Ride"] = 27.76, ["Fly|Ride"] = 57.78, ["Neon"] = 24.93, ["Neon|Ride"] = 53.44, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 159.99, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 264.34}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 71.94, ["Fly"] = 152.1, ["Ride"] = 39.38, ["Fly|Ride"] = 51.97, ["Neon|Ride"] = 377.08, ["Neon|Fly|Ride"] = 303.14, ["Mega|Fly|Ride"] = 1096.4}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1379.96, ["Fly|Ride"] = 1234.93, ["Neon|Fly|Ride"] = 3937.5}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 5775, ["Ride"] = 7011.83, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 26.73, ["Fly"] = 35.43, ["Ride"] = 27.76, ["Fly|Ride"] = 43.32, ["Neon"] = 548.66, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.43, ["Fly"] = 31.5, ["Ride"] = 26.25, ["Fly|Ride"] = 88.37, ["Neon"] = 65.63, ["Neon|Ride"] = 87.59, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 642.48, ["Mega|Ride"] = 613.79, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 68.85, ["Fly"] = 157.49, ["Ride"] = 62.92, ["Fly|Ride"] = 116.71, ["Neon"] = 459.38, ["Neon|Ride"] = 432.09, ["Neon|Fly|Ride"] = 306, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 227.43, ["Ride"] = 236.25, ["Fly|Ride"] = 324.61, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1082.82, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 3698.88}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.92, ["Ride"] = 32.7, ["Fly|Ride"] = 60.12, ["Neon"] = 23.64, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 133.88, ["Mega|Ride"] = 164.42, ["Mega|Fly|Ride"] = 286.71}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.38, ["Fly"] = 261.01, ["Ride"] = 231.16, ["Fly|Ride"] = 259.88, ["Neon"] = 721.88, ["Neon|Ride"] = 909.22, ["Neon|Fly|Ride"] = 956.66, ["Mega|Fly|Ride"] = 3391.42}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.66, ["Fly"] = 40.08, ["Ride"] = 15.35, ["Fly|Ride"] = 40.69, ["Neon"] = 22.78, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.62, ["Neon|Fly|Ride"] = 106.88, ["Mega"] = 415.14, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 268.82, ["Ride"] = 249.38, ["Fly|Ride"] = 262, ["Neon|Fly|Ride"] = 1109.68, ["Mega"] = 10275.45, ["Mega|Ride"] = 4110.2, ["Mega|Fly|Ride"] = 4083.48}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 35.98, ["Ride"] = 26.73, ["Fly|Ride"] = 52.5, ["Neon"] = 61.42, ["Neon|Fly"] = 293.46, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 194.91, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 22.93, ["Fly|Ride"] = 59.07, ["Neon"] = 9.19, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.19, ["Neon|Fly|Ride"] = 176.78, ["Mega"] = 76.67, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 185.71}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 41.11, ["Mega"] = 22.89, ["Mega|Ride"] = 137.49}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.73, ["Fly"] = 52.48, ["Ride"] = 26.25, ["Fly|Ride"] = 213.71, ["Neon"] = 6.14, ["Neon|Ride"] = 40.16, ["Neon|Fly|Ride"] = 131.22, ["Mega"] = 68.16, ["Mega|Fly"] = 154120.45, ["Mega|Ride"] = 90.21, ["Mega|Fly|Ride"] = 158.47}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 65.24, ["Fly"] = 138.7, ["Ride"] = 114.97, ["Fly|Ride"] = 197.28, ["Neon"] = 308.61, ["Neon|Ride"] = 373.99, ["Neon|Fly|Ride"] = 340.8, ["Mega|Ride"] = 1315.27, ["Mega|Fly|Ride"] = 1085.82}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.53, ["Ride"] = 15.65, ["Fly|Ride"] = 103.47, ["Neon"] = 4.32, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 72.83, ["Mega"] = 129.94, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.9, ["Neon"] = 71.92, ["Neon|Ride"] = 210, ["Mega|Ride"] = 540.5}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 45.18, ["Neon|Fly|Ride"] = 34.96, ["Mega"] = 14.21, ["Mega|Ride"] = 55.58, ["Mega|Fly|Ride"] = 206.63}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 14.6, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 12.48, ["Neon|Fly|Ride"] = 31.08, ["Mega"] = 13.77, ["Mega|Fly"] = 40.08, ["Mega|Ride"] = 19.28, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 12.45, ["Fly|Ride"] = 39.26, ["Neon"] = 2.43, ["Neon|Fly"] = 39.26, ["Neon|Ride"] = 15.61, ["Neon|Fly|Ride"] = 45.31, ["Mega"] = 28.88, ["Mega|Fly"] = 154.91, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 108.81}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 102.76, ["Mega"] = 16.89, ["Mega|Ride"] = 120.62}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 2.52, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.17, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 96.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 19.69, ["Mega|Ride"] = 99.42}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.52, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 70.12, ["Neon"] = 7.77, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.21, ["Mega"] = 98.24, ["Mega|Fly"] = 155.3, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.29, ["Neon"] = 2.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 14.43, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 184.97}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.7, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 11.63, ["Mega"] = 105, ["Mega|Ride"] = 102.77, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.94, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 19.69, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 144.94}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.43, ["Fly|Ride"] = 20.56, ["Neon"] = 2.1, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 12.9, ["Neon|Fly|Ride"] = 30.51, ["Mega"] = 15.17, ["Mega|Fly"] = 39.25, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 62.44}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 104.98, ["Neon"] = 34.91, ["Neon|Ride"] = 41.11, ["Mega"] = 261.01, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.27, ["Neon"] = 3.94, ["Neon|Ride"] = 25.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 40.84, ["Mega|Fly|Ride"] = 159.53}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 9.9, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 82.08, ["Mega|Ride"] = 150.5, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 43.32, ["Neon"] = 12.9, ["Neon|Fly"] = 102.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.6, ["Ride"] = 15.43, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 14.74, ["Neon|Ride"] = 11.99, ["Neon|Fly|Ride"] = 27.62, ["Mega"] = 15.75, ["Mega|Fly"] = 28.25, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 45.23}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 20.51, ["Fly|Ride"] = 137.69, ["Neon"] = 14.43, ["Neon|Ride"] = 110.92, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 78.75, ["Mega|Ride"] = 154.04, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Ride"] = 21.77, ["Fly|Ride"] = 59.06, ["Neon"] = 54.52, ["Neon|Ride"] = 67.1, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 203.44, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 12.99, ["Fly|Ride"] = 26.17, ["Neon"] = 3.94, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 14.54, ["Neon|Fly|Ride"] = 45.04, ["Mega|Fly"] = 1312.5, ["Mega|Ride"] = 61.66, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 6.07, ["Fly"] = 171.62, ["Ride"] = 28.73, ["Neon"] = 5.16, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 97.06, ["Mega"] = 68.16, ["Mega|Fly"] = 164.42, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 359.65}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.73, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 31.87, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 18.51, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 135.35}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.6, ["Ride"] = 22.57, ["Fly|Ride"] = 41.91, ["Neon"] = 2.63, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 75.48, ["Mega"] = 77.35, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 199.36}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Fly|Ride"] = 43.32, ["Neon"] = 3.82, ["Neon|Ride"] = 43.32, ["Mega"] = 37.74, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 15.75, ["Fly|Ride"] = 44.88, ["Neon"] = 3.84, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 7.88, ["Ride"] = 67.83, ["Neon"] = 36.66, ["Mega"] = 133.88, ["Mega|Fly"] = 380.63, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 16.7, ["Fly|Ride"] = 137.69, ["Neon"] = 18.56, ["Neon|Fly"] = 104.25, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 303.14, ["Mega|Fly"] = 420, ["Mega|Ride"] = 145.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.62, ["Ride"] = 19.53, ["Fly|Ride"] = 39, ["Neon"] = 19.59, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.32, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 273.34, ["Mega|Fly"] = 410.01, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 219.91}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 3.52, ["Fly|Ride"] = 137.7, ["Neon"] = 30.98, ["Mega"] = 177.28, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.55, ["Ride"] = 131.25, ["Neon"] = 109.95, ["Neon|Ride"] = 231.08, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.94, ["Ride"] = 64.89, ["Neon"] = 38.67, ["Neon|Ride"] = 125.71, ["Mega"] = 253.32, ["Mega|Ride"] = 213.75}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.03, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 47.29, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 245.6, ["Mega|Ride"] = 248.06, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 64.98, ["Mega"] = 22.23, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 147.98}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.8}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.93, ["Fly"] = 22.91, ["Ride"] = 21.95, ["Fly|Ride"] = 41.11, ["Neon"] = 34.04, ["Neon|Ride"] = 47.77, ["Neon|Fly|Ride"] = 100.52, ["Mega"] = 274.37, ["Mega|Fly"] = 328.82, ["Mega|Ride"] = 344.43, ["Mega|Fly|Ride"] = 254.46}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.53, ["Neon"] = 2.1, ["Neon|Ride"] = 26.6, ["Mega"] = 25.88, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 55.51, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.6, ["Fly|Ride"] = 274.37, ["Neon"] = 3.84, ["Neon|Ride"] = 35.32, ["Neon|Fly|Ride"] = 404.88, ["Mega"] = 39.29, ["Mega|Ride"] = 71.7, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.44, ["Ride"] = 15.68, ["Fly|Ride"] = 55.13, ["Neon"] = 6.34, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 141.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.02, ["Ride"] = 36.75, ["Fly|Ride"] = 58.57, ["Neon"] = 35.03, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 212.24, ["Mega"] = 328.13, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 14.23, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 47.46, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 16.05, ["Fly|Ride"] = 273977.92, ["Neon"] = 6.18, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 69.36, ["Mega"] = 31.39, ["Mega|Ride"] = 47.94, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 14.74, ["Fly|Ride"] = 34.13, ["Neon"] = 8.28, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 37.09, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 201.14}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 32.16, ["Fly|Ride"] = 146.73, ["Neon"] = 3.29, ["Neon|Ride"] = 33.12, ["Neon|Fly|Ride"] = 158.25, ["Mega"] = 23.07, ["Mega|Fly"] = 123.69, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.31, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.3, ["Mega"] = 17.36, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 86.7, ["Mega|Fly|Ride"] = 144.75}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.44, ["Ride"] = 18.27, ["Fly|Ride"] = 77.07, ["Neon"] = 2.52, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 22.01, ["Neon|Fly|Ride"] = 65, ["Mega"] = 18.79, ["Mega|Fly"] = 61.66, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.3, ["Neon"] = 2.1, ["Neon|Ride"] = 68.85, ["Mega"] = 39.38, ["Mega|Ride"] = 211.68}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.42, ["Neon|Ride"] = 154.83, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21, ["Mega|Ride"] = 154.76, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 22.62, ["Fly|Ride"] = 49.88, ["Neon"] = 3.93, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 40.47, ["Mega"] = 44.01, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 92.34}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 11.31, ["Ride"] = 138.7, ["Neon"] = 95.81, ["Mega"] = 315, ["Mega|Ride"] = 427.48, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.63, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 54.76, ["Neon|Ride"] = 203.45, ["Mega"] = 1564.97, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Fly|Ride"] = 410.92, ["Neon"] = 30.74, ["Mega"] = 295.25, ["Mega|Ride"] = 341, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.15, ["Ride"] = 15.43, ["Fly|Ride"] = 24.24, ["Neon"] = 2.1, ["Neon|Fly"] = 11.31, ["Neon|Ride"] = 12.26, ["Neon|Fly|Ride"] = 28.59, ["Mega"] = 14.74, ["Mega|Fly"] = 22.32, ["Mega|Ride"] = 22.11, ["Mega|Fly|Ride"] = 51.23}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 57.56, ["Fly|Ride"] = 109.95, ["Neon"] = 3.94, ["Neon|Fly"] = 89.87, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 51.66, ["Mega|Ride"] = 114.07}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 54.57, ["Mega"] = 15.39, ["Mega|Fly"] = 83.16, ["Mega|Fly|Ride"] = 130.52}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.32, ["Neon"] = 3.92, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 102.76, ["Mega"] = 39.06, ["Mega|Ride"] = 101.74, ["Mega|Fly|Ride"] = 152.1}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 3.15, ["Fly"] = 35.14, ["Ride"] = 15.65, ["Fly|Ride"] = 45.93, ["Neon"] = 10.5, ["Neon|Fly"] = 65.6, ["Neon|Ride"] = 35.88, ["Neon|Fly|Ride"] = 92.49, ["Mega"] = 208.85, ["Mega|Ride"] = 204.5, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.37, ["Ride"] = 171.62, ["Fly|Ride"] = 821.94, ["Neon"] = 1015.1, ["Neon|Ride"] = 822.94, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 3412.49}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 12.35, ["Neon|Ride"] = 82.21, ["Mega"] = 69.64, ["Mega|Ride"] = 108.67, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.73, ["Fly"] = 63.03, ["Ride"] = 25.57, ["Neon"] = 22.32, ["Neon|Ride"] = 92.45, ["Neon|Fly|Ride"] = 164.4, ["Mega"] = 350.83, ["Mega|Ride"] = 512.76, ["Mega|Fly|Ride"] = 401.12}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.43, ["Fly|Ride"] = 31.24, ["Neon"] = 4.6, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 55.51, ["Mega"] = 49.67, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 137.7}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.02, ["Neon|Fly"] = 548.66, ["Neon|Ride"] = 93.51, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 96.5, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.46, ["Fly"] = 17.99, ["Ride"] = 17.07, ["Fly|Ride"] = 35.44, ["Neon"] = 24.86, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 73.29, ["Mega|Ride"] = 267.18, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 6.96, ["Ride"] = 34.12, ["Fly|Ride"] = 249.58, ["Neon"] = 52.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 610.38, ["Mega"] = 337.03, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.64, ["Ride"] = 14.74, ["Fly|Ride"] = 36.74, ["Neon"] = 15.54, ["Neon|Fly"] = 68.76, ["Neon|Ride"] = 53.44, ["Neon|Fly|Ride"] = 67.93, ["Mega"] = 131.25, ["Mega|Ride"] = 233.26, ["Mega|Fly|Ride"] = 218.22}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.86, ["Fly"] = 168.53, ["Ride"] = 86.85, ["Fly|Ride"] = 162.75, ["Neon"] = 346.32, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 384.95, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2055.11}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 328.82, ["Ride"] = 205.52, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 959.62, ["Neon|Fly|Ride"] = 1232.97, ["Mega"] = 10275.45, ["Mega|Fly|Ride"] = 3973.53}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 100.56, ["Ride"] = 77.44, ["Fly|Ride"] = 111.78, ["Neon"] = 685.4, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 360.29, ["Mega|Ride"] = 1232.04, ["Mega|Fly|Ride"] = 1051.02}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 7.72, ["Fly"] = 96.6, ["Ride"] = 24.68, ["Fly|Ride"] = 50.85, ["Neon"] = 22.67, ["Neon|Ride"] = 69.56, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 158.82, ["Mega|Ride"] = 375.38, ["Mega|Fly|Ride"] = 262.65}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.78, ["Fly"] = 68.86, ["Ride"] = 36.75, ["Fly|Ride"] = 89.25, ["Neon"] = 72.09, ["Neon|Ride"] = 82.4, ["Mega"] = 353.07, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 393}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.64, ["Fly|Ride"] = 44.51, ["Neon"] = 2.63, ["Neon|Fly"] = 25.43, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 114.6, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.44, ["Fly"] = 27.76, ["Ride"] = 25.44, ["Fly|Ride"] = 296.83, ["Neon"] = 91.12, ["Neon|Fly"] = 343.17, ["Neon|Ride"] = 159.45, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 1837.5, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 16.48, ["Fly|Ride"] = 52.5, ["Neon"] = 15.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 97.55, ["Mega"] = 187.69, ["Mega|Fly"] = 86.7, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 26.6, ["Fly|Ride"] = 328.13, ["Neon"] = 27.62, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 207.38, ["Mega|Ride"] = 231.19, ["Mega|Fly|Ride"] = 421.87}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 35.98, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 47.29, ["Mega"] = 14.44, ["Mega|Fly"] = 41.11, ["Mega|Ride"] = 41.11, ["Mega|Fly|Ride"] = 208061.56}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 17.57, ["Ride"] = 18.05, ["Fly|Ride"] = 39.38, ["Neon"] = 12.18, ["Neon|Fly"] = 102.76, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 76.7, ["Mega|Ride"] = 96.84, ["Mega|Fly|Ride"] = 206.73}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.84, ["Fly"] = 24.93, ["Ride"] = 18.52, ["Fly|Ride"] = 45.94, ["Neon"] = 27.76, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 119.21, ["Mega"] = 283.5, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 220.79}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 142.7, ["Fly"] = 246.63, ["Ride"] = 190.32, ["Fly|Ride"] = 266.16, ["Neon"] = 685.13, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 613.64, ["Mega|Fly|Ride"] = 3562.51}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 12.44, ["Ride"] = 30.83, ["Fly|Ride"] = 205.5, ["Neon"] = 72.19, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 343.22, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.94, ["Fly|Ride"] = 43.32, ["Neon"] = 67.82, ["Neon|Ride"] = 49.33, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.97, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 89.4, ["Neon|Ride"] = 80.06, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 462.35, ["Mega|Fly"] = 822.05, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 684.36}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 4.94, ["Ride"] = 28.49, ["Neon"] = 24.61, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 385.34, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 820}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.45, ["Fly"] = 35.49, ["Ride"] = 35.44, ["Fly|Ride"] = 57.78, ["Neon"] = 178.78, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 159.38, ["Neon|Fly|Ride"] = 135.97, ["Mega"] = 1781.77, ["Mega|Fly|Ride"] = 1781.77}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 20.56, ["Fly|Ride"] = 102.77, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 33.79, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 225.25}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.83, ["Fly"] = 27.81, ["Ride"] = 27.76, ["Fly|Ride"] = 61.66, ["Neon"] = 45.45, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 231.08, ["Mega"] = 231.19, ["Mega|Fly"] = 386.08, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 303.14}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.13, ["Fly|Ride"] = 45.65, ["Neon"] = 14.44, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.41, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 144.38, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 34.35, ["Fly|Ride"] = 205.5, ["Neon"] = 2.88, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 31.21, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.5, ["Fly"] = 51.45, ["Ride"] = 86.63, ["Neon"] = 252.76, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 959.75, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.03, ["Ride"] = 53.18, ["Fly|Ride"] = 210, ["Neon"] = 72.19, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 462.37}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.88, ["Fly"] = 96.6, ["Ride"] = 27.71, ["Fly|Ride"] = 93.51, ["Neon"] = 77.07, ["Neon|Fly"] = 315, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 100.71, ["Mega"] = 214.45, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 72.19, ["Fly"] = 433.12, ["Ride"] = 178.81, ["Fly|Ride"] = 262.44, ["Neon"] = 548.66, ["Neon|Ride"] = 410.99, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.44, ["Fly"] = 45.94, ["Ride"] = 30.26, ["Fly|Ride"] = 55.5, ["Neon"] = 48.56, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 129.49, ["Mega"] = 254.59, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 279.8}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 75.02, ["Fly"] = 145.69, ["Ride"] = 94.85, ["Fly|Ride"] = 184.95, ["Neon"] = 217.95, ["Neon|Fly"] = 525, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 410.01, ["Mega"] = 1067.63, ["Mega|Ride"] = 1066.61, ["Mega|Fly|Ride"] = 914.43}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 25.1, ["Ride"] = 57.18, ["Fly|Ride"] = 131.25, ["Neon"] = 102.45, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 240.42, ["Mega"] = 470.64, ["Mega|Ride"] = 305.69, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.92, ["Ride"] = 27.57, ["Fly|Ride"] = 48.29, ["Neon"] = 123.2, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 247.37, ["Mega"] = 416.96, ["Mega|Ride"] = 1027.56, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 17.07, ["Ride"] = 108.94, ["Fly|Ride"] = 156.33, ["Neon"] = 98.44, ["Neon|Ride"] = 106.76, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.14, ["Mega|Ride"] = 257.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.69, ["Ride"] = 41.11, ["Fly|Ride"] = 137.69, ["Neon"] = 41.11, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 154.91, ["Mega"] = 221.82, ["Mega|Ride"] = 318.88, ["Mega|Fly|Ride"] = 332.01}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 57.1, ["Neon|Fly|Ride"] = 89.41, ["Mega"] = 18.38, ["Mega|Ride"] = 102.77, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.16, ["Ride"] = 27.65, ["Neon"] = 19.48, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.97, ["Mega|Ride"] = 189.08, ["Mega|Fly|Ride"] = 397.67}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.51, ["Neon"] = 23.63, ["Mega"] = 196.23, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 32.79, ["Fly|Ride"] = 115.55, ["Neon"] = 18.51, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.36, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 564.37, ["Ride"] = 525, ["Fly|Ride"] = 632.21, ["Neon"] = 1781.55, ["Neon|Ride"] = 1766.19, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.44, ["Fly"] = 27.76, ["Ride"] = 23.65, ["Fly|Ride"] = 62.43, ["Neon"] = 32.89, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 154.91, ["Mega|Ride"] = 354.88, ["Mega|Fly|Ride"] = 480.87}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.57, ["Fly"] = 524.48, ["Ride"] = 23.65, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 67.82, ["Neon|Fly|Ride"] = 231.19, ["Mega"] = 303.14, ["Mega|Ride"] = 347.22, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.71, ["Fly"] = 96.6, ["Ride"] = 16.44, ["Fly|Ride"] = 61.69, ["Neon|Ride"] = 196.88, ["Mega"] = 260.09, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.18, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 115.4, ["Mega"] = 62.51, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 120.1, ["Mega|Fly|Ride"] = 231.95}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 87.35, ["Mega"] = 24.97, ["Mega|Fly"] = 192.18, ["Mega|Ride"] = 143.88, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.46, ["Ride"] = 35.93, ["Fly|Ride"] = 323.64, ["Neon"] = 59.07, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 397.67, ["Mega|Ride"] = 365.28, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 23.76, ["Neon"] = 6.57, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 40.85, ["Mega|Ride"] = 154.14, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.95, ["Fly|Ride"] = 99.75, ["Neon"] = 11.59, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 183.73, ["Mega|Ride"] = 271.28, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 431.44, ["Fly|Ride"] = 556.07, ["Neon|Ride"] = 1438.4, ["Neon|Fly|Ride"] = 1347.76, ["Mega|Fly|Ride"] = 8006.25}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.67, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.99, ["Neon"] = 56.35, ["Neon|Ride"] = 71.36, ["Neon|Fly|Ride"] = 186.63, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 76.36, ["Ride"] = 34.96, ["Fly|Ride"] = 160.3, ["Neon"] = 4.13, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 43.55, ["Mega|Fly"] = 189, ["Mega|Ride"] = 95.95, ["Mega|Fly|Ride"] = 245.07}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 113.32, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 27.46, ["Mega|Ride"] = 115.99, ["Mega|Fly|Ride"] = 162.09}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.05, ["Fly"] = 107.63, ["Ride"] = 68.83, ["Fly|Ride"] = 85.54, ["Neon"] = 102.76, ["Neon|Ride"] = 57.29, ["Neon|Fly|Ride"] = 343.22, ["Mega"] = 447.36, ["Mega|Ride"] = 400.76, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.71, ["Ride"] = 41.11, ["Fly|Ride"] = 105, ["Neon"] = 108.62, ["Neon|Ride"] = 123.31, ["Neon|Fly|Ride"] = 141.65, ["Mega"] = 421.31, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.74, ["Ride"] = 39.32, ["Fly|Ride"] = 409.96, ["Neon"] = 308.47, ["Neon|Ride"] = 154.83, ["Mega"] = 632.29, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 1233.37}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 13.55, ["Ride"] = 22.67, ["Neon"] = 274.34, ["Neon|Ride"] = 177.51, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 548.72, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Fly"] = 462.31, ["Ride"] = 431.59, ["Fly|Ride"] = 616.46, ["Neon"] = 2876.78, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.68, ["Fly"] = 69.65, ["Ride"] = 22.62, ["Fly|Ride"] = 131.25, ["Neon"] = 109.28, ["Neon|Fly"] = 185.07, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 174.69, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 848.76}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.2, ["Ride"] = 69.98, ["Neon"] = 27.76, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 21.51, ["Ride"] = 70.23, ["Fly|Ride"] = 255.33, ["Neon"] = 68.25, ["Neon|Ride"] = 130.16, ["Neon|Fly|Ride"] = 287.74, ["Mega"] = 236.25, ["Mega|Fly"] = 685.38, ["Mega|Ride"] = 275.61, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.43, ["Fly"] = 41.11, ["Ride"] = 42, ["Fly|Ride"] = 137.7, ["Neon"] = 6.45, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 204.5, ["Mega"] = 44.63, ["Mega|Fly"] = 105, ["Mega|Ride"] = 94.55, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.27, ["Ride"] = 91.88, ["Neon"] = 205.5, ["Neon|Ride"] = 260.97, ["Neon|Fly|Ride"] = 655.4, ["Mega"] = 1370.76, ["Mega|Ride"] = 1343.02, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 577.88, ["Ride"] = 27.2, ["Neon"] = 8.17, ["Neon|Fly"] = 178.78, ["Neon|Ride"] = 63.66, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 74.31, ["Mega|Ride"] = 107.23, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 35.85, ["Ride"] = 27.57, ["Fly|Ride"] = 149.76, ["Neon"] = 3.94, ["Neon|Fly"] = 49.39, ["Neon|Ride"] = 38.82, ["Neon|Fly|Ride"] = 77.46, ["Mega"] = 39.06, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 72.72, ["Mega|Fly|Ride"] = 178.81}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.23, ["Fly"] = 91.88, ["Ride"] = 31.22, ["Fly|Ride"] = 122.48, ["Neon"] = 12.5, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 77.42, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 101.73, ["Fly"] = 92.48, ["Ride"] = 78.75, ["Fly|Ride"] = 193.03, ["Neon"] = 291.38, ["Neon|Ride"] = 282.76, ["Neon|Fly|Ride"] = 412.56, ["Mega|Ride"] = 1027.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 271.69, ["Ride"] = 280.51, ["Fly|Ride"] = 413.44, ["Neon"] = 1428.12, ["Neon|Ride"] = 1127.75, ["Neon|Fly|Ride"] = 1039.5, ["Mega"] = 6165.28, ["Mega|Fly|Ride"] = 5240.85}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.15, ["Ride"] = 71.68, ["Neon"] = 17.35, ["Neon|Ride"] = 143.27, ["Mega"] = 94.5, ["Mega|Ride"] = 183.11, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.62, ["Fly"] = 68.86, ["Ride"] = 28.56, ["Fly|Ride"] = 154.83, ["Neon"] = 11.06, ["Neon|Ride"] = 43.12, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 61.6, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 343.22}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.28, ["Fly"] = 30.07, ["Ride"] = 27.56, ["Fly|Ride"] = 174.67, ["Neon"] = 32.81, ["Mega"] = 373.42, ["Mega|Ride"] = 341.29}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 60.74, ["Ride"] = 34.99, ["Neon"] = 7.77, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 86.08, ["Mega|Fly"] = 145.92, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 67.83, ["Neon"] = 9.47, ["Mega"] = 37.52, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 171.62}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 41.99, ["Neon"] = 4.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 37.25, ["Mega|Ride"] = 99.42, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.7, ["Ride"] = 24.94, ["Fly|Ride"] = 56.82, ["Neon"] = 10.21, ["Neon|Fly"] = 63.03, ["Neon|Ride"] = 39.06, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 92.49, ["Mega|Ride"] = 232.23, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.62, ["Ride"] = 42.62, ["Fly|Ride"] = 77.15, ["Neon"] = 192.13, ["Mega"] = 574.42, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.91, ["Fly"] = 582.75, ["Ride"] = 83.76, ["Fly|Ride"] = 110.57, ["Neon"] = 410.99, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 439.74, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 39.32, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 5.16, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 55.51, ["Mega"] = 61.01, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 89.41, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.55, ["Fly"] = 34.96, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 62.41, ["Neon|Fly|Ride"] = 273.34, ["Mega"] = 527.63, ["Mega|Ride"] = 424.23, ["Mega|Fly|Ride"] = 805.61}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.75, ["Fly"] = 413.44, ["Ride"] = 575.45, ["Fly|Ride"] = 492.19, ["Neon"] = 4109.67, ["Neon|Ride"] = 1781.55, ["Mega|Fly|Ride"] = 7192.82}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 43.94, ["Fly"] = 95.81, ["Ride"] = 55.51, ["Fly|Ride"] = 88.46, ["Neon"] = 170.43, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 305.79, ["Mega|Ride"] = 924.81, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.98, ["Fly|Ride"] = 281.29, ["Neon"] = 7.88, ["Neon|Ride"] = 42.58, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 80.16, ["Mega|Ride"] = 133.88, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.26, ["Fly"] = 205.52, ["Ride"] = 65.61, ["Fly|Ride"] = 142.7, ["Neon"] = 23.64, ["Mega|Ride"] = 274.37}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 19.69, ["Fly"] = 76.06, ["Ride"] = 43.3, ["Fly|Ride"] = 82.21, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 363.77, ["Mega"] = 2466.12, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1288.55}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.74, ["Fly"] = 117.16, ["Ride"] = 98.75, ["Fly|Ride"] = 158.25, ["Neon"] = 430.1, ["Neon|Ride"] = 470.57, ["Neon|Fly|Ride"] = 476.79, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 1872.21}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 261.18, ["Ride"] = 235.45, ["Fly|Ride"] = 512.76, ["Neon"] = 712.69, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1256.73, ["Mega"] = 4365.02, ["Mega|Fly|Ride"] = 4301.32}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 13.21, ["Fly"] = 51.19, ["Ride"] = 61.69, ["Fly|Ride"] = 150.94, ["Neon"] = 75.95, ["Neon|Ride"] = 108.55, ["Neon|Fly|Ride"] = 184.96, ["Mega"] = 379.29, ["Mega|Ride"] = 349.13, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 18.59, ["Ride"] = 15.66, ["Fly|Ride"] = 41.9, ["Neon"] = 8.97, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 85.55, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.89, ["Fly"] = 34.83, ["Ride"] = 19.53, ["Fly|Ride"] = 41.1, ["Neon"] = 31.5, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 81.03, ["Mega"] = 376.09, ["Mega|Ride"] = 303.14, ["Mega|Fly|Ride"] = 326.78}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 479.89, ["Ride"] = 357.56, ["Fly|Ride"] = 453.16, ["Neon"] = 2044.58, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega|Fly|Ride"] = 4548.99}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.64, ["Neon"] = 10.5, ["Neon|Ride"] = 59.6, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.76, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.7, ["Ride"] = 18.38, ["Fly|Ride"] = 45.85, ["Neon"] = 49.86, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 154.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.9, ["Ride"] = 116.22, ["Neon"] = 112.88, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 236.23, ["Neon|Fly|Ride"] = 432.32, ["Mega"] = 465.69, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 110.44, ["Fly"] = 209.63, ["Ride"] = 111.57, ["Fly|Ride"] = 164.42, ["Neon|Ride"] = 562.02, ["Neon|Fly|Ride"] = 611.02, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.1, ["Fly"] = 43.18, ["Ride"] = 27.46, ["Fly|Ride"] = 55.5, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 630.93, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 450.06}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 25.44, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 22.32, ["Mega|Ride"] = 273.34, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 72.19, ["Neon"] = 3.84, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 69.67, ["Mega"] = 30.07, ["Mega|Fly"] = 67.79, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 110.82}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.91, ["Fly"] = 411.03, ["Ride"] = 76.06, ["Neon"] = 30.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 80.64, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 151.66, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 351}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1314.63, ["Fly"] = 1525.58, ["Ride"] = 1227.81, ["Fly|Ride"] = 1286.25, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 11517.19}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 488.24, ["Fly"] = 616.54, ["Ride"] = 510.37, ["Fly|Ride"] = 578.48, ["Neon"] = 1781.55, ["Neon|Ride"] = 1919.24, ["Neon|Fly|Ride"] = 2041.75, ["Mega"] = 16440.72, ["Mega|Fly|Ride"] = 9316.13}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 296.08, ["Fly"] = 413.09, ["Ride"] = 370.02, ["Fly|Ride"] = 478.79, ["Neon"] = 656.25, ["Neon|Fly"] = 1232.69, ["Neon|Ride"] = 753.12, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2915.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 287.41, ["Fly"] = 411.03, ["Ride"] = 380.63, ["Fly|Ride"] = 500.36, ["Neon"] = 1000.13, ["Neon|Fly"] = 1079.05, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1172.1, ["Mega|Fly|Ride"] = 4521.2}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 57.74, ["Ride"] = 18.17, ["Fly|Ride"] = 38.06, ["Neon"] = 5.25, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.14, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 392.22, ["Fly"] = 1370.76, ["Ride"] = 462.31, ["Fly|Ride"] = 549.32, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6576.29, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 27.76, ["Fly|Ride"] = 62.41, ["Neon"] = 11.82, ["Neon|Ride"] = 65.77, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 81.1, ["Mega|Ride"] = 181.55, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.43, ["Ride"] = 18.51, ["Fly|Ride"] = 38.98, ["Neon"] = 7.77, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 108.21, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 23.39, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 65.37, ["Ride"] = 108.94, ["Fly|Ride"] = 459.38, ["Neon"] = 192.14, ["Neon|Ride"] = 351.29, ["Mega|Ride"] = 924.74, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7705.26, ["Ride"] = 22.32, ["Fly|Ride"] = 62.31, ["Neon"] = 27.76, ["Neon|Ride"] = 77.42, ["Mega"] = 411.03, ["Mega|Ride"] = 308.28, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.83, ["Neon|Fly"] = 118.1, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 117.06, ["Mega"] = 19.69, ["Mega|Fly"] = 102.77, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 118.19}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 20.56, ["Fly|Ride"] = 66.89, ["Neon"] = 11.24, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 37.01, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 98.65, ["Mega|Fly"] = 171.62, ["Mega|Ride"] = 117.76, ["Mega|Fly|Ride"] = 153.85}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.49, ["Fly"] = 91.88, ["Ride"] = 27.76, ["Fly|Ride"] = 51.45, ["Neon"] = 17.07, ["Neon|Fly"] = 109.95, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 245.6, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 308.63}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.28, ["Fly"] = 190.32, ["Ride"] = 60.64, ["Neon"] = 52.05, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 411.03, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6164.68, ["Ride"] = 26.62, ["Neon"] = 36.02, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 5.44, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.73, ["Neon|Fly|Ride"] = 41.11, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 144.27, ["Fly"] = 227.11, ["Ride"] = 205.52, ["Fly|Ride"] = 201.04, ["Neon|Ride"] = 956.54, ["Neon|Fly|Ride"] = 1079.63, ["Mega"] = 8220.37, ["Mega|Ride"] = 4110.2, ["Mega|Fly|Ride"] = 4096.83}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.23, ["Ride"] = 15.43, ["Fly|Ride"] = 34.44, ["Neon"] = 2.63, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 24.72, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 39.25, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 122.75}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.6, ["Fly"] = 137.7, ["Ride"] = 55.51, ["Fly|Ride"] = 183.74, ["Neon"] = 83.91, ["Neon|Ride"] = 123.31, ["Mega"] = 360.94, ["Mega|Ride"] = 274.25, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 33.17, ["Ride"] = 93.19, ["Fly|Ride"] = 102.92, ["Neon"] = 155.56, ["Neon|Ride"] = 274.34, ["Mega"] = 786.19, ["Mega|Ride"] = 809.15, ["Mega|Fly|Ride"] = 1025.51}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.11, ["Ride"] = 216.79, ["Fly|Ride"] = 323.66, ["Neon"] = 708.73, ["Neon|Fly"] = 1155.3, ["Neon|Fly|Ride"] = 842.63, ["Mega|Ride"] = 3286.1, ["Mega|Fly|Ride"] = 3286.1}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.65, ["Fly"] = 168.88, ["Ride"] = 38.58, ["Fly|Ride"] = 138.7, ["Neon"] = 123.63, ["Neon|Ride"] = 145.34, ["Mega"] = 281.71, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 12.6, ["Ride"] = 137.7, ["Fly|Ride"] = 616.46, ["Neon"] = 96.59, ["Neon|Fly"] = 154.83, ["Neon|Ride"] = 199.5, ["Mega"] = 479.89, ["Mega|Ride"] = 616.54, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 918.75, ["Ride"] = 1077.71, ["Fly|Ride"] = 1149.75, ["Neon"] = 4621.14, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4623.6, ["Mega|Fly|Ride"] = 16954.72}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.66, ["Fly"] = 30.07, ["Ride"] = 19.56, ["Fly|Ride"] = 90.13, ["Neon"] = 40.45, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 200.39, ["Mega"] = 231.19, ["Mega|Ride"] = 233.26, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.94, ["Fly"] = 13563.59, ["Ride"] = 35.96, ["Fly|Ride"] = 135.19, ["Neon"] = 31.19, ["Neon|Ride"] = 91.28, ["Mega"] = 219.91, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 479.89}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.52, ["Fly"] = 81.19, ["Ride"] = 22.62, ["Fly|Ride"] = 69.57, ["Neon"] = 14.52, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.06, ["Mega"] = 91.88, ["Mega|Ride"] = 171.41, ["Mega|Fly|Ride"] = 707.44}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.13, ["Ride"] = 40.08, ["Fly|Ride"] = 81.09, ["Neon"] = 76.39, ["Neon|Ride"] = 79.43, ["Neon|Fly|Ride"] = 173.39, ["Mega"] = 342.57, ["Mega|Ride"] = 334.69, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.94, ["Fly"] = 20.56, ["Ride"] = 18.47, ["Fly|Ride"] = 41.01, ["Neon"] = 19.64, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 92.49, ["Mega"] = 129.15, ["Mega|Ride"] = 158.25, ["Mega|Fly|Ride"] = 270.51}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 21.97, ["Neon"] = 11.82, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 111.57, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 326.78}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 229.69, ["Fly"] = 261.01, ["Ride"] = 229.69, ["Fly|Ride"] = 390.43, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 22.7, ["Fly|Ride"] = 72.19, ["Neon"] = 6.57, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 82.69, ["Mega|Fly"] = 411.03, ["Mega|Ride"] = 114.03, ["Mega|Fly|Ride"] = 244.58}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.64, ["Ride"] = 81.79, ["Fly|Ride"] = 88.87, ["Neon"] = 39.06, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 137.69, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 92.17, ["Ride"] = 26.17, ["Neon"] = 15.32, ["Neon|Ride"] = 93.51, ["Mega"] = 83.99, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 205.52, ["Mega|Fly|Ride"] = 408.87}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 203.23, ["Ride"] = 315, ["Fly|Ride"] = 1096.27, ["Neon"] = 787.5, ["Neon|Fly"] = 1027.44, ["Neon|Ride"] = 816.38, ["Mega"] = 3082.65, ["Mega|Ride"] = 4932.22, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 33.5, ["Fly"] = 60.64, ["Ride"] = 67.83, ["Fly|Ride"] = 158.24, ["Neon"] = 124.68, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 767.6}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.74, ["Ride"] = 38.68, ["Fly|Ride"] = 89.25, ["Neon"] = 78.1, ["Neon|Ride"] = 138.66, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 506.13, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 589.82}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.22, ["Neon"] = 2.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 47.11, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.02}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 78.74, ["Fly"] = 105.84, ["Ride"] = 101.36, ["Fly|Ride"] = 154.55, ["Neon"] = 262.48, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 354.38, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Neon"] = 5.16, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 122.3, ["Mega"] = 51.39, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.42, ["Fly"] = 97.09, ["Ride"] = 34.13, ["Fly|Ride"] = 79.77, ["Neon"] = 65.63, ["Neon|Ride"] = 122.48, ["Neon|Fly|Ride"] = 246.63, ["Mega"] = 274.37, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 354.34}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 64.97, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 137.31, ["Neon"] = 246.25, ["Neon|Ride"] = 308.47, ["Neon|Fly|Ride"] = 311.07, ["Mega|Ride"] = 3426.87, ["Mega|Fly|Ride"] = 1157.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.74, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 43.26, ["Mega"] = 15.75, ["Mega|Fly"] = 115.6, ["Mega|Ride"] = 26.71, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.63, ["Fly"] = 32.81, ["Ride"] = 43.94, ["Fly|Ride"] = 131.25, ["Neon"] = 14.34, ["Neon|Ride"] = 59.6, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 128.63, ["Mega|Ride"] = 258.57, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.23, ["Ride"] = 64.76, ["Fly|Ride"] = 108.62, ["Neon"] = 77.42, ["Neon|Ride"] = 178.78, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 586.69, ["Mega|Ride"] = 492.09, ["Mega|Fly|Ride"] = 811.78}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.73, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 19.69, ["Mega|Ride"] = 81.19}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.44, ["Fly"] = 176.59, ["Ride"] = 57.9, ["Fly|Ride"] = 99.75, ["Neon"] = 65.63, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 201.14, ["Mega"] = 554.85, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.02, ["Mega|Fly|Ride"] = 513.79}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 67.83, ["Ride"] = 26.25, ["Fly|Ride"] = 45.85, ["Neon"] = 223.99, ["Neon|Ride"] = 109.95, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 8.27, ["Ride"] = 52.5, ["Neon"] = 26.17, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 210, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 386.08}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.31, ["Fly"] = 2055.11, ["Ride"] = 85.32, ["Fly|Ride"] = 196.83, ["Neon"] = 45.94, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6164.42, ["Mega"] = 274.37, ["Mega|Ride"] = 581.44, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 18.56, ["Fly|Ride"] = 196.88, ["Neon"] = 7.8, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 68.06, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 76.3, ["Neon"] = 2.1, ["Neon|Ride"] = 90.99, ["Mega"] = 30.13, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 219.5}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 30.87}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 39.79, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 1050, ["Neon|Ride"] = 202.49, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1224.85, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Mega"] = 23.63, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 308.28}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 393.75, ["Fly"] = 561.05, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3028.85, ["Neon|Fly|Ride"] = 2251.08, ["Mega"] = 16440.72, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 5.16, ["Fly"] = 25.81, ["Ride"] = 22.74, ["Fly|Ride"] = 66.26, ["Neon"] = 25.37, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 80.08, ["Mega|Fly"] = 147.98, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.52, ["Fly"] = 95.55, ["Ride"] = 19.59, ["Fly|Ride"] = 64.22, ["Neon"] = 16.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 162.75, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Fly"] = 77.09, ["Ride"] = 64.76, ["Fly|Ride"] = 106.32, ["Neon"] = 89.15, ["Neon|Ride"] = 177.93, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 793.28, ["Mega|Ride"] = 520.98, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.5, ["Fly"] = 315.47, ["Ride"] = 32.48, ["Fly|Ride"] = 685.3, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.71, ["Fly"] = 139.53, ["Ride"] = 39.38, ["Fly|Ride"] = 157.5, ["Neon"] = 52.5, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 368.9, ["Mega"] = 346.78, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 524.06}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 8.16, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 46.77, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 203.44, ["Mega|Fly"] = 548.72, ["Mega|Ride"] = 320.61, ["Mega|Fly|Ride"] = 317.89}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.32, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 125.68, ["Mega"] = 14.11, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 107}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.88, ["Fly"] = 274.37, ["Ride"] = 27.76, ["Fly|Ride"] = 48.3, ["Neon"] = 28.65, ["Neon|Fly"] = 115.55, ["Neon|Ride"] = 93.51, ["Neon|Fly|Ride"] = 82.22, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 297.94, ["Fly"] = 404.52, ["Ride"] = 300.58, ["Fly|Ride"] = 421.32, ["Neon"] = 1446.62, ["Neon|Ride"] = 1370.58, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4245.82}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 81.15, ["Ride"] = 274.37, ["Fly|Ride"] = 215.25, ["Neon"] = 315, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 515.06, ["Mega"] = 4110.2, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1695.71}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 15.75, ["Fly|Ride"] = 27.93, ["Neon"] = 11.4, ["Neon|Fly"] = 68.25, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 152.1, ["Mega|Fly"] = 204.5, ["Mega|Ride"] = 123.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 21.97, ["Ride"] = 14.31, ["Fly|Ride"] = 31.5, ["Neon"] = 6.55, ["Neon|Fly"] = 39.15, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 59.11, ["Mega"] = 68.25, ["Mega|Fly"] = 344.02, ["Mega|Ride"] = 103.25, ["Mega|Fly|Ride"] = 171.42}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 96.6, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 39.29, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.7, ["Mega|Ride"] = 328.82, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 274.1, ["Fly"] = 420, ["Ride"] = 266.44, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1027.44, ["Neon|Fly|Ride"] = 1407.75, ["Mega|Ride"] = 8220.37, ["Mega|Fly|Ride"] = 3412.49}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 48.3, ["Ride"] = 16.27, ["Fly|Ride"] = 35.04, ["Neon"] = 19.53, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.43, ["Neon|Fly|Ride"] = 108.67, ["Mega"] = 196.88, ["Mega|Fly"] = 123.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.52, ["Fly"] = 154.88, ["Ride"] = 82.11, ["Fly|Ride"] = 205.52, ["Neon"] = 32.82, ["Neon|Ride"] = 130.49, ["Neon|Fly|Ride"] = 273.3, ["Mega"] = 236.25, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 321.59}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 52.5, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 7.87, ["Ride"] = 18.17, ["Fly|Ride"] = 59.07, ["Neon"] = 79.38, ["Neon|Ride"] = 108.07, ["Neon|Fly|Ride"] = 171.62, ["Mega"] = 728.44, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 616.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 44.19, ["Fly"] = 137.7, ["Ride"] = 113.27, ["Fly|Ride"] = 209.9, ["Neon"] = 91.87, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 212.83, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 471.85, ["Mega|Fly"] = 2157.86, ["Mega|Ride"] = 478.46, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 28.88, ["Ride"] = 46.31, ["Fly|Ride"] = 104.79, ["Neon"] = 205.42, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 188.99, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 822.05, ["Mega|Ride"] = 822.05, ["Mega|Fly|Ride"] = 2051.74}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.48, ["Ride"] = 14.9, ["Fly|Ride"] = 32.89, ["Neon"] = 2.1, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 60.64, ["Mega"] = 17.5, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 57.56, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 271.43, ["Ride"] = 303.14, ["Fly|Ride"] = 297.94, ["Neon"] = 3234.79, ["Neon|Ride"] = 1438.4, ["Neon|Fly|Ride"] = 1072.77}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 11.15, ["Fly"] = 82.22, ["Ride"] = 68.86, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 154.97, ["Neon|Fly|Ride"] = 328.12, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.3, ["Ride"] = 15.6, ["Fly|Ride"] = 44.2, ["Neon"] = 6.57, ["Neon|Fly"] = 33.57, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 58.97, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 51.95, ["Mega|Fly|Ride"] = 138.73}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 19.46, ["Fly|Ride"] = 35.44, ["Neon"] = 3.45, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 109.87, ["Mega"] = 26.98, ["Mega|Fly"] = 137.7, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 152.1}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 9.28, ["Neon|Ride"] = 34.44, ["Neon|Fly|Ride"] = 6850.66, ["Mega"] = 129.84, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.66, ["Fly"] = 38.74, ["Ride"] = 24.33, ["Fly|Ride"] = 70.5, ["Neon"] = 51.39, ["Neon|Fly"] = 260.97, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.16, ["Mega"] = 342.12, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 354.37}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.24, ["Ride"] = 55.08, ["Fly|Ride"] = 72.19, ["Neon"] = 31.86, ["Neon|Ride"] = 71.94, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 216.57, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 369.9}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 274.34, ["Neon"] = 2.1, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.06, ["Mega|Ride"] = 66.61, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.39, ["Fly"] = 96.6, ["Ride"] = 26.25, ["Fly|Ride"] = 118.13, ["Neon"] = 26.25, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 179.96, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 300.06}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 115.42, ["Neon"] = 3.86, ["Neon|Fly"] = 109.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.94, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 22.28, ["Fly|Ride"] = 42, ["Neon"] = 6.57, ["Neon|Ride"] = 22.24, ["Neon|Fly|Ride"] = 89.12, ["Mega"] = 50.12, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 675.94, ["Ride"] = 685, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.44, ["Mega|Fly|Ride"] = 12714.84}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.56, ["Ride"] = 15.43, ["Fly|Ride"] = 35.44, ["Neon"] = 46.24, ["Neon|Fly"] = 122.75, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 32.47, ["Mega"] = 183.94, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 81.26, ["Neon"] = 15.4, ["Neon|Fly"] = 616.46, ["Neon|Ride"] = 87.74, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 65.63, ["Mega|Fly"] = 315, ["Mega|Ride"] = 124.26, ["Mega|Fly|Ride"] = 303.78}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.99, ["Fly"] = 40.69, ["Ride"] = 20.74, ["Fly|Ride"] = 52.5, ["Neon"] = 52.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 53.81, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 548.72, ["Mega|Ride"] = 309.74, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 15.32, ["Ride"] = 15.43, ["Fly|Ride"] = 33.39, ["Neon"] = 9.1, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 25.78, ["Neon|Fly|Ride"] = 60.41, ["Mega"] = 65.62, ["Mega|Ride"] = 88.14, ["Mega|Fly|Ride"] = 155.33}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.17, ["Ride"] = 83.99, ["Fly|Ride"] = 273.34, ["Neon"] = 255.84, ["Neon|Ride"] = 257.44, ["Mega"] = 892.49, ["Mega|Fly|Ride"] = 1150.87}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 137.7, ["Ride"] = 18.57, ["Fly|Ride"] = 63.74, ["Neon"] = 6.55, ["Neon|Fly"] = 131.72, ["Neon|Ride"] = 35.98, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 63.59, ["Mega|Ride"] = 114.74, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 22.97, ["Fly|Ride"] = 60.64, ["Neon"] = 12.24, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 236.25, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 14.44, ["Mega"] = 93.5, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 171.09, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 15.75, ["Fly|Ride"] = 49.83, ["Neon"] = 5.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.47, ["Neon|Fly|Ride"] = 84.96, ["Mega"] = 44.2, ["Mega|Fly"] = 250.63, ["Mega|Ride"] = 55.51, ["Mega|Fly|Ride"] = 154.91}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.68, ["Fly"] = 23.63, ["Ride"] = 18.64, ["Fly|Ride"] = 41.06, ["Neon"] = 308.47, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 822.05, ["Mega|Fly|Ride"] = 493.24}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.4, ["Ride"] = 866.24, ["Fly|Ride"] = 918.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1745.63, ["Neon|Fly|Ride"] = 1952.99, ["Mega|Ride"] = 6196.77, ["Mega|Fly|Ride"] = 7743.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 16.32, ["Fly|Ride"] = 39.29, ["Neon"] = 3.57, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 63.73, ["Mega"] = 44.63, ["Mega|Ride"] = 73.91, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.76, ["Ride"] = 27.57, ["Fly|Ride"] = 115.59, ["Neon"] = 45.94, ["Neon|Fly"] = 152.07, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 298.86, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 479.89}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.51, ["Ride"] = 76.67, ["Fly|Ride"] = 108.61, ["Neon"] = 303.11, ["Neon|Ride"] = 383.5, ["Neon|Fly|Ride"] = 530.22, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1286.51}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.76, ["Fly"] = 137.7, ["Ride"] = 39.38, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 168.52, ["Mega"] = 762.45, ["Mega|Ride"] = 821.02, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.19, ["Ride"] = 26.23, ["Fly|Ride"] = 123.59, ["Neon"] = 55.13, ["Neon|Ride"] = 110.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 397.67, ["Mega|Ride"] = 485.01, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.9, ["Ride"] = 76.06, ["Neon"] = 107.62, ["Neon|Ride"] = 135.63, ["Mega"] = 244.52, ["Mega|Fly"] = 501.67, ["Mega|Ride"] = 341.16, ["Mega|Fly|Ride"] = 479.89}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.64, ["Fly"] = 126.89, ["Ride"] = 88.38, ["Neon"] = 268.04, ["Neon|Ride"] = 303.11, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 924, ["Mega|Ride"] = 630.93, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.39}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.57, ["Fly"] = 131248.69, ["Ride"] = 26.73, ["Fly|Ride"] = 84, ["Neon"] = 34.13, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 397.67}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.52, ["Ride"] = 131.25, ["Neon"] = 42, ["Mega"] = 863.47}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 60.64, ["Fly"] = 410.11, ["Ride"] = 61.66, ["Fly|Ride"] = 94.5, ["Neon"] = 616.93, ["Neon|Ride"] = 236.76, ["Neon|Fly|Ride"] = 245.6, ["Mega|Ride"] = 894.68, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 7.88, ["Fly"] = 18.38, ["Ride"] = 17.35, ["Fly|Ride"] = 39.38, ["Neon"] = 26.17, ["Neon|Fly"] = 47.28, ["Neon|Ride"] = 35.02, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 274.37, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.94, ["Fly"] = 82.22, ["Ride"] = 29.81, ["Fly|Ride"] = 104.81, ["Neon"] = 26.64, ["Neon|Ride"] = 54.81, ["Neon|Fly|Ride"] = 123.6, ["Mega"] = 113.75, ["Mega|Ride"] = 175.75, ["Mega|Fly|Ride"] = 232.35}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.54, ["Mega"] = 42, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.27, ["Fly"] = 60.52, ["Ride"] = 52.47, ["Fly|Ride"] = 120.75, ["Neon"] = 152.07, ["Neon|Ride"] = 148.05, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1096.4, ["Mega|Ride"] = 780.95, ["Mega|Fly|Ride"] = 795.33}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Fly|Ride"] = 65.63, ["Neon"] = 8.24, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.06, ["Mega"] = 105, ["Mega|Ride"] = 137.52, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.43, ["Fly"] = 55.51, ["Ride"] = 72.89, ["Fly|Ride"] = 271.28, ["Neon"] = 82.21, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 356.57, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 644.28}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.77, ["Ride"] = 15.65, ["Fly|Ride"] = 36.66, ["Neon"] = 26.73, ["Neon|Ride"] = 27.37, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 17.57, ["Fly|Ride"] = 65.63, ["Neon"] = 77.42, ["Neon|Ride"] = 410.93, ["Mega"] = 377.12, ["Mega|Ride"] = 388.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 4.97, ["Ride"] = 59.91, ["Fly|Ride"] = 131.25, ["Neon"] = 46.87, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.09, ["Ride"] = 125.5, ["Fly|Ride"] = 205.52, ["Neon"] = 261.11, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 435.64, ["Mega"] = 1644.08, ["Mega|Ride"] = 1630.73, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.44, ["Ride"] = 119.01, ["Neon"] = 107.63, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 143.88, ["Mega"] = 411.03, ["Mega|Ride"] = 328.82, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.24, ["Ride"] = 105, ["Neon"] = 64.32, ["Neon|Ride"] = 91.88, ["Mega"] = 389.45, ["Mega|Ride"] = 973.1, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21.17, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 170.99, ["Neon|Ride"] = 616.46, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 822.05, ["Mega|Ride"] = 617.3, ["Mega|Fly|Ride"] = 1165.24}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.52, ["Neon"] = 105, ["Neon|Ride"] = 274.34, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 308.63}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 17.71, ["Fly|Ride"] = 39.38, ["Neon"] = 5.13, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 68.25, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 170.97}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.8, ["Ride"] = 28.88, ["Fly|Ride"] = 77.89, ["Neon"] = 14.48, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 96.74, ["Mega"] = 108.93, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 20.94, ["Ride"] = 20.56, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Fly"] = 31.21, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 47.16, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 188.73}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 68.86, ["Neon"] = 17.39, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 250.59, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.26, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 28.87, ["Neon|Fly"] = 462.13, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 303.14, ["Mega|Fly|Ride"] = 1027.56}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 6.48, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 55.47, ["Neon"] = 21, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 144.27, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 380.07}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.14, ["Ride"] = 17.97, ["Fly|Ride"] = 51.69, ["Neon"] = 22.32, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 54.12, ["Neon|Fly|Ride"] = 123.32, ["Mega"] = 170.63, ["Mega|Ride"] = 227.11}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.97, ["Fly"] = 65.63, ["Ride"] = 42.75, ["Neon"] = 15.83, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 130.01, ["Neon|Fly|Ride"] = 192.18, ["Mega"] = 106.78, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.28, ["Fly"] = 205.52, ["Ride"] = 96.6, ["Fly|Ride"] = 242.82, ["Neon"] = 105, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 453.16, ["Mega|Fly"] = 685.38, ["Mega|Ride"] = 508.83, ["Mega|Fly|Ride"] = 620.8}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.81, ["Ride"] = 93.52, ["Fly|Ride"] = 211.32, ["Neon"] = 285.91, ["Neon|Ride"] = 278.25, ["Neon|Fly|Ride"] = 471.62, ["Mega"] = 1076.25, ["Mega|Ride"] = 1083.05, ["Mega|Fly|Ride"] = 1148.09}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 22.62, ["Fly|Ride"] = 52.41, ["Neon"] = 2.1, ["Neon|Ride"] = 38.45, ["Mega"] = 24.48, ["Mega|Ride"] = 68.61, ["Mega|Fly|Ride"] = 165.27}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 65.63, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.16, ["Fly"] = 105, ["Ride"] = 68.25, ["Neon"] = 304.5, ["Neon|Ride"] = 274.34, ["Mega"] = 685.38, ["Mega|Ride"] = 1096.4, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.15, ["Fly"] = 190.32, ["Ride"] = 31.2, ["Fly|Ride"] = 126, ["Neon"] = 46.87, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 182.47, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 364.8}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.93, ["Ride"] = 89.41, ["Fly|Ride"] = 137.71, ["Neon"] = 3.94, ["Neon|Ride"] = 40.69, ["Mega"] = 60.38, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 95.94, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 18.38, ["Fly|Ride"] = 54.33, ["Neon"] = 11.82, ["Neon|Ride"] = 27.83, ["Neon|Fly|Ride"] = 111.93, ["Mega"] = 164.07, ["Mega|Fly"] = 343.22, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.64, ["Ride"] = 15.74, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 26.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 57.56, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 14.74, ["Fly|Ride"] = 76.56, ["Neon"] = 5.16, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 102.77, ["Mega"] = 43.98, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.83, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 56.44, ["Fly|Ride"] = 154.83, ["Neon"] = 2.1, ["Neon|Ride"] = 47.28, ["Mega"] = 21.76, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.86, ["Ride"] = 44.2, ["Neon"] = 30.19, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 181.63}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.86, ["Ride"] = 26.79, ["Fly|Ride"] = 189.48, ["Neon"] = 52.85, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 548.72, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.62, ["Fly"] = 21.95, ["Ride"] = 18.31, ["Fly|Ride"] = 45.05, ["Neon"] = 30.19, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 46.11, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 462.37, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 349.88}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 83.22, ["Ride"] = 262.03, ["Fly|Ride"] = 262.5, ["Neon"] = 538.13, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 27.75, ["Fly"] = 81.83, ["Ride"] = 65.63, ["Fly|Ride"] = 137.69, ["Neon"] = 164.07, ["Neon|Fly|Ride"] = 630, ["Mega"] = 876.19, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 15.43, ["Fly|Ride"] = 40.08, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 32.16, ["Mega|Ride"] = 94.65, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 15.73, ["Fly|Ride"] = 31.55, ["Neon"] = 5.13, ["Neon|Fly"] = 22.32, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 38.98, ["Mega"] = 44.63, ["Mega|Fly"] = 82.22, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 86.67}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 493.77, ["Ride"] = 530.01, ["Fly|Ride"] = 544.69, ["Neon|Fly|Ride"] = 1540.31}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 6.76, ["Ride"] = 90.16, ["Neon"] = 53.17, ["Neon|Ride"] = 117.13, ["Mega"] = 643.12, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.3, ["Ride"] = 15.27, ["Fly|Ride"] = 35.85, ["Neon"] = 2.1, ["Neon|Fly"] = 26.7, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 54.79, ["Mega"] = 39.38, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 104.37}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 60.44, ["Ride"] = 144.38, ["Fly|Ride"] = 328.13, ["Neon"] = 255.05, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 508.6, ["Mega"] = 919.67, ["Mega|Ride"] = 890.89, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.73, ["Ride"] = 19.62, ["Fly|Ride"] = 42, ["Neon"] = 13.12, ["Neon|Fly"] = 42.95, ["Neon|Ride"] = 30.83, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 84.96, ["Mega|Fly"] = 246.63, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 192.52}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 39.32, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 26.73, ["Mega|Fly"] = 274.37, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42, ["Fly"] = 167.06, ["Ride"] = 100.71, ["Fly|Ride"] = 111.57, ["Neon"] = 217.83, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 788.15}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.44, ["Fly|Ride"] = 52.5, ["Neon"] = 5.86, ["Neon|Ride"] = 39.99, ["Mega"] = 110.15, ["Mega|Ride"] = 174.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Ride"] = 96.6, ["Fly|Ride"] = 137.69, ["Neon"] = 307.21, ["Neon|Ride"] = 253.91, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1623.53, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Fly|Ride"] = 156.19, ["Neon"] = 21.77, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 479.89, ["Mega"] = 104.98, ["Mega|Ride"] = 464.63, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.94, ["Fly"] = 68.86, ["Ride"] = 26.25, ["Fly|Ride"] = 65.79, ["Neon"] = 10.28, ["Neon|Ride"] = 51.39, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 119.21, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 39.38, ["Ride"] = 98.6, ["Fly|Ride"] = 393.75, ["Neon"] = 315, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2053.05, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1219.71}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.23, ["Ride"] = 28.88, ["Fly|Ride"] = 908.98, ["Neon"] = 5.77, ["Neon|Ride"] = 37.01, ["Neon|Fly|Ride"] = 151.45, ["Mega"] = 45.94, ["Mega|Fly"] = 249.61, ["Mega|Ride"] = 154.91, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 17.35, ["Fly|Ride"] = 102.88, ["Neon"] = 40.69, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 16.49, ["Neon|Fly|Ride"] = 115.6, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.08, ["Fly"] = 48.3, ["Ride"] = 26.25, ["Fly|Ride"] = 77.42, ["Neon"] = 77.49, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 131.54, ["Mega"] = 430.5, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 22.05, ["Fly"] = 57.11, ["Ride"] = 39.35, ["Fly|Ride"] = 137.69, ["Neon"] = 93.73, ["Neon|Ride"] = 106.86, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 1055.31, ["Mega|Ride"] = 460.36, ["Mega|Fly|Ride"] = 615.5}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 18.17, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 74, ["Neon"] = 81.38, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 338.27}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 59.07, ["Ride"] = 94.5, ["Fly|Ride"] = 210, ["Neon"] = 294, ["Neon|Ride"] = 491.12, ["Neon|Fly|Ride"] = 716.67, ["Mega"] = 1644.08, ["Mega|Ride"] = 1438.58, ["Mega|Fly|Ride"] = 1260}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.76, ["Ride"] = 45.51, ["Fly|Ride"] = 308.23, ["Neon"] = 24.94, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 213.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 306.22}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.84, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 72.97, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 185.07, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 397.67}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.61, ["Fly"] = 52.5, ["Ride"] = 40.08, ["Fly|Ride"] = 109.95, ["Neon"] = 46.24, ["Neon|Ride"] = 392.43, ["Neon|Fly|Ride"] = 154.91, ["Mega"] = 431.59, ["Mega|Ride"] = 312.39, ["Mega|Fly|Ride"] = 493.24}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.47, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 14.44, ["Mega|Ride"] = 23.29, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 44.51, ["Fly"] = 137.7, ["Ride"] = 96.48, ["Neon"] = 183.75, ["Neon|Fly"] = 2329.17, ["Neon|Ride"] = 225.11, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1079.63, ["Mega|Ride"] = 1492.01, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 112.22, ["Neon"] = 6.03, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 46.34, ["Mega|Ride"] = 51.26, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.6, ["Fly|Ride"] = 45.93, ["Neon"] = 16.46, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 94.55, ["Mega"] = 261.01, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.19, ["Ride"] = 123.43, ["Fly|Ride"] = 223.13, ["Neon"] = 334.69, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 1247.4, ["Mega|Ride"] = 1294.62, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.65, ["Neon"] = 7.79, ["Neon|Ride"] = 35.98, ["Mega"] = 65.52, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 13.89}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 20.56, ["Fly|Ride"] = 291.84, ["Neon"] = 7.76, ["Neon|Ride"] = 42.82, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 47.29, ["Mega|Ride"] = 128.31, ["Mega|Fly|Ride"] = 194.81}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 108.95, ["Ride"] = 203.47, ["Fly|Ride"] = 262.5, ["Neon"] = 644.21, ["Neon|Ride"] = 672.97, ["Neon|Fly|Ride"] = 774.38, ["Mega"] = 3545.16, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2823.72}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.94, ["Ride"] = 40.85, ["Neon"] = 27.57, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 154.91, ["Mega"] = 160.02, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21, ["Neon"] = 4.6, ["Neon|Ride"] = 20.4, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 45.42, ["Mega|Ride"] = 100.08, ["Mega|Fly|Ride"] = 126.62}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.57, ["Ride"] = 26.5, ["Neon"] = 32.82, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.75}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.02, ["Fly"] = 25.47, ["Ride"] = 20.86, ["Fly|Ride"] = 54.31, ["Neon"] = 84.14, ["Neon|Ride"] = 117.8, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 597.19, ["Mega|Ride"] = 426.45, ["Mega|Fly|Ride"] = 466.52}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.27, ["Ride"] = 71.31, ["Fly|Ride"] = 122.48, ["Neon"] = 147.78, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 319.05, ["Mega"] = 525, ["Mega|Ride"] = 559.57, ["Mega|Fly|Ride"] = 771}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.38, ["Fly"] = 183.74, ["Ride"] = 168.92, ["Fly|Ride"] = 229.69, ["Neon"] = 590.66, ["Neon|Ride"] = 577.49, ["Neon|Fly|Ride"] = 611.63, ["Mega|Fly|Ride"] = 2428.13}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.59, ["Fly"] = 38.07, ["Ride"] = 30.19, ["Fly|Ride"] = 51.89, ["Neon"] = 133.47, ["Neon|Fly"] = 204.47, ["Neon|Ride"] = 103.59, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 676.14, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 20.01, ["Fly|Ride"] = 65.62, ["Neon"] = 13.13, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 130.7, ["Mega|Ride"] = 203.47, ["Mega|Fly|Ride"] = 249.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 11.31, ["Fly"] = 231.16, ["Ride"] = 27.57, ["Fly|Ride"] = 117.02, ["Neon"] = 38.07, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 191.15, ["Mega"] = 376.82, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 43.05, ["Fly"] = 142.85, ["Ride"] = 85.31, ["Fly|Ride"] = 178.81, ["Neon"] = 199.5, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 250.6, ["Mega"] = 1177.58, ["Mega|Ride"] = 1078.93, ["Mega|Fly|Ride"] = 1060.22}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.07, ["Ride"] = 121.31, ["Neon"] = 196.88, ["Neon|Ride"] = 238.37, ["Neon|Fly|Ride"] = 453.16, ["Mega"] = 682.5, ["Mega|Ride"] = 822.05, ["Mega|Fly|Ride"] = 813.83}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 411.03, ["Neon|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 6165.28}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 40.08, ["Ride"] = 53.45, ["Fly|Ride"] = 69.57, ["Neon"] = 228.51, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 274.98, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 878.56}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 15.39, ["Fly|Ride"] = 102.55, ["Neon"] = 2.1, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 64.34, ["Mega"] = 21.73, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 15.09, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 259.89, ["Mega|Ride"] = 228.13, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 8.24, ["Fly"] = 26.73, ["Fly|Ride"] = 144.17, ["Neon"] = 18.1, ["Neon|Ride"] = 81.18, ["Neon|Fly|Ride"] = 959.75, ["Mega"] = 122.52, ["Mega|Fly"] = 534.34, ["Mega|Ride"] = 257.93, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Ride"] = 411.03, ["Fly|Ride"] = 616.93, ["Neon"] = 1386.35, ["Neon|Ride"] = 1232.91, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.84, ["Fly"] = 57.01, ["Ride"] = 16.65, ["Fly|Ride"] = 52.5, ["Neon"] = 29.81, ["Neon|Ride"] = 41.61, ["Neon|Fly|Ride"] = 82.22, ["Mega"] = 168, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.5, ["Fly"] = 17, ["Ride"] = 17.07, ["Fly|Ride"] = 43.18, ["Neon"] = 39.38, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 51.39, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.38, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.2, ["Fly"] = 27.57, ["Ride"] = 27.56, ["Neon"] = 18.64, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 110.98, ["Mega"] = 77.44, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 36.66, ["Fly"] = 45.93, ["Ride"] = 40.2, ["Fly|Ride"] = 82.21, ["Neon"] = 137.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 96.6, ["Mega"] = 924.81, ["Mega|Ride"] = 821.02, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 26.99, ["Fly|Ride"] = 68.17, ["Neon"] = 27.46, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 426.45, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.41, ["Fly"] = 787.5, ["Ride"] = 23.63, ["Fly|Ride"] = 85.63, ["Neon"] = 131.25, ["Neon|Ride"] = 164.33, ["Neon|Fly|Ride"] = 274.37, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Fly|Ride"] = 41.11, ["Neon"] = 3.82, ["Neon|Ride"] = 20.56, ["Mega"] = 50.31, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 233.26}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.94, ["Ride"] = 137.7, ["Neon"] = 94.5, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 18.45, ["Ride"] = 39.38, ["Neon"] = 62.91, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 822.05, ["Mega|Ride"] = 341, ["Mega|Fly|Ride"] = 545.65}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.38, ["Fly"] = 55.51, ["Ride"] = 29.87, ["Fly|Ride"] = 45.48, ["Neon"] = 59.07, ["Neon|Fly"] = 115.55, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 118.46, ["Mega"] = 575.45, ["Mega|Ride"] = 394.59, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.39, ["Fly"] = 410.29, ["Ride"] = 282.19, ["Fly|Ride"] = 389.81, ["Neon"] = 1465.1, ["Neon|Ride"] = 1229.82, ["Neon|Fly|Ride"] = 1231, ["Mega|Fly|Ride"] = 5069.92}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.63, ["Fly|Ride"] = 56.8, ["Neon"] = 10.29, ["Neon|Fly"] = 77.42, ["Neon|Ride"] = 58.57, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 192.18, ["Mega|Ride"] = 154.91, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.4, ["Fly"] = 27.65, ["Ride"] = 17.07, ["Fly|Ride"] = 80.15, ["Neon"] = 37.38, ["Neon|Ride"] = 108.62, ["Neon|Fly|Ride"] = 261.01, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 27.98, ["Fly"] = 117.16, ["Ride"] = 274.37, ["Fly|Ride"] = 201.04, ["Neon"] = 138.66, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 328.12, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 501.22}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 127.02, ["Fly"] = 393.75, ["Ride"] = 195.25, ["Fly|Ride"] = 349.34, ["Neon"] = 1096.27, ["Neon|Ride"] = 1079.05, ["Neon|Fly|Ride"] = 1096.4, ["Mega"] = 3082.79, ["Mega|Ride"] = 1792.88, ["Mega|Fly|Ride"] = 2815.26}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 32.71, ["Fly"] = 102.38, ["Ride"] = 82.22, ["Neon"] = 104.3, ["Neon|Ride"] = 308.23, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 249.38, ["Mega|Ride"] = 249.27, ["Mega|Fly|Ride"] = 386.96}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.59, ["Fly|Ride"] = 51.89, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 39.38, ["Mega|Ride"] = 193.06, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 8.48, ["Ride"] = 36.83, ["Fly|Ride"] = 81.18, ["Neon"] = 92.45, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 171.08, ["Mega"] = 160.79, ["Mega|Ride"] = 187.6, ["Mega|Fly|Ride"] = 534.34}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 61.68, ["Fly"] = 196.88, ["Ride"] = 111.57, ["Fly|Ride"] = 216.57, ["Neon"] = 141.26, ["Neon|Ride"] = 196.55, ["Neon|Fly|Ride"] = 350.51, ["Mega"] = 463.1, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 548.72}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 69.36, ["Neon"] = 7.69, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 190.3, ["Mega"] = 66.91, ["Mega|Fly"] = 240.45, ["Mega|Ride"] = 163.8, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 6.18, ["Fly|Ride"] = 273.3, ["Neon"] = 110.79, ["Neon|Ride"] = 401.03, ["Mega"] = 433.13, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 812.8}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 961.54, ["Fly"] = 1252.82, ["Ride"] = 1088.84, ["Fly|Ride"] = 1141.03, ["Neon"] = 3473.94, ["Neon|Ride"] = 2876.78, ["Neon|Fly|Ride"] = 2723.43, ["Mega|Fly|Ride"] = 14247.94}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 22.93, ["Fly"] = 115.59, ["Ride"] = 119.21, ["Fly|Ride"] = 191.63, ["Neon"] = 109.95, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 192.14, ["Mega"] = 656.25, ["Mega|Ride"] = 577.97, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 26.24, ["Fly|Ride"] = 41.22, ["Neon"] = 13.13, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 121.11, ["Mega"] = 72.19, ["Mega|Ride"] = 152.1, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.28, ["Ride"] = 131.22, ["Fly|Ride"] = 137.69, ["Neon"] = 123.31, ["Mega"] = 236.54, ["Mega|Ride"] = 328.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Ride"] = 19.19, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 19.69, ["Mega|Fly"] = 123.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 150.04}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 67.1, ["Ride"] = 109.08, ["Fly|Ride"] = 236.25, ["Neon"] = 339.94, ["Neon|Ride"] = 276.46, ["Mega"] = 1020.22, ["Mega|Ride"] = 976.81, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.77, ["Ride"] = 23.63, ["Fly|Ride"] = 101.07, ["Neon"] = 47.16, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 108.67, ["Mega"] = 397.67, ["Mega|Ride"] = 461.39, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Fly"] = 96.6, ["Ride"] = 26.73, ["Fly|Ride"] = 46.25, ["Neon"] = 16.46, ["Neon|Ride"] = 47.22, ["Mega"] = 145.15, ["Mega|Ride"] = 258.03}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 114.07, ["Ride"] = 32.7, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 684.36, ["Mega|Ride"] = 1027.56, ["Mega|Fly|Ride"] = 771}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 11.46, ["Ride"] = 30.83, ["Fly|Ride"] = 86.24, ["Neon"] = 96.59, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 170.6, ["Mega"] = 576.81, ["Mega|Ride"] = 501.46, ["Mega|Fly|Ride"] = 453.16}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 191.85, ["Ride"] = 84, ["Neon"] = 385.88, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 1867.7, ["Mega|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 1582.44}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.57, ["Neon"] = 24.22, ["Neon|Ride"] = 85.23, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 110.25, ["Mega|Ride"] = 126.82, ["Mega|Fly|Ride"] = 287.34}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.48, ["Ride"] = 22.32, ["Fly|Ride"] = 78.74, ["Neon"] = 45.48, ["Neon|Ride"] = 65.76, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 399, ["Mega|Ride"] = 367.54, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 114.08, ["Fly"] = 513.79, ["Ride"] = 156.19, ["Fly|Ride"] = 258.85, ["Neon"] = 542.22, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 590.86, ["Mega"] = 3144.3, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1824.38}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.99, ["Ride"] = 18.38, ["Fly|Ride"] = 41.15, ["Neon"] = 11.46, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 98.66, ["Mega"] = 65.54, ["Mega|Fly"] = 123.69, ["Mega|Ride"] = 154.76, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 91.02, ["Ride"] = 24.44, ["Fly|Ride"] = 91.88, ["Neon"] = 69.44, ["Neon|Fly"] = 231.08, ["Neon|Ride"] = 92.45, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 378.27, ["Mega|Ride"] = 329.53, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.38, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 24.35, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 47.29, ["Mega"] = 14.8, ["Mega|Fly"] = 48.57, ["Mega|Ride"] = 39.06, ["Mega|Fly|Ride"] = 77.48}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Neon"] = 2.63, ["Neon|Ride"] = 39.06, ["Mega"] = 22.32, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 59.91, ["Mega|Fly|Ride"] = 109.96}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 34.96, ["Ride"] = 18.38, ["Fly|Ride"] = 85.78, ["Neon"] = 14.97, ["Neon|Ride"] = 58.93, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 109.96, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.3, ["Ride"] = 315, ["Neon"] = 117.74, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 664.83}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 18.42, ["Ride"] = 16.84, ["Fly|Ride"] = 27.71, ["Neon"] = 12.31, ["Neon|Fly"] = 31.21, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 108.67, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 131.54, ["Mega|Fly|Ride"] = 180.38}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.93, ["Fly"] = 31.95, ["Ride"] = 23.45, ["Fly|Ride"] = 54.93, ["Neon"] = 29.69, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 182.44, ["Mega|Fly"] = 411.03, ["Mega|Ride"] = 155.93, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.26, ["Fly"] = 26.73, ["Ride"] = 18.09, ["Fly|Ride"] = 76.36, ["Neon"] = 11.74, ["Neon|Fly"] = 85.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 60.38, ["Mega|Fly"] = 101.74, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 128.81}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.48, ["Fly"] = 35.98, ["Ride"] = 32.9, ["Neon"] = 35.44, ["Neon|Ride"] = 80.15, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 219.91, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.4, ["Fly"] = 170.6, ["Ride"] = 122.72, ["Fly|Ride"] = 180.85, ["Neon"] = 123.38, ["Neon|Ride"] = 259.76, ["Mega"] = 548.72, ["Mega|Ride"] = 386.08, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.16, ["Fly"] = 41.88, ["Ride"] = 26.73, ["Fly|Ride"] = 65.63, ["Neon"] = 24.22, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 60.77, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 328.82, ["Mega|Ride"] = 231.19, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.43, ["Fly|Ride"] = 34.94, ["Neon"] = 11.64, ["Neon|Fly"] = 68.33, ["Neon|Ride"] = 31.26, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 131.15, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 181.81, ["Fly"] = 385.91, ["Ride"] = 308.28, ["Fly|Ride"] = 392.43, ["Neon"] = 1124.01, ["Neon|Ride"] = 1232.91, ["Neon|Fly|Ride"] = 1027.56, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 7.88, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 411.03, ["Mega"] = 119.62, ["Mega|Ride"] = 411.03, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 21.63, ["Fly|Ride"] = 77.09, ["Neon"] = 23.15, ["Neon|Fly"] = 219.89, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 201.14, ["Mega"] = 201.1, ["Mega|Ride"] = 277.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.42, ["Ride"] = 34.96, ["Neon"] = 60.38, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.54, ["Mega"] = 461.22, ["Mega|Ride"] = 328.82, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.13, ["Fly|Ride"] = 30.83, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 15.44, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 17.06, ["Fly|Ride"] = 59.07, ["Neon"] = 6.57, ["Neon|Ride"] = 28.98, ["Neon|Fly|Ride"] = 94.81, ["Mega"] = 101.04, ["Mega|Ride"] = 143.59, ["Mega|Fly|Ride"] = 202.12}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 68.86, ["Neon"] = 16.46, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.59, ["Mega|Ride"] = 204.5, ["Mega|Fly|Ride"] = 308.63}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.51, ["Fly"] = 123.32, ["Ride"] = 108.63, ["Fly|Ride"] = 135.63, ["Neon"] = 616.93, ["Neon|Ride"] = 460.29, ["Neon|Fly|Ride"] = 415.8, ["Mega"] = 2055.11, ["Mega|Ride"] = 3426.87, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 5.3, ["Fly"] = 91.88, ["Ride"] = 30.07, ["Fly|Ride"] = 262.48, ["Neon"] = 22.09, ["Neon|Ride"] = 92.45, ["Neon|Fly|Ride"] = 92.49, ["Mega"] = 209.42, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.16, ["Neon"] = 15.75, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 48.57, ["Fly"] = 210, ["Ride"] = 88.36, ["Fly|Ride"] = 274.34, ["Neon"] = 118.13, ["Neon|Ride"] = 196.25, ["Neon|Fly|Ride"] = 308.47, ["Mega"] = 568.32, ["Mega|Ride"] = 657.64, ["Mega|Fly|Ride"] = 617.26}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 12.74, ["Fly|Ride"] = 25.72, ["Neon"] = 2.1, ["Neon|Fly"] = 18.51, ["Neon|Ride"] = 15.67, ["Neon|Fly|Ride"] = 32.65, ["Mega"] = 17.07, ["Mega|Fly"] = 49.38, ["Mega|Ride"] = 55.51, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 2.63, ["Neon|Ride"] = 27.25, ["Neon|Fly|Ride"] = 123.69, ["Mega"] = 30.19, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 158.6}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 107.63, ["Neon"] = 10.26, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 180.87, ["Mega"] = 64.19, ["Mega|Fly"] = 178.81, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 198.94}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.09, ["Fly"] = 68.25, ["Ride"] = 35.98, ["Fly|Ride"] = 130.49, ["Neon"] = 21.25, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 71.47, ["Neon|Fly|Ride"] = 231.08, ["Mega"] = 103.69, ["Mega|Fly"] = 331.76, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 288.73}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 14.81, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 25.67, ["Neon|Ride"] = 48.3, ["Neon|Fly|Ride"] = 44, ["Mega"] = 23.14, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 15.43, ["Fly"] = 72.19, ["Ride"] = 39.06, ["Neon"] = 99.67, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 959.62, ["Mega"] = 388.43, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 678.19}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2771.98, ["Ride"] = 2534.97, ["Fly|Ride"] = 2559.38, ["Neon"] = 9275.53, ["Neon|Fly|Ride"] = 10960.83, ["Mega|Fly|Ride"] = 34525.49}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.2, ["Ride"] = 15.43, ["Fly|Ride"] = 29.81, ["Neon"] = 9.45, ["Neon|Fly"] = 62.41, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.03, ["Mega"] = 77.46, ["Mega|Fly"] = 457.28, ["Mega|Ride"] = 113.43, ["Mega|Fly|Ride"] = 172.97}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 187.04, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 192.18}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 18.38, ["Ride"] = 33.5, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 293.46, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 345.19, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 534.34}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 31.7, ["Ride"] = 58.58, ["Neon"] = 154.83, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 548.72, ["Mega|Ride"] = 767.6, ["Mega|Fly|Ride"] = 809.15}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 141.32, ["Fly"] = 1370.76, ["Ride"] = 197.75, ["Fly|Ride"] = 374.05, ["Neon"] = 780.85, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6165.28, ["Mega|Fly|Ride"] = 3378.38}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 10.02, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.2, ["Neon|Ride"] = 131.5, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Neon"] = 13.13, ["Neon|Fly"] = 102.76, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 513.79, ["Mega"] = 117.1, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.62, ["Fly"] = 101.99, ["Ride"] = 40.42, ["Fly|Ride"] = 131.25, ["Neon"] = 7.91, ["Neon|Ride"] = 56.44, ["Mega"] = 77.44, ["Mega|Ride"] = 96.29, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 105, ["Ride"] = 102.77, ["Neon"] = 135.19, ["Neon|Ride"] = 1165.83, ["Neon|Fly|Ride"] = 483.99, ["Mega|Ride"] = 604.21, ["Mega|Fly|Ride"] = 717.24}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.11, ["Neon"] = 2.1, ["Neon|Ride"] = 82.21, ["Mega"] = 17.07, ["Mega|Fly"] = 115.6, ["Mega|Ride"] = 154.91, ["Mega|Fly|Ride"] = 273.34}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 95.85, ["Fly"] = 137.7, ["Ride"] = 109.96, ["Fly|Ride"] = 168.52, ["Neon"] = 409.96, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 465.84, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1721.15}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 96.6, ["Ride"] = 91.82, ["Neon"] = 10.19, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 69.37, ["Mega|Ride"] = 203.47, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 205.52, ["Ride"] = 85.49, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.5, ["Fly|Ride"] = 50.82, ["Neon"] = 4.64, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 45.57, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 166.82}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 4.55, ["Neon"] = 11.68, ["Neon|Ride"] = 118.13, ["Mega"] = 60.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 604.21}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 12.29, ["Ride"] = 36.65, ["Neon"] = 51.24, ["Neon|Ride"] = 94.4, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 231.19, ["Mega|Ride"] = 345.27, ["Mega|Fly|Ride"] = 915.49}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 545.57, ["Neon"] = 1080.19, ["Neon|Ride"] = 1207.37, ["Neon|Fly|Ride"] = 1246.77, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 34.97, ["Ride"] = 47.48, ["Fly|Ride"] = 96.6, ["Neon"] = 205.5, ["Neon|Ride"] = 240.97, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 1212.52, ["Mega|Fly|Ride"] = 1096.4}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.74, ["Fly|Ride"] = 91.88, ["Neon"] = 7.62, ["Neon|Fly"] = 133.59, ["Neon|Ride"] = 19.72, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 51.45, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.51, ["Fly"] = 82.22, ["Ride"] = 54.33, ["Fly|Ride"] = 131.25, ["Neon"] = 53.28, ["Neon|Fly"] = 105, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 257.25, ["Mega|Fly"] = 951.32, ["Mega|Ride"] = 254.08, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 9.59, ["Ride"] = 20.68, ["Fly|Ride"] = 262, ["Neon"] = 137.69, ["Neon|Ride"] = 76.05, ["Neon|Fly|Ride"] = 308.63, ["Mega"] = 1096.4, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 408.71}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.72, ["Ride"] = 27.76, ["Neon"] = 17.35, ["Mega"] = 68.25, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 411.03}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 86.62, ["Ride"] = 20.16, ["Fly|Ride"] = 57.78, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.63, ["Mega"] = 137.7, ["Mega|Ride"] = 482.07, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 110.44, ["Ride"] = 131.25, ["Fly|Ride"] = 220.89, ["Neon"] = 616.93, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 693.55, ["Mega|Fly|Ride"] = 2576.06}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 22.17, ["Ride"] = 102.77, ["Fly|Ride"] = 137.69, ["Neon"] = 191.62, ["Neon|Ride"] = 192.15, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 682.5, ["Mega|Ride"] = 718.27, ["Mega|Fly|Ride"] = 673.98}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.71, ["Fly"] = 2329.46, ["Ride"] = 2229.94, ["Fly|Ride"] = 2290.43, ["Neon"] = 10959.46, ["Neon|Fly|Ride"] = 5848.5, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 196.87, ["Neon"] = 9.08, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 104.89, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 184.42, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.49, ["Ride"] = 51.35, ["Fly|Ride"] = 137.69, ["Neon"] = 31.5, ["Neon|Ride"] = 123.63, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 185.41, ["Mega|Ride"] = 228.41, ["Mega|Fly|Ride"] = 545.65}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1025.09, ["Fly"] = 1153.44, ["Ride"] = 997.64, ["Fly|Ride"] = 931.88, ["Neon"] = 2623.69, ["Neon|Ride"] = 2927.5, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 9383.07}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.98, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 209.61, ["Neon|Ride"] = 291.72, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 863.16}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.97, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 24.92, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.97, ["Mega|Fly|Ride"] = 512.76}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.7, ["Neon"] = 3.94, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 54.74, ["Neon|Fly|Ride"] = 77.46, ["Mega"] = 21.6, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 246.63}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.95, ["Ride"] = 127.32, ["Fly|Ride"] = 205.5, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 8220.37, ["Mega|Fly|Ride"] = 2329.46}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.25, ["Neon"] = 22.32, ["Neon|Ride"] = 123.31, ["Neon|Fly|Ride"] = 115.6, ["Mega"] = 174.56, ["Mega|Ride"] = 324.72, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 72.35, ["Ride"] = 136.49, ["Neon"] = 380.63, ["Neon|Ride"] = 462.13, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 4.64, ["Fly"] = 105, ["Fly|Ride"] = 109.96, ["Neon"] = 18.38, ["Neon|Ride"] = 77.42, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 137.7, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 178.81}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.13, ["Ride"] = 268.32, ["Fly|Ride"] = 366.62, ["Neon"] = 1410.28, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.29, ["Fly"] = 87.83, ["Ride"] = 20.56, ["Fly|Ride"] = 55.51, ["Neon"] = 77.9, ["Neon|Ride"] = 65.5, ["Neon|Fly|Ride"] = 114.18, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 352.95}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.66, ["Fly|Ride"] = 32.7, ["Neon"] = 6.46, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 21.75, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 45.56, ["Mega|Fly"] = 105.33, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 107.1}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 915.81, ["Ride"] = 1050, ["Fly|Ride"] = 1114.32, ["Neon|Ride"] = 7535.09, ["Neon|Fly|Ride"] = 5480.94, ["Mega"] = 26031.81}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.46, ["Fly"] = 959.75, ["Ride"] = 72.19, ["Neon"] = 56.54, ["Neon|Ride"] = 129.4, ["Mega"] = 244.58, ["Mega|Ride"] = 343.22, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.79, ["Fly"] = 54.91, ["Ride"] = 35.25, ["Fly|Ride"] = 95.82, ["Neon"] = 25.45, ["Neon|Fly"] = 92.45, ["Neon|Ride"] = 58.57, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 181.13, ["Mega|Fly"] = 227.11, ["Mega|Ride"] = 190.21, ["Mega|Fly|Ride"] = 262.87}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 33.39, ["Fly"] = 40.79, ["Ride"] = 55.04, ["Fly|Ride"] = 52.5, ["Neon"] = 219.89, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2055.11, ["Mega|Ride"] = 1233.07, ["Mega|Fly|Ride"] = 740.87}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.53, ["Fly"] = 59.07, ["Ride"] = 27.43, ["Fly|Ride"] = 89.25, ["Neon"] = 68.11, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.4, ["Ride"] = 209.99, ["Fly|Ride"] = 400.76, ["Neon"] = 108.33, ["Neon|Ride"] = 274.34, ["Mega"] = 483.99, ["Mega|Ride"] = 573.39, ["Mega|Fly|Ride"] = 878.56}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 231.16, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 108.71, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 18.27, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 96.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.28, ["Fly"] = 110.18, ["Ride"] = 76.04, ["Fly|Ride"] = 131.15, ["Neon"] = 337.36, ["Neon|Fly"] = 381.25, ["Neon|Ride"] = 308.47, ["Neon|Fly|Ride"] = 371.67, ["Mega"] = 3288.15, ["Mega|Fly|Ride"] = 1182.64}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 102.27, ["Ride"] = 22.09, ["Fly|Ride"] = 81.58, ["Neon"] = 31.5, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 341.54, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 16.46, ["Fly|Ride"] = 38.07, ["Neon"] = 14.85, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 41.08, ["Ride"] = 171.62, ["Neon"] = 20.13, ["Neon|Fly|Ride"] = 183.94, ["Mega"] = 261.01}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 31.4, ["Ride"] = 82.22, ["Fly|Ride"] = 137.7, ["Neon"] = 258.92, ["Neon|Ride"] = 246.6, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 1015.23, ["Mega|Ride"] = 1010.63, ["Mega|Fly|Ride"] = 924.74}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.9, ["Fly|Ride"] = 410.99, ["Neon"] = 20.9, ["Neon|Ride"] = 77.07, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 94.99, ["Mega|Ride"] = 109.96, ["Mega|Fly|Ride"] = 308.63}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 20.6, ["Mega"] = 15.65, ["Mega|Ride"] = 55.51, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.86, ["Ride"] = 25.24, ["Fly|Ride"] = 133.49, ["Neon"] = 2.5, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 31.87, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 109.96}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 23.35, ["Ride"] = 15.43, ["Fly|Ride"] = 38.66, ["Neon"] = 5.34, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 76.06, ["Mega"] = 98.66, ["Mega|Ride"] = 58.49, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 21.84, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.41, ["Fly|Ride"] = 32.82, ["Neon"] = 14.34, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 229.04, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.07, ["Ride"] = 155.23, ["Fly|Ride"] = 359.62, ["Neon"] = 196.88, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1027.56, ["Mega"] = 1541.98, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 1060.43}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.14, ["Ride"] = 14.74, ["Fly|Ride"] = 31.5, ["Neon"] = 3.94, ["Neon|Fly"] = 26.73, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.29, ["Mega"] = 28.77, ["Mega|Ride"] = 33.28, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.71, ["Fly"] = 75.28, ["Ride"] = 35.98, ["Fly|Ride"] = 94.55, ["Neon"] = 35.44, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 294.9, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 296.26}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 15.32, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 65.62, ["Neon"] = 109.05, ["Neon|Ride"] = 157.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 787.5, ["Mega|Ride"] = 459.27, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 196.88, ["Neon"] = 45.94, ["Mega"] = 287.74, ["Mega|Ride"] = 259.87, ["Mega|Fly|Ride"] = 408.98}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 16.46, ["Fly|Ride"] = 39.04, ["Neon"] = 4.91, ["Neon|Fly"] = 40.08, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 41.91, ["Mega|Fly"] = 168.53, ["Mega|Ride"] = 59.42, ["Mega|Fly|Ride"] = 121.96}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.13, ["Fly"] = 39.38, ["Ride"] = 30.83, ["Neon"] = 11.26, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.81, ["Mega|Fly|Ride"] = 397.67}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1039.49, ["Fly"] = 1233.07, ["Ride"] = 944.9, ["Fly|Ride"] = 1030.32, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2332.32, ["Mega|Fly|Ride"] = 6887.61}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 81.38, ["Ride"] = 137.7, ["Fly|Ride"] = 183.75, ["Neon"] = 413.44, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 603.18, ["Mega"] = 3081.62, ["Mega|Ride"] = 2466.12, ["Mega|Fly|Ride"] = 1644.08}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.81, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.52, ["Mega"] = 72.89, ["Mega|Fly|Ride"] = 205.52}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 57.66, ["Ride"] = 109.96, ["Fly|Ride"] = 138.7, ["Neon"] = 301.88, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 410.99, ["Mega"] = 1050, ["Mega|Ride"] = 1309.11, ["Mega|Fly|Ride"] = 1162.88}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.77, ["Ride"] = 26.37, ["Fly|Ride"] = 89.4, ["Neon"] = 19.69, ["Neon|Fly"] = 54.31, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 231.19, ["Mega|Ride"] = 305.92, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 294.08, ["Fly"] = 411.03, ["Ride"] = 334.69, ["Fly|Ride"] = 452.07, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1740.67, ["Mega|Fly|Ride"] = 4554.25}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 40.08, ["Fly|Ride"] = 200.62, ["Neon"] = 24.68, ["Neon|Ride"] = 54.28, ["Mega"] = 164.42, ["Mega|Fly"] = 320.61, ["Mega|Ride"] = 184.96, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 22.61, ["Neon|Ride"] = 137.69, ["Mega"] = 328.82}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 43.04, ["Ride"] = 78.62, ["Fly|Ride"] = 42, ["Neon"] = 164.07, ["Neon|Fly"] = 397.63, ["Neon|Ride"] = 191.13, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 542, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Fly|Ride"] = 274.34, ["Neon"] = 20.56, ["Mega"] = 196.88, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 418.59}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.43, ["Fly|Ride"] = 20.56, ["Neon"] = 2.63, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 30.19, ["Mega"] = 27.62, ["Mega|Ride"] = 38.74, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4396.88, ["Fly|Ride"] = 4436.25, ["Neon"] = 30822.48, ["Neon|Fly|Ride"] = 21783.95, ["Mega|Fly|Ride"] = 84943.99}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 11.4, ["Fly"] = 39.38, ["Ride"] = 45.94, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega"] = 411.03, ["Mega|Ride"] = 224.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 23.45, ["Ride"] = 15.43, ["Fly|Ride"] = 40.04, ["Neon"] = 13.26, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 71.64, ["Mega"] = 131.25, ["Mega|Ride"] = 154.91, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 494.81, ["Fly"] = 547.77, ["Ride"] = 544.91, ["Fly|Ride"] = 539.74, ["Neon"] = 1370.58, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1644.08, ["Mega|Fly|Ride"] = 5480.94}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.63, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 139.08, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.07, ["Fly"] = 4110.2, ["Ride"] = 46.25, ["Neon"] = 27.76, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 408.98, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 491.54}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.45, ["Neon"] = 2.52, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.39, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 892.5, ["Fly"] = 870.34, ["Ride"] = 727.13, ["Fly|Ride"] = 735, ["Neon"] = 2362.5, ["Neon|Ride"] = 2557.37, ["Neon|Fly|Ride"] = 2208.73}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Fly"] = 56.44, ["Ride"] = 78.74, ["Neon"] = 31.5, ["Neon|Ride"] = 74.72, ["Neon|Fly|Ride"] = 178.81, ["Mega"] = 156.19, ["Mega|Ride"] = 202.77, ["Mega|Fly|Ride"] = 377.22}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.94, ["Fly"] = 52.5, ["Ride"] = 63.73, ["Fly|Ride"] = 118.13, ["Neon"] = 28.65, ["Neon|Ride"] = 59.6, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 203.43, ["Mega|Ride"] = 191.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.2, ["Fly|Ride"] = 52.5, ["Neon"] = 15.06, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 274.37, ["Mega|Fly"] = 548.72, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 21.06, ["Ride"] = 46.25, ["Fly|Ride"] = 154.83, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.69, ["Mega"] = 548.72, ["Mega|Fly|Ride"] = 739.85}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 262.5, ["Neon"] = 2.63, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 39.06, ["Neon|Fly|Ride"] = 183.94, ["Mega"] = 46.77, ["Mega|Ride"] = 114.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 528.17, ["Ride"] = 559.57, ["Fly|Ride"] = 685.3, ["Neon"] = 2589.57, ["Neon|Ride"] = 2696.45, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.23, ["Ride"] = 61.66, ["Fly|Ride"] = 308.47, ["Neon"] = 15.37, ["Neon|Ride"] = 90.43, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 78.75, ["Mega|Fly"] = 123.32, ["Mega|Ride"] = 155.6, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 6.18, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 40.08, ["Mega|Ride"] = 137.7, ["Mega|Fly|Ride"] = 267.18}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 25.2, ["Neon"] = 5.16, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.7, ["Mega"] = 51.19, ["Mega|Fly"] = 152.1, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.03, ["Ride"] = 21.84, ["Neon"] = 18.5, ["Mega"] = 201.14}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.44, ["Fly"] = 66.94, ["Ride"] = 57.8, ["Fly|Ride"] = 293.46, ["Neon"] = 128.64, ["Neon|Ride"] = 184.95, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 630.93, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 685.38}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.75, ["Ride"] = 55.31, ["Fly|Ride"] = 137.69, ["Neon"] = 78.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 301.77, ["Mega"] = 464.2, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 627.85}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.77, ["Fly"] = 19.16, ["Ride"] = 15.36, ["Fly|Ride"] = 44.19, ["Neon"] = 19.69, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 299.92, ["Mega|Ride"] = 136.54, ["Mega|Fly|Ride"] = 217.86}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.5, ["Ride"] = 64.32, ["Neon"] = 137.69, ["Neon|Ride"] = 131.25, ["Mega"] = 308.63, ["Mega|Ride"] = 714.16, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 25.44, ["Fly|Ride"] = 72.97, ["Neon"] = 14.21, ["Neon|Ride"] = 31.21, ["Neon|Fly|Ride"] = 205.76, ["Mega"] = 86.63, ["Mega|Fly"] = 164.42, ["Mega|Ride"] = 152.1, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.67, ["Fly"] = 23.15, ["Ride"] = 23.62, ["Fly|Ride"] = 131.25, ["Neon"] = 228.74, ["Neon|Ride"] = 184.95, ["Neon|Fly|Ride"] = 197.68, ["Mega"] = 923.78, ["Mega|Ride"] = 924.74, ["Mega|Fly|Ride"] = 878.56}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 55.5, ["Fly"] = 874.13, ["Neon"] = 273.99, ["Mega|Fly|Ride"] = 959.75}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.05, ["Fly"] = 115.38, ["Ride"] = 70.59, ["Fly|Ride"] = 121.19, ["Neon"] = 259.88, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 361.23, ["Mega|Ride"] = 1634.46, ["Mega|Fly|Ride"] = 1503.31}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 39.38, ["Fly"] = 92.48, ["Ride"] = 88.38, ["Fly|Ride"] = 274.34, ["Neon"] = 129.94, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 389.45, ["Mega"] = 543.93, ["Mega|Ride"] = 657.64, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 14.42, ["Ride"] = 55.51, ["Fly|Ride"] = 137.69, ["Neon"] = 138.72, ["Neon|Ride"] = 123.38, ["Mega"] = 1050, ["Mega|Ride"] = 771, ["Mega|Fly|Ride"] = 1233.07}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 18.08, ["Fly"] = 428.28, ["Ride"] = 41.11, ["Fly|Ride"] = 68.86, ["Neon"] = 86.16, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 231.55, ["Mega"] = 457.47, ["Mega|Ride"] = 354.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.25, ["Fly|Ride"] = 34.94, ["Neon"] = 5.16, ["Neon|Fly"] = 25.14, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 44.61, ["Mega|Fly"] = 154.91, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.41, ["Fly"] = 231.16, ["Ride"] = 127.32, ["Fly|Ride"] = 262.5, ["Neon"] = 288.46, ["Neon|Ride"] = 258.68, ["Neon|Fly|Ride"] = 328.82, ["Mega"] = 788.15, ["Mega|Ride"] = 754.24, ["Mega|Fly|Ride"] = 822.05}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.51, ["Neon"] = 3.18, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.74, ["Mega"] = 29.9, ["Mega|Ride"] = 80.16, ["Mega|Fly|Ride"] = 152.1}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 65.63, ["Ride"] = 64.76, ["Neon"] = 128.37, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 544.69, ["Mega|Ride"] = 520.68, ["Mega|Fly|Ride"] = 802.22}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 105, ["Mega"] = 35.04}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 39.38, ["Mega"] = 77.46, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 112.22, ["Ride"] = 129.47, ["Fly|Ride"] = 257.25, ["Neon"] = 430.57, ["Neon|Ride"] = 514.5, ["Neon|Fly|Ride"] = 685.38, ["Mega|Ride"] = 6357.45, ["Mega|Fly|Ride"] = 3854.93}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 19.69, ["Fly|Ride"] = 92.71, ["Neon"] = 8.22, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 90.57, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 39.32, ["Ride"] = 68.86, ["Fly|Ride"] = 52.49, ["Neon"] = 3.93, ["Neon|Fly"] = 61.66, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 122.3, ["Mega"] = 31.87, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 219.91}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.22, ["Neon"] = 2.1, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 47.11, ["Mega"] = 36.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 224.02}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 5.09, ["Neon|Ride"] = 137.71, ["Mega"] = 52.5, ["Mega|Ride"] = 200.71}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 63.95, ["Ride"] = 116.94, ["Fly|Ride"] = 449.61, ["Neon"] = 415.63, ["Neon|Ride"] = 496.26, ["Neon|Fly|Ride"] = 685.38, ["Mega"] = 1233.07, ["Mega|Ride"] = 1541.33, ["Mega|Fly|Ride"] = 1364.6}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 4.97, ["Ride"] = 59.91, ["Fly|Ride"] = 131.25, ["Neon"] = 46.87, ["Neon|Ride"] = 153.25, ["Mega"] = 375.85, ["Mega|Ride"] = 847.23}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Fly"] = 462.31, ["Ride"] = 431.59, ["Fly|Ride"] = 616.46, ["Neon"] = 2876.78, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 80.47}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 42}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.02}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 35.6}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 115.96}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 57.33}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 19.69}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.15}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 41.11}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.6}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.87}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.99}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.5}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 9.09}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 465.94}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 787.5}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 62.14}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.15}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 36.2}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 18.48}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.18}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.65}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 21.48}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.28}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.23}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.04}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 15.09}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 7.96}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.45}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1861.7}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.84}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 322.34}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.36}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.1}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.14}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 39.19}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 203.6}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.13}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1370.58}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.17}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.52}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 17.99}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.39}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.13}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.15}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.28}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.57}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.43}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 6.07}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 30.01}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 90.06}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 183.75}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.54}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.83}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.17}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 87.94}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22011.78}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 49.33}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 42}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 92.48}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.66}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 75.51}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.85}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 55.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 76.11}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 38.07}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 89.4}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 410.99}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.12}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 10.28}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 11.67}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.36}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.59}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 89.07}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 6.57}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.28}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 636.76}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.87}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.43}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 600.92}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 39.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 68.81}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 27.76}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 22.61}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 138.21}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 18.51}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.43}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.97}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.37}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 24.93}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.95}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 187.28}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.76}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.29}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.9}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.17}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 78.66}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 8.29}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 86.5}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 19.36}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.05}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.45}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.86}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 4.76}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.81}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.25}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6554.05}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.02}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.37}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.65}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.24}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.08}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 7.77}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 5.22}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.09}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 96.59}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 12.72}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 99.73}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.12}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4275.72}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 236.24}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 5.81}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 8.07}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.01}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.4}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.29}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.94}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.63}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.38}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.53}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.4}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.04}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 4.94}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.16}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 11.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.52}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.67}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.38}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 90.46}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1040.82}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.74}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.48}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 68.85}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.25}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.94}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.52}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.18}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.75}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.94}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.51}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 23.46}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.56}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.18}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.26}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.43}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 17.57}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 49.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.16}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.86}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.31}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.18}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.58}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 6.08}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.18}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 6.08}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 7.09}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 314.9}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.37}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1199.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.33}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.71}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 22.32}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.97}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.5}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.52}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.88}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 53.66}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.4}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.79}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 59.07}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.42}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.41}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.59}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 61.85}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.61}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.15}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.17}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 128.94}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.77}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 75.11}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 33.62}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 135.85}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.17}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 229.59}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.5}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 74.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.91}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 135.29}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.91}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.6}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 55.42}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.75}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.07}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.77}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 28.58}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 16.28}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 36.26}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 7.4}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 36.66}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.7}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 55.23}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.88}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.83}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 44.83}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.49}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 20.74}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.6}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.04}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 30.18}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 373.99}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.62}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.36}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 44.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.01}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.56}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 259.77}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.61}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 44.54}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.63}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 64.39}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 126}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 58.79}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 118.13}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.57}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2157.6}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 524.99}},
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