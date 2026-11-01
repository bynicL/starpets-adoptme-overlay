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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 945.68, ["Ride"] = 985.97, ["Fly|Ride"] = 1050, ["Neon"] = 6492.91, ["Neon|Ride"] = 3012.95, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24648.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 494.81, ["Fly"] = 551.25, ["Ride"] = 458.06, ["Fly|Ride"] = 548.39, ["Neon|Fly|Ride"] = 2464.59, ["Mega"] = 10269.05}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5381.25, ["Ride"] = 5066.25, ["Fly|Ride"] = 4374.57, ["Neon|Fly|Ride"] = 19854.17, ["Mega|Fly|Ride"] = 68469.15}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 183.75, ["Fly|Ride"] = 294.74, ["Neon"] = 773.36, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1095.72, ["Mega"] = 4107.64, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 493.66, ["Fly"] = 821.64, ["Ride"] = 551.25, ["Fly|Ride"] = 580.13, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1613.2, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.07, ["Ride"] = 27.57, ["Fly|Ride"] = 152, ["Neon"] = 72.19, ["Neon|Ride"] = 77.7, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 33.67, ["Ride"] = 30.82, ["Fly|Ride"] = 57.75, ["Neon"] = 32.82, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 54.79, ["Neon|Fly|Ride"] = 112.03, ["Mega"] = 130.54, ["Mega|Fly"] = 271.32, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 130.45, ["Ride"] = 163.31, ["Fly|Ride"] = 231, ["Neon"] = 554.54, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 463.8, ["Mega"] = 1417.15, ["Mega|Fly|Ride"] = 2636.41}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.11, ["Fly"] = 55.47, ["Ride"] = 45.94, ["Fly|Ride"] = 96.25, ["Neon"] = 249.38, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 1369.91, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1237.3}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.71, ["Fly"] = 48.87, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 192.05, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1334.12, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.11, ["Fly"] = 206.07, ["Ride"] = 72.19, ["Fly|Ride"] = 137.62, ["Neon"] = 410.78, ["Neon|Fly"] = 408.73, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1575.49}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 55.47}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 335.85, ["Fly"] = 369.74, ["Ride"] = 357, ["Fly|Ride"] = 387.45, ["Neon"] = 1369.91, ["Neon|Ride"] = 1260.33, ["Neon|Fly|Ride"] = 1092.69, ["Mega|Fly|Ride"] = 4779.83}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 135.59, ["Ride"] = 89.14, ["Fly|Ride"] = 178.58, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2627.64}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.02, ["Ride"] = 51.85, ["Fly|Ride"] = 205.4, ["Neon"] = 27.75, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 144.38, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 383.84}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 122.85, ["Fly"] = 144.38, ["Ride"] = 153.57, ["Fly|Ride"] = 218.15, ["Neon"] = 927.57, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.93, ["Fly"] = 26.67, ["Ride"] = 20.99, ["Fly|Ride"] = 46.93, ["Neon"] = 27.57, ["Neon|Ride"] = 90.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 78.75, ["Fly"] = 262.5, ["Ride"] = 133.06, ["Fly|Ride"] = 280.6, ["Neon"] = 343.01, ["Neon|Fly"] = 463.8, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1493.14, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 45.21, ["Ride"] = 96.56, ["Fly|Ride"] = 255.29, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.37, ["Fly"] = 34.49, ["Ride"] = 52.5, ["Fly|Ride"] = 223.13, ["Neon"] = 203.34, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 246.47, ["Mega"] = 2666.74, ["Mega|Ride"] = 573.11, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 42.82, ["Fly"] = 124.69, ["Ride"] = 54.99, ["Fly|Ride"] = 103.69, ["Neon"] = 238.92, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1623.24, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 34.13, ["Fly"] = 274.23, ["Ride"] = 124.09, ["Fly|Ride"] = 136.5, ["Neon"] = 143.07, ["Neon|Fly"] = 384.95, ["Neon|Ride"] = 270.1, ["Neon|Fly|Ride"] = 306.04, ["Mega"] = 1967.44, ["Mega|Ride"] = 1228.35, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.38, ["Ride"] = 40.07, ["Fly|Ride"] = 131.25, ["Neon"] = 343, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.13, ["Mega|Ride"] = 2052.02, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 44.63, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Fly|Ride"] = 146.1, ["Neon"] = 210, ["Neon|Fly"] = 549.41, ["Neon|Ride"] = 294.52, ["Neon|Fly|Ride"] = 367.38, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.91, ["Fly"] = 32.82, ["Ride"] = 22.05, ["Fly|Ride"] = 53.82, ["Neon"] = 27.74, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.79, ["Neon|Fly|Ride"] = 91.86, ["Mega"] = 145.69, ["Mega|Fly"] = 22427.05, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 298.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 394.2, ["Fly|Ride"] = 442.32, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7077}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.42, ["Ride"] = 26.25, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 418.99, ["Mega|Fly|Ride"] = 912.02}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.72, ["Fly"] = 39.87, ["Ride"] = 21.61, ["Fly|Ride"] = 53.59, ["Neon"] = 51.06, ["Neon|Fly"] = 90.38, ["Neon|Ride"] = 80.12, ["Neon|Fly|Ride"] = 123.24, ["Mega|Fly"] = 315.28, ["Mega|Ride"] = 619.24, ["Mega|Fly|Ride"] = 383.6}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 130.45, ["Fly"] = 108.94, ["Ride"] = 102.73, ["Fly|Ride"] = 123.3, ["Neon|Fly"] = 452.88, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2049.72, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.42, ["Ride"] = 27.83, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 695.68, ["Mega|Ride"] = 779.54, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 215.7, ["Fly"] = 347.16, ["Ride"] = 238.71, ["Fly|Ride"] = 259.88, ["Neon"] = 695.68, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 890.33, ["Mega"] = 6161.44, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2865.43}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 35.96}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.77, ["Fly"] = 35.96, ["Ride"] = 22.61, ["Fly|Ride"] = 64.32, ["Neon"] = 22.32, ["Neon|Fly"] = 4879.62, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.79, ["Mega"] = 157.5, ["Mega|Fly"] = 343, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 278.32}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1050, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1312.5, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52181.51, ["Mega|Fly|Ride"] = 25881.21}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.49, ["Fly"] = 67.8, ["Ride"] = 32.8, ["Fly|Ride"] = 131.25, ["Neon"] = 77.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 217.72, ["Mega"] = 508.33, ["Mega|Ride"] = 657.32, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 115.4, ["Ride"] = 152.25, ["Fly|Ride"] = 249.38, ["Neon"] = 890.33, ["Neon|Ride"] = 752.2, ["Neon|Fly|Ride"] = 794.83, ["Mega|Ride"] = 2916.79, ["Mega|Fly|Ride"] = 2602.51}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.6, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 137.62, ["Neon"] = 81.34, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 287.57, ["Mega"] = 670.9, ["Mega|Ride"] = 1083.08, ["Mega|Fly|Ride"] = 727.08}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.97, ["Ride"] = 105, ["Fly|Ride"] = 196.88, ["Neon"] = 584.07, ["Neon|Ride"] = 508.33, ["Neon|Fly|Ride"] = 697.28, ["Mega|Fly|Ride"] = 2054.08}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 111.06, ["Ride"] = 152.25, ["Fly|Ride"] = 194.25, ["Neon"] = 431.31, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1778.84}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.18, ["Fly"] = 59.16, ["Ride"] = 52.17, ["Fly|Ride"] = 77.87, ["Neon"] = 616.17, ["Neon|Ride"] = 394.23, ["Neon|Fly|Ride"] = 292.48, ["Mega"] = 4107.64, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.19, ["Ride"] = 35.96, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 231.07, ["Mega"] = 166.07, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 271.16, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 380.63, ["Fly"] = 426.57, ["Ride"] = 457.25, ["Fly|Ride"] = 498.33, ["Neon|Ride"] = 1700.92, ["Neon|Fly|Ride"] = 1466.42, ["Mega|Fly|Ride"] = 6273.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 103.69, ["Fly"] = 131.25, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon"] = 446.25, ["Neon|Ride"] = 486.76, ["Neon|Fly|Ride"] = 520.66, ["Mega|Ride"] = 2451.53, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3710.7, ["Ride"] = 3433.5, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14375.65}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 40.95, ["Fly"] = 108.88, ["Ride"] = 57.75, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 302.95, ["Mega|Ride"] = 1179.05, ["Mega|Fly|Ride"] = 1368.02}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 61.76, ["Ride"] = 68.25, ["Fly|Ride"] = 195.57, ["Neon"] = 578.59, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 684.96, ["Mega"] = 2328.01, ["Mega|Fly|Ride"] = 1211.07}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 34.93, ["Fly"] = 48.28, ["Ride"] = 60.37, ["Fly|Ride"] = 124.69, ["Neon"] = 160.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.72, ["Mega"] = 2625, ["Mega|Ride"] = 821, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.24}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.94, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 542.22, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.21, ["Ride"] = 219.8, ["Fly|Ride"] = 246.47, ["Neon|Ride"] = 1369.91, ["Neon|Fly|Ride"] = 2224.22, ["Mega|Fly|Ride"] = 4947.98}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 938.44, ["Fly|Ride"] = 1045.8, ["Neon|Ride"] = 3556.03, ["Neon|Fly|Ride"] = 3536.32, ["Mega|Fly|Ride"] = 15405.49}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.42, ["Fly"] = 62.63, ["Ride"] = 38.97, ["Fly|Ride"] = 68.81, ["Neon"] = 178.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 862.72, ["Mega|Fly|Ride"] = 869.71}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 12.68}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6285.44, ["Ride"] = 5478.21, ["Fly|Ride"] = 4588.5, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 32182.05}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.5, ["Fly"] = 74.69, ["Ride"] = 27.74, ["Fly|Ride"] = 39.38, ["Neon"] = 97.34, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 634.24, ["Mega|Ride"] = 685.05, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 8.9, ["Fly"] = 41.1, ["Ride"] = 35.44, ["Fly|Ride"] = 109.89, ["Neon"] = 111.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 244.42, ["Mega"] = 1031.91, ["Mega|Ride"] = 501.21, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.5, ["Fly"] = 252.61, ["Ride"] = 91.86, ["Fly|Ride"] = 72.19, ["Neon"] = 1369.91, ["Neon|Fly|Ride"] = 927.57, ["Mega"] = 4107.64}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.81, ["Ride"] = 27.57, ["Fly|Ride"] = 106.81, ["Neon"] = 93.19, ["Neon|Ride"] = 63.68, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 479.07, ["Mega|Ride"] = 466.29, ["Mega|Fly|Ride"] = 619.24}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 2191.7, ["Fly|Ride"] = 2047.5, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 28620.31, ["Fly|Ride"] = 23921.99, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 67775.67, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.42, ["Fly"] = 157.5, ["Ride"] = 49.87, ["Fly|Ride"] = 89.93, ["Neon"] = 134.93, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 821.55, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.13, ["Fly"] = 48.28, ["Ride"] = 45.93, ["Fly|Ride"] = 183.75, ["Neon"] = 17.06, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 147.94, ["Mega"] = 128.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 38.97}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 36.75, ["Fly|Ride"] = 111.57, ["Neon"] = 52.5, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 343, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 739.48, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon"] = 2938.05, ["Neon|Ride"] = 2898.62, ["Neon|Fly|Ride"] = 2585.58, ["Mega|Fly|Ride"] = 10823.61}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 857.46, ["Fly|Ride"] = 892.5, ["Neon"] = 4107.64, ["Neon|Ride"] = 3355.45, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11206.99}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 22.61, ["Fly"] = 115.98, ["Ride"] = 41.77, ["Fly|Ride"] = 98.44, ["Neon"] = 101.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 1027.05, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.87}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.72, ["Fly"] = 93.19, ["Ride"] = 82.35, ["Fly|Ride"] = 129.7, ["Neon|Ride"] = 384.08, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 2010.94, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.6, ["Ride"] = 63.66, ["Fly|Ride"] = 228.38, ["Neon"] = 328.63, ["Neon|Fly"] = 527.84, ["Neon|Ride"] = 390.24, ["Neon|Fly|Ride"] = 491.57, ["Mega"] = 1725.22, ["Mega|Fly|Ride"] = 1713.1}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.25, ["Fly"] = 47.25, ["Ride"] = 20, ["Fly|Ride"] = 68.81, ["Neon"] = 39.38, ["Neon|Fly"] = 525, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 236.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 98.44, ["Fly"] = 126, ["Ride"] = 118.13, ["Fly|Ride"] = 152.25, ["Neon"] = 504.23, ["Neon|Ride"] = 422.63, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 1424.06}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.49, ["Ride"] = 26.25, ["Fly|Ride"] = 97.12, ["Neon"] = 45.2, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 207.38, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.42, ["Fly"] = 40.28, ["Ride"] = 33.64, ["Fly|Ride"] = 97.57, ["Neon"] = 102.71, ["Neon|Fly"] = 102.71, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 171.61, ["Mega"] = 726.03, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 62.63, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 164.33, ["Mega"] = 694.25, ["Mega|Ride"] = 773.47, ["Mega|Fly|Ride"] = 862.72}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.13, ["Fly"] = 130.79, ["Ride"] = 34.93, ["Fly|Ride"] = 68.82, ["Neon"] = 91.88, ["Neon|Fly"] = 548.39, ["Neon|Ride"] = 106.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 819.48, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6708.59, ["Fly"] = 6847.23, ["Ride"] = 7141.32, ["Fly|Ride"] = 5222.44, ["Neon"] = 30807.13, ["Neon|Fly|Ride"] = 27110.28}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.25, ["Fly"] = 246.51, ["Ride"] = 219.8, ["Fly|Ride"] = 282.19, ["Neon"] = 773.36, ["Neon|Ride"] = 695.68, ["Neon|Fly|Ride"] = 590.61, ["Mega|Ride"] = 5478.21, ["Mega|Fly|Ride"] = 2093.12}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.43, ["Fly"] = 136.67, ["Ride"] = 65.63, ["Fly|Ride"] = 136.05, ["Neon"] = 104.98, ["Neon|Fly"] = 182.8, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 380.07, ["Mega|Fly"] = 548.39, ["Mega|Ride"] = 367.49, ["Mega|Fly|Ride"] = 468.89}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.91, ["Ride"] = 20.56, ["Fly|Ride"] = 96.55, ["Neon"] = 22.1, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 186.9, ["Mega"] = 499.8, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 37.68, ["Fly"] = 5256.43, ["Ride"] = 95.57, ["Fly|Ride"] = 131.25, ["Neon"] = 144.38, ["Neon|Fly"] = 326.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 309.59, ["Mega"] = 429.52, ["Mega|Ride"] = 508.39, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13833.75, ["Ride"] = 12468.75, ["Fly|Ride"] = 11878.13, ["Neon|Fly|Ride"] = 26744.9}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 177.19, ["Fly"] = 274.23, ["Ride"] = 218.51, ["Fly|Ride"] = 233.63, ["Neon"] = 1406.88, ["Neon|Ride"] = 1437.69, ["Neon|Fly|Ride"] = 1465.41, ["Mega|Fly|Ride"] = 4641.17}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 58.56, ["Fly"] = 119.02, ["Ride"] = 32.82, ["Fly|Ride"] = 113.64, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 381.94, ["Mega|Fly|Ride"] = 2312.89}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.24, ["Fly"] = 28.53, ["Ride"] = 20.55, ["Fly|Ride"] = 59.57, ["Neon"] = 76.13, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2464.59, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 487.05, ["Ride"] = 380.63, ["Fly|Ride"] = 472.5, ["Neon"] = 1639.32, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4936.31}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.56, ["Ride"] = 36.75, ["Neon"] = 30.17, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 216.83, ["Mega"] = 129.94, ["Mega|Ride"] = 172.31, ["Mega|Fly|Ride"] = 302.99}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 274.22, ["Fly"] = 217.74, ["Ride"] = 308.19, ["Fly|Ride"] = 343, ["Neon"] = 665.45, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 5478.21}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13, ["Fly"] = 17.41, ["Ride"] = 17.07, ["Fly|Ride"] = 35.04, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 2464.59, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.65}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 52.5, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 326.57, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1129.62, ["Mega|Ride"] = 1232.45, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 65.63, ["Ride"] = 39.37, ["Fly|Ride"] = 86.51, ["Neon"] = 82.17, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 508.33, ["Mega|Ride"] = 614.18, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 27.75, ["Fly"] = 111.57, ["Ride"] = 90.98, ["Fly|Ride"] = 309.59, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 821.55, ["Mega|Ride"] = 919.21, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.2, ["Neon"] = 21.65, ["Neon|Ride"] = 104.36, ["Neon|Fly|Ride"] = 240.32, ["Mega"] = 129.94, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.72, ["Fly"] = 44.63, ["Ride"] = 27.75, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 217.72, ["Mega|Ride"] = 534.08, ["Mega|Fly|Ride"] = 801.1}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 315.17, ["Ride"] = 384.23, ["Fly|Ride"] = 409.89, ["Neon|Fly|Ride"] = 2602.19, ["Mega|Fly|Ride"] = 8627.08}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.41, ["Fly"] = 102.72, ["Ride"] = 45.94, ["Fly|Ride"] = 103.67, ["Neon"] = 184.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 233.12, ["Mega"] = 710.63, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 42, ["Fly"] = 92.59, ["Ride"] = 68.83, ["Fly|Ride"] = 137.82, ["Neon"] = 452.88, ["Neon|Ride"] = 226.94, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.48, ["Fly"] = 78.75, ["Ride"] = 65.63, ["Fly|Ride"] = 143.79, ["Neon"] = 126, ["Neon|Ride"] = 178.69, ["Neon|Fly|Ride"] = 308.1, ["Mega"] = 367.5, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 449.18}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8616.44, ["Ride"] = 9995.9, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 15499.29, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1739.4, ["Ride"] = 1509.38, ["Fly|Ride"] = 1537.11, ["Neon|Fly|Ride"] = 3990, ["Mega"] = 21907.98, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 479.07, ["Ride"] = 452.93, ["Fly|Ride"] = 525, ["Neon"] = 2259.21, ["Neon|Fly|Ride"] = 2191.43, ["Mega|Fly|Ride"] = 6666.49}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.41, ["Fly"] = 23.62, ["Ride"] = 22.32, ["Fly|Ride"] = 46.39, ["Neon"] = 108.78, ["Neon|Ride"] = 108.87, ["Neon|Fly|Ride"] = 164.33, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.3, ["Fly"] = 78.74, ["Ride"] = 164.34, ["Fly|Ride"] = 123.24, ["Neon"] = 27.75, ["Neon|Ride"] = 67.78, ["Neon|Fly|Ride"] = 147, ["Mega"] = 164.33, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.1, ["Fly"] = 55.47, ["Ride"] = 45.93, ["Fly|Ride"] = 103.05, ["Neon"] = 271.11, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 173.25, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.86, ["Fly"] = 23.12, ["Ride"] = 15.75, ["Fly|Ride"] = 44.63, ["Neon"] = 25.77, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 262.5, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 288.75, ["Fly"] = 320.25, ["Ride"] = 333.24, ["Fly|Ride"] = 369.7, ["Neon"] = 1175.72, ["Neon|Ride"] = 1308.28, ["Neon|Fly|Ride"] = 1210.13}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 60.09, ["Ride"] = 40.51, ["Fly|Ride"] = 59.07, ["Neon"] = 139.71, ["Neon|Fly"] = 410.78, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.83, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 26.61, ["Ride"] = 21.17, ["Fly|Ride"] = 43.14, ["Neon"] = 82.17, ["Neon|Fly"] = 132.2, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 546.18, ["Fly"] = 787.5, ["Ride"] = 409.9, ["Fly|Ride"] = 643.89, ["Neon|Ride"] = 2771.64, ["Neon|Fly|Ride"] = 2318.91, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1391.52, ["Ride"] = 1205.75, ["Fly|Ride"] = 1245.57, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 154612.63}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 92.77, ["Fly"] = 123.26, ["Ride"] = 91.88, ["Fly|Ride"] = 109.91, ["Neon"] = 513.47, ["Neon|Ride"] = 1712.9, ["Neon|Fly|Ride"] = 463.8, ["Mega|Ride"] = 2328.3, ["Mega|Fly|Ride"] = 3867.25}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 182.44, ["Fly"] = 164.34, ["Ride"] = 190.43, ["Fly|Ride"] = 240.19, ["Neon"] = 556.49, ["Neon|Ride"] = 684.96, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2474.57}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.57, ["Ride"] = 42, ["Fly|Ride"] = 274.2, ["Neon"] = 232.74, ["Neon|Fly"] = 410.78, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega"] = 656.25, ["Mega|Ride"] = 1855.35, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 205.42, ["Fly|Ride"] = 410.78, ["Neon|Fly|Ride"] = 1298.59, ["Mega|Fly|Ride"] = 4020.31}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1796.6, ["Ride"] = 2474.57, ["Fly|Ride"] = 2129.65, ["Neon|Fly|Ride"] = 8215.25, ["Mega|Fly|Ride"] = 24738.68}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.48, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 349.16, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1918.27, ["Mega|Ride"] = 2259.48, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 794.94, ["Ride"] = 611.37, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1506.48, ["Neon|Fly|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 3106.44}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 41.1, ["Fly"] = 61.64, ["Ride"] = 51.97, ["Fly|Ride"] = 108.93, ["Neon"] = 328.63, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1164.66}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.15, ["Fly"] = 31.63, ["Ride"] = 22.63, ["Fly|Ride"] = 55.67, ["Neon"] = 27.57, ["Neon|Fly"] = 80.56, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 513.47, ["Mega|Fly"] = 338.89, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 250.69}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 43.17, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 478.55, ["Neon|Fly|Ride"] = 619.16, ["Mega|Ride"] = 1370.08, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.37, ["Fly"] = 899.07, ["Ride"] = 716.62, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2420.94, ["Neon|Fly|Ride"] = 2083.72, ["Mega|Fly|Ride"] = 7655.51}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.49, ["Ride"] = 643.13, ["Fly|Ride"] = 866.25, ["Neon"] = 5134.53, ["Neon|Fly|Ride"] = 3245.03, ["Mega|Fly|Ride"] = 12324.39}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.13, ["Fly"] = 25.97, ["Ride"] = 23.21, ["Fly|Ride"] = 44.89, ["Neon"] = 205.4, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 137.62, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.38, ["Ride"] = 23.38, ["Fly|Ride"] = 63.07, ["Neon"] = 72.19, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 959.14, ["Mega|Ride"] = 440.66, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.19, ["Ride"] = 26.69, ["Fly|Ride"] = 111.45, ["Neon"] = 21.84, ["Neon|Fly"] = 309.59, ["Neon|Ride"] = 51.76, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 152.66, ["Mega|Ride"] = 238.62, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.05, ["Fly"] = 68.82, ["Ride"] = 56.44, ["Fly|Ride"] = 94.48, ["Neon"] = 287.55, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 205.4, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 32.82, ["Ride"] = 102.72, ["Fly|Ride"] = 449.61, ["Neon"] = 410.78, ["Neon|Ride"] = 486.76, ["Neon|Fly|Ride"] = 684.96, ["Mega|Fly|Ride"] = 1363.91}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.57, ["Fly"] = 48.57, ["Ride"] = 36.61, ["Fly|Ride"] = 92.77, ["Neon"] = 102.38, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 201.16, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.19, ["Fly"] = 68.82, ["Ride"] = 44.35, ["Fly|Ride"] = 93.19, ["Neon"] = 196.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.89, ["Fly"] = 27.75, ["Ride"] = 19.69, ["Fly|Ride"] = 40.69, ["Neon"] = 34.29, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 96.55, ["Mega"] = 525, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 340.99}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.12, ["Fly"] = 32.48, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 24.69, ["Neon|Fly"] = 82.17, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.33, ["Mega"] = 416.07, ["Mega|Fly"] = 466.23, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 513.54}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.44, ["Fly"] = 65.61, ["Ride"] = 51.14, ["Fly|Ride"] = 84.42, ["Neon"] = 402.34, ["Neon|Ride"] = 273.17, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1816.49, ["Fly"] = 1918.51, ["Ride"] = 1606.05, ["Fly|Ride"] = 1715.66, ["Neon|Fly"] = 4927.64, ["Neon|Ride"] = 4628.27, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 16545.03}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 547.46, ["Ride"] = 472.03, ["Fly|Ride"] = 566.57, ["Neon"] = 3092.24, ["Neon|Ride"] = 2567.28, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 9580.17}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 255.75, ["Fly"] = 348.18, ["Ride"] = 304.5, ["Fly|Ride"] = 476.56, ["Neon"] = 1506.48, ["Neon|Ride"] = 1410.98, ["Neon|Fly|Ride"] = 1370.42, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.49, ["Ride"] = 47.25, ["Fly|Ride"] = 96.55, ["Neon"] = 328.63, ["Neon|Fly"] = 410.78, ["Neon|Ride"] = 343, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 904.72, ["Mega|Ride"] = 821.64, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41081.29, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 16406.25, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 396.38, ["Fly"] = 410.83, ["Ride"] = 410.83, ["Fly|Ride"] = 410.78, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1296.75, ["Mega"] = 6161.44, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 155.4, ["Fly"] = 525, ["Ride"] = 136.49, ["Fly|Ride"] = 155.38, ["Mega|Fly|Ride"] = 4108.14}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.59, ["Fly"] = 262.5, ["Ride"] = 131.04, ["Fly|Ride"] = 213.41, ["Neon"] = 512.44, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 549.94, ["Mega|Fly|Ride"] = 2463.86}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.75, ["Fly"] = 94.5, ["Ride"] = 39.04, ["Fly|Ride"] = 98.48, ["Neon"] = 274.2, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 683.93, ["Mega|Ride"] = 540.23}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4825.01, ["Ride"] = 4872.26, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 17800.37, ["Neon|Fly|Ride"] = 17115.42, ["Mega|Fly|Ride"] = 57513.81}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 96.56, ["Ride"] = 39.04, ["Fly|Ride"] = 54.52, ["Neon"] = 333.94, ["Neon|Ride"] = 231.91, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1095.72, ["Mega|Fly|Ride"] = 856.95}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.21, ["Fly"] = 137.64, ["Ride"] = 45.94, ["Fly|Ride"] = 107.62, ["Neon"] = 393.75, ["Neon|Fly"] = 1369.91, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1546.71, ["Mega|Fly|Ride"] = 1300.23}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 623.44, ["Fly"] = 866.23, ["Ride"] = 656.25, ["Fly|Ride"] = 761.25, ["Neon"] = 1808.63, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 6025.62, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.06, ["Fly"] = 27.75, ["Ride"] = 23.39, ["Fly|Ride"] = 52.49, ["Neon"] = 124.69, ["Neon|Fly"] = 155.38, ["Neon|Ride"] = 105.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 587.86, ["Mega|Ride"] = 582.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.41, ["Fly"] = 82.18, ["Ride"] = 26.72, ["Fly|Ride"] = 484.72, ["Neon"] = 77.7, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.72, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.76, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 527.71, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 646.96, ["Mega"] = 1986.05, ["Mega|Fly|Ride"] = 2177.33}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 27.75, ["Ride"] = 89.36, ["Fly|Ride"] = 138.65, ["Neon"] = 77.44, ["Neon|Ride"] = 129.42, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 304.96, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Fly"] = 5031.45, ["Ride"] = 3675, ["Fly|Ride"] = 3675, ["Neon"] = 12322.86, ["Neon|Ride"] = 11468.48, ["Neon|Fly|Ride"] = 8726.41, ["Mega"] = 43017.01, ["Mega|Fly|Ride"] = 33088.88}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 45.94, ["Ride"] = 64.3, ["Fly|Ride"] = 135.95, ["Neon"] = 219.77, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 306.04, ["Mega|Ride"] = 1027.05, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7804.13, ["Fly|Ride"] = 6276.38, ["Neon|Fly|Ride"] = 16430.48, ["Mega|Fly|Ride"] = 64361.03}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.8, ["Fly"] = 20.55, ["Ride"] = 17.07, ["Fly|Ride"] = 35.96, ["Neon"] = 24.94, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 448.71, ["Mega|Ride"] = 199.26, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 27.42, ["Ride"] = 30.19, ["Fly|Ride"] = 55.47, ["Neon"] = 109.89, ["Neon|Ride"] = 163.29, ["Neon|Fly|Ride"] = 178.69, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 816.37}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 14.32, ["Ride"] = 31.32, ["Fly|Ride"] = 116.02, ["Neon"] = 192.05, ["Neon|Ride"] = 152, ["Neon|Fly|Ride"] = 192.94, ["Mega|Ride"] = 957.21, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.35, ["Fly"] = 262.5, ["Ride"] = 56.12, ["Fly|Ride"] = 137.62, ["Neon"] = 182.43, ["Neon|Ride"] = 130.79, ["Neon|Fly|Ride"] = 252.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.44, ["Fly"] = 26.25, ["Ride"] = 23.15, ["Fly|Ride"] = 38.74, ["Neon"] = 82.17, ["Neon|Ride"] = 106.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2464.59, ["Mega|Ride"] = 578.66, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8764.71}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.15, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1026.92}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 22.32, ["Fly"] = 109.91, ["Ride"] = 63.7, ["Fly|Ride"] = 124.09, ["Neon"] = 119.21, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.69, ["Mega|Ride"] = 927.68, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 7.88}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.51, ["Ride"] = 34.93, ["Fly|Ride"] = 59.57, ["Neon"] = 49.31, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 123.24, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2686.69}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 144.38, ["Fly"] = 281.42, ["Ride"] = 175.88, ["Fly|Ride"] = 408.73, ["Neon"] = 712.69, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 2875.7, ["Mega|Fly|Ride"] = 3246.87}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 137.64, ["Ride"] = 192.07, ["Fly|Ride"] = 209.2, ["Neon"] = 682.5, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 1095.72, ["Mega"] = 2625, ["Mega|Ride"] = 3286.53, ["Mega|Fly|Ride"] = 3092.63}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 157.5, ["Fly"] = 149.63, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 4518.39, ["Mega|Fly|Ride"] = 3574.09}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1561.88, ["Fly"] = 2464.89, ["Ride"] = 1500.87, ["Fly|Ride"] = 1575, ["Neon"] = 6184.48, ["Neon|Ride"] = 5475.47, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 30922.77}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 80.13, ["Ride"] = 55.47, ["Fly|Ride"] = 93.47, ["Neon"] = 135.56, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 241.34, ["Mega"] = 927.57, ["Mega|Ride"] = 890.46, ["Mega|Fly|Ride"] = 1079.43}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 726.02, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 4019.81}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42.33}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.42, ["Ride"] = 31.32, ["Fly|Ride"] = 179.72, ["Neon"] = 98.44, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 273.17, ["Mega"] = 393.65, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.66, ["Fly"] = 48.28, ["Ride"] = 26.72, ["Fly|Ride"] = 94.79, ["Neon"] = 27.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 344.08, ["Mega|Fly|Ride"] = 619.24}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.42}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.69, ["Fly"] = 108.92, ["Ride"] = 31.27, ["Fly|Ride"] = 82.17, ["Neon"] = 196.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 787.5, ["Mega|Ride"] = 1237.3, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.21, ["Fly"] = 76.02, ["Ride"] = 32.82, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 217.98, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 935.69, ["Mega|Ride"] = 1739.4, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5906.25, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 4961.13, ["Neon|Fly|Ride"] = 10026.61, ["Mega|Fly|Ride"] = 28756.91}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.56, ["Fly"] = 40.69, ["Ride"] = 34.93, ["Fly|Ride"] = 59.57, ["Neon"] = 64.97, ["Neon|Ride"] = 77.81, ["Neon|Fly|Ride"] = 185.53, ["Mega"] = 519.45, ["Mega|Ride"] = 534.08, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.92, ["Fly"] = 155.4, ["Ride"] = 99.75, ["Fly|Ride"] = 188.99, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 658.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 62.99, ["Fly"] = 96.48, ["Ride"] = 105.8, ["Fly|Ride"] = 203.44, ["Neon"] = 196.88, ["Neon|Ride"] = 246.47, ["Neon|Fly|Ride"] = 463.89, ["Mega"] = 2318.91, ["Mega|Ride"] = 2773, ["Mega|Fly|Ride"] = 1314.62}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.94, ["Fly"] = 65.63, ["Ride"] = 29.93, ["Fly|Ride"] = 65.63, ["Neon"] = 131.45, ["Neon|Ride"] = 185.53, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 680.69, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.18, ["Fly"] = 57.2, ["Ride"] = 30.81, ["Fly|Ride"] = 82.69, ["Neon"] = 28.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.26, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 157.5, ["Mega|Fly"] = 309.59, ["Mega|Ride"] = 208.73, ["Mega|Fly|Ride"] = 281.5}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.44, ["Ride"] = 31.36, ["Fly|Ride"] = 102.38, ["Neon"] = 93.45, ["Neon|Ride"] = 122.22, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 479.58, ["Mega|Ride"] = 410.82, ["Mega|Fly|Ride"] = 546.39}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.69, ["Fly"] = 31.32, ["Ride"] = 24.94, ["Fly|Ride"] = 45.2, ["Neon"] = 203.34, ["Neon|Fly"] = 81.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 619.02}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 188.98}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.64, ["Ride"] = 96.86, ["Neon"] = 170.63, ["Neon|Fly|Ride"] = 301.47, ["Mega"] = 1325.75, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 192.07, ["Fly"] = 216.86, ["Ride"] = 387.32, ["Fly|Ride"] = 328.67, ["Neon"] = 1095.72}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 32.82, ["Fly"] = 212.01, ["Ride"] = 100.9, ["Fly|Ride"] = 233.12, ["Neon"] = 249.36, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 2141.77, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 888.57, ["Fly"] = 1118.24, ["Ride"] = 897.75, ["Fly|Ride"] = 829.49, ["Neon|Fly"] = 2666.74, ["Neon|Ride"] = 2558.91, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Fly"] = 463.84, ["Ride"] = 262.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1181.25, ["Neon|Ride"] = 2010.49, ["Neon|Fly|Ride"] = 1844.33, ["Mega"] = 8112.57, ["Mega|Fly|Ride"] = 6185.26}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 64.19}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.21, ["Fly"] = 27.57, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 77.95, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.57, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 437.26, ["Mega|Ride"] = 684.03, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 271.52, ["Fly"] = 762.36, ["Ride"] = 301.74, ["Fly|Ride"] = 387.19, ["Neon"] = 1079.3, ["Neon|Ride"] = 821.55, ["Neon|Fly|Ride"] = 934.87, ["Mega|Ride"] = 3587.78, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 20.99}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 149.63, ["Fly"] = 264.99, ["Ride"] = 203.43, ["Fly|Ride"] = 261.19, ["Neon"] = 748.13, ["Neon|Fly"] = 1643.07, ["Neon|Ride"] = 794.83, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 10269.05, ["Mega|Ride"] = 11683.52, ["Mega|Fly|Ride"] = 2822.3}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Fly"] = 192.07, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 671.61, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 924.23}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.72, ["Ride"] = 23.64, ["Fly|Ride"] = 137.62, ["Neon"] = 27.75, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 262.1, ["Mega|Ride"] = 356.4, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 16.63, ["Fly"] = 63, ["Ride"] = 29.28, ["Fly|Ride"] = 76.13, ["Neon"] = 211.56, ["Neon|Ride"] = 109.89, ["Neon|Fly|Ride"] = 255.39, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.18, ["Fly"] = 102.31, ["Ride"] = 45.94, ["Fly|Ride"] = 128.82, ["Neon"] = 129.94, ["Neon|Ride"] = 123.24, ["Neon|Fly|Ride"] = 254.68, ["Mega"] = 461.16, ["Mega|Ride"] = 459.95, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.08, ["Fly"] = 123.26, ["Ride"] = 41.1, ["Fly|Ride"] = 156.41, ["Neon"] = 23.21, ["Neon|Fly"] = 231.91, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 153.56, ["Mega|Ride"] = 175.84, ["Mega|Fly|Ride"] = 294.27}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 283.5, ["Ride"] = 288.74, ["Fly|Ride"] = 358.47, ["Neon"] = 1506.48, ["Neon|Ride"] = 1338.07, ["Neon|Fly|Ride"] = 1404.38, ["Mega|Fly|Ride"] = 5188.58}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 137.64, ["Fly"] = 1050, ["Ride"] = 177.19, ["Fly|Ride"] = 287.55, ["Neon"] = 682.5, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 721.88, ["Mega|Ride"] = 3971.55, ["Mega|Fly|Ride"] = 2294.25}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 90.64, ["Fly|Ride"] = 96.55, ["Neon"] = 358.32, ["Neon|Ride"] = 405.64, ["Neon|Fly|Ride"] = 452.88, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 115.97, ["Neon|Ride"] = 589.01, ["Neon|Fly|Ride"] = 479.58, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 1641.21}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Fly"] = 75.63, ["Ride"] = 41.1, ["Fly|Ride"] = 101.07, ["Neon"] = 77.44, ["Neon|Fly"] = 205.4, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 309.59, ["Mega|Fly"] = 525, ["Mega|Ride"] = 340.99, ["Mega|Fly|Ride"] = 433.71}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.93, ["Fly"] = 52.45, ["Ride"] = 22.61, ["Fly|Ride"] = 98.44, ["Neon"] = 21.99, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 109.89, ["Mega"] = 129.29, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 220.4}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1082.72, ["Ride"] = 918.75, ["Fly|Ride"] = 977.57, ["Neon"] = 3037.75, ["Neon|Fly"] = 3401.83, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 10050.17}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 381.05, ["Ride"] = 379.32, ["Fly|Ride"] = 481.26, ["Neon|Ride"] = 1918.27, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10269.05, ["Mega|Fly|Ride"] = 7924.59}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 78.75, ["Fly"] = 131.25, ["Ride"] = 96.55, ["Fly|Ride"] = 181.13, ["Neon"] = 262.5, ["Neon|Ride"] = 306.11, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 1576.86, ["Mega|Ride"] = 1485.1, ["Mega|Fly|Ride"] = 1532.35}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 339.97, ["Fly"] = 463.84, ["Ride"] = 296.87, ["Fly|Ride"] = 282.19, ["Neon"] = 1391.35, ["Neon|Ride"] = 1391.35, ["Neon|Fly|Ride"] = 1129.62, ["Mega"] = 10269.05, ["Mega|Fly|Ride"] = 5257.59}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.69, ["Fly"] = 137.64, ["Ride"] = 30.82, ["Fly|Ride"] = 63.68, ["Neon"] = 169.32, ["Neon|Ride"] = 128.71, ["Neon|Fly|Ride"] = 229.68, ["Mega|Ride"] = 695.77, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 218.3, ["Ride"] = 271.58, ["Fly|Ride"] = 548.39, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2360.87, ["Mega"] = 4087.38, ["Mega|Ride"] = 4245.76, ["Mega|Fly|Ride"] = 3766.14}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 60.37, ["Fly"] = 76.13, ["Ride"] = 55.47, ["Fly|Ride"] = 101.88, ["Neon|Ride"] = 492.94, ["Neon|Fly|Ride"] = 445.7, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Ride"] = 1351.87, ["Fly|Ride"] = 1509.38, ["Neon|Ride"] = 10822.26, ["Neon|Fly|Ride"] = 4518.39, ["Mega"] = 49291.4, ["Mega|Fly|Ride"] = 21908.66}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 15.75, ["Fly"] = 63, ["Ride"] = 35.44, ["Fly|Ride"] = 90.87, ["Neon"] = 62.77, ["Neon|Fly"] = 172.57, ["Neon|Ride"] = 94.49, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 310.01, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 425.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 42, ["Fly"] = 119.1, ["Ride"] = 82.18, ["Fly|Ride"] = 161.44, ["Neon"] = 274.2, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 817.43, ["Mega|Ride"] = 1005.48, ["Mega|Fly|Ride"] = 904.82}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.63, ["Fly"] = 82.29, ["Ride"] = 78.75, ["Fly|Ride"] = 102.38, ["Neon|Ride"] = 410.78, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1478.94}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3422.09, ["Fly"] = 1181.25, ["Ride"] = 1540.56, ["Fly|Ride"] = 1168.13, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 819.59, ["Ride"] = 410.83, ["Fly|Ride"] = 684.96, ["Neon"] = 1855.12, ["Neon|Fly|Ride"] = 2706.16, ["Mega|Fly|Ride"] = 13915.09}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 127.37, ["Fly"] = 309.63, ["Ride"] = 137.64, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 548.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 589.54, ["Mega"] = 4107.64, ["Mega|Ride"] = 2602.51, ["Mega|Fly|Ride"] = 1855.35}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.39, ["Ride"] = 22.51, ["Fly|Ride"] = 69.59, ["Neon"] = 67.27, ["Neon|Ride"] = 93.55, ["Neon|Fly|Ride"] = 176.65, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1150.29}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.61, ["Ride"] = 48.43, ["Fly|Ride"] = 122.73, ["Neon"] = 204.75, ["Neon|Fly"] = 409.75, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 754.62, ["Ride"] = 820.32, ["Fly|Ride"] = 853.13, ["Neon"] = 3010.9, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 154612.63}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5614.8, ["Ride"] = 5313.88, ["Fly|Ride"] = 4494, ["Neon"] = 42000, ["Neon|Ride"] = 29432.11, ["Neon|Fly|Ride"] = 21621.48, ["Mega|Fly|Ride"] = 87640.75}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 402.74, ["Ride"] = 219.8, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Ride"] = 1237.15, ["Neon|Fly|Ride"] = 1643.07, ["Mega"] = 5750.68, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 274.23, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 2053.83, ["Neon|Ride"] = 492.94, ["Neon|Fly|Ride"] = 959.14, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.95, ["Fly"] = 96.55, ["Ride"] = 34.13, ["Fly|Ride"] = 102.72, ["Neon"] = 147, ["Neon|Ride"] = 86.27, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 548.45, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.42, ["Fly"] = 39.38, ["Ride"] = 27.75, ["Fly|Ride"] = 51.19, ["Neon"] = 194.64, ["Neon|Fly"] = 274.2, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2177.33}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14, ["Fly"] = 274.23, ["Ride"] = 33.64, ["Fly|Ride"] = 91.87, ["Neon"] = 105, ["Neon|Ride"] = 155.08, ["Neon|Fly|Ride"] = 181.56, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.99, ["Fly"] = 55.47, ["Ride"] = 22.32, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Fly"] = 338.89, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 185.53, ["Mega"] = 178.5, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 302.99}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.93, ["Ride"] = 49.31, ["Fly|Ride"] = 183.75, ["Neon"] = 269.07, ["Neon|Fly"] = 821.55, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 695.68, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 801.1}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 318.44, ["Fly"] = 438.35, ["Ride"] = 341.25, ["Fly|Ride"] = 397.35, ["Neon|Ride"] = 1136.8, ["Neon|Fly|Ride"] = 951.57, ["Mega"] = 7875, ["Mega|Ride"] = 3697.33, ["Mega|Fly|Ride"] = 3609.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.14, ["Fly"] = 26.24, ["Ride"] = 15.27, ["Fly|Ride"] = 38.07, ["Neon"] = 26.69, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 69.3, ["Mega"] = 274.2, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 238.26}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 37.42, ["Fly"] = 109.91, ["Ride"] = 75.36, ["Fly|Ride"] = 131.24, ["Neon"] = 164.07, ["Neon|Fly"] = 387.19, ["Neon|Ride"] = 199.11, ["Neon|Fly|Ride"] = 254.67, ["Mega"] = 498.75, ["Mega|Fly"] = 821.55, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.46, ["Fly"] = 950.88, ["Ride"] = 771.65, ["Fly|Ride"] = 841.32, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1458.19, ["Mega|Fly|Ride"] = 3813.77}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 91.88, ["Ride"] = 42.78, ["Fly|Ride"] = 90.57, ["Neon"] = 178.69, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 274.23, ["Fly"] = 328.13, ["Ride"] = 288.75, ["Fly|Ride"] = 291.38, ["Neon|Fly|Ride"] = 1232.85, ["Mega|Fly|Ride"] = 6847.23}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 137.64, ["Fly"] = 155.4, ["Ride"] = 150.93, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 693.17, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 584.07, ["Ride"] = 603.74, ["Fly|Ride"] = 735, ["Neon|Ride"] = 2520.04, ["Neon|Fly|Ride"] = 2328.01, ["Mega|Fly|Ride"] = 8010.86}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.63, ["Ride"] = 40.05, ["Fly|Ride"] = 92.55, ["Neon"] = 108.87, ["Neon|Fly"] = 278.28, ["Neon|Ride"] = 128.71, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 306.04, ["Mega|Ride"] = 354.84, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3971.55, ["Ride"] = 3340.32, ["Fly|Ride"] = 3284.16, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 115.5, ["Fly"] = 105, ["Ride"] = 116.82, ["Fly|Ride"] = 146.99, ["Neon"] = 380.63, ["Neon|Ride"] = 508.33, ["Neon|Fly|Ride"] = 419.45, ["Mega|Fly|Ride"] = 2259.48}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.94, ["Fly"] = 26.25, ["Ride"] = 18.4, ["Fly|Ride"] = 64.32, ["Neon"] = 23.62, ["Neon|Fly"] = 82.17, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 194.65, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.56, ["Ride"] = 27.57, ["Fly|Ride"] = 82.69, ["Neon"] = 18, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 226.64}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.93, ["Fly"] = 152.02, ["Ride"] = 37.41, ["Fly|Ride"] = 59.07, ["Neon"] = 271.32, ["Neon|Ride"] = 287.55, ["Neon|Fly|Ride"] = 274.2, ["Mega|Fly|Ride"] = 1094.83}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1068.38, ["Ride"] = 1159.6, ["Fly|Ride"] = 1113}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6036.19, ["Ride"] = 6957.56, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.26, ["Fly"] = 31.4, ["Ride"] = 22.61, ["Fly|Ride"] = 49.31, ["Neon"] = 205.4, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 753.85}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.57, ["Fly"] = 45.88, ["Ride"] = 28.58, ["Fly|Ride"] = 89.24, ["Neon"] = 94.4, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 642.48, ["Mega|Ride"] = 630.61, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72, ["Fly"] = 88.34, ["Ride"] = 71.48, ["Fly|Ride"] = 111.56, ["Neon"] = 410.78, ["Neon|Ride"] = 375.67, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1643.07, ["Mega|Ride"] = 1787.05, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 205.42, ["Fly"] = 309.63, ["Ride"] = 210, ["Fly|Ride"] = 298.94, ["Neon|Ride"] = 1314.46, ["Neon|Fly|Ride"] = 951.04, ["Mega"] = 10269.05, ["Mega|Fly|Ride"] = 3697.33}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.15, ["Ride"] = 22.32, ["Fly|Ride"] = 86.63, ["Neon"] = 22.87, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.44, ["Mega"] = 158.82, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 190.32, ["Fly"] = 232.13, ["Ride"] = 210, ["Fly|Ride"] = 299.86, ["Neon"] = 840, ["Neon|Ride"] = 952.98, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 4637.2, ["Mega|Fly|Ride"] = 3835.98}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 33.64, ["Ride"] = 14.44, ["Fly|Ride"] = 39.43, ["Neon"] = 19.68, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 196.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 247.11}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 264.99, ["Ride"] = 248.16, ["Fly|Ride"] = 248.14, ["Neon|Ride"] = 1275.41, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 10269.05, ["Mega|Fly|Ride"] = 4081.45}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 70.4, ["Ride"] = 28.91, ["Fly|Ride"] = 61.63, ["Neon"] = 81.38, ["Neon|Fly"] = 294.52, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 513.64, ["Mega|Ride"] = 575.15, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.62, ["Ride"] = 20.25, ["Fly|Ride"] = 86.63, ["Neon"] = 9.76, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 109.93, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 202.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 4.11, ["Neon|Ride"] = 31.85, ["Mega"] = 34.93, ["Mega|Ride"] = 136.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.44, ["Fly"] = 52.48, ["Ride"] = 32.9, ["Fly|Ride"] = 206.57, ["Neon"] = 7.12, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 66.91, ["Mega|Fly"] = 154593.31, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 62.99, ["Fly"] = 136.83, ["Ride"] = 105, ["Fly|Ride"] = 155.86, ["Neon"] = 314.25, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 366.18, ["Mega|Fly|Ride"] = 983.39}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 17.07, ["Fly|Ride"] = 88.7, ["Neon"] = 13.13, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 122.64, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.71, ["Ride"] = 124.09, ["Neon"] = 41.09, ["Neon|Ride"] = 111.57, ["Mega"] = 602.81, ["Mega|Ride"] = 579.95}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 43.42, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 17.22, ["Mega|Ride"] = 46.4, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.42, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.11, ["Neon|Fly|Ride"] = 39.03, ["Mega"] = 13.75, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 30.16, ["Mega|Fly|Ride"] = 48.17}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.3, ["Fly|Ride"] = 30.82, ["Neon"] = 3.38, ["Neon|Fly"] = 20.55, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 19.45, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 39.04, ["Mega|Fly|Ride"] = 97.12}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 123.24, ["Neon"] = 2.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.17, ["Mega"] = 15.75, ["Mega|Ride"] = 146.08, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.92, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 23.43, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.14, ["Neon|Fly|Ride"] = 203.34, ["Mega"] = 22.32, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.9, ["Fly"] = 65.24, ["Ride"] = 17.07, ["Fly|Ride"] = 53.43, ["Neon"] = 9.19, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 64.58, ["Mega|Fly"] = 277.28, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.33, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Neon|Ride"] = 36.99, ["Mega"] = 274.2, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.23}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.69, ["Ride"] = 41.1, ["Neon"] = 6.19, ["Neon|Ride"] = 19.69, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 32.81, ["Mega|Ride"] = 172.79, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 17.41, ["Fly|Ride"] = 30.1, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.73, ["Neon|Fly|Ride"] = 28.68, ["Mega"] = 15.25, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 28.88, ["Neon|Ride"] = 140.95, ["Mega"] = 274.2}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.33, ["Neon"] = 3.55, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 23.62, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 55.47, ["Mega|Fly|Ride"] = 130.45}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.9, ["Neon"] = 20.89, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 81.38, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.61, ["Fly"] = 656.24, ["Ride"] = 32.82, ["Fly|Ride"] = 186.9, ["Neon"] = 15.21, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 223.02, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 14.21, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 35.96, ["Mega"] = 14.44, ["Mega|Fly"] = 30.82, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 52.46}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.66, ["Fly|Ride"] = 96.55, ["Neon"] = 18.27, ["Neon|Ride"] = 111.32, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.57, ["Fly"] = 40.69, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.19, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.25, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.75, ["Fly|Ride"] = 26.17, ["Neon"] = 3.19, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 15.41, ["Neon|Fly|Ride"] = 36.99, ["Mega"] = 14.44, ["Mega|Fly"] = 155.38, ["Mega|Ride"] = 118.15, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.91, ["Fly"] = 171.53, ["Ride"] = 60.36, ["Neon"] = 7.88, ["Neon|Fly"] = 76.01, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 36.66, ["Mega|Fly"] = 164.33, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 26.72, ["Fly|Ride"] = 82.17, ["Neon"] = 4.98, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.86, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 96.55, ["Mega"] = 17.06, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 108.84}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 18.38, ["Fly|Ride"] = 42.02, ["Neon"] = 6.97, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 77.7, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 287.59}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 5.25, ["Neon|Ride"] = 43.3, ["Mega"] = 40.68, ["Mega|Ride"] = 124.09}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 17.56, ["Fly|Ride"] = 43.31, ["Neon"] = 6.57, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.62, ["Ride"] = 27.65, ["Neon"] = 36.15, ["Mega"] = 133.88, ["Mega|Ride"] = 205.92, ["Mega|Fly|Ride"] = 821.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.63, ["Fly"] = 35.96, ["Ride"] = 16.7, ["Fly|Ride"] = 61.63, ["Neon"] = 18.06, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 315.31}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.31, ["Fly"] = 22.45, ["Ride"] = 19.53, ["Fly|Ride"] = 48.57, ["Neon"] = 18.3, ["Neon|Fly"] = 39.36, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 223.13, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 124.09, ["Mega|Fly|Ride"] = 189.7}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly|Ride"] = 137.7, ["Neon"] = 37.41, ["Mega"] = 123.3, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.13, ["Ride"] = 76.02, ["Neon"] = 120.1, ["Neon|Ride"] = 32.82, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.12, ["Ride"] = 109.03, ["Neon"] = 41.11, ["Neon|Ride"] = 105, ["Mega"] = 155.38, ["Mega|Ride"] = 273.67, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.66, ["Ride"] = 45.66, ["Fly|Ride"] = 139.13, ["Neon"] = 55.22, ["Neon|Ride"] = 55.47, ["Mega"] = 248.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.73}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 64.99, ["Mega"] = 21, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 147.91}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.09, ["Fly"] = 21.95, ["Ride"] = 22.32, ["Fly|Ride"] = 41.09, ["Neon"] = 59.53, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 102.71, ["Mega"] = 288.75, ["Mega|Fly"] = 328.63, ["Mega|Ride"] = 278.32, ["Mega|Fly|Ride"] = 281.49}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 69.84, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 35.96, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.41, ["Ride"] = 24.72, ["Neon"] = 4.51, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 102.71, ["Mega"] = 55.49, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.29, ["Fly"] = 45.94, ["Ride"] = 19.53, ["Fly|Ride"] = 55.13, ["Neon"] = 6.89, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 113.55, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.61, ["Ride"] = 31.85, ["Fly|Ride"] = 58.55, ["Neon"] = 32.81, ["Neon|Ride"] = 231.91, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 291.65, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 307.1}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.24, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 54.5, ["Mega"] = 17.06, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 328.67}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 15.94, ["Fly|Ride"] = 273841.4, ["Neon"] = 4.85, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.44, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 6.46, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 14.85, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 47.94, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.24, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.89, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 24.92, ["Mega|Fly"] = 102.71, ["Mega|Ride"] = 66.26, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 149335.23, ["Mega"] = 68.81, ["Mega|Fly"] = 98.6, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.26}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 17.9, ["Fly|Ride"] = 49.31, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.01, ["Neon|Fly|Ride"] = 76.54, ["Mega"] = 24.65, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 109.91}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.57, ["Mega"] = 15.75, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 386.54}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 4.66, ["Neon|Ride"] = 155.38, ["Mega"] = 28.55, ["Mega|Fly"] = 115.97, ["Mega|Ride"] = 122.14}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.05, ["Fly|Ride"] = 49.87, ["Neon"] = 4.6, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 55.48, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 154.07}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.77, ["Fly"] = 55.47, ["Ride"] = 137.54, ["Neon"] = 512.44, ["Mega"] = 536.17, ["Mega|Ride"] = 449.68, ["Mega|Fly|Ride"] = 671.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.08, ["Fly"] = 6562.5, ["Ride"] = 36.75, ["Neon"] = 37.4, ["Neon|Ride"] = 203.34, ["Mega"] = 315.28, ["Mega|Ride"] = 341.92, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.72, ["Ride"] = 26.24, ["Fly|Ride"] = 410.83, ["Neon"] = 33.72, ["Mega"] = 274.2, ["Mega|Ride"] = 248.16, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 12.85, ["Fly|Ride"] = 25.47, ["Neon"] = 2.1, ["Neon|Fly"] = 14.57, ["Neon|Ride"] = 14.46, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 15.75, ["Mega|Fly"] = 31.85, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 49.81}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Fly|Ride"] = 109.89, ["Neon"] = 17.41, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 684.96, ["Mega"] = 115.5, ["Mega|Ride"] = 96.56}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 15.64, ["Mega|Fly"] = 80.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 101.04}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.63, ["Neon"] = 2.63, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 122.22, ["Mega"] = 23.2, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 18.5, ["Fly|Ride"] = 45.94, ["Neon"] = 11.69, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 183.65, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 248.16}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.88, ["Ride"] = 229.05, ["Fly|Ride"] = 274.2, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8215.25, ["Mega|Fly|Ride"] = 3341.99}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 9.18, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 68.25, ["Mega"] = 64.03, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 773.47}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.12, ["Fly"] = 103.68, ["Ride"] = 15.75, ["Neon"] = 59.07, ["Neon|Ride"] = 62.63, ["Neon|Fly|Ride"] = 155.08, ["Mega"] = 155.38, ["Mega|Fly|Ride"] = 409.8}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 805.26, ["Ride"] = 15.09, ["Fly|Ride"] = 32.79, ["Neon"] = 7.88, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 49.67, ["Mega|Ride"] = 74.37, ["Mega|Fly|Ride"] = 152.02}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.71, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.07, ["Fly"] = 24.92, ["Ride"] = 15.75, ["Fly|Ride"] = 34.97, ["Neon"] = 23.63, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.65, ["Ride"] = 23.63, ["Fly|Ride"] = 55.47, ["Neon"] = 45.23, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 185.53, ["Mega|Ride"] = 356.01, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.49, ["Fly"] = 16.45, ["Ride"] = 14.44, ["Fly|Ride"] = 36.75, ["Neon"] = 18.16, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 53.42, ["Neon|Fly|Ride"] = 76.13, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.02, ["Fly"] = 149.16, ["Ride"] = 94.48, ["Fly|Ride"] = 150.93, ["Neon"] = 390.24, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 216.57, ["Fly"] = 328.67, ["Ride"] = 231.25, ["Fly|Ride"] = 289.88, ["Neon"] = 927.57, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1082.93, ["Mega"] = 10269.05, ["Mega|Fly|Ride"] = 3957.17}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 72.19, ["Fly"] = 137.64, ["Ride"] = 77.44, ["Fly|Ride"] = 120.74, ["Neon"] = 402.34, ["Neon|Ride"] = 309.65, ["Neon|Fly|Ride"] = 334.79, ["Mega|Fly|Ride"] = 1325.02}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.2, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 92.77, ["Neon"] = 32.81, ["Neon|Ride"] = 62.56, ["Neon|Fly|Ride"] = 126, ["Mega"] = 315, ["Mega|Ride"] = 376.04, ["Mega|Fly|Ride"] = 394.27}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 14.44, ["Fly"] = 68.83, ["Ride"] = 30.82, ["Fly|Ride"] = 81.14, ["Neon"] = 77.04, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 171.51, ["Mega"] = 351.75, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.48, ["Ride"] = 18.38, ["Fly|Ride"] = 39.43, ["Neon"] = 4.66, ["Neon|Fly"] = 67.3, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 76.01, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 92.78, ["Mega|Fly|Ride"] = 174.61}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.14, ["Fly"] = 68.82, ["Ride"] = 27.75, ["Fly|Ride"] = 309.59, ["Neon"] = 55.47, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 882.12, ["Mega|Ride"] = 583.36, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.62, ["Fly"] = 41.1, ["Ride"] = 15.31, ["Fly|Ride"] = 44.09, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 155.4, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.12, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 30.82, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 155.38, ["Mega"] = 207.37, ["Mega|Ride"] = 206.42, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 35.96, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 14.44, ["Mega|Ride"] = 50.34, ["Mega|Fly|Ride"] = 208726}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.46, ["Fly"] = 45.94, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 102.71, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 98, ["Mega"] = 84, ["Mega|Ride"] = 105.82, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 17.41, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.89, ["Mega"] = 283.5, ["Mega|Ride"] = 201.78, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 154.07, ["Fly"] = 187.69, ["Ride"] = 210, ["Fly|Ride"] = 232.32, ["Neon"] = 700.88, ["Neon|Ride"] = 696.94, ["Neon|Fly|Ride"] = 773.55, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 3645.08}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 10.5, ["Ride"] = 30.82, ["Fly|Ride"] = 206.07, ["Neon"] = 59.57, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 343, ["Mega|Ride"] = 343.05, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.33, ["Fly"] = 15.42, ["Ride"] = 16.21, ["Fly|Ride"] = 39.38, ["Neon"] = 40.6, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.25, ["Ride"] = 40.07, ["Fly|Ride"] = 170.63, ["Neon"] = 119.23, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 506.18, ["Mega"] = 453.14, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 703.88}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.13}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.52, ["Neon"] = 42.95, ["Neon|Ride"] = 153.87, ["Neon|Fly|Ride"] = 616.17, ["Mega"] = 385.1, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 751.79}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 27.41, ["Fly"] = 77.66, ["Ride"] = 26.24, ["Fly|Ride"] = 57.74, ["Neon"] = 178.69, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 2053.83, ["Mega|Fly|Ride"] = 832.94}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.93, ["Neon|Ride"] = 49.31, ["Neon|Fly|Ride"] = 105, ["Mega"] = 30.82, ["Mega|Fly"] = 410.78, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 10.5, ["Fly"] = 27.6, ["Ride"] = 26.69, ["Fly|Ride"] = 61.63, ["Neon"] = 8.24, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 231.91, ["Mega"] = 229.04, ["Mega|Fly"] = 387.27, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 17.26, ["Fly|Ride"] = 43.35, ["Neon"] = 15.28, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.85, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 133.71, ["Mega|Ride"] = 124.09, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 31.32, ["Fly|Ride"] = 82.17, ["Neon"] = 3.69, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 410.78, ["Mega"] = 26.25, ["Mega|Ride"] = 82.35, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 29.56, ["Ride"] = 123.26, ["Neon"] = 231.91, ["Neon|Fly"] = 194.25, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 902.45, ["Mega|Ride"] = 1037.31, ["Mega|Fly|Ride"] = 848.33}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.62, ["Ride"] = 51.03, ["Neon"] = 80.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 274.2, ["Mega|Ride"] = 410.83}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 5.25, ["Fly"] = 87.49, ["Ride"] = 39.38, ["Fly|Ride"] = 69.56, ["Neon"] = 44.63, ["Neon|Fly"] = 315, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 123.24, ["Mega"] = 372.43, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.82, ["Fly"] = 433.13, ["Ride"] = 105, ["Fly|Ride"] = 262.44, ["Neon"] = 406.67, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 684.96, ["Mega"] = 1601.99, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1313.59}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 11.82, ["Fly"] = 39.38, ["Ride"] = 28.87, ["Fly|Ride"] = 60.38, ["Neon"] = 52.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 123.24, ["Mega"] = 265.82, ["Mega|Ride"] = 241.21, ["Mega|Fly|Ride"] = 368.02}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 80.56, ["Fly"] = 143.07, ["Ride"] = 107.58, ["Neon"] = 183.75, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 225.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 979.14, ["Mega|Ride"] = 1000.34, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.52, ["Fly"] = 123.26, ["Ride"] = 60.32, ["Fly|Ride"] = 143.79, ["Neon"] = 62.25, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 267.01, ["Mega"] = 384.95, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 429.59}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.87, ["Fly"] = 137.64, ["Ride"] = 27.75, ["Fly|Ride"] = 41.09, ["Neon"] = 82.68, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 368.72, ["Mega"] = 624.95, ["Mega|Fly|Ride"] = 463.84}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 22.04, ["Ride"] = 105, ["Fly|Ride"] = 151.68, ["Neon"] = 88.35, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 255.2, ["Mega|Fly"] = 496.01, ["Mega|Ride"] = 307.48, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.28, ["Ride"] = 41.1, ["Fly|Ride"] = 135.61, ["Neon"] = 43.26, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 385.1, ["Mega|Ride"] = 306.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 53.42, ["Neon|Ride"] = 56.44, ["Mega"] = 17.73, ["Mega|Fly"] = 137.62, ["Mega|Ride"] = 68.82, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.78, ["Ride"] = 27.57, ["Neon"] = 15.75, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 463.84}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.56, ["Fly"] = 46.4, ["Neon"] = 23.62, ["Neon|Ride"] = 205.4, ["Mega"] = 183.24, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 10.5, ["Ride"] = 32.78, ["Fly|Ride"] = 114.79, ["Neon"] = 15.75, ["Neon|Ride"] = 82.17, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.37, ["Mega|Ride"] = 212.26, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.37, ["Ride"] = 525, ["Fly|Ride"] = 616.88, ["Neon"] = 1702.62, ["Neon|Ride"] = 1439.24, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.61, ["Fly"] = 27.75, ["Ride"] = 23.21, ["Fly|Ride"] = 59.57, ["Neon"] = 35.96, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 369.74, ["Mega|Fly|Ride"] = 487.86}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.16, ["Fly"] = 39.38, ["Ride"] = 27.46, ["Fly|Ride"] = 60.38, ["Neon"] = 76.12, ["Neon|Ride"] = 54.51, ["Mega"] = 273.17, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3, ["Ride"] = 17.07, ["Fly|Ride"] = 308.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 149.94, ["Mega"] = 260.89, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.69, ["Fly|Ride"] = 90.57, ["Neon"] = 7.69, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 91.61, ["Mega"] = 69.57, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 17.07, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.93, ["Mega"] = 22.32, ["Mega|Ride"] = 77.42, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1106.44}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 6.97, ["Ride"] = 41.1, ["Fly|Ride"] = 68.83, ["Neon"] = 76.01, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 178.69, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 846.28}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.24, ["Neon|Ride"] = 40.69, ["Mega"] = 39.25, ["Mega|Ride"] = 149.96, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.03, ["Fly"] = 96.56, ["Ride"] = 58.49, ["Fly|Ride"] = 39.38, ["Neon"] = 7.83, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 131.25, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 446.25, ["Ride"] = 410.83, ["Fly|Ride"] = 488.25, ["Neon|Ride"] = 1571.18, ["Neon|Fly|Ride"] = 1205.4, ["Mega|Fly|Ride"] = 7532.26}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.81, ["Fly"] = 196.88, ["Neon"] = 137.82, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 458.01, ["Mega|Ride"] = 410.83}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Ride"] = 29.29, ["Fly|Ride"] = 141.73, ["Neon"] = 4.93, ["Neon|Ride"] = 38.05, ["Neon|Fly|Ride"] = 124.08, ["Mega"] = 40.26, ["Mega|Fly"] = 189, ["Mega|Ride"] = 76.67, ["Mega|Fly|Ride"] = 206.53}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 821.64, ["Neon"] = 3.84, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 260.86, ["Mega"] = 24.18, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 217.74}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13, ["Fly"] = 107.62, ["Ride"] = 26.25, ["Fly|Ride"] = 178.5, ["Neon"] = 61.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.63, ["Mega"] = 578.59, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.86, ["Fly|Ride"] = 124.08, ["Neon"] = 108.99, ["Neon|Fly|Ride"] = 199.44, ["Mega"] = 393.75, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 1063.79}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.23, ["Ride"] = 39.38, ["Fly|Ride"] = 137.62, ["Neon"] = 27.75, ["Neon|Ride"] = 155.38, ["Mega"] = 634.24, ["Mega|Ride"] = 958.11, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.38, ["Ride"] = 34.93, ["Neon"] = 162.26, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 184.86, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.83, ["Fly|Ride"] = 616.88, ["Neon"] = 1641, ["Neon|Ride"] = 1642.04, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.11, ["Mega|Fly|Ride"] = 3697.33}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.94, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 51.36, ["Neon"] = 98.44, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 684.96, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 846.28}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.82, ["Ride"] = 125.98, ["Fly|Ride"] = 78.75, ["Neon"] = 18.57, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 773.47}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 17.06, ["Ride"] = 68.25, ["Fly|Ride"] = 256.26, ["Neon"] = 44, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 267.94, ["Mega|Fly"] = 548.39, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 324.11}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 40.61, ["Ride"] = 52.5, ["Fly|Ride"] = 123.26, ["Neon"] = 7.25, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 44.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 260.88}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 273.17, ["Neon|Ride"] = 294.74, ["Neon|Fly|Ride"] = 462.12, ["Mega"] = 1780.66, ["Mega|Ride"] = 1230.41, ["Mega|Fly|Ride"] = 1316.66}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.63, ["Fly"] = 56.44, ["Ride"] = 31.85, ["Neon"] = 10.49, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 65.63, ["Mega|Ride"] = 103.67, ["Mega|Fly|Ride"] = 178.48}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.37, ["Fly"] = 19.68, ["Ride"] = 27.57, ["Fly|Ride"] = 148.25, ["Neon"] = 6.18, ["Neon|Fly"] = 68.42, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 131.45, ["Mega"] = 40.69, ["Mega|Ride"] = 69.59, ["Mega|Fly|Ride"] = 170.45}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.63, ["Fly"] = 1519.88, ["Ride"] = 27.57, ["Fly|Ride"] = 137.62, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 95.67, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 71.84, ["Fly"] = 92.78, ["Ride"] = 105.37, ["Neon"] = 328.63, ["Neon|Ride"] = 472.4, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 262.5, ["Ride"] = 309.74, ["Fly|Ride"] = 415.9, ["Neon"] = 1427.41, ["Neon|Ride"] = 1095.72, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6161.44, ["Mega|Fly|Ride"] = 4947.98}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.96, ["Ride"] = 30.16, ["Neon"] = 53.82, ["Neon|Ride"] = 152.02, ["Mega"] = 90.96, ["Mega|Ride"] = 184.9, ["Mega|Fly|Ride"] = 417.46}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 155.38, ["Neon"] = 19.69, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 55.13, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 356.01}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 30.16, ["Ride"] = 20.56, ["Fly|Ride"] = 174.59, ["Neon"] = 36.75, ["Mega"] = 345.85, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.19, ["Fly"] = 58.92, ["Ride"] = 20.56, ["Fly|Ride"] = 133.88, ["Neon"] = 9.18, ["Neon|Ride"] = 34.8, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 68.83, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 8.84, ["Neon|Ride"] = 30.16, ["Mega"] = 32.82, ["Mega|Fly|Ride"] = 271.16}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.75, ["Fly|Ride"] = 41.99, ["Neon"] = 5.25, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.57, ["Mega"] = 43.31, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 90.39, ["Ride"] = 20.46, ["Fly|Ride"] = 53.4, ["Neon"] = 7.88, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.38, ["Mega"] = 156.15, ["Mega|Ride"] = 231.1, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.57, ["Fly"] = 35.96, ["Ride"] = 42, ["Fly|Ride"] = 82.56, ["Neon"] = 274.2, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 409.8, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 65.89, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 137.62, ["Neon"] = 354.38, ["Neon|Ride"] = 389.82, ["Mega"] = 1575.29, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 1416.3}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 37.7, ["Mega|Fly"] = 672, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 241.37}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.73, ["Fly|Ride"] = 35.43, ["Neon"] = 5.24, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 49.86, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.25, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.47, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 273.17, ["Mega"] = 260.95, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 354.38, ["Fly"] = 393.75, ["Ride"] = 541.26, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1780.66, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 7121.46}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 30.17, ["Fly"] = 90.17, ["Ride"] = 61.64, ["Fly|Ride"] = 102.71, ["Neon"] = 252.63, ["Neon|Ride"] = 109.89, ["Neon|Fly|Ride"] = 264.96, ["Mega|Ride"] = 1232.45}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 35.96, ["Fly|Ride"] = 105, ["Neon"] = 11.58, ["Neon|Ride"] = 74.22, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 57.75, ["Mega|Ride"] = 133.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.15, ["Fly"] = 205.42, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 131.25}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.25, ["Fly"] = 45.94, ["Ride"] = 44.37, ["Fly|Ride"] = 68.83, ["Neon"] = 118.13, ["Neon|Ride"] = 279.11, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2464.59, ["Mega|Fly|Ride"] = 1237.3}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 99.75, ["Fly|Ride"] = 189, ["Neon"] = 498.75, ["Neon|Ride"] = 468.27, ["Neon|Fly|Ride"] = 478.55, ["Mega"] = 8215.25, ["Mega|Fly|Ride"] = 1869.21}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 233.2, ["Fly"] = 307.1, ["Ride"] = 262.5, ["Fly|Ride"] = 369.7, ["Neon"] = 820.51, ["Neon|Ride"] = 890.33, ["Neon|Fly|Ride"] = 1095.72, ["Mega|Fly|Ride"] = 3218.74}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.28, ["Ride"] = 39.44, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 152, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 376.65, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.38, ["Fly|Ride"] = 28.88, ["Neon"] = 7.77, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 91.23, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.52, ["Fly"] = 19.69, ["Ride"] = 15.42, ["Fly|Ride"] = 108.99, ["Neon"] = 29.4, ["Neon|Fly"] = 143.79, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 102.71, ["Mega"] = 314.25, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 288.75, ["Fly"] = 479.64, ["Ride"] = 326.82, ["Fly|Ride"] = 410.78, ["Neon"] = 984.38, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1649.82, ["Mega|Ride"] = 5340.58, ["Mega|Fly|Ride"] = 5721.42}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.24, ["Ride"] = 55.47, ["Neon"] = 12.34, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 43.32, ["Mega|Ride"] = 178.7}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.89, ["Fly"] = 20.89, ["Ride"] = 18.57, ["Fly|Ride"] = 41.09, ["Neon"] = 31.34, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105.78, ["Mega"] = 176.65, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.55, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.43, ["Ride"] = 114.19, ["Neon"] = 103.69, ["Neon|Fly"] = 410.78, ["Neon|Ride"] = 142.14, ["Neon|Fly|Ride"] = 387.27, ["Mega"] = 463.07, ["Mega|Ride"] = 520.72, ["Mega|Fly|Ride"] = 452.93}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 155.4, ["Fly"] = 137.64, ["Ride"] = 124.69, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 684.96, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21.93, ["Fly"] = 48.28, ["Ride"] = 31.85, ["Fly|Ride"] = 61.68, ["Neon"] = 78.75, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 163.29, ["Mega"] = 630.53, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.63, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 684.96, ["Mega"] = 20.57, ["Mega|Ride"] = 273.2, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 3.68, ["Neon|Fly"] = 155.38, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 69.59, ["Mega"] = 27.57, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 109.91}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.43, ["Fly"] = 410.83, ["Ride"] = 68.23, ["Fly|Ride"] = 172.54, ["Neon"] = 31.5, ["Neon|Fly"] = 222.63, ["Neon|Ride"] = 92.91, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 151.33, ["Mega|Fly"] = 274.2, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 297.65}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.57, ["Ride"] = 1312.5, ["Fly|Ride"] = 1378.13, ["Neon"] = 4200, ["Neon|Fly|Ride"] = 4825.44, ["Mega|Fly|Ride"] = 10762.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 420, ["Ride"] = 481.69, ["Fly|Ride"] = 615.56, ["Neon"] = 1739.59, ["Neon|Ride"] = 1181.15, ["Neon|Fly|Ride"] = 1813.76, ["Mega"] = 13913.34, ["Mega|Fly|Ride"] = 7084.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 334.69, ["Fly"] = 362.25, ["Ride"] = 368.82, ["Fly|Ride"] = 420, ["Neon"] = 656.25, ["Neon|Fly"] = 1237.15, ["Neon|Ride"] = 617.76, ["Neon|Fly|Ride"] = 761.25, ["Mega|Fly|Ride"] = 3067.21}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 322.12, ["Fly"] = 413.12, ["Ride"] = 365.21, ["Fly|Ride"] = 456.75, ["Neon"] = 1205.6, ["Neon|Fly"] = 1369.91, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 4616.52}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.52, ["Fly"] = 23.39, ["Ride"] = 17.41, ["Fly|Ride"] = 39.38, ["Neon"] = 7.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.17, ["Mega"] = 63.14, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 383.22, ["Ride"] = 525, ["Fly|Ride"] = 548.39, ["Neon"] = 1680, ["Neon|Ride"] = 1509.37, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 8117.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.59, ["Fly"] = 183.75, ["Ride"] = 112.53, ["Fly|Ride"] = 62.63, ["Neon"] = 9.65, ["Neon|Ride"] = 64.71, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 65.63, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 271.16}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.54, ["Fly|Ride"] = 39.38, ["Neon"] = 16.45, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 100.84, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 45.94, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 343}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.78, ["Fly"] = 8038.15, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 77.7, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 34.93, ["Mega|Fly"] = 684.96, ["Mega|Ride"] = 155.29, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.6, ["Fly"] = 35.89, ["Ride"] = 20.56, ["Fly|Ride"] = 61.85, ["Neon"] = 13.81, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.28, ["Neon|Fly|Ride"] = 82.43, ["Mega"] = 52.5, ["Mega|Fly"] = 171.51, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.42, ["Fly"] = 55.47, ["Ride"] = 22.61, ["Fly|Ride"] = 51.45, ["Neon"] = 152, ["Neon|Fly"] = 73.96, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.78, ["Ride"] = 51.19, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 263.21, ["Mega"] = 309.59, ["Mega|Ride"] = 439.59, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.94, ["Fly"] = 6185.26, ["Ride"] = 41.1, ["Neon"] = 24.44, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 274.2, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.16, ["Fly|Ride"] = 54.5, ["Neon"] = 5.25, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 19.69, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 208.69, ["Fly"] = 274.23, ["Ride"] = 224.68, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 2567.28, ["Neon|Fly|Ride"] = 1136.8, ["Mega"] = 8215.25, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.42, ["Fly|Ride"] = 35.44, ["Neon"] = 4.66, ["Neon|Fly"] = 51.36, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 41.09, ["Mega"] = 27.74, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 11.22, ["Fly"] = 137.64, ["Ride"] = 55.47, ["Fly|Ride"] = 183.72, ["Neon"] = 102.38, ["Neon|Ride"] = 100.66, ["Mega"] = 439.52, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 22.61, ["Fly"] = 210, ["Ride"] = 192.05, ["Fly|Ride"] = 167.23, ["Neon"] = 196.88, ["Neon|Ride"] = 309.59, ["Mega"] = 821.55, ["Mega|Ride"] = 849.36}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.4, ["Ride"] = 233.63, ["Fly|Ride"] = 337.57, ["Neon"] = 820.51, ["Neon|Fly"] = 1159.47, ["Neon|Ride"] = 833.86, ["Neon|Fly|Ride"] = 740.25, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.43, ["Ride"] = 37.43, ["Fly|Ride"] = 139.16, ["Neon"] = 123.24, ["Neon|Ride"] = 274.2, ["Mega"] = 286.79, ["Mega|Ride"] = 397.48, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 29.21, ["Ride"] = 48.57, ["Fly|Ride"] = 616.17, ["Neon"] = 1437.69, ["Neon|Ride"] = 192.94, ["Mega"] = 463.68, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 928.46}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1441.13, ["Ride"] = 1050, ["Fly|Ride"] = 1162.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16978.9}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.99, ["Fly"] = 21, ["Ride"] = 19.56, ["Fly|Ride"] = 42, ["Neon"] = 44.17, ["Neon|Fly"] = 73.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 96.55, ["Mega|Ride"] = 219.8, ["Mega|Fly|Ride"] = 308.13}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.66, ["Fly"] = 65.63, ["Ride"] = 38.07, ["Neon"] = 30.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 548.39, ["Mega"] = 342.04, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 217.74, ["Mega|Fly|Ride"] = 579.26}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Fly"] = 81.15, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 12.77, ["Neon|Ride"] = 39.43, ["Mega"] = 90.55, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 17.41, ["Fly"] = 55.47, ["Ride"] = 36.75, ["Fly|Ride"] = 102.11, ["Neon"] = 76.12, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 349.76, ["Mega|Fly|Ride"] = 470.06}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.72, ["Fly"] = 20.99, ["Ride"] = 20.69, ["Fly|Ride"] = 41.09, ["Neon"] = 26.7, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 62.35, ["Mega"] = 147.9, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 410.83, ["Ride"] = 22.04, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 123.24, ["Mega"] = 103.76, ["Mega|Fly"] = 205.4, ["Mega|Ride"] = 191.09, ["Mega|Fly|Ride"] = 304.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 315.31, ["Ride"] = 343.05, ["Fly|Ride"] = 587.86, ["Neon|Ride"] = 1314.83, ["Neon|Fly|Ride"] = 1338.02}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 3.94, ["Fly"] = 25.46, ["Ride"] = 18.38, ["Fly|Ride"] = 48.57, ["Neon"] = 9.21, ["Neon|Fly"] = 82.17, ["Neon|Ride"] = 39.03, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 77.7, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 233.16}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.06, ["Ride"] = 81.77, ["Neon"] = 137.62, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 345.09, ["Mega|Ride"] = 233.1}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.16, ["Fly"] = 89.42, ["Ride"] = 26.17, ["Neon"] = 10.88, ["Neon|Ride"] = 55.47, ["Mega"] = 84.94, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 260.88, ["Ride"] = 314.99, ["Fly|Ride"] = 1036.23, ["Neon"] = 708.75, ["Neon|Ride"] = 821.55, ["Neon|Fly|Ride"] = 1095.72, ["Mega|Ride"] = 4382.37, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.61, ["Fly"] = 54.8, ["Ride"] = 41.1, ["Fly|Ride"] = 105, ["Neon"] = 122.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 788.44, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 820.61}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 22.32, ["Ride"] = 76.13, ["Fly|Ride"] = 124.08, ["Neon"] = 124.69, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 501.27, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.75, ["Neon|Ride"] = 44.18, ["Mega"] = 32.32, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.04, ["Fly"] = 83.61, ["Ride"] = 102.72, ["Fly|Ride"] = 176.69, ["Neon"] = 262.47, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1142.49}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Fly|Ride"] = 137.62, ["Neon"] = 5.25, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.09, ["Mega|Fly|Ride"] = 409.8}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.67, ["Fly"] = 124.09, ["Ride"] = 23.4, ["Fly|Ride"] = 68.39, ["Neon"] = 45.94, ["Neon|Ride"] = 108.99, ["Neon|Fly|Ride"] = 246.47, ["Mega"] = 382.05, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 406.72, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 47.24, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 104.86, ["Neon"] = 182.49, ["Neon|Ride"] = 246.51, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1313.59, ["Mega|Fly|Ride"] = 1089.97}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 20.46, ["Ride"] = 15.42, ["Fly|Ride"] = 33.64, ["Neon"] = 2.63, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 17.41, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 18.38, ["Mega|Fly"] = 55.47, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 5.25, ["Ride"] = 33.64, ["Fly|Ride"] = 1333.96, ["Neon"] = 26.25, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 472.5, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 30.82, ["Fly"] = 137.64, ["Ride"] = 39.38, ["Fly|Ride"] = 131.25, ["Neon"] = 111.44, ["Neon|Ride"] = 203.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 545.3, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 733.31}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 30.82, ["Mega|Ride"] = 77.72, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.31, ["Ride"] = 32.82, ["Fly|Ride"] = 120.75, ["Neon"] = 80.07, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 185.53, ["Mega"] = 548.39, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 432.73}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 20.89, ["Fly"] = 27.75, ["Ride"] = 26.72, ["Fly|Ride"] = 45.94, ["Neon"] = 212.7, ["Neon|Ride"] = 118.29, ["Mega"] = 431.31, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.15, ["Ride"] = 17.41, ["Fly|Ride"] = 76.02, ["Neon"] = 33.47, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 170.63, ["Mega|Ride"] = 232.31, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.67, ["Fly"] = 2054.08, ["Ride"] = 42, ["Fly|Ride"] = 155.38, ["Neon"] = 86.98, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6183.33, ["Mega"] = 410.78, ["Mega|Ride"] = 507.94, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 137.64, ["Fly|Ride"] = 196.87, ["Neon"] = 9.1, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 68.81, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 124.09}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 2.63, ["Neon|Ride"] = 89.17, ["Mega"] = 30.17, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 209.81}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 48.07}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 53.36, ["Fly"] = 102.38, ["Ride"] = 68.82, ["Fly|Ride"] = 205.4, ["Neon"] = 131.25, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1224.08, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 836.03}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Mega"] = 30.82, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 380.63, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Mega"] = 16430.48}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.56, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 13.13, ["Neon|Ride"] = 273.17, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.81, ["Mega|Fly"] = 141.73, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.64, ["Fly"] = 155.4, ["Ride"] = 21.16, ["Fly|Ride"] = 63, ["Neon"] = 17.07, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 346.5, ["Mega|Ride"] = 159.15, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.24, ["Fly"] = 77.04, ["Ride"] = 72.19, ["Fly|Ride"] = 106.32, ["Neon"] = 78.75, ["Neon|Ride"] = 178.58, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 792.79, ["Mega|Ride"] = 405.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 17.41, ["Fly|Ride"] = 721.88, ["Neon"] = 53.42, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.99, ["Fly"] = 43.16, ["Ride"] = 92.78, ["Fly|Ride"] = 157.49, ["Neon"] = 52.41, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 359, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.98, ["Fly"] = 104.99, ["Ride"] = 35.44, ["Fly|Ride"] = 184.86, ["Neon"] = 55.47, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 216.57, ["Mega|Fly"] = 478.55, ["Mega|Ride"] = 273.2, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 14.44, ["Fly|Ride"] = 66.93, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 77.03, ["Mega"] = 15.58, ["Mega|Fly"] = 61.63, ["Mega|Ride"] = 35.39, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.54, ["Fly"] = 274.23, ["Ride"] = 27.57, ["Fly|Ride"] = 155.38, ["Neon"] = 23.21, ["Neon|Fly"] = 115.97, ["Neon|Ride"] = 68.81, ["Neon|Fly|Ride"] = 110.16, ["Mega"] = 144.38, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 275.63, ["Fly"] = 417.46, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 1450, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1046.06, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 98.43, ["Ride"] = 137.27, ["Fly|Ride"] = 294.52, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 684.96, ["Mega"] = 4107.64, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1546.91}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.45, ["Ride"] = 22.04, ["Fly|Ride"] = 39.38, ["Neon"] = 11.62, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 62.67, ["Mega"] = 59.57, ["Mega|Fly"] = 204.37, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 164.34}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 14.65, ["Fly|Ride"] = 31.31, ["Neon"] = 10.5, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 54.5, ["Mega"] = 70.88, ["Mega|Fly"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Mega"] = 137.62, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 286.09, ["Fly|Ride"] = 343.05, ["Neon|Ride"] = 1162.47, ["Neon|Fly|Ride"] = 1308.28, ["Mega|Ride"] = 8216.28, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.83, ["Fly"] = 48.28, ["Ride"] = 17.06, ["Fly|Ride"] = 41, ["Neon"] = 27.75, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.18, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 4.13, ["Fly"] = 155.4, ["Ride"] = 68.82, ["Fly|Ride"] = 205.42, ["Neon"] = 34.93, ["Neon|Ride"] = 139.13, ["Mega"] = 246.47, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.25, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.45, ["Fly"] = 35.96, ["Ride"] = 24.67, ["Fly|Ride"] = 57.23, ["Neon"] = 78.66, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 603.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 40.69, ["Ride"] = 92.01, ["Fly|Ride"] = 209.99, ["Neon"] = 157.5, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 420, ["Mega|Fly"] = 2156.51, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 604.97}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.61, ["Fly"] = 55.47, ["Ride"] = 46.39, ["Fly|Ride"] = 99.05, ["Neon"] = 157.39, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 189.58, ["Mega|Ride"] = 739.48, ["Mega|Fly|Ride"] = 808.28}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.39, ["Fly|Ride"] = 31.32, ["Neon"] = 2.1, ["Neon|Fly"] = 30.16, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 24.67, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 43.15, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.15, ["Ride"] = 274.3, ["Fly|Ride"] = 281.39, ["Neon"] = 3246.46, ["Neon|Ride"] = 890.33, ["Neon|Fly|Ride"] = 1301.1, ["Mega|Fly|Ride"] = 4369.01}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.39, ["Fly"] = 61.63, ["Ride"] = 58, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 199.44, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 410.78, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 16.2, ["Fly|Ride"] = 39.38, ["Neon"] = 10.48, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 108.87, ["Mega"] = 59.15, ["Mega|Fly"] = 274.2, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 147.91}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.07, ["Fly"] = 34.93, ["Ride"] = 15.42, ["Fly|Ride"] = 55.48, ["Neon"] = 2.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.21, ["Neon|Fly|Ride"] = 102.54, ["Mega"] = 27.75, ["Mega|Fly"] = 137.62, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 155.4}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.39, ["Ride"] = 28.88, ["Fly|Ride"] = 69.27, ["Neon"] = 12.2, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 155.38, ["Mega"] = 121.52, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 369.74}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 11.49, ["Fly"] = 38.73, ["Ride"] = 23.83, ["Fly|Ride"] = 68.25, ["Neon"] = 44.63, ["Neon|Fly"] = 260.86, ["Neon|Ride"] = 45.2, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 350.48, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 353.96}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.56, ["Fly"] = 55.47, ["Ride"] = 39.37, ["Fly|Ride"] = 72.19, ["Neon"] = 48.28, ["Neon|Ride"] = 141.73, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 340.95, ["Mega|Ride"] = 359.48, ["Mega|Fly|Ride"] = 371.09}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly|Ride"] = 273.17, ["Neon"] = 3.5, ["Neon|Ride"] = 30.13, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 22.4, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.31}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Ride"] = 24.94, ["Fly|Ride"] = 65.63, ["Neon"] = 40.06, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 283.48}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 96.55, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.94, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 20.55, ["Fly|Ride"] = 61.63, ["Neon"] = 6.19, ["Neon|Ride"] = 22.49, ["Neon|Fly|Ride"] = 87.32, ["Mega"] = 45.52, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 682.5, ["Ride"] = 707.94, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12591.99}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.99, ["Fly|Ride"] = 34.13, ["Neon"] = 49.31, ["Neon|Fly"] = 20.55, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.39, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.54, ["Ride"] = 31.32, ["Fly|Ride"] = 162.33, ["Neon"] = 11.61, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 59.06, ["Mega|Fly"] = 315, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 278.32}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.97, ["Fly"] = 31.32, ["Ride"] = 22.32, ["Fly|Ride"] = 53.81, ["Neon"] = 47.25, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 106.32, ["Mega"] = 326.57, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 15.42, ["Fly|Ride"] = 33.6, ["Neon"] = 8.28, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.77, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 62.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 254.72}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 99.74, ["Ride"] = 72.19, ["Fly|Ride"] = 205.42, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1370.08}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.32, ["Neon"] = 7.87, ["Neon|Fly"] = 132.2, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 66.94, ["Mega|Ride"] = 114.02, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.84, ["Fly"] = 73.5, ["Ride"] = 22.31, ["Fly|Ride"] = 57.52, ["Neon"] = 19.69, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 118.13, ["Mega|Ride"] = 219.8, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.5, ["Fly"] = 26.25, ["Neon"] = 5.25, ["Neon|Fly"] = 62.63, ["Mega"] = 93.5, ["Mega|Fly"] = 410.78, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 88.33, ["Neon"] = 5.19, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.46, ["Neon|Fly|Ride"] = 90.38, ["Mega"] = 44.63, ["Mega|Fly"] = 211.56, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 31.5, ["Fly"] = 26.25, ["Ride"] = 20.56, ["Fly|Ride"] = 38.92, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 94.23, ["Mega"] = 821.55, ["Mega|Ride"] = 512.51, ["Mega|Fly|Ride"] = 456.36}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 790.44, ["Ride"] = 836.07, ["Fly|Ride"] = 918.75, ["Neon"] = 1771.88, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 7804.48, ["Mega|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 7350}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 15.6, ["Fly|Ride"] = 41.09, ["Neon"] = 2.1, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 17.62, ["Neon|Fly|Ride"] = 60.37, ["Mega"] = 26.25, ["Mega|Ride"] = 86.99, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.04, ["Ride"] = 27.75, ["Fly|Ride"] = 52.5, ["Neon"] = 27.57, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 260.86, ["Mega"] = 287.05, ["Mega|Ride"] = 351.21}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.12, ["Ride"] = 65.61, ["Fly|Ride"] = 124.69, ["Neon"] = 295.32, ["Neon|Ride"] = 268.84, ["Neon|Fly|Ride"] = 431.31, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 124.09, ["Ride"] = 66.11, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 192.05, ["Mega"] = 1918.27, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 729.23}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 15.75, ["Ride"] = 25.99, ["Fly|Ride"] = 123.59, ["Neon"] = 81.14, ["Neon|Ride"] = 133.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 354.9, ["Mega|Ride"] = 371.09, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.29, ["Ride"] = 92.78, ["Neon"] = 77.7, ["Neon|Ride"] = 123.24, ["Mega"] = 269.5, ["Mega|Fly"] = 503.21, ["Mega|Ride"] = 354.84, ["Mega|Fly|Ride"] = 452.93}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.42, ["Ride"] = 88.55, ["Neon"] = 177.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 651.15, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.18}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 5.91, ["Fly"] = 24.67, ["Ride"] = 27.75, ["Fly|Ride"] = 78.75, ["Neon"] = 34.05, ["Neon|Ride"] = 214.51, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 166.6, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.02, ["Neon"] = 14.59, ["Mega"] = 342.04}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.63, ["Fly"] = 410.84, ["Ride"] = 62.99, ["Fly|Ride"] = 118.29, ["Neon"] = 262.5, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 324.85, ["Mega|Fly|Ride"] = 1301.26}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.59, ["Fly"] = 24.67, ["Ride"] = 17.07, ["Fly|Ride"] = 39.37, ["Neon"] = 23, ["Neon|Fly"] = 76.54, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 66.1, ["Mega"] = 208.71, ["Mega|Fly"] = 409.75, ["Mega|Ride"] = 177.91, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.01, ["Ride"] = 31.32, ["Fly|Ride"] = 76.01, ["Neon"] = 17.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 118.13, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 285.53}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.66, ["Neon|Ride"] = 45.94, ["Mega"] = 47.52, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 40.68, ["Fly"] = 65.63, ["Ride"] = 61.64, ["Fly|Ride"] = 120.74, ["Neon"] = 137.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 1095.72, ["Mega|Ride"] = 821.64, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 26.35, ["Neon"] = 5.25, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66, ["Mega"] = 95.82, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.4, ["Ride"] = 73.5, ["Fly|Ride"] = 271.16, ["Neon"] = 91.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 382.05, ["Mega"] = 397.42, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.63, ["Fly"] = 23.62, ["Ride"] = 15.64, ["Fly|Ride"] = 59.57, ["Neon"] = 17.41, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 157.5, ["Mega|Ride"] = 261.85, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.67, ["Fly"] = 52.49, ["Ride"] = 20.68, ["Fly|Ride"] = 55.97, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 155.38, ["Mega|Ride"] = 382.08, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.81, ["Ride"] = 62.63, ["Fly|Ride"] = 131.25, ["Neon"] = 42.56, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.26, ["Ride"] = 123.26, ["Neon"] = 156.07, ["Neon|Ride"] = 263.21, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1025.89, ["Mega|Ride"] = 1629.92, ["Mega|Fly|Ride"] = 1159.6}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.56, ["Ride"] = 85.71, ["Neon"] = 122.88, ["Neon|Ride"] = 178.69, ["Neon|Fly|Ride"] = 143.79, ["Mega"] = 411.7, ["Mega|Ride"] = 328.67, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.24, ["Ride"] = 34.93, ["Neon"] = 48.45, ["Mega"] = 684.96, ["Mega|Ride"] = 685.05, ["Mega|Fly|Ride"] = 1643.28}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 10.5, ["Ride"] = 45.94, ["Fly|Ride"] = 520.62, ["Neon"] = 103.9, ["Neon|Ride"] = 273.17, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 718.85, ["Mega|Ride"] = 1083.25, ["Mega|Fly|Ride"] = 1083.08}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 104.99, ["Neon|Ride"] = 274.2, ["Mega"] = 155.38, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.63, ["Fly|Ride"] = 32.82, ["Neon"] = 6.55, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 50.43, ["Mega|Ride"] = 88.34, ["Mega|Fly|Ride"] = 159.72}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.87, ["Ride"] = 55.47, ["Fly|Ride"] = 72.19, ["Neon"] = 27.3, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 191.63, ["Mega|Ride"] = 270.13, ["Mega|Fly|Ride"] = 340.99}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.37, ["Fly|Ride"] = 55.95, ["Neon"] = 6.97, ["Neon|Fly"] = 31.32, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 46.69, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.48, ["Ride"] = 27.75, ["Fly|Ride"] = 118.13, ["Neon"] = 18.37, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 254.68, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 463.84}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.46, ["Ride"] = 32.96, ["Fly|Ride"] = 96.55, ["Neon"] = 29.29, ["Neon|Fly"] = 315, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 1027.05}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.62, ["Fly"] = 131.25, ["Ride"] = 25.98, ["Fly|Ride"] = 60.6, ["Neon"] = 33.77, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 263.21, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 227.22}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.77, ["Ride"] = 21, ["Fly|Ride"] = 51.68, ["Neon"] = 17.07, ["Neon|Fly"] = 82.17, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 100.89, ["Mega"] = 168, ["Mega|Ride"] = 226.99, ["Mega|Fly|Ride"] = 479.64}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.78, ["Fly"] = 57.75, ["Ride"] = 43.32, ["Fly|Ride"] = 179.82, ["Neon"] = 19.28, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 185.53, ["Mega"] = 100.89, ["Mega|Fly"] = 103.69, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 26.13, ["Fly"] = 137.64, ["Ride"] = 104.99, ["Fly|Ride"] = 192.05, ["Neon"] = 89.25, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 415.92, ["Mega|Fly"] = 667.5, ["Mega|Ride"] = 500.55, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.06, ["Ride"] = 97.13, ["Fly|Ride"] = 191.02, ["Neon"] = 249.38, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 359.43, ["Mega"] = 1050, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.56, ["Fly|Ride"] = 47.25, ["Neon"] = 2.63, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 104.36, ["Mega"] = 27.57, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 130.89}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 33.07, ["Neon|Ride"] = 192.05, ["Mega"] = 908.92, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.07, ["Fly"] = 105, ["Ride"] = 111.34, ["Neon"] = 289.88, ["Neon|Ride"] = 246.47, ["Mega"] = 1673.87, ["Mega|Ride"] = 1209.87, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.23, ["Fly"] = 190.32, ["Ride"] = 31.32, ["Fly|Ride"] = 91.88, ["Neon"] = 34.92, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 295.67, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 320.44}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.73, ["Ride"] = 110.44, ["Fly|Ride"] = 137.45, ["Neon"] = 6.19, ["Neon|Ride"] = 31.85, ["Mega"] = 55, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 77.06, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.6, ["Fly"] = 39.04, ["Ride"] = 17.89, ["Fly|Ride"] = 46.39, ["Neon"] = 12.73, ["Neon|Ride"] = 34.05, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 187.94, ["Mega|Fly"] = 343, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 231.94}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.07, ["Fly|Ride"] = 43.14, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 24.94, ["Mega|Ride"] = 69.56}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 74.26, ["Neon"] = 6.17, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 53.34, ["Mega|Fly"] = 168, ["Mega|Ride"] = 53.62, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 155.38, ["Neon"] = 2.63, ["Neon|Ride"] = 47.25, ["Mega"] = 20.55, ["Mega|Fly|Ride"] = 273.2}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.24, ["Ride"] = 44.18, ["Neon"] = 36.99, ["Neon|Ride"] = 46.39, ["Neon|Fly|Ride"] = 616.17, ["Mega"] = 137.62, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 245.24}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.22, ["Ride"] = 31.85, ["Fly|Ride"] = 189.96, ["Neon"] = 61.63, ["Neon|Ride"] = 102.71, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 410.78, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.25, ["Fly"] = 24.75, ["Ride"] = 19.68, ["Fly|Ride"] = 59.07, ["Neon"] = 27.75, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 91.76, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 66.93, ["Ride"] = 191.05, ["Fly|Ride"] = 262.5, ["Neon"] = 219.77, ["Neon|Ride"] = 597.19, ["Mega"] = 3092.24, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.65, ["Fly"] = 71.73, ["Ride"] = 32.82, ["Fly|Ride"] = 123.24, ["Neon"] = 65.73, ["Neon|Fly|Ride"] = 630, ["Mega"] = 619.16, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 16.27, ["Fly|Ride"] = 41.09, ["Neon"] = 2.63, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 39.03, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.41, ["Ride"] = 14.82, ["Fly|Ride"] = 31.49, ["Neon"] = 5.09, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 48.28, ["Mega"] = 42, ["Mega|Fly"] = 82.17, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 446.24, ["Ride"] = 464.63, ["Fly|Ride"] = 492.76, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 17.41, ["Ride"] = 68.82, ["Neon"] = 48.56, ["Neon|Ride"] = 109.87, ["Mega"] = 643.13, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.43, ["Fly|Ride"] = 39.38, ["Neon"] = 8.24, ["Neon|Fly"] = 68.81, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 46.39, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 77.44, ["Ride"] = 128.65, ["Fly|Ride"] = 341.25, ["Neon"] = 236.24, ["Neon|Ride"] = 342.04, ["Neon|Fly|Ride"] = 537.08, ["Mega"] = 735, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 19.53, ["Fly|Ride"] = 41.09, ["Neon"] = 13.13, ["Neon|Fly"] = 41.48, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 83.91, ["Mega|Fly"] = 137.62, ["Mega|Ride"] = 115.35, ["Mega|Fly|Ride"] = 194.49}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 34.12, ["Fly|Ride"] = 43.14, ["Neon"] = 3.71, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 17.45, ["Mega|Fly"] = 265.99, ["Mega|Ride"] = 65.22, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 48.28, ["Fly"] = 177.35, ["Ride"] = 86.6, ["Fly|Ride"] = 124.69, ["Neon"] = 178.69, ["Neon|Ride"] = 183.75, ["Mega"] = 721.88, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Mega"] = 40.6, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 44.18, ["Ride"] = 55.47, ["Fly|Ride"] = 131.25, ["Neon"] = 342.04, ["Neon|Ride"] = 298.85, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1622.53, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 1148.23}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.14, ["Ride"] = 53.01, ["Fly|Ride"] = 156.11, ["Neon"] = 21.27, ["Neon|Ride"] = 274.2, ["Mega"] = 144.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 463.84}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Fly"] = 68.82, ["Ride"] = 19.69, ["Fly|Ride"] = 65.73, ["Neon"] = 10.28, ["Neon|Fly"] = 77.03, ["Neon|Ride"] = 51.36, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 106.81, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.1, ["Ride"] = 55.46, ["Fly|Ride"] = 393.75, ["Neon"] = 176.26, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2051.77, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1086.62}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.63, ["Fly"] = 212.48, ["Ride"] = 33.64, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 151.9, ["Mega"] = 44.01, ["Mega|Fly"] = 242.19, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 155.4}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.88, ["Ride"] = 19.69, ["Fly|Ride"] = 102.88, ["Neon"] = 9.18, ["Neon|Fly"] = 41.09, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 96.55, ["Mega"] = 205.4, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.03, ["Fly"] = 45.21, ["Ride"] = 30.19, ["Fly|Ride"] = 81.14, ["Neon"] = 69.21, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 393.75, ["Mega|Ride"] = 410.81, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 24.66, ["Ride"] = 101.71, ["Fly|Ride"] = 60.6, ["Neon|Fly|Ride"] = 959.14, ["Mega"] = 926.66, ["Mega|Ride"] = 1848.67, ["Mega|Fly|Ride"] = 924.34}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.56, ["Fly"] = 51.18, ["Ride"] = 19.68, ["Fly|Ride"] = 73.96, ["Neon"] = 84, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 537.12, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 54.14, ["Fly"] = 289.92, ["Ride"] = 131.25, ["Fly|Ride"] = 298.88, ["Neon"] = 299.24, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 547.32, ["Mega|Ride"] = 1301.26, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.24, ["Ride"] = 41.1, ["Neon"] = 37.72, ["Neon|Ride"] = 77.7, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 314.26, ["Mega|Fly|Ride"] = 334.83}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.56, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 19.43, ["Neon|Ride"] = 72.93, ["Mega"] = 154.11, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.13, ["Fly"] = 52.49, ["Ride"] = 36.75, ["Fly|Ride"] = 92.77, ["Neon"] = 59.07, ["Neon|Ride"] = 164.33, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.51, ["Fly|Ride"] = 31.85, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 51.36, ["Mega"] = 15.08, ["Mega|Fly"] = 77.7, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 93.16}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.54, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Neon"] = 205.73, ["Neon|Fly"] = 2328.01, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 343, ["Mega"] = 1391.35, ["Mega|Ride"] = 1368.02, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 26.72, ["Fly|Ride"] = 106.81, ["Neon"] = 3.73, ["Neon|Ride"] = 41.09, ["Mega"] = 26.17, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 15.75, ["Fly|Ride"] = 43.31, ["Neon"] = 11.81, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 82.17, ["Mega"] = 257.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 75.93, ["Ride"] = 115.01, ["Fly|Ride"] = 260.86, ["Neon"] = 405.64, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 616.17, ["Mega"] = 1178.63, ["Mega|Ride"] = 1273.25, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.63, ["Ride"] = 22.61, ["Neon"] = 6.08, ["Neon|Ride"] = 65.63, ["Mega"] = 59.07, ["Mega|Fly"] = 155.38, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 232.97}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.97}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 31.32, ["Fly|Ride"] = 291.65, ["Neon"] = 5.24, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 45.2, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 222}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 98.44, ["Ride"] = 156.13, ["Fly|Ride"] = 270.1, ["Neon"] = 538.13, ["Neon|Ride"] = 680.6, ["Neon|Fly|Ride"] = 735, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2294.4}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.92, ["Ride"] = 36.82, ["Neon"] = 19.43, ["Neon|Ride"] = 63.68, ["Neon|Fly|Ride"] = 193.08, ["Mega"] = 173.25, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.42, ["Neon"] = 3.93, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.12, ["Ride"] = 26.72, ["Neon"] = 51.19, ["Neon|Ride"] = 109.9, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.5, ["Fly"] = 72.93, ["Ride"] = 26.7, ["Fly|Ride"] = 41.1, ["Neon"] = 77.04, ["Neon|Ride"] = 93.45, ["Neon|Fly|Ride"] = 137.62, ["Mega"] = 406.67, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 460.13}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 26.25, ["Fly"] = 137.64, ["Ride"] = 52.39, ["Neon"] = 142.67, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 619.16, ["Mega"] = 656.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 136.5, ["Fly"] = 247.57, ["Ride"] = 170.63, ["Fly|Ride"] = 214.47, ["Neon"] = 479.46, ["Neon|Fly"] = 753.77, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 640.4, ["Mega|Fly|Ride"] = 2198.44}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 24.69, ["Fly"] = 34.13, ["Ride"] = 29.75, ["Fly|Ride"] = 53.34, ["Neon"] = 477.71, ["Neon|Fly"] = 6161.44, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 200.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.24, ["Fly"] = 131.23, ["Ride"] = 31.32, ["Fly|Ride"] = 90.38, ["Neon"] = 20.88, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 86.98, ["Neon|Fly|Ride"] = 117.08, ["Mega"] = 99.75, ["Mega|Ride"] = 115.98, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.16, ["Fly"] = 131.25, ["Ride"] = 39.38, ["Neon"] = 41.09, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Ride"] = 88.34, ["Fly|Ride"] = 129.42, ["Neon"] = 220.48, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 209.9, ["Mega"] = 1079.46, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1078.41}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.07, ["Ride"] = 85.25, ["Neon"] = 155.38, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 452.88, ["Mega"] = 660.19, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.25, ["Ride"] = 369.74, ["Neon|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4518.95}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.32, ["Ride"] = 61.64, ["Fly|Ride"] = 104.76, ["Neon"] = 260.86, ["Neon|Ride"] = 294.52, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1229.71}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.42, ["Fly|Ride"] = 78.74, ["Neon"] = 2.61, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 20.88, ["Mega|Fly"] = 102.71, ["Mega|Ride"] = 40.59, ["Mega|Fly|Ride"] = 109.5}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.54, ["Ride"] = 19.53, ["Neon"] = 15.42, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 246.47, ["Mega"] = 196.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 405.69}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.24, ["Ride"] = 41.1, ["Fly|Ride"] = 144.16, ["Neon"] = 17.41, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 112.14, ["Mega|Fly"] = 534, ["Mega|Ride"] = 184.88, ["Mega|Fly|Ride"] = 231.94}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 334.69, ["Fly"] = 619.24, ["Ride"] = 406.88, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1675.92, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 5751.57, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.51, ["Fly"] = 54.74, ["Ride"] = 15.42, ["Fly|Ride"] = 48.28, ["Neon"] = 24.94, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 80.12, ["Mega"] = 131.25, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 569}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.75, ["Fly"] = 22.31, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.05, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.25, ["Fly"] = 39.44, ["Ride"] = 27.55, ["Fly|Ride"] = 82.18, ["Neon"] = 15.74, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 129.41, ["Mega"] = 137.62, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 55.47, ["Fly"] = 137.64, ["Ride"] = 52.5, ["Fly|Ride"] = 62.34, ["Neon"] = 139.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.68, ["Fly|Ride"] = 69.84, ["Neon"] = 15.42, ["Neon|Ride"] = 114.19, ["Mega"] = 158.86, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.4, ["Fly"] = 787.5, ["Ride"] = 31.85, ["Fly|Ride"] = 85.31, ["Neon"] = 123.38, ["Neon|Ride"] = 155.42, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Fly|Ride"] = 41.18, ["Neon"] = 3.4, ["Neon|Ride"] = 28.75, ["Mega"] = 39.38, ["Mega|Ride"] = 129.42, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.13, ["Ride"] = 134.56, ["Neon"] = 82.17, ["Neon|Ride"] = 204.39, ["Mega"] = 155.93, ["Mega|Ride"] = 287.59}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.5, ["Ride"] = 78.07, ["Fly|Ride"] = 69.59, ["Neon"] = 104.9, ["Neon|Ride"] = 101.68, ["Neon|Fly|Ride"] = 410.78, ["Mega"] = 328.13, ["Mega|Ride"] = 342.09, ["Mega|Fly|Ride"] = 483.75}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.66, ["Fly"] = 19.69, ["Ride"] = 26.23, ["Fly|Ride"] = 59.4, ["Neon"] = 45.93, ["Neon|Fly"] = 115.97, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 577.14, ["Mega|Ride"] = 411.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 233.16, ["Fly"] = 369.74, ["Ride"] = 260.88, ["Fly|Ride"] = 367.5, ["Neon"] = 1391.35, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 959.14, ["Mega|Fly|Ride"] = 4642.19}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.61, ["Fly|Ride"] = 56.79, ["Neon"] = 9.56, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 33.64, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 219.77, ["Mega|Ride"] = 155.4, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.55, ["Fly"] = 109.91, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 17.41, ["Neon|Ride"] = 35.96, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 45.7, ["Ride"] = 104.37, ["Neon"] = 103.58, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 393.74, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 516.48}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 117.75, ["Fly"] = 393.75, ["Ride"] = 219.8, ["Fly|Ride"] = 294.52, ["Neon"] = 584.07, ["Neon|Ride"] = 616.17, ["Neon|Fly|Ride"] = 1109.08, ["Mega"] = 2318.91, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 25.99, ["Fly"] = 109.91, ["Ride"] = 55.47, ["Fly|Ride"] = 106.81, ["Neon"] = 84, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 268.98, ["Mega|Ride"] = 288.21, ["Mega|Fly|Ride"] = 529.97}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.62, ["Ride"] = 14.97, ["Fly|Ride"] = 58.47, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 193.67, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 12.77, ["Ride"] = 48.57, ["Neon"] = 99.72, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 124.08, ["Mega"] = 216.83, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 64.31, ["Fly"] = 96.56, ["Ride"] = 114.7, ["Fly|Ride"] = 137.64, ["Neon"] = 133.51, ["Neon|Ride"] = 175.09, ["Neon|Fly|Ride"] = 303.09, ["Mega"] = 449.89, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 77.44, ["Fly|Ride"] = 55.47, ["Neon"] = 7.88, ["Neon|Ride"] = 204.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.75, ["Mega|Fly"] = 240.32, ["Mega|Ride"] = 129.42, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 16.45, ["Ride"] = 361.53, ["Neon"] = 114.19, ["Neon|Ride"] = 401.03, ["Mega"] = 443.63, ["Mega|Fly|Ride"] = 753.85}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 944.99, ["Fly"] = 1215.26, ["Ride"] = 1001.31, ["Fly|Ride"] = 1096.07, ["Neon|Ride"] = 3491.49, ["Neon|Fly|Ride"] = 2743.12, ["Mega|Fly|Ride"] = 12856.39}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 31.5, ["Fly"] = 115.98, ["Ride"] = 68.82, ["Fly|Ride"] = 187.69, ["Neon"] = 164.33, ["Neon|Fly"] = 278.25, ["Neon|Ride"] = 567, ["Neon|Fly|Ride"] = 309.59, ["Mega"] = 959.14, ["Mega|Ride"] = 546.39, ["Mega|Fly|Ride"] = 702.27}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.66, ["Fly"] = 49.25, ["Ride"] = 23.21, ["Fly|Ride"] = 80.89, ["Neon"] = 13.1, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 152, ["Mega"] = 92.77, ["Mega|Ride"] = 86.28, ["Mega|Fly|Ride"] = 155.92}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 26.7, ["Ride"] = 131.22, ["Fly|Ride"] = 68.82, ["Neon"] = 102.71, ["Neon|Fly|Ride"] = 137.62, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 487.86}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Fly|Ride"] = 52.5, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 16.59, ["Mega|Fly"] = 123.24, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 127.68}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 68.82, ["Ride"] = 118.13, ["Fly|Ride"] = 255.93, ["Neon"] = 275.62, ["Neon|Ride"] = 344.6, ["Neon|Fly|Ride"] = 479.58, ["Mega"] = 1100.15, ["Mega|Ride"] = 1105.12, ["Mega|Fly|Ride"] = 1091.9}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.25, ["Fly"] = 174.57, ["Ride"] = 24.94, ["Fly|Ride"] = 68.82, ["Neon"] = 19.84, ["Neon|Ride"] = 78.75, ["Mega"] = 462.63, ["Mega|Ride"] = 367.69, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.57, ["Fly"] = 97.69, ["Ride"] = 20.56, ["Neon"] = 11.2, ["Neon|Ride"] = 55.49, ["Mega"] = 97.13, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 363.59}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 32.47, ["Fly"] = 73.07, ["Ride"] = 52.5, ["Fly|Ride"] = 155.4, ["Neon"] = 200.82, ["Neon|Fly"] = 274.2, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 330.68, ["Mega"] = 496.26, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 680.69}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 39.44, ["Ride"] = 89.36, ["Fly|Ride"] = 190.32, ["Neon"] = 525, ["Neon|Ride"] = 174.6, ["Neon|Fly|Ride"] = 164.33, ["Mega"] = 427.23, ["Mega|Ride"] = 504.14, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.06, ["Neon"] = 309.59, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 431.31, ["Mega"] = 1505.64, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.98, ["Neon"] = 21, ["Neon|Ride"] = 85.81, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 107.93, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 265.53}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.48, ["Ride"] = 19.68, ["Fly|Ride"] = 52.49, ["Neon"] = 44.17, ["Neon|Ride"] = 69.59, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 364.13, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Ride"] = 137.65, ["Fly|Ride"] = 292.2, ["Neon"] = 508.33, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 514.56, ["Mega"] = 3140.28, ["Mega|Ride"] = 2333.63, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.31, ["Fly"] = 21.95, ["Ride"] = 18.27, ["Fly|Ride"] = 32.82, ["Neon"] = 11.24, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 96.55, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 197.78}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 37.13, ["Ride"] = 23.21, ["Fly|Ride"] = 78.75, ["Neon"] = 41.09, ["Neon|Fly"] = 309.59, ["Neon|Ride"] = 55.69, ["Neon|Fly|Ride"] = 175.62, ["Mega"] = 343, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 40.85, ["Neon"] = 2.61, ["Neon|Fly"] = 24.9, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 41.91, ["Mega"] = 14.54, ["Mega|Fly"] = 48.7, ["Mega|Ride"] = 27.56, ["Mega|Fly|Ride"] = 119.16}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.42, ["Neon"] = 3.93, ["Neon|Ride"] = 39.03, ["Mega"] = 23.2, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 51.98, ["Mega|Fly|Ride"] = 158.18}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 128.8, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 41.09, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 232.98}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.76, ["Ride"] = 196.88, ["Neon"] = 326.82, ["Neon|Ride"] = 410.78, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.54}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 17.05, ["Fly|Ride"] = 37.11, ["Neon"] = 14.73, ["Neon|Fly"] = 31.85, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 69.04, ["Mega"] = 114.19, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 176.87}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.75, ["Fly"] = 32.7, ["Ride"] = 23.62, ["Fly|Ride"] = 63.53, ["Neon"] = 19.38, ["Neon|Fly"] = 60.6, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 48.28, ["Mega"] = 169.31, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.15, ["Fly"] = 19.69, ["Ride"] = 16.45, ["Fly|Ride"] = 39.38, ["Neon"] = 9.07, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.6, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.95, ["Fly"] = 169.32, ["Ride"] = 45.93, ["Fly|Ride"] = 52.5, ["Neon"] = 48.28, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 164.33, ["Mega"] = 219.77, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.88, ["Mega|Fly|Ride"] = 631.64}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Fly"] = 170.5, ["Ride"] = 68.82, ["Fly|Ride"] = 220.34, ["Neon"] = 91.77, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343, ["Mega"] = 387.27, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 48.57, ["Ride"] = 18.19, ["Fly|Ride"] = 63.66, ["Neon"] = 27.75, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 309.59, ["Mega|Ride"] = 219.8, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.74, ["Ride"] = 15.42, ["Fly|Ride"] = 27.76, ["Neon"] = 10.39, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 62.63, ["Mega"] = 78.75, ["Mega|Ride"] = 89.36, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 188.99, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 196.87, ["Neon"] = 944.77, ["Neon|Ride"] = 1232.3, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2619.75}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.08, ["Ride"] = 61.76, ["Neon"] = 42.94, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 118.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 20.68, ["Fly|Ride"] = 76.01, ["Neon"] = 22.32, ["Neon|Fly"] = 205.4, ["Neon|Ride"] = 82.17, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 196.88, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 18.57, ["Ride"] = 24.67, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.17, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 15.42, ["Fly|Ride"] = 34.93, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 17.74, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 24.67, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.18, ["Fly"] = 41.1, ["Ride"] = 15.74, ["Fly|Ride"] = 58.97, ["Neon"] = 8.86, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 103.81, ["Mega|Ride"] = 123.69, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 48.28, ["Fly|Ride"] = 97.57, ["Neon"] = 26.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.07, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.82, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 167.41, ["Neon"] = 393.75, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2053.83, ["Mega|Ride"] = 3425.17, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.89, ["Fly"] = 85.32, ["Ride"] = 32.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.09, ["Neon|Ride"] = 54.5, ["Neon|Fly|Ride"] = 109.89, ["Mega"] = 211.54, ["Mega|Ride"] = 320.44, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.52, ["Fly"] = 21, ["Ride"] = 46.91, ["Fly|Ride"] = 118.13, ["Neon"] = 8.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 41.09, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 122.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.94, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 220.31, ["Neon"] = 118.13, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 459.38, ["Mega|Ride"] = 513.65, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 15.42, ["Fly|Ride"] = 35.96, ["Neon"] = 2.63, ["Neon|Fly"] = 22.04, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 18.37, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 34.95, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 92.76, ["Mega"] = 77.7, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.02, ["Fly"] = 72.19, ["Ride"] = 26.17, ["Neon"] = 7.8, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 180.75, ["Mega"] = 65.63, ["Mega|Fly"] = 178.69, ["Mega|Ride"] = 116.15, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.27, ["Fly"] = 69.59, ["Ride"] = 49.31, ["Fly|Ride"] = 111.57, ["Neon"] = 39.37, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 70.67, ["Neon|Fly|Ride"] = 222.74, ["Mega"] = 97.13, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 180.71, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.89, ["Fly|Ride"] = 35.96, ["Neon"] = 2.63, ["Neon|Fly"] = 18.9, ["Neon|Ride"] = 24.66, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 21.56, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.17, ["Mega|Fly|Ride"] = 151.93}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.07, ["Fly"] = 72.19, ["Ride"] = 41.1, ["Fly|Ride"] = 100.89, ["Neon"] = 78.75, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 496.26, ["Mega|Ride"] = 409.8, ["Mega|Fly|Ride"] = 684.03}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Fly"] = 3150, ["Ride"] = 2756.25, ["Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 35878.35}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 146.13, ["Ride"] = 15.4, ["Fly|Ride"] = 43.25, ["Neon"] = 7.87, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 25.97, ["Neon|Fly|Ride"] = 72.93, ["Mega"] = 72.19, ["Mega|Fly"] = 149.94, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.82, ["Neon"] = 21.27, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.4, ["Fly"] = 41.1, ["Ride"] = 32.8, ["Fly|Ride"] = 69.57, ["Neon"] = 62.63, ["Neon|Ride"] = 89.35, ["Neon|Fly|Ride"] = 100.69, ["Mega"] = 393.65, ["Mega|Ride"] = 392.02, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 34.8, ["Ride"] = 98.44, ["Neon"] = 137.62, ["Neon|Ride"] = 216.83, ["Mega"] = 540.75, ["Mega|Ride"] = 799.04, ["Mega|Fly|Ride"] = 804.78}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 167.13, ["Fly"] = 1370.08, ["Ride"] = 196.83, ["Fly|Ride"] = 237.23, ["Neon"] = 1312.5, ["Neon|Ride"] = 717.82, ["Neon|Fly|Ride"] = 718.85, ["Mega"] = 6161.44, ["Mega|Ride"] = 3476.46, ["Mega|Fly|Ride"] = 3014.55}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.09, ["Fly"] = 27.75, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 13.13, ["Neon|Ride"] = 128.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 123.24, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 217.56, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 68.82, ["Fly|Ride"] = 92.78, ["Neon"] = 15.42, ["Neon|Fly"] = 96.55, ["Neon|Fly|Ride"] = 513.47, ["Mega"] = 114.76, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.05, ["Fly"] = 101.98, ["Ride"] = 44.08, ["Fly|Ride"] = 196.88, ["Neon"] = 9.19, ["Neon|Ride"] = 39.43, ["Mega"] = 68.83, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 307.1}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17.41, ["Ride"] = 39.38, ["Neon"] = 64.32, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 602.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 89.67, ["Mega"] = 17.05, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 65.63, ["Fly"] = 137.64, ["Ride"] = 78.74, ["Fly|Ride"] = 137.62, ["Neon"] = 410.78, ["Neon|Fly"] = 309.59, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 410.78, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.49, ["Ride"] = 32.82, ["Neon"] = 9.87, ["Neon|Ride"] = 137.62, ["Mega"] = 61.69, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 40.82, ["Fly"] = 216.86, ["Ride"] = 74.81, ["Fly|Ride"] = 131.23, ["Neon"] = 262.5, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 396.73, ["Mega"] = 2625, ["Mega|Ride"] = 1848.67, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.53, ["Fly|Ride"] = 50.28, ["Neon"] = 6.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 43.32, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 18.38, ["Neon|Ride"] = 39.38, ["Mega"] = 360.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 356.01}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.44, ["Fly|Ride"] = 204.44, ["Neon"] = 41.1, ["Neon|Ride"] = 82.17, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 221.83, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 355.69, ["Fly"] = 548.45, ["Ride"] = 415.8, ["Fly|Ride"] = 498.75, ["Neon"] = 1181.24, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 3780}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.09, ["Fly"] = 68.82, ["Ride"] = 51.68, ["Fly|Ride"] = 126, ["Neon"] = 205.4, ["Neon|Ride"] = 219.85, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 1211.91, ["Mega|Fly|Ride"] = 1005.37}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 19.53, ["Fly|Ride"] = 91.88, ["Neon"] = 7.8, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 68.81, ["Mega"] = 49.88, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 16.45, ["Fly"] = 359.48, ["Ride"] = 45.94, ["Fly|Ride"] = 132.2, ["Neon"] = 36.75, ["Neon|Fly"] = 105, ["Neon|Ride"] = 108.99, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 238.88, ["Mega|Fly"] = 382.03, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 341.16}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.39, ["Ride"] = 23.12, ["Fly|Ride"] = 102.71, ["Neon"] = 138.65, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 309.59, ["Mega"] = 410.78, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 384.76}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.15, ["Neon"] = 15.75, ["Mega"] = 53.42, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.84, ["Fly"] = 39.38, ["Ride"] = 18.18, ["Fly|Ride"] = 47.25, ["Neon"] = 13.13, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.5, ["Mega"] = 57.75, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 956.18}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.4, ["Ride"] = 127.32, ["Fly|Ride"] = 178.69, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 3348.14}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.57, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 137.62, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 656.25, ["Mega|Ride"] = 667.58, ["Mega|Fly|Ride"] = 765.35}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.38, ["Ride"] = 2100, ["Fly|Ride"] = 2349.38, ["Neon"] = 10954, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.5, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 11.31, ["Neon|Ride"] = 135.55, ["Neon|Fly|Ride"] = 192.05, ["Mega"] = 118.13, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 574.12}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 11.82, ["Ride"] = 39.38, ["Neon"] = 45.92, ["Neon|Ride"] = 104.86, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 211.49, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 509.92}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 853.13, ["Fly"] = 1187.43, ["Ride"] = 913.49, ["Fly|Ride"] = 975.19, ["Neon"] = 2598.75, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 11487}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 40.06, ["Ride"] = 56.44, ["Fly|Ride"] = 134.54, ["Neon"] = 157.5, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 369.7, ["Mega"] = 840, ["Mega|Ride"] = 773.47, ["Mega|Fly|Ride"] = 808.28}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.91, ["Fly|Ride"] = 128.09, ["Neon"] = 17.41, ["Neon|Ride"] = 41.09, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 137.64, ["Neon"] = 4.13, ["Neon|Ride"] = 40.65, ["Neon|Fly|Ride"] = 77.7, ["Mega"] = 27.72, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 80.56, ["Ride"] = 127.32, ["Fly|Ride"] = 287.55, ["Neon"] = 459.38, ["Neon|Ride"] = 433.64, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2738.76, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.8, ["Fly|Ride"] = 72.19, ["Neon"] = 20.99, ["Neon|Ride"] = 61.63, ["Mega"] = 137.82, ["Mega|Ride"] = 203.37, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 58.61, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2328.01, ["Mega|Fly|Ride"] = 2039.62}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.66, ["Fly"] = 105, ["Fly|Ride"] = 109.89, ["Neon"] = 39.37, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 203.44, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 233.62, ["Ride"] = 306, ["Fly|Ride"] = 322.44, ["Neon"] = 1080.99, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879, ["Mega|Fly|Ride"] = 4230.36}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 4.66, ["Fly"] = 87.93, ["Ride"] = 26.36, ["Fly|Ride"] = 52.39, ["Neon"] = 31.32, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 14.48, ["Fly|Ride"] = 37.41, ["Neon"] = 5.15, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 22.29, ["Neon|Fly|Ride"] = 52.88, ["Mega"] = 52.5, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 64.72, ["Mega|Fly|Ride"] = 155.39}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 985.97, ["Fly|Ride"] = 1027.3, ["Neon|Ride"] = 7531.33, ["Neon|Fly|Ride"] = 4723.78, ["Mega"] = 26015.59, ["Mega|Fly|Ride"] = 27387.87}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.49, ["Fly"] = 959.26, ["Ride"] = 210, ["Neon"] = 66.94, ["Neon|Ride"] = 129.29, ["Mega"] = 235.9, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 326.17}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 10.5, ["Fly"] = 46.09, ["Ride"] = 32.82, ["Fly|Ride"] = 127.32, ["Neon"] = 24.85, ["Neon|Fly"] = 77.7, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 175.13, ["Mega|Ride"] = 165.13, ["Mega|Fly|Ride"] = 296.88}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.93, ["Fly"] = 40.45, ["Ride"] = 44.16, ["Fly|Ride"] = 63.27, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2053.83, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 18.5, ["Fly"] = 77.04, ["Ride"] = 31.85, ["Fly|Ride"] = 87.94, ["Neon"] = 48.28, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 96.55, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 343, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 435.48}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.67, ["Ride"] = 209.99, ["Fly|Ride"] = 118.13, ["Neon"] = 96.55, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 483.69, ["Mega|Ride"] = 573.11, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 15.42, ["Fly|Ride"] = 231.91, ["Neon"] = 2.9, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 72.01, ["Mega"] = 17.07, ["Mega|Fly"] = 57.75, ["Mega|Ride"] = 64.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 49.31, ["Fly"] = 89.25, ["Ride"] = 68.84, ["Fly|Ride"] = 130.87, ["Neon"] = 339.92, ["Neon|Fly"] = 323.5, ["Neon|Ride"] = 267.01, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 3286.12, ["Mega|Ride"] = 1098.15, ["Mega|Fly|Ride"] = 956.71}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.58, ["Fly"] = 27.75, ["Ride"] = 18.54, ["Fly|Ride"] = 69.92, ["Neon"] = 32.81, ["Neon|Ride"] = 39.38, ["Mega"] = 773.07, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.56, ["Fly|Ride"] = 38.05, ["Neon"] = 12.71, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.12, ["Ride"] = 171.53, ["Neon"] = 105, ["Neon|Fly"] = 52.5, ["Neon|Fly|Ride"] = 183.83, ["Mega"] = 246.47, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 24.93, ["Fly"] = 262.4, ["Ride"] = 86.99, ["Fly|Ride"] = 183.75, ["Neon"] = 105, ["Neon|Ride"] = 243.6, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 726.03, ["Mega|Ride"] = 844.59, ["Mega|Fly|Ride"] = 756}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.59, ["Ride"] = 685.05, ["Neon"] = 21.77, ["Neon|Ride"] = 77.03, ["Neon|Fly|Ride"] = 77.7, ["Mega"] = 91.24, ["Mega|Fly"] = 302.95, ["Mega|Fly|Ride"] = 309.63}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.61, ["Neon|Ride"] = 20.6, ["Mega"] = 15.75, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 25.08, ["Fly|Ride"] = 81.06, ["Neon"] = 2.56, ["Neon|Ride"] = 31.75, ["Mega"] = 16.64, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 106.32}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 15.42, ["Fly|Ride"] = 49.31, ["Neon"] = 7.86, ["Neon|Fly"] = 123.24, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 61.69, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.62, ["Ride"] = 27.75, ["Fly|Ride"] = 109.89, ["Neon"] = 17.41, ["Mega"] = 105, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.41, ["Fly|Ride"] = 35.44, ["Neon"] = 14.42, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 69.96, ["Ride"] = 109.03, ["Neon"] = 164.06, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1026.92, ["Mega"] = 694.32, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 926.52}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 18.5, ["Ride"] = 16.45, ["Fly|Ride"] = 38.66, ["Neon"] = 2.63, ["Neon|Fly"] = 24.66, ["Neon|Ride"] = 20.55, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.83, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 100.61}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 60.4, ["Ride"] = 39.38, ["Fly|Ride"] = 74.81, ["Neon"] = 41.09, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 262.5, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.95, ["Fly"] = 52.39, ["Ride"] = 28.46, ["Fly|Ride"] = 72.19, ["Neon"] = 94.49, ["Neon|Fly"] = 108.99, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1160.41, ["Mega|Ride"] = 520.72, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.96, ["Fly"] = 196.88, ["Neon"] = 60.6, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 405.69}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 5.18, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.83, ["Mega"] = 51.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 62.07, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.24, ["Fly"] = 68.82, ["Ride"] = 27.75, ["Neon"] = 15.41, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 373.85}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 945, ["Fly"] = 1230.41, ["Ride"] = 984.25, ["Fly|Ride"] = 1055.87, ["Neon|Ride"] = 2191.86, ["Neon|Fly|Ride"] = 2336.24, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.73, ["Fly"] = 155.4, ["Ride"] = 118.13, ["Fly|Ride"] = 408.73, ["Neon"] = 322.46, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 589.46, ["Mega"] = 2782.68, ["Mega|Ride"] = 1918.51, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.62, ["Ride"] = 39.38, ["Neon"] = 5.23, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.4, ["Mega"] = 72.19, ["Mega|Ride"] = 102.72, ["Mega|Fly|Ride"] = 178.71}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 53.51, ["Fly"] = 142.77, ["Ride"] = 75.85, ["Fly|Ride"] = 170.62, ["Neon"] = 236.25, ["Neon|Ride"] = 312.14, ["Neon|Fly|Ride"] = 369.7, ["Mega"] = 1023.75, ["Mega|Ride"] = 1130.05, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.41, ["Ride"] = 20.13, ["Fly|Ride"] = 65.63, ["Neon"] = 61.85, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.17, ["Mega"] = 118.13, ["Mega|Ride"] = 345.1, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 251.99, ["Fly"] = 410.83, ["Ride"] = 273, ["Fly|Ride"] = 315.28, ["Neon|Ride"] = 1309.31, ["Neon|Fly|Ride"] = 1386.34, ["Mega|Fly|Ride"] = 4313.55}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.37, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.13, ["Neon"] = 24.66, ["Neon|Ride"] = 54.37, ["Mega"] = 406.67, ["Mega|Fly"] = 320.41}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.62, ["Ride"] = 26.17, ["Neon"] = 32.82, ["Neon|Ride"] = 82.17, ["Mega"] = 328.63, ["Mega|Ride"] = 326.62}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 48.3, ["Fly"] = 155.4, ["Ride"] = 96.56, ["Fly|Ride"] = 525, ["Neon"] = 548.39, ["Neon|Ride"] = 387.27, ["Mega"] = 542, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 965.99}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.54, ["Neon"] = 20.48, ["Mega"] = 78.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 453.5}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.33, ["Fly|Ride"] = 32.82, ["Neon"] = 3.65, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 24.67, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 102.05}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4068.75, ["Neon"] = 30807.13, ["Neon|Fly|Ride"] = 21633.8, ["Mega|Fly|Ride"] = 84901.66}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.81, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 57.75, ["Neon|Ride"] = 106.32, ["Mega"] = 271.11, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.63, ["Fly"] = 20.09, ["Ride"] = 19.68, ["Fly|Ride"] = 55.46, ["Neon"] = 16.94, ["Neon|Fly"] = 46.39, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 131.25, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 459.38, ["Fly"] = 840, ["Ride"] = 482.03, ["Fly|Ride"] = 570, ["Neon"] = 1372.81, ["Neon|Ride"] = 1546.53, ["Neon|Fly|Ride"] = 1380.56, ["Mega|Fly|Ride"] = 5078.07}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 11.82, ["Ride"] = 24.99, ["Neon"] = 17.06, ["Neon|Ride"] = 145.69, ["Mega"] = 129.94, ["Mega|Ride"] = 619.24, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.96, ["Fly"] = 137.64, ["Ride"] = 46.4, ["Neon"] = 102.71, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 408.73, ["Mega|Ride"] = 369.74, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.65, ["Fly|Ride"] = 82.17, ["Neon"] = 3.89, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.6, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 35.96, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 255.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 735, ["Fly"] = 808.28, ["Ride"] = 651.02, ["Fly|Ride"] = 705.46, ["Neon"] = 2362.5, ["Neon|Ride"] = 1957.32, ["Neon|Fly|Ride"] = 1910.27}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.16, ["Ride"] = 78.74, ["Neon"] = 26.25, ["Neon|Ride"] = 77.03, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 144.29, ["Mega|Ride"] = 171.53, ["Mega|Fly|Ride"] = 294.67}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.2, ["Fly"] = 236.15, ["Ride"] = 63.14, ["Neon"] = 34.8, ["Neon|Fly"] = 164.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 183.75, ["Mega|Ride"] = 226.42, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 19.53, ["Fly|Ride"] = 47.25, ["Neon"] = 13.54, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 65.63, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 16.86, ["Ride"] = 21, ["Neon"] = 118.13, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 135.56, ["Mega"] = 463.8, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 205.4, ["Neon"] = 5.19, ["Neon|Fly"] = 137.62, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 183.83, ["Mega"] = 36.37, ["Mega|Fly"] = 109.89, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 302.99}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 466.29, ["Ride"] = 533.5, ["Fly|Ride"] = 696.25, ["Neon"] = 2589.57, ["Neon|Ride"] = 2706.16, ["Neon|Fly|Ride"] = 2464.59, ["Mega|Ride"] = 9044.81, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 68.82, ["Fly|Ride"] = 178.58, ["Neon"] = 11.81, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 55.47, ["Mega|Ride"] = 152.38, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 4.86, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 52.5, ["Mega|Fly"] = 100.66, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 258.83}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.25, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Fly"] = 152, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 192.07}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 4.13, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 39.43, ["Mega"] = 224.9}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 39.44, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 201.84, ["Neon"] = 178.69, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 617.25, ["Mega|Ride"] = 625.73, ["Mega|Fly|Ride"] = 669.73}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.42, ["Ride"] = 68.13, ["Fly|Ride"] = 116.6, ["Neon"] = 102.27, ["Neon|Ride"] = 128.42, ["Mega"] = 463.74, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 560.78}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.03, ["Fly"] = 24.67, ["Ride"] = 13.79, ["Fly|Ride"] = 38.06, ["Neon"] = 15.42, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 299.92, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.31, ["Ride"] = 64.32, ["Fly|Ride"] = 102.71, ["Neon"] = 89.25, ["Neon|Ride"] = 68.81, ["Mega"] = 183.75, ["Mega|Ride"] = 215.7, ["Mega|Fly|Ride"] = 959.26}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Ride"] = 24.93, ["Fly|Ride"] = 60.6, ["Neon"] = 15.21, ["Neon|Ride"] = 33.64, ["Neon|Fly|Ride"] = 206.39, ["Mega"] = 83.98, ["Mega|Fly"] = 147.9, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.05, ["Fly"] = 62.63, ["Ride"] = 23.14, ["Fly|Ride"] = 155.38, ["Neon"] = 228.74, ["Neon|Ride"] = 147.93, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 973.94, ["Mega|Ride"] = 927.68, ["Mega|Fly|Ride"] = 607.69}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.12, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 849.36}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 62.91, ["Fly"] = 82.18, ["Ride"] = 71.54, ["Fly|Ride"] = 163.66, ["Neon"] = 249.38, ["Neon|Fly"] = 431.31, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 349.13, ["Mega|Ride"] = 1437.86, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 45.48, ["Fly"] = 88.05, ["Ride"] = 104.99, ["Fly|Ride"] = 94.5, ["Neon"] = 129.7, ["Neon|Ride"] = 408.19, ["Neon|Fly|Ride"] = 355.97, ["Mega"] = 537.92, ["Mega|Ride"] = 572.25, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 35.86, ["Ride"] = 35.96, ["Fly|Ride"] = 137.62, ["Neon"] = 127.32, ["Mega"] = 821.63, ["Mega|Fly|Ride"] = 750.78}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.07, ["Fly"] = 410.83, ["Ride"] = 46.05, ["Fly|Ride"] = 137.62, ["Neon"] = 86.15, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 457.47, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 484.67}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.41, ["Fly|Ride"] = 32.55, ["Neon"] = 5.24, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 41.99, ["Mega|Fly"] = 205.4, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.26, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 246.47, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 683.93, ["Mega|Ride"] = 602.44, ["Mega|Fly|Ride"] = 734.35}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.47, ["Neon"] = 6.04, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 287.55, ["Mega"] = 28.88, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 152.02}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 32.34, ["Ride"] = 74.24, ["Neon"] = 124.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 702.51, ["Mega|Fly|Ride"] = 754.69}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Ride"] = 105, ["Mega"] = 25.91}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 46.39, ["Mega"] = 24.23, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 114.58, ["Ride"] = 141.03, ["Neon"] = 498.75, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 671.61, ["Mega|Ride"] = 2257.74, ["Mega|Fly|Ride"] = 2098.68}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 10.28, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.56, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 61.63, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.71, ["Mega"] = 32.03, ["Mega|Ride"] = 122.24, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.75, ["Neon|Ride"] = 44.18, ["Mega"] = 32.32, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.25, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 32.82, ["Ride"] = 102.72, ["Fly|Ride"] = 449.61, ["Neon"] = 410.78, ["Neon|Ride"] = 486.76, ["Neon|Fly|Ride"] = 684.96, ["Mega|Fly|Ride"] = 1363.91}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.81, ["Ride"] = 62.63, ["Fly|Ride"] = 131.25, ["Neon"] = 42.56, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.83, ["Fly|Ride"] = 616.88, ["Neon"] = 1641, ["Neon|Ride"] = 1642.04, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.11, ["Mega|Fly|Ride"] = 3697.33}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 86.63}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 45.68}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.63}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 58.58}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.57}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.12}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.56}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.28}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.49}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.37}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 157.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 10.43}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 509.24}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 923.53}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.98}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.62}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.24}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.37}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 57.18}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.68}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.58}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.88}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.91}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 12.99}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 13.62}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 131.72}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.35}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.54}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1836.01}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.34}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 6.65}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.94}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.57}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2049.97}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 21}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 5.25}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.62}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.68}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.12}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.94}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 37.8}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 11.82}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.81}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.44}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 35.44}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 126}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.24}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.64}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 20.9}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 26.25}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22032.2}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 548.45}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.2}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 40.36}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 274.23}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 85.32}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 29.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 66.93}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 66.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.98}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.35}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 328.21}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.49}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 4.61}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 82.69}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.55}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.25}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.34}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1052.92}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.8}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 577.4}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 24.94}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.63}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 43.32}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 69.59}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 48.57}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 45.94}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.81}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.73}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.8}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.59}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 21}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 153.41}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 84}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 3.94}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 9654.11}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.62}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 46.4}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 8.24}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 14.3}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 9.19}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 82.18}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 27.76}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.17}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 26.25}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 3.84}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 3.93}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.4}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.48}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5672.93}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 44.89}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.06}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.43}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.86}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.27}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.49}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.24}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 10.91}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4058.57}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.37}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.32}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 52.48}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 51.01}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.55}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.24}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.87}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.77}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.64}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 137.64}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 31.5}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.28}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.42}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.56}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.26}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 6.18}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 17.75}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 1706.24}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.99}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 86.63}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 39.37}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.82}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.37}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 9.96}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.92}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 68.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.17}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.59}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.19}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.96}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.47}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 16.45}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.12}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.62}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.24}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 11.62}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.36}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 6.98}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.15}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 15.65}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 39.9}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.09}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.84}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.93}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 80.05}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.94}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 4.66}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.72}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 9.21}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.16}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.34}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 92.45}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.47}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 131.14}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 5.25}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1050}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.7}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.37}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 22.31}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.27}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 6.18}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 36.75}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.44}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.41}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.51}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 15.22}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.06}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 62.99}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 60.38}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 4.13}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 11.61}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.86}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 109.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.7}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.62}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.54}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.71}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.24}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.93}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 87.94}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 56.44}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 106.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 315}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.63}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.49}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.94}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 24.84}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 36.74}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.94}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.82}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 73.47}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.75}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 19.85}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 78.75}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 71.84}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.12}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.14}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 64.99}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 62.96}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 73.5}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1758.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 12.77}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 431.42}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.77}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.23}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 36.66}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.98}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.97}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 273}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 49.88}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.61}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.73}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.23}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.36}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 73.38}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 120.37}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 70.88}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 193.72}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.27}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2100}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 418.69}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.15}},
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