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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 781.79, ["Ride"] = 1027.16, ["Fly|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 19994.69}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 459.38, ["Ride"] = 564.37, ["Fly|Ride"] = 613.32, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2456.81, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 9607.29}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5881.83, ["Ride"] = 4811.63, ["Fly|Ride"] = 4593.75, ["Neon|Fly|Ride"] = 22557.09, ["Mega|Fly|Ride"] = 68358.22}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 137.67, ["Ride"] = 183.75, ["Fly|Ride"] = 459.38, ["Neon"] = 820.61, ["Neon|Ride"] = 818.56, ["Neon|Fly|Ride"] = 1189.44, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 3815.41}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 623.44, ["Fly"] = 820.93, ["Ride"] = 611.63, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1519.88, ["Mega|Fly|Ride"] = 6562.4}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 10.02, ["Ride"] = 27.68, ["Fly|Ride"] = 155.8, ["Neon"] = 56.44, ["Neon|Fly"] = 273.9, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 305.58, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 574.23}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.93, ["Fly"] = 41.98, ["Ride"] = 30.08, ["Fly|Ride"] = 77.44, ["Neon"] = 23.94, ["Neon|Fly"] = 102.59, ["Neon|Ride"] = 50.17, ["Neon|Fly|Ride"] = 109.7, ["Mega"] = 147.71, ["Mega|Fly"] = 388.16, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.24}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 96.57, ["Ride"] = 149.22, ["Fly|Ride"] = 240.19, ["Neon"] = 547.77, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 676.75, ["Mega|Fly|Ride"] = 2677.25}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 46.53, ["Fly"] = 97.67, ["Ride"] = 51.28, ["Fly|Ride"] = 77.84, ["Neon"] = 252, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2100, ["Mega|Ride"] = 1394.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.99, ["Fly"] = 57.87, ["Ride"] = 40.69, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 282.19, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 55.13, ["Fly"] = 108.74, ["Ride"] = 77.88, ["Fly|Ride"] = 144.38, ["Neon"] = 402.8, ["Neon|Ride"] = 298.86, ["Neon|Fly|Ride"] = 306.81, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.64}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 339.94, ["Ride"] = 283.5, ["Fly|Ride"] = 349.53, ["Neon"] = 1333.48, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4843.86}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 105, ["Fly"] = 170.23, ["Ride"] = 108.63, ["Fly|Ride"] = 149.63, ["Neon|Fly"] = 674.33, ["Neon|Fly|Ride"] = 650.1, ["Mega|Fly|Ride"] = 2983.19}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 53.43, ["Fly|Ride"] = 131.24, ["Neon"] = 20.52, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 189, ["Mega"] = 127, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 204.06, ["Mega|Fly|Ride"] = 384.68}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 189.95, ["Fly"] = 214.81, ["Ride"] = 183.65, ["Fly|Ride"] = 183.75, ["Neon"] = 775.46, ["Neon|Ride"] = 711.89, ["Neon|Fly|Ride"] = 717.77, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.89, ["Fly"] = 27.72, ["Ride"] = 18.38, ["Fly|Ride"] = 41.04, ["Neon"] = 29.76, ["Neon|Ride"] = 93.02, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 205.09, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 88.64, ["Fly"] = 466.38, ["Ride"] = 136.5, ["Fly|Ride"] = 315, ["Neon"] = 342.61, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 373.86, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 1703.79, ["Mega|Ride"] = 1353.5, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 67.46, ["Ride"] = 90.93, ["Fly|Ride"] = 210, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1367.85, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.83, ["Fly"] = 41.04, ["Ride"] = 31.5, ["Fly|Ride"] = 109.77, ["Neon"] = 262.48, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 955.66, ["Mega|Fly|Ride"] = 614.21}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 50.56, ["Fly"] = 124.43, ["Ride"] = 64.41, ["Fly|Ride"] = 113.19, ["Neon"] = 246.2, ["Neon|Ride"] = 240.18, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1626.98, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 55.42, ["Fly"] = 67.72, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 205.16, ["Neon|Fly"] = 386, ["Neon|Ride"] = 189.96, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 1156.62, ["Mega|Ride"] = 1299.16, ["Mega|Fly|Ride"] = 1244.81}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.32, ["Ride"] = 41.04, ["Fly|Ride"] = 71.82, ["Neon"] = 179.51, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 292.88, ["Mega"] = 818.26, ["Mega|Ride"] = 2050.76, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 116.29, ["Ride"] = 57.75, ["Fly|Ride"] = 123.11, ["Neon"] = 232.54, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 8.23, ["Fly"] = 29.98, ["Ride"] = 24.94, ["Fly|Ride"] = 71.82, ["Neon"] = 38.97, ["Neon|Fly"] = 101.56, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 101.17, ["Mega"] = 156.19, ["Mega|Fly"] = 27377.35, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 417.56, ["Ride"] = 459.09, ["Fly|Ride"] = 480.11, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 6822.82}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.77, ["Ride"] = 32.32, ["Fly|Ride"] = 105.18, ["Neon"] = 198.19, ["Neon|Ride"] = 137.41, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.24, ["Fly"] = 34.54, ["Ride"] = 20.99, ["Fly|Ride"] = 59.07, ["Neon"] = 73.5, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 119.44, ["Mega|Ride"] = 285.07, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 71.72, ["Fly"] = 99.86, ["Ride"] = 57.75, ["Fly|Ride"] = 113.48, ["Neon"] = 410.31, ["Neon|Fly"] = 376.47, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 426.14, ["Mega"] = 3281.2, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1586.25}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.12, ["Ride"] = 24.63, ["Fly|Ride"] = 118.13, ["Neon"] = 96.44, ["Neon|Ride"] = 151.82, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 479.16, ["Mega|Ride"] = 781.35, ["Mega|Fly|Ride"] = 574.23}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 342.61, ["Ride"] = 229.45, ["Fly|Ride"] = 315.38, ["Neon|Ride"] = 734.99, ["Neon|Fly|Ride"] = 963.86, ["Mega"] = 6152.22, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2926.41}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 61.83}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.09, ["Fly"] = 31.97, ["Ride"] = 20.52, ["Fly|Ride"] = 55.21, ["Neon"] = 34.9, ["Neon|Fly"] = 5128.77, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 234.94, ["Mega|Fly"] = 507.57, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 905.63, ["Fly"] = 2625, ["Ride"] = 958.07, ["Fly|Ride"] = 1094.48, ["Neon"] = 4103.03, ["Neon|Ride"] = 6018.1, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52295.57, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.88, ["Fly"] = 68.77, ["Ride"] = 28.09, ["Fly|Ride"] = 105.81, ["Neon"] = 137.47, ["Neon|Ride"] = 118.09, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 787.5, ["Mega|Ride"] = 818.26, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.51, ["Ride"] = 203.44, ["Fly|Ride"] = 260.55, ["Neon"] = 1025.77, ["Neon|Ride"] = 865.81, ["Neon|Fly|Ride"] = 801.94, ["Mega|Ride"] = 3941.53, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 42.46}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 27.7, ["Fly"] = 273636.6, ["Ride"] = 52.31, ["Fly|Ride"] = 137.47, ["Neon"] = 102.59, ["Neon|Ride"] = 206.07, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 683.93, ["Mega|Ride"] = 1081.79, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.77}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 124.43, ["Ride"] = 305.69, ["Fly|Ride"] = 263.92, ["Neon|Ride"] = 547.77, ["Neon|Fly|Ride"] = 683.93, ["Mega|Fly|Ride"] = 2355.94}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 137.52, ["Ride"] = 216.46, ["Fly|Ride"] = 314.79, ["Neon"] = 389.45, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 590.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1948.22}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 40.24}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 62.62, ["Fly"] = 61.35, ["Ride"] = 62.91, ["Fly|Ride"] = 82.48, ["Neon|Ride"] = 355.95, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 1638.55}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.13, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 51.31, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 230.73, ["Mega"] = 194.84, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 321.98, ["Mega|Fly|Ride"] = 598.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 507.95, ["Fly"] = 590.63, ["Ride"] = 465.51, ["Fly|Ride"] = 511.87, ["Neon|Ride"] = 3692.73, ["Neon|Fly|Ride"] = 1572.94, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.87, ["Fly"] = 162.08, ["Ride"] = 115.49, ["Fly|Ride"] = 194.13, ["Neon"] = 459.38, ["Neon|Fly"] = 820.61, ["Neon|Ride"] = 684.2, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 2459.87, ["Mega|Fly|Ride"] = 2317.34}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 6977.74, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14354.15}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.99, ["Fly"] = 112.1, ["Ride"] = 49.88, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 582.65, ["Neon|Fly|Ride"] = 403.28, ["Mega"] = 1299.16, ["Mega|Ride"] = 1710.33, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 155.82, ["Ride"] = 78.75, ["Fly|Ride"] = 136.99, ["Neon"] = 410.31, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2734.67, ["Mega|Ride"] = 2598.29, ["Mega|Fly|Ride"] = 2973.41}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 39, ["Fly"] = 68.77, ["Ride"] = 55.13, ["Fly|Ride"] = 131.15, ["Neon"] = 262.5, ["Neon|Fly"] = 294.41, ["Neon|Ride"] = 184.65, ["Neon|Fly|Ride"] = 205.47, ["Mega"] = 2625, ["Mega|Ride"] = 724.96, ["Mega|Fly|Ride"] = 655.46}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.22}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 46.52, ["Fly"] = 61.58, ["Ride"] = 61.56, ["Fly|Ride"] = 64.94, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 547.56, ["Mega|Fly|Ride"] = 1859.42}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.52}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 223.13, ["Fly|Ride"] = 273.9, ["Neon|Ride"] = 1085.89, ["Neon|Fly|Ride"] = 1367.85, ["Mega|Fly|Ride"] = 4958.8}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1300.13, ["Ride"] = 903.7, ["Fly|Ride"] = 1366.32, ["Neon"] = 2887.5, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 13672.26}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 8.53}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 30.18, ["Fly"] = 86.05, ["Ride"] = 45.92, ["Fly|Ride"] = 64.1, ["Neon"] = 160.78, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 891.66, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.1}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5951.6, ["Ride"] = 5949.38, ["Fly|Ride"] = 4608.19, ["Neon|Fly|Ride"] = 10476.38, ["Mega|Fly|Ride"] = 37187.97}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.86, ["Fly"] = 52.4, ["Ride"] = 23.38, ["Fly|Ride"] = 63.91, ["Neon"] = 102.55, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 193.35, ["Mega"] = 787.5, ["Mega|Ride"] = 488.1, ["Mega|Fly|Ride"] = 635.75}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.61, ["Fly"] = 190.81, ["Ride"] = 32.84, ["Fly|Ride"] = 273.9, ["Neon"] = 68.74, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 721.88, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 1022.31}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 26.25, ["Fly"] = 273.99, ["Ride"] = 91.88, ["Fly|Ride"] = 133.2, ["Neon|Ride"] = 380.57, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4101.49}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 13.13, ["Fly"] = 150.93, ["Ride"] = 27.71, ["Fly|Ride"] = 78.75, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1903.13, ["Fly"] = 2221.02, ["Ride"] = 1785, ["Fly|Ride"] = 1764, ["Neon|Fly|Ride"] = 3495.32, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26250, ["Ride"] = 52500, ["Fly|Ride"] = 26117.44, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 77475.29, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.51, ["Fly"] = 393.74, ["Ride"] = 55.13, ["Fly|Ride"] = 124.69, ["Neon"] = 266.72, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 957.71, ["Mega|Ride"] = 752.63, ["Mega|Fly|Ride"] = 816.21}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.89, ["Fly"] = 65.63, ["Ride"] = 41.04, ["Fly|Ride"] = 158.9, ["Neon"] = 20.87, ["Neon|Fly"] = 96.57, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 120.02, ["Mega"] = 120.75, ["Mega|Ride"] = 120.75, ["Mega|Fly|Ride"] = 356.5}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.98}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.76, ["Ride"] = 32, ["Fly|Ride"] = 125.25, ["Neon"] = 61.56, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 164.08, ["Mega"] = 342.49, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 708.75, ["Ride"] = 735, ["Fly|Ride"] = 859.07, ["Neon"] = 2325.22, ["Neon|Fly|Ride"] = 2529.6, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 905.61, ["Fly"] = 975.19, ["Ride"] = 918.65, ["Fly|Ride"] = 1040.82, ["Neon|Ride"] = 3145.99, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 12086.09}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 21, ["Fly"] = 116.29, ["Ride"] = 23.63, ["Fly|Ride"] = 85.32, ["Neon"] = 137.47, ["Neon|Ride"] = 119.9, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 1204.13, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 594.72}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.77}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.14, ["Fly"] = 98.11, ["Ride"] = 75.51, ["Fly|Ride"] = 104.9, ["Neon"] = 460.58, ["Neon|Ride"] = 403.59, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 2007.69, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 65.76, ["Ride"] = 78.75, ["Fly|Ride"] = 228.38, ["Neon"] = 450.19, ["Neon|Ride"] = 278.73, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 1334.41, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.61, ["Fly"] = 44.2, ["Ride"] = 19.69, ["Fly|Ride"] = 55.41, ["Neon"] = 55.41, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 130.24, ["Mega"] = 288.75, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 133.81, ["Fly"] = 131.25, ["Ride"] = 126, ["Fly|Ride"] = 202.13, ["Neon|Ride"] = 493.77, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1569.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.11, ["Ride"] = 39.38, ["Fly|Ride"] = 262.49, ["Neon"] = 44.12, ["Neon|Ride"] = 127.32, ["Neon|Fly|Ride"] = 477.84, ["Mega"] = 248.07, ["Mega|Ride"] = 664.75, ["Mega|Fly|Ride"] = 539.37}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.04, ["Fly"] = 41.22, ["Ride"] = 32.69, ["Fly|Ride"] = 79.31, ["Neon"] = 85.32, ["Neon|Ride"] = 100.53, ["Neon|Fly|Ride"] = 205.09, ["Mega|Fly|Ride"] = 783.4}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.04, ["Ride"] = 55.41, ["Fly|Ride"] = 156.19, ["Neon"] = 260.55, ["Neon|Ride"] = 328.26, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 918.74, ["Mega|Ride"] = 775.16, ["Mega|Fly|Ride"] = 998.72}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.42, ["Fly"] = 169.81, ["Ride"] = 35.79, ["Fly|Ride"] = 68.74, ["Neon"] = 87.28, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 885.93, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6956.25, ["Ride"] = 7141.32, ["Fly|Ride"] = 5494.13, ["Neon"] = 30772.56, ["Neon|Fly|Ride"] = 27192.78, ["Mega|Fly|Ride"] = 92969.88}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 233.63, ["Fly"] = 267.75, ["Ride"] = 252.27, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 39.38, ["Fly"] = 315, ["Ride"] = 85.29, ["Fly|Ride"] = 161.22, ["Neon"] = 120.75, ["Neon|Fly"] = 306.71, ["Neon|Ride"] = 166.98, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 392.34, ["Mega|Fly"] = 511.68, ["Mega|Ride"] = 434.35, ["Mega|Fly|Ride"] = 500.06}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 86.02, ["Ride"] = 23.26, ["Fly|Ride"] = 105.81, ["Neon"] = 25.38, ["Neon|Fly"] = 49.25, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 330.75, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 63, ["Fly"] = 5265.65, ["Ride"] = 85.32, ["Fly|Ride"] = 199.87, ["Neon"] = 203.16, ["Neon|Fly"] = 379.54, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 311.56, ["Mega"] = 369.26, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 616.74}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 15597.28, ["Ride"] = 11943.75, ["Fly|Ride"] = 11811.19, ["Neon|Fly|Ride"] = 22312.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 204.22, ["Ride"] = 260.55, ["Fly|Ride"] = 343.08, ["Neon"] = 1503.77, ["Neon|Fly|Ride"] = 1538.07, ["Mega"] = 5469.33, ["Mega|Fly|Ride"] = 5605.7}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.75, ["Fly"] = 74.82, ["Ride"] = 68.74, ["Fly|Ride"] = 101.58, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2734.67}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 9.32, ["Fly"] = 44.2, ["Ride"] = 23.22, ["Fly|Ride"] = 72.1, ["Neon"] = 109.3, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 149.63, ["Mega"] = 295.32, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 387.09, ["Ride"] = 414.75, ["Fly|Ride"] = 484.31, ["Neon"] = 1706.25, ["Neon|Ride"] = 1394.94, ["Neon|Fly|Ride"] = 1719.38, ["Mega|Fly|Ride"] = 5011.13}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.19, ["Fly"] = 101.53, ["Ride"] = 37.3, ["Fly|Ride"] = 84.96, ["Neon"] = 27.71, ["Neon|Ride"] = 124.42, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 132.43, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 155.28, ["Fly"] = 211.63, ["Ride"] = 155.96, ["Fly|Ride"] = 233.52, ["Neon"] = 544.69, ["Neon|Ride"] = 524.88, ["Neon|Fly|Ride"] = 545.51, ["Mega|Fly|Ride"] = 2619.25}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 9.19, ["Fly"] = 18.08, ["Ride"] = 13.13, ["Fly|Ride"] = 41.25, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 874.13}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.22}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 74.82, ["Fly"] = 137.52, ["Ride"] = 86.63, ["Fly|Ride"] = 196.88, ["Neon"] = 421.32, ["Neon|Fly"] = 547.77, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1778}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.74, ["Fly"] = 101.61, ["Ride"] = 48.83, ["Fly|Ride"] = 91.88, ["Neon"] = 123.11, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 245.44, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 44.63, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 137.47, ["Neon|Ride"] = 260.46, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 1538.07, ["Mega|Ride"] = 1320.68, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 4.78, ["Ride"] = 29.23, ["Fly|Ride"] = 132.56, ["Neon"] = 28.19, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 135.19, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 14.23, ["Fly"] = 47.25, ["Ride"] = 36.94, ["Fly|Ride"] = 92.91, ["Neon|Ride"] = 137.41, ["Neon|Fly|Ride"] = 211.01, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 552.57, ["Ride"] = 452.61, ["Fly|Ride"] = 446.25, ["Neon|Fly|Ride"] = 2727.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.38, ["Ride"] = 55.11, ["Fly|Ride"] = 134.39, ["Neon"] = 234.67, ["Neon|Ride"] = 242.15, ["Neon|Fly|Ride"] = 314.81, ["Mega"] = 1007.57, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1365}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 53.54, ["Fly"] = 117.49, ["Ride"] = 71.82, ["Fly|Ride"] = 131.15, ["Neon"] = 452.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 752.63, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 31.7, ["Fly"] = 77.88, ["Ride"] = 70.88, ["Fly|Ride"] = 137.47, ["Neon"] = 170.63, ["Neon|Fly"] = 257.49, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 319.93, ["Mega"] = 414.74, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 637.98}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8400, ["Ride"] = 13327.18, ["Fly|Ride"] = 8268.74, ["Neon|Fly|Ride"] = 16275, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1509.38, ["Ride"] = 1391.24, ["Fly|Ride"] = 1375.5, ["Neon|Ride"] = 5120.57, ["Neon|Fly|Ride"] = 4955.11, ["Mega|Fly|Ride"] = 17676.33}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 459.38, ["Ride"] = 560.37, ["Fly|Ride"] = 656.25, ["Neon"] = 4338.65, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 6822.82}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.06, ["Fly"] = 20.9, ["Ride"] = 20.54, ["Fly|Ride"] = 51.47, ["Neon"] = 109.77, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 96.41, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.93, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 88.23, ["Neon"] = 27.57, ["Neon|Ride"] = 75.93, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 143.54, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 46.66, ["Fly"] = 114.6, ["Ride"] = 48.28, ["Fly|Ride"] = 101.48, ["Neon"] = 523.19, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 189.84, ["Mega|Fly|Ride"] = 551.14}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.82, ["Fly"] = 26.66, ["Ride"] = 18.38, ["Fly|Ride"] = 39.26, ["Neon"] = 28.41, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.41, ["Mega|Ride"] = 205.09}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 393.75, ["Fly"] = 369.49, ["Ride"] = 339.34, ["Fly|Ride"] = 403.33, ["Neon|Fly|Ride"] = 1228.41, ["Mega|Fly|Ride"] = 4649.03}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 23.62, ["Fly"] = 60.59, ["Ride"] = 33.72, ["Fly|Ride"] = 88.23, ["Neon"] = 91.88, ["Neon|Fly"] = 410.31, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 598.83, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.49, ["Fly"] = 18.38, ["Ride"] = 19.69, ["Fly|Ride"] = 43.1, ["Neon"] = 137.47, ["Neon|Fly"] = 123.11, ["Neon|Ride"] = 80.56, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 446.25, ["Fly"] = 787.5, ["Ride"] = 446.24, ["Fly|Ride"] = 684.2, ["Neon|Fly|Ride"] = 2789.12, ["Mega|Fly|Ride"] = 8619.21}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1317.65, ["Ride"] = 1154.9, ["Fly|Ride"] = 1312.5, ["Neon"] = 4787.21, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.97, ["Fly"] = 136.19, ["Ride"] = 103.69, ["Fly|Ride"] = 133.88, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3564.25}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 158.95, ["Fly"] = 191.9, ["Ride"] = 168.46, ["Fly|Ride"] = 242.82, ["Neon"] = 577.5, ["Neon|Ride"] = 793.07, ["Neon|Fly|Ride"] = 762.46, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2634.55}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.15, ["Ride"] = 53.82, ["Fly|Ride"] = 118.58, ["Neon"] = 262.64, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 2050.76, ["Mega|Fly|Ride"] = 876.7}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 215.75, ["Ride"] = 273.9, ["Fly|Ride"] = 547.77, ["Neon|Fly"] = 930.09, ["Neon|Fly|Ride"] = 1301.6, ["Mega|Fly|Ride"] = 3691.33}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2230.83, ["Ride"] = 2483.25, ["Fly|Ride"] = 2161.28, ["Neon|Fly|Ride"] = 10253.69, ["Mega|Fly|Ride"] = 27890.98}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 31.4, ["Ride"] = 83.53, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2255.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Ride"] = 643.12, ["Fly|Ride"] = 630, ["Neon|Ride"] = 1627.66, ["Neon|Fly|Ride"] = 1305.93, ["Mega|Fly|Ride"] = 3358.64}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 48.57, ["Fly"] = 59.07, ["Ride"] = 61.04, ["Fly|Ride"] = 97.12, ["Neon|Ride"] = 360.43, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.47, ["Fly"] = 39.38, ["Ride"] = 20.93, ["Fly|Ride"] = 52.27, ["Neon"] = 19.53, ["Neon|Fly"] = 120.75, ["Neon|Ride"] = 48.71, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 147.88, ["Mega|Fly"] = 151.77, ["Mega|Ride"] = 180.02, ["Mega|Fly|Ride"] = 301.24}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 123.05, ["Fly|Ride"] = 252, ["Neon"] = 338.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 1499.11, ["Mega|Ride"] = 1640.61, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.24, ["Fly"] = 1017.42, ["Ride"] = 834.75, ["Fly|Ride"] = 905.63, ["Neon|Ride"] = 2572.77, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9427.25}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 656.25, ["Ride"] = 778.56, ["Fly|Ride"] = 883.6, ["Neon|Fly|Ride"] = 4047.14, ["Mega|Fly|Ride"] = 14765.31}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.7, ["Fly"] = 26.25, ["Ride"] = 25.74, ["Fly|Ride"] = 39.36, ["Neon|Ride"] = 101.82, ["Neon|Fly|Ride"] = 196.77, ["Mega"] = 786.19, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 680.86}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.22, ["Ride"] = 30.79, ["Fly|Ride"] = 59.06, ["Neon"] = 85.28, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 374.07, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.22, ["Ride"] = 24.92, ["Fly|Ride"] = 111.56, ["Neon"] = 21.19, ["Neon|Fly"] = 310.44, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 243.95, ["Mega"] = 166.47, ["Mega|Fly"] = 527.62, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 330.75}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 82.1, ["Fly"] = 73.5, ["Ride"] = 81.02, ["Fly|Ride"] = 111.57, ["Neon"] = 229.69, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 258.4, ["Mega|Fly|Ride"] = 952.91}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 511.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.22, ["Mega|Ride"] = 1538.07, ["Mega|Fly|Ride"] = 1495.01}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 15.57, ["Fly"] = 59.06, ["Ride"] = 34.8, ["Fly|Ride"] = 100.01, ["Neon"] = 82.7, ["Neon|Fly"] = 155.8, ["Neon|Ride"] = 117.85, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 396.83, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 27.75, ["Fly"] = 56.01, ["Ride"] = 45.73, ["Fly|Ride"] = 88.76, ["Neon"] = 547.77, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 957.71, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.84, ["Fly"] = 27.72, ["Ride"] = 17.07, ["Fly|Ride"] = 47.99, ["Neon"] = 24.03, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 72.1, ["Mega"] = 525, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.94, ["Fly"] = 40.63, ["Ride"] = 31.39, ["Fly|Ride"] = 1312.5, ["Neon"] = 25.99, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 151.77, ["Mega"] = 246.09, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 58.43, ["Fly"] = 65.62, ["Ride"] = 61.69, ["Fly|Ride"] = 102.59, ["Neon"] = 403.44, ["Neon|Ride"] = 232.54, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1070.14}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1575, ["Ride"] = 1649.82, ["Fly|Ride"] = 1569.75, ["Neon|Fly|Ride"] = 3804.94, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 393.75, ["Fly"] = 479.64, ["Ride"] = 393.65, ["Fly|Ride"] = 615.47, ["Neon|Fly|Ride"] = 3008.44, ["Mega|Fly|Ride"] = 9570.8}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 239.52, ["Ride"] = 325.26, ["Fly|Ride"] = 392.44, ["Neon"] = 1500.69, ["Neon|Ride"] = 1477.09, ["Neon|Fly|Ride"] = 1572.94, ["Mega|Fly|Ride"] = 7177.59}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.37}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.46, ["Ride"] = 47.14, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 464.86, ["Mega|Ride"] = 1230.45, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 47886.69, ["Fly"] = 65625, ["Ride"] = 34866.61, ["Fly|Ride"] = 17979.93, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 336.53, ["Fly"] = 446.21, ["Ride"] = 485.62, ["Fly|Ride"] = 464.91, ["Neon"] = 1366.32, ["Neon|Fly"] = 1240.51, ["Neon|Ride"] = 984.96, ["Neon|Fly|Ride"] = 1151.07, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 3796.67}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 159.49, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 137.44, ["Fly"] = 262.49, ["Ride"] = 124.69, ["Fly|Ride"] = 190.32, ["Neon|Ride"] = 547.56, ["Neon|Fly|Ride"] = 683.93, ["Mega|Fly|Ride"] = 2460.89}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.52, ["Fly"] = 94.5, ["Ride"] = 35.44, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 694.96, ["Mega|Fly|Ride"] = 627.54}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4980.88, ["Ride"] = 4959.21, ["Fly|Ride"] = 5021.07, ["Neon"] = 20515.05, ["Neon|Fly|Ride"] = 27343.5, ["Mega|Fly|Ride"] = 61980.71}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 24.67, ["Fly"] = 137.42, ["Ride"] = 29, ["Fly|Ride"] = 52.5, ["Neon"] = 337.32, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 43.26, ["Ride"] = 56.26, ["Fly|Ride"] = 109.3, ["Neon"] = 398, ["Neon|Ride"] = 232.86, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 720.56, ["Fly"] = 918.75, ["Ride"] = 732.38, ["Fly|Ride"] = 886.27, ["Neon|Fly|Ride"] = 2415, ["Mega"] = 7443.16, ["Mega|Fly"] = 7443.16, ["Mega|Fly|Ride"] = 7443.16}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 19.8, ["Fly"] = 26.15, ["Ride"] = 25.72, ["Fly|Ride"] = 44.89, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 137.41, ["Mega|Fly|Ride"] = 853.01}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 18.38, ["Ride"] = 30.79, ["Fly|Ride"] = 465.05, ["Neon"] = 80.01, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 406.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 89.24, ["Ride"] = 115.92, ["Fly|Ride"] = 137.47, ["Neon"] = 615.47, ["Neon|Ride"] = 752.92, ["Neon|Fly|Ride"] = 594.72, ["Mega|Fly|Ride"] = 2598.29}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 18.48, ["Fly"] = 137.52, ["Ride"] = 55.41, ["Fly|Ride"] = 164.9, ["Neon"] = 91.2, ["Neon|Fly"] = 102.74, ["Neon|Ride"] = 118.26, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 249.38, ["Mega|Fly"] = 737.97, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4264.6, ["Ride"] = 3883.64, ["Fly|Ride"] = 4000.5, ["Neon"] = 16001.75, ["Neon|Ride"] = 12202.37, ["Neon|Fly|Ride"] = 9581.25, ["Mega"] = 61521.07, ["Mega|Fly|Ride"] = 35328.56}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 45.05, ["Ride"] = 78.75, ["Fly|Ride"] = 190.68, ["Neon"] = 393.32, ["Neon|Ride"] = 245.17, ["Neon|Fly|Ride"] = 410.17, ["Mega|Ride"] = 1017.18, ["Mega|Fly|Ride"] = 1812.92}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Fly"] = 7522.88, ["Ride"] = 6857.82, ["Fly|Ride"] = 6339.37, ["Neon|Ride"] = 18873.85, ["Neon|Fly|Ride"] = 17049.38, ["Mega|Fly|Ride"] = 76902.6}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.19, ["Fly"] = 16.27, ["Ride"] = 16.43, ["Fly|Ride"] = 41.99, ["Neon"] = 27.71, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 45.14, ["Neon|Fly|Ride"] = 84.18, ["Mega"] = 449.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 13.82, ["Fly"] = 26.16, ["Ride"] = 26.25, ["Fly|Ride"] = 50.04, ["Neon"] = 135.42, ["Neon|Fly"] = 226.71, ["Neon|Ride"] = 190.81, ["Neon|Fly|Ride"] = 167.99, ["Mega|Ride"] = 1247.55, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.67}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 19.51, ["Ride"] = 39, ["Fly|Ride"] = 116.01, ["Neon"] = 268.51, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 1049.9, ["Mega|Ride"] = 957.71, ["Mega|Fly|Ride"] = 764.1}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 28.88, ["Fly"] = 190.37, ["Ride"] = 55.41, ["Fly|Ride"] = 99.73, ["Neon"] = 201.06, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 10.49, ["Fly"] = 19.69, ["Ride"] = 19.68, ["Fly|Ride"] = 42.28, ["Neon|Ride"] = 113.88, ["Neon|Fly|Ride"] = 175.18, ["Mega"] = 654.94, ["Mega|Ride"] = 579.91, ["Mega|Fly|Ride"] = 507.41}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8311.71}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.96}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 26.24}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 164.07, ["Ride"] = 196.88, ["Fly|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1025.38, ["Mega|Fly|Ride"] = 5537}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 25.91, ["Fly"] = 129.26, ["Ride"] = 40.14, ["Fly|Ride"] = 105, ["Neon"] = 139.53, ["Neon|Ride"] = 114.47, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 929.72, ["Mega|Fly|Ride"] = 950.53}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.11}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 4.87, ["Ride"] = 29.76, ["Fly|Ride"] = 80.01, ["Neon"] = 81.04, ["Neon|Ride"] = 94.39, ["Neon|Fly|Ride"] = 140.24, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 179.18, ["Fly"] = 410.31, ["Ride"] = 204.14, ["Fly|Ride"] = 301.88, ["Neon"] = 701.37, ["Neon|Ride"] = 918.75, ["Mega|Ride"] = 3144.82, ["Mega|Fly|Ride"] = 3419.61}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 71.06, ["Ride"] = 140.44, ["Fly|Ride"] = 211.32, ["Neon"] = 684.2, ["Neon|Ride"] = 410.31, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 3281.2}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 170.63, ["Fly"] = 265.49, ["Ride"] = 207.38, ["Fly|Ride"] = 250.6, ["Neon"] = 897.75, ["Neon|Ride"] = 842.63, ["Neon|Fly|Ride"] = 849.79, ["Mega|Fly|Ride"] = 3718.81}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2461.82, ["Ride"] = 1968.75, ["Fly|Ride"] = 1818.04, ["Neon"] = 8138.22, ["Neon|Fly|Ride"] = 6014.82, ["Mega|Fly|Ride"] = 24472.47}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.04, ["Fly"] = 96.48, ["Ride"] = 56.8, ["Fly|Ride"] = 69.01, ["Neon"] = 170.29, ["Neon|Ride"] = 202.32, ["Neon|Fly|Ride"] = 260.46, ["Mega"] = 921.83, ["Mega|Ride"] = 853.01, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 876.72, ["Fly"] = 2100, ["Ride"] = 807.29, ["Fly|Ride"] = 923.2, ["Neon|Fly|Ride"] = 4029.1}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 52.29}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.97, ["Ride"] = 39.38, ["Fly|Ride"] = 137.47, ["Neon"] = 101.06, ["Neon|Ride"] = 117.98, ["Neon|Fly|Ride"] = 302.5, ["Mega"] = 480.27, ["Mega|Ride"] = 464.86, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.77, ["Fly"] = 162.24, ["Ride"] = 27.56, ["Fly|Ride"] = 94.83, ["Neon"] = 62.79, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 918.75, ["Mega|Ride"] = 355.83, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 14.54, ["Ride"] = 22.31, ["Fly|Ride"] = 80.01, ["Neon"] = 191.83, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 1504.22}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.49, ["Fly"] = 51.33, ["Ride"] = 41.02, ["Fly|Ride"] = 67.32, ["Neon"] = 232.86, ["Neon|Ride"] = 294.41, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 876.7, ["Mega|Ride"] = 1743.2, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10941.71, ["Ride"] = 5250, ["Fly|Ride"] = 5144.9, ["Neon|Fly|Ride"] = 11550, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.61, ["Fly"] = 57.29, ["Ride"] = 38.72, ["Fly|Ride"] = 105, ["Neon"] = 82.07, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 191.76, ["Mega"] = 520.65, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly"] = 363.13, ["Ride"] = 135.19, ["Fly|Ride"] = 210, ["Neon"] = 525, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 733.31, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 72.11, ["Fly"] = 124.31, ["Ride"] = 90.37, ["Fly|Ride"] = 246.2, ["Neon"] = 262.4, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 396.83, ["Mega"] = 2324.26, ["Mega|Ride"] = 2768.51, ["Mega|Fly|Ride"] = 1650.23}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.03, ["Fly"] = 70.47, ["Ride"] = 31.39, ["Fly|Ride"] = 45.94, ["Neon"] = 128.77, ["Neon|Ride"] = 184.65, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1016.21, ["Mega|Ride"] = 835.7, ["Mega|Fly|Ride"] = 656.23}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.94, ["Fly"] = 68.74, ["Ride"] = 23.84, ["Fly|Ride"] = 91.87, ["Neon"] = 39.38, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 178.5, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 219.58, ["Mega|Fly|Ride"] = 307.51}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.51, ["Ride"] = 31.25, ["Fly|Ride"] = 65.63, ["Neon"] = 115.92, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.44, ["Mega"] = 720.54, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 629.58}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.36, ["Fly"] = 30.19, ["Ride"] = 30.78, ["Fly|Ride"] = 42, ["Neon"] = 205.16, ["Neon|Ride"] = 164.13, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly|Ride"] = 707.52}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 220.5}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 24.66, ["Ride"] = 131.25, ["Fly|Ride"] = 273.78, ["Neon"] = 147.67, ["Neon|Ride"] = 205.16, ["Mega"] = 820.32, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 219.6, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.71, ["Neon"] = 1230.92}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.83, ["Fly"] = 212.02, ["Ride"] = 122.1, ["Fly|Ride"] = 205.16, ["Neon"] = 259.86, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 525, ["Mega"] = 905.62, ["Mega|Ride"] = 1020.26, ["Mega|Fly|Ride"] = 1203.8}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.38, ["Fly"] = 1334.47, ["Ride"] = 975.9, ["Fly|Ride"] = 1023.75, ["Neon|Fly"] = 4022.62, ["Neon|Ride"] = 3145.99, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12480.79}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 262.5, ["Fly"] = 684.2, ["Ride"] = 428.36, ["Fly|Ride"] = 478.01, ["Neon"] = 2872.12, ["Neon|Ride"] = 2051.52, ["Neon|Fly|Ride"] = 1915.4, ["Mega|Fly|Ride"] = 7217.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 68.25}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.07, ["Fly"] = 55.38, ["Ride"] = 25.74, ["Fly|Ride"] = 50.16, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 437.26, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 305.05, ["Fly"] = 410.21, ["Ride"] = 304.5, ["Fly|Ride"] = 469.55, ["Neon"] = 1086.29, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1114.59, ["Mega|Fly|Ride"] = 2756.25}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.18}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 126, ["Ride"] = 183.22, ["Fly|Ride"] = 304.49, ["Neon"] = 1339.65, ["Neon|Ride"] = 560.07, ["Neon|Fly|Ride"] = 1739.07, ["Mega"] = 3008.44, ["Mega|Ride"] = 11664.6, ["Mega|Fly|Ride"] = 2871.05}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 138.54, ["Ride"] = 125.89, ["Fly|Ride"] = 205.16, ["Neon"] = 684.2, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2407.58}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Ride"] = 29.3, ["Fly|Ride"] = 167.22, ["Neon"] = 36.75, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 226.63, ["Mega"] = 264.75, ["Mega|Ride"] = 509.03, ["Mega|Fly|Ride"] = 818.26}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 17.77, ["Fly"] = 63.03, ["Ride"] = 26.64, ["Fly|Ride"] = 71.05, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 310.3, ["Mega|Ride"] = 798.78, ["Mega|Fly|Ride"] = 615.23}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.36, ["Fly"] = 102.33, ["Ride"] = 44.63, ["Fly|Ride"] = 116.95, ["Neon"] = 105, ["Neon|Ride"] = 101.56, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.65, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 491.17}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.07, ["Fly"] = 157.5, ["Ride"] = 52.39, ["Fly|Ride"] = 170.63, ["Neon"] = 30.19, ["Neon|Fly"] = 232.54, ["Neon|Ride"] = 61.68, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 160.95, ["Mega|Fly"] = 192.78, ["Mega|Ride"] = 178.4, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.5, ["Fly"] = 323.25, ["Ride"] = 342.61, ["Fly|Ride"] = 376.68, ["Neon"] = 1610.44, ["Neon|Ride"] = 1499.67, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5195.55}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 154.88, ["Fly"] = 293.04, ["Ride"] = 237.62, ["Fly|Ride"] = 261.19, ["Neon"] = 752.92, ["Neon|Ride"] = 721.87, ["Neon|Fly|Ride"] = 711.76, ["Mega"] = 9843.54, ["Mega|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 3829.76}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 135.19, ["Ride"] = 107.63, ["Fly|Ride"] = 151.82, ["Neon|Ride"] = 547.77, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 12.48, ["Ride"] = 58.24, ["Fly|Ride"] = 273.9, ["Neon"] = 340.56, ["Neon|Ride"] = 590.62, ["Neon|Fly|Ride"] = 478.87, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 1845.67}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.75, ["Fly"] = 57.29, ["Ride"] = 48.22, ["Fly|Ride"] = 97.47, ["Neon"] = 77.39, ["Neon|Ride"] = 102.55, ["Neon|Fly|Ride"] = 157.92, ["Mega"] = 410.17, ["Mega|Fly"] = 525, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 52.33, ["Ride"] = 22.89, ["Fly|Ride"] = 82.07, ["Neon"] = 19.59, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 135.36, ["Mega"] = 133.77, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.5, ["Fly"] = 1078.49, ["Ride"] = 777, ["Fly|Ride"] = 1035.91, ["Neon|Fly"] = 3411.09, ["Neon|Ride"] = 3282.42, ["Neon|Fly|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 9707.17}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 410.47, ["Ride"] = 597.19, ["Fly|Ride"] = 547.77, ["Neon|Ride"] = 1534.54, ["Neon|Fly|Ride"] = 1611.89, ["Mega"] = 10252.68, ["Mega|Fly|Ride"] = 6271.42}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 78.75, ["Fly"] = 137.52, ["Ride"] = 124.57, ["Fly|Ride"] = 147.67, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 460.41, ["Mega|Fly|Ride"] = 1896.95}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 359.17, ["Fly|Ride"] = 314.81, ["Neon"] = 1163.22, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 5469.33}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.85, ["Fly"] = 72.87, ["Ride"] = 28.28, ["Fly|Ride"] = 71.48, ["Neon"] = 169.32, ["Neon|Ride"] = 216.26, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 773.99}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 262.5, ["Fly|Ride"] = 472.4, ["Neon"] = 758.33, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 929.72, ["Mega"] = 4081.27, ["Mega|Ride"] = 4238.89, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 45.85, ["Fly"] = 125.98, ["Ride"] = 72.02, ["Fly|Ride"] = 94.5, ["Neon|Ride"] = 240.03, ["Neon|Fly|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 2231.25, ["Fly|Ride"] = 1964.48, ["Neon|Ride"] = 10847.27, ["Neon|Fly|Ride"] = 6357.29, ["Mega"] = 49217.67, ["Mega|Fly|Ride"] = 23242.03}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.68, ["Fly"] = 82.17, ["Ride"] = 91.87, ["Fly|Ride"] = 113.88, ["Neon"] = 57.95, ["Neon|Fly"] = 226.71, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 227.85, ["Mega"] = 320.66, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.3, ["Ride"] = 81.04, ["Fly|Ride"] = 102.38, ["Neon"] = 272.87, ["Neon|Ride"] = 305.69, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1022.31, ["Mega|Fly|Ride"] = 955.66}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.75, ["Fly"] = 91.85, ["Ride"] = 85.28, ["Fly|Ride"] = 97.01, ["Neon"] = 465.71, ["Neon|Ride"] = 452.38, ["Neon|Fly|Ride"] = 505.32, ["Mega|Fly|Ride"] = 1823.95}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3419.11, ["Ride"] = 1050, ["Fly|Ride"] = 1170.23}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 407.01, ["Fly"] = 818.56, ["Ride"] = 561.1, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 2789.12, ["Mega|Fly|Ride"] = 11550}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 78.75, ["Fly"] = 202.25, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 446.8, ["Neon|Fly"] = 615.47, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 594.72, ["Mega"] = 4101.49, ["Mega|Ride"] = 4101.49, ["Mega|Fly|Ride"] = 2709.26}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.34, ["Ride"] = 31.39, ["Fly|Ride"] = 78.66, ["Neon"] = 87.94, ["Neon|Fly"] = 137.47, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 762.72, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 40.85, ["Fly"] = 54.53, ["Ride"] = 48.06, ["Fly|Ride"] = 102.59, ["Neon"] = 196.88, ["Neon|Fly"] = 410.31, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1189.44, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 740.64, ["Ride"] = 874.13, ["Fly|Ride"] = 892.5, ["Neon"] = 3007.52, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.37, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 682.4}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 4987.5, ["Fly|Ride"] = 4921.88, ["Neon"] = 42000, ["Neon|Ride"] = 29399.1, ["Neon|Fly|Ride"] = 23925.95, ["Mega|Fly|Ride"] = 87498.77}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 315.95, ["Fly"] = 410.93, ["Ride"] = 393.75, ["Neon"] = 1641.22, ["Neon|Ride"] = 2051.52, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 6151.2, ["Mega|Fly|Ride"] = 6152.22}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 84, ["Fly"] = 273.99, ["Ride"] = 96.44, ["Fly|Ride"] = 336, ["Neon"] = 420, ["Neon|Ride"] = 647.27, ["Neon|Fly|Ride"] = 547.56, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 17.46, ["Fly"] = 58.5, ["Ride"] = 37.69, ["Fly|Ride"] = 102.27, ["Neon"] = 113.3, ["Neon|Fly"] = 1240.51, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.23, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 11.82, ["Fly"] = 26.17, ["Ride"] = 21, ["Fly|Ride"] = 44.34, ["Neon"] = 205.16, ["Neon|Ride"] = 310.44, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2173.8}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.65, ["Fly"] = 273.99, ["Ride"] = 40.06, ["Fly|Ride"] = 140.44, ["Neon"] = 115.5, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 211.23, ["Mega"] = 670.69, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 55.42, ["Ride"] = 21.93, ["Fly|Ride"] = 48.57, ["Neon"] = 28.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 123.3, ["Mega"] = 273.78, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 29.43, ["Fly"] = 90.57, ["Ride"] = 51.19, ["Fly|Ride"] = 183.62, ["Neon"] = 172.08, ["Neon|Fly"] = 820.61, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 364.16, ["Mega"] = 820.32, ["Mega|Ride"] = 670.61, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 387.19, ["Fly"] = 464.91, ["Ride"] = 405.57, ["Fly|Ride"] = 420, ["Neon"] = 1362.21, ["Neon|Ride"] = 1368.38, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 7875, ["Mega|Fly"] = 5048.93, ["Mega|Fly|Ride"] = 4921.77}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.03, ["Fly|Ride"] = 30.19, ["Neon"] = 19.69, ["Neon|Ride"] = 32.68, ["Neon|Fly|Ride"] = 86.43, ["Mega"] = 820.32, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 243.77}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 52.44, ["Fly"] = 86.16, ["Ride"] = 83.32, ["Fly|Ride"] = 150.5, ["Neon"] = 196.88, ["Neon|Fly"] = 285.17, ["Neon|Ride"] = 202.42, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1353.5, ["Mega|Ride"] = 582.64, ["Mega|Fly|Ride"] = 575.88}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 955.35, ["Fly"] = 999.99, ["Ride"] = 880.15, ["Fly|Ride"] = 818.99, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1554, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 33.99, ["Fly"] = 91.88, ["Ride"] = 55.17, ["Fly|Ride"] = 82.07, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 767.82}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 262.5, ["Fly"] = 339.71, ["Ride"] = 257.25, ["Fly|Ride"] = 288.72, ["Neon|Ride"] = 1778.67, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 13945.5}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 177.17, ["Fly"] = 232.95, ["Ride"] = 157.39, ["Fly|Ride"] = 236.24, ["Neon|Ride"] = 793.95, ["Neon|Fly|Ride"] = 773.15, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 2872.12, ["Neon|Fly|Ride"] = 2980.76, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.5, ["Ride"] = 43.21, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Fly"] = 279.04, ["Neon|Ride"] = 106.65, ["Neon|Fly|Ride"] = 269.63, ["Mega"] = 354.38, ["Mega|Ride"] = 356.79, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3465, ["Fly"] = 3543.75, ["Ride"] = 3924.38, ["Fly|Ride"] = 3377.06, ["Neon"] = 13677.39, ["Neon|Fly|Ride"] = 6825, ["Mega|Fly|Ride"] = 24395.26}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 116.82, ["Fly"] = 166.28, ["Ride"] = 129.94, ["Fly|Ride"] = 161.33, ["Neon"] = 550.97, ["Neon|Ride"] = 547.77, ["Neon|Fly|Ride"] = 574.23, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.32, ["Ride"] = 19.69, ["Fly|Ride"] = 44.1, ["Neon"] = 19.51, ["Neon|Fly"] = 62.34, ["Neon|Ride"] = 30.78, ["Neon|Fly|Ride"] = 105, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.84, ["Ride"] = 22.6, ["Fly|Ride"] = 58.15, ["Neon"] = 20.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 199.49, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 55.42, ["Ride"] = 35.26, ["Fly|Ride"] = 61.56, ["Neon|Ride"] = 376.47, ["Neon|Fly|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 907.12, ["Ride"] = 1094.48, ["Fly|Ride"] = 1260, ["Neon|Fly|Ride"] = 4235.81}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Fly|Ride"] = 7317.73}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 17.07, ["Fly"] = 34.9, ["Ride"] = 27.57, ["Fly|Ride"] = 47.06, ["Neon"] = 452.13, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 164.08, ["Mega"] = 2460.89, ["Mega|Ride"] = 955.66, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 17.73, ["Fly"] = 55.42, ["Ride"] = 28.65, ["Fly|Ride"] = 65.62, ["Neon"] = 89.24, ["Neon|Ride"] = 93.02, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 655.54, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.56, ["Fly"] = 157.49, ["Ride"] = 65.51, ["Fly|Ride"] = 91.88, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 440.49, ["Mega|Fly|Ride"] = 1368.99}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.25, ["Ride"] = 263.34, ["Fly|Ride"] = 342.61, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1083.11, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 4248.12}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 5.15, ["Ride"] = 32.68, ["Fly|Ride"] = 86.52, ["Neon"] = 20.98, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 55.41, ["Mega"] = 143.75, ["Mega|Ride"] = 186.63, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.74, ["Fly"] = 307.74, ["Ride"] = 205.16, ["Fly|Ride"] = 282.19, ["Neon"] = 718.62, ["Neon|Ride"] = 889.34, ["Neon|Fly|Ride"] = 843.94, ["Mega|Fly|Ride"] = 5315.63}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.33, ["Fly"] = 55.42, ["Ride"] = 17.04, ["Fly|Ride"] = 39.35, ["Neon"] = 22.32, ["Neon|Fly"] = 123.04, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 355.83, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 301.77}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 231, ["Fly"] = 195.17, ["Ride"] = 225.48, ["Fly|Ride"] = 262.5, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10253.69, ["Mega|Ride"] = 4101.49, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 13.83, ["Fly"] = 79.48, ["Ride"] = 26.69, ["Fly|Ride"] = 68.25, ["Neon"] = 72.02, ["Neon|Fly"] = 295.32, ["Neon|Ride"] = 96.44, ["Neon|Fly|Ride"] = 155.74, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.77, ["Ride"] = 19.36, ["Fly|Ride"] = 59.07, ["Neon"] = 7.33, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 176.88, ["Mega"] = 78.75, ["Mega|Ride"] = 100.7, ["Mega|Fly|Ride"] = 195.46}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.92, ["Neon|Ride"] = 41.04, ["Mega"] = 18.37, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.83, ["Fly|Ride"] = 108.18, ["Neon"] = 5.65, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 72.95, ["Mega|Fly"] = 154950.57, ["Mega|Ride"] = 94.27, ["Mega|Fly|Ride"] = 164.04}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 69.77, ["Fly"] = 139.49, ["Ride"] = 120.16, ["Fly|Ride"] = 177.07, ["Neon"] = 347.17, ["Neon|Fly"] = 389.81, ["Neon|Ride"] = 384.57, ["Neon|Fly|Ride"] = 373.13, ["Mega|Ride"] = 1332.99, ["Mega|Fly|Ride"] = 1128.75}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 15.73, ["Fly|Ride"] = 108.74, ["Neon"] = 5.15, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 109.26, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.95, ["Ride"] = 101.07, ["Neon"] = 51.79, ["Neon|Ride"] = 259.62}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.55, ["Neon|Ride"] = 47.36, ["Mega"] = 16.95, ["Mega|Ride"] = 48, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 39.84, ["Ride"] = 15, ["Fly|Ride"] = 33.45, ["Neon"] = 2.1, ["Neon|Fly"] = 9.19, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 31.85, ["Mega"] = 14.57, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.27, ["Mega|Fly|Ride"] = 50.53}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 27.72, ["Ride"] = 12.47, ["Fly|Ride"] = 26.25, ["Neon"] = 2.7, ["Neon|Fly"] = 22.51, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 45.13, ["Mega"] = 30.32, ["Mega|Ride"] = 921.04, ["Mega|Fly|Ride"] = 99.2}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 62.39, ["Mega"] = 19.69, ["Mega|Ride"] = 121.85}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 19.69, ["Fly|Ride"] = 107.63, ["Neon"] = 5.15, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 41.5, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 116.91}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.73, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 15.38, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 68.77, ["Ride"] = 17.31, ["Fly|Ride"] = 70.03, ["Neon"] = 12.77, ["Neon|Fly"] = 68.74, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 78.56, ["Mega"] = 114.09, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 183.62}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.38, ["Mega"] = 16.54, ["Mega|Ride"] = 37.97, ["Mega|Fly|Ride"] = 184.57}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 342.49}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.93, ["Ride"] = 27.57, ["Neon"] = 15.64, ["Mega"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.29, ["Neon|Ride"] = 26.67, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 21.79, ["Mega|Ride"] = 49.23, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.41, ["Fly|Ride"] = 30.14, ["Neon"] = 2.1, ["Neon|Fly"] = 11.82, ["Neon|Ride"] = 12.31, ["Neon|Fly|Ride"] = 31.05, ["Mega"] = 13.12, ["Mega|Fly"] = 38.98, ["Mega|Ride"] = 19.25, ["Mega|Fly|Ride"] = 45.85}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 36.75, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 19.59, ["Neon"] = 6.98, ["Neon|Ride"] = 51.31, ["Neon|Fly|Ride"] = 105, ["Mega"] = 28.86, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 50.7, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.16, ["Neon"] = 10.02, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 98.88, ["Mega|Ride"] = 158.89, ["Mega|Fly|Ride"] = 238.87}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 262.49, ["Ride"] = 34.54, ["Fly|Ride"] = 43.32, ["Neon"] = 20.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 167.2}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 11.71, ["Ride"] = 11.62, ["Fly|Ride"] = 26.28, ["Neon"] = 2.1, ["Neon|Fly"] = 11.71, ["Neon|Ride"] = 12.06, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 15.64, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 21.95, ["Mega|Fly|Ride"] = 44.63}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 20.52, ["Fly|Ride"] = 137.47, ["Neon"] = 12.55, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 91.77, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 314.9}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 22.22, ["Fly|Ride"] = 59.06, ["Neon"] = 77.24, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 227.07, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 399.67}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 12.22, ["Fly|Ride"] = 32.71, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 34.48, ["Mega"] = 31.39, ["Mega|Ride"] = 36.75, ["Mega|Fly|Ride"] = 98.14}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.59, ["Fly"] = 171.38, ["Ride"] = 30.23, ["Neon"] = 3.83, ["Neon|Ride"] = 26.63, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 81.81, ["Mega|Fly"] = 164.08, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 239.4}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.33, ["Fly|Ride"] = 65.63, ["Neon"] = 5.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 33.7, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 133.31, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.65, ["Ride"] = 27.56, ["Neon"] = 2.21, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.96, ["Mega"] = 15.49, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 159.97}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 96.44, ["Ride"] = 22.58, ["Fly|Ride"] = 41.91, ["Neon"] = 4.85, ["Neon|Fly"] = 55.41, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 65.01, ["Mega|Ride"] = 62.77, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 68.24, ["Neon"] = 5.2, ["Neon|Ride"] = 36.01, ["Mega"] = 35.82, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.32, ["Fly|Ride"] = 47.24, ["Neon"] = 7.66, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 84, ["Mega"] = 91.88, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 338.09}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.63, ["Fly"] = 40.74, ["Ride"] = 39.38, ["Neon"] = 38.75, ["Neon|Ride"] = 73.87, ["Mega"] = 98.18, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.38, ["Fly|Ride"] = 137.47, ["Neon"] = 20.52, ["Neon|Fly"] = 104.64, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 202.23, ["Mega|Fly"] = 420, ["Mega|Ride"] = 176.66}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 12.78, ["Fly|Ride"] = 40.68, ["Neon"] = 15.47, ["Neon|Fly"] = 33.87, ["Neon|Ride"] = 38.74, ["Neon|Fly|Ride"] = 65.29, ["Mega"] = 273.95, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 232.44}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Fly|Ride"] = 137.47, ["Neon"] = 23.35, ["Neon|Ride"] = 101.16, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 11.21, ["Ride"] = 56.44, ["Neon"] = 137.45, ["Neon|Ride"] = 232.54, ["Mega"] = 547.56, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.65, ["Ride"] = 136.19, ["Fly|Ride"] = 104.71, ["Neon"] = 39.1, ["Neon|Ride"] = 125.71, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 253.32, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 2.86, ["Ride"] = 29.09, ["Fly|Ride"] = 120.75, ["Neon"] = 54.97, ["Neon|Ride"] = 101.56, ["Neon|Fly|Ride"] = 181.55, ["Mega"] = 287.12, ["Mega|Ride"] = 287.12, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 64.99, ["Mega"] = 20.9, ["Mega|Fly"] = 123.05, ["Mega|Ride"] = 123.05, ["Mega|Fly|Ride"] = 151.77}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 48.35}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.46, ["Fly"] = 23, ["Ride"] = 19.51, ["Fly|Ride"] = 54.51, ["Neon"] = 45.84, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.46, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 374.32, ["Mega|Ride"] = 348.59, ["Mega|Fly|Ride"] = 799.26}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 92.37, ["Ride"] = 19.56, ["Neon"] = 5.25, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 26.69, ["Mega"] = 27.69, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 32.74, ["Neon"] = 3.71, ["Neon|Ride"] = 31.57, ["Neon|Fly|Ride"] = 98, ["Mega"] = 77.43, ["Mega|Ride"] = 73.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.45, ["Ride"] = 15.69, ["Fly|Ride"] = 55.13, ["Neon"] = 3.94, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 123.12, ["Mega"] = 123.05, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.39, ["Ride"] = 49.25, ["Fly|Ride"] = 62.79, ["Neon"] = 35.04, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 275.45, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 32.81, ["Neon"] = 2.6, ["Mega"] = 19.47, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 56.74, ["Mega|Fly|Ride"] = 328.14}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.65, ["Ride"] = 15.94, ["Fly|Ride"] = 273534.2, ["Neon"] = 3.42, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 27.69, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 23.62, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 72.72, ["Mega|Fly|Ride"] = 137.45}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.71, ["Ride"] = 14.45, ["Fly|Ride"] = 68.74, ["Neon"] = 4.94, ["Neon|Fly"] = 26.69, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 47.95, ["Mega|Ride"] = 109.74, ["Mega|Fly|Ride"] = 155.74}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.71, ["Ride"] = 32.16, ["Fly|Ride"] = 147.67, ["Neon"] = 5.22, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 110.77, ["Mega"] = 27.45, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 208.6}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Ride"] = 164.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 20.58, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 102.55, ["Mega|Fly|Ride"] = 149.2}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 20.52, ["Fly|Ride"] = 45.94, ["Neon"] = 3.26, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 76.76, ["Mega"] = 19.35, ["Mega|Fly"] = 45.94, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 127.05}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 48.22, ["Neon"] = 2.1, ["Mega"] = 656.25, ["Mega|Ride"] = 224.6}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.37, ["Neon"] = 4.08, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 420, ["Mega"] = 23.1, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 16.15, ["Fly|Ride"] = 49.88, ["Neon"] = 6.19, ["Neon|Fly"] = 55.41, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 90.2, ["Mega|Ride"] = 94.54, ["Mega|Fly|Ride"] = 82.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 14.43, ["Ride"] = 139.49, ["Neon"] = 170.63, ["Mega"] = 1025.38, ["Mega|Ride"] = 545.51, ["Mega|Fly|Ride"] = 519.87}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 58.15, ["Neon|Ride"] = 203.11, ["Mega"] = 1640.61, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.65, ["Ride"] = 30.18, ["Fly|Ride"] = 410.17, ["Neon"] = 39, ["Neon|Fly|Ride"] = 260.46, ["Mega"] = 295.19, ["Mega|Ride"] = 350.69, ["Mega|Fly|Ride"] = 401.97}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.32, ["Ride"] = 11.67, ["Fly|Ride"] = 22.72, ["Neon"] = 2.1, ["Neon|Fly"] = 14.58, ["Neon|Ride"] = 11.82, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 16.54, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 19.85, ["Mega|Fly|Ride"] = 49.86}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 57.46, ["Fly|Ride"] = 109.77, ["Neon"] = 8.22, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 45.94, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 30.78, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 68.65, ["Mega"] = 14.32, ["Mega|Fly"] = 87.47, ["Mega|Ride"] = 71.6, ["Mega|Fly|Ride"] = 116.89}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 123.11, ["Mega"] = 16.41, ["Mega|Ride"] = 102.55, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.52, ["Fly"] = 38.51, ["Ride"] = 15.66, ["Fly|Ride"] = 42.69, ["Neon"] = 8.71, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 90.96, ["Mega"] = 208.85, ["Mega|Ride"] = 205.09, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 168, ["Ride"] = 194.11, ["Fly|Ride"] = 177.19, ["Neon|Ride"] = 1641.22, ["Neon|Fly|Ride"] = 1094.09, ["Mega"] = 8202.95, ["Mega|Fly|Ride"] = 3550.87}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 19.51, ["Neon"] = 6.57, ["Neon|Ride"] = 64.32, ["Mega"] = 90.96, ["Mega|Ride"] = 124.36, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 7.75, ["Fly"] = 63.67, ["Ride"] = 25.57, ["Fly|Ride"] = 59.07, ["Neon"] = 31.4, ["Neon|Ride"] = 92.98, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 406.06}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.01, ["Ride"] = 11.82, ["Fly|Ride"] = 32.13, ["Neon"] = 6.06, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 49.68, ["Mega|Ride"] = 79.99, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.57, ["Neon"] = 6.13, ["Neon|Ride"] = 78.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 18.29, ["Ride"] = 15.75, ["Fly|Ride"] = 36, ["Neon"] = 34.04, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 260.46, ["Mega|Ride"] = 269.7, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.6, ["Ride"] = 34.31, ["Fly|Ride"] = 249.58, ["Neon"] = 55.17, ["Neon|Ride"] = 137.45, ["Neon|Fly|Ride"] = 609.09, ["Mega"] = 512.7, ["Mega|Ride"] = 255.64, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 16.41, ["Ride"] = 15.41, ["Fly|Ride"] = 29.75, ["Neon"] = 17.75, ["Neon|Fly"] = 75.93, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 157.5, ["Mega|Ride"] = 232.78, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 68.25, ["Fly"] = 178.5, ["Ride"] = 92.54, ["Fly|Ride"] = 157.5, ["Neon"] = 360.61, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 378.12}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 328.26, ["Ride"] = 248.79, ["Fly|Ride"] = 313.34, ["Neon|Ride"] = 2564.39, ["Neon|Fly|Ride"] = 1230.45, ["Mega"] = 10253.69, ["Mega|Fly|Ride"] = 4645.96}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.41, ["Fly"] = 137.52, ["Ride"] = 77.88, ["Fly|Ride"] = 78.75, ["Neon"] = 697.58, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 382.01, ["Mega|Fly|Ride"] = 1387.22}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.97, ["Fly"] = 26.17, ["Ride"] = 27.65, ["Fly|Ride"] = 137.47, ["Neon"] = 24.25, ["Neon|Ride"] = 81.81, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 262.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.41, ["Fly"] = 68.74, ["Ride"] = 26.69, ["Fly|Ride"] = 90.28, ["Neon"] = 52.41, ["Neon|Ride"] = 123.11, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 818.26}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 12.32, ["Ride"] = 14.63, ["Fly|Ride"] = 34.93, ["Neon"] = 4.17, ["Neon|Fly"] = 25.59, ["Neon|Ride"] = 20.78, ["Neon|Fly|Ride"] = 58.83, ["Mega"] = 114.6, ["Mega|Fly"] = 52.5, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 175.35}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.16, ["Fly"] = 72.12, ["Ride"] = 20.9, ["Fly|Ride"] = 310.44, ["Neon"] = 99.83, ["Neon|Ride"] = 96.41, ["Neon|Fly|Ride"] = 136.29, ["Mega"] = 413.44, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 604.31}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 16.43, ["Fly|Ride"] = 36.11, ["Neon"] = 19.68, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 113.82, ["Mega|Ride"] = 204.88, ["Mega|Fly|Ride"] = 171.52}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 20.46, ["Fly|Ride"] = 328.13, ["Neon"] = 19.67, ["Neon|Ride"] = 61.53, ["Neon|Fly|Ride"] = 65.64, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 480.68}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 53.33, ["Mega"] = 14.84, ["Mega|Ride"] = 27.69, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.05, ["Fly|Ride"] = 55.41, ["Neon"] = 14.22, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 101.88, ["Mega|Fly|Ride"] = 209.19}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.88, ["Fly"] = 24.94, ["Ride"] = 18.5, ["Fly|Ride"] = 60.8, ["Neon"] = 34.9, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 260.46, ["Mega|Ride"] = 191.76, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 163.16, ["Fly"] = 232.86, ["Ride"] = 169.51, ["Fly|Ride"] = 213.7, ["Neon"] = 685.21, ["Neon|Ride"] = 749.36, ["Neon|Fly|Ride"] = 802.18, ["Mega"] = 4101.49, ["Mega|Fly|Ride"] = 2734.67}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.45, ["Ride"] = 31.8, ["Fly|Ride"] = 124.42, ["Neon"] = 51.03, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 383.5, ["Mega|Ride"] = 296.63, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 18.2, ["Ride"] = 14.09, ["Fly|Ride"] = 45.34, ["Neon"] = 22.98, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 104.61, ["Mega"] = 308.44, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 24.64, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 105, ["Neon|Ride"] = 290.26, ["Neon|Fly|Ride"] = 464.03, ["Mega"] = 511.29, ["Mega|Fly"] = 820.32, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 1025.38}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.1}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 28.24, ["Neon"] = 24.21, ["Neon|Ride"] = 273.9, ["Neon|Fly|Ride"] = 342.49, ["Mega"] = 307.62, ["Mega|Ride"] = 343.52, ["Mega|Fly|Ride"] = 889.01}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 31.83, ["Fly"] = 34.91, ["Ride"] = 28.88, ["Fly|Ride"] = 59.07, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 2050.76, ["Mega|Fly|Ride"] = 1915.4}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 102.59, ["Neon"] = 2.1, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 106.25, ["Mega"] = 31.5, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 227.11}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.92, ["Fly"] = 27.72, ["Ride"] = 15.67, ["Fly|Ride"] = 61.56, ["Neon"] = 45.55, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.54, ["Mega"] = 233.21, ["Mega|Fly"] = 388.16, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 340.44}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.89, ["Fly|Ride"] = 40.69, ["Neon"] = 13.29, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 174.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 209.79}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 35.93, ["Fly|Ride"] = 205.16, ["Neon"] = 6.07, ["Neon|Ride"] = 22.42, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 26.79, ["Mega|Ride"] = 53.76, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 32.45, ["Ride"] = 78.66, ["Fly|Ride"] = 147.72, ["Neon"] = 308.19, ["Neon|Fly|Ride"] = 801.89, ["Mega"] = 799.99, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Ride"] = 45.94, ["Fly|Ride"] = 210, ["Neon"] = 85.32, ["Neon|Ride"] = 116.28, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.58, ["Fly"] = 210, ["Ride"] = 21.15, ["Fly|Ride"] = 55.41, ["Neon"] = 22.3, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.29, ["Neon|Fly|Ride"] = 107.58, ["Mega"] = 342.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 85.56, ["Fly"] = 433.12, ["Ride"] = 385.86, ["Fly|Ride"] = 262.44, ["Neon"] = 328.13, ["Neon|Ride"] = 533.42, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1836.18}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.8, ["Fly"] = 26.17, ["Ride"] = 28.82, ["Fly|Ride"] = 62.79, ["Neon"] = 46.87, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 216.57, ["Mega|Ride"] = 269.7, ["Mega|Fly|Ride"] = 509.83}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.1, ["Fly"] = 186.38, ["Ride"] = 112.73, ["Fly|Ride"] = 171.68, ["Neon"] = 236.91, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 405.04, ["Mega"] = 1056.15, ["Mega|Ride"] = 1007.96, ["Mega|Fly|Ride"] = 957.84}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 26.66, ["Ride"] = 52.49, ["Fly|Ride"] = 172.34, ["Neon"] = 87.99, ["Neon|Ride"] = 135.42, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 470.96, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 456.1}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.58, ["Ride"] = 27.55, ["Fly|Ride"] = 68.74, ["Neon"] = 71.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 248.71, ["Mega"] = 205.09, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.05, ["Ride"] = 45.66, ["Fly|Ride"] = 273.9, ["Neon"] = 65.54, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 305.58, ["Mega"] = 269.62, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 19.58, ["Ride"] = 28.88, ["Fly|Ride"] = 55.73, ["Neon"] = 137.47, ["Neon|Ride"] = 69.67, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 236.25, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 383.5}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 57.2, ["Mega"] = 19.69, ["Mega|Ride"] = 123.05, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 28.24, ["Neon"] = 18.1, ["Neon|Fly"] = 123.11, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 96.5, ["Mega|Ride"] = 246.09, ["Mega|Fly|Ride"] = 467.19}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Neon"] = 25.82, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.16, ["Ride"] = 32.79, ["Fly|Ride"] = 116.28, ["Neon"] = 20.52, ["Neon|Ride"] = 82.95, ["Mega"] = 198.94, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 342.49}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 523.69, ["Ride"] = 514.5, ["Fly|Ride"] = 700.88, ["Neon"] = 1778.67, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1948.22, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.69, ["Fly"] = 27.72, ["Ride"] = 19.68, ["Fly|Ride"] = 62.77, ["Neon"] = 35.93, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.74, ["Mega|Ride"] = 355.63, ["Mega|Fly|Ride"] = 483.46}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 19.67, ["Fly"] = 524.69, ["Ride"] = 25.01, ["Fly|Ride"] = 51.35, ["Neon"] = 76.12, ["Neon|Fly"] = 315, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 330.75, ["Mega|Ride"] = 310.26, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 15.65, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 196.88, ["Mega"] = 263.82, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21, ["Fly|Ride"] = 88.75, ["Neon"] = 7.52, ["Neon|Ride"] = 34.04, ["Neon|Fly|Ride"] = 94.98, ["Mega"] = 59.06, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 112.87, ["Mega|Fly|Ride"] = 250.2}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 68.77, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 91.88, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.05}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.5, ["Ride"] = 36.75, ["Fly|Ride"] = 323.64, ["Neon"] = 83.72, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 273.78, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 25.1, ["Neon"] = 5.15, ["Neon|Ride"] = 73.84, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 164.08, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 58.97, ["Fly|Ride"] = 99.75, ["Neon"] = 15.4, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 183.73, ["Mega|Ride"] = 314.81, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 465.84, ["Ride"] = 523.69, ["Fly|Ride"] = 588.8, ["Neon|Ride"] = 1902.58, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 31.48, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.31, ["Neon"] = 51.31, ["Neon|Ride"] = 77.16, ["Neon|Fly|Ride"] = 185.99, ["Mega"] = 478.87, ["Mega|Ride"] = 441.61}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 83.64, ["Ride"] = 31.82, ["Fly|Ride"] = 162.08, ["Neon"] = 4.61, ["Neon|Ride"] = 25.87, ["Neon|Fly|Ride"] = 106.14, ["Mega"] = 52.5, ["Mega|Ride"] = 76.01, ["Mega|Fly|Ride"] = 177.08}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 25.98, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 287.12}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.39, ["Fly"] = 107.63, ["Ride"] = 68.84, ["Fly|Ride"] = 190.81, ["Neon"] = 120.7, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 185.95, ["Mega"] = 425.55, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.43, ["Neon"] = 80.22, ["Neon|Ride"] = 123.11, ["Neon|Fly|Ride"] = 820.32, ["Mega"] = 473.73, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 1094.09}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.94, ["Ride"] = 31.38, ["Fly|Ride"] = 410.31, ["Neon"] = 310.44, ["Neon|Ride"] = 175.56, ["Mega"] = 635.7, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 18.83, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 182.43, ["Neon|Fly|Ride"] = 198.94, ["Mega"] = 610.32, ["Mega|Ride"] = 646.42, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 353.07, ["Ride"] = 410.8, ["Fly|Ride"] = 748.73, ["Neon"] = 1025.77, ["Neon|Ride"] = 1085.89, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.11, ["Fly"] = 69.65, ["Ride"] = 20.79, ["Fly|Ride"] = 236.25, ["Neon"] = 119.67, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 193.23, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 843.9}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.1, ["Fly|Ride"] = 127.32, ["Neon"] = 38.87, ["Neon|Ride"] = 105, ["Mega"] = 217.4, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.32, ["Ride"] = 70.88, ["Fly|Ride"] = 256.95, ["Neon"] = 85.32, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 272.35, ["Mega|Fly"] = 683.93, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 137.47, ["Neon"] = 9.2, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 47.79, ["Mega|Ride"] = 102.54, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 62.79, ["Ride"] = 72.82, ["Neon"] = 313.9, ["Neon|Ride"] = 348.77, ["Mega"] = 1504.22, ["Mega|Ride"] = 1353.5, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.4, ["Ride"] = 25.16, ["Fly|Ride"] = 60.36, ["Neon"] = 9.09, ["Neon|Fly"] = 178.5, ["Neon|Ride"] = 63.61, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 68.25, ["Mega|Ride"] = 108.39, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 36.04, ["Ride"] = 27.97, ["Fly|Ride"] = 152.81, ["Neon"] = 3.84, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 42.79, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 32.7, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.4, ["Mega|Fly|Ride"] = 155.74}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 31.39, ["Fly|Ride"] = 123.24, ["Neon"] = 15.41, ["Neon|Ride"] = 59.4, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 111.03, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 97.59, ["Fly"] = 93.03, ["Ride"] = 65.63, ["Fly|Ride"] = 194.11, ["Neon"] = 291.38, ["Neon|Ride"] = 291.43, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 252, ["Ride"] = 269.16, ["Fly|Ride"] = 411.76, ["Neon"] = 1425.81, ["Neon|Ride"] = 1139.14, ["Neon|Fly|Ride"] = 1278.36, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 4045.13}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.32, ["Neon"] = 40.07, ["Mega"] = 99.75, ["Mega|Ride"] = 213.99}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 68.77, ["Ride"] = 27.57, ["Neon"] = 7.76, ["Neon|Ride"] = 44, ["Neon|Fly|Ride"] = 178.43, ["Mega"] = 59.07, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.37, ["Mega|Fly|Ride"] = 343.52}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.13, ["Fly"] = 155.57, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Neon|Ride"] = 68.74, ["Mega"] = 206.73, ["Mega|Ride"] = 348.23, ["Mega|Fly|Ride"] = 388.16}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.51, ["Fly"] = 67.23, ["Ride"] = 63.61, ["Neon"] = 10.49, ["Neon|Ride"] = 34.95, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 114.17, ["Mega|Ride"] = 125.89, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.28, ["Neon"] = 7.8, ["Mega"] = 39.29, ["Mega|Fly|Ride"] = 270.71}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 3.9, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 452.82, ["Mega"] = 39.3, ["Mega|Ride"] = 99.95, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.52, ["Ride"] = 24.93, ["Fly|Ride"] = 59.77, ["Neon"] = 16.54, ["Neon|Fly"] = 63.67, ["Neon|Ride"] = 27.71, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 113.82, ["Mega|Ride"] = 231.75, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 138.54, ["Ride"] = 115.5, ["Fly|Ride"] = 77.15, ["Neon"] = 137.69, ["Neon|Ride"] = 151.82, ["Neon|Fly|Ride"] = 260.46, ["Mega"] = 1127.93, ["Mega|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 73.32, ["Fly"] = 123.15, ["Ride"] = 100.53, ["Fly|Ride"] = 117.47, ["Neon"] = 439.69, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 439, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1470}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.87, ["Fly|Ride"] = 131.25, ["Neon"] = 3.44, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 49.23, ["Mega|Fly"] = 672, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 11.3, ["Ride"] = 15.74, ["Fly|Ride"] = 39.37, ["Neon"] = 3.84, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.75, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 61.43, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 6.24, ["Fly"] = 41.06, ["Ride"] = 73.48, ["Neon"] = 51.17, ["Neon|Ride"] = 69.77, ["Neon|Fly|Ride"] = 272.76, ["Mega"] = 527.63, ["Mega|Ride"] = 478.87, ["Mega|Fly|Ride"] = 636.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 232.32, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 492.19, ["Neon"] = 4103.03, ["Neon|Ride"] = 1916.12, ["Mega|Fly|Ride"] = 7177.59}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 23.23, ["Fly"] = 101.33, ["Ride"] = 39.38, ["Fly|Ride"] = 84.72, ["Neon"] = 178.5, ["Neon|Ride"] = 196.62, ["Neon|Fly|Ride"] = 291.38, ["Mega|Ride"] = 1131.92, ["Mega|Fly|Ride"] = 958.74}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 34.9, ["Fly|Ride"] = 281.29, ["Neon"] = 9.19, ["Neon|Ride"] = 47.39, ["Neon|Fly|Ride"] = 169.31, ["Mega"] = 86.35, ["Mega|Ride"] = 147.82, ["Mega|Fly|Ride"] = 261.76}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.52, ["Fly"] = 205.16, ["Ride"] = 26.25, ["Fly|Ride"] = 142.7, ["Neon"] = 16.31, ["Mega|Ride"] = 396.83}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 34.91, ["Fly"] = 162.6, ["Ride"] = 43.49, ["Fly|Ride"] = 102.59, ["Neon|Ride"] = 347.82, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2460.89, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1348.37}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.93, ["Ride"] = 105, ["Fly|Ride"] = 179.51, ["Neon"] = 434.43, ["Neon|Fly|Ride"] = 464.86, ["Mega"] = 8202.95, ["Mega|Fly|Ride"] = 2044.6}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 196.86, ["Fly"] = 278.96, ["Ride"] = 196.87, ["Fly|Ride"] = 701.63, ["Neon"] = 1050, ["Neon|Ride"] = 889.34, ["Neon|Fly|Ride"] = 929.72, ["Mega|Fly|Ride"] = 4641.86}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 11.46, ["Fly"] = 51.19, ["Ride"] = 43.67, ["Fly|Ride"] = 150.94, ["Neon"] = 82.69, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 388.49, ["Mega|Ride"] = 400.21, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 18.38, ["Fly|Ride"] = 41.9, ["Neon"] = 10.27, ["Neon|Ride"] = 22.86, ["Neon|Fly|Ride"] = 91.11, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.15, ["Fly"] = 38.43, ["Ride"] = 16.01, ["Fly|Ride"] = 43.24, ["Neon"] = 42, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 92.99, ["Mega"] = 358.89, ["Mega|Ride"] = 328.14, ["Mega|Fly|Ride"] = 352.74}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.94, ["Fly"] = 479.21, ["Ride"] = 301.88, ["Fly|Ride"] = 606.23, ["Neon|Ride"] = 2461.82, ["Neon|Fly|Ride"] = 1781.07, ["Mega"] = 9843.54, ["Mega|Fly|Ride"] = 5081.32}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.53, ["Neon"] = 10.17, ["Neon|Ride"] = 68.74, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 262.5, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.92, ["Ride"] = 15.74, ["Fly|Ride"] = 40.92, ["Neon"] = 26.23, ["Neon|Fly"] = 69.77, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 203.04, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 244.06}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 15.52, ["Ride"] = 135.7, ["Neon"] = 271.84, ["Neon|Fly"] = 410.31, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 295.19, ["Mega"] = 527.69, ["Mega|Ride"] = 609.09, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 137.52, ["Fly"] = 157.5, ["Ride"] = 109.71, ["Fly|Ride"] = 127.32, ["Neon"] = 634.96, ["Neon|Ride"] = 697.58, ["Neon|Fly|Ride"] = 572.25, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 20.99, ["Fly"] = 43.29, ["Ride"] = 27.91, ["Fly|Ride"] = 63.4, ["Neon"] = 96.44, ["Neon|Ride"] = 102.59, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 682.91, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 534.51}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 683.93, ["Mega"] = 20.27, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.64, ["Fly|Ride"] = 72.19, ["Neon"] = 2.1, ["Neon|Ride"] = 19.51, ["Neon|Fly|Ride"] = 71.81, ["Mega"] = 23.55, ["Mega|Fly"] = 83.25, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 123.05}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.9, ["Fly"] = 410.31, ["Ride"] = 79.94, ["Fly|Ride"] = 129.29, ["Neon"] = 35.17, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 185.95, ["Mega"] = 154.88, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1418.79, ["Fly"] = 1604.63, ["Ride"] = 1271.82, ["Fly|Ride"] = 1364.99, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12475.32}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 545.74, ["Fly|Ride"] = 607.28, ["Neon"] = 2408.47, ["Neon|Ride"] = 2005.4, ["Neon|Fly|Ride"] = 2050.76, ["Mega"] = 16405.9, ["Mega|Fly|Ride"] = 9297.02}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 341.25, ["Ride"] = 383.24, ["Fly|Ride"] = 492.38, ["Neon"] = 779.59, ["Neon|Ride"] = 775.46, ["Neon|Fly|Ride"] = 786.18, ["Mega|Fly|Ride"] = 2362.4}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 293.99, ["Fly"] = 410.86, ["Ride"] = 351.79, ["Fly|Ride"] = 451.86, ["Neon"] = 925.32, ["Neon|Fly"] = 1368.38, ["Neon|Ride"] = 1093.46, ["Neon|Fly|Ride"] = 1137.74, ["Mega|Fly|Ride"] = 4610.07}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15, ["Fly|Ride"] = 33.68, ["Neon"] = 5.97, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 92.3, ["Mega|Ride"] = 135.36, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 357, ["Fly"] = 1368.88, ["Ride"] = 410.31, ["Fly|Ride"] = 549.94, ["Neon"] = 1340.68, ["Neon|Ride"] = 1281.63, ["Neon|Fly|Ride"] = 1381.19, ["Mega|Ride"] = 6562.38, ["Mega|Fly|Ride"] = 4787.41}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.45, ["Fly"] = 183.75, ["Ride"] = 88.24, ["Neon"] = 15.33, ["Neon|Ride"] = 48.29, ["Neon|Fly|Ride"] = 208.67, ["Mega"] = 84, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 369.14}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.36, ["Fly|Ride"] = 31.01, ["Neon"] = 7.87, ["Neon|Ride"] = 27.72, ["Neon|Fly|Ride"] = 110.42, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 39.37, ["Mega"] = 28.56, ["Mega|Ride"] = 173.78}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 37.23, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 656.25, ["Mega|Ride"] = 929.72, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7752.1, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 32.82, ["Mega"] = 328.13, ["Mega|Ride"] = 423.03, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.96, ["Neon|Ride"] = 38.8, ["Neon|Fly|Ride"] = 116.91, ["Mega"] = 20.52, ["Mega|Ride"] = 90.2, ["Mega|Fly|Ride"] = 121.02}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.66, ["Fly"] = 36.01, ["Ride"] = 20.52, ["Fly|Ride"] = 67.1, ["Neon"] = 9.19, ["Neon|Fly"] = 96.44, ["Neon|Ride"] = 40.01, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 110.97, ["Mega|Fly"] = 171.26, ["Mega|Ride"] = 118.97, ["Mega|Fly|Ride"] = 184.71}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.1, ["Fly"] = 55.42, ["Ride"] = 15.41, ["Fly|Ride"] = 51.97, ["Neon"] = 19.69, ["Neon|Fly"] = 116.95, ["Neon|Ride"] = 155.74, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 326.08}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 12.78, ["Ride"] = 39.38, ["Neon"] = 62.75, ["Mega"] = 504.38, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6199.3, ["Ride"] = 41.04, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 439.03, ["Mega|Ride"] = 714, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.49, ["Ride"] = 18.38, ["Fly|Ride"] = 45.94, ["Neon"] = 6.16, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 59.49, ["Mega"] = 58.47, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 152.4, ["Ride"] = 178.5, ["Fly|Ride"] = 209.99, ["Neon"] = 1686.78, ["Neon|Ride"] = 946.38, ["Neon|Fly|Ride"] = 1007.57, ["Mega"] = 8202.95, ["Mega|Ride"] = 4101.49, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.86, ["Ride"] = 14.94, ["Fly|Ride"] = 34.96, ["Neon"] = 4.11, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 53.8, ["Mega"] = 36.66, ["Mega|Ride"] = 52.64, ["Mega|Fly|Ride"] = 121.79}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 136.17, ["Fly"] = 137.47, ["Ride"] = 68.74, ["Fly|Ride"] = 160.12, ["Neon"] = 164.13, ["Neon|Ride"] = 151.82, ["Mega"] = 312.38, ["Mega|Ride"] = 464.86, ["Mega|Fly|Ride"] = 1025.38}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.24, ["Ride"] = 205.16, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 410.17, ["Mega"] = 786.19, ["Mega|Ride"] = 906.47}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.75, ["Ride"] = 253.21, ["Fly|Ride"] = 310.28, ["Neon"] = 708.74, ["Neon|Ride"] = 841.13, ["Neon|Fly|Ride"] = 912.99, ["Mega|Fly|Ride"] = 3335.47}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 15.74, ["Fly"] = 168.88, ["Fly|Ride"] = 139.49, ["Neon"] = 155.8, ["Neon|Ride"] = 145.34, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.54, ["Ride"] = 137.47, ["Fly|Ride"] = 615.47, ["Neon"] = 89.25, ["Neon|Ride"] = 199.5, ["Mega"] = 771.75, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1050, ["Fly"] = 1439.69, ["Ride"] = 1050, ["Fly|Ride"] = 1154.99, ["Neon"] = 4650.78, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4511.64, ["Mega|Fly|Ride"] = 17876.29}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.76, ["Fly"] = 19.58, ["Ride"] = 19.51, ["Fly|Ride"] = 52.5, ["Neon"] = 26.24, ["Neon|Fly"] = 84.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 82.05, ["Mega"] = 232.44, ["Mega|Fly|Ride"] = 345.19}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 5.03, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 35.2, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 585.51}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.09, ["Ride"] = 27.3, ["Fly|Ride"] = 69.57, ["Neon"] = 46.52, ["Neon|Ride"] = 30.3, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 91.88, ["Mega|Ride"] = 189.57, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.44, ["Fly"] = 34.89, ["Ride"] = 36.96, ["Fly|Ride"] = 80.27, ["Neon"] = 69.57, ["Neon|Ride"] = 77.04, ["Neon|Fly|Ride"] = 105, ["Mega"] = 342.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.74}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.62, ["Fly"] = 20.53, ["Ride"] = 17.74, ["Fly|Ride"] = 40.84, ["Neon"] = 24.63, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 36.94, ["Neon|Fly|Ride"] = 93.17, ["Mega|Ride"] = 310.3, ["Mega|Fly|Ride"] = 254.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 101.35, ["Neon"] = 8.22, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 54.32, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 131.15, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 208.69, ["Fly"] = 260.65, ["Ride"] = 229.69, ["Fly|Ride"] = 342.61, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 27.71, ["Fly|Ride"] = 72.19, ["Neon"] = 7.87, ["Neon|Fly"] = 82.07, ["Neon|Ride"] = 27.08, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 84, ["Mega|Fly"] = 410.17, ["Mega|Ride"] = 127.36, ["Mega|Fly|Ride"] = 258.4}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 244.06, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.78, ["Fly"] = 96.95, ["Ride"] = 26.23, ["Neon"] = 12.75, ["Neon|Ride"] = 1368.38, ["Mega"] = 94.5, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 410.01}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 388.5, ["Ride"] = 820.61, ["Fly|Ride"] = 697.58, ["Neon"] = 1050, ["Neon|Fly"] = 1230.92, ["Neon|Ride"] = 1163.22, ["Mega"] = 4648.51, ["Mega|Ride"] = 3409.69, ["Mega|Fly|Ride"] = 2875.69}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.34, ["Fly"] = 116.29, ["Ride"] = 55.41, ["Fly|Ride"] = 187.72, ["Neon"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 620.6, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 18.16, ["Fly"] = 74.41, ["Ride"] = 36.66, ["Fly|Ride"] = 98.43, ["Neon"] = 97.67, ["Neon|Ride"] = 142.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 548.02, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 670.61}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.07, ["Neon"] = 3.59, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.24, ["Mega"] = 45.92, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.85}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 58.33, ["Fly"] = 5813.78, ["Ride"] = 95.71, ["Fly|Ride"] = 170.63, ["Neon"] = 196.88, ["Neon|Fly"] = 245.85, ["Neon|Ride"] = 294.16, ["Neon|Fly|Ride"] = 343.18, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.03, ["Fly|Ride"] = 52.5, ["Neon"] = 6.46, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 52.41, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 22.39, ["Fly"] = 102.59, ["Ride"] = 28.61, ["Fly|Ride"] = 83.72, ["Neon"] = 66.2, ["Neon|Ride"] = 155.67, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 409.14, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.27, ["Fly"] = 82.1, ["Ride"] = 79.71, ["Fly|Ride"] = 158.95, ["Neon"] = 313.9, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 369.56, ["Mega"] = 1230.45, ["Mega|Ride"] = 3419.61, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 13.02, ["Ride"] = 13.85, ["Fly|Ride"] = 30.54, ["Neon"] = 2.1, ["Neon|Fly"] = 23.61, ["Neon|Ride"] = 17.48, ["Neon|Fly|Ride"] = 30.18, ["Mega"] = 14.98, ["Mega|Fly"] = 116.23, ["Mega|Ride"] = 27.69, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.21, ["Fly"] = 32.82, ["Ride"] = 39.29, ["Fly|Ride"] = 129.26, ["Neon"] = 16.96, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 129.94, ["Mega|Ride"] = 271.85, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 15.07, ["Ride"] = 46.64, ["Fly|Ride"] = 112.88, ["Neon"] = 102.59, ["Neon|Ride"] = 139.53, ["Mega"] = 1025.38, ["Mega|Ride"] = 550.86}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 13.08, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 19.36, ["Mega|Ride"] = 79.23, ["Mega|Fly|Ride"] = 209.19}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 13.08, ["Fly"] = 210, ["Ride"] = 58.7, ["Fly|Ride"] = 164.07, ["Neon"] = 65.51, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 503.58, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 391.13, ["Mega|Fly|Ride"] = 609.09}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 10.84, ["Fly"] = 103.69, ["Ride"] = 26.25, ["Fly|Ride"] = 98.43, ["Neon"] = 430.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 172.01, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 463.71}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.81, ["Ride"] = 18.86, ["Neon"] = 26.16, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.43, ["Mega"] = 231, ["Mega|Ride"] = 216.86, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 45.94, ["Fly"] = 2052.29, ["Fly|Ride"] = 248.49, ["Neon"] = 143.99, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 6197.62, ["Mega|Ride"] = 568.07, ["Mega|Fly|Ride"] = 473.75}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 145.68, ["Fly|Ride"] = 196.88, ["Neon"] = 13.01, ["Neon|Fly"] = 55.41, ["Neon|Ride"] = 32.43, ["Mega"] = 68.16, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 151.77}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 55.53, ["Neon"] = 3.83, ["Neon|Ride"] = 100.53, ["Mega"] = 31.49, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 266.61}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 77.95}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42, ["Fly"] = 78.75, ["Ride"] = 53.48, ["Neon|Ride"] = 263.7, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1230.45, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 30.19, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 307.62}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 417.38, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2047.42, ["Neon|Ride"] = 1860.17, ["Mega"] = 16405.9, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.46, ["Fly"] = 26.17, ["Ride"] = 24.19, ["Fly|Ride"] = 66.26, ["Neon"] = 27.42, ["Neon|Ride"] = 273.9, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 87.71, ["Mega|Fly"] = 153.82, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.94, ["Fly"] = 95.55, ["Ride"] = 19.69, ["Fly|Ride"] = 68.25, ["Neon"] = 18.4, ["Neon|Ride"] = 35.91, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 345.19, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 17.48, ["Fly"] = 76.95, ["Ride"] = 64.63, ["Fly|Ride"] = 106.32, ["Neon"] = 126, ["Neon|Ride"] = 171.32, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 803.91, ["Mega|Ride"] = 620.6, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.18, ["Fly"] = 410.47, ["Ride"] = 38.07, ["Fly|Ride"] = 721.88, ["Neon"] = 30.38, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.55, ["Fly"] = 139.53, ["Ride"] = 137.47, ["Fly|Ride"] = 157.5, ["Neon"] = 102.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 359.28, ["Mega"] = 375.62, ["Mega|Ride"] = 388.16, ["Mega|Fly|Ride"] = 682.91}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.04, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 32.9, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 216.57, ["Mega|Fly"] = 547.56, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 338.26}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 46.51, ["Ride"] = 11.23, ["Fly|Ride"] = 68.25, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 13.64, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 14.86, ["Mega|Fly"] = 32.21, ["Mega|Ride"] = 24.62, ["Mega|Fly|Ride"] = 109.1}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 11.8, ["Fly"] = 109.77, ["Ride"] = 27.71, ["Fly|Ride"] = 102.59, ["Neon"] = 22.34, ["Neon|Fly"] = 116.28, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.55, ["Mega"] = 183.75, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 294.73, ["Fly"] = 342.75, ["Ride"] = 350.44, ["Fly|Ride"] = 421.32, ["Neon"] = 1240.51, ["Neon|Ride"] = 1368.38, ["Neon|Fly|Ride"] = 1252.12, ["Mega"] = 4374.57, ["Mega|Ride"] = 5024.32, ["Mega|Fly|Ride"] = 4507.54}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 103.14, ["Ride"] = 137.16, ["Fly|Ride"] = 295.32, ["Neon"] = 315, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 543.27, ["Mega"] = 2188.15, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1514.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14.34, ["Fly|Ride"] = 40.84, ["Neon"] = 7.88, ["Neon|Fly"] = 68.74, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 63.31, ["Mega"] = 13.13, ["Mega|Fly"] = 204.06, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.04, ["Ride"] = 15.41, ["Fly|Ride"] = 31.5, ["Neon"] = 6.45, ["Neon|Fly"] = 51.31, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 59.13, ["Mega"] = 68.72, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 116.23, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 98.44, ["Neon"] = 39.38, ["Mega"] = 205.09, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 236.23, ["Fly"] = 420, ["Ride"] = 249.38, ["Fly|Ride"] = 375.38, ["Neon"] = 1327.34, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1983.08, ["Mega|Ride"] = 8202.95, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.7, ["Fly"] = 14.44, ["Ride"] = 13.65, ["Fly|Ride"] = 32.66, ["Neon"] = 19.69, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 124.36, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.55, ["Fly"] = 310.47, ["Ride"] = 82.07, ["Fly|Ride"] = 205.16, ["Neon"] = 40.85, ["Neon|Ride"] = 410.31, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 253.32, ["Mega|Ride"] = 287.43, ["Mega|Fly|Ride"] = 413.22}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.71, ["Neon"] = 5.03, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 202.16}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 14, ["Fly"] = 24.64, ["Ride"] = 22.58, ["Fly|Ride"] = 74.79, ["Neon"] = 79.7, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 189.45, ["Mega"] = 575.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 42, ["Ride"] = 107.62, ["Fly|Ride"] = 209.99, ["Neon"] = 210, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 257.25, ["Neon|Fly|Ride"] = 336, ["Mega"] = 680.86, ["Mega|Fly"] = 2153.28, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 848.01}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.36, ["Ride"] = 40.13, ["Fly|Ride"] = 96.44, ["Neon"] = 262.5, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 205.09, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 840.16, ["Mega|Fly|Ride"] = 754.68}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.25, ["Ride"] = 14.6, ["Fly|Ride"] = 34.9, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 18.12, ["Neon|Fly|Ride"] = 45.66, ["Mega"] = 27.69, ["Mega|Fly"] = 34.89, ["Mega|Ride"] = 39.69, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 262.49, ["Ride"] = 270.12, ["Fly|Ride"] = 317.52, ["Neon"] = 721.88, ["Neon|Ride"] = 1085.89, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 4648.51}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 104.98, ["Fly"] = 101.18, ["Ride"] = 47.25, ["Fly|Ride"] = 105, ["Neon"] = 151.82, ["Neon|Ride"] = 185.9, ["Neon|Fly|Ride"] = 328.13}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 15.6, ["Fly|Ride"] = 44.19, ["Neon"] = 5.91, ["Neon|Fly"] = 34.27, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 60.52, ["Mega|Fly"] = 273.78, ["Mega|Ride"] = 62.77, ["Mega|Fly|Ride"] = 291.71}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.79, ["Ride"] = 19.51, ["Fly|Ride"] = 39.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 124.36, ["Mega"] = 28.76, ["Mega|Fly"] = 137.41, ["Mega|Ride"] = 61.53, ["Mega|Fly|Ride"] = 153.82}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.73, ["Fly|Ride"] = 69.29, ["Neon"] = 11.23, ["Neon|Fly"] = 697.58, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 127.98, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 30.21, ["Fly"] = 38.07, ["Ride"] = 28.18, ["Fly|Ride"] = 64.14, ["Neon"] = 57.81, ["Neon|Fly"] = 260.55, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 304.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.07, ["Ride"] = 55.09, ["Neon"] = 59.31, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 441.95}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 43.3, ["Fly|Ride"] = 273.9, ["Neon"] = 2.1, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 30.35, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.72, ["Fly"] = 96.48, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 31.8, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 72.62, ["Neon|Fly|Ride"] = 154.63, ["Mega"] = 199.37, ["Mega|Ride"] = 158.24, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.74, ["Ride"] = 191.79, ["Neon"] = 3.93, ["Neon|Fly"] = 109.77, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.19, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 123.05}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 39.23, ["Ride"] = 15.65, ["Fly|Ride"] = 68.62, ["Neon"] = 4.81, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 52.4, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 721.86, ["Ride"] = 689.07, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3150, ["Neon|Fly|Ride"] = 3248.38, ["Mega|Fly|Ride"] = 17499.97}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.48, ["Ride"] = 13.68, ["Fly|Ride"] = 27.6, ["Neon"] = 11.71, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 27.87, ["Neon|Fly|Ride"] = 45.93, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 210, ["Neon"] = 9.56, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 95.5, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 328.14}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.38, ["Fly"] = 30.23, ["Ride"] = 20.51, ["Fly|Ride"] = 57.66, ["Neon"] = 65.52, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 69.92, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 683.93, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 372.92}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 17.48, ["Ride"] = 15.19, ["Fly|Ride"] = 35.42, ["Neon"] = 6.41, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 63.36, ["Mega"] = 65.62, ["Mega|Ride"] = 83.73, ["Mega|Fly|Ride"] = 174.51}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 31.56, ["Ride"] = 47.2, ["Fly|Ride"] = 272.87, ["Neon"] = 116.82, ["Neon|Ride"] = 256.46, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1162.79}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.79, ["Fly|Ride"] = 63.95, ["Neon"] = 7.44, ["Neon|Fly"] = 132.56, ["Neon|Ride"] = 31.2, ["Neon|Fly|Ride"] = 104.52, ["Mega"] = 117.11, ["Mega|Ride"] = 111.97, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.62, ["Ride"] = 15.75, ["Fly|Ride"] = 65.63, ["Neon"] = 15.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 262.5, ["Mega|Ride"] = 198.58, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.37, ["Mega"] = 91.83, ["Mega|Ride"] = 172.01, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Neon"] = 3.67, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 44.01, ["Mega|Fly"] = 287.12, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 184.57}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.21, ["Fly"] = 18.03, ["Ride"] = 20.9, ["Fly|Ride"] = 39, ["Neon"] = 309.74, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 820.32, ["Mega|Ride"] = 464.86, ["Mega|Fly|Ride"] = 439.21}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 840, ["Ride"] = 917.44, ["Fly|Ride"] = 1094.48, ["Neon"] = 2106.91, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 2095.42, ["Mega"] = 8202.95, ["Mega|Ride"] = 6373, ["Mega|Fly|Ride"] = 7109.91}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 14.89, ["Fly|Ride"] = 32.74, ["Neon"] = 3.85, ["Neon|Fly"] = 23.22, ["Neon|Ride"] = 20.51, ["Neon|Fly|Ride"] = 68.19, ["Mega|Ride"] = 68.61, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 9.19, ["Ride"] = 137.47, ["Fly|Ride"] = 116.28, ["Neon"] = 43.31, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 383.5, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 478.87}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 63, ["Ride"] = 85.32, ["Fly|Ride"] = 105, ["Neon|Ride"] = 389.81, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3144.82, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.25, ["Ride"] = 46.28, ["Fly|Ride"] = 102.79, ["Neon"] = 183.75, ["Neon|Ride"] = 188.75, ["Mega"] = 926.94, ["Mega|Ride"] = 669.38, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.09, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 55.41, ["Neon|Ride"] = 115.77, ["Neon|Fly|Ride"] = 121.47, ["Mega"] = 410.17, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.9, ["Ride"] = 63.51, ["Neon"] = 105, ["Neon|Ride"] = 78.75, ["Mega"] = 263.82, ["Mega|Fly"] = 504.38, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.18, ["Fly"] = 126.89, ["Ride"] = 28.61, ["Neon"] = 273.9, ["Neon|Ride"] = 306.71, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 557.81}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 6.8}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.28, ["Fly"] = 131248.69, ["Ride"] = 26.69, ["Fly|Ride"] = 78.75, ["Neon"] = 32.82, ["Neon|Ride"] = 72.93, ["Neon|Fly|Ride"] = 168.18, ["Mega"] = 164.08, ["Mega|Fly"] = 463.49, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 3.93, ["Neon"] = 80.33, ["Mega"] = 868.11}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.07, ["Fly"] = 410.47, ["Ride"] = 104.89, ["Fly|Ride"] = 111.59, ["Neon"] = 273, ["Neon|Ride"] = 328.26, ["Neon|Fly|Ride"] = 278.93, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 788.82}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.1, ["Fly"] = 15.21, ["Ride"] = 15.05, ["Fly|Ride"] = 45.14, ["Neon"] = 27.35, ["Neon|Fly"] = 63, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 71.95, ["Mega|Fly"] = 409.14, ["Mega|Ride"] = 195.46, ["Mega|Fly|Ride"] = 203.34}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.75, ["Fly"] = 145.73, ["Ride"] = 34.9, ["Fly|Ride"] = 196.96, ["Neon"] = 23.35, ["Neon|Ride"] = 55.38, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 129.93, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.98, ["Mega"] = 48.56, ["Mega|Ride"] = 137.48, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 34.13, ["Fly"] = 65.63, ["Ride"] = 48.22, ["Fly|Ride"] = 94.46, ["Neon"] = 196.88, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 1094.09, ["Mega|Ride"] = 820.32, ["Mega|Fly|Ride"] = 777}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 38.56, ["Fly|Ride"] = 65.54, ["Neon"] = 3.89, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.26, ["Mega"] = 74.72, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 15.37, ["Ride"] = 60.8, ["Fly|Ride"] = 272.87, ["Neon"] = 145.69, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 656.25, ["Mega|Ride"] = 616.88, ["Mega|Fly|Ride"] = 670.61}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 15.65, ["Fly|Ride"] = 40.11, ["Neon"] = 13.02, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 65.61, ["Mega"] = 170.63, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 18.59, ["Neon"] = 35.44, ["Neon|Ride"] = 410.31, ["Mega"] = 383.5, ["Mega|Ride"] = 396.83, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.46, ["Ride"] = 62.77, ["Fly|Ride"] = 131.25, ["Neon"] = 38.75, ["Neon|Ride"] = 155.8, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.56, ["Ride"] = 129.26, ["Neon"] = 269.07, ["Neon|Fly|Ride"] = 639.84, ["Mega"] = 1486.8, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 17.01, ["Ride"] = 109.77, ["Neon"] = 99.02, ["Neon|Ride"] = 410.31, ["Mega"] = 408.11, ["Mega|Ride"] = 355.83, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.01, ["Ride"] = 105, ["Neon"] = 162.73, ["Neon|Fly"] = 205.16, ["Mega"] = 273.78, ["Mega|Ride"] = 1551.45, ["Mega|Fly|Ride"] = 1640.61}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.53, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 820.32, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 20.52, ["Neon|Ride"] = 273.9, ["Mega"] = 118.13, ["Mega|Fly|Ride"] = 310.3}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.41, ["Ride"] = 17.91, ["Fly|Ride"] = 60.61, ["Neon"] = 2.1, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 79.04, ["Mega|Ride"] = 86.01, ["Mega|Fly|Ride"] = 198.94}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 7.86, ["Fly"] = 50.18, ["Ride"] = 288.64, ["Fly|Ride"] = 77.9, ["Neon"] = 18.77, ["Neon|Ride"] = 41.55, ["Neon|Fly|Ride"] = 163.96, ["Mega"] = 109.31, ["Mega|Fly|Ride"] = 388.16}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 19.48, ["Fly|Ride"] = 55.95, ["Neon"] = 5.19, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 22.78, ["Neon|Fly|Ride"] = 69.06, ["Mega"] = 45.93, ["Mega|Ride"] = 74.11, ["Mega|Fly|Ride"] = 277.3}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 26.69, ["Fly|Ride"] = 118.13, ["Neon"] = 32.81, ["Neon|Ride"] = 96.44, ["Neon|Fly|Ride"] = 254.3, ["Mega"] = 246.16, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.88, ["Fly"] = 65.63, ["Ride"] = 22.32, ["Fly|Ride"] = 103.69, ["Neon"] = 27.71, ["Neon|Fly"] = 465.05, ["Neon|Ride"] = 82.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.83, ["Fly"] = 26.17, ["Ride"] = 20.93, ["Fly|Ride"] = 45.68, ["Neon"] = 26.23, ["Neon|Fly"] = 54.66, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 92.98, ["Mega"] = 208.25, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 15.64, ["Fly|Ride"] = 45.8, ["Neon|Fly"] = 82.07, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 183.57, ["Mega"] = 170.63, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 246.09}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.65, ["Fly"] = 57.66, ["Ride"] = 41.04, ["Neon"] = 14.6, ["Neon|Fly"] = 408.7, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 142.21, ["Mega"] = 94.5, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 145.59, ["Mega|Fly|Ride"] = 263.57}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.38, ["Fly"] = 205.25, ["Ride"] = 98.43, ["Fly|Ride"] = 286.2, ["Neon"] = 124.68, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 525, ["Mega|Fly"] = 711.62, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 733.89}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.13, ["Ride"] = 94.74, ["Fly|Ride"] = 217.88, ["Neon"] = 291.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1312.5, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1216.53}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 19.5, ["Fly|Ride"] = 54.45, ["Neon"] = 2.1, ["Neon|Ride"] = 41.04, ["Mega"] = 25.73, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 165.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 27.54, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.75, ["Ride"] = 97.13, ["Neon"] = 246.2, ["Neon|Ride"] = 302.6, ["Mega|Ride"] = 1203.8, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.24, ["Fly"] = 190.32, ["Ride"] = 33.29, ["Fly|Ride"] = 126, ["Neon"] = 40.69, ["Neon|Ride"] = 82.07, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 172.91, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.5}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.82, ["Ride"] = 123.11, ["Fly|Ride"] = 137.47, ["Neon"] = 8.09, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 63, ["Mega"] = 64.83, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 317.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 15.56, ["Fly|Ride"] = 45.03, ["Neon"] = 14.2, ["Neon|Ride"] = 27.2, ["Neon|Fly|Ride"] = 105.63, ["Mega"] = 151.77, ["Mega|Fly"] = 342.49, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 15.66, ["Fly|Ride"] = 40.74, ["Neon"] = 2.1, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 30.23, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 83.87, ["Neon"] = 5.04, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 40.27, ["Mega|Fly"] = 168, ["Mega|Ride"] = 67.07, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.47, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 19.49, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 310.7}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 2.58, ["Ride"] = 104.98, ["Neon"] = 27.46, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 615.23, ["Mega"] = 213.94, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 14.96, ["Ride"] = 30.18, ["Fly|Ride"] = 202.98, ["Neon"] = 45.54, ["Neon|Ride"] = 202.32, ["Neon|Fly|Ride"] = 137.41, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.17, ["Fly"] = 22.61, ["Ride"] = 25.58, ["Fly|Ride"] = 41.09, ["Neon"] = 39.29, ["Neon|Fly"] = 68.74, ["Neon|Ride"] = 41.04, ["Neon|Fly|Ride"] = 91.88, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 360.38}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.57, ["Ride"] = 45.93, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 597.19, ["Mega|Fly|Ride"] = 1782.72}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.42, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 282.19, ["Neon|Fly|Ride"] = 630, ["Mega"] = 950.92, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 889.01}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.36, ["Fly|Ride"] = 38, ["Neon"] = 2.35, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 16.96, ["Neon|Fly|Ride"] = 48.2, ["Mega"] = 82.05, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 15.09, ["Fly|Ride"] = 39, ["Neon"] = 3.68, ["Neon|Fly"] = 22.47, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 44.63, ["Mega|Fly"] = 82.05, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 620.93, ["Ride"] = 534.18, ["Fly|Ride"] = 549.94, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 11.25, ["Ride"] = 65.63, ["Neon"] = 40.69, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 159.92, ["Mega"] = 364.88, ["Mega|Ride"] = 388.16, ["Mega|Fly|Ride"] = 996.19}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Ride"] = 15.27, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly"] = 26.69, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 140.76, ["Mega|Ride"] = 62.78, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 101.25, ["Ride"] = 93.18, ["Fly|Ride"] = 342.61, ["Neon"] = 260.78, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 449.13, ["Mega"] = 737.62, ["Mega|Ride"] = 917.44}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 16.68, ["Fly|Ride"] = 47.24, ["Neon"] = 8.78, ["Neon|Fly"] = 48.11, ["Neon|Ride"] = 24.21, ["Neon|Fly|Ride"] = 66.78, ["Mega"] = 91.88, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 236.2}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 68.74, ["Ride"] = 42.84, ["Neon"] = 2.1, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 18.6, ["Mega|Ride"] = 64.54, ["Mega|Fly|Ride"] = 190.76}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 42.41, ["Fly"] = 195.09, ["Ride"] = 86.35, ["Fly|Ride"] = 164.07, ["Neon"] = 169.32, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 328.14, ["Mega"] = 787.5, ["Mega|Ride"] = 630, ["Mega|Fly|Ride"] = 903.36}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 17.54, ["Fly|Ride"] = 52.5, ["Neon"] = 6.79, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 41.03, ["Mega|Ride"] = 178, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 33.77, ["Ride"] = 80.06, ["Fly|Ride"] = 137.47, ["Neon"] = 233.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1620.1, ["Mega|Ride"] = 1640.61, ["Mega|Fly|Ride"] = 1226.36}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 156.32, ["Fly|Ride"] = 155.93, ["Neon"] = 16.49, ["Neon|Ride"] = 273.9, ["Neon|Fly|Ride"] = 478.87, ["Mega"] = 104.99, ["Mega|Ride"] = 464.86, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 3.89, ["Fly"] = 68.74, ["Ride"] = 26.25, ["Fly|Ride"] = 65.66, ["Neon"] = 10.13, ["Neon|Ride"] = 41.04, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 121.02, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.01, ["Ride"] = 145.69, ["Fly|Ride"] = 213.63, ["Neon"] = 138.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 242.24, ["Ride"] = 32.82, ["Fly|Ride"] = 908.98, ["Neon"] = 4.86, ["Neon|Ride"] = 48.22, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 57.44, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 181.92}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 14.2, ["Ride"] = 17.45, ["Fly|Ride"] = 127.32, ["Neon"] = 10.48, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 116.23, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 11.12, ["Fly"] = 51.33, ["Ride"] = 32.24, ["Fly|Ride"] = 77.86, ["Neon"] = 77.9, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 430.5, ["Mega|Ride"] = 403.28, ["Mega|Fly|Ride"] = 393.72}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 22.58, ["Ride"] = 24.63, ["Fly|Ride"] = 82.05, ["Neon"] = 96.5, ["Neon|Fly"] = 137.47, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 233.8, ["Mega"] = 861.32, ["Mega|Ride"] = 415.17, ["Mega|Fly|Ride"] = 2050.76}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.6, ["Fly"] = 48.25, ["Ride"] = 28.25, ["Fly|Ride"] = 68.74, ["Neon"] = 82.07, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 123.05, ["Mega"] = 547.56, ["Mega|Ride"] = 310.3, ["Mega|Fly|Ride"] = 690.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 67.18, ["Fly"] = 135.19, ["Ride"] = 164.07, ["Fly|Ride"] = 223.13, ["Neon"] = 330.75, ["Neon|Ride"] = 497.61, ["Neon|Fly|Ride"] = 505.32, ["Mega"] = 1859.42, ["Mega|Ride"] = 1441.06, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 3.93, ["Fly"] = 137.47, ["Ride"] = 50.74, ["Fly|Ride"] = 307.74, ["Neon"] = 23.62, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.13, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 367.11}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.84, ["Ride"] = 26.57, ["Fly|Ride"] = 137.47, ["Neon"] = 21.17, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 137.45, ["Mega"] = 185.07, ["Mega|Ride"] = 191.96, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 12.8, ["Ride"] = 33.5, ["Fly|Ride"] = 160.13, ["Neon"] = 96.51, ["Neon|Ride"] = 262.49, ["Mega"] = 426.57, ["Mega|Ride"] = 478.87, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.41, ["Fly|Ride"] = 25.89, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 14.36, ["Mega|Fly"] = 65.64, ["Mega|Ride"] = 25.2, ["Mega|Fly|Ride"] = 91.94}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 48.65, ["Ride"] = 110.24, ["Fly|Ride"] = 273.9, ["Neon"] = 356.93, ["Neon|Fly"] = 2325.4, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1258.14, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.41, ["Fly|Ride"] = 112.22, ["Neon"] = 3.5, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 44.01, ["Mega|Ride"] = 75.28, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.71, ["Ride"] = 14.44, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Fly"] = 137.47, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 96.41, ["Mega"] = 260.46, ["Mega|Ride"] = 128.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.1, ["Ride"] = 129.46, ["Fly|Ride"] = 273.9, ["Neon"] = 303.74, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 478.87, ["Mega"] = 1286.25, ["Mega|Ride"] = 1367.85, ["Mega|Fly|Ride"] = 1233.74}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 23.67, ["Neon"] = 6.56, ["Neon|Ride"] = 58.49, ["Neon|Fly|Ride"] = 96.41, ["Mega"] = 109.74, ["Mega|Ride"] = 109.92, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 10.13}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 291.33, ["Neon"] = 6.06, ["Neon|Ride"] = 50.04, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 49.23, ["Mega|Ride"] = 112.73, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.56, ["Ride"] = 204.14, ["Fly|Ride"] = 262.5, ["Neon"] = 576.22, ["Neon|Ride"] = 643.16, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 2835}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.96, ["Ride"] = 39, ["Neon"] = 19.56, ["Neon|Ride"] = 55.79, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 173.15, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 81.81, ["Neon"] = 3.45, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 100.5, ["Mega|Fly|Ride"] = 137.41}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.94, ["Ride"] = 27.71, ["Neon"] = 46.54, ["Neon|Ride"] = 109.77, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 410.17, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 13.12, ["Fly"] = 25.47, ["Ride"] = 20.97, ["Fly|Ride"] = 54.66, ["Neon"] = 92.14, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 463.71}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.9, ["Ride"] = 60.29, ["Fly|Ride"] = 109.77, ["Neon"] = 170.63, ["Neon|Ride"] = 205.16, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 667.07, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 141.75, ["Fly"] = 210.98, ["Ride"] = 160.12, ["Fly|Ride"] = 256.5, ["Neon"] = 591.45, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 636.69, ["Mega|Fly|Ride"] = 2623.68}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.67, ["Fly"] = 130.75, ["Ride"] = 45.84, ["Fly|Ride"] = 83.7, ["Neon"] = 341.21, ["Neon|Fly"] = 6154.53, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 903.36, ["Mega|Ride"] = 765.96, ["Mega|Fly|Ride"] = 806.98}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.62, ["Fly"] = 131.23, ["Ride"] = 19.26, ["Fly|Ride"] = 65.62, ["Neon"] = 11.27, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 62.77, ["Mega"] = 137.41, ["Mega|Ride"] = 219.44, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 232.46, ["Ride"] = 32.45, ["Fly|Ride"] = 123.04, ["Neon"] = 131.25, ["Neon|Fly"] = 137.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 379.31, ["Mega|Ride"] = 431.82, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 51.06, ["Fly"] = 139.55, ["Ride"] = 88.27, ["Fly|Ride"] = 126.18, ["Neon"] = 287.22, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 408.02, ["Mega"] = 944.1, ["Mega|Ride"] = 1080.76, ["Mega|Fly|Ride"] = 1177.14}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.86, ["Ride"] = 127.35, ["Neon"] = 137.47, ["Neon|Ride"] = 245.17, ["Neon|Fly|Ride"] = 452.21, ["Mega"] = 683.82, ["Mega|Ride"] = 813.5, ["Mega|Fly|Ride"] = 922.84}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 315, ["Ride"] = 547.77, ["Neon|Ride"] = 3099.39, ["Neon|Fly|Ride"] = 2050.76}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 44.94, ["Ride"] = 96.44, ["Fly|Ride"] = 74.92, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 291.38, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 954.2}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 37.27, ["Ride"] = 15.41, ["Fly|Ride"] = 28.88, ["Neon"] = 2.1, ["Neon|Ride"] = 13.02, ["Neon|Fly|Ride"] = 68.72, ["Mega"] = 27.44, ["Mega|Fly"] = 102.55, ["Mega|Ride"] = 55.38, ["Mega|Fly|Ride"] = 112.87}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.45, ["Neon"] = 17.53, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 259.89, ["Mega"] = 143.83, ["Mega|Ride"] = 278.25, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.13, ["Ride"] = 29.76, ["Fly|Ride"] = 144.18, ["Neon"] = 16.91, ["Neon|Ride"] = 122.08, ["Neon|Fly|Ride"] = 957.71, ["Mega"] = 107.63, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 417.42, ["Ride"] = 458.07, ["Fly|Ride"] = 615.47, ["Neon"] = 1395.14, ["Neon|Ride"] = 1436.07, ["Neon|Fly|Ride"] = 1422.2, ["Mega|Fly|Ride"] = 4862.82}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 4.93, ["Fly"] = 63.73, ["Ride"] = 15.65, ["Fly|Ride"] = 52.7, ["Neon"] = 38.38, ["Neon|Ride"] = 66.4, ["Neon|Fly|Ride"] = 85.13, ["Mega"] = 168, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 376.32}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.27, ["Fly"] = 21.29, ["Ride"] = 16.36, ["Fly|Ride"] = 32.16, ["Neon"] = 26.71, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 410.31, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 683.93, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.45, ["Fly"] = 32.71, ["Ride"] = 28.87, ["Neon"] = 12.77, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 51.31, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 137.41, ["Mega|Ride"] = 266.61, ["Mega|Fly|Ride"] = 302.5}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 30.09, ["Fly"] = 34.93, ["Ride"] = 40.2, ["Fly|Ride"] = 96.44, ["Neon"] = 140.44, ["Neon|Ride"] = 205.06, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 819.29, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 27.71, ["Fly|Ride"] = 50.3, ["Neon"] = 6.24, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 448.1, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 64.26, ["Ride"] = 25.46, ["Fly|Ride"] = 91.88, ["Neon"] = 139.53, ["Neon|Ride"] = 164.34, ["Neon|Fly|Ride"] = 155.74, ["Mega|Ride"] = 738.27, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.93, ["Neon|Ride"] = 27.69, ["Mega"] = 51.89, ["Mega|Ride"] = 116.91, ["Mega|Fly|Ride"] = 232.78}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.21, ["Ride"] = 137.47, ["Neon"] = 273.9, ["Mega"] = 547.56}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 34.8, ["Neon"] = 76.56, ["Neon|Ride"] = 137.47, ["Mega"] = 302.5, ["Mega|Ride"] = 464.57, ["Mega|Fly|Ride"] = 544.48}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.75, ["Fly"] = 28.69, ["Ride"] = 30.19, ["Fly|Ride"] = 68.72, ["Neon"] = 51.16, ["Neon|Fly"] = 69.14, ["Neon|Ride"] = 54.8, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 576.28, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 305.7, ["Fly"] = 299.25, ["Ride"] = 327.99, ["Fly|Ride"] = 393.65, ["Neon"] = 1462.74, ["Neon|Ride"] = 1340.68, ["Neon|Fly|Ride"] = 1353.5, ["Mega|Fly|Ride"] = 5192.48}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 31.82, ["Ride"] = 15.32, ["Fly|Ride"] = 39.38, ["Neon"] = 11.71, ["Neon|Fly"] = 77.9, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 130.6, ["Mega"] = 212.68, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.24, ["Fly"] = 109.8, ["Ride"] = 45.92, ["Fly|Ride"] = 77.9, ["Neon"] = 41.56, ["Neon|Ride"] = 146.5, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 289.85, ["Mega|Ride"] = 359.91}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 16.43, ["Ride"] = 100.23, ["Fly|Ride"] = 183.75, ["Neon"] = 144.27, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 658.3, ["Mega"] = 328.12, ["Mega|Ride"] = 374.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 97.91, ["Ride"] = 124.69, ["Fly|Ride"] = 443.57, ["Neon"] = 903.7, ["Neon|Ride"] = 1230.92, ["Neon|Fly|Ride"] = 1435.53, ["Mega"] = 3099.39, ["Mega|Ride"] = 7747.9, ["Mega|Fly|Ride"] = 3537.54}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 26.34, ["Fly"] = 91.88, ["Ride"] = 45.94, ["Fly|Ride"] = 142.63, ["Neon"] = 110.06, ["Neon|Ride"] = 123.14, ["Neon|Fly|Ride"] = 213.29, ["Mega"] = 328.13, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 16.94, ["Fly|Ride"] = 57.66, ["Neon"] = 10.39, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 65.58, ["Mega|Ride"] = 151.77, ["Mega|Fly|Ride"] = 155.74}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.49, ["Ride"] = 40.01, ["Neon"] = 30.9, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 169.32, ["Mega|Ride"] = 310.3, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 78.27, ["Fly"] = 196.88, ["Ride"] = 137.47, ["Fly|Ride"] = 202.63, ["Neon"] = 199, ["Neon|Ride"] = 182.49, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 511.88, ["Mega|Ride"] = 498, ["Mega|Fly|Ride"] = 610.31}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 123.11, ["Neon"] = 4.87, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 63.78, ["Mega|Ride"] = 161.91, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 19.46, ["Neon"] = 114.19, ["Neon|Ride"] = 306.71, ["Mega"] = 683.93, ["Mega|Fly|Ride"] = 811.09}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2052.29, ["Ride"] = 1149.11, ["Fly|Ride"] = 1076.24, ["Neon"] = 3556.3, ["Neon|Ride"] = 3877.29, ["Neon|Fly|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 11621.53}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 23.26, ["Fly"] = 76.61, ["Ride"] = 164.13, ["Fly|Ride"] = 191.63, ["Neon"] = 112.88, ["Neon|Fly"] = 273.9, ["Neon|Ride"] = 205.16, ["Mega"] = 379.4, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 25.61, ["Fly|Ride"] = 80.89, ["Neon"] = 10.5, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 32.84, ["Neon|Fly|Ride"] = 91.47, ["Mega"] = 82.05, ["Mega|Ride"] = 108.71, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.71, ["Ride"] = 47.25, ["Fly|Ride"] = 137.47, ["Neon"] = 202.14, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 410.17, ["Mega|Ride"] = 421.71, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 18.62, ["Fly|Ride"] = 59.49, ["Neon"] = 3.67, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 18.01, ["Mega|Fly"] = 123.05, ["Mega|Ride"] = 51.28, ["Mega|Fly|Ride"] = 151.55}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 89.25, ["Ride"] = 117.98, ["Fly|Ride"] = 236.24, ["Neon"] = 410.31, ["Neon|Ride"] = 393.75, ["Mega"] = 1062.09, ["Mega|Ride"] = 1042.13, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 8.5, ["Ride"] = 44.12, ["Fly|Ride"] = 124.68, ["Neon"] = 62.11, ["Neon|Ride"] = 96.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 669.38, ["Mega|Ride"] = 544.48, ["Mega|Fly|Ride"] = 544.48}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.69, ["Neon"] = 11.76, ["Neon|Ride"] = 46.5, ["Mega"] = 99.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 342.49}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 131.15, ["Fly"] = 52.49, ["Ride"] = 205.16, ["Fly|Ride"] = 110.61, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 342.49, ["Mega"] = 683.93, ["Mega|Ride"] = 1025.38, ["Mega|Fly|Ride"] = 1069.17}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 12.53, ["Ride"] = 48.22, ["Fly|Ride"] = 98.32, ["Neon"] = 49.49, ["Neon|Ride"] = 174.18, ["Neon|Fly|Ride"] = 315, ["Mega"] = 465.53, ["Mega|Ride"] = 512.7, ["Mega|Fly|Ride"] = 465.53}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 39.26, ["Ride"] = 84, ["Neon"] = 388.33, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 210, ["Mega"] = 1860.03, ["Mega|Ride"] = 2324.26, ["Mega|Fly|Ride"] = 1579.08}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 5.07, ["Ride"] = 59.52, ["Fly|Ride"] = 78.74, ["Neon"] = 22.07, ["Neon|Ride"] = 86.2, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 104.9, ["Mega|Ride"] = 223.54, ["Mega|Fly|Ride"] = 288.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.94, ["Ride"] = 20.45, ["Fly|Ride"] = 78.75, ["Neon"] = 63.47, ["Neon|Ride"] = 134.39, ["Neon|Fly|Ride"] = 126.34, ["Mega"] = 464.63, ["Mega|Ride"] = 402.94, ["Mega|Fly|Ride"] = 544.48}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 120.75, ["Fly"] = 175.81, ["Ride"] = 177.18, ["Fly|Ride"] = 376.47, ["Neon"] = 547.89, ["Neon|Ride"] = 586.69, ["Neon|Fly|Ride"] = 636.57, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 1903.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 29.75, ["Ride"] = 16.17, ["Fly|Ride"] = 37.8, ["Neon"] = 13.01, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 29.42, ["Neon|Fly|Ride"] = 68.23, ["Mega"] = 124.69, ["Mega|Ride"] = 225.46, ["Mega|Fly|Ride"] = 142.14}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.69, ["Fly"] = 99.75, ["Ride"] = 27.04, ["Fly|Ride"] = 62.78, ["Neon"] = 74.69, ["Neon|Fly"] = 232.54, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 315, ["Mega|Ride"] = 427.75, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 16.34, ["Ride"] = 14.36, ["Fly|Ride"] = 43.31, ["Neon"] = 2.1, ["Neon|Fly"] = 25.45, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 15.1, ["Mega|Fly"] = 48.83, ["Mega|Ride"] = 33.74, ["Mega|Fly|Ride"] = 104.5}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.41, ["Fly|Ride"] = 39.38, ["Neon"] = 2.63, ["Neon|Ride"] = 41.04, ["Mega"] = 18.38, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 63.03, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.9, ["Ride"] = 18.38, ["Fly|Ride"] = 85.79, ["Neon"] = 26.25, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 37.52, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 114.09, ["Neon|Ride"] = 348.79, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 664.44}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 14.3, ["Ride"] = 14.81, ["Fly|Ride"] = 36.94, ["Neon"] = 14.39, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 118.13, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.76, ["Fly"] = 39.38, ["Ride"] = 19.68, ["Fly|Ride"] = 66.89, ["Neon"] = 27.71, ["Neon|Fly"] = 55.41, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 105, ["Mega"] = 185.95, ["Mega|Fly"] = 410.17, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.99, ["Fly|Ride"] = 82.07, ["Neon"] = 7.24, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 20.06, ["Neon|Fly|Ride"] = 89.22, ["Mega"] = 101.54, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 204.74, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.75, ["Fly"] = 169.32, ["Ride"] = 23.34, ["Neon"] = 27.53, ["Neon|Ride"] = 85.28, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 231.75, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 321.57}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.25, ["Fly"] = 127.46, ["Ride"] = 122.75, ["Fly|Ride"] = 157.5, ["Neon"] = 65.62, ["Neon|Ride"] = 262.39, ["Mega"] = 461.43, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 5.14, ["Fly"] = 41.88, ["Ride"] = 27.71, ["Fly|Ride"] = 44.35, ["Neon"] = 22.4, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 41.91, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 328.14, ["Mega|Ride"] = 297.94, ["Mega|Fly|Ride"] = 418.28}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.18, ["Ride"] = 15.42, ["Fly|Ride"] = 34.9, ["Neon"] = 14.15, ["Neon|Fly"] = 46.52, ["Neon|Ride"] = 21.36, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 209.9, ["Mega|Ride"] = 232.44, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 178.5, ["Fly"] = 393.75, ["Ride"] = 306.85, ["Fly|Ride"] = 392.43, ["Neon"] = 1096.35, ["Neon|Ride"] = 1360.26, ["Neon|Fly|Ride"] = 1094.09, ["Mega|Fly|Ride"] = 3740.63}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.94, ["Ride"] = 63.67, ["Neon"] = 42.94, ["Neon|Ride"] = 55.41, ["Neon|Fly|Ride"] = 410.17, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 102.59, ["Ride"] = 21.84, ["Fly|Ride"] = 79.06, ["Neon"] = 20.9, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 203.23, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.87, ["Ride"] = 41.04, ["Neon"] = 60.9, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 603.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.68, ["Fly|Ride"] = 26.03, ["Neon"] = 2.1, ["Neon|Fly"] = 28.66, ["Neon|Ride"] = 15.16, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 18.38, ["Mega|Fly"] = 68.72, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 96.46}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 22.04, ["Ride"] = 18.93, ["Fly|Ride"] = 61.36, ["Neon"] = 12.39, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 85.32, ["Mega|Ride"] = 149.71, ["Mega|Fly|Ride"] = 208.68}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 144.38, ["Neon"] = 39.38, ["Neon|Ride"] = 273.9, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 78.67, ["Mega|Ride"] = 342.49, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.04, ["Fly"] = 162.81, ["Ride"] = 116.95, ["Fly|Ride"] = 173.24, ["Neon"] = 556.49, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 2050.76, ["Mega|Ride"] = 3419.61, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.11, ["Fly"] = 81.29, ["Ride"] = 55.41, ["Fly|Ride"] = 65.63, ["Neon"] = 22.17, ["Neon|Ride"] = 109.77, ["Neon|Fly|Ride"] = 137.41, ["Mega"] = 213.68, ["Mega|Ride"] = 356.12, ["Mega|Fly|Ride"] = 409.14}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 48.99, ["Neon"] = 5.07, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 521.8, ["Mega"] = 52.5, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 96.41}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 72.87, ["Fly"] = 210, ["Ride"] = 94.38, ["Fly|Ride"] = 209.28, ["Neon"] = 115.76, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 636.57, ["Mega|Ride"] = 614.25, ["Mega|Fly|Ride"] = 728.43}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.13, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 20.52, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 36.92, ["Mega"] = 17.63, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 92.98}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 65.52, ["Neon|Fly|Ride"] = 209.34, ["Mega"] = 24.94, ["Mega|Ride"] = 88.17, ["Mega|Fly|Ride"] = 384.68}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 48.44, ["Neon"] = 15.41, ["Neon|Ride"] = 128.8, ["Neon|Fly|Ride"] = 180.48, ["Mega"] = 78.66, ["Mega|Fly"] = 178.43, ["Mega|Ride"] = 109.74, ["Mega|Fly|Ride"] = 220.42}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 3.89, ["Fly"] = 77.17, ["Ride"] = 30.75, ["Fly|Ride"] = 205.11, ["Neon"] = 26.65, ["Neon|Fly"] = 137.47, ["Neon|Ride"] = 76.65, ["Neon|Fly|Ride"] = 217.4, ["Mega"] = 118.02, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 137.65, ["Mega|Fly|Ride"] = 254.42}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.31, ["Ride"] = 15.4, ["Fly|Ride"] = 35.93, ["Neon"] = 2.1, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 18.04, ["Mega|Fly"] = 54.64, ["Mega|Ride"] = 49.23, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 13.13, ["Fly"] = 131.25, ["Ride"] = 123.11, ["Neon"] = 109.12, ["Neon|Fly"] = 410.31, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 957.71, ["Mega"] = 465.53, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2520, ["Ride"] = 2734.67, ["Fly|Ride"] = 2559.38, ["Neon|Fly|Ride"] = 9566.69, ["Mega|Fly|Ride"] = 35820.22}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 137.88, ["Ride"] = 17.48, ["Fly|Ride"] = 40.01, ["Neon"] = 7.06, ["Neon|Fly"] = 62.79, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 62.76, ["Mega"] = 94.35, ["Mega|Fly"] = 457.32, ["Mega|Ride"] = 111.14, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 13.95, ["Mega"] = 140.37, ["Mega|Fly"] = 441, ["Mega|Ride"] = 158.82, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 20.29, ["Fly"] = 109.77, ["Ride"] = 31.17, ["Fly|Ride"] = 105, ["Neon"] = 131.25, ["Neon|Ride"] = 107.72, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 459.38, ["Mega|Ride"] = 460.69, ["Mega|Fly|Ride"] = 488.23}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.44, ["Ride"] = 61.56, ["Neon"] = 187.67, ["Mega"] = 1231.29, ["Mega|Ride"] = 752.63, ["Mega|Fly|Ride"] = 773.15}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 145.78, ["Fly"] = 1368.38, ["Ride"] = 197.88, ["Fly|Ride"] = 415.96, ["Neon"] = 1312.5, ["Neon|Ride"] = 693.39, ["Neon|Fly|Ride"] = 971.04, ["Mega"] = 6152.22, ["Mega|Fly|Ride"] = 3478.13}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 10.17, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 19.52, ["Neon|Ride"] = 146.32, ["Mega"] = 156.19, ["Mega|Ride"] = 171.26, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.36, ["Neon|Ride"] = 114.85, ["Mega"] = 130.85, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 34.73, ["Fly|Ride"] = 131.25, ["Neon"] = 10.4, ["Neon|Ride"] = 43.11, ["Mega"] = 87.45, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 12.9, ["Ride"] = 100.53, ["Neon"] = 145.68, ["Neon|Ride"] = 1165.82, ["Mega|Ride"] = 615.23, ["Mega|Fly|Ride"] = 786.48}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.05, ["Mega"] = 18.31, ["Mega|Fly"] = 116.23, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.88, ["Fly"] = 205.25, ["Ride"] = 122.08, ["Fly|Ride"] = 178.5, ["Neon"] = 511.87, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 512.51, ["Mega"] = 2050.76, ["Mega|Fly|Ride"] = 1732.89}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.31, ["Neon|Ride"] = 141.57, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 127.32, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.63, ["Fly"] = 205.25, ["Ride"] = 89.13, ["Fly|Ride"] = 157.39, ["Neon"] = 262.5, ["Neon|Ride"] = 328.02, ["Mega"] = 1435.53, ["Mega|Fly|Ride"] = 1548.74}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 21.18, ["Fly|Ride"] = 51.33, ["Neon"] = 3.84, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 77.95, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 45.28, ["Neon"] = 19.68, ["Neon|Ride"] = 105, ["Mega"] = 89.25, ["Mega|Ride"] = 191.76, ["Mega|Fly|Ride"] = 615.23}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 10.13, ["Fly"] = 77.43, ["Neon"] = 30.75, ["Neon|Ride"] = 102.59, ["Mega"] = 232.79, ["Mega|Ride"] = 369.14, ["Mega|Fly|Ride"] = 620.6}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 504, ["Ride"] = 590.63, ["Fly|Ride"] = 519.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1723.29, ["Neon|Fly|Ride"] = 1378.12, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4198.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 38.54, ["Ride"] = 57.66, ["Fly|Ride"] = 82.07, ["Neon"] = 278.67, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 272.76, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.68, ["Fly|Ride"] = 91.88, ["Neon"] = 9.19, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 21.84, ["Neon|Fly|Ride"] = 99.95, ["Mega"] = 65.63, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 12.45, ["Fly"] = 219.19, ["Ride"] = 49.87, ["Fly|Ride"] = 124.37, ["Neon"] = 65.55, ["Neon|Fly"] = 465.05, ["Neon|Ride"] = 109.77, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 262.48, ["Mega|Fly"] = 956.45, ["Mega|Ride"] = 270.01, ["Mega|Fly|Ride"] = 379.21}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.23, ["Ride"] = 20.69, ["Fly|Ride"] = 82.07, ["Neon"] = 138.5, ["Neon|Ride"] = 116.91, ["Neon|Fly|Ride"] = 263.82, ["Mega"] = 1094.09, ["Mega|Ride"] = 514.5, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.82, ["Neon"] = 14.4, ["Mega"] = 69.57, ["Mega|Ride"] = 122.06}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21.74, ["Fly|Ride"] = 55.41, ["Neon"] = 25.47, ["Neon|Ride"] = 31.8, ["Neon|Fly|Ride"] = 274.41, ["Mega"] = 137.41, ["Mega|Ride"] = 410.17, ["Mega|Fly|Ride"] = 1640.61}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 103.59, ["Fly"] = 342.61, ["Ride"] = 143.07, ["Fly|Ride"] = 235.62, ["Neon"] = 697.58, ["Neon|Ride"] = 616.88, ["Neon|Fly|Ride"] = 819.29, ["Mega|Fly|Ride"] = 2596.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 41.06, ["Ride"] = 68.74, ["Fly|Ride"] = 137.47, ["Neon"] = 178.5, ["Neon|Ride"] = 191.83, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 889.01, ["Mega|Ride"] = 799.8, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2218.12, ["Fly"] = 2349.38, ["Ride"] = 2152.5, ["Fly|Ride"] = 2152.5, ["Neon"] = 10941.71, ["Neon|Fly|Ride"] = 6424.59, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 77.88, ["Neon"] = 17.07, ["Neon|Ride"] = 137.47, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 121.61, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 198.31, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.11, ["Ride"] = 53.76, ["Neon"] = 46.52, ["Neon|Fly|Ride"] = 232.32, ["Mega"] = 551.5, ["Mega|Ride"] = 547.56, ["Mega|Fly|Ride"] = 819.29}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1036.77, ["Fly"] = 1159.91, ["Ride"] = 908.25, ["Fly|Ride"] = 918.75, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.87, ["Neon|Fly|Ride"] = 2782.49, ["Mega|Fly|Ride"] = 11156.25}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 40.69, ["Fly"] = 82.1, ["Ride"] = 57.51, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 273.9, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 1367.85}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.76, ["Ride"] = 23, ["Fly|Ride"] = 137.47, ["Neon"] = 9.17, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 247.42, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 547.56}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.09, ["Ride"] = 137.47, ["Neon"] = 3.94, ["Neon|Ride"] = 55.32, ["Mega"] = 22.58, ["Mega|Ride"] = 105.63, ["Mega|Fly|Ride"] = 246.09}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 82.1, ["Ride"] = 236.25, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2598.29, ["Mega|Fly|Ride"] = 4101.49}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.94, ["Neon"] = 15.74, ["Neon|Ride"] = 52.02, ["Mega"] = 137.41, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 263.71}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 73.49, ["Ride"] = 102.38, ["Neon"] = 385.87, ["Neon|Ride"] = 465.05, ["Neon|Fly|Ride"] = 494.32}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.57, ["Fly"] = 105, ["Fly|Ride"] = 109.77, ["Neon"] = 26.2, ["Neon|Ride"] = 77.88, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 153.4, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 314.81}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 262.38, ["Ride"] = 330.74, ["Fly|Ride"] = 369.09, ["Neon"] = 1438.92, ["Neon|Ride"] = 836.06, ["Neon|Fly|Ride"] = 879.01, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.26, ["Fly"] = 87.94, ["Ride"] = 19.3, ["Fly|Ride"] = 103.76, ["Neon"] = 34.8, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 342.49, ["Mega|Ride"] = 272.76, ["Mega|Fly|Ride"] = 386.42}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.64, ["Fly|Ride"] = 32.81, ["Neon"] = 3.93, ["Neon|Fly"] = 30.79, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 64.6, ["Mega"] = 77.88, ["Mega|Fly"] = 129.33, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 918.65, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Ride"] = 7522.88, ["Neon|Fly|Ride"] = 5469.33, ["Mega"] = 25976.69}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 18.48, ["Fly"] = 958.07, ["Ride"] = 72.19, ["Fly|Ride"] = 205.16, ["Neon"] = 42.75, ["Neon|Ride"] = 311.75, ["Mega"] = 269.06, ["Mega|Ride"] = 383.5, ["Mega|Fly|Ride"] = 542.73}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.56, ["Fly"] = 46.1, ["Ride"] = 41.04, ["Fly|Ride"] = 127.32, ["Neon"] = 26.25, ["Neon|Fly"] = 124.42, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 130.79, ["Mega"] = 656.25, ["Mega|Fly"] = 226.63, ["Mega|Ride"] = 194.74, ["Mega|Fly|Ride"] = 223.01}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.81, ["Fly"] = 46.51, ["Ride"] = 47.22, ["Fly|Ride"] = 63, ["Neon|Ride"] = 195.46, ["Neon|Fly|Ride"] = 203.33, ["Mega"] = 2050.76, ["Mega|Ride"] = 1230.45, ["Mega|Fly|Ride"] = 1020.26}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.34, ["Fly"] = 82.1, ["Ride"] = 26.24, ["Fly|Ride"] = 91.87, ["Neon"] = 72.86, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 88.3, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 377.9}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 36.66, ["Ride"] = 209.99, ["Fly|Ride"] = 400.05, ["Neon"] = 118.64, ["Neon|Ride"] = 273.9, ["Mega"] = 572.17, ["Mega|Ride"] = 572.17, ["Mega|Fly|Ride"] = 574.23}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 273.9, ["Neon"] = 2.1, ["Neon|Fly"] = 55.41, ["Neon|Ride"] = 109.27, ["Neon|Fly|Ride"] = 310.3, ["Mega"] = 17.01, ["Mega|Ride"] = 88.19, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.41, ["Fly"] = 114.19, ["Ride"] = 85.3, ["Fly|Ride"] = 157.49, ["Neon"] = 393.75, ["Neon|Ride"] = 356.93, ["Neon|Fly|Ride"] = 438.09, ["Mega"] = 3281.2, ["Mega|Ride"] = 1687.76, ["Mega|Fly|Ride"] = 1213.19}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 103.31, ["Ride"] = 23.15, ["Fly|Ride"] = 70.88, ["Neon"] = 51.19, ["Neon|Ride"] = 78.72, ["Mega"] = 773.07, ["Mega|Ride"] = 382.67, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 20.52, ["Fly|Ride"] = 38.06, ["Neon"] = 15.64, ["Neon|Ride"] = 52.33, ["Neon|Fly|Ride"] = 122.84, ["Mega|Ride"] = 269.7, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.75, ["Neon|Fly"] = 135.42, ["Neon|Fly|Ride"] = 183.57, ["Mega"] = 287.12, ["Mega|Fly|Ride"] = 286.09}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.93, ["Ride"] = 68.74, ["Fly|Ride"] = 262.5, ["Neon"] = 262.48, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 369.14, ["Mega"] = 1094.09, ["Mega|Ride"] = 1076.25, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 9.89, ["Neon"] = 28.77, ["Neon|Ride"] = 76.95, ["Mega"] = 104.89, ["Mega|Fly|Ride"] = 310.3}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 20.52, ["Mega"] = 15.64, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 392.74}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 31.65, ["Fly|Ride"] = 136.21, ["Neon"] = 2.62, ["Neon|Ride"] = 28.5, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 18.12, ["Mega|Ride"] = 44.91, ["Mega|Fly|Ride"] = 139.95}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 14.9, ["Fly|Ride"] = 52.46, ["Neon"] = 6.49, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 123.05, ["Mega|Ride"] = 54.44, ["Mega|Fly|Ride"] = 137.41}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 22.32, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.89, ["Fly|Ride"] = 46.49, ["Neon"] = 14.33, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 55.38, ["Mega"] = 230.11, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 66.82, ["Ride"] = 101.73, ["Fly|Ride"] = 219.52, ["Neon"] = 171.32, ["Neon|Ride"] = 328.26, ["Neon|Fly|Ride"] = 1025.38, ["Mega"] = 1550.29, ["Mega|Fly"] = 998.72, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1089.99}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.67, ["Ride"] = 13.71, ["Fly|Ride"] = 35.34, ["Neon"] = 3.84, ["Neon|Fly"] = 41.75, ["Neon|Ride"] = 16.43, ["Neon|Fly|Ride"] = 102.55, ["Mega"] = 23.62, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.65, ["Fly"] = 79.19, ["Ride"] = 23.28, ["Fly|Ride"] = 74.99, ["Neon"] = 42, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 104.89, ["Mega"] = 362.09, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 267.65, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 11.16, ["Fly"] = 47.25, ["Ride"] = 31.79, ["Fly|Ride"] = 52.5, ["Neon"] = 110.15, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 787.5, ["Mega|Ride"] = 492.19, ["Mega|Fly|Ride"] = 697.29}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.65, ["Fly"] = 196.88, ["Neon"] = 73.41, ["Mega"] = 287.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.74, ["Fly|Ride"] = 34.9, ["Neon"] = 4.08, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 24.85, ["Neon|Fly|Ride"] = 52.95, ["Mega"] = 39.38, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 59.41, ["Mega|Fly|Ride"] = 102.52}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.09, ["Fly"] = 52.5, ["Ride"] = 38.07, ["Neon"] = 18.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.53, ["Mega"] = 137.41, ["Mega|Fly"] = 735, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 383.5}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 997.5, ["Ride"] = 1018.36, ["Fly|Ride"] = 1049.99, ["Neon|Ride"] = 2191.88, ["Neon|Fly|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 6929.61}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 100.65, ["Ride"] = 141.75, ["Fly|Ride"] = 105, ["Neon"] = 525, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 655.23, ["Mega"] = 2050.76, ["Mega|Ride"] = 2460.89, ["Mega|Fly|Ride"] = 2037.42}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.42, ["Ride"] = 39.38, ["Neon"] = 5.92, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 205.09, ["Mega"] = 79.99, ["Mega|Fly|Ride"] = 205.09}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 217.34, ["Neon"] = 355.95, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1312.5, ["Mega|Ride"] = 1504.22, ["Mega|Fly|Ride"] = 1510.27}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 6.19, ["Ride"] = 46.69, ["Fly|Ride"] = 89.25, ["Neon"] = 19.3, ["Neon|Fly"] = 41.04, ["Neon|Ride"] = 47.79, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 273.78, ["Mega|Ride"] = 341.3, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 288.75, ["Fly"] = 410.47, ["Ride"] = 364.88, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1395.14, ["Neon|Fly|Ride"] = 1739.04, ["Mega|Fly|Ride"] = 4470.62}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 35.44, ["Fly|Ride"] = 204.69, ["Neon"] = 31.37, ["Neon|Ride"] = 54.37, ["Mega"] = 342.49, ["Mega|Fly"] = 319.93}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.43, ["Mega"] = 328.14}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 28.41, ["Ride"] = 256.35, ["Fly|Ride"] = 153.82, ["Neon"] = 151.82, ["Neon|Ride"] = 273.9, ["Mega"] = 459.38, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.65, ["Fly|Ride"] = 273.9, ["Neon"] = 20.52, ["Neon|Ride"] = 46.52, ["Mega"] = 239.95, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 454.4}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 13.36, ["Ride"] = 12.22, ["Fly|Ride"] = 34.78, ["Neon"] = 2.1, ["Neon|Fly"] = 31.38, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 23.63, ["Mega|Ride"] = 43.09, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4450.69, ["Fly|Ride"] = 4490.07, ["Neon"] = 30772.56, ["Neon|Fly|Ride"] = 19293.74, ["Mega|Fly|Ride"] = 128171.01}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 20.01, ["Ride"] = 54.51, ["Neon"] = 52.39, ["Neon|Ride"] = 106.32, ["Mega"] = 205.09, ["Mega|Ride"] = 278.88, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 17.95, ["Fly|Ride"] = 41.04, ["Neon"] = 13.39, ["Neon|Fly"] = 45.9, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 68.72, ["Mega"] = 131.25, ["Mega|Ride"] = 164.08, ["Mega|Fly|Ride"] = 239.75}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 495.47, ["Fly"] = 547.77, ["Ride"] = 477.75, ["Fly|Ride"] = 551.24, ["Neon"] = 1641.22, ["Neon|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 1521.76, ["Mega|Fly|Ride"] = 5264.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 4.53, ["Ride"] = 32.62, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 683.93}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 9.09, ["Fly"] = 65.63, ["Ride"] = 7131.39, ["Neon"] = 28.64, ["Neon|Ride"] = 273.9, ["Neon|Fly|Ride"] = 273.78, ["Mega"] = 875.61, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 469.23}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.45, ["Ride"] = 17.06, ["Neon"] = 3.69, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 22.29, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 49.7, ["Mega|Ride"] = 76.12, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 790.48, ["Ride"] = 772.35, ["Fly|Ride"] = 861.65, ["Neon"] = 2362.5, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2362.29}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.5, ["Fly"] = 288.25, ["Ride"] = 78.75, ["Neon"] = 31.52, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 217.4, ["Mega"] = 157.49, ["Mega|Ride"] = 216.03, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 6.57, ["Fly"] = 236.15, ["Ride"] = 47.02, ["Fly|Ride"] = 137.47, ["Neon"] = 25.06, ["Neon|Ride"] = 54.63, ["Neon|Fly|Ride"] = 3875.7, ["Mega"] = 205.08, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 14.59, ["Neon"] = 14.33, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.06, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 272.76, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.78, ["Ride"] = 68.74, ["Fly|Ride"] = 155.8, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 307.62, ["Mega"] = 547.56, ["Mega|Ride"] = 765.96, ["Mega|Fly|Ride"] = 738.27}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly|Ride"] = 410.31, ["Neon"] = 3.63, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 183.57, ["Mega"] = 55.31, ["Mega|Ride"] = 104.89, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 478.8, ["Ride"] = 564.38, ["Fly|Ride"] = 787.5, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2492.69, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 102.63, ["Ride"] = 72.18, ["Fly|Ride"] = 131.25, ["Neon"] = 14.44, ["Neon|Ride"] = 84.51, ["Neon|Fly|Ride"] = 525, ["Mega"] = 92.3, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.39, ["Neon"] = 3.84, ["Neon|Fly"] = 232.86, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 64.32, ["Mega|Ride"] = 137.41, ["Mega|Fly|Ride"] = 273.78}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.17, ["Neon|Ride"] = 42.59, ["Mega"] = 55.38, ["Mega|Fly"] = 151.77, ["Mega|Ride"] = 68.54, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.02, ["Ride"] = 27.48, ["Neon"] = 26.69, ["Mega"] = 205.09}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 35.86, ["Fly"] = 98.44, ["Ride"] = 113.45, ["Fly|Ride"] = 295.32, ["Neon"] = 121.95, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 274.37, ["Mega"] = 957.71, ["Mega|Ride"] = 681.19, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 19.15, ["Ride"] = 58, ["Fly|Ride"] = 128.99, ["Neon"] = 105, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 257.15, ["Mega"] = 464.68, ["Mega|Fly"] = 547.56, ["Mega|Ride"] = 451.8, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 15.52, ["Fly|Ride"] = 31.49, ["Neon"] = 28.87, ["Neon|Ride"] = 34.77, ["Neon|Fly|Ride"] = 76.82, ["Mega"] = 299.92, ["Mega|Ride"] = 426.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 8.91, ["Ride"] = 64.32, ["Fly|Ride"] = 119.01, ["Neon"] = 143.01, ["Neon|Ride"] = 135.42, ["Mega|Ride"] = 287.12}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 26.17, ["Fly|Ride"] = 111.55, ["Neon"] = 15.31, ["Neon|Ride"] = 61.56, ["Neon|Fly|Ride"] = 547.56, ["Mega"] = 105, ["Mega|Ride"] = 155.74, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Ride"] = 30.17, ["Fly|Ride"] = 131.25, ["Neon"] = 273.9, ["Neon|Ride"] = 512.9, ["Neon|Fly|Ride"] = 239.95, ["Mega"] = 921.83}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 28.51, ["Fly"] = 874.13, ["Neon"] = 144.38, ["Mega|Fly|Ride"] = 957.71}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 54.04, ["Fly"] = 115.38, ["Ride"] = 76.26, ["Fly|Ride"] = 185.57, ["Neon"] = 294.96, ["Neon|Fly"] = 389.81, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1643.27, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 70.85, ["Fly"] = 92.33, ["Ride"] = 45.93, ["Neon"] = 137.45, ["Neon|Ride"] = 139.53, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 588.69, ["Mega|Ride"] = 642.92, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.97, ["Ride"] = 56.44, ["Fly|Ride"] = 137.47, ["Neon"] = 120.93, ["Neon|Ride"] = 273.9, ["Mega"] = 590.63, ["Mega|Ride"] = 752.63, ["Mega|Fly|Ride"] = 1230.45}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 19.68, ["Fly"] = 428.28, ["Ride"] = 47.24, ["Fly|Ride"] = 192.93, ["Neon"] = 68.74, ["Neon|Fly"] = 420, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 252.13, ["Mega"] = 464.37, ["Mega|Ride"] = 492.64, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 11.82, ["Fly|Ride"] = 26.5, ["Neon"] = 5.25, ["Neon|Fly"] = 27.71, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 42.39, ["Mega|Fly"] = 155.74, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1253.91}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 47.24, ["Fly"] = 232.46, ["Ride"] = 105, ["Fly|Ride"] = 288.75, ["Neon"] = 293.99, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 816.21, ["Mega|Ride"] = 1074.6, ["Mega|Fly|Ride"] = 987.96}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.71, ["Neon"] = 3.82, ["Neon|Fly"] = 96.44, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.12, ["Mega"] = 39.38, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 164.08}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.68, ["Ride"] = 75.93, ["Fly|Ride"] = 166.19, ["Neon"] = 124.69, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 606.66, ["Mega|Ride"] = 589.61, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 26.24}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 35.9, ["Mega|Ride"] = 90.66, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 110.25, ["Fly"] = 241.16, ["Ride"] = 154.88, ["Fly|Ride"] = 246.2, ["Neon"] = 512.9, ["Neon|Ride"] = 587.99, ["Neon|Fly|Ride"] = 724.96, ["Mega|Ride"] = 2529.6, ["Mega|Fly|Ride"] = 1824.38}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.9, ["Fly|Ride"] = 92.99, ["Neon"] = 6.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 205.13}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 34.99, ["Fly|Ride"] = 86.63, ["Neon"] = 3.93, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 32.81, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 82.07, ["Neon"] = 3.59, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 131.24, ["Mega"] = 45.92, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 235.85}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 27.71, ["Neon"] = 5.03, ["Neon|Ride"] = 155.6, ["Mega"] = 65.54, ["Mega|Ride"] = 202.16}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.54, ["Ride"] = 118.13, ["Fly|Ride"] = 449.61, ["Neon"] = 419.83, ["Neon|Ride"] = 511.87, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1504.22, ["Mega|Ride"] = 1538.07, ["Mega|Fly|Ride"] = 1495.01}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.46, ["Ride"] = 62.77, ["Fly|Ride"] = 131.25, ["Neon"] = 38.75, ["Neon|Ride"] = 155.8, ["Mega"] = 383.5, ["Mega|Ride"] = 853.79}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 353.07, ["Ride"] = 410.8, ["Fly|Ride"] = 748.73, ["Neon"] = 1025.77, ["Neon|Ride"] = 1085.89, ["Neon|Fly|Ride"] = 1312.5}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 89.25}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.87}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.81}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 84}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.07}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 45.94}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 14.33}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.66}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.87}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 30.19}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.73}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.18}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 4.74}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 205.09}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.16}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.73}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.53}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.04}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.03}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 564.38}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 820.93}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.86}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.97}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 31.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.09}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.42}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 45.55}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 20.95}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.33}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.31}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.52}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 17.75}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 8.82}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.67}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.55}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1859.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 47.88}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.82}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.12}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.23}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 10.42}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.59}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.4}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1368.88}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 23.55}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.56}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.18}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 32.7}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.71}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 28.88}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 13.44}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 31.4}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 11.3}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 9.08}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 23.72}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 98.44}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 196.86}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 8.61}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 43.07}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 30.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 100.58}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 17.4}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22148.17}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 150.94}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 62.88}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 134.42}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 36.66}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 46.66}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.79}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 76}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 87.05}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.06}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 35.44}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 93.51}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.36}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 46.52}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 410.47}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.24}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.16}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 34.06}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 93.59}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.1}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.65}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 356.09}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 656.25}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 12.22}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 582.75}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.64}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.52}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.51}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.66}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.19}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.16}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 49.76}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.61}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 8.99}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 13.12}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.43}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 24.86}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.89}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.86}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 189.95}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 70.35}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.42}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.71}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.75}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 147.97}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 20.9}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 14.49}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.55}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 15.64}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 90.56}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.61}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 127.55}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 11.16}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.64}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 9.08}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.26}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.13}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.4}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.52}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.46}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7752.1}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.6}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 13}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 5.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 6.67}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 13.12}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.02}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.81}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 6.45}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 4.55}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 109.8}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.38}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.55}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 104.99}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.39}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4342.9}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 6.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 3.13}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 40.51}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.34}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.84}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 5.02}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.5}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 92.64}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.42}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.82}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.12}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 23.16}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 3.03}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.98}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.56}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 5.8}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 18.38}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.13}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.6}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.17}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.26}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.5}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 42.56}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.56}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1039.5}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 39.37}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 11.46}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 21.25}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.81}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.28}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 79.09}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.86}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.67}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 9.22}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.59}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.43}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.11}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.5}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.51}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.46}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 4.67}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 37.16}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 8.53}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 21.61}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 52.41}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 51.05}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 35.37}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.19}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.46}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.9}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 9.85}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 38.58}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 143.75}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.57}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1011.35}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.4}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 273.95}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 70.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 73.49}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.52}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.36}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.7}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 11.71}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 7.18}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.77}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.26}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.29}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 80.64}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 39.8}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 131.06}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 78.41}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 69.57}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 49.87}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 155.82}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 80.16}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 8.22}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 205.25}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.93}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 27.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 60.29}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.83}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 42.95}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.24}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.46}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 39.29}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.48}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 38.07}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 14.81}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 4.11}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 16.17}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 96.48}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.17}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 5.55}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 37.02}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 45}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 21.95}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1706.25}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.01}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 5.81}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 46.52}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 262.5}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.94}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.66}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 10.24}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.29}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.44}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 262.49}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 32.71}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 52.31}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 7.24}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 53.45}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 124.69}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.4}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 951.57}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 211.39}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.33}},
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