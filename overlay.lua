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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 823.09, ["Ride"] = 1027.16, ["Fly|Ride"] = 1232.91, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 20034.62}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 460.29, ["Ride"] = 513.73, ["Fly|Ride"] = 584.72, ["Neon|Ride"] = 1968.75, ["Neon|Fly|Ride"] = 2463.76, ["Mega"] = 11625.88, ["Mega|Fly|Ride"] = 6780.96}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4948.13, ["Ride"] = 5117.44, ["Fly|Ride"] = 4689.57, ["Neon|Fly|Ride"] = 20945.1, ["Mega|Fly|Ride"] = 68494.75}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 129.94, ["Ride"] = 233.21, ["Fly|Ride"] = 286, ["Neon"] = 890.78, ["Neon|Ride"] = 821.94, ["Neon|Fly|Ride"] = 1026.41, ["Mega"] = 4109.67, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 618.52, ["Fly"] = 821.94, ["Ride"] = 538.12, ["Fly|Ride"] = 580.83, ["Neon|Fly|Ride"] = 1650.42, ["Mega|Fly|Ride"] = 6562.49}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.4, ["Ride"] = 29.25, ["Fly|Ride"] = 155.8, ["Neon"] = 39.38, ["Neon|Fly"] = 274.34, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 324.84, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 575.37}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.92, ["Fly"] = 40.47, ["Ride"] = 28.87, ["Fly|Ride"] = 60.38, ["Neon"] = 27.07, ["Neon|Fly"] = 78.14, ["Neon|Ride"] = 50.8, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 130.91, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 276.05}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 104.99, ["Ride"] = 152.27, ["Fly|Ride"] = 240.19, ["Neon"] = 420, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 678.11, ["Mega|Fly|Ride"] = 2682.61}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.4, ["Fly"] = 2779.88, ["Ride"] = 55.5, ["Fly|Ride"] = 98.17, ["Neon"] = 252, ["Neon|Ride"] = 237.93, ["Neon|Fly|Ride"] = 334.69, ["Mega"] = 2100}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 30.83, ["Fly"] = 59.07, ["Ride"] = 40.08, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 243.43, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 670.69}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 53.71, ["Fly"] = 123.31, ["Ride"] = 78.27, ["Fly|Ride"] = 137.69, ["Neon"] = 434.82, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 438.38, ["Mega|Ride"] = 1231.89, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 60.61}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.49, ["Fly"] = 399, ["Ride"] = 323.18, ["Fly|Ride"] = 361.1, ["Neon"] = 1335.66, ["Neon|Ride"] = 1023.75, ["Neon|Fly|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 4860.72}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.68, ["Fly"] = 173.15, ["Ride"] = 109.89, ["Fly|Ride"] = 164.4, ["Neon|Fly"] = 674.31, ["Neon|Ride"] = 581.32, ["Neon|Fly|Ride"] = 959.62, ["Mega|Fly|Ride"] = 2984.38}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.63, ["Ride"] = 53.44, ["Fly|Ride"] = 131.24, ["Neon"] = 20.56, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 130.48, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 308.23, ["Mega|Fly|Ride"] = 273.3}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.53, ["Fly"] = 219.18, ["Ride"] = 177.31, ["Fly|Ride"] = 203.74, ["Neon"] = 775.45, ["Neon|Fly|Ride"] = 780.5, ["Mega"] = 3562.07, ["Mega|Fly|Ride"] = 2611.88}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.47, ["Fly"] = 30.83, ["Ride"] = 16.8, ["Fly|Ride"] = 36.93, ["Neon"] = 26.06, ["Neon|Ride"] = 90.43, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 205.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 88.6, ["Fly"] = 118.13, ["Ride"] = 118.13, ["Fly|Ride"] = 288.75, ["Neon"] = 455.17, ["Neon|Fly"] = 465.05, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1703.79, ["Mega|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 1269.96}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 42}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 56.9, ["Ride"] = 97.62, ["Fly|Ride"] = 178.78, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1370.58, ["Mega|Fly|Ride"] = 2876.78}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 18.38, ["Fly"] = 393.75, ["Ride"] = 31.19, ["Fly|Ride"] = 369.89, ["Neon"] = 159.17, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 410.99, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1643.87}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 55.5, ["Fly"] = 157.49, ["Ride"] = 76.04, ["Fly|Ride"] = 105, ["Neon"] = 671.95, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 1627.63, ["Mega|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.22, ["Fly"] = 65.63, ["Ride"] = 189, ["Fly|Ride"] = 136.5, ["Neon"] = 209.9, ["Neon|Ride"] = 356.04, ["Neon|Fly|Ride"] = 394.49, ["Mega"] = 2047.5, ["Mega|Ride"] = 1232.91, ["Mega|Fly|Ride"] = 1230.87}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 21.86, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 343.17, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 292.99, ["Mega"] = 819.89, ["Mega|Ride"] = 2054.84, ["Mega|Fly|Ride"] = 959.62}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 40.57, ["Fly"] = 136.75, ["Ride"] = 57.87, ["Fly|Ride"] = 123.31, ["Neon"] = 426.39, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 903.42}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.11, ["Fly"] = 24.15, ["Ride"] = 20.56, ["Fly|Ride"] = 52.26, ["Neon"] = 54.66, ["Neon|Fly"] = 101.04, ["Neon|Ride"] = 50.53, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 174.46, ["Mega|Fly"] = 298.12, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 253.38}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 479.82, ["Ride"] = 328.13, ["Fly|Ride"] = 480.12, ["Neon"] = 1781.55, ["Neon|Ride"] = 1781.55, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 8835.67}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.5, ["Ride"] = 27.76, ["Fly|Ride"] = 107.34, ["Neon"] = 204.27, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 274.34, ["Mega|Ride"] = 780.85, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.04, ["Fly"] = 34.44, ["Ride"] = 19.3, ["Fly|Ride"] = 52.5, ["Neon"] = 124.41, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 85.32, ["Mega|Ride"] = 315.44, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 91.88, ["Fly"] = 108.61, ["Ride"] = 94.33, ["Fly|Ride"] = 131.23, ["Neon"] = 410.99, ["Neon|Fly"] = 376.72, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 465.65, ["Mega"] = 3287.74, ["Mega|Ride"] = 7874.99, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.81, ["Ride"] = 30.83, ["Fly|Ride"] = 118.13, ["Neon"] = 96.59, ["Neon|Ride"] = 152.07, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 479.82, ["Mega|Ride"] = 783.93, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 183.75, ["Fly"] = 347.28, ["Ride"] = 248.37, ["Fly|Ride"] = 315.38, ["Neon"] = 836.34, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 978.12, ["Mega"] = 6164.51, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2986.71}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 31.86}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.93, ["Fly"] = 31.39, ["Ride"] = 23.52, ["Fly|Ride"] = 58.69, ["Neon"] = 20.9, ["Neon|Fly"] = 5137.09, ["Neon|Ride"] = 52.47, ["Neon|Fly|Ride"] = 126, ["Mega"] = 158.82, ["Mega|Fly"] = 211.54, ["Mega|Ride"] = 174.41, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 821.94, ["Fly"] = 2625, ["Ride"] = 992.25, ["Fly|Ride"] = 1100.38, ["Neon"] = 7158.38, ["Neon|Ride"] = 6027.87, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Ride"] = 52316.43, ["Mega|Fly|Ride"] = 46503.49}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 11.69, ["Fly"] = 68.85, ["Ride"] = 24.94, ["Fly|Ride"] = 109.3, ["Neon"] = 137.69, ["Neon|Ride"] = 116.25, ["Neon|Fly|Ride"] = 227.08, ["Mega"] = 787.5, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 820.31}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 184.51, ["Ride"] = 191.02, ["Fly|Ride"] = 301.88, ["Neon"] = 1781.55, ["Neon|Ride"] = 865.81, ["Neon|Fly|Ride"] = 918.75, ["Mega|Ride"] = 3949.4, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.45}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.33, ["Fly"] = 109.95, ["Ride"] = 52.41, ["Fly|Ride"] = 137.69, ["Neon"] = 104.89, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 684.53, ["Mega|Ride"] = 1083.93, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 137.69, ["Ride"] = 173.97, ["Fly|Ride"] = 308.23, ["Neon|Ride"] = 513.73, ["Neon|Fly|Ride"] = 546.59, ["Mega|Ride"] = 1956.75, ["Mega|Fly|Ride"] = 2663.7}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 134.61, ["Fly"] = 157.49, ["Ride"] = 192.94, ["Fly|Ride"] = 248.8, ["Neon"] = 410.99, ["Neon|Fly"] = 548.66, ["Neon|Ride"] = 418.55, ["Neon|Fly|Ride"] = 485.63, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1955.19}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.75}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 64.32, ["Fly"] = 51.48, ["Ride"] = 54.12, ["Fly|Ride"] = 108.92, ["Neon|Ride"] = 409.96, ["Neon|Fly|Ride"] = 365.14, ["Mega"] = 4109.67, ["Mega|Fly|Ride"] = 2029.16}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 9.19, ["Ride"] = 56.82, ["Fly|Ride"] = 155.8, ["Neon"] = 137.69, ["Neon|Ride"] = 125.63, ["Neon|Fly|Ride"] = 231.18, ["Mega"] = 237.35, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 323.66, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 525, ["Fly"] = 590.63, ["Ride"] = 465.52, ["Fly|Ride"] = 514.5, ["Neon|Ride"] = 3698.71, ["Neon|Fly|Ride"] = 1605.05, ["Mega|Fly|Ride"] = 7376.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 91.87, ["Fly"] = 150.02, ["Ride"] = 115.5, ["Fly|Ride"] = 188.03, ["Neon"] = 459.38, ["Neon|Fly"] = 821.94, ["Neon|Ride"] = 770.44, ["Neon|Fly|Ride"] = 656.13, ["Mega|Ride"] = 2464.79, ["Mega|Fly|Ride"] = 2328.59}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3562.07, ["Ride"] = 3596.25, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14382.81}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 47.25, ["Fly"] = 112.1, ["Ride"] = 47.49, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 299.83, ["Mega"] = 1315.11, ["Mega|Ride"] = 1753.82, ["Mega|Fly|Ride"] = 1602.79}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 79.49, ["Ride"] = 99.75, ["Fly|Ride"] = 145.53, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 6164.51, ["Mega|Ride"] = 2603.49, ["Mega|Fly|Ride"] = 3158.25}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.03, ["Fly"] = 68.85, ["Ride"] = 45.94, ["Fly|Ride"] = 105.83, ["Neon"] = 131.25, ["Neon|Fly"] = 294.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 203.13, ["Mega"] = 959.62, ["Mega|Ride"] = 767.49, ["Mega|Fly|Ride"] = 656.15}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 37.22, ["Fly"] = 61.66, ["Ride"] = 52.5, ["Fly|Ride"] = 64.95, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 548.66, ["Mega|Fly|Ride"] = 1860.15}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 45.33}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 155.86, ["Ride"] = 219.89, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1068.53, ["Neon|Fly|Ride"] = 1370.58}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 892.5, ["Ride"] = 943.69, ["Fly|Ride"] = 1038.51, ["Neon"] = 2887.5, ["Neon|Ride"] = 2945.62, ["Neon|Fly|Ride"] = 3018.75, ["Mega|Fly|Ride"] = 11358.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 5.76}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 22.12, ["Fly"] = 64.32, ["Ride"] = 43.12, ["Fly|Ride"] = 64.22, ["Neon"] = 164.07, ["Neon|Ride"] = 159.91, ["Neon|Fly|Ride"] = 196.87, ["Mega|Ride"] = 892.19, ["Mega|Fly|Ride"] = 762.75}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 15.68}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4593.75, ["Ride"] = 6472.74, ["Fly|Ride"] = 4705.32, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40613.83}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.67, ["Fly"] = 52.41, ["Ride"] = 24.25, ["Fly|Ride"] = 52.78, ["Neon"] = 109.95, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 787.5, ["Mega|Ride"] = 618.52, ["Mega|Fly|Ride"] = 644.21}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 14.25, ["Fly"] = 139.88, ["Ride"] = 41.11, ["Fly|Ride"] = 115.11, ["Neon"] = 96.59, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1034.72, ["Mega|Ride"] = 577.05, ["Mega|Fly|Ride"] = 648.32}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.88, ["Fly"] = 52.5, ["Ride"] = 68.85, ["Fly|Ride"] = 140.21, ["Neon|Ride"] = 381.19, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4109.67}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.5, ["Fly"] = 150.93, ["Ride"] = 25.1, ["Fly|Ride"] = 78.75, ["Neon"] = 68.85, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 501.38, ["Mega|Ride"] = 731.08, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1706.22, ["Fly"] = 2221.71, ["Ride"] = 1689.19, ["Fly|Ride"] = 1785, ["Neon|Fly|Ride"] = 3542.23, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 26223.75, ["Fly"] = 32877.32, ["Ride"] = 30139.26, ["Fly|Ride"] = 26236.88, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 71234.87, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 16.8, ["Fly"] = 393.74, ["Ride"] = 45.94, ["Fly|Ride"] = 124.41, ["Neon"] = 274.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 410.99, ["Mega"] = 959.62, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 817.84}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 86.63, ["Ride"] = 31.68, ["Fly|Ride"] = 129.07, ["Neon"] = 19.16, ["Neon|Fly"] = 109.3, ["Neon|Ride"] = 44.19, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 127.3, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.75, ["Ride"] = 40.5, ["Fly|Ride"] = 131.25, ["Neon"] = 59.07, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 462.35, ["Mega"] = 285.77, ["Mega|Ride"] = 328.12, ["Mega|Fly|Ride"] = 546.48}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 771.18, ["Ride"] = 787.5, ["Fly|Ride"] = 827.86, ["Neon|Fly|Ride"] = 2352.98, ["Mega|Fly|Ride"] = 8662.5}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 918.75, ["Ride"] = 984.27, ["Fly|Ride"] = 979.13, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.71, ["Fly"] = 116.28, ["Ride"] = 36.39, ["Fly|Ride"] = 85.32, ["Neon"] = 68.25, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 1204.13, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 1096.27}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 28.98}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 58.16, ["Fly"] = 96.59, ["Ride"] = 76.13, ["Fly|Ride"] = 115.11, ["Neon"] = 462.35, ["Neon|Fly|Ride"] = 455.44, ["Mega|Ride"] = 2011.69, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 70.02, ["Ride"] = 105, ["Fly|Ride"] = 209.28, ["Neon"] = 450.19, ["Neon|Ride"] = 296.09, ["Neon|Fly|Ride"] = 548.66, ["Mega"] = 1337.07, ["Mega|Fly|Ride"] = 1861.13}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.29, ["Fly"] = 35.43, ["Ride"] = 15.75, ["Fly|Ride"] = 41.29, ["Neon"] = 41.48, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 55.71, ["Neon|Fly|Ride"] = 119.19, ["Mega"] = 315.44, ["Mega|Fly|Ride"] = 534.27}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 137.45, ["Fly"] = 158.81, ["Ride"] = 152.2, ["Fly|Ride"] = 196.87, ["Neon"] = 446.25, ["Neon|Ride"] = 518.43, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1736.35}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.94, ["Ride"] = 47.28, ["Fly|Ride"] = 123.31, ["Neon"] = 44.19, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 349.34, ["Mega"] = 223.62, ["Mega|Ride"] = 474.62}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.82, ["Fly"] = 41.32, ["Ride"] = 27.76, ["Fly|Ride"] = 75.95, ["Neon"] = 90.63, ["Neon|Ride"] = 110.32, ["Neon|Fly|Ride"] = 304.13, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.82, ["Ride"] = 55.5, ["Fly|Ride"] = 156.19, ["Neon"] = 244.54, ["Neon|Ride"] = 310.43, ["Neon|Fly|Ride"] = 308.23, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 1096.27}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 16.96, ["Fly"] = 178.76, ["Ride"] = 26.25, ["Fly|Ride"] = 70.88, ["Neon"] = 91.88, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 204.47, ["Mega|Fly|Ride"] = 978.12}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7087.5, ["Ride"] = 7141.32, ["Fly|Ride"] = 5494, ["Neon"] = 34247.9, ["Neon|Ride"] = 23625, ["Neon|Fly|Ride"] = 24384.7, ["Mega|Fly|Ride"] = 93006.97}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 213.94, ["Fly"] = 223.02, ["Ride"] = 240.64, ["Fly|Ride"] = 289.92, ["Neon|Fly|Ride"] = 576.19, ["Mega|Fly|Ride"] = 2063.25}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 38.98, ["Fly"] = 147.31, ["Ride"] = 64.73, ["Fly|Ride"] = 178.78, ["Neon"] = 121.61, ["Neon|Ride"] = 176.97, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 433.84, ["Mega|Ride"] = 401.2, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.63, ["Fly"] = 86.04, ["Ride"] = 32.88, ["Fly|Ride"] = 52.5, ["Neon"] = 30.83, ["Neon|Fly"] = 49.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 187, ["Mega"] = 273.3, ["Mega|Ride"] = 187.69}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 49.7, ["Fly"] = 5270.01, ["Ride"] = 83.91, ["Fly|Ride"] = 248.8, ["Neon"] = 216.18, ["Neon|Fly"] = 380.16, ["Neon|Ride"] = 233.87, ["Neon|Fly|Ride"] = 311.56, ["Mega"] = 429.61, ["Mega|Ride"] = 485.45, ["Mega|Fly|Ride"] = 605.04}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16485, ["Ride"] = 12009.38, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 22837.5}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 250.71, ["Ride"] = 301.9, ["Fly|Ride"] = 334.95, ["Neon"] = 1516.03, ["Neon|Fly|Ride"] = 1555.53, ["Mega"] = 5650.81, ["Mega|Fly|Ride"] = 5866.56}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 63, ["Fly"] = 78.77, ["Ride"] = 58.59, ["Fly|Ride"] = 103.66, ["Neon"] = 390.43, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 275.63, ["Mega|Fly|Ride"] = 2740.13}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.38, ["Fly"] = 44.19, ["Ride"] = 24.75, ["Fly|Ride"] = 72.12, ["Neon"] = 140.44, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Ride"] = 418.69, ["Fly|Ride"] = 464.63, ["Neon"] = 1771.88, ["Neon|Ride"] = 1581.97, ["Neon|Fly|Ride"] = 1740.46, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.12, ["Fly"] = 48.57, ["Ride"] = 37.7, ["Fly|Ride"] = 104.9, ["Neon"] = 25.65, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 129.47, ["Mega"] = 137.81, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 123.8, ["Fly"] = 159.27, ["Ride"] = 128.52, ["Fly|Ride"] = 210, ["Neon"] = 485.63, ["Neon|Ride"] = 524.88, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2624.99}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.73, ["Fly"] = 18.09, ["Ride"] = 18.06, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 102.65, ["Mega"] = 2465.81}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.2}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 45.02, ["Fly"] = 137.69, ["Ride"] = 79.87, ["Fly|Ride"] = 196.88, ["Neon"] = 421.32, ["Neon|Fly"] = 548.66, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 3082.26, ["Mega|Ride"] = 1232.91}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.76, ["Fly"] = 101.73, ["Ride"] = 35.25, ["Fly|Ride"] = 89.25, ["Neon"] = 91.88, ["Neon|Ride"] = 160.46, ["Neon|Fly|Ride"] = 295.91, ["Mega|Ride"] = 615.44, ["Mega|Fly|Ride"] = 699.89}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 24.82}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.17, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 249.38, ["Neon"] = 217.39, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 479.82, ["Mega"] = 1541.14, ["Mega|Ride"] = 1550.91, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.94, ["Ride"] = 29.23, ["Fly|Ride"] = 132.55, ["Neon"] = 23.63, ["Neon|Ride"] = 101.16, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 137.82, ["Mega|Ride"] = 274.34, ["Mega|Fly|Ride"] = 358.98}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.49, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 99.65, ["Neon|Ride"] = 152.07, ["Neon|Fly|Ride"] = 205.5, ["Mega|Ride"] = 624.49, ["Mega|Fly|Ride"] = 590.28}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 438.38, ["Ride"] = 480.77, ["Fly|Ride"] = 575.37, ["Neon|Fly|Ride"] = 2740.13, ["Mega|Fly|Ride"] = 12401.33}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 39.87, ["Ride"] = 41.5, ["Fly|Ride"] = 105, ["Neon"] = 234.99, ["Neon|Ride"] = 257.27, ["Neon|Fly|Ride"] = 217.42, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 1370.58}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 58.15, ["Fly"] = 117.49, ["Ride"] = 70.87, ["Fly|Ride"] = 131.15, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 435.64, ["Mega|Fly|Ride"] = 1507.24}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 32.8, ["Fly"] = 99.68, ["Ride"] = 62.5, ["Fly|Ride"] = 137.69, ["Neon"] = 112.88, ["Neon|Fly"] = 257.9, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 303.11, ["Mega"] = 437.07, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11160.82, ["Ride"] = 13331.38, ["Fly|Ride"] = 8526, ["Neon|Fly|Ride"] = 16929.94, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1556.63, ["Fly"] = 1487.07, ["Ride"] = 1405.22, ["Fly|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 4987.5, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 548.66, ["Ride"] = 560.39, ["Fly|Ride"] = 685.3, ["Neon"] = 2552.44, ["Neon|Fly|Ride"] = 2062.55, ["Mega|Fly|Ride"] = 9589.92}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.39, ["Fly"] = 22.35, ["Ride"] = 23.55, ["Fly|Ride"] = 52.41, ["Neon"] = 72.19, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 137.69, ["Mega|Fly|Ride"] = 534.27}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 4.67, ["Fly"] = 78.74, ["Ride"] = 29.46, ["Fly|Ride"] = 97.62, ["Neon"] = 24.94, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 246.75, ["Mega"] = 143.55, ["Mega|Ride"] = 178.58, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.05, ["Fly"] = 66.07, ["Ride"] = 54.68, ["Fly|Ride"] = 99.75, ["Neon"] = 267.15, ["Neon|Ride"] = 184.95, ["Neon|Fly|Ride"] = 189.84, ["Mega|Fly|Ride"] = 553.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.63, ["Fly"] = 31.86, ["Ride"] = 19, ["Fly|Ride"] = 40.03, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 43.64, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 164.4, ["Mega|Ride"] = 232.54, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 283.5, ["Fly"] = 369.49, ["Ride"] = 332.07, ["Fly|Ride"] = 419.63, ["Neon|Fly|Ride"] = 1096.27, ["Mega|Fly|Ride"] = 4904.9}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.27, ["Fly"] = 55.5, ["Ride"] = 38.75, ["Fly|Ride"] = 82.51, ["Neon"] = 131.25, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 141.6, ["Neon|Fly|Ride"] = 233.24, ["Mega"] = 821.94, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.46, ["Fly"] = 20.99, ["Ride"] = 19.69, ["Fly|Ride"] = 35.44, ["Neon"] = 82.21, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 508.58, ["Fly"] = 787.5, ["Ride"] = 509.75, ["Fly|Ride"] = 528.11, ["Mega|Fly|Ride"] = 8082.71}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1318.19, ["Ride"] = 1239.95, ["Fly|Ride"] = 1312.5, ["Neon"] = 4794.97, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 91.88, ["Fly"] = 133.59, ["Ride"] = 103.69, ["Fly|Ride"] = 105, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 3100.64}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 168, ["Fly"] = 157.49, ["Ride"] = 162.53, ["Fly|Ride"] = 233.24, ["Neon"] = 577.5, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 762.57, ["Mega|Ride"] = 8603.44, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.17, ["Ride"] = 47.16, ["Fly|Ride"] = 118.6, ["Neon"] = 384.27, ["Neon|Ride"] = 272.98, ["Mega|Ride"] = 863.04, ["Mega|Fly|Ride"] = 878.46}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 151.28, ["Ride"] = 274.34, ["Fly|Ride"] = 548.66, ["Neon|Fly|Ride"] = 1302.12, ["Mega|Fly|Ride"] = 3698.71}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2233.33, ["Ride"] = 2480.98, ["Fly|Ride"] = 2353.82, ["Neon|Fly|Ride"] = 10274.17, ["Mega|Fly|Ride"] = 27902.1}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 49.98, ["Fly"] = 205.5, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 511.88, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 343.87, ["Mega|Ride"] = 2260.33, ["Mega|Fly|Ride"] = 1259.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 605.18, ["Fly"] = 754.15, ["Ride"] = 605.71, ["Fly|Ride"] = 682.5, ["Neon|Ride"] = 1520.59, ["Neon|Fly|Ride"] = 1216.15, ["Mega|Fly|Ride"] = 3359.54}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 37.69, ["Fly"] = 64.32, ["Ride"] = 55.5, ["Fly|Ride"] = 98.44, ["Neon|Ride"] = 266.09, ["Neon|Fly|Ride"] = 303.19, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.63, ["Fly"] = 35.44, ["Ride"] = 18.38, ["Fly|Ride"] = 64.31, ["Neon"] = 19.53, ["Neon|Fly"] = 85.26, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 152.03, ["Mega|Fly"] = 248.99, ["Mega|Ride"] = 182.1, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 51.93, ["Ride"] = 137.69, ["Fly|Ride"] = 253.32, ["Neon"] = 339.06, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 685.3, ["Mega"] = 1438.4, ["Mega|Fly|Ride"] = 1429.16}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 826.87, ["Fly"] = 853.13, ["Ride"] = 808.5, ["Fly|Ride"] = 849.62, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2562.38, ["Mega|Fly|Ride"] = 8424.83}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 714.65, ["Ride"] = 881.26, ["Fly|Ride"] = 930.08, ["Neon|Fly|Ride"] = 4100.43, ["Mega|Fly|Ride"] = 14794.81}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.92, ["Fly"] = 21, ["Ride"] = 20.65, ["Fly|Ride"] = 40.31, ["Neon"] = 118.02, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 206.07, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 25.99, ["Fly|Ride"] = 68.84, ["Neon"] = 93.02, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 400.32, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 529.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 6.18, ["Ride"] = 22.32, ["Fly|Ride"] = 111.57, ["Neon"] = 21.23, ["Neon|Fly"] = 310.3, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 134.99, ["Mega|Fly"] = 527.83, ["Mega|Ride"] = 244.02, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.91, ["Ride"] = 50.75, ["Fly|Ride"] = 100.95, ["Neon"] = 249.38, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 189.8, ["Mega|Fly|Ride"] = 947.61}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 63.4, ["Ride"] = 133.84, ["Fly|Ride"] = 616.46, ["Neon"] = 424.07, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1507.24, ["Mega|Ride"] = 1541.14, ["Mega|Fly|Ride"] = 1502.1}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 14.16, ["Fly"] = 51.19, ["Ride"] = 37.01, ["Fly|Ride"] = 77.18, ["Neon"] = 93.51, ["Neon|Fly"] = 155.8, ["Neon|Ride"] = 118.02, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 439.74, ["Mega|Ride"] = 352.96, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 31.54, ["Fly"] = 109.95, ["Ride"] = 43.26, ["Fly|Ride"] = 89.25, ["Neon"] = 323.84, ["Neon|Ride"] = 193.68, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 2100, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.94, ["Fly"] = 18.51, ["Ride"] = 15.75, ["Fly|Ride"] = 41.11, ["Neon"] = 24.03, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.73, ["Mega"] = 732.38, ["Mega|Ride"] = 465.05, ["Mega|Fly|Ride"] = 512.7}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.5, ["Fly"] = 43.2, ["Ride"] = 35.98, ["Fly|Ride"] = 31507.77, ["Neon"] = 25.99, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 71.94, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 287.69, ["Mega|Ride"] = 306.48, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.67, ["Fly"] = 65.63, ["Ride"] = 52.31, ["Fly|Ride"] = 95.82, ["Neon"] = 403.44, ["Neon|Ride"] = 254.82, ["Neon|Fly|Ride"] = 261.19, ["Mega|Fly|Ride"] = 1072.11}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1358.6, ["Fly"] = 1367.27, ["Ride"] = 1414.88, ["Fly|Ride"] = 1573.69, ["Neon|Ride"] = 4914.27, ["Neon|Fly|Ride"] = 3806.25, ["Mega|Fly|Ride"] = 13480.61}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 452.75, ["Fly"] = 470.15, ["Ride"] = 450.09, ["Fly|Ride"] = 448.26, ["Neon|Fly|Ride"] = 3242.54, ["Mega|Fly|Ride"] = 9589.92}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 298.86, ["Ride"] = 363.72, ["Fly|Ride"] = 453.11, ["Neon"] = 853.13, ["Neon|Ride"] = 1232.91, ["Neon|Fly|Ride"] = 1713.74, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 47.24}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 25.35, ["Ride"] = 41.19, ["Fly|Ride"] = 98.43, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 465.05, ["Mega|Ride"] = 1411.69, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 71234.87, ["Fly"] = 65625, ["Ride"] = 34877.55, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 335.9, ["Fly"] = 381.33, ["Ride"] = 345.19, ["Fly|Ride"] = 328.13, ["Neon"] = 1368.53, ["Neon|Fly"] = 1240.49, ["Neon|Ride"] = 1059.28, ["Neon|Fly|Ride"] = 1036.88, ["Mega"] = 6164.51, ["Mega|Fly|Ride"] = 3871.88}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 167.9, ["Fly"] = 525, ["Ride"] = 137.67, ["Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 130.49, ["Fly"] = 262.5, ["Ride"] = 123.38, ["Fly|Ride"] = 205.37, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 462, ["Mega|Fly|Ride"] = 5137.09}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 17.07, ["Fly"] = 94.5, ["Ride"] = 33.73, ["Fly|Ride"] = 108.94, ["Neon"] = 393.75, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 695.24, ["Mega|Ride"] = 548.49, ["Mega|Fly|Ride"] = 630.84}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5275.83, ["Ride"] = 5342.58, ["Fly|Ride"] = 5177.45, ["Neon"] = 20548.33, ["Neon|Fly|Ride"] = 27123.79}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 21, ["Fly"] = 137.64, ["Ride"] = 26.29, ["Fly|Ride"] = 64.32, ["Neon"] = 205.5, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 217.42, ["Mega|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 780.85}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 32.81, ["Fly"] = 106.51, ["Ride"] = 55.34, ["Fly|Ride"] = 91.88, ["Neon"] = 403.96, ["Neon|Ride"] = 240.43, ["Neon|Fly|Ride"] = 359.63, ["Mega|Fly|Ride"] = 1372.86}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 662.82, ["Fly"] = 837.08, ["Ride"] = 674.63, ["Fly|Ride"] = 733.21, ["Neon"] = 2522.33, ["Neon|Ride"] = 2300.41, ["Neon|Fly|Ride"] = 1955.41, ["Mega"] = 7458.03, ["Mega|Fly"] = 7458.03, ["Mega|Fly|Ride"] = 7145.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.27, ["Fly"] = 24.94, ["Ride"] = 24.4, ["Fly|Ride"] = 39.38, ["Neon"] = 115.49, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 693.53}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.39, ["Ride"] = 21.86, ["Fly|Ride"] = 77.9, ["Neon"] = 91.88, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 124.74, ["Mega|Ride"] = 809.62, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 89.25, ["Ride"] = 102.76, ["Fly|Ride"] = 167.49, ["Neon"] = 713.04, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 603.1, ["Mega|Fly|Ride"] = 2724.72}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 20.71, ["Ride"] = 62.79, ["Fly|Ride"] = 152.07, ["Neon"] = 96.59, ["Neon|Ride"] = 130.49, ["Neon|Fly|Ride"] = 210, ["Mega"] = 275.63, ["Mega|Fly"] = 738.26, ["Mega|Ride"] = 276.28, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4196.38, ["Fly"] = 4918.26, ["Ride"] = 3883.64, ["Fly|Ride"] = 4160.62, ["Neon|Ride"] = 11812.5, ["Neon|Fly|Ride"] = 9841.13, ["Mega"] = 61644.96, ["Mega|Fly|Ride"] = 32194.1}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 40.45, ["Fly"] = 102.76, ["Ride"] = 60.38, ["Fly|Ride"] = 190.67, ["Neon"] = 393.75, ["Neon|Ride"] = 248.81, ["Neon|Fly|Ride"] = 369.89, ["Mega|Ride"] = 1019.21, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7271.25, ["Ride"] = 6857.82, ["Fly|Ride"] = 7054.69, ["Neon|Ride"] = 18904.48, ["Neon|Fly|Ride"] = 15754.4, ["Mega|Fly|Ride"] = 63555.17}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.62, ["Fly"] = 13.86, ["Ride"] = 16.47, ["Fly|Ride"] = 29.51, ["Neon"] = 23.97, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 137.69, ["Mega|Ride"] = 164.4, ["Mega|Fly|Ride"] = 340.09}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 17.72, ["Fly"] = 28.71, ["Ride"] = 26.25, ["Fly|Ride"] = 34.94, ["Neon"] = 137.69, ["Neon|Fly"] = 227.08, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.82}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.92, ["Ride"] = 32.82, ["Fly|Ride"] = 85.32, ["Neon"] = 270.04, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 1049.9, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 1231.8}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 25.34, ["Fly"] = 190.37, ["Ride"] = 41.19, ["Fly|Ride"] = 99.73, ["Neon"] = 207.56, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 342.98, ["Mega"] = 945, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.31, ["Fly"] = 18.47, ["Ride"] = 20.26, ["Fly|Ride"] = 37.89, ["Neon|Fly"] = 109.95, ["Neon|Ride"] = 114.06, ["Neon|Fly|Ride"] = 178.78, ["Mega"] = 2465.81, ["Mega|Ride"] = 580.14, ["Mega|Fly|Ride"] = 517.83}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8322.08}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2362.5}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 20.2}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.19, ["Ride"] = 205.48, ["Fly|Ride"] = 218.66, ["Neon|Fly|Ride"] = 685.3, ["Mega|Fly|Ride"] = 5115.41}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.39, ["Fly"] = 129.47, ["Ride"] = 33.73, ["Fly|Ride"] = 105, ["Neon"] = 95.82, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 534.27, ["Mega|Fly|Ride"] = 957.57}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.86, ["Ride"] = 29.81, ["Fly|Ride"] = 82.21, ["Neon|Ride"] = 96.59, ["Mega|Fly|Ride"] = 821.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 3051.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 181.39, ["Fly"] = 410.99, ["Ride"] = 215.25, ["Fly|Ride"] = 301.88, ["Neon"] = 701.37, ["Neon|Ride"] = 724.5, ["Mega|Ride"] = 3151.1, ["Mega|Fly|Ride"] = 3426.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 119.12, ["Ride"] = 111.23, ["Fly|Ride"] = 164.4, ["Neon"] = 685.3, ["Neon|Ride"] = 502.51, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 208.58, ["Fly"] = 265.49, ["Ride"] = 170.19, ["Fly|Ride"] = 233.24, ["Neon"] = 590.63, ["Neon|Ride"] = 1591.08, ["Neon|Fly|Ride"] = 1219.56, ["Mega|Fly|Ride"] = 4615.17}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1811.25, ["Fly"] = 3151.1, ["Ride"] = 2093.07, ["Fly|Ride"] = 1575, ["Neon"] = 8138.1, ["Neon|Fly|Ride"] = 6162.19, ["Mega|Fly|Ride"] = 23973.74}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 17.07, ["Fly"] = 96.59, ["Ride"] = 56.8, ["Fly|Ride"] = 69.02, ["Neon"] = 127.3, ["Neon|Ride"] = 202.3, ["Neon|Fly|Ride"] = 178.78, ["Mega"] = 923.66, ["Mega|Ride"] = 930.08, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 782.25, ["Fly"] = 2100, ["Ride"] = 727.57, ["Fly|Ride"] = 945.24, ["Neon|Fly|Ride"] = 4030.7, ["Mega|Fly|Ride"] = 18601.41}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 40.74}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 12.99, ["Ride"] = 39.38, ["Fly|Ride"] = 647.98, ["Neon"] = 101.07, ["Neon|Ride"] = 129.47, ["Neon|Fly|Ride"] = 303.11, ["Mega"] = 480.38, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 562.02}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.84, ["Fly"] = 27.76, ["Ride"] = 28.88, ["Fly|Ride"] = 96.77, ["Neon"] = 67.45, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 918.75, ["Mega|Ride"] = 356.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 72.97}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.45, ["Fly"] = 108.92, ["Ride"] = 31.5, ["Fly|Ride"] = 80.14, ["Neon"] = 192.14, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 170.63, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 1828.82}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 27.09, ["Fly"] = 76.05, ["Ride"] = 41.11, ["Fly|Ride"] = 70.88, ["Neon"] = 233.24, ["Neon|Ride"] = 294.88, ["Neon|Fly|Ride"] = 303.11, ["Mega"] = 959.62, ["Mega|Ride"] = 1743.9, ["Mega|Fly|Ride"] = 959.62}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6300, ["Fly"] = 10959.46, ["Ride"] = 5250, ["Fly|Ride"] = 5204.07, ["Neon|Fly|Ride"] = 11550, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.71, ["Fly"] = 65.62, ["Ride"] = 32.82, ["Fly|Ride"] = 85.3, ["Neon"] = 80.32, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 520.86, ["Mega|Ride"] = 384.27, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 26.71}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.34, ["Fly"] = 363.72, ["Ride"] = 133.71, ["Neon"] = 479.82, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1926.64}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 52.5, ["Fly"] = 82.21, ["Ride"] = 94.54, ["Fly|Ride"] = 155.93, ["Neon"] = 255.93, ["Neon|Ride"] = 265.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2325.19, ["Mega|Ride"] = 2774.03, ["Mega|Fly|Ride"] = 1777.44}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.99, ["Fly"] = 68.85, ["Ride"] = 27.76, ["Fly|Ride"] = 64.98, ["Neon|Fly"] = 233.24, ["Neon|Ride"] = 205.37, ["Neon|Fly|Ride"] = 185.81, ["Mega"] = 1016.21, ["Mega|Ride"] = 853.35, ["Mega|Fly|Ride"] = 707.42}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.88, ["Fly"] = 82.21, ["Ride"] = 26.33, ["Fly|Ride"] = 91.87, ["Neon"] = 37.74, ["Neon|Ride"] = 51.96, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 180.48, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 212.58, ["Mega|Fly|Ride"] = 305.16}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.89, ["Fly"] = 38.19, ["Ride"] = 30.19, ["Fly|Ride"] = 71.4, ["Neon"] = 85.22, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 219.89, ["Mega"] = 720.82, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 754.15}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.18, ["Fly"] = 28.88, ["Ride"] = 24.05, ["Fly|Ride"] = 44.63, ["Neon"] = 205.5, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 150.94, ["Mega|Fly|Ride"] = 713.04}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 213.94}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 45.21, ["Ride"] = 94.5, ["Fly|Ride"] = 274.34, ["Neon"] = 196.88, ["Neon|Ride"] = 821.94, ["Mega"] = 821.94, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 208.59, ["Ride"] = 443.63, ["Fly|Ride"] = 1550.71, ["Neon"] = 1096.27}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.11, ["Fly"] = 212.02, ["Ride"] = 99.98, ["Fly|Ride"] = 163.27, ["Neon"] = 314.88, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 404.53, ["Mega"] = 908.24, ["Mega|Ride"] = 2171.72, ["Mega|Fly|Ride"] = 1289.43}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 900.36, ["Fly"] = 1329.49, ["Ride"] = 997.5, ["Fly|Ride"] = 984.38, ["Neon|Fly"] = 4022.55, ["Neon|Ride"] = 3151.1, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12877.65}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 392.34, ["Fly"] = 685.3, ["Ride"] = 433.13, ["Fly|Ride"] = 520.91, ["Neon"] = 1922.93, ["Neon|Ride"] = 2054.84, ["Neon|Fly|Ride"] = 2124.06, ["Mega|Fly|Ride"] = 7479.94}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 68.85}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.82, ["Fly"] = 25.59, ["Ride"] = 18.38, ["Fly|Ride"] = 72.97, ["Neon"] = 78.73, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 94.54, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 437.26, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 479.82}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 259.63, ["Fly"] = 685.21, ["Ride"] = 301.88, ["Fly|Ride"] = 416.07, ["Neon"] = 1074.7, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3087}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 126.12, ["Ride"] = 202.17, ["Fly|Ride"] = 288.75, ["Neon"] = 820.92, ["Neon|Ride"] = 853.35, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 9863.21, ["Mega|Ride"] = 2740.13, ["Mega|Fly|Ride"] = 3012.39}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 127.32, ["Fly"] = 138.72, ["Ride"] = 125.89, ["Fly|Ride"] = 274.32, ["Neon"] = 685.3, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 3426.45}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.16, ["Ride"] = 22.4, ["Fly|Ride"] = 167.49, ["Neon"] = 38.07, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 230.21, ["Mega"] = 303.11, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 819.89}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 13.02, ["Fly"] = 63.03, ["Ride"] = 27.76, ["Fly|Ride"] = 73.24, ["Neon"] = 177.19, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 800.38, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.72, ["Fly"] = 102.34, ["Ride"] = 44.19, ["Fly|Ride"] = 82.21, ["Neon"] = 102.76, ["Neon|Ride"] = 130.49, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 498.75, ["Mega|Ride"] = 504, ["Mega|Fly|Ride"] = 726.39}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.67, ["Fly"] = 262.5, ["Ride"] = 56.15, ["Fly|Ride"] = 137.69, ["Neon"] = 29.3, ["Neon|Fly"] = 232.54, ["Neon|Ride"] = 58.65, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 169.54, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.8, ["Fly"] = 410.99, ["Ride"] = 262.5, ["Fly|Ride"] = 393.86, ["Neon"] = 1617.16, ["Neon|Ride"] = 1478.47, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5205.93}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 144.38, ["Fly"] = 328.79, ["Ride"] = 165.3, ["Fly|Ride"] = 236.25, ["Neon"] = 545.57, ["Neon|Ride"] = 753.81, ["Neon|Fly|Ride"] = 571.69, ["Mega|Ride"] = 3287.74, ["Mega|Fly|Ride"] = 3287.74}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 101.73, ["Fly"] = 167.45, ["Ride"] = 94.5, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 575.49, ["Neon|Fly|Ride"] = 416.06, ["Mega"] = 1781.55, ["Mega|Ride"] = 1849.37, ["Mega|Fly|Ride"] = 1801.11}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.38, ["Ride"] = 32.89, ["Fly|Ride"] = 274.34, ["Neon"] = 343.17, ["Neon|Ride"] = 590.61, ["Neon|Fly|Ride"] = 479.82, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 1849.37}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.13, ["Ride"] = 43.32, ["Fly|Ride"] = 72.19, ["Neon"] = 77.39, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 192.57, ["Mega"] = 248.64, ["Mega|Fly"] = 525, ["Mega|Ride"] = 360.94, ["Mega|Fly|Ride"] = 515.79}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.92, ["Fly"] = 52.41, ["Ride"] = 23.62, ["Fly|Ride"] = 68.85, ["Neon"] = 17.84, ["Neon|Fly"] = 85.07, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 118.09, ["Mega"] = 122.63, ["Mega|Ride"] = 135.69, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 922.69, ["Fly"] = 1082.72, ["Ride"] = 932.45, ["Fly|Ride"] = 984.38, ["Neon|Fly"] = 3411.05, ["Neon|Ride"] = 3133.62, ["Neon|Fly|Ride"] = 2559.38, ["Mega|Fly|Ride"] = 9300.71}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 343.17, ["Ride"] = 453.11, ["Fly|Ride"] = 525, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1588.4, ["Mega"] = 10274.17, ["Mega|Fly|Ride"] = 6145.44}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 63, ["Fly"] = 137.69, ["Ride"] = 124.69, ["Fly|Ride"] = 177.28, ["Neon"] = 339.94, ["Neon|Ride"] = 304.5, ["Neon|Fly|Ride"] = 343.17, ["Mega|Fly|Ride"] = 1917.17}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 308.23, ["Ride"] = 231.28, ["Fly|Ride"] = 268.83, ["Neon|Fly|Ride"] = 1232.91, ["Mega"] = 10274.17, ["Mega|Fly|Ride"] = 5480.25}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 15.54, ["Fly"] = 72.97, ["Ride"] = 28.88, ["Fly|Ride"] = 71.49, ["Neon"] = 169.32, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 774.3}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.25, ["Ride"] = 299, ["Fly|Ride"] = 459.38, ["Neon"] = 805.49, ["Neon|Ride"] = 819.89, ["Neon|Fly|Ride"] = 1010.63, ["Mega"] = 4088.6, ["Mega|Ride"] = 4520.64, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 53.72, ["Fly"] = 125.98, ["Ride"] = 51.97, ["Fly|Ride"] = 132.53, ["Neon|Ride"] = 449.94, ["Mega|Fly|Ride"] = 1438.4}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1870.32, ["Ride"] = 1837.49, ["Fly|Ride"] = 1978.96, ["Neon|Ride"] = 10851.61, ["Neon|Fly|Ride"] = 6713.16, ["Mega"] = 49315.97, ["Mega|Fly|Ride"] = 22150.08}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13, ["Fly"] = 55.5, ["Ride"] = 46.76, ["Fly|Ride"] = 114.06, ["Neon"] = 51.66, ["Neon|Fly"] = 236.57, ["Neon|Ride"] = 76.11, ["Neon|Fly|Ride"] = 230.22, ["Mega"] = 365.77, ["Mega|Fly"] = 561.75, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 50.55, ["Fly"] = 119.1, ["Ride"] = 79.19, ["Fly|Ride"] = 115.5, ["Neon"] = 315, ["Neon|Ride"] = 308.23, ["Neon|Fly|Ride"] = 304.5, ["Mega"] = 1627.63, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 65.54, ["Fly"] = 94.29, ["Ride"] = 77.28, ["Fly|Ride"] = 97.12, ["Neon"] = 525, ["Neon|Ride"] = 439.74, ["Neon|Fly|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1842.37}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3423.37, ["Fly"] = 1550.9, ["Ride"] = 1073.63, ["Fly|Ride"] = 1049.99}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 474.27, ["Fly"] = 819.89, ["Ride"] = 677.08, ["Fly|Ride"] = 656.25, ["Neon|Fly|Ride"] = 3100.64}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 82.82, ["Fly"] = 202.3, ["Ride"] = 133.59, ["Fly|Ride"] = 271.25, ["Neon"] = 408.19, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 533.24, ["Mega"] = 4109.67, ["Mega|Ride"] = 2596.29, ["Mega|Fly|Ride"] = 2465.81}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.48, ["Ride"] = 21.76, ["Fly|Ride"] = 109.3, ["Neon"] = 78.75, ["Neon|Ride"] = 95.82, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 831.27, ["Mega|Ride"] = 762.72}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 38.33, ["Fly"] = 61.66, ["Ride"] = 49.51, ["Fly|Ride"] = 104.66, ["Neon"] = 262.5, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 757.32, ["Fly"] = 927.75, ["Ride"] = 784.88, ["Fly|Ride"] = 892.5, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2139.38, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 734.9}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4823.43, ["Ride"] = 6161.71, ["Fly|Ride"] = 5118.75, ["Neon"] = 42000, ["Neon|Ride"] = 29446.78, ["Neon|Fly|Ride"] = 18493.5, ["Mega|Fly|Ride"] = 87673.51}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 313.38, ["Fly"] = 410.99, ["Ride"] = 393.75, ["Neon"] = 1643.87, ["Neon|Ride"] = 2054.84, ["Neon|Fly|Ride"] = 2054.84, ["Mega"] = 6163.48, ["Mega|Fly|Ride"] = 6164.51}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 83.6, ["Fly"] = 274.34, ["Ride"] = 118.13, ["Fly|Ride"] = 336, ["Neon"] = 466.47, ["Neon|Ride"] = 648.32, ["Neon|Fly|Ride"] = 548.66, ["Mega|Fly|Ride"] = 2119.51}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.02, ["Fly"] = 41.11, ["Ride"] = 37.69, ["Fly|Ride"] = 96.59, ["Neon"] = 113.19, ["Neon|Fly"] = 1240.49, ["Neon|Ride"] = 124.26, ["Neon|Fly|Ride"] = 152.07, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 15.43, ["Fly"] = 26.24, ["Ride"] = 21, ["Fly|Ride"] = 44.35, ["Neon"] = 205.5, ["Neon|Ride"] = 310.43, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2192.52}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.32, ["Fly"] = 274.34, ["Ride"] = 27.56, ["Fly|Ride"] = 140.44, ["Neon"] = 144.17, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 670.69, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.93, ["Fly"] = 76.05, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 31.38, ["Neon|Ride"] = 54.65, ["Neon|Fly|Ride"] = 129.47, ["Mega"] = 274.34, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.15, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 178.78, ["Neon|Fly"] = 821.94, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 365.77, ["Mega"] = 821.94, ["Mega|Ride"] = 685.3}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 367.5, ["Fly"] = 420, ["Ride"] = 393.75, ["Fly|Ride"] = 481.27, ["Neon"] = 1561.69, ["Neon|Ride"] = 1370.58, ["Neon|Fly|Ride"] = 1351.88, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 11625.88}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.63, ["Fly"] = 18.38, ["Ride"] = 14.8, ["Fly|Ride"] = 29.85, ["Neon"] = 19.5, ["Neon|Ride"] = 32.6, ["Neon|Fly|Ride"] = 82.21, ["Mega"] = 821.94, ["Mega|Ride"] = 310.43, ["Mega|Fly|Ride"] = 248.81}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 54.87, ["Fly"] = 97.63, ["Ride"] = 79.9, ["Fly|Ride"] = 154.33, ["Neon"] = 210, ["Neon|Fly"] = 287.69, ["Neon|Ride"] = 206.54, ["Neon|Fly|Ride"] = 247.7, ["Mega"] = 575.05, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 566.74}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 767.82, ["Fly"] = 999.85, ["Ride"] = 787.5, ["Fly|Ride"] = 892.49, ["Neon|Ride"] = 1603.88, ["Neon|Fly|Ride"] = 1704.9, ["Mega|Fly|Ride"] = 3933.57}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 68.85, ["Fly"] = 165.37, ["Ride"] = 47.7, ["Fly|Ride"] = 65.63, ["Neon|Ride"] = 235.28, ["Neon|Fly|Ride"] = 232.82, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 315, ["Fly"] = 297.64, ["Ride"] = 336, ["Fly|Ride"] = 381.94, ["Neon|Ride"] = 1395.12, ["Neon|Fly|Ride"] = 1370.58}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 175.4, ["Fly"] = 269.19, ["Ride"] = 183.75, ["Fly|Ride"] = 199.49, ["Neon"] = 633.63, ["Neon|Ride"] = 801.41, ["Neon|Fly|Ride"] = 767.49, ["Mega|Fly|Ride"] = 3473.01}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 720.3, ["Ride"] = 708.74, ["Fly|Ride"] = 786.19, ["Neon|Ride"] = 3426.45, ["Neon|Fly|Ride"] = 2986.71, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 18.61, ["Ride"] = 43.22, ["Fly|Ride"] = 110.25, ["Neon"] = 78.08, ["Neon|Fly"] = 279.04, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 269.74, ["Mega"] = 354.38, ["Mega|Ride"] = 388.32, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.48, ["Ride"] = 3936.19, ["Fly|Ride"] = 3458.43, ["Neon"] = 13699.58, ["Neon|Fly|Ride"] = 6980.28, ["Mega|Fly|Ride"] = 24448.35}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 118.13, ["Fly"] = 166.28, ["Ride"] = 133.59, ["Fly|Ride"] = 203.88, ["Neon"] = 550.97, ["Neon|Ride"] = 590.78, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2300.41}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 27.32, ["Ride"] = 19.74, ["Fly|Ride"] = 37.97, ["Neon"] = 20.15, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 105, ["Mega"] = 137.69, ["Mega|Fly"] = 164.4, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 273.3}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.86, ["Ride"] = 22.6, ["Fly|Ride"] = 57.7, ["Neon"] = 18.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 161.44, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 343.17}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 34.28, ["Fly"] = 37.49, ["Ride"] = 37.58, ["Fly|Ride"] = 56.35, ["Neon|Fly|Ride"] = 538.13, ["Mega|Fly|Ride"] = 1143.19}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 1150.72, ["Ride"] = 1221.42, ["Fly|Ride"] = 1299.64}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6562.5, ["Fly|Ride"] = 8219.34}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21, ["Fly"] = 21, ["Ride"] = 24.81, ["Fly|Ride"] = 55.13, ["Neon"] = 452.13, ["Neon|Ride"] = 178.78, ["Neon|Fly|Ride"] = 143.36, ["Mega"] = 2465.81, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 624.68}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 16.68, ["Fly"] = 41.09, ["Ride"] = 27.43, ["Fly|Ride"] = 61.56, ["Neon"] = 89.24, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 655.54, ["Mega|Ride"] = 664.75, ["Mega|Fly|Ride"] = 524.16}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 69.29, ["Fly"] = 157.49, ["Ride"] = 72.17, ["Fly|Ride"] = 118.01, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 441.48, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1402.61}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 196.88, ["Ride"] = 301.88, ["Fly|Ride"] = 376.69, ["Neon|Ride"] = 977.79, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 10274.17, ["Mega|Fly|Ride"] = 5480.25}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 30.34, ["Fly|Ride"] = 86.63, ["Neon"] = 20.56, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 68.25, ["Mega"] = 143.66, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 283.58}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 196.88, ["Fly"] = 241.46, ["Ride"] = 226.97, ["Fly|Ride"] = 248.59, ["Neon"] = 740.64, ["Neon|Ride"] = 652.44, ["Neon|Fly|Ride"] = 843.93, ["Mega|Fly|Ride"] = 3426.45}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.34, ["Fly"] = 26.25, ["Ride"] = 16.49, ["Fly|Ride"] = 40.86, ["Neon"] = 25.78, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 93.02, ["Mega"] = 415.09, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 171.07, ["Fly"] = 268.82, ["Ride"] = 257.9, ["Fly|Ride"] = 260.97, ["Neon|Fly|Ride"] = 879.38, ["Mega"] = 10274.17, ["Mega|Ride"] = 4109.67, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.5, ["Fly"] = 84.46, ["Ride"] = 19.53, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 295.32, ["Neon|Ride"] = 152.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 478.79, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 408.93}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 23.03, ["Fly|Ride"] = 65.63, ["Neon"] = 9.19, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 177.08, ["Mega"] = 65.63, ["Mega|Ride"] = 113.85, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.05, ["Neon"] = 3.84, ["Mega"] = 19.69, ["Mega|Ride"] = 147.96}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 25.58, ["Fly|Ride"] = 108.18, ["Neon"] = 6.57, ["Neon|Ride"] = 38.62, ["Neon|Fly|Ride"] = 109.95, ["Mega"] = 209.61, ["Mega|Fly"] = 155012.4, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 188.82}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 83.92, ["Fly"] = 139.53, ["Ride"] = 95.97, ["Fly|Ride"] = 178.85, ["Neon"] = 347.06, ["Neon|Fly"] = 282.19, ["Neon|Ride"] = 292.69, ["Neon|Fly|Ride"] = 382.72, ["Mega|Fly|Ride"] = 1140.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.73, ["Ride"] = 15.73, ["Fly|Ride"] = 108.92, ["Neon"] = 5.25, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.77, ["Ride"] = 26.25, ["Neon"] = 69.03, ["Neon|Ride"] = 259.75}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.05, ["Neon"] = 2.63, ["Neon|Ride"] = 51.51, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 16.92, ["Mega|Ride"] = 64.81, ["Mega|Fly|Ride"] = 322.13}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.05, ["Fly"] = 15.75, ["Ride"] = 15.53, ["Fly|Ride"] = 34.94, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.01, ["Neon|Fly|Ride"] = 55.39, ["Mega"] = 12.63, ["Mega|Fly"] = 31.38, ["Mega|Ride"] = 19.28, ["Mega|Fly|Ride"] = 57.07}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 18.15, ["Ride"] = 12.6, ["Fly|Ride"] = 77.07, ["Neon"] = 2.1, ["Neon|Fly"] = 23.55, ["Neon|Ride"] = 13.61, ["Neon|Fly|Ride"] = 34.94, ["Mega"] = 24.94, ["Mega|Ride"] = 41.11, ["Mega|Fly|Ride"] = 77.52}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.05, ["Ride"] = 27.76, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 102.76, ["Mega"] = 147, ["Mega|Ride"] = 77.9}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.84, ["Ride"] = 13.13, ["Fly|Ride"] = 107.62, ["Neon"] = 4.93, ["Neon|Fly"] = 167.95, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 26.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 46.95, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.05, ["Neon"] = 3.94, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 17.07, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 205.5}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 19.68, ["Fly|Ride"] = 70.12, ["Neon"] = 10.69, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 30.75, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 129.72, ["Mega|Fly"] = 343.17, ["Mega|Ride"] = 124.64, ["Mega|Fly|Ride"] = 189.6}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.05, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 13.13, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly|Ride"] = 524.99, ["Neon"] = 16.21, ["Mega"] = 190.31, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 685.3}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 15.89, ["Mega"] = 105, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 3.51, ["Neon|Ride"] = 26.72, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 22.32, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 11.82, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 12.79, ["Neon|Fly|Ride"] = 31.05, ["Mega"] = 12.9, ["Mega|Fly"] = 39.06, ["Mega|Ride"] = 16.89, ["Mega|Fly|Ride"] = 43.29}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 104.98, ["Neon"] = 34.92, ["Neon|Ride"] = 140.94, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 23.16, ["Neon"] = 3.94, ["Neon|Ride"] = 27.91, ["Neon|Fly|Ride"] = 105, ["Mega"] = 25.91, ["Mega|Ride"] = 41.11, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 11.43, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 122.28, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 233.24}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 34.53, ["Fly|Ride"] = 49.88, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 140.19, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.05, ["Fly"] = 11.02, ["Ride"] = 11.65, ["Fly|Ride"] = 18.8, ["Neon"] = 2.1, ["Neon|Fly"] = 13.52, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 17.5, ["Mega|Fly"] = 36.9, ["Mega|Ride"] = 24.73, ["Mega|Fly|Ride"] = 51.07}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 20.56, ["Fly|Ride"] = 131.25, ["Neon"] = 17.46, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 91.77, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 112.03, ["Ride"] = 19.49, ["Fly|Ride"] = 59.06, ["Neon"] = 60.37, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 236.24, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 401.96}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 12.33, ["Fly|Ride"] = 31.86, ["Neon"] = 2.1, ["Neon|Fly"] = 23.62, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 34.49, ["Mega"] = 20.97, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 171.6, ["Ride"] = 28.73, ["Neon"] = 5.92, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 92.48, ["Mega"] = 85.32, ["Mega|Fly"] = 164.4, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 31.86, ["Neon"] = 4.66, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 27.57, ["Mega|Fly"] = 137.69, ["Mega|Ride"] = 129.47, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.66, ["Ride"] = 17.99, ["Neon"] = 2.1, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 15.75, ["Mega|Ride"] = 43.75, ["Mega|Fly|Ride"] = 160.3}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 14.95, ["Fly|Ride"] = 39.38, ["Neon"] = 5.24, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 67.82, ["Mega"] = 65.35, ["Mega|Ride"] = 77.9}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 52.73, ["Neon"] = 4.73, ["Neon|Ride"] = 52.5, ["Mega"] = 35.02, ["Mega|Ride"] = 110.35, ["Mega|Fly|Ride"] = 306.18}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 14.47, ["Fly|Ride"] = 72.19, ["Neon"] = 5.39, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 19.45, ["Neon|Fly|Ride"] = 83.91, ["Mega"] = 76.75, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 191.29}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.76, ["Fly"] = 41.58, ["Ride"] = 36.26, ["Neon"] = 41.91, ["Neon|Ride"] = 74, ["Mega"] = 98.18, ["Mega|Ride"] = 168.38, ["Mega|Fly|Ride"] = 821.94}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.11, ["Fly|Ride"] = 34.94, ["Neon"] = 33.73, ["Neon|Fly"] = 104.53, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 70.83, ["Mega"] = 315, ["Mega|Fly"] = 420}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 16.95, ["Fly|Ride"] = 40.69, ["Neon"] = 15.66, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 274.2, ["Mega|Fly"] = 192.14, ["Mega|Ride"] = 180.85, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly|Ride"] = 137.69, ["Neon"] = 54.94, ["Neon|Ride"] = 101.16, ["Mega"] = 215.92, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.87, ["Ride"] = 56.44, ["Neon"] = 262.4, ["Neon|Ride"] = 205.5, ["Mega|Ride"] = 685.3}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 137.68, ["Neon"] = 41.11, ["Neon|Ride"] = 125.71, ["Mega"] = 254.82, ["Mega|Ride"] = 306.48}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.16, ["Ride"] = 30.19, ["Fly|Ride"] = 120.75, ["Neon"] = 53.39, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 178.78, ["Mega"] = 465.05, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 257.17}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.05, ["Neon"] = 3.9, ["Neon|Ride"] = 64.98, ["Mega"] = 22.32, ["Mega|Fly"] = 123.31, ["Mega|Ride"] = 123.31, ["Mega|Fly|Ride"] = 153.57}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.44, ["Fly"] = 19.91, ["Ride"] = 20.15, ["Fly|Ride"] = 121.03, ["Neon"] = 45.93, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 374.32, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 295.14}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 19.69, ["Fly|Ride"] = 37.01, ["Neon"] = 2.79, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 26.73, ["Neon|Fly|Ride"] = 153.48, ["Mega"] = 31.29, ["Mega|Fly"] = 137.69, ["Mega|Ride"] = 68.85, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 32.89, ["Neon"] = 4.31, ["Neon|Ride"] = 33, ["Mega"] = 37.94, ["Mega|Ride"] = 73.41, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 48.3, ["Ride"] = 17.82, ["Fly|Ride"] = 55.65, ["Neon"] = 7.77, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 116.24, ["Mega"] = 123.31, ["Mega|Ride"] = 155.8}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 5.16, ["Ride"] = 36.67, ["Neon"] = 47.16, ["Neon|Ride"] = 49.55, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.13, ["Mega|Ride"] = 275.45, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Fly"] = 82.21, ["Ride"] = 32.81, ["Neon"] = 3.29, ["Mega"] = 18.03, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.67, ["Ride"] = 14.44, ["Fly|Ride"] = 273977.92, ["Neon"] = 3.93, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 21, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 124.66}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 16.41, ["Fly|Ride"] = 32.82, ["Neon"] = 3.29, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 18.14, ["Neon|Fly|Ride"] = 47.91, ["Mega"] = 47.95, ["Mega|Fly"] = 137.69, ["Mega|Ride"] = 53.44, ["Mega|Fly|Ride"] = 94.65}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 46.78, ["Fly|Ride"] = 147.67, ["Neon"] = 4.64, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 111.45, ["Mega"] = 29.75, ["Mega|Ride"] = 79.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 164.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 22.3, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.87, ["Ride"] = 20.9, ["Fly|Ride"] = 45.94, ["Neon"] = 2.2, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 83.72, ["Mega"] = 19.48, ["Mega|Fly"] = 61.66, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 116.01}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.05, ["Ride"] = 24.68, ["Neon"] = 2.1, ["Neon|Ride"] = 36.66, ["Mega"] = 21.42, ["Mega|Ride"] = 409.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.57, ["Neon"] = 6.35, ["Neon|Ride"] = 295.26, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.41, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.05, ["Fly"] = 26.25, ["Ride"] = 12.5, ["Fly|Ride"] = 41.11, ["Neon"] = 3.88, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17, ["Neon|Fly|Ride"] = 136.49, ["Mega"] = 123.3, ["Mega|Ride"] = 49.5, ["Mega|Fly|Ride"] = 93.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.57, ["Ride"] = 186.02, ["Neon"] = 135.63, ["Mega"] = 1027.44, ["Mega|Ride"] = 665.44, ["Mega|Fly|Ride"] = 671.51}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 56.24, ["Neon"] = 42, ["Mega"] = 1643.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.19, ["Fly|Ride"] = 410.92, ["Neon"] = 41.11, ["Neon|Ride"] = 93.51, ["Neon|Fly|Ride"] = 260.97, ["Mega"] = 397.95, ["Mega|Ride"] = 351.39, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.05, ["Fly"] = 12.9, ["Ride"] = 10.5, ["Fly|Ride"] = 22.83, ["Neon"] = 2.1, ["Neon|Fly"] = 13.13, ["Neon|Ride"] = 11.46, ["Neon|Fly|Ride"] = 27.76, ["Mega"] = 14.22, ["Mega|Fly"] = 105, ["Mega|Ride"] = 19.65, ["Mega|Fly|Ride"] = 93.51}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Ride"] = 57.54, ["Fly|Ride"] = 154.12, ["Neon"] = 9.21, ["Neon|Fly"] = 67.76, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 685.3, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.05, ["Ride"] = 31.01, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 22.14, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 13.13, ["Mega|Fly|Ride"] = 130.49}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 123.31, ["Mega"] = 17.3, ["Mega|Ride"] = 110.98, ["Mega|Fly|Ride"] = 164.4}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 40.98, ["Ride"] = 16.67, ["Fly|Ride"] = 42.69, ["Neon"] = 9.22, ["Neon|Ride"] = 30.86, ["Neon|Fly|Ride"] = 95.36, ["Mega"] = 208.95, ["Mega|Ride"] = 390.43, ["Mega|Fly|Ride"] = 381.35}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 161.1, ["Ride"] = 191.13, ["Fly|Ride"] = 199.5, ["Neon"] = 525, ["Mega"] = 8219.34, ["Mega|Fly|Ride"] = 3877.25}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 18.51, ["Neon"] = 10.4, ["Neon|Ride"] = 64.32, ["Mega"] = 91.87, ["Mega|Ride"] = 163.37, ["Mega|Fly|Ride"] = 775.46}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 7.77, ["Fly"] = 64.97, ["Ride"] = 25.58, ["Fly|Ride"] = 65.63, ["Neon"] = 52.5, ["Neon|Ride"] = 93.01, ["Neon|Fly|Ride"] = 164.4, ["Mega"] = 356.43, ["Mega|Ride"] = 512.7, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 14.8, ["Ride"] = 13.55, ["Fly|Ride"] = 32.69, ["Neon"] = 6.57, ["Neon|Fly"] = 31.86, ["Neon|Ride"] = 29.34, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 49.68, ["Mega|Ride"] = 78.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.68, ["Fly|Ride"] = 92.56, ["Neon"] = 6.14, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 168.52, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.56, ["Fly"] = 22.72, ["Ride"] = 14.6, ["Fly|Ride"] = 31.29, ["Neon"] = 34.13, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 74.83, ["Mega|Ride"] = 270.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.41, ["Ride"] = 62.91, ["Fly|Ride"] = 249.58, ["Neon"] = 77.99, ["Neon|Ride"] = 56.81, ["Neon|Fly|Ride"] = 610.31, ["Mega"] = 410.99, ["Mega|Ride"] = 271.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.44, ["Fly|Ride"] = 34.13, ["Neon"] = 18.8, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 72.18, ["Mega|Ride"] = 238.37, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 70.74, ["Fly"] = 102.76, ["Ride"] = 78.75, ["Fly|Ride"] = 137.82, ["Neon"] = 377.08, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 319.3, ["Neon|Fly|Ride"] = 375.09, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 328.79, ["Ride"] = 249.23, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 2568.56, ["Neon|Fly|Ride"] = 1232.65, ["Mega"] = 10274.17, ["Mega|Fly|Ride"] = 4658.32}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 55.29, ["Fly"] = 137.68, ["Ride"] = 68.85, ["Fly|Ride"] = 109.95, ["Neon"] = 697.57, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 397.47, ["Mega|Fly|Ride"] = 1182.57}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.12, ["Fly"] = 96.59, ["Ride"] = 31.86, ["Fly|Ride"] = 137.69, ["Neon"] = 25.64, ["Neon|Ride"] = 100.01, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 309.72, ["Mega|Ride"] = 379.32, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 15.43, ["Fly"] = 68.85, ["Ride"] = 32.86, ["Fly|Ride"] = 59.04, ["Neon"] = 81.2, ["Neon|Ride"] = 291.37, ["Neon|Fly|Ride"] = 263.92, ["Mega"] = 353.07, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 457.84}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 16.46, ["Fly|Ride"] = 34.94, ["Neon"] = 2.1, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 19.92, ["Neon|Fly|Ride"] = 58.22, ["Mega"] = 49.88, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 310.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.76, ["Fly"] = 72.12, ["Ride"] = 19.69, ["Fly|Ride"] = 81.38, ["Neon"] = 108.15, ["Neon|Ride"] = 101.73, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 413.44, ["Mega|Ride"] = 817.84, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 20.56, ["Ride"] = 13.54, ["Fly|Ride"] = 39.58, ["Neon"] = 11.82, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 28.65, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 190.68, ["Mega|Ride"] = 211.18, ["Mega|Fly|Ride"] = 171.42}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 328.13, ["Neon"] = 19.69, ["Neon|Ride"] = 57.75, ["Mega"] = 178.78, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 369.89}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 15.43, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 15.61, ["Mega|Ride"] = 35.98, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.26, ["Fly"] = 18.1, ["Ride"] = 18.17, ["Fly|Ride"] = 41.11, ["Neon"] = 14.13, ["Neon|Fly"] = 36.75, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 147, ["Mega"] = 84, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 154.58}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.88, ["Fly"] = 24.94, ["Ride"] = 18.52, ["Fly|Ride"] = 61.01, ["Neon"] = 25.78, ["Neon|Ride"] = 47.25, ["Mega"] = 260.97, ["Mega|Ride"] = 123.31, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 163.16, ["Fly"] = 410.99, ["Ride"] = 236.25, ["Fly|Ride"] = 276.71, ["Neon"] = 685.21, ["Neon|Ride"] = 685.3, ["Neon|Fly|Ride"] = 612.5, ["Mega"] = 4109.67, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.79, ["Ride"] = 31.86, ["Fly|Ride"] = 124.41, ["Neon"] = 123.31, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 376.56, ["Mega"] = 410.99, ["Mega|Ride"] = 371.43, ["Mega|Fly|Ride"] = 385.86}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 15.38, ["Fly|Ride"] = 41.11, ["Neon"] = 18.38, ["Neon|Ride"] = 26.54, ["Neon|Fly|Ride"] = 104.81, ["Mega"] = 312.36, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.37, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 85.32, ["Neon|Ride"] = 290.77, ["Neon|Fly|Ride"] = 492.91, ["Mega"] = 543.1, ["Mega|Fly"] = 821.94, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 1027.44}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 5.25}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 115.12, ["Neon"] = 38.99, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 343.17, ["Mega"] = 343.17, ["Mega|Ride"] = 384.27, ["Mega|Fly|Ride"] = 897.98}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 24.94, ["Fly"] = 34.94, ["Ride"] = 32.82, ["Fly|Ride"] = 50.44, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 168.87, ["Mega"] = 2054.84, ["Mega|Fly|Ride"] = 2054.84}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 18.29, ["Fly|Ride"] = 102.76, ["Neon"] = 2.1, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 106.26, ["Mega"] = 19.69, ["Mega|Fly"] = 274.34, ["Mega|Ride"] = 72.71, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 23.64, ["Fly|Ride"] = 61.66, ["Neon"] = 17.46, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 232.54, ["Mega"] = 233.21, ["Mega|Fly"] = 388.32, ["Mega|Ride"] = 205.5, ["Mega|Fly|Ride"] = 363.72}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.51, ["Fly|Ride"] = 34.94, ["Neon"] = 12.15, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.9, ["Neon|Fly|Ride"] = 64.37, ["Mega"] = 182.88, ["Mega|Ride"] = 138.21, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 205.5, ["Neon"] = 3.68, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 26.81, ["Mega|Ride"] = 55.04, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 66.04, ["Ride"] = 87.94, ["Fly|Ride"] = 262.5, ["Neon"] = 223.12, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 799.99, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 941.5}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.34, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 91.32, ["Neon|Ride"] = 137.69, ["Mega|Ride"] = 524.99}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.94, ["Fly"] = 29.54, ["Ride"] = 18.23, ["Fly|Ride"] = 67.77, ["Neon"] = 26.71, ["Neon|Fly"] = 315, ["Neon|Ride"] = 38.73, ["Neon|Fly|Ride"] = 109.3, ["Mega"] = 343.39, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.79, ["Fly"] = 433.12, ["Ride"] = 164.4, ["Fly|Ride"] = 262.46, ["Neon"] = 328.13, ["Neon|Ride"] = 534.27, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1788.22}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.77, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 57.65, ["Neon"] = 43.6, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 199.34, ["Mega"] = 218.1, ["Mega|Ride"] = 294.88, ["Mega|Fly|Ride"] = 680.17}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 65.63, ["Fly"] = 142.83, ["Ride"] = 84, ["Fly|Ride"] = 120.93, ["Neon"] = 262.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 405.85, ["Mega"] = 1066.47, ["Mega|Ride"] = 975.74, ["Mega|Fly|Ride"] = 1019.03}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 55.23, ["Ride"] = 58.46, ["Fly|Ride"] = 199.5, ["Neon"] = 78.57, ["Neon|Ride"] = 112.95, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 476.6, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 439.04}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 7.23, ["Fly"] = 104.13, ["Ride"] = 27.74, ["Fly|Ride"] = 48.3, ["Neon"] = 82.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 248.81, ["Mega"] = 416.96, ["Mega|Fly|Ride"] = 520.91}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 13.13, ["Ride"] = 45.66, ["Fly|Ride"] = 274.34, ["Neon"] = 65.63, ["Neon|Ride"] = 259.88, ["Neon|Fly|Ride"] = 274.33, ["Mega"] = 283.82, ["Mega|Ride"] = 279.05, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.46, ["Ride"] = 26.17, ["Fly|Ride"] = 65.19, ["Neon"] = 29.31, ["Neon|Ride"] = 56.59, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 236.25, ["Mega|Ride"] = 567, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.05, ["Neon"] = 2.37, ["Neon|Ride"] = 57.1, ["Mega"] = 24.94, ["Mega|Ride"] = 123.31, ["Mega|Fly|Ride"] = 405.85}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.28, ["Ride"] = 28.42, ["Neon"] = 22.32, ["Neon|Fly"] = 123.31, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 177.61, ["Mega|Ride"] = 246.6, ["Mega|Fly|Ride"] = 439.74}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Neon"] = 25.83, ["Mega"] = 347.17, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 6.18, ["Ride"] = 32.79, ["Fly|Ride"] = 116.28, ["Neon"] = 20.46, ["Neon|Ride"] = 82.95, ["Mega"] = 123.44, ["Mega|Ride"] = 274.34, ["Mega|Fly|Ride"] = 524.9}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 562.14, ["Ride"] = 616.88, ["Fly|Ride"] = 656.23, ["Neon"] = 1746.63, ["Neon|Ride"] = 1784.04, ["Neon|Fly|Ride"] = 1753.82, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 8.24, ["Fly"] = 27.76, ["Ride"] = 19.19, ["Fly|Ride"] = 62.79, ["Neon"] = 37.01, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 155.8, ["Mega|Ride"] = 355.77, ["Mega|Fly|Ride"] = 493.18}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.29, ["Fly"] = 524.69, ["Ride"] = 31.13, ["Fly|Ride"] = 51.54, ["Neon"] = 48.57, ["Neon|Fly"] = 315, ["Neon|Ride"] = 88.37, ["Neon|Fly|Ride"] = 156.4, ["Mega"] = 331.84, ["Mega|Ride"] = 380.16, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 22.51, ["Fly|Ride"] = 308.23, ["Neon"] = 13.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 263.92, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.58, ["Ride"] = 21, ["Fly|Ride"] = 90.57, ["Neon"] = 7.88, ["Neon|Ride"] = 36.83, ["Neon|Fly|Ride"] = 101.25, ["Mega"] = 60.13, ["Mega|Fly"] = 211.78, ["Mega|Ride"] = 109.95, ["Mega|Fly|Ride"] = 376.05}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.05, ["Fly"] = 68.85, ["Ride"] = 19.69, ["Neon"] = 2.63, ["Neon|Ride"] = 19.45, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 22.61, ["Mega|Ride"] = 62.91, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1050}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.04, ["Ride"] = 36.75, ["Fly|Ride"] = 323.65, ["Neon"] = 57.74, ["Neon|Ride"] = 104.7, ["Neon|Fly|Ride"] = 274.34, ["Mega|Ride"] = 546.59, ["Mega|Fly|Ride"] = 589.75}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.05, ["Ride"] = 25.58, ["Neon"] = 3.94, ["Neon|Ride"] = 74, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.26, ["Mega|Ride"] = 164.4, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.13, ["Fly"] = 41.01, ["Ride"] = 96.59, ["Neon"] = 15.75, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.73, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 377.08}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 507.94, ["Fly|Ride"] = 560.06, ["Neon|Ride"] = 1643.87, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.72, ["Fly"] = 196.88, ["Ride"] = 59.07, ["Fly|Ride"] = 410.99, ["Neon"] = 35.44, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 186.02, ["Mega"] = 479.82, ["Mega|Ride"] = 441.8}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 88.87, ["Ride"] = 23.57, ["Fly|Ride"] = 118.13, ["Neon"] = 3.84, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 103.69, ["Mega|Fly"] = 205.48, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.05, ["Neon"] = 3.84, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 30.17, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 369.89}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 12.29, ["Fly"] = 107.63, ["Ride"] = 68.85, ["Fly|Ride"] = 87.28, ["Neon"] = 98.44, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 369.89, ["Mega"] = 453.11, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 595.88}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.61, ["Neon"] = 80.22, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 821.94, ["Mega"] = 540.44, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 534.27}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.03, ["Ride"] = 31.39, ["Fly|Ride"] = 131.25, ["Neon"] = 310.43, ["Neon|Ride"] = 175.56, ["Mega"] = 635.95, ["Mega|Ride"] = 1055.17, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.23, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 656.25, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 199.29, ["Mega"] = 610.32, ["Mega|Ride"] = 649.04, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 340.86, ["Ride"] = 443.63, ["Fly|Ride"] = 748.72, ["Neon"] = 918.75, ["Neon|Ride"] = 1016.13, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.2, ["Fly"] = 78.73, ["Ride"] = 20.01, ["Fly|Ride"] = 236.25, ["Neon"] = 127.15, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 205.26, ["Mega|Ride"] = 548.66, ["Mega|Fly|Ride"] = 848.67}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.62, ["Ride"] = 125.99, ["Neon"] = 41.11, ["Neon|Ride"] = 105, ["Mega"] = 217.83, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 787.49}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 20.35, ["Ride"] = 70.81, ["Fly|Ride"] = 256.94, ["Neon"] = 89.14, ["Neon|Ride"] = 123.22, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 262.5, ["Mega|Fly"] = 685.3, ["Mega|Ride"] = 287.44, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.5, ["Ride"] = 52.5, ["Fly|Ride"] = 137.69, ["Neon"] = 6.33, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 236.32, ["Mega"] = 47.13, ["Mega|Ride"] = 129.44, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.38, ["Ride"] = 72.62, ["Neon"] = 318.51, ["Neon|Ride"] = 359.62, ["Mega"] = 1627.63, ["Mega|Ride"] = 1370.58, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 581.32, ["Ride"] = 25.18, ["Neon"] = 6.57, ["Neon|Fly"] = 178.78, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 112.02, ["Mega"] = 63.54, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 246.6}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 30.19, ["Fly|Ride"] = 155.93, ["Neon"] = 5.16, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 47.15, ["Neon|Fly|Ride"] = 117.13, ["Mega"] = 35.16, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 73.49, ["Mega|Fly|Ride"] = 255.29}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.05, ["Ride"] = 37.97, ["Fly|Ride"] = 262.4, ["Neon"] = 13.31, ["Neon|Ride"] = 59.6, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.38, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 1507.24}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 70.68, ["Fly"] = 93.02, ["Ride"] = 60.24, ["Fly|Ride"] = 155.8, ["Neon"] = 282.72, ["Neon|Ride"] = 300.38, ["Neon|Fly|Ride"] = 412.56, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.35, ["Ride"] = 268.7, ["Fly|Ride"] = 410.99, ["Neon"] = 1428.12, ["Neon|Ride"] = 1134.7, ["Neon|Fly|Ride"] = 1278.86, ["Mega"] = 9300.71, ["Mega|Fly|Ride"] = 4311.57}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 4.06, ["Neon"] = 41.11, ["Mega"] = 112.88, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 392.49}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 24.68, ["Neon"] = 8.14, ["Neon|Ride"] = 44.1, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 64.32, ["Mega|Fly"] = 210, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6, ["Fly"] = 155.57, ["Ride"] = 27.56, ["Neon"] = 32.81, ["Neon|Ride"] = 68.85, ["Mega"] = 132.76, ["Mega|Ride"] = 348.23}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 69.29, ["Ride"] = 47.25, ["Neon"] = 9.19, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 115.5, ["Mega|Ride"] = 127.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 90.43, ["Neon"] = 7.58, ["Mega"] = 39.38, ["Mega|Fly"] = 137.69, ["Mega|Fly|Ride"] = 271.25}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 18.51, ["Ride"] = 16.71, ["Fly|Ride"] = 49.88, ["Neon"] = 7, ["Neon|Ride"] = 22.61, ["Neon|Fly|Ride"] = 410.99, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 137.61, ["Ride"] = 24.94, ["Fly|Ride"] = 61.66, ["Neon"] = 17.75, ["Neon|Fly"] = 64.97, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 93.28, ["Mega"] = 123.31, ["Mega|Ride"] = 232.21, ["Mega|Fly|Ride"] = 428.3}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 27.53, ["Ride"] = 30.74, ["Fly|Ride"] = 107.52, ["Neon"] = 137.69, ["Neon|Fly|Ride"] = 155.76, ["Mega"] = 1130.17, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 548.94}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 58.98, ["Ride"] = 77.86, ["Fly|Ride"] = 137.69, ["Neon"] = 393.75, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 504.48, ["Mega"] = 1470, ["Mega|Ride"] = 3254.99, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.87, ["Fly|Ride"] = 131.25, ["Neon"] = 3.89, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 40.69, ["Mega|Fly"] = 88.37, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 12.27, ["Ride"] = 13.44, ["Fly|Ride"] = 39.36, ["Neon"] = 4.75, ["Neon|Fly"] = 28.37, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 61.67, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 65.62, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.81, ["Ride"] = 73.48, ["Neon"] = 35.65, ["Neon|Ride"] = 93.02, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 527.63, ["Mega|Ride"] = 479.82}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 383.77, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 498.75, ["Neon"] = 4109.67, ["Neon|Ride"] = 1919.24, ["Mega|Fly|Ride"] = 7191.93}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 22.56, ["Fly"] = 101.33, ["Ride"] = 41.11, ["Fly|Ride"] = 55.5, ["Neon"] = 204.95, ["Neon|Ride"] = 154.3, ["Neon|Fly|Ride"] = 305.81, ["Mega|Ride"] = 1132.38, ["Mega|Fly|Ride"] = 906.83}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 281.29, ["Neon"] = 7.82, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 96.59, ["Mega"] = 98.44, ["Mega|Ride"] = 126.99, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 26.25, ["Fly|Ride"] = 142.94, ["Neon"] = 13.11, ["Neon|Ride"] = 68.85}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 23.63, ["Fly"] = 165.92, ["Ride"] = 45.11, ["Fly|Ride"] = 82.21, ["Neon"] = 194.25, ["Neon|Ride"] = 260.97, ["Neon|Fly|Ride"] = 264.99, ["Mega"] = 2465.81, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1191.81}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 75.08, ["Ride"] = 107.85, ["Fly|Ride"] = 204.47, ["Neon"] = 434.43, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 610.31, ["Mega"] = 8219.34, ["Mega|Fly|Ride"] = 6164.51}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 246.6, ["Ride"] = 271.3, ["Fly|Ride"] = 513.64, ["Neon"] = 1050, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1232.91, ["Mega|Fly|Ride"] = 3554.87}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.32, ["Fly"] = 51.19, ["Ride"] = 20.56, ["Fly|Ride"] = 102.76, ["Neon"] = 82.69, ["Neon|Ride"] = 95.71, ["Neon|Fly|Ride"] = 202.26, ["Mega"] = 388.49, ["Mega|Ride"] = 344.55, ["Mega|Fly|Ride"] = 435.63}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 17.3, ["Ride"] = 13.64, ["Fly|Ride"] = 41.91, ["Neon"] = 7.44, ["Neon|Ride"] = 21.54, ["Neon|Fly|Ride"] = 91.11, ["Mega"] = 109.3, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 166.41}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.63, ["Fly"] = 38.63, ["Ride"] = 15.88, ["Fly|Ride"] = 48.57, ["Neon"] = 30.35, ["Neon|Fly"] = 105, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 108.91, ["Mega"] = 376.05, ["Mega|Fly|Ride"] = 288.93}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 334.68, ["Fly"] = 479.82, ["Ride"] = 298.86, ["Fly|Ride"] = 577.42, ["Neon"] = 1575, ["Neon|Ride"] = 2150.35, ["Neon|Fly|Ride"] = 1781.55, ["Mega"] = 9863.21, ["Mega|Fly|Ride"] = 5573.88}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 155.8, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 447.99}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 5.25, ["Fly"] = 41.11, ["Ride"] = 15.73, ["Fly|Ride"] = 50.16, ["Neon"] = 20.95, ["Neon|Fly"] = 72.97, ["Neon|Ride"] = 37.54, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 223.99, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 179.47, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 65.63, ["Ride"] = 46.18, ["Neon"] = 178.78, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 527.69, ["Mega|Ride"] = 649.66, ["Mega|Fly|Ride"] = 538.13}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 158.81, ["Fly"] = 157.5, ["Ride"] = 115.5, ["Fly|Ride"] = 152.64, ["Neon"] = 635.99, ["Neon|Ride"] = 694.45, ["Neon|Fly|Ride"] = 586.34, ["Mega|Fly|Ride"] = 2378.25}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.9, ["Fly"] = 41.11, ["Ride"] = 26.25, ["Fly|Ride"] = 55.55, ["Neon"] = 103.69, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 152.07, ["Mega"] = 685.3, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 549.15}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.05, ["Ride"] = 20.65, ["Neon"] = 2.5, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 685.3, ["Mega"] = 19.69, ["Mega|Ride"] = 274.34}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.54, ["Fly|Ride"] = 70.17, ["Neon"] = 2.63, ["Neon|Ride"] = 19.85, ["Neon|Fly|Ride"] = 74.46, ["Mega"] = 26.25, ["Mega|Fly"] = 87.64, ["Mega|Ride"] = 39.16, ["Mega|Fly|Ride"] = 110.82}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.09, ["Fly"] = 410.99, ["Ride"] = 78.75, ["Fly|Ride"] = 135.48, ["Neon"] = 31.5, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 192.34, ["Mega"] = 164.24, ["Mega|Fly"] = 274.34, ["Mega|Ride"] = 204.47, ["Mega|Fly|Ride"] = 382.22}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.12, ["Fly"] = 1604.38, ["Ride"] = 1285.09, ["Fly|Ride"] = 1479.13, ["Neon"] = 4200, ["Neon|Ride"] = 3609.38, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12481.88}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 437.33, ["Fly"] = 918.75, ["Ride"] = 577.4, ["Fly|Ride"] = 637.02, ["Neon"] = 2412.39, ["Neon|Ride"] = 2562, ["Neon|Fly|Ride"] = 1917.17, ["Mega"] = 16438.67, ["Mega|Fly|Ride"] = 9315.59}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 328.13, ["Ride"] = 385.59, ["Fly|Ride"] = 472.5, ["Neon"] = 871.84, ["Neon|Ride"] = 791.11, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2916.22}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 308.23, ["Fly"] = 410.99, ["Ride"] = 388.38, ["Fly|Ride"] = 445.68, ["Neon"] = 959.62, ["Neon|Fly"] = 2054.84, ["Neon|Ride"] = 1643.87, ["Neon|Fly|Ride"] = 1948}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.63, ["Fly|Ride"] = 36.92, ["Neon"] = 6.09, ["Neon|Ride"] = 48.47, ["Neon|Fly|Ride"] = 105, ["Mega"] = 68.52, ["Mega|Fly"] = 96.59, ["Mega|Ride"] = 1617.16, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 388.32, ["Fly"] = 1370.58, ["Ride"] = 437.7, ["Fly|Ride"] = 593.85, ["Neon"] = 1706.24, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1159.83, ["Mega|Ride"] = 6575.47, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.05, ["Fly"] = 157.5, ["Ride"] = 97.65, ["Neon"] = 16.42, ["Neon|Ride"] = 54.93, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 97.95, ["Mega|Ride"] = 178.66, ["Mega|Fly|Ride"] = 498.74}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.05, ["Fly|Ride"] = 31.98, ["Neon"] = 7.84, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.49, ["Neon|Ride"] = 39.37, ["Mega"] = 29.47, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 45.3, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 671.95, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 41.11, ["Ride"] = 26.73, ["Fly|Ride"] = 68.24, ["Neon"] = 32.71, ["Mega|Ride"] = 423.21, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.1, ["Neon|Ride"] = 39.92, ["Neon|Fly|Ride"] = 93.94, ["Mega"] = 22.32, ["Mega|Ride"] = 90.43, ["Mega|Fly|Ride"] = 123.2}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.63, ["Fly"] = 34.13, ["Ride"] = 16.3, ["Fly|Ride"] = 78.65, ["Neon"] = 9.72, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 43.13, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 103.69, ["Mega|Fly"] = 279.04, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.16, ["Fly"] = 55.5, ["Ride"] = 22.32, ["Fly|Ride"] = 51.98, ["Neon"] = 27.57, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 326.73}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.69, ["Ride"] = 60.64, ["Neon"] = 76.05, ["Mega"] = 410.99, ["Mega|Ride"] = 328.79, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6201.24, ["Ride"] = 27.76, ["Neon"] = 37.79, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 439.74, ["Mega|Ride"] = 479.82, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 98.65, ["Ride"] = 18.16, ["Fly|Ride"] = 45.94, ["Neon"] = 3.94, ["Neon|Fly"] = 82.48, ["Neon|Ride"] = 24.45, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 57.54, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 136.5, ["Ride"] = 178.5, ["Fly|Ride"] = 227.08, ["Neon|Ride"] = 883.6, ["Neon|Fly|Ride"] = 1027.44, ["Mega"] = 8219.34, ["Mega|Ride"] = 4109.67, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 18.33, ["Ride"] = 13.54, ["Fly|Ride"] = 34.94, ["Neon"] = 3.05, ["Neon|Ride"] = 20.56, ["Neon|Fly|Ride"] = 54.02, ["Mega"] = 40.69, ["Mega|Ride"] = 52.64, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 4.87, ["Fly"] = 137.69, ["Ride"] = 42.37, ["Fly|Ride"] = 160.12, ["Neon"] = 260.97, ["Neon|Ride"] = 133.84, ["Mega"] = 312.38, ["Mega|Ride"] = 271.1, ["Mega|Fly|Ride"] = 1027.44}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 51.1, ["Ride"] = 274.34, ["Fly|Ride"] = 170.63, ["Neon"] = 155.66, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 227.08, ["Mega"] = 890.78, ["Mega|Ride"] = 906.83, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 167.14, ["Ride"] = 253.32, ["Fly|Ride"] = 242.43, ["Neon"] = 708.74, ["Neon|Ride"] = 912.36, ["Neon|Fly|Ride"] = 924.69, ["Mega|Fly|Ride"] = 3389.46}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 16.05, ["Neon"] = 96.59, ["Mega"] = 284.57, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 9.18, ["Ride"] = 57.75, ["Fly|Ride"] = 178.78, ["Neon"] = 1438.4, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 771.75, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 959.62}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 984.38, ["Ride"] = 984.38, ["Fly|Ride"] = 1219.56, ["Neon"] = 4658.32, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4622.36, ["Mega|Fly|Ride"] = 17941.79}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 8.7, ["Fly"] = 19.58, ["Ride"] = 19.56, ["Fly|Ride"] = 43.32, ["Neon"] = 15.75, ["Neon|Fly"] = 89.32, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 232.54, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.84, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 32.87, ["Neon|Ride"] = 81.18, ["Mega"] = 244.62, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 242.06}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 81.18, ["Ride"] = 24.86, ["Fly|Ride"] = 69.57, ["Neon"] = 8.97, ["Neon|Ride"] = 68.85, ["Mega"] = 91.88, ["Mega|Ride"] = 201.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.97, ["Ride"] = 29.47, ["Fly|Ride"] = 81.08, ["Neon"] = 65.63, ["Neon|Ride"] = 79.72, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 437.07, ["Mega|Ride"] = 363.2, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.63, ["Fly"] = 20.46, ["Ride"] = 18.38, ["Fly|Ride"] = 41.11, ["Neon"] = 17.07, ["Neon|Fly"] = 43.32, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 93.19, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.46, ["Neon"] = 10.48, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 56.01, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 96.59, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 274.34}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 175.88, ["Ride"] = 322.63, ["Fly|Ride"] = 343.17, ["Neon|Ride"] = 1096.27, ["Neon|Fly|Ride"] = 984.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 22.7, ["Fly|Ride"] = 72.19, ["Neon"] = 6.65, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 119.83, ["Mega"] = 76.33, ["Mega|Fly"] = 410.99, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 260.97}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.52, ["Ride"] = 81.79, ["Fly|Ride"] = 88.86, ["Neon"] = 52.5, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega|Ride"] = 244.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 96.96, ["Ride"] = 26.24, ["Neon"] = 14.34, ["Neon|Ride"] = 1370.58, ["Mega"] = 99.75, ["Mega|Fly"] = 139.53, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 482.32}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 685.3, ["Ride"] = 465.05, ["Fly|Ride"] = 745.5, ["Neon|Ride"] = 1458.19, ["Mega"] = 2790.23, ["Mega|Ride"] = 4931.61, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.1, ["Ride"] = 41.11, ["Fly|Ride"] = 188.03, ["Neon"] = 149.5, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 548.66, ["Mega|Ride"] = 735, ["Mega|Fly|Ride"] = 859.69}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 16.49, ["Fly"] = 74.42, ["Ride"] = 30.97, ["Fly|Ride"] = 90.57, ["Neon"] = 74.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 513.73, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 45.94, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 236.32}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42, ["Fly"] = 68.85, ["Ride"] = 82.21, ["Fly|Ride"] = 176.07, ["Neon"] = 262.48, ["Neon|Fly"] = 258.8, ["Neon|Ride"] = 218.19, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 1187.59}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.45, ["Fly|Ride"] = 52.5, ["Neon"] = 4.81, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 122.28, ["Mega"] = 53.44, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 20.95, ["Fly"] = 137.69, ["Ride"] = 22.32, ["Fly|Ride"] = 83.72, ["Neon"] = 66.2, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 246.6, ["Mega"] = 389.82, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.63, ["Fly"] = 102.76, ["Ride"] = 78.75, ["Fly|Ride"] = 174.67, ["Neon"] = 270.8, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 356.93, ["Mega"] = 1232.91, ["Mega|Ride"] = 1919.24, ["Mega|Fly|Ride"] = 1169.44}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 15.65, ["Ride"] = 13.84, ["Fly|Ride"] = 30.87, ["Neon"] = 2.61, ["Neon|Fly"] = 23.64, ["Neon|Ride"] = 16.46, ["Neon|Fly|Ride"] = 34.94, ["Mega"] = 17.06, ["Mega|Ride"] = 28.77, ["Mega|Fly|Ride"] = 86.63}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.18, ["Ride"] = 52.49, ["Fly|Ride"] = 129.47, ["Neon"] = 15.43, ["Neon|Ride"] = 61.66, ["Neon|Fly|Ride"] = 410.99, ["Mega"] = 157.5, ["Mega|Ride"] = 272.06, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 154.55, ["Ride"] = 48.61, ["Fly|Ride"] = 201.38, ["Neon|Ride"] = 186.02, ["Mega"] = 1027.44, ["Mega|Ride"] = 786.91, ["Mega|Fly|Ride"] = 1860.15}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 2.63, ["Neon|Ride"] = 28.88, ["Mega"] = 18.38, ["Mega|Ride"] = 82.21}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 9.75, ["Fly"] = 187.6, ["Ride"] = 58.97, ["Fly|Ride"] = 164.07, ["Neon"] = 102.76, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 513.73, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 644.09}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.4, ["Fly"] = 101.61, ["Ride"] = 27.76, ["Fly|Ride"] = 98.44, ["Neon"] = 388.53, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 172.08, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.51, ["Ride"] = 18.12, ["Fly|Ride"] = 76.05, ["Neon"] = 29.79, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.43, ["Mega"] = 231, ["Mega|Ride"] = 223.71, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.5, ["Fly"] = 2054.84, ["Ride"] = 83.99, ["Neon"] = 69.56, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 6200.09, ["Mega"] = 466.47, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 923.66}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 16.01, ["Fly|Ride"] = 196.88, ["Neon"] = 6.39, ["Neon|Ride"] = 32.43, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 150.02}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.05, ["Ride"] = 55.52, ["Neon"] = 3.21, ["Neon|Ride"] = 102.76, ["Mega"] = 28.75, ["Mega|Ride"] = 152.07, ["Mega|Fly|Ride"] = 287.69}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.44}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.04, ["Fly"] = 78.75, ["Ride"] = 37.8, ["Neon"] = 183.75, ["Neon|Ride"] = 271.8, ["Neon|Fly|Ride"] = 313.68, ["Mega"] = 1643.87, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 889.88}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.46, ["Neon|Ride"] = 28.39, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 22.32, ["Mega|Ride"] = 274.34, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 446.24, ["Fly"] = 498.75, ["Ride"] = 577.5, ["Fly|Ride"] = 641.82, ["Neon"] = 2050.74, ["Neon|Ride"] = 2015.94, ["Neon|Fly|Ride"] = 2273.82, ["Mega"] = 16438.67, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.19, ["Fly|Ride"] = 34.94, ["Neon"] = 32.18, ["Neon|Ride"] = 274.34, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 95.85, ["Mega|Fly"] = 154.12, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.04, ["Fly"] = 95.55, ["Ride"] = 19.47, ["Fly|Ride"] = 69.33, ["Neon"] = 18.31, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 155.8, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 227.26}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.46, ["Ride"] = 50.3, ["Fly|Ride"] = 106.32, ["Neon"] = 101.75, ["Neon|Ride"] = 167.49, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 821.94, ["Mega|Ride"] = 493.18}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.8, ["Fly"] = 410.99, ["Ride"] = 38.57, ["Fly|Ride"] = 721.88, ["Neon"] = 30.24, ["Mega"] = 258.57}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 105, ["Fly"] = 139.53, ["Ride"] = 137.69, ["Fly|Ride"] = 157.5, ["Neon"] = 110.99, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 369.89, ["Mega"] = 385.3, ["Mega|Ride"] = 418.55, ["Mega|Fly|Ride"] = 795.23}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.05, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 133.88, ["Neon"] = 31.19, ["Neon|Ride"] = 76.04, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 217.87, ["Mega|Fly"] = 548.66, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 359.03}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.05, ["Fly"] = 46.52, ["Ride"] = 11.29, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 58.57, ["Neon|Ride"] = 15.38, ["Neon|Fly|Ride"] = 123.31, ["Mega"] = 14.86, ["Mega|Ride"] = 24.94, ["Mega|Fly|Ride"] = 109.3}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 4.34, ["Fly"] = 278.36, ["Ride"] = 32.7, ["Fly|Ride"] = 102.76, ["Neon"] = 27.37, ["Neon|Fly"] = 116.28, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 219.89, ["Mega"] = 196.86, ["Mega|Ride"] = 217.88, ["Mega|Fly|Ride"] = 714.67}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 288.75, ["Fly"] = 406.92, ["Ride"] = 292.86, ["Fly|Ride"] = 393.17, ["Neon"] = 1240.49, ["Neon|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 5034.36, ["Mega|Fly|Ride"] = 5069.29}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 108.92, ["Ride"] = 139.53, ["Fly|Ride"] = 274.34, ["Neon"] = 465.05, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 563.71, ["Mega"] = 2192.52, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 12.33, ["Ride"] = 15.1, ["Fly|Ride"] = 41.11, ["Neon"] = 8.4, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 55.5, ["Mega|Fly"] = 204.47, ["Mega|Ride"] = 77.07, ["Mega|Fly|Ride"] = 256.6}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 13.79, ["Fly|Ride"] = 32.82, ["Neon"] = 9.72, ["Neon|Fly"] = 51.35, ["Neon|Ride"] = 23.37, ["Neon|Fly|Ride"] = 55.5, ["Mega"] = 90.57, ["Mega|Fly"] = 344.03, ["Mega|Ride"] = 86.01, ["Mega|Fly|Ride"] = 179.2}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 98.44, ["Neon"] = 45.85, ["Mega"] = 205.5, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 231.88, ["Fly"] = 420, ["Ride"] = 286.67, ["Fly|Ride"] = 375.38, ["Neon|Ride"] = 2054.58, ["Mega|Ride"] = 8219.34, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 14.36, ["Ride"] = 13.02, ["Fly|Ride"] = 32.67, ["Neon"] = 18.38, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.24, ["Neon|Fly|Ride"] = 89.15, ["Mega"] = 252.76, ["Mega|Ride"] = 310.43}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.88, ["Ride"] = 26.25, ["Fly|Ride"] = 205.5, ["Neon"] = 410.99, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 253.21, ["Mega|Ride"] = 288.64, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 27.76, ["Neon"] = 3.94, ["Neon|Ride"] = 41.11, ["Mega"] = 65.54, ["Mega|Ride"] = 205.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.11, ["Fly"] = 27.19, ["Ride"] = 19.35, ["Fly|Ride"] = 74.81, ["Neon"] = 80.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 179.82, ["Mega"] = 575.19, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 45.94, ["Ride"] = 91.88, ["Fly|Ride"] = 207.89, ["Neon"] = 170.15, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 199.34, ["Neon|Fly|Ride"] = 297.36, ["Mega"] = 787.5, ["Mega|Fly"] = 2157.6, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.57, ["Ride"] = 41.11, ["Fly|Ride"] = 91.88, ["Neon"] = 105, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 209.61, ["Neon|Fly|Ride"] = 209.48, ["Mega"] = 821.94, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 766.47}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.05, ["Fly"] = 20.46, ["Ride"] = 14.9, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.46, ["Neon|Ride"] = 18.13, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 18.38, ["Mega|Fly"] = 410.99, ["Mega|Ride"] = 47.28, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.38, ["Fly"] = 262.5, ["Ride"] = 282.34, ["Fly|Ride"] = 328.02, ["Neon"] = 764.1, ["Neon|Ride"] = 1191.81, ["Neon|Fly|Ride"] = 825.96, ["Mega|Fly|Ride"] = 4247.36}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.55, ["Fly"] = 101.18, ["Ride"] = 41.11, ["Fly|Ride"] = 61.66, ["Neon"] = 130.49, ["Neon|Ride"] = 186.02, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 512.7, ["Mega|Fly|Ride"] = 775.46}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 30.68, ["Ride"] = 16.23, ["Fly|Ride"] = 42.09, ["Neon"] = 5.92, ["Neon|Fly"] = 35.33, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 59.07, ["Mega|Fly"] = 274.34, ["Mega|Ride"] = 69.33, ["Mega|Fly|Ride"] = 273.3}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 15.65, ["Fly|Ride"] = 41.97, ["Neon"] = 2.63, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 124.3, ["Mega"] = 24.55, ["Mega|Fly"] = 137.69, ["Mega|Ride"] = 45.4, ["Mega|Fly|Ride"] = 177.85}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.96, ["Ride"] = 28.74, ["Fly|Ride"] = 69.29, ["Neon"] = 7.88, ["Neon|Fly"] = 697.57, ["Neon|Ride"] = 71.21, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 123.33, ["Mega|Ride"] = 194.09, ["Mega|Fly|Ride"] = 369.89}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.08, ["Fly"] = 27.76, ["Ride"] = 22.68, ["Fly|Ride"] = 66.27, ["Neon"] = 55.13, ["Neon|Fly"] = 260.97, ["Neon|Ride"] = 56.47, ["Neon|Fly|Ride"] = 115.5, ["Mega"] = 368.82, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.25, ["Fly"] = 41.11, ["Ride"] = 55.11, ["Fly|Ride"] = 72.19, ["Neon"] = 44.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 260.97, ["Mega|Fly|Ride"] = 418.18}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Fly|Ride"] = 274.34, ["Neon"] = 3.93, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 100.64, ["Mega"] = 23.63, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.77, ["Fly"] = 96.59, ["Ride"] = 24.75, ["Fly|Ride"] = 131.25, ["Neon"] = 28.17, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 77.17, ["Neon|Fly|Ride"] = 190.2, ["Mega"] = 219.89, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 295.91}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 203.76, ["Neon"] = 2.91, ["Neon|Fly"] = 109.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 19.69, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 128.63}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 40.69, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 5.16, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 95.47, ["Mega"] = 52.41, ["Mega|Ride"] = 137.45, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 682.5, ["Ride"] = 721.88, ["Fly|Ride"] = 825.57, ["Neon|Ride"] = 3565.67, ["Neon|Fly|Ride"] = 3361.73, ["Mega|Fly|Ride"] = 12832.39}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 12.89, ["Ride"] = 15.75, ["Fly|Ride"] = 31.54, ["Neon"] = 11.46, ["Neon|Fly"] = 137.65, ["Neon|Ride"] = 27.88, ["Neon|Fly|Ride"] = 71.94, ["Mega|Fly|Ride"] = 340.09}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 44.63, ["Fly|Ride"] = 210, ["Neon"] = 8.57, ["Neon|Ride"] = 88.54, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 60.38, ["Mega|Fly"] = 191.13, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 240.66}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.3, ["Fly"] = 30.13, ["Ride"] = 22.13, ["Fly|Ride"] = 44.62, ["Neon"] = 57.1, ["Neon|Fly"] = 189.38, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 106.86, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 372.92}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.11, ["Ride"] = 14.44, ["Fly|Ride"] = 33.37, ["Neon"] = 7.35, ["Neon|Fly"] = 137.13, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 68.4, ["Mega"] = 65.01, ["Mega|Ride"] = 99.74, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 25.62, ["Ride"] = 50.65, ["Fly|Ride"] = 273.3, ["Neon"] = 116.82, ["Neon|Ride"] = 257.44, ["Mega"] = 918.75, ["Mega|Ride"] = 807.56, ["Mega|Fly|Ride"] = 1165.11}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.27, ["Fly|Ride"] = 64.16, ["Neon"] = 6.57, ["Neon|Fly"] = 141.75, ["Neon|Ride"] = 32.22, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 67.82, ["Mega|Ride"] = 116.24, ["Mega|Fly|Ride"] = 263.92}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 124.41, ["Ride"] = 19.36, ["Fly|Ride"] = 51.39, ["Neon"] = 9.82, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 155.8, ["Mega"] = 328.79, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 472.62}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.45, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 15.43, ["Mega"] = 91.87, ["Mega|Ride"] = 172.08, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.73, ["Fly|Ride"] = 49.83, ["Neon"] = 3.94, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.95, ["Mega"] = 41.83, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 172.08}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.43, ["Fly"] = 19.19, ["Ride"] = 17.48, ["Fly|Ride"] = 35.23, ["Neon"] = 309.75, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 98.43}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 787.5, ["Ride"] = 787.5, ["Fly|Ride"] = 947.99, ["Neon"] = 1712.63, ["Neon|Ride"] = 1836.19, ["Neon|Fly|Ride"] = 2054.84, ["Mega"] = 8219.34, ["Mega|Fly|Ride"] = 7260.77}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 17.79, ["Ride"] = 15.2, ["Fly|Ride"] = 30.83, ["Neon"] = 6.43, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 15.98, ["Neon|Fly|Ride"] = 48.3, ["Mega"] = 55.5, ["Mega|Ride"] = 57.73, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.04, ["Ride"] = 137.69, ["Fly|Ride"] = 116.28, ["Neon"] = 39.32, ["Neon|Ride"] = 46.52, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 385.3, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 479.82}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 59.07, ["Ride"] = 79.46, ["Fly|Ride"] = 91.88, ["Neon"] = 488.03, ["Neon|Ride"] = 389.82, ["Neon|Fly|Ride"] = 508.58, ["Mega"] = 3151.1, ["Mega|Fly|Ride"] = 2332.32}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 24.94, ["Ride"] = 31.5, ["Fly|Ride"] = 104.89, ["Neon"] = 183.75, ["Neon|Ride"] = 158.24, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 1919.24, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 779.06}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.97, ["Ride"] = 26.23, ["Fly|Ride"] = 139.71, ["Neon"] = 58.97, ["Neon|Ride"] = 138.72, ["Neon|Fly|Ride"] = 121.42, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 540.44}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 20.74, ["Ride"] = 63.51, ["Neon"] = 134.88, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 356.93, ["Mega"] = 325.54, ["Mega|Fly"] = 504.57, ["Mega|Ride"] = 366.23, ["Mega|Fly|Ride"] = 508.6}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 19.69, ["Fly"] = 126.89, ["Ride"] = 69.4, ["Neon"] = 274.34, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 12.9}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 8.13, ["Fly"] = 131248.69, ["Ride"] = 19.02, ["Fly|Ride"] = 78.75, ["Neon"] = 34.13, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 178.78, ["Mega"] = 185.11, ["Mega|Fly"] = 463.87, ["Mega|Ride"] = 194.18, ["Mega|Fly|Ride"] = 821.94}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 47.28, ["Neon"] = 11.82, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 139.53}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 53.44, ["Fly"] = 62.99, ["Ride"] = 68.85, ["Fly|Ride"] = 117.13, ["Neon"] = 272.06, ["Neon|Ride"] = 265.09, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 644.21, ["Mega|Ride"] = 1643.87, ["Mega|Fly|Ride"] = 959.62}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.83, ["Fly"] = 16.34, ["Ride"] = 14.44, ["Fly|Ride"] = 45.66, ["Neon"] = 36.05, ["Neon|Fly"] = 63, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 76.59, ["Mega"] = 198.19, ["Mega|Fly"] = 409.96, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 243.74}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.02, ["Fly"] = 145.91, ["Ride"] = 27.19, ["Fly|Ride"] = 80.56, ["Neon"] = 20.64, ["Neon|Ride"] = 40.85, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 129.93, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 4.99, ["Mega"] = 45.94, ["Mega|Ride"] = 192.14}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.23, ["Fly"] = 65.63, ["Ride"] = 48.2, ["Fly|Ride"] = 93.02, ["Neon"] = 945, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 303.03, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 863.04}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.05, ["Ride"] = 38.56, ["Fly|Ride"] = 65.63, ["Neon"] = 4.72, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66.27, ["Mega"] = 74.7, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.97, ["Fly"] = 52.5, ["Ride"] = 67.59, ["Fly|Ride"] = 273.3, ["Neon"] = 107.63, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 12.79, ["Fly|Ride"] = 40.63, ["Neon"] = 18.59, ["Neon|Ride"] = 27.65, ["Neon|Fly|Ride"] = 65.62, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.42, ["Fly"] = 52.49, ["Ride"] = 19.69, ["Fly|Ride"] = 71.36, ["Neon"] = 35.44, ["Neon|Ride"] = 410.93, ["Mega"] = 384.27, ["Mega|Ride"] = 397.63, ["Mega|Fly|Ride"] = 410.17}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.19, ["Ride"] = 64.84, ["Neon"] = 59.6, ["Neon|Ride"] = 157.55, ["Mega"] = 464.93, ["Mega|Ride"] = 873.32}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 42, ["Ride"] = 112.88, ["Neon"] = 310.43, ["Neon|Fly|Ride"] = 805.51, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 1640.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.63, ["Ride"] = 123.3, ["Neon"] = 99.02, ["Neon|Ride"] = 262.5, ["Mega"] = 410.99, ["Mega|Fly|Ride"] = 547.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.69, ["Ride"] = 105, ["Neon"] = 162.74, ["Neon|Fly"] = 205.5, ["Mega|Ride"] = 1027.44}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 15.53, ["Ride"] = 105, ["Fly|Ride"] = 367.46, ["Neon"] = 145.53, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 821.94, ["Mega|Fly"] = 2054.84, ["Mega|Fly|Ride"] = 1091.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.43, ["Neon"] = 20.56, ["Neon|Ride"] = 274.34, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 310.43}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.62, ["Ride"] = 18.38, ["Fly|Ride"] = 63, ["Neon"] = 3.59, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.26, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 109.95, ["Mega|Ride"] = 109.95, ["Mega|Fly|Ride"] = 199.34}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.11, ["Fly"] = 50.3, ["Ride"] = 41.11, ["Fly|Ride"] = 77.9, ["Neon"] = 18.51, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 163.96, ["Mega|Fly|Ride"] = 388.32}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 19.69, ["Fly|Ride"] = 56.16, ["Neon"] = 5.25, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 69.77, ["Mega"] = 41.91, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Fly|Ride"] = 118.13, ["Neon"] = 32.82, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 254.82, ["Mega"] = 246.6, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 103.69, ["Neon"] = 25.35, ["Neon|Fly"] = 465.05, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.2, ["Fly"] = 131.25, ["Ride"] = 20.56, ["Fly|Ride"] = 76.02, ["Neon"] = 17.46, ["Neon|Fly"] = 111.55, ["Neon|Ride"] = 40.08, ["Neon|Fly|Ride"] = 124.42, ["Mega"] = 228.06, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 392.41}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 5.91, ["Fly"] = 35.49, ["Ride"] = 15.62, ["Fly|Ride"] = 45.8, ["Neon"] = 14.44, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 67.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 227.08, ["Mega|Ride"] = 195.23, ["Mega|Fly|Ride"] = 244.54}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.45, ["Fly"] = 57.75, ["Ride"] = 43.18, ["Neon"] = 17.01, ["Neon|Fly"] = 410.84, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 90.43, ["Mega|Fly"] = 176.5, ["Mega|Ride"] = 132.57, ["Mega|Fly|Ride"] = 250.68}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 20.56, ["Fly"] = 205.5, ["Ride"] = 105, ["Fly|Ride"] = 155.8, ["Neon"] = 65.63, ["Neon|Fly"] = 393.37, ["Neon|Ride"] = 188.16, ["Neon|Fly|Ride"] = 418.55, ["Mega"] = 626.06, ["Mega|Fly"] = 821.94, ["Mega|Ride"] = 584.07, ["Mega|Fly|Ride"] = 748.95}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 59.07, ["Ride"] = 83.75, ["Fly|Ride"] = 164.4, ["Neon"] = 252.87, ["Neon|Ride"] = 227.08, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 1550.91, ["Mega|Ride"] = 1116.94, ["Mega|Fly|Ride"] = 1221.93}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.05, ["Fly"] = 50.96, ["Ride"] = 19.51, ["Fly|Ride"] = 61.66, ["Neon"] = 2.63, ["Neon|Ride"] = 40.86, ["Mega"] = 27.76, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 63.74, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 50.3, ["Fly"] = 105, ["Ride"] = 97.13, ["Neon"] = 310.38, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 820.92, ["Mega|Ride"] = 1206.2, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.72, ["Fly"] = 190.32, ["Ride"] = 34.12, ["Fly|Ride"] = 126, ["Neon"] = 36.62, ["Neon|Ride"] = 65.63, ["Mega"] = 176.65, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 383.92}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Fly|Ride"] = 137.45, ["Neon"] = 10.45, ["Neon|Ride"] = 65.63, ["Mega"] = 64.85, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 109.66, ["Mega|Fly|Ride"] = 337.22}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 16.73, ["Fly|Ride"] = 37.68, ["Neon"] = 11.65, ["Neon|Ride"] = 30.83, ["Neon|Fly|Ride"] = 84, ["Mega"] = 205.5, ["Mega|Fly"] = 343.17, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.74, ["Ride"] = 14.33, ["Fly|Ride"] = 40.65, ["Neon"] = 2.49, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 132.56, ["Mega"] = 24.09, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 89.13, ["Neon"] = 3.94, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 78.1, ["Mega"] = 58.57, ["Mega|Fly"] = 168, ["Mega|Ride"] = 124.42, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 2.63, ["Neon|Ride"] = 145.08, ["Mega"] = 23.63, ["Mega|Fly|Ride"] = 274.34}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.34, ["Ride"] = 104.98, ["Neon"] = 31.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 616.46, ["Mega"] = 231.18, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 299.24}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.52, ["Ride"] = 34.12, ["Fly|Ride"] = 202.98, ["Neon"] = 47.41, ["Neon|Ride"] = 102.76, ["Neon|Fly|Ride"] = 180.85, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 466.47}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.17, ["Fly"] = 25.79, ["Ride"] = 19.4, ["Fly|Ride"] = 41.11, ["Neon"] = 41.36, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 37.41, ["Neon|Fly|Ride"] = 82.35, ["Mega|Ride"] = 273, ["Mega|Fly|Ride"] = 353.2}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 61.68, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 446.15, ["Mega|Ride"] = 1987.04, ["Mega|Fly|Ride"] = 1836.01}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 24.43, ["Fly"] = 82.66, ["Ride"] = 65.63, ["Neon"] = 282.7, ["Neon|Fly|Ride"] = 630, ["Mega"] = 639.85, ["Mega|Ride"] = 827.54, ["Mega|Fly|Ride"] = 1020.48}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 30.73, ["Neon"] = 2.1, ["Neon|Fly"] = 41.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 41.01, ["Mega|Ride"] = 96.59, ["Mega|Fly|Ride"] = 188.97}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.02, ["Ride"] = 14.32, ["Fly|Ride"] = 26.86, ["Neon"] = 4.2, ["Neon|Fly"] = 26.4, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 27.47, ["Mega"] = 42, ["Mega|Fly"] = 82.21, ["Mega|Ride"] = 56.32, ["Mega|Fly|Ride"] = 90.46}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 620.78, ["Ride"] = 534.18, ["Fly|Ride"] = 660.37, ["Neon|Fly|Ride"] = 1884.09}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 24.68, ["Ride"] = 55.6, ["Neon"] = 97.13, ["Neon|Ride"] = 274.34, ["Mega"] = 356.52, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 10.5, ["Ride"] = 15.27, ["Fly|Ride"] = 26.25, ["Neon"] = 3.18, ["Neon|Fly"] = 23.26, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 39.06, ["Mega"] = 140.76, ["Mega|Ride"] = 74.99, ["Mega|Fly|Ride"] = 105.44}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.65, ["Ride"] = 137.69, ["Fly|Ride"] = 343.17, ["Neon"] = 260.88, ["Neon|Ride"] = 262.4, ["Neon|Fly|Ride"] = 450.02, ["Mega"] = 719.25, ["Mega|Ride"] = 917.44, ["Mega|Fly|Ride"] = 1401.41}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 36.98, ["Ride"] = 16.68, ["Fly|Ride"] = 34.13, ["Neon"] = 11.23, ["Neon|Fly"] = 51.34, ["Neon|Ride"] = 27.76, ["Neon|Fly|Ride"] = 66.85, ["Mega"] = 105, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.05, ["Fly"] = 21, ["Ride"] = 42.95, ["Neon"] = 3.56, ["Neon|Ride"] = 31.86, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.04, ["Mega|Ride"] = 72.97, ["Mega|Fly|Ride"] = 190.77}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 36.4, ["Fly"] = 108.03, ["Ride"] = 70.88, ["Fly|Ride"] = 194.86, ["Neon"] = 192.14, ["Neon|Ride"] = 191.26, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 787.5, ["Mega|Ride"] = 708.75, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 18.27, ["Fly|Ride"] = 32.82, ["Neon"] = 6.67, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 63, ["Mega"] = 45.22, ["Mega|Ride"] = 188.9, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 32.81, ["Ride"] = 69.43, ["Fly|Ride"] = 137.69, ["Neon"] = 233.19, ["Neon|Ride"] = 256.48, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1623.34, ["Mega|Ride"] = 1643.87, ["Mega|Fly|Ride"] = 1500.03}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Ride"] = 176.73, ["Fly|Ride"] = 156.19, ["Neon"] = 16.95, ["Neon|Ride"] = 46.52, ["Neon|Fly|Ride"] = 152.07, ["Mega"] = 105, ["Mega|Ride"] = 603.75}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 68.85, ["Ride"] = 26.25, ["Fly|Ride"] = 65.77, ["Neon"] = 6.89, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 127.41, ["Mega|Ride"] = 137.69, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 34.13, ["Ride"] = 104.99, ["Fly|Ride"] = 513.73, ["Neon"] = 148.82, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 770.58}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 59.6, ["Neon"] = 6.19, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 152.31, ["Mega"] = 67.82, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 91.41}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.05, ["Fly"] = 14.45, ["Ride"] = 17.46, ["Fly|Ride"] = 101.82, ["Neon"] = 10.5, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly|Ride"] = 205.78}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 8.46, ["Fly"] = 58.49, ["Ride"] = 35.35, ["Fly|Ride"] = 75.78, ["Neon"] = 81.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 147.67, ["Mega"] = 429.49, ["Mega|Ride"] = 403.44, ["Mega|Fly|Ride"] = 456.49}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 15.75, ["Ride"] = 131.23, ["Fly|Ride"] = 68.85, ["Neon"] = 99.52, ["Neon|Ride"] = 184.95, ["Neon|Fly|Ride"] = 232.54, ["Mega"] = 542.94, ["Mega|Ride"] = 540.05, ["Mega|Fly|Ride"] = 485.01}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.63, ["Fly"] = 52.41, ["Ride"] = 22.32, ["Fly|Ride"] = 62.79, ["Neon"] = 118.16, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 155.8, ["Mega"] = 315.44, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 405.85}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 74.82, ["Ride"] = 104.24, ["Fly|Ride"] = 223.13, ["Neon"] = 271.58, ["Neon|Ride"] = 343.17, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1379.83, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.04, ["Ride"] = 54.03, ["Neon"] = 23.63, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 223.12, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 382.22}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 5.2, ["Ride"] = 26.67, ["Fly|Ride"] = 78.74, ["Neon"] = 123.31, ["Neon|Ride"] = 59.31, ["Neon|Fly|Ride"] = 123.31, ["Mega"] = 172.62, ["Mega|Ride"] = 204.47, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 7.88, ["Ride"] = 31.2, ["Fly|Ride"] = 108.63, ["Neon"] = 84, ["Neon|Ride"] = 174.08, ["Mega"] = 431.53, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 724.5}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.05, ["Fly"] = 15.65, ["Ride"] = 11.91, ["Fly|Ride"] = 30.23, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.11, ["Neon|Fly|Ride"] = 37.68, ["Mega"] = 12.58, ["Mega|Ride"] = 26.97, ["Mega|Fly|Ride"] = 93.82}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 49.65, ["Ride"] = 96.59, ["Fly|Ride"] = 274.34, ["Neon"] = 388.32, ["Neon|Fly"] = 2329.17, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 1096.27, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 1484.03}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 76.02, ["Fly|Ride"] = 137.69, ["Neon"] = 3.94, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 34.38, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 15.73, ["Fly|Ride"] = 51.7, ["Neon"] = 13.02, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 96.59, ["Mega|Ride"] = 169.43, ["Mega|Fly|Ride"] = 236.15}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 142.93, ["Ride"] = 91.88, ["Fly|Ride"] = 258.56, ["Neon"] = 262.5, ["Neon|Ride"] = 533.24, ["Neon|Fly|Ride"] = 585.38, ["Mega"] = 1232.91, ["Mega|Ride"] = 1220.73, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.22, ["Ride"] = 25.25, ["Neon"] = 5.99, ["Neon|Ride"] = 60.64, ["Mega"] = 48.57, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 7.33}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Neon"] = 5.25, ["Neon|Ride"] = 41.27, ["Neon|Fly|Ride"] = 116.25, ["Mega"] = 51.39, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.05}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 145.68, ["Ride"] = 189, ["Fly|Ride"] = 295.25, ["Neon"] = 651.39, ["Neon|Ride"] = 657.57, ["Neon|Fly|Ride"] = 917.44, ["Mega|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 2094.27}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Neon"] = 17.36, ["Neon|Ride"] = 61.76, ["Mega"] = 183.54, ["Mega|Ride"] = 202.85, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 82.1, ["Neon"] = 3.72, ["Neon|Ride"] = 19.4, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 32.8, ["Mega|Ride"] = 96.59, ["Mega|Fly|Ride"] = 137.69}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.41, ["Ride"] = 18.8, ["Neon"] = 48.07, ["Neon|Ride"] = 64.05, ["Neon|Fly|Ride"] = 155.8, ["Mega"] = 410.99, ["Mega|Ride"] = 548.66, ["Mega|Fly|Ride"] = 614.76}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.66, ["Fly"] = 26.25, ["Ride"] = 20.99, ["Fly|Ride"] = 54.66, ["Neon"] = 98, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 597.19, ["Mega|Ride"] = 548.66, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 15.89, ["Ride"] = 60.29, ["Fly|Ride"] = 109.95, ["Neon"] = 155.8, ["Neon|Ride"] = 168.04, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 560.44, ["Mega|Ride"] = 630.84, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 144.37, ["Fly"] = 274.2, ["Ride"] = 179.82, ["Fly|Ride"] = 228.38, ["Neon"] = 591.64, ["Neon|Ride"] = 578.2, ["Neon|Fly|Ride"] = 575.49, ["Mega|Fly|Ride"] = 2357.38}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 26.25, ["Fly"] = 98.44, ["Ride"] = 98.18, ["Fly|Ride"] = 67.13, ["Neon|Fly"] = 6164.51, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 1027.44, ["Mega|Ride"] = 1062.36, ["Mega|Fly|Ride"] = 1096.27}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 19.48, ["Fly|Ride"] = 65.63, ["Neon"] = 15.61, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 137.69, ["Mega|Fly|Ride"] = 296.63}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 5.39, ["Fly"] = 232.54, ["Ride"] = 35.98, ["Fly|Ride"] = 123.31, ["Neon"] = 144.37, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 80.07, ["Mega"] = 379.31, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Fly"] = 109.95, ["Ride"] = 85.32, ["Fly|Ride"] = 137.69, ["Neon"] = 308.23, ["Neon|Ride"] = 275.44, ["Neon|Fly|Ride"] = 410.99, ["Mega"] = 1541.14, ["Mega|Ride"] = 1165.5, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 20.26, ["Ride"] = 67.39, ["Neon"] = 78.75, ["Neon|Ride"] = 248.64, ["Neon|Fly|Ride"] = 453.11, ["Mega"] = 683.71, ["Mega|Ride"] = 479.82, ["Mega|Fly|Ride"] = 924.69}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 459.38, ["Neon|Ride"] = 3100.64}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 25.1, ["Ride"] = 35.22, ["Fly|Ride"] = 61.66, ["Neon"] = 224.26, ["Neon|Ride"] = 227.39, ["Neon|Fly|Ride"] = 252.76, ["Mega"] = 1034.25, ["Mega|Ride"] = 922.62, ["Mega|Fly|Ride"] = 1137.36}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.05, ["Fly"] = 38.11, ["Ride"] = 13.69, ["Fly|Ride"] = 119.13, ["Neon"] = 2.1, ["Neon|Ride"] = 13.84, ["Neon|Fly|Ride"] = 74, ["Mega"] = 27.75, ["Mega|Fly"] = 102.74, ["Mega|Ride"] = 35.85, ["Mega|Fly|Ride"] = 112.88}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 10.5, ["Neon"] = 19.2, ["Neon|Ride"] = 66.87, ["Neon|Fly|Ride"] = 259.9, ["Mega"] = 143.85, ["Mega|Ride"] = 308.23, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Ride"] = 34.94, ["Fly|Ride"] = 144.18, ["Neon"] = 11.82, ["Neon|Ride"] = 122.28, ["Neon|Fly|Ride"] = 959.62, ["Mega"] = 107.63, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 266.12, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 422.63, ["Ride"] = 393.75, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1370.58, ["Neon|Fly|Ride"] = 1395.12, ["Mega|Fly|Ride"] = 5026.88}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.52, ["Fly"] = 67.73, ["Ride"] = 15.75, ["Fly|Ride"] = 41.99, ["Neon"] = 39.38, ["Neon|Ride"] = 64.78, ["Neon|Fly|Ride"] = 82.1, ["Mega"] = 168, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 410.92}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.16, ["Fly"] = 21.84, ["Ride"] = 16.53, ["Fly|Ride"] = 32.16, ["Neon"] = 26.78, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 410.99, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 5.16, ["Fly"] = 44.19, ["Ride"] = 28.87, ["Fly|Ride"] = 78.75, ["Neon"] = 23.25, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 54.94, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 138.72, ["Mega|Ride"] = 202.3, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 29.17, ["Fly"] = 34.94, ["Ride"] = 34.94, ["Fly|Ride"] = 96.59, ["Neon"] = 140.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 307.21, ["Mega|Ride"] = 820.92, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 15.75, ["Fly|Ride"] = 50.3, ["Neon"] = 6.46, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.09, ["Mega|Ride"] = 449, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.65, ["Fly"] = 64.26, ["Ride"] = 28.62, ["Fly|Ride"] = 88.76, ["Neon"] = 137.69, ["Neon|Ride"] = 209.99, ["Mega|Ride"] = 739.76, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 4.61, ["Neon|Ride"] = 28.87, ["Mega"] = 52.41, ["Mega|Ride"] = 109.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 6.07, ["Ride"] = 137.69, ["Neon"] = 49.88, ["Mega|Ride"] = 287.69}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 9.09, ["Neon"] = 78.66, ["Neon|Ride"] = 52.5, ["Mega"] = 303.11, ["Mega|Ride"] = 541.3, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.47, ["Fly"] = 28.69, ["Ride"] = 23.64, ["Fly|Ride"] = 57.75, ["Neon"] = 52.39, ["Neon|Fly"] = 67.82, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 577.42, ["Mega|Ride"] = 313.74, ["Mega|Fly|Ride"] = 465.05}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 320.08, ["Fly"] = 439.74, ["Ride"] = 334.59, ["Fly|Ride"] = 446.25, ["Neon"] = 1348.61, ["Neon|Ride"] = 1303.12, ["Neon|Fly|Ride"] = 1425.04, ["Mega|Fly|Ride"] = 6164.51}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 31.86, ["Ride"] = 15.43, ["Fly|Ride"] = 39.38, ["Neon"] = 12.49, ["Neon|Fly"] = 77.9, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 212.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 4.72, ["Fly"] = 109.95, ["Ride"] = 45.94, ["Fly|Ride"] = 110.34, ["Neon"] = 41.97, ["Neon|Ride"] = 146.47, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 196.88, ["Mega|Ride"] = 389.81}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 35.98, ["Ride"] = 121.26, ["Neon"] = 73.5, ["Neon|Ride"] = 174.67, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 354.8, ["Mega|Ride"] = 319.1, ["Mega|Fly|Ride"] = 667.85}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 198.79, ["Ride"] = 130.49, ["Fly|Ride"] = 443.58, ["Neon"] = 656.54, ["Neon|Fly|Ride"] = 1085.86, ["Mega|Ride"] = 6200.25, ["Mega|Fly|Ride"] = 3022.74}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 32.45, ["Fly"] = 117.13, ["Ride"] = 124.41, ["Fly|Ride"] = 142.63, ["Neon"] = 111.2, ["Neon|Ride"] = 96.59, ["Neon|Fly|Ride"] = 213.71, ["Mega"] = 236.25, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 58.45, ["Neon"] = 12.47, ["Neon|Fly|Ride"] = 68.76, ["Mega"] = 65.58, ["Mega|Ride"] = 152.07, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 10.28, ["Ride"] = 30.18, ["Neon"] = 34.94, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 172.81, ["Mega"] = 169.32, ["Mega|Fly|Ride"] = 306.99}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 65.63, ["Fly"] = 96.59, ["Ride"] = 83.12, ["Fly|Ride"] = 216.57, ["Neon"] = 155.8, ["Neon|Ride"] = 215.78, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 475.13, ["Mega|Ride"] = 507.56, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 7.55, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 48.57, ["Mega|Ride"] = 133.68, ["Mega|Fly|Ride"] = 397.63}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 27.57, ["Neon"] = 118.12, ["Neon|Ride"] = 307.21, ["Mega"] = 426.39, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 1023.75, ["Fly"] = 2054.84, ["Ride"] = 1036.88, ["Fly|Ride"] = 1013.52, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2591.91, ["Mega|Fly|Ride"] = 12329.01}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 15.06, ["Fly"] = 106.47, ["Ride"] = 76.75, ["Fly|Ride"] = 191.63, ["Neon"] = 76.13, ["Neon|Fly"] = 274.34, ["Neon|Ride"] = 157.5, ["Mega"] = 410.99, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.61, ["Fly"] = 49.34, ["Ride"] = 21.42, ["Fly|Ride"] = 64.51, ["Neon"] = 13.86, ["Neon|Ride"] = 32.91, ["Neon|Fly|Ride"] = 80.99, ["Mega"] = 82.43, ["Mega|Ride"] = 101.24, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 9.26, ["Ride"] = 47.25, ["Fly|Ride"] = 137.69, ["Neon"] = 202.3, ["Mega"] = 311.33, ["Mega|Ride"] = 421.91, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.05, ["Ride"] = 39.38, ["Fly|Ride"] = 59.6, ["Neon"] = 2.1, ["Neon|Ride"] = 20.53, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 17.05, ["Mega|Fly"] = 123.31, ["Mega|Ride"] = 37.54, ["Mega|Fly|Ride"] = 125.16}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 46.99, ["Ride"] = 117.68, ["Fly|Ride"] = 229.59, ["Neon"] = 320.43, ["Neon|Ride"] = 381.12, ["Neon|Fly|Ride"] = 439.74, ["Mega"] = 1062.09, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 6.39, ["Ride"] = 44.19, ["Fly|Ride"] = 156.24, ["Neon"] = 68.85, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 256.94, ["Mega"] = 669.38, ["Mega|Ride"] = 545.57, ["Mega|Fly|Ride"] = 527.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 26.73, ["Neon"] = 13.02, ["Neon|Ride"] = 46.52, ["Mega"] = 78.75, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 39.06, ["Fly"] = 152.07, ["Ride"] = 40.08, ["Fly|Ride"] = 113.91, ["Neon"] = 205.5, ["Neon|Ride"] = 155.8, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 687.95, ["Mega|Ride"] = 310.43, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 55.39, ["Ride"] = 28.43, ["Neon"] = 55.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 315, ["Mega"] = 410.99, ["Mega|Ride"] = 513.73, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Ride"] = 55.5, ["Neon"] = 274.34, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 775.69, ["Mega"] = 1863.75, ["Mega|Ride"] = 1643.87, ["Mega|Fly|Ride"] = 1617.16}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.36, ["Ride"] = 59.6, ["Fly|Ride"] = 68.16, ["Neon"] = 20.09, ["Neon|Ride"] = 88.37, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 98.44, ["Mega|Ride"] = 213.71, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.57, ["Ride"] = 19.69, ["Fly|Ride"] = 45.22, ["Neon"] = 91.88, ["Neon|Ride"] = 82.21, ["Neon|Fly|Ride"] = 123.31, ["Mega"] = 465.05, ["Mega|Ride"] = 381.94, ["Mega|Fly|Ride"] = 1027.44}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 111.57, ["Fly"] = 393.75, ["Ride"] = 177.18, ["Fly|Ride"] = 233.48, ["Neon"] = 589.75, ["Neon|Ride"] = 600.54, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 2327.07, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 16.37, ["Fly|Ride"] = 42.71, ["Neon"] = 13.73, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 68.24, ["Mega"] = 124.69, ["Mega|Ride"] = 232.54, ["Mega|Fly|Ride"] = 213.46}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.43, ["Fly"] = 191.51, ["Ride"] = 33.78, ["Fly|Ride"] = 68.16, ["Neon"] = 69.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 404.91, ["Mega|Ride"] = 435.58, ["Mega|Fly|Ride"] = 385.91}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.05, ["Ride"] = 14.67, ["Fly|Ride"] = 69.77, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.1, ["Mega|Ride"] = 31.45, ["Mega|Fly|Ride"] = 80.03}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 55.5, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 41.11, ["Mega"] = 18.38, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 34.94, ["Ride"] = 18.27, ["Fly|Ride"] = 91.17, ["Neon"] = 15.75, ["Neon|Ride"] = 64.98, ["Mega"] = 262.5, ["Mega|Ride"] = 116.28, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.12, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 117.5, ["Neon|Ride"] = 348.79, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 423.01, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 665.78}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 12.91, ["Ride"] = 15.33, ["Fly|Ride"] = 29.43, ["Neon"] = 12.5, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 22.81, ["Neon|Fly|Ride"] = 68.85, ["Mega"] = 109.95, ["Mega|Fly"] = 170.61, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.18}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 4.99, ["Fly"] = 39.38, ["Ride"] = 23.63, ["Fly|Ride"] = 59.07, ["Neon"] = 21.28, ["Neon|Fly"] = 48.3, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 164.3, ["Mega|Fly"] = 410.99, ["Mega|Ride"] = 144.27, ["Mega|Fly|Ride"] = 263.58}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 21.74, ["Ride"] = 18.09, ["Fly|Ride"] = 82.21, ["Neon"] = 9.19, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 89.23, ["Mega"] = 103.69, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 204.74, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.86, ["Fly"] = 169.32, ["Ride"] = 23.44, ["Fly|Ride"] = 131.25, ["Neon"] = 29.88, ["Neon|Ride"] = 89.78, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 227.08, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.84, ["Ride"] = 137.45, ["Fly|Ride"] = 196.88, ["Neon"] = 45.94, ["Neon|Ride"] = 123.31, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.72, ["Fly"] = 41.88, ["Ride"] = 17.07, ["Fly|Ride"] = 44.45, ["Neon"] = 24.43, ["Neon|Fly"] = 196.67, ["Neon|Ride"] = 55.5, ["Neon|Fly|Ride"] = 109.4, ["Mega"] = 328.79, ["Mega|Ride"] = 303.11, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 21.27, ["Ride"] = 15.42, ["Fly|Ride"] = 34.83, ["Neon"] = 15.3, ["Neon|Fly"] = 46.52, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 232.4, ["Mega|Ride"] = 246.48, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 183.75, ["Fly"] = 393.75, ["Ride"] = 306.93, ["Fly|Ride"] = 392.43, ["Neon"] = 1096.33, ["Neon|Ride"] = 1360.25, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 9.11, ["Ride"] = 65.63, ["Neon"] = 42.95, ["Mega"] = 118.13, ["Mega|Ride"] = 420.6, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.82, ["Ride"] = 16.25, ["Fly|Ride"] = 79.07, ["Neon"] = 21.25, ["Neon|Fly"] = 233.24, ["Neon|Ride"] = 47.28, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.16, ["Mega|Ride"] = 320.57, ["Mega|Fly|Ride"] = 274.34}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.08, ["Neon"] = 36.75, ["Neon|Ride"] = 213.45, ["Neon|Fly|Ride"] = 616.46, ["Mega"] = 463.88, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 549.29}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 15.41, ["Ride"] = 12.35, ["Fly|Ride"] = 26.04, ["Neon"] = 2.1, ["Neon|Fly"] = 28.87, ["Neon|Ride"] = 15.49, ["Neon|Fly|Ride"] = 26.25, ["Mega"] = 18.16, ["Mega|Fly"] = 68.85, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 20.56, ["Fly|Ride"] = 91.88, ["Neon"] = 7.77, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 78.75, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 144.38, ["Neon"] = 11.47, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 101.07, ["Mega|Ride"] = 157.49, ["Mega|Fly|Ride"] = 205.5}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 75.79, ["Fly"] = 162.78, ["Ride"] = 102.6, ["Fly|Ride"] = 158.82, ["Neon"] = 556.49, ["Neon|Ride"] = 372.9, ["Neon|Fly|Ride"] = 548.66, ["Mega|Ride"] = 3426.45, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.65, ["Fly"] = 91.88, ["Ride"] = 18.22, ["Fly|Ride"] = 262.49, ["Neon"] = 22.32, ["Neon|Ride"] = 84.27, ["Neon|Fly|Ride"] = 295.91, ["Mega"] = 211.54, ["Mega|Ride"] = 263.92, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 41.11, ["Neon"] = 8.81, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 521.75, ["Mega"] = 52.5, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 233.24}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 59.06, ["Fly"] = 210, ["Ride"] = 94.4, ["Fly|Ride"] = 196.88, ["Neon"] = 170.63, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 263.92, ["Mega"] = 636.57, ["Mega|Ride"] = 667.85, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 14.42, ["Fly|Ride"] = 30.19, ["Neon"] = 2.63, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 16.37, ["Neon|Fly|Ride"] = 36.64, ["Mega"] = 18.37, ["Mega|Fly"] = 49.87, ["Mega|Ride"] = 35.44, ["Mega|Fly|Ride"] = 82.07}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.05, ["Neon"] = 3.94, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 209.35, ["Mega"] = 27.57, ["Mega|Ride"] = 97.68, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.21, ["Ride"] = 107.63, ["Neon"] = 9.84, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 136.83, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 91.88, ["Mega|Fly"] = 178.78, ["Mega|Ride"] = 124.04, ["Mega|Fly|Ride"] = 190.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.28, ["Fly"] = 76.13, ["Ride"] = 34.94, ["Fly|Ride"] = 206.07, ["Neon"] = 22.95, ["Neon|Fly"] = 137.69, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.44, ["Mega"] = 110.14, ["Mega|Fly"] = 219.89, ["Mega|Ride"] = 158.16, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 11.31, ["Ride"] = 11.31, ["Fly|Ride"] = 26.81, ["Neon"] = 2.1, ["Neon|Fly"] = 27.76, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 18.04, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 21.04, ["Fly"] = 131.25, ["Ride"] = 53.44, ["Neon"] = 115.95, ["Neon|Fly"] = 410.99, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 959.62, ["Mega"] = 513.64, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 684.28}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.55, ["Ride"] = 2493.74, ["Fly|Ride"] = 2598.74, ["Neon|Fly|Ride"] = 9688.21, ["Mega|Fly|Ride"] = 35958.54}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 19.49, ["Ride"] = 15.4, ["Fly|Ride"] = 31.86, ["Neon"] = 8.09, ["Neon|Fly"] = 56.83, ["Neon|Ride"] = 23.97, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 85.32, ["Mega|Fly"] = 458.25, ["Mega|Ride"] = 88.36, ["Mega|Fly|Ride"] = 172.1}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Mega"] = 111.57, ["Mega|Fly"] = 441, ["Mega|Ride"] = 116.17, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 15.26, ["Fly"] = 109.95, ["Ride"] = 31.8, ["Fly|Ride"] = 68.85, ["Neon"] = 86.97, ["Neon|Ride"] = 107.72, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 459.38, ["Mega|Ride"] = 555.74, ["Mega|Fly|Ride"] = 574.34}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 32.81, ["Ride"] = 43.29, ["Neon"] = 187.68, ["Mega"] = 1232.65, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 903.11}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 160.13, ["Fly"] = 1370.58, ["Ride"] = 193.5, ["Fly|Ride"] = 205.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 754.15, ["Mega"] = 6164.51, ["Mega|Fly|Ride"] = 2635.6}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 15.65, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 17.07, ["Neon|Ride"] = 155.8, ["Mega"] = 156.19, ["Mega|Ride"] = 246.6, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Neon"] = 18.37, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 139.02, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 144.38, ["Ride"] = 20.19, ["Fly|Ride"] = 131.25, ["Neon"] = 7.88, ["Neon|Fly"] = 76.05, ["Neon|Ride"] = 39.37, ["Mega"] = 90.43, ["Mega|Ride"] = 112.88, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 11.21, ["Ride"] = 100.7, ["Neon"] = 180.07, ["Neon|Ride"] = 1165.83, ["Mega"] = 374.07, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 809.17}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 41.11, ["Neon"] = 2.1, ["Neon|Ride"] = 47.57, ["Mega"] = 20.35, ["Mega|Fly"] = 116.28, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 274.34}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 91.88, ["Fly"] = 205.5, ["Ride"] = 129.47, ["Fly|Ride"] = 174.67, ["Neon"] = 453.11, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 512.71, ["Mega"] = 2054.84, ["Mega|Fly|Ride"] = 1643.87}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.05, ["Ride"] = 91.82, ["Neon"] = 10.5, ["Neon|Ride"] = 141.8, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 70.88, ["Mega|Ride"] = 273.3, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 43.39, ["Fly"] = 205.5, ["Ride"] = 85.32, ["Fly|Ride"] = 144.38, ["Neon"] = 289.4, ["Neon|Ride"] = 363.72, ["Neon|Fly|Ride"] = 320.24, ["Mega"] = 1438.4, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 32.85, ["Fly|Ride"] = 50.7, ["Neon"] = 4.45, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 80.15, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 98.44, ["Mega"] = 65.54, ["Mega|Ride"] = 162.07, ["Mega|Fly|Ride"] = 328.79}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.59, ["Fly"] = 77.43, ["Ride"] = 56.44, ["Neon"] = 39.38, ["Neon|Ride"] = 102.64, ["Mega"] = 233, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 408.68, ["Ride"] = 426.57, ["Fly|Ride"] = 518.44, ["Neon"] = 1050, ["Neon|Ride"] = 1230.03, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 3517.48, ["Mega|Ride"] = 4725, ["Mega|Fly|Ride"] = 4723.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 41.11, ["Ride"] = 54.51, ["Fly|Ride"] = 78.75, ["Neon"] = 1181.24, ["Neon|Ride"] = 246.88, ["Neon|Fly|Ride"] = 274.34, ["Mega|Fly|Ride"] = 1995}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 47.38, ["Ride"] = 16.46, ["Fly|Ride"] = 91.88, ["Neon"] = 8.71, ["Neon|Ride"] = 19.59, ["Neon|Fly|Ride"] = 105, ["Mega"] = 82.56, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 11.57, ["Fly"] = 219.18, ["Ride"] = 42.56, ["Fly|Ride"] = 98.44, ["Neon"] = 59.07, ["Neon|Fly"] = 93.02, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 307.02, ["Mega|Fly"] = 956.82, ["Mega|Ride"] = 290, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.76, ["Ride"] = 20.56, ["Fly|Ride"] = 82.21, ["Neon"] = 137.69, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 164.4, ["Mega"] = 1096.27, ["Mega|Ride"] = 515.71, ["Mega|Fly|Ride"] = 412.84}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.77, ["Neon"] = 16.57, ["Mega"] = 70.88, ["Mega|Fly"] = 91.77, ["Mega|Ride"] = 131.14}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.45, ["Fly"] = 39.38, ["Ride"] = 17.52, ["Fly|Ride"] = 55.5, ["Neon"] = 32.16, ["Neon|Ride"] = 32.78, ["Neon|Fly|Ride"] = 269.19, ["Mega"] = 152.07, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 101.62, ["Ride"] = 147, ["Fly|Ride"] = 224.43, ["Neon"] = 767.49, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 853.12, ["Mega|Fly|Ride"] = 2875.76}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.69, ["Ride"] = 68.16, ["Fly|Ride"] = 85.32, ["Neon"] = 137.69, ["Neon|Ride"] = 205.5, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 682.5, ["Mega|Ride"] = 821.94, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2231.25, ["Fly"] = 2464.79, ["Ride"] = 2165.52, ["Fly|Ride"] = 2254.88, ["Neon"] = 10959.46, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.1, ["Fly"] = 65625, ["Ride"] = 115.12, ["Fly|Ride"] = 196.87, ["Neon"] = 12.27, ["Neon|Fly|Ride"] = 105, ["Mega"] = 95.45, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 9.91, ["Ride"] = 43.17, ["Neon"] = 33.33, ["Neon|Ride"] = 98.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 150.94, ["Mega|Ride"] = 233.24, ["Mega|Fly|Ride"] = 1027.44}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1047.81, ["Fly"] = 1160.28, ["Ride"] = 870.57, ["Fly|Ride"] = 989.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2863.06, ["Mega"] = 11096.1, ["Mega|Fly|Ride"] = 11644.75}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 37.12, ["Ride"] = 77.44, ["Fly|Ride"] = 173.35, ["Neon"] = 170.63, ["Neon|Ride"] = 297.18, ["Neon|Fly|Ride"] = 367.39, ["Mega"] = 839.9, ["Mega|Ride"] = 959.62, ["Mega|Fly|Ride"] = 821.94}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.25, ["Ride"] = 23.46, ["Fly|Ride"] = 128.15, ["Neon"] = 10.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 202.79, ["Mega|Ride"] = 268.98, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.2, ["Ride"] = 137.69, ["Neon"] = 3.72, ["Neon|Ride"] = 55.23, ["Neon|Fly|Ride"] = 71.94, ["Mega"] = 22.61, ["Mega|Ride"] = 105.83, ["Mega|Fly|Ride"] = 274.34}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 83.88, ["Ride"] = 130.7, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Fly|Ride"] = 603.75, ["Mega"] = 4108.64, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Fly|Ride"] = 73.11, ["Neon"] = 25.6, ["Neon|Ride"] = 52.01, ["Mega"] = 133.7, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 51.35, ["Ride"] = 102.38, ["Fly|Ride"] = 102.76, ["Neon"] = 385.88, ["Neon|Ride"] = 409.96, ["Neon|Fly|Ride"] = 410.99, ["Mega|Fly|Ride"] = 1713.74}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.13, ["Fly"] = 105, ["Fly|Ride"] = 109.95, ["Neon"] = 26.2, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 161.47, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 356.52}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 275.63, ["Ride"] = 301.88, ["Fly|Ride"] = 337.22, ["Neon"] = 1438.92, ["Neon|Ride"] = 853.12, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.18, ["Fly"] = 87.94, ["Ride"] = 19.3, ["Fly|Ride"] = 103.94, ["Neon"] = 52.46, ["Neon|Fly"] = 155.8, ["Neon|Ride"] = 56.05, ["Neon|Fly|Ride"] = 100.06, ["Mega|Ride"] = 308.23, ["Mega|Fly|Ride"] = 390.32}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 15.43, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 20.46, ["Neon|Fly|Ride"] = 69.87, ["Mega"] = 52.5, ["Mega|Fly"] = 136.14, ["Mega|Ride"] = 115.48, ["Mega|Fly|Ride"] = 137.69}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1068.3, ["Ride"] = 1050, ["Fly|Ride"] = 1194.38, ["Neon|Ride"] = 7535.09, ["Neon|Fly|Ride"] = 5548.06, ["Mega"] = 22786.72}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.03, ["Fly"] = 959.51, ["Ride"] = 72.19, ["Fly|Ride"] = 205.5, ["Neon"] = 42.78, ["Neon|Ride"] = 311.75, ["Mega"] = 305.81, ["Mega|Ride"] = 410.99, ["Mega|Fly|Ride"] = 589.29}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 10.5, ["Fly"] = 52.5, ["Ride"] = 40.69, ["Fly|Ride"] = 79.49, ["Neon"] = 25.47, ["Neon|Fly"] = 124.41, ["Neon|Ride"] = 47.19, ["Neon|Fly|Ride"] = 109.95, ["Mega"] = 183.92, ["Mega|Ride"] = 198.8, ["Mega|Fly|Ride"] = 295.39}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 34.37, ["Fly"] = 32.71, ["Ride"] = 38.07, ["Fly|Ride"] = 77, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 2054.84, ["Mega|Ride"] = 1232.91, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.6, ["Ride"] = 27.56, ["Fly|Ride"] = 55.39, ["Neon"] = 72.86, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 88.35, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 367.49, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 425.15}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 38.07, ["Ride"] = 52.5, ["Fly|Ride"] = 400.71, ["Neon"] = 126.06, ["Neon|Ride"] = 378, ["Mega|Ride"] = 548.66, ["Mega|Fly|Ride"] = 562.02}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.05, ["Ride"] = 116.61, ["Fly|Ride"] = 77.9, ["Neon"] = 2.1, ["Neon|Fly"] = 55.5, ["Neon|Ride"] = 109.3, ["Neon|Fly|Ride"] = 310.43, ["Mega"] = 15.75, ["Mega|Ride"] = 79.15, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 58.46, ["Fly"] = 126, ["Ride"] = 91.5, ["Fly|Ride"] = 140.31, ["Neon"] = 393.75, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 423.72, ["Mega"] = 3287.74, ["Mega|Ride"] = 1691.13, ["Mega|Fly|Ride"] = 1326.95}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 91.4, ["Ride"] = 23.63, ["Fly|Ride"] = 70.88, ["Neon"] = 59.07, ["Neon|Ride"] = 90.43, ["Mega"] = 773.07, ["Mega|Ride"] = 386.54, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.05, ["Fly"] = 20.95, ["Ride"] = 15.65, ["Fly|Ride"] = 36.26, ["Neon"] = 15.75, ["Neon|Fly"] = 77.9, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 270.22, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.16, ["Ride"] = 125.99, ["Neon"] = 15.75, ["Neon|Fly"] = 135.63, ["Neon|Fly|Ride"] = 183.92, ["Mega"] = 287.69, ["Mega|Fly|Ride"] = 465.05}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 56.59, ["Ride"] = 74, ["Fly|Ride"] = 262.5, ["Neon"] = 209.68, ["Neon|Ride"] = 248.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1637.72, ["Mega|Ride"] = 1222.64, ["Mega|Fly|Ride"] = 1201.44}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.72, ["Fly"] = 19.53, ["Neon"] = 22.63, ["Neon|Ride"] = 77.07, ["Mega"] = 122.05, ["Mega|Fly|Ride"] = 290.15}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Mega"] = 17.07, ["Mega|Ride"] = 34.94, ["Mega|Fly|Ride"] = 393.37}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.05, ["Fly"] = 102.94, ["Ride"] = 31.86, ["Fly|Ride"] = 39.01, ["Neon"] = 2.1, ["Neon|Ride"] = 32.89, ["Neon|Fly|Ride"] = 164.4, ["Mega"] = 16.59, ["Mega|Ride"] = 44.16, ["Mega|Fly|Ride"] = 143.38}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 30.83, ["Ride"] = 14.9, ["Fly|Ride"] = 56.35, ["Neon"] = 6.57, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 123.31, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 178.78}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 65.63, ["Neon"] = 34.94, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 279.04}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.04, ["Ride"] = 15.4, ["Fly|Ride"] = 31.27, ["Neon"] = 14.58, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 209.35, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.86, ["Ride"] = 91.51, ["Fly|Ride"] = 219.89, ["Neon"] = 196.76, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 1027.44, ["Mega"] = 959.62, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1076.75}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.53, ["Ride"] = 12.35, ["Fly|Ride"] = 35.35, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 16.7, ["Neon|Fly|Ride"] = 41.96, ["Mega"] = 24.94, ["Mega|Ride"] = 24.05, ["Mega|Fly|Ride"] = 129.74}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 5.15, ["Fly"] = 80.15, ["Ride"] = 29.81, ["Fly|Ride"] = 68.85, ["Neon"] = 30.1, ["Neon|Fly"] = 82.91, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 381.19, ["Mega|Fly"] = 321.78, ["Mega|Ride"] = 278.11, ["Mega|Fly|Ride"] = 307.21}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 13.79, ["Fly"] = 39.8, ["Ride"] = 28.29, ["Fly|Ride"] = 97.93, ["Neon"] = 112.93, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 223.01, ["Mega"] = 787.5, ["Mega|Ride"] = 557.82, ["Mega|Fly|Ride"] = 742.91}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Neon"] = 52.5, ["Mega"] = 366.19, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 27.76, ["Ride"] = 14.48, ["Fly|Ride"] = 34.94, ["Neon"] = 4.87, ["Neon|Fly"] = 24.68, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 55.13, ["Mega"] = 44.49, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 76.04, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.73, ["Fly"] = 52.5, ["Ride"] = 38.07, ["Neon"] = 19.48, ["Neon|Fly"] = 109.95, ["Neon|Ride"] = 109.95, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 240.19, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 384.27}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 977.82, ["Fly"] = 1260.66, ["Ride"] = 1023.75, ["Fly|Ride"] = 1077.18, ["Neon"] = 2808.96, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2488.4, ["Mega|Fly|Ride"] = 6929.9}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.77, ["Ride"] = 142.93, ["Fly|Ride"] = 186.02, ["Neon"] = 577.5, ["Neon|Ride"] = 569.63, ["Neon|Fly|Ride"] = 682.22, ["Mega"] = 3081.24, ["Mega|Ride"] = 2603.49, ["Mega|Fly|Ride"] = 2047.5}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 55.5, ["Ride"] = 39.38, ["Neon"] = 6.14, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 205.5, ["Mega"] = 90.43, ["Mega|Fly|Ride"] = 205.5}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.01, ["Ride"] = 102.92, ["Fly|Ride"] = 222.05, ["Neon"] = 288.75, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 1575, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1573.69}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 47.16, ["Fly|Ride"] = 89.4, ["Neon"] = 21.63, ["Neon|Fly"] = 54.66, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 274.34, ["Mega"] = 274.02, ["Mega|Ride"] = 306.9, ["Mega|Fly|Ride"] = 397.63}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 275.25, ["Fly"] = 410.99, ["Ride"] = 315.44, ["Fly|Ride"] = 378, ["Neon|Ride"] = 1219.56, ["Neon|Fly|Ride"] = 1260.66, ["Mega|Fly|Ride"] = 4518.6}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.08, ["Fly|Ride"] = 210.96, ["Neon"] = 31.39, ["Neon|Ride"] = 54.37, ["Mega"] = 355.49, ["Mega|Fly"] = 320.57, ["Mega|Ride"] = 620.84}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 16.46, ["Mega"] = 328.79}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 22.76, ["Ride"] = 256.87, ["Fly|Ride"] = 153.82, ["Neon"] = 155.67, ["Neon|Ride"] = 158.24, ["Mega"] = 603.1, ["Mega|Ride"] = 685.3, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.66, ["Fly|Ride"] = 274.34, ["Neon"] = 20.56, ["Neon|Ride"] = 141.91, ["Mega"] = 240.43, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 454.58}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 12.07, ["Fly|Ride"] = 39.35, ["Neon"] = 2.1, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 37.54, ["Mega"] = 26.25, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4913.48, ["Fly|Ride"] = 4509.75, ["Neon"] = 30822.48, ["Neon|Fly|Ride"] = 18414.38, ["Mega|Fly|Ride"] = 128427}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.13, ["Ride"] = 55.34, ["Neon"] = 52.5, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 299.54, ["Mega|Fly|Ride"] = 410.99}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 18.51, ["Fly|Ride"] = 41.11, ["Neon"] = 15.43, ["Neon|Fly"] = 46.52, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.38, ["Mega|Ride"] = 172.62, ["Mega|Fly|Ride"] = 239.65}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 514.23, ["Fly"] = 547.77, ["Ride"] = 519.58, ["Fly|Ride"] = 568.32, ["Neon"] = 1781.55, ["Neon|Ride"] = 1883.97, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 5851.14}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.05, ["Ride"] = 32.62, ["Neon"] = 18.69, ["Neon|Ride"] = 145.69, ["Mega"] = 140.51, ["Mega|Fly|Ride"] = 685.3}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.18, ["Fly"] = 4109.67, ["Ride"] = 7133.63, ["Neon"] = 23.12, ["Neon|Ride"] = 62.79, ["Neon|Fly|Ride"] = 274.34, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.05, ["Fly"] = 52.48, ["Ride"] = 20.56, ["Neon"] = 5.13, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 22.95, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 44.63, ["Mega|Ride"] = 75.99, ["Mega|Fly|Ride"] = 257.24}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 853.02, ["Ride"] = 666.75, ["Fly|Ride"] = 753.64, ["Neon"] = 2625, ["Neon|Ride"] = 3248.44, ["Neon|Fly|Ride"] = 2455.41}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 63, ["Fly|Ride"] = 410.99, ["Neon"] = 26.25, ["Neon|Ride"] = 67.72, ["Neon|Fly|Ride"] = 217.83, ["Mega"] = 164.07, ["Mega|Ride"] = 224.46, ["Mega|Fly|Ride"] = 344.92}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.87, ["Fly"] = 236.15, ["Ride"] = 26.25, ["Neon"] = 34.13, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 232.54, ["Mega"] = 194.91, ["Mega|Fly"] = 775.46, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 16.21, ["Neon"] = 15.24, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 274.34, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 204.1}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 19.62, ["Ride"] = 38.07, ["Fly|Ride"] = 155.8, ["Neon"] = 117.59, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 308.23, ["Mega"] = 557.82, ["Mega|Fly|Ride"] = 739.76}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.05, ["Fly|Ride"] = 410.99, ["Neon"] = 7.88, ["Neon|Fly"] = 68.85, ["Neon|Ride"] = 45.22, ["Neon|Fly|Ride"] = 183.92, ["Mega"] = 78.75, ["Mega|Ride"] = 137.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 537.6, ["Fly"] = 659.61, ["Ride"] = 538.12, ["Fly|Ride"] = 700.71, ["Neon"] = 2589.57, ["Neon|Ride"] = 2192.52, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 102.76, ["Ride"] = 72.18, ["Fly|Ride"] = 310.43, ["Neon"] = 15.75, ["Neon|Ride"] = 89.15, ["Mega"] = 131.53, ["Mega|Ride"] = 269.07, ["Mega|Fly|Ride"] = 548.66}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 52.4, ["Neon"] = 4.51, ["Neon|Fly"] = 233.24, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 81.38, ["Mega|Ride"] = 137.69, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 15.43, ["Fly|Ride"] = 48.3, ["Neon"] = 3.94, ["Neon|Ride"] = 44.12, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 82.21, ["Mega|Fly"] = 152.07, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.45, ["Ride"] = 28.54, ["Neon"] = 20.56, ["Mega"] = 205.5}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.17, ["Fly"] = 98.44, ["Ride"] = 78.1, ["Fly|Ride"] = 137.69, ["Neon"] = 122.06, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 273.3, ["Mega"] = 1507.24, ["Mega|Ride"] = 789.08, ["Mega|Fly|Ride"] = 754.15}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 15.75, ["Ride"] = 57.24, ["Fly|Ride"] = 128.99, ["Neon"] = 59.07, ["Neon|Ride"] = 129.84, ["Neon|Fly|Ride"] = 247.02, ["Mega"] = 477.23, ["Mega|Fly"] = 548.66, ["Mega|Ride"] = 451.79, ["Mega|Fly|Ride"] = 629.89}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 13.91, ["Fly|Ride"] = 32.81, ["Neon"] = 28.65, ["Neon|Ride"] = 35.48, ["Neon|Fly|Ride"] = 70.79, ["Mega"] = 299.92, ["Mega|Ride"] = 274.34, ["Mega|Fly|Ride"] = 292.36}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.18, ["Ride"] = 65.54, ["Neon"] = 118.02, ["Neon|Ride"] = 135.63, ["Mega|Ride"] = 287.69}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 157.5, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 11.82, ["Neon|Ride"] = 61.66, ["Neon|Fly|Ride"] = 150.84, ["Mega"] = 77.44, ["Mega|Ride"] = 155.8, ["Mega|Fly|Ride"] = 241.84}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.2, ["Ride"] = 30.18, ["Fly|Ride"] = 78.75, ["Neon"] = 274.34, ["Neon|Ride"] = 513.73, ["Neon|Fly|Ride"] = 184.95, ["Mega"] = 923.66}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 34.75, ["Fly"] = 874.13, ["Neon"] = 260.97, ["Mega"] = 274.34, ["Mega|Ride"] = 290.77}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.59, ["Fly"] = 115.39, ["Ride"] = 77.16, ["Fly|Ride"] = 185.66, ["Neon"] = 258.27, ["Neon|Fly"] = 390.43, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 414.77, ["Mega|Ride"] = 1643.92, ["Mega|Fly|Ride"] = 1240.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.09, ["Fly"] = 92.48, ["Ride"] = 75.51, ["Neon"] = 131.25, ["Neon|Ride"] = 203.43, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 630.84, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 18.59, ["Ride"] = 56.44, ["Fly|Ride"] = 137.69, ["Neon"] = 139.53, ["Neon|Ride"] = 284.82, ["Mega"] = 590.63, ["Mega|Ride"] = 778.05, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 17.36, ["Fly"] = 428.28, ["Ride"] = 57.19, ["Fly|Ride"] = 118.13, ["Neon"] = 116.94, ["Neon|Fly"] = 420, ["Neon|Ride"] = 133.25, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 464.37, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 582.39}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 14.94, ["Fly|Ride"] = 28.37, ["Neon"] = 3.94, ["Neon|Fly"] = 26.75, ["Neon|Ride"] = 27.26, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 65.5, ["Mega|Fly"] = 155.8, ["Mega|Ride"] = 77.89, ["Mega|Fly|Ride"] = 393.74}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1890}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 52.87, ["Fly"] = 232.54, ["Ride"] = 103.69, ["Fly|Ride"] = 288.75, ["Neon"] = 309.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 538.13, ["Mega"] = 1507.24, ["Mega|Ride"] = 1395.12, ["Mega|Fly|Ride"] = 1137.36}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 3.93, ["Neon|Fly"] = 96.59, ["Neon|Ride"] = 43.18, ["Neon|Fly|Ride"] = 287.66, ["Mega"] = 27.76, ["Mega|Ride"] = 84.92, ["Mega|Fly|Ride"] = 196.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.06, ["Ride"] = 52.5, ["Fly|Ride"] = 166.45, ["Neon"] = 130.49, ["Neon|Ride"] = 137.69, ["Neon|Fly|Ride"] = 465.05, ["Mega"] = 644.4, ["Mega|Ride"] = 616.46, ["Mega|Fly|Ride"] = 1232.91}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Mega"] = 22.23}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Mega"] = 22.32, ["Mega|Ride"] = 82.21, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 100.25, ["Fly"] = 349.34, ["Ride"] = 155.8, ["Fly|Ride"] = 281.35, ["Neon"] = 393.75, ["Neon|Ride"] = 587.99, ["Neon|Fly|Ride"] = 577.4, ["Mega|Ride"] = 2534.65, ["Mega|Fly|Ride"] = 1829.63}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 18.77, ["Fly|Ride"] = 93, ["Neon"] = 6.24, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.57, ["Mega|Ride"] = 109.81, ["Mega|Fly|Ride"] = 281.71}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 68.85, ["Fly|Ride"] = 86.63, ["Neon"] = 5.62, ["Neon|Ride"] = 40.63, ["Neon|Fly|Ride"] = 137.69, ["Mega"] = 36.67, ["Mega|Ride"] = 123.27, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.05, ["Neon"] = 4.03, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 210, ["Mega"] = 45.94, ["Mega|Ride"] = 275.33, ["Mega|Fly|Ride"] = 236.32}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.05, ["Ride"] = 27.76, ["Neon"] = 3.94, ["Neon|Ride"] = 41.11, ["Mega"] = 65.54, ["Mega|Ride"] = 205.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 63.4, ["Ride"] = 133.84, ["Fly|Ride"] = 616.46, ["Neon"] = 424.07, ["Neon|Ride"] = 548.66, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1507.24, ["Mega|Ride"] = 1541.14, ["Mega|Fly|Ride"] = 1502.1}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.19, ["Ride"] = 64.84, ["Neon"] = 59.6, ["Neon|Ride"] = 157.55, ["Mega"] = 464.93, ["Mega|Ride"] = 873.32}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 340.86, ["Ride"] = 443.63, ["Fly|Ride"] = 748.72, ["Neon"] = 918.75, ["Neon|Ride"] = 1016.13, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4109.67}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.05}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 90.57}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 53.13}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 25.66}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 122.66}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 71.46}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.91}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.02}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 196.88}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 25.71}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.05}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 31.43}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 5.15}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.79}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 207.56}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.69}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.56}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.29}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.29}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 498.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.05}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 685.3}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.28}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1038.98}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.85}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.52}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 15.41}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.34}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 18.2}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 33.69}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.56}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 24.14}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.92}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.11}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.81}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 4.06}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 16.7}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.02}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.18}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 6.56}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1903.13}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 63.7}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 274.14}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.23}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.28}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 8.94}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.49}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.71}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.16}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.03}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 10.69}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 1370.58}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 28.87}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 4.87}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 18.25}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 4.66}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 215.73}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 35.44}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.48}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.05}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.62}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.76}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.91}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 31.47}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.09}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 210}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.54}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.09}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 98.05}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 31.5}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 117.13}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 18.19}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22144.94}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 209.98}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 63}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 43.32}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 42.44}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 41.11}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.45}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 36.74}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 78.53}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.27}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 59.61}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.39}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 109.49}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 410.99}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 4.76}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 3.94}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.41}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.98}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 28.69}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 102.44}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.63}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.89}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.24}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 7.96}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 756}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 9.1}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.46}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.6}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 604.55}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 25.12}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.31}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 18.21}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 23.37}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 43.95}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 11.79}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.46}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.77}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.62}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 15.65}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 2.14}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 27.2}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.62}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 6.57}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.24}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 18.69}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 191.02}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 55.5}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.05}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1048.58}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.03}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.49}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.76}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 21.29}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 13.72}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 7.14}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 10.11}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.01}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 30.74}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 30.83}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.07}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.77}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 3.52}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.77}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 15.43}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.61}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.5}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.41}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7535.09}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.61}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 18.63}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 9.02}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.02}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 9.11}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 6.9}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 6.8}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.25}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.05}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 109.95}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.48}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.6}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.34}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 98.69}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 6.18}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4301.58}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 7.7}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.5}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 3.31}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.58}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.1}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 58.05}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 65.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 104.89}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 6.76}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.35}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.07}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 39.06}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 3.17}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.12}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.62}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.86}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.43}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.05}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 24.05}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.68}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 4.67}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 8.45}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 78.56}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.51}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 53.11}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 4.07}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.3}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 918.23}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.05}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 42.62}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.51}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.05}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 7.67}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 20.34}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 6.18}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.52}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.45}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.28}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 11.46}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 12.5}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.15}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.49}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.57}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.24}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.22}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.53}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.41}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.65}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.05}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 11.71}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 17.75}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 46.34}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.63}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.94}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.05}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 23.7}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 61.67}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 4.99}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 4.67}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 84}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 28.88}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.05}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.82}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.15}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.83}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.78}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.42}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.52}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 142.95}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.71}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 233.24}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.26}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 196.88}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 52.5}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.35}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.35}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 32.71}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 14.81}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 6.93}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.43}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.05}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.19}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.81}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 65.54}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 9.32}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 50.02}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 20.29}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 132.45}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.03}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 78.41}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.49}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.05}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.24}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 63.32}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 49.98}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 64.43}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 402.94}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 50.87}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 114.22}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.3}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.81}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 25.83}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 55}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.72}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 51.35}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.23}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 42.62}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.63}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.44}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 52.17}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 22.23}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 5.02}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.05}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 19.24}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 46.65}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.84}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 9.95}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 45.66}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 26.25}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.66}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1782.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.16}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 7.88}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 36.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 377.03}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.75}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 10.02}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.02}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 269.07}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 47.97}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 56}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 131.06}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 157.49}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.24}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 62.98}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1023.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 211.63}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.88}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2329.17}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.52}},
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