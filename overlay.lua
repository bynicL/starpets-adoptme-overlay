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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 823.09, ["Ride"] = 1027.16, ["Fly|Ride"] = 1043.68, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 20351.6}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 498.75, ["Ride"] = 521.85, ["Fly|Ride"] = 556.04, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2450.56, ["Mega"] = 10436.72}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 4811.63, ["Fly|Ride"] = 4592.44, ["Neon|Fly|Ride"] = 22959.75, ["Mega|Fly|Ride"] = 69578.44}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 169.21, ["Ride"] = 201.6, ["Fly|Ride"] = 341.25, ["Neon"] = 904.87, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 1251.37, ["Mega"] = 4174.7, ["Mega|Fly|Ride"] = 3836.44}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 834.94, ["Ride"] = 538.12, ["Fly|Ride"] = 680.16, ["Neon|Fly|Ride"] = 1584.39, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.3, ["Ride"] = 27.68, ["Fly|Ride"] = 159.44, ["Neon"] = 68.25, ["Neon|Fly"] = 278.67, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.45, ["Fly"] = 41.99, ["Ride"] = 29.09, ["Fly|Ride"] = 68.16, ["Neon"] = 25.88, ["Neon|Fly"] = 128.63, ["Neon|Ride"] = 50.74, ["Neon|Fly|Ride"] = 105, ["Mega"] = 152.25, ["Mega|Fly"] = 394.44, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.05}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 96.57, ["Ride"] = 150.73, ["Fly|Ride"] = 240.19, ["Neon"] = 557.33, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 688.84, ["Mega|Fly|Ride"] = 2725.04}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 46.39, ["Fly"] = 2779.88, ["Ride"] = 51.3, ["Fly|Ride"] = 99.17, ["Neon"] = 252, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 326.24, ["Mega"] = 2100, ["Mega|Ride"] = 1417.13, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 31.32, ["Fly"] = 59.07, ["Ride"] = 41.34, ["Fly|Ride"] = 66.75, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 282.19, ["Mega|Fly|Ride"] = 670.69}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 59.07, ["Fly"] = 111.69, ["Ride"] = 57.88, ["Fly|Ride"] = 157.05, ["Neon"] = 402.8, ["Neon|Ride"] = 375.38, ["Neon|Fly|Ride"] = 315.32, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 69.93}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 339.94, ["Ride"] = 355.69, ["Fly|Ride"] = 357.95, ["Neon"] = 1356.79, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 4933.44}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.44, ["Fly"] = 170.52, ["Ride"] = 124.36, ["Fly|Ride"] = 164.07, ["Neon|Fly"] = 684.95, ["Neon|Fly|Ride"] = 749.37, ["Mega|Fly|Ride"] = 3031.45}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.29, ["Ride"] = 53.44, ["Fly|Ride"] = 131.24, ["Neon"] = 21.51, ["Neon|Fly"] = 96.58, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 124.69, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 277.64, ["Mega|Fly|Ride"] = 277.64}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.53, ["Fly"] = 219.18, ["Ride"] = 212.52, ["Fly|Ride"] = 221.82, ["Neon"] = 787.69, ["Neon|Fly|Ride"] = 751.46, ["Mega"] = 3618.43, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.29, ["Fly"] = 29.21, ["Ride"] = 15.29, ["Fly|Ride"] = 40.95, ["Neon"] = 28.87, ["Neon|Ride"] = 93.98, ["Neon|Fly|Ride"] = 119, ["Mega"] = 208.76, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 96.75, ["Fly"] = 466.38, ["Ride"] = 146.25, ["Fly|Ride"] = 315, ["Neon"] = 433.14, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 373.86, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1703.79, ["Mega|Ride"] = 1390.18, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 68.9, ["Ride"] = 92.79, ["Fly|Ride"] = 210, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1392.27}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.29, ["Fly"] = 393.75, ["Ride"] = 32.48, ["Fly|Ride"] = 223.13, ["Neon"] = 262.49, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 278.67, ["Mega|Ride"] = 972.71, ["Mega|Fly|Ride"] = 1669.88}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 56.38, ["Fly"] = 131.25, ["Ride"] = 70.16, ["Fly|Ride"] = 105, ["Neon"] = 255.82, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 335.11, ["Mega"] = 1653.3, ["Mega|Ride"] = 1392.27, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.22, ["Fly"] = 68.9, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 208.76, ["Neon|Fly"] = 392.09, ["Neon|Ride"] = 296.56, ["Neon|Fly|Ride"] = 378.71, ["Mega"] = 1183.54, ["Mega|Ride"] = 1110.48, ["Mega|Fly|Ride"] = 1275.39}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.89, ["Ride"] = 41.76, ["Fly|Ride"] = 84, ["Neon"] = 348.6, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 297.61, ["Mega"] = 832.88, ["Mega|Ride"] = 2087.35, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.59, ["Fly"] = 83.51, ["Ride"] = 57.75, ["Fly|Ride"] = 111.69, ["Neon"] = 370.82, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.21, ["Fly"] = 24.15, ["Ride"] = 22.44, ["Fly|Ride"] = 70.17, ["Neon"] = 55.13, ["Neon|Ride"] = 50.53, ["Neon|Fly|Ride"] = 105, ["Mega"] = 156.19, ["Mega|Fly"] = 307.9, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 311.77}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 452.69, ["Ride"] = 417.47, ["Fly|Ride"] = 480.11, ["Neon"] = 1502.9, ["Neon|Ride"] = 2212.6, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6944.61}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.75, ["Ride"] = 31.57, ["Fly|Ride"] = 105.18, ["Neon"] = 202.22, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 278.67, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 11.38, ["Fly"] = 34.54, ["Ride"] = 19.3, ["Fly|Ride"] = 59.07, ["Neon"] = 73.5, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 292.25, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.88, ["Fly"] = 105.65, ["Ride"] = 94.33, ["Fly|Ride"] = 129.94, ["Neon"] = 417.47, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 443.6, ["Mega"] = 3339.76, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1656.33}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 12.54, ["Ride"] = 28.2, ["Fly|Ride"] = 118.13, ["Neon"] = 98.12, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 487.4, ["Mega|Ride"] = 795.3}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 348.6, ["Ride"] = 196.88, ["Fly|Ride"] = 315.38, ["Neon"] = 847.48, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 991.5, ["Mega"] = 6262.05, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 3016.22}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 68.15}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.76, ["Fly"] = 31.39, ["Ride"] = 22.98, ["Fly|Ride"] = 55.79, ["Neon"] = 23.99, ["Neon|Fly"] = 5218.37, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 161.44, ["Mega|Fly"] = 508.46, ["Mega|Ride"] = 177.15, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 918.75, ["Fly"] = 2625, ["Ride"] = 990.94, ["Fly|Ride"] = 1128.27, ["Neon"] = 7158.38, ["Neon|Ride"] = 6123.23, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 53141.65, ["Mega|Fly|Ride"] = 47237.03}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.84, ["Fly"] = 69.93, ["Ride"] = 24.86, ["Fly|Ride"] = 107.47, ["Neon"] = 139.86, ["Neon|Ride"] = 116.25, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 787.5, ["Mega|Ride"] = 832.88, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.51, ["Ride"] = 191.02, ["Fly|Ride"] = 278.67, ["Neon"] = 1809.74, ["Neon|Ride"] = 905.78, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.47}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.71, ["Fly"] = 68.85, ["Ride"] = 52.4, ["Fly|Ride"] = 139.86, ["Neon"] = 104.89, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 684.53, ["Mega|Ride"] = 1101.1, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 131.52, ["Ride"] = 390.34, ["Fly|Ride"] = 313.11, ["Neon|Ride"] = 562.56, ["Neon|Fly|Ride"] = 696.14, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 157.5, ["Ride"] = 189.1, ["Fly|Ride"] = 274.32, ["Neon"] = 394.44, ["Neon|Fly"] = 557.33, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 2676.45}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 63.95, ["Fly"] = 58.91, ["Ride"] = 51.96, ["Fly|Ride"] = 88.28, ["Neon|Ride"] = 417.47, ["Neon|Fly|Ride"] = 364.34, ["Mega"] = 4174.7, ["Mega|Fly|Ride"] = 1575.37}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.12, ["Ride"] = 56.44, ["Fly|Ride"] = 201.95, ["Neon"] = 139.86, ["Neon|Ride"] = 125.63, ["Neon|Fly|Ride"] = 234.85, ["Mega"] = 204.58, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 324.9, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 521.85, ["Fly"] = 590.63, ["Ride"] = 465.52, ["Fly|Ride"] = 505.32, ["Neon|Ride"] = 3713, ["Neon|Fly|Ride"] = 1647.54, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.87, ["Fly"] = 164.92, ["Ride"] = 115.5, ["Fly|Ride"] = 194.14, ["Neon"] = 459.38, ["Neon|Fly"] = 834.94, ["Neon|Ride"] = 696.14, ["Neon|Fly|Ride"] = 557.33, ["Mega|Ride"] = 2503.78, ["Mega|Fly|Ride"] = 2358.71}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 7096.99, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14610.38}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 34.73, ["Fly"] = 112.1, ["Ride"] = 47.39, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 582.75, ["Neon|Fly|Ride"] = 409.8, ["Mega"] = 1322.34, ["Mega|Ride"] = 1781.57, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 111.69, ["Ride"] = 101.07, ["Fly|Ride"] = 138.37, ["Neon"] = 575.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6262.05, ["Mega|Ride"] = 2644.67, ["Mega|Fly|Ride"] = 3003.45}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 69.93, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 158.17, ["Neon|Fly"] = 299.56, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 219.38, ["Mega"] = 2625, ["Mega|Ride"] = 779.64, ["Mega|Fly|Ride"] = 655.56}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 10.45}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 55.89, ["Fly"] = 62.63, ["Ride"] = 62.63, ["Fly|Ride"] = 64.95, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 557.33, ["Mega|Fly|Ride"] = 1889.49}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 192.17, ["Ride"] = 223.36, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1103, ["Neon|Fly|Ride"] = 1392.27}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 892.5, ["Ride"] = 943.69, ["Fly|Ride"] = 1008.94, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13916.33}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.49, ["Fly"] = 64.32, ["Ride"] = 38.97, ["Fly|Ride"] = 64.32, ["Neon"] = 160.78, ["Neon|Ride"] = 166.69, ["Neon|Fly|Ride"] = 234.82, ["Mega|Ride"] = 891.98, ["Mega|Fly|Ride"] = 725.34}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.63}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4593.75, ["Ride"] = 6570.97, ["Fly|Ride"] = 4554.38, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36215.46}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 13.12, ["Fly"] = 52.4, ["Ride"] = 22.41, ["Fly|Ride"] = 61.95, ["Neon"] = 104.64, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 208.22, ["Mega"] = 787.5, ["Mega|Ride"] = 570.9, ["Mega|Fly|Ride"] = 584.48}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.42, ["Fly"] = 139.88, ["Ride"] = 33.41, ["Fly|Ride"] = 278.67, ["Neon"] = 98.12, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 727.13, ["Mega|Ride"] = 532.23, ["Mega|Fly|Ride"] = 1040.57}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 113.38, ["Fly"] = 52.5, ["Ride"] = 54.33, ["Fly|Ride"] = 140.21, ["Neon|Ride"] = 387.22, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4174.7}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 11.82, ["Fly"] = 150.93, ["Ride"] = 30.41, ["Fly|Ride"] = 78.75, ["Neon"] = 79.75, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1968.75, ["Fly"] = 2256.77, ["Ride"] = 1785, ["Fly|Ride"] = 1876.88, ["Neon|Ride"] = 4077.64, ["Neon|Fly|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 26118.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72359.83, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 17.07, ["Fly"] = 393.74, ["Ride"] = 55.13, ["Fly|Ride"] = 124.69, ["Neon"] = 277.64, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 342.57, ["Mega"] = 974.8, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 830.79}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.94, ["Fly"] = 60.56, ["Ride"] = 38.31, ["Fly|Ride"] = 131.1, ["Neon"] = 19.52, ["Neon|Fly"] = 70.87, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 124.69, ["Mega|Ride"] = 234.92, ["Mega|Fly|Ride"] = 333.99}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.85}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.56, ["Ride"] = 38.34, ["Fly|Ride"] = 131.25, ["Neon"] = 59.07, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 469.67, ["Mega"] = 278.67, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 546.48}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 787.5, ["Fly|Ride"] = 841.89, ["Neon"] = 2366.02, ["Neon|Fly|Ride"] = 2426.67, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 975.19, ["Ride"] = 918.65, ["Fly|Ride"] = 971.25, ["Neon|Ride"] = 3200.96, ["Neon|Fly|Ride"] = 3109.21, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 15.66, ["Fly"] = 118.1, ["Ride"] = 39.38, ["Fly|Ride"] = 85.32, ["Neon"] = 139.86, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 236.94, ["Mega"] = 1204.13, ["Mega|Ride"] = 696.14, ["Mega|Fly|Ride"] = 612.65}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 39.03}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 67.67, ["Fly"] = 98.12, ["Ride"] = 73.1, ["Fly|Ride"] = 139.13, ["Neon"] = 469.67, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 433.14, ["Mega|Ride"] = 2043.53, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 66.55, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 281.56, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1358.23, ["Mega|Fly|Ride"] = 1770.57}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.97, ["Fly"] = 60.56, ["Ride"] = 17.94, ["Fly|Ride"] = 49.55, ["Neon"] = 56.38, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 125.32, ["Mega"] = 348.6, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.84, ["Fly"] = 139.86, ["Ride"] = 144.38, ["Fly|Ride"] = 209.99, ["Neon"] = 630.62, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1569.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.57, ["Ride"] = 46.51, ["Fly|Ride"] = 262.5, ["Neon"] = 51.1, ["Neon|Ride"] = 119.19, ["Mega"] = 248.07, ["Mega|Ride"] = 474.62, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.77, ["Fly"] = 41.32, ["Ride"] = 32.69, ["Fly|Ride"] = 75.95, ["Neon"] = 111.03, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 307.9, ["Mega"] = 779.64, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.71, ["Ride"] = 56.38, ["Fly|Ride"] = 156.19, ["Neon"] = 245.46, ["Neon|Ride"] = 315.32, ["Mega"] = 918.74, ["Mega|Ride"] = 976.63, ["Mega|Fly|Ride"] = 1109.43}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 12.43, ["Fly"] = 169.81, ["Ride"] = 35.79, ["Fly|Ride"] = 70.88, ["Neon"] = 91.88, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 904.87, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7087.5, ["Ride"] = 7141.32, ["Fly|Ride"] = 5494, ["Neon"] = 31310.14, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24770.51, ["Mega|Fly|Ride"] = 94474.04}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 248.36, ["Fly"] = 242.82, ["Ride"] = 250.69, ["Fly|Ride"] = 296.27, ["Neon|Fly|Ride"] = 630, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 32.82, ["Fly"] = 315, ["Ride"] = 85.31, ["Fly|Ride"] = 168.62, ["Neon"] = 122.07, ["Neon|Fly"] = 312.08, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 434.44, ["Mega|Fly"] = 583.43, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 87.41, ["Ride"] = 23.63, ["Fly|Ride"] = 52.5, ["Neon"] = 31.5, ["Neon|Fly"] = 50.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 189.96, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 49.8, ["Fly"] = 65.63, ["Ride"] = 86.63, ["Fly|Ride"] = 264.64, ["Neon"] = 214.02, ["Neon|Fly"] = 386.16, ["Neon|Ride"] = 233.88, ["Neon|Fly|Ride"] = 311.56, ["Mega"] = 376.8, ["Mega|Ride"] = 480.31, ["Mega|Fly|Ride"] = 623.78}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 11943.75, ["Fly|Ride"] = 11942.43, ["Neon|Fly|Ride"] = 22575}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 249.27, ["Ride"] = 295.54, ["Fly|Ride"] = 343.08, ["Neon"] = 1582.22, ["Neon|Ride"] = 1392.27, ["Neon|Fly|Ride"] = 1565.52, ["Mega"] = 5740.21, ["Mega|Fly|Ride"] = 5775}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 63, ["Fly"] = 74.82, ["Ride"] = 68.16, ["Fly|Ride"] = 94.64, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2783.49}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.35, ["Fly"] = 44.89, ["Ride"] = 24.32, ["Fly|Ride"] = 72.12, ["Neon"] = 140.44, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 295.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 380.52, ["Ride"] = 418.68, ["Fly|Ride"] = 484.32, ["Neon"] = 1531.08, ["Neon|Ride"] = 1394.94, ["Neon|Fly|Ride"] = 1711.64, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.19, ["Fly"] = 34.99, ["Ride"] = 37.68, ["Fly|Ride"] = 85.22, ["Neon"] = 19.85, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 181.61, ["Mega"] = 135.14, ["Mega|Ride"] = 232.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 137.69, ["Fly"] = 214.94, ["Ride"] = 128.64, ["Fly|Ride"] = 233.71, ["Neon"] = 557.33, ["Neon|Ride"] = 524.88, ["Neon|Fly|Ride"] = 554.21, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.26, ["Fly"] = 18.38, ["Ride"] = 18.25, ["Fly|Ride"] = 38.07, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1246.88, ["Mega|Fly|Ride"] = 974.8}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 139.86, ["Ride"] = 86.63, ["Fly|Ride"] = 196.88, ["Neon"] = 421.32, ["Neon|Fly"] = 557.33, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1809.74}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 27.57, ["Fly"] = 103.34, ["Ride"] = 33.76, ["Fly|Ride"] = 89.25, ["Neon"] = 158.26, ["Neon|Ride"] = 165.34, ["Neon|Fly|Ride"] = 287.16, ["Mega"] = 557.33, ["Mega|Ride"] = 516.64, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 28.85}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.15, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 111.03, ["Neon|Ride"] = 412.27, ["Neon|Fly|Ride"] = 478.03, ["Mega"] = 1565.52, ["Mega|Ride"] = 1350.53, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.21, ["Ride"] = 29.23, ["Fly|Ride"] = 132.54, ["Neon"] = 23.63, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 135.19, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 9.98, ["Fly"] = 52.5, ["Ride"] = 28.23, ["Fly|Ride"] = 98.12, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 222.04, ["Mega|Ride"] = 633.52, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 446.25, ["Ride"] = 457.19, ["Fly|Ride"] = 584.48, ["Neon|Fly|Ride"] = 2783.49, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 34.48, ["Ride"] = 55.11, ["Fly|Ride"] = 105, ["Neon"] = 234.99, ["Neon|Ride"] = 244.61, ["Neon|Fly|Ride"] = 320.42, ["Mega"] = 1040.42, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 834.94}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 54.58, ["Fly"] = 117.49, ["Ride"] = 64.73, ["Fly|Ride"] = 131.25, ["Neon"] = 278.67, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 917.41, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 31.9, ["Fly"] = 102.3, ["Ride"] = 72.19, ["Fly|Ride"] = 139.86, ["Neon"] = 112.88, ["Neon|Fly"] = 261.98, ["Neon|Ride"] = 164.11, ["Neon|Fly|Ride"] = 325.64, ["Mega"] = 417.47, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 657.53}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9447.42, ["Fly"] = 8400, ["Ride"] = 13541.69, ["Fly|Ride"] = 8523.38, ["Neon|Fly|Ride"] = 16905, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Fly"] = 1312.4, ["Ride"] = 1312.5, ["Fly|Ride"] = 1443.75, ["Neon|Ride"] = 5210.02, ["Neon|Fly|Ride"] = 4960.15, ["Mega|Fly|Ride"] = 18088.93}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 656.25, ["Ride"] = 560.39, ["Fly|Ride"] = 656.25, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 6944.61}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.08, ["Fly"] = 21.77, ["Ride"] = 21.5, ["Fly|Ride"] = 53.25, ["Neon"] = 111.69, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 139.86, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 7.88, ["Fly"] = 78.74, ["Ride"] = 29, ["Fly|Ride"] = 99.17, ["Neon"] = 19.69, ["Neon|Ride"] = 56, ["Mega"] = 150.29, ["Mega|Ride"] = 164.56, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 55.04, ["Fly"] = 76.13, ["Ride"] = 52.42, ["Fly|Ride"] = 98.75, ["Neon"] = 531.43, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 190.32, ["Mega|Fly|Ride"] = 551.04}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.93, ["Fly"] = 29, ["Ride"] = 18.38, ["Fly|Ride"] = 40.69, ["Neon"] = 31.48, ["Neon|Fly"] = 56.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 208.76, ["Mega|Ride"] = 208.76}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.69, ["Fly"] = 369.49, ["Ride"] = 348.09, ["Fly|Ride"] = 413.44, ["Neon|Fly|Ride"] = 1348.64, ["Mega|Fly|Ride"] = 4732.02}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 22.41, ["Fly"] = 91.88, ["Ride"] = 35.49, ["Fly|Ride"] = 89.25, ["Neon"] = 118.13, ["Neon|Fly"] = 417.47, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 612.65, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.46, ["Fly"] = 20.99, ["Ride"] = 19.69, ["Fly|Ride"] = 43.85, ["Neon"] = 139.86, ["Neon|Fly"] = 125.25, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 446.25, ["Fly"] = 787.5, ["Ride"] = 446.25, ["Fly|Ride"] = 536.47, ["Neon|Fly|Ride"] = 2834.24, ["Mega|Fly|Ride"] = 8762.49}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1317.65, ["Ride"] = 1154.9, ["Fly|Ride"] = 1312.5, ["Neon"] = 4870.84, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.86, ["Fly"] = 96.03, ["Ride"] = 103.69, ["Fly|Ride"] = 133.88, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3621.92}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 166.39, ["Fly"] = 157.49, ["Ride"] = 169.22, ["Fly|Ride"] = 242.81, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.57, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2764.63}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.41, ["Ride"] = 47.25, ["Fly|Ride"] = 278.67, ["Neon"] = 265.31, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 2087.35, ["Mega|Fly|Ride"] = 917.41}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.75, ["Ride"] = 278.67, ["Fly|Ride"] = 557.33, ["Neon|Fly"] = 944.75, ["Neon|Fly|Ride"] = 1322.66, ["Mega|Fly|Ride"] = 3757.23}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2483.25, ["Fly|Ride"] = 2391.06, ["Neon|Fly|Ride"] = 10436.72, ["Mega|Fly|Ride"] = 28342.22}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.94, ["Fly"] = 208.76, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2296.09, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 656.13, ["Fly|Ride"] = 714.13, ["Neon|Ride"] = 1653.3, ["Neon|Fly|Ride"] = 1314.94, ["Mega|Fly|Ride"] = 3359.14}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 31.9, ["Fly"] = 64.21, ["Ride"] = 54.16, ["Fly|Ride"] = 101.06, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.14, ["Fly"] = 46.03, ["Ride"] = 20.89, ["Fly|Ride"] = 56.38, ["Neon"] = 18.8, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 37.87, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 152.03, ["Mega|Fly"] = 248.98, ["Mega|Ride"] = 182.1, ["Mega|Fly|Ride"] = 289.42}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.51, ["Ride"] = 125.25, ["Fly|Ride"] = 253.32, ["Neon"] = 344.43, ["Neon|Ride"] = 486.36, ["Neon|Fly|Ride"] = 696.14, ["Mega"] = 1525.86, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.88, ["Fly"] = 1033.33, ["Ride"] = 842.63, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2366.02, ["Neon|Fly|Ride"] = 2227.21, ["Mega|Fly|Ride"] = 9631.13}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 689.07, ["Ride"] = 793.21, ["Fly|Ride"] = 626.21, ["Neon|Fly|Ride"] = 4165.3, ["Mega|Fly|Ride"] = 15028.89}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.97, ["Fly"] = 26.25, ["Ride"] = 20.44, ["Fly|Ride"] = 39.29, ["Neon|Ride"] = 102.85, ["Neon|Fly|Ride"] = 206.07, ["Mega"] = 1019.82, ["Mega|Ride"] = 696.14, ["Mega|Fly|Ride"] = 695.09}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.44, ["Ride"] = 25.73, ["Fly|Ride"] = 70.17, ["Neon"] = 94.48, ["Neon|Ride"] = 76.4, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 400.32, ["Mega|Ride"] = 417.47, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.98, ["Ride"] = 22.32, ["Fly|Ride"] = 111.57, ["Neon"] = 22.32, ["Neon|Fly"] = 315.21, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 162.54, ["Mega|Fly"] = 536.16, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 122.94, ["Fly"] = 278.67, ["Ride"] = 57.75, ["Fly|Ride"] = 102.71, ["Neon"] = 249.38, ["Neon|Ride"] = 208.76, ["Neon|Fly|Ride"] = 188.99, ["Mega|Fly|Ride"] = 952.81}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 133.84, ["Fly|Ride"] = 630.62, ["Neon"] = 419.83, ["Neon|Ride"] = 520.8, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1531.08, ["Mega|Ride"] = 1565.52, ["Mega|Fly|Ride"] = 1521.69}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.67, ["Fly"] = 59.06, ["Ride"] = 35.12, ["Fly|Ride"] = 62.37, ["Neon"] = 86.16, ["Neon|Fly"] = 158.26, ["Neon|Ride"] = 110.64, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 415.41, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 36.38, ["Ride"] = 45.74, ["Fly|Ride"] = 93.19, ["Neon"] = 323.84, ["Neon|Ride"] = 137.08, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 2100, ["Mega|Ride"] = 974.8, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 28.2, ["Ride"] = 13.83, ["Fly|Ride"] = 45.83, ["Neon"] = 24.03, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 732.38, ["Mega|Ride"] = 472.38, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.2, ["Fly"] = 41.06, ["Ride"] = 33.99, ["Fly|Ride"] = 31629.46, ["Neon"] = 25.99, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 293.25, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.66, ["Fly"] = 65.62, ["Ride"] = 50.3, ["Fly|Ride"] = 110.02, ["Neon"] = 409.8, ["Neon|Ride"] = 289, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1071.06}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1358.83, ["Fly"] = 1809.74, ["Ride"] = 1677.93, ["Fly|Ride"] = 1599.94, ["Neon|Ride"] = 4800.91, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 393.75, ["Ride"] = 393.65, ["Fly|Ride"] = 553.88, ["Neon|Fly|Ride"] = 3293.84, ["Mega|Fly|Ride"] = 9741.65}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 290.72, ["Ride"] = 338.63, ["Fly|Ride"] = 521.85, ["Neon"] = 1113.61, ["Neon|Ride"] = 1576.55, ["Neon|Fly|Ride"] = 1672.2, ["Mega|Fly|Ride"] = 7332.86}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 44.05}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 23.67, ["Ride"] = 47.16, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 472.38, ["Mega|Ride"] = 1434.02, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 72361.92, ["Fly"] = 65625, ["Ride"] = 35427.77, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 320.42, ["Fly"] = 325.5, ["Ride"] = 319.54, ["Fly|Ride"] = 417.47, ["Neon"] = 1390.18, ["Neon|Fly"] = 1260.06, ["Neon|Ride"] = 994.91, ["Neon|Fly|Ride"] = 1127.44, ["Mega"] = 6262.05, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 167.9, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 139.86, ["Fly"] = 262.5, ["Ride"] = 125.25, ["Fly|Ride"] = 206.07, ["Neon|Ride"] = 548.59, ["Neon|Fly|Ride"] = 462, ["Mega|Fly|Ride"] = 2504.82}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 706.2}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5108.79, ["Ride"] = 4920.92, ["Fly|Ride"] = 5121.31, ["Neon"] = 20873.44, ["Neon|Fly|Ride"] = 27831.59}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.24, ["Fly"] = 138.21, ["Ride"] = 33.27, ["Fly|Ride"] = 64.32, ["Neon"] = 337.32, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 244.27, ["Mega|Fly|Ride"] = 833.9}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.32, ["Ride"] = 52.04, ["Fly|Ride"] = 117.95, ["Neon"] = 403.96, ["Neon|Ride"] = 244.23, ["Neon|Fly|Ride"] = 359.63, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 733.69, ["Fly"] = 834.94, ["Ride"] = 717.92, ["Fly|Ride"] = 904.87, ["Neon"] = 2504.82, ["Neon|Ride"] = 2296.09, ["Neon|Fly|Ride"] = 1955.51, ["Mega"] = 7576.02, ["Mega|Fly"] = 7576.02, ["Mega|Ride"] = 6598.34, ["Mega|Fly|Ride"] = 7145.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.61, ["Fly"] = 28.65, ["Ride"] = 21.81, ["Fly|Ride"] = 52.5, ["Neon"] = 115.49, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 163.41, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.43, ["Ride"] = 21.86, ["Fly|Ride"] = 79.13, ["Neon"] = 91.88, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 181.61, ["Mega"] = 417.47}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 89.25, ["Ride"] = 112.2, ["Fly|Ride"] = 139.86, ["Neon"] = 724.33, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 605.34, ["Mega|Fly|Ride"] = 2574.75}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 22.45, ["Fly"] = 139.86, ["Ride"] = 62.69, ["Fly|Ride"] = 144.38, ["Neon"] = 101.07, ["Neon|Ride"] = 118.27, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 255.94, ["Mega|Fly"] = 749.9, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4241.02, ["Ride"] = 3871.88, ["Fly|Ride"] = 4003.12, ["Neon"] = 13384.63, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 9646.88, ["Mega"] = 62619.24, ["Mega|Fly|Ride"] = 35900.15}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 38.67, ["Fly"] = 104.39, ["Ride"] = 65.34, ["Fly|Ride"] = 193.69, ["Neon"] = 393.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 417.47, ["Mega|Ride"] = 1732.43, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 6338.07, ["Neon|Ride"] = 19203.57, ["Neon|Fly|Ride"] = 17521.88, ["Mega|Fly|Ride"] = 78275.35}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.63, ["Fly"] = 16.95, ["Ride"] = 18.12, ["Fly|Ride"] = 39.27, ["Neon"] = 24.34, ["Neon|Fly"] = 58.47, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 86, ["Mega"] = 160.74, ["Mega|Ride"] = 181.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 19.65, ["Fly"] = 28.61, ["Ride"] = 26.25, ["Fly|Ride"] = 53.29, ["Neon"] = 139.86, ["Neon|Fly"] = 230.67, ["Neon|Ride"] = 194.14, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 985.04, ["Mega|Fly|Ride"] = 724.33}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.18}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.91, ["Ride"] = 32.82, ["Fly|Ride"] = 85.32, ["Neon"] = 85.32, ["Neon|Ride"] = 157.68, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 1049.9, ["Mega|Ride"] = 974.8, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 23.9, ["Fly"] = 190.37, ["Ride"] = 40.28, ["Fly|Ride"] = 99.73, ["Neon"] = 210.83, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 315.32, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.64, ["Fly"] = 19.69, ["Ride"] = 19.37, ["Fly|Ride"] = 37.89, ["Neon|Ride"] = 115.86, ["Neon|Fly|Ride"] = 175.19, ["Mega"] = 874.13, ["Mega|Ride"] = 589.3, ["Mega|Fly|Ride"] = 507.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8453.75}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2362.5}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 39.67}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.19, ["Ride"] = 205.48, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1043.68, ["Mega|Fly|Ride"] = 5648.36}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 13.17, ["Fly"] = 131.52, ["Ride"] = 41.34, ["Fly|Ride"] = 105, ["Neon"] = 139.86, ["Neon|Ride"] = 155.93, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 944.75, ["Mega|Fly|Ride"] = 972.71}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.22, ["Ride"] = 29.22, ["Fly|Ride"] = 83.51, ["Neon"] = 102.9, ["Neon|Ride"] = 98.12, ["Mega|Fly|Ride"] = 834.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 194.8, ["Fly"] = 417.47, ["Ride"] = 207.72, ["Fly|Ride"] = 301.88, ["Neon"] = 701.37, ["Neon|Ride"] = 750.41, ["Mega|Ride"] = 3200.96, ["Mega|Fly|Ride"] = 3480.66}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 170.07, ["Ride"] = 139.86, ["Fly|Ride"] = 164.3, ["Neon"] = 696.14, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 2227.21}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 165.79, ["Fly"] = 265.49, ["Ride"] = 207.38, ["Fly|Ride"] = 252, ["Neon"] = 897.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1041.78, ["Mega|Fly|Ride"] = 4094.28}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2504.82, ["Ride"] = 1968.75, ["Fly|Ride"] = 1836.4, ["Neon"] = 8266.5, ["Neon|Fly|Ride"] = 6030.94, ["Mega|Fly|Ride"] = 23378.24}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.98, ["Fly"] = 98.12, ["Ride"] = 56.8, ["Fly|Ride"] = 69.02, ["Neon"] = 127.3, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 265.11, ["Mega"] = 938.27, ["Mega|Ride"] = 866.81, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 834.94, ["Fly"] = 2100, ["Ride"] = 727.57, ["Fly|Ride"] = 939.32, ["Neon|Fly|Ride"] = 4094.28, ["Mega|Fly|Ride"] = 18894.83}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 53.45}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.3, ["Ride"] = 39.38, ["Fly|Ride"] = 647.98, ["Neon"] = 101.07, ["Neon|Ride"] = 131.52, ["Neon|Fly|Ride"] = 307.9, ["Mega"] = 480.38, ["Mega|Ride"] = 505.45, ["Mega|Fly|Ride"] = 575.08}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.89, ["Fly"] = 56.38, ["Ride"] = 27.56, ["Fly|Ride"] = 94.83, ["Neon"] = 55.52, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 918.75, ["Mega|Ride"] = 362.17, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 71.94}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 14.88, ["Ride"] = 22.32, ["Fly|Ride"] = 80.14, ["Neon"] = 195.18, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 834.94, ["Mega|Fly|Ride"] = 1826.44}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.5, ["Fly"] = 52.2, ["Ride"] = 40.85, ["Fly|Ride"] = 70.88, ["Neon"] = 236.94, ["Neon|Ride"] = 299.56, ["Neon|Fly|Ride"] = 307.9, ["Mega"] = 892.35, ["Mega|Ride"] = 1771.4, ["Mega|Fly|Ride"] = 974.8}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 11132.86, ["Ride"] = 5250, ["Fly|Ride"] = 5183.07, ["Neon|Fly|Ride"] = 11550, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.82, ["Fly"] = 83.51, ["Ride"] = 32.82, ["Fly|Ride"] = 105, ["Neon"] = 60.8, ["Neon|Ride"] = 104.39, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 529.08, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.32}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 94.65, ["Fly"] = 369.48, ["Ride"] = 135.19, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 745.18, ["Mega"] = 2879.59, ["Mega|Ride"] = 2087.35, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52.5, ["Fly"] = 126.37, ["Ride"] = 91.69, ["Fly|Ride"] = 278.67, ["Neon"] = 255.93, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 546.9, ["Mega"] = 2361.86, ["Mega|Ride"] = 2817.93, ["Mega|Fly|Ride"] = 1564.48}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 18.1, ["Fly"] = 70.46, ["Ride"] = 30.19, ["Fly|Ride"] = 81.38, ["Neon"] = 128.77, ["Neon|Fly"] = 236.94, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 176.69, ["Mega"] = 1016.21, ["Mega|Ride"] = 850.61, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 8.86, ["Fly"] = 82.1, ["Ride"] = 26.71, ["Fly|Ride"] = 65.24, ["Neon"] = 37.09, ["Neon|Ride"] = 59.72, ["Neon|Fly|Ride"] = 160.74, ["Mega"] = 178.5, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 305.16}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.32, ["Ride"] = 31.9, ["Fly|Ride"] = 65.63, ["Neon"] = 115.86, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 220.85, ["Mega"] = 732.19, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 695.09}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.09, ["Fly"] = 28.68, ["Ride"] = 31.32, ["Fly|Ride"] = 50.25, ["Neon"] = 208.76, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 737.89}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 224.44}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 44.37, ["Ride"] = 542.06, ["Fly|Ride"] = 274.31, ["Neon"] = 150, ["Neon|Ride"] = 200.76, ["Mega"] = 834.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.59, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.71}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 46.78, ["Fly"] = 212.02, ["Ride"] = 95.95, ["Fly|Ride"] = 177.19, ["Neon"] = 174.8, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 388.71, ["Mega"] = 905.63, ["Mega|Ride"] = 2205.98, ["Mega|Fly|Ride"] = 1231.73}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.75, ["Fly"] = 1334.47, ["Ride"] = 996.19, ["Fly|Ride"] = 1028.49, ["Neon|Fly"] = 4086.02, ["Neon|Ride"] = 3200.96, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12941.54}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 392.44, ["Fly"] = 696.14, ["Ride"] = 433.13, ["Fly|Ride"] = 510.57, ["Neon"] = 2922.29, ["Neon|Ride"] = 2080.32, ["Neon|Fly|Ride"] = 2087.35, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 67.71}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.31, ["Fly"] = 78.75, ["Ride"] = 23.81, ["Fly|Ride"] = 50.68, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 96.03, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 437.26, ["Mega|Ride"] = 696.14, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 283.5, ["Fly"] = 417.47, ["Ride"] = 323.06, ["Fly|Ride"] = 393.75, ["Neon"] = 1091.7, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1141.8, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 16.09}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 166.78, ["Ride"] = 262.5, ["Fly|Ride"] = 309.75, ["Neon"] = 1061.82, ["Neon|Ride"] = 814.08, ["Neon|Fly|Ride"] = 910.1, ["Mega"] = 10019.26, ["Mega|Ride"] = 11872.82, ["Mega|Fly|Ride"] = 3060.05}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 140.91, ["Ride"] = 125.89, ["Fly|Ride"] = 274.32, ["Neon"] = 696.14, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3480.66, ["Mega|Fly|Ride"] = 2450.56}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.07, ["Ride"] = 29.3, ["Fly|Ride"] = 208.76, ["Neon"] = 27.16, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 227.54, ["Mega"] = 307.9, ["Mega|Ride"] = 518.44, ["Mega|Fly|Ride"] = 832.88}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.78, ["Fly"] = 47.24, ["Ride"] = 27.19, ["Fly|Ride"] = 72.52, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 341.25, ["Mega|Ride"] = 1392.27, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 23.63, ["Fly"] = 102.34, ["Fly|Ride"] = 128.84, ["Neon"] = 102.76, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.57, ["Fly"] = 131.23, ["Ride"] = 50.53, ["Fly|Ride"] = 170.63, ["Neon"] = 28.24, ["Neon|Fly"] = 236.19, ["Neon|Ride"] = 54.18, ["Neon|Fly|Ride"] = 173.01, ["Mega"] = 143.54, ["Mega|Fly"] = 265.11, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.8, ["Fly"] = 328.78, ["Ride"] = 327.81, ["Fly|Ride"] = 382.33, ["Neon"] = 1638.57, ["Neon|Ride"] = 1501.86, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5288.29}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 160.86, ["Fly"] = 333.99, ["Ride"] = 194.14, ["Fly|Ride"] = 249.38, ["Neon"] = 918.75, ["Neon|Ride"] = 761.25, ["Neon|Fly|Ride"] = 700.88, ["Mega"] = 10019.26, ["Mega|Ride"] = 3412.5, ["Mega|Fly|Ride"] = 6262.05}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 89.25, ["Ride"] = 94.5, ["Fly|Ride"] = 178.47, ["Neon"] = 417.47, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.82, ["Ride"] = 69.93, ["Fly|Ride"] = 278.67, ["Neon"] = 346.52, ["Neon|Ride"] = 599.92, ["Neon|Fly|Ride"] = 487.4, ["Mega|Ride"] = 626.21, ["Mega|Fly|Ride"] = 1878.62}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 12.05, ["Fly"] = 57.29, ["Ride"] = 47.24, ["Fly|Ride"] = 102.3, ["Neon"] = 77.39, ["Neon|Ride"] = 101.71, ["Neon|Fly|Ride"] = 187.79, ["Mega"] = 210, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 515.65}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.29, ["Fly"] = 52.47, ["Ride"] = 23.14, ["Fly|Ride"] = 83.51, ["Neon"] = 19.48, ["Neon|Fly"] = 85.07, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 132.18, ["Mega"] = 117.72, ["Mega|Ride"] = 144.09, ["Mega|Fly|Ride"] = 321.46}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1031.99, ["Fly"] = 1082.72, ["Ride"] = 984.48, ["Fly|Ride"] = 984.38, ["Neon|Fly"] = 3464.85, ["Neon|Ride"] = 3183.21, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 10159.1}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 394.44, ["Ride"] = 557.33, ["Fly|Ride"] = 525, ["Neon|Ride"] = 3534.93, ["Neon|Fly|Ride"] = 1531.08, ["Mega"] = 10435.68, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 63, ["Fly"] = 139.86, ["Ride"] = 127.63, ["Fly|Ride"] = 168.07, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 417.47, ["Mega|Fly|Ride"] = 1947.5}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 500.29, ["Ride"] = 383.04, ["Fly|Ride"] = 390.34, ["Neon|Fly|Ride"] = 2087.35, ["Mega"] = 10436.72, ["Mega|Fly|Ride"] = 5566.96}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.44, ["Fly"] = 74.11, ["Ride"] = 25.32, ["Fly|Ride"] = 71.49, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 786.52}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 313.11, ["Fly|Ride"] = 459.27, ["Neon"] = 773.73, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4154.01, ["Mega|Ride"] = 4314.55, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.72, ["Fly"] = 125.98, ["Ride"] = 72.35, ["Fly|Ride"] = 132.53, ["Neon|Ride"] = 457.04, ["Neon|Fly|Ride"] = 278.67, ["Mega|Fly|Ride"] = 1461.15}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 2087.35, ["Fly|Ride"] = 1967.95, ["Neon|Ride"] = 11022.77, ["Neon|Fly|Ride"] = 6470.78, ["Mega"] = 50096.24, ["Mega|Fly|Ride"] = 23656.91}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.89, ["Fly"] = 54.29, ["Ride"] = 47.24, ["Fly|Ride"] = 113.96, ["Neon"] = 64.22, ["Neon|Fly"] = 230.67, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 234.56, ["Mega"] = 374.7, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 49.53, ["Fly"] = 119.1, ["Ride"] = 79.17, ["Fly|Ride"] = 134.19, ["Neon"] = 277.64, ["Neon|Ride"] = 313.11, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1043.68, ["Mega|Fly|Ride"] = 1043.68}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 93.95, ["Fly"] = 90.81, ["Ride"] = 77.28, ["Fly|Ride"] = 97.11, ["Neon"] = 525, ["Neon|Fly|Ride"] = 516.64, ["Mega|Fly|Ride"] = 1823.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3477.52, ["Ride"] = 1073.63, ["Fly|Ride"] = 1043.44}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 455.56, ["Fly"] = 832.88, ["Ride"] = 682.58, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2834.24}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 82.69, ["Fly"] = 205.5, ["Ride"] = 119.6, ["Fly|Ride"] = 196.88, ["Neon"] = 427.92, ["Neon|Ride"] = 417.47, ["Neon|Fly|Ride"] = 615.77, ["Mega"] = 4174.7, ["Mega|Ride"] = 4174.7, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.61, ["Ride"] = 21.76, ["Fly|Ride"] = 134.92, ["Neon"] = 86.63, ["Neon|Ride"] = 137.64, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 42.32, ["Fly"] = 56.81, ["Ride"] = 48.57, ["Fly|Ride"] = 111.03, ["Neon"] = 262.5, ["Neon|Fly"] = 557.33, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 386.19, ["Mega|Ride"] = 1210.68, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Ride"] = 838.69, ["Fly|Ride"] = 892.5, ["Neon"] = 3060.05, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 682.5}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 6220.3, ["Fly|Ride"] = 4987.5, ["Neon"] = 42000, ["Neon|Ride"] = 29912.68, ["Neon|Fly|Ride"] = 17808, ["Mega|Fly|Ride"] = 89060.66}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.28, ["Fly"] = 410.93, ["Ride"] = 393.75, ["Neon"] = 1669.88, ["Neon|Ride"] = 2087.35, ["Neon|Fly|Ride"] = 2087.35, ["Mega"] = 6261, ["Mega|Fly|Ride"] = 6262.05}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 52.5, ["Fly"] = 278.67, ["Ride"] = 98.12, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 658.56, ["Neon|Fly|Ride"] = 557.33, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.17, ["Fly"] = 41.76, ["Ride"] = 37.69, ["Fly|Ride"] = 106.3, ["Neon"] = 113.3, ["Neon|Fly"] = 1260.06, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 667.96, ["Mega|Ride"] = 834.94, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.96, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 44.35, ["Neon"] = 208.76, ["Neon|Ride"] = 83.51, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2227.21}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.05, ["Ride"] = 25.39, ["Fly|Ride"] = 140.44, ["Neon"] = 115.5, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.75, ["Mega|Ride"] = 626.21, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 56.38, ["Ride"] = 21.93, ["Fly|Ride"] = 39.27, ["Neon"] = 31.38, ["Neon|Ride"] = 55.52, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 278.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.21, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 181.61, ["Neon|Fly"] = 834.94, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 370.52, ["Mega"] = 834.94, ["Mega|Ride"] = 682.58, ["Mega|Fly|Ride"] = 839.12}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 387.19, ["Fly"] = 465.94, ["Ride"] = 405.57, ["Fly|Ride"] = 483.77, ["Neon"] = 1586.4, ["Neon|Ride"] = 1392.27, ["Neon|Fly|Ride"] = 1344.31, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5142.18}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.93, ["Fly"] = 18.17, ["Ride"] = 15.05, ["Fly|Ride"] = 32.82, ["Neon"] = 18.38, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.44, ["Mega"] = 834.94, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 48.53, ["Fly"] = 81.85, ["Ride"] = 84, ["Fly|Ride"] = 145.69, ["Neon"] = 231, ["Neon|Fly"] = 292.25, ["Neon|Ride"] = 202.42, ["Neon|Fly|Ride"] = 267.06, ["Mega"] = 696.14, ["Mega|Ride"] = 582.64, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 767.81, ["Fly"] = 1015.62, ["Ride"] = 824.25, ["Fly|Ride"] = 893.82, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1561.88, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.82, ["Fly"] = 75.59, ["Ride"] = 47.7, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 257.23, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 339.71, ["Ride"] = 313.63, ["Fly|Ride"] = 381.94, ["Neon|Ride"] = 1417.13, ["Neon|Fly|Ride"] = 1120.71}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.16, ["Fly"] = 248.4, ["Ride"] = 196.76, ["Fly|Ride"] = 236.25, ["Neon|Ride"] = 807.81, ["Neon|Fly|Ride"] = 785.44, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 682.5, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3200.96, ["Neon|Fly|Ride"] = 3005.79, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.51, ["Ride"] = 45.94, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Fly"] = 283.43, ["Neon|Ride"] = 78.73, ["Neon|Fly|Ride"] = 273.99, ["Mega"] = 354.38, ["Mega|Ride"] = 362.56, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Fly"] = 3590.9, ["Ride"] = 3924.38, ["Fly|Ride"] = 3473.14, ["Neon|Fly|Ride"] = 6956.25, ["Mega|Fly|Ride"] = 24837.22}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 118.12, ["Fly"] = 166.28, ["Ride"] = 134.93, ["Fly|Ride"] = 157.5, ["Neon"] = 550.97, ["Neon|Ride"] = 599.08, ["Neon|Fly|Ride"] = 577.5, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.6, ["Fly"] = 27.33, ["Ride"] = 20.89, ["Fly|Ride"] = 52.2, ["Neon"] = 19.85, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 113.38, ["Mega"] = 147, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.86, ["Ride"] = 22.6, ["Fly|Ride"] = 57.71, ["Neon"] = 20.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 157.5, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 325.99}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 89.15, ["Fly"] = 116.82, ["Ride"] = 35.63, ["Fly|Ride"] = 77.24, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1032.94, ["Ride"] = 1392.27, ["Fly|Ride"] = 1299.64, ["Neon|Ride"] = 3898.13}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Ride"] = 6958.17, ["Fly|Ride"] = 13125}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.93, ["Fly"] = 35.49, ["Ride"] = 24.55, ["Fly|Ride"] = 43.66, ["Neon"] = 452.13, ["Neon|Ride"] = 181.61, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2504.82, ["Mega|Ride"] = 972.71, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 15.51, ["Fly"] = 41.09, ["Ride"] = 25.27, ["Fly|Ride"] = 65.63, ["Neon"] = 89.24, ["Neon|Ride"] = 94.48, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 655.54, ["Mega|Ride"] = 696.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 66.89, ["Fly"] = 157.49, ["Ride"] = 70.72, ["Fly|Ride"] = 118.13, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 441, ["Mega|Fly|Ride"] = 1352.81}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.56, ["Ride"] = 310, ["Fly|Ride"] = 348.6, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10436.72, ["Mega|Fly|Ride"] = 5232.98}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.19, ["Ride"] = 30.34, ["Fly|Ride"] = 86.52, ["Neon"] = 23.26, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 68.25, ["Mega"] = 151.52, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 307.9}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 205.06, ["Fly"] = 245.27, ["Ride"] = 251.47, ["Fly|Ride"] = 282.19, ["Neon"] = 733.23, ["Neon|Ride"] = 934.1, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.39, ["Fly"] = 58.47, ["Ride"] = 17.07, ["Fly|Ride"] = 43.99, ["Neon"] = 23.37, ["Neon|Fly"] = 41.76, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 92.91, ["Mega"] = 472.38, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 303.71}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 231, ["Fly"] = 195.18, ["Ride"] = 304.15, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 10436.72, ["Mega|Ride"] = 4174.7, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14, ["Fly"] = 80.29, ["Ride"] = 26.55, ["Fly|Ride"] = 68.25, ["Neon"] = 73.49, ["Neon|Fly"] = 299.97, ["Neon|Ride"] = 94.48, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 626.21, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 69.93, ["Ride"] = 20.87, ["Fly|Ride"] = 59.07, ["Neon"] = 6.76, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 68.52, ["Mega|Ride"] = 100.7, ["Mega|Fly|Ride"] = 195.46}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Mega"] = 18.19, ["Mega|Ride"] = 137.67}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 24.44, ["Fly|Ride"] = 108.18, ["Neon"] = 6.24, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 73.07, ["Mega|Fly"] = 157457.51, ["Mega|Ride"] = 92.73, ["Mega|Fly|Ride"] = 172.43}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 77.23, ["Fly"] = 141.72, ["Ride"] = 107.82, ["Fly|Ride"] = 177.19, ["Neon"] = 347.17, ["Neon|Fly"] = 396.61, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 380.84, ["Mega|Fly|Ride"] = 1137.59}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.27, ["Ride"] = 15.73, ["Fly|Ride"] = 108.92, ["Neon"] = 5.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.14, ["Ride"] = 39.38, ["Neon"] = 78.75, ["Neon|Ride"] = 259.62, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.05, ["Neon"] = 3.68, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 29.27, ["Mega|Ride"] = 49.09, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 40.57, ["Ride"] = 15.53, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 11.68, ["Neon|Fly|Ride"] = 31.85, ["Mega"] = 11.68, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 50.3}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 12.48, ["Fly|Ride"] = 31.5, ["Neon"] = 3.77, ["Neon|Fly"] = 22.91, ["Neon|Ride"] = 14.62, ["Neon|Fly|Ride"] = 36.83, ["Mega"] = 31.05, ["Mega|Ride"] = 921.06, ["Mega|Fly|Ride"] = 137.45}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Neon"] = 2.63, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 62.39, ["Mega"] = 14.44, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.62, ["Neon"] = 5.25, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 47.7, ["Mega|Fly|Ride"] = 119}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.05, ["Neon"] = 4.74, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 15.92, ["Mega|Ride"] = 70.03, ["Mega|Fly|Ride"] = 208.76}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.67, ["Fly"] = 69.93, ["Ride"] = 19.58, ["Fly|Ride"] = 70.03, ["Neon"] = 8.95, ["Neon|Fly"] = 68.83, ["Neon|Ride"] = 27.46, ["Neon|Fly|Ride"] = 78.65, ["Mega"] = 119.49, ["Mega|Fly"] = 333.99, ["Mega|Ride"] = 124.64, ["Mega|Fly|Ride"] = 183.63}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 12.6, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 187.87}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 348.6}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 15.39, ["Mega"] = 105, ["Mega|Ride"] = 208.76, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.05, ["Ride"] = 24.94, ["Neon"] = 3.92, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 22.32, ["Mega|Ride"] = 50.11, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.82, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 13.02, ["Neon|Ride"] = 12.16, ["Neon|Fly|Ride"] = 31.05, ["Mega"] = 12.64, ["Mega|Fly"] = 39.67, ["Mega|Ride"] = 16.89, ["Mega|Fly|Ride"] = 49.26}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.15, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 36.75, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 20.58, ["Neon"] = 7.35, ["Neon|Ride"] = 52.2, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.55, ["Mega|Ride"] = 55.52, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.68, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 101.36, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.62, ["Fly"] = 262.49, ["Ride"] = 15.75, ["Fly|Ride"] = 43.32, ["Neon"] = 21.65, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 174.17}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 10.15, ["Ride"] = 11.65, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Fly"] = 13.44, ["Neon|Ride"] = 11.59, ["Neon|Fly|Ride"] = 28.2, ["Mega"] = 14.41, ["Mega|Fly"] = 36.9, ["Mega|Ride"] = 20.89, ["Mega|Fly|Ride"] = 45.1}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 20.89, ["Fly|Ride"] = 139.86, ["Neon"] = 14.34, ["Neon|Ride"] = 104.39, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 91.77, ["Mega|Ride"] = 157.95, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 19.09, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 32.37, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 235.86, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.67, ["Ride"] = 12.23, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 12.77, ["Neon|Fly|Ride"] = 34.48, ["Mega"] = 20.89, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 97.91}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 174.32, ["Ride"] = 28.73, ["Neon"] = 5.08, ["Neon|Ride"] = 27.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 83.51, ["Mega|Fly"] = 167.01, ["Mega|Ride"] = 116.71}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.63, ["Ride"] = 35.33, ["Fly|Ride"] = 65.63, ["Neon"] = 3.71, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 27.3, ["Mega|Fly"] = 139.86, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 236.19}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 17.62, ["Neon"] = 2.1, ["Neon|Fly"] = 41.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 19.69, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 98.12, ["Ride"] = 22.98, ["Fly|Ride"] = 41.91, ["Neon"] = 4.97, ["Neon|Fly"] = 56.38, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 164.3, ["Mega|Ride"] = 63.79}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 52.19, ["Neon"] = 5.24, ["Neon|Ride"] = 52.4, ["Mega"] = 40.69, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 311.03}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.34, ["Fly|Ride"] = 47.25, ["Neon"] = 6.6, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 84, ["Mega"] = 103.69, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 355.89}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.42, ["Fly"] = 41.16, ["Ride"] = 35.53, ["Neon"] = 39.29, ["Neon|Ride"] = 75.16, ["Neon|Fly|Ride"] = 315.55, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 834.94}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 5.25, ["Ride"] = 15.11, ["Fly|Ride"] = 34.94, ["Neon"] = 18.71, ["Neon|Fly"] = 106.3, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 137.43, ["Mega"] = 224.39, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 20.77, ["Ride"] = 13.8, ["Fly|Ride"] = 40.69, ["Neon"] = 14.34, ["Neon|Fly"] = 33.52, ["Neon|Ride"] = 26.35, ["Neon|Fly|Ride"] = 72.07, ["Mega"] = 273.95, ["Mega|Ride"] = 167.01, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 139.86, ["Neon"] = 23.55, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 9.74, ["Ride"] = 56.44, ["Neon"] = 262.39, ["Neon|Ride"] = 236.19, ["Mega"] = 557.33, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 32.61, ["Neon"] = 40.15, ["Neon|Ride"] = 28.2, ["Mega"] = 253.32, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.66, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 52.2, ["Neon|Ride"] = 103.34, ["Neon|Fly|Ride"] = 178.66, ["Mega"] = 472.38, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 296.28}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 64.98, ["Mega"] = 21, ["Mega|Fly"] = 125.25, ["Mega|Ride"] = 125.25, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.47, ["Fly"] = 23.4, ["Ride"] = 14.83, ["Fly|Ride"] = 55.49, ["Neon"] = 51.6, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.58, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 93.94, ["Ride"] = 19.85, ["Neon"] = 3.66, ["Neon|Fly"] = 31.9, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 155.9, ["Mega"] = 32.73, ["Mega|Fly"] = 139.86, ["Mega|Ride"] = 68.83, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 33.41, ["Neon"] = 5.69, ["Neon|Ride"] = 32.23, ["Mega"] = 77.44, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 16.35, ["Fly|Ride"] = 55.65, ["Neon"] = 7.16, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 125.25, ["Mega|Ride"] = 167.01, ["Mega|Fly|Ride"] = 161.65}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5, ["Ride"] = 33.77, ["Fly|Ride"] = 79.13, ["Neon"] = 66.94, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 275.45}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 32.81, ["Neon"] = 3.15, ["Mega"] = 19.58, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.29, ["Mega|Fly|Ride"] = 333.99}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 15.94, ["Fly|Ride"] = 278312.69, ["Neon"] = 3.84, ["Neon|Fly"] = 109.1, ["Neon|Ride"] = 19.62, ["Neon|Fly|Ride"] = 69.93, ["Mega"] = 27.55, ["Mega|Ride"] = 75.75, ["Mega|Fly|Ride"] = 124.66}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 16.41, ["Fly|Ride"] = 36.75, ["Neon"] = 3.94, ["Neon|Fly"] = 28.2, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 94.65}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 46.31, ["Fly|Ride"] = 150, ["Neon"] = 5.18, ["Neon|Ride"] = 27.02, ["Neon|Fly|Ride"] = 111.09, ["Mega"] = 30.19, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 165.96}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Ride"] = 164.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.75, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 104.37, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 21, ["Fly|Ride"] = 39.38, ["Neon"] = 2.61, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 80.8, ["Mega"] = 22.32, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.05, ["Ride"] = 47.81, ["Neon"] = 2.63, ["Mega"] = 27.36, ["Mega|Ride"] = 409.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.42, ["Neon"] = 6.35, ["Neon|Ride"] = 158.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 21.69, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 41.11, ["Neon"] = 12.91, ["Neon|Fly"] = 55.48, ["Neon|Ride"] = 16.94, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 123.2, ["Mega|Ride"] = 49.26, ["Mega|Fly|Ride"] = 86.13}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.76, ["Ride"] = 188.96, ["Neon"] = 137.69, ["Mega"] = 1043.68, ["Mega|Ride"] = 652.32, ["Mega|Fly|Ride"] = 542.72}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 42, ["Neon|Ride"] = 206.67, ["Mega"] = 1669.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 410.92, ["Neon"] = 41.76, ["Neon|Fly|Ride"] = 265.11, ["Mega"] = 299.97, ["Mega|Ride"] = 356.94, ["Mega|Fly|Ride"] = 367.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.79, ["Ride"] = 11.68, ["Fly|Ride"] = 21.82, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 11.46, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 13.08, ["Mega|Fly"] = 105, ["Mega|Ride"] = 20.41, ["Mega|Fly|Ride"] = 53.82}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 58.47, ["Fly|Ride"] = 156.56, ["Neon"] = 9.36, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 32.37, ["Neon|Fly|Ride"] = 696.14, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.05, ["Ride"] = 30.91, ["Neon"] = 2.1, ["Neon|Fly"] = 30.82, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 68.76, ["Mega"] = 12.71, ["Mega|Ride"] = 71.8, ["Mega|Fly|Ride"] = 123.2}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 123.27, ["Mega"] = 16.76, ["Mega|Ride"] = 112.73, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.94, ["Ride"] = 16.7, ["Fly|Ride"] = 42.69, ["Neon"] = 9.22, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 95.33, ["Mega"] = 208.95, ["Mega|Ride"] = 396.61, ["Mega|Fly|Ride"] = 387.36}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 161.1, ["Ride"] = 208.76, ["Fly|Ride"] = 177.19, ["Neon"] = 766.07, ["Mega"] = 8349.38, ["Mega|Fly|Ride"] = 3615.29}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.63, ["Ride"] = 19.85, ["Neon"] = 9.54, ["Neon|Ride"] = 64.32, ["Mega"] = 91.88, ["Mega|Ride"] = 164.92, ["Mega|Fly|Ride"] = 834.94}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 10.23, ["Fly"] = 64.32, ["Ride"] = 25.57, ["Fly|Ride"] = 59.07, ["Neon"] = 52.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 167.01, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 413.32}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 14.39, ["Fly|Ride"] = 32.13, ["Neon"] = 6.28, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 45.96, ["Mega"] = 49.68, ["Mega|Ride"] = 80.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.14, ["Neon|Ride"] = 69.21, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 171.18, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.63, ["Fly"] = 19.26, ["Ride"] = 14.7, ["Fly|Ride"] = 36, ["Neon"] = 28.62, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.83, ["Mega|Ride"] = 274.5, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 61.64, ["Fly|Ride"] = 249.58, ["Neon"] = 61.46, ["Neon|Ride"] = 139.85, ["Neon|Fly|Ride"] = 619.96, ["Mega"] = 521.85, ["Mega|Ride"] = 258.22, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.35, ["Fly"] = 19.85, ["Ride"] = 15.42, ["Fly|Ride"] = 35.49, ["Neon"] = 17.95, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 244.23, ["Mega|Fly|Ride"] = 299.56}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.74, ["Fly"] = 178.5, ["Ride"] = 89.25, ["Fly|Ride"] = 137.82, ["Neon"] = 417.47, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 319.3, ["Neon|Fly|Ride"] = 381.94}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 333.99, ["Ride"] = 248.79, ["Fly|Ride"] = 320.42, ["Neon|Ride"] = 2609.19, ["Neon|Fly|Ride"] = 1252.41, ["Mega"] = 10436.72, ["Mega|Fly|Ride"] = 4728.89}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 50.94, ["Fly"] = 137.68, ["Ride"] = 57.75, ["Fly|Ride"] = 111.57, ["Neon"] = 315.32, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 410.84, ["Mega|Fly|Ride"] = 1169.4}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.33, ["Fly"] = 96.5, ["Ride"] = 28.2, ["Fly|Ride"] = 139.86, ["Neon"] = 24.26, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 283.43, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 18.35, ["Fly"] = 69.93, ["Ride"] = 30.14, ["Fly|Ride"] = 91.87, ["Neon"] = 81.2, ["Neon|Fly"] = 69.93, ["Neon|Ride"] = 154.71, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 14.91, ["Ride"] = 17.82, ["Fly|Ride"] = 34.93, ["Neon"] = 4.17, ["Neon|Fly"] = 25.99, ["Neon|Ride"] = 19.15, ["Neon|Fly|Ride"] = 60.78, ["Mega"] = 60.56, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 455.64}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.55, ["Fly"] = 72.12, ["Ride"] = 20.89, ["Fly|Ride"] = 81.38, ["Neon"] = 100.85, ["Neon|Ride"] = 98.12, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 830.79, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.52, ["Fly"] = 20.89, ["Ride"] = 18.38, ["Fly|Ride"] = 41.76, ["Neon"] = 19.69, ["Neon|Fly"] = 98.12, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 115.86, ["Mega"] = 193.69, ["Mega|Ride"] = 211.18, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 5.15, ["Ride"] = 17.54, ["Fly|Ride"] = 328.13, ["Neon"] = 19.28, ["Neon|Ride"] = 57.75, ["Mega"] = 207.38, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.67, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.59, ["Mega|Ride"] = 36.54, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 3.23, ["Fly"] = 19.09, ["Ride"] = 18.17, ["Fly|Ride"] = 41.76, ["Neon"] = 14.43, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 103.95, ["Mega|Fly|Ride"] = 154.58}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 4.13, ["Fly"] = 24.94, ["Ride"] = 18.52, ["Fly|Ride"] = 60.9, ["Neon"] = 45.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 557.33, ["Mega"] = 265.11, ["Mega|Ride"] = 125.25, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 161.02, ["Fly"] = 417.47, ["Ride"] = 252.48, ["Fly|Ride"] = 235.81, ["Neon"] = 622.08, ["Neon|Ride"] = 749.37, ["Neon|Fly|Ride"] = 568.47, ["Mega"] = 4174.7, ["Mega|Fly|Ride"] = 5250}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.79, ["Ride"] = 32.37, ["Fly|Ride"] = 126.37, ["Neon"] = 53.82, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 412.27, ["Mega|Ride"] = 304.84, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 18.31, ["Ride"] = 15.4, ["Fly|Ride"] = 46.08, ["Neon"] = 23.38, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 278.67}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 18.38, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 167.37, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 468.72, ["Mega"] = 516.46, ["Mega|Fly"] = 834.94, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 1043.68}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.18}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.3, ["Ride"] = 28.25, ["Fly|Ride"] = 115.12, ["Neon"] = 27.46, ["Neon|Ride"] = 274.26, ["Neon|Fly|Ride"] = 348.6, ["Mega"] = 343.08, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 912.18}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.5, ["Fly"] = 35.49, ["Ride"] = 30.22, ["Fly|Ride"] = 58.97, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 2087.35, ["Mega|Fly|Ride"] = 1949.59}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 17.36, ["Fly|Ride"] = 104.39, ["Neon"] = 3.94, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 31.5, ["Mega|Fly"] = 278.67, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.45, ["Fly"] = 27.65, ["Ride"] = 24.02, ["Fly|Ride"] = 62.63, ["Neon"] = 52.41, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 236.19, ["Mega"] = 233.21, ["Mega|Fly"] = 394.44, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 369.48}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 16.17, ["Fly|Ride"] = 35.49, ["Neon"] = 10.8, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 31.74, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 174.89, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 209.9}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.05, ["Ride"] = 26.25, ["Fly|Ride"] = 208.76, ["Neon"] = 3.94, ["Neon|Ride"] = 22.89, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 26.79, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 38.28, ["Ride"] = 87.94, ["Fly|Ride"] = 141.72, ["Neon"] = 226.08, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 348.6, ["Mega"] = 799.99, ["Mega|Ride"] = 971.67, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 8.13, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 86.82, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.75, ["Fly"] = 210, ["Ride"] = 21, ["Fly|Ride"] = 69.12, ["Neon"] = 22.82, ["Neon|Fly"] = 315, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 372.43, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 86.52, ["Fly"] = 433.12, ["Ride"] = 385.86, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 542.72, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1788.22}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.29, ["Fly"] = 26.17, ["Ride"] = 24.29, ["Fly|Ride"] = 65.77, ["Neon"] = 57.75, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 202.49, ["Mega"] = 236.25, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.57, ["Fly"] = 145.09, ["Ride"] = 110.25, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 412.27, ["Mega"] = 1077.08, ["Mega|Ride"] = 1041.59, ["Mega|Fly|Ride"] = 988.67}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.73, ["Ride"] = 55.9, ["Fly|Ride"] = 199.5, ["Neon"] = 87.94, ["Neon|Ride"] = 107.48, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 503.07, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 425.83}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 8.33, ["Ride"] = 27.64, ["Fly|Ride"] = 48.29, ["Neon"] = 74.89, ["Neon|Ride"] = 35.49, ["Neon|Fly|Ride"] = 252.74, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.08, ["Ride"] = 45.2, ["Fly|Ride"] = 278.67, ["Neon"] = 63.72, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 312.08, ["Mega"] = 283.81, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 15.67, ["Ride"] = 26.25, ["Fly|Ride"] = 55.73, ["Neon"] = 29.81, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 187.87, ["Mega"] = 236.25, ["Mega|Ride"] = 350.69, ["Mega|Fly|Ride"] = 394.44}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.35, ["Neon|Ride"] = 57.1, ["Mega"] = 22.32, ["Mega|Ride"] = 125.25, ["Mega|Fly|Ride"] = 412.27}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.04, ["Ride"] = 28.25, ["Neon"] = 21.33, ["Neon|Fly"] = 125.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 125.25, ["Mega|Ride"] = 235.89, ["Mega|Fly|Ride"] = 446.72}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 25.83, ["Mega"] = 347.17, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.77, ["Ride"] = 32.79, ["Neon"] = 25.07, ["Neon|Ride"] = 82.95, ["Mega"] = 124.69, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 348.6}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 534.56, ["Ride"] = 607.69, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1947.65, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 4.88, ["Fly"] = 28.2, ["Ride"] = 19.2, ["Fly|Ride"] = 63.79, ["Neon"] = 36.54, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 158.26, ["Mega|Ride"] = 355.72, ["Mega|Fly|Ride"] = 500.98}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.6, ["Fly"] = 524.69, ["Ride"] = 31.13, ["Fly|Ride"] = 51.35, ["Neon"] = 48.57, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.6, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 265.11, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 5.8, ["Ride"] = 22.51, ["Fly|Ride"] = 313.11, ["Neon|Ride"] = 196.88, ["Mega"] = 258.57, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 20.48, ["Fly|Ride"] = 90.57, ["Neon"] = 5.51, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 95.94, ["Mega"] = 60.13, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 283.43}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.93, ["Ride"] = 19.69, ["Neon"] = 3.94, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 91.88, ["Mega|Ride"] = 65.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 11.43, ["Ride"] = 36.75, ["Fly|Ride"] = 323.65, ["Neon"] = 64.32, ["Neon|Ride"] = 78.66, ["Mega|Ride"] = 555.26, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.05, ["Ride"] = 25.23, ["Neon"] = 3.73, ["Neon|Ride"] = 75.16, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 167.01, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 8.36, ["Fly"] = 27.17, ["Ride"] = 58.97, ["Neon"] = 15.75, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 137.44, ["Mega"] = 183.73, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.94, ["Ride"] = 523.69, ["Fly|Ride"] = 642.92, ["Neon|Ride"] = 1921.81, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 10.5, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 417.47, ["Neon"] = 30.08, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 487.4, ["Mega|Ride"] = 448.76}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 84.49, ["Ride"] = 36.75, ["Neon"] = 3.94, ["Neon|Ride"] = 27.06, ["Neon|Fly|Ride"] = 119, ["Mega"] = 79.33, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 177.09}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 31.37, ["Mega|Ride"] = 111.69, ["Mega|Fly|Ride"] = 355.36}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 11.12, ["Fly"] = 107.63, ["Ride"] = 68.84, ["Fly|Ride"] = 120.03, ["Neon"] = 120.7, ["Neon|Ride"] = 111.06, ["Neon|Fly|Ride"] = 236.19, ["Mega"] = 433.14, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 6, ["Ride"] = 71.31, ["Neon"] = 80.22, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 834.94, ["Mega"] = 542.72, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 1669.88}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 6.27, ["Ride"] = 31.38, ["Fly|Ride"] = 131.25, ["Neon"] = 311.25, ["Neon|Ride"] = 176.55, ["Mega"] = 644.69, ["Mega|Ride"] = 1071.88, ["Mega|Fly|Ride"] = 348.6}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 48.02, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 98.12, ["Neon|Ride"] = 182.43, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 610.32, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 433.13, ["Fly|Ride"] = 760.53, ["Neon"] = 1043.68, ["Neon|Ride"] = 1392.27, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3618.43, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.14, ["Fly"] = 19.69, ["Ride"] = 19.81, ["Fly|Ride"] = 236.25, ["Neon"] = 120.89, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 195.18, ["Mega|Ride"] = 557.33, ["Mega|Fly|Ride"] = 858.96}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.61, ["Ride"] = 125.99, ["Neon"] = 39.66, ["Neon|Ride"] = 105, ["Mega"] = 221.27, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.1, ["Ride"] = 70.88, ["Fly|Ride"] = 261, ["Neon"] = 89.12, ["Neon|Ride"] = 119.55, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 273, ["Mega|Fly"] = 696.14, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 377.35}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 139.86, ["Neon"] = 6.57, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 48.57, ["Mega|Ride"] = 123.17, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.77, ["Ride"] = 72.82, ["Neon"] = 323.56, ["Neon|Ride"] = 365.3, ["Mega"] = 1809.74, ["Mega|Ride"] = 1392.27, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 590.47, ["Ride"] = 25.18, ["Neon"] = 7.25, ["Neon|Fly"] = 181.61, ["Neon|Ride"] = 77.16, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 69.57, ["Mega|Ride"] = 108.36, ["Mega|Fly|Ride"] = 223.36}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 89.39, ["Ride"] = 30.19, ["Fly|Ride"] = 154.37, ["Neon"] = 6.57, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 43.34, ["Neon|Fly|Ride"] = 117.11, ["Mega"] = 34.8, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.9, ["Fly|Ride"] = 125.2, ["Neon"] = 15.67, ["Neon|Ride"] = 59.53, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.7, ["Fly"] = 94.48, ["Ride"] = 65.63, ["Fly|Ride"] = 197.23, ["Neon"] = 268.84, ["Neon|Ride"] = 297.36, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 255.75, ["Ride"] = 268.82, ["Fly|Ride"] = 411.76, ["Neon"] = 1450.73, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1297.57, ["Mega"] = 6262.05, ["Mega|Fly|Ride"] = 4088.44}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.75, ["Neon"] = 33.42, ["Mega"] = 116.6, ["Mega|Ride"] = 212.2}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.62, ["Fly"] = 69.93, ["Ride"] = 25.07, ["Neon"] = 8.28, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 55.52, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 349.64}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.99, ["Fly"] = 30.72, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Neon|Ride"] = 69.93, ["Mega"] = 208.76, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.63, ["Fly"] = 68.6, ["Ride"] = 43.55, ["Fly|Ride"] = 139.86, ["Neon"] = 5.99, ["Neon|Ride"] = 36.19, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 115.24, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.24, ["Ride"] = 91.87, ["Neon"] = 7.58, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 275.55}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.52, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 6.17, ["Neon|Ride"] = 28.2, ["Neon|Fly|Ride"] = 417.47, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.61, ["Ride"] = 24.93, ["Fly|Ride"] = 61.69, ["Neon"] = 16.7, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 85.31, ["Mega"] = 115.86, ["Mega|Ride"] = 235.89, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 26.25, ["Ride"] = 56.6, ["Fly|Ride"] = 77.15, ["Neon"] = 111.03, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1148.05, ["Mega|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 81.86, ["Ride"] = 77.86, ["Fly|Ride"] = 136.29, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 455.67, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 18.95, ["Fly|Ride"] = 131.25, ["Neon"] = 3.84, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 45.85, ["Mega|Fly"] = 89.78, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 12.54, ["Ride"] = 15.75, ["Fly|Ride"] = 39.37, ["Neon"] = 4.09, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.43, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.57, ["Ride"] = 73.48, ["Neon"] = 52.5, ["Neon|Ride"] = 94.48, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 527.63, ["Mega|Ride"] = 487.4, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 232.32, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 492.19, ["Neon"] = 4174.7, ["Neon|Ride"] = 1949.59, ["Mega|Fly|Ride"] = 7305.72}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 24.41, ["Fly"] = 101.33, ["Ride"] = 56.38, ["Fly|Ride"] = 116.08, ["Neon"] = 142.77, ["Neon|Ride"] = 202.85, ["Neon|Fly|Ride"] = 299.97, ["Mega|Ride"] = 1150.24, ["Mega|Fly|Ride"] = 934.1}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 34.93, ["Fly|Ride"] = 281.29, ["Neon"] = 9.19, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 89.67, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 3.2, ["Fly"] = 205.47, ["Ride"] = 26.25, ["Fly|Ride"] = 142.94, ["Neon"] = 16.7, ["Mega|Ride"] = 460.27}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.24, ["Fly"] = 162.6, ["Ride"] = 49.18, ["Fly|Ride"] = 65.63, ["Neon"] = 630.62, ["Neon|Ride"] = 352.22, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2504.82, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1461.15}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 76.02, ["Ride"] = 103.95, ["Fly|Ride"] = 207.72, ["Neon"] = 434.43, ["Neon|Ride"] = 557.33, ["Neon|Fly|Ride"] = 557.33, ["Mega"] = 8349.38, ["Mega|Fly|Ride"] = 2087.35}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 223.02, ["Ride"] = 283.47, ["Fly|Ride"] = 713.88, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1103, ["Mega|Fly|Ride"] = 3606.94}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.4, ["Fly"] = 51.19, ["Ride"] = 41.11, ["Fly|Ride"] = 150.94, ["Neon"] = 82.69, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 388.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 12.32, ["Fly|Ride"] = 41.9, ["Neon"] = 6.35, ["Neon|Ride"] = 22.87, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 111.03, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 124.49}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 15.67, ["Fly"] = 38.53, ["Ride"] = 17.62, ["Fly|Ride"] = 44.01, ["Neon"] = 31.5, ["Neon|Ride"] = 34.82, ["Neon|Fly|Ride"] = 93, ["Mega|Fly|Ride"] = 359.03}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 487.4, ["Ride"] = 301.88, ["Fly|Ride"] = 599.08, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.07, ["Mega"] = 10019.26, ["Mega|Fly|Ride"] = 5132.66}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 41.76, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 69.93, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 8.13, ["Fly"] = 41.76, ["Ride"] = 14.49, ["Fly|Ride"] = 50.68, ["Neon"] = 27.13, ["Neon|Fly"] = 73.07, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 207.72, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 19.03, ["Ride"] = 139.86, ["Neon"] = 133.46, ["Neon|Fly"] = 417.47, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 299.97, ["Mega"] = 527.69, ["Mega|Ride"] = 624.14, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 133.61, ["Fly"] = 157.5, ["Ride"] = 114.35, ["Fly|Ride"] = 126, ["Neon"] = 646.05, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.37, ["Fly"] = 43.29, ["Ride"] = 27.75, ["Fly|Ride"] = 51.18, ["Neon"] = 103.69, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 154.47, ["Mega"] = 695.09, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 542.17}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 19.02, ["Neon"] = 2.5, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 696.14, ["Mega"] = 21.67}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.54, ["Fly|Ride"] = 72.19, ["Neon"] = 2.62, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 73.71, ["Mega"] = 24.43, ["Mega|Fly"] = 83.25, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 19.85, ["Fly"] = 417.47, ["Ride"] = 62.16, ["Fly|Ride"] = 98.12, ["Neon"] = 29.81, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 194.48, ["Mega"] = 164.37, ["Mega|Fly"] = 313.11, ["Mega|Ride"] = 214.01, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1461.15, ["Fly"] = 1629.69, ["Ride"] = 1271.82, ["Fly|Ride"] = 1365, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12475.32}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.25, ["Fly"] = 918.75, ["Ride"] = 557.33, ["Fly|Ride"] = 523.69, ["Neon"] = 2423.08, ["Neon|Ride"] = 1601.25, ["Neon|Fly|Ride"] = 1934.98, ["Mega"] = 16698.75, ["Mega|Fly|Ride"] = 9462.98}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 375.38, ["Ride"] = 383.25, ["Fly|Ride"] = 480.38, ["Neon"] = 871.84, ["Neon|Ride"] = 791.11, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2624.79}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 399, ["Fly"] = 410.86, ["Ride"] = 360.39, ["Fly|Ride"] = 479.07, ["Neon"] = 2087.35, ["Neon|Fly"] = 2087.35, ["Neon|Ride"] = 1055.25, ["Neon|Fly|Ride"] = 1260.06, ["Mega|Fly|Ride"] = 5563.83}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15, ["Fly|Ride"] = 34.73, ["Neon"] = 8.24, ["Neon|Ride"] = 43.85, ["Neon|Fly|Ride"] = 105, ["Mega"] = 68.52, ["Mega|Fly"] = 98.12, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 181.61}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 378, ["Fly"] = 1392.27, ["Ride"] = 412.27, ["Fly|Ride"] = 549.94, ["Neon"] = 1252.41, ["Neon|Ride"] = 1293.12, ["Neon|Fly|Ride"] = 1444.46, ["Mega|Ride"] = 6679.52, ["Mega|Fly|Ride"] = 4612.15}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.3, ["Fly"] = 183.75, ["Ride"] = 90.04, ["Fly|Ride"] = 112.54, ["Neon"] = 16.1, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 205.43, ["Mega"] = 83.91, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 376.98}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 14.39, ["Fly|Ride"] = 31.01, ["Neon"] = 7.84, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 29.47, ["Mega|Ride"] = 181.13}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 52.5, ["Fly|Ride"] = 459.38, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 656.25, ["Mega|Ride"] = 682.58, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7873.25, ["Ride"] = 26.25, ["Fly|Ride"] = 68.24, ["Neon"] = 32.82, ["Mega|Ride"] = 429.86, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.63, ["Neon|Ride"] = 38.8, ["Neon|Fly|Ride"] = 93.94, ["Mega"] = 22.23, ["Mega|Ride"] = 90.19, ["Mega|Fly|Ride"] = 123.17}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.94, ["Fly"] = 34.13, ["Ride"] = 19.84, ["Fly|Ride"] = 67.6, ["Neon"] = 8.6, ["Neon|Fly"] = 98.12, ["Neon|Ride"] = 40.99, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 110.97, ["Mega|Fly"] = 283.43, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 188.47}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.94, ["Fly"] = 56.38, ["Ride"] = 15.67, ["Fly|Ride"] = 51.97, ["Neon"] = 27.57, ["Neon|Fly"] = 125.25, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 331.9}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.81, ["Ride"] = 28.2, ["Neon"] = 63.79, ["Mega"] = 512.53, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6299.07, ["Ride"] = 41.76, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 441.35, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 64.05, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 6.57, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 24.45, ["Mega"] = 60.56, ["Mega|Ride"] = 178.34, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 131.25, ["Ride"] = 178.5, ["Fly|Ride"] = 210, ["Neon|Ride"] = 961.29, ["Neon|Fly|Ride"] = 696.14, ["Mega"] = 8349.38, ["Mega|Ride"] = 4174.7, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.78, ["Fly|Ride"] = 40.62, ["Neon"] = 6.27, ["Neon|Fly"] = 30.74, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 53.9, ["Mega"] = 44.63, ["Mega|Ride"] = 52.64, ["Mega|Fly|Ride"] = 126.88}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 3.92, ["Fly"] = 139.86, ["Ride"] = 39.29, ["Fly|Ride"] = 160.12, ["Neon"] = 250.49, ["Neon|Ride"] = 181.89, ["Mega"] = 311.07, ["Mega|Fly|Ride"] = 1043.68}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 278.67, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 417.47, ["Mega"] = 904.87, ["Mega|Ride"] = 921.14, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 190.32, ["Ride"] = 253.21, ["Fly|Ride"] = 300.07, ["Neon"] = 708.74, ["Neon|Fly|Ride"] = 982.66, ["Mega|Fly|Ride"] = 3378.24}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.62, ["Fly"] = 168.88, ["Fly|Ride"] = 141.72, ["Neon"] = 158.26, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 15.12, ["Ride"] = 139.86, ["Fly|Ride"] = 626.21, ["Neon"] = 63.79, ["Neon|Ride"] = 199.5, ["Mega"] = 771.75, ["Mega|Ride"] = 626.21, ["Mega|Fly|Ride"] = 2087.35}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Ride"] = 1043.44, ["Fly|Ride"] = 1050, ["Neon"] = 4732.02, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4696.53, ["Mega|Fly|Ride"] = 18225.65}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.41, ["Fly"] = 19.47, ["Ride"] = 19.82, ["Fly|Ride"] = 43.32, ["Neon"] = 26.25, ["Neon|Fly"] = 84.91, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 226.75, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.25, ["Ride"] = 31.32, ["Fly|Ride"] = 135.19, ["Neon"] = 33.08, ["Neon|Ride"] = 504, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 242.05, ["Mega|Fly|Ride"] = 696.14}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.47, ["Ride"] = 27.41, ["Fly|Ride"] = 69.57, ["Neon"] = 15.67, ["Neon|Ride"] = 30.3, ["Mega"] = 91.88, ["Mega|Ride"] = 191.49, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.16, ["Fly"] = 35.44, ["Ride"] = 36.88, ["Fly|Ride"] = 81.09, ["Neon"] = 70.75, ["Neon|Ride"] = 78.62, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 437.07, ["Mega|Ride"] = 427.49, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 20.55, ["Ride"] = 17.75, ["Fly|Ride"] = 40.91, ["Neon"] = 56.38, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 37.58, ["Neon|Fly|Ride"] = 93.18, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 28.2, ["Neon"] = 11.87, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.25, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 137.06, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 249.45, ["Fly"] = 265.11, ["Ride"] = 328.13, ["Fly|Ride"] = 348.6, ["Neon|Fly"] = 1043.68, ["Neon|Ride"] = 1113.61, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 22.7, ["Fly|Ride"] = 72.19, ["Neon"] = 7.88, ["Neon|Fly"] = 83.51, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 81.38, ["Mega|Fly"] = 417.47, ["Mega|Ride"] = 98.12, ["Mega|Fly|Ride"] = 263.02}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.94, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 248.4, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.24, ["Fly"] = 96.96, ["Ride"] = 26.24, ["Neon"] = 13.54, ["Neon|Ride"] = 1392.27, ["Mega"] = 94.48, ["Mega|Fly"] = 139.86, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 478.31}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 487.4, ["Ride"] = 655.98, ["Fly|Ride"] = 708.57, ["Neon|Ride"] = 1443.65, ["Neon|Fly|Ride"] = 1732.43, ["Mega"] = 4723.71, ["Mega|Ride"] = 5009.64, ["Mega|Fly|Ride"] = 2876.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.69, ["Fly"] = 118.1, ["Ride"] = 63.79, ["Fly|Ride"] = 188.01, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 728.44, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.14, ["Fly"] = 75.59, ["Ride"] = 32.37, ["Fly|Ride"] = 90.57, ["Neon"] = 91.87, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 125.25, ["Mega"] = 471.13, ["Mega|Ride"] = 412.56, ["Mega|Fly|Ride"] = 679.45}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.51, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 240.06}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 76.01, ["Fly"] = 81.38, ["Ride"] = 84.54, ["Fly|Ride"] = 181.13, ["Neon"] = 262.48, ["Neon|Fly"] = 245.85, ["Neon|Ride"] = 294.16, ["Neon|Fly|Ride"] = 394.44, ["Mega|Fly|Ride"] = 1187.59}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 52.5, ["Neon"] = 6.27, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 124.21, ["Mega"] = 53.44, ["Mega|Fly|Ride"] = 417.47}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.8, ["Fly"] = 126.37, ["Ride"] = 20.48, ["Fly|Ride"] = 85.04, ["Neon"] = 66.2, ["Neon|Ride"] = 158.26, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 416.45, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.39, ["Fly"] = 78.75, ["Ride"] = 79.95, ["Fly|Ride"] = 154.47, ["Neon"] = 270.31, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 377.91, ["Mega"] = 1252.41, ["Mega|Ride"] = 3480.66, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 27.65, ["Ride"] = 13.84, ["Fly|Ride"] = 30.55, ["Neon"] = 2.1, ["Neon|Fly"] = 23.96, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 15.62, ["Mega|Fly"] = 118.1, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 82.69}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.74, ["Fly"] = 32.82, ["Ride"] = 44.89, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 61.56, ["Neon|Fly|Ride"] = 417.47, ["Mega"] = 131.25, ["Mega|Ride"] = 276.35, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.75, ["Ride"] = 44.68, ["Fly|Ride"] = 204.58, ["Neon"] = 181.61, ["Neon|Ride"] = 181.61, ["Mega"] = 1043.68, ["Mega|Ride"] = 534.11, ["Mega|Fly|Ride"] = 1889.49}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Mega"] = 21.57, ["Mega|Ride"] = 79.33, ["Mega|Fly|Ride"] = 153.64}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 12.44, ["Fly"] = 185.72, ["Ride"] = 58.96, ["Fly|Ride"] = 164.07, ["Neon"] = 65.63, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 512.46, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 640.83}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.05, ["Fly"] = 101.61, ["Ride"] = 26.5, ["Fly|Ride"] = 98.44, ["Neon"] = 430.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 174.8, ["Mega|Ride"] = 357, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 9.45, ["Ride"] = 18.85, ["Neon"] = 26.25, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.43, ["Mega"] = 231, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 7.88, ["Fly"] = 2087.35, ["Ride"] = 78.04, ["Neon"] = 156.26, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 6297.89, ["Mega"] = 329.48, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43, ["Mega"] = 68.16, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 125.25}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 6.18, ["Neon|Ride"] = 103.34, ["Mega"] = 30.23, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 292.25}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 35.44}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 35.46, ["Fly"] = 78.75, ["Ride"] = 37.05, ["Neon"] = 131.25, ["Neon|Ride"] = 269.08, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1669.88, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 125.25, ["Mega"] = 20.21, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 313.11}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 426.57, ["Fly"] = 459.38, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2083.18, ["Neon|Ride"] = 2047.74, ["Mega"] = 16698.75, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 23.93, ["Fly|Ride"] = 66.26, ["Neon"] = 32.18, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 87.71, ["Mega|Fly"] = 156.56, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 95.55, ["Ride"] = 20.86, ["Fly|Ride"] = 69.21, ["Neon"] = 23.63, ["Neon|Ride"] = 36.28, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 346.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 15.23, ["Fly"] = 78.29, ["Ride"] = 50.3, ["Fly|Ride"] = 475.82, ["Neon"] = 102.78, ["Neon|Ride"] = 167.01, ["Mega"] = 818.26, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 595.94}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.11, ["Fly"] = 417.47, ["Ride"] = 27.76, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 12.98, ["Fly"] = 139.53, ["Ride"] = 139.86, ["Fly|Ride"] = 157.5, ["Neon"] = 104.39, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 369.74, ["Mega"] = 391.69, ["Mega|Ride"] = 394.44, ["Mega|Fly|Ride"] = 764.54}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 5.93, ["Fly"] = 105, ["Ride"] = 32.48, ["Fly|Ride"] = 133.88, ["Neon"] = 29.44, ["Neon|Ride"] = 76.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 216.57, ["Mega|Fly"] = 557.33, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 351.71}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Fly"] = 47.24, ["Ride"] = 11.24, ["Fly|Ride"] = 69.93, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.39, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 14.86, ["Mega|Fly"] = 32.21, ["Mega|Ride"] = 24.86, ["Mega|Fly|Ride"] = 108.94}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 9.22, ["Fly"] = 278.36, ["Ride"] = 32.7, ["Fly|Ride"] = 104.39, ["Neon"] = 22.01, ["Neon|Fly"] = 118.1, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 223.36, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.5, ["Fly"] = 413.34, ["Ride"] = 348.46, ["Fly|Ride"] = 421.32, ["Neon"] = 1260.06, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 5114, ["Mega|Fly|Ride"] = 4587.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 106.32, ["Ride"] = 210, ["Fly|Ride"] = 278.67, ["Neon"] = 367.5, ["Neon|Ride"] = 483.84, ["Neon|Fly|Ride"] = 549.94, ["Mega"] = 2227.21, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1704.94}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.33, ["Ride"] = 14.6, ["Fly|Ride"] = 41.76, ["Neon"] = 56.38, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 35.49, ["Neon|Fly|Ride"] = 63.31, ["Mega|Fly"] = 207.72, ["Mega|Ride"] = 78.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 11.92, ["Fly|Ride"] = 32.82, ["Neon"] = 8.39, ["Neon|Fly"] = 39.29, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 62.27, ["Mega"] = 70.87, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 111.69, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 208.76, ["Mega|Ride"] = 417.47, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 220.48, ["Fly"] = 420, ["Ride"] = 315, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 2054.58, ["Neon|Fly|Ride"] = 2018.48, ["Mega|Ride"] = 8349.38, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 4.18, ["Fly"] = 22.32, ["Ride"] = 13.93, ["Fly|Ride"] = 32.67, ["Neon"] = 18.8, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 28.2, ["Neon|Fly|Ride"] = 152.39, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.97, ["Ride"] = 82.1, ["Fly|Ride"] = 208.76, ["Neon"] = 52.12, ["Neon|Ride"] = 417.47, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 253.32, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 400.79}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.2, ["Neon"] = 5.23, ["Neon|Ride"] = 41.76, ["Mega"] = 65.54, ["Mega|Ride"] = 205.51}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 9.6, ["Fly"] = 55.69, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 80.07, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 192.51, ["Mega"] = 728.44, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.37, ["Ride"] = 107.63, ["Fly|Ride"] = 210, ["Neon"] = 194.14, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 252.58, ["Neon|Fly|Ride"] = 529.16, ["Mega"] = 833.9, ["Mega|Fly"] = 2191.73, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 786.52}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.63, ["Ride"] = 44.46, ["Fly|Ride"] = 115.86, ["Neon"] = 138.81, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 208.76, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.35, ["Ride"] = 14.44, ["Fly|Ride"] = 35.49, ["Neon"] = 2.63, ["Neon|Fly"] = 23.72, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 46.69, ["Mega"] = 21.51, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 40.25, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.49, ["Ride"] = 283.43, ["Fly|Ride"] = 318.84, ["Neon"] = 787.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 4314.55}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 9.19, ["Fly"] = 101.18, ["Ride"] = 42.37, ["Fly|Ride"] = 105, ["Neon"] = 127.86, ["Neon|Ride"] = 188.96, ["Neon|Fly|Ride"] = 328.13, ["Mega|Fly|Ride"] = 696.14}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 15.44, ["Fly|Ride"] = 42.09, ["Neon"] = 5.16, ["Neon|Fly"] = 34.97, ["Neon|Ride"] = 27.18, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 61.59, ["Mega|Fly"] = 278.67, ["Mega|Ride"] = 63.79, ["Mega|Fly|Ride"] = 296.43}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.75, ["Fly|Ride"] = 39.89, ["Neon"] = 2.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 126.37, ["Mega"] = 21.51, ["Mega|Fly"] = 139.86, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 177.85}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 69.29, ["Neon"] = 7.55, ["Neon|Fly"] = 708.57, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 93.54, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 12.01, ["Fly"] = 38.74, ["Ride"] = 28.2, ["Fly|Ride"] = 64.79, ["Neon"] = 64.32, ["Neon|Fly"] = 265.11, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 305.82, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.42, ["Fly"] = 41.76, ["Ride"] = 55.11, ["Fly|Ride"] = 72.19, ["Neon"] = 42.35, ["Neon|Ride"] = 69.93, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 414.75, ["Mega|Fly|Ride"] = 421.65}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 278.67, ["Neon"] = 2.91, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 30.97, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.49, ["Fly"] = 98.12, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 31.29, ["Neon|Fly"] = 102.92, ["Neon|Ride"] = 73.36, ["Neon|Fly|Ride"] = 180.86, ["Mega"] = 201.38, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 278.67}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 69.93, ["Ride"] = 193.73, ["Neon"] = 6.27, ["Neon|Fly"] = 111.69, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.94, ["Mega|Ride"] = 103.34, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.62, ["Ride"] = 15.65, ["Fly|Ride"] = 68.83, ["Neon"] = 5.15, ["Neon|Ride"] = 20.68, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 52.41, ["Mega|Ride"] = 86, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 680.61, ["Ride"] = 630, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3260.22}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 12.75, ["Ride"] = 15.47, ["Fly|Ride"] = 29.04, ["Neon"] = 11.46, ["Neon|Fly"] = 139.86, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 73.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.52, ["Ride"] = 70.45, ["Fly|Ride"] = 210, ["Neon"] = 14.01, ["Neon|Ride"] = 88.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 74.11, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.12, ["Fly"] = 30.72, ["Ride"] = 21.82, ["Fly|Ride"] = 44.62, ["Neon"] = 65.52, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 63.79, ["Neon|Fly|Ride"] = 128.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 372.92}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 18.32, ["Ride"] = 14.79, ["Fly|Ride"] = 35.44, ["Neon"] = 6.75, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 22.23, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 65.62, ["Mega|Ride"] = 91.83, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 23.39, ["Ride"] = 47.79, ["Fly|Ride"] = 277.64, ["Neon"] = 116.82, ["Neon|Ride"] = 257.44, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1183.54}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.85, ["Fly|Ride"] = 64.05, ["Neon"] = 10.7, ["Neon|Fly"] = 134.65, ["Neon|Ride"] = 31.2, ["Neon|Fly|Ride"] = 144.04, ["Mega"] = 131.25, ["Mega|Ride"] = 118.5, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.6, ["Fly"] = 73.62, ["Ride"] = 19.36, ["Fly|Ride"] = 65.63, ["Neon"] = 12.54, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 158.26, ["Mega"] = 328.13, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.37, ["Mega"] = 93.32, ["Mega|Ride"] = 174.8, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.83, ["Neon"] = 5.2, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.95, ["Mega"] = 58.47, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 52.85, ["Mega|Fly|Ride"] = 167.01}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 15.75, ["Fly"] = 19.08, ["Ride"] = 23.63, ["Fly|Ride"] = 37.11, ["Neon"] = 309.74, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 98.43, ["Mega|Fly|Ride"] = 388.73}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 846.57, ["Ride"] = 689.07, ["Fly|Ride"] = 945, ["Neon"] = 1559.25, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 2113.13, ["Mega"] = 8349.38, ["Mega|Fly|Ride"] = 7236.84}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.9, ["Ride"] = 14.99, ["Fly|Ride"] = 32.86, ["Neon"] = 3.9, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 68.9, ["Mega|Ride"] = 72.59, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 10.06, ["Ride"] = 139.86, ["Neon"] = 31.9, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 391.39, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 487.4}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.07, ["Ride"] = 85.32, ["Fly|Ride"] = 108.74, ["Neon"] = 467.58, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 283.43, ["Mega"] = 3162.88, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.69, ["Ride"] = 45.95, ["Fly|Ride"] = 104.89, ["Neon"] = 183.75, ["Neon|Ride"] = 192.05, ["Neon|Fly|Ride"] = 195.18, ["Mega"] = 946.63, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.83, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 56.38, ["Neon|Ride"] = 69.93, ["Neon|Fly|Ride"] = 121.47, ["Mega"] = 417.47, ["Mega|Ride"] = 557.33, ["Mega|Fly|Ride"] = 554.21}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.37, ["Ride"] = 63.51, ["Neon"] = 134.87, ["Neon|Ride"] = 360.76, ["Mega"] = 283.43, ["Mega|Fly"] = 512.53, ["Mega|Ride"] = 372.01, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 139.86, ["Fly"] = 126.88, ["Ride"] = 28.61, ["Neon"] = 227.54, ["Neon|Ride"] = 308.23, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.6}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.18, ["Fly"] = 131248.69, ["Ride"] = 19.11, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 176.98, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 141.72, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Ride"] = 48.02, ["Neon"] = 80.33, ["Mega"] = 882.17}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 41.07, ["Fly"] = 417.47, ["Ride"] = 74.82, ["Fly|Ride"] = 111.69, ["Neon"] = 258.85, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 654.41, ["Mega|Ride"] = 834.94, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.25, ["Fly"] = 15.21, ["Ride"] = 17.07, ["Fly|Ride"] = 31.9, ["Neon"] = 41.76, ["Neon|Fly"] = 63, ["Neon|Ride"] = 35.49, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 262.5, ["Mega|Fly"] = 416.45, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 205}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.16, ["Fly"] = 148.22, ["Ride"] = 27.09, ["Fly|Ride"] = 79.75, ["Neon"] = 30.19, ["Neon|Ride"] = 55.52, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 129.93, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.11, ["Mega"] = 45.29, ["Mega|Ride"] = 195.18, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 35.66, ["Fly"] = 65.63, ["Ride"] = 48.2, ["Fly|Ride"] = 94.48, ["Neon"] = 393.75, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 317.22, ["Mega"] = 1113.61, ["Mega|Ride"] = 834.94, ["Mega|Fly|Ride"] = 991.5}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.17, ["Fly|Ride"] = 65.63, ["Neon"] = 4.51, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.26, ["Mega"] = 74.72, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 13.13, ["Ride"] = 62.32, ["Fly|Ride"] = 277.64, ["Neon"] = 107.63, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 682.58}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 14.98, ["Fly|Ride"] = 40.13, ["Neon"] = 86.92, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 65.62, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.08, ["Fly"] = 52.49, ["Ride"] = 18.51, ["Neon"] = 35.44, ["Neon|Ride"] = 410.93, ["Mega"] = 390.34, ["Mega|Ride"] = 403.92, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 64.84, ["Neon"] = 59.06, ["Neon|Ride"] = 157.55, ["Mega"] = 409.86, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.87, ["Ride"] = 134.93, ["Neon"] = 269.07, ["Neon|Fly|Ride"] = 728.49, ["Mega"] = 1575.37, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.28, ["Ride"] = 119, ["Neon"] = 99.01, ["Neon|Ride"] = 417.47, ["Mega"] = 417.47, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.09, ["Ride"] = 105, ["Neon"] = 162.74, ["Neon|Fly"] = 208.76, ["Mega|Ride"] = 1043.68}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 11.57, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 130.2, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 834.94, ["Mega|Fly"] = 2087.35, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 5.95, ["Neon"] = 20.89, ["Neon|Ride"] = 278.67, ["Mega"] = 126, ["Mega|Fly|Ride"] = 315.32}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.41, ["Ride"] = 18.38, ["Fly|Ride"] = 60.61, ["Neon"] = 6.57, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 104.39, ["Mega|Ride"] = 120.03, ["Mega|Fly|Ride"] = 202.49}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 6.57, ["Fly"] = 50.19, ["Ride"] = 39.67, ["Fly|Ride"] = 77.9, ["Neon"] = 19.52, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.87, ["Mega"] = 102.46, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 394.44}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 17.41, ["Fly|Ride"] = 56.16, ["Neon"] = 5.57, ["Neon|Fly"] = 31.9, ["Neon|Ride"] = 26.19, ["Neon|Fly|Ride"] = 69.06, ["Mega"] = 51.19, ["Mega|Ride"] = 74.97, ["Mega|Fly|Ride"] = 285.8}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 59.07, ["Fly|Ride"] = 118.13, ["Neon"] = 14.44, ["Neon|Ride"] = 98.12, ["Neon|Fly|Ride"] = 258.85, ["Mega"] = 246.65, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.88, ["Fly"] = 65.63, ["Ride"] = 28.88, ["Fly|Ride"] = 103.69, ["Neon"] = 26.25, ["Neon|Fly"] = 472.38, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.87, ["Fly"] = 131.25, ["Ride"] = 23.63, ["Fly|Ride"] = 60.4, ["Neon"] = 26.24, ["Neon|Fly"] = 55.52, ["Neon|Ride"] = 43.42, ["Neon|Fly|Ride"] = 118.01, ["Mega"] = 222.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 386.3}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 5.25, ["Fly"] = 35.49, ["Ride"] = 15.62, ["Fly|Ride"] = 45.8, ["Neon"] = 15.75, ["Neon|Fly"] = 83.51, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 158.26, ["Mega"] = 230.67, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 248.4}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 4.74, ["Fly"] = 57.66, ["Ride"] = 43.18, ["Neon"] = 19.85, ["Neon|Fly"] = 410.46, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 94.39, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 249.34}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 28.2, ["Fly"] = 208.76, ["Ride"] = 105, ["Fly|Ride"] = 286.13, ["Neon"] = 126, ["Neon|Ride"] = 225.45, ["Neon|Fly|Ride"] = 425.15, ["Mega"] = 525, ["Mega|Fly"] = 766.07, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 729.09}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 42.88, ["Ride"] = 90.55, ["Fly|Ride"] = 167.01, ["Neon"] = 252.87, ["Neon|Ride"] = 315.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1575.37, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1221.94}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.05, ["Fly"] = 50.96, ["Ride"] = 19.5, ["Fly|Ride"] = 60.52, ["Neon"] = 3.71, ["Neon|Ride"] = 40.45, ["Mega"] = 26.25, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.63, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 60.03, ["Ride"] = 97.13, ["Neon"] = 188.96, ["Neon|Ride"] = 341.25, ["Mega|Ride"] = 1238.86, ["Mega|Fly|Ride"] = 1526.9}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.45, ["Fly"] = 190.32, ["Ride"] = 34, ["Fly|Ride"] = 126, ["Neon"] = 36.62, ["Neon|Ride"] = 49.07, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 173.9, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 125.25, ["Fly|Ride"] = 137.45, ["Neon"] = 7.95, ["Neon|Ride"] = 49.62, ["Mega"] = 64.76, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 94.9, ["Mega|Fly|Ride"] = 325.4}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.63, ["Fly"] = 27.3, ["Ride"] = 14.93, ["Fly|Ride"] = 37.69, ["Neon"] = 13.13, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 108.55, ["Mega"] = 169.32, ["Mega|Fly"] = 348.6, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 14.44, ["Fly|Ride"] = 40.74, ["Neon"] = 2.63, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 25.68, ["Neon|Fly|Ride"] = 134.65, ["Mega"] = 23.72, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 84.73, ["Neon"] = 4.74, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 62.63, ["Mega"] = 42.39, ["Mega|Ride"] = 133.61, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.48, ["Neon"] = 2.63, ["Neon|Ride"] = 145.08, ["Mega"] = 22.32, ["Mega|Fly|Ride"] = 316.25}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 8.34, ["Ride"] = 104.98, ["Neon"] = 28.77, ["Neon|Ride"] = 158.26, ["Neon|Fly|Ride"] = 626.21, ["Mega"] = 213.94, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 15.26, ["Ride"] = 31.44, ["Fly|Ride"] = 202.98, ["Neon"] = 41.76, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 183.7, ["Mega|Ride"] = 315.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.17, ["Fly"] = 23.76, ["Ride"] = 15.67, ["Fly|Ride"] = 45.94, ["Neon"] = 56.38, ["Neon|Fly"] = 68.76, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 557.33, ["Mega|Fly|Ride"] = 335.86}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.64, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15, ["Mega|Ride"] = 2018.48, ["Mega|Fly|Ride"] = 1774.26}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 630, ["Mega"] = 639.85, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 974.8}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.67, ["Fly|Ride"] = 30.73, ["Neon"] = 2.5, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 41.01, ["Mega"] = 51.98, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 13.59, ["Fly|Ride"] = 26.97, ["Neon"] = 5.25, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 19.15, ["Neon|Fly|Ride"] = 41.16, ["Mega"] = 42, ["Mega|Fly"] = 83.51, ["Mega|Ride"] = 56.21, ["Mega|Fly|Ride"] = 94.48}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 597.53, ["Ride"] = 498.75, ["Fly|Ride"] = 549.94, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 5.19, ["Ride"] = 55.6, ["Neon"] = 45.94, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 25.07, ["Ride"] = 15.27, ["Fly|Ride"] = 34.13, ["Neon"] = 5.23, ["Neon|Fly"] = 23.16, ["Neon|Ride"] = 16.37, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 140.76, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 103.94, ["Ride"] = 164.07, ["Fly|Ride"] = 348.6, ["Neon"] = 188.96, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 457.14, ["Mega"] = 1006.11, ["Mega|Ride"] = 695.63}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 13.84, ["Fly|Ride"] = 47.24, ["Neon"] = 8.99, ["Neon|Fly"] = 48.7, ["Neon|Ride"] = 23.85, ["Neon|Fly|Ride"] = 66.8, ["Mega"] = 84, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 315.32}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.93, ["Ride"] = 42.94, ["Neon"] = 2.62, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.8, ["Mega|Ride"] = 67.24, ["Mega|Fly|Ride"] = 190.77}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 44.94, ["Fly"] = 195.2, ["Ride"] = 83.51, ["Fly|Ride"] = 164.07, ["Neon"] = 220.5, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.75, ["Fly|Ride"] = 52.5, ["Neon"] = 6.79, ["Neon|Ride"] = 40.45, ["Neon|Fly|Ride"] = 63, ["Mega"] = 45.05, ["Mega|Ride"] = 181.83, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 29.3, ["Ride"] = 69.43, ["Fly|Ride"] = 139.86, ["Neon"] = 233.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1649.02, ["Mega|Ride"] = 1669.88, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.98, ["Ride"] = 162.85, ["Fly|Ride"] = 158.65, ["Neon"] = 16.7, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 481.61, ["Mega"] = 104.99, ["Mega|Ride"] = 603.75, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 69.93, ["Ride"] = 26.25, ["Fly|Ride"] = 66.81, ["Neon"] = 10.96, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 129.43, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 32.44, ["Ride"] = 63.79, ["Fly|Ride"] = 213.63, ["Neon"] = 420, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1392.27}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 908.98, ["Neon"] = 6.27, ["Neon|Ride"] = 138.46, ["Neon|Fly|Ride"] = 154.71, ["Mega"] = 129.93, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 139.86, ["Mega|Fly|Ride"] = 181.79}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 17.73, ["Fly|Ride"] = 144.04, ["Neon"] = 11.82, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.02, ["Neon|Fly|Ride"] = 118.1, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 10.5, ["Fly"] = 52.2, ["Ride"] = 29.5, ["Fly|Ride"] = 75.78, ["Neon"] = 81.77, ["Neon|Ride"] = 119.55, ["Neon|Fly|Ride"] = 150, ["Mega"] = 430.5, ["Mega|Ride"] = 409.8, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 58.46, ["Ride"] = 28.37, ["Fly|Ride"] = 139.86, ["Neon"] = 134.65, ["Neon|Ride"] = 294.07, ["Neon|Fly|Ride"] = 158.26, ["Mega"] = 557.33, ["Mega|Ride"] = 419.37, ["Mega|Fly|Ride"] = 866.81}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.47, ["Fly"] = 49.07, ["Ride"] = 34.17, ["Fly|Ride"] = 69.93, ["Neon"] = 120.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 320.42, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 430.01}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.97, ["Fly"] = 135.19, ["Ride"] = 125.25, ["Fly|Ride"] = 167.01, ["Neon"] = 330.75, ["Neon|Ride"] = 446.72, ["Neon|Fly|Ride"] = 465.94, ["Mega|Ride"] = 1575.37, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.82, ["Fly"] = 139.86, ["Ride"] = 51.36, ["Fly|Ride"] = 313.11, ["Neon"] = 37.8, ["Neon|Ride"] = 111.03, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Ride"] = 348.6, ["Mega|Fly|Ride"] = 374.73}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 8.24, ["Ride"] = 26.57, ["Fly|Ride"] = 78.74, ["Neon"] = 125.25, ["Neon|Ride"] = 64.72, ["Mega"] = 154.47, ["Mega|Ride"] = 208.76, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 34.83, ["Fly"] = 287.55, ["Ride"] = 27.65, ["Fly|Ride"] = 108.63, ["Neon"] = 65.63, ["Neon|Ride"] = 174.08, ["Mega"] = 430.5, ["Mega|Ride"] = 487.4, ["Mega|Fly|Ride"] = 637.88}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 11.47, ["Fly|Ride"] = 25.99, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 14.16, ["Mega|Fly"] = 66.81, ["Mega|Ride"] = 25.31, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.54, ["Ride"] = 110.25, ["Fly|Ride"] = 278.67, ["Neon"] = 388.17, ["Neon|Fly"] = 2366.02, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1113.61, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.41, ["Fly|Ride"] = 112.22, ["Neon"] = 3.56, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 43.17, ["Mega|Ride"] = 77.3, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.2, ["Ride"] = 15.73, ["Fly|Ride"] = 58.46, ["Neon"] = 11.71, ["Neon|Fly"] = 139.86, ["Neon|Ride"] = 35, ["Neon|Fly|Ride"] = 98.12, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 131.91, ["Ride"] = 123.27, ["Fly|Ride"] = 196.88, ["Neon"] = 262.5, ["Neon|Ride"] = 540.75, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 1286.25, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.67, ["Neon"] = 9.19, ["Neon|Ride"] = 60.56, ["Mega"] = 64.22, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 3.25}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 27.65, ["Neon"] = 9.19, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 78.74, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.68, ["Ride"] = 208.76, ["Fly|Ride"] = 288.75, ["Neon"] = 600.24, ["Neon|Ride"] = 667.96, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2065.21}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.55, ["Ride"] = 26.16, ["Neon"] = 17.35, ["Neon|Ride"] = 56.94, ["Mega"] = 183.35, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 81.81, ["Neon"] = 6.46, ["Neon|Ride"] = 25.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.37, ["Mega|Ride"] = 98.12, ["Mega|Fly|Ride"] = 138.21}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 10.31, ["Ride"] = 28.2, ["Neon"] = 47.59, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 417.47, ["Mega|Ride"] = 548.65, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 11.36, ["Fly"] = 25.99, ["Ride"] = 20.98, ["Fly|Ride"] = 54.66, ["Neon"] = 93.17, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 597.19, ["Mega|Ride"] = 538.13, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 22.31, ["Ride"] = 58.94, ["Fly|Ride"] = 111.69, ["Neon"] = 170.86, ["Neon|Ride"] = 167.01, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 748.72, ["Mega|Ride"] = 677.86, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 196.88, ["Fly"] = 274.19, ["Ride"] = 203.44, ["Fly|Ride"] = 472.38, ["Neon"] = 591.73, ["Neon|Fly"] = 834.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 636.69, ["Mega|Fly|Ride"] = 3117.47}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 30.18, ["Fly"] = 78.75, ["Ride"] = 36, ["Fly|Ride"] = 110.24, ["Neon"] = 471.14, ["Neon|Fly"] = 6262.05, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 919.49, ["Mega|Ride"] = 959.15, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 5.2, ["Fly"] = 131.23, ["Ride"] = 19.27, ["Fly|Ride"] = 65.63, ["Neon"] = 11.74, ["Neon|Ride"] = 50.11, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.82, ["Mega|Ride"] = 265.11, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 24.33, ["Fly"] = 236.19, ["Ride"] = 32.48, ["Fly|Ride"] = 125.25, ["Neon"] = 56.38, ["Neon|Fly"] = 139.86, ["Neon|Ride"] = 114.14, ["Mega"] = 379.31, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42.88, ["Fly"] = 141.72, ["Ride"] = 96.57, ["Fly|Ride"] = 131.52, ["Neon"] = 315.32, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 403.92, ["Mega"] = 987.13, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 11.22, ["Ride"] = 129.94, ["Neon"] = 139.86, ["Neon|Ride"] = 250.49, ["Neon|Fly|Ride"] = 460.27, ["Mega"] = 683.82, ["Mega|Ride"] = 826.66, ["Mega|Fly|Ride"] = 934.1}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 378, ["Fly|Ride"] = 349.64, ["Neon|Ride"] = 3149.54}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.04, ["Ride"] = 33.14, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 1026.67}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.05, ["Fly"] = 37.59, ["Ride"] = 12.6, ["Fly|Ride"] = 104.39, ["Neon"] = 2.63, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 73.97, ["Mega"] = 27.55, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 43.25, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 4.03, ["Neon"] = 18.69, ["Neon|Ride"] = 66.76, ["Neon|Fly|Ride"] = 259.9, ["Mega"] = 143.83, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 460.27}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 10.17, ["Ride"] = 63.79, ["Fly|Ride"] = 144.18, ["Neon"] = 20.78, ["Neon|Ride"] = 124.21, ["Neon|Fly|Ride"] = 974.8, ["Mega"] = 107.63, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 262.97, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 414.11, ["Ride"] = 458.07, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1461.15, ["Neon|Fly|Ride"] = 1461.15, ["Mega|Fly|Ride"] = 4862.82}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 5.1, ["Fly"] = 64.39, ["Ride"] = 16.96, ["Fly|Ride"] = 57.21, ["Neon"] = 37.7, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 86.64, ["Mega"] = 168, ["Mega|Ride"] = 273.33, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.91, ["Fly"] = 21.4, ["Ride"] = 16.53, ["Fly|Ride"] = 32.16, ["Neon"] = 26.71, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 417.47, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 696.14, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 4.03, ["Fly"] = 44.01, ["Ride"] = 28.87, ["Neon"] = 14.46, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 111.03, ["Mega|Ride"] = 205.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 100.7, ["Fly"] = 34.94, ["Ride"] = 40.2, ["Fly|Ride"] = 98.12, ["Neon"] = 140.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 833.9, ["Mega|Fly|Ride"] = 660.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 50.19, ["Neon"] = 6.35, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 456.09, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.08, ["Fly"] = 64.26, ["Ride"] = 24.19, ["Fly|Ride"] = 91.88, ["Neon"] = 141.72, ["Neon|Ride"] = 178.35, ["Mega|Ride"] = 751.46, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.56, ["Neon"] = 4.67, ["Neon|Ride"] = 28.66, ["Mega"] = 52.41, ["Mega|Ride"] = 94.48, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.94, ["Ride"] = 139.86, ["Neon"] = 65.68}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.75, ["Neon"] = 77.09, ["Neon|Ride"] = 472.38, ["Mega"] = 307.9, ["Mega|Ride"] = 472.38, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.61, ["Fly"] = 28.69, ["Ride"] = 25.44, ["Fly|Ride"] = 137.79, ["Neon"] = 51.98, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 586.57, ["Mega|Ride"] = 313.74, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 321.57, ["Fly"] = 446.72, ["Ride"] = 334.69, ["Fly|Ride"] = 393.75, ["Neon"] = 1260.06, ["Neon|Ride"] = 1371.7, ["Neon|Fly|Ride"] = 1378.13}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.37, ["Ride"] = 15.43, ["Fly|Ride"] = 39.38, ["Neon"] = 12.49, ["Neon|Fly"] = 79.13, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 216.13, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.14, ["Fly"] = 111.69, ["Ride"] = 45.93, ["Fly|Ride"] = 79.13, ["Neon"] = 42.84, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 287.03, ["Mega|Ride"] = 370.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 34.92, ["Ride"] = 115.66, ["Fly|Ride"] = 315, ["Neon"] = 102.93, ["Neon|Ride"] = 177.44, ["Neon|Fly|Ride"] = 404.6, ["Mega"] = 334.36, ["Mega|Ride"] = 384.32, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 139.76, ["Fly"] = 169.32, ["Ride"] = 139.86, ["Fly|Ride"] = 443.58, ["Neon"] = 834.94, ["Neon|Ride"] = 1466.16, ["Neon|Fly|Ride"] = 693, ["Mega|Ride"] = 6200.25, ["Mega|Fly|Ride"] = 3339.76}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 29.98, ["Fly"] = 119, ["Ride"] = 126.37, ["Fly|Ride"] = 142.63, ["Neon"] = 77.24, ["Neon|Ride"] = 208.76, ["Neon|Fly|Ride"] = 217.09, ["Mega"] = 258.57, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 17.06, ["Fly|Ride"] = 58.35, ["Neon"] = 12.48, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.58, ["Mega|Ride"] = 154.47, ["Mega|Fly|Ride"] = 158.26}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 9.97, ["Ride"] = 34, ["Neon"] = 32.19, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.32, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 66.81, ["Fly"] = 86.63, ["Ride"] = 90.96, ["Fly|Ride"] = 202.63, ["Neon"] = 262.4, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 516.64, ["Mega"] = 511.88, ["Mega|Ride"] = 507.35, ["Mega|Fly|Ride"] = 619.4}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.63, ["Ride"] = 131.25, ["Neon"] = 6.15, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 72.19, ["Mega|Ride"] = 123.29, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 18.66, ["Neon"] = 111.69, ["Neon|Ride"] = 312.08, ["Mega"] = 469.27}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1017.19, ["Fly"] = 2087.35, ["Ride"] = 1181.25, ["Fly|Ride"] = 1086.75, ["Neon"] = 3618.43, ["Neon|Ride"] = 3938.41, ["Neon|Fly|Ride"] = 2888.61, ["Mega|Fly|Ride"] = 11828.98}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 17.22, ["Fly"] = 76.61, ["Ride"] = 164.3, ["Fly|Ride"] = 191.63, ["Neon"] = 186.27, ["Neon|Fly"] = 278.67, ["Neon|Ride"] = 531.57, ["Mega|Fly|Ride"] = 654.93}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.26, ["Ride"] = 23.28, ["Fly|Ride"] = 80.89, ["Neon"] = 10.66, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 107.51, ["Mega"] = 82.43, ["Mega|Ride"] = 94.48, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 10.4, ["Ride"] = 131.23, ["Fly|Ride"] = 139.86, ["Neon"] = 79.13, ["Mega"] = 316.25, ["Mega|Ride"] = 421.91, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 60.56, ["Neon"] = 2.63, ["Neon|Ride"] = 18.9, ["Neon|Fly|Ride"] = 91.76, ["Mega"] = 17.3, ["Mega|Fly"] = 125.25, ["Mega|Ride"] = 45.83, ["Mega|Fly|Ride"] = 158}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 63.95, ["Ride"] = 120.03, ["Fly|Ride"] = 196.77, ["Neon"] = 315.32, ["Neon|Fly"] = 417.47, ["Neon|Ride"] = 306.94, ["Mega"] = 1062.09, ["Mega|Ride"] = 1044.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.82, ["Ride"] = 44.63, ["Fly|Ride"] = 154.68, ["Neon"] = 68.76, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 261, ["Mega"] = 520.8, ["Mega|Ride"] = 554.21, ["Mega|Fly|Ride"] = 527.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.71, ["Neon"] = 13.13, ["Neon|Ride"] = 47.24, ["Mega"] = 139.86, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 157.4, ["Fly"] = 154.47, ["Ride"] = 208.76, ["Fly|Ride"] = 112.87, ["Neon"] = 231.71, ["Neon|Ride"] = 195.18, ["Neon|Fly|Ride"] = 348.6, ["Mega"] = 687.95, ["Mega|Ride"] = 446.72, ["Mega|Fly|Ride"] = 788.05}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 24.94, ["Fly"] = 35.49, ["Ride"] = 44.89, ["Fly|Ride"] = 98.32, ["Neon"] = 41.76, ["Neon|Ride"] = 74.11, ["Neon|Fly|Ride"] = 315, ["Mega"] = 276.35, ["Mega|Ride"] = 513.59, ["Mega|Fly|Ride"] = 473.85}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.33, ["Ride"] = 103.03, ["Neon"] = 278.67, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 775.69, ["Mega"] = 1893.24, ["Mega|Ride"] = 1669.88, ["Mega|Fly|Ride"] = 1642.75}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.25, ["Ride"] = 60.56, ["Fly|Ride"] = 78.75, ["Neon"] = 18.37, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 105.95, ["Mega|Ride"] = 228.58, ["Mega|Fly|Ride"] = 472.38}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 13.85, ["Ride"] = 20.55, ["Fly|Ride"] = 47.24, ["Neon"] = 82.67, ["Neon|Ride"] = 99.17, ["Neon|Fly|Ride"] = 126.37, ["Mega"] = 464.63, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 545.35}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 170.63, ["Ride"] = 177.18, ["Fly|Ride"] = 386.16, ["Neon"] = 568.99, ["Neon|Ride"] = 495.38, ["Neon|Fly|Ride"] = 641.82, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.62, ["Fly"] = 19, ["Ride"] = 15.71, ["Fly|Ride"] = 41.76, ["Neon"] = 12.59, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 68.16, ["Mega"] = 124.69, ["Mega|Ride"] = 236.19, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 9.15, ["Fly"] = 103.95, ["Ride"] = 29.27, ["Fly|Ride"] = 63.79, ["Neon"] = 40.17, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 408.51, ["Mega|Ride"] = 434.1, ["Mega|Fly|Ride"] = 334.46}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 14.53, ["Fly|Ride"] = 44.63, ["Neon"] = 2.1, ["Neon|Fly"] = 25.91, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 14.27, ["Mega|Fly"] = 49.62, ["Mega|Ride"] = 32.67, ["Mega|Fly|Ride"] = 103.34}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.38, ["Fly|Ride"] = 39.38, ["Neon"] = 3.53, ["Neon|Ride"] = 41.76, ["Mega"] = 18.38, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 18.38, ["Fly|Ride"] = 87.55, ["Neon"] = 15.67, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 39.1, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 117.39, ["Neon|Ride"] = 354.29, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 676.32}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 14.4, ["Ride"] = 16.82, ["Fly|Ride"] = 38.07, ["Neon"] = 13.05, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 98.12, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 286.05}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 45.36, ["Fly"] = 37.21, ["Ride"] = 23.62, ["Fly|Ride"] = 66.9, ["Neon"] = 28.55, ["Neon|Fly"] = 47.7, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 105, ["Mega"] = 209.35, ["Mega|Fly"] = 417.47, ["Mega|Ride"] = 192.55, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 18.09, ["Fly|Ride"] = 83.51, ["Neon"] = 7.55, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 19.26, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 49.26, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 204.74, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.86, ["Fly"] = 169.32, ["Ride"] = 23.43, ["Neon"] = 29.27, ["Neon|Ride"] = 85.29, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 220.85, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 6.42, ["Ride"] = 21.19, ["Fly|Ride"] = 170.63, ["Neon"] = 65.63, ["Neon|Ride"] = 125.25, ["Mega"] = 557.33, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.25, ["Fly"] = 42.21, ["Ride"] = 22.45, ["Fly|Ride"] = 44.91, ["Neon"] = 22.5, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 49.62, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 333.99, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 383.25}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.27, ["Ride"] = 15.42, ["Fly|Ride"] = 35.49, ["Neon"] = 14.24, ["Neon|Fly"] = 47.24, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 236.15, ["Mega|Ride"] = 250.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 311.77, ["Fly|Ride"] = 392.43, ["Neon"] = 1113.62, ["Neon|Ride"] = 1381.7, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 8.91, ["Ride"] = 64.97, ["Neon"] = 42.95, ["Neon|Ride"] = 56.38, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.86, ["Fly"] = 104.39, ["Ride"] = 21.84, ["Fly|Ride"] = 79.07, ["Neon"] = 20.93, ["Neon|Ride"] = 48.02, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.16, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 278.67}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.71, ["Ride"] = 41.76, ["Neon"] = 60.9, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 626.21, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 15.41, ["Ride"] = 11.69, ["Fly|Ride"] = 26.04, ["Neon"] = 2.63, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 15.27, ["Neon|Fly|Ride"] = 37, ["Mega"] = 18.26, ["Mega|Fly"] = 69.93, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.62, ["Fly"] = 22.97, ["Ride"] = 20.89, ["Fly|Ride"] = 61.56, ["Neon"] = 10.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 96.37, ["Mega|Ride"] = 130.66, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 3.19, ["Ride"] = 69.93, ["Neon"] = 13.13, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 82.82, ["Mega|Ride"] = 348.6, ["Mega|Fly|Ride"] = 208.76}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.51, ["Fly"] = 165.34, ["Ride"] = 125.25, ["Fly|Ride"] = 176.69, ["Neon"] = 556.49, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 3480.66, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 6.57, ["Fly"] = 84.68, ["Ride"] = 28.88, ["Fly|Ride"] = 262.49, ["Neon"] = 22.23, ["Neon|Ride"] = 109.83, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 169.31, ["Mega|Ride"] = 270.38, ["Mega|Fly|Ride"] = 486.36}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 51.14, ["Neon"] = 15.3, ["Neon|Ride"] = 63.79, ["Neon|Fly|Ride"] = 530.15, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 178.47, ["Mega|Fly|Ride"] = 348.6}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 63.66, ["Fly"] = 210, ["Ride"] = 91.88, ["Neon"] = 143.07, ["Neon|Ride"] = 216.12, ["Neon|Fly|Ride"] = 348.6, ["Mega"] = 400.32, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.42, ["Fly|Ride"] = 91.88, ["Neon"] = 2.1, ["Neon|Fly"] = 20.46, ["Neon|Ride"] = 14.52, ["Neon|Fly|Ride"] = 39.04, ["Mega"] = 18.04, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 92.02}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.9, ["Neon|Ride"] = 65.52, ["Neon|Fly|Ride"] = 209.35, ["Mega"] = 26.07, ["Mega|Ride"] = 90.68, ["Mega|Fly|Ride"] = 181.89}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.62, ["Ride"] = 107.63, ["Neon"] = 10.5, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 132.76, ["Neon|Fly|Ride"] = 183.7, ["Mega"] = 87.41, ["Mega|Fly"] = 181.61, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 219.59}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 14.74, ["Fly"] = 76.13, ["Ride"] = 33.41, ["Fly|Ride"] = 206.05, ["Neon"] = 23.54, ["Neon|Fly"] = 139.86, ["Neon|Ride"] = 76.67, ["Neon|Fly|Ride"] = 222.04, ["Mega"] = 116.94, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 136.26, ["Mega|Fly|Ride"] = 283.59}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.31, ["Ride"] = 11.31, ["Fly|Ride"] = 26.71, ["Neon"] = 2.63, ["Neon|Fly"] = 25.65, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 43.79, ["Mega"] = 18.04, ["Mega|Ride"] = 50.24, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 16.05, ["Fly"] = 131.25, ["Ride"] = 54.29, ["Neon"] = 110.22, ["Neon|Fly"] = 417.47, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 974.8, ["Mega"] = 513.64, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 584.48}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2731.11, ["Fly|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 36459.63}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 139.28, ["Ride"] = 14.64, ["Fly|Ride"] = 39.38, ["Neon"] = 8.36, ["Neon|Fly"] = 63.79, ["Neon|Ride"] = 24.86, ["Neon|Fly|Ride"] = 63, ["Mega"] = 139.86, ["Mega|Fly"] = 465.49, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 175.48}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.16, ["Neon"] = 10.45, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.71, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 21.19, ["Fly"] = 111.69, ["Ride"] = 25.07, ["Fly|Ride"] = 69.93, ["Neon"] = 94.48, ["Neon|Ride"] = 107.72, ["Neon|Fly|Ride"] = 292.37, ["Mega"] = 459.38, ["Mega|Ride"] = 460.69, ["Mega|Fly|Ride"] = 410.84}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 43.22, ["Ride"] = 41.56, ["Neon"] = 187.68, ["Mega"] = 1232.65, ["Mega|Ride"] = 766.07, ["Mega|Fly|Ride"] = 786.95}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 163.7, ["Fly"] = 1392.27, ["Ride"] = 189.42, ["Fly|Ride"] = 415.96, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 1080.19, ["Mega"] = 6262.05, ["Mega|Fly|Ride"] = 2834.24}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.27, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 147.91, ["Mega"] = 156.19, ["Mega|Ride"] = 223.36, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.37, ["Neon|Ride"] = 114.85, ["Mega"] = 132.18, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.63, ["Fly"] = 102, ["Ride"] = 35.44, ["Fly|Ride"] = 131.25, ["Neon"] = 10.42, ["Neon|Ride"] = 46.08, ["Mega"] = 75.6, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 15.37, ["Ride"] = 102.3, ["Neon"] = 180.07, ["Neon|Ride"] = 1165.83, ["Mega"] = 374.07, ["Mega|Ride"] = 626.21, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 47.46, ["Mega"] = 19.69, ["Mega|Fly"] = 116.27, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 278.67}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 208.76, ["Ride"] = 123.17, ["Fly|Ride"] = 177.44, ["Neon"] = 262.5, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 520.8, ["Mega"] = 2087.35, ["Mega|Fly|Ride"] = 1770.08}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.5, ["Neon|Ride"] = 140.91, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 127.32, ["Mega|Ride"] = 277.64, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 45.94, ["Fly"] = 208.76, ["Ride"] = 83.51, ["Fly|Ride"] = 157.39, ["Neon"] = 266.69, ["Neon|Ride"] = 328.13, ["Mega"] = 1461.15, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 21.28, ["Fly|Ride"] = 50.71, ["Neon"] = 5.25, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 56.38, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.52, ["Ride"] = 46.22, ["Neon"] = 10.81, ["Neon|Ride"] = 98.44, ["Mega"] = 65.63, ["Mega|Ride"] = 195.18, ["Mega|Fly|Ride"] = 626.21}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.02, ["Fly"] = 77.43, ["Ride"] = 56.44, ["Neon"] = 67.2, ["Neon|Ride"] = 104.39, ["Mega"] = 232.89, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 362.17, ["Ride"] = 525, ["Fly|Ride"] = 580.3, ["Neon"] = 1181.25, ["Neon|Ride"] = 1417.13, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 37.66, ["Ride"] = 54.51, ["Fly|Ride"] = 83.51, ["Neon"] = 278.67, ["Neon|Ride"] = 246.88, ["Neon|Fly|Ride"] = 375.74, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.62, ["Fly"] = 52.5, ["Ride"] = 16.58, ["Fly|Ride"] = 91.88, ["Neon"] = 8.11, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.87, ["Neon|Fly|Ride"] = 105, ["Mega"] = 83.86, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 94.48}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.31, ["Fly"] = 219.19, ["Ride"] = 42.99, ["Fly|Ride"] = 91.88, ["Neon"] = 68.25, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 307.13, ["Mega|Fly"] = 971.92, ["Mega|Ride"] = 280.8, ["Mega|Fly|Ride"] = 380.52}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.41, ["Ride"] = 20.69, ["Fly|Ride"] = 83.51, ["Neon"] = 139.86, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 268.09, ["Mega"] = 1113.61, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.74, ["Neon"] = 15.01, ["Mega"] = 72.19, ["Mega|Ride"] = 111.57}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 5.23, ["Fly"] = 39.38, ["Ride"] = 15.67, ["Fly|Ride"] = 56.38, ["Neon"] = 25.73, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 274.41, ["Mega"] = 551.51, ["Mega|Ride"] = 486.94}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.94, ["Fly"] = 348.6, ["Ride"] = 147, ["Fly|Ride"] = 235.73, ["Neon"] = 755.81, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 833.9, ["Mega|Fly|Ride"] = 2712.51}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 35.44, ["Ride"] = 64.8, ["Fly|Ride"] = 139.86, ["Neon"] = 129.94, ["Neon|Ride"] = 208.76, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 682.5, ["Mega|Ride"] = 814.08, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.13, ["Fly"] = 2503.78, ["Ride"] = 2164.32, ["Fly|Ride"] = 2165.63, ["Neon"] = 11132.86, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 12.5, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 95.34, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 201.49, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.9, ["Ride"] = 61.37, ["Neon"] = 31.47, ["Neon|Ride"] = 104.78, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.4, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 1042.62}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.69, ["Fly"] = 1127.18, ["Ride"] = 984.38, ["Fly|Ride"] = 1036.88, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2783.49, ["Mega|Fly|Ride"] = 11814.37}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 39.38, ["Ride"] = 57.52, ["Fly|Ride"] = 173.35, ["Neon"] = 170.63, ["Neon|Ride"] = 297.18, ["Neon|Fly|Ride"] = 373.19, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1669.88}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.62, ["Ride"] = 23.25, ["Fly|Ride"] = 128.15, ["Neon"] = 10.14, ["Neon|Ride"] = 76.04, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 202.79, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.09, ["Ride"] = 139.86, ["Neon"] = 3.83, ["Neon|Ride"] = 54.85, ["Neon|Fly|Ride"] = 73.07, ["Mega"] = 17.94, ["Mega|Ride"] = 107.51, ["Mega|Fly|Ride"] = 250.49}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 81.86, ["Ride"] = 127.34, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 8349.38, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.62, ["Neon"] = 12, ["Neon|Ride"] = 52.01, ["Mega"] = 133.49, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 45.59, ["Ride"] = 102.38, ["Neon"] = 385.88, ["Neon|Ride"] = 416.45, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Fly|Ride"] = 111.69, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.4, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.41, ["Ride"] = 332.58, ["Fly|Ride"] = 369.11, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.02, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.63, ["Fly"] = 87.94, ["Ride"] = 15.75, ["Fly|Ride"] = 103.76, ["Neon"] = 58.14, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 100.49, ["Mega"] = 348.6, ["Mega|Ride"] = 649.66, ["Mega|Fly|Ride"] = 390.32}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 16.71, ["Ride"] = 15.67, ["Fly|Ride"] = 32.82, ["Neon"] = 6.57, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 60.48, ["Mega"] = 128.63, ["Mega|Fly"] = 129.33, ["Mega|Ride"] = 63.79, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 961.15, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Ride"] = 7654.31, ["Neon|Fly|Ride"] = 5566.96, ["Mega"] = 26440.38}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.36, ["Fly"] = 959.51, ["Ride"] = 72.19, ["Fly|Ride"] = 208.76, ["Neon"] = 43.94, ["Neon|Ride"] = 311.75, ["Mega"] = 282.19, ["Mega|Ride"] = 390.34, ["Mega|Fly|Ride"] = 542.75}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 13.13, ["Fly"] = 48.2, ["Ride"] = 42.97, ["Fly|Ride"] = 79.49, ["Neon"] = 30.29, ["Neon|Fly"] = 124.4, ["Neon|Ride"] = 56.38, ["Neon|Fly|Ride"] = 130.79, ["Mega"] = 206.07, ["Mega|Fly"] = 230.67, ["Mega|Ride"] = 158.09, ["Mega|Fly|Ride"] = 295.21}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 38.19, ["Fly"] = 32.71, ["Ride"] = 44.89, ["Fly|Ride"] = 66.26, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2087.35, ["Mega|Ride"] = 1252.41, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.99, ["Fly"] = 83.51, ["Ride"] = 26.25, ["Fly|Ride"] = 91.88, ["Neon"] = 72.97, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 89.76, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 39.37, ["Ride"] = 71.75, ["Fly|Ride"] = 407.05, ["Neon"] = 119.85, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 582.39, ["Mega|Ride"] = 582.39, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Ride"] = 116.61, ["Fly|Ride"] = 79.13, ["Neon"] = 2.63, ["Neon|Fly"] = 55.49, ["Neon|Ride"] = 47.24, ["Neon|Fly|Ride"] = 315.32, ["Mega"] = 16.59, ["Mega|Ride"] = 88.26, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 58.46, ["Fly"] = 114.19, ["Ride"] = 92.67, ["Fly|Ride"] = 152.25, ["Neon"] = 393.75, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 452.4, ["Mega"] = 3339.76, ["Mega|Fly|Ride"] = 1294.67}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.4, ["Fly"] = 103.31, ["Ride"] = 23.63, ["Fly|Ride"] = 70.88, ["Neon"] = 52.5, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 386.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.38, ["Fly|Ride"] = 36.26, ["Neon"] = 15.65, ["Neon|Ride"] = 93.94, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 274.5, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 15.67, ["Neon|Fly"] = 137.79, ["Neon|Fly|Ride"] = 186.83, ["Mega"] = 292.25, ["Mega|Fly|Ride"] = 496.8}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 55.77, ["Ride"] = 69.93, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 345.48, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1083.34, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 5.1, ["Neon"] = 24.67, ["Neon|Ride"] = 78.29, ["Mega"] = 104.9, ["Mega|Fly|Ride"] = 310.7}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.37, ["Neon|Ride"] = 20.89, ["Mega"] = 16.38, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 393.37}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 31.76, ["Fly|Ride"] = 38.61, ["Neon"] = 2.1, ["Neon|Ride"] = 41.76, ["Neon|Fly|Ride"] = 125.94, ["Mega"] = 18.25, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 139.95}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 14.31, ["Fly|Ride"] = 52.47, ["Neon"] = 6.55, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 86.33, ["Mega"] = 125.25, ["Mega|Ride"] = 56.7, ["Mega|Fly|Ride"] = 137.45}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 24.94, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15, ["Fly|Ride"] = 34.13, ["Neon"] = 14.34, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 209.35, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 65.25, ["Ride"] = 101.73, ["Fly|Ride"] = 223.36, ["Neon"] = 196.76, ["Neon|Ride"] = 330.24, ["Neon|Fly|Ride"] = 1043.68, ["Mega"] = 961.8, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1092.74}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.84, ["Ride"] = 13.92, ["Fly|Ride"] = 35.23, ["Neon"] = 3.94, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 40.3, ["Mega"] = 24.94, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 101.57}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.48, ["Fly"] = 81.42, ["Ride"] = 34.21, ["Fly|Ride"] = 64.51, ["Neon"] = 28.25, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 58.97, ["Neon|Fly|Ride"] = 131.14, ["Mega"] = 362.09, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 267.65, ["Mega|Fly|Ride"] = 345.03}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.83, ["Fly"] = 39.8, ["Ride"] = 28.64, ["Fly|Ride"] = 98.12, ["Neon"] = 110.48, ["Neon|Ride"] = 127.14, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 787.5, ["Mega|Ride"] = 557.71, ["Mega|Fly|Ride"] = 755.81}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 4.82, ["Fly"] = 196.88, ["Neon"] = 73.41, ["Mega"] = 382.01, ["Mega|Ride"] = 390.34, ["Mega|Fly|Ride"] = 417.47}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 14.48, ["Fly|Ride"] = 35.49, ["Neon"] = 4.74, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.45, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 44.49, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 114.82}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.24, ["Fly"] = 52.5, ["Ride"] = 24.02, ["Neon"] = 18.61, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 109.92, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 177.44, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 390.34}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1109.07, ["Ride"] = 1023.65, ["Fly|Ride"] = 1061.82, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2487.19, ["Mega|Fly|Ride"] = 6929.7}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 102.69, ["Ride"] = 141.75, ["Fly|Ride"] = 223.2, ["Neon"] = 577.5, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 626.21, ["Mega"] = 3129.98, ["Mega|Ride"] = 2644.67, ["Mega|Fly|Ride"] = 2047.5}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 56.38, ["Ride"] = 39.38, ["Neon"] = 6.03, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 208.76, ["Mega"] = 83.51, ["Mega|Fly|Ride"] = 208.76}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 65.51, ["Ride"] = 100.85, ["Fly|Ride"] = 208.76, ["Neon"] = 367.5, ["Neon|Ride"] = 325.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1312.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1504.57}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6, ["Ride"] = 47.25, ["Fly|Ride"] = 90.81, ["Neon"] = 21.2, ["Neon|Fly"] = 41.76, ["Neon|Ride"] = 47.79, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 274.02, ["Mega|Ride"] = 350.69, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 280.88, ["Fly"] = 417.47, ["Ride"] = 315, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1238.86, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.37, ["Fly"] = 76.4, ["Ride"] = 36.92, ["Fly|Ride"] = 208.85, ["Neon"] = 31.38, ["Neon|Ride"] = 54.37, ["Mega"] = 361.12, ["Mega|Fly"] = 325.64, ["Mega|Ride"] = 188.96}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.71, ["Mega"] = 333.99}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 64.32, ["Ride"] = 28.2, ["Fly|Ride"] = 153.82, ["Neon"] = 111.69, ["Neon|Ride"] = 124.59, ["Mega"] = 971.67, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.66, ["Fly|Ride"] = 278.67, ["Neon"] = 20.56, ["Neon|Ride"] = 47.24, ["Mega"] = 240.19, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 461.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 13.92, ["Ride"] = 11.11, ["Fly|Ride"] = 36.25, ["Neon"] = 2.63, ["Neon|Fly"] = 31.89, ["Neon|Ride"] = 17.73, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 24.2, ["Mega|Ride"] = 40.71, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4454.63, ["Fly|Ride"] = 4500.57, ["Neon"] = 31310.14, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 130458.91}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 21.34, ["Ride"] = 54.51, ["Neon"] = 52.41, ["Neon|Ride"] = 106.32, ["Mega"] = 315.32, ["Mega|Ride"] = 293.56, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 20.89, ["Fly|Ride"] = 41.76, ["Neon"] = 13.29, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 69.93, ["Mega"] = 144.37, ["Mega|Ride"] = 167.01, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 510.06, ["Fly"] = 547.77, ["Ride"] = 521.9, ["Fly|Ride"] = 569.86, ["Neon"] = 1669.88, ["Neon|Ride"] = 1669.88, ["Neon|Fly|Ride"] = 1531.17, ["Mega|Fly|Ride"] = 5273.63}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.87, ["Ride"] = 32.62, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.67, ["Fly"] = 4174.7, ["Ride"] = 7246.17, ["Neon"] = 25.65, ["Neon|Ride"] = 278.67, ["Neon|Fly|Ride"] = 278.67, ["Mega"] = 875.61, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 20.89, ["Neon"] = 5.13, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 22.4, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 49.7, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 689.07, ["Fly"] = 2087.35, ["Ride"] = 767.81, ["Fly|Ride"] = 753.64, ["Neon"] = 2362.5, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2362.4}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.67, ["Fly"] = 69.93, ["Ride"] = 73.07, ["Neon"] = 29.03, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 221.27, ["Mega"] = 156.18, ["Mega|Ride"] = 218.31, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.86, ["Fly"] = 236.15, ["Ride"] = 27.44, ["Fly|Ride"] = 139.86, ["Neon"] = 22.92, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 3938.41, ["Mega"] = 205.08, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.52, ["Fly"] = 34.1, ["Ride"] = 14.22, ["Neon"] = 14.34, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 51.18, ["Mega"] = 277.64, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 205.37}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.8, ["Ride"] = 69.93, ["Fly|Ride"] = 158.26, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 313.11, ["Mega"] = 557.33, ["Mega|Ride"] = 779.64, ["Mega|Fly|Ride"] = 726.41}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 417.47, ["Neon"] = 4.02, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 186.83, ["Mega"] = 47.37, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 478.8, ["Ride"] = 538.12, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 1949.59, ["Neon|Fly|Ride"] = 2800.19, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.4, ["Fly"] = 104.39, ["Ride"] = 63.19, ["Fly|Ride"] = 315.32, ["Neon"] = 17.49, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 78.75, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 557.33}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.05, ["Ride"] = 52.4, ["Neon"] = 6.56, ["Neon|Fly"] = 236.94, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 72.19, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 46.04, ["Neon"] = 6.57, ["Neon|Ride"] = 43.57, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 67.14, ["Mega|Fly"] = 154.47, ["Mega|Ride"] = 74.11, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.94, ["Ride"] = 27.97, ["Neon"] = 28.2, ["Mega"] = 208.76}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 32.45, ["Fly"] = 98.44, ["Ride"] = 115.77, ["Fly|Ride"] = 295.24, ["Neon"] = 129.64, ["Neon|Ride"] = 134.33, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 974.8, ["Mega|Ride"] = 612.65, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.65, ["Ride"] = 62.99, ["Fly|Ride"] = 128.99, ["Neon"] = 78.75, ["Neon|Ride"] = 141.65, ["Neon|Fly|Ride"] = 247.02, ["Mega"] = 472.38, ["Mega|Fly"] = 557.33, ["Mega|Ride"] = 451.79, ["Mega|Fly|Ride"] = 560.8}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 15.53, ["Fly|Ride"] = 35.49, ["Neon"] = 28.77, ["Neon|Ride"] = 34.77, ["Neon|Fly|Ride"] = 84, ["Mega"] = 299.92, ["Mega|Ride"] = 278.67, ["Mega|Fly|Ride"] = 268.09}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.68, ["Ride"] = 65.54, ["Neon"] = 118.13, ["Neon|Ride"] = 137.79, ["Mega|Ride"] = 292.25}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 26.17, ["Fly|Ride"] = 111.54, ["Neon"] = 15.67, ["Neon|Ride"] = 62.63, ["Neon|Fly|Ride"] = 147.82, ["Mega"] = 98.12, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Ride"] = 30.18, ["Fly|Ride"] = 68.9, ["Neon"] = 278.67, ["Neon|Ride"] = 516.06, ["Neon|Fly|Ride"] = 187.87, ["Mega"] = 938.27}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 55.5, ["Fly"] = 874.13, ["Neon"] = 265.11, ["Mega|Fly|Ride"] = 974.8}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.19, ["Fly"] = 115.38, ["Ride"] = 77.14, ["Fly|Ride"] = 139.86, ["Neon"] = 292.25, ["Neon|Fly"] = 396.61, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1643.44, ["Mega|Fly|Ride"] = 1260.06}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 40.6, ["Fly"] = 93.94, ["Ride"] = 44.63, ["Neon"] = 144.37, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 654.25, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.4, ["Ride"] = 56.44, ["Fly|Ride"] = 139.86, ["Neon"] = 192.05, ["Neon|Ride"] = 274.26, ["Mega"] = 590.63, ["Mega|Ride"] = 778.05, ["Mega|Fly|Ride"] = 1252.41}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.4, ["Fly"] = 428.28, ["Ride"] = 57.53, ["Fly|Ride"] = 192.93, ["Neon"] = 111.09, ["Neon|Fly"] = 420, ["Neon|Ride"] = 94.48, ["Neon|Fly|Ride"] = 252.14, ["Mega"] = 464.37, ["Mega|Ride"] = 524.68, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 13.61, ["Fly|Ride"] = 26.5, ["Neon"] = 4.74, ["Neon|Fly"] = 26.48, ["Neon|Ride"] = 27.36, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 62.23, ["Mega|Fly"] = 158.26, ["Mega|Ride"] = 77.89, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.93}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 49.88, ["Fly"] = 236.19, ["Ride"] = 126.93, ["Fly|Ride"] = 288.75, ["Neon"] = 294.15, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 834.94, ["Mega|Ride"] = 1112.56, ["Mega|Fly|Ride"] = 1029.13}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.94, ["Neon|Fly"] = 98.12, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 28.19, ["Mega|Ride"] = 84.92}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 29.81, ["Ride"] = 62.37, ["Fly|Ride"] = 169.1, ["Neon"] = 128.37, ["Neon|Ride"] = 147.18, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 612.8, ["Mega|Ride"] = 614.16, ["Mega|Fly|Ride"] = 1238.86}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 24.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 32.82, ["Mega|Ride"] = 151.41, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 104.9, ["Fly"] = 245.27, ["Ride"] = 168, ["Fly|Ride"] = 250.49, ["Neon"] = 582.75, ["Neon|Ride"] = 587.99, ["Neon|Fly|Ride"] = 782.77, ["Mega|Ride"] = 2565.35, ["Mega|Fly|Ride"] = 1829.63}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 34.23, ["Fly|Ride"] = 92.99, ["Neon"] = 6.49, ["Neon|Ride"] = 31.9, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 96.95, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Fly|Ride"] = 86.63, ["Neon"] = 3.94, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 34.18, ["Mega|Ride"] = 158.26, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 83.51, ["Neon"] = 3.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.25, ["Mega"] = 45.94, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 240.06}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 28.2, ["Neon"] = 5.23, ["Neon|Ride"] = 41.76, ["Mega"] = 65.54, ["Mega|Ride"] = 205.51}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 133.84, ["Fly|Ride"] = 630.62, ["Neon"] = 419.83, ["Neon|Ride"] = 520.8, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1531.08, ["Mega|Ride"] = 1565.52, ["Mega|Fly|Ride"] = 1521.69}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.94, ["Ride"] = 64.84, ["Neon"] = 59.06, ["Neon|Ride"] = 157.55, ["Mega"] = 409.86, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 354.38, ["Ride"] = 433.13, ["Fly|Ride"] = 760.53, ["Neon"] = 1043.68, ["Neon|Ride"] = 1392.27, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Ride"] = 3618.43, ["Mega|Fly|Ride"] = 4174.7}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.42}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 57.65}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 14.52}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 18.53}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 65.63}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 16.71}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 102.37}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 25.45}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.18}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 19.28}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.44}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.19}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 10.45}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 4.18}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.43}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.34}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 498.74}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 696.14}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.65}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.44}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 13.85}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.67}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 37.58}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.07}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 53.7}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 23.62}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.47}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.32}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.55}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.64}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.59}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.82}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.56}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1891.15}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 63.39}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.62}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.95}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.69}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 4.89}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.69}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1392.27}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26.25}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.68}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 23.97}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 9.19}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.25}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.72}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 33.78}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.21}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 102.72}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.59}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.9}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.45}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 196.88}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.51}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.77}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 97.55}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 31.49}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 826.66}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 18.15}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22494.28}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 63}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 41.14}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 37.41}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 30.02}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.74}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76.67}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 87.3}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.61}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 52.5}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 93.52}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.37}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 417.47}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 4.74}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.83}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.3}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.49}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.13}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 93.91}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.83}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.99}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 362.17}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 756}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 14.43}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 584.07}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 16.65}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.6}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.58}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 614.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 75.38}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.37}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.66}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 41.32}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 10.43}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 9.19}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.13}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.65}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 25.13}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.58}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 6.56}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.19}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 30.29}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 191.01}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 5.65}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 5.98}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.25}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.19}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 27.16}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.82}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.6}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.65}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 8.87}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 38.93}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 141.46}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 3.9}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.64}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.26}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.97}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.43}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.08}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.13}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7652.22}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 14.01}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 6.23}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.25}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.33}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.5}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.9}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.33}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.25}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 111.69}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 11.6}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.6}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.34}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.27}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4410.78}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.69}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 30.96}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.35}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.58}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 14.44}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 53.48}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 13.62}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 11.82}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 96.67}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 4.76}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.62}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 5.04}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 131.36}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 9.22}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.8}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.92}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 23.25}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.85}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.81}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.18}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 13.13}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.51}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.14}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.57}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.08}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1041.39}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 36.29}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.62}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.42}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 25.3}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 10.45}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 6.11}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.07}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 314913.83}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 19.85}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 25.99}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.19}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.16}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 21.55}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.99}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 19.85}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 22.32}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.55}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.63}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.71}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 14.34}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 39.21}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 22.16}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.41}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.66}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 6.02}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 31.67}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.15}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 19.47}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 10.45}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 59.07}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 39.38}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 7.88}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 179.34}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.6}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.71}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 250.49}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 11.49}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 70.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 129.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.15}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.74}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.33}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.71}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 12.84}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.88}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 7.69}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.52}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 3.94}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.26}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 51.28}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 51.1}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 4.87}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 69.36}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.12}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 58.07}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.99}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 9.4}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 77.62}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.4}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 57.73}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.05}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 49.88}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 77.24}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 287.44}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 85.43}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.36}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 181.61}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.94}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.45}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 29.22}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 48.57}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 43.85}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.77}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 42.6}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 14.05}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 39.38}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 17.97}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.62}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 15.99}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 587.49}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.62}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 25.19}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 8.54}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.03}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45.01}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 22.32}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1706.25}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.12}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.87}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 62.18}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 262.5}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 14.52}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.8}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 8.04}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 7.16}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 275.62}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 48.2}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.67}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 56.1}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 144.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.98}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 984.38}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 199.5}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2366.02}},
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