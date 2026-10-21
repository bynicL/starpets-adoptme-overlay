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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1049.9, ["Ride"] = 1050, ["Fly|Ride"] = 1292.82, ["Neon"] = 6666.08, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 4235.63, ["Mega|Fly|Ride"] = 17458.42}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.65, ["Ride"] = 497.44, ["Fly|Ride"] = 545.98, ["Neon|Fly|Ride"] = 1967.44, ["Mega"] = 11902.38, ["Mega|Fly|Ride"] = 6931.33}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4954.69, ["Ride"] = 4700.49, ["Fly|Ride"] = 4954.69, ["Neon|Fly|Ride"] = 20724.64, ["Mega|Fly|Ride"] = 70013.63}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 160.12, ["Ride"] = 222.5, ["Fly|Ride"] = 275.36, ["Neon"] = 980.65, ["Neon|Ride"] = 897.93, ["Neon|Fly|Ride"] = 1049.18, ["Mega|Fly|Ride"] = 4199.76}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 839.97, ["Ride"] = 538.13, ["Fly|Ride"] = 643.13, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6665.35}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.54, ["Ride"] = 57.68, ["Fly|Ride"] = 129.94, ["Neon"] = 51.19, ["Neon|Fly"] = 280.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 350.78, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 587.07}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.42, ["Fly"] = 34.18, ["Ride"] = 24.15, ["Fly|Ride"] = 42.02, ["Neon"] = 26.01, ["Neon|Fly"] = 103.67, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 115.74, ["Mega"] = 162.62, ["Mega|Ride"] = 196.4, ["Mega|Fly|Ride"] = 291.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 91.88, ["Fly"] = 210, ["Ride"] = 147.02, ["Neon"] = 525, ["Neon|Ride"] = 493.5, ["Neon|Fly|Ride"] = 658.49, ["Mega"] = 2071, ["Mega|Fly|Ride"] = 2742.09}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 39.38, ["Fly"] = 83.3, ["Ride"] = 44.1, ["Fly|Ride"] = 103.52, ["Neon"] = 275.63, ["Neon|Ride"] = 237.96, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 1400.98, ["Mega|Ride"] = 1270, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 16.86, ["Fly"] = 81.76, ["Ride"] = 30.19, ["Fly|Ride"] = 69.34, ["Neon"] = 145.97, ["Neon|Ride"] = 238.41, ["Neon|Fly|Ride"] = 280.42, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 38.97, ["Fly"] = 111.3, ["Ride"] = 70.87, ["Fly|Ride"] = 182.25, ["Neon"] = 445.22, ["Neon|Ride"] = 236.31, ["Neon|Fly|Ride"] = 420.1, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.36}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 313.5, ["Fly"] = 392.68, ["Ride"] = 326.8, ["Fly|Ride"] = 374.07, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1122.19, ["Mega|Fly|Ride"] = 4969.56}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 124.69, ["Fly"] = 135.06, ["Ride"] = 94.33, ["Fly|Ride"] = 147, ["Neon|Fly"] = 690.43, ["Neon|Ride"] = 573.56, ["Neon|Fly|Ride"] = 635.6, ["Mega|Fly|Ride"] = 3055.36}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 2.1, ["Ride"] = 54.78, ["Fly|Ride"] = 131.25, ["Neon"] = 17.07, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 128.63, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 168.05, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 183.43, ["Fly"] = 232.83, ["Ride"] = 178.26, ["Fly|Ride"] = 196.88, ["Neon"] = 833.27, ["Neon|Ride"] = 868.53, ["Neon|Fly|Ride"] = 833.18, ["Mega"] = 3220.98, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 2.51, ["Fly"] = 19.69, ["Ride"] = 17.85, ["Fly|Ride"] = 37.72, ["Neon"] = 29.63, ["Neon|Fly"] = 126.04, ["Neon|Ride"] = 92.44, ["Neon|Fly|Ride"] = 116.94, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 81.38, ["Fly"] = 284.72, ["Ride"] = 139.95, ["Fly|Ride"] = 190.82, ["Neon"] = 280.35, ["Neon|Ride"] = 354.27, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1703.79, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1422.75}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.3}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 52.5, ["Ride"] = 99.77, ["Fly|Ride"] = 178.5, ["Neon"] = 279.37, ["Neon|Fly|Ride"] = 787.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 16.3, ["Fly"] = 393.75, ["Ride"] = 32.15, ["Fly|Ride"] = 377.99, ["Neon"] = 207.03, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 275.17, ["Mega"] = 2737.55, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 628.03}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 21.2, ["Fly"] = 140.7, ["Ride"] = 54.28, ["Fly|Ride"] = 99.75, ["Neon"] = 280.42, ["Neon|Ride"] = 296.18, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1666.34, ["Mega|Ride"] = 1400.98, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 27.55, ["Fly"] = 72.19, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 395.21, ["Neon|Ride"] = 371.16, ["Neon|Fly|Ride"] = 449.5, ["Mega"] = 1967.44, ["Mega|Fly|Ride"] = 1274.96}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 16.94, ["Ride"] = 35.18, ["Fly|Ride"] = 84, ["Neon"] = 210.06, ["Neon|Ride"] = 213.57, ["Neon|Fly|Ride"] = 299.95, ["Mega"] = 890.59, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 37.49, ["Fly"] = 49.37, ["Ride"] = 57.74, ["Fly|Ride"] = 127.09, ["Neon"] = 284.45, ["Neon|Fly"] = 233.17, ["Neon|Ride"] = 220.82, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 3.99, ["Fly"] = 27.13, ["Ride"] = 18.69, ["Fly|Ride"] = 52.48, ["Neon"] = 21.95, ["Neon|Fly"] = 101.05, ["Neon|Ride"] = 48.54, ["Neon|Fly|Ride"] = 95.69, ["Mega"] = 157.5, ["Mega|Fly"] = 301.88, ["Mega|Ride"] = 170.5, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 446.25, ["Ride"] = 433.86, ["Fly|Ride"] = 505.85, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega|Fly|Ride"] = 7686.42}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.55, ["Ride"] = 32.33, ["Fly|Ride"] = 108.43, ["Neon"] = 212.67, ["Mega|Ride"] = 798.16, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 6.57, ["Fly"] = 34.7, ["Ride"] = 20.56, ["Fly|Ride"] = 32.82, ["Neon"] = 52.5, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 113.24, ["Mega"] = 252.07, ["Mega|Ride"] = 294.07, ["Mega|Fly|Ride"] = 450.57}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86.1, ["Fly"] = 102.38, ["Ride"] = 102.66, ["Fly|Ride"] = 131.24, ["Neon"] = 328.13, ["Neon|Fly"] = 368.64, ["Neon|Ride"] = 410.65, ["Neon|Fly|Ride"] = 399, ["Mega"] = 4074.79, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1587.92}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.8, ["Ride"] = 23.59, ["Fly|Ride"] = 118.13, ["Neon"] = 131.25, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 700.49, ["Mega|Ride"] = 793.91, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 206.05, ["Fly"] = 354.89, ["Ride"] = 218.39, ["Fly|Ride"] = 275.62, ["Neon"] = 672.79, ["Neon|Ride"] = 728.85, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 6301.2, ["Mega|Fly|Ride"] = 3016.08}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.2}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 2.63, ["Fly"] = 32.15, ["Ride"] = 23.81, ["Fly|Ride"] = 53.99, ["Neon"] = 20.56, ["Neon|Fly"] = 135.72, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 126.04, ["Mega"] = 152.39, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 892.46, ["Fly"] = 2625, ["Ride"] = 889.45, ["Fly|Ride"] = 1092.66, ["Neon"] = 10207.32, ["Neon|Ride"] = 6161.53, ["Neon|Fly|Ride"] = 4282.32, ["Mega|Ride"] = 53560.7, ["Mega|Fly|Ride"] = 17083.5}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 7.88, ["Fly"] = 70.35, ["Ride"] = 27.64, ["Fly|Ride"] = 91.49, ["Neon"] = 91.88, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 232.12, ["Mega"] = 766.66, ["Mega|Ride"] = 1070.16, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 149.63, ["Ride"] = 241.84, ["Fly|Ride"] = 236.25, ["Neon"] = 830.82, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 977.74, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.63}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.63, ["Fly"] = 112.35, ["Ride"] = 65.54, ["Fly|Ride"] = 140.7, ["Neon"] = 98.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 700.49, ["Mega|Ride"] = 1107.98, ["Mega|Fly|Ride"] = 317.81}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 123.14, ["Ride"] = 136.49, ["Fly|Ride"] = 236.25, ["Neon"] = 609.13, ["Neon|Ride"] = 446.92, ["Mega|Fly|Ride"] = 2723.17}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 115.49, ["Fly"] = 157.49, ["Ride"] = 164.07, ["Fly|Ride"] = 274.31, ["Neon"] = 360.94, ["Neon|Fly"] = 560.82, ["Neon|Ride"] = 349.47, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1555.5}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 30.93}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.4, ["Fly"] = 58.82, ["Ride"] = 52.26, ["Fly|Ride"] = 73.36, ["Neon|Ride"] = 389.22, ["Neon|Fly|Ride"] = 302.27, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 4.14, ["Fly"] = 70.35, ["Ride"] = 35.43, ["Fly|Ride"] = 157.49, ["Neon"] = 35.72, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 560.82, ["Mega"] = 183.3, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 298.97, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 485.31, ["Fly"] = 462, ["Ride"] = 476.34, ["Fly|Ride"] = 524.98, ["Neon|Ride"] = 2023.42, ["Neon|Fly|Ride"] = 1690.81, ["Mega|Ride"] = 14702.8, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 104.98, ["Fly"] = 151.22, ["Ride"] = 118.12, ["Fly|Ride"] = 178.5, ["Neon"] = 420, ["Neon|Fly"] = 840.17, ["Neon|Ride"] = 552.42, ["Neon|Fly|Ride"] = 666.54, ["Mega|Ride"] = 2519.45, ["Mega|Fly|Ride"] = 2239.05}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3412.5, ["Ride"] = 3885, ["Fly|Ride"] = 3674.99, ["Neon|Fly|Ride"] = 14701.76}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 41.85, ["Fly"] = 119.7, ["Ride"] = 56.58, ["Fly|Ride"] = 128.43, ["Neon|Ride"] = 322.87, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 1574.26, ["Mega|Ride"] = 1792.7, ["Mega|Fly|Ride"] = 1448.24}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 85.32, ["Fly|Ride"] = 136.73, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega|Ride"] = 2241.15, ["Mega|Fly|Ride"] = 2101.54}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.56, ["Fly"] = 56.24, ["Ride"] = 46.09, ["Fly|Ride"] = 77.97, ["Neon"] = 210.06, ["Neon|Fly"] = 196.4, ["Neon|Ride"] = 140.34, ["Neon|Fly|Ride"] = 203.13, ["Mega"] = 980.89, ["Mega|Ride"] = 686.85, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.32}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 38.1, ["Fly"] = 56.72, ["Ride"] = 56.63, ["Fly|Ride"] = 65.62, ["Neon|Ride"] = 317.81, ["Neon|Fly|Ride"] = 420.1, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.71}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 197.03, ["Ride"] = 229.69, ["Fly|Ride"] = 301.88, ["Neon|Ride"] = 1092.21, ["Neon|Fly|Ride"] = 1088.03, ["Mega|Fly|Ride"] = 4528.48}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["Ride"] = 943.69, ["Fly|Ride"] = 980.65, ["Neon|Fly|Ride"] = 3372.21, ["Mega|Fly|Ride"] = 10791.89}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 4.78}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 24.92, ["Fly"] = 56.37, ["Ride"] = 32.09, ["Fly|Ride"] = 58.97, ["Neon"] = 245.76, ["Neon|Ride"] = 166.68, ["Neon|Fly|Ride"] = 211.77, ["Mega|Ride"] = 1142.65, ["Mega|Fly|Ride"] = 762.74}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 4856.25, ["Ride"] = 6194.68, ["Fly|Ride"] = 4829.99, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 42055.88}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 10.27, ["Fly"] = 55.12, ["Ride"] = 27.37, ["Fly|Ride"] = 54.76, ["Neon"] = 95.82, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 126.04, ["Mega"] = 700.49, ["Mega|Ride"] = 1514.52, ["Mega|Fly|Ride"] = 700.88}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 15.2, ["Fly"] = 139.89, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 95.59, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 918.75, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 70.87, ["Fly"] = 280.35, ["Ride"] = 58.95, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 374.07, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4200.8}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.2, ["Fly"] = 70.35, ["Ride"] = 25.8, ["Fly|Ride"] = 78.75, ["Neon"] = 70.39, ["Neon|Ride"] = 134.44, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 1400.98, ["Mega|Ride"] = 746.29, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1666.88, ["Fly"] = 2078.55, ["Ride"] = 1767.15, ["Fly|Ride"] = 1611.75, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27428.63, ["Fly"] = 33598.19, ["Ride"] = 32812.5, ["Fly|Ride"] = 27008.68, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 72684.25, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.46, ["Fly"] = 393.75, ["Ride"] = 55.11, ["Fly|Ride"] = 90.96, ["Neon"] = 275.1, ["Neon|Ride"] = 210.06, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 840.17, ["Mega|Ride"] = 1008.21, ["Mega|Fly|Ride"] = 1361.08}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.49, ["Fly"] = 75.13, ["Ride"] = 26.25, ["Fly|Ride"] = 109.2, ["Neon"] = 19.65, ["Neon|Fly"] = 145.16, ["Neon|Ride"] = 63.67, ["Neon|Fly|Ride"] = 140.48, ["Mega"] = 131.25, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 18.27}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 5.25, ["Ride"] = 37.9, ["Fly|Ride"] = 124.67, ["Neon"] = 58.45, ["Neon|Ride"] = 139.07, ["Neon|Fly|Ride"] = 472.6, ["Mega"] = 326.62, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 714, ["Ride"] = 682.5, ["Fly|Ride"] = 735, ["Neon"] = 3016.4, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11109.7}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 918.75, ["Fly"] = 975.19, ["Ride"] = 827.94, ["Fly|Ride"] = 904.32, ["Neon|Ride"] = 3641.06, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 10642.73}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 9.05, ["Fly"] = 119, ["Ride"] = 30.18, ["Fly|Ride"] = 71.38, ["Neon"] = 70.39, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 213.94, ["Mega"] = 1200.96, ["Mega|Ride"] = 933.45, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.82}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 68.4, ["Fly"] = 111.3, ["Ride"] = 78.44, ["Fly|Ride"] = 112.26, ["Neon"] = 420, ["Neon|Ride"] = 399.09, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2056.31, ["Mega|Fly|Ride"] = 1664.25}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 72.17, ["Ride"] = 123.92, ["Fly|Ride"] = 214.17, ["Neon"] = 450.19, ["Neon|Fly"] = 397.61, ["Neon|Ride"] = 366.59, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1366.73, ["Mega|Ride"] = 1890.37, ["Mega|Fly|Ride"] = 1935.53}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.55, ["Fly"] = 35.43, ["Ride"] = 22.19, ["Fly|Ride"] = 41.71, ["Neon"] = 23.63, ["Neon|Fly"] = 525, ["Neon|Ride"] = 65.13, ["Neon|Fly|Ride"] = 91.88, ["Mega|Fly|Ride"] = 507.94}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 120.85, ["Fly"] = 146.9, ["Ride"] = 140.7, ["Fly|Ride"] = 157.5, ["Neon"] = 725.82, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 531.44, ["Mega|Fly|Ride"] = 2028.99}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.67, ["Ride"] = 32.71, ["Fly|Ride"] = 168, ["Neon"] = 42, ["Neon|Ride"] = 82.69, ["Mega"] = 196.88, ["Mega|Ride"] = 476.12, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 10.36, ["Fly"] = 41.65, ["Ride"] = 32.69, ["Fly|Ride"] = 77.72, ["Neon"] = 98.44, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 140.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 29.43, ["Ride"] = 60.27, ["Fly|Ride"] = 156.19, ["Neon"] = 183.75, ["Neon|Ride"] = 317.81, ["Mega"] = 918.74, ["Mega|Ride"] = 1161.57}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 13.12, ["Fly"] = 84.02, ["Ride"] = 35.75, ["Fly|Ride"] = 67.38, ["Neon"] = 91.87, ["Neon|Ride"] = 114.59, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 918.75, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 7376.61, ["Ride"] = 6555.94, ["Fly|Ride"] = 5502, ["Neon"] = 35007.34, ["Neon|Ride"] = 24281.25, ["Neon|Fly|Ride"] = 27851.29}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 190.38, ["Fly"] = 242.16, ["Ride"] = 196.88, ["Fly|Ride"] = 272.52, ["Neon"] = 525, ["Neon|Ride"] = 737.97, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 1892.62}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 27.61, ["Fly"] = 95.2, ["Ride"] = 85.32, ["Fly|Ride"] = 142.93, ["Neon"] = 105, ["Neon|Fly"] = 254.76, ["Neon|Ride"] = 164.92, ["Neon|Fly|Ride"] = 229.68, ["Mega"] = 393.75, ["Mega|Fly"] = 574.48, ["Mega|Ride"] = 419.87, ["Mega|Fly|Ride"] = 539.43}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.42, ["Fly"] = 88.06, ["Ride"] = 28.25, ["Fly|Ride"] = 52.5, ["Neon"] = 31.5, ["Neon|Fly"] = 60.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 191.16, ["Mega"] = 195.35, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 355.89}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 51.19, ["Fly"] = 5393.26, ["Ride"] = 99.32, ["Fly|Ride"] = 105.02, ["Neon"] = 227.39, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 381.22, ["Mega"] = 532.47, ["Mega|Ride"] = 635.6, ["Mega|Fly|Ride"] = 609.87}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13387.5, ["Fly|Ride"] = 12206.25, ["Neon|Fly|Ride"] = 24937.5, ["Mega|Fly|Ride"] = 111951.23}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 267.75, ["Ride"] = 261.19, ["Fly|Ride"] = 317.09, ["Neon"] = 1260.26, ["Neon|Ride"] = 1400.98, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 6002.95}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 70.35, ["Fly"] = 78.77, ["Ride"] = 56.82, ["Fly|Ride"] = 119.43, ["Neon"] = 398.99, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 524.98, ["Mega|Fly|Ride"] = 3149.56}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 6.49, ["Fly"] = 27.96, ["Ride"] = 25.74, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 270.22, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 110.25, ["Mega"] = 360.94, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 379.32, ["Fly"] = 839.97, ["Ride"] = 392.44, ["Fly|Ride"] = 500.07, ["Neon"] = 1568.76, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1540.66, ["Mega|Fly|Ride"] = 4856.25}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 4.74, ["Fly"] = 104.11, ["Ride"] = 38.06, ["Fly|Ride"] = 111.57, ["Neon"] = 32.07, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 192.21, ["Mega"] = 128.52, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 213.49, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 102.38, ["Fly"] = 195.32, ["Ride"] = 131.15, ["Fly|Ride"] = 189, ["Neon"] = 626.07, ["Neon|Fly"] = 525, ["Neon|Ride"] = 510.87, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2273.48}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.4, ["Fly"] = 19.05, ["Ride"] = 18.8, ["Fly|Ride"] = 30.72, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 90.02, ["Mega"] = 2520.5, ["Mega|Fly|Ride"] = 952.21}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 5.15}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 63, ["Ride"] = 58.36, ["Fly|Ride"] = 419.99, ["Neon"] = 421.32, ["Neon|Fly"] = 419.05, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 504.12, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1821.06}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 7.88, ["Fly"] = 103.97, ["Ride"] = 32.96, ["Fly|Ride"] = 97.13, ["Neon"] = 91.88, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 629.08, ["Mega|Ride"] = 629.08, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 30.32, ["Fly"] = 210, ["Ride"] = 109.79, ["Fly|Ride"] = 85.32, ["Neon"] = 284.62, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1575.31, ["Mega|Ride"] = 2100.4, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 2.63, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 20.79, ["Neon|Ride"] = 103.57, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 131.24, ["Mega|Ride"] = 213.42, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.1, ["Fly"] = 52.5, ["Ride"] = 28.25, ["Fly|Ride"] = 79.73, ["Neon"] = 159.52, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 210.06, ["Mega|Ride"] = 640.64, ["Mega|Fly|Ride"] = 635.6}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 437.77, ["Ride"] = 495.24, ["Fly|Ride"] = 485.63, ["Neon|Fly|Ride"] = 1961.78, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 31, ["Fly"] = 98.72, ["Ride"] = 57.58, ["Fly|Ride"] = 131.24, ["Neon"] = 175.35, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 326.21, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 2730}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 43.74, ["Fly"] = 119.7, ["Ride"] = 70.87, ["Fly|Ride"] = 100.33, ["Neon"] = 312.93, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 458.07, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 15.75, ["Fly"] = 84.32, ["Ride"] = 63.67, ["Fly|Ride"] = 119.55, ["Neon"] = 97, ["Neon|Ride"] = 155.65, ["Neon|Fly|Ride"] = 294.07, ["Mega"] = 414.74, ["Mega|Fly"] = 525, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 607.03}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 10569.79, ["Fly"] = 26250, ["Ride"] = 13643.16, ["Fly|Ride"] = 7868.44, ["Neon|Fly|Ride"] = 17646.57, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1339.46, ["Fly"] = 1486.83, ["Ride"] = 1509.36, ["Fly|Ride"] = 1443.73, ["Neon|Fly|Ride"] = 3936.18, ["Mega|Fly|Ride"] = 14437.5}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 586.94, ["Ride"] = 761.48, ["Fly|Ride"] = 538.12, ["Neon"] = 2548.51, ["Neon|Fly|Ride"] = 2380.82, ["Mega|Fly|Ride"] = 7001.69}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.31, ["Fly"] = 20.29, ["Ride"] = 21.63, ["Fly|Ride"] = 35.53, ["Neon"] = 67.83, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 2.77, ["Fly"] = 78.74, ["Ride"] = 28.37, ["Fly|Ride"] = 48.3, ["Neon"] = 20.6, ["Neon|Ride"] = 54.85, ["Mega"] = 140.75, ["Mega|Ride"] = 189.06, ["Mega|Fly|Ride"] = 259.87}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 35.73, ["Fly"] = 53.81, ["Ride"] = 47.82, ["Fly|Ride"] = 82.68, ["Neon"] = 535.68, ["Neon|Ride"] = 155.92, ["Neon|Fly|Ride"] = 196.4, ["Mega|Fly|Ride"] = 586.59}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.6, ["Fly"] = 22.47, ["Ride"] = 15.18, ["Fly|Ride"] = 21.03, ["Neon"] = 31.48, ["Neon|Fly"] = 76.92, ["Neon|Ride"] = 46.24, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 195.57, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 334.59, ["Fly"] = 369.49, ["Ride"] = 321.55, ["Fly|Ride"] = 360.84, ["Neon"] = 1540.66, ["Neon|Ride"] = 1305.26, ["Neon|Fly|Ride"] = 1400.98, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 12.27, ["Fly"] = 59.51, ["Ride"] = 30.94, ["Fly|Ride"] = 105, ["Neon"] = 140.75, ["Neon|Fly"] = 309.83, ["Neon|Ride"] = 142.7, ["Neon|Fly|Ride"] = 257.25, ["Mega"] = 798.16, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 11.57, ["Fly"] = 20.98, ["Ride"] = 20.9, ["Fly|Ride"] = 39.92, ["Neon"] = 98.74, ["Neon|Fly"] = 135.72, ["Neon|Ride"] = 129.06, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 425.25}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 577.5, ["Fly"] = 1048.69, ["Ride"] = 520.79, ["Fly|Ride"] = 537.58, ["Neon|Fly|Ride"] = 2100.4, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1443.75, ["Ride"] = 1214.06, ["Fly|Ride"] = 1384.69, ["Neon|Ride"] = 4313.18, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 88.24, ["Fly"] = 136.5, ["Ride"] = 78.75, ["Fly|Ride"] = 108.6, ["Neon"] = 971.25, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2380.82}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 129.74, ["Fly"] = 196.87, ["Ride"] = 183.36, ["Fly|Ride"] = 202.13, ["Neon"] = 851.51, ["Neon|Fly"] = 699.45, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 618.56, ["Mega"] = 2661.22, ["Mega|Ride"] = 3081.29, ["Mega|Fly|Ride"] = 2792.56}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 27.38, ["Fly"] = 120.75, ["Ride"] = 53.7, ["Fly|Ride"] = 121.37, ["Neon"] = 233.88, ["Neon|Ride"] = 243, ["Mega|Ride"] = 2100.4, ["Mega|Fly|Ride"] = 1048.11}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 183.75, ["Ride"] = 315, ["Fly|Ride"] = 335.99, ["Neon|Fly"] = 952.3, ["Neon|Fly|Ride"] = 1333.07, ["Mega|Fly|Ride"] = 4126.57}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2063.09, ["Fly"] = 2260.58, ["Ride"] = 2483.25, ["Fly|Ride"] = 2230.62, ["Neon|Fly|Ride"] = 10502, ["Mega|Fly|Ride"] = 28565.72}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.79, ["Fly"] = 210, ["Ride"] = 51.83, ["Fly|Ride"] = 196.88, ["Neon"] = 322.35, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 1120.59, ["Mega|Fly|Ride"] = 2520.5}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 643.12, ["Fly"] = 616.88, ["Ride"] = 597.19, ["Fly|Ride"] = 627.38, ["Neon|Ride"] = 1540.66, ["Neon|Fly|Ride"] = 1278.02, ["Mega|Fly|Ride"] = 3412.49}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 38.19, ["Fly"] = 48.55, ["Ride"] = 45.94, ["Fly|Ride"] = 94.37, ["Neon|Ride"] = 266.77, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 2.56, ["Fly"] = 42.74, ["Ride"] = 16.54, ["Fly|Ride"] = 52.29, ["Neon"] = 19.58, ["Neon|Fly"] = 139.12, ["Neon|Ride"] = 36.66, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 138.25, ["Mega|Fly"] = 244.29, ["Mega|Ride"] = 182.76, ["Mega|Fly|Ride"] = 246.88}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 38.17, ["Ride"] = 128.31, ["Fly|Ride"] = 253.32, ["Neon"] = 346.5, ["Neon|Ride"] = 365.71, ["Neon|Fly|Ride"] = 700.49, ["Mega"] = 1535.41, ["Mega|Fly|Ride"] = 1695.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 845.23, ["Fly"] = 892.7, ["Ride"] = 840, ["Fly|Ride"] = 853.13, ["Neon|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 2690.63, ["Mega|Fly|Ride"] = 10964.09}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 721.87, ["Ride"] = 1027.09, ["Fly|Ride"] = 974.36, ["Neon|Fly|Ride"] = 4191.36, ["Mega|Fly|Ride"] = 15261.5}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 8.76, ["Fly"] = 25.71, ["Ride"] = 22.93, ["Fly|Ride"] = 38.68, ["Neon"] = 91.88, ["Neon|Ride"] = 98.74, ["Neon|Fly|Ride"] = 137.82, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 6.57, ["Ride"] = 26.17, ["Fly|Ride"] = 70.35, ["Neon"] = 140.7, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 237.57, ["Mega"] = 623.44, ["Mega|Ride"] = 733.06, ["Mega|Fly|Ride"] = 616.49}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 2.57, ["Ride"] = 22.32, ["Fly|Ride"] = 102.38, ["Neon"] = 19.58, ["Neon|Fly"] = 317.85, ["Neon|Ride"] = 54.48, ["Neon|Fly|Ride"] = 151.17, ["Mega"] = 162.46, ["Mega|Fly"] = 157.5, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 27.68, ["Fly"] = 57.25, ["Ride"] = 45.94, ["Fly|Ride"] = 78.54, ["Neon"] = 266.77, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 233.02, ["Mega|Fly|Ride"] = 1098.53}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 60.41, ["Ride"] = 135.19, ["Fly|Ride"] = 449.39, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2031.09, ["Mega|Ride"] = 1575.31, ["Mega|Fly|Ride"] = 1575.31}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 7.16, ["Fly"] = 43.31, ["Ride"] = 35.42, ["Fly|Ride"] = 63, ["Neon"] = 98.44, ["Neon|Fly"] = 119.05, ["Neon|Ride"] = 91.86, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 629.08, ["Mega|Ride"] = 363.67, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 39.26, ["Ride"] = 44.6, ["Fly|Ride"] = 75.28, ["Neon"] = 242.82, ["Neon|Fly"] = 1400.98, ["Neon|Ride"] = 190.11, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2100, ["Mega|Ride"] = 1047.06, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 2.15, ["Fly"] = 20.89, ["Ride"] = 16.95, ["Fly|Ride"] = 41.91, ["Neon"] = 29.53, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.73, ["Mega"] = 735.16, ["Mega|Ride"] = 350.78, ["Mega|Fly|Ride"] = 590.62}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 4.03, ["Fly"] = 46.41, ["Ride"] = 33.01, ["Fly|Ride"] = 32198.61, ["Neon"] = 39.38, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 142.85, ["Mega"] = 301.43, ["Mega|Ride"] = 315}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 44.54, ["Fly"] = 65.63, ["Ride"] = 53.24, ["Fly|Ride"] = 96.46, ["Neon"] = 413.07, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1575, ["Fly"] = 1575, ["Ride"] = 1417.4, ["Fly|Ride"] = 1469.99, ["Neon|Fly|Ride"] = 3858.75, ["Mega"] = 100119.68, ["Mega|Fly|Ride"] = 14423.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 479.81, ["Ride"] = 393.75, ["Fly|Ride"] = 478.96, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 10502}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 291.21, ["Ride"] = 262.5, ["Fly|Ride"] = 545.98, ["Neon"] = 1207.5, ["Neon|Ride"] = 1540.66, ["Neon|Fly|Ride"] = 1680.33, ["Mega|Fly|Ride"] = 7654.5}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.21}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 27.56, ["Fly"] = 131.25, ["Ride"] = 46.95, ["Fly|Ride"] = 98.44, ["Neon|Fly"] = 420.1, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 315.07, ["Mega|Ride"] = 1527, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 72796.77, ["Fly"] = 65625, ["Ride"] = 35437.5, ["Fly|Ride"] = 17979.94, ["Neon|Fly|Ride"] = 35437.49, ["Mega"] = 210039.8, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 262.5, ["Fly"] = 317.64, ["Ride"] = 288.75, ["Fly|Ride"] = 339.85, ["Neon"] = 945, ["Neon|Fly"] = 1111.82, ["Neon|Ride"] = 873.71, ["Neon|Fly|Ride"] = 891.45, ["Mega"] = 3990.77, ["Mega|Ride"] = 4199.76, ["Mega|Fly|Ride"] = 3922.51}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 197.3, ["Fly"] = 525, ["Ride"] = 210, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1746.09}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 123.19, ["Fly"] = 280.35, ["Ride"] = 157.5, ["Fly|Ride"] = 229.48, ["Neon|Ride"] = 657.64, ["Neon|Fly|Ride"] = 817.06, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.46, ["Fly"] = 94.5, ["Ride"] = 30.18, ["Fly|Ride"] = 70.35, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 711.78, ["Mega|Ride"] = 700.49, ["Mega|Fly|Ride"] = 750.9}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3936.19, ["Ride"] = 3937.5, ["Fly|Ride"] = 4790.63, ["Neon"] = 27298.53, ["Neon|Fly|Ride"] = 28005.67}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 26.25, ["Fly"] = 39.38, ["Ride"] = 28.29, ["Fly|Ride"] = 47.99, ["Neon"] = 280.42, ["Neon|Ride"] = 343.88, ["Neon|Fly|Ride"] = 240.19, ["Mega|Ride"] = 1400.98, ["Mega|Fly|Ride"] = 733.2}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 39.38, ["Fly"] = 106.51, ["Ride"] = 56.79, ["Fly|Ride"] = 78.75, ["Neon"] = 407.49, ["Neon|Fly"] = 1400.98, ["Neon|Ride"] = 204.75, ["Neon|Fly|Ride"] = 241.5, ["Mega|Fly|Ride"] = 1372.87}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 616.88, ["Ride"] = 629.9, ["Fly|Ride"] = 682.5, ["Neon"] = 2492.58, ["Neon|Ride"] = 2035.69, ["Neon|Fly|Ride"] = 2034.38, ["Mega"] = 8191.57, ["Mega|Fly"] = 8191.57, ["Mega|Fly|Ride"] = 7691.25}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 10.24, ["Fly"] = 21.02, ["Ride"] = 20.14, ["Fly|Ride"] = 39.16, ["Neon"] = 116.82, ["Neon|Fly"] = 158.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.96, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 9.18, ["Ride"] = 27.57, ["Fly|Ride"] = 79.73, ["Neon"] = 81.93, ["Neon|Ride"] = 119.04, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 733.06}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 96.93, ["Ride"] = 128.62, ["Fly|Ride"] = 156.19, ["Neon"] = 789.23, ["Neon|Ride"] = 700.49, ["Neon|Fly|Ride"] = 814.97, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.75, ["Fly"] = 41.91, ["Ride"] = 47.25, ["Fly|Ride"] = 131.06, ["Neon"] = 66.48, ["Neon|Ride"] = 91.72, ["Neon|Fly|Ride"] = 231.72, ["Mega"] = 307.13, ["Mega|Fly"] = 728.85, ["Mega|Ride"] = 276.29, ["Mega|Fly|Ride"] = 409.31}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.83, ["Ride"] = 4034.62, ["Fly|Ride"] = 3937.5, ["Neon"] = 18898.99, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 36756.98, ["Mega|Fly|Ride"] = 36183.25}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 28.25, ["Fly"] = 140.7, ["Ride"] = 65.33, ["Fly|Ride"] = 155.4, ["Neon"] = 399.26, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 571.6, ["Mega"] = 770.86, ["Mega|Ride"] = 1041.81, ["Mega|Fly|Ride"] = 782.23}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7251.57, ["Fly"] = 8679.89, ["Ride"] = 6857.82, ["Fly|Ride"] = 6168.75, ["Neon|Ride"] = 22404.96, ["Neon|Fly|Ride"] = 16625.35, ["Mega|Fly|Ride"] = 65066.74}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.47, ["Fly"] = 22.32, ["Ride"] = 14.12, ["Fly|Ride"] = 31.4, ["Neon"] = 24.61, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 195.57, ["Mega|Ride"] = 210.06, ["Mega|Fly|Ride"] = 347.64}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 24.15, ["Fly"] = 37.68, ["Ride"] = 28.23, ["Fly|Ride"] = 47.61, ["Neon"] = 182.7, ["Neon|Fly"] = 232.12, ["Neon|Ride"] = 102.94, ["Neon|Fly|Ride"] = 158.22, ["Mega|Ride"] = 980.89, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.89}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 9.1, ["Ride"] = 32.93, ["Fly|Ride"] = 116.02, ["Neon"] = 89.14, ["Neon|Ride"] = 139.12, ["Mega"] = 1049.9, ["Mega|Ride"] = 881.13, ["Mega|Fly|Ride"] = 635.6}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 26.25, ["Fly"] = 111.3, ["Ride"] = 43.32, ["Fly|Ride"] = 99.75, ["Neon"] = 203.44, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 318.22, ["Mega"] = 945, ["Mega|Ride"] = 952.21, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.02, ["Fly"] = 20.15, ["Ride"] = 21.44, ["Fly|Ride"] = 34.29, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2520.5, ["Mega|Ride"] = 593.95, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8540.24}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.98}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 17.5}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 225.86, ["Ride"] = 252, ["Fly|Ride"] = 223.13, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.48, ["Fly"] = 129.17, ["Ride"] = 28.77, ["Fly|Ride"] = 126.13, ["Neon"] = 183.81, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 524.91, ["Mega|Fly|Ride"] = 980.89}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.49}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.83, ["Ride"] = 26.25, ["Fly|Ride"] = 84.02, ["Neon|Ride"] = 182.76, ["Neon|Fly|Ride"] = 140.75, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2855.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 175.49, ["Fly"] = 419.99, ["Ride"] = 211.32, ["Fly|Ride"] = 328.13, ["Neon"] = 910.32, ["Neon|Ride"] = 839.12, ["Neon|Fly|Ride"] = 854.88, ["Mega|Ride"] = 4061.13, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 77.78, ["Ride"] = 65.63, ["Fly|Ride"] = 210, ["Neon"] = 770.67, ["Neon|Ride"] = 504.12, ["Neon|Fly|Ride"] = 1435.35, ["Mega|Ride"] = 2100.4, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 131.25, ["Fly"] = 204.75, ["Ride"] = 196.81, ["Fly|Ride"] = 235.11, ["Neon"] = 944.98, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 3324.95}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1967.44, ["Fly"] = 2362.5, ["Ride"] = 1967.44, ["Fly|Ride"] = 2164.98, ["Neon"] = 14751.11, ["Neon|Ride"] = 8736.62, ["Neon|Fly|Ride"] = 7245, ["Mega|Fly|Ride"] = 31366.31}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.15, ["Fly"] = 98.72, ["Ride"] = 28.88, ["Fly|Ride"] = 99.74, ["Neon"] = 127.32, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 196.4, ["Mega"] = 944.14, ["Mega|Ride"] = 1031.96, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 748.13, ["Fly|Ride"] = 721.88, ["Neon|Ride"] = 3081.29, ["Neon|Fly|Ride"] = 4126.57, ["Mega|Fly|Ride"] = 16663.34}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.76}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 12.87, ["Ride"] = 51.97, ["Fly|Ride"] = 280.35, ["Neon"] = 81.29, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 420.1, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 505.32}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.39, ["Fly"] = 167.23, ["Ride"] = 27.56, ["Fly|Ride"] = 100.82, ["Neon"] = 39.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.7, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 635.6}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 71.4}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 13.9, ["Fly"] = 108.92, ["Ride"] = 30.95, ["Fly|Ride"] = 81.92, ["Neon"] = 95.25, ["Neon|Ride"] = 252.07, ["Neon|Fly|Ride"] = 254.62, ["Mega|Fly|Ride"] = 2223.38}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 21.62, ["Fly"] = 39.37, ["Ride"] = 39.29, ["Fly|Ride"] = 52.4, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 318.22, ["Mega|Ride"] = 1785.37, ["Mega|Fly|Ride"] = 978.79}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6793.5, ["Fly|Ride"] = 5105.63, ["Neon|Fly|Ride"] = 12468.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 7.66, ["Fly"] = 65.62, ["Ride"] = 34.11, ["Fly|Ride"] = 81.37, ["Neon"] = 44.56, ["Neon|Fly"] = 77.74, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 178.55, ["Mega"] = 533.24, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 476.12}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 15.28}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 83.16, ["Fly"] = 371.69, ["Ride"] = 132.59, ["Fly|Ride"] = 183.75, ["Neon"] = 525, ["Neon|Ride"] = 455.23, ["Neon|Fly|Ride"] = 700.49, ["Mega"] = 2879.59, ["Mega|Fly|Ride"] = 1957.58}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 39.38, ["Fly"] = 142.78, ["Ride"] = 69.69, ["Fly|Ride"] = 163.68, ["Neon"] = 257.24, ["Neon|Ride"] = 272.37, ["Neon|Fly|Ride"] = 317.81, ["Mega"] = 2380.49, ["Mega|Ride"] = 2835.56, ["Mega|Fly|Ride"] = 1540.66}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 20.09, ["Fly"] = 70.47, ["Ride"] = 28.56, ["Fly|Ride"] = 59.73, ["Neon"] = 156.19, ["Neon|Ride"] = 142.87, ["Neon|Fly|Ride"] = 190.29, ["Mega"] = 1016.21, ["Mega|Ride"] = 873.65, ["Mega|Fly|Ride"] = 774.37}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 3.81, ["Fly"] = 65.54, ["Ride"] = 22.23, ["Fly|Ride"] = 60.92, ["Neon"] = 26.16, ["Neon|Fly"] = 70.39, ["Neon|Ride"] = 50.9, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 190.11, ["Mega|Fly"] = 254.63, ["Mega|Ride"] = 178.29, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.19, ["Ride"] = 27.01, ["Fly|Ride"] = 92.4, ["Neon"] = 86.63, ["Neon|Ride"] = 120.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 635.6, ["Mega|Fly|Ride"] = 742.5}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.31, ["Fly"] = 24.83, ["Ride"] = 26.38, ["Fly|Ride"] = 47.61, ["Neon"] = 364.34, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.92, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 190.32}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 18.8, ["Ride"] = 131.21, ["Fly|Ride"] = 280.35, ["Neon"] = 170.63, ["Neon|Ride"] = 196.4, ["Neon|Fly|Ride"] = 575.53, ["Mega"] = 1183.59, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 209.9, ["Ride"] = 443.63, ["Fly|Ride"] = 1587.17}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 41.25, ["Fly"] = 212.31, ["Ride"] = 102.38, ["Fly|Ride"] = 217.25, ["Neon"] = 269.99, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 423.62, ["Mega"] = 1035.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1079.16}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 918.74, ["Fly"] = 1330.29, ["Ride"] = 1007.97, ["Fly|Ride"] = 1030.32, ["Neon|Fly"] = 4118.68, ["Neon|Ride"] = 3570.7, ["Neon|Fly|Ride"] = 3478.86, ["Mega|Fly|Ride"] = 11735.06}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 432.58, ["Fly"] = 700.32, ["Ride"] = 413.44, ["Fly|Ride"] = 393.75, ["Neon"] = 2139.38, ["Neon|Ride"] = 2100.4, ["Neon|Fly|Ride"] = 3570.7, ["Mega"] = 12602.4, ["Mega|Fly|Ride"] = 8990.63}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 68.95}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.37}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 7.77, ["Fly"] = 19.71, ["Ride"] = 21, ["Fly|Ride"] = 43.32, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.34, ["Neon|Fly|Ride"] = 166.69, ["Mega"] = 437.26, ["Mega|Ride"] = 700.49, ["Mega|Fly|Ride"] = 524.06}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 231.29, ["Fly"] = 392.03, ["Ride"] = 278.25, ["Fly|Ride"] = 320.25, ["Neon"] = 1090.9, ["Neon|Ride"] = 1061.7, ["Neon|Fly|Ride"] = 1035.63, ["Mega|Fly|Ride"] = 3276.63}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 137.82, ["Ride"] = 145.97, ["Fly|Ride"] = 259.85, ["Neon"] = 585.38, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 672.88, ["Mega"] = 2661.22, ["Mega|Ride"] = 3064.5, ["Mega|Fly|Ride"] = 2319.57}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 110.25, ["Ride"] = 128.65, ["Fly|Ride"] = 134.09, ["Neon"] = 840.17, ["Neon|Fly"] = 590.63, ["Neon|Ride"] = 888.57, ["Neon|Fly|Ride"] = 913.5, ["Mega|Ride"] = 5601.78, ["Mega|Fly|Ride"] = 2520.5}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.91, ["Ride"] = 29.16, ["Fly|Ride"] = 171.17, ["Neon"] = 26.25, ["Neon|Ride"] = 86.56, ["Neon|Fly|Ride"] = 137.6, ["Mega"] = 264.75, ["Mega|Ride"] = 249.38, ["Mega|Fly|Ride"] = 839.12}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.25, ["Fly"] = 63.02, ["Ride"] = 27.13, ["Fly|Ride"] = 76.28, ["Neon"] = 177.19, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 317.81, ["Mega|Ride"] = 818.11, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.49, ["Fly"] = 102.35, ["Ride"] = 28.2, ["Fly|Ride"] = 104.69, ["Neon"] = 78.75, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.05, ["Fly"] = 98.18, ["Ride"] = 38.07, ["Fly|Ride"] = 167.23, ["Neon"] = 19.69, ["Neon|Ride"] = 69.03, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 131.25, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 246.65, ["Ride"] = 275.63, ["Fly|Ride"] = 359.63, ["Neon"] = 1652.63, ["Neon|Ride"] = 1330.62, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5545.07}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 112.88, ["Fly"] = 323.64, ["Ride"] = 157.04, ["Fly|Ride"] = 241.48, ["Neon"] = 700.49, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 790.33, ["Mega"] = 2539.99, ["Mega|Fly|Ride"] = 2513.44}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 58.97, ["Ride"] = 67.94, ["Fly|Ride"] = 125.98, ["Neon"] = 380.63, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 416.07, ["Mega"] = 1821.06, ["Mega|Fly|Ride"] = 1801.13}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 14.34, ["Fly"] = 126, ["Ride"] = 58.24, ["Fly|Ride"] = 280.35, ["Neon|Ride"] = 604.66, ["Neon|Fly|Ride"] = 490.46, ["Mega|Fly|Ride"] = 1961.78}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.66, ["Fly"] = 59.07, ["Ride"] = 34.13, ["Fly|Ride"] = 82.04, ["Neon"] = 77.44, ["Neon|Fly"] = 280.42, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 189.26, ["Mega"] = 371.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 436.9, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.1, ["Fly"] = 43.32, ["Ride"] = 18.86, ["Fly|Ride"] = 44.61, ["Neon"] = 16.95, ["Neon|Fly"] = 66.92, ["Neon|Ride"] = 35.35, ["Neon|Fly|Ride"] = 118.1, ["Mega"] = 136.4, ["Mega|Ride"] = 141.91, ["Mega|Fly|Ride"] = 253.62}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 1017.65, ["Fly"] = 911.66, ["Ride"] = 853.13, ["Fly|Ride"] = 918.64, ["Neon"] = 3052.2, ["Neon|Fly"] = 3254.49, ["Neon|Ride"] = 8401.6, ["Neon|Fly|Ride"] = 2624.88, ["Mega"] = 7935.33, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 341.16, ["Ride"] = 393.75, ["Fly|Ride"] = 476.69, ["Neon"] = 1277.38, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1587.78, ["Mega"] = 10502, ["Mega|Fly|Ride"] = 5881.13}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 81.24, ["Fly"] = 140.7, ["Ride"] = 103.64, ["Fly|Ride"] = 207.9, ["Neon"] = 283.08, ["Neon|Ride"] = 319.81, ["Neon|Fly|Ride"] = 535.62, ["Mega"] = 1312.5, ["Mega|Ride"] = 1680.33, ["Mega|Fly|Ride"] = 1663.53}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 232.32, ["Fly"] = 283.5, ["Ride"] = 219.19, ["Fly|Ride"] = 223.13, ["Neon|Fly|Ride"] = 1094.62, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.21, ["Fly"] = 52.5, ["Ride"] = 26.25, ["Fly|Ride"] = 68.62, ["Neon"] = 150.94, ["Neon|Ride"] = 97.46, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 793.91}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 236.24, ["Ride"] = 236.25, ["Fly|Ride"] = 615.28, ["Neon"] = 959.75, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 4171.13, ["Mega|Ride"] = 4620.9, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 56.44, ["Fly"] = 125.98, ["Ride"] = 76.21, ["Fly|Ride"] = 100.11, ["Neon|Ride"] = 560.82, ["Neon|Fly|Ride"] = 560.82, ["Mega|Fly|Ride"] = 1732.5}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1890, ["Ride"] = 1968.75, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 11109.7, ["Neon|Fly|Ride"] = 12602.4, ["Mega"] = 50409.56, ["Mega|Fly|Ride"] = 24505.36}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 10.8, ["Fly"] = 76.36, ["Ride"] = 34.78, ["Fly|Ride"] = 70.75, ["Neon"] = 54.5, ["Neon|Fly"] = 136.9, ["Neon|Ride"] = 103.99, ["Neon|Fly|Ride"] = 192.09, ["Mega"] = 420.1, ["Mega|Fly"] = 763.51, ["Mega|Ride"] = 335.46, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.02, ["Ride"] = 72.18, ["Fly|Ride"] = 126.02, ["Neon"] = 223.13, ["Neon|Ride"] = 350.78, ["Mega"] = 1666.34, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 83.9, ["Fly"] = 78.7, ["Ride"] = 78, ["Fly|Ride"] = 97.13, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.74, ["Mega|Fly|Ride"] = 1842.38}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2697.38, ["Fly"] = 1587.17, ["Ride"] = 1050, ["Fly|Ride"] = 892.5, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 485.63, ["Fly"] = 525, ["Ride"] = 591.13, ["Fly|Ride"] = 629.98, ["Neon|Fly|Ride"] = 3174.39}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 67.93, ["Fly"] = 317.69, ["Ride"] = 84.27, ["Fly|Ride"] = 157.5, ["Neon"] = 350.69, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 557.82, ["Mega|Ride"] = 2653.87, ["Mega|Fly|Ride"] = 2800.89}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 6.36, ["Ride"] = 19.58, ["Fly|Ride"] = 81.92, ["Neon"] = 69.16, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 64.97, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 603.75}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.8, ["Fly"] = 68.25, ["Ride"] = 54.01, ["Fly|Ride"] = 105.02, ["Neon"] = 210.06, ["Neon|Fly"] = 329.78, ["Neon|Ride"] = 217.83, ["Neon|Fly|Ride"] = 386.19, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 748.13, ["Fly"] = 1094.61, ["Ride"] = 737.36, ["Fly|Ride"] = 826.87, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2162.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 760.09}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5118.75, ["Ride"] = 6298.62, ["Fly|Ride"] = 6005.34, ["Neon"] = 42000, ["Neon|Ride"] = 30099.78, ["Neon|Fly|Ride"] = 23488.17, ["Mega|Fly|Ride"] = 89617.69}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 328.13, ["Fly"] = 400.58, ["Ride"] = 393.75, ["Fly|Ride"] = 455.69, ["Neon"] = 1679.92, ["Neon|Fly|Ride"] = 2205.44, ["Mega"] = 6300.16, ["Mega|Fly|Ride"] = 6665.35}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 84, ["Fly"] = 280.35, ["Ride"] = 118.13, ["Fly|Ride"] = 336, ["Neon"] = 712.22, ["Neon|Ride"] = 560.82, ["Neon|Fly|Ride"] = 625.93, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 13.76, ["Fly"] = 65.62, ["Ride"] = 27.91, ["Fly|Ride"] = 89.35, ["Neon"] = 112.4, ["Neon|Fly"] = 1270.15, ["Neon|Ride"] = 125.97, ["Neon|Fly|Ride"] = 180.1, ["Mega"] = 978.79, ["Mega|Ride"] = 840.17, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 7.77, ["Fly"] = 33.62, ["Ride"] = 21.11, ["Fly|Ride"] = 44.36, ["Neon"] = 210, ["Neon|Ride"] = 317.81, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2226.44}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 12.86, ["Ride"] = 26.25, ["Fly|Ride"] = 116.82, ["Neon"] = 101.27, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 232.12, ["Mega"] = 670.69, ["Mega|Ride"] = 658.88, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.15, ["Fly"] = 77.72, ["Ride"] = 19.97, ["Fly|Ride"] = 48.57, ["Neon"] = 35.43, ["Neon|Ride"] = 55.95, ["Neon|Fly|Ride"] = 113.7, ["Mega"] = 317.17, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 22.32, ["Fly"] = 90.57, ["Ride"] = 34.13, ["Fly|Ride"] = 47.61, ["Neon"] = 203.44, ["Neon|Fly"] = 840.17, ["Neon|Ride"] = 247.86, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 603.7, ["Mega|Ride"] = 1246.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 420, ["Fly"] = 538.12, ["Ride"] = 449.97, ["Fly|Ride"] = 494.82, ["Neon"] = 1574.93, ["Neon|Ride"] = 1470.3, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5458.94}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 15.44, ["Fly|Ride"] = 31.52, ["Neon"] = 18.38, ["Neon|Ride"] = 21.95, ["Neon|Fly|Ride"] = 68.93, ["Mega"] = 252.98, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 24.42, ["Fly"] = 103.35, ["Ride"] = 72.1, ["Fly|Ride"] = 105, ["Neon"] = 183.75, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 170.61, ["Neon|Fly|Ride"] = 255.81, ["Mega"] = 524.79, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.75, ["Fly"] = 1035.12, ["Ride"] = 800.63, ["Fly|Ride"] = 787.5, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1674.63, ["Mega|Fly|Ride"] = 3936.18}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.38, ["Fly"] = 54.47, ["Ride"] = 42.49, ["Fly|Ride"] = 78.75, ["Neon"] = 282.59, ["Neon|Ride"] = 188.87, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1575, ["Mega|Fly|Ride"] = 851.75}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 385.34, ["Fly"] = 384.56, ["Ride"] = 288.75, ["Fly|Ride"] = 345.19, ["Neon|Ride"] = 1821.06, ["Neon|Fly|Ride"] = 1120.59}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 170.63, ["Fly"] = 171.41, ["Ride"] = 159.45, ["Fly|Ride"] = 233.63, ["Neon"] = 980.89, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 826.52, ["Mega|Fly|Ride"] = 3431.02}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 754.69, ["Fly|Ride"] = 786.19, ["Neon|Fly|Ride"] = 3010.93, ["Mega|Fly|Ride"] = 7611.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 17.57, ["Fly"] = 84.02, ["Ride"] = 32.57, ["Fly|Ride"] = 100.42, ["Neon"] = 105.02, ["Neon|Fly"] = 285.7, ["Neon|Ride"] = 107.14, ["Neon|Fly|Ride"] = 151.25, ["Mega"] = 354.38, ["Mega|Ride"] = 353.32, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3543.75, ["Ride"] = 3936.19, ["Fly|Ride"] = 3543.75, ["Neon"] = 14003.36, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25003.16}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 111.08, ["Fly"] = 166.28, ["Ride"] = 135.43, ["Fly|Ride"] = 161.32, ["Neon"] = 472.5, ["Neon|Fly"] = 459.38, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Fly|Ride"] = 2387.44}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 27.32, ["Ride"] = 16.45, ["Fly|Ride"] = 43.08, ["Neon"] = 15.74, ["Neon|Fly"] = 65.61, ["Neon|Ride"] = 36.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 140.75, ["Mega|Fly"] = 182.76, ["Mega|Ride"] = 155.45, ["Mega|Fly|Ride"] = 227.07}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 24.51, ["Fly|Ride"] = 57.71, ["Neon"] = 15.74, ["Neon|Fly"] = 116.67, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 266.44, ["Mega"] = 151.11, ["Mega|Ride"] = 203.75, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 31.52, ["Fly"] = 84.02, ["Ride"] = 39.37, ["Fly|Ride"] = 56.34, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1118.84}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 913.5, ["Ride"] = 980.65, ["Fly|Ride"] = 1298.07}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Ride"] = 7135.43, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.69, ["Fly"] = 36.01, ["Ride"] = 25.1, ["Fly|Ride"] = 39.35, ["Neon"] = 452.12, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.81, ["Fly"] = 49.85, ["Ride"] = 25.89, ["Fly|Ride"] = 74.55, ["Neon"] = 85.32, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 107.63, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 662.17, ["Mega|Ride"] = 546.11, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 59.05, ["Fly"] = 157.49, ["Ride"] = 72.19, ["Fly|Ride"] = 115.5, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 454.13, ["Mega|Fly|Ride"] = 1741.09}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 258.57, ["Ride"] = 221.82, ["Fly|Ride"] = 335.99, ["Neon|Ride"] = 980.89, ["Neon|Fly|Ride"] = 977.73, ["Mega|Fly|Ride"] = 4602.66}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 2.57, ["Ride"] = 32.78, ["Fly|Ride"] = 93.19, ["Neon"] = 15.43, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 94.54, ["Mega"] = 149.57, ["Mega|Fly"] = 226.4, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 192.83, ["Fly"] = 238.35, ["Ride"] = 208.69, ["Fly|Ride"] = 288.73, ["Neon"] = 909.57, ["Neon|Fly"] = 840.17, ["Neon|Ride"] = 889.54, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 3219.92, ["Mega|Fly|Ride"] = 3039.14}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 14.3, ["Fly|Ride"] = 35.3, ["Neon"] = 18.8, ["Neon|Fly"] = 126.04, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 269, ["Mega|Ride"] = 182.76, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 223.13, ["Fly"] = 280.35, ["Ride"] = 208.69, ["Fly|Ride"] = 231.55, ["Neon|Fly|Ride"] = 892.18, ["Mega"] = 10502, ["Mega|Ride"] = 4725.91, ["Mega|Fly|Ride"] = 4898.15}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 10.05, ["Fly"] = 74.37, ["Ride"] = 27.32, ["Fly|Ride"] = 68.25, ["Neon"] = 71.31, ["Neon|Fly"] = 302.36, ["Neon|Ride"] = 155.45, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 489.41, ["Mega|Ride"] = 532.47, ["Mega|Fly|Ride"] = 490.46}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 23.3, ["Neon"] = 14.34, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 65.63, ["Mega|Ride"] = 109.73, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.56, ["Mega"] = 18.19, ["Mega|Ride"] = 140.46, ["Mega|Fly|Ride"] = 315.07}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 31.25, ["Fly|Ride"] = 108.17, ["Neon"] = 6, ["Neon|Ride"] = 43.43, ["Neon|Fly|Ride"] = 105.04, ["Mega"] = 70.96, ["Mega|Fly"] = 158699.15, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 76.12, ["Fly"] = 142.78, ["Ride"] = 105.45, ["Fly|Ride"] = 128.63, ["Neon"] = 262.4, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 364.88, ["Mega|Fly|Ride"] = 1194.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.52, ["Ride"] = 15.73, ["Fly|Ride"] = 111.3, ["Neon"] = 9.06, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 95.23, ["Mega|Ride"] = 155.45, ["Mega|Fly|Ride"] = 261.44}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.09, ["Neon"] = 78.61, ["Neon|Ride"] = 259.88, ["Mega|Ride"] = 317.81, ["Mega|Fly|Ride"] = 476.8}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 56.79, ["Neon"] = 2.1, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 164.93, ["Mega"] = 14.44, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 312.41}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 1.79, ["Fly"] = 61.74, ["Ride"] = 15.73, ["Fly|Ride"] = 42.02, ["Neon"] = 2.1, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 14.18, ["Neon|Fly|Ride"] = 38.11, ["Mega"] = 12.87, ["Mega|Fly"] = 42.02, ["Mega|Ride"] = 18.66, ["Mega|Fly|Ride"] = 64.31}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 17.85, ["Ride"] = 12.67, ["Fly|Ride"] = 62.84, ["Neon"] = 2.1, ["Neon|Fly"] = 39.29, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 39.24, ["Mega"] = 28, ["Mega|Fly"] = 159.51, ["Mega|Ride"] = 31.4, ["Mega|Fly|Ride"] = 77.6}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.55, ["Mega"] = 22.31, ["Mega|Ride"] = 121.84, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 21, ["Fly|Ride"] = 107.61, ["Neon"] = 3.75, ["Neon|Fly"] = 167.97, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 79.75, ["Mega"] = 24.34, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 95.42}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 14.43, ["Mega|Fly"] = 95.23, ["Mega|Ride"] = 210.06, ["Mega|Fly|Ride"] = 195.56}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.25, ["Fly"] = 77.44, ["Ride"] = 32.79, ["Fly|Ride"] = 70.35, ["Neon"] = 12.5, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 119.04, ["Mega"] = 112.4, ["Mega|Fly"] = 131.17, ["Mega|Ride"] = 126.02, ["Mega|Fly|Ride"] = 196.75}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 50.94, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 11.85, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 61.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 141.75, ["Fly|Ride"] = 525, ["Neon"] = 16.65, ["Mega"] = 141.91, ["Mega|Fly"] = 315, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 544.02}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Neon"] = 16.7, ["Mega"] = 78.75, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.77, ["Neon|Ride"] = 27.33, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 19.15, ["Mega|Ride"] = 58.29, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 12.5, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 32.24, ["Mega"] = 15.02, ["Mega|Fly"] = 36.75, ["Mega|Ride"] = 18.27, ["Mega|Fly|Ride"] = 49.88}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.69, ["Fly|Ride"] = 118.11, ["Neon"] = 36.75, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 168.05, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 26.46, ["Neon"] = 2.91, ["Neon|Ride"] = 23.16, ["Neon|Fly|Ride"] = 105, ["Mega"] = 22.31, ["Mega|Ride"] = 45.84, ["Mega|Fly|Ride"] = 172.25}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.4, ["Neon"] = 14.07, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 78.75, ["Mega|Ride"] = 168.05, ["Mega|Fly|Ride"] = 236.31}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 34.13, ["Fly|Ride"] = 39.38, ["Neon"] = 65.63, ["Neon|Ride"] = 49.38, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 124.68, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.41}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.5, ["Ride"] = 10.29, ["Fly|Ride"] = 26.59, ["Neon"] = 1.79, ["Neon|Fly"] = 15.29, ["Neon|Ride"] = 11.71, ["Neon|Fly|Ride"] = 25.09, ["Mega"] = 14.8, ["Mega|Fly"] = 26.16, ["Mega|Ride"] = 15.22, ["Mega|Fly|Ride"] = 51.6}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 27.2, ["Fly|Ride"] = 131.25, ["Neon"] = 11.8, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.54, ["Mega|Ride"] = 159.51, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.22, ["Fly"] = 112.52, ["Ride"] = 23.41, ["Fly|Ride"] = 59.06, ["Neon"] = 44.07, ["Neon|Ride"] = 28.62, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 234.94, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.77, ["Ride"] = 13.01, ["Fly|Ride"] = 43.19, ["Neon"] = 2.1, ["Neon|Fly"] = 18.92, ["Neon|Ride"] = 14.6, ["Neon|Fly|Ride"] = 35.56, ["Mega"] = 21, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 103.69}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 175.35, ["Ride"] = 29.32, ["Neon"] = 2.6, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 63.91, ["Mega|Fly"] = 168.05, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 167.22}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 65.63, ["Neon"] = 4.93, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 34.82, ["Mega|Fly"] = 140.75, ["Mega|Ride"] = 72.09, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 35.72, ["Ride"] = 18.04, ["Neon"] = 2.1, ["Neon|Fly"] = 42.02, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 3149.99, ["Mega"] = 13.13, ["Mega|Ride"] = 40.68, ["Mega|Fly|Ride"] = 168.05}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.35, ["Ride"] = 23.63, ["Fly|Ride"] = 42.02, ["Neon"] = 5.15, ["Neon|Fly"] = 28.38, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 57.66, ["Mega"] = 137.61, ["Mega|Ride"] = 87.81, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 54.91, ["Fly|Ride"] = 45.94, ["Neon"] = 6.02, ["Neon|Ride"] = 62.07, ["Mega"] = 40.57, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 249.26}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.1, ["Ride"] = 14.47, ["Fly|Ride"] = 72.19, ["Neon"] = 3.93, ["Neon|Fly"] = 79.97, ["Neon|Ride"] = 20.47, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 98.43, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 142.94}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 36.27, ["Fly|Ride"] = 50.05, ["Neon"] = 41.68, ["Neon|Fly"] = 245.76, ["Neon|Ride"] = 75.64, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Ride"] = 168.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 18.29, ["Fly|Ride"] = 35.72, ["Neon"] = 12.8, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 280.42, ["Mega|Fly"] = 420, ["Mega|Ride"] = 151.34}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 22.58, ["Ride"] = 22.58, ["Fly|Ride"] = 52.49, ["Neon"] = 15.26, ["Neon|Fly"] = 31.49, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 72.17, ["Mega"] = 168.05, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 232.12}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 7.88, ["Fly"] = 111.3, ["Neon"] = 71.31, ["Mega"] = 241.04, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.01, ["Ride"] = 56.44, ["Neon"] = 210.06, ["Neon|Ride"] = 238.07, ["Mega"] = 560.82, ["Mega|Ride"] = 700.49, ["Mega|Fly|Ride"] = 797.11}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 3.66, ["Ride"] = 28.06, ["Fly|Ride"] = 105.02, ["Neon"] = 42, ["Neon|Ride"] = 126, ["Mega"] = 236.15, ["Mega|Ride"] = 365.53}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.44, ["Ride"] = 30.97, ["Fly|Ride"] = 120.75, ["Neon"] = 26.24, ["Neon|Ride"] = 66.64, ["Mega"] = 476.12, ["Mega|Ride"] = 315.07, ["Mega|Fly|Ride"] = 301.43}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.52, ["Neon|Ride"] = 64.99, ["Mega"] = 19.85, ["Mega|Fly"] = 63.03, ["Mega|Ride"] = 126.04, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 39.15}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 2.45, ["Fly"] = 23.02, ["Ride"] = 20.6, ["Fly|Ride"] = 41.15, ["Neon"] = 53.63, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 42.12, ["Neon|Fly|Ride"] = 78.61, ["Mega"] = 271.44, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 287.84}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 13.01, ["Fly|Ride"] = 44.63, ["Neon"] = 3.56, ["Neon|Fly"] = 32.16, ["Neon|Ride"] = 21.42, ["Neon|Fly|Ride"] = 157.13, ["Mega"] = 24.68, ["Mega|Fly"] = 140.75, ["Mega|Ride"] = 70.39, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Neon"] = 4.86, ["Neon|Ride"] = 33.44, ["Neon|Fly|Ride"] = 95.59, ["Mega"] = 38.31, ["Mega|Ride"] = 73.78, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 16.28, ["Fly|Ride"] = 42.83, ["Neon"] = 6.55, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 124.76, ["Mega"] = 126.04, ["Mega|Ride"] = 159.51, ["Mega|Fly|Ride"] = 171.95}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 15.58, ["Ride"] = 36.66, ["Fly|Ride"] = 57.75, ["Neon"] = 33.65, ["Neon|Ride"] = 131.06, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 124.69, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 314.02}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 31.82, ["Neon"] = 2.23, ["Mega"] = 19.11, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 59.28, ["Mega|Fly|Ride"] = 336.08}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 21.89, ["Ride"] = 16.49, ["Fly|Ride"] = 32.71, ["Neon"] = 2.67, ["Neon|Fly"] = 111.34, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 28.5, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 39.09, ["Mega|Fly|Ride"] = 130.24}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.11, ["Ride"] = 13.13, ["Fly|Ride"] = 42.02, ["Neon"] = 4.87, ["Neon|Fly"] = 91.67, ["Neon|Ride"] = 18.15, ["Neon|Fly|Ride"] = 50.93, ["Mega"] = 52.49, ["Mega|Fly"] = 140.75, ["Mega|Ride"] = 70.39, ["Mega|Fly|Ride"] = 99.75}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 52.91, ["Fly|Ride"] = 131.25, ["Neon"] = 3.61, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 102.27, ["Mega"] = 32.36, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 215.23}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 31.53, ["Neon|Fly|Ride"] = 153301.42, ["Mega"] = 18.78, ["Mega|Fly"] = 95.23, ["Mega|Ride"] = 110.29, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.88, ["Ride"] = 16.97, ["Fly|Ride"] = 79.69, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 19.3, ["Mega|Fly"] = 63.03, ["Mega|Ride"] = 41.12, ["Mega|Fly|Ride"] = 95.23}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 56.73, ["Mega|Ride"] = 418, ["Mega|Fly|Ride"] = 161.24}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 1.99, ["Neon"] = 3.03, ["Neon|Ride"] = 317.81, ["Neon|Fly|Ride"] = 420, ["Mega"] = 24.82, ["Mega|Ride"] = 153.62}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.34, ["Fly|Ride"] = 49.88, ["Neon"] = 3.82, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 17.03, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 126.04, ["Mega|Ride"] = 49.86, ["Mega|Fly|Ride"] = 94.5}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 8.39, ["Ride"] = 78.74, ["Neon"] = 125.98, ["Mega"] = 456.21, ["Mega|Ride"] = 666.89}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.07, ["Fly"] = 6562.5, ["Ride"] = 56.44, ["Neon"] = 42, ["Mega"] = 190.7}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 30.35, ["Fly|Ride"] = 178.5, ["Neon"] = 25.99, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 397.95, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 370.33}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 13.12, ["Ride"] = 11.82, ["Fly|Ride"] = 25.31, ["Neon"] = 2.1, ["Neon|Fly"] = 14.39, ["Neon|Ride"] = 10.48, ["Neon|Fly|Ride"] = 26.16, ["Mega"] = 13.13, ["Mega|Fly"] = 22.78, ["Mega|Ride"] = 20.82, ["Mega|Fly|Ride"] = 41.06}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 60.38, ["Neon"] = 6.15, ["Neon|Fly"] = 67.24, ["Neon|Ride"] = 32.58, ["Neon|Fly|Ride"] = 700.49, ["Mega"] = 72.19, ["Mega|Ride"] = 118.02}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 1.79, ["Ride"] = 31.2, ["Neon"] = 2.1, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 22.83, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 14.42, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 126.04}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.89, ["Neon|Ride"] = 127.32, ["Mega"] = 18.25, ["Mega|Fly|Ride"] = 168.05}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 1.79, ["Fly"] = 41.97, ["Ride"] = 17.31, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 183.75, ["Mega|Ride"] = 197.91, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 164.06, ["Fly"] = 183.75, ["Ride"] = 211.21, ["Fly|Ride"] = 839.97, ["Neon"] = 925.5, ["Neon|Ride"] = 757.32, ["Neon|Fly|Ride"] = 939.94, ["Mega"] = 8401.6, ["Mega|Ride"] = 3220.98, ["Mega|Fly|Ride"] = 3326}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 1.79, ["Ride"] = 17.85, ["Neon"] = 7.56, ["Neon|Ride"] = 64.31, ["Mega"] = 78.08, ["Mega|Ride"] = 168.05, ["Mega|Fly|Ride"] = 624.88}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.17, ["Fly"] = 64.97, ["Ride"] = 26.19, ["Fly|Ride"] = 59.07, ["Neon"] = 31.08, ["Neon|Ride"] = 95.23, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 381.82, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.81, ["Fly|Ride"] = 37.59, ["Neon"] = 3.67, ["Neon|Fly"] = 28.38, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 40.48, ["Mega"] = 49.68, ["Mega|Ride"] = 81.38, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.35, ["Ride"] = 17.76, ["Fly|Ride"] = 92.58, ["Neon"] = 6.85, ["Neon|Fly"] = 560.82, ["Neon|Ride"] = 69.47, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 69.57, ["Mega|Ride"] = 190.45}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 23.73, ["Ride"] = 15.02, ["Fly|Ride"] = 36, ["Neon"] = 28.62, ["Neon|Fly"] = 98.74, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 276.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 5.02, ["Ride"] = 34.32, ["Fly|Ride"] = 252, ["Neon"] = 79.24, ["Neon|Ride"] = 140.69, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 414.51, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.24, ["Fly|Ride"] = 35.25, ["Neon"] = 20.16, ["Neon|Fly"] = 70.39, ["Neon|Ride"] = 28.81, ["Neon|Fly|Ride"] = 70.49, ["Mega"] = 131.25, ["Mega|Ride"] = 210.06, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 67.56, ["Ride"] = 72.19, ["Fly|Ride"] = 124.69, ["Neon"] = 328.13, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 254.73, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1468.68}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 335.99, ["Ride"] = 236.67, ["Fly|Ride"] = 280.72, ["Neon|Ride"] = 1120.59, ["Neon|Fly|Ride"] = 906.46, ["Mega"] = 10502, ["Mega|Fly|Ride"] = 4856.14}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 54.6, ["Fly"] = 140.7, ["Ride"] = 70.35, ["Fly|Ride"] = 84.02, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 354.26, ["Mega|Fly|Ride"] = 1751.74}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 6.45, ["Fly"] = 287.88, ["Ride"] = 23.63, ["Fly|Ride"] = 139.07, ["Neon"] = 28.38, ["Neon|Fly"] = 84.03, ["Neon|Ride"] = 68.24, ["Neon|Fly|Ride"] = 179.81, ["Mega"] = 263.82, ["Mega|Ride"] = 378.09, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.66, ["Fly"] = 70.35, ["Ride"] = 20.35, ["Fly|Ride"] = 62.76, ["Neon"] = 84.03, ["Neon|Ride"] = 126.27, ["Neon|Fly|Ride"] = 196.4, ["Mega"] = 353.07, ["Mega|Ride"] = 390.75, ["Mega|Fly|Ride"] = 554.52}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.05, ["Fly"] = 20.97, ["Ride"] = 12.62, ["Fly|Ride"] = 35.72, ["Neon"] = 2.1, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 19.97, ["Neon|Fly|Ride"] = 47.25, ["Mega"] = 50, ["Mega|Fly"] = 154.88, ["Mega|Ride"] = 130.24, ["Mega|Fly|Ride"] = 84.46}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.71, ["Fly"] = 72.12, ["Ride"] = 21.4, ["Fly|Ride"] = 81.38, ["Neon"] = 125.82, ["Neon|Fly"] = 350.78, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 173.38, ["Mega"] = 393.75, ["Mega|Ride"] = 835.97, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 13.01, ["Fly|Ride"] = 32.81, ["Neon"] = 11.82, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 31.43, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 149.63, ["Mega|Fly"] = 162.84, ["Mega|Ride"] = 196.4, ["Mega|Fly|Ride"] = 178.37}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 21.02, ["Fly|Ride"] = 328.13, ["Neon"] = 22.28, ["Neon|Ride"] = 35.73, ["Mega"] = 207.37, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 476.12}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.05, ["Fly"] = 27.68, ["Ride"] = 19.34, ["Neon"] = 2.1, ["Neon|Ride"] = 19.65, ["Neon|Fly|Ride"] = 57.73, ["Mega"] = 14.44, ["Mega|Ride"] = 42.02, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 18.27, ["Fly|Ride"] = 42.02, ["Neon"] = 13.58, ["Neon|Fly"] = 105.04, ["Neon|Ride"] = 31.53, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 108.93, ["Mega|Ride"] = 195.35, ["Mega|Fly|Ride"] = 210.06}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.15, ["Fly"] = 25.17, ["Ride"] = 18.41, ["Fly|Ride"] = 61.53, ["Neon"] = 21.42, ["Neon|Ride"] = 47.25, ["Mega"] = 131.17, ["Mega|Ride"] = 203.75, ["Mega|Fly|Ride"] = 224.76}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 105, ["Fly"] = 154.34, ["Ride"] = 131.25, ["Fly|Ride"] = 213.82, ["Neon"] = 678.44, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 632.63, ["Mega"] = 4200.8, ["Mega|Ride"] = 2730.53, ["Mega|Fly|Ride"] = 2035.69}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 28.16, ["Ride"] = 32.57, ["Fly|Ride"] = 127.32, ["Neon"] = 46.1, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 328.13, ["Mega|Ride"] = 396.99, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 15.59, ["Fly|Ride"] = 35.72, ["Neon"] = 19.69, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 120.74, ["Mega"] = 238.07, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 317.81}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.58, ["Ride"] = 41.32, ["Fly|Ride"] = 170.63, ["Neon"] = 118.01, ["Neon|Ride"] = 203.75, ["Neon|Fly|Ride"] = 627.47, ["Mega"] = 660.77, ["Mega|Fly"] = 840.17, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 619.64}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 10.52}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 28.5, ["Fly|Ride"] = 117.41, ["Neon"] = 42, ["Neon|Ride"] = 102.94, ["Neon|Fly|Ride"] = 350.78, ["Mega"] = 630.13, ["Mega|Ride"] = 537.72, ["Mega|Fly|Ride"] = 873.65}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 25.57, ["Fly"] = 32.32, ["Ride"] = 31.36, ["Fly|Ride"] = 49.24, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.63, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 2100.4, ["Mega|Fly|Ride"] = 541.75}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 1.79, ["Ride"] = 18.68, ["Fly|Ride"] = 65.63, ["Neon"] = 3.42, ["Neon|Fly"] = 65.62, ["Neon|Ride"] = 25.48, ["Neon|Fly|Ride"] = 106.3, ["Mega"] = 23.82, ["Mega|Ride"] = 57.08, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 15.22, ["Fly"] = 28.37, ["Ride"] = 24.15, ["Fly|Ride"] = 63.02, ["Neon"] = 52.41, ["Neon|Ride"] = 238.07, ["Mega"] = 280.42, ["Mega|Fly"] = 397.56, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 382.29}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 1.87, ["Fly"] = 32.82, ["Ride"] = 13.02, ["Fly|Ride"] = 47.08, ["Neon"] = 17.34, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 34.82, ["Neon|Fly|Ride"] = 77.43, ["Mega"] = 138.89, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 210, ["Neon"] = 3.15, ["Neon|Fly"] = 37.49, ["Neon|Ride"] = 25.98, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 19.06, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 31.73, ["Ride"] = 74.45, ["Fly|Ride"] = 142.78, ["Neon"] = 236.25, ["Neon|Ride"] = 205.48, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.61, ["Mega|Ride"] = 904.23, ["Mega|Fly|Ride"] = 1119.54}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.31, ["Ride"] = 28.37, ["Fly|Ride"] = 210, ["Neon"] = 92.26, ["Neon|Ride"] = 140.75, ["Mega"] = 140.75, ["Mega|Ride"] = 342.67}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.4, ["Fly"] = 29.54, ["Ride"] = 15.77, ["Fly|Ride"] = 46.97, ["Neon"] = 18.72, ["Neon|Fly"] = 84, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 194.02, ["Mega|Ride"] = 254.17, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 61.06, ["Fly"] = 433.13, ["Ride"] = 393.73, ["Fly|Ride"] = 262.47, ["Neon"] = 354.38, ["Neon|Ride"] = 546.11, ["Mega"] = 4445.56, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.12, ["Fly"] = 44.54, ["Ride"] = 22.32, ["Fly|Ride"] = 57.64, ["Neon"] = 46.1, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.95, ["Neon|Fly|Ride"] = 114.18, ["Mega"] = 224.43, ["Mega|Ride"] = 389.64, ["Mega|Fly|Ride"] = 685.31}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 69.42, ["Fly"] = 140.7, ["Ride"] = 87.72, ["Fly|Ride"] = 150.93, ["Neon"] = 266.44, ["Neon|Ride"] = 230.15, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1260.26, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 1084.99}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 15.49, ["Ride"] = 43.32, ["Fly|Ride"] = 105.02, ["Neon"] = 77.86, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 235.68, ["Mega"] = 354.38, ["Mega|Ride"] = 355.49, ["Mega|Fly|Ride"] = 413.43}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.12, ["Fly"] = 40.13, ["Ride"] = 28.37, ["Fly|Ride"] = 63.02, ["Neon"] = 49.8, ["Neon|Ride"] = 131.14, ["Neon|Fly|Ride"] = 378.51, ["Mega"] = 210.06, ["Mega|Ride"] = 1575.31, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.28, ["Ride"] = 39.36, ["Fly|Ride"] = 162.54, ["Neon"] = 66.99, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 299.57, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 3.59, ["Ride"] = 24.81, ["Fly|Ride"] = 88.2, ["Neon"] = 30.96, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 141.16, ["Mega"] = 238.88, ["Mega|Ride"] = 265.21, ["Mega|Fly|Ride"] = 403.54}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 1.79, ["Neon"] = 2.1, ["Neon|Ride"] = 56.73, ["Mega"] = 11.91, ["Mega|Ride"] = 126.04, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.5, ["Ride"] = 28.42, ["Neon"] = 24.03, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 157.5, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 418}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.97, ["Ride"] = 37.82, ["Neon"] = 28.74, ["Neon|Fly"] = 116.94, ["Mega"] = 170.55, ["Mega|Ride"] = 138.65, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 5.14, ["Ride"] = 32.79, ["Fly|Ride"] = 119, ["Neon"] = 23.81, ["Neon|Ride"] = 78.78, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 511.88, ["Ride"] = 544.69, ["Fly|Ride"] = 616.77, ["Neon"] = 1821.06, ["Neon|Ride"] = 1849.64, ["Neon|Fly|Ride"] = 1961.78, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 3.94, ["Fly"] = 28.37, ["Ride"] = 20.01, ["Fly|Ride"] = 56.34, ["Neon"] = 40.97, ["Neon|Ride"] = 60.93, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 216.36, ["Mega|Ride"] = 365.43, ["Mega|Fly|Ride"] = 476.8}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.23, ["Fly"] = 524.79, ["Ride"] = 31.13, ["Fly|Ride"] = 51.54, ["Neon"] = 48.56, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.35, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 331.86, ["Mega|Ride"] = 498.86, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 4.72, ["Fly"] = 91.87, ["Ride"] = 27.09, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 1.79, ["Fly"] = 65.59, ["Ride"] = 22.09, ["Fly|Ride"] = 71.4, ["Neon"] = 7.87, ["Neon|Ride"] = 29.8, ["Neon|Fly|Ride"] = 87.8, ["Mega"] = 64.32, ["Mega|Fly"] = 280.42, ["Mega|Ride"] = 88.64, ["Mega|Fly|Ride"] = 197.81}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 1.79, ["Fly"] = 70.35, ["Ride"] = 17.07, ["Neon"] = 2.1, ["Neon|Ride"] = 24.05, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 18.25, ["Mega|Fly"] = 196.4, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 190.32}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1109.07}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 4.14, ["Ride"] = 21.02, ["Fly|Ride"] = 56.72, ["Neon"] = 65.63, ["Neon|Ride"] = 91.74, ["Mega"] = 459.38, ["Mega|Ride"] = 571.33, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 26.38, ["Neon"] = 5.16, ["Neon|Ride"] = 56.44, ["Mega"] = 39.38, ["Mega|Ride"] = 102.94, ["Mega|Fly|Ride"] = 251.34}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 389.71, ["Ride"] = 64.02, ["Neon"] = 22.97, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 183.75, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1050.2}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 419.99, ["Ride"] = 485.63, ["Fly|Ride"] = 545.98, ["Neon|Ride"] = 2135.17, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8729.22, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.52, ["Fly"] = 196.88, ["Ride"] = 56.72, ["Fly|Ride"] = 419.99, ["Neon"] = 29.86, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 190.45, ["Mega"] = 524.06, ["Mega|Ride"] = 476.12, ["Mega|Fly|Ride"] = 698.69}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 1.79, ["Ride"] = 22.74, ["Fly|Ride"] = 118.13, ["Neon"] = 2.88, ["Neon|Ride"] = 36.25, ["Neon|Fly|Ride"] = 99.04, ["Mega"] = 37.45, ["Mega|Fly"] = 126.04, ["Mega|Ride"] = 71.67, ["Mega|Fly|Ride"] = 276.15}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 1.79, ["Neon"] = 2.14, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 28.58, ["Mega|Ride"] = 134.78, ["Mega|Fly|Ride"] = 391.65}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 10.5, ["Fly"] = 107.63, ["Ride"] = 80.06, ["Neon"] = 128.14, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 545.06, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.94, ["Ride"] = 71.31, ["Neon"] = 80.22, ["Neon|Ride"] = 126.04, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 496.13, ["Mega|Ride"] = 478.42, ["Mega|Fly|Ride"] = 490.46}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 31.38, ["Neon"] = 96.94, ["Neon|Ride"] = 178.34, ["Mega"] = 651.08, ["Mega|Ride"] = 770.86, ["Mega|Fly|Ride"] = 1260.26}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 9, ["Ride"] = 23.15, ["Fly|Ride"] = 262.5, ["Neon"] = 131.24, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 616.88, ["Mega|Ride"] = 476.12, ["Mega|Fly|Ride"] = 700.49}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 324.83, ["Fly|Ride"] = 509.23, ["Neon"] = 1115.63, ["Neon|Ride"] = 1270, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4023.02}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.57, ["Fly"] = 78.74, ["Ride"] = 20.11, ["Fly|Ride"] = 64.4, ["Neon"] = 145.69, ["Neon|Ride"] = 159.51, ["Neon|Fly|Ride"] = 195.82, ["Mega"] = 756.16, ["Mega|Ride"] = 734.11, ["Mega|Fly|Ride"] = 725.7}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 2.58, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 63.67, ["Neon|Ride"] = 210, ["Mega"] = 367.5, ["Mega|Ride"] = 350.78, ["Mega|Fly|Ride"] = 793.91}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 9.68, ["Fly"] = 140.7, ["Ride"] = 96.05, ["Fly|Ride"] = 159.45, ["Neon"] = 79.01, ["Neon|Ride"] = 150.99, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 285.47, ["Mega|Fly"] = 700.49, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.49, ["Ride"] = 42.02, ["Fly|Ride"] = 140.7, ["Neon"] = 6.47, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 36.91, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 228.37}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 37.28, ["Ride"] = 77.17, ["Neon"] = 315, ["Neon|Ride"] = 419.05, ["Neon|Fly|Ride"] = 463.16, ["Mega"] = 1666.34, ["Mega|Ride"] = 2100.4, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Neon"] = 6.56, ["Neon|Fly"] = 182.76, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 125.03, ["Mega"] = 70.55, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 215.91}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.22, ["Ride"] = 27.39, ["Neon"] = 4.64, ["Neon|Fly"] = 49.38, ["Neon|Ride"] = 46.66, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 38.88, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 170.36}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 126.13, ["Neon"] = 15.75, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 87.94, ["Mega|Ride"] = 122.3, ["Mega|Fly|Ride"] = 309.83}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 50.91, ["Fly"] = 77.72, ["Ride"] = 60.26, ["Fly|Ride"] = 169.32, ["Neon"] = 271.01, ["Neon|Ride"] = 303.41, ["Neon|Fly|Ride"] = 476.12, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 228.38, ["Ride"] = 301.35, ["Fly|Ride"] = 418.94, ["Neon"] = 1462.13, ["Neon|Ride"] = 1161.68, ["Neon|Fly|Ride"] = 1309.28, ["Mega"] = 6562.5, ["Mega|Fly|Ride"] = 4481.22}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.69, ["Neon"] = 30.03, ["Neon|Fly"] = 350.44, ["Mega"] = 108.94, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 209.01}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 25.22, ["Neon"] = 6.33, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 61.68, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.45, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 30.95, ["Ride"] = 27.57, ["Fly|Ride"] = 47.61, ["Neon"] = 32.8, ["Mega"] = 138.65, ["Mega|Ride"] = 351.74, ["Mega|Fly|Ride"] = 392.79}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 90.96, ["Ride"] = 35.72, ["Fly|Ride"] = 373.79, ["Neon"] = 11.22, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 155.45, ["Mega"] = 124.29, ["Mega|Ride"] = 142.85, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 192.21, ["Mega"] = 52.5, ["Mega|Ride"] = 141.8, ["Mega|Fly|Ride"] = 347.64}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 17.91, ["Fly|Ride"] = 51.19, ["Neon"] = 4.1, ["Neon|Fly"] = 79.76, ["Neon|Ride"] = 21.45, ["Neon|Fly|Ride"] = 137.6, ["Mega"] = 39.38, ["Mega|Ride"] = 95.72, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 3.67, ["Fly"] = 26.25, ["Ride"] = 15.89, ["Fly|Ride"] = 41.31, ["Neon"] = 15.12, ["Neon|Fly"] = 64.96, ["Neon|Ride"] = 27.09, ["Neon|Fly|Ride"] = 95.23, ["Mega"] = 86.63, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 20.79, ["Fly"] = 52.5, ["Ride"] = 31.8, ["Fly|Ride"] = 78.73, ["Neon|Ride"] = 266.77, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 388.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 532.47}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.82, ["Ride"] = 78.66, ["Fly|Ride"] = 133.63, ["Neon"] = 406.88, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 3174.39, ["Mega|Ride"] = 3255, ["Mega|Fly|Ride"] = 1502.82}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.88, ["Fly|Ride"] = 140.7, ["Neon"] = 2.77, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 128.47, ["Mega"] = 38.4, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.11, ["Ride"] = 14.17, ["Fly|Ride"] = 28.37, ["Neon"] = 4.05, ["Neon|Fly"] = 28.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.73, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.79, ["Ride"] = 27.32, ["Fly|Ride"] = 131.25, ["Neon"] = 36.75, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 527.62, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 635.6}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon|Ride"] = 1904.39, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 7935.33}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.31, ["Fly"] = 98.72, ["Ride"] = 40.68, ["Fly|Ride"] = 84.02, ["Neon"] = 236.25, ["Neon|Ride"] = 210.74, ["Neon|Fly|Ride"] = 305.8, ["Mega|Ride"] = 880.69, ["Mega|Fly|Ride"] = 936.73}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21.02, ["Fly|Ride"] = 70.35, ["Neon"] = 4.77, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 84, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 260.56}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.61, ["Fly|Ride"] = 143.05, ["Neon"] = 17.87}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 24.6, ["Fly"] = 169.3, ["Ride"] = 35.72, ["Fly|Ride"] = 52.5, ["Neon"] = 194.25, ["Neon|Ride"] = 357.08, ["Neon|Fly|Ride"] = 185.07, ["Mega"] = 2520.5, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1207.74}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 77.96, ["Fly"] = 126.02, ["Ride"] = 111.16, ["Fly|Ride"] = 189, ["Neon"] = 434.43, ["Neon|Ride"] = 558.72, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8401.6, ["Mega|Fly|Ride"] = 2281.05}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 199.34, ["Ride"] = 276.07, ["Fly|Ride"] = 502.93, ["Neon"] = 1050, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 4147.5}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.52, ["Fly"] = 56.72, ["Ride"] = 34.82, ["Fly|Ride"] = 96.17, ["Neon"] = 84.11, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 350.78, ["Mega"] = 389.79, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 515.66}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 13.65, ["Fly|Ride"] = 42.02, ["Neon"] = 9.42, ["Neon|Ride"] = 22.21, ["Neon|Fly|Ride"] = 91.39, ["Mega"] = 63, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.35}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 39.19, ["Ride"] = 15.32, ["Fly|Ride"] = 55.86, ["Neon"] = 30.77, ["Neon|Fly"] = 105, ["Neon|Ride"] = 36.04, ["Neon|Fly|Ride"] = 74.59, ["Mega"] = 381.09, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 359.03}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 311.28, ["Fly"] = 490.34, ["Ride"] = 399.07, ["Fly|Ride"] = 444.98, ["Neon"] = 1575, ["Neon|Ride"] = 2029.3, ["Neon|Fly|Ride"] = 1993.29, ["Mega"] = 10081.93, ["Mega|Fly|Ride"] = 5870.21}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.62, ["Neon"] = 6.38, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 27.4, ["Mega|Ride"] = 170.98}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Ride"] = 15.73, ["Fly|Ride"] = 39.38, ["Neon"] = 26.2, ["Neon|Ride"] = 36.41, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 232.12, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 194.36, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.3, ["Ride"] = 83.15, ["Neon"] = 107.62, ["Neon|Fly"] = 420.1, ["Neon|Ride"] = 236.25, ["Mega"] = 548.63, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 102.79, ["Fly"] = 157.5, ["Ride"] = 103.59, ["Fly|Ride"] = 127.03, ["Neon"] = 459.38, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 10.38, ["Fly"] = 24.57, ["Ride"] = 23.38, ["Fly|Ride"] = 47.41, ["Neon"] = 103.99, ["Neon|Ride"] = 84.03, ["Neon|Fly|Ride"] = 560.82, ["Mega"] = 700.49, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 1.79, ["Ride"] = 21.02, ["Neon"] = 2.1, ["Neon|Ride"] = 140.75, ["Mega"] = 24.92, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 18.92, ["Fly|Ride"] = 70.35, ["Neon"] = 2.1, ["Neon|Ride"] = 21.02, ["Neon|Fly|Ride"] = 78.38, ["Mega"] = 23.13, ["Mega|Fly"] = 83.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 9.1, ["Ride"] = 52.42, ["Fly|Ride"] = 141.93, ["Neon"] = 30.44, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 170.51, ["Mega|Ride"] = 204.73, ["Mega|Fly|Ride"] = 292.59}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1455.57, ["Fly"] = 1641.91, ["Ride"] = 1443.74, ["Fly|Ride"] = 1365, ["Neon"] = 4681.78, ["Neon|Ride"] = 4147.5, ["Neon|Fly|Ride"] = 4136.84, ["Mega|Fly|Ride"] = 12598.69}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 446.24, ["Ride"] = 472.5, ["Fly|Ride"] = 633.23, ["Neon"] = 2465.28, ["Neon|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 2520.5, ["Mega"] = 16803.2, ["Mega|Fly|Ride"] = 7069.96}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 275.63, ["Fly"] = 379.44, ["Ride"] = 354.36, ["Fly|Ride"] = 393.75, ["Neon"] = 656.25, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 242.97, ["Fly"] = 334.69, ["Ride"] = 308.44, ["Fly|Ride"] = 364.87, ["Neon"] = 777, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 980.89, ["Mega|Fly|Ride"] = 4199.76}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.31, ["Ride"] = 15.81, ["Fly|Ride"] = 36.91, ["Neon"] = 3.82, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.43, ["Mega|Fly"] = 90.33, ["Mega|Ride"] = 112.4, ["Mega|Fly|Ride"] = 135.07}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 299.06, ["Fly"] = 1400.64, ["Ride"] = 361.88, ["Fly|Ride"] = 602.28, ["Neon"] = 1575, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 1785, ["Mega"] = 21284.4, ["Mega|Ride"] = 6721.3, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.01, ["Fly"] = 183.75, ["Ride"] = 42.02, ["Fly|Ride"] = 159.45, ["Neon"] = 18.52, ["Neon|Ride"] = 110.52, ["Neon|Fly|Ride"] = 252, ["Mega"] = 137.7, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 498.86}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 14.65, ["Fly|Ride"] = 33.68, ["Neon"] = 11.82, ["Neon|Ride"] = 32.58, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 104.9, ["Mega|Ride"] = 192.93, ["Mega|Fly|Ride"] = 151.25}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Neon"] = 2.5, ["Neon|Ride"] = 39.37, ["Mega"] = 29.65, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 30.95, ["Ride"] = 55.49, ["Fly|Ride"] = 459.37, ["Neon"] = 273, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 488.25, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 7932.23, ["Ride"] = 25.99, ["Fly|Ride"] = 68.24, ["Neon"] = 73.5, ["Neon|Ride"] = 61.13, ["Mega|Ride"] = 406.44, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.12, ["Neon"] = 2.1, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 102.9, ["Mega"] = 20.79, ["Mega|Ride"] = 68.01, ["Mega|Fly|Ride"] = 161.75}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 36.01, ["Ride"] = 18.44, ["Fly|Ride"] = 47.61, ["Neon"] = 12.68, ["Neon|Fly"] = 112.4, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 76.56, ["Mega"] = 129.72, ["Mega|Fly"] = 476.12, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.06, ["Fly"] = 56.72, ["Ride"] = 15.8, ["Fly|Ride"] = 52.5, ["Neon"] = 35.76, ["Neon|Fly"] = 142.86, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 10.13, ["Ride"] = 63.02, ["Neon"] = 92.91, ["Neon|Fly|Ride"] = 270.2, ["Mega"] = 516.57, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.98, ["Fly"] = 6346.27, ["Ride"] = 19.59, ["Neon"] = 19.69, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 183.73, ["Neon|Fly|Ride"] = 714.16, ["Mega"] = 301.88, ["Mega|Ride"] = 414.85, ["Mega|Fly|Ride"] = 402.94}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 18.26, ["Fly|Ride"] = 37.82, ["Neon"] = 3.4, ["Neon|Fly"] = 31.53, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 84.03, ["Mega"] = 39.29, ["Mega|Ride"] = 179.74, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.31, ["Ride"] = 164.07, ["Fly|Ride"] = 254.63, ["Neon"] = 1686.78, ["Neon|Ride"] = 897.93, ["Neon|Fly|Ride"] = 838.68, ["Mega"] = 8401.6, ["Mega|Ride"] = 4200.8, ["Mega|Fly|Ride"] = 3487.73}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.03, ["Ride"] = 14.84, ["Fly|Ride"] = 28.61, ["Neon"] = 2.1, ["Neon|Fly"] = 24.18, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 56.26, ["Mega"] = 44.61, ["Mega|Ride"] = 52.76, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.55, ["Ride"] = 42.36, ["Fly|Ride"] = 183.75, ["Neon"] = 87.67, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 313.69, ["Mega|Fly"] = 793.91, ["Mega|Ride"] = 441.1, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 23.62, ["Ride"] = 105.02, ["Fly|Ride"] = 170.63, ["Neon"] = 137.8, ["Neon|Ride"] = 270.21, ["Neon|Fly|Ride"] = 238.07, ["Mega"] = 786.19, ["Mega|Ride"] = 686.85, ["Mega|Fly|Ride"] = 840.17}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 171.93, ["Ride"] = 183.74, ["Fly|Ride"] = 316.93, ["Neon"] = 753.64, ["Neon|Ride"] = 720.57, ["Neon|Fly|Ride"] = 917.44, ["Mega|Fly|Ride"] = 3389.01}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 19.95, ["Ride"] = 158.3, ["Fly|Ride"] = 140.7, ["Neon"] = 78.75, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 700.49}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.98, ["Ride"] = 57.75, ["Fly|Ride"] = 182.7, ["Neon"] = 101.88, ["Neon|Fly"] = 159.52, ["Neon|Ride"] = 198.99, ["Neon|Fly|Ride"] = 222.58, ["Mega"] = 771.89, ["Mega|Ride"] = 840.17, ["Mega|Fly|Ride"] = 980.89}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 957.91, ["Fly"] = 1050, ["Ride"] = 1049.99, ["Fly|Ride"] = 1179.93, ["Neon|Ride"] = 4089.48, ["Neon|Fly|Ride"] = 4477.01, ["Mega|Fly|Ride"] = 19953.8}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.38, ["Fly"] = 19.69, ["Ride"] = 19.8, ["Fly|Ride"] = 43.32, ["Neon"] = 25.23, ["Neon|Fly"] = 42.84, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 78.78, ["Mega"] = 226.16, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.94, ["Fly"] = 51.19, ["Ride"] = 35.32, ["Fly|Ride"] = 135.19, ["Neon"] = 35.72, ["Neon|Ride"] = 78.78, ["Mega"] = 241.56, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 278.11, ["Mega|Fly|Ride"] = 980.89}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 82.97, ["Ride"] = 27.4, ["Fly|Ride"] = 69.56, ["Neon"] = 16.68, ["Neon|Ride"] = 44.03, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 199.66, ["Mega|Ride"] = 240.62, ["Mega|Fly|Ride"] = 972.49}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.76, ["Fly"] = 57.84, ["Ride"] = 32.44, ["Fly|Ride"] = 83.84, ["Neon"] = 77.42, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 79.43, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 397.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.45, ["Ride"] = 22.32, ["Fly|Ride"] = 51.19, ["Neon"] = 16.83, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 98.8, ["Mega|Fly"] = 252.07, ["Mega|Ride"] = 91.77, ["Mega|Fly|Ride"] = 214.26}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Neon"] = 10.11, ["Neon|Fly"] = 13125, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.97, ["Mega|Ride"] = 199.37, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Ride"] = 256.15, ["Fly|Ride"] = 350.69, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 3697.76}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 15.82, ["Fly|Ride"] = 98.44, ["Neon"] = 6.57, ["Neon|Fly"] = 84.03, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 124.87, ["Mega"] = 42, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 88.86, ["Neon"] = 27.2, ["Neon|Ride"] = 188.27, ["Mega"] = 140.75, ["Mega|Ride"] = 238.07}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.15, ["Fly"] = 98.72, ["Ride"] = 20.89, ["Neon"] = 25.76, ["Neon|Ride"] = 52.49, ["Mega"] = 84.95, ["Mega|Fly"] = 142.85, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 259.77, ["Ride"] = 509.23, ["Fly|Ride"] = 560.68, ["Neon|Ride"] = 1049.18, ["Neon|Fly|Ride"] = 1260.26, ["Mega|Ride"] = 4200.8, ["Mega|Fly|Ride"] = 2856.58}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 19.05, ["Fly"] = 119, ["Ride"] = 47.61, ["Fly|Ride"] = 224.7, ["Neon"] = 149.5, ["Neon|Ride"] = 280.42, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 564.38, ["Mega|Ride"] = 840.17, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.57, ["Fly"] = 84.02, ["Ride"] = 31.61, ["Fly|Ride"] = 90.57, ["Neon"] = 97.67, ["Neon|Ride"] = 124.66, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 432.16, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 589.32}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.12, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 45.17, ["Fly"] = 52.5, ["Ride"] = 73.97, ["Fly|Ride"] = 131.25, ["Neon"] = 294, ["Neon|Fly"] = 272.43, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 298.83, ["Mega|Fly|Ride"] = 991.47}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 37.82, ["Neon"] = 5.04, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 124.99, ["Mega"] = 58.9}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.82, ["Fly"] = 127.32, ["Ride"] = 21.93, ["Fly|Ride"] = 85.68, ["Neon"] = 66.2, ["Neon|Ride"] = 112.4, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 393.75, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 40.11, ["Fly"] = 112.35, ["Ride"] = 96.98, ["Fly|Ride"] = 150.22, ["Neon"] = 183.65, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 419.05, ["Mega|Ride"] = 1961.78, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.05, ["Fly"] = 16.36, ["Ride"] = 12.11, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 24.18, ["Neon|Ride"] = 15.77, ["Neon|Fly|Ride"] = 35.93, ["Mega"] = 16.7, ["Mega|Fly"] = 119.04, ["Mega|Ride"] = 31.39, ["Mega|Fly|Ride"] = 88.24}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 1.98, ["Ride"] = 21, ["Fly|Ride"] = 131.15, ["Neon"] = 16.97, ["Neon|Ride"] = 50.43, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 131.25, ["Mega|Ride"] = 278.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.77, ["Ride"] = 50.42, ["Fly|Ride"] = 85.32, ["Neon"] = 110.25, ["Mega"] = 536.71, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 1.79, ["Ride"] = 21.63, ["Neon"] = 2.1, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 16.78, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 176.45}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 10.57, ["Fly"] = 193.36, ["Ride"] = 65.55, ["Fly|Ride"] = 172.22, ["Neon"] = 61.13, ["Neon|Ride"] = 172.25, ["Neon|Fly|Ride"] = 443.63, ["Mega"] = 537.72, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 616.49}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 12.86, ["Fly"] = 42.14, ["Ride"] = 21.56, ["Fly|Ride"] = 98.44, ["Neon"] = 408.97, ["Neon|Ride"] = 109.8, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 18.5, ["Neon"] = 24.04, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 130.19, ["Mega"] = 233.63, ["Mega|Ride"] = 249.76, ["Mega|Fly|Ride"] = 414.85}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 10.28, ["Fly"] = 1994.97, ["Ride"] = 72.17, ["Fly|Ride"] = 280.35, ["Neon"] = 42.41, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 6347.55, ["Mega|Ride"] = 265.25, ["Mega|Fly|Ride"] = 944.14}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.02, ["Ride"] = 18.89, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.43, ["Mega"] = 69.55, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 148.32}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 1.79, ["Ride"] = 55.53, ["Neon"] = 3.25, ["Mega"] = 20.89, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 385.65}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 15.62}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.88, ["Fly"] = 98.72, ["Ride"] = 52.49, ["Fly|Ride"] = 82.66, ["Neon"] = 239.46, ["Neon|Ride"] = 282.97, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1680.33, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 1.79, ["Neon"] = 2.1, ["Neon|Ride"] = 28.38, ["Mega"] = 17.98, ["Mega|Ride"] = 119.7, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 458.07, ["Fly"] = 498.75, ["Ride"] = 524.98, ["Fly|Ride"] = 641.82, ["Neon"] = 2096.21, ["Neon|Fly|Ride"] = 2338.81, ["Mega"] = 16803.2, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 6.07, ["Fly"] = 26.24, ["Ride"] = 25.47, ["Fly|Ride"] = 66.26, ["Neon"] = 33.51, ["Neon|Fly"] = 183.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 90.42, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 21.84, ["Fly|Ride"] = 69.34, ["Neon"] = 19.03, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 140.75, ["Mega|Fly"] = 210.06, ["Mega|Ride"] = 159.51, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 12.76, ["Fly"] = 70.35, ["Ride"] = 50.42, ["Fly|Ride"] = 68.86, ["Neon"] = 101.76, ["Neon|Ride"] = 171.2, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 826.52, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 56.72, ["Ride"] = 28.37, ["Fly|Ride"] = 721.88, ["Neon"] = 30.48, ["Neon|Ride"] = 105, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 10.29, ["Fly"] = 36.77, ["Ride"] = 30.47, ["Fly|Ride"] = 157.49, ["Neon"] = 64.59, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 378.09, ["Mega"] = 420.1, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 532.47}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.65, ["Ride"] = 35.85, ["Fly|Ride"] = 133.88, ["Neon"] = 32.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 209.01, ["Mega"] = 420.1, ["Mega|Fly"] = 560.82, ["Mega|Ride"] = 351.14, ["Mega|Fly|Ride"] = 386.94}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 1.79, ["Fly"] = 40.47, ["Ride"] = 13.54, ["Fly|Ride"] = 69.29, ["Neon"] = 2.1, ["Neon|Fly"] = 59.88, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 76.16, ["Mega"] = 14.44, ["Mega|Fly"] = 32.16, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 141.65}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.07, ["Fly"] = 53.57, ["Ride"] = 22.62, ["Fly|Ride"] = 105.02, ["Neon"] = 28.64, ["Neon|Fly"] = 119.05, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 224.76, ["Mega"] = 168.05, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 360.29}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 311.95, ["Ride"] = 305.32, ["Fly|Ride"] = 519.74, ["Neon"] = 1312.5, ["Neon|Ride"] = 1263.94, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9236.27, ["Mega|Fly|Ride"] = 5086.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 83.26, ["Ride"] = 140.7, ["Fly|Ride"] = 280.35, ["Neon"] = 616.87, ["Neon|Ride"] = 364.88, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2241.15, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1697.64}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.85, ["Ride"] = 15.32, ["Fly|Ride"] = 47.61, ["Neon"] = 8.43, ["Neon|Fly"] = 69.53, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 64.05, ["Mega|Fly"] = 209.01, ["Mega|Ride"] = 103.99, ["Mega|Fly|Ride"] = 159.51}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 18.68, ["Ride"] = 13.39, ["Fly|Ride"] = 34.89, ["Neon"] = 6.56, ["Neon|Fly"] = 52.53, ["Neon|Ride"] = 20.05, ["Neon|Fly|Ride"] = 60.95, ["Mega"] = 65.54, ["Mega|Fly"] = 280.42, ["Mega|Ride"] = 102.94, ["Mega|Fly|Ride"] = 161.44}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.75, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 58.97, ["Mega"] = 273.06, ["Mega|Ride"] = 350.78}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 239.01, ["Fly"] = 420, ["Ride"] = 249.37, ["Fly|Ride"] = 334.69, ["Neon|Ride"] = 2100.4, ["Neon|Fly|Ride"] = 1554.32, ["Mega|Ride"] = 8401.6, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 17.85, ["Ride"] = 15.33, ["Fly|Ride"] = 35.22, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.26, ["Neon|Fly|Ride"] = 111.34, ["Mega"] = 255.94, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 304.58}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 6.34, ["Ride"] = 95.51, ["Fly|Ride"] = 210, ["Neon"] = 59.06, ["Neon|Ride"] = 196.4, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 222.66, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.79}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.15, ["Neon|Ride"] = 155.92, ["Mega"] = 59.07, ["Mega|Ride"] = 210.06}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 9.18, ["Fly"] = 26.25, ["Ride"] = 19.94, ["Fly|Ride"] = 57.2, ["Neon"] = 80.76, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 510.46, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.99}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.74, ["Ride"] = 105.24, ["Fly|Ride"] = 196.86, ["Neon"] = 137.4, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 203.2, ["Neon|Fly|Ride"] = 284.82, ["Mega"] = 402.94, ["Mega|Fly"] = 2205.44, ["Mega|Ride"] = 446.34, ["Mega|Fly|Ride"] = 576.4}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.08, ["Fly"] = 63, ["Ride"] = 42.02, ["Fly|Ride"] = 96.59, ["Neon"] = 140.44, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 210.37, ["Neon|Fly|Ride"] = 285.89, ["Mega"] = 840.17, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.86, ["Ride"] = 14.95, ["Fly|Ride"] = 42.33, ["Neon"] = 2.1, ["Neon|Fly"] = 17.87, ["Neon|Ride"] = 15.32, ["Neon|Fly|Ride"] = 47.15, ["Mega"] = 17.73, ["Mega|Fly"] = 420.1, ["Mega|Ride"] = 35.73, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.3, ["Ride"] = 228.38, ["Fly|Ride"] = 318.93, ["Neon"] = 3171.21, ["Neon|Fly|Ride"] = 1282.22, ["Mega|Fly|Ride"] = 4326.83}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.67, ["Fly"] = 101.18, ["Ride"] = 42.02, ["Fly|Ride"] = 70.35, ["Neon"] = 112.4, ["Neon|Ride"] = 133.92, ["Neon|Fly|Ride"] = 98.74, ["Mega"] = 546.11, ["Mega|Ride"] = 714.16, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 1.93, ["Fly"] = 32.29, ["Ride"] = 17.67, ["Fly|Ride"] = 42.09, ["Neon"] = 5.92, ["Neon|Fly"] = 39, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 111.34, ["Mega"] = 61.98, ["Mega|Fly"] = 280.42, ["Mega|Ride"] = 80.84, ["Mega|Fly|Ride"] = 211.78}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 1.79, ["Fly"] = 31.52, ["Ride"] = 20.68, ["Fly|Ride"] = 43.72, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 13.11, ["Mega|Fly"] = 140.75, ["Mega|Ride"] = 56.73, ["Mega|Fly|Ride"] = 163.42}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 8.98, ["Neon|Fly"] = 714.24, ["Neon|Ride"] = 48.33, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 103.67, ["Mega|Ride"] = 191.35, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 7.56, ["Fly"] = 38.75, ["Ride"] = 23.3, ["Fly|Ride"] = 42.02, ["Neon"] = 47.16, ["Neon|Fly"] = 301.43, ["Neon|Ride"] = 45.83, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 346.17, ["Mega|Ride"] = 236.23, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.65, ["Ride"] = 56.22, ["Fly|Ride"] = 72.19, ["Neon"] = 38.59, ["Neon|Ride"] = 105.04, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 275.63, ["Mega|Ride"] = 317.81, ["Mega|Fly|Ride"] = 389.22}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 35.58, ["Mega|Ride"] = 73.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 4.99, ["Ride"] = 26.27, ["Fly|Ride"] = 131.25, ["Neon"] = 24.55, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 45, ["Neon|Fly|Ride"] = 107.14, ["Mega"] = 238.07, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 270.13}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 79.69, ["Neon"] = 3.66, ["Neon|Fly"] = 112.4, ["Neon|Ride"] = 45.77, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.91, ["Mega|Ride"] = 91.34, ["Mega|Fly|Ride"] = 136.55}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 42.75, ["Ride"] = 17.52, ["Fly|Ride"] = 39.38, ["Neon"] = 4.22, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 121.84, ["Mega"] = 53.87, ["Mega|Fly"] = 140.75, ["Mega|Ride"] = 84.73, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 767.47, ["Ride"] = 721.88, ["Fly|Ride"] = 913.49, ["Neon|Fly|Ride"] = 3543.75, ["Mega|Fly|Ride"] = 12571.04}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.22, ["Ride"] = 14.23, ["Fly|Ride"] = 31.52, ["Neon"] = 18.35, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 35.73, ["Neon|Fly|Ride"] = 56.73, ["Mega|Fly|Ride"] = 361.28}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 22.62, ["Fly|Ride"] = 280.35, ["Neon"] = 7.02, ["Neon|Fly"] = 735.16, ["Neon|Ride"] = 83.91, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 54.51, ["Mega|Fly"] = 196.4, ["Mega|Ride"] = 116.82, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.7, ["Fly"] = 47.61, ["Ride"] = 18.02, ["Fly|Ride"] = 35.9, ["Neon"] = 50.6, ["Neon|Fly"] = 190.46, ["Neon|Ride"] = 49.25, ["Neon|Fly|Ride"] = 95.82, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 281.31}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 1.79, ["Fly"] = 21.02, ["Ride"] = 14.38, ["Fly|Ride"] = 32.15, ["Neon"] = 6.79, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 69.47, ["Mega"] = 61.95, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 180.79}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 32.15, ["Ride"] = 83.16, ["Fly|Ride"] = 280.35, ["Neon"] = 281.3, ["Neon|Ride"] = 187.95, ["Mega"] = 977.74, ["Mega|Ride"] = 770.86, ["Mega|Fly|Ride"] = 1190.95}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 64.16, ["Neon"] = 5.16, ["Neon|Fly"] = 135.72, ["Neon|Ride"] = 29.76, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 42.29, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 69.21, ["Ride"] = 20.58, ["Fly|Ride"] = 60.92, ["Neon"] = 9.05, ["Neon|Ride"] = 41.88, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 114.19, ["Mega|Ride"] = 198.6, ["Mega|Fly|Ride"] = 351.74}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 59.07, ["Neon"] = 26.24, ["Mega"] = 94.05, ["Mega|Ride"] = 157.54, ["Mega|Fly|Ride"] = 376.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 1.79, ["Fly"] = 42, ["Ride"] = 16.51, ["Fly|Ride"] = 49.87, ["Neon"] = 3.15, ["Neon|Ride"] = 24.36, ["Neon|Fly|Ride"] = 99.79, ["Mega"] = 38.75, ["Mega|Fly"] = 229.68, ["Mega|Ride"] = 63.84, ["Mega|Fly|Ride"] = 168.05}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.39, ["Fly"] = 19.98, ["Ride"] = 17.58, ["Fly|Ride"] = 32.8, ["Neon"] = 317.85, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 101.07, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 461.49}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 714, ["Ride"] = 682.5, ["Fly|Ride"] = 787.5, ["Neon"] = 1782.92, ["Neon|Ride"] = 1967.44, ["Neon|Fly|Ride"] = 1990.86, ["Mega"] = 4654.5, ["Mega|Ride"] = 6287.56, ["Mega|Fly|Ride"] = 6161.53}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 15.71, ["Ride"] = 15.33, ["Fly|Ride"] = 33.9, ["Neon"] = 2.1, ["Neon|Fly"] = 21.02, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 50.98, ["Mega"] = 44.62, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 140.75}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.4, ["Ride"] = 36.74, ["Fly|Ride"] = 202, ["Neon"] = 43.32, ["Neon|Fly"] = 71.44, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 366.18, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 535.62}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 55.13, ["Fly"] = 104.9, ["Ride"] = 56.58, ["Fly|Ride"] = 110.25, ["Neon"] = 515.66, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 383.27, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2040.94}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.91, ["Ride"] = 39.92, ["Fly|Ride"] = 101.77, ["Neon"] = 187.69, ["Neon|Ride"] = 220.56, ["Neon|Fly|Ride"] = 309.83, ["Mega"] = 983.89, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1020.8}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 8.57, ["Ride"] = 25.97, ["Fly|Ride"] = 140.91, ["Neon"] = 69.57, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 116.6, ["Mega"] = 288.75, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.04, ["Ride"] = 56.72, ["Neon"] = 103.68, ["Neon|Ride"] = 139.61, ["Mega"] = 314.35, ["Mega|Fly"] = 516.57, ["Mega|Ride"] = 351.14, ["Mega|Fly|Ride"] = 784.23}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 18.42, ["Fly"] = 126.9, ["Ride"] = 62.88, ["Fly|Ride"] = 152.17, ["Neon"] = 252, ["Neon|Ride"] = 317.81, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 630.13, ["Mega|Fly|Ride"] = 563.21}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.3}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.6, ["Fly"] = 131248.69, ["Ride"] = 20.13, ["Fly|Ride"] = 58.82, ["Neon"] = 31.52, ["Neon|Ride"] = 48.95, ["Neon|Fly|Ride"] = 182.76, ["Mega"] = 196.27, ["Mega|Fly"] = 474.7, ["Mega|Ride"] = 167, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.45, ["Ride"] = 46.85, ["Neon"] = 11.81, ["Neon|Ride"] = 39.92, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 140.75, ["Mega|Fly|Ride"] = 405.57}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 36.74, ["Fly"] = 56.72, ["Ride"] = 56.72, ["Fly|Ride"] = 79.73, ["Neon"] = 262.5, ["Neon|Ride"] = 207.12, ["Neon|Fly|Ride"] = 952.21, ["Mega|Ride"] = 1680.33}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.15, ["Fly"] = 17.59, ["Ride"] = 15.22, ["Fly|Ride"] = 33.36, ["Neon"] = 23.18, ["Neon|Fly"] = 61.98, ["Neon|Ride"] = 31.38, ["Neon|Fly|Ride"] = 73.38, ["Mega"] = 182.76, ["Mega|Fly"] = 419.05, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 211.68}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 2.62, ["Fly"] = 36.77, ["Ride"] = 22.22, ["Fly|Ride"] = 55.7, ["Neon"] = 14.43, ["Neon|Ride"] = 41.48, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 135.83, ["Mega|Ride"] = 169.25, ["Mega|Fly|Ride"] = 260.25}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 7.88, ["Mega"] = 38.75, ["Mega|Ride"] = 196.4}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 24.68, ["Fly"] = 77.17, ["Ride"] = 52.5, ["Fly|Ride"] = 89.25, ["Neon"] = 183.75, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 289.87, ["Mega"] = 765.66, ["Mega|Ride"] = 14003.36}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.36, ["Fly|Ride"] = 65.63, ["Neon"] = 6.3, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 28.38, ["Mega"] = 74.81, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 462.2}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 9.16, ["Ride"] = 78.14, ["Fly|Ride"] = 279.3, ["Neon"] = 107.09, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 374.07, ["Mega|Ride"] = 391.75, ["Mega|Fly|Ride"] = 603.47}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 1.93, ["Fly"] = 45.91, ["Ride"] = 12.66, ["Fly|Ride"] = 50.42, ["Neon"] = 18.83, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 75.88, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.2, ["Fly|Ride"] = 75.12, ["Neon"] = 35.44, ["Neon|Fly"] = 66.18, ["Neon|Ride"] = 420.1, ["Mega"] = 291.38, ["Mega|Ride"] = 419.05, ["Mega|Fly|Ride"] = 412.79}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 33.62, ["Neon"] = 39.36, ["Neon|Ride"] = 32.16, ["Mega"] = 476.12, ["Mega|Ride"] = 952.21}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 39.88, ["Ride"] = 91.88, ["Neon"] = 269.07, ["Neon|Ride"] = 654.29, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 2241.15, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 16.93, ["Ride"] = 280.35, ["Neon"] = 103.97, ["Neon|Ride"] = 183.75, ["Mega"] = 452.92, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 3.02, ["Ride"] = 125.97, ["Neon"] = 171.62, ["Neon|Fly"] = 210.06, ["Neon|Ride"] = 420.1, ["Mega"] = 140.75, ["Mega|Ride"] = 839.12}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.89, ["Ride"] = 232.32, ["Fly|Ride"] = 367.46, ["Neon"] = 103.36, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 604.54, ["Mega|Fly"] = 2100.4, ["Mega|Fly|Ride"] = 666.54}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.43, ["Neon"] = 13, ["Mega"] = 210, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 317.81}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 128.52, ["Ride"] = 17.81, ["Fly|Ride"] = 40.61, ["Neon"] = 3.77, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 140.75, ["Mega|Ride"] = 79.76, ["Mega|Fly|Ride"] = 195.35}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Ride"] = 42.02, ["Fly|Ride"] = 65.63, ["Neon"] = 15.21, ["Neon|Ride"] = 69.3, ["Neon|Fly|Ride"] = 119.04, ["Mega"] = 104.99, ["Mega|Ride"] = 132.14, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 16.56, ["Fly|Ride"] = 56.44, ["Neon"] = 3.14, ["Neon|Ride"] = 25.88, ["Neon|Fly|Ride"] = 79.76, ["Mega"] = 38.21, ["Mega|Fly"] = 168.05, ["Mega|Ride"] = 62.91, ["Mega|Fly|Ride"] = 191.02}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 18, ["Fly|Ride"] = 112.35, ["Neon"] = 15.73, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.02, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 476.12}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 19.59, ["Fly|Ride"] = 103.69, ["Neon"] = 25.89, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 287.46}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 14.3, ["Fly|Ride"] = 61.65, ["Neon"] = 19.47, ["Neon|Fly"] = 112.4, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 196.88, ["Mega|Ride"] = 302.33, ["Mega|Fly|Ride"] = 394.42}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.07, ["Ride"] = 19.68, ["Fly|Ride"] = 51.78, ["Neon"] = 18.79, ["Neon|Ride"] = 70.26, ["Neon|Fly|Ride"] = 105.04, ["Mega"] = 238.41, ["Mega|Ride"] = 210.06, ["Mega|Fly|Ride"] = 245.76}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 57.66, ["Ride"] = 43.29, ["Fly|Ride"] = 87.93, ["Neon"] = 15.65, ["Neon|Fly"] = 437.04, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 103.49, ["Mega|Fly"] = 178.55, ["Mega|Ride"] = 132.2, ["Mega|Fly|Ride"] = 223.12}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.27, ["Fly"] = 106.56, ["Ride"] = 99.54, ["Fly|Ride"] = 225.75, ["Neon"] = 111.57, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 321.38, ["Mega"] = 519.75, ["Mega|Ride"] = 669.37, ["Mega|Fly|Ride"] = 690.89}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.19, ["Fly"] = 164.07, ["Ride"] = 79.82, ["Fly|Ride"] = 490.21, ["Neon"] = 221.8, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 488.01, ["Mega"] = 1155.24, ["Mega|Ride"] = 1061.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 1.79, ["Fly"] = 50.97, ["Ride"] = 18.35, ["Fly|Ride"] = 73.79, ["Neon"] = 2.1, ["Neon|Ride"] = 23.99, ["Mega"] = 27.19, ["Mega|Ride"] = 47.16, ["Mega|Fly|Ride"] = 144.01}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 8.69, ["Mega|Fly|Ride"] = 1033.41}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 55.49, ["Fly"] = 105, ["Ride"] = 78.75, ["Fly|Ride"] = 183.75, ["Neon"] = 299.14, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 839.12, ["Mega"] = 1721.29}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 3.85, ["Fly"] = 190.32, ["Ride"] = 36.74, ["Fly|Ride"] = 133.87, ["Neon"] = 36.63, ["Neon|Ride"] = 84.03, ["Neon|Fly|Ride"] = 210, ["Mega"] = 192.93, ["Mega|Ride"] = 223.12, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.82, ["Ride"] = 65.37, ["Fly|Ride"] = 140.7, ["Neon"] = 9.01, ["Neon|Ride"] = 65.62, ["Mega"] = 78.75, ["Mega|Fly"] = 310.84, ["Mega|Ride"] = 137.81, ["Mega|Fly|Ride"] = 362.15}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 21.84, ["Ride"] = 14.3, ["Fly|Ride"] = 39.38, ["Neon"] = 8.91, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 236.15, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 140.75, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 1.79, ["Fly"] = 16.74, ["Ride"] = 14.44, ["Fly|Ride"] = 41.2, ["Neon"] = 2.1, ["Neon|Fly"] = 17.77, ["Neon|Ride"] = 23.82, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 28.88, ["Mega|Ride"] = 69.55, ["Mega|Fly|Ride"] = 118.14}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.46, ["Fly|Ride"] = 90.95, ["Neon"] = 3.14, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 38.75, ["Mega|Ride"] = 140.75, ["Mega|Fly|Ride"] = 177.11}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 1.79, ["Ride"] = 52.49, ["Fly|Ride"] = 119, ["Neon"] = 2.6, ["Neon|Ride"] = 145.07, ["Mega"] = 21.45, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.02, ["Ride"] = 104.98, ["Neon"] = 30.45, ["Neon|Ride"] = 159.51, ["Neon|Fly|Ride"] = 630.13, ["Mega"] = 317.81, ["Mega|Ride"] = 269.48, ["Mega|Fly|Ride"] = 317.81}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.25, ["Ride"] = 31.61, ["Fly|Ride"] = 98.72, ["Neon"] = 52.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.75, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.28, ["Fly"] = 20.99, ["Ride"] = 16.71, ["Fly|Ride"] = 38.75, ["Neon"] = 29.5, ["Neon|Ride"] = 38.17, ["Neon|Fly|Ride"] = 91.77, ["Mega|Ride"] = 350.78, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 56.21, ["Ride"] = 160.13, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 449.5, ["Mega"] = 2380.49, ["Mega|Fly|Ride"] = 1472.63}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 26.34, ["Fly"] = 82.67, ["Ride"] = 31.4, ["Fly|Ride"] = 78.75, ["Neon"] = 280.35, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.6, ["Mega|Ride"] = 689.73, ["Mega|Fly|Ride"] = 694.98}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 1.79, ["Fly"] = 25.79, ["Ride"] = 15.75, ["Fly|Ride"] = 38.06, ["Neon"] = 2.1, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 61.98, ["Mega"] = 32.71, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.37, ["Ride"] = 12.22, ["Fly|Ride"] = 28.25, ["Neon"] = 3.84, ["Neon|Fly"] = 27.19, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 42.76, ["Mega"] = 43.19, ["Mega|Fly"] = 91.39, ["Mega|Ride"] = 56.35, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.81, ["Fly"] = 606.8, ["Ride"] = 446.24, ["Fly|Ride"] = 551.24, ["Neon|Fly|Ride"] = 1903.12}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.5, ["Ride"] = 64.97, ["Fly|Ride"] = 535.42, ["Neon"] = 45.26, ["Neon|Ride"] = 106.81, ["Mega"] = 364.43, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 280053.42}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.78, ["Ride"] = 15.75, ["Fly|Ride"] = 27.92, ["Neon"] = 3.94, ["Neon|Fly"] = 23.82, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 36.4, ["Mega"] = 140.75, ["Mega|Ride"] = 74.97, ["Mega|Fly|Ride"] = 105.45}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.98, ["Ride"] = 141.37, ["Fly|Ride"] = 280.35, ["Neon"] = 262.39, ["Neon|Ride"] = 269, ["Neon|Fly|Ride"] = 463.16, ["Mega"] = 719.25, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 878.36}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 37.82, ["Ride"] = 15.65, ["Fly|Ride"] = 35.44, ["Neon"] = 12.11, ["Neon|Fly"] = 61.86, ["Neon|Ride"] = 22.43, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 111.38, ["Mega|Ride"] = 124.76, ["Mega|Fly|Ride"] = 215.19}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 1.79, ["Fly"] = 70.35, ["Ride"] = 42.02, ["Neon"] = 2.1, ["Neon|Ride"] = 35.43, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 19.69, ["Mega|Ride"] = 56.14, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.94, ["Fly"] = 102.39, ["Ride"] = 66.89, ["Fly|Ride"] = 213.94, ["Neon"] = 141.88, ["Neon|Ride"] = 191.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 830.82, ["Mega|Ride"] = 840.17, ["Mega|Fly|Ride"] = 811.13}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 3.88, ["Neon|Ride"] = 39.99, ["Mega"] = 36.75, ["Mega|Ride"] = 197.4, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 23.63, ["Ride"] = 51.17, ["Fly|Ride"] = 159.45, ["Neon"] = 335.99, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 359.63, ["Mega"] = 1659.33, ["Mega|Ride"] = 1680.33, ["Mega|Fly|Ride"] = 1512.31}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.18, ["Ride"] = 183.74, ["Neon"] = 21.94, ["Neon|Ride"] = 79.76, ["Neon|Fly|Ride"] = 155.45, ["Mega"] = 157.49, ["Mega|Ride"] = 147}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 71.3, ["Fly|Ride"] = 70.49, ["Neon"] = 7.4, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 117.6, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 28.37, ["Ride"] = 104.99, ["Fly|Ride"] = 524.98, ["Neon"] = 140.75, ["Neon|Ride"] = 700.88, ["Mega"] = 2100.4, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 1802.15}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 1.79, ["Fly"] = 52.5, ["Ride"] = 15.75, ["Fly|Ride"] = 60.2, ["Neon"] = 3.82, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 46.35, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 1.79, ["Fly"] = 15.49, ["Ride"] = 15.18, ["Fly|Ride"] = 101.82, ["Neon"] = 10.9, ["Neon|Fly"] = 47.77, ["Neon|Ride"] = 24.18, ["Neon|Fly|Ride"] = 119.04, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.47, ["Fly"] = 58.49, ["Ride"] = 31.48, ["Fly|Ride"] = 75.78, ["Neon"] = 81.77, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 441.1, ["Mega|Ride"] = 392.79, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 8.96, ["Fly"] = 57.11, ["Ride"] = 21.02, ["Fly|Ride"] = 71.52, ["Neon"] = 118.12, ["Neon|Ride"] = 135.94, ["Neon|Fly|Ride"] = 121.84, ["Mega"] = 354.25, ["Mega|Ride"] = 418.59, ["Mega|Fly|Ride"] = 496.91}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.69, ["Fly"] = 51.19, ["Ride"] = 25.99, ["Fly|Ride"] = 64.26, ["Neon"] = 56.6, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 138.65, ["Mega"] = 560.82, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 432.69}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 58.47, ["Ride"] = 104.85, ["Fly|Ride"] = 236.25, ["Neon"] = 288.75, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 476.12, ["Mega"] = 1428.3, ["Mega|Ride"] = 1260.26, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.02, ["Fly"] = 140.7, ["Ride"] = 28.88, ["Neon"] = 24.04, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 118.69, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 223.13, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 399.09}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.68, ["Ride"] = 26.25, ["Fly|Ride"] = 78.74, ["Neon"] = 15.89, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 262.49, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 9.86, ["Ride"] = 24.04, ["Fly|Ride"] = 110.95, ["Neon"] = 47.59, ["Neon|Ride"] = 138.65, ["Neon|Fly|Ride"] = 238.07, ["Mega"] = 518.7, ["Mega|Ride"] = 490.46, ["Mega|Fly|Ride"] = 735.16}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 1.79, ["Fly"] = 15.49, ["Ride"] = 12.62, ["Fly|Ride"] = 31.18, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 13.41, ["Neon|Fly|Ride"] = 39.25, ["Mega"] = 15.35, ["Mega|Ride"] = 29.96, ["Mega|Fly|Ride"] = 93.83}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 52.49, ["Fly"] = 222.6, ["Ride"] = 105, ["Neon"] = 264.27, ["Neon|Fly"] = 2380.82, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 3150.6, ["Mega|Ride"] = 945, ["Mega|Fly|Ride"] = 918.74}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.05, ["Ride"] = 21.02, ["Fly|Ride"] = 35.72, ["Neon"] = 3.15, ["Neon|Ride"] = 27.44, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 265.72, ["Mega|Ride"] = 138.41, ["Mega|Fly|Ride"] = 406.44}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.05, ["Fly"] = 28.37, ["Ride"] = 16.67, ["Fly|Ride"] = 59.07, ["Neon"] = 42.02, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 257.25, ["Mega|Ride"] = 138.65, ["Mega|Fly|Ride"] = 210.06}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 65.63, ["Fly"] = 157.5, ["Ride"] = 91.88, ["Fly|Ride"] = 258.57, ["Neon"] = 437.07, ["Neon|Ride"] = 341.57, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 1748.25, ["Mega|Ride"] = 1758.75, ["Mega|Fly|Ride"] = 1618.32}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 20.9, ["Neon"] = 5.43, ["Neon|Ride"] = 52.4, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 63.94, ["Mega|Ride"] = 96.12, ["Mega|Fly|Ride"] = 261.18}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 9.17}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Fly|Ride"] = 298.2, ["Neon"] = 4.45, ["Neon|Ride"] = 50.3, ["Neon|Fly|Ride"] = 155.45, ["Mega"] = 44.5, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 212.85}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 1.79}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 110.93, ["Ride"] = 118.46, ["Fly|Ride"] = 302.23, ["Neon"] = 836.07, ["Neon|Ride"] = 698.69, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3360.66, ["Mega|Ride"] = 2493.75, ["Mega|Fly|Ride"] = 2825.05}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.14, ["Ride"] = 41.91, ["Fly|Ride"] = 101.07, ["Neon"] = 19.58, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.4, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 369.69}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 23.1, ["Ride"] = 35.72, ["Neon"] = 3.71, ["Neon|Ride"] = 20.23, ["Mega"] = 19.06, ["Mega|Ride"] = 98.74, ["Mega|Fly|Ride"] = 140.75}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.05, ["Ride"] = 19.52, ["Fly|Ride"] = 131.25, ["Neon"] = 50.74, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 490.46, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 625.64}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 8.99, ["Fly"] = 57.9, ["Ride"] = 21.02, ["Fly|Ride"] = 55.94, ["Neon"] = 99, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 616.88, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 18.26, ["Ride"] = 63.67, ["Fly|Ride"] = 126.13, ["Neon"] = 131.25, ["Neon|Ride"] = 162.8, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 784.51, ["Mega|Ride"] = 594.48, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 142.9, ["Fly"] = 196.76, ["Ride"] = 144.38, ["Fly|Ride"] = 203.74, ["Neon"] = 593.14, ["Neon|Ride"] = 590, ["Neon|Fly|Ride"] = 654.94, ["Mega|Fly|Ride"] = 2418.94}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 40.2, ["Fly"] = 23.81, ["Ride"] = 30.47, ["Fly|Ride"] = 129.92, ["Neon"] = 519.74, ["Neon|Ride"] = 420.1, ["Neon|Fly|Ride"] = 684.75, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.73, ["Fly"] = 131.15, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 132.14, ["Mega|Ride"] = 140.32, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.54, ["Fly"] = 98.43, ["Ride"] = 35.18, ["Fly|Ride"] = 180.6, ["Neon"] = 52.5, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 157.54, ["Mega"] = 379.31, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 42, ["Fly"] = 142.78, ["Ride"] = 76.67, ["Fly|Ride"] = 124.69, ["Neon"] = 219.19, ["Neon|Ride"] = 276.22, ["Neon|Fly|Ride"] = 336.08, ["Mega"] = 1111.69, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1002.04}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 12.57, ["Ride"] = 70.35, ["Neon"] = 155.73, ["Neon|Ride"] = 181.86, ["Neon|Fly|Ride"] = 463.16, ["Mega"] = 686.85, ["Mega|Ride"] = 620.69}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 449.39, ["Neon|Ride"] = 3174.39, ["Neon|Fly|Ride"] = 1376.82}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 28.3, ["Fly"] = 56.72, ["Ride"] = 32.8, ["Fly|Ride"] = 65.54, ["Neon"] = 224.26, ["Neon|Ride"] = 182.76, ["Neon|Fly|Ride"] = 317.81, ["Mega"] = 761.25, ["Mega|Ride"] = 734.9, ["Mega|Fly|Ride"] = 889.84}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 1.79, ["Fly"] = 38.64, ["Ride"] = 12.62, ["Fly|Ride"] = 33.62, ["Neon"] = 2.1, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 43.66, ["Mega"] = 19.55, ["Mega|Fly"] = 100.84, ["Mega|Ride"] = 35.6, ["Mega|Fly|Ride"] = 104.92}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Neon"] = 7.61, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 128.88, ["Mega|Ride"] = 119.04, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.04, ["Ride"] = 38.57, ["Fly|Ride"] = 144.21, ["Neon"] = 18.38, ["Neon|Ride"] = 82.98, ["Neon|Fly|Ride"] = 980.89, ["Mega"] = 108.84, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 354.37, ["Fly|Ride"] = 525, ["Neon"] = 1424.39, ["Neon|Ride"] = 1582.67, ["Neon|Fly|Ride"] = 1537.51, ["Mega|Fly|Ride"] = 5321.37}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 20.61, ["Ride"] = 16.61, ["Fly|Ride"] = 42, ["Neon"] = 21, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 168, ["Mega|Ride"] = 280.42, ["Mega|Fly|Ride"] = 563.07}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.7, ["Fly"] = 22.32, ["Ride"] = 17.48, ["Fly|Ride"] = 35.44, ["Neon"] = 39.36, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.83, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 267.82, ["Mega|Fly|Ride"] = 286.38}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.79, ["Fly"] = 32.45, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 10.84, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 102.64, ["Mega|Ride"] = 189.06, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.24, ["Fly"] = 42.14, ["Ride"] = 42.02, ["Fly|Ride"] = 65.63, ["Neon"] = 119.05, ["Neon|Ride"] = 173.79, ["Neon|Fly|Ride"] = 314.02, ["Mega"] = 1312.5, ["Mega|Ride"] = 839.12, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 28.37, ["Fly|Ride"] = 50.3, ["Neon"] = 11.46, ["Neon|Ride"] = 37.51, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.73, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 7.16, ["Fly"] = 64.28, ["Ride"] = 25.6, ["Fly|Ride"] = 91.88, ["Neon"] = 168.71, ["Neon|Fly"] = 159.52, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 735.16, ["Mega|Ride"] = 756.16, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 5.65, ["Neon|Ride"] = 35.11, ["Mega"] = 52.49, ["Mega|Ride"] = 119.67, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 3.95, ["Neon"] = 50.66}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.91, ["Ride"] = 77.72, ["Neon"] = 79.71, ["Neon|Ride"] = 70.67, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 280.42, ["Mega|Ride"] = 545.06, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.47, ["Fly"] = 27.92, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 34.54, ["Neon|Fly"] = 70.39, ["Neon|Ride"] = 45.92, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 590.22, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 336.84, ["Fly"] = 475.92, ["Ride"] = 388.42, ["Fly|Ride"] = 426.57, ["Neon"] = 1659, ["Neon|Ride"] = 1190.95, ["Neon|Fly|Ride"] = 1428.3}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 1.79, ["Ride"] = 15.64, ["Fly|Ride"] = 35.72, ["Neon"] = 13.01, ["Neon|Fly"] = 79.76, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 205.86, ["Mega|Ride"] = 196.77}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 7.32, ["Fly"] = 70.35, ["Ride"] = 44.12, ["Fly|Ride"] = 65.62, ["Neon"] = 45.05, ["Neon|Ride"] = 155.45, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 236.25, ["Mega|Fly"] = 700.49, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 29.71, ["Ride"] = 102.52, ["Fly|Ride"] = 314.99, ["Neon"] = 114.23, ["Neon|Ride"] = 142.93, ["Neon|Fly|Ride"] = 346.37, ["Mega"] = 422.62, ["Mega|Ride"] = 354.27, ["Mega|Fly|Ride"] = 541.8}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 91.35, ["Fly"] = 169.32, ["Ride"] = 140.7, ["Fly|Ride"] = 196.88, ["Neon|Ride"] = 1470.3, ["Neon|Fly|Ride"] = 945.19, ["Mega|Ride"] = 5554.86}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 57.17, ["Ride"] = 85.68, ["Fly|Ride"] = 130.96, ["Neon"] = 98.74, ["Neon|Ride"] = 105.16, ["Neon|Fly|Ride"] = 363.56, ["Mega"] = 275.63, ["Mega|Ride"] = 259.06, ["Mega|Fly|Ride"] = 443.49}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 1.93, ["Fly"] = 28.87, ["Ride"] = 19.58, ["Fly|Ride"] = 58.45, ["Neon"] = 12.48, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 70.39, ["Mega"] = 65.61, ["Mega|Ride"] = 145.22, ["Mega|Fly|Ride"] = 238.07}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.89, ["Ride"] = 31.52, ["Neon"] = 23.35, ["Neon|Ride"] = 94.25, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 116.6, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 52.9, ["Fly"] = 183.74, ["Ride"] = 84.08, ["Fly|Ride"] = 104.99, ["Neon"] = 131.19, ["Neon|Ride"] = 157.36, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 417.64, ["Mega|Ride"] = 693.15, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 1.79, ["Ride"] = 131.25, ["Fly|Ride"] = 140.7, ["Neon"] = 6.15, ["Neon|Fly"] = 84.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 55.13, ["Mega|Fly"] = 181.13, ["Mega|Ride"] = 173.1, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 15.77, ["Neon"] = 119.69, ["Neon|Ride"] = 401.03, ["Mega"] = 588.12, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.38, ["Fly"] = 1194.38, ["Ride"] = 1040.58, ["Fly|Ride"] = 1050, ["Neon"] = 3341.76, ["Neon|Ride"] = 3318.65, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 11585.79}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 13.1, ["Fly"] = 87.64, ["Ride"] = 57.31, ["Fly|Ride"] = 143.16, ["Neon"] = 202.13, ["Neon|Fly"] = 699.45, ["Neon|Ride"] = 210.06, ["Mega"] = 337.89, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 21.4, ["Fly|Ride"] = 80.91, ["Neon"] = 10.38, ["Neon|Fly"] = 56.73, ["Neon|Ride"] = 33.06, ["Neon|Fly|Ride"] = 91.46, ["Mega"] = 82.86, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 246.59}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 6.45, ["Ride"] = 47.79, ["Fly|Ride"] = 140.7, ["Neon"] = 95.71, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 787.5, ["Mega|Ride"] = 420.1, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 1.79, ["Ride"] = 35.05, ["Fly|Ride"] = 182.7, ["Neon"] = 2.1, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 80.06, ["Mega"] = 15.64, ["Mega|Fly"] = 126.04, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 159.52}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 51.97, ["Ride"] = 101.62, ["Fly|Ride"] = 196.77, ["Neon"] = 260.75, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 387.91, ["Mega"] = 1091.12, ["Mega|Ride"] = 930.57, ["Mega|Fly|Ride"] = 958.13}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.27, ["Ride"] = 63, ["Fly|Ride"] = 79.73, ["Neon"] = 70.26, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 576.19, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 558.72}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.81, ["Ride"] = 27.32, ["Neon"] = 13.11, ["Neon|Ride"] = 65.62, ["Mega"] = 85.32, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 19.94, ["Fly"] = 66.15, ["Ride"] = 41.18, ["Fly|Ride"] = 118.91, ["Neon"] = 81.93, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 155.45, ["Mega"] = 1039.49, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.41, ["Fly"] = 32.57, ["Ride"] = 30.23, ["Fly|Ride"] = 84, ["Neon"] = 58.33, ["Neon|Ride"] = 209.7, ["Neon|Fly|Ride"] = 118.89, ["Mega"] = 384.39, ["Mega|Ride"] = 519.86, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 30.18, ["Ride"] = 208.68, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 910.53, ["Mega"] = 2100.4, ["Mega|Ride"] = 1680.33, ["Mega|Fly|Ride"] = 1678.23}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.85, ["Ride"] = 44.63, ["Fly|Ride"] = 255.34, ["Neon"] = 15.77, ["Neon|Ride"] = 84.03, ["Neon|Fly|Ride"] = 168.78, ["Mega"] = 99.93, ["Mega|Ride"] = 159.51, ["Mega|Fly|Ride"] = 226.94}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.82, ["Fly"] = 19.69, ["Ride"] = 18.92, ["Fly|Ride"] = 81.92, ["Neon"] = 63, ["Neon|Ride"] = 58.24, ["Neon|Fly|Ride"] = 114.77, ["Mega"] = 301.67, ["Mega|Ride"] = 378.09, ["Mega|Fly|Ride"] = 600.73}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 116.81, ["Fly"] = 173.72, ["Ride"] = 171.84, ["Fly|Ride"] = 207.9, ["Neon"] = 577.6, ["Neon|Ride"] = 679.88, ["Neon|Fly|Ride"] = 689.07, ["Mega"] = 2327.07, ["Mega|Ride"] = 2344.06, ["Mega|Fly|Ride"] = 1945.13}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.05, ["Fly"] = 24.61, ["Ride"] = 17.72, ["Fly|Ride"] = 39.29, ["Neon"] = 12.46, ["Neon|Fly"] = 57.53, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 140.75, ["Mega|Ride"] = 238.07, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.2, ["Fly"] = 195.43, ["Ride"] = 39.14, ["Fly|Ride"] = 93.8, ["Neon"] = 79.73, ["Neon|Fly"] = 317.85, ["Neon|Ride"] = 82.88, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 452.81, ["Mega|Ride"] = 465.26, ["Mega|Fly|Ride"] = 411.52}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 1.79, ["Fly"] = 18.36, ["Ride"] = 14.7, ["Fly|Ride"] = 28.37, ["Neon"] = 2.05, ["Neon|Fly"] = 26.46, ["Neon|Ride"] = 15.64, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.74, ["Mega|Fly"] = 50, ["Mega|Ride"] = 28.38, ["Mega|Fly|Ride"] = 70.88}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 56.72, ["Fly|Ride"] = 39.38, ["Neon"] = 3.71, ["Neon|Ride"] = 39.92, ["Neon|Fly|Ride"] = 130.24, ["Mega"] = 17.07, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 126.04}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Ride"] = 26.32, ["Fly|Ride"] = 112.77, ["Neon"] = 16.7, ["Neon|Ride"] = 52.53, ["Neon|Fly|Ride"] = 207.12, ["Mega"] = 77.44, ["Mega|Ride"] = 266.77, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 30.13, ["Ride"] = 52.47, ["Fly|Ride"] = 131.25, ["Neon"] = 164.06, ["Neon|Ride"] = 336.08, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 427.28, ["Mega|Ride"] = 576.19, ["Mega|Fly|Ride"] = 687.9}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 1.79, ["Fly"] = 17.12, ["Ride"] = 13.98, ["Fly|Ride"] = 30.72, ["Neon"] = 9.47, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 24.01, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 103.59, ["Mega|Fly"] = 170.62, ["Mega|Ride"] = 121.35, ["Mega|Fly|Ride"] = 157.24}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.9, ["Fly"] = 45.03, ["Ride"] = 24.59, ["Fly|Ride"] = 84.76, ["Neon"] = 25.67, ["Neon|Fly"] = 55.86, ["Neon|Ride"] = 37.25, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 210, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 225.75, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 65.63, ["Neon"] = 7.96, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 70.39, ["Mega"] = 159.51, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 74.93, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 7.06, ["Fly"] = 158.55, ["Ride"] = 23.71, ["Fly|Ride"] = 217.19, ["Neon"] = 26.25, ["Neon|Ride"] = 79.83, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 261.83, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 377.04, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 4.78, ["Ride"] = 56.72, ["Fly|Ride"] = 134.4, ["Neon"] = 39.38, ["Neon|Ride"] = 126.04, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 980.89}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 7.88, ["Fly"] = 42.02, ["Ride"] = 16.8, ["Fly|Ride"] = 44.82, ["Neon"] = 13.13, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 111.89, ["Mega"] = 262.49, ["Mega|Ride"] = 325.58, ["Mega|Fly|Ride"] = 414.85}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.09, ["Ride"] = 17.06, ["Fly|Ride"] = 35.88, ["Neon"] = 16.02, ["Neon|Fly"] = 47.63, ["Neon|Ride"] = 35.73, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 238.07, ["Mega|Ride"] = 278.53, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.44, ["Fly"] = 314.99, ["Ride"] = 299.84, ["Fly|Ride"] = 392.44, ["Neon"] = 1121.97, ["Neon|Ride"] = 1392.6, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4019.12}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.75, ["Ride"] = 109.51, ["Neon"] = 60.93, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 122.07, ["Mega|Ride"] = 420.6}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 105.41, ["Ride"] = 21.54, ["Fly|Ride"] = 79.07, ["Neon"] = 22.41, ["Neon|Fly"] = 238.41, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 204.64, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 6.23, ["Fly|Ride"] = 212.89, ["Neon"] = 36.64, ["Neon|Ride"] = 222.66, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.53, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 414.1}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.05, ["Fly"] = 16.06, ["Ride"] = 13.86, ["Fly|Ride"] = 29.59, ["Neon"] = 2.1, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 12.62, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 18.92, ["Mega|Fly"] = 75.64, ["Mega|Ride"] = 42.02, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 1.87, ["Fly"] = 24.18, ["Ride"] = 15.1, ["Fly|Ride"] = 112.35, ["Neon"] = 8.3, ["Neon|Ride"] = 23.61, ["Neon|Fly|Ride"] = 96.76, ["Mega"] = 104.87, ["Mega|Ride"] = 110.24, ["Mega|Fly|Ride"] = 220.66}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 39.92, ["Neon"] = 10.34, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 117.85, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.88, ["Ride"] = 89.25, ["Fly|Ride"] = 170.52, ["Neon"] = 556.49, ["Neon|Ride"] = 373.75, ["Neon|Fly|Ride"] = 557.67, ["Mega"] = 2100.4, ["Mega|Ride"] = 3502.43, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 2.1, ["Fly"] = 98.72, ["Ride"] = 28.49, ["Fly|Ride"] = 141.75, ["Neon"] = 22.89, ["Neon|Ride"] = 62.33, ["Neon|Fly|Ride"] = 420.1, ["Mega"] = 157.49, ["Mega|Ride"] = 184.24, ["Mega|Fly|Ride"] = 566.07}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.3, ["Ride"] = 33.09, ["Neon"] = 5.25, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 534.43, ["Mega"] = 42, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 41.05, ["Fly"] = 210, ["Ride"] = 96.15, ["Fly|Ride"] = 191.86, ["Neon"] = 131.25, ["Neon|Ride"] = 202.13, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 590.63, ["Mega|Ride"] = 623.44, ["Mega|Fly|Ride"] = 581.44}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.04, ["Ride"] = 12.58, ["Fly|Ride"] = 28.58, ["Neon"] = 2.1, ["Neon|Fly"] = 17.13, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 32.7, ["Mega"] = 18.38, ["Mega|Fly"] = 49.86, ["Mega|Ride"] = 34.12, ["Mega|Fly|Ride"] = 86.37}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 33.65, ["Neon"] = 3.15, ["Neon|Fly"] = 32.58, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 20.57, ["Mega|Ride"] = 82.46, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 41.91, ["Neon"] = 8.37, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 98.04, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 104.53, ["Mega|Fly"] = 182.76, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 233.29}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.49, ["Fly"] = 56.72, ["Ride"] = 37.82, ["Fly|Ride"] = 127.32, ["Neon"] = 15.74, ["Neon|Fly"] = 90.33, ["Neon|Ride"] = 77.86, ["Neon|Fly|Ride"] = 191.71, ["Mega"] = 103.36, ["Mega|Fly"] = 260.47, ["Mega|Ride"] = 191.9, ["Mega|Fly|Ride"] = 254.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 12.5, ["Fly|Ride"] = 36.77, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.01, ["Mega"] = 9.54, ["Mega|Ride"] = 52.41, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 14.44, ["Fly"] = 131.25, ["Ride"] = 70.35, ["Neon"] = 128.63, ["Neon|Fly"] = 420.1, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 532.47, ["Mega|Ride"] = 524.99, ["Mega|Fly|Ride"] = 644.84}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2493.75, ["Fly|Ride"] = 2598.75, ["Neon|Fly|Ride"] = 9661.84, ["Mega|Fly|Ride"] = 42006.93}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 1.79, ["Fly"] = 16.59, ["Ride"] = 14.14, ["Fly|Ride"] = 31.82, ["Neon"] = 4.64, ["Neon|Fly"] = 56.16, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 62.27, ["Mega"] = 76.13, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 4.39, ["Mega"] = 140.75, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.51, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.1, ["Fly"] = 112.35, ["Ride"] = 28.56, ["Fly|Ride"] = 70.35, ["Neon"] = 70.88, ["Neon|Ride"] = 103.79, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 367.5, ["Mega|Ride"] = 445.3}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 28.2, ["Ride"] = 50.74, ["Neon"] = 159.52, ["Neon|Fly|Ride"] = 224.76, ["Mega"] = 603.47, ["Mega|Ride"] = 602.83, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 129.92, ["Fly"] = 1400.64, ["Ride"] = 197.88, ["Fly|Ride"] = 251.98, ["Neon"] = 770.67, ["Neon|Ride"] = 700.41, ["Neon|Fly|Ride"] = 715.32, ["Mega"] = 6301.2, ["Mega|Fly|Ride"] = 3806.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 3.71, ["Ride"] = 31.49, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 140.75, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 156.19, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 309.83, ["Mega|Fly|Ride"] = 357.08}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 35.72, ["Fly|Ride"] = 69.4, ["Neon"] = 22.84, ["Neon|Ride"] = 114.85, ["Mega"] = 140.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 846.27}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 26.16, ["Fly|Ride"] = 131.25, ["Neon"] = 6.46, ["Neon|Fly"] = 123.94, ["Neon|Ride"] = 38.58, ["Mega"] = 73.5, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 9.18, ["Ride"] = 103.05, ["Neon"] = 180.65, ["Neon|Ride"] = 1193.83, ["Neon|Fly|Ride"] = 494.66, ["Mega"] = 374.06, ["Mega|Ride"] = 465.26, ["Mega|Fly|Ride"] = 805.52}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 1.79, ["Ride"] = 42.02, ["Neon"] = 2.1, ["Neon|Ride"] = 47.67, ["Mega"] = 18.92, ["Mega|Fly"] = 119.04, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 80.93, ["Fly"] = 160.26, ["Ride"] = 103.72, ["Fly|Ride"] = 159.45, ["Neon"] = 366.19, ["Neon|Ride"] = 401.06, ["Neon|Fly|Ride"] = 324.28, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.82, ["Neon"] = 10.28, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 71.44, ["Mega|Ride"] = 279.37}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 36.75, ["Fly"] = 100.82, ["Ride"] = 74.68, ["Fly|Ride"] = 157.48, ["Neon"] = 278.57, ["Neon|Ride"] = 485.62, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 1.79, ["Fly"] = 61.97, ["Ride"] = 20.9, ["Fly|Ride"] = 51.31, ["Neon"] = 3.63, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 41.92, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 180.65}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 3.94, ["Neon"] = 7.55, ["Neon|Ride"] = 98.44, ["Mega"] = 89.15, ["Mega|Ride"] = 152.36, ["Mega|Fly|Ride"] = 480.39}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.8, ["Fly"] = 77.43, ["Ride"] = 38.57, ["Fly|Ride"] = 210, ["Neon"] = 26.25, ["Neon|Ride"] = 120.75, ["Mega"] = 262.5, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 349.13, ["Ride"] = 328.13, ["Fly|Ride"] = 393.75, ["Neon"] = 1050, ["Neon|Ride"] = 964.66, ["Neon|Fly|Ride"] = 1144.5, ["Mega"] = 3922.51, ["Mega|Ride"] = 4132.54, ["Mega|Fly|Ride"] = 4165.85}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.72, ["Fly"] = 84.02, ["Ride"] = 48.55, ["Fly|Ride"] = 100.19, ["Neon"] = 187.02, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 287.96, ["Mega"] = 1398.89, ["Mega|Fly|Ride"] = 983.07}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 17.77, ["Fly|Ride"] = 72.19, ["Neon"] = 10.29, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 120.65, ["Mega|Ride"] = 109.44, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.11, ["Fly"] = 54.62, ["Ride"] = 43.99, ["Fly|Ride"] = 157.5, ["Neon"] = 68.25, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 72.17, ["Neon|Fly|Ride"] = 182.39, ["Mega"] = 326.7, ["Mega|Fly"] = 979.58, ["Mega|Ride"] = 380.89, ["Mega|Fly|Ride"] = 423.25}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.07, ["Fly"] = 35.72, ["Ride"] = 20.77, ["Fly|Ride"] = 42.02, ["Neon"] = 141.8, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 270.2, ["Mega"] = 309.83, ["Mega|Ride"] = 321.38, ["Mega|Fly|Ride"] = 560.82}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.1, ["Neon"] = 17.06, ["Mega"] = 78.75, ["Mega|Fly"] = 157.4, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 207.55}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.88, ["Fly|Ride"] = 56.72, ["Neon"] = 41.91, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 86.52, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 107.22, ["Ride"] = 108.94, ["Fly|Ride"] = 238.87, ["Neon"] = 775.39, ["Neon|Ride"] = 523.67, ["Neon|Fly|Ride"] = 568.5, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3123.3}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 30.35, ["Ride"] = 46.1, ["Fly|Ride"] = 91.87, ["Neon"] = 142.95, ["Neon|Ride"] = 210.06, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 1120.59, ["Mega|Ride"] = 840.17, ["Mega|Fly|Ride"] = 692.1}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1995, ["Fly"] = 2030.44, ["Ride"] = 2060.63, ["Fly|Ride"] = 2085.57, ["Neon"] = 11199.76, ["Neon|Fly|Ride"] = 6424.69, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.1, ["Fly"] = 65625, ["Ride"] = 32.82, ["Neon"] = 16.72, ["Mega"] = 97.46, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 460.64}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 6.93, ["Ride"] = 47.25, ["Fly|Ride"] = 114.19, ["Neon"] = 26.16, ["Neon|Ride"] = 76.56, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 150.94, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 1050.2}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 1101.19, ["Fly"] = 948.54, ["Ride"] = 899.06, ["Fly|Ride"] = 971.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2624.99, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 12323.06, ["Mega|Fly|Ride"] = 11342.17}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 21.44, ["Ride"] = 52.49, ["Fly|Ride"] = 173.35, ["Neon"] = 176.82, ["Neon|Ride"] = 203.75, ["Neon|Fly|Ride"] = 376.14, ["Mega"] = 839.9, ["Mega|Ride"] = 804.56, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.28, ["Ride"] = 23.61, ["Fly|Ride"] = 128.15, ["Neon"] = 11.89, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 266.77, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.41, ["Ride"] = 140.7, ["Neon"] = 2.83, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 92.44, ["Mega"] = 19.58, ["Mega|Ride"] = 78.75}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 87.86, ["Ride"] = 105, ["Fly|Ride"] = 170.63, ["Neon"] = 419.99, ["Neon|Ride"] = 595.13, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2380.49, ["Mega|Fly|Ride"] = 2100.4}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Fly|Ride"] = 73.41, ["Neon"] = 12.18, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 159.51, ["Mega"] = 117.59, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 76.51, ["Ride"] = 102.38, ["Fly|Ride"] = 123.92, ["Neon"] = 393.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 515.66, ["Mega|Fly|Ride"] = 1783.26}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.85, ["Fly"] = 105, ["Fly|Ride"] = 126.02, ["Neon"] = 26.22, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 183.14, ["Mega|Ride"] = 309.83}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 244.39, ["Fly"] = 354.38, ["Ride"] = 237.98, ["Fly|Ride"] = 334.68, ["Neon"] = 1137.32, ["Neon|Ride"] = 1112.18, ["Neon|Fly|Ride"] = 879.03, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.15, ["Fly"] = 87.94, ["Ride"] = 14.44, ["Fly|Ride"] = 103.94, ["Neon"] = 31.06, ["Neon|Fly"] = 159.52, ["Neon|Ride"] = 57.2, ["Neon|Fly|Ride"] = 100.7, ["Mega"] = 236.25, ["Mega|Ride"] = 656.23}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 1.79, ["Fly"] = 19.17, ["Ride"] = 15.3, ["Fly|Ride"] = 31.78, ["Neon"] = 3.4, ["Neon|Fly"] = 31.29, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 35.15, ["Mega"] = 39.38, ["Mega|Ride"] = 64.32, ["Mega|Fly|Ride"] = 124.42}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1190.65, ["Ride"] = 1050, ["Fly|Ride"] = 1189.78, ["Neon|Ride"] = 7702.16, ["Neon|Fly|Ride"] = 6301.2, ["Mega"] = 23328.66, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.49, ["Fly"] = 980.65, ["Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 132.34, ["Mega"] = 320.25, ["Mega|Ride"] = 358.39, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 3.51, ["Fly"] = 50.42, ["Ride"] = 46.48, ["Fly|Ride"] = 79.73, ["Neon"] = 15.54, ["Neon|Fly"] = 176.19, ["Neon|Ride"] = 52.39, ["Neon|Fly|Ride"] = 210, ["Mega"] = 170.63, ["Mega|Ride"] = 195.7, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 28.87, ["Fly"] = 39.38, ["Ride"] = 31.67, ["Fly|Ride"] = 45.94, ["Neon"] = 157.5, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 190.31, ["Mega|Ride"] = 1111.69, ["Mega|Fly|Ride"] = 799.31}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.39, ["Fly"] = 84.02, ["Ride"] = 24.76, ["Fly|Ride"] = 85.31, ["Neon"] = 69.53, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 179.8, ["Mega"] = 367.5, ["Mega|Fly"] = 478.9, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 31.81, ["Ride"] = 111.86, ["Fly|Ride"] = 409.49, ["Neon"] = 183.26, ["Neon|Ride"] = 376.69, ["Neon|Fly|Ride"] = 528.94, ["Mega"] = 1050, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 588.12}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 1.79, ["Ride"] = 116.61, ["Fly|Ride"] = 119, ["Neon"] = 2.1, ["Neon|Ride"] = 111.89, ["Mega"] = 15.65, ["Mega|Ride"] = 83.54, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 52.5, ["Fly"] = 123.92, ["Ride"] = 72.17, ["Fly|Ride"] = 118.13, ["Neon"] = 446.24, ["Neon|Ride"] = 360.94, ["Neon|Fly|Ride"] = 447.57, ["Mega"] = 3360.66, ["Mega|Ride"] = 1728.64, ["Mega|Fly|Ride"] = 1591.34}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 18.8, ["Fly|Ride"] = 70.88, ["Neon"] = 65.63, ["Neon|Ride"] = 111.34, ["Neon|Fly|Ride"] = 168.05, ["Mega"] = 773.06, ["Mega|Ride"] = 397.56}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 21.02, ["Ride"] = 15.65, ["Fly|Ride"] = 35.72, ["Neon"] = 17.16, ["Neon|Fly"] = 79.76, ["Neon|Ride"] = 56.73, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.06, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 138.65, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.4, ["Mega"] = 375.99, ["Mega|Fly|Ride"] = 476.12}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 64.32, ["Ride"] = 72.02, ["Fly|Ride"] = 262.5, ["Neon"] = 288.75, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 560.82, ["Mega|Ride"] = 1442.99, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 7.7, ["Fly|Ride"] = 419.99, ["Neon"] = 16.67, ["Neon|Ride"] = 78.78, ["Mega"] = 125.9, ["Mega|Ride"] = 126.04, ["Mega|Fly|Ride"] = 317.81}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 1.79, ["Ride"] = 33.78, ["Neon"] = 2.1, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 15.75, ["Mega|Ride"] = 40.28, ["Mega|Fly|Ride"] = 525.12}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 1.79, ["Fly"] = 102.94, ["Ride"] = 32.55, ["Fly|Ride"] = 60.11, ["Neon"] = 3.67, ["Neon|Ride"] = 28.17, ["Neon|Fly|Ride"] = 70.39, ["Mega"] = 16.83, ["Mega|Ride"] = 55.49, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 15.52, ["Fly|Ride"] = 52.5, ["Neon"] = 7.27, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 28.38, ["Neon|Fly|Ride"] = 84.52, ["Mega"] = 61.68, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 182.76}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.35, ["Neon"] = 39.38, ["Mega"] = 118.09, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 15.14, ["Fly|Ride"] = 32.37, ["Neon"] = 15.77, ["Neon|Fly"] = 210.06, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 144.38, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 56.39, ["Ride"] = 91.62, ["Fly|Ride"] = 266.69, ["Neon"] = 196.88, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 1050.2, ["Mega"] = 694.32, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1111.69}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.48, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 21.02, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 46.23, ["Mega"] = 18.69, ["Mega|Ride"] = 23.92, ["Mega|Fly|Ride"] = 99.65}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.41, ["Fly"] = 129.93, ["Ride"] = 25.88, ["Fly|Ride"] = 57.2, ["Neon"] = 26.22, ["Neon|Fly"] = 87.28, ["Neon|Ride"] = 47.57, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 381.57, ["Mega|Fly"] = 285.06, ["Mega|Ride"] = 213.5, ["Mega|Fly|Ride"] = 308.43}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 9.97, ["Fly"] = 27.46, ["Ride"] = 25.73, ["Fly|Ride"] = 84.58, ["Neon"] = 126.04, ["Neon|Fly"] = 174.49, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 182.43, ["Mega"] = 787.5, ["Mega|Ride"] = 756.16, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Neon"] = 52.31, ["Mega"] = 366.19, ["Mega|Ride"] = 1049.99, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 1.79, ["Fly"] = 15.75, ["Ride"] = 14.94, ["Fly|Ride"] = 37.82, ["Neon"] = 3.92, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 58.46, ["Mega"] = 44.22, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 121.03}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 2.85, ["Fly"] = 71.4, ["Ride"] = 37.97, ["Neon"] = 22.74, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 205.69, ["Mega"] = 210.06, ["Mega|Fly"] = 735, ["Mega|Ride"] = 224.76, ["Mega|Fly|Ride"] = 392.79}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 918.75, ["Fly"] = 1380.16, ["Ride"] = 1045.54, ["Fly|Ride"] = 1099.88, ["Neon"] = 3118.78, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2362.4, ["Mega|Fly|Ride"] = 7197.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 104.81, ["Ride"] = 166.59, ["Fly|Ride"] = 412.86, ["Neon"] = 629.08, ["Neon|Ride"] = 628.68, ["Neon|Fly|Ride"] = 820.31, ["Mega"] = 3149.56, ["Mega|Ride"] = 2661.22, ["Mega|Fly|Ride"] = 2360}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.05, ["Fly"] = 56.72, ["Ride"] = 39.38, ["Neon"] = 5.93, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 204.8, ["Mega"] = 89.25, ["Mega|Fly|Ride"] = 1120.59}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 70.14, ["Ride"] = 129.93, ["Fly|Ride"] = 229.69, ["Neon"] = 392.42, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 406.86, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1836.19, ["Mega|Ride"] = 1796.82, ["Mega|Fly|Ride"] = 1728.67}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.76, ["Ride"] = 20.55, ["Fly|Ride"] = 91.35, ["Neon"] = 14, ["Neon|Fly"] = 55.97, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 280.42, ["Mega|Ride"] = 349.19, ["Mega|Fly|Ride"] = 406.44}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.13, ["Fly"] = 419.99, ["Ride"] = 271.69, ["Fly|Ride"] = 350.01, ["Neon|Ride"] = 1199.35, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 4607.24}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 76.4, ["Ride"] = 40.97, ["Fly|Ride"] = 219.96, ["Neon"] = 21, ["Neon|Fly"] = 35.73, ["Neon|Ride"] = 54.37, ["Mega"] = 393.75, ["Mega|Fly"] = 327.68, ["Mega|Ride"] = 635.6}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.37, ["Neon"] = 28.6, ["Mega"] = 336.08, ["Mega|Ride"] = 360.23}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 21.67, ["Ride"] = 71.39, ["Fly|Ride"] = 151.12, ["Neon"] = 84.36, ["Neon|Ride"] = 124.69, ["Mega"] = 642.75, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.73, ["Neon"] = 25.24, ["Neon|Ride"] = 140.75, ["Mega"] = 238.07, ["Mega|Ride"] = 253.3, ["Mega|Fly|Ride"] = 465.41}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 1.79, ["Fly"] = 18.38, ["Ride"] = 13.13, ["Fly|Ride"] = 39.36, ["Neon"] = 2.1, ["Neon|Fly"] = 23.63, ["Neon|Ride"] = 15.8, ["Neon|Fly|Ride"] = 28.51, ["Mega"] = 23.82, ["Mega|Ride"] = 42.87, ["Mega|Fly|Ride"] = 80.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4828.02, ["Ride"] = 5124, ["Fly|Ride"] = 4929.75, ["Neon"] = 31498.3, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 131274.88}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.35, ["Fly"] = 84.02, ["Ride"] = 41.57, ["Neon"] = 53.43, ["Neon|Ride"] = 105, ["Mega"] = 210, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 420.1}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 1.79, ["Fly"] = 24.7, ["Ride"] = 16.52, ["Fly|Ride"] = 33.5, ["Neon"] = 13.36, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 63, ["Mega"] = 124.69, ["Mega|Ride"] = 176.06, ["Mega|Fly|Ride"] = 237.36}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 432.94, ["Fly"] = 547.31, ["Ride"] = 480.51, ["Fly|Ride"] = 551.25, ["Neon"] = 1612.22, ["Neon|Ride"] = 1519.44, ["Neon|Fly|Ride"] = 1500.65, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 5.39, ["Ride"] = 32.62, ["Neon"] = 19.23, ["Neon|Ride"] = 291.38, ["Mega"] = 140.6, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.39, ["Fly"] = 4199.79, ["Ride"] = 65.62, ["Neon"] = 23.63, ["Neon|Ride"] = 45.24, ["Mega"] = 1141.58, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 820.98}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 18.37, ["Neon"] = 3.8, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 23.29, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 37.97, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 222.58}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 643.09, ["Ride"] = 735, ["Fly|Ride"] = 781.59, ["Neon|Ride"] = 2793.55, ["Neon|Fly|Ride"] = 2480.62, ["Mega|Fly|Ride"] = 9102.09}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 4.75, ["Fly"] = 295.08, ["Ride"] = 51.39, ["Fly|Ride"] = 419.99, ["Neon"] = 26.43, ["Neon|Ride"] = 81.93, ["Neon|Fly|Ride"] = 285.67, ["Mega"] = 165.55, ["Mega|Ride"] = 229.04, ["Mega|Fly|Ride"] = 393.19}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.08, ["Fly"] = 236.15, ["Ride"] = 31.07, ["Fly|Ride"] = 111.86, ["Neon"] = 22.31, ["Neon|Ride"] = 51.35, ["Neon|Fly|Ride"] = 144.35, ["Mega"] = 184.86, ["Mega|Fly"] = 793.91, ["Mega|Ride"] = 214.17, ["Mega|Fly|Ride"] = 265.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.12, ["Ride"] = 16.68, ["Fly|Ride"] = 45.94, ["Neon"] = 11.54, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 81.36, ["Mega"] = 280.42, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 202.84}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.57, ["Ride"] = 34.12, ["Fly|Ride"] = 47.65, ["Neon"] = 117.58, ["Neon|Ride"] = 70.39, ["Neon|Fly|Ride"] = 315.07, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 980.89}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.05, ["Ride"] = 42.88, ["Fly|Ride"] = 84.02, ["Neon"] = 6.25, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 40.45, ["Mega|Fly"] = 166.64, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 226.7}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 622.54, ["Ride"] = 535.5, ["Fly|Ride"] = 629.98, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9283.87, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 76.21, ["Fly|Ride"] = 131.25, ["Neon"] = 15.2, ["Neon|Ride"] = 85.61, ["Neon|Fly|Ride"] = 476.12, ["Mega"] = 183.65, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 1.79, ["Ride"] = 27.57, ["Neon"] = 6.32, ["Neon|Fly"] = 105.04, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 86.63, ["Mega|Ride"] = 140.75}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 1.79, ["Ride"] = 49.43, ["Neon"] = 3.83, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 210.06, ["Mega"] = 34.53, ["Mega|Fly"] = 155.45, ["Mega|Ride"] = 103.24, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 28.65, ["Neon"] = 37.82, ["Mega"] = 210.06, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 25.07, ["Fly"] = 98.44, ["Ride"] = 50.3, ["Fly|Ride"] = 498.74, ["Neon"] = 118.12, ["Neon|Fly"] = 140.75, ["Neon|Ride"] = 137.22, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 918.75, ["Mega|Ride"] = 544.69, ["Mega|Fly|Ride"] = 561.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 10.17, ["Ride"] = 48.21, ["Fly|Ride"] = 128.99, ["Neon"] = 81.79, ["Neon|Ride"] = 125.98, ["Neon|Fly|Ride"] = 280.42, ["Mega"] = 492.18, ["Mega|Ride"] = 440.99, ["Mega|Fly|Ride"] = 560.44}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 16.48, ["Fly|Ride"] = 32.82, ["Neon"] = 28.38, ["Neon|Ride"] = 32.05, ["Neon|Fly|Ride"] = 87.18, ["Mega"] = 255.29, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 249.96}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.76, ["Ride"] = 32.57, ["Fly|Ride"] = 121.82, ["Neon"] = 54.63, ["Neon|Ride"] = 138.65, ["Mega|Ride"] = 410.82}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 23.46, ["Fly|Ride"] = 87.04, ["Neon"] = 10.29, ["Neon|Ride"] = 40.74, ["Neon|Fly|Ride"] = 112.4, ["Mega"] = 77.14, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 15.43, ["Fly"] = 64.26, ["Ride"] = 19.69, ["Fly|Ride"] = 54.62, ["Neon"] = 419.99, ["Neon|Ride"] = 525.12, ["Neon|Fly|Ride"] = 189.56, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 827.57}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 23.66, ["Fly"] = 874.13, ["Neon"] = 133.77, ["Mega"] = 452.65, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 495.48}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.94, ["Fly"] = 115.5, ["Ride"] = 81.18, ["Fly|Ride"] = 160.13, ["Neon"] = 314.99, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 418.97, ["Mega|Ride"] = 1683.01, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 35.34, ["Fly"] = 84.02, ["Ride"] = 76.73, ["Fly|Ride"] = 204.75, ["Neon"] = 144.35, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 398.04, ["Mega"] = 584.06, ["Mega|Ride"] = 609.53, ["Mega|Fly|Ride"] = 618.78}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 16.68, ["Ride"] = 64.31, ["Neon"] = 131.15, ["Neon|Ride"] = 428.3, ["Mega"] = 1049.99, ["Mega|Ride"] = 703.74}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.67, ["Fly"] = 419.99, ["Ride"] = 32.22, ["Fly|Ride"] = 192.95, ["Neon"] = 129.34, ["Neon|Fly"] = 420, ["Neon|Ride"] = 139.78, ["Neon|Fly|Ride"] = 142.85, ["Mega"] = 464.37, ["Mega|Ride"] = 546.95, ["Mega|Fly|Ride"] = 634.51}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 1.79, ["Fly"] = 17.91, ["Ride"] = 15.25, ["Fly|Ride"] = 32.73, ["Neon"] = 3.9, ["Neon|Fly"] = 28.32, ["Neon|Ride"] = 29.03, ["Neon|Fly|Ride"] = 48.4, ["Mega"] = 40.32, ["Mega|Fly"] = 330.83, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1012.94}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 41.91, ["Ride"] = 95.18, ["Fly|Ride"] = 419.99, ["Neon"] = 345.19, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1540.66, ["Mega|Ride"] = 1466.1, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.73, ["Neon"] = 2.1, ["Neon|Ride"] = 43.19, ["Neon|Fly|Ride"] = 285.67, ["Mega"] = 23.51, ["Mega|Ride"] = 84.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 20, ["Ride"] = 52.5, ["Fly|Ride"] = 159.45, ["Neon"] = 123.9, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 519.74, ["Mega|Ride"] = 793.91, ["Mega|Fly|Ride"] = 686.82}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 22.91}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 1.79, ["Neon"] = 3.94, ["Neon|Ride"] = 39.38, ["Mega"] = 21.66, ["Mega|Ride"] = 149.98}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.55, ["Fly"] = 223.13, ["Ride"] = 141.36, ["Fly|Ride"] = 302.23, ["Neon"] = 446.25, ["Neon|Ride"] = 451.5, ["Neon|Fly|Ride"] = 656.25, ["Mega|Ride"] = 6546.32, ["Mega|Fly|Ride"] = 2001.45}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.09, ["Fly|Ride"] = 95.2, ["Neon"] = 4.23, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 280.42}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 68.84, ["Fly|Ride"] = 51.45, ["Neon"] = 2.71, ["Neon|Ride"] = 25.6, ["Neon|Fly|Ride"] = 140.75, ["Mega"] = 34.13, ["Mega|Ride"] = 126.04, ["Mega|Fly|Ride"] = 278.53}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.74, ["Neon"] = 6.27, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 207.38, ["Mega"] = 76.12, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 82.68, ["Neon"] = 6.15, ["Neon|Ride"] = 155.92, ["Mega"] = 59.07, ["Mega|Ride"] = 210.06}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 60.41, ["Ride"] = 135.19, ["Fly|Ride"] = 449.39, ["Neon"] = 424.07, ["Neon|Ride"] = 479.34, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2031.09, ["Mega|Ride"] = 1575.31, ["Mega|Fly|Ride"] = 1575.31}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 2.63, ["Ride"] = 33.62, ["Neon"] = 39.36, ["Neon|Ride"] = 32.16, ["Mega"] = 476.12, ["Mega|Ride"] = 952.21}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 347.08, ["Ride"] = 324.83, ["Fly|Ride"] = 509.23, ["Neon"] = 1115.63, ["Neon|Ride"] = 1270, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4023.02}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 1.79}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 89.25}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 48.5}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.82}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 18.87}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 65}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 104.32}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.28}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.13}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 262.48}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 26.16}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.71}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.91}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 2.78}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 131.25}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.11}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.31}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.84}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 9.84}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 12.17}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 561.75}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 790.07}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 8.03}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1050}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.05}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 57.75}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.78}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.63}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 31.94}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.36}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.44}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 4.58}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.44}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.09}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 46.68}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.73}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 10.91}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 17.75}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 4.94}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 18.32}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 18.05}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 140.07}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 3.19}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2068.5}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 28.25}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.92}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.18}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 9.09}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 6.04}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 49.64}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 193.17}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.43}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 6.27}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 141.49}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 26}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 2.25}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 22}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.04}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 111.57}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 32.51}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.4}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.74}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 4.2}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 32.7}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 87.41}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 223}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.22}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 131.25}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.92}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.22}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.9}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 1.79}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22606.96}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 140.7}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 78.74}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 43.15}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 78.75}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 26.25}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.49}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 33.41}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 81.29}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 43.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 56.81}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 138.66}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 54.55}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 50.42}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 233.37}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.16}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.11}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.5}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 31.29}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 118.12}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.15}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 5.23}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 2.1}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 12.78}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 1.79}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.05}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 955.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.57}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.47}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.62}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.62}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 21}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 171.17}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.09}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 20.79}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 47.57}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 14.11}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.56}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 1.79}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.88}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.05}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.49}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.34}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 28.88}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.05}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.14}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.17}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 282.05}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 1.79}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.05}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 1.79}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.05}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 629.98}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.62}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 6.19}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 3.93}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 25.66}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 15.6}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 4.5}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 8.58}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.15}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 12.1}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 23.63}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 15.06}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 4.52}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 4.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.05}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 5.39}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 5.97}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.62}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.45}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.58}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.7}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 1.79}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8348.82}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 20.31}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.96}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.57}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 18.59}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.59}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.43}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 1.79}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 30.19}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.97}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.8}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4199.79}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.33}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.05}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 26.91}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 6.37}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.67}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 64.61}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.15}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 97.13}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 1.79}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 14.28}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.15}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 2.1}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.7}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 13.13}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.55}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.59}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 15.71}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 1.79}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 1.79}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.72}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.05}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 5.8}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.05}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.23}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.5}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.85}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.92}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 9.06}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.53}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 62.08}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.61}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 8.38}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1097.06}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 31.5}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.67}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 1.79}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 18.64}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.16}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 6.13}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.76}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 10.87}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.54}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.36}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 1.79}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 1.79}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.06}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 6.23}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.59}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 8.12}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.35}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 1.92}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.55}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.44}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.33}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 3.08}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.05}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 20.03}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.87}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.85}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 4.55}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 32.51}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 85.31}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 6.65}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.92}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 1.79}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 48.57}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.02}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 32.45}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.5}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.6}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.03}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 1.79}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.03}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 74.43}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 144.04}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 7.07}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1425.44}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.39}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 183.72}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.31}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.69}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 54.74}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 6.18}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.83}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 1.79}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.46}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 67.55}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.59}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 8.65}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.05}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.05}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 1.79}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.01}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.97}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.26}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.62}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.63}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 24.04}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 134.4}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.05}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 8.54}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 4.34}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 1.79}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 17.87}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 56.84}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 1.79}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 53.43}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 66.94}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 167.95}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.6}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 54.32}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 120.56}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.51}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 8.93}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 28.87}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 66.68}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 3.93}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.66}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.61}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 2.37}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 81.38}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 20.9}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 62.36}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 33.18}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.05}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 1.79}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 73.32}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 43.82}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.11}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.71}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 1.8}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 13}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 65.01}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 33.37}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 82.74}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1963.56}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.19}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 22.79}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 386.24}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.95}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 16.82}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.05}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 11.1}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 11.38}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 2.96}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.84}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 52.28}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.22}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 1.79}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 65.64}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 157.15}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 1.96}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 70.71}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1049.95}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 151.17}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 3.94}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
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