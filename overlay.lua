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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 999.85, ["Ride"] = 853.13, ["Fly|Ride"] = 1050, ["Neon"] = 6495.17, ["Neon|Ride"] = 3013.33, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24648.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 448.88, ["Fly"] = 551.25, ["Ride"] = 466.94, ["Fly|Ride"] = 581.37, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 2464.89, ["Mega"] = 10270.33}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4200, ["Ride"] = 5197.5, ["Fly|Ride"] = 4461.19, ["Neon|Fly|Ride"] = 19856.65, ["Mega|Fly|Ride"] = 68469.15}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 157.5, ["Ride"] = 164.34, ["Fly|Ride"] = 252, ["Neon"] = 773.63, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1095.87, ["Mega"] = 4108.14, ["Mega|Fly|Ride"] = 3136.58}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 821.64, ["Ride"] = 577.5, ["Fly|Ride"] = 574.32, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 1649.45, ["Mega|Fly|Ride"] = 6495.15}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.19, ["Ride"] = 27.68, ["Fly|Ride"] = 152.02, ["Neon"] = 72.19, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 285.27, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.13, ["Fly"] = 40.53, ["Ride"] = 27.75, ["Fly|Ride"] = 57.75, ["Neon"] = 32.81, ["Neon|Fly"] = 106.72, ["Neon|Ride"] = 56.13, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 131.03, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 286.61}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 97.76, ["Ride"] = 146.24, ["Fly|Ride"] = 233.63, ["Neon"] = 546.39, ["Neon|Ride"] = 615.21, ["Neon|Fly|Ride"] = 463.96, ["Mega"] = 1437.86, ["Mega|Fly|Ride"] = 2640.51}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.33, ["Fly"] = 137.64, ["Ride"] = 46.49, ["Fly|Ride"] = 81.38, ["Neon"] = 224.94, ["Neon|Ride"] = 301.86, ["Neon|Fly|Ride"] = 286.56, ["Mega"] = 1370.08, ["Mega|Ride"] = 2730, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.25, ["Fly"] = 49.88, ["Ride"] = 36.75, ["Fly|Ride"] = 65.63, ["Neon"] = 137.64, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1334.12, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 59.07, ["Fly"] = 85.32, ["Ride"] = 80.75, ["Fly|Ride"] = 177.19, ["Neon"] = 262.5, ["Neon|Fly"] = 274.23, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 288.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.9}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 336, ["Fly"] = 395.01, ["Ride"] = 346.21, ["Fly|Ride"] = 388.26, ["Neon"] = 1370.08, ["Neon|Ride"] = 1260.77, ["Neon|Fly|Ride"] = 1179.03, ["Mega|Fly|Ride"] = 4834.26}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.95, ["Fly"] = 105, ["Ride"] = 123.38, ["Fly|Ride"] = 124.38, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 602.88, ["Mega|Fly|Ride"] = 2619.98}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.62, ["Fly"] = 114.02, ["Ride"] = 51.85, ["Fly|Ride"] = 205.42, ["Neon"] = 19.69, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 141.08, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 383.93}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 155.93, ["Fly"] = 241.37, ["Ride"] = 144.38, ["Fly|Ride"] = 220.79, ["Neon"] = 927.89, ["Neon|Fly"] = 685.05, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 2229.93}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.63, ["Fly"] = 21.38, ["Ride"] = 18.38, ["Fly|Ride"] = 26.25, ["Neon"] = 26.25, ["Neon|Ride"] = 90.39, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 334.69, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.95, ["Fly"] = 262.5, ["Ride"] = 131.24, ["Fly|Ride"] = 180.79, ["Neon"] = 343.01, ["Neon|Fly"] = 463.96, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1493.33, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 45.94, ["Ride"] = 123.38, ["Fly|Ride"] = 164.07, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 13.13, ["Fly"] = 393.75, ["Ride"] = 35.44, ["Fly|Ride"] = 223.13, ["Neon"] = 65.63, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 246.51, ["Mega"] = 2667.67, ["Mega|Ride"] = 577.21, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.38, ["Fly"] = 77.73, ["Ride"] = 55.08, ["Fly|Ride"] = 108.94, ["Neon"] = 238.92, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1623.8, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 31.5, ["Fly"] = 274.23, ["Ride"] = 124.11, ["Fly|Ride"] = 136.5, ["Neon"] = 204.75, ["Neon|Fly"] = 385.08, ["Neon|Ride"] = 294.77, ["Neon|Fly|Ride"] = 343.05, ["Mega"] = 1067.1, ["Mega|Ride"] = 1228.35, ["Mega|Fly|Ride"] = 1005.6}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 24.67, ["Ride"] = 40.07, ["Fly|Ride"] = 131.25, ["Neon"] = 343.05, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 315, ["Mega"] = 768.24, ["Mega|Ride"] = 2052.02, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.38, ["Fly"] = 136.75, ["Ride"] = 59.06, ["Fly|Ride"] = 144.38, ["Neon"] = 210, ["Neon|Fly"] = 549.48, ["Neon|Ride"] = 309.7, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 859.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.57, ["Fly"] = 35.89, ["Ride"] = 21.48, ["Fly|Ride"] = 52.49, ["Neon"] = 30.94, ["Neon|Fly"] = 104.99, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 78.88, ["Mega"] = 129.94, ["Mega|Fly"] = 23607.43, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 298.86}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 397.48, ["Ride"] = 415.09, ["Fly|Ride"] = 441.23, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1680, ["Mega|Fly|Ride"] = 7254.97}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 32.45, ["Fly|Ride"] = 107.34, ["Neon"] = 219.19, ["Neon|Fly|Ride"] = 419.05, ["Mega|Fly|Ride"] = 912.02}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 40.28, ["Ride"] = 20.65, ["Fly|Ride"] = 39.38, ["Neon"] = 51.18, ["Neon|Fly"] = 90.39, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 123.38, ["Mega|Ride"] = 256.66, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 77.98, ["Fly"] = 77.44, ["Ride"] = 81.72, ["Fly|Ride"] = 143.63, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 2054.08, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.13, ["Ride"] = 30.82, ["Fly|Ride"] = 75.22, ["Neon"] = 151.2, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 162.42, ["Mega"] = 695.92, ["Mega|Ride"] = 779.54, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 182.43, ["Fly"] = 347.16, ["Ride"] = 190.32, ["Fly|Ride"] = 294.77, ["Neon"] = 811.91, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 985.97, ["Mega"] = 6162.21, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2865.43}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.18}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 29.4, ["Ride"] = 24.67, ["Fly|Ride"] = 49.89, ["Neon"] = 27.74, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 51.36, ["Neon|Fly|Ride"] = 152.02, ["Mega"] = 234.94, ["Mega|Fly"] = 343.05, ["Mega|Ride"] = 273.2, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1092, ["Fly"] = 2625, ["Ride"] = 1181.25, ["Fly|Ride"] = 1112.12, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4003.13, ["Mega|Ride"] = 52193.09, ["Mega|Fly|Ride"] = 21089.1}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.73, ["Fly"] = 65.63, ["Ride"] = 32.8, ["Fly|Ride"] = 65.63, ["Neon"] = 77.04, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 103.17, ["Neon|Fly|Ride"] = 217.74, ["Mega"] = 508.39, ["Mega|Ride"] = 665.54, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 157.5, ["Ride"] = 168, ["Fly|Ride"] = 278.37, ["Neon"] = 801.1, ["Neon|Ride"] = 616.77, ["Neon|Fly|Ride"] = 1014.72, ["Mega|Ride"] = 2916.79, ["Mega|Fly|Ride"] = 2734.99}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.38, ["Fly"] = 68.84, ["Ride"] = 52.28, ["Fly|Ride"] = 137.64, ["Neon"] = 81.34, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 670.9, ["Mega|Fly|Ride"] = 727.23}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 113.13, ["Ride"] = 407.58, ["Neon"] = 584.07, ["Neon|Ride"] = 315.31, ["Neon|Fly|Ride"] = 697.36, ["Mega|Fly|Ride"] = 2434.07}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 105, ["Ride"] = 152.25, ["Fly|Ride"] = 220.5, ["Neon"] = 389.45, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 1540.56, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1846.62}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 61.94}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.46, ["Fly"] = 59.16, ["Ride"] = 54.93, ["Fly|Ride"] = 81.35, ["Neon|Ride"] = 477.88, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 4108.14, ["Mega|Fly|Ride"] = 1547.25}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.57, ["Fly"] = 55.47, ["Ride"] = 62.65, ["Fly|Ride"] = 131.25, ["Neon"] = 39.03, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 328.67, ["Mega"] = 157.5, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 420, ["Fly"] = 426.57, ["Ride"] = 367.5, ["Fly|Ride"] = 419.99, ["Neon|Ride"] = 1745.97, ["Neon|Fly|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 6298.95}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 97.12, ["Fly"] = 137.64, ["Ride"] = 104.99, ["Fly|Ride"] = 170.63, ["Neon"] = 446.25, ["Neon|Ride"] = 486.83, ["Neon|Fly|Ride"] = 524.34, ["Mega|Ride"] = 2451.53, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3711.52, ["Ride"] = 3433.5, ["Fly|Ride"] = 3673.69, ["Neon|Fly|Ride"] = 14377.43}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.98, ["Fly"] = 109.91, ["Ride"] = 46.87, ["Fly|Ride"] = 96.56, ["Neon"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.05, ["Mega|Ride"] = 1179.05, ["Mega|Fly|Ride"] = 1368.02}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 64.97, ["Ride"] = 78.74, ["Fly|Ride"] = 195.57, ["Neon"] = 578.78, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2739.12, ["Mega|Fly|Ride"] = 2319.71}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.17, ["Fly"] = 61.64, ["Ride"] = 58.54, ["Fly|Ride"] = 108.15, ["Neon"] = 130.28, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 217.41, ["Mega"] = 2625, ["Mega|Ride"] = 671.69, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.21, ["Fly"] = 393.75, ["Ride"] = 47.25, ["Fly|Ride"] = 71.61, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 41.14}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 194.11, ["Ride"] = 233.16, ["Fly|Ride"] = 274.19, ["Neon|Ride"] = 1370.08, ["Neon|Fly|Ride"] = 927.89, ["Mega|Fly|Ride"] = 4949.09}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 924, ["Ride"] = 773.63, ["Fly|Ride"] = 1136.94, ["Neon|Ride"] = 3557.27, ["Neon|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 36.99, ["Fly"] = 40.61, ["Ride"] = 39.1, ["Fly|Ride"] = 77.73, ["Neon"] = 180.77, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 656.15, ["Mega|Fly|Ride"] = 874.54}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 12.75}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 6285.44, ["Fly|Ride"] = 4723.69, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40208.4}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.13, ["Fly"] = 74.7, ["Ride"] = 21, ["Fly|Ride"] = 58.46, ["Neon"] = 98.23, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 216.91, ["Mega"] = 643.97, ["Mega|Ride"] = 1506.67, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 11.81, ["Fly"] = 41.1, ["Ride"] = 30.82, ["Fly|Ride"] = 109.91, ["Neon"] = 92.52, ["Neon|Ride"] = 132.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 1027.05, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 93.47, ["Fly"] = 263, ["Ride"] = 39.38, ["Fly|Ride"] = 89.25, ["Neon|Fly|Ride"] = 927.89, ["Mega"] = 4108.14}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.19, ["Ride"] = 26.25, ["Fly|Ride"] = 106.82, ["Neon"] = 82.18, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 501.37, ["Mega"] = 1370.08, ["Mega|Ride"] = 500.18, ["Mega|Fly|Ride"] = 619.37}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.64, ["Fly"] = 1837.5, ["Ride"] = 1732.5, ["Fly|Ride"] = 1918.51, ["Neon|Fly|Ride"] = 3909.02, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 23100, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 65047.08, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.75, ["Fly"] = 315, ["Ride"] = 52.5, ["Fly|Ride"] = 89.93, ["Neon"] = 252.67, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 960.28, ["Mega|Ride"] = 682.5, ["Mega|Fly|Ride"] = 817.53}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.29, ["Fly"] = 55.47, ["Ride"] = 46.01, ["Fly|Ride"] = 205.42, ["Neon"] = 19.52, ["Neon|Fly"] = 134.4, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 125.18, ["Mega|Ride"] = 140.13, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 34.13}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.5, ["Ride"] = 36.75, ["Fly|Ride"] = 124.66, ["Neon"] = 55.47, ["Neon|Ride"] = 136.23, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 210, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 717.92, ["Ride"] = 735, ["Fly|Ride"] = 774.38, ["Neon"] = 2939.06, ["Neon|Ride"] = 2899.63, ["Neon|Fly|Ride"] = 2319.71, ["Mega|Fly|Ride"] = 8490.48}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 821.54, ["Fly"] = 962.07, ["Ride"] = 901.69, ["Fly|Ride"] = 944.99, ["Neon"] = 4108.14, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11227.53}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.75, ["Fly"] = 116, ["Ride"] = 41.76, ["Fly|Ride"] = 65.63, ["Neon"] = 101.07, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 1027.05, ["Mega|Ride"] = 685.13, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.81}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 72.19, ["Fly"] = 93.19, ["Ride"] = 80.07, ["Fly|Ride"] = 105.7, ["Neon|Ride"] = 382.08, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 2010.94, ["Mega|Fly|Ride"] = 1598.63}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 68.25, ["Ride"] = 48.74, ["Fly|Ride"] = 228.38, ["Neon"] = 355.37, ["Neon|Ride"] = 390.29, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 2069.71, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.94, ["Fly"] = 41.1, ["Ride"] = 20, ["Fly|Ride"] = 51.32, ["Neon"] = 32.82, ["Neon|Fly"] = 525, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 315, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 103.68, ["Fly"] = 106.32, ["Ride"] = 89.78, ["Fly|Ride"] = 188.49, ["Neon"] = 804.18, ["Neon|Ride"] = 397.48, ["Neon|Fly|Ride"] = 347.82, ["Mega|Fly|Ride"] = 1401.39}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.7, ["Ride"] = 47.51, ["Fly|Ride"] = 111.57, ["Neon"] = 53.82, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 210, ["Mega|Ride"] = 335.85, ["Mega|Fly|Ride"] = 496.33}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.75, ["Fly"] = 40.69, ["Ride"] = 31.34, ["Fly|Ride"] = 82.16, ["Neon"] = 109.05, ["Neon|Ride"] = 109.19, ["Neon|Fly|Ride"] = 175.64, ["Mega"] = 726.13, ["Mega|Fly|Ride"] = 772.47}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 21, ["Ride"] = 74.72, ["Fly|Ride"] = 156.19, ["Neon"] = 259.26, ["Neon|Ride"] = 685.05, ["Mega"] = 694.25, ["Mega|Ride"] = 773.63, ["Mega|Fly|Ride"] = 862.72}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.46, ["Fly"] = 124.8, ["Ride"] = 34.93, ["Fly|Ride"] = 72.19, ["Neon"] = 91.88, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 712.78, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6846.2, ["Ride"] = 6332.82, ["Fly|Ride"] = 6259.68, ["Neon"] = 30810.96, ["Neon|Fly|Ride"] = 27252.3}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 255.15, ["Fly"] = 242.82, ["Ride"] = 243.78, ["Fly|Ride"] = 249.38, ["Neon|Fly|Ride"] = 555.5, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 31.5, ["Fly"] = 131.73, ["Ride"] = 76.02, ["Fly|Ride"] = 141.06, ["Neon"] = 80.07, ["Neon|Fly"] = 204.39, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 380.62, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 85.84, ["Ride"] = 20.56, ["Fly|Ride"] = 96.56, ["Neon"] = 23.01, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 186.93, ["Mega"] = 262.5, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.5, ["Fly"] = 5257.6, ["Ride"] = 92.8, ["Fly|Ride"] = 157.5, ["Neon"] = 181.76, ["Neon|Fly"] = 236.25, ["Neon|Ride"] = 201.71, ["Neon|Fly|Ride"] = 315.31, ["Mega"] = 407.91, ["Mega|Ride"] = 592.65, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 13991.25, ["Ride"] = 13125, ["Fly|Ride"] = 12307.32, ["Neon|Fly|Ride"] = 27562.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 128.62, ["Ride"] = 164.06, ["Fly|Ride"] = 223.13, ["Neon"] = 918.75, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 4231.39}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.77, ["Fly"] = 101.88, ["Ride"] = 58.47, ["Fly|Ride"] = 86.63, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 407.82, ["Mega|Fly|Ride"] = 2505.97}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.5, ["Fly"] = 28.53, ["Ride"] = 24.55, ["Fly|Ride"] = 59.59, ["Neon"] = 85.32, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 229.69, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 341.25, ["Fly"] = 821.64, ["Ride"] = 413.44, ["Fly|Ride"] = 483, ["Neon"] = 1639.32, ["Neon|Ride"] = 1709, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.57, ["Ride"] = 20.56, ["Fly|Ride"] = 137.64, ["Neon"] = 24.94, ["Neon|Ride"] = 123.26, ["Neon|Fly|Ride"] = 216.91, ["Mega"] = 129.94, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 255.18, ["Fly"] = 263.3, ["Ride"] = 272.87, ["Fly|Ride"] = 264.47, ["Neon"] = 756.24, ["Neon|Ride"] = 687.93, ["Neon|Fly|Ride"] = 773.63, ["Mega|Fly|Ride"] = 3557.27}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 15.75, ["Ride"] = 17.07, ["Fly|Ride"] = 35.05, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 685.49}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.34}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 86.63, ["Fly|Ride"] = 279.57, ["Neon"] = 409.8, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1129.74, ["Mega|Ride"] = 1232.45, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.13, ["Fly"] = 101.7, ["Ride"] = 42, ["Fly|Ride"] = 86.63, ["Neon"] = 96.56, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 512.51, ["Mega|Ride"] = 548.45, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 42, ["Fly"] = 131.25, ["Ride"] = 91.08, ["Fly|Ride"] = 274.23, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 914.07, ["Mega|Ride"] = 927.89, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.24, ["Neon"] = 21.67, ["Neon|Ride"] = 104.4, ["Neon|Fly|Ride"] = 240.34, ["Mega"] = 135.18, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 47.24, ["Ride"] = 31.85, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 135.59, ["Neon|Fly|Ride"] = 217.74, ["Mega|Ride"] = 534.08, ["Mega|Fly|Ride"] = 801.1}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 363.83, ["Ride"] = 376.93, ["Fly|Ride"] = 346.5, ["Neon|Fly|Ride"] = 2602.51, ["Mega|Fly|Ride"] = 8627.08}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 42, ["Fly"] = 34.93, ["Ride"] = 53.82, ["Fly|Ride"] = 103.68, ["Neon"] = 184.43, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 233.16, ["Mega"] = 710.72, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.93, ["Fly"] = 109.01, ["Ride"] = 72.19, ["Fly|Ride"] = 137.64, ["Neon"] = 410.83, ["Neon|Ride"] = 220.75, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1261.21}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 28.48, ["Fly"] = 84.23, ["Ride"] = 64.32, ["Fly|Ride"] = 144.43, ["Neon"] = 111.56, ["Neon|Ride"] = 152.02, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 367.5, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 26249.99, ["Ride"] = 9995.9, ["Fly|Ride"] = 7940.62, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 39373.95}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1442.44, ["Fly|Ride"] = 1521.19, ["Neon"] = 5478.21, ["Neon|Fly|Ride"] = 4068.74, ["Mega"] = 22732.35, ["Mega|Fly|Ride"] = 14962.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 511.88, ["Ride"] = 505.32, ["Fly|Ride"] = 548.45, ["Neon"] = 2270, ["Neon|Fly|Ride"] = 2232.79, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 13.02, ["Fly"] = 23.62, ["Ride"] = 19.69, ["Fly|Ride"] = 48.79, ["Neon"] = 108.78, ["Neon|Ride"] = 101.7, ["Neon|Fly|Ride"] = 137.64, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.75, ["Fly"] = 78.74, ["Ride"] = 30.76, ["Fly|Ride"] = 123.26, ["Neon"] = 27.61, ["Neon|Ride"] = 67.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 156.85, ["Mega|Ride"] = 180.31, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 46.39, ["Fly"] = 68.25, ["Ride"] = 43.32, ["Fly|Ride"] = 97.44, ["Neon"] = 274.23, ["Neon|Ride"] = 193.59, ["Neon|Fly|Ride"] = 169.41, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.94, ["Fly"] = 13.13, ["Ride"] = 17.07, ["Fly|Ride"] = 43.24, ["Neon"] = 23.71, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 359.48, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 315, ["Fly"] = 320.25, ["Ride"] = 249.38, ["Fly|Ride"] = 375.46, ["Neon"] = 1004.41, ["Neon|Ride"] = 1308.45, ["Neon|Fly|Ride"] = 1210.13}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 39.35, ["Fly"] = 60.09, ["Ride"] = 40.51, ["Fly|Ride"] = 76.02, ["Neon"] = 204.75, ["Neon|Fly"] = 63, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 12.34, ["Fly"] = 26.56, ["Ride"] = 17.41, ["Fly|Ride"] = 26.25, ["Neon"] = 68.82, ["Neon|Fly"] = 132.24, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 435.74, ["Fly|Ride"] = 643.97, ["Neon|Fly|Ride"] = 2319.71, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1130.46, ["Fly"] = 1391.83, ["Ride"] = 1154.99, ["Fly|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13716.15}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 123.24, ["Fly"] = 128.63, ["Ride"] = 94.5, ["Fly|Ride"] = 110.51, ["Neon"] = 513.54, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 2328.3, ["Mega|Fly|Ride"] = 3868.1}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 170.41, ["Fly"] = 212.13, ["Ride"] = 181.13, ["Fly|Ride"] = 196.88, ["Neon"] = 556.5, ["Neon|Ride"] = 665.54, ["Neon|Fly|Ride"] = 606.66, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2475.13}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.88, ["Ride"] = 65.62, ["Fly|Ride"] = 274.23, ["Neon"] = 232.74, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 385.08, ["Mega"] = 656.25, ["Mega|Ride"] = 1855.76, ["Mega|Fly|Ride"] = 792.88}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 273, ["Fly|Ride"] = 410.83, ["Neon|Fly|Ride"] = 1299.03, ["Mega|Fly|Ride"] = 3286.53}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2040.73, ["Ride"] = 2483.25, ["Fly|Ride"] = 2464.89, ["Neon|Fly|Ride"] = 8216.28, ["Mega|Fly|Ride"] = 24744.17}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 59.07, ["Ride"] = 65.63, ["Fly|Ride"] = 196.87, ["Neon"] = 511.88, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 1918.51, ["Mega|Ride"] = 2259.48, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 617.47, ["Fly"] = 794.94, ["Ride"] = 643.13, ["Fly|Ride"] = 656.24, ["Neon|Ride"] = 1506.67, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 3107.9}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 42, ["Fly"] = 64.32, ["Ride"] = 52.5, ["Fly|Ride"] = 81.38, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 359.57, ["Neon|Fly|Ride"] = 231, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.61, ["Fly"] = 31.55, ["Ride"] = 20.44, ["Fly|Ride"] = 44.88, ["Neon"] = 27.75, ["Neon|Fly"] = 92.8, ["Neon|Ride"] = 32.48, ["Neon|Fly|Ride"] = 77.97, ["Mega"] = 141.67, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 184.92, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 262.5, ["Neon|Ride"] = 409.8, ["Neon|Fly|Ride"] = 619.37, ["Mega|Ride"] = 1370.08, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 643.13, ["Fly"] = 899.07, ["Ride"] = 721.88, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2428.74, ["Neon|Fly|Ride"] = 2131.54, ["Mega|Fly|Ride"] = 7803.41}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 577.5, ["Ride"] = 551.25, ["Fly|Ride"] = 859.69, ["Neon"] = 5135.17, ["Neon|Fly|Ride"] = 3527.87, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.01, ["Fly"] = 32.82, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 205.42, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 168.45, ["Mega"] = 786.19, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.5, ["Ride"] = 22.16, ["Fly|Ride"] = 64.72, ["Neon"] = 72.02, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 959.26, ["Mega|Ride"] = 439.59, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.09, ["Ride"] = 26.95, ["Fly|Ride"] = 111.56, ["Neon"] = 20.66, ["Neon|Fly"] = 309.7, ["Neon|Ride"] = 52.82, ["Neon|Fly|Ride"] = 152.02, ["Mega"] = 156.39, ["Mega|Fly"] = 538.13, ["Mega|Ride"] = 238.68, ["Mega|Fly|Ride"] = 302.54}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.78, ["Fly"] = 76.02, ["Ride"] = 52.87, ["Fly|Ride"] = 108.78, ["Neon"] = 287.59, ["Neon|Ride"] = 286.56, ["Neon|Fly|Ride"] = 231, ["Mega|Ride"] = 1047.59, ["Mega|Fly|Ride"] = 944.9}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.64, ["Neon|Ride"] = 490.94, ["Neon|Fly|Ride"] = 685.05, ["Mega"] = 1540.56, ["Mega|Ride"] = 1540.56, ["Mega|Fly|Ride"] = 1321.81}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 11.82, ["Fly"] = 54.55, ["Ride"] = 39.16, ["Fly|Ride"] = 78.75, ["Neon"] = 65.63, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 200.28, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 38.24, ["Fly"] = 56.01, ["Ride"] = 47.25, ["Fly|Ride"] = 90.96, ["Neon"] = 548.45, ["Neon|Ride"] = 256.34, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 2100, ["Mega|Ride"] = 959.26, ["Mega|Fly|Ride"] = 787.4}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.6, ["Fly"] = 23.64, ["Ride"] = 19.68, ["Fly|Ride"] = 40.67, ["Neon"] = 26.25, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 91.71, ["Mega"] = 525, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 315.31}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.09, ["Fly"] = 30.86, ["Ride"] = 30.82, ["Fly|Ride"] = 80.88, ["Neon"] = 27.28, ["Neon|Fly"] = 82.18, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 164.34, ["Mega"] = 192.07, ["Mega|Ride"] = 302.3, ["Mega|Fly|Ride"] = 649.1}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 43.32, ["Fly"] = 65.62, ["Ride"] = 51.16, ["Fly|Ride"] = 87.94, ["Neon"] = 274.23, ["Neon|Ride"] = 186.51, ["Neon|Fly|Ride"] = 267.75, ["Mega|Fly|Ride"] = 924.34}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1569.02, ["Fly"] = 1470, ["Ride"] = 1494.28, ["Fly|Ride"] = 1521.19, ["Neon|Fly"] = 4929.37, ["Neon|Ride"] = 4628.86, ["Neon|Fly|Ride"] = 3732.75, ["Mega|Fly|Ride"] = 16431.5}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 547.46, ["Ride"] = 483.27, ["Fly|Ride"] = 545.36, ["Neon|Ride"] = 2567.59, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 9584.28}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 241.5, ["Fly"] = 348.18, ["Ride"] = 275.63, ["Fly|Ride"] = 328.13, ["Neon"] = 1370.08, ["Neon|Ride"] = 1577.4, ["Neon|Fly|Ride"] = 1437.69, ["Mega|Fly|Ride"] = 6546.31}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.99}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 30.19, ["Ride"] = 41.85, ["Fly|Ride"] = 96.56, ["Neon"] = 329.41, ["Neon|Fly"] = 410.83, ["Neon|Ride"] = 343.05, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 924.34, ["Mega|Ride"] = 959.26, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 41081.29, ["Fly"] = 20998.69, ["Ride"] = 34781.25, ["Fly|Ride"] = 17587.5, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 388.23, ["Fly"] = 853.67, ["Ride"] = 408.72, ["Fly|Ride"] = 419.47, ["Neon"] = 1115.63, ["Neon|Ride"] = 1207.5, ["Neon|Fly|Ride"] = 1239, ["Mega"] = 6025.62, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 171.93, ["Fly"] = 525, ["Ride"] = 136.5, ["Fly|Ride"] = 173.7, ["Mega|Fly|Ride"] = 4108.14}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 132.24, ["Fly"] = 262.5, ["Ride"] = 116.94, ["Fly|Ride"] = 179.82, ["Neon"] = 616.23, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 548.45, ["Mega|Fly|Ride"] = 2463.86}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.44, ["Fly"] = 94.5, ["Ride"] = 33.65, ["Fly|Ride"] = 102.54, ["Neon"] = 274.23, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 204.39, ["Mega"] = 684.03, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4847.6, ["Ride"] = 4929.78, ["Fly|Ride"] = 3675, ["Neon|Ride"] = 17802.58, ["Neon|Fly|Ride"] = 17528.37}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 30.17, ["Fly"] = 40.62, ["Ride"] = 35.72, ["Fly|Ride"] = 53.82, ["Neon"] = 333.94, ["Neon|Ride"] = 231.98, ["Neon|Fly|Ride"] = 171.67, ["Mega"] = 1095.87, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 44.63, ["Fly"] = 137.64, ["Ride"] = 58.56, ["Fly|Ride"] = 109.15, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 1547.25, ["Mega|Fly|Ride"] = 1493.33}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 623.44, ["Fly"] = 918.75, ["Ride"] = 721.88, ["Fly|Ride"] = 840, ["Neon"] = 2054.08, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Ride"] = 7532.26, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 24.77, ["Ride"] = 22.44, ["Fly|Ride"] = 44.63, ["Neon"] = 124.68, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 588.06, ["Mega|Ride"] = 582.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 20.56, ["Fly"] = 88.34, ["Ride"] = 34.12, ["Fly|Ride"] = 463.96, ["Neon"] = 80.06, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 520.72, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 101.33, ["Ride"] = 115.5, ["Fly|Ride"] = 262.5, ["Neon"] = 533.05, ["Neon|Ride"] = 525.35, ["Neon|Fly|Ride"] = 602.88, ["Mega|Ride"] = 2739.12, ["Mega|Fly|Ride"] = 2052.02}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 25.99, ["Fly"] = 85.62, ["Ride"] = 84.24, ["Fly|Ride"] = 162.28, ["Neon"] = 84.45, ["Neon|Ride"] = 136.23, ["Neon|Fly|Ride"] = 256.09, ["Mega"] = 273, ["Mega|Fly"] = 736.52, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 456.3}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3807.36, ["Fly"] = 5031.45, ["Ride"] = 3937.49, ["Fly|Ride"] = 3675, ["Neon"] = 12324.39, ["Neon|Ride"] = 11469.91, ["Neon|Fly|Ride"] = 8908.78, ["Mega"] = 40982.02, ["Mega|Fly|Ride"] = 34177.2}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 36.74, ["Ride"] = 59.07, ["Fly|Ride"] = 135.59, ["Neon"] = 479.64, ["Neon|Ride"] = 294.61, ["Neon|Fly|Ride"] = 302.99, ["Mega|Ride"] = 1026.02, ["Mega|Fly|Ride"] = 1095.87}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 5891.82, ["Fly"] = 7875, ["Ride"] = 7668.87, ["Fly|Ride"] = 5775, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 68044.7}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.38, ["Fly"] = 20.56, ["Ride"] = 17.07, ["Fly|Ride"] = 30.82, ["Neon"] = 19.68, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 448.87, ["Mega|Ride"] = 192.07, ["Mega|Fly|Ride"] = 299.92}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.62, ["Fly"] = 26.25, ["Ride"] = 26.56, ["Fly|Ride"] = 48.28, ["Neon"] = 109.91, ["Neon|Ride"] = 163.31, ["Neon|Fly|Ride"] = 178.71, ["Mega|Fly|Ride"] = 927.89}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.42}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 17.5, ["Ride"] = 26.25, ["Fly|Ride"] = 116.03, ["Neon"] = 141.74, ["Neon|Ride"] = 124.11, ["Neon|Fly|Ride"] = 599.8, ["Mega"] = 775.85, ["Mega|Ride"] = 959.26, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.75, ["Fly"] = 190.37, ["Ride"] = 40.07, ["Fly|Ride"] = 308.13, ["Neon"] = 182.44, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 265.69, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 20.56, ["Fly"] = 20.45, ["Ride"] = 22.32, ["Fly|Ride"] = 41.99, ["Neon"] = 89.36, ["Neon|Ride"] = 114.02, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 786.19, ["Mega|Ride"] = 578.78, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8763.61}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.18, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1027.05}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 18.38, ["Fly"] = 123.26, ["Ride"] = 48.57, ["Fly|Ride"] = 111.57, ["Neon"] = 82.18, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 927.89, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.47}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 29.22, ["Fly|Ride"] = 68.82, ["Neon"] = 49.31, ["Neon|Ride"] = 68.82, ["Neon|Fly|Ride"] = 123.26, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2966.25}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 152.1, ["Fly"] = 281.42, ["Ride"] = 196.88, ["Fly|Ride"] = 476.56, ["Neon"] = 701.37, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 685.05, ["Mega|Ride"] = 3006.14, ["Mega|Fly|Ride"] = 3013.33}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 155.44, ["Ride"] = 196.87, ["Fly|Ride"] = 209.2, ["Neon"] = 726.13, ["Neon|Ride"] = 619.84, ["Neon|Fly|Ride"] = 1095.87, ["Mega|Ride"] = 2739.12, ["Mega|Fly|Ride"] = 3093.33}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 168, ["Fly"] = 157.5, ["Ride"] = 196.88, ["Fly|Ride"] = 234.94, ["Neon"] = 897.75, ["Neon|Fly"] = 956.18, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 813.75, ["Mega"] = 4518.95, ["Mega|Fly|Ride"] = 3696.3}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1640.52, ["Fly"] = 2464.89, ["Ride"] = 1574.98, ["Fly|Ride"] = 1670.01, ["Neon"] = 6804.84, ["Neon|Ride"] = 5853.07, ["Neon|Fly|Ride"] = 4265.63, ["Mega|Fly|Ride"] = 30810.96}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 16.69, ["Fly"] = 80.13, ["Ride"] = 39.41, ["Fly|Ride"] = 93.47, ["Neon"] = 137.64, ["Neon|Ride"] = 205.42, ["Neon|Fly|Ride"] = 322.88, ["Mega"] = 820.61, ["Mega|Ride"] = 890.46, ["Mega|Fly|Ride"] = 1079.43}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 678.43, ["Fly|Ride"] = 883.26, ["Neon|Fly|Ride"] = 3971.55}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 36.73}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 13.13, ["Ride"] = 35.44, ["Fly|Ride"] = 681.8, ["Neon"] = 98.44, ["Neon|Ride"] = 123.53, ["Neon|Fly|Ride"] = 273.2, ["Mega"] = 459.38, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 508.39}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.57, ["Fly"] = 48.28, ["Ride"] = 26.46, ["Fly|Ride"] = 94.8, ["Neon"] = 52.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.32, ["Mega|Ride"] = 344.08, ["Mega|Fly|Ride"] = 619.37}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 57.06}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 25.54, ["Fly"] = 108.92, ["Ride"] = 31.28, ["Fly|Ride"] = 55.47, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 192.07, ["Mega"] = 918.75, ["Mega|Ride"] = 1237.58, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 100.92, ["Fly"] = 76.02, ["Ride"] = 32.82, ["Fly|Ride"] = 60.75, ["Neon|Ride"] = 218.07, ["Neon|Fly|Ride"] = 299.91, ["Mega"] = 819.59, ["Mega|Ride"] = 1739.79, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.5, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 4961.25, ["Neon|Fly|Ride"] = 9581.25, ["Mega|Fly|Ride"] = 35415.92}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.77, ["Fly"] = 46.4, ["Ride"] = 35.34, ["Fly|Ride"] = 88.06, ["Neon"] = 64.97, ["Neon|Ride"] = 77.44, ["Mega"] = 519.62, ["Mega|Ride"] = 511.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 27.57}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.75, ["Fly"] = 155.44, ["Ride"] = 143.17, ["Fly|Ride"] = 189, ["Neon"] = 485.63, ["Neon|Ride"] = 517.13, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 63.67, ["Fly"] = 96.48, ["Ride"] = 81.15, ["Fly|Ride"] = 152.25, ["Neon"] = 342.91, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 463.32, ["Mega"] = 2319.71, ["Mega|Ride"] = 1437.86, ["Mega|Fly|Ride"] = 1436.84}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.35, ["Fly"] = 70.45, ["Ride"] = 30.22, ["Fly|Ride"] = 45.94, ["Neon"] = 196.88, ["Neon|Ride"] = 155.1, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 734.34, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.25, ["Fly"] = 59.59, ["Ride"] = 27.75, ["Fly|Ride"] = 82.18, ["Neon"] = 31.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 124.68, ["Mega"] = 157.5, ["Mega|Fly"] = 6847.23, ["Mega|Ride"] = 217.67, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.92, ["Fly"] = 137.64, ["Ride"] = 26.12, ["Fly|Ride"] = 96.56, ["Neon"] = 93.47, ["Neon|Ride"] = 117.1, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 484.77, ["Mega|Ride"] = 508.39, ["Mega|Fly|Ride"] = 561.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 26.25, ["Fly"] = 27.75, ["Ride"] = 24.64, ["Fly|Ride"] = 52.39, ["Neon"] = 131.25, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 193.79}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 19.53, ["Ride"] = 96.86, ["Neon"] = 177.19, ["Mega"] = 525, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 137.64, ["Fly"] = 216.91, ["Ride"] = 443.63, ["Neon"] = 1095.87}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 37.41, ["Fly"] = 212, ["Ride"] = 82.18, ["Fly|Ride"] = 170.63, ["Neon"] = 249.36, ["Neon|Ride"] = 382.87, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 2916.38, ["Mega|Ride"] = 2142.25, ["Mega|Fly|Ride"] = 1236.63}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 917.44, ["Fly"] = 1152.97, ["Ride"] = 866.25, ["Fly|Ride"] = 918.75, ["Neon|Ride"] = 3149.92, ["Neon|Fly|Ride"] = 2546.19, ["Mega|Fly|Ride"] = 11025}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 286.13, ["Fly"] = 463.96, ["Ride"] = 325.5, ["Fly|Ride"] = 393.73, ["Neon"] = 1181.25, ["Neon|Ride"] = 2011.19, ["Neon|Fly|Ride"] = 1916.45, ["Mega"] = 4593.75, ["Mega|Fly|Ride"] = 5512.5}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 55.13}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 13.13, ["Fly"] = 27.75, ["Ride"] = 18.19, ["Fly|Ride"] = 43.32, ["Neon"] = 77.95, ["Neon|Fly"] = 116, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 684.03, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 271.69, ["Fly"] = 762.36, ["Ride"] = 301.88, ["Fly|Ride"] = 387.21, ["Neon"] = 959.26, ["Neon|Ride"] = 894.52, ["Neon|Fly|Ride"] = 979.36, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 196.88, ["Fly"] = 264.99, ["Ride"] = 195.57, ["Fly|Ride"] = 313.83, ["Neon"] = 784.88, ["Neon|Fly"] = 1643.28, ["Neon|Ride"] = 845.25, ["Neon|Fly|Ride"] = 1027.05, ["Mega"] = 9859.53, ["Mega|Ride"] = 11683.52, ["Mega|Fly|Ride"] = 2572.5}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 155.44, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 671.69, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 924.34}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.25, ["Ride"] = 27.75, ["Fly|Ride"] = 73.08, ["Neon"] = 30.18, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 262.1, ["Mega|Ride"] = 356.4, ["Mega|Fly|Ride"] = 788.78}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.41, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.27, ["Neon"] = 177.19, ["Neon|Ride"] = 109.91, ["Neon|Fly|Ride"] = 258.2, ["Mega|Ride"] = 799.04, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 15.75, ["Fly"] = 41.1, ["Ride"] = 44.18, ["Fly|Ride"] = 128.84, ["Neon"] = 109.05, ["Neon|Ride"] = 130.87, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 461.15, ["Mega|Ride"] = 478.84, ["Mega|Fly|Ride"] = 684.03}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.66, ["Fly"] = 78.75, ["Ride"] = 42, ["Fly|Ride"] = 165.59, ["Neon"] = 24.85, ["Neon|Fly"] = 65.75, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 155.27, ["Mega"] = 152, ["Mega|Ride"] = 184.16, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 269.06, ["Ride"] = 288.75, ["Fly|Ride"] = 262.5, ["Neon"] = 1506.67, ["Neon|Ride"] = 1454.46, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5202.95}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 116.64, ["Fly"] = 1050, ["Ride"] = 179.38, ["Fly|Ride"] = 328.67, ["Neon"] = 753.38, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 2625, ["Mega|Ride"] = 2875.7, ["Mega|Fly|Ride"] = 2475.13}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 62.12, ["Fly"] = 167.45, ["Ride"] = 72.19, ["Fly|Ride"] = 184.88, ["Neon"] = 356.4, ["Neon|Ride"] = 405.69, ["Neon|Fly|Ride"] = 477.53, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 13.13, ["Ride"] = 57.75, ["Fly|Ride"] = 246.51, ["Neon|Ride"] = 589.22, ["Neon|Fly|Ride"] = 479.64, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 1641.21}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Fly"] = 75.63, ["Ride"] = 34.9, ["Fly|Ride"] = 105, ["Neon"] = 77.44, ["Neon|Fly"] = 205.42, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 123.26, ["Mega"] = 346.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 450.21}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.63, ["Fly"] = 52.45, ["Ride"] = 18.18, ["Fly|Ride"] = 96.56, ["Neon"] = 19.69, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 130.45, ["Mega"] = 129.94, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 216.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 958.13, ["Fly"] = 1082.72, ["Ride"] = 909.56, ["Fly|Ride"] = 960.24, ["Neon"] = 3038.82, ["Neon|Fly"] = 3403.01, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2362.49, ["Mega|Fly|Ride"] = 7335.57}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 357, ["Ride"] = 412.13, ["Fly|Ride"] = 522.38, ["Neon|Ride"] = 2739.12, ["Neon|Fly|Ride"] = 1922.33, ["Mega"] = 10270.33, ["Mega|Fly|Ride"] = 8814.85}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 88.34, ["Fly"] = 137.64, ["Ride"] = 103.69, ["Fly|Ride"] = 180.77, ["Neon"] = 340.99, ["Neon|Ride"] = 302.99, ["Neon|Fly|Ride"] = 405.69, ["Mega"] = 1577.4, ["Mega|Ride"] = 2134.13, ["Mega|Fly|Ride"] = 1689.49}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 273, ["Ride"] = 296.87, ["Fly|Ride"] = 305.18, ["Neon|Fly|Ride"] = 1095.87, ["Mega"] = 10270.33, ["Mega|Fly|Ride"] = 4929.78}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 17.07, ["Fly"] = 137.64, ["Ride"] = 32.21, ["Fly|Ride"] = 71.5, ["Neon"] = 169.32, ["Neon|Ride"] = 102.72, ["Neon|Fly|Ride"] = 229.68, ["Mega|Fly|Ride"] = 773.63}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 218.67, ["Ride"] = 278.98, ["Fly|Ride"] = 545.36, ["Neon"] = 878.13, ["Neon|Ride"] = 878.13, ["Neon|Fly|Ride"] = 912.82, ["Mega"] = 4087.89, ["Mega|Ride"] = 4245.76, ["Mega|Fly|Ride"] = 3835.98}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.82, ["Fly"] = 76.13, ["Ride"] = 62.43, ["Fly|Ride"] = 122.14, ["Neon|Ride"] = 493, ["Neon|Fly|Ride"] = 548.45, ["Mega|Fly|Ride"] = 1547.25}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1815.81, ["Ride"] = 1654.85, ["Fly|Ride"] = 1676.93, ["Neon|Ride"] = 10826.02, ["Neon|Fly|Ride"] = 4381.34, ["Mega"] = 49297.55, ["Mega|Fly|Ride"] = 21773.1}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 18.37, ["Fly"] = 63.7, ["Ride"] = 38.07, ["Fly|Ride"] = 91.8, ["Neon"] = 61.07, ["Neon|Fly"] = 179.45, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 232.74, ["Mega"] = 288.71, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 318.74, ["Mega|Fly|Ride"] = 442.09}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 36.75, ["Fly"] = 119.1, ["Ride"] = 82.69, ["Fly|Ride"] = 160.13, ["Neon"] = 262.5, ["Neon|Ride"] = 278.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 817.53, ["Mega|Ride"] = 1005.48, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.63, ["Fly"] = 91.85, ["Ride"] = 91.08, ["Fly|Ride"] = 102.87, ["Neon|Ride"] = 397.48, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3422.09, ["Fly"] = 1312.5, ["Ride"] = 2316.57, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 5567.27, ["Mega|Fly|Ride"] = 23196.93}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 480.77, ["Fly"] = 819.59, ["Ride"] = 561.8, ["Fly|Ride"] = 685.05, ["Neon"] = 2166.62, ["Neon|Fly|Ride"] = 2707.09, ["Mega|Fly|Ride"] = 13918.16}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 91.85, ["Ride"] = 126.96, ["Fly|Ride"] = 206.07, ["Neon"] = 444.29, ["Neon|Fly"] = 616.23, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 630.52, ["Mega"] = 4108.14, ["Mega|Ride"] = 2602.51, ["Mega|Fly|Ride"] = 2054.08}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 12.34, ["Fly"] = 41.1, ["Ride"] = 26.18, ["Fly|Ride"] = 52.5, ["Neon"] = 71.91, ["Neon|Fly"] = 137.64, ["Neon|Ride"] = 93.56, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 1219.1}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 51.36, ["Ride"] = 48.43, ["Fly|Ride"] = 102.72, ["Neon"] = 204.75, ["Neon|Fly"] = 410.83, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1334.12, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Ride"] = 820.32, ["Fly|Ride"] = 774.38, ["Neon"] = 3011.27, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 15064.51}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 727.65}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5567.28, ["Fly|Ride"] = 4410, ["Neon"] = 42000, ["Neon|Ride"] = 29435.78, ["Neon|Fly|Ride"] = 21633.41, ["Mega|Fly|Ride"] = 87640.75}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 173.25, ["Fly"] = 402.74, ["Ride"] = 226.99, ["Fly|Ride"] = 367.5, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 2054.08, ["Mega"] = 5751.39, ["Mega|Fly|Ride"] = 5478.21}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 410.83, ["Neon|Ride"] = 493, ["Neon|Fly|Ride"] = 1095.87, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.13, ["Fly"] = 96.55, ["Ride"] = 36.19, ["Fly|Ride"] = 107.63, ["Neon"] = 147, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 643.97, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.13, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 49.87, ["Neon"] = 202.67, ["Neon|Fly"] = 274.23, ["Neon|Ride"] = 68.82, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 1312.5, ["Mega|Ride"] = 1583.7, ["Mega|Fly|Ride"] = 2177.33}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 17.06, ["Fly"] = 274.23, ["Ride"] = 37.13, ["Fly|Ride"] = 131.25, ["Neon"] = 102.72, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 181.56, ["Mega"] = 548.45, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 21, ["Ride"] = 18.71, ["Fly|Ride"] = 57.75, ["Neon"] = 22.32, ["Neon|Fly"] = 338.93, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 199.26, ["Mega|Ride"] = 217.74, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 17.41, ["Ride"] = 49.31, ["Fly|Ride"] = 183.75, ["Neon"] = 246.51, ["Neon|Fly"] = 821.64, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 306.08, ["Mega"] = 656.29, ["Mega|Ride"] = 1239, ["Mega|Fly|Ride"] = 924.34}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 306.08, ["Fly"] = 436.12, ["Ride"] = 351.4, ["Fly|Ride"] = 408.35, ["Neon"] = 1048.69, ["Neon|Fly"] = 1454.3, ["Neon|Ride"] = 1150.29, ["Neon|Fly|Ride"] = 1095.87, ["Mega"] = 7875, ["Mega|Fly"] = 4312.52, ["Mega|Ride"] = 3835.98, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.52, ["Fly"] = 13.13, ["Ride"] = 15.75, ["Fly|Ride"] = 39.44, ["Neon"] = 19.66, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 821.64, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.24, ["Fly"] = 88.26, ["Ride"] = 77.73, ["Fly|Ride"] = 123.44, ["Neon"] = 157.5, ["Neon|Fly"] = 387.4, ["Neon|Ride"] = 203.43, ["Neon|Fly|Ride"] = 245.37, ["Mega"] = 510.56, ["Mega|Fly"] = 821.64, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 609}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.46, ["Fly"] = 951.08, ["Ride"] = 767.81, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 1603.87, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 4056.85}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 31.85, ["Fly"] = 91.88, ["Ride"] = 43.66, ["Fly|Ride"] = 85.29, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 343.88, ["Fly"] = 341.25, ["Ride"] = 288.75, ["Fly|Ride"] = 328.13, ["Neon|Fly|Ride"] = 1232.86, ["Mega|Fly|Ride"] = 6847.23}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 145.67, ["Fly"] = 204.37, ["Ride"] = 154.21, ["Fly|Ride"] = 168.91, ["Neon|Ride"] = 712.78, ["Neon|Fly|Ride"] = 655.53, ["Mega"] = 3868.1, ["Mega|Fly|Ride"] = 3149.99}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 649.69, ["Ride"] = 656.25, ["Fly|Ride"] = 745.02, ["Neon|Ride"] = 2588.14, ["Neon|Fly|Ride"] = 2389.92, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.13, ["Ride"] = 40.53, ["Fly|Ride"] = 92.55, ["Neon"] = 65.63, ["Neon|Fly"] = 278.37, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 266.78, ["Mega"] = 274.23, ["Mega|Ride"] = 302.99, ["Mega|Fly|Ride"] = 486.83}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Ride"] = 3018.75, ["Fly|Ride"] = 2962.57, ["Neon|Fly|Ride"] = 6299.99, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 110.25, ["Fly"] = 118.13, ["Ride"] = 126, ["Fly|Ride"] = 157.5, ["Neon"] = 380.63, ["Neon|Ride"] = 515.59, ["Neon|Fly|Ride"] = 419.47, ["Mega|Fly|Ride"] = 2397.1}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 20.55, ["Ride"] = 18.21, ["Fly|Ride"] = 42.88, ["Neon"] = 18.38, ["Neon|Fly"] = 82.18, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 194.91, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.81, ["Ride"] = 27.75, ["Fly|Ride"] = 58.01, ["Neon"] = 19.69, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 210, ["Mega"] = 200.28, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 40.49, ["Fly"] = 152.02, ["Ride"] = 39.38, ["Fly|Ride"] = 55.13, ["Neon"] = 271.42, ["Neon|Ride"] = 287.59, ["Neon|Fly|Ride"] = 170.63, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 984.38, ["Ride"] = 1370.08, ["Fly|Ride"] = 1115.63}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6221.24, ["Fly"] = 7052.64, ["Ride"] = 6959.1, ["Fly|Ride"] = 6299.99}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.45, ["Fly"] = 35.97, ["Ride"] = 24.94, ["Fly|Ride"] = 50.6, ["Neon"] = 261.86, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 170.5, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.13, ["Fly"] = 45.94, ["Ride"] = 32.95, ["Fly|Ride"] = 68.82, ["Neon"] = 94.4, ["Neon|Ride"] = 90.37, ["Neon|Fly|Ride"] = 150.93, ["Mega"] = 642.48, ["Mega|Ride"] = 630.61, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.77, ["Fly"] = 96.56, ["Ride"] = 62.9, ["Fly|Ride"] = 104.98, ["Neon"] = 459.37, ["Neon|Ride"] = 328.67, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1787.05, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.25, ["Fly"] = 309.7, ["Ride"] = 219.18, ["Fly|Ride"] = 308.17, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1015.55, ["Mega"] = 10270.33, ["Mega|Fly|Ride"] = 3544.3}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 2.63, ["Ride"] = 31.85, ["Fly|Ride"] = 86.63, ["Neon"] = 20.79, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.45, ["Mega"] = 158.82, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 320.44}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 194.91, ["Fly"] = 266.78, ["Ride"] = 232.33, ["Fly|Ride"] = 328.13, ["Neon"] = 864.77, ["Neon|Ride"] = 907.02, ["Neon|Fly|Ride"] = 914.89, ["Mega|Fly|Ride"] = 5442.26}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.13, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 49.31, ["Neon"] = 19.69, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 64.96, ["Mega"] = 256.34, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 247.11}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 211.32, ["Fly"] = 243.58, ["Ride"] = 248.22, ["Fly|Ride"] = 241.5, ["Neon|Ride"] = 1026.02, ["Neon|Fly|Ride"] = 821.64, ["Mega"] = 10270.33, ["Mega|Ride"] = 4108.14, ["Mega|Fly|Ride"] = 4081.45}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 70.4, ["Ride"] = 24.94, ["Fly|Ride"] = 61.64, ["Neon"] = 56.56, ["Neon|Fly"] = 294.61, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 513.82, ["Mega|Ride"] = 575.15, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.6, ["Ride"] = 20.99, ["Fly|Ride"] = 86.63, ["Neon"] = 9.01, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 44.17, ["Neon|Fly|Ride"] = 176.77, ["Mega"] = 82.03, ["Mega|Ride"] = 99.38, ["Mega|Fly|Ride"] = 201.31}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 31.85, ["Mega"] = 31.34, ["Mega|Ride"] = 136.4}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.82, ["Fly"] = 52.48, ["Ride"] = 26.25, ["Fly|Ride"] = 206.57, ["Neon"] = 6.18, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 68.16, ["Mega|Fly"] = 154646.92, ["Mega|Ride"] = 96.89, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 66.92, ["Fly"] = 136.88, ["Ride"] = 104.39, ["Fly|Ride"] = 175.9, ["Neon"] = 323.53, ["Neon|Ride"] = 378.11, ["Neon|Fly|Ride"] = 309.74, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 15.65, ["Fly|Ride"] = 93.37, ["Neon"] = 8.24, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 122.75, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 27.75, ["Ride"] = 1050, ["Neon"] = 126.34, ["Neon|Ride"] = 248.07, ["Mega"] = 443.63, ["Mega|Ride"] = 579.94, ["Mega|Fly|Ride"] = 643.97}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.1, ["Neon|Ride"] = 44.49, ["Neon|Fly|Ride"] = 278.25, ["Mega"] = 15.33, ["Mega|Ride"] = 61.64, ["Mega|Fly|Ride"] = 85.32}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 14.6, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.43, ["Neon|Ride"] = 14.12, ["Neon|Fly|Ride"] = 77.17, ["Mega"] = 13.13, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 38.98}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 15.42, ["Fly|Ride"] = 35.43, ["Neon"] = 3.84, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 15.79, ["Neon|Fly|Ride"] = 35.44, ["Mega"] = 28.23, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 27.75, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.64, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 82.18, ["Mega"] = 13.13, ["Mega|Ride"] = 146.15}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 18.38, ["Fly|Ride"] = 107.62, ["Neon"] = 3.94, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 26.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 180.08}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 203.37, ["Mega"] = 76.37, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 154.71}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.94, ["Fly"] = 65.24, ["Ride"] = 19.69, ["Fly|Ride"] = 82.18, ["Neon"] = 10.19, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 23.93, ["Neon|Fly|Ride"] = 74.45, ["Mega"] = 84, ["Mega|Fly"] = 186.24, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.25, ["Neon"] = 2.1, ["Neon|Ride"] = 78.66, ["Neon|Fly|Ride"] = 157.37, ["Mega"] = 14.42, ["Mega|Ride"] = 39.44, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 3.92, ["Fly|Ride"] = 524.99, ["Neon"] = 15.74, ["Mega"] = 137.64, ["Mega|Fly"] = 315, ["Mega|Ride"] = 343.05}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.63, ["Neon"] = 6.18, ["Neon|Ride"] = 26.75, ["Mega"] = 103.69, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 20.16, ["Mega|Ride"] = 54.51, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.36, ["Fly|Ride"] = 30.15, ["Neon"] = 2.1, ["Neon|Fly"] = 33.67, ["Neon|Ride"] = 13.98, ["Neon|Fly|Ride"] = 30.92, ["Mega"] = 14.03, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 59.59}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Neon"] = 31.49, ["Neon|Ride"] = 140.95}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 82.16, ["Neon"] = 3.94, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 26.24, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 130.45}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 6.18, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 82.51, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.62, ["Fly"] = 262.49, ["Ride"] = 32.82, ["Fly|Ride"] = 186.93, ["Neon"] = 15.31, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.29, ["Ride"] = 15.26, ["Fly|Ride"] = 26.17, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 12.78, ["Neon|Fly|Ride"] = 26.24, ["Mega"] = 15.48, ["Mega|Fly"] = 23.64, ["Mega|Ride"] = 22.09, ["Mega|Fly|Ride"] = 45.94}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.46, ["Ride"] = 19.69, ["Fly|Ride"] = 135.59, ["Neon"] = 14.33, ["Neon|Ride"] = 111.37, ["Neon|Fly|Ride"] = 100.67, ["Mega"] = 78.75, ["Mega|Ride"] = 154.16, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 7.48, ["Fly"] = 41.1, ["Ride"] = 32.82, ["Fly|Ride"] = 58.46, ["Neon"] = 72.19, ["Neon|Ride"] = 48.09, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 236.25, ["Mega|Ride"] = 282.72, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 10.5, ["Fly|Ride"] = 26.17, ["Neon"] = 3.92, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 26.72, ["Mega|Fly"] = 155.44, ["Mega|Ride"] = 48.28, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.71, ["Fly"] = 171.53, ["Ride"] = 60.38, ["Neon"] = 7.76, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 38.67, ["Mega|Fly"] = 164.34, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.72, ["Fly|Ride"] = 82.18, ["Neon"] = 5.15, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 309.7, ["Mega"] = 34.93, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.72, ["Neon"] = 2.39, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 96.56, ["Mega"] = 14.43, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 109.05}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.56, ["Ride"] = 19.69, ["Fly|Ride"] = 42, ["Neon"] = 11.51, ["Neon|Fly"] = 52.02, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.77, ["Mega"] = 78.07, ["Mega|Ride"] = 81.38}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.25, ["Neon"] = 3.93, ["Neon|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.77, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 6.56, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 19.84, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 91.87, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 8.64, ["Ride"] = 39.38, ["Neon"] = 36.21, ["Mega"] = 133.88, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 13.13, ["Fly|Ride"] = 82.18, ["Neon"] = 17.07, ["Neon|Fly"] = 104.16, ["Neon|Ride"] = 26.74, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 105, ["Mega|Ride"] = 144.02, ["Mega|Fly|Ride"] = 332.77}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 3.82, ["Fly"] = 22.45, ["Ride"] = 19.53, ["Fly|Ride"] = 36.75, ["Neon"] = 15.65, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 223.13, ["Mega|Fly"] = 40950, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 195.53}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.7, ["Neon"] = 55.1, ["Mega"] = 152.02, ["Mega|Ride"] = 175.64}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 14.44, ["Ride"] = 131.25, ["Neon"] = 120.1, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 309.7, ["Ride"] = 64.89, ["Neon"] = 41.11, ["Neon|Ride"] = 125.71, ["Mega"] = 219.8, ["Mega|Ride"] = 273.67}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.24, ["Ride"] = 34.97, ["Fly|Ride"] = 152.02, ["Neon|Ride"] = 76.02, ["Mega"] = 245.48, ["Mega|Ride"] = 280.23, ["Mega|Fly|Ride"] = 355.04}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.63, ["Neon|Ride"] = 64.98, ["Mega"] = 21, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 143.8}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.94}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 11.71, ["Fly"] = 21.95, ["Ride"] = 17.63, ["Fly|Ride"] = 41.41, ["Neon"] = 74.81, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 102.72, ["Mega"] = 294, ["Mega|Fly"] = 328.67, ["Mega|Ride"] = 514.99, ["Mega|Fly|Ride"] = 252.94}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.54, ["Neon"] = 2.88, ["Neon|Ride"] = 26.25, ["Mega"] = 25.03, ["Mega|Fly"] = 137.64, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 184.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Neon"] = 4.13, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 410.83, ["Mega"] = 51.19, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 5.24, ["Fly"] = 45.94, ["Ride"] = 14.44, ["Fly|Ride"] = 47.25, ["Neon"] = 6.95, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 115.88, ["Mega"] = 125.23, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 9.3, ["Fly|Ride"] = 46.41, ["Neon"] = 32.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 192.07, ["Mega"] = 324.56, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 15.75, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 328.67}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.5, ["Ride"] = 16.05, ["Fly|Ride"] = 273875.53, ["Neon"] = 6.12, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 69.35, ["Mega"] = 26.02, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.47, ["Mega|Fly|Ride"] = 104.89}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.37, ["Ride"] = 15.75, ["Fly|Ride"] = 34.13, ["Neon"] = 7.85, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 36.75, ["Mega|Ride"] = 51.34, ["Mega|Fly|Ride"] = 158.29}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 51.17, ["Fly|Ride"] = 138.04, ["Neon"] = 3.9, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 109.91, ["Mega"] = 23.39, ["Mega|Fly"] = 102.72, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.72, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 122.24, ["Mega"] = 82.18, ["Mega|Fly"] = 106.32, ["Mega|Ride"] = 86.63, ["Mega|Fly|Ride"] = 199.26}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 32.43, ["Ride"] = 18.17, ["Fly|Ride"] = 77.04, ["Neon"] = 3.93, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 32.82, ["Mega|Fly"] = 102.72, ["Mega|Ride"] = 36.14, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.63, ["Mega"] = 21, ["Mega|Ride"] = 123.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.39, ["Neon"] = 3.34, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 420, ["Mega"] = 20.56, ["Mega|Ride"] = 122.24}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.03, ["Fly|Ride"] = 26.25, ["Neon"] = 4.03, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 55.47, ["Mega|Ride"] = 52.39}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 15.64, ["Ride"] = 137.54, ["Neon"] = 512.51, ["Neon|Fly|Ride"] = 256.34, ["Mega"] = 545.36, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 3.94, ["Fly"] = 6562.5, ["Ride"] = 68.25, ["Neon"] = 49.26, ["Neon|Ride"] = 203.37, ["Mega"] = 1564.18, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 7.55, ["Ride"] = 26.24, ["Fly|Ride"] = 410.83, ["Neon"] = 34.79, ["Mega"] = 152.02, ["Mega|Ride"] = 260.88, ["Mega|Fly|Ride"] = 365.3}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 11.82, ["Ride"] = 12.85, ["Fly|Ride"] = 23.63, ["Neon"] = 2.1, ["Neon|Fly"] = 11.82, ["Neon|Ride"] = 14.3, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.44, ["Mega|Fly"] = 32.52, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 65.63, ["Neon"] = 15.75, ["Neon|Fly"] = 89.46, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 685.05, ["Mega"] = 85.31, ["Mega|Ride"] = 114.02, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 30.82, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 15.74, ["Mega|Fly"] = 82.32, ["Mega|Fly|Ride"] = 103.68}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 91.65, ["Neon"] = 3.29, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 103.32, ["Mega"] = 19.34, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 152.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19.19, ["Fly|Ride"] = 45.91, ["Neon"] = 9.31, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 183.75, ["Mega|Ride"] = 190.13, ["Mega|Fly|Ride"] = 347.97}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 203.44, ["Ride"] = 262.5, ["Fly|Ride"] = 821.64, ["Neon"] = 1050, ["Neon|Ride"] = 821.64, ["Mega"] = 8216.28, ["Mega|Fly|Ride"] = 3403.6}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.63, ["Ride"] = 27.75, ["Neon"] = 8.51, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 68.25, ["Mega"] = 61.68, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 6.49, ["Fly"] = 62.39, ["Ride"] = 19.69, ["Neon"] = 26.72, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 155.1, ["Mega"] = 350.83, ["Mega|Fly|Ride"] = 397.48}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.68, ["Ride"] = 14.73, ["Fly|Ride"] = 30.19, ["Neon"] = 7.88, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 55.62, ["Mega"] = 49.66, ["Mega|Ride"] = 78.16, ["Mega|Fly|Ride"] = 170.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 65.63, ["Neon"] = 5.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.82, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.13, ["Fly"] = 17.75, ["Ride"] = 15.75, ["Fly|Ride"] = 35.42, ["Neon"] = 22.61, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 52.5, ["Mega|Ride"] = 260.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.67, ["Ride"] = 26.25, ["Fly|Ride"] = 249.58, ["Neon"] = 45.94, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 610.08, ["Mega"] = 155.44, ["Mega|Ride"] = 306.08, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.56, ["Fly"] = 15.42, ["Ride"] = 15.16, ["Fly|Ride"] = 31.18, ["Neon"] = 18.17, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 73.32, ["Mega|Fly|Ride"] = 201.71}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 74.25, ["Fly"] = 164.34, ["Ride"] = 102.38, ["Fly|Ride"] = 150.94, ["Neon"] = 433.8, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 405.57, ["Neon|Fly|Ride"] = 398.74, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.88, ["Fly"] = 328.67, ["Ride"] = 230.85, ["Fly|Ride"] = 289.98, ["Neon"] = 927.89, ["Neon|Ride"] = 1437.86, ["Neon|Fly|Ride"] = 959.26, ["Mega"] = 10270.33, ["Mega|Fly|Ride"] = 3593.6}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 67.16, ["Fly"] = 137.62, ["Ride"] = 77.73, ["Fly|Ride"] = 135.59, ["Neon"] = 410.83, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 352.92, ["Mega|Fly|Ride"] = 1816.33}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.76, ["Fly"] = 26.25, ["Ride"] = 26.16, ["Fly|Ride"] = 137.64, ["Neon"] = 24.93, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 274.23, ["Mega|Ride"] = 374.06, ["Mega|Fly|Ride"] = 504.29}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.39, ["Fly"] = 68.82, ["Ride"] = 15.42, ["Fly|Ride"] = 82.18, ["Neon"] = 31.5, ["Neon|Ride"] = 135.59, ["Neon|Fly|Ride"] = 178.71, ["Mega"] = 326.62, ["Mega|Ride"] = 364.53, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.38, ["Fly|Ride"] = 40.07, ["Neon"] = 2.63, ["Neon|Fly"] = 70.85, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 87.94, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 176.67}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.25, ["Fly"] = 27.75, ["Ride"] = 27.75, ["Fly|Ride"] = 300.03, ["Neon"] = 55.47, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 904.82, ["Mega|Ride"] = 612.12, ["Mega|Fly|Ride"] = 864.94}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 5.25, ["Fly|Ride"] = 55.47, ["Neon"] = 13.13, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 131.25, ["Mega|Ride"] = 200.79, ["Mega|Fly|Ride"] = 201.84}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 23.22, ["Fly|Ride"] = 328.13, ["Neon"] = 29.8, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 155.44, ["Mega"] = 207.37, ["Mega|Ride"] = 192.07, ["Mega|Fly|Ride"] = 371.98}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 35.96, ["Neon"] = 2.1, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 15.75, ["Mega|Ride"] = 50.34, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.74, ["Fly"] = 19.59, ["Ride"] = 17.75, ["Fly|Ride"] = 39.38, ["Neon"] = 12.9, ["Neon|Fly"] = 102.72, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.75, ["Mega|Ride"] = 107.98, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.39, ["Fly"] = 19.69, ["Ride"] = 18.48, ["Fly|Ride"] = 45.94, ["Neon"] = 24.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 109.91, ["Mega"] = 283.5, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 159.15, ["Fly"] = 231.98, ["Ride"] = 183.75, ["Fly|Ride"] = 225.75, ["Neon"] = 792.19, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 720.57, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.8, ["Ride"] = 23.63, ["Fly|Ride"] = 204.39, ["Neon"] = 96.56, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 343.05, ["Mega|Ride"] = 322.45, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.62, ["Fly"] = 15.42, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 30.17, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 288.75, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 16.46, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 120.44, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 441.27, ["Mega"] = 453.14, ["Mega|Fly"] = 821.64, ["Mega|Ride"] = 469.88, ["Mega|Fly|Ride"] = 707.52}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.97}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.27, ["Ride"] = 25.54, ["Neon"] = 25.31, ["Neon|Ride"] = 274.23, ["Neon|Fly|Ride"] = 616.23, ["Mega"] = 385.16, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 819.59}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 30.19, ["Fly"] = 77.45, ["Ride"] = 30.81, ["Fly|Ride"] = 56.43, ["Neon"] = 178.71, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.8, ["Mega"] = 2054.08, ["Mega|Fly|Ride"] = 1367}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 5.25, ["Fly|Ride"] = 78.75, ["Neon"] = 3.84, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 106.24, ["Mega"] = 31.95, ["Mega|Ride"] = 68.86, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.2, ["Fly"] = 27.69, ["Ride"] = 26.7, ["Fly|Ride"] = 61.64, ["Neon"] = 45.34, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 34.93, ["Mega"] = 231.48, ["Mega|Fly"] = 387.4, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 11.31, ["Fly|Ride"] = 39.44, ["Neon"] = 11.68, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.65, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 136.43, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 204.39}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.96, ["Neon"] = 3.74, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 410.83, ["Mega"] = 30.18, ["Mega|Ride"] = 82.36, ["Mega|Fly|Ride"] = 197.21}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 34.09, ["Ride"] = 104.77, ["Fly|Ride"] = 133.6, ["Neon"] = 250.62, ["Neon|Ride"] = 294.61, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 791.99, ["Mega|Ride"] = 1035.26, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.94, ["Ride"] = 52.5, ["Fly|Ride"] = 210, ["Neon"] = 80.07, ["Neon|Ride"] = 101.7, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 7.56, ["Fly"] = 96.96, ["Ride"] = 23.22, ["Fly|Ride"] = 62.48, ["Neon"] = 62.96, ["Neon|Fly"] = 463.96, ["Neon|Ride"] = 103.01, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 410.83, ["Mega|Ride"] = 315.31, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 52.5, ["Fly"] = 433.13, ["Ride"] = 131.25, ["Fly|Ride"] = 262.44, ["Neon"] = 434.97, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 685.05, ["Mega"] = 1739.81, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1641.21}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 10.21, ["Fly"] = 45.94, ["Ride"] = 27.61, ["Fly|Ride"] = 61.64, ["Neon"] = 48.56, ["Neon|Ride"] = 44.18, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 209.9, ["Mega|Ride"] = 240.55, ["Mega|Fly|Ride"] = 368.02}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 94.5, ["Fly"] = 143.07, ["Ride"] = 104.19, ["Fly|Ride"] = 155.44, ["Neon"] = 183.75, ["Neon|Fly"] = 498.75, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1010.63, ["Mega|Ride"] = 985.97, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.68, ["Ride"] = 55.71, ["Fly|Ride"] = 131.24, ["Neon"] = 82.67, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 263.3, ["Mega"] = 343.88, ["Mega|Ride"] = 301.46, ["Mega|Fly|Ride"] = 408.77}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 10, ["Ride"] = 27.56, ["Fly|Ride"] = 41.1, ["Neon"] = 105.52, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 368.85, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.24, ["Ride"] = 62.56, ["Fly|Ride"] = 154.76, ["Neon"] = 90.55, ["Neon|Ride"] = 129.75, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 255.2, ["Mega|Fly"] = 496.08, ["Mega|Ride"] = 307.02, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 11.05, ["Ride"] = 26.25, ["Fly|Ride"] = 135.59, ["Neon"] = 58.01, ["Neon|Ride"] = 97.44, ["Neon|Fly|Ride"] = 160.23, ["Mega"] = 411.89, ["Mega|Ride"] = 301.97, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 53.42, ["Neon|Ride"] = 56.35, ["Mega"] = 18.38, ["Mega|Fly"] = 137.64, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.71, ["Ride"] = 27.26, ["Neon"] = 18.76, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.82, ["Mega|Ride"] = 160.23, ["Mega|Fly|Ride"] = 260.88}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.62, ["Fly"] = 46.41, ["Neon"] = 23.63, ["Mega"] = 183.27, ["Mega|Ride"] = 137.64}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 10.5, ["Ride"] = 32.79, ["Fly|Ride"] = 114.84, ["Neon"] = 17.77, ["Neon|Ride"] = 82.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 199.26, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 558.72, ["Ride"] = 576.18, ["Fly|Ride"] = 616.88, ["Neon"] = 1702.84, ["Neon|Fly"] = 1797.78, ["Neon|Ride"] = 1498.29, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5890.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.79, ["Fly"] = 27.75, ["Ride"] = 23.22, ["Fly|Ride"] = 59.59, ["Neon"] = 26.25, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 369.74, ["Mega|Fly|Ride"] = 482.51}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 8.58, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 54.53, ["Mega"] = 274.23, ["Mega|Ride"] = 303.8, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.4, ["Ride"] = 17.07, ["Fly|Ride"] = 308.13, ["Neon|Ride"] = 101.7, ["Mega"] = 252.86, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 24.35, ["Fly|Ride"] = 90.57, ["Neon"] = 9.02, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 67.92, ["Mega|Ride"] = 109.51, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 18.5, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 72.93, ["Mega"] = 23.36, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.75}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.23, ["Ride"] = 41.1, ["Fly|Ride"] = 68.82, ["Neon"] = 65.63, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 178.71, ["Mega"] = 397.48, ["Mega|Ride"] = 384.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.15, ["Neon|Ride"] = 40.69, ["Mega"] = 38.75, ["Mega|Ride"] = 154.07, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.63, ["Fly"] = 27.57, ["Ride"] = 58.49, ["Neon"] = 7.88, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 109.78, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 152.02, ["Mega|Ride"] = 250.62, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 459.38, ["Ride"] = 480.18, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1311.18, ["Neon|Fly|Ride"] = 1254.88, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.82, ["Fly"] = 196.88, ["Fly|Ride"] = 410.83, ["Neon"] = 109.91, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 468.34, ["Mega|Ride"] = 440.76}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.75, ["Fly|Ride"] = 152.02, ["Neon"] = 5.87, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 93.2, ["Mega"] = 40.68, ["Mega|Fly"] = 189, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 821.64, ["Neon"] = 3.94, ["Neon|Ride"] = 109.85, ["Neon|Fly|Ride"] = 260.88, ["Mega"] = 23.49, ["Mega|Ride"] = 113.67, ["Mega|Fly|Ride"] = 217.74}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.67, ["Fly"] = 107.63, ["Ride"] = 52.5, ["Fly|Ride"] = 178.5, ["Neon"] = 101.74, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 328.67, ["Mega"] = 448.87, ["Mega|Ride"] = 397.48, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Neon"] = 109.05, ["Neon|Ride"] = 123.26, ["Neon|Fly|Ride"] = 199.52, ["Mega"] = 410.83, ["Mega|Ride"] = 482.34, ["Mega|Fly|Ride"] = 1095.87}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.18, ["Fly|Ride"] = 137.64, ["Neon"] = 27.75, ["Neon|Ride"] = 175.16, ["Mega"] = 634.46, ["Mega|Ride"] = 959.04, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 12.81, ["Ride"] = 26.72, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 524.99, ["Mega|Ride"] = 616.23, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Ride"] = 426.23, ["Fly|Ride"] = 616.23, ["Neon"] = 1641.21, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.11, ["Mega|Fly|Ride"] = 3835.98}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.18, ["Fly"] = 69.65, ["Ride"] = 23.63, ["Fly|Ride"] = 96.56, ["Neon"] = 106.01, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 158.18, ["Mega"] = 684.03, ["Mega|Ride"] = 408.77, ["Mega|Fly|Ride"] = 846.28}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 6.18, ["Fly|Ride"] = 78.75, ["Neon"] = 35.17, ["Neon|Ride"] = 221.82, ["Mega"] = 131.25, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 773.63}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 14.86, ["Ride"] = 80.13, ["Fly|Ride"] = 256.34, ["Neon"] = 42, ["Neon|Ride"] = 110.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 272.35, ["Mega|Fly"] = 685.05, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 340.66}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.35, ["Fly"] = 40.61, ["Ride"] = 52.5, ["Fly|Ride"] = 137.64, ["Neon"] = 6.35, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 44.62, ["Mega|Fly"] = 105, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 38.07, ["Ride"] = 71.91, ["Fly|Ride"] = 157.5, ["Neon"] = 307.1, ["Neon|Ride"] = 302.99, ["Neon|Fly|Ride"] = 462.18, ["Mega"] = 1780.89, ["Mega|Ride"] = 1287.91, ["Mega|Fly|Ride"] = 813.74}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 28.25, ["Neon"] = 10.5, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 65.75, ["Mega|Ride"] = 101.07, ["Mega|Fly|Ride"] = 185.1}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 27.75, ["Fly|Ride"] = 148.25, ["Neon"] = 4.6, ["Neon|Fly"] = 68.45, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 131.48, ["Mega"] = 40.28, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 206.47}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.24, ["Fly"] = 1519.88, ["Ride"] = 5.25, ["Fly|Ride"] = 123.26, ["Neon"] = 11.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 78.75, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 59.75, ["Ride"] = 78.74, ["Neon"] = 291.38, ["Neon|Ride"] = 509.25, ["Neon|Fly|Ride"] = 615.21, ["Mega|Ride"] = 1027.05, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 301.58, ["Ride"] = 309.74, ["Fly|Ride"] = 393.75, ["Neon"] = 1427.58, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6162.21, ["Mega|Fly|Ride"] = 5188.58}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.2, ["Fly|Ride"] = 184.25, ["Neon"] = 36.82, ["Mega"] = 102.01, ["Mega|Ride"] = 181.22, ["Mega|Fly|Ride"] = 306.08}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.94, ["Ride"] = 26.25, ["Neon"] = 19.69, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 123.26, ["Mega"] = 56.23, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 335.85}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.49, ["Fly"] = 30.17, ["Ride"] = 27.56, ["Fly|Ride"] = 174.61, ["Neon"] = 36.75, ["Mega|Ride"] = 341.29, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.94, ["Fly"] = 58.92, ["Ride"] = 48.2, ["Neon"] = 7.77, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 84.36, ["Mega|Fly"] = 145.85, ["Mega|Ride"] = 107.52, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 57.53, ["Neon"] = 9, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 271.16}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 13.13, ["Fly|Ride"] = 41.99, ["Neon"] = 6.19, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 97.59, ["Mega"] = 96.56, ["Mega|Ride"] = 73.96, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.64, ["Ride"] = 20.56, ["Fly|Ride"] = 54.49, ["Neon"] = 8.97, ["Neon|Fly"] = 62.39, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 63.37, ["Mega"] = 123.26, ["Mega|Ride"] = 231.1, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 43.24, ["Ride"] = 52.42, ["Fly|Ride"] = 77.16, ["Neon"] = 274.23, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 574.12, ["Mega|Ride"] = 451.9, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 121.21, ["Fly"] = 123.26, ["Ride"] = 78.75, ["Fly|Ride"] = 309.7, ["Neon"] = 410.83, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 460.87, ["Mega"] = 1470, ["Mega|Ride"] = 1505.64, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.8, ["Ride"] = 17.85, ["Fly|Ride"] = 131.25, ["Neon"] = 5.66, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 38.75, ["Mega|Fly"] = 672, ["Mega|Ride"] = 65.49, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 16.45, ["Ride"] = 15.72, ["Fly|Ride"] = 36.66, ["Neon"] = 3.94, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.52, ["Neon|Fly|Ride"] = 55.47, ["Mega"] = 51.85, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Ride"] = 73.48, ["Fly|Ride"] = 131.25, ["Neon"] = 246.51, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 273.2, ["Mega"] = 267.05, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 376.82, ["Fly"] = 393.75, ["Ride"] = 541.26, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1780.89, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 6804.82}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 31.28, ["Fly"] = 93.89, ["Ride"] = 52.5, ["Fly|Ride"] = 124.11, ["Neon"] = 272.57, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 305.78, ["Mega|Ride"] = 1054.77, ["Mega|Fly|Ride"] = 944.98}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.28, ["Neon"] = 10.5, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 89.15, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 205.42, ["Ride"] = 65.63, ["Fly|Ride"] = 142.7, ["Neon"] = 20.56}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.57, ["Fly"] = 76.02, ["Ride"] = 43.28, ["Fly|Ride"] = 82.18, ["Neon|Ride"] = 231.98, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2464.89, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1237.58}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 65.63, ["Fly|Ride"] = 152.02, ["Neon"] = 544.66, ["Neon|Ride"] = 468.34, ["Neon|Fly|Ride"] = 478.62, ["Mega"] = 8216.28, ["Mega|Fly|Ride"] = 1869.21}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 195.56, ["Fly"] = 307.1, ["Ride"] = 279.56, ["Fly|Ride"] = 503.4, ["Neon"] = 821.64, ["Neon|Ride"] = 890.46, ["Neon|Fly|Ride"] = 1095.87, ["Mega|Fly|Ride"] = 3379.99}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.08, ["Ride"] = 53.38, ["Fly|Ride"] = 150.94, ["Neon"] = 73.5, ["Neon|Ride"] = 119.17, ["Neon|Fly|Ride"] = 223.91, ["Mega"] = 384.06, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 418.24}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 14.49, ["Fly|Ride"] = 40.62, ["Neon"] = 7.55, ["Neon|Ride"] = 21.62, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.18, ["Fly"] = 19.69, ["Ride"] = 13.13, ["Fly|Ride"] = 51.36, ["Neon"] = 29.09, ["Neon|Fly"] = 143.8, ["Neon|Ride"] = 39.71, ["Neon|Fly|Ride"] = 118.32, ["Mega"] = 328.67, ["Mega|Ride"] = 291.61, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Fly"] = 479.64, ["Ride"] = 326.82, ["Fly|Ride"] = 410.83, ["Neon"] = 1312.5, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1649.82, ["Mega|Fly|Ride"] = 5722.69}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 19.53, ["Neon"] = 9.19, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 45.66, ["Mega|Ride"] = 233.16}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 4.13, ["Ride"] = 14.44, ["Fly|Ride"] = 45.85, ["Neon"] = 21.19, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 155.44, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 185.59, ["Mega|Fly|Ride"] = 246.51}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.99, ["Ride"] = 111.57, ["Neon"] = 98.44, ["Neon|Fly"] = 410.83, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 387.4, ["Mega"] = 476.83, ["Mega|Ride"] = 545.36, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 109.91, ["Fly"] = 157.5, ["Ride"] = 133.53, ["Fly|Ride"] = 154.88, ["Neon|Ride"] = 695.92, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.64, ["Fly"] = 48.28, ["Ride"] = 27.56, ["Fly|Ride"] = 63, ["Neon"] = 85.32, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 187.34, ["Mega"] = 630.61, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 2.5, ["Neon|Ride"] = 309.7, ["Neon|Fly|Ride"] = 685.05, ["Mega"] = 20.79, ["Mega|Ride"] = 273.2, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 52.5, ["Neon"] = 2.6, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 24.93, ["Mega|Fly"] = 87.01, ["Mega|Ride"] = 51.19, ["Mega|Fly|Ride"] = 117.1}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 10.48, ["Fly"] = 410.83, ["Ride"] = 68.16, ["Fly|Ride"] = 164.34, ["Neon"] = 31.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 137.64, ["Mega|Fly"] = 274.23, ["Mega|Ride"] = 188.98, ["Mega|Fly|Ride"] = 324.16}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1434.57, ["Ride"] = 1310.15, ["Fly|Ride"] = 1296.75, ["Neon"] = 4200, ["Neon|Ride"] = 3675, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11353.13}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 419.99, ["Ride"] = 459.38, ["Fly|Ride"] = 505.32, ["Neon"] = 1780.89, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1857.21, ["Mega"] = 16432.53, ["Mega|Fly|Ride"] = 7086.19}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 309.75, ["Ride"] = 364.88, ["Fly|Ride"] = 406.88, ["Neon"] = 654.78, ["Neon|Fly"] = 1237.58, ["Neon|Ride"] = 643.1, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 288.75, ["Fly"] = 413.22, ["Ride"] = 342.89, ["Fly|Ride"] = 417.56, ["Neon"] = 1232.45, ["Neon|Fly"] = 1370.08, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1044.74, ["Mega|Fly|Ride"] = 4616.52}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.27, ["Fly|Ride"] = 31.5, ["Neon"] = 5.78, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.18, ["Mega"] = 72.93, ["Mega|Ride"] = 108.86, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 406.88, ["Ride"] = 508.39, ["Fly|Ride"] = 577.5, ["Neon"] = 1680, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1918.4, ["Mega|Ride"] = 5722.69, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.6, ["Fly"] = 183.75, ["Ride"] = 112.53, ["Neon"] = 10.4, ["Neon|Ride"] = 64.72, ["Neon|Fly|Ride"] = 155.81, ["Mega"] = 74.82, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 271.16}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.72, ["Ride"] = 20.56, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 39.37, ["Mega"] = 21, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 67.8, ["Ride"] = 109.22, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 420, ["Mega|Ride"] = 927.89}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7732.72, ["Ride"] = 21, ["Fly|Ride"] = 60.44, ["Neon"] = 26.37, ["Neon|Ride"] = 77.73, ["Mega"] = 328.13, ["Mega|Ride"] = 302.99, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 35.11, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 39.38, ["Mega|Ride"] = 155.3, ["Mega|Fly|Ride"] = 114.02}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.93, ["Fly"] = 36.01, ["Ride"] = 22.61, ["Fly|Ride"] = 62.65, ["Neon"] = 8.06, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 82.67, ["Mega"] = 78.75, ["Mega|Fly"] = 171.53, ["Mega|Ride"] = 116.58, ["Mega|Fly|Ride"] = 191.05}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.15, ["Fly"] = 55.47, ["Ride"] = 27.75, ["Fly|Ride"] = 51.45, ["Neon"] = 27.57, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 245.48, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.31, ["Ride"] = 53.82, ["Neon"] = 56.44, ["Neon|Fly|Ride"] = 263.3, ["Mega"] = 369.74, ["Mega|Ride"] = 445.75, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 6.98, ["Fly"] = 6186.64, ["Ride"] = 26.72, ["Neon"] = 26.25, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 10.49, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 5.44, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 15.42, ["Mega"] = 80.13, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 188.99, ["Fly"] = 274.23, ["Ride"] = 224.68, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 1026.02, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 8216.28, ["Mega|Fly|Ride"] = 4198.58}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.02, ["Ride"] = 14.44, ["Fly|Ride"] = 31.85, ["Neon"] = 3.93, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 18.27, ["Neon|Fly|Ride"] = 45.93, ["Mega"] = 31.34, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 15.42, ["Ride"] = 69.46, ["Fly|Ride"] = 183.73, ["Neon"] = 79.52, ["Neon|Ride"] = 100.66, ["Mega"] = 459.25, ["Mega|Ride"] = 397.48, ["Mega|Fly|Ride"] = 520.72}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.57, ["Fly"] = 210, ["Ride"] = 93.17, ["Fly|Ride"] = 167.23, ["Neon"] = 199.52, ["Neon|Ride"] = 272.57, ["Mega"] = 821.64, ["Mega|Ride"] = 849.36}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 209.87, ["Ride"] = 236.14, ["Fly|Ride"] = 315, ["Neon"] = 708.73, ["Neon|Fly"] = 1159.87, ["Neon|Ride"] = 790.82, ["Neon|Fly|Ride"] = 740.64, ["Mega|Fly|Ride"] = 3018.65}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.12, ["Fly"] = 168.88, ["Ride"] = 37.43, ["Fly|Ride"] = 139.2, ["Neon"] = 116.07, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 119.6, ["Fly|Ride"] = 525, ["Neon"] = 135.97, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 262.94, ["Mega"] = 463.68, ["Mega|Ride"] = 513.54, ["Mega|Fly|Ride"] = 928.46}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1139.73, ["Fly"] = 1440.94, ["Ride"] = 1132.41, ["Fly|Ride"] = 1165.5, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 4415.25, ["Mega|Fly|Ride"] = 16978.9}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 15.3, ["Fly"] = 29.4, ["Ride"] = 19.55, ["Fly|Ride"] = 42, ["Neon"] = 44.18, ["Neon|Fly"] = 79.91, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 270.13, ["Mega|Ride"] = 229.05, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 8, ["Fly"] = 65.63, ["Ride"] = 41.1, ["Neon"] = 30.24, ["Neon|Ride"] = 91.65, ["Mega"] = 218.28, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 238.88, ["Mega|Fly|Ride"] = 260.88}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.15, ["Ride"] = 22.08, ["Fly|Ride"] = 69.57, ["Neon"] = 15.41, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 39.04, ["Mega"] = 90.57, ["Mega|Ride"] = 136.89, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.13, ["Fly"] = 55.47, ["Ride"] = 37.24, ["Fly|Ride"] = 72.93, ["Neon"] = 66.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.62, ["Fly"] = 21, ["Ride"] = 18.47, ["Fly|Ride"] = 31.38, ["Neon"] = 23.35, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 88.69, ["Mega"] = 147.91, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 19.53, ["Neon"] = 10.5, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 821.64, ["Mega"] = 105, ["Mega|Fly"] = 274.23, ["Mega|Ride"] = 192.07}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.2, ["Fly"] = 259.27, ["Ride"] = 417.56, ["Fly|Ride"] = 548.45, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 25.46, ["Ride"] = 18.38, ["Fly|Ride"] = 48.57, ["Neon"] = 9.28, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 119.84, ["Mega"] = 78.75, ["Mega|Ride"] = 109.48, ["Mega|Fly|Ride"] = 242.01}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.21, ["Ride"] = 27.75, ["Fly|Ride"] = 88.87, ["Neon"] = 77.42, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 328.67, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.2, ["Fly"] = 91.25, ["Ride"] = 26.17, ["Neon"] = 11.71, ["Neon|Ride"] = 83.16, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 85.32, ["Mega|Fly"] = 137.64, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 356.09}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 308.13, ["Ride"] = 308.13, ["Fly|Ride"] = 1036.23, ["Neon"] = 851.34, ["Neon|Ride"] = 816.38, ["Neon|Fly|Ride"] = 1129.74, ["Mega"] = 4639.4, ["Mega|Ride"] = 3080.09, ["Mega|Fly|Ride"] = 2789.41}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.35, ["Fly"] = 57.69, ["Ride"] = 147.91, ["Fly|Ride"] = 131.25, ["Neon"] = 122.24, ["Neon|Ride"] = 178.71, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 721, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.08, ["Ride"] = 26.25, ["Fly|Ride"] = 137.64, ["Neon"] = 78.66, ["Neon|Ride"] = 123.26, ["Neon|Fly|Ride"] = 257.8, ["Mega"] = 486.83, ["Mega|Ride"] = 495.83, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 60.38, ["Fly"] = 87.47, ["Ride"] = 79.8, ["Fly|Ride"] = 155.92, ["Neon"] = 262.48, ["Neon|Fly"] = 303.14, ["Neon|Ride"] = 275.98, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 1061.24}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 5.25, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 588, ["Mega"] = 47.84, ["Mega|Fly|Ride"] = 409.8}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.05, ["Fly"] = 124.11, ["Ride"] = 30.82, ["Fly|Ride"] = 71.99, ["Neon"] = 52.5, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 246.51, ["Mega"] = 274.23, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.63, ["Fly"] = 110.06, ["Ride"] = 75.94, ["Fly|Ride"] = 91.88, ["Neon"] = 182.6, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 355.37, ["Mega|Ride"] = 1313.59, ["Mega|Fly|Ride"] = 1134.7}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 13.8, ["Fly|Ride"] = 35.42, ["Neon"] = 2.1, ["Neon|Fly"] = 23.97, ["Neon|Ride"] = 16.45, ["Neon|Fly|Ride"] = 40.51, ["Mega"] = 18.37, ["Mega|Fly"] = 116, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 90.4}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.93, ["Fly"] = 32.82, ["Ride"] = 34.93, ["Fly|Ride"] = 131.25, ["Neon"] = 14, ["Neon|Ride"] = 59.59, ["Neon|Fly|Ride"] = 168, ["Mega"] = 157.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.74, ["Fly"] = 137.64, ["Ride"] = 41.28, ["Fly|Ride"] = 62.65, ["Neon"] = 137.64, ["Neon|Ride"] = 133.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 545.36, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 811.36}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 20.64, ["Mega|Ride"] = 48.28, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 14.42, ["Fly"] = 210, ["Ride"] = 53.82, ["Fly|Ride"] = 124.11, ["Neon"] = 87.77, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 185.59, ["Mega"] = 548.45, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 343.05}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 27.75, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 223.91, ["Neon|Ride"] = 118.78, ["Neon|Fly|Ride"] = 117.1, ["Mega"] = 431.37, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 433.8}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.84, ["Ride"] = 52.5, ["Neon"] = 25.99, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 68.98, ["Mega"] = 131.25, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 371.17}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 170.62, ["Fly"] = 2054.08, ["Ride"] = 66.92, ["Neon"] = 61.64, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 6185.48, ["Mega"] = 295.32, ["Mega|Ride"] = 544.69}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.58, ["Fly"] = 41.1, ["Ride"] = 20.56, ["Fly|Ride"] = 196.87, ["Neon"] = 5.92, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 26.25, ["Mega"] = 65.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.64}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 68.82, ["Neon"] = 5.24, ["Neon|Ride"] = 89.17, ["Mega"] = 30.19, ["Mega|Ride"] = 161.23, ["Mega|Fly|Ride"] = 215.06}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 58.55}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 45.94, ["Fly"] = 78.75, ["Ride"] = 70.88, ["Neon"] = 178.71, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1224.23, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.87}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Mega"] = 22.31, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 308.13}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 388.5, ["Fly"] = 560.77, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 3018.75, ["Neon|Fly|Ride"] = 3080.09, ["Mega"] = 16432.53, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.55, ["Fly"] = 25.99, ["Ride"] = 39.37, ["Fly|Ride"] = 66.26, ["Neon"] = 25.1, ["Neon|Ride"] = 274.23, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 68.82, ["Mega|Fly"] = 147.91, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 548.45}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.49, ["Fly"] = 26.25, ["Ride"] = 21.17, ["Fly|Ride"] = 63, ["Neon"] = 16.21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 162.28, ["Mega|Ride"] = 175.64, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 14.44, ["Fly"] = 77.04, ["Ride"] = 69.61, ["Fly|Ride"] = 106.32, ["Neon"] = 68.25, ["Neon|Ride"] = 179.8, ["Mega"] = 512.51, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 570.02}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.38, ["Fly"] = 315.31, ["Ride"] = 32.16, ["Fly|Ride"] = 721.88, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 13.94, ["Fly"] = 139.53, ["Ride"] = 105, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 102.72, ["Neon|Fly|Ride"] = 369.74, ["Mega"] = 262.5, ["Mega|Ride"] = 400.98, ["Mega|Fly|Ride"] = 466.29}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.65, ["Fly"] = 104.99, ["Ride"] = 32.82, ["Fly|Ride"] = 184.88, ["Neon"] = 55.47, ["Neon|Ride"] = 100.66, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 216.56, ["Mega|Fly"] = 478.62, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 356.4}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.31, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.26, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 13.86, ["Mega|Fly"] = 61.64, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.65, ["Fly"] = 274.23, ["Ride"] = 27.57, ["Fly|Ride"] = 48.28, ["Neon"] = 31.34, ["Neon|Ride"] = 68.82, ["Neon|Fly|Ride"] = 110.2, ["Mega"] = 194.25, ["Mega|Fly"] = 204.39, ["Mega|Ride"] = 205.42, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 261.19, ["Fly"] = 298.86, ["Ride"] = 328.12, ["Fly|Ride"] = 421.31, ["Neon"] = 1450.18, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1047.38, ["Mega|Fly|Ride"] = 4201.6}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 87.94, ["Ride"] = 168.45, ["Fly|Ride"] = 294.61, ["Neon"] = 315, ["Neon|Ride"] = 380.63, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4108.14, ["Mega|Ride"] = 1431.69, ["Mega|Fly|Ride"] = 1547.25}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.44, ["Fly|Ride"] = 28.51, ["Neon"] = 15.42, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 137.64, ["Mega|Fly"] = 204.39, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 205.83}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 14.43, ["Fly|Ride"] = 31.28, ["Neon"] = 6.57, ["Neon|Fly"] = 39.14, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 67.9, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 155.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Mega"] = 137.64, ["Mega|Ride"] = 246.51, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 296.21, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 1231.43, ["Neon|Fly|Ride"] = 1301.26, ["Mega|Ride"] = 8216.28, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.78, ["Fly"] = 23.63, ["Ride"] = 10.5, ["Fly|Ride"] = 21, ["Neon"] = 21.17, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 101, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.18, ["Fly"] = 155.44, ["Ride"] = 98.44, ["Fly|Ride"] = 205.42, ["Neon"] = 19.53, ["Neon|Ride"] = 139.13, ["Mega"] = 246.51, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 60.61, ["Mega|Ride"] = 109.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 35.96, ["Ride"] = 26.25, ["Fly|Ride"] = 57.23, ["Neon"] = 78.75, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 728.44, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 54.98, ["Fly"] = 155.44, ["Ride"] = 92.16, ["Fly|Ride"] = 196.88, ["Neon"] = 115.5, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 202.4, ["Neon|Fly|Ride"] = 379.19, ["Mega"] = 420, ["Mega|Fly"] = 2156.79, ["Mega|Ride"] = 454.13, ["Mega|Fly|Ride"] = 618.16}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.14, ["Fly"] = 68.82, ["Ride"] = 48.09, ["Fly|Ride"] = 100.08, ["Neon"] = 146.15, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 185.88, ["Neon|Fly|Ride"] = 197.38, ["Mega|Ride"] = 739.48, ["Mega|Fly|Ride"] = 927.89}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.05, ["Ride"] = 14.89, ["Fly|Ride"] = 27.57, ["Neon"] = 2.1, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 15.42, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 18.38, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 43.15, ["Mega|Fly|Ride"] = 106.82}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.36, ["Ride"] = 285.89, ["Fly|Ride"] = 306.44, ["Neon"] = 1095.87, ["Neon|Ride"] = 856.56, ["Neon|Fly|Ride"] = 1018.32, ["Mega|Fly|Ride"] = 4313.55}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.97, ["Fly"] = 82.18, ["Ride"] = 55.47, ["Fly|Ride"] = 130.45, ["Neon"] = 96.56, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 410.83, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 29.14, ["Ride"] = 15.6, ["Fly|Ride"] = 26.25, ["Neon"] = 10.47, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 108.88, ["Mega"] = 59.16, ["Mega|Fly"] = 274.23, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 109.05}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 18.5, ["Fly|Ride"] = 43.72, ["Neon"] = 2.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 102.72, ["Mega"] = 24.92, ["Mega|Fly"] = 137.64, ["Mega|Ride"] = 46.27, ["Mega|Fly|Ride"] = 179.74}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 69.28, ["Neon"] = 9.37, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 6847.23, ["Mega"] = 78.75, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.55, ["Fly"] = 38.74, ["Ride"] = 24.94, ["Fly|Ride"] = 70.5, ["Neon"] = 49.26, ["Neon|Fly"] = 260.88, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 416.4, ["Mega|Ride"] = 315.15, ["Mega|Fly|Ride"] = 383.43}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.38, ["Fly"] = 55.47, ["Ride"] = 39.38, ["Fly|Ride"] = 72.19, ["Neon"] = 52.5, ["Neon|Ride"] = 135.59, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 267.05, ["Mega|Ride"] = 343.05, ["Mega|Fly|Ride"] = 371.17}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.89, ["Neon|Ride"] = 41.66, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 18.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 9.06, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 34.93, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 135.33, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 297.85}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 111.99, ["Neon"] = 3.9, ["Neon|Fly"] = 96.56, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.93, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 38.83, ["Ride"] = 22.28, ["Fly|Ride"] = 61.85, ["Neon"] = 6.46, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 87.33, ["Mega"] = 47.25, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 754.69, ["Fly|Ride"] = 817.3, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3192.25, ["Mega|Fly|Ride"] = 12598.62}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 13.91, ["Fly|Ride"] = 34.99, ["Neon"] = 46.41, ["Neon|Fly"] = 55.47, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 46.41, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.68, ["Ride"] = 36.75, ["Fly|Ride"] = 210, ["Neon"] = 13.2, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 62.9, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 62.43, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 299.92}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 9.98, ["Fly"] = 31.34, ["Ride"] = 23.38, ["Fly|Ride"] = 46.78, ["Neon"] = 47.25, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 60.8, ["Neon|Fly|Ride"] = 107.07, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 13.13, ["Fly|Ride"] = 31.5, ["Neon"] = 10.28, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 24.52, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 70.88, ["Mega|Ride"] = 88.13, ["Mega|Fly|Ride"] = 160.05}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 59.3, ["Ride"] = 72.19, ["Fly|Ride"] = 205.42, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.56}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 10.28, ["Neon|Fly"] = 132.24, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 57.74, ["Mega|Ride"] = 119.44, ["Mega|Fly|Ride"] = 356.09}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.5, ["Ride"] = 20.56, ["Fly|Ride"] = 60.61, ["Neon"] = 40.43, ["Neon|Fly"] = 137.64, ["Neon|Ride"] = 42, ["Mega"] = 123.38, ["Mega|Ride"] = 224.94, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.62, ["Neon"] = 9.18, ["Neon|Fly"] = 62.65, ["Mega"] = 93.5, ["Mega|Fly"] = 410.83, ["Mega|Ride"] = 171.67, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 97.59, ["Neon"] = 2.1, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 23.22, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 44.63, ["Mega|Fly"] = 219.8, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 174.57}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 19.67, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 18.38, ["Neon"] = 137.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 821.64, ["Mega|Ride"] = 508.39, ["Mega|Fly|Ride"] = 456.37}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 695.62, ["Ride"] = 753.38, ["Fly|Ride"] = 918.96, ["Neon"] = 2024.87, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1903.13, ["Mega"] = 7943.08, ["Mega|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 6195}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 18.38, ["Fly|Ride"] = 47.24, ["Neon"] = 3.94, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 21.47, ["Neon|Fly|Ride"] = 60.36, ["Mega"] = 57.74, ["Mega|Ride"] = 133.53, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.15, ["Ride"] = 27.75, ["Fly|Ride"] = 77.44, ["Neon"] = 34.51, ["Neon|Fly"] = 137.64, ["Neon|Ride"] = 106.72, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.05, ["Mega|Ride"] = 351.21}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 64.32, ["Ride"] = 72.98, ["Fly|Ride"] = 105, ["Neon"] = 295.32, ["Neon|Ride"] = 313.18, ["Neon|Fly|Ride"] = 431.37, ["Mega"] = 3149.92, ["Mega|Fly|Ride"] = 1641.21}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 124.11, ["Ride"] = 56.43, ["Fly|Ride"] = 102.79, ["Neon"] = 105, ["Neon|Ride"] = 137.64, ["Mega"] = 1918.51, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 729.39}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 19.53, ["Ride"] = 26.25, ["Fly|Ride"] = 123.59, ["Neon"] = 77.44, ["Neon|Ride"] = 136.35, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 410.83, ["Mega|Ride"] = 393.37, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.39, ["Ride"] = 92.8, ["Neon"] = 78.75, ["Neon|Ride"] = 356.09, ["Neon|Fly|Ride"] = 164.34, ["Mega"] = 274.23, ["Mega|Fly"] = 503.4, ["Mega|Ride"] = 354.93, ["Mega|Fly|Ride"] = 452.93}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 21, ["Ride"] = 77.95, ["Neon"] = 185.59, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 302.99, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 525, ["Mega|Ride"] = 630.61, ["Mega|Fly|Ride"] = 555.19}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.47}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 4.88, ["Fly"] = 26.72, ["Ride"] = 27.75, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 214.58, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 204.75, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 201.31, ["Mega|Fly|Ride"] = 302.99}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.94, ["Neon"] = 14.73, ["Mega"] = 137.64, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.16, ["Fly"] = 410.83, ["Ride"] = 73.5, ["Fly|Ride"] = 92.77, ["Neon"] = 301.58, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 257.8, ["Mega|Ride"] = 959.26, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.14, ["Fly"] = 18.37, ["Ride"] = 5.25, ["Fly|Ride"] = 37.41, ["Neon"] = 19.69, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 34.77, ["Neon|Fly|Ride"] = 64.96, ["Mega"] = 164.34, ["Mega|Fly"] = 409.8, ["Mega|Ride"] = 178.71, ["Mega|Fly|Ride"] = 221.71}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.65, ["Fly"] = 82.18, ["Ride"] = 24.94, ["Fly|Ride"] = 63, ["Neon"] = 18.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 116.94, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 273.21}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.76, ["Neon|Ride"] = 226.19, ["Mega"] = 42, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 55.47, ["Fly"] = 58.7, ["Ride"] = 64.97, ["Fly|Ride"] = 120.75, ["Neon"] = 153.57, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 219.8, ["Mega"] = 1095.87, ["Mega|Ride"] = 861.7, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Neon"] = 8.27, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 84.24, ["Mega"] = 100.67, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.19, ["Ride"] = 68.82, ["Fly|Ride"] = 271.16, ["Neon"] = 55.47, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 389.82, ["Mega"] = 374.07, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 630.61}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.42, ["Fly|Ride"] = 36.2, ["Neon"] = 30.19, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 157.5, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 17.41, ["Fly|Ride"] = 59.03, ["Neon"] = 157.5, ["Neon|Ride"] = 410.83, ["Mega"] = 274.23, ["Mega|Ride"] = 388.23, ["Mega|Fly|Ride"] = 343.05}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.29, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.54, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 36.4, ["Ride"] = 136.5, ["Fly|Ride"] = 164.34, ["Neon"] = 156.19, ["Neon|Ride"] = 192.93, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1629.92, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 12.15, ["Ride"] = 85.77, ["Neon"] = 102.72, ["Neon|Ride"] = 178.71, ["Neon|Fly|Ride"] = 143.8, ["Mega"] = 411.7, ["Mega|Ride"] = 328.67, ["Mega|Fly|Ride"] = 498.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 9.29, ["Ride"] = 41.1, ["Fly|Ride"] = 41.1, ["Neon"] = 44.62, ["Mega"] = 924.34, ["Mega|Ride"] = 944.89, ["Mega|Fly|Ride"] = 1643.28}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 13.13, ["Ride"] = 45.94, ["Fly|Ride"] = 367.46, ["Neon"] = 103.9, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 819.59, ["Mega|Ride"] = 792.74, ["Mega|Fly|Ride"] = 1083.31}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.62, ["Neon"] = 26.72, ["Neon|Ride"] = 274.23, ["Mega"] = 309.7, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.67, ["Fly|Ride"] = 38.18, ["Neon"] = 3.84, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 34.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 68.24, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 172.11}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.44, ["Ride"] = 55.47, ["Fly|Ride"] = 52.5, ["Neon"] = 19.69, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 205.42, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 18.26, ["Fly|Ride"] = 55.95, ["Neon"] = 5.82, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 45.84, ["Mega|Ride"] = 74.29, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.14, ["Fly"] = 39.38, ["Ride"] = 27.75, ["Fly|Ride"] = 68.82, ["Neon"] = 18.5, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 463.96}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.13, ["Fly"] = 65.63, ["Ride"] = 34.93, ["Fly|Ride"] = 103.69, ["Neon"] = 27.75, ["Neon|Fly"] = 463.96, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 1027.05}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.83, ["Fly"] = 131.25, ["Ride"] = 26.72, ["Fly|Ride"] = 55.47, ["Neon"] = 24.66, ["Neon|Fly"] = 111.54, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 137.82, ["Mega|Ride"] = 257.24, ["Mega|Fly|Ride"] = 313.29}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.78, ["Ride"] = 18.38, ["Fly|Ride"] = 51.78, ["Neon"] = 22.32, ["Neon|Fly"] = 82.18, ["Neon|Ride"] = 46.41, ["Neon|Fly|Ride"] = 100.92, ["Mega"] = 168, ["Mega|Ride"] = 226.99, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.02, ["Fly"] = 41.1, ["Ride"] = 41.29, ["Neon"] = 20.26, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.38, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 10.28, ["Fly"] = 137.64, ["Ride"] = 105, ["Fly|Ride"] = 525, ["Neon"] = 97.13, ["Neon|Ride"] = 179.74, ["Neon|Fly|Ride"] = 463.96, ["Mega"] = 430.5, ["Mega|Fly"] = 685.05, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 677.25}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 52.5, ["Ride"] = 97.13, ["Fly|Ride"] = 191.05, ["Neon"] = 262.5, ["Neon|Ride"] = 271.69, ["Neon|Fly|Ride"] = 406.72, ["Mega"] = 1237.58, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1194.92}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.56, ["Fly|Ride"] = 49.31, ["Neon"] = 3.35, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 104.4, ["Mega"] = 29.45, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 35.96, ["Neon|Ride"] = 204.39, ["Mega"] = 959.26, ["Mega|Ride"] = 820.61, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.81, ["Fly"] = 105, ["Ride"] = 59.06, ["Neon"] = 289.98, ["Neon|Ride"] = 246.51, ["Mega"] = 1674.07, ["Mega|Ride"] = 1209.87, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 4.65, ["Fly"] = 190.32, ["Ride"] = 13.13, ["Fly|Ride"] = 105, ["Neon"] = 49.87, ["Neon|Ride"] = 65.54, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Ride"] = 82.18, ["Fly|Ride"] = 137.68, ["Neon"] = 6.97, ["Neon|Ride"] = 41.1, ["Mega"] = 52.5, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 88.34, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.71, ["Fly"] = 21, ["Ride"] = 9.19, ["Fly|Ride"] = 55.47, ["Neon"] = 11.82, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 109.91, ["Mega"] = 192.07, ["Mega|Fly"] = 343.05, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.73, ["Ride"] = 14.06, ["Neon"] = 2.59, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 57.53, ["Mega"] = 27.03, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 203.37}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 74.27, ["Neon"] = 6.18, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 89.36, ["Mega"] = 41.99, ["Mega|Fly"] = 168, ["Mega|Ride"] = 76.71, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 155.44, ["Neon"] = 2.63, ["Neon|Ride"] = 47.25, ["Mega"] = 21, ["Mega|Fly|Ride"] = 302.99}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.66, ["Ride"] = 44.18, ["Neon"] = 15.42, ["Neon|Ride"] = 83.52, ["Neon|Fly|Ride"] = 616.23, ["Mega"] = 139.13, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 250.23}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.32, ["Ride"] = 26.79, ["Fly|Ride"] = 189.96, ["Neon"] = 51.19, ["Neon|Ride"] = 96.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 408.77, ["Mega|Ride"] = 548.45, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.71, ["Fly"] = 24.75, ["Ride"] = 19.69, ["Fly|Ride"] = 40.71, ["Neon"] = 39.57, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 41.37, ["Neon|Fly|Ride"] = 88.64, ["Mega"] = 483.75, ["Mega|Ride"] = 315.31, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 65.63, ["Ride"] = 261.91, ["Fly|Ride"] = 262.5, ["Neon"] = 274.23, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.75, ["Fly"] = 71.73, ["Ride"] = 31.5, ["Fly|Ride"] = 149.96, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 630, ["Mega"] = 619.37, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.37, ["Fly|Ride"] = 31.85, ["Neon"] = 3.59, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 39.04, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 17.41, ["Ride"] = 14.44, ["Fly|Ride"] = 30.82, ["Neon"] = 5.09, ["Neon|Fly"] = 26.16, ["Neon|Ride"] = 20.22, ["Neon|Fly|Ride"] = 45.72, ["Mega"] = 44.17, ["Mega|Fly"] = 82.18, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 532.62, ["Ride"] = 483.5, ["Fly|Ride"] = 497, ["Neon|Fly|Ride"] = 1500.73}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 13.13, ["Ride"] = 68.82, ["Neon"] = 81.2, ["Neon|Ride"] = 109.88, ["Mega"] = 315, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 1232.45}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 48.28, ["Ride"] = 13.71, ["Fly|Ride"] = 35.97, ["Neon"] = 5.24, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.47, ["Mega"] = 46.41, ["Mega|Ride"] = 74.81, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 65.63, ["Ride"] = 124.69, ["Fly|Ride"] = 328.13, ["Neon"] = 236.24, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 463.96, ["Mega"] = 737.62, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 932.76}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 16.45, ["Fly|Ride"] = 31.67, ["Neon"] = 13, ["Neon|Fly"] = 41.37, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 84, ["Mega|Fly"] = 178.71, ["Mega|Ride"] = 93.89, ["Mega|Fly|Ride"] = 196.46}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 35.96, ["Fly|Ride"] = 1312.5, ["Neon"] = 3.33, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.31, ["Mega|Fly"] = 269.1, ["Mega|Ride"] = 79.29, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 46.65, ["Fly"] = 143.13, ["Ride"] = 86.62, ["Fly|Ride"] = 170.5, ["Neon"] = 131.25, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 419.88, ["Mega"] = 721.88, ["Mega|Ride"] = 617.47, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 14.44, ["Fly|Ride"] = 52.5, ["Neon"] = 4.38, ["Neon|Ride"] = 39.99, ["Mega"] = 40.61, ["Mega|Ride"] = 183.65, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 34.11, ["Ride"] = 78.75, ["Fly|Ride"] = 131.25, ["Neon"] = 312.23, ["Neon|Ride"] = 248.84, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1622.72, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 55.8, ["Fly|Ride"] = 156.13, ["Neon"] = 21.56, ["Neon|Ride"] = 274.23, ["Mega"] = 144.38, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 517.78}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.62, ["Fly"] = 68.82, ["Ride"] = 26.25, ["Fly|Ride"] = 65.75, ["Neon"] = 9.3, ["Neon|Fly"] = 82.18, ["Neon|Ride"] = 109.91, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 109.91, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 30.19, ["Ride"] = 55.47, ["Fly|Ride"] = 393.74, ["Neon"] = 144.38, ["Neon|Ride"] = 204.39, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2052.02, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1123.59}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 230.31, ["Ride"] = 31.85, ["Fly|Ride"] = 908.98, ["Neon"] = 6.57, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 151.96, ["Mega"] = 46.78, ["Mega|Fly"] = 247.11, ["Mega|Ride"] = 108.88, ["Mega|Fly|Ride"] = 201.55}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 32.88, ["Ride"] = 15.42, ["Fly|Ride"] = 102.88, ["Neon"] = 9.3, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 18.5, ["Neon|Fly|Ride"] = 96.56, ["Mega"] = 205.42, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.97, ["Fly"] = 45.21, ["Ride"] = 26.25, ["Fly|Ride"] = 81.15, ["Neon"] = 69.56, ["Neon|Ride"] = 109.91, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 430.5, ["Mega|Ride"] = 410.83, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 34.9, ["Fly"] = 57.11, ["Ride"] = 43.31, ["Neon"] = 286.78, ["Neon|Fly|Ride"] = 452.81, ["Mega"] = 1054.77, ["Mega|Ride"] = 1848.67, ["Mega|Fly|Ride"] = 835.1}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.55, ["Fly"] = 51.18, ["Ride"] = 24.94, ["Fly|Ride"] = 73.96, ["Neon"] = 63.7, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 222.71, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 361.52}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 52.44, ["Fly"] = 262.5, ["Ride"] = 101.07, ["Fly|Ride"] = 273.2, ["Neon"] = 299.24, ["Neon|Ride"] = 382.08, ["Neon|Fly|Ride"] = 546.39, ["Mega|Ride"] = 1299.78, ["Mega|Fly|Ride"] = 1258.69}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.55, ["Ride"] = 44.01, ["Neon"] = 32.82, ["Neon|Ride"] = 77.73, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.39, ["Mega|Ride"] = 298.88, ["Mega|Fly|Ride"] = 335.35}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.44, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 18.37, ["Neon|Ride"] = 77.04, ["Mega"] = 131.25, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.5, ["Fly"] = 65.63, ["Ride"] = 40.07, ["Fly|Ride"] = 92.8, ["Neon"] = 61.64, ["Neon|Ride"] = 69.13, ["Mega"] = 430.5, ["Mega|Ride"] = 639.19, ["Mega|Fly|Ride"] = 466.29}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.95, ["Fly|Ride"] = 30.82, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 51.36, ["Mega"] = 17.85, ["Mega|Ride"] = 22.34, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 61.64, ["Fly"] = 164.07, ["Ride"] = 78.75, ["Fly|Ride"] = 296.93, ["Neon"] = 262.64, ["Neon|Fly"] = 2328.3, ["Neon|Ride"] = 224.44, ["Neon|Fly|Ride"] = 488.14, ["Mega"] = 1391.83, ["Mega|Ride"] = 1340.79, ["Mega|Fly|Ride"] = 937.36}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Fly|Ride"] = 106.82, ["Neon"] = 3.84, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.34, ["Mega|Ride"] = 64.72, ["Mega|Fly|Ride"] = 306.66}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.75, ["Ride"] = 15.16, ["Fly|Ride"] = 45.93, ["Neon"] = 22.32, ["Neon|Fly"] = 137.64, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 94.5, ["Mega"] = 262.5, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 77.95, ["Ride"] = 119.75, ["Fly|Ride"] = 222.6, ["Neon"] = 402.62, ["Neon|Ride"] = 381.75, ["Neon|Fly|Ride"] = 602.88, ["Mega"] = 1181.25, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 22.61, ["Neon"] = 5.25, ["Neon|Ride"] = 65.63, ["Mega"] = 63.67, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.26}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 34.93, ["Fly|Ride"] = 291.69, ["Neon"] = 6.53, ["Neon|Ride"] = 41.18, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.38, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 94.5, ["Ride"] = 164.34, ["Fly|Ride"] = 294.61, ["Neon"] = 685.05, ["Neon|Ride"] = 680.85, ["Neon|Fly|Ride"] = 735, ["Mega"] = 3557.27, ["Mega|Ride"] = 2464.89, ["Mega|Fly|Ride"] = 2551.67}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 4.14, ["Ride"] = 36.82, ["Neon"] = 43.35, ["Neon|Ride"] = 55.47, ["Neon|Fly|Ride"] = 193.1, ["Mega"] = 145.69, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 27.75, ["Neon"] = 4.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 27.75, ["Mega|Ride"] = 99.65, ["Mega|Fly|Ride"] = 124.09}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.76, ["Ride"] = 26.72, ["Neon"] = 51.19, ["Neon|Ride"] = 109.05, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 257.8, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.61, ["Fly"] = 24.2, ["Ride"] = 13.13, ["Fly|Ride"] = 54.32, ["Neon"] = 80.22, ["Neon|Ride"] = 117.49, ["Neon|Fly|Ride"] = 164.34, ["Mega"] = 410.83, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 464.23}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.99, ["Ride"] = 55.13, ["Fly|Ride"] = 102.72, ["Neon"] = 142.67, ["Neon|Ride"] = 195.16, ["Neon|Fly|Ride"] = 619.37, ["Mega"] = 656.25, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 771.1}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 120.75, ["Fly"] = 247.57, ["Ride"] = 187.08, ["Fly|Ride"] = 225.75, ["Neon"] = 590.45, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 616.23, ["Mega|Fly|Ride"] = 2329.69}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 27, ["Fly"] = 36.74, ["Ride"] = 25.64, ["Fly|Ride"] = 49.25, ["Neon"] = 135.59, ["Neon|Fly"] = 137.64, ["Neon|Ride"] = 123.14, ["Neon|Fly|Ride"] = 181.13, ["Mega|Ride"] = 712.78, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 20.56, ["Fly|Ride"] = 90.39, ["Neon"] = 26.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 117.1, ["Mega"] = 127.32, ["Mega|Ride"] = 132.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 8.61, ["Fly"] = 231.98, ["Ride"] = 39.38, ["Neon"] = 82.21, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Ride"] = 92.92, ["Fly|Ride"] = 164.34, ["Neon"] = 220.49, ["Neon|Ride"] = 213.64, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1164.66, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.75, ["Ride"] = 105, ["Neon"] = 96.56, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 452.93, ["Mega"] = 660.19, ["Mega|Ride"] = 548.45, ["Mega|Fly|Ride"] = 773.63}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 410.83, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 1506.66, ["Mega"] = 4620.62, ["Mega|Fly|Ride"] = 4620.62}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 47.25, ["Ride"] = 64.97, ["Fly|Ride"] = 92.8, ["Neon"] = 176.67, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.46, ["Mega|Fly|Ride"] = 889.52}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.21, ["Fly|Ride"] = 98.44, ["Neon"] = 2.61, ["Neon|Ride"] = 17.3, ["Neon|Fly|Ride"] = 64.28, ["Mega"] = 20.98, ["Mega|Fly"] = 102.72, ["Mega|Ride"] = 41.1, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.31, ["Neon"] = 15.73, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 162.68, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 405.69}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 5.12, ["Ride"] = 41.1, ["Fly|Ride"] = 144.16, ["Neon"] = 18.37, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 122.24, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 118.98, ["Mega|Fly"] = 142.68, ["Mega|Ride"] = 203.37, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 341.25, ["Fly"] = 619.37, ["Ride"] = 412.55, ["Fly|Ride"] = 630.61, ["Neon"] = 1487.15, ["Neon|Ride"] = 1370.08, ["Neon|Fly|Ride"] = 1370.25, ["Mega|Ride"] = 5752.85, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 37.68, ["Ride"] = 17.06, ["Fly|Ride"] = 68.25, ["Neon"] = 15.74, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 77.32, ["Mega"] = 168, ["Mega|Ride"] = 275.18, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 7.07, ["Fly"] = 22.31, ["Ride"] = 17.06, ["Fly|Ride"] = 44.63, ["Neon"] = 28.07, ["Neon|Fly"] = 156.45, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.05, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.11, ["Fly"] = 39.44, ["Ride"] = 27.55, ["Neon"] = 13.13, ["Neon|Fly"] = 151.96, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 121.21, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 55.13, ["Fly"] = 137.64, ["Ride"] = 52.5, ["Fly|Ride"] = 65.63, ["Neon"] = 119.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 1623.8, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 41.1, ["Fly|Ride"] = 69.85, ["Neon"] = 10.5, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 158.86, ["Mega|Ride"] = 410.83}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.03, ["Fly"] = 787.5, ["Ride"] = 25.35, ["Fly|Ride"] = 85.31, ["Neon"] = 123.38, ["Neon|Ride"] = 155.44, ["Mega"] = 677.85, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 6.03, ["Neon|Ride"] = 28.76, ["Mega"] = 39.38, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 291.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.73, ["Ride"] = 134.56, ["Neon"] = 94.5, ["Neon|Ride"] = 204.39, ["Mega"] = 157.5, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 13.13, ["Ride"] = 78.07, ["Neon"] = 139.2, ["Neon|Ride"] = 101.7, ["Neon|Fly|Ride"] = 410.83, ["Mega"] = 479.64, ["Mega|Ride"] = 342.17, ["Mega|Fly|Ride"] = 520.72}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.47, ["Fly"] = 31.5, ["Ride"] = 24.43, ["Fly|Ride"] = 55.55, ["Neon"] = 52.49, ["Neon|Fly"] = 90.57, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 577.21, ["Mega|Ride"] = 369.74, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 262.5, ["Fly"] = 410.27, ["Ride"] = 262.5, ["Fly|Ride"] = 393.74, ["Neon"] = 1464.57, ["Neon|Ride"] = 681.22, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 5031.45}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.62, ["Fly|Ride"] = 56.79, ["Neon"] = 9.98, ["Neon|Fly"] = 77.73, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 219.8, ["Mega|Ride"] = 155.44, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.99, ["Fly"] = 27.86, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 35.43, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 269.15, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 36.82, ["Ride"] = 96.77, ["Neon"] = 105, ["Neon|Ride"] = 185.59, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 393.75, ["Mega|Ride"] = 368.49, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 116.61, ["Fly"] = 393.75, ["Ride"] = 164.34, ["Fly|Ride"] = 243.78, ["Neon"] = 483, ["Neon|Fly"] = 1041.43, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 1168.12, ["Mega"] = 2319.71, ["Mega|Ride"] = 1794.19, ["Mega|Fly|Ride"] = 2235.19}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 30.37, ["Fly"] = 109.91, ["Ride"] = 66.03, ["Neon"] = 80.07, ["Neon|Ride"] = 201.31, ["Neon|Fly|Ride"] = 246.51, ["Mega"] = 249.38, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 15.77, ["Fly|Ride"] = 58.47, ["Neon"] = 9.19, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 53.42, ["Mega|Ride"] = 193.71, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.96, ["Ride"] = 48.57, ["Fly|Ride"] = 81.15, ["Neon"] = 40.68, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 307.1, ["Mega"] = 287.59, ["Mega|Ride"] = 442.98, ["Mega|Fly|Ride"] = 329.88}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 66.93, ["Fly"] = 196.88, ["Ride"] = 135.19, ["Fly|Ride"] = 216.57, ["Neon"] = 141.74, ["Neon|Ride"] = 170.62, ["Neon|Fly|Ride"] = 315, ["Mega"] = 433.13, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.62, ["Neon"] = 5.24, ["Neon|Ride"] = 248.22, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 61.69, ["Mega|Fly"] = 116.82, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 10.28, ["Fly|Ride"] = 273.2, ["Neon"] = 84, ["Neon|Ride"] = 274.23, ["Mega"] = 479.64, ["Mega|Fly|Ride"] = 760.03}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 945, ["Fly"] = 1252.64, ["Ride"] = 1013.25, ["Fly|Ride"] = 1127.44, ["Neon|Ride"] = 3868.1, ["Neon|Fly|Ride"] = 2623.69, ["Mega|Fly|Ride"] = 13694.46}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.83, ["Fly"] = 116, ["Ride"] = 82.18, ["Fly|Ride"] = 194.25, ["Neon"] = 191.05, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 203.37, ["Mega"] = 410.83, ["Mega|Ride"] = 569.5, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.25, ["Ride"] = 20.55, ["Fly|Ride"] = 80.88, ["Neon"] = 11.81, ["Neon|Ride"] = 33.26, ["Neon|Fly|Ride"] = 116.07, ["Mega"] = 78.66, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 124.11}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.02, ["Ride"] = 131.22, ["Neon"] = 109.91, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 274.23, ["Mega|Ride"] = 318.93, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.64, ["Fly|Ride"] = 52.5, ["Neon"] = 2.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 17.06, ["Mega|Fly"] = 123.26, ["Mega|Ride"] = 44.49, ["Mega|Fly|Ride"] = 127.93}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 61.57, ["Ride"] = 118.13, ["Fly|Ride"] = 210, ["Neon"] = 246.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 479.64, ["Mega"] = 1301.26, ["Mega|Ride"] = 1168.13, ["Mega|Fly|Ride"] = 1197}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.11, ["Fly"] = 174.57, ["Ride"] = 18.38, ["Fly|Ride"] = 68.82, ["Neon"] = 20.9, ["Neon|Ride"] = 78.75, ["Mega"] = 462.79, ["Mega|Ride"] = 392.34, ["Mega|Fly|Ride"] = 463.96}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.68, ["Fly"] = 97.69, ["Ride"] = 20.56, ["Neon"] = 11.31, ["Neon|Ride"] = 55.47, ["Mega"] = 92.8, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 369.74}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 62.98, ["Ride"] = 78.75, ["Fly|Ride"] = 118.13, ["Neon"] = 94.5, ["Neon|Fly"] = 267.05, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 496.42, ["Mega|Ride"] = 512.51, ["Mega|Fly|Ride"] = 619.37}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 19.53, ["Ride"] = 84, ["Fly|Ride"] = 62.99, ["Neon"] = 210, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 168.45, ["Mega"] = 341.97, ["Mega|Ride"] = 493, ["Mega|Fly|Ride"] = 603.14}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 59.05, ["Neon"] = 356.09, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 431.37, ["Mega"] = 1534.4, ["Mega|Ride"] = 1643.28, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 8.24, ["Ride"] = 42, ["Neon"] = 27.75, ["Neon|Ride"] = 84.81, ["Neon|Fly|Ride"] = 619.37, ["Mega"] = 99.49, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 280.77}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.82, ["Ride"] = 18.59, ["Fly|Ride"] = 39.38, ["Neon"] = 44.63, ["Neon|Ride"] = 91.65, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 337.63, ["Mega|Fly|Ride"] = 349.2}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.5, ["Ride"] = 154.63, ["Fly|Ride"] = 245.82, ["Neon"] = 459.38, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 604.34, ["Mega"] = 3140.68, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1889.99}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.63, ["Fly"] = 22.91, ["Ride"] = 17.75, ["Fly|Ride"] = 105000, ["Neon"] = 11.45, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 34.93, ["Neon|Fly|Ride"] = 96.56, ["Mega"] = 139.55, ["Mega|Ride"] = 148.47, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 8.37, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 91.88, ["Neon"] = 51.98, ["Neon|Fly"] = 309.7, ["Neon|Ride"] = 76.02, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 366.12, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 334.83}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 17.61, ["Ride"] = 14.33, ["Fly|Ride"] = 41.1, ["Neon"] = 2.1, ["Neon|Fly"] = 24.09, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 41.28, ["Mega"] = 14.57, ["Mega|Fly"] = 48.74, ["Mega|Ride"] = 27.3, ["Mega|Fly|Ride"] = 82.67}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 53.42, ["Neon"] = 2.58, ["Neon|Ride"] = 39.04, ["Mega"] = 20.99, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 109.91}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.93, ["Ride"] = 19.69, ["Fly|Ride"] = 65.63, ["Neon"] = 26.25, ["Neon|Ride"] = 41.1, ["Mega"] = 155.44, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.27, ["Ride"] = 77.04, ["Neon"] = 307.1, ["Neon|Ride"] = 410.83, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 665.54}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.93, ["Fly"] = 19.69, ["Ride"] = 17.06, ["Fly|Ride"] = 36.75, ["Neon"] = 10.49, ["Neon|Fly"] = 34.44, ["Neon|Ride"] = 25.99, ["Neon|Fly|Ride"] = 53.36, ["Mega"] = 118.13, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.85, ["Fly"] = 30.82, ["Ride"] = 23.62, ["Fly|Ride"] = 63.54, ["Neon"] = 20.99, ["Neon|Fly"] = 61.64, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 92.58, ["Mega"] = 182.43, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 171.42, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.42, ["Fly"] = 19.69, ["Ride"] = 18.09, ["Fly|Ride"] = 49.88, ["Neon"] = 9.08, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 59.16, ["Mega|Fly"] = 96.56, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.03, ["Fly"] = 35.96, ["Ride"] = 45.93, ["Neon"] = 86.1, ["Neon|Ride"] = 90.39, ["Neon|Fly|Ride"] = 178.71, ["Mega"] = 213.42, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 130.45, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 95.8, ["Fly"] = 170.5, ["Ride"] = 122.72, ["Fly|Ride"] = 220.39, ["Neon"] = 96.56, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 343.05, ["Mega"] = 387.4, ["Mega|Fly|Ride"] = 959.26}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.05, ["Fly"] = 41.88, ["Ride"] = 18.84, ["Fly|Ride"] = 65.54, ["Neon"] = 24.05, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 109.35, ["Mega"] = 256.77, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 369.74}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 15.42, ["Fly|Ride"] = 34.95, ["Neon"] = 10.44, ["Neon|Fly"] = 67.64, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 131.25, ["Mega|Ride"] = 135.59, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 189, ["Fly"] = 370.69, ["Ride"] = 267.75, ["Fly|Ride"] = 274.23, ["Neon"] = 942.82, ["Neon|Ride"] = 1232.45, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 6.37, ["Ride"] = 61.76, ["Neon"] = 42.95, ["Neon|Fly|Ride"] = 410.83, ["Mega"] = 119.62, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.59, ["Fly"] = 23.63, ["Ride"] = 15.59, ["Fly|Ride"] = 76.02, ["Neon"] = 22.89, ["Neon|Fly"] = 205.42, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 201.8, ["Mega"] = 197.51, ["Mega|Ride"] = 273.2, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 14.41, ["Ride"] = 24.67, ["Neon"] = 26.25, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 616.23, ["Mega"] = 461.77, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.42, ["Ride"] = 15.42, ["Fly|Ride"] = 28.88, ["Neon"] = 2.63, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 16.43, ["Neon|Fly|Ride"] = 40.49, ["Mega"] = 18.27, ["Mega|Ride"] = 27.75, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 5.15, ["Fly"] = 41.1, ["Ride"] = 17.06, ["Fly|Ride"] = 61.69, ["Neon"] = 8.97, ["Neon|Ride"] = 31.34, ["Neon|Fly|Ride"] = 94.76, ["Mega"] = 102.38, ["Mega|Ride"] = 137.97, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.23, ["Ride"] = 60.61, ["Neon"] = 19.53, ["Neon|Ride"] = 205.42, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 59.07, ["Mega|Ride"] = 195.16, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 74.82, ["Fly"] = 105, ["Ride"] = 105, ["Fly|Ride"] = 136.68, ["Neon"] = 511.5, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2054.08, ["Mega|Ride"] = 3425.17, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.71, ["Fly"] = 91.88, ["Ride"] = 23.63, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Neon|Ride"] = 54.53, ["Neon|Fly|Ride"] = 92.79, ["Mega"] = 211.54, ["Mega|Ride"] = 322.51, ["Mega|Fly|Ride"] = 397.48}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 6.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 519.43, ["Mega"] = 52.49, ["Mega|Fly"] = 400.56, ["Mega|Ride"] = 122.24, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 53.65, ["Fly"] = 210, ["Ride"] = 89.25, ["Fly|Ride"] = 192.07, ["Neon"] = 129.94, ["Neon|Ride"] = 197.21, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 575.15, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 681.97}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.39, ["Ride"] = 13.13, ["Fly|Ride"] = 27.75, ["Neon"] = 2.1, ["Neon|Fly"] = 15.42, ["Neon|Ride"] = 16.45, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 19.05, ["Mega|Fly"] = 48.87, ["Mega|Ride"] = 36.99, ["Mega|Fly|Ride"] = 82.21}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 92.8, ["Mega"] = 24.85, ["Mega|Ride"] = 68.82, ["Mega|Fly|Ride"] = 204.63}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 107.63, ["Neon"] = 11.7, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 180.77, ["Mega"] = 74.06, ["Mega|Fly"] = 178.71, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 188.11}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.09, ["Fly"] = 89.36, ["Ride"] = 46.93, ["Fly|Ride"] = 91.88, ["Neon"] = 30.71, ["Neon|Fly"] = 136.88, ["Neon|Ride"] = 72.83, ["Neon|Fly|Ride"] = 222.74, ["Mega"] = 105, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.5, ["Ride"] = 6.57, ["Fly|Ride"] = 25.2, ["Neon"] = 2.1, ["Neon|Fly"] = 20.89, ["Neon|Ride"] = 48.28, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 22.04, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.7, ["Fly"] = 72.19, ["Ride"] = 41.1, ["Neon"] = 116.94, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 496.42, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 684.03}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2457, ["Ride"] = 2822.3, ["Fly|Ride"] = 2520, ["Neon|Fly|Ride"] = 9558.61, ["Mega|Fly|Ride"] = 35878.35}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 17.49, ["Fly|Ride"] = 27.75, ["Neon"] = 2.1, ["Neon|Fly"] = 62.29, ["Neon|Ride"] = 26.6, ["Neon|Fly|Ride"] = 67.16, ["Mega"] = 78.75, ["Mega|Fly"] = 437.54, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.93, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 21.31, ["Fly"] = 41.1, ["Ride"] = 48.28, ["Fly|Ride"] = 157.5, ["Neon"] = 116.82, ["Neon|Ride"] = 92.45, ["Neon|Fly|Ride"] = 232.13, ["Mega"] = 393.75, ["Mega|Ride"] = 397.68, ["Mega|Fly|Ride"] = 437.54}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 36.75, ["Ride"] = 58.56, ["Neon"] = 155.07, ["Neon|Ride"] = 216.91, ["Mega"] = 540.75, ["Mega|Ride"] = 813.43, ["Mega|Fly|Ride"] = 804.96}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 155.44, ["Fly"] = 1370.08, ["Ride"] = 177.06, ["Fly|Ride"] = 155.44, ["Neon"] = 685.05, ["Neon|Ride"] = 717.92, ["Neon|Fly|Ride"] = 787.65, ["Mega"] = 6162.21, ["Mega|Ride"] = 3477.24, ["Mega|Fly|Ride"] = 3255}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.75, ["Fly"] = 27.75, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 128.7, ["Mega"] = 106.32, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 217.56, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 68.82, ["Neon"] = 15.65, ["Neon|Fly|Ride"] = 513.54, ["Mega"] = 114.76, ["Mega|Ride"] = 320.15, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.94, ["Fly"] = 101.99, ["Ride"] = 52.39, ["Fly|Ride"] = 196.88, ["Neon"] = 9.07, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 68.82, ["Mega"] = 78.75, ["Mega|Ride"] = 112.53, ["Mega|Fly|Ride"] = 322.51}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.31, ["Ride"] = 98.44, ["Neon"] = 129.94, ["Neon|Ride"] = 1165.82, ["Mega"] = 504.29, ["Mega|Ride"] = 602.88, ["Mega|Fly|Ride"] = 716.88}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 93.69, ["Mega"] = 16.94, ["Mega|Fly"] = 115.59, ["Mega|Ride"] = 155.44}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 68.25, ["Fly"] = 137.64, ["Ride"] = 78.75, ["Fly|Ride"] = 146.45, ["Neon"] = 410.83, ["Neon|Ride"] = 408.77, ["Neon|Fly|Ride"] = 410.83, ["Mega"] = 1365, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 9.98, ["Neon|Ride"] = 137.64, ["Mega"] = 62.65, ["Mega|Ride"] = 164.34, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 42.77, ["Fly"] = 216.91, ["Ride"] = 89.25, ["Fly|Ride"] = 131.23, ["Neon"] = 236.25, ["Neon|Ride"] = 328.02, ["Neon|Fly|Ride"] = 424.07, ["Mega"] = 2625, ["Mega|Ride"] = 1848.67, ["Mega|Fly|Ride"] = 1601.25}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.53, ["Fly|Ride"] = 50.28, ["Neon"] = 5.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 58.47, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 43.94, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 165.14}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 9.19, ["Neon|Ride"] = 118.13, ["Mega"] = 68.31, ["Mega|Ride"] = 145.14, ["Mega|Fly|Ride"] = 603.9}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.16, ["Ride"] = 37.41, ["Fly|Ride"] = 205.42, ["Neon"] = 54.51, ["Neon|Ride"] = 89.36, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 231.98, ["Mega|Ride"] = 344.08, ["Mega|Fly|Ride"] = 918.62}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 370.13, ["Fly"] = 548.45, ["Ride"] = 449.5, ["Fly|Ride"] = 575.3, ["Neon"] = 1291.49, ["Neon|Ride"] = 1102.5, ["Neon|Fly|Ride"] = 1246.53, ["Mega|Ride"] = 4655.99, ["Mega|Fly|Ride"] = 3744.78}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.69, ["Ride"] = 59.07, ["Fly|Ride"] = 78.75, ["Neon"] = 205.42, ["Neon|Ride"] = 192.54, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1370.08, ["Mega|Ride"] = 1211.91, ["Mega|Fly|Ride"] = 1054.77}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 45.01, ["Ride"] = 19.69, ["Fly|Ride"] = 91.88, ["Neon"] = 7.27, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 68.82, ["Mega"] = 49.88, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.34, ["Fly"] = 77.44, ["Ride"] = 60.38, ["Fly|Ride"] = 105, ["Neon"] = 43.32, ["Neon|Fly"] = 105, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 174.12, ["Mega"] = 242.82, ["Mega|Fly"] = 954.57, ["Mega|Ride"] = 236.34, ["Mega|Fly|Ride"] = 342.47}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 5.93, ["Ride"] = 15.75, ["Fly|Ride"] = 261.91, ["Neon"] = 138.67, ["Neon|Ride"] = 67.8, ["Mega"] = 410.83, ["Mega|Ride"] = 682.26, ["Mega|Fly|Ride"] = 400.56}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.91, ["Ride"] = 27.75, ["Neon"] = 15.74, ["Mega"] = 93.56, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.81, ["Fly"] = 52.5, ["Ride"] = 18.37, ["Fly|Ride"] = 55.47, ["Neon"] = 24.94, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 209.53, ["Mega"] = 541.66, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 956.18}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105.33, ["Ride"] = 131.24, ["Fly|Ride"] = 223.13, ["Neon|Ride"] = 708.65, ["Neon|Fly|Ride"] = 695.92, ["Mega|Fly|Ride"] = 4108.14}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 30.44, ["Fly"] = 95.82, ["Ride"] = 52.5, ["Fly|Ride"] = 137.64, ["Neon"] = 192.94, ["Neon|Ride"] = 192.14, ["Mega"] = 682.5, ["Mega|Ride"] = 667.58, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2216.81, ["Fly"] = 2349.38, ["Ride"] = 2100, ["Fly|Ride"] = 2244.38, ["Neon"] = 7532.26, ["Neon|Fly|Ride"] = 7875, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 107.63, ["Fly|Ride"] = 183.75, ["Neon"] = 13.12, ["Neon|Ride"] = 135.59, ["Neon|Fly|Ride"] = 192.07, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 574.12}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.18, ["Ride"] = 27.75, ["Neon"] = 91.88, ["Neon|Ride"] = 119.48, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 191.63, ["Mega|Ride"] = 240.48, ["Mega|Fly|Ride"] = 520.72}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 854.16, ["Fly"] = 1187.69, ["Ride"] = 994.88, ["Fly|Ride"] = 1030.32, ["Neon"] = 2598.75, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2480.63, ["Mega|Fly|Ride"] = 11638.34}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 38.66, ["Ride"] = 56.44, ["Fly|Ride"] = 134.56, ["Neon"] = 309.7, ["Neon|Ride"] = 291.72, ["Neon|Fly|Ride"] = 369.74, ["Mega"] = 775.43, ["Mega|Ride"] = 773.63, ["Mega|Fly|Ride"] = 836.03}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.23, ["Ride"] = 22.89, ["Fly|Ride"] = 128.09, ["Neon"] = 15.42, ["Neon|Ride"] = 41.1, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 196.88, ["Mega|Ride"] = 123.26, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 137.64, ["Neon"] = 3.68, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 55.72, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 81.38, ["Ride"] = 127.32, ["Fly|Ride"] = 309.7, ["Neon"] = 409.8, ["Neon|Ride"] = 433.8, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2739.12, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 5.15, ["Neon"] = 21, ["Neon|Ride"] = 61.64, ["Mega"] = 144.48, ["Mega|Ride"] = 187.95, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.63, ["Ride"] = 133.71, ["Neon"] = 385.88, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 494.32, ["Mega"] = 2464.89, ["Mega|Fly|Ride"] = 2460.78}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 7.77, ["Fly"] = 105, ["Fly|Ride"] = 109.91, ["Neon"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 309.7, ["Mega|Ride"] = 309.02, ["Mega|Fly|Ride"] = 274.23}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.36, ["Ride"] = 302.99, ["Fly|Ride"] = 337.74, ["Neon"] = 1125.35, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 4210.85}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.22, ["Fly"] = 87.93, ["Ride"] = 26.25, ["Fly|Ride"] = 39.37, ["Neon"] = 55.47, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 335.63}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 4.58, ["Neon|Fly"] = 30.82, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 52.46, ["Mega"] = 54.17, ["Mega|Fly"] = 95.04, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 892.4, ["Ride"] = 1050, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 7532.26, ["Neon|Fly|Ride"] = 5135.17, ["Mega"] = 26018.85, ["Mega|Fly|Ride"] = 27387.87}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.38, ["Fly"] = 959.26, ["Ride"] = 210, ["Neon"] = 66.94, ["Neon|Ride"] = 129.4, ["Mega"] = 236.24, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 9.19, ["Fly"] = 46.09, ["Ride"] = 39.04, ["Fly|Ride"] = 97.13, ["Neon"] = 15.75, ["Neon|Fly"] = 92.8, ["Neon|Ride"] = 58.01, ["Neon|Fly|Ride"] = 124.22, ["Mega"] = 173.17, ["Mega|Fly"] = 204.39, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 55.13, ["Fly"] = 40.68, ["Ride"] = 44.23, ["Fly|Ride"] = 70.85, ["Neon"] = 274.23, ["Neon|Ride"] = 200.17, ["Neon|Fly|Ride"] = 183.66, ["Mega"] = 2054.08, ["Mega|Fly|Ride"] = 860.9}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.6, ["Fly"] = 77.04, ["Ride"] = 31.85, ["Fly|Ride"] = 87.94, ["Neon"] = 65.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 76.15, ["Neon|Fly|Ride"] = 146.15, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 460.13}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 29.85, ["Ride"] = 77.73, ["Fly|Ride"] = 135.59, ["Neon"] = 78.75, ["Neon|Ride"] = 274.23, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 483.75, ["Mega|Ride"] = 573.11, ["Mega|Fly|Ride"] = 616.23}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 231.98, ["Neon"] = 2.61, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 309.7, ["Mega"] = 15.74, ["Mega|Fly"] = 68.25, ["Mega|Ride"] = 67.51}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 45.93, ["Fly"] = 68.24, ["Ride"] = 64.32, ["Fly|Ride"] = 130.97, ["Neon"] = 402.48, ["Neon|Fly"] = 431.37, ["Neon|Ride"] = 302.99, ["Neon|Fly|Ride"] = 385.86, ["Mega"] = 3286.53, ["Mega|Fly|Ride"] = 924.34}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 4.66, ["Fly"] = 27.75, ["Ride"] = 18.25, ["Fly|Ride"] = 72.86, ["Neon"] = 31.5, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 82.18, ["Mega"] = 773.07, ["Mega|Ride"] = 309.7, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 20.56, ["Fly|Ride"] = 38.06, ["Neon"] = 13.39, ["Neon|Ride"] = 27.75, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 265.9, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.91, ["Ride"] = 171.53, ["Neon"] = 105, ["Neon|Ride"] = 821.64, ["Neon|Fly|Ride"] = 183.85, ["Mega"] = 246.51, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 25.98, ["Ride"] = 80.13, ["Fly|Ride"] = 183.75, ["Neon"] = 195.57, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 302.99, ["Mega"] = 787.75, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.88, ["Ride"] = 131.25, ["Neon"] = 20.88, ["Neon|Ride"] = 77.04, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 91.76, ["Mega|Fly"] = 302.99, ["Mega|Ride"] = 109.91, ["Mega|Fly|Ride"] = 309.7}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.62, ["Neon|Ride"] = 20.6, ["Mega"] = 15.74, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 68.82, ["Ride"] = 25.1, ["Fly|Ride"] = 82.18, ["Neon"] = 2.57, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 23.01, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 21.06, ["Ride"] = 17.51, ["Fly|Ride"] = 40.05, ["Neon"] = 7.87, ["Neon|Fly"] = 123.26, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 68.82, ["Mega"] = 96.56, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 92.8}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.75, ["Fly|Ride"] = 65.63, ["Neon"] = 34.93, ["Neon|Ride"] = 1312.5, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.73, ["Fly|Ride"] = 47.24, ["Neon"] = 14.44, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 77.58, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.75, ["Ride"] = 155.23, ["Fly|Ride"] = 359.48, ["Neon"] = 173.24, ["Neon|Ride"] = 231.27, ["Neon|Fly|Ride"] = 1027.05, ["Mega"] = 1230.41, ["Mega|Ride"] = 883.26, ["Mega|Fly|Ride"] = 985.97}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 15.42, ["Fly|Ride"] = 35.44, ["Neon"] = 2.62, ["Neon|Fly"] = 24.67, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 48.74, ["Mega"] = 23.22, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 123.27}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.72, ["Fly"] = 61.64, ["Ride"] = 34.93, ["Fly|Ride"] = 82.18, ["Neon"] = 39.21, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 262.5, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.85, ["Fly"] = 51.48, ["Ride"] = 28.5, ["Fly|Ride"] = 74.24, ["Neon"] = 103.79, ["Neon|Ride"] = 102.9, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 1108.84, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 565.78}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.53, ["Fly"] = 196.88, ["Neon"] = 60.61, ["Mega"] = 288.75, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 405.69}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.31, ["Fly|Ride"] = 35.96, ["Neon"] = 5.23, ["Neon|Fly"] = 40.07, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 41.34, ["Mega|Ride"] = 68.82, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.82, ["Fly"] = 26.25, ["Ride"] = 27.75, ["Neon"] = 10.27, ["Neon|Fly"] = 31.34, ["Neon|Ride"] = 96.53, ["Mega"] = 136.5, ["Mega|Fly"] = 735, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 384.13}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 971.25, ["Fly"] = 984.38, ["Ride"] = 984.38, ["Fly|Ride"] = 959.26, ["Neon"] = 2864.84, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 6891.29}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.9, ["Ride"] = 137.82, ["Fly|Ride"] = 155.44, ["Neon"] = 400.32, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 602.88, ["Mega"] = 2783.65, ["Mega|Ride"] = 1918.51, ["Mega|Fly|Ride"] = 1506.67}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 205.42, ["Mega"] = 74.23, ["Mega|Fly|Ride"] = 205.42}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 56.44, ["Fly"] = 152.02, ["Ride"] = 77.7, ["Fly|Ride"] = 210, ["Neon"] = 290.98, ["Neon|Ride"] = 340.47, ["Neon|Fly|Ride"] = 397.48, ["Mega"] = 1023.75, ["Mega|Ride"] = 1170.84, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.54, ["Ride"] = 15.75, ["Neon"] = 23.01, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 273.2, ["Mega"] = 223.13, ["Mega|Ride"] = 345.1, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 252, ["Fly"] = 410.83, ["Ride"] = 274.23, ["Fly|Ride"] = 349.2, ["Neon|Ride"] = 1333.11, ["Neon|Fly|Ride"] = 1390.61, ["Mega|Fly|Ride"] = 4175.46}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 75.64, ["Ride"] = 26.25, ["Fly|Ride"] = 202.64, ["Neon"] = 24.67, ["Neon|Ride"] = 54.28, ["Mega"] = 137.64, ["Mega|Fly"] = 320.44}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Ride"] = 26.17, ["Neon"] = 35.18, ["Mega"] = 328.67}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 55.69, ["Ride"] = 96.55, ["Fly|Ride"] = 525, ["Neon"] = 164.71, ["Neon|Ride"] = 191.05, ["Neon|Fly|Ride"] = 216.91, ["Mega"] = 542, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 680.85}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 23.47, ["Mega"] = 183.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 453.51}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.43, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 27.57, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 4446.75, ["Fly|Ride"] = 4331.25, ["Neon"] = 30810.96, ["Neon|Fly|Ride"] = 21636.5, ["Mega|Fly|Ride"] = 84901.66}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 10.38, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 271.16, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 278.37}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.56, ["Fly"] = 21.15, ["Ride"] = 20.66, ["Fly|Ride"] = 41.58, ["Neon"] = 13.26, ["Neon|Fly"] = 68.82, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 137.82, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 468.57, ["Fly"] = 773.63, ["Ride"] = 459.38, ["Fly|Ride"] = 559.3, ["Neon"] = 1372.81, ["Neon|Ride"] = 1370.08, ["Neon|Fly|Ride"] = 1467.19, ["Mega|Fly|Ride"] = 5237.88}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 11.82, ["Ride"] = 25.81, ["Neon"] = 17.07, ["Neon|Ride"] = 145.69, ["Mega"] = 105, ["Mega|Fly|Ride"] = 685.05}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 137.64, ["Ride"] = 46.41, ["Neon"] = 27.75, ["Neon|Ride"] = 274.23, ["Neon|Fly|Ride"] = 274.23, ["Mega"] = 408.77, ["Mega|Ride"] = 401.63}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 27.09, ["Neon"] = 4.44, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 24.76, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 44.63, ["Mega|Ride"] = 74.72}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 812.4, ["Fly"] = 808.28, ["Ride"] = 685.05, ["Fly|Ride"] = 753.38, ["Neon"] = 2362.5, ["Neon|Ride"] = 2037.62, ["Neon|Fly|Ride"] = 2164.46, ["Mega|Fly|Ride"] = 9586.33}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.87, ["Fly"] = 61.64, ["Ride"] = 72.65, ["Neon"] = 30.82, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 178.71, ["Mega"] = 151.18, ["Mega|Ride"] = 179.74, ["Mega|Fly|Ride"] = 294.77}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 17.45, ["Fly"] = 235.34, ["Ride"] = 63.57, ["Neon"] = 31.34, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 206.85, ["Mega|Fly|Ride"] = 277.17}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 3.94, ["Fly"] = 34.11, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 14.13, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 67.45, ["Mega"] = 287.66, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 20.99, ["Ride"] = 46.41, ["Fly|Ride"] = 155.44, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Mega|Fly|Ride"] = 821.64}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Neon"] = 5.24, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 26.25, ["Mega|Fly"] = 109.91, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 481.36}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 537.6, ["Ride"] = 446.25, ["Fly|Ride"] = 696.34, ["Neon"] = 2875.7, ["Neon|Ride"] = 2707.1, ["Neon|Fly|Ride"] = 2711.37, ["Mega|Ride"] = 9046.82, ["Mega|Fly|Ride"] = 6847.23}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 61.04, ["Fly|Ride"] = 178.63, ["Neon"] = 10.18, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 192.07, ["Mega"] = 57.53, ["Mega|Ride"] = 157.83, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 5.24, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 53.42, ["Mega|Fly"] = 109.91, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 254.72}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 24.45, ["Neon"] = 5.25, ["Neon|Ride"] = 41.31, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 39.38, ["Mega|Fly"] = 152.02, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 192.07}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 4.12, ["Ride"] = 131.25, ["Neon"] = 15.5, ["Neon|Ride"] = 39.44, ["Mega"] = 192.07}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.43, ["Fly"] = 98.44, ["Ride"] = 137.64, ["Fly|Ride"] = 201.84, ["Neon"] = 152.78, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 326.62, ["Mega"] = 630.61, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 680.84}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.54, ["Ride"] = 72.93, ["Fly|Ride"] = 116.6, ["Neon"] = 85.32, ["Neon|Ride"] = 131.13, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 410.83, ["Mega|Ride"] = 385.9, ["Mega|Fly|Ride"] = 560.79}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 9.19, ["Fly|Ride"] = 35.89, ["Neon"] = 23.22, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 77.73, ["Mega"] = 299.92, ["Mega|Ride"] = 137.64, ["Mega|Fly|Ride"] = 201.89}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.19, ["Ride"] = 64.32, ["Fly|Ride"] = 102.72, ["Neon"] = 92.45, ["Mega"] = 262.5, ["Mega|Fly|Ride"] = 959.26}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 6.57, ["Fly|Ride"] = 44.63, ["Neon"] = 14.44, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 206.47, ["Mega"] = 84.44, ["Mega|Fly"] = 152.02, ["Mega|Ride"] = 152.02, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.72, ["Fly"] = 62.65, ["Ride"] = 23.37, ["Fly|Ride"] = 155.44, ["Neon"] = 228.74, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 240.34, ["Mega"] = 923.31, ["Mega|Ride"] = 927.89, ["Mega|Fly|Ride"] = 737.43}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 23.63, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Neon|Ride"] = 137.64, ["Mega"] = 328.13, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 849.36}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 55.12, ["Fly"] = 85.32, ["Ride"] = 71.63, ["Fly|Ride"] = 183.27, ["Neon"] = 308.44, ["Neon|Ride"] = 272.67, ["Neon|Fly|Ride"] = 346.63, ["Mega|Ride"] = 1640.03, ["Mega|Fly|Ride"] = 1316.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 65.63, ["Fly"] = 92.8, ["Ride"] = 61.86, ["Fly|Ride"] = 656.25, ["Neon"] = 129.94, ["Neon|Ride"] = 186.93, ["Neon|Fly|Ride"] = 217.74, ["Mega"] = 576.35, ["Mega|Ride"] = 685.05, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.53, ["Ride"] = 39.38, ["Neon"] = 127.32, ["Neon|Ride"] = 274.23, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 1231.43}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 12.47, ["Fly"] = 428.26, ["Ride"] = 39.29, ["Fly|Ride"] = 184.88, ["Neon"] = 85.24, ["Neon|Fly"] = 420, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 457.47, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 508.61}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 11.31, ["Fly|Ride"] = 34.93, ["Neon"] = 4.66, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 62.65, ["Mega"] = 44.61, ["Mega|Fly"] = 205.42, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 202.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 37.02, ["Ride"] = 103.69, ["Fly|Ride"] = 249.38, ["Neon"] = 236.25, ["Neon|Ride"] = 193.71, ["Neon|Fly|Ride"] = 302.99, ["Mega"] = 696.34, ["Mega|Ride"] = 608.02, ["Mega|Fly|Ride"] = 615.21}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.24, ["Ride"] = 55.47, ["Neon"] = 3.94, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.88, ["Mega|Fly"] = 55.47, ["Mega|Ride"] = 80.13, ["Mega|Fly|Ride"] = 137.64}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 52.5, ["Ride"] = 51.98, ["Neon"] = 128.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 767.21, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Ride"] = 105, ["Mega"] = 15.65}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 47.25, ["Mega"] = 23.93, ["Mega|Ride"] = 106.81, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 118.13, ["Ride"] = 105, ["Fly|Ride"] = 274.23, ["Neon"] = 498.75, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 677.85, ["Mega|Ride"] = 6379.17, ["Mega|Fly|Ride"] = 2181.94}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 17.07, ["Fly|Ride"] = 92.67, ["Neon"] = 12.77, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 90.56, ["Mega|Ride"] = 107.62, ["Mega|Fly|Ride"] = 219.8}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 18.5, ["Fly|Ride"] = 86.63, ["Neon"] = 3.73, ["Neon|Fly"] = 61.64, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 102.72, ["Mega"] = 35.43, ["Mega|Ride"] = 122.24, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 44.18, ["Mega"] = 35.82, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 223.91}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Ride"] = 137.71, ["Mega"] = 60.61, ["Mega|Ride"] = 109.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.64, ["Neon|Ride"] = 490.94, ["Neon|Fly|Ride"] = 685.05, ["Mega"] = 1540.56, ["Mega|Ride"] = 1540.56, ["Mega|Fly|Ride"] = 1321.81}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.29, ["Ride"] = 56.95, ["Fly|Ride"] = 131.25, ["Neon"] = 46.54, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 313.69, ["Ride"] = 426.23, ["Fly|Ride"] = 616.23, ["Neon"] = 1641.21, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Ride"] = 4107.11, ["Mega|Fly|Ride"] = 3835.98}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 82.17}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 40.69}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 23.37}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 61.69}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 51.14}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.07}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 11.67}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 245.43}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 41.09}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.38}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.4}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.73}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.73}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 8.81}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 511.41}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 712.69}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.52}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.84}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 34.38}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.56}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 20.4}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 39.38}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 49.88}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 24.14}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.5}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 14.03}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.73}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.71}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.36}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.81}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1369.91}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 308.34}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.09}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.8}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 7.48}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2049.72}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.63}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.92}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.52}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 14.94}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 17.41}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 40.06}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 178.49}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 26.23}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 18.48}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.63}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 27.16}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.63}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 5.86}},
    ["rbxassetid://1265129203"] = {name = "Ice Snowboard", prices = {["default"] = 1953}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.42}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 26.17}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 105}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 222.98}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.55}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 13.8}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 22.32}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 77.33}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.95}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22034.36}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 786.44}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.2}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 132.96}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 48.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 308.1}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 343}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 28.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 64.97}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 64.32}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 54.51}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 57.75}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 47.25}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 177.38}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 343.14}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.46}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 82.17}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.91}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 85.31}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.13}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.22}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 10.5}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 262.9}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 748.13}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.87}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 23.39}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.52}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 603.06}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 45.94}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.48}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 49.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 39.44}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.44}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.6}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.75}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.6}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.5}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 34.81}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.24}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.88}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 118.13}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 84}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.63}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.69}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.24}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 5.88}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 16.96}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 30.19}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.19}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 6.46}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 72.18}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 11.82}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 67.89}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 29.38}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.17}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 155.88}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 4.55}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 137.62}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.42}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.41}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6240.23}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 40.6}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.18}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 10.23}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.85}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.74}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.84}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.71}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.09}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 95.7}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 23.41}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 5.72}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 89.8}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.22}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4331.51}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.25}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 38.97}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.7}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 65.62}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 39.38}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.67}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.91}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 91.88}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.13}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 6.98}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 7.87}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.18}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 13.12}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 21.48}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 10.38}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.15}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.21}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.51}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.61}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 18.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 6300}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.79}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 84.74}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.48}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 47.25}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 3.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1039.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 32.48}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 13.09}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 26.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 77.43}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.36}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.45}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 3.29}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 16.45}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 5.14}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.14}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 21.46}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.5}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.51}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 17.73}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 6.46}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.02}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.41}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 36.95}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 7.56}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.52}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 13.13}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 43.26}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 18.26}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.69}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 3.94}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 282.47}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 27.07}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.39}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.97}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.15}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.22}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 410.83}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 5.25}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 137.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1115.63}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 213.61}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 4.58}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 23.64}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 54.87}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 4.66}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 2.96}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.82}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 8.82}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 9.08}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.62}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.08}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 68.15}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 9.18}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.68}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 2.88}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 82.73}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.6}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 30.64}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 118.4}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 6.19}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 71.98}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.47}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.39}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 5.23}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 65.62}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 47.25}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 91.88}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 281.96}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.89}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 152}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.58}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.9}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 6.46}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.77}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.37}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.99}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 6.03}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 74.03}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 16.95}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 21.19}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 32.81}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 4.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 31.47}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.48}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 155.42}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 7.69}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 131.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.67}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.91}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.25}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 74.81}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 137.79}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1758.75}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.03}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 40.07}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.56}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 361.82}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 24.78}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 314.9}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 15.42}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.01}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 273}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.48}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.93}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 32.28}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.17}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 105}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 114.34}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 55.12}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 193.71}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 10.19}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2054.08}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 446.25}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.37}},
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