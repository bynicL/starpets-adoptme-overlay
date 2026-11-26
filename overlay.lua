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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 812.52, ["Fly"] = 1125.91, ["Ride"] = 801.86, ["Fly|Ride"] = 858.83, ["Neon"] = 6540.47, ["Neon|Ride"] = 4502.51, ["Neon|Fly|Ride"] = 3443.1}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 422.09, ["Fly"] = 507.05, ["Ride"] = 472.5, ["Fly|Ride"] = 561.3, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 8301.2}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["Ride"] = 4659.38, ["Fly|Ride"] = 4593.74, ["Neon"] = 26025.24, ["Neon|Fly|Ride"] = 26378.72, ["Mega|Fly|Ride"] = 73195.32}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 124.58, ["Ride"] = 156.19, ["Fly|Ride"] = 294.37, ["Neon"] = 1090.99, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 947.57, ["Mega"] = 2814.2, ["Mega|Fly|Ride"] = 6230.16}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 479.07, ["Ride"] = 483.83, ["Fly|Ride"] = 538.12, ["Neon|Ride"] = 1547.98, ["Neon|Fly|Ride"] = 1719.37, ["Mega|Fly|Ride"] = 7276.98}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 6.51, ["Ride"] = 145.68, ["Fly|Ride"] = 112.91, ["Neon"] = 45.56, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 265.16, ["Mega"] = 280.88, ["Mega|Ride"] = 200.5, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.92, ["Fly"] = 31.37, ["Ride"] = 19.69, ["Fly|Ride"] = 62.06, ["Neon"] = 21.08, ["Neon|Fly"] = 53.74, ["Neon|Ride"] = 37.91, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 128.7, ["Mega|Fly"] = 303.19, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 264.87}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 133.88, ["Fly"] = 656.25, ["Ride"] = 282.19, ["Neon"] = 506.45, ["Neon|Ride"] = 542.38, ["Neon|Fly|Ride"] = 1688.32, ["Mega|Ride"] = 1899.36, ["Mega|Fly|Ride"] = 1601.79}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 32.82, ["Fly"] = 62.39, ["Ride"] = 45.68, ["Fly|Ride"] = 65.42, ["Neon"] = 210.97, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 2100, ["Mega|Ride"] = 685.9, ["Mega|Fly|Ride"] = 730.21}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 17.54, ["Fly"] = 41.93, ["Ride"] = 31.55, ["Fly|Ride"] = 65.45, ["Neon"] = 278.56, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 484.35, ["Mega|Fly|Ride"] = 694.34}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 49.85, ["Fly"] = 394.66, ["Ride"] = 54.81, ["Fly|Ride"] = 105, ["Neon"] = 103.69, ["Neon|Fly"] = 197.31, ["Neon|Ride"] = 221.94, ["Neon|Fly|Ride"] = 246.75, ["Mega|Ride"] = 1042.54, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 61.29}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 336, ["Fly"] = 441.09, ["Ride"] = 322.88, ["Fly|Ride"] = 420, ["Neon"] = 1266.08, ["Neon|Ride"] = 1214.81, ["Neon|Fly|Ride"] = 1194.38, ["Mega|Fly|Ride"] = 3798.23}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 111.57, ["Ride"] = 114.19, ["Fly|Ride"] = 124.69, ["Neon"] = 1407.47, ["Neon|Fly|Ride"] = 540.75, ["Mega|Fly|Ride"] = 2431.17}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Fly"] = 32.72, ["Ride"] = 56.99, ["Fly|Ride"] = 65.63, ["Neon"] = 16.56, ["Neon|Ride"] = 67.18, ["Neon|Fly|Ride"] = 80.21, ["Mega"] = 107.76, ["Mega|Ride"] = 172.88, ["Mega|Fly|Ride"] = 386.63}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 123.37, ["Fly"] = 118.44, ["Ride"] = 115.5, ["Fly|Ride"] = 150.94, ["Neon"] = 619.34, ["Neon|Ride"] = 633.05, ["Neon|Fly|Ride"] = 542.07, ["Mega"] = 2110.39, ["Mega|Fly|Ride"] = 1967.44}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.5, ["Fly"] = 23.63, ["Ride"] = 22.44, ["Fly|Ride"] = 59.07, ["Neon"] = 19.69, ["Neon|Fly"] = 105.52, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 82.85, ["Mega"] = 223.71, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 32.72, ["Ride"] = 54.88, ["Fly|Ride"] = 131.25, ["Neon"] = 152.25, ["Neon|Ride"] = 186.9, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 696.35, ["Mega|Ride"] = 681.07, ["Mega|Fly|Ride"] = 679.38}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 43.32}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 47.25, ["Ride"] = 112.92, ["Neon"] = 279.57, ["Mega"] = 2954.55, ["Mega|Fly|Ride"] = 3115.08}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 11.38, ["Fly"] = 42.23, ["Ride"] = 32.02, ["Fly|Ride"] = 141.4, ["Neon"] = 85.32, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 258.27, ["Mega"] = 2686.42, ["Mega|Ride"] = 499.93, ["Mega|Fly|Ride"] = 654.1}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 31.14, ["Fly"] = 99.75, ["Ride"] = 45.75, ["Fly|Ride"] = 78.75, ["Neon"] = 354.52, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1681.32, ["Mega|Fly|Ride"] = 915.01}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.93, ["Ride"] = 155.76, ["Fly|Ride"] = 196.88, ["Neon"] = 209.84, ["Neon|Ride"] = 422.04, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 1680.53, ["Mega|Ride"] = 1252.53, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 27.45, ["Ride"] = 45.94, ["Fly|Ride"] = 133.22, ["Neon"] = 171.99, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 311.29, ["Mega"] = 525, ["Mega|Ride"] = 902.1, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 52.24, ["Fly"] = 75.98, ["Ride"] = 56.44, ["Fly|Ride"] = 98.13, ["Neon"] = 253.23, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 307.97, ["Mega|Ride"] = 3165.59, ["Mega|Fly|Ride"] = 941.25}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.93, ["Fly"] = 28.3, ["Ride"] = 21, ["Fly|Ride"] = 41.97, ["Neon"] = 21.05, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 80.3, ["Mega"] = 109.82, ["Mega|Fly"] = 422.09, ["Mega|Ride"] = 153.3, ["Mega|Fly|Ride"] = 215.25}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 303.73, ["Fly"] = 369.33, ["Ride"] = 323.96, ["Fly|Ride"] = 233.63, ["Neon"] = 1434.9, ["Neon|Ride"] = 1477.28, ["Neon|Fly|Ride"] = 1416.19, ["Mega"] = 10551.92, ["Mega|Fly|Ride"] = 5451.09}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.84, ["Ride"] = 47.25, ["Fly|Ride"] = 137.17, ["Neon"] = 239.52, ["Neon|Ride"] = 211.05, ["Mega"] = 830.46, ["Mega|Fly|Ride"] = 742.88}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 2.63, ["Fly"] = 38.07, ["Ride"] = 19.69, ["Fly|Ride"] = 41.68, ["Neon"] = 39.3, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 64.66, ["Neon|Fly|Ride"] = 105.19, ["Mega"] = 352.46, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 95.82, ["Fly"] = 5250, ["Ride"] = 102.38, ["Fly|Ride"] = 104.47, ["Neon"] = 274.32, ["Neon|Fly"] = 379.84, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 6189.27, ["Mega|Ride"] = 3115.08, ["Mega|Fly|Ride"] = 1713.48}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.18, ["Ride"] = 31.66, ["Fly|Ride"] = 115.5, ["Neon"] = 151.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 207.38, ["Mega"] = 700.66, ["Mega|Ride"] = 585.64}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 196.88, ["Ride"] = 226.09, ["Fly|Ride"] = 281.72, ["Neon"] = 703.74, ["Neon|Ride"] = 759.75, ["Neon|Fly|Ride"] = 801.94, ["Mega"] = 6331.16, ["Mega|Fly|Ride"] = 2528.25}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 31.4, ["Ride"] = 28.5, ["Fly|Ride"] = 62.27, ["Neon"] = 18.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 42.23, ["Neon|Fly|Ride"] = 105.53, ["Mega"] = 147.45, ["Mega|Fly"] = 225.83, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 280.33}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 494.82, ["Fly"] = 601.48, ["Ride"] = 525, ["Fly|Ride"] = 570.94, ["Neon"] = 2954.19, ["Neon|Ride"] = 3032.64, ["Neon|Fly|Ride"] = 2532.16, ["Mega"] = 12662.3, ["Mega|Ride"] = 52560.19, ["Mega|Fly|Ride"] = 9849.16}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 9.34, ["Fly"] = 45.59, ["Ride"] = 26.25, ["Fly|Ride"] = 70.1, ["Neon"] = 42.23, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 102.1, ["Neon|Fly|Ride"] = 176.24, ["Mega"] = 526.32, ["Mega|Ride"] = 601.48, ["Mega|Fly|Ride"] = 665.68}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 103.37, ["Ride"] = 141.39, ["Fly|Ride"] = 157.5, ["Neon"] = 590.85, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 605.69, ["Mega"] = 2492.53, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 2532.48}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 41.22}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 26.25, ["Ride"] = 91.88, ["Fly|Ride"] = 262.5, ["Neon"] = 157.5, ["Neon|Ride"] = 246.93, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 675.12, ["Mega|Ride"] = 623.74, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 166.69, ["Ride"] = 204.11, ["Neon"] = 513.19, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 2336.02, ["Mega|Fly|Ride"] = 2287.67}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 124.68, ["Ride"] = 129.94, ["Fly|Ride"] = 262.49, ["Neon"] = 436.89, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 1829.72, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 53.33}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 74.68, ["Fly"] = 56.99, ["Ride"] = 53.82, ["Fly|Ride"] = 90.77, ["Neon|Ride"] = 303.72, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1346.44}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.22, ["Ride"] = 44.79, ["Fly|Ride"] = 131.25, ["Neon"] = 26.25, ["Neon|Ride"] = 56.99, ["Neon|Fly|Ride"] = 225.83, ["Mega"] = 183.08, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 253.25, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 303.19, ["Fly"] = 576.19, ["Ride"] = 315, ["Fly|Ride"] = 353.07, ["Neon|Fly"] = 1868.71, ["Neon|Ride"] = 1971.11, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 4828.55}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 62.27, ["Fly"] = 94.5, ["Ride"] = 75.68, ["Fly|Ride"] = 137.82, ["Neon"] = 262.47, ["Neon|Fly"] = 301.34, ["Neon|Ride"] = 280.65, ["Neon|Fly|Ride"] = 394.59, ["Mega|Fly|Ride"] = 1407.65}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3519.08, ["Fly"] = 3798.71, ["Ride"] = 3018.75, ["Fly|Ride"] = 3412.5, ["Neon|Fly|Ride"] = 13716.44}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 30.17, ["Fly"] = 56.99, ["Ride"] = 39.77, ["Fly|Ride"] = 110.25, ["Neon"] = 324.63, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 1899.36, ["Mega|Ride"] = 1899.36, ["Mega|Fly|Ride"] = 1266.24}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 86.54, ["Ride"] = 124.68, ["Fly|Ride"] = 167.55, ["Neon"] = 373.75, ["Neon|Ride"] = 506.5, ["Neon|Fly|Ride"] = 563.49, ["Mega"] = 6331.16, ["Mega|Ride"] = 1868.83, ["Mega|Fly|Ride"] = 1532.15}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 23.63, ["Fly"] = 62.78, ["Ride"] = 38.06, ["Fly|Ride"] = 104.62, ["Neon"] = 138.29, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 203.41, ["Mega"] = 2598.75, ["Mega|Fly|Ride"] = 561.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.44}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 63, ["Ride"] = 78.75, ["Fly|Ride"] = 105, ["Neon"] = 443.14, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 504.39, ["Mega|Fly|Ride"] = 1713.48}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 32.74}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 204.91, ["Ride"] = 211.03, ["Fly|Ride"] = 341.25, ["Neon|Fly|Ride"] = 2110.39}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 656.24, ["Ride"] = 718.19, ["Fly|Ride"] = 695.63, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 11760}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.59}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.24, ["Fly"] = 37.98, ["Ride"] = 27.56, ["Fly|Ride"] = 64.32, ["Neon"] = 183.6, ["Neon|Fly"] = 211.03, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 207.94, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 9.85}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4987.49, ["Fly|Ride"] = 4173.75, ["Neon|Fly|Ride"] = 10283.44, ["Mega|Fly|Ride"] = 40660.74}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 6.54, ["Ride"] = 23.59, ["Fly|Ride"] = 61.32, ["Neon"] = 69.65, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 392.55, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.73, ["Fly"] = 79.15, ["Ride"] = 39.38, ["Fly|Ride"] = 114.22, ["Neon"] = 141.4, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 703.83, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 56.99, ["Ride"] = 128.63, ["Fly|Ride"] = 111.85, ["Neon|Fly|Ride"] = 577.21}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 14.16, ["Ride"] = 42, ["Fly|Ride"] = 139.65, ["Neon"] = 56.97, ["Neon|Ride"] = 281.75, ["Neon|Fly|Ride"] = 335.26, ["Mega"] = 1125.91, ["Mega|Ride"] = 843.11, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2392.13, ["Fly"] = 2165.63, ["Ride"] = 2785.38, ["Fly|Ride"] = 2098.68, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 11892.57}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29437.7, ["Fly"] = 26250, ["Ride"] = 24806.25, ["Fly|Ride"] = 25554.38, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 70206.08, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 196969.32}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 20.98, ["Fly"] = 393.75, ["Ride"] = 39.35, ["Fly|Ride"] = 91.81, ["Neon"] = 156.18, ["Neon|Ride"] = 178.38, ["Neon|Fly|Ride"] = 337.67, ["Mega"] = 1470, ["Mega|Ride"] = 738.65, ["Mega|Fly|Ride"] = 948.49}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.37, ["Fly"] = 36.94, ["Ride"] = 28.49, ["Fly|Ride"] = 109.8, ["Neon"] = 14.41, ["Neon|Fly"] = 129.34, ["Neon|Ride"] = 35.7, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 99.75, ["Mega|Ride"] = 131.02, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.55, ["Ride"] = 38.07, ["Fly|Ride"] = 281.72, ["Neon"] = 40.19, ["Neon|Ride"] = 124.36, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 177.18, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Fly"] = 841.18, ["Ride"] = 682.5, ["Fly|Ride"] = 778.32, ["Neon"] = 2949.19, ["Neon|Ride"] = 2788.23, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 11255.73, ["Mega|Fly|Ride"] = 10830.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 910.88, ["Ride"] = 879.38, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 3798.71, ["Neon|Fly|Ride"] = 3459.03, ["Mega|Fly|Ride"] = 13928.54}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 23.34, ["Fly"] = 56.99, ["Ride"] = 44.4, ["Fly|Ride"] = 78.75, ["Neon"] = 156.59, ["Neon|Ride"] = 168.84, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 644.75}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 31.48}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 72.19, ["Fly"] = 116.85, ["Ride"] = 73.5, ["Fly|Ride"] = 156.16, ["Neon|Ride"] = 375.38, ["Neon|Fly|Ride"] = 380.63, ["Mega|Ride"] = 1688.32, ["Mega|Fly|Ride"] = 1526.59}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 75.62, ["Fly"] = 131.25, ["Ride"] = 118.13, ["Fly|Ride"] = 183.6, ["Neon"] = 441, ["Neon|Ride"] = 563.49, ["Neon|Fly|Ride"] = 15575.19, ["Mega"] = 2126.45, ["Mega|Ride"] = 1688.32, ["Mega|Fly|Ride"] = 1400.25}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 2.63, ["Fly"] = 21.12, ["Ride"] = 21.12, ["Fly|Ride"] = 49.6, ["Neon"] = 28.5, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 281.75, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 78.62, ["Fly"] = 93.17, ["Ride"] = 83.81, ["Fly|Ride"] = 140.21, ["Neon"] = 303.87, ["Neon|Ride"] = 362.25, ["Neon|Fly|Ride"] = 283.5, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.93, ["Ride"] = 39.38, ["Neon"] = 32.71, ["Neon|Ride"] = 91.59, ["Neon|Fly|Ride"] = 563.49, ["Mega"] = 98.44, ["Mega|Fly"] = 422.09, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 833.26}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.52, ["Fly"] = 60.17, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 259.88, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 454.8}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 35.44, ["Ride"] = 63.09, ["Fly|Ride"] = 274.33, ["Neon"] = 133.88, ["Neon|Ride"] = 345.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 492.79, ["Mega|Fly|Ride"] = 730.21}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.38, ["Fly"] = 90.77, ["Ride"] = 42.23, ["Fly|Ride"] = 78.28, ["Neon"] = 96.26, ["Neon|Ride"] = 124.52, ["Neon|Fly|Ride"] = 141.41, ["Mega|Ride"] = 914.87, ["Mega|Fly|Ride"] = 882.16}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7013.22, ["Ride"] = 4790.63, ["Fly|Ride"] = 4856.25, ["Neon"] = 30950.29, ["Neon|Fly|Ride"] = 26250}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 196.87, ["Fly"] = 215.25, ["Ride"] = 210, ["Fly|Ride"] = 230.66, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 1899.36}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 23.61, ["Fly"] = 53.82, ["Ride"] = 54.89, ["Fly|Ride"] = 109.8, ["Neon"] = 65.62, ["Neon|Fly"] = 109.8, ["Neon|Ride"] = 91.49, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 300.57, ["Mega|Fly"] = 422.09, ["Mega|Ride"] = 249.14, ["Mega|Fly|Ride"] = 330.74}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.03, ["Fly"] = 40.91, ["Ride"] = 20.96, ["Fly|Ride"] = 65.63, ["Neon"] = 15.7, ["Neon|Ride"] = 52.5, ["Mega"] = 140.44}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 42, ["Fly"] = 156.56, ["Ride"] = 65.62, ["Fly|Ride"] = 128.63, ["Neon"] = 103.69, ["Neon|Fly"] = 335.21, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 228.58, ["Mega"] = 380.86, ["Mega|Ride"] = 281.72, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 18571.88, ["Ride"] = 11082.75, ["Fly|Ride"] = 11489.63, ["Neon|Fly|Ride"] = 23625, ["Mega|Fly|Ride"] = 99891.77}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 134.03, ["Ride"] = 196.87, ["Fly|Ride"] = 262.5, ["Neon"] = 2110.14, ["Neon|Fly|Ride"] = 844.17, ["Mega"] = 4642.86, ["Mega|Fly|Ride"] = 4346.15}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.21, ["Fly"] = 459.38, ["Ride"] = 49.59, ["Fly|Ride"] = 88.91, ["Neon|Fly"] = 467.19, ["Neon|Ride"] = 266.44, ["Neon|Fly|Ride"] = 281.75, ["Mega|Fly|Ride"] = 2813.15}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.37, ["Ride"] = 24.28, ["Fly|Ride"] = 91.81, ["Neon"] = 72.19, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 112.22, ["Mega"] = 2532.48, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 779.07}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 346.54, ["Fly"] = 844.17, ["Ride"] = 393.37, ["Fly|Ride"] = 446.24, ["Neon"] = 1640.63, ["Neon|Ride"] = 1713.58, ["Neon|Fly|Ride"] = 1350.57, ["Mega"] = 5153.61, ["Mega|Fly|Ride"] = 5001.62}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.81, ["Ride"] = 31.55, ["Fly|Ride"] = 78.28, ["Neon"] = 19, ["Neon|Ride"] = 101.63, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 130.41, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 274.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 118.01, ["Fly"] = 109.83, ["Ride"] = 133.2, ["Fly|Ride"] = 179.81, ["Neon"] = 433.13, ["Neon|Ride"] = 406.07, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1574.99, ["Mega|Fly|Ride"] = 1749.37}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 14, ["Fly"] = 17.46, ["Ride"] = 18.35, ["Fly|Ride"] = 39.37, ["Neon|Fly"] = 94.97, ["Neon|Ride"] = 102.08, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 2532.48, ["Mega|Fly|Ride"] = 546.61}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 6.54}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.63, ["Ride"] = 99.2, ["Fly|Ride"] = 525, ["Neon"] = 406.87, ["Neon|Fly"] = 1688.12, ["Neon|Ride"] = 369.33, ["Neon|Fly|Ride"] = 692.1, ["Mega|Ride"] = 1401.62, ["Mega|Fly|Ride"] = 1541.78}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 12.86, ["Ride"] = 30.19, ["Fly|Ride"] = 78.08, ["Neon"] = 84.55, ["Neon|Ride"] = 123.9, ["Neon|Fly|Ride"] = 143.69, ["Mega"] = 393.75, ["Mega|Ride"] = 548.71, ["Mega|Fly|Ride"] = 926.89}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 13.92}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 26.24, ["Fly"] = 210, ["Ride"] = 76.13, ["Fly|Ride"] = 278.25, ["Neon"] = 133.88, ["Neon|Ride"] = 141.4, ["Neon|Fly|Ride"] = 262.24, ["Mega"] = 1547.98, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.77, ["Ride"] = 24.28, ["Neon"] = 18.31, ["Neon|Ride"] = 138.25, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 101.05, ["Mega|Ride"] = 259.6, ["Mega|Fly|Ride"] = 400.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.68, ["Fly"] = 56.99, ["Ride"] = 35.88, ["Fly|Ride"] = 91.87, ["Neon"] = 211.87, ["Neon|Ride"] = 154.88, ["Neon|Fly|Ride"] = 623.77, ["Mega|Ride"] = 623.74, ["Mega|Fly|Ride"] = 677.25}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 349.13, ["Fly"] = 437.75, ["Ride"] = 316.57, ["Fly|Ride"] = 387.19, ["Neon|Fly|Ride"] = 1632.4, ["Mega|Fly|Ride"] = 8863.61}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.43, ["Ride"] = 52.49, ["Fly|Ride"] = 115.5, ["Neon"] = 197.31, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 311.29, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 700.66}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 58.78, ["Ride"] = 77.12, ["Neon"] = 323.92, ["Neon|Fly"] = 281.72, ["Neon|Ride"] = 215.28, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1336.94}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.73, ["Ride"] = 51.75, ["Fly|Ride"] = 99.16, ["Neon"] = 70.71, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 211.03, ["Mega"] = 301.88, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 11215.49, ["Ride"] = 11089.97, ["Fly|Ride"] = 7348.52, ["Neon|Fly|Ride"] = 16401, ["Mega|Fly|Ride"] = 39372.9}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 2232.56, ["Fly"] = 2570.23, ["Ride"] = 1836.19, ["Fly|Ride"] = 2100, ["Neon|Ride"] = 5698.05, ["Neon|Fly|Ride"] = 4528.13, ["Mega|Fly|Ride"] = 14016.07}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 281.71, ["Ride"] = 261.19, ["Fly|Ride"] = 375.61, ["Neon"] = 1407.47, ["Neon|Ride"] = 1350.66, ["Neon|Fly|Ride"] = 1350.66, ["Mega"] = 16883.07, ["Mega|Fly|Ride"] = 6331.16}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.57, ["Fly"] = 31.56, ["Ride"] = 22.32, ["Fly|Ride"] = 38.04, ["Neon"] = 124.99, ["Neon|Ride"] = 93.45, ["Neon|Fly|Ride"] = 142.47, ["Mega|Fly|Ride"] = 522.34}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.23, ["Ride"] = 61.69, ["Fly|Ride"] = 153.57, ["Neon"] = 23.23, ["Neon|Ride"] = 55.97, ["Neon|Fly|Ride"] = 233.64, ["Mega"] = 164.62, ["Mega|Ride"] = 210.46, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 39.34, ["Fly"] = 45.94, ["Ride"] = 43.02, ["Fly|Ride"] = 85.32, ["Neon"] = 183.59, ["Neon|Ride"] = 195.56, ["Neon|Fly|Ride"] = 143.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.1, ["Fly"] = 25.44, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 15.84, ["Neon|Fly"] = 58.42, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 219.6, ["Mega|Ride"] = 158.29, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 295.32, ["Fly"] = 317.62, ["Ride"] = 278.81, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1054.15, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3504.03}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 56.99, ["Ride"] = 39.37, ["Fly|Ride"] = 56.43, ["Neon"] = 122.4, ["Neon|Fly"] = 467.19, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 782.97, ["Mega|Fly|Ride"] = 682.73}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.17, ["Fly"] = 33.89, ["Ride"] = 24.28, ["Fly|Ride"] = 46.44, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 109.82, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 422.09, ["Mega|Ride"] = 581.42, ["Mega|Fly|Ride"] = 346.12}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 452.09, ["Fly"] = 787.5, ["Ride"] = 420, ["Fly|Ride"] = 682.64, ["Mega|Fly|Ride"] = 9177}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1043.44, ["Ride"] = 1210.13, ["Fly|Ride"] = 1161.57, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 17811.64}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 72.19, ["Fly"] = 137.2, ["Ride"] = 87.94, ["Fly|Ride"] = 105, ["Neon"] = 502.22, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 455.85, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 169.31, ["Fly"] = 247.7, ["Ride"] = 196.88, ["Fly|Ride"] = 183.41, ["Neon"] = 703.74, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 590.23, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.49, ["Ride"] = 56.44, ["Neon"] = 394.61, ["Neon|Ride"] = 280.69, ["Neon|Fly|Ride"] = 844.17, ["Mega|Ride"] = 934.42, ["Mega|Fly|Ride"] = 1039.54}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 105.52, ["Ride"] = 168.83, ["Fly|Ride"] = 597.19, ["Neon"] = 1547.8, ["Neon|Ride"] = 1266.24, ["Neon|Fly|Ride"] = 1688.32, ["Mega|Fly|Ride"] = 2996.76}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1534.32, ["Fly"] = 2532.48, ["Ride"] = 1468.08, ["Fly|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 6562.49, ["Mega|Fly|Ride"] = 32081.58}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 64.92, ["Ride"] = 91.88, ["Fly|Ride"] = 264, ["Neon"] = 278.07, ["Neon|Ride"] = 281.72, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1971.11, ["Mega|Ride"] = 2321.44, ["Mega|Fly|Ride"] = 1975.1}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 536.16, ["Fly"] = 675.94, ["Ride"] = 528.68, ["Fly|Ride"] = 615.03, ["Neon"] = 1477.11, ["Neon|Ride"] = 1407.65, ["Neon|Fly|Ride"] = 1119.56, ["Mega|Fly|Ride"] = 2782.5}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 51.89, ["Fly"] = 59.06, ["Ride"] = 52.27, ["Fly|Ride"] = 99.18, ["Neon"] = 204.69, ["Neon|Ride"] = 513.45, ["Neon|Fly|Ride"] = 246.75, ["Mega|Fly|Ride"] = 738.65}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.4, ["Fly"] = 26.41, ["Ride"] = 19.84, ["Fly|Ride"] = 45.39, ["Neon"] = 20.06, ["Neon|Fly"] = 62.98, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 83.74, ["Mega"] = 98.44, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 183.59}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.81, ["Ride"] = 66.94, ["Fly|Ride"] = 252, ["Neon"] = 703.74, ["Neon|Ride"] = 774.53, ["Mega"] = 1401.62, ["Mega|Fly|Ride"] = 7034.97}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 492.51, ["Fly"] = 899.07, ["Ride"] = 535.5, ["Fly|Ride"] = 570.94, ["Neon|Ride"] = 1971.11, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 469.87, ["Ride"] = 523.68, ["Fly|Ride"] = 770.21, ["Neon"] = 8440.52, ["Neon|Fly|Ride"] = 3903.17, ["Mega|Fly|Ride"] = 17903.44}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15, ["Fly"] = 32.82, ["Ride"] = 25.19, ["Fly|Ride"] = 46.15, ["Neon"] = 141.4, ["Neon|Ride"] = 87.63, ["Neon|Fly|Ride"] = 114.48, ["Mega|Fly|Ride"] = 623.11}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 7.87, ["Ride"] = 19.69, ["Fly|Ride"] = 75.98, ["Neon"] = 70.3, ["Neon|Ride"] = 70.1, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 462.19, ["Mega|Ride"] = 462.19, ["Mega|Fly|Ride"] = 474.85}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.68, ["Ride"] = 26.25, ["Fly|Ride"] = 91.68, ["Neon"] = 18.83, ["Neon|Fly"] = 108.92, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 119.07, ["Mega|Fly"] = 224.44, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 31.5, ["Fly"] = 39.38, ["Ride"] = 45.47, ["Fly|Ride"] = 93.45, ["Neon"] = 252.29, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 709.86}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 31.44, ["Ride"] = 91.88, ["Fly|Ride"] = 623.76, ["Neon"] = 352.41, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1245.39}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 16.37, ["Fly"] = 57.11, ["Ride"] = 35.44, ["Fly|Ride"] = 70.71, ["Neon"] = 77.33, ["Neon|Ride"] = 92.93, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 656.25, ["Mega|Ride"] = 390.13, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.18, ["Fly"] = 78.1, ["Ride"] = 32.8, ["Fly|Ride"] = 92.13, ["Neon"] = 350.3, ["Neon|Ride"] = 196.83, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2100, ["Mega|Ride"] = 1214.74, ["Mega|Fly|Ride"] = 746.23}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.83, ["Fly"] = 38.07, ["Ride"] = 17.07, ["Fly|Ride"] = 43.82, ["Neon"] = 34.28, ["Neon|Ride"] = 35.68, ["Neon|Fly|Ride"] = 105, ["Mega"] = 249.98, ["Mega|Ride"] = 467.21, ["Mega|Fly|Ride"] = 314.47}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 2.63, ["Fly"] = 59.11, ["Ride"] = 28.67, ["Fly|Ride"] = 1838.22, ["Neon"] = 28.48, ["Neon|Fly"] = 156.52, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 128.61, ["Mega"] = 233.61, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.15, ["Fly"] = 60.36, ["Ride"] = 45.72, ["Fly|Ride"] = 78.73, ["Neon"] = 419.93, ["Neon|Ride"] = 247.98, ["Neon|Fly|Ride"] = 263.82, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2321.44, ["Fly"] = 2406.14, ["Ride"] = 2029.11, ["Fly|Ride"] = 2065.88, ["Neon"] = 6697.68, ["Neon|Fly|Ride"] = 4882.6, ["Mega|Fly|Ride"] = 14003.07}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 437.92, ["Fly"] = 581.36, ["Ride"] = 524.47, ["Fly|Ride"] = 521.07, ["Neon"] = 3114.9, ["Neon|Ride"] = 3095.94, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 275.63, ["Ride"] = 280.72, ["Fly|Ride"] = 430.5, ["Neon"] = 2110.14, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1407.65, ["Mega|Fly|Ride"] = 6048.36}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.12, ["Fly"] = 65.63, ["Ride"] = 57, ["Fly|Ride"] = 76.13, ["Neon"] = 288.75, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 282.8, ["Mega"] = 1159.67, ["Mega|Ride"] = 1477.28, ["Mega|Fly|Ride"] = 1125.91}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 29967.44, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 14437.5, ["Neon|Fly|Ride"] = 36748.69, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 210.72, ["Fly"] = 262.88, ["Ride"] = 216.98, ["Fly|Ride"] = 273, ["Neon"] = 576.18, ["Neon|Fly"] = 801.86, ["Neon|Ride"] = 700.07, ["Neon|Fly|Ride"] = 623.44, ["Mega"] = 3504.31, ["Mega|Ride"] = 2477.61, ["Mega|Fly|Ride"] = 2315.1}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 5250, ["Ride"] = 249.38, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1713.58, ["Mega|Fly|Ride"] = 4220.77}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 86.49, ["Ride"] = 103.69, ["Fly|Ride"] = 169.32, ["Neon"] = 534.93, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 563.48, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 1581.56}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 12.86, ["Fly"] = 94.5, ["Ride"] = 30.39, ["Fly|Ride"] = 78.08, ["Neon"] = 99.2, ["Neon|Ride"] = 139.01, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 622.13, ["Mega|Ride"] = 602.7, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3814.63, ["Ride"] = 4331.25, ["Fly|Ride"] = 4284.5, ["Neon|Ride"] = 22651.79, ["Neon|Fly|Ride"] = 17062.5}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 22.3, ["Fly"] = 46.75, ["Ride"] = 30.03, ["Fly|Ride"] = 64.03, ["Neon"] = 131.25, ["Neon|Ride"] = 140.19, ["Neon|Fly|Ride"] = 208.9, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 47.25, ["Fly"] = 63.1, ["Ride"] = 42.23, ["Fly|Ride"] = 87.94, ["Neon"] = 139, ["Neon|Ride"] = 278.59, ["Neon|Fly|Ride"] = 197.34, ["Mega"] = 830.46, ["Mega|Fly|Ride"] = 868.44}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 536.8, ["Fly"] = 656.25, ["Ride"] = 422.04, ["Fly|Ride"] = 652.32, ["Neon"] = 1635.14, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Ride"] = 6331.16, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.09, ["Fly"] = 25.34, ["Ride"] = 22.32, ["Fly|Ride"] = 53.81, ["Neon"] = 63.32, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 703.83, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 18.71, ["Ride"] = 139.13, ["Fly|Ride"] = 137.17, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 89.25}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 91.28, ["Ride"] = 120.27, ["Fly|Ride"] = 165.38, ["Neon"] = 498.75, ["Neon|Ride"] = 633.12, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 3021.03}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 23.63, ["Fly"] = 90.77, ["Ride"] = 88.59, ["Fly|Ride"] = 141.4, ["Neon"] = 78.75, ["Neon|Fly"] = 126, ["Neon|Ride"] = 132.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 140.44, ["Mega|Fly"] = 523.69, ["Mega|Ride"] = 241.49, ["Mega|Fly|Ride"] = 419.97}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3028.86, ["Ride"] = 3136.88, ["Fly|Ride"] = 3033.19, ["Neon"] = 9494.52, ["Neon|Ride"] = 17133.41, ["Neon|Fly|Ride"] = 6825, ["Mega"] = 63311.46, ["Mega|Fly|Ride"] = 35575.77}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 33.76, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 114.48, ["Neon"] = 162.49, ["Neon|Ride"] = 140.76, ["Neon|Fly|Ride"] = 211.03, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5628.4, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 5512.5, ["Neon|Fly|Ride"] = 13123.69, ["Mega|Fly|Ride"] = 63241.82}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 19.67, ["Ride"] = 18.36, ["Fly|Ride"] = 32.82, ["Neon"] = 21.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 84.04, ["Mega"] = 452.04, ["Mega|Ride"] = 211.05, ["Mega|Fly|Ride"] = 218.44}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.31, ["Fly"] = 35.43, ["Ride"] = 31.5, ["Fly|Ride"] = 55.76, ["Neon"] = 141.4, ["Neon|Ride"] = 281.38, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 1342.05, ["Mega|Fly|Ride"] = 927.94}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.83, ["Fly"] = 70.71, ["Ride"] = 26.22, ["Fly|Ride"] = 91.88, ["Neon"] = 62.99, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 141.41, ["Mega|Ride"] = 633.12, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 40.68, ["Fly"] = 111.86, ["Ride"] = 50.29, ["Fly|Ride"] = 281.72, ["Neon"] = 162.49, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 280.33, ["Mega"] = 840, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 8.45, ["Fly"] = 30.39, ["Ride"] = 21.07, ["Fly|Ride"] = 34.8, ["Neon"] = 54.88, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 1126.96, ["Mega|Fly|Ride"] = 623.74}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8888.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2698.23}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.59}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 303.05, ["Fly"] = 422.09, ["Ride"] = 295.32, ["Fly|Ride"] = 352.41, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1801.23, ["Mega|Fly|Ride"] = 5909.08}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.58, ["Fly"] = 130.86, ["Ride"] = 31.56, ["Fly|Ride"] = 101.07, ["Neon"] = 131.23, ["Neon|Ride"] = 162.51, ["Mega"] = 545.47, ["Mega|Ride"] = 563.49, ["Mega|Fly|Ride"] = 474.85}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.15, ["Neon"] = 99.2, ["Neon|Ride"] = 183.62}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 129.94, ["Ride"] = 141.41, ["Fly|Ride"] = 10498.95, ["Neon"] = 623.69, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1899.36}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 88.75, ["Fly"] = 141.41, ["Ride"] = 126.62, ["Fly|Ride"] = 118.12, ["Neon"] = 467.19, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 1798.07, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1401.75}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 175.76, ["Fly"] = 281.75, ["Ride"] = 174.57, ["Fly|Ride"] = 196.88, ["Neon"] = 820.32, ["Neon|Ride"] = 671.98, ["Neon|Fly|Ride"] = 908.25, ["Mega|Ride"] = 3236.29, ["Mega|Fly|Ride"] = 2933.44}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1069.69, ["Fly"] = 2532.48, ["Ride"] = 945, ["Fly|Ride"] = 1097.97, ["Neon|Fly|Ride"] = 4592.44, ["Mega|Fly|Ride"] = 21103.83}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.73, ["Fly"] = 109.83, ["Ride"] = 41.18, ["Fly|Ride"] = 86.63, ["Neon"] = 105, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 934.42, ["Mega|Fly|Ride"] = 793.52}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 582.74, ["Fly"] = 2100, ["Ride"] = 694.61, ["Fly|Ride"] = 1149.75, ["Neon|Fly|Ride"] = 4049.48}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 46.18}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.44, ["Fly"] = 144.38, ["Ride"] = 40.69, ["Fly|Ride"] = 98.44, ["Neon"] = 60.16, ["Neon|Ride"] = 156.54, ["Neon|Fly|Ride"] = 379.88, ["Mega"] = 393.75, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.83, ["Fly"] = 350.49, ["Ride"] = 23.63, ["Fly|Ride"] = 91.88, ["Neon"] = 52.5, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 202.18, ["Mega|Ride"] = 392.55, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 76.11}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 23.63, ["Ride"] = 37.99, ["Fly|Ride"] = 65.54, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 545.47, ["Mega"] = 817.79, ["Mega|Ride"] = 1125.91, ["Mega|Fly|Ride"] = 563.41}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.82, ["Fly"] = 39.38, ["Ride"] = 44.43, ["Fly|Ride"] = 78.75, ["Neon"] = 156.52, ["Neon|Fly"] = 242.94, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 274.32, ["Mega"] = 1405.52, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5712, ["Fly"] = 11255.73, ["Ride"] = 6330.38, ["Fly|Ride"] = 5053.13, ["Neon|Fly|Ride"] = 9712.49, ["Mega|Fly|Ride"] = 34638.77}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.81, ["Ride"] = 26.25, ["Fly|Ride"] = 111.85, ["Neon"] = 65.58, ["Neon|Fly"] = 112.91, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 238.49, ["Mega"] = 451.58, ["Mega|Ride"] = 379.84, ["Mega|Fly|Ride"] = 454.65}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 104.98, ["Fly"] = 373.55, ["Ride"] = 125, ["Fly|Ride"] = 156.54, ["Neon"] = 417.37, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 479.08, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 61.64, ["Fly"] = 183.75, ["Ride"] = 87.28, ["Fly|Ride"] = 236.25, ["Neon"] = 235.1, ["Neon|Ride"] = 299.69, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1354.89, ["Mega|Fly|Ride"] = 1052.04}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.01, ["Fly"] = 70.82, ["Ride"] = 28.5, ["Fly|Ride"] = 78.75, ["Neon"] = 126.62, ["Neon|Ride"] = 141.36, ["Neon|Fly|Ride"] = 161.6, ["Mega|Fly|Ride"] = 485.03}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.54, ["Fly"] = 48.71, ["Ride"] = 23.02, ["Fly|Ride"] = 50.27, ["Neon"] = 21.12, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 118.13, ["Mega|Fly"] = 151.86, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.37, ["Ride"] = 28.22, ["Fly|Ride"] = 99.2, ["Neon"] = 63.09, ["Neon|Ride"] = 91.11, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 315, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.22, ["Fly"] = 26.24, ["Ride"] = 24.94, ["Fly|Ride"] = 42.23, ["Neon"] = 84.42, ["Neon|Fly"] = 211.03, ["Neon|Ride"] = 188.25, ["Neon|Fly|Ride"] = 124.69, ["Mega|Fly"] = 703.83, ["Mega|Fly|Ride"] = 585.83}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 195.44}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 13.13, ["Fly"] = 125.02, ["Ride"] = 98.44, ["Neon"] = 92.87, ["Neon|Ride"] = 394.66, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 525.62, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 172.9, ["Ride"] = 360.9, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 417.38}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 28.88, ["Ride"] = 78.75, ["Fly|Ride"] = 246.75, ["Neon"] = 199.5, ["Neon|Ride"] = 324.98, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 1111.69, ["Mega|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 1036.88}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 616.88, ["Fly"] = 780.94, ["Ride"] = 689.07, ["Fly|Ride"] = 654.94, ["Neon|Ride"] = 1704.94, ["Neon|Fly|Ride"] = 2086.88, ["Mega|Fly|Ride"] = 7783.13}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 196.88, ["Ride"] = 281.72, ["Fly|Ride"] = 275.63, ["Neon"] = 1159.54, ["Neon|Fly"] = 3426.75, ["Neon|Ride"] = 1558.24, ["Neon|Fly|Ride"] = 1175.5, ["Mega"] = 8301.2, ["Mega|Ride"] = 4088.02, ["Mega|Fly|Ride"] = 3941.16}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 78.23}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.87, ["Fly"] = 23.09, ["Ride"] = 23.61, ["Fly|Ride"] = 48.57, ["Neon"] = 80.07, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 63.09, ["Neon|Fly|Ride"] = 84, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 288.7, ["Fly"] = 338.82, ["Ride"] = 291.37, ["Fly|Ride"] = 328.12, ["Neon"] = 1181.69, ["Neon|Ride"] = 931.88, ["Neon|Fly|Ride"] = 939.75, ["Mega|Fly|Ride"] = 3890.03}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.43}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 89.25, ["Fly"] = 178.12, ["Ride"] = 140.44, ["Fly|Ride"] = 216.57, ["Neon"] = 525, ["Neon|Fly"] = 1407.47, ["Neon|Ride"] = 486.94, ["Neon|Fly|Ride"] = 648.4, ["Mega"] = 2215.91, ["Mega|Fly|Ride"] = 1770.11}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 156.19, ["Ride"] = 150.94, ["Fly|Ride"] = 150.94, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 703.65}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.68, ["Ride"] = 32.72, ["Fly|Ride"] = 125, ["Neon"] = 31.55, ["Neon|Ride"] = 75.98, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 240.19, ["Mega|Ride"] = 197.07, ["Mega|Fly|Ride"] = 545.47}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.26, ["Fly"] = 42, ["Ride"] = 24.93, ["Fly|Ride"] = 76.13, ["Neon"] = 99.18, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 197.34, ["Mega|Ride"] = 738.65, ["Mega|Fly|Ride"] = 623.74}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.69, ["Fly"] = 141.41, ["Ride"] = 39.38, ["Fly|Ride"] = 144.38, ["Neon"] = 169.32, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 277.53, ["Mega"] = 328.13, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 551.88}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.13, ["Fly"] = 337.67, ["Ride"] = 46.74, ["Fly|Ride"] = 89.25, ["Neon"] = 19.04, ["Neon|Fly"] = 69.65, ["Neon|Ride"] = 45.35, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 109.81, ["Mega|Fly"] = 183.74, ["Mega|Ride"] = 141.12, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 261.19, ["Fly"] = 918.75, ["Ride"] = 336, ["Fly|Ride"] = 404.25, ["Neon"] = 1745.08, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1264.88}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 97.08, ["Fly"] = 1050, ["Ride"] = 156.19, ["Fly|Ride"] = 241.89, ["Neon"] = 525, ["Neon|Ride"] = 561.75, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2321.44, ["Mega|Ride"] = 2392.13, ["Mega|Fly|Ride"] = 2220.96}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 156.19, ["Ride"] = 78.75, ["Fly|Ride"] = 131.24, ["Neon"] = 295.43, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 355.04, ["Mega"] = 1620.04, ["Mega|Ride"] = 1666.75, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.73, ["Fly"] = 52.5, ["Ride"] = 58.24, ["Fly|Ride"] = 281.72, ["Neon"] = 211.03, ["Neon|Ride"] = 593.4, ["Neon|Fly|Ride"] = 491.74, ["Mega"] = 422.09, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 18.38, ["Ride"] = 48.57, ["Fly|Ride"] = 102.38, ["Neon"] = 111.57, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 157.33, ["Mega"] = 451.64, ["Mega|Fly"] = 525, ["Mega|Ride"] = 408.37, ["Mega|Fly|Ride"] = 560.33}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 42.23, ["Ride"] = 27.44, ["Fly|Ride"] = 69.65, ["Neon"] = 15.67, ["Neon|Ride"] = 40.1, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 107.84, ["Mega|Ride"] = 175.51, ["Mega|Fly|Ride"] = 163.52}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 1124.85, ["Ride"] = 943.69, ["Fly|Ride"] = 912.19, ["Neon"] = 3036.98, ["Neon|Fly"] = 2848.69, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2336.25, ["Mega"] = 11959.55, ["Mega|Fly|Ride"] = 7113.75}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 257.23, ["Fly"] = 500.04, ["Ride"] = 268.04, ["Fly|Ride"] = 288.75, ["Neon"] = 1055.08, ["Neon|Ride"] = 943.69, ["Neon|Fly|Ride"] = 1005.38, ["Mega"] = 10551.92, ["Mega|Ride"] = 5918.3, ["Mega|Fly|Ride"] = 3602.44}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 98.44, ["Ride"] = 126.65, ["Fly|Ride"] = 153.03, ["Neon"] = 354.38, ["Neon|Ride"] = 379.88, ["Neon|Fly|Ride"] = 408.37, ["Mega"] = 1640.63, ["Mega|Ride"] = 1688.32, ["Mega|Fly|Ride"] = 1371.77}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 166.66, ["Fly"] = 227.07, ["Ride"] = 189, ["Fly|Ride"] = 252.16, ["Neon"] = 703.74, ["Neon|Ride"] = 985.56, ["Neon|Fly|Ride"] = 675.09, ["Mega"] = 10551.92, ["Mega|Fly|Ride"] = 2887.49}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.98, ["Fly"] = 42.23, ["Ride"] = 27.57, ["Fly|Ride"] = 71.76, ["Neon"] = 157.49, ["Neon|Ride"] = 141.39, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 563.49, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 779.07}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 261.19, ["Ride"] = 350.44, ["Fly|Ride"] = 473.73, ["Neon"] = 1336.78, ["Neon|Ride"] = 1348.54, ["Neon|Fly|Ride"] = 1393.88, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 3519.08}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 116.34, ["Fly"] = 173.07, ["Ride"] = 141.4, ["Fly|Ride"] = 157.49, ["Neon|Ride"] = 422.09, ["Neon|Fly|Ride"] = 416.81, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1246.88, ["Ride"] = 1384.69, ["Fly|Ride"] = 1358.43, ["Neon|Ride"] = 4080.44, ["Neon|Fly|Ride"] = 5628.4, ["Mega"] = 50649.18, ["Mega|Fly|Ride"] = 23358.92}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.41, ["Fly"] = 53.82, ["Ride"] = 31.66, ["Fly|Ride"] = 93.08, ["Neon"] = 38.07, ["Neon|Fly"] = 141.39, ["Neon|Ride"] = 63.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 280.32, ["Mega|Ride"] = 289.22, ["Mega|Fly|Ride"] = 354.12}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 37.33, ["Ride"] = 98.36, ["Fly|Ride"] = 77.11, ["Neon"] = 203.44, ["Neon|Ride"] = 166.74, ["Neon|Fly|Ride"] = 413.44, ["Mega"] = 1029.03, ["Mega|Fly|Ride"] = 1047.73}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 72.45, ["Fly"] = 73.5, ["Ride"] = 73.48, ["Fly|Ride"] = 80.07, ["Neon"] = 390.1, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 352.94, ["Mega|Fly|Ride"] = 1468.67}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2531.41, ["Ride"] = 918.75, ["Fly|Ride"] = 844.07, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 323.96, ["Ride"] = 388.33, ["Fly|Ride"] = 405.15, ["Neon|Ride"] = 1688.32, ["Neon|Fly|Ride"] = 1470.95, ["Mega|Fly|Ride"] = 9188.7}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 114.18, ["Fly"] = 209.85, ["Ride"] = 140.44, ["Fly|Ride"] = 131.25, ["Neon"] = 703.71, ["Neon|Ride"] = 429.99, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3962.44, ["Mega|Ride"] = 4220.77, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.65, ["Fly"] = 70.71, ["Ride"] = 26.71, ["Fly|Ride"] = 65.28, ["Neon"] = 74.34, ["Neon|Ride"] = 61.22, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 642.43, ["Mega|Ride"] = 508.59, ["Mega|Fly|Ride"] = 703.83}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 30.18, ["Fly"] = 70.71, ["Ride"] = 48.57, ["Fly|Ride"] = 78.75, ["Neon"] = 211.03, ["Neon|Fly"] = 295.43, ["Neon|Ride"] = 231.06, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1825.49, ["Mega|Fly|Ride"] = 1026.72}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 813.75, ["Fly"] = 945.56, ["Ride"] = 918.75, ["Fly|Ride"] = 811.13, ["Neon|Ride"] = 5250, ["Neon|Fly|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 15574.17}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 945}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4173.75, ["Ride"] = 3345.46, ["Fly|Ride"] = 3360, ["Neon|Ride"] = 30242.84, ["Neon|Fly|Ride"] = 14437.5, ["Mega|Fly|Ride"] = 90043.67}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 149.62, ["Fly"] = 408.19, ["Ride"] = 105.53, ["Fly|Ride"] = 393.75, ["Neon"] = 611.94, ["Neon|Ride"] = 1246.35, ["Neon|Fly|Ride"] = 851.82, ["Mega"] = 5909.08, ["Mega|Fly|Ride"] = 5487.01}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 77.38, ["Ride"] = 109.83, ["Fly|Ride"] = 336, ["Neon|Ride"] = 493.84, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1688.32}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 10.49, ["Fly"] = 131.25, ["Ride"] = 28.29, ["Fly|Ride"] = 74.92, ["Neon"] = 274.32, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 421.04, ["Mega|Ride"] = 844.17, ["Mega|Fly|Ride"] = 476.96}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 19.62, ["Fly"] = 39.38, ["Ride"] = 22.23, ["Fly|Ride"] = 42.21, ["Neon|Fly|Ride"] = 653.63, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 702.77}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 20.98, ["Fly"] = 70.9, ["Ride"] = 38.06, ["Fly|Ride"] = 105, ["Neon"] = 141.4, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1181.82, ["Mega|Ride"] = 859.69, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.23, ["Ride"] = 28.34, ["Fly|Ride"] = 252, ["Neon"] = 34.13, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 166.68, ["Mega"] = 292.02, ["Mega|Ride"] = 337.67, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 20.97, ["Ride"] = 49.24, ["Fly|Ride"] = 111.57, ["Neon"] = 143.06, ["Neon|Ride"] = 295.47, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 675.34, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 236.25, ["Fly"] = 301.43, ["Ride"] = 255.94, ["Fly|Ride"] = 261.19, ["Neon"] = 721.83, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 677.25, ["Mega"] = 6562.5, ["Mega|Ride"] = 4220.77, ["Mega|Fly|Ride"] = 2622.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.6, ["Fly"] = 16.9, ["Ride"] = 15.94, ["Fly|Ride"] = 46.44, ["Neon"] = 20.86, ["Neon|Fly"] = 93.44, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 69.25, ["Mega"] = 196.88, ["Mega|Ride"] = 738.94, ["Mega|Fly|Ride"] = 230.05}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 30.19, ["Fly"] = 98.36, ["Ride"] = 51.19, ["Fly|Ride"] = 107.63, ["Neon"] = 141.75, ["Neon|Fly"] = 226.59, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 511.88, ["Mega|Ride"] = 580.3, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 728.44, ["Ride"] = 741.56, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 1970.87, ["Neon|Fly|Ride"] = 1568.44, ["Mega|Fly|Ride"] = 4189.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 30.19, ["Fly"] = 59.6, ["Ride"] = 32.82, ["Fly|Ride"] = 78.09, ["Neon"] = 242.97, ["Neon|Fly"] = 467.19, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 1575, ["Mega|Ride"] = 985.56, ["Mega|Fly|Ride"] = 799.84}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 294.39, ["Fly"] = 352.46, ["Ride"] = 232.32, ["Fly|Ride"] = 295.43, ["Neon"] = 1407.47, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4193.35}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 112.92, ["Fly"] = 139.13, ["Ride"] = 120.31, ["Fly|Ride"] = 158.82, ["Neon"] = 633.05, ["Neon|Fly"] = 641.49, ["Neon|Ride"] = 526.55, ["Neon|Fly|Ride"] = 543.37, ["Mega"] = 2954.55, ["Mega|Fly|Ride"] = 1730.06}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 603.75, ["Fly|Ride"] = 656.25, ["Neon"] = 2378.13, ["Neon|Ride"] = 2405.85, ["Neon|Fly|Ride"] = 2411.07, ["Mega|Fly|Ride"] = 7764.11}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.07, ["Ride"] = 39.38, ["Fly|Ride"] = 94.97, ["Neon"] = 91.62, ["Neon|Fly"] = 183.6, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 525, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3719.63, ["Fly"] = 3956.54, ["Ride"] = 3936.19, ["Fly|Ride"] = 3013.5, ["Neon"] = 14032.35, ["Neon|Fly|Ride"] = 6753.23, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 75.59, ["Fly"] = 81.79, ["Ride"] = 78.17, ["Fly|Ride"] = 141.75, ["Neon"] = 394.75, ["Neon|Fly"] = 420.48, ["Neon|Ride"] = 405.35, ["Neon|Fly|Ride"] = 400.32, ["Mega|Fly|Ride"] = 1771.46}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.5, ["Fly"] = 27.43, ["Ride"] = 18.96, ["Fly|Ride"] = 70.71, ["Neon"] = 18.38, ["Neon|Fly"] = 44.63, ["Neon|Ride"] = 54.92, ["Neon|Fly|Ride"] = 73.88, ["Mega"] = 101.13, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 139.31, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.29, ["Ride"] = 32.71, ["Neon"] = 19.66, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 147, ["Mega|Ride"] = 168.84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 52.5, ["Fly"] = 65.63, ["Ride"] = 54.39, ["Fly|Ride"] = 78.75, ["Neon|Ride"] = 703.83, ["Neon|Fly|Ride"] = 240.19, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 787.5, ["Ride"] = 914.81, ["Fly|Ride"] = 977.82, ["Neon|Ride"] = 5274.91, ["Neon|Fly|Ride"] = 5803.56, ["Mega"] = 16352.07, ["Mega|Fly|Ride"] = 19697.26}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 4747.79, ["Ride"] = 5628.4, ["Fly|Ride"] = 4856.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.45, ["Fly"] = 27.44, ["Ride"] = 27.45, ["Fly|Ride"] = 47.23, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 120.25, ["Mega"] = 2532.48, ["Mega|Fly|Ride"] = 590.92}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.66, ["Fly"] = 39.38, ["Ride"] = 40.89, ["Fly|Ride"] = 78.28, ["Neon"] = 84.42, ["Neon|Ride"] = 62.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 935.29, ["Mega|Ride"] = 492.79, ["Mega|Fly|Ride"] = 486.41}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 44.88, ["Fly"] = 157.49, ["Ride"] = 48.55, ["Fly|Ride"] = 81.38, ["Neon"] = 393.75, ["Neon|Ride"] = 251.9, ["Neon|Fly|Ride"] = 329.2, ["Mega|Fly|Ride"] = 868.88}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 229.69, ["Ride"] = 249.38, ["Fly|Ride"] = 320.25, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1157.62, ["Mega"] = 10551.92, ["Mega|Fly|Ride"] = 3655.32}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 42.23, ["Fly|Ride"] = 105, ["Neon"] = 19.66, ["Neon|Fly"] = 70.95, ["Neon|Fly|Ride"] = 137.2, ["Mega"] = 126.81, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 295.47}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 195.07, ["Fly"] = 292.08, ["Ride"] = 196.88, ["Fly|Ride"] = 282.19, ["Neon"] = 671.04, ["Neon|Ride"] = 712.55, ["Neon|Fly|Ride"] = 703.71, ["Mega"] = 3504.31, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.71, ["Fly"] = 28.5, ["Ride"] = 19, ["Fly|Ride"] = 43.55, ["Neon"] = 28.02, ["Neon|Ride"] = 35.89, ["Neon|Fly|Ride"] = 105, ["Mega"] = 352.46, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 479.08}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 210, ["Fly"] = 270.14, ["Ride"] = 239.54, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 10551.92, ["Mega|Fly|Ride"] = 3798.23}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.8, ["Fly"] = 262.5, ["Ride"] = 26.25, ["Fly|Ride"] = 86.47, ["Neon"] = 124.51, ["Neon|Fly"] = 296.67, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 394.66, ["Mega"] = 451.64, ["Mega|Ride"] = 590.92, ["Mega|Fly|Ride"] = 504.32}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.56, ["Fly|Ride"] = 45.94, ["Neon"] = 13.99, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 36.22, ["Neon|Fly|Ride"] = 119.25, ["Mega"] = 76.13, ["Mega|Fly"] = 422.09, ["Mega|Ride"] = 100.99, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.97, ["Mega"] = 42, ["Mega|Fly|Ride"] = 166.74}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.94, ["Ride"] = 28.5, ["Fly|Ride"] = 141.4, ["Neon"] = 14.43, ["Neon|Ride"] = 41.19, ["Neon|Fly|Ride"] = 78.28, ["Mega"] = 68.25, ["Mega|Fly"] = 155734.64, ["Mega|Ride"] = 116.13, ["Mega|Fly|Ride"] = 255.19}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 67.17, ["Fly"] = 141.41, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 249.38, ["Neon|Ride"] = 249.37, ["Neon|Fly|Ride"] = 366.19, ["Mega"] = 1231.41, ["Mega|Ride"] = 1311.19, ["Mega|Fly|Ride"] = 1137.51}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 45.85, ["Ride"] = 18.38, ["Fly|Ride"] = 30.61, ["Neon"] = 12.5, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.79, ["Ride"] = 62.99, ["Fly|Ride"] = 126.62, ["Neon"] = 112.51, ["Neon|Ride"] = 212.63, ["Mega"] = 459.38, ["Mega|Ride"] = 560.44}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 80.21, ["Neon|Fly|Ride"] = 156.54, ["Mega"] = 14.43, ["Mega|Ride"] = 61.74, ["Mega|Fly|Ride"] = 170.1}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 17.07, ["Ride"] = 18, ["Fly|Ride"] = 35.88, ["Neon"] = 2.1, ["Neon|Fly"] = 21.12, ["Neon|Ride"] = 16.85, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 11.42, ["Mega|Ride"] = 23.23, ["Mega|Fly|Ride"] = 59.72}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.05, ["Ride"] = 15.84, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 16.27, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 17.53, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 91.87}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 19.69, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 126.65}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 31.67, ["Ride"] = 18.38, ["Fly|Ride"] = 105.52, ["Neon"] = 6.57, ["Neon|Ride"] = 35.89, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 221.93, ["Mega|Fly"] = 91.88, ["Mega|Fly|Ride"] = 138.25}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 141.39, ["Mega"] = 13.13, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 46.56, ["Ride"] = 21, ["Fly|Ride"] = 53.53, ["Neon"] = 3.94, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 25.34, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 60.38, ["Mega|Fly"] = 352.46, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Mega"] = 15.73, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.9, ["Ride"] = 142.45, ["Fly|Ride"] = 525, ["Neon"] = 14.43, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 56.99, ["Neon"] = 21}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Neon"] = 6.45, ["Neon|Ride"] = 103.95, ["Mega"] = 73.86, ["Mega|Ride"] = 174.04, ["Mega|Fly|Ride"] = 277.53}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.05, ["Fly"] = 30.39, ["Ride"] = 15.84, ["Fly|Ride"] = 51.72, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.44, ["Mega|Ride"] = 23.38, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 6.57, ["Fly"] = 72.19, ["Ride"] = 218.19, ["Fly|Ride"] = 120.29, ["Neon"] = 27.57, ["Neon|Ride"] = 39.38, ["Mega|Ride"] = 352.46}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.72, ["Fly|Ride"] = 78.73, ["Neon"] = 7.87, ["Neon|Ride"] = 31.67, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.82, ["Mega|Ride"] = 80.21, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.34, ["Ride"] = 70.71, ["Neon"] = 9.14, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 69.66, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.25, ["Ride"] = 32.81, ["Fly|Ride"] = 192.04, ["Neon"] = 10.56, ["Neon|Fly"] = 92.29, ["Neon|Ride"] = 42.23, ["Neon|Fly|Ride"] = 272.25, ["Mega"] = 105.53, ["Mega|Ride"] = 85.3, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.05, ["Ride"] = 22.31, ["Fly|Ride"] = 27.57, ["Neon"] = 2.05, ["Neon|Fly"] = 20.06, ["Neon|Ride"] = 13.73, ["Neon|Fly|Ride"] = 24.94, ["Mega"] = 13.11, ["Mega|Fly"] = 23.23, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.65, ["Fly|Ride"] = 138.5, ["Neon"] = 15.74, ["Neon|Ride"] = 112.16, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 122.19, ["Mega|Fly|Ride"] = 201.55}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 6.2, ["Fly"] = 112.92, ["Neon"] = 87.72, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 177.29, ["Mega|Ride"] = 419.97, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.05, ["Fly"] = 23.23, ["Ride"] = 15.75, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.89, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 125}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 5.67, ["Ride"] = 31.5, ["Neon"] = 7.86, ["Neon|Fly"] = 78.08, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 62.27, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.05, ["Ride"] = 28.5, ["Neon"] = 5.97, ["Neon|Fly"] = 156.16, ["Neon|Fly|Ride"] = 311.9, ["Mega"] = 32.8, ["Mega|Ride"] = 75.98, ["Mega|Fly|Ride"] = 197.34}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 120.31, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 84, ["Mega"] = 11.8, ["Mega|Ride"] = 72.43}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 20.98, ["Fly|Ride"] = 78.08, ["Neon"] = 7.03, ["Neon|Fly"] = 42.23, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 219.6, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.05, ["Neon"] = 11.8, ["Neon|Ride"] = 60.38, ["Mega"] = 63.53, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.49, ["Ride"] = 21, ["Fly|Ride"] = 35.88, ["Neon"] = 5.7, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 52.5, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 11.02, ["Ride"] = 82.69, ["Neon"] = 72.19, ["Mega"] = 296.63, ["Mega|Fly|Ride"] = 1045.37}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 56.44, ["Neon"] = 10.24, ["Neon|Fly"] = 58.78, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 143.69, ["Mega"] = 315, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 8.45, ["Fly"] = 105, ["Fly|Ride"] = 36.94, ["Neon"] = 18.36, ["Neon|Fly"] = 56.99, ["Neon|Ride"] = 56.99, ["Neon|Fly|Ride"] = 112.16, ["Mega"] = 128.62, ["Mega|Ride"] = 141.39, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 79.47, ["Fly|Ride"] = 105.15, ["Neon"] = 56.99}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.64, ["Neon|Ride"] = 422.04, ["Mega"] = 459.38, ["Mega|Ride"] = 985.56, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.57, ["Ride"] = 262.5, ["Neon"] = 42, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 84.42, ["Mega"] = 364.46, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 10.32, ["Ride"] = 70.1, ["Neon"] = 78.75, ["Neon|Ride"] = 291.38, ["Mega"] = 235.95, ["Mega|Ride"] = 269.73, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 15.74, ["Mega|Ride"] = 70.71, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 73.5}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.55, ["Fly"] = 22.32, ["Ride"] = 21.11, ["Fly|Ride"] = 58.42, ["Neon"] = 32.53, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 281.75, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 172.89, ["Mega"] = 19.69, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 194.17}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.43, ["Ride"] = 164.07, ["Fly|Ride"] = 390.15, ["Neon"] = 6.45, ["Neon|Ride"] = 45.39, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 45.91, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 4.69, ["Fly"] = 45.94, ["Ride"] = 17.54, ["Fly|Ride"] = 63.32, ["Neon"] = 14.68, ["Neon|Ride"] = 57.75, ["Mega"] = 281.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 311.91}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.24, ["Ride"] = 23.38, ["Neon"] = 45.39, ["Neon|Ride"] = 156.54, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 211.05}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.89, ["Neon|Ride"] = 51.06, ["Mega"] = 15.72, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Ride"] = 19.79, ["Fly|Ride"] = 281350.44, ["Neon"] = 11.82, ["Neon|Fly"] = 30.19, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 66.49, ["Mega"] = 35.44, ["Mega|Fly"] = 94.98, ["Mega|Ride"] = 58.61, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.05, ["Fly"] = 28.25, ["Ride"] = 17.07, ["Fly|Ride"] = 105.52, ["Neon"] = 7.86, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 112.13, ["Mega|Fly|Ride"] = 126.63}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.05, ["Ride"] = 281.72, ["Neon"] = 3.92, ["Neon|Ride"] = 39.74, ["Neon|Fly|Ride"] = 78.28, ["Mega"] = 22.32, ["Mega|Ride"] = 46.74, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Neon|Fly|Ride"] = 121.33, ["Mega"] = 18.38, ["Mega|Fly"] = 105, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 168.84}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 26.36, ["Ride"] = 27.88, ["Neon"] = 5.2, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 21, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 19.69, ["Mega|Ride"] = 205.33}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.34, ["Neon|Ride"] = 78.28, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21.67, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.54, ["Fly|Ride"] = 52.5, ["Neon"] = 3.68, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 35.37, ["Mega|Fly"] = 42, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 141.39}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.5, ["Ride"] = 59.07, ["Neon"] = 91.81, ["Mega"] = 412.79, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 514.95}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.91, ["Fly"] = 42.23, ["Ride"] = 53.83, ["Neon"] = 94.5, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 422.09, ["Mega|Ride"] = 344.54, ["Mega|Fly|Ride"] = 633.12}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.63, ["Ride"] = 42, ["Fly|Ride"] = 352.41, ["Neon"] = 15.84, ["Neon|Ride"] = 281.75, ["Mega"] = 166.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 12.74, ["Fly|Ride"] = 36.94, ["Neon"] = 2.1, ["Neon|Fly"] = 17.53, ["Neon|Ride"] = 16.9, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 15.67, ["Mega|Fly"] = 23.62, ["Mega|Ride"] = 15.84, ["Mega|Fly|Ride"] = 43.31}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 4.24, ["Ride"] = 55.13, ["Fly|Ride"] = 64.32, ["Neon"] = 14.7, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 70.14, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 31.5, ["Neon"] = 2.3, ["Neon|Fly"] = 21.12, ["Neon|Ride"] = 31.67, ["Neon|Fly|Ride"] = 79.04, ["Mega"] = 13.65, ["Mega|Fly"] = 46.74, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 211.05}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Fly"] = 60.9, ["Mega"] = 14.44, ["Mega|Fly|Ride"] = 274.37}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Ride"] = 20.07, ["Fly|Ride"] = 56.99, ["Neon"] = 10.21, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 40.11, ["Neon|Fly|Ride"] = 100.53, ["Mega"] = 179.08, ["Mega|Ride"] = 231.1, ["Mega|Fly|Ride"] = 204.71}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 255.94, ["Ride"] = 265.71, ["Fly|Ride"] = 393.75, ["Neon"] = 1407.47, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1477.28, ["Mega"] = 8441.54, ["Mega|Fly|Ride"] = 4921.88}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 10.5, ["Neon|Ride"] = 69.66, ["Mega"] = 73.88, ["Mega|Ride"] = 175.19, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.47, ["Fly"] = 103.68, ["Ride"] = 24.1, ["Fly|Ride"] = 140.2, ["Neon"] = 53.82, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 577.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 467.21}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 21.19, ["Ride"] = 15.75, ["Fly|Ride"] = 46.44, ["Neon"] = 3.94, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 49.88, ["Mega|Ride"] = 63.09, ["Mega|Fly|Ride"] = 124.52}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Ride"] = 24.92, ["Fly|Ride"] = 122.4, ["Neon"] = 5.24, ["Neon|Fly"] = 42.23, ["Neon|Ride"] = 103.73, ["Mega"] = 94.98, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 7.02, ["Fly"] = 32.82, ["Ride"] = 19.52, ["Fly|Ride"] = 48.51, ["Neon"] = 28.59, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 160.13, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.93, ["Ride"] = 37.91, ["Fly|Ride"] = 246.75, ["Neon"] = 49.88, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 626.8, ["Mega"] = 299.92, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 19.67, ["Ride"] = 18.72, ["Fly|Ride"] = 39.35, ["Neon"] = 23.39, ["Neon|Fly"] = 49.61, ["Neon|Ride"] = 30.61, ["Neon|Fly|Ride"] = 70.71, ["Mega|Fly"] = 384.57, ["Mega|Ride"] = 419.72, ["Mega|Fly|Ride"] = 233600.78}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.57, ["Ride"] = 101.07, ["Fly|Ride"] = 156.54, ["Neon"] = 429.49, ["Neon|Fly"] = 394.42, ["Neon|Ride"] = 316.53, ["Neon|Fly|Ride"] = 399, ["Mega"] = 1125.91, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 210, ["Fly"] = 316.57, ["Ride"] = 168, ["Fly|Ride"] = 281.72, ["Neon|Ride"] = 1125.91, ["Neon|Fly|Ride"] = 1019.82, ["Mega"] = 10551.92, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.43, ["Fly"] = 105, ["Ride"] = 65.63, ["Fly|Ride"] = 107.63, ["Neon"] = 211.03, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1246.27, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.16, ["Ride"] = 278.2, ["Fly|Ride"] = 74.76, ["Neon"] = 32.71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 183.62, ["Mega"] = 246.93, ["Mega|Ride"] = 240.63, ["Mega|Fly|Ride"] = 391.5}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.13, ["Ride"] = 32.54, ["Fly|Ride"] = 53.74, ["Neon"] = 109.8, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 462.19, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 21, ["Fly|Ride"] = 53.83, ["Neon"] = 2.63, ["Neon|Fly"] = 31.67, ["Neon|Ride"] = 21.12, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 36.22, ["Mega|Fly"] = 116.81, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.46, ["Fly"] = 65.63, ["Ride"] = 24.94, ["Fly|Ride"] = 103.69, ["Neon"] = 18.98, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 467.21, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 213.17}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 27.99, ["Ride"] = 16.96, ["Fly|Ride"] = 45.1, ["Neon"] = 11.06, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 131.24, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.66, ["Ride"] = 28.5, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 56.99, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 703.83}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 28.38, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 12.48, ["Mega|Ride"] = 51.72, ["Mega|Fly|Ride"] = 166.69}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.6, ["Fly"] = 56.99, ["Ride"] = 30.39, ["Fly|Ride"] = 56.44, ["Neon"] = 14.32, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.62, ["Mega"] = 78.75, ["Mega|Ride"] = 99.21, ["Mega|Fly|Ride"] = 192.29}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 36.6, ["Ride"] = 23.62, ["Fly|Ride"] = 59.07, ["Neon"] = 62.31, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 112.92, ["Mega"] = 156.19, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 131.25, ["Fly"] = 243.7, ["Ride"] = 154.88, ["Fly|Ride"] = 164.07, ["Neon"] = 556.03, ["Neon|Ride"] = 547.34, ["Neon|Fly|Ride"] = 542.07, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 9.37, ["Ride"] = 240.91, ["Fly|Ride"] = 206.07, ["Neon"] = 53.82, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 414.75, ["Mega|Ride"] = 366.17, ["Mega|Fly|Ride"] = 391.5}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 69.78, ["Ride"] = 32.71, ["Fly|Ride"] = 63.32, ["Neon"] = 35.88, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 93.45, ["Mega"] = 236.25, ["Mega|Ride"] = 281.75, ["Mega|Fly|Ride"] = 218.44}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 14.44, ["Fly"] = 147.75, ["Ride"] = 63.09, ["Fly|Ride"] = 156.33, ["Neon"] = 106.2, ["Neon|Ride"] = 112.92, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 522.33, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 489.56}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.92}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.24, ["Ride"] = 42.23, ["Neon"] = 69.57, ["Neon|Fly|Ride"] = 623.63, ["Mega"] = 281.75, ["Mega|Ride"] = 408.37, ["Mega|Fly|Ride"] = 1266.24}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 33.78, ["Fly"] = 45.94, ["Ride"] = 45.94, ["Fly|Ride"] = 52.49, ["Neon"] = 141.4, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2110.39, ["Mega|Fly|Ride"] = 627.85}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.73, ["Neon|Ride"] = 34.84, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 22.32, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 6.29, ["Fly"] = 34.13, ["Ride"] = 28.5, ["Fly|Ride"] = 112.54, ["Neon"] = 47.92, ["Neon|Ride"] = 233.64, ["Mega"] = 278.59, ["Mega|Fly"] = 390.13, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 3.93, ["Ride"] = 18.23, ["Fly|Ride"] = 45, ["Neon"] = 31.49, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 118.13, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 84.42, ["Mega"] = 28.46, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 139.31}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.48, ["Fly"] = 156.56, ["Ride"] = 32.82, ["Neon"] = 202.13, ["Neon|Ride"] = 282.8, ["Mega"] = 774.38, ["Mega|Ride"] = 759.75, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 4.67, ["Ride"] = 46.44, ["Fly|Ride"] = 209.99, ["Neon"] = 24.94, ["Neon|Ride"] = 79.15, ["Mega"] = 232.45}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 11.63, ["Fly"] = 83.12, ["Ride"] = 56.99, ["Fly|Ride"] = 184.65, ["Neon"] = 52.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 393.1, ["Mega|Ride"] = 320.79, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 65.63, ["Fly"] = 281.75, ["Ride"] = 102.38, ["Fly|Ride"] = 352.41, ["Neon"] = 563.41, ["Neon|Ride"] = 422.09, ["Neon|Fly|Ride"] = 422.09, ["Mega|Ride"] = 1801.23, ["Mega|Fly|Ride"] = 1829.72}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 21.11, ["Ride"] = 34.13, ["Fly|Ride"] = 261.66, ["Neon"] = 84.58, ["Neon|Ride"] = 79.15, ["Neon|Fly|Ride"] = 265.16, ["Mega"] = 400.32, ["Mega|Ride"] = 379.88, ["Mega|Fly|Ride"] = 419.97}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.05, ["Fly"] = 131.25, ["Ride"] = 103.69, ["Fly|Ride"] = 157.5, ["Neon"] = 268.01, ["Neon|Ride"] = 263.05, ["Neon|Fly|Ride"] = 371.48, ["Mega"] = 982.4, ["Mega|Ride"] = 935.25, ["Mega|Fly|Ride"] = 1008.78}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 15.73, ["Ride"] = 70.89, ["Fly|Ride"] = 156.54, ["Neon"] = 85.31, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 209.77, ["Mega"] = 279.85, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10.5, ["Fly"] = 28.5, ["Ride"] = 23.23, ["Fly|Ride"] = 65.63, ["Neon"] = 56.85, ["Neon|Ride"] = 93.35, ["Neon|Fly|Ride"] = 560.68, ["Mega"] = 331.73, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 23.51, ["Fly"] = 111.57, ["Ride"] = 42, ["Fly|Ride"] = 156.54, ["Neon"] = 69.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 188.9, ["Mega"] = 234.94, ["Mega|Ride"] = 366.85, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.54, ["Ride"] = 44.29, ["Neon"] = 43.32, ["Neon|Ride"] = 124.04, ["Mega"] = 366.17, ["Mega|Ride"] = 301.47, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 32.78, ["Mega"] = 15.72, ["Mega|Fly"] = 141.41, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 70.71, ["Neon"] = 13.12, ["Neon|Ride"] = 83.83, ["Mega"] = 120.75, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 6.56, ["Ride"] = 19.69, ["Neon"] = 17.54, ["Neon|Ride"] = 126.62, ["Mega"] = 336, ["Mega|Ride"] = 394.66}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.54, ["Ride"] = 31.42, ["Fly|Ride"] = 116.83, ["Neon"] = 27.57, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 280.69, ["Mega"] = 123.38, ["Mega|Ride"] = 152.97, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 484.3, ["Fly"] = 618.36, ["Ride"] = 544.69, ["Fly|Ride"] = 598.49, ["Neon"] = 1582.61, ["Neon|Ride"] = 1688.32, ["Neon|Fly|Ride"] = 1517.25, ["Mega|Fly|Ride"] = 4593.74}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.61, ["Fly"] = 56.26, ["Ride"] = 24.94, ["Fly|Ride"] = 72.43, ["Neon"] = 37.99, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 125, ["Mega"] = 225.83, ["Mega|Ride"] = 281.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.56, ["Fly"] = 31.5, ["Fly|Ride"] = 84.42, ["Neon"] = 75.98, ["Neon|Fly"] = 315, ["Neon|Ride"] = 156.54, ["Mega"] = 337.67, ["Mega|Ride"] = 323.96, ["Mega|Fly|Ride"] = 358.78}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.63, ["Ride"] = 23.19, ["Fly|Ride"] = 316.53, ["Neon|Ride"] = 61.22, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 42.23, ["Ride"] = 24.93, ["Neon"] = 8.44, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 130.86, ["Mega"] = 65.62, ["Mega|Fly"] = 238.49, ["Mega|Ride"] = 74.8, ["Mega|Fly|Ride"] = 195.64}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 68.86, ["Neon"] = 3.68, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 116.81, ["Mega"] = 19.92, ["Mega|Fly|Ride"] = 185.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 2532.48}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.86, ["Fly"] = 65.63, ["Ride"] = 41.27, ["Fly|Ride"] = 130.85, ["Neon"] = 84, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 137.17, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 500.18, ["Mega|Ride"] = 280.69, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 45.36, ["Neon"] = 7.86, ["Neon|Ride"] = 74.78, ["Mega"] = 39.38, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 42.23, ["Ride"] = 23.23, ["Fly|Ride"] = 525, ["Neon"] = 7.86, ["Neon|Ride"] = 70.09, ["Neon|Fly|Ride"] = 105, ["Mega"] = 82.32, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 134.32}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 401.63, ["Ride"] = 451.58, ["Fly|Ride"] = 452.82, ["Neon|Ride"] = 1401.71, ["Neon|Fly|Ride"] = 1371.77, ["Mega|Fly|Ride"] = 7738.78}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 6.45, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Neon"] = 84, ["Neon|Ride"] = 131.25, ["Mega"] = 458.07, ["Mega|Ride"] = 500.07, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Ride"] = 28.49, ["Neon"] = 4.24, ["Neon|Ride"] = 31.55, ["Neon|Fly|Ride"] = 84.42, ["Mega"] = 38.06, ["Mega|Fly"] = 156.53, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 239.52, ["Neon"] = 3.39, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.93, ["Mega|Ride"] = 83.74, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 8.85, ["Fly"] = 78.79, ["Ride"] = 34.83, ["Fly|Ride"] = 52.77, ["Neon"] = 42.23, ["Neon|Ride"] = 207.38, ["Neon|Fly|Ride"] = 280.69, ["Mega"] = 295.98, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.49, ["Ride"] = 31.55, ["Fly|Ride"] = 131.25, ["Neon"] = 93.44, ["Neon|Fly|Ride"] = 837.38, ["Mega"] = 501.23, ["Mega|Ride"] = 467.21, ["Mega|Fly|Ride"] = 1049.35}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 10.5, ["Fly|Ride"] = 141.4, ["Neon"] = 197.3, ["Neon|Ride"] = 209.99, ["Mega"] = 281.75, ["Mega|Ride"] = 378.25, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 7.86, ["Ride"] = 65.43, ["Fly|Ride"] = 233.63, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 779.13, ["Mega"] = 660.19, ["Mega|Ride"] = 440.55, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 300.57, ["Ride"] = 408.83, ["Fly|Ride"] = 606.3, ["Neon"] = 1769.62, ["Neon|Ride"] = 1160.73, ["Neon|Fly|Ride"] = 1170.75, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.73, ["Ride"] = 44.63, ["Fly|Ride"] = 82.69, ["Neon"] = 43.31, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 529.78, ["Mega|Ride"] = 500.18, ["Mega|Fly|Ride"] = 700.66}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 5.23, ["Ride"] = 41.68, ["Neon"] = 28.32, ["Mega"] = 1266.24, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 6.55, ["Ride"] = 60.38, ["Fly|Ride"] = 162.75, ["Neon"] = 28.87, ["Neon|Ride"] = 65.63, ["Mega"] = 160.12, ["Mega|Ride"] = 202.12, ["Mega|Fly|Ride"] = 309.27}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Fly|Ride"] = 99.2, ["Neon"] = 5.92, ["Neon|Ride"] = 65.63, ["Mega"] = 39.37, ["Mega|Ride"] = 91.11, ["Mega|Fly|Ride"] = 218.44}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 28.34, ["Ride"] = 59.07, ["Neon"] = 210, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 913.81, ["Mega|Ride"] = 937.02, ["Mega|Fly|Ride"] = 1055.21}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 584.15, ["Ride"] = 21, ["Fly|Ride"] = 91.81, ["Neon"] = 10.48, ["Neon|Fly"] = 183.6, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 105.53, ["Mega"] = 65.63, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 255.19}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 31.55, ["Fly|Ride"] = 148.32, ["Neon"] = 5.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 39.35, ["Mega|Ride"] = 88.86, ["Mega|Fly|Ride"] = 261.7}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 52.5, ["Fly|Ride"] = 262.5, ["Neon"] = 10.5, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 96.04, ["Mega|Ride"] = 124.52, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 60.15, ["Ride"] = 94.5, ["Fly|Ride"] = 156.54, ["Neon"] = 483, ["Neon|Ride"] = 465.35, ["Neon|Fly|Ride"] = 672.67, ["Mega|Fly|Ride"] = 901.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 236.38, ["Ride"] = 262.5, ["Fly|Ride"] = 437.87, ["Neon|Ride"] = 1099.88, ["Neon|Fly|Ride"] = 1558.24, ["Mega"] = 7034.97, ["Mega|Fly|Ride"] = 5275.96}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.34, ["Neon"] = 15.74, ["Mega"] = 91.82, ["Mega|Ride"] = 195.64, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 5.92, ["Neon"] = 26.24, ["Neon|Ride"] = 59.11, ["Mega"] = 119.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 4.25, ["Fly"] = 155.57, ["Neon"] = 37.41, ["Neon|Ride"] = 63.09, ["Mega"] = 484.98}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 53.23, ["Ride"] = 30.19, ["Fly|Ride"] = 42, ["Neon"] = 3.94, ["Neon|Ride"] = 25.7, ["Neon|Fly|Ride"] = 182.62, ["Mega"] = 48.55, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 139.31}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.33, ["Mega"] = 33.06, ["Mega|Ride"] = 206.07}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.84, ["Fly|Ride"] = 46.74, ["Neon"] = 3.94, ["Neon|Ride"] = 19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 43.24, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 60.38, ["Neon"] = 24.28, ["Neon|Fly"] = 46.73, ["Neon|Ride"] = 39.74, ["Neon|Fly|Ride"] = 86.45, ["Mega"] = 170.63, ["Mega|Ride"] = 194.17, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.82, ["Fly"] = 100.49, ["Ride"] = 28.3, ["Fly|Ride"] = 137.17, ["Neon"] = 114.19, ["Neon|Ride"] = 141.41, ["Mega"] = 367.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 80.07, ["Fly"] = 582.75, ["Ride"] = 99.75, ["Fly|Ride"] = 156.16, ["Neon"] = 475.85, ["Neon|Ride"] = 391.13, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 3115.08, ["Mega|Ride"] = 1546.93, ["Mega|Fly|Ride"] = 1463.56}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 131.25, ["Neon"] = 4.23, ["Neon|Ride"] = 70.71, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 77.11, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 109.8}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 24.28, ["Ride"] = 18.96, ["Fly|Ride"] = 46.59, ["Neon"] = 3.94, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.07, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Neon"] = 112.91, ["Neon|Ride"] = 422.09, ["Neon|Fly|Ride"] = 280.69, ["Mega"] = 611, ["Mega|Ride"] = 623.74, ["Mega|Fly|Ride"] = 626.73}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 251.73, ["Fly"] = 348.23, ["Ride"] = 554.96, ["Fly|Ride"] = 337.64, ["Neon|Ride"] = 1477.28, ["Neon|Fly|Ride"] = 985.56, ["Mega"] = 6858.75, ["Mega|Fly|Ride"] = 5295.74}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 28.35, ["Fly"] = 209.9, ["Ride"] = 68.57, ["Fly|Ride"] = 112.91, ["Neon"] = 278.25, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 183.62, ["Mega|Ride"] = 788.24, ["Mega|Fly|Ride"] = 738.65}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.23, ["Neon"] = 10.48, ["Neon|Ride"] = 40.89, ["Mega"] = 112.88, ["Mega|Ride"] = 134.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.63, ["Fly"] = 211.05, ["Ride"] = 84.42, ["Fly|Ride"] = 142.7, ["Neon"] = 24.28, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 63.33, ["Mega"] = 211.32, ["Mega|Ride"] = 436.85}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 28.3, ["Fly"] = 31.56, ["Ride"] = 39.38, ["Fly|Ride"] = 78.08, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 2532.48, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 738.65}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.92, ["Ride"] = 141.39, ["Fly|Ride"] = 141.4, ["Neon"] = 345.19, ["Neon|Ride"] = 469.88, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 3095.94, ["Mega|Fly"] = 2108.29, ["Mega|Fly|Ride"] = 2181.1}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 194.25, ["Fly"] = 502.28, ["Ride"] = 275.63, ["Fly|Ride"] = 262.49, ["Neon"] = 775.69, ["Neon|Ride"] = 985.56, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3024}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 15.83, ["Ride"] = 78.1, ["Fly|Ride"] = 262.5, ["Neon"] = 112.88, ["Neon|Ride"] = 105.53, ["Neon|Fly|Ride"] = 779.13, ["Mega"] = 487.68, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 32.82, ["Neon"] = 8.8, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 65.63, ["Mega|Ride"] = 84.42, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.25, ["Ride"] = 20.07, ["Fly|Ride"] = 53.82, ["Neon"] = 30.15, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 126.65, ["Mega"] = 250.79, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 310.15}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 337.67, ["Ride"] = 328.13, ["Fly|Ride"] = 485.34, ["Neon|Ride"] = 1547.98, ["Mega|Fly|Ride"] = 7008.04}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 46.44, ["Neon"] = 11.29, ["Neon|Ride"] = 233.64, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.88, ["Mega|Ride"] = 158.29, ["Mega|Fly|Ride"] = 289.68}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.75, ["Fly"] = 52.5, ["Ride"] = 17.07, ["Fly|Ride"] = 78.28, ["Neon"] = 30.38, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 350.41, ["Mega|Ride"] = 281.75, ["Mega|Fly|Ride"] = 206.83}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.74, ["Ride"] = 39.73, ["Neon"] = 103.62, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 540.21, ["Mega"] = 422.09, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 514.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 105, ["Fly"] = 280.69, ["Ride"] = 62.99, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 422.09, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 1540.6}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 13.11, ["Fly"] = 78.29, ["Ride"] = 24.86, ["Fly|Ride"] = 62.27, ["Neon"] = 85.32, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 125.95, ["Mega"] = 703.83, ["Mega|Ride"] = 344.58, ["Mega|Fly|Ride"] = 482.95}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 42.23, ["Fly|Ride"] = 104.47, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 36.94, ["Mega|Ride"] = 56.99, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 84.42, ["Neon"] = 2.63, ["Neon|Fly"] = 31.55, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 69.18, ["Mega"] = 17.53, ["Mega|Fly"] = 86.44, ["Mega|Ride"] = 61.22, ["Mega|Fly|Ride"] = 111.51}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 7.27, ["Fly"] = 105.53, ["Ride"] = 56.09, ["Fly|Ride"] = 157.5, ["Neon"] = 26.25, ["Neon|Fly"] = 265.14, ["Neon|Ride"] = 56.99, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 142.51, ["Mega|Ride"] = 168.84, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1239.32, ["Ride"] = 1389.94, ["Fly|Ride"] = 1417.49, ["Neon"] = 5275.32, ["Neon|Fly|Ride"] = 4053, ["Mega|Fly|Ride"] = 13335}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 459.38, ["Ride"] = 607.41, ["Fly|Ride"] = 626.1, ["Neon|Ride"] = 2181.1, ["Neon|Fly|Ride"] = 2110.39, ["Mega"] = 14016.07, ["Mega|Fly|Ride"] = 6329.05}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.88, ["Fly"] = 394.66, ["Ride"] = 315, ["Fly|Ride"] = 367.5, ["Neon"] = 656.25, ["Neon|Fly"] = 844.07, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 838.69, ["Mega|Fly|Ride"] = 2363.64}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 281.75, ["Fly"] = 419.69, ["Ride"] = 326.76, ["Fly|Ride"] = 427.9, ["Neon"] = 844.06, ["Neon|Ride"] = 882.16, ["Neon|Fly|Ride"] = 813.75, ["Mega|Ride"] = 3675, ["Mega|Fly|Ride"] = 2954.55}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 80.21, ["Ride"] = 21, ["Fly|Ride"] = 37.99, ["Neon"] = 8.46, ["Neon|Ride"] = 65.43, ["Neon|Fly|Ride"] = 73.61, ["Mega"] = 63.31, ["Mega|Ride"] = 87.61, ["Mega|Fly|Ride"] = 141.41}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 262.49, ["Ride"] = 326.82, ["Fly|Ride"] = 500.07, ["Neon"] = 1202.79, ["Neon|Ride"] = 1040.43, ["Neon|Fly|Ride"] = 1049.99, ["Mega"] = 3519.08, ["Mega|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 3281.24}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 40.11, ["Neon"] = 3.93, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 98.44, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 20.07, ["Ride"] = 31.49, ["Fly|Ride"] = 49.88, ["Neon"] = 7.86, ["Neon|Ride"] = 63.09, ["Neon|Fly|Ride"] = 126.65, ["Mega"] = 125.57, ["Mega|Ride"] = 132.97, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.82, ["Mega"] = 21.87, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 56.95, ["Ride"] = 70.71, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 420, ["Mega"] = 2110.39, ["Mega|Ride"] = 934.42, ["Mega|Fly|Ride"] = 972.57}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.61, ["Fly"] = 65.61, ["Ride"] = 18.9, ["Neon"] = 28.49, ["Mega"] = 328.13, ["Mega|Ride"] = 318.68}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 3.86, ["Neon|Fly"] = 45.39, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 24.94, ["Mega|Fly"] = 101.63, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 20.07, ["Ride"] = 21.11, ["Fly|Ride"] = 65.42, ["Neon"] = 8.56, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 22.77, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 66.33, ["Mega|Fly"] = 198.57, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 8.28, ["Fly"] = 46.1, ["Ride"] = 32.49, ["Fly|Ride"] = 55.26, ["Neon"] = 54.88, ["Neon|Ride"] = 253.25, ["Neon|Fly|Ride"] = 253.25, ["Mega"] = 237.56, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 13.78, ["Ride"] = 27.57, ["Mega"] = 467.21, ["Mega|Ride"] = 337.67, ["Mega|Fly|Ride"] = 522.34}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.5, ["Ride"] = 19, ["Fly|Ride"] = 87.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 700.87, ["Mega"] = 225.83, ["Mega|Ride"] = 492.79}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.54, ["Fly|Ride"] = 66.48, ["Neon"] = 3.94, ["Neon|Ride"] = 25.34, ["Neon|Fly|Ride"] = 168.84, ["Mega"] = 39.38, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 130.92, ["Ride"] = 194.25, ["Fly|Ride"] = 257.25, ["Neon"] = 858.83, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 896.93, ["Neon|Fly|Ride"] = 844.17, ["Mega"] = 8441.54, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 15.84, ["Fly|Ride"] = 32.82, ["Neon"] = 3.67, ["Neon|Fly"] = 105.52, ["Neon|Ride"] = 26.14, ["Neon|Fly|Ride"] = 69.66, ["Mega"] = 36.22, ["Mega|Ride"] = 71.85, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.35, ["Ride"] = 69.57, ["Fly|Ride"] = 94.5, ["Neon"] = 77.56, ["Neon|Ride"] = 148.36, ["Neon|Fly|Ride"] = 321.24, ["Mega"] = 315, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 446.36}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 27.41, ["Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 310.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 633.12, ["Mega|Ride"] = 737.6, ["Mega|Fly|Ride"] = 837.83}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 159.6, ["Fly"] = 252.2, ["Ride"] = 223.13, ["Fly|Ride"] = 298.6, ["Neon"] = 826.13, ["Neon|Ride"] = 738.65, ["Neon|Fly|Ride"] = 833.58, ["Mega|Fly|Ride"] = 3264.78}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.84, ["Neon"] = 95.79, ["Mega"] = 328.13, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 703.83}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 26.25, ["Ride"] = 56.99, ["Fly|Ride"] = 632, ["Neon"] = 165.3, ["Neon|Ride"] = 633.12, ["Neon|Fly|Ride"] = 844.17, ["Mega"] = 625.44, ["Mega|Ride"] = 632.07, ["Mega|Fly|Ride"] = 633.12}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1147.82, ["Fly"] = 1441.13, ["Ride"] = 1028.99, ["Fly|Ride"] = 1264.38, ["Neon|Ride"] = 6331.16, ["Neon|Fly|Ride"] = 4407.89, ["Mega|Fly|Ride"] = 14069.93}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.85, ["Fly"] = 43.32, ["Ride"] = 21, ["Fly|Ride"] = 62.03, ["Neon"] = 49.19, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 78.28, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 209.35, ["Mega|Fly"] = 563.49, ["Mega|Ride"] = 267.75, ["Mega|Fly|Ride"] = 382.6}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 7.86, ["Fly"] = 13928.54, ["Ride"] = 39.38, ["Neon"] = 38.06, ["Neon|Ride"] = 166.74, ["Neon|Fly|Ride"] = 144.74, ["Mega"] = 212.63, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 3.75, ["Ride"] = 26.24, ["Fly|Ride"] = 91.81, ["Neon"] = 16.8, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 311.9, ["Mega"] = 131.25, ["Mega|Ride"] = 225.83, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.54, ["Fly"] = 40.69, ["Ride"] = 38.85, ["Fly|Ride"] = 90.76, ["Neon"] = 69.37, ["Neon|Ride"] = 119.24, ["Neon|Fly|Ride"] = 200.87, ["Mega"] = 341.25, ["Mega|Ride"] = 331.67, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.47, ["Fly"] = 20.07, ["Ride"] = 28.5, ["Fly|Ride"] = 64.32, ["Neon"] = 20.07, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 70.1, ["Mega"] = 280.69, ["Mega|Ride"] = 196.28, ["Mega|Fly|Ride"] = 216.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 3.75, ["Ride"] = 22.32, ["Neon"] = 7.86, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 111.54, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 225.8}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 131.25, ["Ride"] = 451.64, ["Fly|Ride"] = 479.01, ["Neon"] = 774.43, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1401.71, ["Mega|Fly|Ride"] = 3367.13}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.92, ["Ride"] = 28.5, ["Neon"] = 8.86, ["Neon|Fly"] = 78.27, ["Neon|Ride"] = 42.23, ["Neon|Fly|Ride"] = 123.47, ["Mega"] = 105, ["Mega|Ride"] = 130.86, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.93, ["Fly"] = 408.19, ["Neon"] = 77.42, ["Mega"] = 238.88, ["Mega|Ride"] = 236.31}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.75, ["Fly"] = 81.74, ["Ride"] = 40.69, ["Neon"] = 15.69, ["Neon|Ride"] = 28.5, ["Mega"] = 104.32, ["Mega|Ride"] = 177.85, ["Mega|Fly|Ride"] = 406.48}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 108.94, ["Fly"] = 262.5, ["Ride"] = 183.62, ["Fly|Ride"] = 418.04, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 619.41, ["Mega"] = 1971.11, ["Mega|Ride"] = 1772.74, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 24.9, ["Fly"] = 59.11, ["Ride"] = 84, ["Fly|Ride"] = 109.75, ["Neon"] = 121.35, ["Neon|Fly"] = 233.6, ["Neon|Fly|Ride"] = 263.82, ["Mega"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 591.42}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.69, ["Ride"] = 38.07, ["Neon"] = 110.96, ["Neon|Ride"] = 168.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 675.25, ["Mega|Ride"] = 420.87, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.56, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.49, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 76.06, ["Fly"] = 105, ["Ride"] = 97.13, ["Fly|Ride"] = 185.77, ["Neon"] = 492.73, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 904.32}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.08, ["Neon"] = 7.07, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 588, ["Mega"] = 61.22}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 13.12, ["Fly"] = 140.38, ["Ride"] = 45.94, ["Fly|Ride"] = 109.8, ["Neon"] = 82.31, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 120.31, ["Mega"] = 262.5, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 52.5, ["Ride"] = 78.73, ["Fly|Ride"] = 156.54, ["Neon"] = 295.43, ["Neon|Ride"] = 242.7, ["Neon|Fly|Ride"] = 320.25, ["Mega"] = 1125.91, ["Mega|Ride"] = 1221.93, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.25, ["Ride"] = 15.74, ["Fly|Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Fly"] = 27.72, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 21.05, ["Mega|Fly"] = 70.09, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 103.67}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.87, ["Ride"] = 31.48, ["Fly|Ride"] = 98.65, ["Neon"] = 14.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 202.79, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 504.67}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 12.46, ["Ride"] = 58.43, ["Fly|Ride"] = 124.51, ["Neon"] = 131.25, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 623.77, ["Mega"] = 700.82, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 23.09, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 126.65, ["Mega"] = 16.79, ["Mega|Ride"] = 125.57, ["Mega|Fly|Ride"] = 390.48}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 5.25, ["Fly"] = 210, ["Ride"] = 28.5, ["Fly|Ride"] = 98.44, ["Neon"] = 40.69, ["Neon|Ride"] = 91.33, ["Neon|Fly|Ride"] = 183.62, ["Mega"] = 523.95, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 413.6}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 27.45, ["Fly"] = 42.23, ["Ride"] = 28.88, ["Fly|Ride"] = 46.74, ["Neon"] = 112.22, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 466.55}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.68, ["Ride"] = 42.2, ["Neon"] = 28.87, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 200.82, ["Mega"] = 150.94, ["Mega|Ride"] = 247.98, ["Mega|Fly|Ride"] = 289.13}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 14.31, ["Fly"] = 2110.39, ["Ride"] = 52.5, ["Fly|Ride"] = 132.57, ["Neon"] = 118.13, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 6229.38, ["Mega"] = 378, ["Mega|Ride"] = 526.55, ["Mega|Fly|Ride"] = 661.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 24.28, ["Fly|Ride"] = 126.48, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Mega"] = 84.42, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 408.19, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Neon"] = 3.92, ["Neon|Ride"] = 42.23, ["Mega"] = 26.25, ["Mega|Ride"] = 126.65}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 31.48}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 32.38, ["Fly"] = 78.1, ["Ride"] = 70.71, ["Fly|Ride"] = 141.4, ["Neon"] = 1050, ["Neon|Ride"] = 281.75, ["Neon|Fly|Ride"] = 527.62, ["Mega|Ride"] = 983.46, ["Mega|Fly|Ride"] = 795.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 140.62, ["Neon"] = 2.1, ["Mega"] = 17.03, ["Mega|Ride"] = 78.07, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 661.62, ["Ride"] = 700.86, ["Fly|Ride"] = 647.82, ["Neon"] = 4220.27, ["Neon|Ride"] = 2616.89, ["Neon|Fly|Ride"] = 2673.87, ["Mega"] = 16883.07, ["Mega|Fly|Ride"] = 5628.4}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.6, ["Fly"] = 49.88, ["Ride"] = 40.69, ["Fly|Ride"] = 56.99, ["Neon"] = 30.19, ["Neon|Ride"] = 104.48, ["Neon|Fly|Ride"] = 563.49, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.29, ["Ride"] = 20.98, ["Fly|Ride"] = 40.89, ["Neon"] = 99.2, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 141.41, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 259.6}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.82, ["Ride"] = 76.13, ["Fly|Ride"] = 106.32, ["Neon"] = 211.03, ["Neon|Ride"] = 141.41, ["Mega"] = 1042.54, ["Mega|Ride"] = 464.3, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.54, ["Fly"] = 49.62, ["Ride"] = 31.5, ["Fly|Ride"] = 393.75, ["Neon"] = 140.59, ["Mega"] = 293.36, ["Mega|Ride"] = 386.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.57, ["Ride"] = 56.99, ["Fly|Ride"] = 157.5, ["Neon"] = 39.38, ["Neon|Fly"] = 189.93, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 414.58, ["Mega|Ride"] = 437.92, ["Mega|Fly|Ride"] = 626.73}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.92, ["Fly"] = 105, ["Ride"] = 28.5, ["Fly|Ride"] = 65.63, ["Neon"] = 24.92, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 170.63, ["Mega|Fly"] = 487.51, ["Mega|Ride"] = 274.37, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Ride"] = 19, ["Fly|Ride"] = 75.98, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.88, ["Neon|Fly|Ride"] = 60.1, ["Mega"] = 15.67, ["Mega|Fly"] = 78.27, ["Mega|Ride"] = 36.6, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.3, ["Ride"] = 32.82, ["Fly|Ride"] = 56.99, ["Neon"] = 54.92, ["Neon|Fly"] = 390.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 132.56, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 236.25, ["Ride"] = 248.07, ["Fly|Ride"] = 278.25, ["Neon"] = 1480.5, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 5623.95, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 90.54, ["Ride"] = 166.69, ["Fly|Ride"] = 249.38, ["Neon"] = 390.1, ["Neon|Ride"] = 422.09, ["Neon|Fly|Ride"] = 633.12, ["Mega"] = 4220.77, ["Mega|Ride"] = 1983.78, ["Mega|Fly|Ride"] = 1683.89}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 40.91, ["Ride"] = 24.94, ["Fly|Ride"] = 39.37, ["Neon"] = 12.68, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 53.45, ["Mega"] = 78.27, ["Mega|Fly"] = 209.99, ["Mega|Ride"] = 91.82, ["Mega|Fly|Ride"] = 32.82}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 16.79, ["Ride"] = 15.84, ["Fly|Ride"] = 35.89, ["Neon"] = 7.87, ["Neon|Fly"] = 28.49, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 131.78, ["Mega|Ride"] = 101.14, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 18.96, ["Fly|Ride"] = 98.44, ["Neon"] = 13.13, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 131.25}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 235.76, ["Ride"] = 275.63, ["Fly|Ride"] = 393.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1055.21, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 8441.54, ["Mega|Fly|Ride"] = 4733.6}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.99, ["Ride"] = 15.74, ["Fly|Ride"] = 32.81, ["Neon"] = 13.7, ["Neon|Fly"] = 156.52, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 67.76, ["Mega"] = 268.04, ["Mega|Ride"] = 192.06, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.89, ["Ride"] = 39.37, ["Fly|Ride"] = 211.03, ["Neon"] = 21.12, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 225.83, ["Mega"] = 141.39, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 349.96}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.24, ["Neon|Ride"] = 21, ["Mega"] = 28.88, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.96, ["Fly"] = 56, ["Ride"] = 19.69, ["Fly|Ride"] = 60.78, ["Neon"] = 93.44, ["Neon|Ride"] = 89.64, ["Neon|Fly|Ride"] = 231, ["Mega"] = 578.18, ["Mega|Ride"] = 408.37, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 41.99, ["Ride"] = 68.86, ["Fly|Ride"] = 209.97, ["Neon"] = 155.66, ["Neon|Fly"] = 311.85, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 476.44, ["Mega|Fly"] = 590.92, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 559.65}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.32, ["Fly"] = 65.63, ["Ride"] = 41.91, ["Fly|Ride"] = 92.87, ["Neon"] = 380.63, ["Neon|Ride"] = 253.25, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 783.12, ["Mega|Fly|Ride"] = 700.66}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 71.53, ["Fly|Ride"] = 42.23, ["Neon"] = 2.1, ["Neon|Fly"] = 42.23, ["Neon|Ride"] = 20.06, ["Neon|Fly|Ride"] = 56.99, ["Mega"] = 18.92, ["Mega|Fly"] = 48.55, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 109.8}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 186.98, ["Fly"] = 236.25, ["Ride"] = 209.4, ["Fly|Ride"] = 263.82, ["Neon"] = 934.36, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1052.04, ["Mega|Fly|Ride"] = 3412.5}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.17, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 112.91, ["Neon"] = 118.12, ["Neon|Ride"] = 121.36, ["Neon|Fly|Ride"] = 210, ["Mega"] = 548.71, ["Mega|Ride"] = 451.64, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 59.07, ["Neon"] = 9.35, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 61.68, ["Mega|Fly"] = 111.57, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 265.86}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 141.41, ["Ride"] = 17.07, ["Neon"] = 3.93, ["Neon|Fly"] = 31.55, ["Neon|Ride"] = 20.19, ["Neon|Fly|Ride"] = 120.31, ["Mega"] = 17.53, ["Mega|Fly"] = 138.25, ["Mega|Ride"] = 45.39, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19, ["Fly|Ride"] = 56.99, ["Neon"] = 10.5, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 156.19, ["Mega"] = 119.1, ["Mega|Ride"] = 116.76, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 10.59, ["Fly"] = 32.28, ["Ride"] = 19.69, ["Fly|Ride"] = 67.02, ["Neon"] = 45.93, ["Neon|Ride"] = 69.96, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 462.19, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 416.81}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 78.75, ["Neon"] = 101.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 168.84, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 398.88}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.05, ["Ride"] = 52.41, ["Fly|Ride"] = 49.61, ["Neon"] = 3.91, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.22, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 11.8, ["Ride"] = 28.5, ["Fly|Ride"] = 94.97, ["Neon"] = 27.57, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 69.66, ["Neon|Fly|Ride"] = 119.69, ["Mega"] = 130.86, ["Mega|Ride"] = 219.5, ["Mega|Fly|Ride"] = 350.41}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 210, ["Neon"] = 7.87, ["Neon|Ride"] = 91.88, ["Mega"] = 31.49, ["Mega|Ride"] = 56.99, ["Mega|Fly|Ride"] = 623.74}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.05, ["Ride"] = 24.28, ["Fly|Ride"] = 118.13, ["Neon"] = 6.56, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 117.12, ["Mega"] = 56.44, ["Mega|Ride"] = 88.86, ["Mega|Fly|Ride"] = 195.8}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 1154.25, ["Ride"] = 1038.19, ["Fly|Ride"] = 1266.08, ["Neon"] = 4361.64, ["Neon|Fly|Ride"] = 4579.54, ["Mega|Fly|Ride"] = 13705.37}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.54, ["Ride"] = 15.64, ["Fly|Ride"] = 42.23, ["Neon"] = 17.49, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 105.53, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 6.97, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 140.52, ["Mega"] = 53.38, ["Mega|Ride"] = 98.43, ["Mega|Fly|Ride"] = 198.18}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.56, ["Fly"] = 32.82, ["Ride"] = 23.19, ["Fly|Ride"] = 39.38, ["Neon"] = 35.44, ["Neon|Ride"] = 39.32, ["Neon|Fly|Ride"] = 81.78, ["Mega|Ride"] = 277.93, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 41.18, ["Ride"] = 16.84, ["Fly|Ride"] = 40.69, ["Neon"] = 7.77, ["Neon|Fly"] = 89.24, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 70.88, ["Mega|Ride"] = 100.26, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 39.38, ["Ride"] = 141.41, ["Fly|Ride"] = 156.54, ["Neon"] = 301.88, ["Neon|Ride"] = 338.63, ["Mega"] = 769.13, ["Mega|Ride"] = 985.56, ["Mega|Fly|Ride"] = 1055.21}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 7.67, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 109.82, ["Mega"] = 79.41, ["Mega|Ride"] = 68.19, ["Mega|Fly|Ride"] = 280.08}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 31.35, ["Fly|Ride"] = 65.63, ["Neon"] = 10.48, ["Neon|Fly"] = 147.72, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 131.25, ["Mega|Ride"] = 294.41, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 65.63, ["Neon"] = 20.07, ["Neon|Fly"] = 63.09, ["Mega"] = 255.29, ["Mega|Ride"] = 156.53}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2593.49, ["Ride"] = 20.06, ["Fly|Ride"] = 42.23, ["Neon"] = 3.81, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 32.82, ["Mega|Fly"] = 108.94, ["Mega|Ride"] = 62.63, ["Mega|Fly|Ride"] = 108.67}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 20.73, ["Fly"] = 39.37, ["Ride"] = 26.25, ["Fly|Ride"] = 43.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 844.17, ["Mega|Ride"] = 344.58, ["Mega|Fly|Ride"] = 453.66}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 682.49, ["Ride"] = 717.94, ["Fly|Ride"] = 871.5, ["Neon"] = 2015.99, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2084.25, ["Mega"] = 5139.24, ["Mega|Ride"] = 7738.78, ["Mega|Fly|Ride"] = 4987.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 42.23, ["Neon"] = 6.35, ["Neon|Fly"] = 28.5, ["Neon|Ride"] = 16.88, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 34.13, ["Mega|Ride"] = 70.2, ["Mega|Fly|Ride"] = 120.31}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.4, ["Ride"] = 38.66, ["Fly|Ride"] = 116.82, ["Neon"] = 54.55, ["Neon|Ride"] = 125.55, ["Neon|Fly|Ride"] = 337.67, ["Mega"] = 275.63, ["Mega|Ride"] = 268.66, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 82.79, ["Fly"] = 144.38, ["Ride"] = 96.39, ["Fly|Ride"] = 125.87, ["Neon"] = 506.45, ["Neon|Ride"] = 534.99, ["Neon|Fly|Ride"] = 527.62, ["Mega"] = 2959.73, ["Mega|Fly|Ride"] = 3033.19}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 35.4, ["Ride"] = 57.02, ["Fly|Ride"] = 301.88, ["Neon"] = 280.26, ["Neon|Ride"] = 105.53, ["Mega"] = 788.24, ["Mega|Ride"] = 681.66, ["Mega|Fly|Ride"] = 657.4}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 13.13, ["Ride"] = 36.75, ["Fly|Ride"] = 211.03, ["Neon"] = 113.96, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 226.63, ["Mega"] = 300.57, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 491.46}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.99, ["Ride"] = 112.35, ["Neon"] = 89.25, ["Neon|Ride"] = 358.61, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 263.82, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 379.88}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 25.2, ["Ride"] = 315, ["Neon"] = 242.68, ["Neon|Ride"] = 316.57, ["Neon|Fly|Ride"] = 525, ["Mega"] = 719.92, ["Mega|Ride"] = 737.6, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.49}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.35, ["Ride"] = 31.55, ["Neon"] = 54.92, ["Neon|Ride"] = 70.71, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 245.74, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 337.67}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.63, ["Neon"] = 23.23, ["Mega"] = 367.5, ["Mega|Fly|Ride"] = 949.69}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 62.99, ["Fly"] = 420.46, ["Ride"] = 60.77, ["Fly|Ride"] = 105, ["Neon"] = 276.44, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 208.22, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 704.66, ["Mega|Ride"] = 757.64, ["Mega|Fly|Ride"] = 694.31}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 4.55, ["Fly"] = 18.47, ["Ride"] = 18.36, ["Fly|Ride"] = 41.9, ["Neon"] = 23.38, ["Neon|Fly"] = 41.92, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 209.99, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 263.99}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.13, ["Ride"] = 25.34, ["Fly|Ride"] = 84.42, ["Neon"] = 25.07, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 58.26, ["Neon|Fly|Ride"] = 265.75, ["Mega"] = 138.25, ["Mega|Fly"] = 301.45, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.62, ["Mega"] = 41.15}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 33.23, ["Fly"] = 84.42, ["Ride"] = 59.11, ["Fly|Ride"] = 105.52, ["Neon"] = 211.03, ["Neon|Ride"] = 105.53, ["Mega"] = 1090.92, ["Mega|Ride"] = 816.74, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 9.36, ["Neon|Fly"] = 145.69, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 120.75, ["Mega|Ride"] = 208.11}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.91, ["Ride"] = 140.63, ["Neon"] = 65.58, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 295.47, ["Mega"] = 280.33, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 542.38}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 15.84, ["Fly|Ride"] = 61.69, ["Neon"] = 27.44, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 168.84, ["Mega|Fly|Ride"] = 314.35}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.66, ["Fly"] = 52.5, ["Ride"] = 24.13, ["Fly|Ride"] = 49.88, ["Neon"] = 157.5, ["Neon|Ride"] = 126.65, ["Mega"] = 209.99, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.61, ["Ride"] = 129.31, ["Fly|Ride"] = 78.28, ["Neon"] = 18.38, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 465.35}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.4, ["Fly"] = 118.13, ["Ride"] = 99.21, ["Neon"] = 164.07, ["Neon|Ride"] = 211.05, ["Neon|Fly|Ride"] = 419.97, ["Mega"] = 1090.92, ["Mega|Ride"] = 1266.24, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.19, ["Ride"] = 246.93, ["Neon"] = 116.82, ["Neon|Fly|Ride"] = 390.15, ["Mega"] = 337.62, ["Mega|Ride"] = 769.12, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 6.57, ["Ride"] = 105, ["Neon"] = 91.61, ["Neon|Ride"] = 56.99, ["Mega"] = 156.53, ["Mega|Ride"] = 280.69, ["Mega|Fly|Ride"] = 1688.32}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.73, ["Ride"] = 105, ["Fly|Ride"] = 524.48, ["Neon"] = 59.06, ["Mega"] = 525, ["Mega|Ride"] = 703.74, ["Mega|Fly|Ride"] = 671.35}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 11.7, ["Neon"] = 31.55, ["Mega"] = 844.17, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.23, ["Fly|Ride"] = 52.5, ["Neon"] = 6.45, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 43.97, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 187.84}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 9.01, ["Ride"] = 46.76, ["Fly|Ride"] = 105.52, ["Neon"] = 23.63, ["Neon|Ride"] = 71.6, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 188.32, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 449.53}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.69, ["Ride"] = 21, ["Fly|Ride"] = 55.13, ["Neon"] = 6.3, ["Neon|Fly"] = 32.72, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 69.66, ["Mega"] = 44.45, ["Mega|Ride"] = 92.88, ["Mega|Fly|Ride"] = 140.18}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.49, ["Ride"] = 27.45, ["Neon"] = 13.13, ["Neon|Ride"] = 93.45, ["Neon|Fly|Ride"] = 261.7, ["Mega"] = 249.38, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.92, ["Ride"] = 27.57, ["Fly|Ride"] = 84.42, ["Neon"] = 329.2, ["Neon|Ride"] = 134.03, ["Mega"] = 422.09, ["Mega|Fly|Ride"] = 983.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.93, ["Fly"] = 30.85, ["Ride"] = 18.36, ["Fly|Ride"] = 28.5, ["Neon"] = 23.23, ["Neon|Fly"] = 91.81, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 102.24, ["Mega"] = 281.75, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 316.57}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.92, ["Fly"] = 34.07, ["Ride"] = 17.54, ["Fly|Ride"] = 60.16, ["Neon"] = 23.38, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 147.19, ["Mega"] = 166.62, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 492.79}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.93, ["Ride"] = 70.71, ["Neon"] = 15.73, ["Neon|Fly"] = 61.2, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 135.08, ["Mega"] = 73.74, ["Mega|Ride"] = 156.74, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 7.87, ["Ride"] = 76.13, ["Fly|Ride"] = 281.72, ["Neon"] = 49.62, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 442.72, ["Mega"] = 286.13, ["Mega|Fly"] = 656.25, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Fly"] = 198.62, ["Ride"] = 74.97, ["Fly|Ride"] = 291.38, ["Neon"] = 283.5, ["Neon|Ride"] = 278.24, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2532.48, ["Mega|Ride"] = 997.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 19.92, ["Neon"] = 2.1, ["Neon|Ride"] = 20.06, ["Mega"] = 31.55, ["Mega|Ride"] = 62.99, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 9.34, ["Ride"] = 131.25, ["Neon"] = 54.55, ["Mega"] = 312.38, ["Mega|Ride"] = 408.37, ["Mega|Fly|Ride"] = 844.17}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 31.67, ["Ride"] = 115.5, ["Neon"] = 779.03, ["Neon|Ride"] = 1125.91, ["Mega|Ride"] = 1097.41, ["Mega|Fly|Ride"] = 1253.59}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.45, ["Fly"] = 190.32, ["Ride"] = 51.19, ["Fly|Ride"] = 105, ["Neon"] = 35.05, ["Neon|Ride"] = 99.52, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 156.19, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 26.25, ["Fly|Ride"] = 137.82, ["Neon"] = 3.54, ["Neon|Ride"] = 26.17, ["Mega"] = 23.63, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.65}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 22.21, ["Ride"] = 18.1, ["Fly|Ride"] = 47.24, ["Neon"] = 15.73, ["Neon|Fly"] = 26.87, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 98.16, ["Mega"] = 274.37, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 206.83}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 23.23, ["Fly|Ride"] = 32.72, ["Neon"] = 2.1, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 28.11, ["Mega|Fly|Ride"] = 133.18}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19, ["Fly|Ride"] = 91.81, ["Neon"] = 3.94, ["Neon|Ride"] = 28.05, ["Neon|Fly|Ride"] = 105.51, ["Mega"] = 34.97, ["Mega|Fly"] = 168, ["Mega|Ride"] = 63.33, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.28, ["Neon|Ride"] = 26.25, ["Mega"] = 21.12, ["Mega|Ride"] = 99.21, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 7.86, ["Ride"] = 157.5, ["Fly|Ride"] = 358.74, ["Neon"] = 27.35, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 156.54, ["Mega"] = 213.94, ["Mega|Ride"] = 296.69, ["Mega|Fly|Ride"] = 718.6}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.86, ["Ride"] = 37.73, ["Fly|Ride"] = 84.42, ["Neon"] = 74.82, ["Neon|Ride"] = 141.39, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 371.45, ["Mega|Ride"] = 337.67, ["Mega|Fly|Ride"] = 364.88}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 7.72, ["Fly"] = 19.69, ["Ride"] = 25.34, ["Fly|Ride"] = 45.91, ["Neon"] = 56.51, ["Neon|Fly"] = 106.32, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 417.87, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 73.5, ["Ride"] = 59.05, ["Fly|Ride"] = 262.49, ["Neon"] = 538.13, ["Neon|Ride"] = 527.62, ["Mega"] = 3115.08, ["Mega|Ride"] = 2110.39, ["Mega|Fly|Ride"] = 1558.13}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.65, ["Fly"] = 99.21, ["Ride"] = 42.21, ["Neon"] = 55.13, ["Neon|Fly"] = 126.62, ["Neon|Ride"] = 126.65, ["Mega"] = 610.97, ["Mega|Fly"] = 647.91, ["Mega|Ride"] = 600.48, ["Mega|Fly|Ride"] = 1029.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 16.9, ["Fly|Ride"] = 54.88, ["Neon"] = 2.1, ["Neon|Fly"] = 42.23, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 56.65, ["Mega"] = 14.44, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 3.82, ["Neon|Fly"] = 19, ["Neon|Ride"] = 23.23, ["Neon|Fly|Ride"] = 42.23, ["Mega"] = 39.35, ["Mega|Ride"] = 77.11, ["Mega|Fly|Ride"] = 99.3}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 367.5, ["Ride"] = 415.98, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1829.72, ["Neon|Fly|Ride"] = 1844.46}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 10.47, ["Ride"] = 138.24, ["Fly|Ride"] = 72.19, ["Neon"] = 55.13, ["Neon|Ride"] = 281.75, ["Neon|Fly|Ride"] = 400.99, ["Mega"] = 677.45, ["Mega|Ride"] = 500.18, ["Mega|Fly|Ride"] = 1266.24}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 17.54, ["Ride"] = 17.07, ["Fly|Ride"] = 42.23, ["Neon"] = 4.24, ["Neon|Ride"] = 21.12, ["Neon|Fly|Ride"] = 71.77, ["Mega"] = 114.19, ["Mega|Ride"] = 70.71, ["Mega|Fly|Ride"] = 97.09}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 52.5, ["Ride"] = 117.12, ["Fly|Ride"] = 315, ["Neon"] = 232.31, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 465.29, ["Mega"] = 886.37, ["Mega|Ride"] = 798, ["Mega|Fly|Ride"] = 886.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.9, ["Fly|Ride"] = 42.29, ["Neon"] = 10.48, ["Neon|Fly"] = 69.65, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 83.93, ["Mega"] = 84, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 111.86, ["Mega|Fly|Ride"] = 172.88}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 78.28, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 282.95, ["Mega"] = 16.75, ["Mega|Ride"] = 78.1, ["Mega|Fly|Ride"] = 197.34}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 52.49, ["Ride"] = 107.73, ["Neon"] = 174.57, ["Neon|Fly"] = 454.74, ["Neon|Ride"] = 280.69, ["Neon|Fly|Ride"] = 316.57, ["Mega"] = 661.62, ["Mega|Ride"] = 623.74, ["Mega|Fly|Ride"] = 736.54}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Neon"] = 8.45, ["Neon|Ride"] = 54.89, ["Mega"] = 46.81, ["Mega|Ride"] = 63.09, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.82, ["Fly"] = 141.41, ["Ride"] = 66.6, ["Fly|Ride"] = 131.25, ["Neon"] = 141.4, ["Neon|Ride"] = 405.35, ["Neon|Fly|Ride"] = 258.16, ["Mega|Ride"] = 1686.21}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 6.17, ["Ride"] = 30.19, ["Neon"] = 57.73, ["Neon|Ride"] = 288.75, ["Mega"] = 164.07, ["Mega|Ride"] = 830.46, ["Mega|Fly|Ride"] = 486.29}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.81, ["Fly"] = 70.71, ["Ride"] = 67.54, ["Neon"] = 11.63, ["Neon|Ride"] = 171.94, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 420, ["Mega|Ride"] = 569.63, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.08, ["Ride"] = 39.38, ["Fly|Ride"] = 393.75, ["Neon"] = 545.44, ["Mega|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 1246.27}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 104.82, ["Ride"] = 105.52, ["Neon"] = 5.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 139.31, ["Mega"] = 45.94, ["Mega|Fly"] = 158.61, ["Mega|Ride"] = 82.85, ["Mega|Fly|Ride"] = 278.6}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 27.45, ["Ride"] = 23.21, ["Fly|Ride"] = 72.17, ["Neon"] = 11.81, ["Neon|Fly"] = 41.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105.53, ["Mega|Fly|Ride"] = 282.85}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.5, ["Ride"] = 35.89, ["Neon"] = 105, ["Neon|Ride"] = 57.09, ["Neon|Fly|Ride"] = 112.16, ["Mega"] = 844.17, ["Mega|Ride"] = 454.13, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 23.41, ["Ride"] = 52.5, ["Fly|Ride"] = 141.4, ["Neon"] = 183.75, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 221.82, ["Mega"] = 508.54, ["Mega|Ride"] = 623.74, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 31.66, ["Fly"] = 91.88, ["Ride"] = 43.32, ["Fly|Ride"] = 76.13, ["Neon"] = 103.69, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 237.86, ["Mega"] = 409.42, ["Mega|Ride"] = 408.37, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.62, ["Fly"] = 196.88, ["Ride"] = 111.64, ["Fly|Ride"] = 281.66, ["Neon"] = 246.74, ["Neon|Fly"] = 443.14, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1260, ["Mega|Ride"] = 1200.82, ["Mega|Fly|Ride"] = 1246.27}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.81, ["Ride"] = 23.62, ["Fly|Ride"] = 262.5, ["Neon"] = 15.84, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 316.56, ["Mega"] = 141.41, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 327.48}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.03, ["Ride"] = 28.88, ["Fly|Ride"] = 118.13, ["Neon"] = 31.67, ["Neon|Ride"] = 70.71, ["Mega"] = 141.41, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 218.44}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.05, ["Fly"] = 65.63, ["Ride"] = 26.18, ["Fly|Ride"] = 157.5, ["Neon"] = 120.1, ["Neon|Ride"] = 83.98, ["Mega"] = 492.79, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 16.12, ["Neon|Fly|Ride"] = 28.88, ["Mega"] = 19.03, ["Mega|Fly"] = 78.27, ["Mega|Ride"] = 28.05, ["Mega|Fly|Ride"] = 99.21}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 59.06, ["Fly"] = 220.5, ["Ride"] = 422.04, ["Neon"] = 299.65, ["Neon|Fly"] = 2391.84, ["Neon|Ride"] = 294, ["Mega"] = 872.66, ["Mega|Ride"] = 891.19, ["Mega|Fly|Ride"] = 885.94}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.05, ["Fly|Ride"] = 89.25, ["Neon"] = 6.41, ["Neon|Ride"] = 52.5, ["Mega"] = 70.09, ["Mega|Fly"] = 112.92, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 23.23, ["Fly|Ride"] = 63.32, ["Neon"] = 22.73, ["Neon|Ride"] = 34.36, ["Neon|Fly|Ride"] = 99.21, ["Mega|Ride"] = 422.09, ["Mega|Fly|Ride"] = 268.04}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 84.67, ["Fly"] = 211.05, ["Ride"] = 133.18, ["Fly|Ride"] = 232.32, ["Neon"] = 303.91, ["Neon|Ride"] = 281.72, ["Neon|Fly|Ride"] = 476.96, ["Mega"] = 958.13, ["Mega|Ride"] = 912.19, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 56.99, ["Neon"] = 11.19, ["Neon|Ride"] = 141.39, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 48.39, ["Mega|Ride"] = 132.97, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 11.74}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.88, ["Fly|Ride"] = 209.47, ["Neon"] = 5.92, ["Neon|Ride"] = 26.64, ["Mega"] = 41.88, ["Mega|Ride"] = 115.24, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.91, ["Ride"] = 211.03, ["Fly|Ride"] = 281.72, ["Neon"] = 393.75, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 735, ["Mega"] = 2181.1, ["Mega|Ride"] = 2825.82, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 41.99, ["Neon"] = 18.38, ["Neon|Ride"] = 61.69, ["Mega"] = 303.7, ["Mega|Ride"] = 297.85, ["Mega|Fly|Ride"] = 251.14}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 211.05, ["Neon"] = 6.57, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 23.63, ["Mega|Ride"] = 78.1, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.35, ["Ride"] = 30.85, ["Neon"] = 41.99, ["Neon|Ride"] = 126.62, ["Neon|Fly|Ride"] = 156.54, ["Mega"] = 391.5, ["Mega|Ride"] = 633.12, ["Mega|Fly|Ride"] = 281.72}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 14.44, ["Fly"] = 74.59, ["Ride"] = 24.94, ["Fly|Ride"] = 45.94, ["Neon"] = 82.69, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 272.25, ["Mega"] = 455.44, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 24.54, ["Ride"] = 59.07, ["Neon"] = 131.25, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 563.49, ["Mega|Ride"] = 604.67, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 111.51, ["Fly"] = 206.83, ["Ride"] = 154.87, ["Fly|Ride"] = 193.6, ["Neon"] = 620.39, ["Neon|Ride"] = 548.63, ["Neon|Fly|Ride"] = 669.58, ["Mega|Fly|Ride"] = 2954.55}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.5, ["Fly"] = 21.11, ["Ride"] = 18.25, ["Fly|Ride"] = 39.37, ["Neon"] = 41.15, ["Neon|Ride"] = 46.74, ["Neon|Fly|Ride"] = 78.27, ["Mega"] = 422.09, ["Mega|Ride"] = 702.77, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.61, ["Fly"] = 72.19, ["Ride"] = 23.61, ["Fly|Ride"] = 59.07, ["Neon"] = 18.79, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 189.95, ["Mega|Fly|Ride"] = 259.6}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.46, ["Fly"] = 36.75, ["Ride"] = 52.5, ["Fly|Ride"] = 105.52, ["Neon"] = 80.07, ["Neon|Ride"] = 91.88, ["Mega"] = 560.33, ["Mega|Fly|Ride"] = 1272.57}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 34.65, ["Ride"] = 65.63, ["Fly|Ride"] = 116.83, ["Neon"] = 129.94, ["Neon|Ride"] = 105.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 577.5, ["Mega|Fly"] = 985.56, ["Mega|Ride"] = 742.88, ["Mega|Fly|Ride"] = 880.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 19.62, ["Fly"] = 65.63, ["Ride"] = 81.84, ["Neon"] = 131.25, ["Neon|Ride"] = 105.53, ["Mega"] = 630, ["Mega|Ride"] = 661.62, ["Mega|Fly|Ride"] = 731.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 208.94, ["Ride"] = 281.75, ["Fly|Ride"] = 459.38, ["Neon"] = 1263.98, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1266.24, ["Mega|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 5695.93}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 32.81, ["Fly"] = 32.82, ["Ride"] = 39.61, ["Fly|Ride"] = 63.32, ["Neon"] = 280.26, ["Neon|Ride"] = 71.77, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 1195.69, ["Mega|Ride"] = 522.34, ["Mega|Fly|Ride"] = 631.02}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 15.74, ["Fly|Ride"] = 37.99, ["Neon"] = 2.1, ["Neon|Ride"] = 15.84, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 21.12, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 46.45, ["Mega|Fly|Ride"] = 108.42}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.78, ["Ride"] = 56.44, ["Neon"] = 15.84, ["Neon|Ride"] = 39.35, ["Mega"] = 125.08, ["Mega|Ride"] = 211.05, ["Mega|Fly|Ride"] = 460.04}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.94, ["Ride"] = 62.98, ["Neon"] = 15.73, ["Neon|Ride"] = 77.7, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 84, ["Mega|Fly"] = 281.75, ["Mega|Ride"] = 311.29, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 584.15, ["Ride"] = 377.99, ["Fly|Ride"] = 490.88, ["Neon"] = 2110.14, ["Neon|Ride"] = 1558.24, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 5034.75}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.33, ["Fly"] = 70.71, ["Ride"] = 15.78, ["Fly|Ride"] = 42.23, ["Neon"] = 37.89, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 236.25, ["Mega|Ride"] = 183.62, ["Mega|Fly|Ride"] = 467.21}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.24, ["Fly"] = 19, ["Ride"] = 19.66, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 46.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 419.97, ["Mega|Ride"] = 703.83, ["Mega|Fly|Ride"] = 331.34}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.2, ["Fly"] = 84.42, ["Ride"] = 27.48, ["Fly|Ride"] = 105.15, ["Neon"] = 16.4, ["Neon|Fly"] = 70.71, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 105.53, ["Mega"] = 140.44, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.07, ["Fly"] = 42.23, ["Fly|Ride"] = 70.71, ["Neon"] = 91.88, ["Neon|Ride"] = 126.65, ["Neon|Fly|Ride"] = 147.75, ["Mega|Ride"] = 845.25, ["Mega|Fly|Ride"] = 622.49}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 315, ["Ride"] = 63, ["Neon"] = 14.44, ["Neon|Ride"] = 78.28, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 600.48}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.57, ["Fly"] = 787.5, ["Ride"] = 65.63, ["Fly|Ride"] = 91.88, ["Neon"] = 311.85, ["Neon|Ride"] = 143.52, ["Mega"] = 703.83, ["Mega|Ride"] = 322.91, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.05, ["Ride"] = 26.25, ["Fly|Ride"] = 61.21, ["Neon"] = 3.93, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 71.93, ["Mega|Ride"] = 2573.63, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 11.63, ["Neon"] = 89.25, ["Mega"] = 170.63, ["Mega|Ride"] = 338.63, ["Mega|Fly|Ride"] = 633.12}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.43, ["Ride"] = 70.71, ["Fly|Ride"] = 141.4, ["Neon"] = 154.3, ["Neon|Ride"] = 70.71, ["Mega"] = 289.59, ["Mega|Ride"] = 280.18, ["Mega|Fly|Ride"] = 1055.21}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 14.78, ["Fly"] = 35.88, ["Ride"] = 24.93, ["Fly|Ride"] = 78.31, ["Neon"] = 46.73, ["Neon|Ride"] = 57.85, ["Neon|Fly|Ride"] = 108.29, ["Mega"] = 408.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 427.19}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 196.88, ["Fly"] = 281.75, ["Ride"] = 156.56, ["Fly|Ride"] = 225.78, ["Neon"] = 951.45, ["Neon|Ride"] = 934.48, ["Neon|Fly|Ride"] = 844.19, ["Mega|Fly|Ride"] = 3142.37}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.63, ["Fly"] = 21.2, ["Ride"] = 18.38, ["Fly|Ride"] = 65.09, ["Neon"] = 17.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 106.98, ["Mega"] = 211.05, ["Mega|Ride"] = 323.96, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.26, ["Fly"] = 32.82, ["Ride"] = 23.63, ["Fly|Ride"] = 77.68, ["Neon"] = 20.97, ["Neon|Ride"] = 56.99, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 31.16, ["Ride"] = 108.84, ["Fly|Ride"] = 216.57, ["Neon"] = 111.57, ["Neon|Ride"] = 259.6, ["Neon|Fly|Ride"] = 561.38, ["Mega"] = 401.63, ["Mega|Ride"] = 341.24, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 55.13, ["Fly"] = 126.65, ["Ride"] = 98.44, ["Fly|Ride"] = 109.8, ["Neon"] = 267.94, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1370.71, ["Mega|Ride"] = 1611.29, ["Mega|Fly|Ride"] = 1154.4}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 21.09, ["Ride"] = 59.11, ["Fly|Ride"] = 315, ["Neon"] = 83.98, ["Neon|Ride"] = 98.41, ["Neon|Fly|Ride"] = 252.2, ["Mega"] = 232.44, ["Mega|Ride"] = 257.25, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 22.17, ["Fly|Ride"] = 33.6, ["Neon"] = 11.63, ["Neon|Fly|Ride"] = 120.31, ["Mega"] = 125, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 20.67, ["Fly"] = 42, ["Ride"] = 91.81, ["Fly|Ride"] = 422.04, ["Neon"] = 71.54, ["Neon|Fly"] = 112.91, ["Neon|Ride"] = 134.03, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 209.42, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 64.32, ["Fly"] = 141.41, ["Ride"] = 116.82, ["Fly|Ride"] = 262.5, ["Neon"] = 195.18, ["Neon|Ride"] = 249.61, ["Neon|Fly|Ride"] = 315, ["Mega"] = 525, ["Mega|Ride"] = 484.32, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Neon"] = 6.55, ["Neon|Fly"] = 197.31, ["Neon|Ride"] = 104.74, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 40.84, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 7.86, ["Ride"] = 288.75, ["Neon"] = 78.75, ["Neon|Ride"] = 126.65, ["Mega"] = 275.63, ["Mega|Ride"] = 503.43, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.75, ["Fly"] = 1246.58, ["Ride"] = 1023.75, ["Fly|Ride"] = 1032.94, ["Neon"] = 3095.57, ["Neon|Ride"] = 3519.08, ["Neon|Fly|Ride"] = 3180.36, ["Mega|Fly|Ride"] = 10498.69}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 24.93, ["Ride"] = 97.08, ["Fly|Ride"] = 311.89, ["Neon"] = 188.31, ["Neon|Ride"] = 339.78, ["Mega"] = 563.49, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 698.83}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.24, ["Fly"] = 49.88, ["Ride"] = 30.18, ["Fly|Ride"] = 211.03, ["Neon"] = 15.75, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 46.74, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 89.23, ["Mega|Ride"] = 111.08, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.48, ["Ride"] = 131.22, ["Neon"] = 109.8, ["Mega"] = 386.63, ["Mega|Ride"] = 462.54, ["Mega|Fly|Ride"] = 779.07}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 49.62, ["Fly|Ride"] = 422.04, ["Neon"] = 2.59, ["Neon|Ride"] = 36.21, ["Neon|Fly|Ride"] = 109.82, ["Mega"] = 17.05, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 95.82, ["Ride"] = 140.58, ["Neon"] = 288.75, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 465.35, ["Mega"] = 1258.86, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 4.68, ["Fly"] = 101.07, ["Ride"] = 45.56, ["Fly|Ride"] = 817.66, ["Neon"] = 27.2, ["Neon|Ride"] = 84, ["Mega"] = 316.57, ["Mega|Ride"] = 231.1, ["Mega|Fly|Ride"] = 323.96}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.77, ["Ride"] = 65.63, ["Neon"] = 11.63, ["Neon|Ride"] = 39.38, ["Mega"] = 170.6, ["Mega|Ride"] = 278.59, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 40.63, ["Fly"] = 99.21, ["Ride"] = 84.42, ["Fly|Ride"] = 91.88, ["Neon"] = 131.25, ["Neon|Ride"] = 151.96, ["Neon|Fly|Ride"] = 340.76, ["Mega"] = 505.45, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 527.62}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 14.44, ["Fly"] = 183.75, ["Ride"] = 289.1, ["Neon"] = 87.28, ["Neon|Fly"] = 179.82, ["Neon|Ride"] = 240.19, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 393.74, ["Mega|Ride"] = 422.09, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 52.55, ["Ride"] = 63.09, ["Neon"] = 314.99, ["Neon|Ride"] = 933.19, ["Neon|Fly|Ride"] = 911.54, ["Mega"] = 1455.12, ["Mega|Ride"] = 1401.62, ["Mega|Fly|Ride"] = 1252.53}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.07, ["Ride"] = 45.39, ["Fly|Ride"] = 168.83, ["Neon"] = 24.93, ["Neon|Ride"] = 109.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 108.94, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 275}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 9.17, ["Fly"] = 31.5, ["Ride"] = 28.5, ["Fly|Ride"] = 68.25, ["Neon"] = 65.63, ["Neon|Ride"] = 99.21, ["Neon|Fly|Ride"] = 111.86, ["Mega"] = 354.36, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 448.52}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 126.66, ["Ride"] = 183.75, ["Fly|Ride"] = 156.16, ["Neon"] = 485.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 638.9, ["Mega"] = 2362.5, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.6, ["Fly"] = 26.25, ["Ride"] = 19.57, ["Fly|Ride"] = 48.55, ["Neon"] = 18.38, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 175.19, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.25, ["Fly"] = 42.23, ["Ride"] = 22.32, ["Fly|Ride"] = 50.48, ["Neon"] = 18.38, ["Neon|Fly"] = 63.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 91.82, ["Mega"] = 220.5, ["Mega|Ride"] = 192.54, ["Mega|Fly|Ride"] = 258.15}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 19, ["Fly|Ride"] = 46.36, ["Neon"] = 2.1, ["Neon|Fly"] = 22.2, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 46.74, ["Mega"] = 15.27, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 31.67, ["Neon"] = 3.93, ["Neon|Ride"] = 42.23, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 156.53}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 132.34, ["Ride"] = 32.82, ["Neon"] = 17.54, ["Neon|Ride"] = 28.5, ["Mega"] = 98.44, ["Mega|Ride"] = 208.94}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 103.66, ["Ride"] = 156.56, ["Neon"] = 281.72, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 630, ["Mega"] = 526.55, ["Mega|Fly|Ride"] = 522.58}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 5.24, ["Fly"] = 20.07, ["Ride"] = 17.07, ["Fly|Ride"] = 40.89, ["Neon"] = 15.73, ["Neon|Fly"] = 35.02, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 66.87, ["Mega"] = 119.27, ["Mega|Fly"] = 211.05, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.78, ["Fly"] = 32.82, ["Ride"] = 22.2, ["Fly|Ride"] = 70.71, ["Neon"] = 12.63, ["Neon|Fly"] = 68.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 136.5, ["Mega|Fly"] = 197.34, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 186.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.92, ["Fly"] = 25.34, ["Ride"] = 24.94, ["Fly|Ride"] = 72.19, ["Neon"] = 15.75, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 140.19, ["Mega"] = 127.23, ["Mega|Fly"] = 408.19, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.6, ["Ride"] = 48.55, ["Neon"] = 31.49, ["Neon|Ride"] = 112.32, ["Neon|Fly|Ride"] = 172.89, ["Mega"] = 233.21, ["Mega|Ride"] = 299.92, ["Mega|Fly|Ride"] = 386.22}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.45, ["Fly"] = 160.69, ["Neon"] = 69.57, ["Neon|Ride"] = 99.21, ["Mega"] = 420, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 91.88, ["Ride"] = 24.28, ["Fly|Ride"] = 32.72, ["Neon"] = 18.31, ["Neon|Fly"] = 196.65, ["Neon|Ride"] = 61.2, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 183.75, ["Mega|Ride"] = 175.38, ["Mega|Fly|Ride"] = 285.97}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Ride"] = 16.86, ["Fly|Ride"] = 49.61, ["Neon"] = 10.48, ["Neon|Fly"] = 86.44, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 422.09, ["Mega|Ride"] = 145.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 239.52, ["Fly|Ride"] = 362.12, ["Neon"] = 893.66, ["Neon|Ride"] = 934.48, ["Neon|Fly|Ride"] = 892.5, ["Mega"] = 4220.77, ["Mega|Fly|Ride"] = 3661.88}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.24, ["Ride"] = 42, ["Neon"] = 15.84, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 141.41, ["Mega|Ride"] = 267.88, ["Mega|Fly|Ride"] = 703.83}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.62, ["Fly"] = 32.82, ["Ride"] = 27.44, ["Fly|Ride"] = 97.08, ["Neon"] = 35.44, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 125, ["Mega"] = 203.44, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 211.05}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 9.03, ["Fly|Ride"] = 156.54, ["Neon"] = 40.69, ["Neon|Fly|Ride"] = 630, ["Mega"] = 416.81, ["Mega|Ride"] = 474.85, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.9, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 28.76, ["Neon|Ride"] = 22.11, ["Neon|Fly|Ride"] = 42.23, ["Mega"] = 15.72, ["Mega|Ride"] = 46.45, ["Mega|Fly|Ride"] = 95.55}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.59, ["Fly"] = 56.44, ["Ride"] = 26.25, ["Fly|Ride"] = 63.32, ["Neon"] = 22.93, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 78.73, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.93, ["Ride"] = 65.63, ["Neon"] = 11.8, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 105, ["Mega|Ride"] = 149.52, ["Mega|Fly|Ride"] = 450.19}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 78.09, ["Fly"] = 130.86, ["Ride"] = 91.88, ["Fly|Ride"] = 168.83, ["Neon"] = 393.75, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 408.19, ["Mega|Ride"] = 3519.08, ["Mega|Fly|Ride"] = 1547.98}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.91, ["Fly"] = 65.63, ["Ride"] = 39.37, ["Fly|Ride"] = 65.54, ["Neon"] = 12.68, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 311.9, ["Mega"] = 283.49}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 156.16, ["Neon"] = 9.37, ["Neon|Ride"] = 177.07, ["Neon|Fly|Ride"] = 524.49, ["Mega"] = 66.94, ["Mega|Fly"] = 411.54, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 141.41}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.82, ["Fly"] = 44.41, ["Ride"] = 93.49, ["Fly|Ride"] = 226.31, ["Neon"] = 154.82, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 561.38, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 754.83}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.84, ["Ride"] = 15.74, ["Fly|Ride"] = 35.88, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 17.16, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 18.36, ["Mega|Ride"] = 41.99, ["Mega|Fly|Ride"] = 44.63}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.05, ["Fly|Ride"] = 52.5, ["Neon"] = 3.68, ["Neon|Ride"] = 63.09, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 22.32, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.62}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.28, ["Ride"] = 70.08, ["Neon"] = 10.49, ["Neon|Ride"] = 69.66, ["Neon|Fly|Ride"] = 141.41, ["Mega"] = 77.16, ["Mega|Ride"] = 127.93, ["Mega|Fly|Ride"] = 447.37}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.24, ["Fly"] = 78.29, ["Ride"] = 39.38, ["Fly|Ride"] = 106.65, ["Neon"] = 17.54, ["Neon|Fly"] = 46.73, ["Neon|Ride"] = 69.51, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 125.94, ["Mega|Fly"] = 203.24, ["Mega|Ride"] = 181.07, ["Mega|Fly|Ride"] = 247.98}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.05, ["Fly"] = 15.84, ["Ride"] = 15.7, ["Fly|Ride"] = 91.34, ["Neon"] = 2.1, ["Neon|Fly"] = 15.84, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 15.84, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 32.68, ["Mega|Fly|Ride"] = 121.36}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.06, ["Ride"] = 45.94, ["Neon"] = 60.85, ["Neon|Fly|Ride"] = 176.54, ["Mega"] = 379.88, ["Mega|Ride"] = 419.97, ["Mega|Fly|Ride"] = 365.11}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 3150, ["Ride"] = 3938.82, ["Fly|Ride"] = 3500.44, ["Neon|Fly|Ride"] = 10500}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 28.33, ["Ride"] = 17.03, ["Fly|Ride"] = 49.61, ["Neon"] = 7.54, ["Neon|Fly"] = 60.16, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 63.33, ["Mega"] = 78.75, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 204.62}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.65, ["Ride"] = 26.25, ["Neon"] = 11.19, ["Neon|Ride"] = 31.67, ["Mega"] = 131.25, ["Mega|Ride"] = 422.09, ["Mega|Fly|Ride"] = 168.84}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.15, ["Ride"] = 30.08, ["Fly|Ride"] = 91.87, ["Neon"] = 66.67, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 268.04, ["Mega"] = 422.09, ["Mega|Ride"] = 261.84, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 24.91, ["Ride"] = 117.13, ["Fly|Ride"] = 141.4, ["Neon"] = 139, ["Neon|Fly|Ride"] = 422.09, ["Mega"] = 563.49, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 590.92}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 152.91, ["Fly"] = 211.05, ["Ride"] = 157.5, ["Fly|Ride"] = 187.69, ["Neon"] = 697.18, ["Neon|Ride"] = 771.75, ["Neon|Fly|Ride"] = 838.89, ["Mega"] = 6331.16, ["Mega|Ride"] = 3025.24, ["Mega|Fly|Ride"] = 3473.71}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 11.8, ["Ride"] = 26.25, ["Fly|Ride"] = 112.91, ["Neon"] = 15.85, ["Neon|Ride"] = 125, ["Neon|Fly|Ride"] = 105.53, ["Mega"] = 281.75, ["Mega|Ride"] = 186.89, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 63.33, ["Neon"] = 16.44, ["Neon|Fly"] = 94.97, ["Neon|Ride"] = 34.13, ["Mega"] = 102.95, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 819}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 101.99, ["Ride"] = 26.94, ["Fly|Ride"] = 42.23, ["Neon"] = 9.83, ["Neon|Fly"] = 48.55, ["Neon|Ride"] = 39.72, ["Mega"] = 65.63, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.58, ["Neon"] = 109.8, ["Neon|Ride"] = 156.54, ["Mega"] = 196.88, ["Mega|Ride"] = 281.75, ["Mega|Fly|Ride"] = 607.04}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.05, ["Ride"] = 69.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.23, ["Mega"] = 14.42, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 81.38, ["Fly"] = 303.77, ["Ride"] = 121.36, ["Fly|Ride"] = 168.82, ["Neon"] = 365.07, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 436.88, ["Mega|Ride"] = 1688.32, ["Mega|Fly|Ride"] = 1601.79}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 32.29, ["Neon"] = 6.33, ["Mega"] = 99.21, ["Mega|Ride"] = 122.07}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.32, ["Ride"] = 55.13, ["Fly|Ride"] = 157.5, ["Neon"] = 249.95, ["Neon|Ride"] = 418.18, ["Neon|Fly|Ride"] = 319.73, ["Mega"] = 2625, ["Mega|Ride"] = 2814.2, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 21.12, ["Fly|Ride"] = 70.71, ["Neon"] = 5.25, ["Neon|Ride"] = 21.12, ["Mega"] = 48.55, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 210.67}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.05, ["Neon"] = 7.88, ["Mega"] = 63, ["Mega|Ride"] = 165.31, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.92, ["Ride"] = 54.87, ["Fly|Ride"] = 157.5, ["Neon"] = 17.49, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 105.53, ["Neon|Fly|Ride"] = 690.11, ["Mega"] = 141.41, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 406.88, ["Fly"] = 545.61, ["Ride"] = 422.14, ["Fly|Ride"] = 492.19, ["Neon"] = 1036.88, ["Neon|Ride"] = 1000.13, ["Neon|Fly|Ride"] = 1263.93, ["Mega"] = 3564.45, ["Mega|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 2743.13}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.85, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 94.97, ["Neon"] = 156.53, ["Neon|Fly"] = 311.85, ["Neon|Ride"] = 186.38, ["Neon|Fly|Ride"] = 280.23, ["Mega|Ride"] = 703.83, ["Mega|Fly|Ride"] = 779.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.9, ["Fly|Ride"] = 91.88, ["Neon"] = 5.25, ["Neon|Fly"] = 137.17, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 54.89, ["Mega|Ride"] = 84.42, ["Mega|Fly|Ride"] = 281.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 10.98, ["Fly"] = 109.57, ["Ride"] = 31.34, ["Fly|Ride"] = 99.2, ["Neon"] = 39.38, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 64.24, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.19, ["Mega|Fly"] = 960.24, ["Mega|Ride"] = 272.01, ["Mega|Fly|Ride"] = 276.48}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 10.39, ["Ride"] = 25.97, ["Fly|Ride"] = 105.52, ["Neon"] = 105, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 138.25, ["Mega"] = 379.88, ["Mega|Ride"] = 311.29, ["Mega|Fly|Ride"] = 485.4}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 15.68, ["Neon|Ride"] = 65.63, ["Mega"] = 50.34, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.51, ["Fly"] = 86.63, ["Ride"] = 17.54, ["Fly|Ride"] = 78.73, ["Neon"] = 27.56, ["Neon|Ride"] = 42.23, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 545.47, ["Mega|Ride"] = 323.96}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.44, ["Fly"] = 139.13, ["Ride"] = 125.99, ["Fly|Ride"] = 210, ["Neon"] = 623.69, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 654.23, ["Mega|Ride"] = 2426.95, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 18.36, ["Ride"] = 78.75, ["Fly|Ride"] = 144, ["Neon"] = 141.4, ["Neon|Ride"] = 281.75, ["Mega"] = 700.82, ["Mega|Ride"] = 711.21, ["Mega|Fly|Ride"] = 633.12}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2887.49, ["Ride"] = 3130.42, ["Fly|Ride"] = 2492.44, ["Neon"] = 12660.77, ["Neon|Fly|Ride"] = 4988.27, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 22.32, ["Fly|Ride"] = 170.63, ["Neon"] = 11.69, ["Neon|Ride"] = 35.89, ["Mega"] = 96.97, ["Mega|Ride"] = 159.43, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.8, ["Ride"] = 52.5, ["Fly|Ride"] = 281.72, ["Neon"] = 56.13, ["Neon|Ride"] = 101.82, ["Mega"] = 141.37, ["Mega|Ride"] = 211.05, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1050, ["Fly"] = 1252.13, ["Ride"] = 984.38, ["Fly|Ride"] = 1141.88, ["Neon"] = 3587.22, ["Neon|Ride"] = 3658.36, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Ride"] = 15978.77, ["Mega|Fly|Ride"] = 11664.69}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 37.99, ["Neon"] = 209.36, ["Mega"] = 985.56, ["Mega|Ride"] = 759.75, ["Mega|Fly|Ride"] = 775.69}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.87, ["Ride"] = 104.48, ["Fly|Ride"] = 52.5, ["Neon"] = 15.73, ["Neon|Fly|Ride"] = 179.9, ["Mega"] = 249.38, ["Mega|Ride"] = 349.28, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly|Ride"] = 52.5, ["Neon"] = 3.89, ["Mega"] = 18.38, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 125.57}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.69, ["Ride"] = 131.25, ["Fly|Ride"] = 656.25, ["Neon"] = 328.13, ["Neon|Ride"] = 556.1, ["Mega"] = 5250, ["Mega|Fly|Ride"] = 2532.48}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Ride"] = 140.48, ["Neon"] = 17.35, ["Neon|Ride"] = 252, ["Mega"] = 170.63, ["Mega|Ride"] = 179.59, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 104.95, ["Ride"] = 211.05, ["Neon"] = 603.75, ["Mega"] = 2110.39, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 10.57, ["Fly"] = 105, ["Neon"] = 31.46, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 315, ["Mega"] = 224.44}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 258.9, ["Ride"] = 262.5, ["Fly|Ride"] = 354.6, ["Neon"] = 985.44, ["Neon|Ride"] = 985.56, ["Neon|Fly|Ride"] = 813.75, ["Mega|Fly|Ride"] = 3821.92}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.67, ["Fly"] = 70.29, ["Ride"] = 23.63, ["Fly|Ride"] = 84.42, ["Neon"] = 42, ["Neon|Ride"] = 45.89, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 250.04, ["Mega|Ride"] = 311.29, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 16.49, ["Fly|Ride"] = 42.21, ["Neon"] = 3.94, ["Neon|Fly"] = 39.11, ["Neon|Ride"] = 28.49, ["Neon|Fly|Ride"] = 54.89, ["Mega"] = 39.38, ["Mega|Ride"] = 66.49, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 859.69, ["Fly"] = 1069.98, ["Ride"] = 901.69, ["Fly|Ride"] = 951.56, ["Neon|Ride"] = 3913.08, ["Neon|Fly|Ride"] = 3519.08, ["Mega"] = 28032.11, ["Mega|Fly|Ride"] = 28138.8}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 3.91, ["Ride"] = 40.69, ["Neon"] = 42.21, ["Mega"] = 129.94, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.51, ["Fly"] = 141.41, ["Ride"] = 32.72, ["Fly|Ride"] = 52.5, ["Neon"] = 27.56, ["Neon|Fly"] = 75.98, ["Neon|Ride"] = 42.23, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 173.25, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 44.63, ["Fly"] = 46.14, ["Ride"] = 38.06, ["Fly|Ride"] = 78.72, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2076.63, ["Mega|Fly|Ride"] = 752.21}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 18.38, ["Fly"] = 79.15, ["Ride"] = 21.11, ["Fly|Ride"] = 60.52, ["Neon"] = 78.75, ["Neon|Ride"] = 82.89, ["Neon|Fly|Ride"] = 158.29, ["Mega"] = 563.49, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 439.68}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 26.1, ["Ride"] = 28.5, ["Fly|Ride"] = 636.57, ["Neon"] = 91.83, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 437.92, ["Mega|Ride"] = 494.82, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Fly"] = 45.94, ["Ride"] = 105, ["Fly|Ride"] = 156.54, ["Neon"] = 2.55, ["Neon|Ride"] = 90.77, ["Mega"] = 17.73, ["Mega|Ride"] = 89.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 34.9, ["Fly"] = 69.65, ["Ride"] = 47.25, ["Fly|Ride"] = 92.87, ["Neon"] = 578.82, ["Neon|Fly"] = 310.21, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 3376.63, ["Mega|Fly|Ride"] = 766.5}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.94, ["Fly"] = 141.41, ["Ride"] = 26.25, ["Fly|Ride"] = 127.32, ["Neon"] = 42, ["Neon|Ride"] = 141.07, ["Mega"] = 656.25, ["Mega|Fly|Ride"] = 563.49}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 25.33, ["Ride"] = 18.38, ["Fly|Ride"] = 68.25, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 54.92, ["Mega"] = 1042.54, ["Mega|Ride"] = 251.14, ["Mega|Fly|Ride"] = 202.13}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.87, ["Neon"] = 105, ["Mega"] = 98.44, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 19.93, ["Fly"] = 262.5, ["Ride"] = 39.38, ["Fly|Ride"] = 70.71, ["Neon"] = 104.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 732.33, ["Mega|Ride"] = 906.42, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.9, ["Neon"] = 21.12, ["Neon|Ride"] = 78.75, ["Mega"] = 74.29, ["Mega|Fly|Ride"] = 311.88}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.05, ["Ride"] = 27.18, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 15.81, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 198.85}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Ride"] = 26.13, ["Neon"] = 2.1, ["Neon|Fly"] = 393.65, ["Neon|Ride"] = 28.88, ["Mega"] = 15.74, ["Mega|Ride"] = 59.56, ["Mega|Fly|Ride"] = 119.44}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 24.07, ["Fly|Ride"] = 56.99, ["Neon"] = 5.25, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 86.63, ["Mega|Ride"] = 168.84, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 5256.29, ["Neon"] = 57.75, ["Neon|Ride"] = 1312.5, ["Mega"] = 141.41, ["Mega|Ride"] = 158.33}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.56, ["Ride"] = 16.72, ["Fly|Ride"] = 72.19, ["Neon"] = 22.31, ["Neon|Ride"] = 30.58, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 284.82, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 61.68, ["Ride"] = 197.31, ["Fly|Ride"] = 394.61, ["Neon"] = 183.75, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 323.96, ["Mega"] = 690.11, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 876.88}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 26.39, ["Ride"] = 15.74, ["Fly|Ride"] = 36.06, ["Neon"] = 2.1, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 42.21, ["Mega"] = 30.4, ["Mega|Ride"] = 56.68, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.19, ["Fly"] = 65.63, ["Ride"] = 35.18, ["Fly|Ride"] = 119.24, ["Neon"] = 41.97, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 524.99, ["Mega|Ride"] = 211.05, ["Mega|Fly|Ride"] = 340.83}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.75, ["Fly"] = 28.5, ["Ride"] = 21.21, ["Fly|Ride"] = 78.21, ["Neon"] = 64.32, ["Neon|Ride"] = 84.42, ["Neon|Fly|Ride"] = 139.31, ["Mega"] = 1027.78, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.63, ["Fly"] = 140.38, ["Ride"] = 46.4, ["Neon"] = 17.05, ["Neon|Ride"] = 70.71, ["Mega"] = 150.94, ["Mega|Ride"] = 239.54, ["Mega|Fly|Ride"] = 141.41}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Ride"] = 21.11, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 21.11, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.89, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 61.57, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.63, ["Ride"] = 27.57, ["Fly|Ride"] = 39.38, ["Neon"] = 14.3, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 211.05, ["Mega"] = 156.53, ["Mega|Fly"] = 735, ["Mega|Ride"] = 141.41, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 958.11, ["Fly"] = 1269.4, ["Ride"] = 1017.19, ["Fly|Ride"] = 1069.69, ["Neon"] = 2959.88, ["Neon|Fly"] = 2708.36, ["Neon|Ride"] = 2362.49, ["Neon|Fly|Ride"] = 2098.68, ["Mega|Fly|Ride"] = 7428.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 65.63, ["Ride"] = 102.38, ["Neon"] = 236.25, ["Neon|Ride"] = 250.69, ["Neon|Fly|Ride"] = 408.84, ["Mega"] = 3164.53, ["Mega|Ride"] = 1125.91, ["Mega|Fly|Ride"] = 1160.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 63.33, ["Ride"] = 70.71, ["Neon"] = 9.19, ["Neon|Ride"] = 74.93, ["Neon|Fly|Ride"] = 315, ["Mega"] = 63.33, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 34.12, ["Ride"] = 54.85, ["Fly|Ride"] = 262.5, ["Neon"] = 199.76, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 300.57, ["Mega"] = 844.17, ["Mega|Ride"] = 949.69, ["Mega|Fly|Ride"] = 775.59}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.87, ["Ride"] = 36.46, ["Neon"] = 46.6, ["Neon|Ride"] = 131.25, ["Mega"] = 376.69, ["Mega|Fly|Ride"] = 1055.21}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 301.87, ["Fly"] = 934.64, ["Ride"] = 295.32, ["Fly|Ride"] = 417.82, ["Neon|Ride"] = 1273.13, ["Neon|Fly|Ride"] = 1182.57, ["Mega|Fly|Ride"] = 4271.79}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 102.38, ["Ride"] = 22.32, ["Fly|Ride"] = 129.93, ["Neon"] = 14.44, ["Mega"] = 393.75, ["Mega|Fly"] = 281.75}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 38.07, ["Neon|Ride"] = 141.41}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 35.89, ["Ride"] = 103.68, ["Fly|Ride"] = 211.03, ["Neon"] = 170.63, ["Neon|Ride"] = 311.25, ["Mega"] = 623.74, ["Mega|Ride"] = 981.1, ["Mega|Fly|Ride"] = 633.12}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 70.88, ["Fly|Ride"] = 141.4, ["Neon"] = 15.84, ["Neon|Ride"] = 203.25, ["Mega"] = 177.29, ["Mega|Ride"] = 225.83, ["Mega|Fly|Ride"] = 422.09}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 15.74, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 19, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 3906.14, ["Ride"] = 3937.5, ["Fly|Ride"] = 4198.68, ["Neon"] = 25321.52, ["Neon|Fly|Ride"] = 19163.82, ["Mega|Fly|Ride"] = 78927.23}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.36, ["Ride"] = 50.67, ["Neon"] = 36.75, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 168.84, ["Mega"] = 255.93, ["Mega|Ride"] = 311.88, ["Mega|Fly|Ride"] = 336}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.43, ["Ride"] = 24.94, ["Fly|Ride"] = 47.25, ["Neon"] = 15.64, ["Neon|Fly"] = 46.73, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.48, ["Mega"] = 284.92, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 207.64}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 413.44, ["Fly"] = 840, ["Ride"] = 474.38, ["Fly|Ride"] = 497.06, ["Neon"] = 1688.12, ["Neon|Ride"] = 1279.06, ["Neon|Fly|Ride"] = 1266.24, ["Mega|Fly|Ride"] = 5544.54}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 7.87, ["Ride"] = 31.5, ["Neon"] = 52.5, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.92, ["Fly"] = 60.06, ["Ride"] = 78.27, ["Neon"] = 59.07, ["Neon|Ride"] = 280.69, ["Neon|Fly|Ride"] = 14069.93, ["Mega"] = 281.75, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 2336.02}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 46.44, ["Neon"] = 6.57, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 101.07, ["Mega"] = 38.07, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 597.19, ["Ride"] = 615.66, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 8751.75}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.51, ["Ride"] = 65.63, ["Neon"] = 21.06, ["Neon|Fly"] = 75.98, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 643.13, ["Mega"] = 112.88, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.86, ["Fly"] = 236.25, ["Ride"] = 52.5, ["Fly|Ride"] = 154.88, ["Neon"] = 42.94, ["Neon|Ride"] = 63.51, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 252, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 333.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.47, ["Fly|Ride"] = 37.41, ["Neon"] = 11.69, ["Neon|Fly"] = 141.4, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 89.8, ["Mega"] = 124.69, ["Mega|Fly"] = 225.83, ["Mega|Ride"] = 219.5, ["Mega|Fly|Ride"] = 280.69}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 30.18, ["Ride"] = 92.4, ["Fly|Ride"] = 116.83, ["Neon"] = 138.21, ["Mega"] = 526.55, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 526.32}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 4.23, ["Neon|Fly|Ride"] = 2044.16, ["Mega"] = 45.47, ["Mega|Ride"] = 95.79, ["Mega|Fly|Ride"] = 169.32}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 511.88, ["Ride"] = 544.03, ["Fly|Ride"] = 682.5, ["Neon"] = 2083.77, ["Neon|Ride"] = 1978.5, ["Neon|Fly|Ride"] = 1859.07, ["Mega|Ride"] = 9110.45, ["Mega|Fly|Ride"] = 7848.75}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 40.61, ["Neon"] = 4.68, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 35.44, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 315.68}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 28.46, ["Neon"] = 3.94, ["Neon|Ride"] = 41.67, ["Mega"] = 35.44, ["Mega|Ride"] = 73.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 3.93, ["Neon|Ride"] = 63.04, ["Mega"] = 35.88, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 105.53, ["Mega|Fly|Ride"] = 167.37}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.82, ["Ride"] = 26.25, ["Neon"] = 15.73, ["Mega|Ride"] = 358.59}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 53.23, ["Ride"] = 140.19, ["Fly|Ride"] = 141.4, ["Neon"] = 123.47, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 451.64, ["Mega"] = 669.38, ["Mega|Ride"] = 563.49, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 20.76, ["Ride"] = 65.63, ["Fly|Ride"] = 242.82, ["Neon"] = 104.47, ["Neon|Ride"] = 189.09, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 551.25, ["Mega|Ride"] = 562.42, ["Mega|Fly|Ride"] = 488.24}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 34.65, ["Ride"] = 16.37, ["Fly|Ride"] = 42, ["Neon"] = 31.49, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.1, ["Mega"] = 299.92, ["Mega|Ride"] = 222.69, ["Mega|Fly|Ride"] = 233.61}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 12.28, ["Ride"] = 32.82, ["Neon"] = 281.72, ["Mega"] = 422.09, ["Mega|Fly|Ride"] = 519.18}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 32.72, ["Ride"] = 28.29, ["Fly|Ride"] = 362.25, ["Neon"] = 13.12, ["Neon|Ride"] = 83.87, ["Mega"] = 105, ["Mega|Ride"] = 140.18, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 26.21, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 62.39, ["Neon"] = 248.07, ["Neon|Ride"] = 83.12, ["Neon|Fly|Ride"] = 210, ["Mega"] = 948.64, ["Mega|Ride"] = 934.42, ["Mega|Fly|Ride"] = 623.33}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 60.36, ["Fly"] = 874.13, ["Neon"] = 183.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 328.13}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 41.14, ["Fly"] = 115.5, ["Ride"] = 84.42, ["Fly|Ride"] = 144.38, ["Neon"] = 290.07, ["Neon|Ride"] = 337.67, ["Neon|Fly|Ride"] = 337.67, ["Mega|Ride"] = 1651.57, ["Mega|Fly|Ride"] = 1546.93}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 65.62, ["Fly"] = 126.1, ["Ride"] = 102.22, ["Neon"] = 152.12, ["Neon|Ride"] = 218.45, ["Neon|Fly|Ride"] = 203.24, ["Mega"] = 629.44, ["Mega|Ride"] = 633.12, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 24.93, ["Ride"] = 65.62, ["Neon"] = 211.03, ["Neon|Ride"] = 252, ["Mega"] = 675.34, ["Mega|Ride"] = 699.61, ["Mega|Fly|Ride"] = 1265.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 6.02, ["Ride"] = 27.43, ["Fly|Ride"] = 84.42, ["Neon"] = 41.95, ["Neon|Fly"] = 168.83, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 224.44, ["Mega"] = 485.4, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 343.77}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 28.5, ["Ride"] = 15.74, ["Fly|Ride"] = 41.15, ["Neon"] = 4.24, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 72.43, ["Mega"] = 45.94, ["Mega|Ride"] = 86.54, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1311.19}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 23.6, ["Ride"] = 78.28, ["Fly|Ride"] = 262.5, ["Neon"] = 93.58, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 315.52, ["Mega"] = 563.49, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 394.33}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 56.48, ["Neon"] = 3.94, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 293.86, ["Mega"] = 32.82, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 217.88}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.32, ["Ride"] = 82.31, ["Fly|Ride"] = 281.72, ["Neon"] = 64.32, ["Neon|Ride"] = 414.74, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 703.83, ["Mega|Ride"] = 620.47, ["Mega|Fly|Ride"] = 631.02}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Mega"] = 18.31}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 4.6, ["Neon|Ride"] = 87.63, ["Mega"] = 23.62, ["Mega|Ride"] = 126.65, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 104.99, ["Ride"] = 162.74, ["Fly|Ride"] = 343.96, ["Neon"] = 589.03, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 619.5, ["Mega|Ride"] = 6424.04, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 3.93, ["Fly"] = 65.63, ["Ride"] = 23.62, ["Neon"] = 10.5, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.54, ["Mega"] = 107.58, ["Mega|Ride"] = 156.53, ["Mega|Fly|Ride"] = 452.04}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.92, ["Fly|Ride"] = 65.63, ["Neon"] = 6.06, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 419.99, ["Mega"] = 34.94, ["Mega|Ride"] = 125.57}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 31.56, ["Neon"] = 3.93, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 35.44, ["Mega"] = 31.49, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 91.88, ["Neon"] = 5.24, ["Neon|Ride"] = 21, ["Mega"] = 28.88, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 31.44, ["Ride"] = 91.88, ["Fly|Ride"] = 623.76, ["Neon"] = 352.41, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 1245.39}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.61, ["Ride"] = 129.31, ["Fly|Ride"] = 78.28, ["Neon"] = 18.38, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 281.75, ["Mega"] = 140.6, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 465.35}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 300.57, ["Ride"] = 408.83, ["Fly|Ride"] = 606.3, ["Neon"] = 1769.62, ["Neon|Ride"] = 1160.73, ["Neon|Fly|Ride"] = 1170.75, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 68.25}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 36.75}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 30.39}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 19.66}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 42.47}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 7.85}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 3.93}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 216.56}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 254.63}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.93}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 15.74}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 501.04}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 690.11}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 12.58}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1064.44}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 226.21}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 10.5}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.55}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.63}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 50.11}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 59.06}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.08}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 22.19}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 7.87}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.75}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.94}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1259.99}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 111.57}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 280.35}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.89}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.22}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 11.61}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 180.46}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 105}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.49}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 19.81}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 199.91}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 13.06}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.57}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 12.69}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 7.07}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 140.28}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 19.67}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.54}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 19.62}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 9.85}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 196.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.92}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 19.67}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 115.74}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 91.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.06}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 15.47}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 26.25}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 64.3}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 26.24}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22195.09}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 42.23}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 139.12}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 25.74}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 74.08}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 119.44}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 86.45}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 36.74}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 49.62}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 170.63}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.34}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.43}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 6.45}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.49}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 44.62}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.86}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 5.24}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 6.56}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 582.9}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.44}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 262.5}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 28.55}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 42}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.8}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 82.69}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 28.62}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 4.99}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.11}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.05}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 3.93}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.82}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.61}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.68}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.92}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 12.68}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 189.74}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 36.75}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 205.78}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.21}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 7.96}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 52.5}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 12.7}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 90.2}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 9.16}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.18}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 11.79}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.79}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 95.64}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 36.36}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.87}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.1}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.02}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.02}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 8.33}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 630}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.73}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.33}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.87}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 4.85}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7365.25}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.07}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.45}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 5.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.69}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 26.19}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.16}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 5.25}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 14.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 117.13}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.56}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 7.16}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.9}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 4.96}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 4.97}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 3.62}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4220.77}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.39}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 36.75}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.7}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.36}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.67}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 182.28}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 4.24}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 3.94}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.5}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.63}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.15}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 9.93}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 22.28}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.54}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.44}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.49}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.23}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.18}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 8.67}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 4.51}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.05}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.23}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 3.6}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.6}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.33}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.84}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.51}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.44}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 111.57}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 31.01}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1086.86}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 15.67}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 4.23}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 28.82}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 3.66}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.35}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 31.6}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.44}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 3.67}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.7}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 15.74}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.68}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 10.85}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.46}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 9.18}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 14.55}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.05}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 420}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 230.73}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 2.1}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 25.92}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.96}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 95.6}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.3}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 6.34}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 4.66}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.03}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 4.66}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.05}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 8.82}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.68}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 86.63}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1102.5}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 169.31}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.25}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 10.49}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.66}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.24}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 65.6}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 6.48}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.05}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.59}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.36}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 10.44}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 52.03}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.62}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 54.74}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.45}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 22.29}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 98.44}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.37}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.6}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.28}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 55.6}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.49}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.94}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 7.34}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 77.1}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 27.41}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 86.63}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 315}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 47.25}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 104.13}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.37}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 10.49}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 72.07}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 15.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.11}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 13.12}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.55}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 19.66}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 7.87}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.93}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 31.49}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 32.82}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.15}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.24}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.92}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 39.31}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 19.69}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1378.13}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.46}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 249.22}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 27.02}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.37}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.19}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.93}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 72.44}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 72.44}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 8.01}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 70.23}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 105.98}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 84}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.85}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1057.4}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 525}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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