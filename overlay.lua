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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 945.68, ["Ride"] = 866.25, ["Fly|Ride"] = 1050, ["Neon"] = 6494.52, ["Neon|Ride"] = 3013.7, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24651.84}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 494.81, ["Fly"] = 551.25, ["Ride"] = 446.39, ["Fly|Ride"] = 548.51, ["Neon|Fly|Ride"] = 2465.19, ["Mega"] = 10271.61}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5381.24, ["Ride"] = 5066.25, ["Fly|Ride"] = 4395.56, ["Neon|Fly|Ride"] = 19859.13, ["Mega|Fly|Ride"] = 68477.69}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 136.5, ["Ride"] = 183.75, ["Fly|Ride"] = 251.99, ["Neon"] = 773.56, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1095.99, ["Mega"] = 4108.64, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 493.77, ["Fly"] = 821.73, ["Ride"] = 525, ["Fly|Ride"] = 569.62, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 1609.13, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.08, ["Ride"] = 27.57, ["Fly|Ride"] = 152.03, ["Neon"] = 72.19, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.83, ["Fly"] = 33.67, ["Ride"] = 30.19, ["Fly|Ride"] = 57.17, ["Neon"] = 26.25, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 54.79, ["Neon|Fly|Ride"] = 95.66, ["Mega"] = 130.54, ["Mega|Fly"] = 271.4, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 123.27, ["Ride"] = 163.36, ["Fly|Ride"] = 231, ["Neon"] = 554.69, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 463.91, ["Mega"] = 1417.49, ["Mega|Fly|Ride"] = 2636.73}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.18, ["Fly"] = 55.5, ["Ride"] = 48.27, ["Fly|Ride"] = 92.79, ["Neon"] = 262.5, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1370.24, ["Mega|Ride"] = 1275.72, ["Mega|Fly|Ride"] = 1237.45}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.71, ["Fly"] = 48.87, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 192.1, ["Neon|Ride"] = 96.57, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1334.29, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.1, ["Fly"] = 114.05, ["Ride"] = 72.19, ["Fly|Ride"] = 137.65, ["Neon"] = 262.5, ["Neon|Fly"] = 408.82, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1575.68}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 359.54, ["Fly"] = 395, ["Ride"] = 351.74, ["Fly|Ride"] = 387.19, ["Neon"] = 1370.24, ["Neon|Ride"] = 1260.63, ["Neon|Fly|Ride"] = 1091.42, ["Mega|Fly|Ride"] = 4780.41}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 118.13, ["Ride"] = 90.04, ["Fly|Ride"] = 144.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2627.97}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Fly"] = 114.05, ["Ride"] = 51.85, ["Fly|Ride"] = 205.44, ["Neon"] = 21, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 148.32, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 383.88}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 127.34, ["Fly"] = 144.38, ["Ride"] = 137.71, ["Fly|Ride"] = 212.54, ["Neon"] = 927.81, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 485.63, ["Mega|Fly|Ride"] = 2212.88}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.27, ["Fly"] = 26.67, ["Ride"] = 21, ["Fly|Ride"] = 43.32, ["Neon"] = 27.57, ["Neon|Ride"] = 90.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 332.07}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 78.74, ["Fly"] = 262.5, ["Ride"] = 133.47, ["Fly|Ride"] = 267.07, ["Neon"] = 343.01, ["Neon|Fly"] = 463.91, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1493.5, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 32.26}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 41.1, ["Ride"] = 124.69, ["Fly|Ride"] = 255.29, ["Neon"] = 577.5, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.36, ["Fly"] = 34.49, ["Ride"] = 39.44, ["Fly|Ride"] = 223.13, ["Neon"] = 203.39, ["Neon|Ride"] = 164.36, ["Neon|Fly|Ride"] = 246.53, ["Mega"] = 2667.4, ["Mega|Ride"] = 577.28, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 36.74, ["Fly"] = 65.63, ["Ride"] = 52.29, ["Fly|Ride"] = 103.69, ["Neon"] = 238.92, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1623.64, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 34.13, ["Fly"] = 274.26, ["Ride"] = 124.13, ["Fly|Ride"] = 136.5, ["Neon"] = 143.07, ["Neon|Fly"] = 385.05, ["Neon|Ride"] = 273.25, ["Neon|Fly|Ride"] = 306.11, ["Mega"] = 1067.24, ["Mega|Ride"] = 1228.49, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 39.38, ["Ride"] = 40.06, ["Fly|Ride"] = 131.25, ["Neon"] = 343.08, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.33, ["Mega|Ride"] = 2052.27, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.37, ["Fly"] = 136.75, ["Ride"] = 65.63, ["Neon"] = 210, ["Neon|Fly"] = 549.54, ["Neon|Ride"] = 294.59, ["Neon|Fly|Ride"] = 367.38, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.81, ["Fly"] = 32.82, ["Ride"] = 22.05, ["Fly|Ride"] = 52.5, ["Neon"] = 27.56, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 44.41, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 141.26, ["Mega|Fly"] = 22427.05, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 298.6}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 399.28, ["Fly|Ride"] = 446.25, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7255.87}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.65, ["Ride"] = 26.25, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Ride"] = 123.27, ["Neon|Fly|Ride"] = 419.1, ["Mega|Fly|Ride"] = 912.13}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.79, ["Fly"] = 38.07, ["Ride"] = 21.61, ["Fly|Ride"] = 53.61, ["Neon"] = 51.06, ["Neon|Fly"] = 90.4, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 123.38, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 383.65}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.24, ["Fly"] = 108.94, ["Ride"] = 102.75, ["Fly|Ride"] = 123.31, ["Neon"] = 385.2, ["Neon|Fly"] = 453, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 2050.22, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.12, ["Ride"] = 27.84, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 695.86, ["Mega|Ride"] = 767.3, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.44, ["Fly"] = 347.24, ["Ride"] = 211.21, ["Fly|Ride"] = 260.61, ["Neon"] = 695.86, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 890.56, ["Mega"] = 6162.97, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2865.79}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.34}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.76, ["Fly"] = 28.73, ["Ride"] = 19.68, ["Fly|Ride"] = 64.32, ["Neon"] = 20.66, ["Neon|Fly"] = 5135.81, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 106.84, ["Mega"] = 157.5, ["Mega|Fly"] = 343.08, ["Mega|Ride"] = 273.25, ["Mega|Fly|Ride"] = 278.35}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1050, ["Fly"] = 2625, ["Ride"] = 983.07, ["Fly|Ride"] = 1312.5, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52187.98, ["Mega|Fly|Ride"] = 25884.44}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.49, ["Fly"] = 67.81, ["Ride"] = 32.8, ["Fly|Ride"] = 131.25, ["Neon"] = 109.92, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 217.77, ["Mega"] = 508.47, ["Mega|Ride"] = 659.45, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 121.63, ["Ride"] = 136.5, ["Fly|Ride"] = 249.38, ["Neon"] = 801.2, ["Neon|Ride"] = 752.2, ["Neon|Fly|Ride"] = 795.04, ["Mega|Ride"] = 2917.15, ["Mega|Fly|Ride"] = 2719.94}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.6, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 137.68, ["Neon"] = 81.34, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 287.62, ["Mega"] = 670.9, ["Mega|Ride"] = 1083.21, ["Mega|Fly|Ride"] = 727.16}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.97, ["Ride"] = 164.38, ["Fly|Ride"] = 196.88, ["Neon"] = 584.07, ["Neon|Ride"] = 513.59, ["Neon|Fly|Ride"] = 697.46, ["Mega|Fly|Ride"] = 2054.33}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 111.07, ["Ride"] = 152.24, ["Fly|Ride"] = 194.25, ["Neon"] = 431.43, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1779.05}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 51.18, ["Fly"] = 59.16, ["Ride"] = 52.18, ["Fly|Ride"] = 77.87, ["Neon"] = 616.3, ["Neon|Ride"] = 477.83, ["Neon|Fly|Ride"] = 295.44, ["Mega"] = 4108.64, ["Mega|Fly|Ride"] = 1592.07}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.88, ["Ride"] = 39.44, ["Fly|Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 231.12, ["Mega"] = 152.03, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 271.19, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 406.88, ["Fly"] = 420, ["Ride"] = 392.43, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1701.34, ["Neon|Fly|Ride"] = 1470.44, ["Mega|Fly|Ride"] = 6273.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 101.07, ["Fly"] = 137.68, ["Ride"] = 97.13, ["Fly|Ride"] = 157.5, ["Neon"] = 446.25, ["Neon|Ride"] = 486.89, ["Neon|Fly|Ride"] = 459.37, ["Mega|Ride"] = 2451.85, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3711.17, ["Ride"] = 3433.5, ["Fly|Ride"] = 3673.69, ["Neon|Fly|Ride"] = 14379.22}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.9, ["Fly"] = 108.91, ["Ride"] = 57.75, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 303.03, ["Mega|Ride"] = 1179.2, ["Mega|Fly|Ride"] = 1368.2}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 62.39, ["Ride"] = 68.85, ["Fly|Ride"] = 195.57, ["Neon"] = 548.51, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2328.59, ["Mega|Fly|Ride"] = 1235.68}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 36.11, ["Fly"] = 78.74, ["Ride"] = 61.03, ["Fly|Ride"] = 124.68, ["Neon"] = 160.63, ["Neon|Ride"] = 176.29, ["Neon|Fly|Ride"] = 220.15, ["Mega"] = 2625, ["Mega|Ride"] = 821.1, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 10.28}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.94, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 542.36, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 44.01}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 200.31, ["Ride"] = 219.86, ["Fly|Ride"] = 274.26, ["Neon|Ride"] = 1370.24, ["Neon|Fly|Ride"] = 773.56, ["Mega|Fly|Ride"] = 4948.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 918.75, ["Ride"] = 938.44, ["Fly|Ride"] = 1045.93, ["Neon|Ride"] = 3556.92, ["Neon|Fly|Ride"] = 3537.2, ["Mega|Fly|Ride"] = 15407.41}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.39}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 28.42, ["Fly"] = 62.62, ["Ride"] = 38.96, ["Fly|Ride"] = 73.48, ["Neon"] = 178.5, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 177.19, ["Mega|Ride"] = 862.83, ["Mega|Fly|Ride"] = 866.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6286.23, ["Fly|Ride"] = 4068.75, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 39991.46}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.87, ["Fly"] = 74.69, ["Ride"] = 27.72, ["Fly|Ride"] = 52.4, ["Neon"] = 97.34, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 634.39, ["Mega|Ride"] = 677.94, ["Mega|Fly|Ride"] = 597.19}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 8.99, ["Fly"] = 41.1, ["Ride"] = 32.89, ["Fly|Ride"] = 109.92, ["Neon"] = 111.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 244.48, ["Mega"] = 1027.17, ["Mega|Ride"] = 501.26, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 94.5, ["Fly"] = 255.18, ["Ride"] = 91.86, ["Fly|Ride"] = 72.19, ["Neon|Fly|Ride"] = 927.81, ["Mega"] = 4108.64}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.31, ["Ride"] = 27.57, ["Fly|Ride"] = 106.84, ["Neon"] = 93.19, ["Neon|Ride"] = 94.77, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 479.07, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 619.32}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 2191.7, ["Fly|Ride"] = 1942.5, ["Neon|Fly|Ride"] = 3953.25, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 24374.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 67792.56, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.96, ["Fly"] = 393.75, ["Ride"] = 51.96, ["Fly|Ride"] = 89.93, ["Neon"] = 136.29, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 960.41, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.14, ["Fly"] = 48.29, ["Ride"] = 45.93, ["Fly|Ride"] = 183.75, ["Neon"] = 19.69, ["Neon|Fly"] = 134.39, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 150.11, ["Mega"] = 133.77, ["Mega|Ride"] = 210.69, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 30.82}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.57, ["Ride"] = 36.75, ["Fly|Ride"] = 111.57, ["Neon"] = 52.39, ["Neon|Ride"] = 96.57, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 369.79, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 773.56, ["Ride"] = 767.4, ["Fly|Ride"] = 782.35, ["Neon"] = 2938.78, ["Neon|Ride"] = 2899.35, ["Neon|Fly|Ride"] = 2520, ["Mega|Fly|Ride"] = 10824.96}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 962.07, ["Ride"] = 866.12, ["Fly|Ride"] = 892.5, ["Neon"] = 4108.64, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11208.39}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.72, ["Fly"] = 115.99, ["Ride"] = 39.38, ["Fly|Ride"] = 98.44, ["Neon"] = 101.07, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 192.1, ["Mega"] = 1027.05, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.16}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.72, ["Fly"] = 111.57, ["Ride"] = 84.66, ["Fly|Ride"] = 129.73, ["Neon|Ride"] = 384.18, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 2011.2, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 61.6, ["Ride"] = 63.66, ["Fly|Ride"] = 228.38, ["Neon"] = 328.71, ["Neon|Fly"] = 527.98, ["Neon|Ride"] = 390.33, ["Neon|Fly|Ride"] = 491.57, ["Mega"] = 1725.65, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 47.25, ["Ride"] = 20, ["Fly|Ride"] = 68.83, ["Neon"] = 35.88, ["Neon|Fly"] = 525, ["Neon|Ride"] = 67.81, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 262.5, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 98.44, ["Fly"] = 98.44, ["Ride"] = 118.13, ["Fly|Ride"] = 152.76, ["Neon"] = 795.04, ["Neon|Ride"] = 387.4, ["Neon|Fly|Ride"] = 328.11, ["Mega|Fly|Ride"] = 1424.06}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.25, ["Ride"] = 41.11, ["Fly|Ride"] = 97.12, ["Neon"] = 53.45, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 207.38, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.13, ["Fly"] = 40.28, ["Ride"] = 33.65, ["Fly|Ride"] = 78.75, ["Neon"] = 102.74, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 100.68, ["Neon|Fly|Ride"] = 175.67, ["Mega"] = 726.22, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 62.66, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 164.36, ["Mega"] = 694.25, ["Mega|Ride"] = 773.56, ["Mega|Fly|Ride"] = 862.83}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.12, ["Fly"] = 130.79, ["Ride"] = 34.93, ["Fly|Ride"] = 68.85, ["Neon"] = 91.88, ["Neon|Ride"] = 106.72, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 819.69, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6847.07, ["Fly"] = 6916.91, ["Ride"] = 6574.65, ["Fly|Ride"] = 5236.88, ["Neon"] = 30814.81, ["Neon|Fly|Ride"] = 27117.03}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 236.25, ["Fly"] = 233.18, ["Ride"] = 232.18, ["Fly|Ride"] = 287.05, ["Neon"] = 773.56, ["Neon|Ride"] = 695.86, ["Neon|Fly|Ride"] = 420, ["Mega|Fly|Ride"] = 2093.12}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.83, ["Fly"] = 131.73, ["Ride"] = 65.63, ["Fly|Ride"] = 137.12, ["Neon"] = 104.98, ["Neon|Fly"] = 182.85, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 380.07, ["Mega|Fly"] = 548.51, ["Mega|Ride"] = 350.44, ["Mega|Fly|Ride"] = 470}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.29, ["Ride"] = 20.56, ["Fly|Ride"] = 96.57, ["Neon"] = 22.1, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 186.96, ["Mega"] = 127.98, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 38.07, ["Fly"] = 5257.74, ["Ride"] = 83.52, ["Fly|Ride"] = 131.25, ["Neon"] = 144.38, ["Neon|Fly"] = 326.65, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 309.66, ["Mega"] = 367.5, ["Mega|Ride"] = 513.59, ["Mega|Fly|Ride"] = 584.72}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13833.75, ["Ride"] = 12468.75, ["Fly|Ride"] = 11863.69, ["Neon|Fly|Ride"] = 26751.57}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 165.37, ["Ride"] = 218.61, ["Fly|Ride"] = 233.18, ["Neon"] = 1407.23, ["Neon|Ride"] = 1438.03, ["Neon|Fly|Ride"] = 1465.77, ["Mega"] = 4108.64, ["Mega|Fly|Ride"] = 4641.75}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 60.38, ["Fly"] = 119.02, ["Ride"] = 63, ["Fly|Ride"] = 115.21, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 381.94, ["Mega|Fly|Ride"] = 2327.56}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.67, ["Fly"] = 28.53, ["Ride"] = 20.55, ["Fly|Ride"] = 55.49, ["Neon"] = 76.13, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 2465.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 333.37, ["Fly"] = 491.8, ["Ride"] = 380.63, ["Fly|Ride"] = 472.5, ["Neon"] = 1639.32, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4937.22}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.9, ["Fly"] = 82.21, ["Ride"] = 36.75, ["Fly|Ride"] = 109.04, ["Neon"] = 30.17, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 216.89, ["Mega"] = 129.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 287.44, ["Ride"] = 328.75, ["Fly|Ride"] = 288.74, ["Neon"] = 1026.14, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 4930.37}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.01, ["Fly"] = 15.74, ["Ride"] = 16.21, ["Fly|Ride"] = 35.04, ["Neon|Ride"] = 102.74, ["Neon|Fly|Ride"] = 84.25, ["Mega"] = 2465.19, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.8}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 59.07, ["Ride"] = 86.63, ["Fly|Ride"] = 525, ["Neon"] = 326.65, ["Neon|Fly"] = 1643.46, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1129.89, ["Mega|Ride"] = 1232.6, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 65.63, ["Ride"] = 39.38, ["Fly|Ride"] = 86.52, ["Neon"] = 92.46, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 508.47, ["Mega|Ride"] = 541.33, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 20.03}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 27.75, ["Fly"] = 111.57, ["Ride"] = 91.21, ["Fly|Ride"] = 309.7, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 821.73, ["Mega|Ride"] = 919.33, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 29.23, ["Fly|Ride"] = 132.23, ["Neon"] = 21.65, ["Neon|Ride"] = 104.39, ["Neon|Fly|Ride"] = 240.37, ["Mega"] = 131.24, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.42, ["Fly"] = 45.94, ["Ride"] = 27.76, ["Fly|Ride"] = 77.44, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 217.77, ["Mega|Ride"] = 534.14, ["Mega|Fly|Ride"] = 801.2}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 318.36, ["Ride"] = 377.03, ["Fly|Ride"] = 409.89, ["Neon|Fly|Ride"] = 2602.84, ["Mega|Fly|Ride"] = 8628.15}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 37.41, ["Fly"] = 102.74, ["Ride"] = 45.94, ["Fly|Ride"] = 103.67, ["Neon"] = 184.42, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 233.18, ["Mega"] = 710.8, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 602.97}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 37.71, ["Fly"] = 92.59, ["Ride"] = 72.18, ["Fly|Ride"] = 137.65, ["Neon"] = 453, ["Neon|Ride"] = 226.94, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1232.6}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 32.82, ["Fly"] = 85.85, ["Ride"] = 65.63, ["Fly|Ride"] = 143.82, ["Neon"] = 111.56, ["Neon|Ride"] = 168.47, ["Neon|Fly|Ride"] = 308.16, ["Mega"] = 393.75, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 449.18}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8616.44, ["Ride"] = 9995.9, ["Fly|Ride"] = 7875, ["Neon|Fly|Ride"] = 15499.31, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.37, ["Fly"] = 1855.82, ["Ride"] = 1509.38, ["Fly|Ride"] = 1534.49, ["Neon|Fly|Ride"] = 3990, ["Mega"] = 21913.44, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 448.84, ["Ride"] = 453.05, ["Fly|Ride"] = 525, ["Neon"] = 3780, ["Neon|Fly|Ride"] = 2054.33, ["Mega|Fly|Ride"] = 6667.31}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 15.42, ["Fly"] = 23.62, ["Ride"] = 22.32, ["Fly|Ride"] = 46.94, ["Neon"] = 108.78, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 171.54, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.49, ["Fly"] = 78.74, ["Ride"] = 164.38, ["Fly|Ride"] = 123.27, ["Neon"] = 27.57, ["Neon|Ride"] = 67.81, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 156.85, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.07, ["Fly"] = 55.49, ["Ride"] = 45.93, ["Fly|Ride"] = 110.25, ["Neon"] = 262.5, ["Neon|Ride"] = 162.42, ["Neon|Fly|Ride"] = 155.3, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.86, ["Fly"] = 23.12, ["Ride"] = 19.69, ["Fly|Ride"] = 41.1, ["Neon"] = 25.77, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 262.5, ["Mega|Ride"] = 192.1, ["Mega|Fly|Ride"] = 341.03}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 305.04, ["Fly"] = 320.25, ["Ride"] = 306.93, ["Fly|Ride"] = 367.5, ["Neon"] = 1175.72, ["Neon|Ride"] = 1308.61, ["Neon|Fly|Ride"] = 1210.13, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.68, ["Fly"] = 60.09, ["Ride"] = 40.51, ["Fly|Ride"] = 76.13, ["Neon"] = 139.71, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 229.69, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 26.61, ["Ride"] = 21.17, ["Fly|Ride"] = 43.17, ["Neon"] = 82.19, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 532.08, ["Fly"] = 787.5, ["Ride"] = 409.89, ["Fly|Ride"] = 644.04, ["Neon|Ride"] = 2772.32, ["Neon|Fly|Ride"] = 2319.49, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.75, ["Fly"] = 1391.69, ["Ride"] = 1232.76, ["Fly|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 154631.79}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 93.72, ["Fly"] = 123.27, ["Ride"] = 85.32, ["Fly|Ride"] = 108.94, ["Neon"] = 513.59, ["Neon|Ride"] = 1713.32, ["Neon|Fly|Ride"] = 463.91, ["Mega|Ride"] = 2328.59, ["Mega|Fly|Ride"] = 3867.73}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 178.75, ["Fly"] = 212.13, ["Ride"] = 191.09, ["Fly|Ride"] = 243.77, ["Neon"] = 556.49, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 598.35, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2474.89}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.18, ["Ride"] = 54.53, ["Fly|Ride"] = 274.31, ["Neon"] = 232.74, ["Neon|Fly"] = 410.87, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega"] = 656.25, ["Mega|Ride"] = 1855.59, ["Mega|Fly|Ride"] = 739.57}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 157.5, ["Ride"] = 205.48, ["Fly|Ride"] = 410.87, ["Neon|Fly|Ride"] = 1298.92, ["Mega|Fly|Ride"] = 4020.8}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1814.75, ["Ride"] = 2475.19, ["Fly|Ride"] = 2054.33, ["Neon|Fly|Ride"] = 8217.28, ["Mega|Fly|Ride"] = 24741.74}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 51.45, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 511.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1918.75, ["Mega|Ride"] = 2259.76, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 795.04, ["Ride"] = 619.48, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1506.86, ["Neon|Fly|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 3106.35}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 62.09, ["Ride"] = 51.19, ["Fly|Ride"] = 84.44, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 249.38, ["Mega|Fly|Ride"] = 1164.81}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.28, ["Fly"] = 31.02, ["Ride"] = 21.51, ["Fly|Ride"] = 65.63, ["Neon"] = 27.56, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 141.68, ["Mega|Fly"] = 338.98, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 252.3}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.17, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 409.85, ["Neon|Fly|Ride"] = 619.32, ["Mega|Ride"] = 1370.24, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.37, ["Fly"] = 899.07, ["Ride"] = 716.96, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 2421.55, ["Neon|Fly|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 7806.43}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.49, ["Ride"] = 643.13, ["Fly|Ride"] = 866.25, ["Neon"] = 5135.81, ["Neon|Fly|Ride"] = 3245.84, ["Mega|Fly|Ride"] = 12325.92}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.13, ["Fly"] = 25.97, ["Ride"] = 22.32, ["Fly|Ride"] = 44.89, ["Neon"] = 205.44, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 137.65, ["Mega|Fly|Ride"] = 710.8}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.38, ["Ride"] = 23.54, ["Fly|Ride"] = 63.71, ["Neon"] = 72.19, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 959.38, ["Mega|Ride"] = 440.71, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.91, ["Ride"] = 26.25, ["Fly|Ride"] = 111.45, ["Neon"] = 22.08, ["Neon|Fly"] = 309.66, ["Neon|Ride"] = 52.82, ["Neon|Fly|Ride"] = 155.42, ["Mega"] = 155.42, ["Mega|Ride"] = 238.62, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 39.05, ["Fly"] = 68.85, ["Ride"] = 51.19, ["Fly|Ride"] = 94.49, ["Neon"] = 287.62, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 233.63, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 59.07, ["Ride"] = 102.75, ["Fly|Ride"] = 449.61, ["Neon"] = 410.87, ["Neon|Ride"] = 491.01, ["Neon|Fly|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1364.09}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.9, ["Fly"] = 48.57, ["Ride"] = 36.61, ["Fly|Ride"] = 94.5, ["Neon"] = 59.07, ["Neon|Ride"] = 102.94, ["Neon|Fly|Ride"] = 200.31, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.82, ["Fly"] = 86.03, ["Ride"] = 44.35, ["Fly|Ride"] = 93.19, ["Neon"] = 196.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.9, ["Fly"] = 27.75, ["Ride"] = 18.51, ["Fly|Ride"] = 40.69, ["Neon"] = 26.25, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 93.49, ["Mega"] = 525, ["Mega|Ride"] = 274.26, ["Mega|Fly|Ride"] = 341.03}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.16, ["Fly"] = 32.48, ["Ride"] = 27.57, ["Fly|Ride"] = 72.19, ["Neon"] = 24.94, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.36, ["Mega"] = 410.87, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 648.38}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 42.44, ["Fly"] = 65.61, ["Ride"] = 51.14, ["Fly|Ride"] = 88.67, ["Neon"] = 402.45, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1816.5, ["Fly"] = 1889.98, ["Ride"] = 1575, ["Fly|Ride"] = 1640.63, ["Neon|Fly"] = 4928.88, ["Neon|Ride"] = 4629.42, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 16547.08}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 461.99, ["Fly"] = 547.46, ["Ride"] = 483.27, ["Fly|Ride"] = 566.73, ["Neon"] = 3093.02, ["Neon|Ride"] = 2567.92, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 9581.37}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 248.24, ["Fly"] = 348.23, ["Ride"] = 303.07, ["Fly|Ride"] = 476.68, ["Neon"] = 1396.96, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1370.42, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 42}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.74, ["Ride"] = 41.42, ["Fly|Ride"] = 96.58, ["Neon"] = 328.71, ["Neon|Fly"] = 410.87, ["Neon|Ride"] = 343.08, ["Neon|Fly|Ride"] = 308.16, ["Mega"] = 904.95, ["Mega|Ride"] = 959.38, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41086.4, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 16799.99, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 349.13, ["Fly"] = 853.69, ["Ride"] = 484.32, ["Fly|Ride"] = 537.22, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1296.75, ["Mega"] = 6026.36, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.94, ["Fly"] = 525, ["Ride"] = 136.49, ["Fly|Ride"] = 155.42, ["Mega|Fly|Ride"] = 4108.64}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 116.08, ["Fly"] = 262.5, ["Ride"] = 122.78, ["Fly|Ride"] = 196.88, ["Neon"] = 512.57, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 549.94, ["Mega|Fly|Ride"] = 2464.17}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.75, ["Fly"] = 94.5, ["Ride"] = 33.65, ["Fly|Ride"] = 99.48, ["Neon"] = 274.26, ["Neon|Ride"] = 135.19, ["Neon|Fly|Ride"] = 204.42, ["Mega"] = 684.11, ["Mega|Ride"] = 540.3, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4825.62, ["Ride"] = 4930.99, ["Fly|Ride"] = 3937.5, ["Neon|Ride"] = 17804.8, ["Neon|Fly|Ride"] = 17119.69, ["Mega|Fly|Ride"] = 57520.96}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.19, ["Fly"] = 137.65, ["Ride"] = 39.37, ["Fly|Ride"] = 54.52, ["Neon"] = 228.04, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 1095.99, ["Mega|Fly|Ride"] = 857.06}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.62, ["Fly"] = 137.65, ["Ride"] = 45.94, ["Fly|Ride"] = 107.62, ["Neon|Fly"] = 1370.24, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1547.1, ["Mega|Fly|Ride"] = 1337.38}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 622.13, ["Fly"] = 897.77, ["Ride"] = 602.44, ["Fly|Ride"] = 787.49, ["Neon"] = 1808.63, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Ride"] = 6026.36, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 13.29, ["Fly"] = 27.75, ["Ride"] = 23.63, ["Fly|Ride"] = 49.86, ["Neon"] = 124.68, ["Neon|Fly"] = 155.42, ["Neon|Ride"] = 105.98, ["Neon|Fly|Ride"] = 131.14, ["Mega"] = 588, ["Mega|Ride"] = 582.41, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.42, ["Fly"] = 82.19, ["Ride"] = 27.74, ["Fly|Ride"] = 484.83, ["Neon"] = 80.06, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.78, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 98.76, ["Ride"] = 105, ["Fly|Ride"] = 196.88, ["Neon"] = 527.71, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 647.12, ["Mega|Fly|Ride"] = 2177.59}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 27.75, ["Ride"] = 83.98, ["Fly|Ride"] = 138.68, ["Neon"] = 77.97, ["Neon|Ride"] = 129.42, ["Neon|Fly|Ride"] = 250.7, ["Mega"] = 301.54, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3731.22, ["Fly"] = 5032.08, ["Ride"] = 3740.63, ["Fly|Ride"] = 3770.82, ["Neon"] = 12325.92, ["Neon|Ride"] = 11471.33, ["Neon|Fly|Ride"] = 8726.41, ["Mega"] = 43027.73, ["Mega|Fly|Ride"] = 33092.98}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 41.1, ["Ride"] = 48.57, ["Fly|Ride"] = 135.95, ["Neon"] = 205.44, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 306.11, ["Mega|Ride"] = 1026.14, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7732.93, ["Fly|Ride"] = 6286.87, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 64369.05}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.82, ["Fly"] = 20.55, ["Ride"] = 17.07, ["Fly|Ride"] = 33.13, ["Neon"] = 20.56, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 86.62, ["Mega"] = 448.84, ["Mega|Ride"] = 199.28, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 23.21, ["Fly"] = 27.42, ["Ride"] = 30.19, ["Fly|Ride"] = 55.49, ["Neon"] = 109.92, ["Neon|Ride"] = 163.33, ["Neon|Fly|Ride"] = 178.75, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 927.81}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 15.07, ["Ride"] = 31.34, ["Fly|Ride"] = 116.02, ["Neon"] = 192.1, ["Neon|Ride"] = 152.03, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 820.72, ["Mega|Ride"] = 957.33, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 22.32, ["Fly"] = 262.5, ["Ride"] = 44.63, ["Fly|Ride"] = 135.61, ["Neon"] = 182.43, ["Neon|Ride"] = 130.79, ["Neon|Fly|Ride"] = 252.39, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.35, ["Fly"] = 26.25, ["Ride"] = 23.15, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 106.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2465.19, ["Mega|Ride"] = 578.73, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8765.79}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.72}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.15, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1027.17}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 19.86, ["Fly"] = 109.94, ["Ride"] = 44.77, ["Fly|Ride"] = 124.13, ["Neon"] = 51.03, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 178.75, ["Mega|Ride"] = 927.81, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 7.87}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 7.66, ["Ride"] = 29.22, ["Fly|Ride"] = 68.83, ["Neon"] = 49.32, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 123.27, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2686.69}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 155.42, ["Fly"] = 281.49, ["Ride"] = 177.19, ["Fly|Ride"] = 408.82, ["Neon"] = 701.37, ["Neon|Ride"] = 685.13, ["Mega|Ride"] = 2876.06, ["Mega|Fly|Ride"] = 3013.7}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 105, ["Ride"] = 211.63, ["Fly|Ride"] = 209.2, ["Neon"] = 682.5, ["Neon|Ride"] = 685.13, ["Neon|Fly|Ride"] = 1095.99, ["Mega"] = 2625, ["Mega|Ride"] = 3286.92, ["Mega|Fly|Ride"] = 3093.02}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 164.07, ["Fly"] = 186.38, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 4519.51, ["Mega|Fly|Ride"] = 3609.45}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1561.88, ["Fly"] = 2465.51, ["Ride"] = 1500.87, ["Fly|Ride"] = 1575, ["Neon"] = 6804.16, ["Neon|Ride"] = 5476.84, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 30926.61}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 80.14, ["Ride"] = 55.5, ["Fly|Ride"] = 93.5, ["Neon"] = 135.6, ["Neon|Ride"] = 203.39, ["Neon|Fly|Ride"] = 241.4, ["Mega"] = 820.72, ["Mega|Ride"] = 890.56, ["Mega|Fly|Ride"] = 1079.56}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 726.02, ["Fly|Ride"] = 1050, ["Neon|Fly|Ride"] = 3972.05}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.61}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.74, ["Ride"] = 31.34, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 118.14, ["Neon|Fly|Ride"] = 273.25, ["Mega"] = 393.65, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 7.76, ["Fly"] = 48.29, ["Ride"] = 26.72, ["Fly|Ride"] = 94.79, ["Neon"] = 39.04, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 344.11, ["Mega|Fly|Ride"] = 619.32}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 53.42}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.86, ["Fly"] = 108.92, ["Ride"] = 31.27, ["Fly|Ride"] = 82.21, ["Neon"] = 196.88, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.1, ["Mega"] = 787.5, ["Mega|Ride"] = 1237.45, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 100.91, ["Fly"] = 76.04, ["Ride"] = 36.75, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 218.05, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 935.92, ["Mega|Ride"] = 1739.62, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 5906.25, ["Fly"] = 6300.61, ["Ride"] = 4987.5, ["Fly|Ride"] = 4961.13, ["Neon|Fly|Ride"] = 9986.12, ["Mega|Fly|Ride"] = 30814.81}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.56, ["Fly"] = 40.69, ["Ride"] = 35.44, ["Fly|Ride"] = 78.75, ["Neon"] = 64.97, ["Neon|Ride"] = 77.44, ["Mega"] = 519.58, ["Mega|Ride"] = 463.91, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.92, ["Fly"] = 363.67, ["Ride"] = 91.88, ["Fly|Ride"] = 188.99, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 62.99, ["Fly"] = 96.48, ["Ride"] = 96.58, ["Fly|Ride"] = 203.39, ["Neon"] = 178.75, ["Neon|Ride"] = 246.53, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 2319.49, ["Mega|Ride"] = 2773.35, ["Mega|Fly|Ride"] = 1314.78}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.96, ["Fly"] = 65.63, ["Ride"] = 29.8, ["Fly|Ride"] = 63, ["Neon"] = 131.5, ["Neon|Ride"] = 185.58, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.16, ["Fly"] = 57.2, ["Ride"] = 30.81, ["Fly|Ride"] = 82.69, ["Neon"] = 28.88, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 157.5, ["Mega|Fly"] = 918.75, ["Mega|Ride"] = 217.67, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.44, ["Ride"] = 26.25, ["Fly|Ride"] = 96.58, ["Neon"] = 93.49, ["Neon|Ride"] = 122.25, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 479.7, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 546.47}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.63, ["Fly"] = 26.25, ["Ride"] = 27.56, ["Fly|Ride"] = 55.49, ["Neon"] = 203.39, ["Neon|Fly"] = 84, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 149.98, ["Mega|Fly|Ride"] = 619.1}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 188.99}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.64, ["Ride"] = 96.85, ["Neon"] = 170.63, ["Mega"] = 1326.07, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 328.13, ["Fly"] = 216.91, ["Ride"] = 387.41, ["Fly|Ride"] = 410.87, ["Neon"] = 1095.99}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 36.75, ["Fly"] = 212.01, ["Ride"] = 103.94, ["Fly|Ride"] = 205.44, ["Neon"] = 249.36, ["Neon|Ride"] = 274.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1183.88, ["Mega|Ride"] = 919.33, ["Mega|Fly|Ride"] = 1222.29}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 888.57, ["Fly"] = 1118.24, ["Ride"] = 897.75, ["Fly|Ride"] = 829.49, ["Neon|Fly"] = 2667.4, ["Neon|Ride"] = 2706.83, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 274.31, ["Fly"] = 463.91, ["Ride"] = 273, ["Fly|Ride"] = 367.5, ["Neon"] = 1181.25, ["Neon|Ride"] = 2011, ["Neon|Fly|Ride"] = 1844.79, ["Mega"] = 8114.58, ["Mega|Fly|Ride"] = 6186.03}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 61.65}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.41}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.22, ["Fly"] = 27.57, ["Ride"] = 17.41, ["Fly|Ride"] = 42, ["Neon"] = 77.95, ["Neon|Fly"] = 116.26, ["Neon|Ride"] = 97.6, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 437.26, ["Mega|Ride"] = 684.11, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 271.55, ["Fly"] = 762.36, ["Ride"] = 301.74, ["Fly|Ride"] = 387.19, ["Neon"] = 1079.56, ["Neon|Ride"] = 879.59, ["Neon|Fly|Ride"] = 938.44, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.75}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 150.73, ["Fly"] = 265.02, ["Ride"] = 203.43, ["Fly|Ride"] = 288.75, ["Neon"] = 721.88, ["Neon|Fly"] = 1643.46, ["Neon|Ride"] = 748.13, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 2257.5, ["Mega|Ride"] = 11684.98, ["Mega|Fly|Ride"] = 2808.75}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Ride"] = 131.15, ["Fly|Ride"] = 157.5, ["Neon"] = 671.77, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 924.46}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.41, ["Ride"] = 23.64, ["Fly|Ride"] = 167.44, ["Neon"] = 27.75, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 262.1, ["Mega|Ride"] = 356.44, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.51, ["Fly"] = 63, ["Ride"] = 29.28, ["Fly|Ride"] = 76.13, ["Neon"] = 211.61, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 255.5, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 17.41, ["Fly"] = 102.31, ["Ride"] = 64.32, ["Fly|Ride"] = 128.82, ["Neon"] = 137.65, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 254.76, ["Mega"] = 461.16, ["Mega|Ride"] = 464.6, ["Mega|Fly|Ride"] = 685.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.66, ["Fly"] = 123.3, ["Ride"] = 55.5, ["Fly|Ride"] = 156.41, ["Neon"] = 26.25, ["Neon|Fly"] = 231.96, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 147, ["Mega"] = 137.81, ["Mega|Ride"] = 181.33, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 283.5, ["Ride"] = 288.75, ["Fly|Ride"] = 320.12, ["Neon"] = 1506.86, ["Neon|Ride"] = 1370.25, ["Neon|Fly|Ride"] = 1404.38, ["Mega|Fly|Ride"] = 5068.02}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 164.07, ["Fly"] = 1050, ["Ride"] = 182.44, ["Fly|Ride"] = 309.7, ["Neon"] = 682.5, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2600.78, ["Mega|Ride"] = 3972.05, ["Mega|Fly|Ride"] = 2294.25}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.19, ["Fly"] = 167.45, ["Ride"] = 90.64, ["Fly|Ride"] = 102.74, ["Neon"] = 471.48, ["Neon|Ride"] = 405.75, ["Neon|Fly|Ride"] = 453, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 115.99, ["Neon|Ride"] = 589.16, ["Neon|Fly|Ride"] = 479.7, ["Mega|Ride"] = 616.3, ["Mega|Fly|Ride"] = 1641.42}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.74, ["Fly"] = 75.63, ["Ride"] = 40.06, ["Fly|Ride"] = 101.07, ["Neon"] = 76.67, ["Neon|Fly"] = 205.44, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 356.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.03, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 52.45, ["Ride"] = 22.61, ["Fly|Ride"] = 98.44, ["Neon"] = 22.01, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 109.92, ["Mega"] = 129.94, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 220.4}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 918.75, ["Fly"] = 1082.72, ["Ride"] = 892.5, ["Fly|Ride"] = 979.13, ["Neon"] = 3038.52, ["Neon|Fly"] = 3402.68, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2623.69, ["Mega|Fly|Ride"] = 7560}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 397.53, ["Ride"] = 400.32, ["Fly|Ride"] = 485.63, ["Neon|Ride"] = 2054.33, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10271.61, ["Mega|Fly|Ride"] = 7929.69}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 82.19, ["Fly"] = 131.25, ["Ride"] = 96.58, ["Fly|Ride"] = 178.75, ["Neon"] = 262.5, ["Neon|Ride"] = 306.18, ["Neon|Fly|Ride"] = 397.53, ["Mega"] = 1577.24, ["Mega|Ride"] = 1489.4, ["Mega|Fly|Ride"] = 1532.53}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 307.14, ["Fly"] = 463.91, ["Ride"] = 296.87, ["Fly|Ride"] = 282.19, ["Neon"] = 1391.69, ["Neon|Ride"] = 1391.69, ["Neon|Fly|Ride"] = 1305.53, ["Mega"] = 10271.61, ["Mega|Fly|Ride"] = 4930.37}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.69, ["Fly"] = 137.65, ["Ride"] = 32.8, ["Fly|Ride"] = 47.29, ["Neon"] = 169.32, ["Neon|Ride"] = 128.75, ["Neon|Fly|Ride"] = 229.68, ["Mega|Ride"] = 695.86, ["Mega|Fly|Ride"] = 657.4}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 218.3, ["Ride"] = 275.63, ["Fly|Ride"] = 548.51, ["Neon"] = 849.48, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2361.45, ["Mega"] = 4088.39, ["Mega|Ride"] = 4246.29, ["Mega|Fly|Ride"] = 3766.62}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 60.37, ["Fly"] = 76.13, ["Ride"] = 55.5, ["Fly|Ride"] = 102.92, ["Neon|Ride"] = 493.05, ["Neon|Fly|Ride"] = 445.8, ["Mega|Fly|Ride"] = 1214.07}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1640.63, ["Ride"] = 1443.75, ["Fly|Ride"] = 1509.38, ["Neon|Ride"] = 10824.96, ["Neon|Fly|Ride"] = 4790.69, ["Mega"] = 49303.68, ["Mega|Fly|Ride"] = 21911.39}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 17.05, ["Fly"] = 63.07, ["Ride"] = 41.1, ["Fly|Ride"] = 90.87, ["Neon"] = 62.78, ["Neon|Fly"] = 184.7, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 213.67, ["Mega"] = 310.01, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 412.16}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 42, ["Fly"] = 119.1, ["Ride"] = 82.21, ["Fly|Ride"] = 161.44, ["Neon"] = 274.26, ["Neon|Ride"] = 278.37, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 817.63, ["Mega|Ride"] = 1005.6, ["Mega|Fly|Ride"] = 1026.14}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.63, ["Fly"] = 82.29, ["Ride"] = 85.59, ["Fly|Ride"] = 102.38, ["Neon|Fly|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3422.51, ["Fly"] = 1181.25, ["Ride"] = 1547.28, ["Fly|Ride"] = 1168.13, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 819.79, ["Ride"] = 410.93, ["Fly|Ride"] = 685.21, ["Neon"] = 2166.4, ["Neon|Fly|Ride"] = 2706.83, ["Mega|Fly|Ride"] = 13916.81}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 94.39, ["Fly"] = 309.66, ["Ride"] = 152.06, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 616.3, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 607.4, ["Mega"] = 4108.64, ["Mega|Ride"] = 2602.84, ["Mega|Fly|Ride"] = 2054.33}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.48, ["Ride"] = 26.17, ["Fly|Ride"] = 69.61, ["Neon"] = 67.28, ["Neon|Ride"] = 93.55, ["Neon|Fly|Ride"] = 176.69, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1150.43}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.61, ["Ride"] = 48.3, ["Fly|Ride"] = 122.73, ["Neon"] = 204.75, ["Neon|Fly"] = 409.85, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1334.29, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 641.82, ["Ride"] = 807.19, ["Fly|Ride"] = 903.81, ["Neon"] = 3011.65, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 15066.4}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5615.5, ["Ride"] = 5258.9, ["Fly|Ride"] = 4494.38, ["Neon"] = 42000, ["Neon|Ride"] = 29439.44, ["Neon|Fly|Ride"] = 21626.87, ["Mega|Fly|Ride"] = 87651.67}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 157.5, ["Fly"] = 402.74, ["Ride"] = 219.86, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Ride"] = 1237.45, ["Neon|Fly|Ride"] = 1643.46, ["Mega"] = 5752.1, ["Mega|Fly|Ride"] = 5889.75}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 274.26, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 397.53, ["Neon|Ride"] = 493.05, ["Neon|Fly|Ride"] = 959.38, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.96, ["Fly"] = 96.55, ["Ride"] = 34.33, ["Fly|Ride"] = 102.75, ["Neon"] = 147, ["Neon|Ride"] = 93.49, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 548.51, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 17.41, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 52.64, ["Neon"] = 196.62, ["Neon|Fly"] = 274.26, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 123.27, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2177.59}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14, ["Fly"] = 274.26, ["Ride"] = 33.64, ["Fly|Ride"] = 91.87, ["Neon"] = 100.68, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 549.94, ["Mega|Ride"] = 465.94, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.96, ["Fly"] = 55.49, ["Ride"] = 22.32, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Fly"] = 338.98, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 178.75, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 308.16}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 24.93, ["Ride"] = 49.32, ["Fly|Ride"] = 183.75, ["Neon"] = 164.36, ["Neon|Fly"] = 821.73, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 656.37, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 799.23}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 274.26, ["Fly"] = 436.13, ["Ride"] = 341.25, ["Fly|Ride"] = 384.18, ["Neon|Ride"] = 1137.08, ["Neon|Fly|Ride"] = 958.13, ["Mega"] = 7875, ["Mega|Fly"] = 4313.06, ["Mega|Ride"] = 3697.79, ["Mega|Fly|Ride"] = 3609.38}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.61, ["Fly"] = 26.24, ["Ride"] = 15.27, ["Fly|Ride"] = 38.07, ["Neon"] = 15.42, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 69.3, ["Mega"] = 285.57, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 238.28}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 37.94, ["Fly"] = 85.62, ["Ride"] = 77.3, ["Fly|Ride"] = 131.25, ["Neon"] = 164.07, ["Neon|Fly"] = 303.03, ["Neon|Ride"] = 192.1, ["Neon|Fly|Ride"] = 254.92, ["Mega"] = 498.75, ["Mega|Fly"] = 821.73, ["Mega|Ride"] = 564.36, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.45, ["Fly"] = 951, ["Ride"] = 761.25, ["Fly|Ride"] = 822.94, ["Neon|Ride"] = 1458.19, ["Neon|Fly|Ride"] = 1410.94, ["Mega|Fly|Ride"] = 3801.36}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 32.82, ["Fly"] = 91.43, ["Ride"] = 43.32, ["Fly|Ride"] = 72.19, ["Neon"] = 206.07, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 301.88, ["Fly"] = 328.13, ["Ride"] = 288.75, ["Fly|Ride"] = 291.38, ["Neon|Fly|Ride"] = 1232.85, ["Mega|Fly|Ride"] = 6848.09}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 137.65, ["Fly"] = 155.44, ["Ride"] = 150.94, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 693.34, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 572.42, ["Ride"] = 603.74, ["Fly|Ride"] = 735, ["Neon|Ride"] = 2520.67, ["Neon|Fly|Ride"] = 2328.59, ["Mega|Fly|Ride"] = 8011.86}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 26.72, ["Ride"] = 39.5, ["Fly|Ride"] = 92.55, ["Neon"] = 108.89, ["Neon|Fly"] = 278.35, ["Neon|Ride"] = 128.75, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 306.11, ["Mega|Ride"] = 342.17, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3972.05, ["Ride"] = 3173.29, ["Fly|Ride"] = 3341.5, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 115.49, ["Fly"] = 131.24, ["Ride"] = 116.82, ["Fly|Ride"] = 146.99, ["Neon"] = 380.63, ["Neon|Ride"] = 508.47, ["Neon|Fly|Ride"] = 419.45, ["Mega|Fly|Ride"] = 2328.59}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.58, ["Fly"] = 26.25, ["Ride"] = 18.02, ["Fly|Ride"] = 45.94, ["Neon"] = 23.63, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 194.76, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.59, ["Ride"] = 27.57, ["Fly|Ride"] = 82.69, ["Neon"] = 18.19, ["Neon|Ride"] = 46.4, ["Neon|Fly|Ride"] = 210, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 226.64}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.94, ["Fly"] = 152.06, ["Ride"] = 37.41, ["Fly|Ride"] = 59.15, ["Neon"] = 271.4, ["Neon|Ride"] = 287.62, ["Neon|Fly|Ride"] = 303.03, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 958.13, ["Ride"] = 1096.13, ["Fly|Ride"] = 1115.63}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6037.5, ["Ride"] = 6959.28, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.23, ["Fly"] = 31.34, ["Ride"] = 23.67, ["Fly|Ride"] = 45.94, ["Neon"] = 261.86, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 171.54, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.48, ["Fly"] = 45.88, ["Ride"] = 28.87, ["Fly|Ride"] = 88.35, ["Neon"] = 94.4, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 642.48, ["Mega|Ride"] = 630.69, ["Mega|Fly|Ride"] = 500}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 72, ["Fly"] = 88.35, ["Ride"] = 71.49, ["Fly|Ride"] = 108.94, ["Neon"] = 328.13, ["Neon|Ride"] = 371.14, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2054.33, ["Mega|Ride"] = 1787.28, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 183.75, ["Fly"] = 309.66, ["Ride"] = 216.57, ["Fly|Ride"] = 288.75, ["Neon|Ride"] = 1314.93, ["Neon|Fly|Ride"] = 957.33, ["Mega"] = 10271.61, ["Mega|Fly|Ride"] = 3561.18}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.2, ["Ride"] = 39.38, ["Fly|Ride"] = 86.63, ["Neon"] = 20.79, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.46, ["Mega"] = 136.5, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 170.63, ["Fly"] = 232.15, ["Ride"] = 216.04, ["Fly|Ride"] = 287.62, ["Neon"] = 840, ["Neon|Ride"] = 909.24, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 4637.79, ["Mega|Fly|Ride"] = 3836.45}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.92, ["Fly"] = 33.65, ["Ride"] = 16.46, ["Fly|Ride"] = 48.27, ["Neon"] = 19.68, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 23.21, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 196.88, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 247.11}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 265.06, ["Ride"] = 248.24, ["Fly|Ride"] = 241.5, ["Neon|Ride"] = 1007.66, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 10271.61, ["Mega|Fly|Ride"] = 4081.95}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.13, ["Fly"] = 70.4, ["Ride"] = 28.91, ["Fly|Ride"] = 61.65, ["Neon"] = 56.56, ["Neon|Fly"] = 294.59, ["Neon|Ride"] = 96.57, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 513.78, ["Mega|Ride"] = 575.23, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.62, ["Ride"] = 20.25, ["Fly|Ride"] = 86.63, ["Neon"] = 10.27, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 109.92, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.63, ["Neon"] = 4.11, ["Neon|Ride"] = 31.86, ["Mega"] = 22.31, ["Mega|Ride"] = 136.79}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.34, ["Fly"] = 52.48, ["Ride"] = 32.9, ["Fly|Ride"] = 206.56, ["Neon"] = 11.46, ["Neon|Ride"] = 38.98, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 67.08, ["Mega|Fly"] = 154631.79, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 159.85}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 64.32, ["Fly"] = 136.83, ["Ride"] = 113.04, ["Fly|Ride"] = 145.69, ["Neon"] = 356.44, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 415.09, ["Mega|Fly|Ride"] = 993.34}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 17.07, ["Fly|Ride"] = 88.7, ["Neon"] = 5.25, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 96, ["Mega|Ride"] = 122.54, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.71, ["Ride"] = 124.13, ["Neon"] = 74.81, ["Neon|Ride"] = 91.88, ["Mega"] = 602.97, ["Mega|Ride"] = 579.95, ["Mega|Fly|Ride"] = 644.04}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 43.53, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 17.06, ["Mega|Ride"] = 51.38, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.42, ["Fly|Ride"] = 23.22, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.11, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 13.75, ["Mega|Fly"] = 17.07, ["Mega|Ride"] = 26.72, ["Mega|Fly|Ride"] = 74.51}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.21, ["Fly|Ride"] = 33.66, ["Neon"] = 3.38, ["Neon|Fly"] = 20.55, ["Neon|Ride"] = 15.77, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 14.44, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 123.27, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 96.57, ["Mega"] = 16.67, ["Mega|Ride"] = 146.08, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 18.37, ["Fly|Ride"] = 107.62, ["Neon"] = 3.92, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 23.44, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Fly|Ride"] = 203.39, ["Mega"] = 24.94, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.18, ["Fly"] = 65.24, ["Ride"] = 17.07, ["Fly|Ride"] = 53.43, ["Neon"] = 10.49, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 23.92, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 64.58, ["Mega|Fly"] = 277.35, ["Mega|Ride"] = 90.96, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.28, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 15.33, ["Mega|Fly"] = 69.86, ["Mega|Ride"] = 47.27, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.65, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.26}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.69, ["Ride"] = 41.11, ["Neon"] = 6.19, ["Neon|Ride"] = 19.69, ["Mega"] = 103.69, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.94, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 32.81, ["Mega|Ride"] = 62.65, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.75, ["Fly|Ride"] = 30.09, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.8, ["Neon|Fly|Ride"] = 28.68, ["Mega"] = 15.41, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 27.56, ["Mega|Fly|Ride"] = 86.62}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.63, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Neon"] = 28.88, ["Neon|Ride"] = 140.95, ["Mega"] = 274.26}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.33, ["Neon"] = 3.55, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 23.63, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 130.47}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 5.9, ["Neon"] = 10, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 78.75, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.24, ["Ride"] = 32.82, ["Fly|Ride"] = 186.96, ["Neon"] = 15.21, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 223.02, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 14.21, ["Fly|Ride"] = 26.16, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 40.07, ["Mega"] = 17.07, ["Mega|Fly"] = 30.82, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 52.38}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 19.68, ["Fly|Ride"] = 96.57, ["Neon"] = 18.27, ["Neon|Ride"] = 111.36, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 154.14, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.61, ["Fly"] = 40.69, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.19, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 215.23, ["Mega|Ride"] = 280.88, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.75, ["Fly|Ride"] = 26.17, ["Neon"] = 3.29, ["Neon|Fly"] = 22.43, ["Neon|Ride"] = 15.41, ["Neon|Fly|Ride"] = 39.03, ["Mega"] = 17.07, ["Mega|Fly"] = 155.42, ["Mega|Ride"] = 118.15, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 171.54, ["Ride"] = 60.36, ["Neon"] = 7.88, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 36.66, ["Mega|Fly"] = 164.36, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.72, ["Fly|Ride"] = 82.19, ["Neon"] = 4.98, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.88, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.1, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 96.57, ["Mega"] = 17.07, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 108.74}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 68.83, ["Ride"] = 18.38, ["Fly|Ride"] = 32.82, ["Neon"] = 6.97, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 78.07, ["Mega|Ride"] = 81.2, ["Mega|Fly|Ride"] = 287.62}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 4.66, ["Neon|Ride"] = 43.3, ["Mega"] = 40.68, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 17.56, ["Fly|Ride"] = 43.32, ["Neon"] = 6.57, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 36.16, ["Mega"] = 133.88, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 821.84}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 35.97, ["Ride"] = 16.7, ["Fly|Ride"] = 61.64, ["Neon"] = 18.16, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 170.63, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 332.82}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.45, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 18.31, ["Neon|Fly"] = 40.17, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 223.13, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 191.62}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 37.41, ["Mega"] = 123.27, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 13.55, ["Ride"] = 76.04, ["Neon"] = 120.1, ["Neon|Ride"] = 171.66, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 4.13, ["Ride"] = 109.05, ["Neon"] = 41.11, ["Neon|Ride"] = 105, ["Mega"] = 155.42, ["Mega|Ride"] = 273.67}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 7.87, ["Ride"] = 45.66, ["Fly|Ride"] = 139.13, ["Neon"] = 55.22, ["Neon|Ride"] = 55.49, ["Mega"] = 248.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 64.99, ["Mega"] = 21, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 147.93}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.01}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.16, ["Fly"] = 21.95, ["Ride"] = 18.38, ["Fly|Ride"] = 41.35, ["Neon"] = 59.53, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 78.6, ["Mega"] = 294, ["Mega|Fly"] = 328.71, ["Mega|Ride"] = 278.35, ["Mega|Fly|Ride"] = 272.76}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 2.61, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 31.85, ["Mega|Fly"] = 137.65, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 184.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Neon"] = 4.51, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 102.74, ["Mega"] = 55.13, ["Mega|Ride"] = 57.54, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 3.5, ["Fly"] = 45.94, ["Ride"] = 19.53, ["Fly|Ride"] = 55.13, ["Neon"] = 6.57, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 113.56, ["Mega"] = 124.69, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.72, ["Ride"] = 31.86, ["Fly|Ride"] = 58.56, ["Neon"] = 32.82, ["Neon|Ride"] = 231.96, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 291.73, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 307.14}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Mega"] = 17.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 328.71}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 15.93, ["Fly|Ride"] = 273909.66, ["Neon"] = 5.15, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.42, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 124.58}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 6.46, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 55.49, ["Mega"] = 47.94, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.89, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 24.92, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 66.26, ["Mega|Fly|Ride"] = 123.27}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.27, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 80.07, ["Mega|Fly"] = 105, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 178.61}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 17.91, ["Fly|Ride"] = 49.32, ["Neon"] = 3.94, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 23.01, ["Neon|Fly|Ride"] = 76.55, ["Mega"] = 24.65, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 45.24, ["Mega|Fly|Ride"] = 109.92}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.58, ["Mega"] = 21, ["Mega|Ride"] = 123.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 6.18, ["Neon|Ride"] = 155.42, ["Mega"] = 27.57, ["Mega|Fly"] = 115.99, ["Mega|Ride"] = 122.14}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.05, ["Fly|Ride"] = 49.87, ["Neon"] = 4.76, ["Neon|Ride"] = 20.35, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 55.48, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 154.08}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 19.32, ["Fly"] = 55.5, ["Ride"] = 137.54, ["Neon"] = 124.1, ["Mega"] = 545.44, ["Mega|Ride"] = 449.68, ["Mega|Fly|Ride"] = 671.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.94, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 37.4, ["Neon|Ride"] = 203.39, ["Mega"] = 315.35, ["Mega|Ride"] = 343.08, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.72, ["Ride"] = 26.24, ["Fly|Ride"] = 410.91, ["Neon"] = 33.72, ["Mega"] = 274.26, ["Mega|Ride"] = 248.2, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.55, ["Ride"] = 12.83, ["Fly|Ride"] = 24.28, ["Neon"] = 2.1, ["Neon|Fly"] = 14.57, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 32.21, ["Mega"] = 20.56, ["Mega|Fly"] = 31.85, ["Mega|Ride"] = 22.3, ["Mega|Fly|Ride"] = 49.81}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.63, ["Fly"] = 118.12, ["Ride"] = 48.29, ["Fly|Ride"] = 109.92, ["Neon"] = 17.07, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 685.13, ["Mega"] = 115.5, ["Mega|Ride"] = 96.57}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 84.07, ["Mega"] = 15.64, ["Mega|Fly"] = 80.68, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 101.54}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.65, ["Neon"] = 2.63, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 96.57, ["Neon|Fly|Ride"] = 122.25, ["Mega"] = 23.63, ["Mega|Ride"] = 82.19, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19.53, ["Fly|Ride"] = 45.94, ["Neon"] = 11.69, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 88.35, ["Mega"] = 183.65, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 248.2}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 173.88, ["Ride"] = 229.09, ["Fly|Ride"] = 183.75, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8217.28, ["Mega|Fly|Ride"] = 3328.01}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 9.18, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 68.25, ["Mega"] = 61.69, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 773.56}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.13, ["Fly"] = 103.68, ["Ride"] = 35.97, ["Neon"] = 59.07, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 155.11, ["Mega"] = 155.42, ["Mega|Fly|Ride"] = 409.85}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 805.27, ["Ride"] = 15.09, ["Fly|Ride"] = 32.79, ["Neon"] = 6.57, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 61.95, ["Mega"] = 49.67, ["Mega|Ride"] = 75.12, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.47, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.13, ["Fly"] = 24.93, ["Ride"] = 15.75, ["Fly|Ride"] = 34.06, ["Neon"] = 23.63, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 205.44, ["Mega|Ride"] = 260.92, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.78, ["Ride"] = 23.62, ["Fly|Ride"] = 55.49, ["Neon"] = 45.23, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 185.58, ["Mega|Ride"] = 356.05, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.49, ["Fly"] = 16.54, ["Ride"] = 14.89, ["Fly|Ride"] = 33.65, ["Neon"] = 18.16, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 73.32, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 81.77, ["Fly"] = 152.19, ["Ride"] = 94.49, ["Fly|Ride"] = 150.94, ["Neon"] = 426.28, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 446.25, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 328.75, ["Ride"] = 223.13, ["Fly|Ride"] = 262.5, ["Neon"] = 927.81, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1025.26, ["Mega"] = 10271.61, ["Mega|Fly|Ride"] = 3957.66}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 65.63, ["Fly"] = 137.65, ["Ride"] = 74.82, ["Fly|Ride"] = 120.74, ["Neon"] = 402.45, ["Neon|Ride"] = 309.65, ["Neon|Fly|Ride"] = 334.87, ["Mega|Fly|Ride"] = 1325.02}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 92.8, ["Neon"] = 32.82, ["Neon|Ride"] = 62.56, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 189.06, ["Mega|Ride"] = 376.04, ["Mega|Fly|Ride"] = 394.32}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 14.34, ["Fly"] = 68.83, ["Ride"] = 30.82, ["Fly|Ride"] = 81.14, ["Neon"] = 77.04, ["Neon|Ride"] = 97.09, ["Neon|Fly|Ride"] = 171.54, ["Mega"] = 274.26, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.48, ["Ride"] = 17.67, ["Fly|Ride"] = 39.44, ["Neon"] = 6.13, ["Neon|Fly"] = 67.3, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 68.86, ["Mega"] = 94.5, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 92.79, ["Mega|Fly|Ride"] = 174.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.14, ["Fly"] = 68.83, ["Ride"] = 27.75, ["Fly|Ride"] = 309.66, ["Neon"] = 53.43, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 882.34, ["Mega|Ride"] = 583.44, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.62, ["Fly"] = 41.1, ["Ride"] = 15.31, ["Fly|Ride"] = 46.4, ["Neon"] = 14.44, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 155.42, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 6.18, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 233.18, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 155.42, ["Mega"] = 207.37, ["Mega|Ride"] = 206.45, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 35.97, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 14.44, ["Mega|Ride"] = 50.35, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.41, ["Fly"] = 45.94, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 98, ["Mega"] = 84, ["Mega|Ride"] = 105.82, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 45.94, ["Neon"] = 17.41, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.92, ["Mega"] = 283.5, ["Mega|Ride"] = 199.28, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 157.5, ["Fly"] = 273.27, ["Ride"] = 202.13, ["Fly|Ride"] = 232.32, ["Neon"] = 700.88, ["Neon|Ride"] = 696.94, ["Neon|Fly|Ride"] = 773.55, ["Mega|Fly|Ride"] = 3645.08}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 6.04, ["Ride"] = 30.83, ["Fly|Ride"] = 204.42, ["Neon"] = 77.44, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 314.32, ["Mega|Ride"] = 369.79, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 16.21, ["Fly|Ride"] = 43.26, ["Neon"] = 13.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 274.26, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.31, ["Ride"] = 41.11, ["Fly|Ride"] = 170.63, ["Neon"] = 119.23, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 516.46, ["Mega"] = 453.14, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 707.45}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.24}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.29, ["Ride"] = 25.54, ["Neon"] = 42.95, ["Neon|Ride"] = 77.72, ["Neon|Fly|Ride"] = 616.3, ["Mega"] = 385.2, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 819.69}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 26.7, ["Fly"] = 77.66, ["Ride"] = 23.22, ["Fly|Ride"] = 55.49, ["Neon"] = 178.75, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 2054.33, ["Mega|Fly|Ride"] = 1088.8}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 6.18, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 105, ["Mega"] = 31.34, ["Mega|Fly"] = 410.87, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 11.1, ["Fly"] = 27.6, ["Ride"] = 26.7, ["Fly|Ride"] = 61.64, ["Neon"] = 32.81, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 34.95, ["Mega"] = 231.48, ["Mega|Fly"] = 387.36, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 17.26, ["Fly|Ride"] = 43.36, ["Neon"] = 15.28, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.85, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 133.71, ["Mega|Ride"] = 124.1, ["Mega|Fly|Ride"] = 201.8}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 31.34, ["Fly|Ride"] = 82.19, ["Neon"] = 3.69, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 124.1, ["Mega"] = 27.57, ["Mega|Ride"] = 82.36, ["Mega|Fly|Ride"] = 137.65}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 30.18, ["Fly"] = 32.82, ["Ride"] = 114.84, ["Neon"] = 250.66, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 346.78, ["Mega"] = 902.45, ["Mega|Ride"] = 1037.45, ["Mega|Fly|Ride"] = 1023.83}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.73, ["Ride"] = 51.06, ["Neon"] = 80.07, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 328.71, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 6.55, ["Fly"] = 87.49, ["Ride"] = 39.38, ["Fly|Ride"] = 69.56, ["Neon"] = 65.63, ["Neon|Fly"] = 315, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 116.08, ["Mega"] = 372.43, ["Mega|Ride"] = 320.24, ["Mega|Fly|Ride"] = 353.43}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 51.19, ["Fly"] = 433.13, ["Ride"] = 105, ["Fly|Ride"] = 262.44, ["Neon"] = 409.85, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 685.13, ["Mega"] = 1602.39, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1313.75}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.98, ["Fly"] = 39.38, ["Ride"] = 23.63, ["Fly|Ride"] = 60.38, ["Neon"] = 53.82, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 315.35, ["Mega|Ride"] = 215.34, ["Mega|Fly|Ride"] = 368.02}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 81.38, ["Fly"] = 143.07, ["Ride"] = 108.42, ["Neon"] = 183.75, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 225.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1010.21, ["Mega|Ride"] = 1068.26, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 24.43, ["Ride"] = 57.16, ["Fly|Ride"] = 143.82, ["Neon"] = 59.07, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 267.07, ["Mega"] = 385.05, ["Mega|Ride"] = 274.26, ["Mega|Fly|Ride"] = 399.38}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.88, ["Fly"] = 233.65, ["Ride"] = 27.76, ["Fly|Ride"] = 41.1, ["Neon"] = 82.68, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 368.82, ["Mega"] = 625.19, ["Mega|Fly|Ride"] = 463.91}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 22.05, ["Ride"] = 105, ["Fly|Ride"] = 151.68, ["Neon"] = 88.35, ["Neon|Ride"] = 129.66, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 255.2, ["Mega|Fly"] = 496.14, ["Mega|Ride"] = 306.64, ["Mega|Fly|Ride"] = 425.24}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 10.37, ["Ride"] = 41.11, ["Fly|Ride"] = 135.61, ["Neon"] = 57.9, ["Neon|Ride"] = 97.43, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 385.2, ["Mega|Ride"] = 306.39, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.37, ["Neon|Fly"] = 53.43, ["Neon|Ride"] = 56.44, ["Mega"] = 18.38, ["Mega|Fly"] = 137.65, ["Mega|Ride"] = 68.83, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.78, ["Ride"] = 27.26, ["Neon"] = 18.75, ["Neon|Fly"] = 123.27, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 463.91}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 46.41, ["Neon"] = 23.61, ["Neon|Ride"] = 420, ["Mega"] = 183.24, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.07, ["Ride"] = 32.78, ["Fly|Ride"] = 114.83, ["Neon"] = 15.75, ["Neon|Ride"] = 82.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.37, ["Mega|Ride"] = 212.26, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 543.38, ["Ride"] = 525, ["Fly|Ride"] = 616.88, ["Neon"] = 1703.04, ["Neon|Ride"] = 1453.78, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.61, ["Fly"] = 27.75, ["Ride"] = 23.22, ["Fly|Ride"] = 59.59, ["Neon"] = 26.25, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 369.79, ["Mega|Fly|Ride"] = 487.91}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.17, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 60.38, ["Neon"] = 76.12, ["Neon|Ride"] = 53.96, ["Mega"] = 273.27, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.52, ["Ride"] = 17.07, ["Fly|Ride"] = 308.16, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 149.98, ["Mega"] = 252.83, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.37, ["Fly"] = 64.97, ["Ride"] = 24.94, ["Fly|Ride"] = 90.57, ["Neon"] = 7.34, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 91.62, ["Mega"] = 73.62, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.83, ["Ride"] = 17.07, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.94, ["Mega"] = 22.32, ["Mega|Ride"] = 77.42, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1106.44}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 9.86, ["Ride"] = 41.11, ["Fly|Ride"] = 68.82, ["Neon"] = 76.02, ["Neon|Ride"] = 72.17, ["Neon|Fly|Ride"] = 178.75, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 846.4}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.24, ["Neon|Ride"] = 40.69, ["Mega"] = 39.15, ["Mega|Ride"] = 149.98, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.08, ["Fly"] = 96.58, ["Ride"] = 58.49, ["Fly|Ride"] = 39.38, ["Neon"] = 7.83, ["Neon|Fly"] = 123.27, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 210, ["Mega"] = 131.25, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 452.82, ["Ride"] = 504.9, ["Fly|Ride"] = 463.97, ["Neon|Ride"] = 1571.57, ["Neon|Fly|Ride"] = 1217.58, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.7, ["Fly"] = 196.88, ["Neon"] = 137.82, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 458.12, ["Mega|Ride"] = 440.71}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 74.08, ["Ride"] = 29.29, ["Fly|Ride"] = 141.75, ["Neon"] = 4.98, ["Neon|Ride"] = 38.05, ["Neon|Fly|Ride"] = 124.1, ["Mega"] = 40.67, ["Mega|Fly"] = 189, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 821.85, ["Neon"] = 3.94, ["Neon|Ride"] = 109.85, ["Neon|Fly|Ride"] = 260.92, ["Mega"] = 24.68, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 217.77}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 13.12, ["Fly"] = 107.62, ["Ride"] = 26.25, ["Fly|Ride"] = 178.5, ["Neon"] = 65.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.71, ["Mega"] = 578.73, ["Mega|Ride"] = 397.69, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.87, ["Fly|Ride"] = 124.1, ["Neon"] = 101.71, ["Neon|Ride"] = 123.27, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.75, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 1068.26}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 39.38, ["Fly|Ride"] = 137.65, ["Neon"] = 27.75, ["Neon|Ride"] = 155.42, ["Mega"] = 634.46, ["Mega|Ride"] = 958.32, ["Mega|Fly|Ride"] = 1232.6}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.38, ["Ride"] = 34.94, ["Neon"] = 162.31, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 184.9, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1641.42, ["Neon|Fly"] = 1725.65, ["Neon|Ride"] = 1642.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.63, ["Mega|Fly|Ride"] = 3822}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.94, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 51.38, ["Neon"] = 98.44, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 685.13, ["Mega|Ride"] = 544.04, ["Mega|Fly|Ride"] = 846.4}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.03, ["Fly|Ride"] = 78.75, ["Neon"] = 35.44, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 773.56}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 18.06, ["Ride"] = 68.45, ["Fly|Ride"] = 253.64, ["Neon"] = 44, ["Neon|Ride"] = 114.83, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 268.54, ["Mega|Fly"] = 548.51, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 324.11}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.14, ["Fly"] = 40.61, ["Ride"] = 52.5, ["Fly|Ride"] = 123.3, ["Neon"] = 7.25, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 44.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 139.18}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 45.71, ["Ride"] = 91.88, ["Fly|Ride"] = 157.5, ["Neon"] = 273.25, ["Neon|Ride"] = 294.81, ["Neon|Fly|Ride"] = 462.24, ["Mega"] = 1781.11, ["Mega|Ride"] = 1232.6, ["Mega|Fly|Ride"] = 1263.42}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.62, ["Fly"] = 56.44, ["Ride"] = 34.94, ["Neon"] = 10.49, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 78.75, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 178.5}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 31.34, ["Ride"] = 27.57, ["Fly|Ride"] = 148.25, ["Neon"] = 6.18, ["Neon|Fly"] = 68.44, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 131.5, ["Mega"] = 40.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.45}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Fly"] = 1519.88, ["Ride"] = 27.57, ["Fly|Ride"] = 124.3, ["Neon"] = 14.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 116.82, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 69.6, ["Fly"] = 92.79, ["Ride"] = 105.37, ["Neon"] = 437.07, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 615.28, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 274.32, ["Ride"] = 262.5, ["Fly|Ride"] = 415.9, ["Neon"] = 1427.77, ["Neon|Ride"] = 1095.99, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6162.97, ["Mega|Fly|Ride"] = 4948.6}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.39, ["Neon"] = 53.42, ["Neon|Ride"] = 152.02, ["Mega"] = 90.57, ["Mega|Ride"] = 177.57, ["Mega|Fly|Ride"] = 390.33}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Ride"] = 32.71, ["Fly|Ride"] = 155.42, ["Neon"] = 17.41, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 54.56, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 356.05}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.63, ["Fly"] = 30.17, ["Ride"] = 20.56, ["Fly|Ride"] = 174.64, ["Neon"] = 4.66, ["Mega"] = 347.17, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.68, ["Fly"] = 58.92, ["Ride"] = 20.46, ["Fly|Ride"] = 133.88, ["Neon"] = 9.19, ["Neon|Ride"] = 34.81, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 68.83, ["Mega|Ride"] = 100.91, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 15.75, ["Mega"] = 52.5, ["Mega|Fly|Ride"] = 271.19}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.74, ["Fly|Ride"] = 41.99, ["Neon"] = 4.66, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 97.6, ["Mega"] = 43.6, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 137.65}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.42, ["Ride"] = 20.46, ["Fly|Ride"] = 53.4, ["Neon"] = 8.87, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 156.15, ["Mega|Ride"] = 231.12, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 25.55, ["Fly"] = 35.97, ["Ride"] = 42, ["Fly|Ride"] = 82.56, ["Neon"] = 274.26, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 409.85, ["Mega|Fly|Ride"] = 488.94}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 66, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 124.02, ["Neon"] = 410.87, ["Neon|Ride"] = 389.82, ["Mega"] = 1575.68, ["Mega|Ride"] = 1643.46, ["Mega|Fly|Ride"] = 1424.69}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.81, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 37.7, ["Mega|Fly"] = 672, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 15.73, ["Fly|Ride"] = 35.44, ["Neon"] = 5.2, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 55.49, ["Mega"] = 49.86, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 5.25, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.53, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 273.25, ["Mega"] = 260.95, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.5, ["Fly"] = 393.75, ["Ride"] = 541.4, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1781.11, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 7122.34}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 25.79, ["Fly"] = 91.08, ["Ride"] = 65.63, ["Fly|Ride"] = 103.69, ["Neon"] = 246.53, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 277.35, ["Mega|Ride"] = 1232.6, ["Mega|Fly|Ride"] = 951.27}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 281.28, ["Neon"] = 11.58, ["Neon|Ride"] = 74.24, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 91.88, ["Mega|Ride"] = 133.85, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.26, ["Fly"] = 205.48, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 131.15}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 41.98, ["Fly"] = 45.94, ["Ride"] = 43.3, ["Fly|Ride"] = 68.83, ["Neon"] = 118.13, ["Neon|Ride"] = 281.93, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2465.19, ["Mega|Fly|Ride"] = 1237.45}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 99.75, ["Fly|Ride"] = 189.08, ["Neon"] = 498.75, ["Neon|Ride"] = 468.4, ["Neon|Fly|Ride"] = 478.68, ["Mega"] = 8217.28, ["Mega|Fly|Ride"] = 1869.45}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 229.69, ["Fly"] = 307.14, ["Ride"] = 261.98, ["Fly|Ride"] = 410.87, ["Neon"] = 820.32, ["Neon|Ride"] = 890.56, ["Neon|Fly|Ride"] = 1092.92, ["Mega|Fly|Ride"] = 3219.14}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 14.43, ["Ride"] = 61.68, ["Fly|Ride"] = 150.94, ["Neon"] = 73.49, ["Neon|Ride"] = 135.56, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 376.65, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 14.39, ["Fly|Ride"] = 40.63, ["Neon"] = 7.48, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.23, ["Mega|Ride"] = 109.92, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 3.29, ["Fly"] = 19.69, ["Ride"] = 18.38, ["Fly|Ride"] = 109.04, ["Neon"] = 27.83, ["Neon|Fly"] = 143.82, ["Neon|Ride"] = 269.14, ["Neon|Fly|Ride"] = 102.74, ["Mega"] = 314.32, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 229.69, ["Fly"] = 479.7, ["Ride"] = 326.82, ["Fly|Ride"] = 410.93, ["Neon"] = 1050, ["Neon|Ride"] = 1115.63, ["Neon|Fly|Ride"] = 1649.82, ["Mega|Ride"] = 5478.88, ["Mega|Fly|Ride"] = 5722.14}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.24, ["Ride"] = 55.5, ["Neon"] = 13.13, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 43.32, ["Mega|Ride"] = 178.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.28, ["Fly"] = 21.59, ["Ride"] = 18.57, ["Fly|Ride"] = 41.1, ["Neon"] = 49.87, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 97.6, ["Mega"] = 155.42, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.58, ["Mega|Fly|Ride"] = 246.53}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.44, ["Ride"] = 114.19, ["Neon"] = 103.69, ["Neon|Fly"] = 410.87, ["Neon|Ride"] = 142.14, ["Neon|Fly|Ride"] = 387.36, ["Mega"] = 463.07, ["Mega|Ride"] = 539.44, ["Mega|Fly|Ride"] = 453}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 120.94, ["Fly"] = 137.65, ["Ride"] = 115.81, ["Fly|Ride"] = 124.69, ["Neon|Ride"] = 695.86, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 21.93, ["Fly"] = 48.29, ["Ride"] = 26.36, ["Fly|Ride"] = 61.57, ["Neon"] = 78.74, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 171.54, ["Mega"] = 630.69, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.63, ["Neon|Ride"] = 138.67, ["Neon|Fly|Ride"] = 685.13, ["Mega"] = 20.57, ["Mega|Ride"] = 273.25, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.6, ["Fly|Ride"] = 52.5, ["Neon"] = 3.68, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 23.67, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 114.03}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.03, ["Fly"] = 410.93, ["Ride"] = 49.87, ["Fly|Ride"] = 172.57, ["Neon"] = 34.92, ["Neon|Fly"] = 222.69, ["Neon|Ride"] = 84.17, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 144.37, ["Mega|Fly"] = 274.26, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 260.92}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.57, ["Ride"] = 1312.49, ["Fly|Ride"] = 1488.38, ["Neon"] = 4200, ["Neon|Fly|Ride"] = 4621.21, ["Mega|Fly|Ride"] = 10893.75}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 380.63, ["Ride"] = 467.42, ["Fly|Ride"] = 604.54, ["Neon"] = 1740.03, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1814.22, ["Mega"] = 13916.81, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 288.75, ["Fly"] = 362.25, ["Ride"] = 366.8, ["Fly|Ride"] = 433.13, ["Neon"] = 656.25, ["Neon|Fly"] = 1237.45, ["Neon|Ride"] = 624.01, ["Neon|Fly|Ride"] = 721.87, ["Mega|Fly|Ride"] = 3068.42}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 326.82, ["Fly"] = 413.12, ["Ride"] = 374.07, ["Fly|Ride"] = 456.63, ["Neon"] = 1027.17, ["Neon|Fly"] = 1370.24, ["Neon|Ride"] = 968.62, ["Neon|Fly|Ride"] = 971.25, ["Mega|Fly|Ride"] = 4617.11}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 23.39, ["Ride"] = 18.26, ["Fly|Ride"] = 41.1, ["Neon"] = 5.69, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.19, ["Mega"] = 63.78, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 378, ["Ride"] = 433.57, ["Fly|Ride"] = 548.51, ["Neon"] = 1680, ["Neon|Ride"] = 1509.37, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 5722.14, ["Mega|Fly|Ride"] = 8118.14}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.59, ["Fly"] = 183.75, ["Ride"] = 112.53, ["Neon"] = 9.65, ["Neon|Ride"] = 64.73, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 65.63, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 271.19}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.54, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 101.85, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 45.94, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 343.08, ["Mega|Ride"] = 927.81}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 8038.15, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.25, ["Neon|Ride"] = 77.72, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 3.93, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 29.19, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.36, ["Mega|Fly"] = 685.13, ["Mega|Ride"] = 155.29, ["Mega|Fly|Ride"] = 110.25}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.61, ["Fly"] = 35.9, ["Ride"] = 20.56, ["Fly|Ride"] = 61.85, ["Neon"] = 14.38, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 82.43, ["Mega"] = 76.4, ["Mega|Fly"] = 171.54, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.94, ["Fly"] = 55.49, ["Ride"] = 22.61, ["Fly|Ride"] = 51.45, ["Neon"] = 152.03, ["Neon|Fly"] = 73.97, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 245.51, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.38, ["Ride"] = 53.82, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 263.28, ["Mega"] = 309.66, ["Mega|Ride"] = 439.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.93, ["Fly"] = 6186.8, ["Ride"] = 41.11, ["Neon"] = 15.75, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.16, ["Fly|Ride"] = 54.53, ["Neon"] = 4.73, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 24.97, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 188.99, ["Fly"] = 274.26, ["Ride"] = 224.68, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 1026.14, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 8217.28, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.75, ["Fly|Ride"] = 31.86, ["Neon"] = 5.25, ["Neon|Fly"] = 51.38, ["Neon|Ride"] = 21.55, ["Neon|Fly|Ride"] = 41.1, ["Mega"] = 27.74, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.5, ["Fly"] = 137.68, ["Ride"] = 55.5, ["Fly|Ride"] = 183.72, ["Neon"] = 84, ["Neon|Ride"] = 100.66, ["Mega"] = 459.25, ["Mega|Ride"] = 433.76, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.24, ["Fly"] = 210, ["Ride"] = 93.17, ["Fly|Ride"] = 167.23, ["Neon"] = 196.88, ["Neon|Ride"] = 309.66, ["Mega"] = 821.73, ["Mega|Ride"] = 849.48}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 178.4, ["Fly"] = 304.5, ["Ride"] = 236.25, ["Fly|Ride"] = 382.12, ["Neon"] = 821.73, ["Neon|Fly"] = 1159.75, ["Neon|Ride"] = 834.06, ["Neon|Fly|Ride"] = 740.25, ["Mega|Fly|Ride"] = 2624.9}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.43, ["Ride"] = 37.43, ["Fly|Ride"] = 139.2, ["Neon"] = 116.08, ["Neon|Ride"] = 274.26, ["Mega"] = 287.44, ["Mega|Ride"] = 397.53, ["Mega|Fly|Ride"] = 1232.6}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 28.88, ["Ride"] = 48.57, ["Fly|Ride"] = 616.3, ["Neon"] = 86.63, ["Neon|Ride"] = 199.5, ["Mega"] = 463.68, ["Mega|Ride"] = 1643.46, ["Mega|Fly|Ride"] = 928.56}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1107.75, ["Fly"] = 1441.13, ["Ride"] = 1050, ["Fly|Ride"] = 1162.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16981.02}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 9.19, ["Fly"] = 21, ["Ride"] = 19.56, ["Fly|Ride"] = 42, ["Neon"] = 43.15, ["Neon|Fly"] = 75.2, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 270.16, ["Mega|Ride"] = 219.82, ["Mega|Fly|Ride"] = 267.07}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.65, ["Fly"] = 65.63, ["Ride"] = 40.07, ["Neon"] = 30.24, ["Neon|Ride"] = 78.75, ["Mega"] = 342.15, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 217.8, ["Mega|Fly|Ride"] = 270.16}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.63, ["Fly"] = 81.17, ["Ride"] = 22.32, ["Fly|Ride"] = 69.57, ["Neon"] = 15.42, ["Neon|Ride"] = 33.74, ["Mega"] = 90.55, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 18.57, ["Fly"] = 55.5, ["Ride"] = 36.75, ["Fly|Ride"] = 102.14, ["Neon"] = 76.13, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 349.51, ["Mega|Fly|Ride"] = 488.53}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.72, ["Fly"] = 20.99, ["Ride"] = 20.7, ["Fly|Ride"] = 51.19, ["Neon"] = 24.71, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 59.24, ["Mega"] = 147.93, ["Mega|Ride"] = 152.03, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.52, ["Ride"] = 22.05, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 68.22, ["Neon|Fly|Ride"] = 123.27, ["Mega"] = 103.76, ["Mega|Fly"] = 205.44, ["Mega|Ride"] = 191.09, ["Mega|Fly|Ride"] = 304.42}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.13, ["Ride"] = 437.07, ["Fly|Ride"] = 588, ["Neon|Ride"] = 1315.16, ["Neon|Fly|Ride"] = 1232.6}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 25.46, ["Ride"] = 18.27, ["Fly|Ride"] = 48.57, ["Neon"] = 9.21, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 105, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 223.94}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.06, ["Ride"] = 81.78, ["Neon"] = 137.65, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 233.1}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.78, ["Fly"] = 89.42, ["Ride"] = 18.57, ["Neon"] = 10.8, ["Neon|Ride"] = 84, ["Mega"] = 84.94, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 343.08}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 368.76, ["Ride"] = 314.99, ["Fly|Ride"] = 1036.23, ["Neon"] = 708.75, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 1068.26, ["Mega"] = 4638.95, ["Mega|Ride"] = 4382.9, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.61, ["Fly"] = 54.8, ["Ride"] = 41.11, ["Fly|Ride"] = 135.6, ["Neon"] = 122.25, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 721.08, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 22.32, ["Ride"] = 76.13, ["Fly|Ride"] = 124.13, ["Neon"] = 105, ["Neon|Ride"] = 123.27, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 501.4, ["Mega|Ride"] = 429.19, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 44.18, ["Mega"] = 32.31, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 54.87, ["Fly"] = 84.46, ["Ride"] = 110.15, ["Fly|Ride"] = 180.26, ["Neon"] = 262.47, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 253.72, ["Neon|Fly|Ride"] = 328.09, ["Mega|Fly|Ride"] = 1142.63}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.83, ["Neon"] = 5.25, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 588, ["Mega"] = 45.1, ["Mega|Fly|Ride"] = 409.85}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 17.66, ["Fly"] = 124.1, ["Ride"] = 23.64, ["Fly|Ride"] = 68.39, ["Neon"] = 45.94, ["Neon|Ride"] = 109.04, ["Neon|Fly|Ride"] = 246.53, ["Mega"] = 382.05, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 406.76, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 47.25, ["Fly"] = 110.06, ["Ride"] = 79.95, ["Fly|Ride"] = 104.89, ["Neon"] = 182.49, ["Neon|Ride"] = 246.53, ["Neon|Fly|Ride"] = 355.69, ["Mega|Ride"] = 1313.75, ["Mega|Fly|Ride"] = 1100.98}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 30.07, ["Ride"] = 15.27, ["Fly|Ride"] = 33.64, ["Neon"] = 2.1, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 55.49, ["Mega"] = 18.38, ["Mega|Fly"] = 55.49, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 90.14}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.62, ["Ride"] = 35, ["Fly|Ride"] = 131.25, ["Neon"] = 17.06, ["Neon|Ride"] = 58.56, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 150.94, ["Mega|Ride"] = 194.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 31.34, ["Fly"] = 137.65, ["Ride"] = 52.5, ["Fly|Ride"] = 143.82, ["Neon"] = 111.44, ["Neon|Ride"] = 204.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 545.44, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 753.95}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.63, ["Neon|Ride"] = 18.37, ["Mega"] = 23.63, ["Mega|Ride"] = 77.72}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.31, ["Ride"] = 32.82, ["Fly|Ride"] = 99.75, ["Neon"] = 80.07, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 548.51, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 432.73}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 23.64, ["Fly"] = 27.75, ["Ride"] = 26.72, ["Fly|Ride"] = 45.94, ["Neon"] = 212.7, ["Neon|Ride"] = 118.31, ["Mega"] = 431.43, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.41, ["Ride"] = 52.5, ["Fly|Ride"] = 76.02, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.97, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 170.63, ["Mega|Ride"] = 232.31, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 13.13, ["Fly"] = 2054.33, ["Ride"] = 69.47, ["Fly|Ride"] = 128.71, ["Neon"] = 59.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 6184.87, ["Mega"] = 356.05, ["Mega|Ride"] = 507.94, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 20.56, ["Fly|Ride"] = 196.87, ["Neon"] = 9.19, ["Neon|Fly"] = 55.49, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 102.14, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 124.1}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 2.1, ["Neon|Ride"] = 89.17, ["Mega"] = 30.17, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 209.84}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 39.29}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 40.68, ["Fly"] = 102.38, ["Ride"] = 68.85, ["Fly|Ride"] = 205.44, ["Neon"] = 131.25, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 410.87, ["Mega"] = 1224.39, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 836.21}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 35.97, ["Mega|Ride"] = 164.36, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 380.63, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 3080.46, ["Mega"] = 16434.56}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.56, ["Fly"] = 25.99, ["Ride"] = 39.38, ["Fly|Ride"] = 66.26, ["Neon"] = 13.13, ["Neon|Ride"] = 273.24, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.83, ["Mega|Fly"] = 141.75, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 72.96, ["Ride"] = 21.67, ["Fly|Ride"] = 63, ["Neon"] = 17.07, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 164.36, ["Mega|Ride"] = 159.17, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 18.57, ["Fly"] = 77.06, ["Ride"] = 72.19, ["Fly|Ride"] = 106.32, ["Neon"] = 68.25, ["Neon|Ride"] = 179.78, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 753.95, ["Mega|Ride"] = 405.75}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 3.94, ["Fly"] = 131.25, ["Ride"] = 32.16, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.5, ["Fly"] = 43.17, ["Ride"] = 92.7, ["Fly|Ride"] = 157.49, ["Neon"] = 52.41, ["Neon|Ride"] = 91.77, ["Neon|Fly|Ride"] = 359, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 649.04}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.13, ["Fly"] = 104.99, ["Ride"] = 35.44, ["Fly|Ride"] = 184.9, ["Neon"] = 55.49, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 216.47, ["Mega|Fly"] = 478.68, ["Mega|Ride"] = 273.25, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 14.44, ["Fly|Ride"] = 66.93, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 76.97, ["Mega"] = 15.58, ["Mega|Fly"] = 61.64, ["Mega|Ride"] = 35.4, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.54, ["Fly"] = 274.26, ["Ride"] = 27.57, ["Fly|Ride"] = 102.74, ["Neon"] = 23.21, ["Neon|Fly"] = 115.99, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 110.19, ["Mega"] = 144.38, ["Mega|Fly"] = 204.42, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 282.08, ["Fly"] = 292.9, ["Ride"] = 315, ["Fly|Ride"] = 393.75, ["Neon"] = 1438.03, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1046.06, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 98.1, ["Ride"] = 137.27, ["Fly|Ride"] = 294.59, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4108.64, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1575.68}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.46, ["Ride"] = 21.83, ["Fly|Ride"] = 39.42, ["Neon"] = 11.62, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 59.59, ["Mega|Fly"] = 204.42, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 164.36}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.82, ["Fly|Ride"] = 31.63, ["Neon"] = 6.18, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 23.45, ["Neon|Fly|Ride"] = 55.11, ["Mega"] = 70.88, ["Mega|Fly"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.94, ["Ride"] = 20.56, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Mega"] = 137.65, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.25, ["Fly"] = 420, ["Ride"] = 286.16, ["Fly|Ride"] = 367.5, ["Neon|Ride"] = 1162.76, ["Neon|Fly|Ride"] = 1308.61, ["Mega|Ride"] = 8217.28, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.82, ["Fly"] = 19.69, ["Ride"] = 17.07, ["Fly|Ride"] = 40.69, ["Neon"] = 27.75, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.18, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.12, ["Fly"] = 155.42, ["Ride"] = 68.85, ["Fly|Ride"] = 205.48, ["Neon"] = 34.94, ["Neon|Ride"] = 139.13, ["Mega"] = 246.53, ["Mega|Ride"] = 261.18, ["Mega|Fly|Ride"] = 292.9}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.25, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.76, ["Fly"] = 35.96, ["Ride"] = 19.53, ["Fly|Ride"] = 57.23, ["Neon"] = 65.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 603.65}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.73, ["Fly"] = 155.42, ["Ride"] = 82.21, ["Fly|Ride"] = 131.25, ["Neon"] = 137.82, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 194.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 420, ["Mega|Fly"] = 2157.05, ["Mega|Ride"] = 427.88, ["Mega|Fly|Ride"] = 622.13}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.63, ["Fly"] = 55.49, ["Ride"] = 48.09, ["Fly|Ride"] = 99.05, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 191.5, ["Mega|Ride"] = 739.57, ["Mega|Fly|Ride"] = 820.72}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.39, ["Fly|Ride"] = 31.34, ["Neon"] = 2.37, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.36, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 196.88, ["Ride"] = 274.3, ["Fly|Ride"] = 316.82, ["Neon"] = 3247.27, ["Neon|Ride"] = 890.33, ["Neon|Fly|Ride"] = 997.38, ["Mega|Fly|Ride"] = 4369.56}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 10.4, ["Fly"] = 61.64, ["Ride"] = 58, ["Fly|Ride"] = 105, ["Neon"] = 96.55, ["Neon|Ride"] = 199.48, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 408.82, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 16.21, ["Fly|Ride"] = 39.38, ["Neon"] = 8.24, ["Neon|Ride"] = 25.66, ["Neon|Fly|Ride"] = 108.89, ["Mega"] = 59.15, ["Mega|Fly"] = 274.26, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 147.93}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.08, ["Fly"] = 34.94, ["Ride"] = 18.19, ["Fly|Ride"] = 55.49, ["Neon"] = 3.43, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 23.21, ["Neon|Fly|Ride"] = 102.54, ["Mega"] = 30.17, ["Mega|Fly"] = 137.65, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 155.42}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.48, ["Ride"] = 28.88, ["Fly|Ride"] = 69.28, ["Neon"] = 12.21, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 155.42, ["Mega"] = 125.7, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 369.79}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.93, ["Fly"] = 38.73, ["Ride"] = 26.17, ["Fly|Ride"] = 68.25, ["Neon"] = 44.63, ["Neon|Fly"] = 260.92, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 350.53, ["Mega|Ride"] = 273.53, ["Mega|Fly|Ride"] = 356.65}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.24, ["Fly"] = 55.49, ["Ride"] = 39.37, ["Fly|Ride"] = 72.19, ["Neon"] = 48.29, ["Neon|Ride"] = 135.6, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 341.03, ["Mega|Ride"] = 359.54, ["Mega|Fly|Ride"] = 369.79}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly|Ride"] = 273.25, ["Neon"] = 3.5, ["Neon|Ride"] = 30.43, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.31}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.19, ["Ride"] = 24.94, ["Fly|Ride"] = 65.63, ["Neon"] = 40.06, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.94, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 20.55, ["Fly|Ride"] = 61.64, ["Neon"] = 6.19, ["Neon|Ride"] = 22.49, ["Neon|Fly|Ride"] = 87.32, ["Mega"] = 45.52, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 685.21, ["Fly|Ride"] = 779.63, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12736.79}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.99, ["Fly|Ride"] = 34.13, ["Neon"] = 49.32, ["Neon|Fly"] = 32.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.4, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.55, ["Ride"] = 31.34, ["Fly|Ride"] = 162.39, ["Neon"] = 13.12, ["Neon|Fly"] = 821.73, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 60.37, ["Mega|Fly"] = 315, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 6.97, ["Fly"] = 31.33, ["Ride"] = 22.23, ["Fly|Ride"] = 53.81, ["Neon"] = 47.25, ["Neon|Fly"] = 123.27, ["Neon|Ride"] = 54.52, ["Neon|Fly|Ride"] = 105.83, ["Mega"] = 326.65, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 14.43, ["Fly|Ride"] = 33.62, ["Neon"] = 15.75, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.77, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 68.83, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 260.92}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 44.62, ["Ride"] = 72.19, ["Fly|Ride"] = 205.48, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1370.24}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.42, ["Neon"] = 8.23, ["Neon|Fly"] = 132.23, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 78.07, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 275.29}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 73.5, ["Ride"] = 22.31, ["Fly|Ride"] = 57.53, ["Neon"] = 40.43, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 118.13, ["Mega|Ride"] = 219.82, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Neon"] = 9.16, ["Neon|Fly"] = 62.65, ["Mega"] = 93.5, ["Mega|Fly"] = 410.87, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 17.75, ["Fly|Ride"] = 88.35, ["Neon"] = 5.2, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 90.2, ["Mega"] = 44.63, ["Mega|Fly"] = 211.61, ["Mega|Ride"] = 68.09, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 17.41, ["Fly"] = 17.41, ["Ride"] = 23.63, ["Fly|Ride"] = 40.55, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 94.23, ["Mega"] = 821.73, ["Mega|Ride"] = 508.47, ["Mega|Fly|Ride"] = 456.36}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 800.63, ["Ride"] = 808.31, ["Fly|Ride"] = 934.5, ["Neon"] = 1938.14, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 7804.37, ["Mega|Fly|Ride"] = 7350}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 15.75, ["Fly|Ride"] = 47.24, ["Neon"] = 4.13, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 18.56, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 53.43, ["Mega|Ride"] = 56.42, ["Mega|Fly|Ride"] = 142.83}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.16, ["Ride"] = 27.75, ["Fly|Ride"] = 52.5, ["Neon"] = 27.57, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 46.4, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.05, ["Mega|Ride"] = 351.21}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 54.57, ["Ride"] = 65.61, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 271.56, ["Neon|Fly|Ride"] = 431.43, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.86, ["Fly"] = 124.1, ["Ride"] = 66.13, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 176.29, ["Mega"] = 1918.75, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 729.39}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11, ["Ride"] = 25.99, ["Fly|Ride"] = 123.59, ["Neon"] = 81.17, ["Neon|Ride"] = 133.63, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 384.18, ["Mega|Ride"] = 371.14, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 22.29, ["Ride"] = 92.8, ["Neon"] = 107.59, ["Neon|Ride"] = 123.27, ["Mega"] = 269.57, ["Mega|Fly"] = 503.34, ["Mega|Ride"] = 354.89, ["Mega|Fly|Ride"] = 453}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.59, ["Ride"] = 88.55, ["Neon"] = 177.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 651.24, ["Mega|Fly|Ride"] = 765.44}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.27}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.05, ["Fly"] = 24.67, ["Ride"] = 27.76, ["Fly|Ride"] = 78.75, ["Neon"] = 34.05, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.05, ["Neon"] = 14.59, ["Mega"] = 231.96}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 65.63, ["Fly"] = 410.84, ["Ride"] = 62.99, ["Fly|Ride"] = 119.46, ["Neon"] = 262.5, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 328.71, ["Mega|Ride"] = 899.07, ["Mega|Fly|Ride"] = 1493.5}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.46, ["Fly"] = 24.67, ["Ride"] = 17.41, ["Fly|Ride"] = 39.37, ["Neon"] = 23, ["Neon|Fly"] = 82.69, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 66.12, ["Mega"] = 262.5, ["Mega|Fly"] = 409.85, ["Mega|Ride"] = 177.91, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.14, ["Ride"] = 26.25, ["Fly|Ride"] = 76.55, ["Neon"] = 17.31, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 116.93, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 277.35}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.66, ["Neon|Ride"] = 45.94, ["Mega"] = 46.4, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 46.4, ["Fly"] = 65.63, ["Ride"] = 61.69, ["Fly|Ride"] = 120.74, ["Neon"] = 153.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 1095.99, ["Mega|Ride"] = 861.8, ["Mega|Fly|Ride"] = 816.66}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 26.35, ["Neon"] = 5.24, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66, ["Mega"] = 96.57, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.5, ["Ride"] = 73.5, ["Fly|Ride"] = 271.21, ["Neon"] = 96.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 382.05, ["Mega"] = 284.82, ["Mega|Ride"] = 591.66, ["Mega|Fly|Ride"] = 630.69}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 15.59, ["Fly|Ride"] = 59.53, ["Neon"] = 17.41, ["Neon|Ride"] = 30.17, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 157.5, ["Mega|Ride"] = 261.85, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.59, ["Fly"] = 52.49, ["Ride"] = 20.68, ["Fly|Ride"] = 55.97, ["Neon"] = 157.5, ["Neon|Ride"] = 27.75, ["Mega"] = 155.42, ["Mega|Ride"] = 382.12, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 62.66, ["Fly|Ride"] = 131.25, ["Neon"] = 44.01, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 34.58, ["Ride"] = 123.3, ["Neon"] = 156.07, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1630.12, ["Mega|Fly|Ride"] = 1159.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.58, ["Ride"] = 85.71, ["Neon"] = 131.25, ["Neon|Ride"] = 178.75, ["Neon|Fly|Ride"] = 143.82, ["Mega"] = 411.69, ["Mega|Ride"] = 328.71, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.25, ["Ride"] = 34.94, ["Neon"] = 48.45, ["Neon|Ride"] = 105, ["Mega"] = 685.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1643.46}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.13, ["Ride"] = 45.94, ["Fly|Ride"] = 520.79, ["Neon"] = 103.9, ["Neon|Ride"] = 273.25, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 719.02, ["Mega|Ride"] = 619.29, ["Mega|Fly|Ride"] = 1083.21}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.94, ["Neon"] = 104.99, ["Neon|Ride"] = 274.26, ["Mega"] = 155.42, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.64, ["Fly|Ride"] = 38.06, ["Neon"] = 6.56, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.02, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 68.24, ["Mega|Ride"] = 89.38, ["Mega|Fly|Ride"] = 166.51}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.03, ["Ride"] = 55.47, ["Fly|Ride"] = 46.41, ["Neon"] = 14.44, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 191.63, ["Mega|Ride"] = 303.03, ["Mega|Fly|Ride"] = 341.03}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.37, ["Fly|Ride"] = 55.95, ["Neon"] = 6.57, ["Neon|Fly"] = 31.34, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 46.69, ["Mega|Ride"] = 73.49, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.48, ["Fly"] = 39.38, ["Ride"] = 27.76, ["Fly|Ride"] = 118.13, ["Neon"] = 18.37, ["Neon|Ride"] = 96.57, ["Neon|Fly|Ride"] = 254.76, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 463.91}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.51, ["Ride"] = 31.5, ["Fly|Ride"] = 103.69, ["Neon"] = 29.29, ["Neon|Fly"] = 315, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 1027.17}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.81, ["Fly"] = 131.25, ["Ride"] = 25.99, ["Fly|Ride"] = 60.61, ["Neon"] = 33.77, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 198.33, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 229.63}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.13, ["Fly"] = 34.77, ["Ride"] = 19.53, ["Fly|Ride"] = 51.68, ["Neon"] = 19.53, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 100.91, ["Mega"] = 168, ["Mega|Ride"] = 227.01, ["Mega|Fly|Ride"] = 479.7}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.25, ["Fly"] = 57.75, ["Ride"] = 43.32, ["Neon"] = 19.48, ["Neon|Fly"] = 78.66, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 185.58, ["Mega"] = 110.25, ["Mega|Ride"] = 143.36, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 14.44, ["Fly"] = 137.68, ["Ride"] = 104.99, ["Fly|Ride"] = 192.1, ["Neon"] = 89.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 410.87, ["Mega"] = 366.19, ["Mega|Fly"] = 667.67, ["Mega|Ride"] = 500.55, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.52, ["Ride"] = 97.13, ["Fly|Ride"] = 128.75, ["Neon"] = 249.38, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 359.51, ["Mega"] = 1050, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1207.5}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 19.56, ["Fly|Ride"] = 39.04, ["Neon"] = 3.42, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 104.39, ["Mega"] = 27.57, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 130.89}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 33.07, ["Neon|Ride"] = 192.1, ["Mega"] = 913.27, ["Mega|Ride"] = 820.72, ["Mega|Fly|Ride"] = 1232.6}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 51.07, ["Fly"] = 105, ["Ride"] = 69.57, ["Neon"] = 289.95, ["Neon|Ride"] = 246.53, ["Mega"] = 1674.28, ["Mega|Ride"] = 1210.01, ["Mega|Fly|Ride"] = 997.5}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 8.24, ["Fly"] = 190.32, ["Ride"] = 31.02, ["Fly|Ride"] = 126, ["Neon"] = 36.75, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 295.75, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.62, ["Ride"] = 110.44, ["Fly|Ride"] = 137.45, ["Neon"] = 5.25, ["Neon|Ride"] = 47.25, ["Mega"] = 55.12, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 77.26, ["Mega|Fly|Ride"] = 124.59}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.6, ["Fly"] = 34.94, ["Ride"] = 19.53, ["Fly|Ride"] = 46.4, ["Neon"] = 13.27, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 34.06, ["Neon|Fly|Ride"] = 100.68, ["Mega"] = 187.99, ["Mega|Fly"] = 343.08, ["Mega|Ride"] = 309.66, ["Mega|Fly|Ride"] = 231.96}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.07, ["Fly|Ride"] = 43.15, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 24.94, ["Mega|Ride"] = 69.56}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 74.27, ["Neon"] = 6.18, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 62.26, ["Mega|Fly"] = 168, ["Mega|Ride"] = 53.62, ["Mega|Fly|Ride"] = 137.65}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 155.42, ["Neon"] = 2.63, ["Neon|Ride"] = 47.25, ["Mega"] = 21, ["Mega|Fly|Ride"] = 273.25}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.24, ["Ride"] = 44.19, ["Neon"] = 37, ["Neon|Ride"] = 83.52, ["Neon|Fly|Ride"] = 616.3, ["Mega"] = 137.65, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 245.24}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 7.22, ["Ride"] = 31.86, ["Fly|Ride"] = 189.96, ["Neon"] = 61.64, ["Neon|Ride"] = 92.46, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 410.87, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.32, ["Fly"] = 24.75, ["Ride"] = 19.68, ["Fly|Ride"] = 45.94, ["Neon"] = 36.74, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 72.18, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 343.08}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 66.93, ["Ride"] = 191.09, ["Fly|Ride"] = 262.5, ["Neon"] = 216.89, ["Neon|Ride"] = 597.19, ["Mega"] = 3093.02, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.65, ["Fly"] = 71.73, ["Ride"] = 32.82, ["Fly|Ride"] = 123.27, ["Neon"] = 62.65, ["Neon|Fly|Ride"] = 630, ["Mega"] = 619.32, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 16.27, ["Fly|Ride"] = 39.04, ["Neon"] = 3.82, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 39.04, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.4, ["Ride"] = 14.82, ["Fly|Ride"] = 23.63, ["Neon"] = 3.94, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 53.43, ["Mega"] = 42, ["Mega|Fly"] = 82.19, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 446.24, ["Ride"] = 464.63, ["Fly|Ride"] = 492.76, ["Neon|Fly|Ride"] = 1456.14}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 15.42, ["Ride"] = 61.65, ["Neon"] = 48.56, ["Neon|Ride"] = 109.87, ["Mega"] = 309.66, ["Mega|Ride"] = 387.36, ["Mega|Fly|Ride"] = 1232.6}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.71, ["Fly|Ride"] = 39.38, ["Neon"] = 5.08, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 46.39, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 78.24, ["Fly|Ride"] = 328.13, ["Neon"] = 236.24, ["Neon|Ride"] = 309.66, ["Neon|Fly|Ride"] = 537.22, ["Mega"] = 735, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.57, ["Ride"] = 18.19, ["Fly|Ride"] = 41.11, ["Neon"] = 13.13, ["Neon|Fly"] = 41.48, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 83.91, ["Mega|Fly"] = 137.65, ["Mega|Ride"] = 115.17, ["Mega|Fly|Ride"] = 194.49}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 34.13, ["Fly|Ride"] = 43.15, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 105, ["Mega"] = 17.45, ["Mega|Fly"] = 266.04, ["Mega|Ride"] = 65.22, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.37, ["Fly"] = 177.35, ["Ride"] = 86.6, ["Fly|Ride"] = 124.69, ["Neon"] = 131.25, ["Neon|Ride"] = 183.75, ["Mega"] = 721.88, ["Mega|Ride"] = 629.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 5.25, ["Neon|Ride"] = 26.24, ["Mega"] = 40.59, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 40.69, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 342.15, ["Neon|Ride"] = 298.92, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1622.93, ["Mega|Ride"] = 1643.46, ["Mega|Fly|Ride"] = 1150.43}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.94, ["Ride"] = 53.01, ["Fly|Ride"] = 156.14, ["Neon"] = 21.27, ["Neon|Ride"] = 274.26, ["Mega"] = 144.38, ["Mega|Ride"] = 155.42, ["Mega|Fly|Ride"] = 517.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.93, ["Fly"] = 68.85, ["Ride"] = 19.68, ["Fly|Ride"] = 65.76, ["Neon"] = 10.28, ["Neon|Fly"] = 77.04, ["Neon|Ride"] = 51.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 109.92, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.1, ["Ride"] = 55.46, ["Fly|Ride"] = 393.74, ["Neon"] = 176.29, ["Neon|Ride"] = 204.42, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2052.27, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1086.74}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.61, ["Fly"] = 216.81, ["Ride"] = 33.65, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 151.94, ["Mega"] = 38.06, ["Mega|Fly"] = 242.19, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 227.01}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.89, ["Ride"] = 14.44, ["Fly|Ride"] = 102.88, ["Neon"] = 4.13, ["Neon|Fly"] = 41.01, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 92.46, ["Mega"] = 205.44, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 9.35, ["Fly"] = 45.21, ["Ride"] = 30.83, ["Fly|Ride"] = 81.17, ["Neon"] = 69.2, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 393.75, ["Mega|Ride"] = 410.81, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 18.4, ["Ride"] = 28.33, ["Neon"] = 131.25, ["Neon|Fly|Ride"] = 1232.6, ["Mega"] = 926.66, ["Mega|Ride"] = 1848.9, ["Mega|Fly|Ride"] = 904.95}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 26.69, ["Fly"] = 51.18, ["Ride"] = 19.68, ["Fly|Ride"] = 73.96, ["Neon"] = 84, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 537.12, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 392.39}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 49.62, ["Fly"] = 289.99, ["Ride"] = 131.25, ["Fly|Ride"] = 298.95, ["Neon"] = 299.24, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 393.74, ["Mega|Ride"] = 1219.25, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.2, ["Ride"] = 44.01, ["Neon"] = 31.5, ["Neon|Ride"] = 77.72, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.39, ["Mega|Ride"] = 298.92, ["Mega|Fly|Ride"] = 334.87}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.57, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 72.94, ["Mega"] = 154.11, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 13.13, ["Fly"] = 52.49, ["Ride"] = 36.75, ["Fly|Ride"] = 92.8, ["Neon"] = 59.07, ["Neon|Ride"] = 170.52, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.51, ["Fly|Ride"] = 31.86, ["Neon"] = 2.57, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 51.38, ["Mega"] = 15.08, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 93.17}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 62.54, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Neon"] = 183.75, ["Neon|Fly"] = 2328.59, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 343.08, ["Mega"] = 1391.69, ["Mega|Ride"] = 1368.2, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.75, ["Fly|Ride"] = 106.84, ["Neon"] = 3.73, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 26.17, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 11.81, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 89.38, ["Mega"] = 257.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 75.93, ["Fly"] = 157.5, ["Ride"] = 116.18, ["Fly|Ride"] = 260.92, ["Neon"] = 260.92, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 548.51, ["Mega"] = 1179.94, ["Mega|Ride"] = 1274.56, ["Mega|Fly|Ride"] = 1227.19}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.61, ["Neon"] = 7.77, ["Neon|Ride"] = 65.63, ["Mega"] = 63.67, ["Mega|Fly"] = 155.42, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 232.97}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.18}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 31.34, ["Fly|Ride"] = 291.73, ["Neon"] = 6.57, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 45.21, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 228.52}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 98.44, ["Ride"] = 164.38, ["Fly|Ride"] = 271.19, ["Neon"] = 538.13, ["Neon|Ride"] = 680.77, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3556.92, ["Mega|Ride"] = 2191.97, ["Mega|Fly|Ride"] = 2463.14}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.92, ["Ride"] = 36.82, ["Neon"] = 19.43, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 193.12, ["Mega"] = 115.5, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.43, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 6.12, ["Ride"] = 24.67, ["Neon"] = 51.19, ["Neon|Ride"] = 109.9, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.76, ["Fly"] = 24.2, ["Ride"] = 26.7, ["Fly|Ride"] = 54.32, ["Neon"] = 77.83, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 406.76, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 460.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.77, ["Ride"] = 52.4, ["Neon"] = 142.67, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 619.32, ["Mega"] = 656.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 739.57}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 130.79, ["Fly"] = 247.57, ["Ride"] = 170.62, ["Fly|Ride"] = 214.47, ["Neon"] = 478.96, ["Neon|Ride"] = 498.74, ["Neon|Fly|Ride"] = 640.4, ["Mega|Fly|Ride"] = 2198.44}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 26.16, ["Fly"] = 34.13, ["Ride"] = 29.76, ["Fly|Ride"] = 65.51, ["Neon"] = 131.25, ["Neon|Fly"] = 6162.97, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 200.54, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 6.33, ["Fly"] = 131.23, ["Ride"] = 30.83, ["Fly|Ride"] = 90.4, ["Neon"] = 20.88, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 117.11, ["Mega"] = 99.74, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.17, ["Fly"] = 131.25, ["Ride"] = 39.38, ["Neon"] = 58.56, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.47, ["Ride"] = 88.36, ["Fly|Ride"] = 137.68, ["Neon"] = 220.48, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 262.4, ["Mega"] = 1079.73, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 914.82}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 17.6, ["Ride"] = 88.36, ["Neon"] = 155.42, ["Neon|Ride"] = 155.42, ["Neon|Fly|Ride"] = 453, ["Mega"] = 660.19, ["Mega|Ride"] = 651.24, ["Mega|Fly|Ride"] = 773.56}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 236.25, ["Ride"] = 405.79, ["Neon|Ride"] = 1706.25, ["Mega"] = 4581.14, ["Mega|Fly|Ride"] = 4519.51}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 31.34, ["Ride"] = 34.76, ["Fly|Ride"] = 104.78, ["Neon"] = 260.92, ["Neon|Ride"] = 294.59, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1231.02}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.43, ["Fly|Ride"] = 78.74, ["Neon"] = 2.61, ["Neon|Ride"] = 17.64, ["Neon|Fly|Ride"] = 64.26, ["Mega"] = 20.88, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 40.65, ["Mega|Fly|Ride"] = 109.5}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.54, ["Ride"] = 19.53, ["Neon"] = 16.46, ["Neon|Ride"] = 40.66, ["Neon|Fly|Ride"] = 257.83, ["Mega"] = 196.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 405.75}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.29, ["Ride"] = 41.11, ["Fly|Ride"] = 144.16, ["Neon"] = 18.36, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 115.97, ["Mega|Fly"] = 534.14, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 231.96}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 334.69, ["Fly"] = 619.39, ["Ride"] = 406.88, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1676.35, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 5752.28, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 54.74, ["Ride"] = 15.42, ["Fly|Ride"] = 48.29, ["Neon"] = 24.94, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 80.14, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.22, ["Fly"] = 22.32, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 31.34, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.88, ["Fly"] = 41.11, ["Ride"] = 27.55, ["Fly|Ride"] = 89.39, ["Neon"] = 15.74, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 129.44, ["Mega"] = 137.65, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 137.65, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 139.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.68, ["Fly|Ride"] = 69.86, ["Neon"] = 15.42, ["Neon|Ride"] = 114.19, ["Mega"] = 158.86, ["Mega|Ride"] = 410.87, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.47, ["Fly"] = 787.5, ["Ride"] = 25.7, ["Fly|Ride"] = 85.31, ["Neon"] = 123.38, ["Neon|Ride"] = 155.42, ["Mega|Fly|Ride"] = 718.01}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.71, ["Neon|Ride"] = 28.76, ["Mega"] = 39.38, ["Mega|Ride"] = 129.44, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 10.18, ["Ride"] = 134.58, ["Neon"] = 82.19, ["Neon|Ride"] = 204.39, ["Mega"] = 155.93, ["Mega|Ride"] = 287.62}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.4, ["Ride"] = 78.07, ["Neon"] = 104.9, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 410.87, ["Mega"] = 328.13, ["Mega|Ride"] = 342.15, ["Mega|Fly|Ride"] = 483.8}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 11.68, ["Fly"] = 19.69, ["Ride"] = 26.23, ["Fly|Ride"] = 53.82, ["Neon"] = 41.11, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 577.28, ["Mega|Ride"] = 411.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 240.37, ["Fly"] = 369.79, ["Ride"] = 210, ["Fly|Ride"] = 367.5, ["Neon"] = 1391.69, ["Neon|Ride"] = 1054.91, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4724.94}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.61, ["Fly|Ride"] = 56.79, ["Neon"] = 9.66, ["Neon|Fly"] = 77.72, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 219.82, ["Mega|Ride"] = 155.42, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.67, ["Fly"] = 27.86, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 11.31, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 46.18, ["Ride"] = 104.39, ["Neon"] = 104.99, ["Neon|Ride"] = 184.9, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 393.74, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 517.79}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 122, ["Fly"] = 393.75, ["Ride"] = 164.06, ["Fly|Ride"] = 294.59, ["Neon"] = 584.07, ["Neon|Ride"] = 548.51, ["Neon|Fly|Ride"] = 619.32, ["Mega"] = 2319.49, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 25.99, ["Fly"] = 109.94, ["Ride"] = 96.58, ["Fly|Ride"] = 114.03, ["Neon"] = 86.05, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 152.03, ["Mega"] = 393.75, ["Mega|Ride"] = 440.71, ["Mega|Fly|Ride"] = 529.01}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 14.97, ["Fly|Ride"] = 58.47, ["Neon"] = 5.24, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.03, ["Mega|Ride"] = 193.69, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 23.68, ["Ride"] = 48.57, ["Neon"] = 68.25, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 155.42, ["Mega"] = 216.89, ["Mega|Ride"] = 442.97, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 64.97, ["Fly"] = 96.57, ["Ride"] = 111.57, ["Fly|Ride"] = 216.57, ["Neon"] = 147, ["Neon|Ride"] = 240.37, ["Neon|Fly|Ride"] = 274.2, ["Mega"] = 393.75, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 77.73, ["Fly|Ride"] = 55.49, ["Neon"] = 9.19, ["Neon|Ride"] = 204.42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 57.74, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 129.44, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 12.34, ["Ride"] = 361.62, ["Neon"] = 114.19, ["Neon|Ride"] = 401.03, ["Mega"] = 410.87, ["Mega|Fly|Ride"] = 753.95}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 943.68, ["Fly"] = 1194.38, ["Ride"] = 1001.31, ["Fly|Ride"] = 1094.62, ["Neon|Ride"] = 3404.02, ["Neon|Fly|Ride"] = 2611.88, ["Mega|Fly|Ride"] = 12872.39}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 76.13, ["Fly"] = 115.99, ["Ride"] = 108.91, ["Fly|Ride"] = 187.69, ["Neon"] = 163.33, ["Neon|Fly"] = 278.25, ["Neon|Ride"] = 567, ["Neon|Fly|Ride"] = 309.66, ["Mega"] = 959.38, ["Mega|Ride"] = 542.36, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 4.66, ["Fly"] = 49.25, ["Ride"] = 26.35, ["Fly|Ride"] = 80.89, ["Neon"] = 13.11, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 152.03, ["Mega"] = 93.19, ["Mega|Ride"] = 102.74, ["Mega|Fly|Ride"] = 155.9}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 26.7, ["Ride"] = 131.22, ["Fly|Ride"] = 137.65, ["Neon"] = 102.74, ["Neon|Fly|Ride"] = 137.65, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 466.34}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Fly|Ride"] = 52.5, ["Neon"] = 2.62, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 16.95, ["Mega|Fly"] = 123.27, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 126.95}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 64.96, ["Ride"] = 118.15, ["Fly|Ride"] = 255.94, ["Neon"] = 275.63, ["Neon|Ride"] = 341.62, ["Neon|Fly|Ride"] = 479.7, ["Mega"] = 1100.15, ["Mega|Ride"] = 1098.43, ["Mega|Fly|Ride"] = 1170.65}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.77, ["Fly"] = 174.57, ["Ride"] = 24.94, ["Fly|Ride"] = 68.85, ["Neon"] = 19.85, ["Neon|Ride"] = 78.75, ["Mega"] = 462.75, ["Mega|Ride"] = 367.75, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.57, ["Fly"] = 97.69, ["Ride"] = 20.56, ["Neon"] = 11.2, ["Neon|Ride"] = 55.49, ["Mega"] = 92.79, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 368.76}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 32.81, ["Ride"] = 74.81, ["Fly|Ride"] = 155.44, ["Neon"] = 78.75, ["Neon|Ride"] = 130.47, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 496.38, ["Mega|Ride"] = 510.57, ["Mega|Fly|Ride"] = 680.77}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 54.87, ["Ride"] = 89.25, ["Fly|Ride"] = 190.32, ["Neon"] = 210, ["Neon|Ride"] = 174.6, ["Mega"] = 328.13, ["Mega|Ride"] = 504.14, ["Mega|Fly|Ride"] = 821.73}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.38, ["Ride"] = 51.38, ["Neon"] = 309.66, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 431.43, ["Mega"] = 1505.64, ["Mega|Ride"] = 1643.46, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.15, ["Neon"] = 19.69, ["Neon|Ride"] = 122.95, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 109.04, ["Mega|Ride"] = 211.61, ["Mega|Fly|Ride"] = 262.89}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.5, ["Ride"] = 18.37, ["Fly|Ride"] = 62.66, ["Neon"] = 44.17, ["Neon|Ride"] = 91.64, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 364.17, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 124.69, ["Ride"] = 137.65, ["Fly|Ride"] = 251.78, ["Neon"] = 515.64, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 3141.07, ["Mega|Ride"] = 2333.63, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.26, ["Fly|Ride"] = 105000, ["Neon"] = 11.24, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 78.73, ["Mega"] = 124.59, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 197.8}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 6.57, ["Fly"] = 37.13, ["Ride"] = 31.34, ["Fly|Ride"] = 78.75, ["Neon"] = 49.89, ["Neon|Fly"] = 309.66, ["Neon|Ride"] = 55.69, ["Neon|Fly|Ride"] = 175.67, ["Mega"] = 343.08, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 308.16}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Ride"] = 13.81, ["Fly|Ride"] = 40.85, ["Neon"] = 2.1, ["Neon|Fly"] = 24.9, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 14.54, ["Mega|Fly"] = 26.25, ["Mega|Ride"] = 27.57, ["Mega|Fly|Ride"] = 119.17}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.43, ["Neon"] = 3.93, ["Neon|Ride"] = 39.04, ["Mega"] = 23.21, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 51.98, ["Mega|Fly|Ride"] = 158.21}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 128.82, ["Ride"] = 19.69, ["Fly|Ride"] = 45.94, ["Neon"] = 41.1, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 98.44, ["Mega|Fly|Ride"] = 232.98}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 46.39, ["Ride"] = 196.88, ["Neon"] = 307.14, ["Neon|Ride"] = 410.87, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.62}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.18, ["Fly"] = 20.53, ["Ride"] = 16.21, ["Fly|Ride"] = 45.21, ["Neon"] = 14.74, ["Neon|Fly"] = 31.34, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 68.83, ["Mega"] = 114.19, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 170.39}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.81, ["Fly"] = 32.91, ["Ride"] = 23.63, ["Fly|Ride"] = 63.53, ["Neon"] = 19.69, ["Neon|Fly"] = 60.61, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 70.73, ["Mega"] = 169.31, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 167.98, ["Mega|Fly|Ride"] = 215.24}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.15, ["Fly"] = 19.69, ["Ride"] = 15.43, ["Fly|Ride"] = 39.38, ["Neon"] = 9.07, ["Neon|Fly"] = 98.44, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.6, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 10.07, ["Fly"] = 27.76, ["Ride"] = 45.94, ["Fly|Ride"] = 52.5, ["Neon"] = 48.28, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 202.41, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.88, ["Mega|Fly|Ride"] = 630.69}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.79, ["Fly"] = 170.52, ["Ride"] = 68.85, ["Fly|Ride"] = 220.34, ["Neon"] = 91.77, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343.08, ["Mega"] = 387.36, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.88, ["Fly"] = 48.57, ["Ride"] = 18.19, ["Fly|Ride"] = 63.66, ["Neon"] = 27.75, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 105, ["Mega"] = 309.66, ["Mega|Ride"] = 227.04, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.63, ["Fly"] = 20.9, ["Ride"] = 15.43, ["Fly|Ride"] = 27.75, ["Neon"] = 10.26, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 78.75, ["Mega|Ride"] = 86.29, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 393.75, ["Ride"] = 262.5, ["Fly|Ride"] = 196.87, ["Neon"] = 937.13, ["Neon|Ride"] = 1232.6, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.08, ["Ride"] = 61.76, ["Neon"] = 28.88, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 118.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 20.68, ["Fly|Ride"] = 76.04, ["Neon"] = 22.32, ["Neon|Fly"] = 205.44, ["Neon|Ride"] = 82.19, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 196.88, ["Mega|Ride"] = 274.26, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 22.31, ["Ride"] = 23.22, ["Neon"] = 52.5, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.3, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.06, ["Ride"] = 14.44, ["Fly|Ride"] = 34.94, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.37, ["Mega"] = 17.74, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 27.75, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.18, ["Fly"] = 41.1, ["Ride"] = 15.75, ["Fly|Ride"] = 58.97, ["Neon"] = 8.86, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 94.7, ["Mega"] = 103.81, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 48.29, ["Fly|Ride"] = 97.6, ["Neon"] = 26.24, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.04, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 62.34, ["Fly"] = 105, ["Ride"] = 104.99, ["Fly|Ride"] = 145.29, ["Neon"] = 393.75, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2054.33, ["Mega|Ride"] = 3425.59, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.9, ["Fly"] = 85.32, ["Ride"] = 32.89, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 109.92, ["Mega"] = 211.53, ["Mega|Ride"] = 320.5, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.41, ["Fly"] = 20.99, ["Ride"] = 46.91, ["Fly|Ride"] = 118.13, ["Neon"] = 8.24, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 52.49, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 122.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.64, ["Fly"] = 210, ["Ride"] = 88.36, ["Fly|Ride"] = 220.37, ["Neon"] = 118.13, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 256.81, ["Mega"] = 472.5, ["Mega|Ride"] = 513.65, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 15.32, ["Fly|Ride"] = 35.96, ["Neon"] = 2.63, ["Neon|Fly"] = 22.04, ["Neon|Ride"] = 17.41, ["Neon|Fly|Ride"] = 33.65, ["Mega"] = 18.37, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 35.97, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.92, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 92.76, ["Mega"] = 23.21, ["Mega|Ride"] = 81.19, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 4.76, ["Ride"] = 26.17, ["Neon"] = 13.13, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 180.79, ["Mega"] = 52.5, ["Mega|Fly"] = 178.75, ["Mega|Ride"] = 116.05, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.24, ["Fly"] = 69.61, ["Ride"] = 55.5, ["Fly|Ride"] = 111.57, ["Neon"] = 26.25, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 73.12, ["Neon|Fly|Ride"] = 222.74, ["Mega"] = 97.12, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 180.89, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.9, ["Fly|Ride"] = 35.95, ["Neon"] = 2.58, ["Neon|Fly"] = 18.9, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 21.57, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 151.94}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 10.49, ["Fly"] = 72.19, ["Ride"] = 41.11, ["Neon"] = 78.75, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 496.38, ["Mega|Ride"] = 409.85, ["Mega|Fly|Ride"] = 684.11}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2572.5, ["Fly"] = 3150, ["Ride"] = 2756.25, ["Fly|Ride"] = 2716.88, ["Mega|Fly|Ride"] = 35882.82}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 52.4, ["Ride"] = 15.41, ["Fly|Ride"] = 68.25, ["Neon"] = 7.88, ["Neon|Fly"] = 55.49, ["Neon|Ride"] = 24.91, ["Neon|Fly|Ride"] = 67.81, ["Mega"] = 89.25, ["Mega|Fly"] = 149.98, ["Mega|Ride"] = 109.33, ["Mega|Fly|Ride"] = 160.83}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.63, ["Neon"] = 21.27, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 616.3}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 19.42, ["Fly"] = 41.1, ["Ride"] = 32.8, ["Fly|Ride"] = 69.57, ["Neon"] = 62.65, ["Neon|Ride"] = 89.38, ["Neon|Fly|Ride"] = 100.68, ["Mega"] = 393.65, ["Mega|Ride"] = 392.82, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 34.8, ["Ride"] = 58.57, ["Neon"] = 137.65, ["Neon|Ride"] = 216.89, ["Mega"] = 540.75, ["Mega|Ride"] = 805.3, ["Mega|Fly|Ride"] = 804.87}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 157.48, ["Fly"] = 1370.41, ["Ride"] = 183.75, ["Fly|Ride"] = 233.63, ["Neon"] = 760.12, ["Neon|Ride"] = 718.01, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6162.97, ["Mega|Ride"] = 3476.9, ["Mega|Fly|Ride"] = 3087.32}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.19, ["Fly"] = 27.76, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 13.13, ["Neon|Ride"] = 128.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 123.27, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 155.42, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 68.85, ["Fly|Ride"] = 92.8, ["Neon"] = 15.66, ["Neon|Fly"] = 96.57, ["Neon|Fly|Ride"] = 513.59, ["Mega"] = 114.76, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.05, ["Fly"] = 101.99, ["Ride"] = 44.09, ["Fly|Ride"] = 196.88, ["Neon"] = 10.14, ["Neon|Ride"] = 46.23, ["Mega"] = 69.6, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 307.14}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 18.51, ["Ride"] = 39.38, ["Neon"] = 129.94, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 602.97, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 89.67, ["Mega"] = 16.94, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 410.87}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.87, ["Fly"] = 137.68, ["Ride"] = 78.74, ["Fly|Ride"] = 137.65, ["Neon"] = 405.75, ["Neon|Fly"] = 309.66, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 410.87, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.49, ["Ride"] = 32.82, ["Neon"] = 9.89, ["Neon|Ride"] = 137.67, ["Mega"] = 61.69, ["Mega|Ride"] = 152.03, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.84, ["Fly"] = 216.91, ["Ride"] = 74.81, ["Fly|Ride"] = 131.23, ["Neon"] = 262.5, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 400.74, ["Mega"] = 2625, ["Mega|Ride"] = 1848.9, ["Mega|Fly|Ride"] = 1620.93}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.53, ["Fly|Ride"] = 50.28, ["Neon"] = 6.17, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 43.1, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 164.99}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.63, ["Neon"] = 18.38, ["Neon|Ride"] = 39.38, ["Mega"] = 82.69, ["Mega|Ride"] = 129.82, ["Mega|Fly|Ride"] = 356.05}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 4.92, ["Ride"] = 63.71, ["Fly|Ride"] = 204.44, ["Neon"] = 41.1, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 221.89, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 328.13, ["Fly"] = 548.59, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon"] = 1220.62, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1246.53, ["Mega"] = 6617.63, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 3799.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.42, ["Fly"] = 67.28, ["Ride"] = 52.74, ["Fly|Ride"] = 77.38, ["Neon"] = 205.44, ["Neon|Ride"] = 219.85, ["Neon|Fly|Ride"] = 275.63, ["Mega|Ride"] = 1212.06, ["Mega|Fly|Ride"] = 1025.12}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 19.53, ["Fly|Ride"] = 91.88, ["Neon"] = 7.79, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 68.83, ["Mega"] = 49.88, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.38, ["Fly"] = 359.57, ["Ride"] = 45.94, ["Fly|Ride"] = 162.31, ["Neon"] = 39.27, ["Neon|Fly"] = 105, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 238.88, ["Mega|Fly"] = 954.48, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 342.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.39, ["Ride"] = 23.12, ["Fly|Ride"] = 39.38, ["Neon"] = 138.68, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 137.65, ["Mega"] = 410.87, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 388.65}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 13.13, ["Mega"] = 39.38, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 115.99}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 18.37, ["Fly|Ride"] = 47.25, ["Neon"] = 13.13, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.56, ["Mega"] = 65.63, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 956.3}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 106.37, ["Ride"] = 127.32, ["Fly|Ride"] = 182.52, ["Neon|Ride"] = 708.64, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 3348.55}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 27.15, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 137.65, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 821.73, ["Mega|Ride"] = 667.67, ["Mega|Fly|Ride"] = 765.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.37, ["Ride"] = 2100, ["Fly|Ride"] = 2362.5, ["Neon"] = 10956.73, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.03, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 12.5, ["Neon|Ride"] = 135.56, ["Neon|Fly|Ride"] = 155.42, ["Mega"] = 118.13, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 574.2}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 12.86, ["Ride"] = 39.38, ["Fly|Ride"] = 139.23, ["Neon"] = 45.93, ["Neon|Ride"] = 104.89, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 217.87, ["Mega|Ride"] = 240.19, ["Mega|Fly|Ride"] = 508.47}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 846.57, ["Fly"] = 1187.73, ["Ride"] = 913.5, ["Fly|Ride"] = 975.19, ["Neon"] = 2598.75, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 11602.5}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 40.06, ["Ride"] = 56.44, ["Fly|Ride"] = 134.57, ["Neon"] = 157.5, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 369.79, ["Mega"] = 771.41, ["Mega|Ride"] = 773.56, ["Mega|Fly|Ride"] = 808.4}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.89, ["Fly|Ride"] = 128.09, ["Neon"] = 15.43, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 137.45, ["Neon"] = 6.98, ["Neon|Ride"] = 40.57, ["Neon|Fly|Ride"] = 77.72, ["Mega"] = 27.74, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.26}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 80.22, ["Ride"] = 127.32, ["Fly|Ride"] = 309.7, ["Neon"] = 409.85, ["Neon|Ride"] = 433.76, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2739.45, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.89, ["Fly|Ride"] = 72.19, ["Neon"] = 20.99, ["Neon|Ride"] = 61.64, ["Mega"] = 137.82, ["Mega|Ride"] = 205.44, ["Mega|Fly|Ride"] = 223.02}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 58.61, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2328.59, ["Mega|Fly|Ride"] = 2048.17}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.67, ["Fly"] = 105, ["Fly|Ride"] = 109.94, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 203.44, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Ride"] = 306, ["Fly|Ride"] = 325.7, ["Neon"] = 1091.91, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 4230.89}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 8.16, ["Fly"] = 87.93, ["Ride"] = 26.36, ["Fly|Ride"] = 52.4, ["Neon"] = 43.15, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.88, ["Ride"] = 14.48, ["Fly|Ride"] = 39.34, ["Neon"] = 5.16, ["Neon|Fly"] = 30.91, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 53.43, ["Mega"] = 54.17, ["Mega|Fly"] = 118.14, ["Mega|Ride"] = 58.56, ["Mega|Fly|Ride"] = 138.03}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 1000.59, ["Fly|Ride"] = 1027.17, ["Neon|Ride"] = 7533.21, ["Neon|Fly|Ride"] = 4724.94, ["Mega"] = 26022.08, ["Mega|Fly|Ride"] = 27391.29}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Fly"] = 959.51, ["Ride"] = 210, ["Neon"] = 66.27, ["Neon|Ride"] = 129.29, ["Mega"] = 236.24, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.31, ["Ride"] = 32.82, ["Fly|Ride"] = 127.32, ["Neon"] = 29.92, ["Neon|Fly"] = 77.72, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 178.5, ["Mega|Ride"] = 187.9, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 46.4, ["Fly"] = 40.55, ["Ride"] = 44.16, ["Fly|Ride"] = 63.27, ["Neon"] = 197.23, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2054.33, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.44, ["Fly"] = 77.04, ["Ride"] = 31.85, ["Fly|Ride"] = 87.94, ["Neon"] = 48.29, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 343.08, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 435.53}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 28.77, ["Ride"] = 209.99, ["Fly|Ride"] = 135.19, ["Neon"] = 96.57, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 483.8, ["Mega|Ride"] = 573.18, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 15.43, ["Fly|Ride"] = 231.99, ["Neon"] = 2.63, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 72.19, ["Mega"] = 17.07, ["Mega|Fly"] = 57.75, ["Mega|Ride"] = 64.13}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 51.06, ["Fly"] = 89.25, ["Ride"] = 68.84, ["Fly|Ride"] = 111.57, ["Neon"] = 578.82, ["Neon|Fly"] = 323.58, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 330.75, ["Mega"] = 3286.92, ["Mega|Ride"] = 1098.28, ["Mega|Fly|Ride"] = 956.71}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.63, ["Fly"] = 27.75, ["Ride"] = 17.6, ["Fly|Ride"] = 69.92, ["Neon"] = 32.81, ["Neon|Ride"] = 39.38, ["Mega"] = 773.07, ["Mega|Ride"] = 348.48, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.56, ["Fly|Ride"] = 38.04, ["Neon"] = 12.71, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.17, ["Ride"] = 171.57, ["Neon"] = 105, ["Neon|Fly"] = 52.5, ["Neon|Fly|Ride"] = 183.88, ["Mega"] = 246.53, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 24.93, ["Ride"] = 88.1, ["Fly|Ride"] = 183.75, ["Neon"] = 195.57, ["Neon|Ride"] = 243.6, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 722.11, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.7, ["Ride"] = 131.25, ["Neon"] = 22.82, ["Neon|Ride"] = 77.04, ["Neon|Fly|Ride"] = 77.72, ["Mega"] = 91.24, ["Mega|Fly"] = 303.03, ["Mega|Fly|Ride"] = 309.66}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.61, ["Neon|Ride"] = 20.6, ["Mega"] = 15.74, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.83, ["Ride"] = 25.1, ["Fly|Ride"] = 81.06, ["Neon"] = 2.56, ["Neon|Ride"] = 32.45, ["Mega"] = 16.7, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 106.53}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 20, ["Ride"] = 15.85, ["Fly|Ride"] = 49.26, ["Neon"] = 7.88, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 61.69, ["Mega|Ride"] = 90.47, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.74, ["Fly|Ride"] = 109.92, ["Neon"] = 16.46, ["Neon|Ride"] = 1312.5, ["Mega"] = 105, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.14, ["Fly|Ride"] = 35.44, ["Neon"] = 14.42, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 274.26, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 69.92, ["Ride"] = 150.94, ["Neon"] = 164.06, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1027.17, ["Mega"] = 694.32, ["Mega|Ride"] = 883.31, ["Mega|Fly|Ride"] = 926.64}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 16.46, ["Fly|Ride"] = 38.66, ["Neon"] = 2.1, ["Neon|Fly"] = 24.65, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 49.87, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 101.62}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.45, ["Fly"] = 60.4, ["Ride"] = 39.04, ["Fly|Ride"] = 74.81, ["Neon"] = 685.21, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 67.81, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 262.5, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.95, ["Fly"] = 55.5, ["Ride"] = 28.47, ["Fly|Ride"] = 72.19, ["Neon"] = 109.25, ["Neon|Ride"] = 102.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1160.71, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 548.51}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.08, ["Fly"] = 196.88, ["Neon"] = 60.61, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 405.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.39, ["Fly|Ride"] = 39.04, ["Neon"] = 5.2, ["Neon|Fly"] = 40.09, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 45.83, ["Mega"] = 51.05, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 62.07, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.62, ["Fly"] = 68.83, ["Ride"] = 27.76, ["Neon"] = 15.41, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.24, ["Fly"] = 1230.71, ["Ride"] = 1016.1, ["Fly|Ride"] = 1050, ["Neon"] = 2864.55, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 72.73, ["Ride"] = 124.69, ["Fly|Ride"] = 408.82, ["Neon"] = 309.66, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 589.61, ["Mega"] = 2783.37, ["Mega|Ride"] = 1918.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.44, ["Mega"] = 72.1, ["Mega|Ride"] = 102.74, ["Mega|Fly|Ride"] = 205.44}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 53.5, ["Fly"] = 142.79, ["Ride"] = 78.53, ["Fly|Ride"] = 146.16, ["Neon"] = 252, ["Neon|Ride"] = 324.35, ["Neon|Fly|Ride"] = 380.61, ["Mega"] = 1023.75, ["Mega|Ride"] = 1129.89, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.94, ["Ride"] = 20.13, ["Fly|Ride"] = 65.63, ["Neon"] = 62.67, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.25, ["Mega"] = 183.75, ["Mega|Ride"] = 345.14, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 242.82, ["Fly"] = 301.88, ["Ride"] = 262.5, ["Fly|Ride"] = 315.35, ["Neon|Ride"] = 1232.6, ["Neon|Fly|Ride"] = 1329.17, ["Mega|Fly|Ride"] = 4314.08}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.66, ["Neon|Ride"] = 54.37, ["Mega"] = 406.81, ["Mega|Fly"] = 320.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 32.82, ["Neon|Ride"] = 82.19, ["Mega"] = 328.71, ["Mega|Ride"] = 326.65}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 59.16, ["Ride"] = 96.58, ["Fly|Ride"] = 525, ["Neon"] = 548.51, ["Neon|Ride"] = 387.36, ["Mega"] = 542, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 780.66}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.54, ["Neon"] = 20.48, ["Mega"] = 183.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 453.5}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 12.34, ["Fly|Ride"] = 32.48, ["Neon"] = 3.66, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 137.61, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 48.29, ["Mega|Fly|Ride"] = 102.06}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4134.38, ["Ride"] = 4446.75, ["Fly|Ride"] = 4200, ["Neon"] = 30814.81, ["Neon|Fly|Ride"] = 19162.5, ["Mega|Fly|Ride"] = 84912.24}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.19, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 57.75, ["Neon|Ride"] = 106.32, ["Mega"] = 271.19, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 320.5}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 19.68, ["Fly|Ride"] = 55.5, ["Neon"] = 16.94, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 76.37, ["Mega"] = 137.82, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 183.07}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 420, ["Fly"] = 645.16, ["Ride"] = 472.5, ["Fly|Ride"] = 564.38, ["Neon"] = 1372.81, ["Neon|Ride"] = 1546.92, ["Neon|Fly|Ride"] = 1284.94, ["Mega|Fly|Ride"] = 5078.07}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 11.7, ["Ride"] = 24.99, ["Neon"] = 17.06, ["Neon|Ride"] = 145.69, ["Mega"] = 129.94, ["Mega|Ride"] = 619.32, ["Mega|Fly|Ride"] = 685.13}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.96, ["Fly"] = 137.65, ["Ride"] = 46.35, ["Neon"] = 102.74, ["Neon|Ride"] = 274.26, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 408.82, ["Mega|Ride"] = 356.05, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.5, ["Fly"] = 52.45, ["Ride"] = 26.17, ["Fly|Ride"] = 82.19, ["Neon"] = 3.89, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.61, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 29.8, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 255.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 735, ["Fly"] = 808.49, ["Ride"] = 650.77, ["Fly|Ride"] = 721.88, ["Neon"] = 2362.5, ["Neon|Ride"] = 1977.09, ["Neon|Fly|Ride"] = 1929.57}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 78.74, ["Neon"] = 30.19, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 144.58, ["Mega|Ride"] = 164.36, ["Mega|Fly|Ride"] = 271.19}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.28, ["Fly"] = 236.15, ["Ride"] = 63.14, ["Neon"] = 39.09, ["Neon|Fly"] = 164.36, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 188.99, ["Mega|Ride"] = 242.5, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 17.68, ["Fly|Ride"] = 42, ["Neon"] = 13.55, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 65.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 16.96, ["Ride"] = 46.39, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.65, ["Mega"] = 463.91, ["Mega|Fly|Ride"] = 616.3}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 205.44, ["Neon"] = 5.19, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 183.88, ["Mega"] = 36.75, ["Mega|Fly"] = 109.92, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 481.3}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 406.88, ["Ride"] = 534.17, ["Fly|Ride"] = 696.44, ["Neon"] = 2589.57, ["Neon|Ride"] = 2706.83, ["Neon|Fly|Ride"] = 2711.37, ["Mega|Ride"] = 9045.92, ["Mega|Fly|Ride"] = 7190.13}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 49.88, ["Fly|Ride"] = 178.61, ["Neon"] = 11.78, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 72.19, ["Mega|Ride"] = 152.39, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.25, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 53.43, ["Mega|Fly"] = 100.68, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 258.86}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 3.45, ["Neon|Ride"] = 41.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.62, ["Mega|Fly"] = 152.03, ["Mega|Ride"] = 78.73, ["Mega|Fly|Ride"] = 192.1}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.93, ["Ride"] = 131.25, ["Neon"] = 18.5, ["Neon|Ride"] = 39.44, ["Mega"] = 224.97}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 44.18, ["Fly"] = 196.88, ["Ride"] = 129.94, ["Fly|Ride"] = 201.84, ["Neon"] = 179.73, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 215.25, ["Mega"] = 617.32, ["Mega|Ride"] = 629.91, ["Mega|Fly|Ride"] = 669.73}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.75, ["Ride"] = 58.36, ["Fly|Ride"] = 116.6, ["Neon"] = 102.27, ["Neon|Ride"] = 128.31, ["Mega"] = 463.91, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 560.78}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.04, ["Fly"] = 27.75, ["Ride"] = 16.27, ["Fly|Ride"] = 38.07, ["Neon"] = 27.85, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 299.92, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 195.87}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 15.3, ["Ride"] = 64.32, ["Fly|Ride"] = 102.75, ["Neon"] = 89.25, ["Neon|Ride"] = 137.65, ["Mega"] = 210, ["Mega|Ride"] = 215.72, ["Mega|Fly|Ride"] = 959.38}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 24.93, ["Fly|Ride"] = 60.61, ["Neon"] = 15.21, ["Neon|Ride"] = 33.65, ["Neon|Fly|Ride"] = 206.45, ["Mega"] = 83.98, ["Mega|Fly"] = 147.93, ["Mega|Ride"] = 152.03, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 17.07, ["Fly"] = 62.66, ["Ride"] = 22.88, ["Fly|Ride"] = 68.83, ["Neon"] = 228.74, ["Neon|Ride"] = 149.43, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 974.19, ["Mega|Ride"] = 927.81, ["Mega|Fly|Ride"] = 607.69}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.12, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega"] = 328.13, ["Mega|Fly|Ride"] = 849.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 63.72, ["Fly"] = 82.21, ["Ride"] = 71.63, ["Fly|Ride"] = 178.66, ["Neon"] = 249.38, ["Neon|Ride"] = 237.98, ["Neon|Fly|Ride"] = 349.13, ["Mega|Ride"] = 1438.12, ["Mega|Fly|Ride"] = 1194.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 51.03, ["Fly"] = 88.05, ["Ride"] = 105, ["Fly|Ride"] = 94.5, ["Neon"] = 126, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 356.05, ["Mega"] = 576.26, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 23.7, ["Ride"] = 35.97, ["Fly|Ride"] = 137.68, ["Neon"] = 127.32, ["Mega"] = 821.63, ["Mega|Fly|Ride"] = 753.95}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 9.18, ["Fly"] = 410.87, ["Ride"] = 46.06, ["Fly|Ride"] = 62.65, ["Neon"] = 86.15, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 457.47, ["Mega|Ride"] = 364.34, ["Mega|Fly|Ride"] = 498.38}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 15.41, ["Fly|Ride"] = 32.89, ["Neon"] = 5.2, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.65, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 41.99, ["Mega|Fly"] = 205.44, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1848.9}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 39.26, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 246.53, ["Neon|Ride"] = 137.65, ["Neon|Fly|Ride"] = 274.26, ["Mega"] = 684.11, ["Mega|Ride"] = 602.44, ["Mega|Fly|Ride"] = 734.35}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 55.5, ["Neon"] = 4.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 287.62, ["Mega"] = 27.85, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 137.65}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 32.34, ["Ride"] = 74.25, ["Neon"] = 124.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 702.59, ["Mega|Fly|Ride"] = 754.69}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 105, ["Mega"] = 26.17}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 46.4, ["Mega"] = 24.23, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.88, ["Ride"] = 122.06, ["Neon"] = 498.75, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 671.77, ["Mega|Ride"] = 2040.98, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 10.28, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 90.56, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 86.63, ["Neon"] = 3.84, ["Neon|Fly"] = 61.64, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.74, ["Mega"] = 32.03, ["Mega|Ride"] = 122.25, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 44.18, ["Mega"] = 32.31, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.97, ["Neon|Ride"] = 131.25, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 59.07, ["Ride"] = 102.75, ["Fly|Ride"] = 449.61, ["Neon"] = 410.87, ["Neon|Ride"] = 491.01, ["Neon|Fly|Ride"] = 685.13, ["Mega|Fly|Ride"] = 1364.09}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.57, ["Ride"] = 62.66, ["Fly|Ride"] = 131.25, ["Neon"] = 44.01, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 275.63}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 325.49, ["Ride"] = 410.93, ["Fly|Ride"] = 616.88, ["Neon"] = 1641.42, ["Neon|Fly"] = 1725.65, ["Neon|Ride"] = 1642.44, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.63, ["Mega|Fly|Ride"] = 3822}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 84}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.63}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 22.32}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 58.59}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 51.14}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.12}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.45}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.28}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.49}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.37}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 157.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.49}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 10.43}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 509.24}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 923.53}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.45}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.62}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 32.66}},
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
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.69}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.49}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.89}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 12.99}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 13.63}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 131.72}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.15}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.52}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1836.01}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.1}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.13}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.63}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 195.57}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.92}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.86}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2050.22}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 20.99}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.63}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 19.68}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.12}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 3.56}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 157.5}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 37.8}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.84}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.81}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.66}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 35.09}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.63}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 104.99}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 190.32}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.19}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 20.9}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.69}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22034.93}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 548.51}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.75}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 40.68}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 274.3}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 29.82}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 66.94}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.49}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.99}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 274.26}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.49}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.04}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 5.94}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.9}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 82.69}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.25}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.89}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.34}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 273.25}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.8}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 564.38}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.38}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.48}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 61.64}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 48.57}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 49.53}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 22.32}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.81}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 14.44}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.81}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.25}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 157.5}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 9655.31}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 4.65}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.53}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 13.13}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 10.5}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 67.89}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 27.46}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 27.75}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.3}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 3.84}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 8.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.5}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.63}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 21.51}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.36}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.06}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.44}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 6.18}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 9.77}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 15.42}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.5}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 11.02}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4058.57}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 44.61}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.32}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 52.49}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 39.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.66}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.13}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.87}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.14}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.82}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.64}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.37}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 19.53}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.28}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 10.5}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.04}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 4.13}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 13.13}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 1706.25}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.12}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.49}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 39.37}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.81}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.49}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.63}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.72}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 9.98}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 23.63}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 7.88}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 68.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.35}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.18}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.52}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 12.59}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 18.37}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 4.97}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.77}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 16.45}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 13.13}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.19}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.3}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.42}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.38}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 6.98}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.52}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 14.32}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 39.9}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.15}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.56}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 80.07}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.94}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.84}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.18}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.99}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.35}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.29}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1050}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 212.63}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.37}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.37}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 22.32}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 60.27}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 13.13}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 36.75}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 6.57}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.45}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.88}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 15.43}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 56.43}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 63}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 65.63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.49}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.89}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 28.86}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 109.73}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 68.25}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.94}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 90.57}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 71.92}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 106.84}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 685.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.94}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.88}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.14}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.61}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 24.94}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 36.74}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.94}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 73.48}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 15.75}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 22.32}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 20.25}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 17.07}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 68.83}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 4.13}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.14}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 45.22}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.92}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 66.94}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.8}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1758.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 15.42}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.43}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 328.13}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.76}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 12.89}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 36.71}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 8.98}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 4.98}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 273}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 49.62}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.94}},
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
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 65.63}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 191.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 15.42}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2054.33}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 418.69}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.92}},
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