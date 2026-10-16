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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1139.2, ["Ride"] = 1049.99, ["Fly|Ride"] = 1687.88, ["Neon"] = 6720.33, ["Neon|Fly|Ride"] = 5118.75, ["Mega|Fly|Ride"] = 20618.29}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 433.12, ["Fly"] = 640.83, ["Ride"] = 496.75, ["Fly|Ride"] = 538.13, ["Neon"] = 2088.28, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 11999.32, ["Mega|Fly|Ride"] = 6999.66}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6015.43, ["Ride"] = 5250, ["Fly|Ride"] = 4959.82, ["Neon|Fly|Ride"] = 24249.22, ["Mega|Fly|Ride"] = 70490.19}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 141.68, ["Ride"] = 222.04, ["Fly|Ride"] = 213.12, ["Neon"] = 1120.87, ["Neon|Ride"] = 971.72, ["Neon|Fly|Ride"] = 1056.3, ["Mega|Fly|Ride"] = 4371.09}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 845.79, ["Ride"] = 505.32, ["Fly|Ride"] = 565.11, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Fly|Ride"] = 6485.78}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.12, ["Ride"] = 57.1, ["Fly|Ride"] = 105, ["Neon"] = 71.47, ["Neon|Fly"] = 282.32, ["Neon|Ride"] = 84.6, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 350.21, ["Mega|Ride"] = 353.17, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.24, ["Fly"] = 49.88, ["Ride"] = 29.72, ["Fly|Ride"] = 65.63, ["Neon"] = 31.38, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 64.21, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 176.59, ["Mega|Ride"] = 228.41, ["Mega|Fly|Ride"] = 298.37}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Ride"] = 185.07, ["Fly|Ride"] = 208.69, ["Neon"] = 529.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 353.17, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2756.52}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 35.43, ["Fly"] = 80.41, ["Ride"] = 41.46, ["Fly|Ride"] = 104.68, ["Neon"] = 257.25, ["Neon|Ride"] = 197.74, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1410.51, ["Mega|Ride"] = 1120.75, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 23.63, ["Fly"] = 57.1, ["Ride"] = 27.45, ["Fly|Ride"] = 70.75, ["Neon"] = 208.82, ["Neon|Ride"] = 121.61, ["Neon|Fly|Ride"] = 184, ["Mega|Ride"] = 482.31, ["Mega|Fly|Ride"] = 705.26}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.36, ["Fly"] = 113.14, ["Ride"] = 85.35, ["Fly|Ride"] = 162.75, ["Neon"] = 341.84, ["Neon|Ride"] = 316.16, ["Neon|Fly|Ride"] = 425.25, ["Mega|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 1268.82}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 73.39}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 384.76, ["Fly"] = 399, ["Ride"] = 326.81, ["Fly|Ride"] = 378.19, ["Neon"] = 1260.21, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 5074.22}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 169.17, ["Ride"] = 111.57, ["Fly|Ride"] = 174.2, ["Neon|Fly"] = 693.63, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 631.78, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.45, ["Fly"] = 34.13, ["Ride"] = 57.1, ["Fly|Ride"] = 131.25, ["Neon"] = 23.36, ["Neon|Ride"] = 48.02, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 150.94, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 240}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 196.88, ["Fly"] = 223.13, ["Ride"] = 177.19, ["Fly|Ride"] = 216.57, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 692.9, ["Mega|Fly|Ride"] = 3102.27}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.94, ["Fly"] = 25.58, ["Ride"] = 16.21, ["Fly|Ride"] = 38.07, ["Neon"] = 30.68, ["Neon|Fly"] = 126.9, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 206.2, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.54, ["Fly"] = 160.82, ["Ride"] = 124.69, ["Fly|Ride"] = 236.25, ["Neon"] = 259.88, ["Neon|Ride"] = 385.6, ["Neon|Fly|Ride"] = 426.16, ["Mega"] = 1691.76, ["Mega|Ride"] = 1434.2, ["Mega|Fly|Ride"] = 1391.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.18}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 76.13, ["Ride"] = 232.32, ["Fly|Ride"] = 273.83, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 776.1, ["Mega|Fly|Ride"] = 2114.7}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 19.27, ["Fly"] = 54.98, ["Ride"] = 32.82, ["Fly|Ride"] = 329.44, ["Neon"] = 320.43, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 2759.86, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 705.26}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.75, ["Fly"] = 78.75, ["Ride"] = 51.85, ["Fly|Ride"] = 103.58, ["Neon"] = 304.83, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 1679.92, ["Mega|Ride"] = 1015.07, ["Mega|Fly|Ride"] = 941.07}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.27, ["Ride"] = 111.56, ["Fly|Ride"] = 196.88, ["Neon"] = 141.7, ["Neon|Fly"] = 398.44, ["Neon|Ride"] = 380.72, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1691.76, ["Mega|Fly|Ride"] = 1280.34}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.19, ["Ride"] = 33.42, ["Fly|Ride"] = 83.91, ["Neon"] = 120.65, ["Neon|Ride"] = 211.47, ["Neon|Fly|Ride"] = 253.32, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 38.07, ["Fly"] = 137.46, ["Ride"] = 54.86, ["Fly|Ride"] = 177.63, ["Neon"] = 175.22, ["Neon|Fly"] = 233.68, ["Neon|Ride"] = 212.79, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.2, ["Fly"] = 26.93, ["Ride"] = 23.62, ["Fly|Ride"] = 52.46, ["Neon"] = 36.74, ["Neon|Fly"] = 79.32, ["Neon|Ride"] = 57.65, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 170.63, ["Mega|Fly"] = 353.17, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 399, ["Ride"] = 420, ["Fly|Ride"] = 479.99, ["Neon"] = 2114.7, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10573.48, ["Mega|Fly|Ride"] = 8177.54}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 6.45, ["Ride"] = 27.46, ["Fly|Ride"] = 124.77, ["Neon"] = 214.81, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 803.6, ["Mega|Fly|Ride"] = 923.08}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.8, ["Fly"] = 37.3, ["Ride"] = 21.3, ["Fly|Ride"] = 47.24, ["Neon"] = 52.49, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 125.98, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 78.75, ["Fly"] = 119.34, ["Ride"] = 103.22, ["Fly|Ride"] = 122.42, ["Neon"] = 367.97, ["Neon|Fly"] = 324.62, ["Neon|Ride"] = 363.75, ["Neon|Fly|Ride"] = 395.01, ["Mega"] = 6358.45, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 15.88, ["Ride"] = 32.24, ["Fly|Ride"] = 75.51, ["Neon"] = 94.49, ["Neon|Ride"] = 112.83, ["Neon|Fly|Ride"] = 184, ["Mega"] = 705.26, ["Mega|Ride"] = 719.97}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 201.32, ["Fly"] = 262.5, ["Ride"] = 205.64, ["Fly|Ride"] = 291.38, ["Neon"] = 739.1, ["Neon|Ride"] = 696.05, ["Neon|Fly|Ride"] = 730.16, ["Mega"] = 6344.09, ["Mega|Fly|Ride"] = 2905.61}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.59}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.57, ["Fly"] = 32.81, ["Ride"] = 18.94, ["Fly|Ride"] = 55.13, ["Neon"] = 26.17, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.41, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 184, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 826.88, ["Fly"] = 2625, ["Ride"] = 903.83, ["Fly|Ride"] = 918.75, ["Neon"] = 6343.04, ["Neon|Ride"] = 4794.02, ["Neon|Fly|Ride"] = 4723.18, ["Mega|Ride"] = 53996.93, ["Mega|Fly|Ride"] = 16917.56}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.74, ["Fly"] = 50.43, ["Ride"] = 38.05, ["Fly|Ride"] = 91.88, ["Neon"] = 156.5, ["Neon|Ride"] = 99.41, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1082.74, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 183.75, ["Fly"] = 360.03, ["Ride"] = 251.86, ["Fly|Ride"] = 284.82, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4001.79}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.43, ["Fly"] = 126.89, ["Ride"] = 42.31, ["Fly|Ride"] = 141.68, ["Neon"] = 90.02, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 338.37, ["Mega"] = 353.22, ["Mega|Ride"] = 564.77, ["Mega|Fly|Ride"] = 593.98}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 110.11, ["Ride"] = 141.68, ["Fly|Ride"] = 269.61, ["Neon"] = 480.04, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 501.19, ["Mega"] = 2114.7, ["Mega|Ride"] = 2114.7, ["Mega|Fly|Ride"] = 1988.75}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 101.22, ["Fly"] = 157.49, ["Ride"] = 149.63, ["Fly|Ride"] = 262.5, ["Neon"] = 387.19, ["Neon|Fly"] = 564.63, ["Neon|Ride"] = 348.04, ["Neon|Fly|Ride"] = 493.5, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 43.8}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 52.5, ["Fly"] = 80.89, ["Ride"] = 56.84, ["Fly|Ride"] = 63.95, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4229.39, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.18, ["Fly"] = 98.44, ["Ride"] = 42.31, ["Fly|Ride"] = 157.5, ["Neon"] = 35.97, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 237.92, ["Mega"] = 170.63, ["Mega|Fly"] = 359.99, ["Mega|Ride"] = 295.19, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 570.84, ["Fly"] = 591, ["Ride"] = 479.01, ["Fly|Ride"] = 526.56, ["Neon|Fly"] = 3806.46, ["Neon|Ride"] = 1833.45, ["Neon|Fly|Ride"] = 1756.13, ["Mega"] = 8458.78, ["Mega|Ride"] = 14802.87, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 95.82, ["Fly"] = 156.49, ["Ride"] = 128.42, ["Fly|Ride"] = 169.32, ["Neon"] = 479.07, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2537.64, ["Mega|Fly|Ride"] = 2550.64}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4228.89, ["Ride"] = 3885, ["Fly|Ride"] = 3806.01, ["Neon|Fly|Ride"] = 14801.82}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 45.93, ["Fly"] = 120.58, ["Ride"] = 45.94, ["Fly|Ride"] = 131.25, ["Neon"] = 438.81, ["Neon|Ride"] = 312.38, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1901.12, ["Mega|Ride"] = 1804.91, ["Mega|Fly|Ride"] = 1620.94}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 72.18, ["Ride"] = 65.63, ["Fly|Ride"] = 141.68, ["Neon"] = 640.84, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6203.47, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1826.9}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.65, ["Fly"] = 45.94, ["Ride"] = 42, ["Fly|Ride"] = 84, ["Neon"] = 169.21, ["Neon|Fly"] = 288.03, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 197.74, ["Mega"] = 987.57, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.35}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.72, ["Ride"] = 37.66, ["Fly|Ride"] = 72.02, ["Neon|Ride"] = 211.47, ["Neon|Fly|Ride"] = 422.94, ["Mega|Ride"] = 1280.34, ["Mega|Fly|Ride"] = 1505.67}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 36.72}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 223.13, ["Ride"] = 183.75, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1114.46, ["Neon|Fly|Ride"] = 1095.43, ["Mega|Fly|Ride"] = 4559.3}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 630, ["Fly|Ride"] = 783.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10220.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.56}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 26.16, ["Fly"] = 59.07, ["Ride"] = 35.22, ["Fly|Ride"] = 71.02, ["Neon"] = 219.95, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 220.48, ["Mega"] = 2114.7, ["Mega|Ride"] = 1159.45, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4329.94, ["Neon|Ride"] = 17602.41, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 36798.3}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.11, ["Fly"] = 55.11, ["Ride"] = 20.79, ["Fly|Ride"] = 55.86, ["Neon"] = 82.69, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 128.43, ["Mega"] = 480.05, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 601.38}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 13.02, ["Fly"] = 138.51, ["Ride"] = 30.18, ["Neon"] = 105.75, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 739.1, ["Mega|Ride"] = 823.71, ["Mega|Fly|Ride"] = 987.57}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 60.79, ["Ride"] = 75.08, ["Fly|Ride"] = 90.93, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4229.39, ["Mega|Fly|Ride"] = 1760.32}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.23, ["Fly"] = 70.86, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 56.16, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 1410.51, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.69, ["Fly"] = 2044.68, ["Ride"] = 1638, ["Fly|Ride"] = 1575, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 33831.07, ["Ride"] = 52500, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 55125, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21.38, ["Fly"] = 393.75, ["Ride"] = 45.94, ["Fly|Ride"] = 126.89, ["Neon"] = 282.3, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 564.63, ["Mega"] = 987.57, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1377.54}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.63, ["Fly"] = 63, ["Ride"] = 48.2, ["Fly|Ride"] = 147, ["Neon"] = 24.94, ["Neon|Fly"] = 113.15, ["Neon|Ride"] = 58.59, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 129.94, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.93}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 6.56, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 58.46, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 380.66, ["Mega|Ride"] = 421.45, ["Mega|Fly|Ride"] = 685.18}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.94, ["Fly"] = 800.44, ["Ride"] = 681.9, ["Fly|Ride"] = 805.62, ["Neon"] = 2749.11, ["Neon|Ride"] = 2791.41, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9444.24}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 1057.24, ["Ride"] = 938.33, ["Fly|Ride"] = 971.25, ["Neon"] = 4088.3, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11561.05}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 14.44, ["Fly"] = 120.02, ["Ride"] = 29.97, ["Fly|Ride"] = 72.19, ["Neon"] = 85.3, ["Neon|Ride"] = 104.69, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 1209.02, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 556.18}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 22.3}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 66.18, ["Fly"] = 120.02, ["Ride"] = 85.29, ["Fly|Ride"] = 126, ["Neon"] = 594.04, ["Neon|Ride"] = 492.05, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 19687.5, ["Mega|Ride"] = 2070.3, ["Mega|Fly|Ride"] = 2088.19}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.75, ["Ride"] = 102.89, ["Fly|Ride"] = 183.75, ["Neon"] = 450.19, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 1402.54, ["Mega|Fly|Ride"] = 1909.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.9, ["Fly"] = 28.37, ["Ride"] = 16.65, ["Fly|Ride"] = 42.63, ["Neon"] = 45.94, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 57.11, ["Neon|Fly|Ride"] = 160.82, ["Mega|Fly|Ride"] = 656.38}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 142.38, ["Fly"] = 168, ["Ride"] = 168, ["Fly|Ride"] = 236.15, ["Neon"] = 600.64, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 5075.27, ["Mega|Fly|Ride"] = 2493.74}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.6, ["Ride"] = 47.07, ["Fly|Ride"] = 183.98, ["Neon"] = 30.68, ["Neon|Fly"] = 169.19, ["Neon|Ride"] = 112.83, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 191.02, ["Mega|Fly"] = 337.32, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 417.38}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.46, ["Fly"] = 63.46, ["Ride"] = 32.71, ["Fly|Ride"] = 77.31, ["Neon"] = 128.63, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 662.97, ["Mega|Ride"] = 818.41, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.74, ["Ride"] = 60.29, ["Fly|Ride"] = 156.19, ["Neon"] = 208.82, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 913.57}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.98, ["Fly"] = 211.45, ["Ride"] = 35.96, ["Fly|Ride"] = 47.15, ["Neon"] = 91.88, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 141.7, ["Mega|Fly|Ride"] = 1111.28}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.75, ["Neon"] = 35245.63, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 24953.41}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 216.57, ["Fly"] = 242.16, ["Ride"] = 227.64, ["Fly|Ride"] = 283.18, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 1857.19}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 49.26, ["Fly"] = 141.68, ["Ride"] = 98.45, ["Fly|Ride"] = 211.16, ["Neon"] = 156.19, ["Neon|Fly"] = 320.43, ["Neon|Ride"] = 162.21, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 459.15, ["Mega|Fly"] = 640.78, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 576.6}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 88.82, ["Ride"] = 18.38, ["Fly|Ride"] = 52.49, ["Neon"] = 24.73, ["Neon|Fly"] = 69.8, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 358.79}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 61.64, ["Fly"] = 164.07, ["Ride"] = 95.82, ["Fly|Ride"] = 202.02, ["Neon"] = 183.75, ["Neon|Fly"] = 438.81, ["Neon|Ride"] = 258.58, ["Neon|Fly|Ride"] = 387.18, ["Mega"] = 557.52, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 678.82}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 13415.07, ["Fly|Ride"] = 12075, ["Neon|Fly|Ride"] = 27201.65, ["Mega|Fly|Ride"] = 112784.09}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 271.69, ["Ride"] = 317.2, ["Fly|Ride"] = 459.38, ["Neon"] = 1607.18, ["Neon|Ride"] = 1128.2, ["Neon|Fly|Ride"] = 1607.18, ["Mega|Fly|Ride"] = 7189.97}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 47.38, ["Fly"] = 80.59, ["Ride"] = 52.41, ["Fly|Ride"] = 95.82, ["Neon"] = 401.76, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 3066.32}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.88, ["Ride"] = 23.68, ["Fly|Ride"] = 64.82, ["Neon"] = 67.46, ["Neon|Ride"] = 63.46, ["Neon|Fly|Ride"] = 154.35, ["Mega"] = 393.75, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 368.82, ["Fly"] = 845.79, ["Ride"] = 420, ["Fly|Ride"] = 513.18, ["Neon"] = 1593.44, ["Neon|Ride"] = 1376.75, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5065.76}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.64, ["Fly"] = 104.68, ["Ride"] = 42, ["Fly|Ride"] = 177.62, ["Neon"] = 33.97, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 140.44, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 197.74, ["Mega|Fly|Ride"] = 311.93}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.76, ["Fly"] = 164.07, ["Ride"] = 134.28, ["Fly|Ride"] = 170.63, ["Neon"] = 381.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 508.77, ["Mega|Ride"] = 1776.36, ["Mega|Fly|Ride"] = 2114.7}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.06, ["Fly"] = 18.15, ["Ride"] = 18.71, ["Fly|Ride"] = 39.29, ["Neon"] = 160.82, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.72, ["Mega"] = 2537.64, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.93}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 64.32, ["Ride"] = 58.97, ["Fly|Ride"] = 211.45, ["Neon"] = 422.9, ["Neon|Fly"] = 421.89, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 430.5, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1600.72}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.42, ["Fly"] = 78.25, ["Ride"] = 31.4, ["Fly|Ride"] = 65.35, ["Neon"] = 98.44, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 183.88, ["Mega"] = 599.99, ["Mega|Ride"] = 564.63, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 32.4}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 50.99, ["Fly"] = 141.68, ["Ride"] = 101.07, ["Fly|Ride"] = 282.3, ["Neon"] = 297.64, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 282.32, ["Mega|Fly|Ride"] = 1655.82}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 29.22, ["Fly|Ride"] = 136.57, ["Neon"] = 22.32, ["Neon|Ride"] = 112.83, ["Neon|Fly|Ride"] = 185.05, ["Mega"] = 144.9, ["Mega|Ride"] = 297.6, ["Mega|Fly|Ride"] = 353.17}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.81, ["Fly"] = 56.44, ["Ride"] = 31.74, ["Fly|Ride"] = 85.22, ["Neon"] = 160.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 189.29, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 431.82, ["Fly"] = 565.63, ["Ride"] = 505.32, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 2748.43, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.05, ["Fly"] = 105.74, ["Ride"] = 57.61, ["Fly|Ride"] = 107.63, ["Neon"] = 129.94, ["Neon|Ride"] = 215.25, ["Neon|Fly|Ride"] = 329.91, ["Mega"] = 776.43, ["Mega|Ride"] = 592.13, ["Mega|Fly|Ride"] = 492.09}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 48.02, ["Fly"] = 141.68, ["Ride"] = 52.5, ["Fly|Ride"] = 121.59, ["Neon"] = 317.22, ["Neon|Ride"] = 199.5, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 938.94}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 20.83, ["Ride"] = 71.69, ["Fly|Ride"] = 103.69, ["Neon"] = 98.44, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 422.63, ["Mega|Fly"] = 525, ["Mega|Ride"] = 380.66, ["Mega|Fly|Ride"] = 590.02}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 7612.5, ["Neon|Fly|Ride"] = 15592.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1312.86, ["Fly"] = 1486.7, ["Ride"] = 1286.38, ["Fly|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 4772.25, ["Mega|Fly|Ride"] = 15509.19}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 543.43, ["Ride"] = 625.07, ["Fly|Ride"] = 704.12, ["Neon"] = 4482.21, ["Neon|Fly|Ride"] = 3526.27, ["Mega"] = 21146.95, ["Mega|Fly|Ride"] = 8177.54}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.5, ["Fly"] = 22.97, ["Ride"] = 22.75, ["Fly|Ride"] = 35.44, ["Neon"] = 63.46, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 122.67, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.46, ["Fly"] = 78.74, ["Ride"] = 32.03, ["Fly|Ride"] = 157.5, ["Neon"] = 24.86, ["Neon|Ride"] = 54.94, ["Mega"] = 160.13, ["Mega|Ride"] = 184, ["Mega|Fly|Ride"] = 264.35}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.2, ["Fly"] = 52.5, ["Ride"] = 47.25, ["Fly|Ride"] = 98.43, ["Neon"] = 200.91, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 180.51, ["Mega|Ride"] = 740.16, ["Mega|Fly|Ride"] = 663.36}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.59, ["Fly"] = 21.16, ["Ride"] = 16.35, ["Fly|Ride"] = 37.22, ["Neon"] = 45.47, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 57.11, ["Neon|Fly|Ride"] = 95, ["Mega"] = 288.75, ["Mega|Ride"] = 699.96, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 328, ["Fly"] = 369.5, ["Ride"] = 301.14, ["Fly|Ride"] = 354.36, ["Neon"] = 1600.89, ["Neon|Ride"] = 1321.7, ["Neon|Fly|Ride"] = 1268.82, ["Mega|Fly|Ride"] = 3653.85}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.75, ["Fly"] = 60.02, ["Ride"] = 28.55, ["Fly|Ride"] = 84.59, ["Neon"] = 131.25, ["Neon|Fly"] = 308.44, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 662.97, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 695}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.03, ["Fly"] = 19.69, ["Ride"] = 18.8, ["Fly|Ride"] = 40.68, ["Neon"] = 82.49, ["Neon|Fly"] = 120.56, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 604.78, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 564.58, ["Fly"] = 1048.69, ["Ride"] = 540.75, ["Fly|Ride"] = 420, ["Neon|Fly|Ride"] = 3383.52, ["Mega|Fly|Ride"] = 12265.24}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1102.4, ["Ride"] = 1148.44, ["Fly|Ride"] = 1264.51, ["Neon"] = 4934.06, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 11983.99}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 137.82, ["Fly"] = 138.51, ["Ride"] = 113.14, ["Fly|Ride"] = 120.75, ["Neon"] = 583.67, ["Neon|Ride"] = 581.56, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2536.59}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 180.27, ["Fly"] = 212.13, ["Ride"] = 157.31, ["Fly|Ride"] = 236.25, ["Neon"] = 857.42, ["Neon|Ride"] = 764.48, ["Neon|Fly|Ride"] = 648.54, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2914.07}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.87, ["Fly"] = 57.1, ["Ride"] = 32.71, ["Fly|Ride"] = 113.6, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1410.51, ["Mega|Fly|Ride"] = 1070.05}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 295.32, ["Ride"] = 315, ["Fly|Ride"] = 409.16, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1128.2, ["Mega"] = 5639.9, ["Mega|Fly|Ride"] = 5639.9}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2283.61, ["Ride"] = 1670.71, ["Fly|Ride"] = 1837.48, ["Mega|Fly|Ride"] = 29598.72}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.94, ["Fly"] = 211.45, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 266.47, ["Mega"] = 1410.51, ["Mega|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 987.57}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.75, ["Fly"] = 845.79, ["Ride"] = 576.18, ["Fly|Ride"] = 668.07, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1152.38, ["Mega|Fly|Ride"] = 3451.65}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.92, ["Fly"] = 70.88, ["Ride"] = 54.34, ["Fly|Ride"] = 74.82, ["Neon"] = 262.5, ["Neon|Ride"] = 235.23, ["Neon|Fly|Ride"] = 232.59, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.4, ["Fly"] = 46.53, ["Ride"] = 23.28, ["Fly|Ride"] = 55.02, ["Neon"] = 28.88, ["Neon|Fly"] = 105, ["Neon|Ride"] = 48.92, ["Neon|Fly|Ride"] = 102.21, ["Mega"] = 170.57, ["Mega|Ride"] = 184.99, ["Mega|Fly|Ride"] = 302.91}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 53.45, ["Ride"] = 128.34, ["Fly|Ride"] = 205.11, ["Neon"] = 262.4, ["Neon|Ride"] = 430.17, ["Neon|Fly|Ride"] = 705.26, ["Mega"] = 1545.87, ["Mega|Ride"] = 1543.74}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 774.38, ["Fly"] = 1092, ["Ride"] = 826.88, ["Fly|Ride"] = 909.03, ["Neon|Ride"] = 3102.27, ["Neon|Fly|Ride"] = 2967.39, ["Mega|Fly|Ride"] = 12318.11}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 643.13, ["Ride"] = 523.69, ["Fly|Ride"] = 845.79, ["Neon|Fly|Ride"] = 4219.88, ["Mega|Fly|Ride"] = 15365.39}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 12.78, ["Fly"] = 21, ["Ride"] = 22.99, ["Fly|Ride"] = 45.47, ["Neon"] = 144.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 113.15, ["Mega"] = 800.37, ["Mega|Ride"] = 480.05, ["Mega|Fly|Ride"] = 701.04}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 10.82, ["Ride"] = 26.25, ["Fly|Ride"] = 90.93, ["Neon"] = 205.23, ["Neon|Ride"] = 156.5, ["Neon|Fly|Ride"] = 210, ["Mega"] = 846.57, ["Mega|Ride"] = 662.97, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.8, ["Fly"] = 64.72, ["Ride"] = 26.17, ["Fly|Ride"] = 111.57, ["Neon"] = 21.94, ["Neon|Fly"] = 321.5, ["Neon|Ride"] = 64.82, ["Neon|Fly|Ride"] = 211.46, ["Mega"] = 176.58, ["Mega|Fly"] = 544.79, ["Mega|Ride"] = 202.5, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 36.26, ["Fly"] = 51.19, ["Ride"] = 47.34, ["Fly|Ride"] = 106.32, ["Neon"] = 293.02, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 233.06, ["Mega|Fly|Ride"] = 959.06}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 77.44, ["Ride"] = 129.94, ["Fly|Ride"] = 353.13, ["Neon"] = 428.35, ["Neon|Ride"] = 564.63, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2256.39, ["Mega|Ride"] = 2159.89, ["Mega|Fly|Ride"] = 2099.91}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.63, ["Fly"] = 45.94, ["Ride"] = 37.22, ["Fly|Ride"] = 90.93, ["Neon"] = 105.75, ["Neon|Fly"] = 113.15, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 147, ["Mega"] = 425.39, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 447.4}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.62, ["Fly"] = 65.63, ["Ride"] = 45.94, ["Fly|Ride"] = 84.11, ["Neon"] = 308.76, ["Neon|Fly"] = 1410.51, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.59}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.67, ["Fly"] = 27.18, ["Ride"] = 17.41, ["Fly|Ride"] = 44.6, ["Neon"] = 23.54, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 740.16, ["Mega|Ride"] = 479.99, ["Mega|Fly|Ride"] = 527.63}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.63, ["Fly"] = 49.87, ["Ride"] = 19.69, ["Fly|Ride"] = 63.58, ["Neon"] = 37.41, ["Neon|Fly"] = 109.98, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 124.78, ["Mega"] = 416.07, ["Mega|Ride"] = 353.17, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 57.1, ["Fly"] = 56.21, ["Ride"] = 53.82, ["Fly|Ride"] = 96.73, ["Neon"] = 525, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 229.59, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1403.07, ["Fly"] = 1410.93, ["Ride"] = 1443.75, ["Fly|Ride"] = 1478.7, ["Neon|Fly|Ride"] = 3778.69, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 467.25, ["Fly"] = 640.83, ["Ride"] = 393.75, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 2819.96, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14802.87, ["Mega|Fly|Ride"] = 9304.66}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 280.88, ["Fly"] = 378.23, ["Ride"] = 320.42, ["Fly|Ride"] = 458.84, ["Neon"] = 1311.19, ["Neon|Ride"] = 1522.5, ["Neon|Fly|Ride"] = 1374.57}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 40.03}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 24.6, ["Ride"] = 32.71, ["Fly|Ride"] = 97.12, ["Neon"] = 325.5, ["Neon|Ride"] = 206.2, ["Neon|Fly|Ride"] = 354.38, ["Mega|Ride"] = 1551.14, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 73301.34, ["Fly"] = 23258.86, ["Ride"] = 24000.59, ["Fly|Ride"] = 16915.54, ["Neon|Fly|Ride"] = 37800, ["Mega"] = 211469.48, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 262.5, ["Ride"] = 223.13, ["Fly|Ride"] = 332.45, ["Neon"] = 1080.07, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 874.44, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 3700.73, ["Mega|Ride"] = 4228.34, ["Mega|Fly|Ride"] = 3424.43}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 212.42, ["Fly|Ride"] = 257.23, ["Neon|Fly|Ride"] = 1760.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.63, ["Fly"] = 144.38, ["Ride"] = 150.94, ["Fly|Ride"] = 259.88, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Ride"] = 2254.28, ["Mega|Fly|Ride"] = 2918.29}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 11.57, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 75.08, ["Neon"] = 141.7, ["Neon|Ride"] = 99.41, ["Neon|Fly|Ride"] = 705.26, ["Mega"] = 717.57, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 924.13}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3871.88, ["Ride"] = 3885, ["Fly|Ride"] = 4003.13, ["Neon"] = 27487.74, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.14, ["Fly"] = 45.94, ["Ride"] = 28.25, ["Fly|Ride"] = 50.09, ["Neon"] = 337.81, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 194.54, ["Mega"] = 1128.2, ["Mega|Ride"] = 1410.51, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 42, ["Ride"] = 41.91, ["Fly|Ride"] = 102.79, ["Neon"] = 314.26, ["Neon|Fly"] = 1410.51, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.19}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 420, ["Fly"] = 551.25, ["Ride"] = 473.71, ["Fly|Ride"] = 580.13, ["Neon"] = 1256.07, ["Neon|Ride"] = 1180.88, ["Neon|Fly|Ride"] = 1298.06, ["Mega|Ride"] = 6767.03, ["Mega|Fly|Ride"] = 8320.34}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.25, ["Fly"] = 22.84, ["Ride"] = 23.86, ["Fly|Ride"] = 45.97, ["Neon"] = 123.37, ["Neon|Fly"] = 159.68, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 776.1, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.91, ["Ride"] = 26.24, ["Fly|Ride"] = 80.15, ["Neon"] = 95.82, ["Neon|Ride"] = 92.64, ["Neon|Fly|Ride"] = 209.08, ["Mega|Ride"] = 743.97, ["Mega|Fly|Ride"] = 719.97}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 108.94, ["Ride"] = 105, ["Fly|Ride"] = 207.23, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.44, ["Fly"] = 126.89, ["Ride"] = 52.5, ["Fly|Ride"] = 164.94, ["Neon"] = 43.64, ["Neon|Fly"] = 120.56, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 236.24, ["Mega"] = 324.62, ["Mega|Fly"] = 733.82, ["Mega|Ride"] = 294.67, ["Mega|Fly|Ride"] = 425.92}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3911.15, ["Fly"] = 6240.17, ["Ride"] = 3883.68, ["Fly|Ride"] = 4068.75, ["Neon"] = 14802.87, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42292.85, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.8, ["Fly"] = 42, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 395.47, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 396.03, ["Mega"] = 845.88, ["Mega|Ride"] = 1760.32, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7875, ["Fly"] = 7612, ["Ride"] = 6857.82, ["Fly|Ride"] = 5642.44, ["Neon|Fly|Ride"] = 15225, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.29, ["Fly"] = 17.88, ["Ride"] = 15.65, ["Fly|Ride"] = 34.82, ["Neon"] = 24.94, ["Neon|Fly"] = 57.11, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 241.08, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.23, ["Fly"] = 26.25, ["Ride"] = 26.25, ["Fly|Ride"] = 55.21, ["Neon"] = 141.7, ["Neon|Fly"] = 233.68, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 164.66, ["Mega|Ride"] = 987.57, ["Mega|Fly|Ride"] = 924.13}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.92}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.66, ["Ride"] = 31.5, ["Fly|Ride"] = 57.66, ["Neon"] = 98.44, ["Neon|Ride"] = 91.76, ["Mega"] = 1049.9, ["Mega|Ride"] = 888.19, ["Mega|Fly|Ride"] = 794.09}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 27.5, ["Fly"] = 190.37, ["Ride"] = 46.53, ["Fly|Ride"] = 99.74, ["Neon"] = 156.5, ["Neon|Ride"] = 170.42, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 945, ["Mega|Ride"] = 845.88, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.5, ["Fly"] = 26.25, ["Ride"] = 21.38, ["Fly|Ride"] = 37.02, ["Neon|Fly"] = 1054.19, ["Neon|Ride"] = 117.37, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2537.64, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8599.45}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.04, ["Ride"] = 388.01, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.99, ["Fly"] = 134.28, ["Ride"] = 32.42, ["Fly|Ride"] = 126.89, ["Neon"] = 120.56, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.45}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 8.82, ["Ride"] = 25.99, ["Fly|Ride"] = 84.59, ["Neon|Ride"] = 249.38, ["Mega"] = 1551.14}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2585.63}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 128.63, ["Fly"] = 336.21, ["Ride"] = 169.21, ["Fly|Ride"] = 422.9, ["Neon"] = 918.75, ["Neon|Ride"] = 844.83, ["Neon|Fly|Ride"] = 1551.14, ["Mega|Ride"] = 4088.78, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 68.25, ["Fly"] = 211.45, ["Ride"] = 91.88, ["Fly|Ride"] = 211.45, ["Neon|Ride"] = 494.82, ["Neon|Fly|Ride"] = 931.53, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 128.62, ["Fly"] = 315, ["Ride"] = 157.49, ["Fly|Ride"] = 223.13, ["Neon"] = 944.98, ["Neon|Ride"] = 787.49, ["Neon|Fly|Ride"] = 849.79, ["Mega|Ride"] = 3242.9, ["Mega|Fly|Ride"] = 3004.79}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3242.51, ["Ride"] = 2231.25, ["Fly|Ride"] = 2231.25, ["Neon"] = 14851.51, ["Neon|Ride"] = 8400.39, ["Neon|Fly|Ride"] = 5906.25, ["Mega|Fly|Ride"] = 25593.75}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.54, ["Fly"] = 70.86, ["Ride"] = 34.96, ["Fly|Ride"] = 100.08, ["Neon"] = 127.32, ["Neon|Fly"] = 160.82, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 950.57, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 818.31, ["Fly"] = 2100, ["Ride"] = 874.34, ["Fly|Ride"] = 774.38, ["Neon|Fly|Ride"] = 4160.18}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.7, ["Ride"] = 51.62, ["Fly|Ride"] = 338.44, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 105.75, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 451.78, ["Mega|Fly"] = 959.96, ["Mega|Ride"] = 493.79, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.59, ["Fly"] = 74.02, ["Ride"] = 27.57, ["Fly|Ride"] = 104.68, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.34, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 448.79, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 59.07}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.78, ["Fly"] = 105.68, ["Ride"] = 21.19, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 192.03, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 987.57, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 25.07, ["Fly"] = 39.38, ["Ride"] = 33.54, ["Fly|Ride"] = 52.41, ["Neon|Fly"] = 233.68, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 1439.93, ["Mega|Ride"] = 1799.9, ["Mega|Fly|Ride"] = 987.57}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.5, ["Fly"] = 10237.5, ["Ride"] = 6240.17, ["Fly|Ride"] = 5050.5, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.54, ["Fly"] = 65.62, ["Ride"] = 34.13, ["Fly|Ride"] = 81.37, ["Neon"] = 51.98, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 62.27, ["Neon|Fly|Ride"] = 168.13, ["Mega"] = 507.54, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 493.79}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.65}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 102.38, ["Fly"] = 374.28, ["Ride"] = 111.46, ["Fly|Ride"] = 160.09, ["Neon"] = 531.57, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 643.13, ["Mega|Ride"] = 2256.39, ["Mega|Fly|Ride"] = 2073.47}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 45.93, ["Fly"] = 141.68, ["Ride"] = 74.82, ["Fly|Ride"] = 190.31, ["Neon"] = 284.82, ["Neon|Ride"] = 273.87, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2399.88, ["Mega|Ride"] = 2854.85, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.82, ["Fly"] = 48.99, ["Ride"] = 22.32, ["Fly|Ride"] = 64.31, ["Neon"] = 128.77, ["Neon|Fly"] = 228.41, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 201.41, ["Mega|Ride"] = 863.97, ["Mega|Fly|Ride"] = 783.56}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.55, ["Fly"] = 68.95, ["Ride"] = 21.82, ["Fly|Ride"] = 63.46, ["Neon"] = 31.5, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 48.02, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 136.43, ["Mega|Fly"] = 7049.35, ["Mega|Ride"] = 210.39, ["Mega|Fly|Ride"] = 287.15}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 10.5, ["Fly"] = 42.31, ["Ride"] = 26.25, ["Fly|Ride"] = 97.95, ["Neon"] = 91.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 141.7, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.52, ["Fly"] = 32.7, ["Ride"] = 24.05, ["Fly|Ride"] = 54.41, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 141.7, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 161.47}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 35.44, ["Ride"] = 131.23, ["Fly|Ride"] = 282.3, ["Neon"] = 169.17, ["Neon|Ride"] = 219.95, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 691.52, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 262.21, ["Ride"] = 695.63, ["Fly|Ride"] = 634.34, ["Neon|Ride"] = 16917.56, ["Neon|Fly|Ride"] = 28196.3}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 45.84, ["Fly"] = 212.84, ["Ride"] = 86.52, ["Fly|Ride"] = 162.75, ["Neon"] = 252, ["Neon|Ride"] = 321.54, ["Neon|Fly|Ride"] = 458.91, ["Mega"] = 850.5, ["Mega|Ride"] = 1040.36, ["Mega|Fly|Ride"] = 1184.24}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 984.27, ["Fly"] = 1368.06, ["Ride"] = 984.38, ["Fly|Ride"] = 984.38, ["Neon|Ride"] = 4242.21, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 354.38, ["Fly"] = 705.17, ["Ride"] = 385.88, ["Fly|Ride"] = 422.9, ["Neon"] = 1968.75, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 11999.32, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 76.15}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 8.4, ["Fly"] = 23, ["Ride"] = 27.5, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 557.24, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 544.55}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 242.82, ["Fly"] = 406.65, ["Ride"] = 280.74, ["Fly|Ride"] = 326.7, ["Neon"] = 1168.86, ["Neon|Ride"] = 905.1, ["Neon|Fly|Ride"] = 946.34, ["Mega|Ride"] = 3102.27, ["Mega|Fly|Ride"] = 2808.75}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 103.69, ["Fly"] = 286.82, ["Ride"] = 171.05, ["Fly|Ride"] = 278.58, ["Neon"] = 606.86, ["Neon|Ride"] = 577.5, ["Neon|Fly|Ride"] = 590.63, ["Mega"] = 2231.43, ["Mega|Ride"] = 2150.67, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.22, ["Fly"] = 211.45, ["Ride"] = 129.45, ["Fly|Ride"] = 156.49, ["Neon"] = 1128.2, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2537.64}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.89, ["Ride"] = 25.62, ["Fly|Ride"] = 52.5, ["Neon"] = 38.58, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 238.97, ["Mega"] = 253.78, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 479.99}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.65, ["Fly"] = 71.54, ["Ride"] = 25.76, ["Fly|Ride"] = 78.64, ["Neon"] = 141.7, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 316.28, ["Mega|Ride"] = 1410.51, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 10.49, ["Fly"] = 102.36, ["Ride"] = 31.5, ["Fly|Ride"] = 104.81, ["Neon"] = 78.75, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 258, ["Mega"] = 421.89, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 564.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.15, ["Fly"] = 98.44, ["Ride"] = 45.94, ["Fly|Ride"] = 137.71, ["Neon"] = 26.16, ["Neon|Ride"] = 70.59, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 150.94, ["Mega|Fly"] = 272.4, ["Mega|Ride"] = 174.77, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 240, ["Ride"] = 261.19, ["Fly|Ride"] = 403.01, ["Neon"] = 1586.04, ["Neon|Ride"] = 1365.68, ["Neon|Fly|Ride"] = 1381.75, ["Mega|Fly|Ride"] = 5610.29}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 84.59, ["Fly"] = 148.02, ["Ride"] = 141.68, ["Fly|Ride"] = 238.95, ["Neon"] = 459.38, ["Neon|Ride"] = 549.84, ["Neon|Fly|Ride"] = 630, ["Mega"] = 2255.89, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 60.38, ["Fly"] = 94.5, ["Ride"] = 70.26, ["Fly|Ride"] = 126, ["Neon"] = 380.63, ["Neon|Ride"] = 254.81, ["Neon|Fly|Ride"] = 407.77, ["Mega|Ride"] = 1635.74, ["Mega|Fly|Ride"] = 1800.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.96, ["Fly"] = 78.75, ["Ride"] = 28.55, ["Fly|Ride"] = 282.3, ["Neon"] = 115.5, ["Neon|Ride"] = 609.65, ["Neon|Fly|Ride"] = 493.79}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.45, ["Fly"] = 35.96, ["Ride"] = 28.87, ["Fly|Ride"] = 79.31, ["Neon"] = 77.43, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 376.44, ["Mega|Fly"] = 525, ["Mega|Ride"] = 366.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.42, ["Fly"] = 52.48, ["Ride"] = 19.69, ["Fly|Ride"] = 57.1, ["Neon"] = 21, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 141.7, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 870.18, ["Fly"] = 1082.73, ["Ride"] = 843.93, ["Fly|Ride"] = 909.57, ["Neon"] = 4228.89, ["Neon|Fly"] = 3258.15, ["Neon|Ride"] = 8458.78, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 7742.44}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 311.9, ["Fly"] = 705.17, ["Ride"] = 302.74, ["Fly|Ride"] = 322.88, ["Neon|Ride"] = 1488.09, ["Neon|Fly|Ride"] = 1247.67, ["Mega"] = 10573.48, ["Mega|Fly|Ride"] = 6344.09}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 84.3, ["Fly"] = 133.22, ["Ride"] = 116.82, ["Fly|Ride"] = 165.73, ["Neon"] = 344.67, ["Neon|Fly"] = 480.04, ["Neon|Ride"] = 326.32, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1579.7, ["Mega|Fly|Ride"] = 1627.27}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 205.11, ["Fly|Ride"] = 244.23, ["Neon|Ride"] = 1280.48, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10573.48, ["Mega|Fly|Ride"] = 4934.65}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 23.62, ["Fly"] = 32.82, ["Ride"] = 28.87, ["Fly|Ride"] = 74.61, ["Neon"] = 169.32, ["Neon|Ride"] = 184, ["Neon|Fly|Ride"] = 204.75, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 800.37}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 190.29, ["Ride"] = 222.01, ["Fly|Ride"] = 358.32, ["Neon"] = 786.19, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4179, ["Mega|Fly|Ride"] = 3750.44}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 84.59, ["Fly"] = 125.98, ["Ride"] = 79.42, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 480.04, ["Mega|Fly|Ride"] = 1537.39}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1955.63, ["Ride"] = 2034.38, ["Fly|Ride"] = 1968.75, ["Neon|Ride"] = 11201.32, ["Neon|Fly|Ride"] = 7598.12, ["Mega"] = 50752.68, ["Mega|Fly|Ride"] = 23998.64}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.13, ["Fly"] = 77.44, ["Ride"] = 42.31, ["Fly|Ride"] = 100.09, ["Neon"] = 110.25, ["Neon|Fly"] = 233.68, ["Neon|Ride"] = 113.15, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 312.38, ["Mega|Fly"] = 564.63, ["Mega|Ride"] = 307.18, ["Mega|Fly|Ride"] = 440.09}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 58.97, ["Fly"] = 93.05, ["Ride"] = 84, ["Fly|Ride"] = 142.7, ["Neon"] = 196.88, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 564.63, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 79.66, ["Fly"] = 91.87, ["Ride"] = 81.38, ["Fly|Ride"] = 91.88, ["Neon"] = 525, ["Neon|Ride"] = 256.83, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3360.1, ["Fly"] = 1600.86, ["Ride"] = 1069.68, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 5120.64, ["Neon|Fly|Ride"] = 4725, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 523.69, ["Fly"] = 525, ["Ride"] = 845.79, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3200.24, ["Mega|Fly|Ride"] = 11278.74}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.74, ["Fly"] = 170.63, ["Ride"] = 77.97, ["Fly|Ride"] = 208.69, ["Neon"] = 442.98, ["Neon|Ride"] = 342.54, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 5639.9, ["Mega|Ride"] = 1480.29, ["Mega|Fly|Ride"] = 1534.77}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.75, ["Ride"] = 21.57, ["Fly|Ride"] = 60.38, ["Neon"] = 74.33, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 94.31, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 656.25, ["Mega|Ride"] = 765.54}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 25.6, ["Fly"] = 68.25, ["Ride"] = 42, ["Fly|Ride"] = 78.75, ["Neon"] = 281.24, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 2256.39, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 735, ["Fly"] = 1104.04, ["Ride"] = 735, ["Fly|Ride"] = 829.5, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.41}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 6600.18, ["Fly|Ride"] = 5248.69, ["Neon"] = 42000, ["Neon|Ride"] = 30304.65, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 105594.13}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 249.38, ["Fly"] = 396.46, ["Ride"] = 328.13, ["Fly|Ride"] = 417.63, ["Neon"] = 1312.5, ["Neon|Ride"] = 1833.45, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6343.04, ["Mega|Fly|Ride"] = 6344.09}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 282.3, ["Ride"] = 131.14, ["Fly|Ride"] = 336, ["Neon"] = 421.89, ["Neon|Ride"] = 789.86, ["Neon|Fly|Ride"] = 630.19, ["Mega|Fly|Ride"] = 2144.31}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.39, ["Fly"] = 65.62, ["Ride"] = 30.19, ["Fly|Ride"] = 64.78, ["Neon"] = 156.92, ["Neon|Fly"] = 1280.48, ["Neon|Ride"] = 117.62, ["Neon|Fly|Ride"] = 214.68, ["Mega|Ride"] = 564.63, ["Mega|Fly|Ride"] = 753.38}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.7, ["Fly"] = 26.23, ["Ride"] = 21, ["Fly|Ride"] = 48.65, ["Neon"] = 126.9, ["Neon|Ride"] = 67.22, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2114.7}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.7, ["Fly"] = 282.3, ["Ride"] = 27.57, ["Fly|Ride"] = 85.32, ["Neon"] = 118.13, ["Neon|Ride"] = 126.67, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.04, ["Fly"] = 62.39, ["Ride"] = 19.69, ["Fly|Ride"] = 48.57, ["Neon"] = 31.38, ["Neon|Ride"] = 56.42, ["Neon|Fly|Ride"] = 126, ["Mega"] = 661.56, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 274.93}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 28.51, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 845.88, ["Neon|Ride"] = 228.41, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 628.69, ["Mega|Ride"] = 776.1}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 482.99, ["Fly"] = 538.12, ["Ride"] = 472.5, ["Fly|Ride"] = 551.5, ["Neon"] = 1797.51, ["Neon|Ride"] = 1551.14, ["Neon|Fly|Ride"] = 1376.82, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5216.96}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.19, ["Fly"] = 19.58, ["Ride"] = 15.58, ["Fly|Ride"] = 35.96, ["Neon"] = 24.18, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 170.63, ["Mega|Ride"] = 224.17, ["Mega|Fly|Ride"] = 211.47}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.68, ["Fly"] = 98.44, ["Ride"] = 83.41, ["Fly|Ride"] = 145.21, ["Neon"] = 196.87, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 221.16, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 524.48, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 597.08}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 800.63, ["Ride"] = 774.27, ["Fly|Ride"] = 803.25, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 29.96, ["Fly"] = 90.56, ["Ride"] = 44.63, ["Fly|Ride"] = 65.24, ["Neon"] = 253.78, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1199.96, ["Mega|Ride"] = 951.63, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 334.1, ["Fly"] = 480.02, ["Ride"] = 259.88, ["Fly|Ride"] = 337.22, ["Neon"] = 1551.14, ["Neon|Ride"] = 1833.45, ["Neon|Fly|Ride"] = 1504.61, ["Mega|Fly|Ride"] = 6400.45}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 196.86, ["Fly"] = 178.5, ["Ride"] = 177.19, ["Fly|Ride"] = 236.14, ["Neon"] = 987.57, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 4016.87}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 843.19, ["Ride"] = 783.57, ["Fly|Ride"] = 912.39, ["Neon|Ride"] = 3949.21, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.69, ["Fly"] = 84.59, ["Ride"] = 44.52, ["Fly|Ride"] = 110.25, ["Neon"] = 78.74, ["Neon|Fly"] = 288.03, ["Neon|Ride"] = 99.41, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 304.8, ["Mega|Ride"] = 409.21, ["Mega|Fly|Ride"] = 527.63}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3438.49, ["Ride"] = 3281.25, ["Fly|Ride"] = 3279.94, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 23998.64}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 102.88, ["Fly"] = 154.37, ["Ride"] = 131.91, ["Fly|Ride"] = 186.04, ["Neon"] = 459.38, ["Neon|Fly"] = 711.38, ["Neon|Ride"] = 523.4, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2679.33, ["Mega|Fly|Ride"] = 2818.91}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.63, ["Fly"] = 28.55, ["Ride"] = 15.54, ["Fly|Ride"] = 38.97, ["Neon"] = 20.22, ["Neon|Fly"] = 59.79, ["Neon|Ride"] = 36.26, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 160.1, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 245.75, ["Mega|Fly|Ride"] = 226.28}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.66, ["Ride"] = 24.51, ["Fly|Ride"] = 57.71, ["Neon"] = 22.32, ["Neon|Fly"] = 117.62, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 105, ["Mega"] = 161.44, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 28.45, ["Fly"] = 38.45, ["Ride"] = 30.86, ["Fly|Ride"] = 56.11, ["Neon"] = 288.03, ["Neon|Ride"] = 184, ["Neon|Fly|Ride"] = 253.8, ["Mega|Fly|Ride"] = 1084.85}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 840, ["Fly"] = 1242.04, ["Ride"] = 985.35, ["Fly|Ride"] = 1056.68, ["Neon"] = 4511.18, ["Neon|Fly|Ride"] = 4229.39}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.9, ["Fly"] = 45.47, ["Ride"] = 23.63, ["Fly|Ride"] = 44.63, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 135.09, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.97, ["Fly"] = 56.94, ["Ride"] = 26.25, ["Fly|Ride"] = 77.44, ["Neon"] = 85.68, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 170.59, ["Mega"] = 319.2, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 549.84}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 90.75, ["Fly"] = 157.5, ["Ride"] = 87.94, ["Fly|Ride"] = 141.75, ["Neon|Ride"] = 446.24, ["Neon|Fly|Ride"] = 418.71, ["Mega|Fly|Ride"] = 1833.45}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 216.47, ["Fly"] = 241.5, ["Ride"] = 221.79, ["Fly|Ride"] = 261.19, ["Neon"] = 918.75, ["Neon|Ride"] = 1065.82, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 8458.78, ["Mega|Fly|Ride"] = 3522.04}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 4.71, ["Ride"] = 32.71, ["Fly|Ride"] = 57.1, ["Neon"] = 21.67, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 52.88, ["Mega"] = 145.92, ["Mega|Fly"] = 235.8, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 181.04, ["Fly"] = 231.7, ["Ride"] = 209.28, ["Fly|Ride"] = 282.3, ["Neon"] = 776.1, ["Neon|Ride"] = 712.3, ["Neon|Fly|Ride"] = 774.38, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.07, ["Fly"] = 21.16, ["Ride"] = 15.65, ["Fly|Ride"] = 57.1, ["Neon"] = 29.96, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 37.4, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 196.69, ["Mega|Fly|Ride"] = 275.78}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 188.41, ["Fly"] = 341.51, ["Ride"] = 236.25, ["Fly|Ride"] = 236.25, ["Neon"] = 1268.82, ["Neon|Ride"] = 1200.07, ["Neon|Fly|Ride"] = 815.05, ["Mega"] = 10573.48, ["Mega|Fly|Ride"] = 5440.51}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.45, ["Fly"] = 77.44, ["Ride"] = 24.02, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 304.83, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 564.63, ["Mega|Ride"] = 493.79, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.93, ["Ride"] = 19.59, ["Fly|Ride"] = 72.19, ["Neon"] = 10.71, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 139.58, ["Mega"] = 82.04, ["Mega|Ride"] = 96.01, ["Mega|Fly|Ride"] = 213.94}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Mega"] = 17.81, ["Mega|Ride"] = 151.22, ["Mega|Fly|Ride"] = 167.08}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.12, ["Fly"] = 52.49, ["Ride"] = 35.33, ["Fly|Ride"] = 113.14, ["Neon"] = 6.34, ["Neon|Ride"] = 27.8, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 71.32, ["Mega|Fly"] = 159991.68, ["Mega|Ride"] = 76, ["Mega|Fly|Ride"] = 211.47}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 61.07, ["Fly"] = 105, ["Ride"] = 111.57, ["Fly|Ride"] = 207.38, ["Neon"] = 313.88, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 368.82, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 34.82, ["Ride"] = 15.75, ["Fly|Ride"] = 78.75, ["Neon"] = 4.81, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 91.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 9.17, ["Ride"] = 113.14, ["Neon"] = 64.32, ["Neon|Fly"] = 240.02, ["Neon|Ride"] = 247.22, ["Mega"] = 361.64, ["Mega|Ride"] = 422.94}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 57.1, ["Neon"] = 2.52, ["Neon|Ride"] = 54.51, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 14.44, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 157.16}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 15.88, ["Fly|Ride"] = 24.43, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 14.2, ["Neon|Fly|Ride"] = 28.79, ["Mega"] = 15.85, ["Mega|Fly"] = 26.61, ["Mega|Ride"] = 20.61, ["Mega|Fly|Ride"] = 57.3}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.82, ["Fly|Ride"] = 66.62, ["Neon"] = 2.1, ["Neon|Fly"] = 20.99, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 141.7, ["Mega|Fly"] = 160.81, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 64.32}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 70.86, ["Neon"] = 2.52, ["Neon|Ride"] = 65.62, ["Mega"] = 19.69, ["Mega|Ride"] = 131.13, ["Mega|Fly|Ride"] = 353.17}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.21, ["Fly|Ride"] = 107.62, ["Neon"] = 2.45, ["Neon|Fly"] = 120.56, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.83, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 98.44}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 414.64, ["Mega"] = 17.73, ["Mega|Fly"] = 137.47, ["Mega|Ride"] = 113.15}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.15, ["Fly"] = 36.75, ["Ride"] = 32.82, ["Fly|Ride"] = 156.45, ["Neon"] = 11.82, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 141.68, ["Mega|Fly"] = 281.95, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 320.43, ["Mega"] = 12.7, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.98, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.15, ["Ride"] = 142.73, ["Fly|Ride"] = 141.68, ["Neon"] = 18.13, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.55, ["Neon"] = 19.05, ["Neon|Ride"] = 70.86, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 564.63}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.2, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 20.1, ["Mega|Ride"] = 44.62, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.25, ["Ride"] = 14.17, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 15.88, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 36.94, ["Mega"] = 13.05, ["Mega|Fly"] = 32.76, ["Mega|Ride"] = 18.75, ["Mega|Fly|Ride"] = 49.63}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 4.65, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 53.82, ["Neon|Ride"] = 140.95, ["Mega"] = 190.34, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 30.87, ["Fly|Ride"] = 80.41, ["Neon"] = 6.35, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Mega"] = 82.69, ["Mega|Ride"] = 161.44, ["Mega|Fly|Ride"] = 254.61}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.16, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 19.22, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 192}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 11.82, ["Fly|Ride"] = 28.55, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 12.88, ["Neon|Fly|Ride"] = 28.87, ["Mega"] = 12.7, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 19.43, ["Mega|Fly|Ride"] = 48.08}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 21.38, ["Ride"] = 27.4, ["Fly|Ride"] = 141.68, ["Neon"] = 10.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.64, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.12, ["Fly"] = 113.14, ["Ride"] = 40.2, ["Fly|Ride"] = 59.07, ["Neon"] = 47.49, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 262.5, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 13.71, ["Fly|Ride"] = 28.76, ["Neon"] = 3.83, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 15.57, ["Neon|Fly|Ride"] = 32.76, ["Mega"] = 19.83, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.84, ["Fly"] = 176.57, ["Ride"] = 31.5, ["Neon"] = 6.46, ["Neon|Ride"] = 35.12, ["Neon|Fly|Ride"] = 168.13, ["Mega"] = 63, ["Mega|Fly"] = 169.19, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 65.63, ["Neon"] = 3.5, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 283.64, ["Mega"] = 25.73, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 14.95, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 39.4, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 14.34, ["Fly|Ride"] = 46.55, ["Neon"] = 5.25, ["Neon|Fly"] = 53.93, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 59.17, ["Mega"] = 80.41, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 57.1, ["Neon"] = 4.95, ["Neon|Ride"] = 26.25, ["Mega"] = 34.13, ["Mega|Fly"] = 240, ["Mega|Ride"] = 98.44, ["Mega|Fly|Ride"] = 221.81}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.12, ["Fly|Ride"] = 72.19, ["Neon"] = 5.25, ["Neon|Fly"] = 80.41, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.31, ["Mega"] = 111.57, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 38.58, ["Neon"] = 31.11, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 168.03, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.59, ["Fly|Ride"] = 32.03, ["Neon"] = 9.18, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 32.22, ["Neon|Fly|Ride"] = 85.19, ["Mega"] = 262.24, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 17.07, ["Fly|Ride"] = 70.86, ["Neon"] = 13.12, ["Neon|Fly"] = 65.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 169.19, ["Mega|Fly"] = 156.5, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.08, ["Neon"] = 12.02, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 188.81, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.91, ["Ride"] = 56.44, ["Neon"] = 202, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 564.63, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.16, ["Ride"] = 54.98, ["Neon"] = 45.84, ["Neon|Ride"] = 106.55, ["Mega"] = 126.9, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 319.2}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 7.49, ["Ride"] = 21.38, ["Fly|Ride"] = 120.75, ["Neon"] = 31.38, ["Neon|Ride"] = 57.11, ["Mega"] = 311.07, ["Mega|Ride"] = 349.19, ["Mega|Fly|Ride"] = 385.23}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.57, ["Neon|Ride"] = 65.01, ["Mega"] = 15.64, ["Mega|Fly"] = 121.61, ["Mega|Ride"] = 126.9, ["Mega|Fly|Ride"] = 189.31}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.16}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.29, ["Fly"] = 23.62, ["Ride"] = 22.2, ["Fly|Ride"] = 41.71, ["Neon"] = 43.32, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 57.11, ["Neon|Fly|Ride"] = 78.66, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 15.75, ["Fly|Ride"] = 64.32, ["Neon"] = 5.25, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 32.8, ["Mega"] = 16.42, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 98.42}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Neon"] = 3.84, ["Neon|Ride"] = 36, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 34.13, ["Mega|Ride"] = 63.42, ["Mega|Fly|Ride"] = 99.41}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 15.44, ["Fly|Ride"] = 45.73, ["Neon"] = 6.3, ["Neon|Ride"] = 19.05, ["Neon|Fly|Ride"] = 69.8, ["Mega"] = 141.75, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 232.29}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.61, ["Fly"] = 28.55, ["Ride"] = 84.96, ["Fly|Ride"] = 57.75, ["Neon"] = 41.84, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 169.19, ["Mega|Ride"] = 353.17, ["Mega|Fly|Ride"] = 316.16}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 2.1, ["Mega"] = 17.39, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 120.56}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.68, ["Fly|Ride"] = 34.28, ["Neon"] = 3.66, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 96.02, ["Mega"] = 25.77, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 37.97, ["Mega|Fly|Ride"] = 122.13}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.63, ["Fly|Ride"] = 31.5, ["Neon"] = 5.15, ["Neon|Fly"] = 57.11, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 33.86, ["Mega"] = 47.95, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 26.25, ["Fly|Ride"] = 141.68, ["Neon"] = 3.6, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 55.49, ["Mega|Ride"] = 83.35, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 154565.84, ["Mega"] = 18.38, ["Mega|Fly"] = 106.45, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 16.99, ["Fly|Ride"] = 43.32, ["Neon"] = 2.3, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 18.17, ["Mega|Fly"] = 63.46, ["Mega|Ride"] = 36.3, ["Mega|Fly|Ride"] = 90.7}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 42.41, ["Neon"] = 2.63, ["Neon|Ride"] = 40.2, ["Mega"] = 19.69, ["Mega|Ride"] = 133.88}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 320.43, ["Neon|Fly|Ride"] = 420, ["Mega"] = 28.87, ["Mega|Ride"] = 191.18, ["Mega|Fly|Ride"] = 262.24}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.44, ["Fly|Ride"] = 52.49, ["Neon"] = 4.17, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 15.59, ["Neon|Fly|Ride"] = 42, ["Mega"] = 34.13, ["Mega|Fly"] = 45.48, ["Mega|Ride"] = 105.75, ["Mega|Fly|Ride"] = 107.55}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.41, ["Ride"] = 59.06, ["Fly|Ride"] = 211.45, ["Neon"] = 126, ["Neon|Ride"] = 174.57, ["Mega"] = 406.88, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 640.78}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 38.42, ["Neon"] = 32.16, ["Neon|Ride"] = 157.5, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 31.74, ["Fly|Ride"] = 179.74, ["Neon"] = 17.99, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 262.24, ["Mega|Ride"] = 452.55, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 16.11, ["Ride"] = 11.69, ["Fly|Ride"] = 27.5, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 12.7, ["Neon|Fly|Ride"] = 24.65, ["Mega"] = 13.65, ["Mega|Fly"] = 19.14, ["Mega|Ride"] = 18.38, ["Mega|Fly|Ride"] = 41.6}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.94, ["Fly"] = 118.12, ["Ride"] = 59.22, ["Neon"] = 6.35, ["Neon|Fly"] = 67.69, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 705.26, ["Mega"] = 77.41, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 31.49, ["Neon"] = 2.1, ["Neon|Fly"] = 31.75, ["Neon|Ride"] = 23.54, ["Neon|Fly|Ride"] = 84.6, ["Mega"] = 12.34, ["Mega|Fly"] = 63.46, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 126.9}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 11.82, ["Mega|Ride"] = 57.11, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.31, ["Ride"] = 16.66, ["Fly|Ride"] = 43.22, ["Neon"] = 9.89, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 37.99, ["Neon|Fly|Ride"] = 75.8, ["Mega"] = 169.32, ["Mega|Ride"] = 401.81, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 155.3, ["Ride"] = 224, ["Fly|Ride"] = 378.5, ["Neon"] = 931.43, ["Neon|Fly|Ride"] = 972.77, ["Mega"] = 8458.78, ["Mega|Ride"] = 3313.74, ["Mega|Fly|Ride"] = 3320.09}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.02, ["Neon"] = 8.07, ["Neon|Ride"] = 64.32, ["Mega"] = 65.54, ["Mega|Ride"] = 184, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 5.25, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 62.19, ["Neon"] = 32.34, ["Neon|Ride"] = 169.19, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 381.82, ["Mega|Ride"] = 527.63, ["Mega|Fly|Ride"] = 643.22}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.48, ["Fly|Ride"] = 32.8, ["Neon"] = 7.88, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 46.78, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 141.7}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 18.01, ["Fly|Ride"] = 92.59, ["Neon"] = 8.03, ["Neon|Ride"] = 61.51, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.86, ["Mega|Ride"] = 192, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.2, ["Fly"] = 25.98, ["Ride"] = 15.67, ["Fly|Ride"] = 31.23, ["Neon"] = 20.83, ["Neon|Fly"] = 99.41, ["Neon|Ride"] = 30.82, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 278.1, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.45, ["Ride"] = 28.55, ["Fly|Ride"] = 118.13, ["Neon"] = 47.1, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 328.97, ["Mega|Fly|Ride"] = 324.62}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.63, ["Fly"] = 18.79, ["Ride"] = 16.27, ["Fly|Ride"] = 37.72, ["Neon"] = 24.87, ["Neon|Fly"] = 67.28, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 62.36, ["Mega"] = 262.5, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.12, ["Fly"] = 98.63, ["Ride"] = 91.23, ["Fly|Ride"] = 141.68, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 437.96, ["Mega|Fly|Ride"] = 1407.35}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 194.71, ["Fly"] = 422.9, ["Ride"] = 245.44, ["Fly|Ride"] = 308.43, ["Neon"] = 1200.07, ["Neon|Ride"] = 1128.2, ["Neon|Fly|Ride"] = 965.62, ["Mega"] = 10573.48, ["Mega|Fly|Ride"] = 4934.65}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 56.99, ["Fly"] = 141.68, ["Ride"] = 74.31, ["Fly|Ride"] = 113.14, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 286.8, ["Mega|Ride"] = 1355.53, ["Mega|Fly|Ride"] = 1372.45}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 8.48, ["Fly"] = 42.31, ["Ride"] = 23.28, ["Fly|Ride"] = 65.54, ["Neon"] = 26.25, ["Neon|Ride"] = 122.67, ["Neon|Fly|Ride"] = 283.4, ["Mega"] = 262.5, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 8.55, ["Fly"] = 70.86, ["Ride"] = 20.57, ["Fly|Ride"] = 92.36, ["Neon"] = 48.57, ["Neon|Ride"] = 55.21, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 355.69, ["Mega|Ride"] = 286.86, ["Mega|Fly|Ride"] = 389.03}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 15.33, ["Fly|Ride"] = 44.68, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 21.76, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 120.01, ["Mega|Fly"] = 146.41, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 370.32}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.81, ["Fly"] = 72.12, ["Ride"] = 23.27, ["Fly|Ride"] = 66.25, ["Neon"] = 400.84, ["Neon|Fly"] = 353.17, ["Neon|Ride"] = 113.04, ["Neon|Fly|Ride"] = 211.44, ["Mega"] = 422.94, ["Mega|Ride"] = 479.99, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.71, ["Fly|Ride"] = 36.05, ["Neon"] = 9.71, ["Neon|Fly"] = 80.41, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 162.85, ["Mega|Ride"] = 175.42, ["Mega|Fly|Ride"] = 196.21}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 30.68, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.97, ["Mega"] = 207.37, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.36, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.37, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.33, ["Ride"] = 18.38, ["Fly|Ride"] = 42.31, ["Neon"] = 15.61, ["Neon|Fly"] = 105.75, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 96.01, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.56, ["Fly"] = 25.72, ["Ride"] = 17.38, ["Fly|Ride"] = 62.39, ["Neon"] = 15.78, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 240.03, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 98.44, ["Fly"] = 143.07, ["Ride"] = 142.17, ["Fly|Ride"] = 182.44, ["Neon"] = 489.57, ["Neon|Ride"] = 432.95, ["Neon|Fly|Ride"] = 524.94, ["Mega"] = 4229.39, ["Mega|Ride"] = 2720.26, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.86, ["Ride"] = 40.81, ["Fly|Ride"] = 128.43, ["Neon"] = 46.53, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 326.82, ["Mega|Ride"] = 430.5, ["Mega|Fly|Ride"] = 480.05}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 15.65, ["Fly|Ride"] = 36.74, ["Neon"] = 13.13, ["Neon|Ride"] = 28.77, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 240, ["Mega|Ride"] = 186.38, ["Mega|Fly|Ride"] = 311.93}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.63, ["Ride"] = 58.02, ["Fly|Ride"] = 170.63, ["Neon"] = 78.75, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 605.52, ["Mega"] = 564.63, ["Mega|Fly"] = 845.88, ["Mega|Ride"] = 687.75, ["Mega|Fly|Ride"] = 634.41}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 6.57}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.63, ["Ride"] = 28.84, ["Fly|Ride"] = 125.82, ["Neon"] = 36.74, ["Neon|Fly"] = 69.57, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 422.94, ["Mega|Ride"] = 479.99, ["Mega|Fly|Ride"] = 884.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.39, ["Fly"] = 36.88, ["Ride"] = 26.18, ["Fly|Ride"] = 42.63, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 160.82, ["Neon|Fly|Ride"] = 172.86, ["Mega"] = 1365.06, ["Mega|Fly|Ride"] = 564.63}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.48, ["Fly|Ride"] = 70.86, ["Neon"] = 3.78, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 106.54, ["Mega"] = 29.58, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 59.06, ["Mega|Fly|Ride"] = 229.01}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 9.09, ["Fly"] = 28.55, ["Ride"] = 19.81, ["Fly|Ride"] = 39.38, ["Neon"] = 56.42, ["Neon|Ride"] = 63.46, ["Mega"] = 282.32, ["Mega|Fly"] = 400.79, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 452.55}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 13.55, ["Fly|Ride"] = 47.49, ["Neon"] = 19.22, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.3, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 138.9, ["Mega|Ride"] = 187.59, ["Mega|Fly|Ride"] = 360.89}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.64, ["Fly|Ride"] = 211.45, ["Neon"] = 3.25, ["Neon|Fly"] = 37.02, ["Neon|Ride"] = 32.7, ["Mega"] = 26.42, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 121.78}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 27.57, ["Ride"] = 42, ["Fly|Ride"] = 94.48, ["Neon"] = 181.13, ["Neon|Ride"] = 209.68, ["Neon|Fly|Ride"] = 564.63, ["Mega"] = 946.34, ["Mega|Ride"] = 987.57, ["Mega|Fly|Ride"] = 866.25}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.6, ["Fly"] = 28.55, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 95.81, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.63, ["Fly"] = 28.8, ["Ride"] = 15.88, ["Fly|Ride"] = 48.2, ["Neon"] = 16.57, ["Neon|Fly"] = 84.6, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 72.58, ["Mega"] = 387.85, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.86, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 367.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4481.75, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2579.94}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.59, ["Fly"] = 44.94, ["Ride"] = 20.22, ["Fly|Ride"] = 57.66, ["Neon"] = 37.68, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 48.37, ["Neon|Fly|Ride"] = 85.05, ["Mega"] = 250.69, ["Mega|Ride"] = 215.93, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.58, ["Fly"] = 143.06, ["Ride"] = 108.05, ["Fly|Ride"] = 140.44, ["Neon"] = 262.4, ["Neon|Fly"] = 321.44, ["Neon|Ride"] = 250.41, ["Neon|Fly|Ride"] = 314.74, ["Mega"] = 840.61, ["Mega|Ride"] = 938.97, ["Mega|Fly|Ride"] = 968.63}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.49, ["Ride"] = 42.62, ["Fly|Ride"] = 208.82, ["Neon"] = 80.55, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 315, ["Mega|Ride"] = 333.59, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5, ["Fly"] = 41.36, ["Ride"] = 28.55, ["Fly|Ride"] = 70.13, ["Neon"] = 98.44, ["Neon|Ride"] = 144.03, ["Neon|Fly|Ride"] = 381.6, ["Mega"] = 211.47, ["Mega|Ride"] = 1586.04, ["Mega|Fly|Ride"] = 536.09}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 12.99, ["Fly"] = 69.79, ["Ride"] = 49.88, ["Fly|Ride"] = 131.25, ["Neon"] = 69.47, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.05, ["Ride"] = 29.98, ["Fly|Ride"] = 84.59, ["Neon"] = 28.56, ["Neon|Ride"] = 57.18, ["Neon|Fly|Ride"] = 126.9, ["Mega"] = 276.63, ["Mega|Ride"] = 250.34, ["Mega|Fly|Ride"] = 347.83}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 93.78, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 15.75, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.89, ["Ride"] = 32.82, ["Neon"] = 31.74, ["Neon|Ride"] = 184.7, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 228.38, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 124.77, ["Ride"] = 28.53, ["Neon"] = 28.88, ["Neon|Fly"] = 78.25, ["Neon|Ride"] = 70.86, ["Mega"] = 184, ["Mega|Ride"] = 282.57, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.62, ["Ride"] = 32.8, ["Fly|Ride"] = 120.02, ["Neon"] = 30.68, ["Neon|Ride"] = 82.49, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 124.69, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 459.27, ["Ride"] = 536.82, ["Fly|Ride"] = 559.13, ["Neon"] = 1797.51, ["Neon|Fly"] = 1799.62, ["Neon|Ride"] = 1837.68, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 9.19, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 56.35, ["Neon"] = 41.26, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 183.75, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 350}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.69, ["Fly"] = 66.94, ["Ride"] = 16.95, ["Fly|Ride"] = 51.55, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 71.65, ["Neon|Fly|Ride"] = 162.85, ["Mega"] = 331.87, ["Mega|Ride"] = 502.26, ["Mega|Fly|Ride"] = 376.44}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.28, ["Fly"] = 24.93, ["Ride"] = 20.24, ["Fly|Ride"] = 50.78, ["Neon"] = 11.82, ["Neon|Ride"] = 49.71, ["Neon|Fly|Ride"] = 131.25}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.36, ["Fly|Ride"] = 52.41, ["Neon"] = 8.24, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 99.41, ["Mega"] = 61.32, ["Mega|Fly"] = 282.32, ["Mega|Ride"] = 94.38, ["Mega|Fly|Ride"] = 228.71}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 16.95, ["Neon"] = 2.5, ["Neon|Ride"] = 23.6, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 22.32, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 224.17}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.12, ["Ride"] = 30.19, ["Fly|Ride"] = 329.99, ["Neon"] = 63.41, ["Neon|Ride"] = 91.88, ["Mega"] = 395.47, ["Mega|Ride"] = 845.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.69, ["Neon"] = 5.02, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 987.81, ["Mega"] = 36.95, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.29, ["Fly"] = 28.56, ["Ride"] = 65.63, ["Neon"] = 20.18, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 243.48, ["Mega"] = 208.69, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 409.49, ["Ride"] = 424.93, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1234.04, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8800.32, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 3.46, ["Fly"] = 196.88, ["Ride"] = 57.1, ["Fly|Ride"] = 422.9, ["Neon"] = 19.69, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 391, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 736.78}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 28.23, ["Fly|Ride"] = 118.13, ["Neon"] = 3.94, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 35.11, ["Mega|Fly"] = 144, ["Mega|Ride"] = 75.18, ["Mega|Fly|Ride"] = 154.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 4.09, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 32.12, ["Mega|Ride"] = 138.92, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 21.51, ["Fly"] = 107.9, ["Ride"] = 42.74, ["Fly|Ride"] = 141.68, ["Neon"] = 195.51, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 513.58, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 10.27, ["Ride"] = 71.31, ["Neon"] = 102.27, ["Neon|Ride"] = 179.47, ["Neon|Fly|Ride"] = 480.04, ["Mega"] = 400.79, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 634.41}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 70.86, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 656.38, ["Mega|Ride"] = 776.1, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 11.03, ["Ride"] = 23.86, ["Fly|Ride"] = 262.5, ["Neon"] = 167.28, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 244.27, ["Mega"] = 629.9, ["Mega|Ride"] = 564.63, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 417.78, ["Fly|Ride"] = 513.64, ["Neon"] = 1706.25, ["Neon|Ride"] = 1410.51, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.25, ["Fly"] = 78.75, ["Ride"] = 28.87, ["Fly|Ride"] = 82.18, ["Neon"] = 113.15, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 141.7, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.83, ["Ride"] = 30.68, ["Fly|Ride"] = 127.32, ["Neon"] = 62.34, ["Neon|Ride"] = 221.82, ["Mega"] = 167.08, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 26.94, ["Ride"] = 84, ["Neon"] = 91.77, ["Neon|Ride"] = 160.23, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 314.9, ["Mega|Fly"] = 705.26, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.58, ["Ride"] = 42.31, ["Fly|Ride"] = 211.45, ["Neon"] = 7.4, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 273.87, ["Mega"] = 38.36, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 244.27}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 36.66, ["Ride"] = 90.93, ["Neon"] = 315, ["Neon|Ride"] = 282.32, ["Neon|Fly|Ride"] = 503.31, ["Mega"] = 1619.92, ["Mega|Ride"] = 2080.71, ["Mega|Fly|Ride"] = 1326.59}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.13, ["Ride"] = 26.25, ["Fly|Ride"] = 196.88, ["Neon"] = 7.28, ["Neon|Fly"] = 184, ["Neon|Ride"] = 37.22, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 59.07, ["Mega|Ride"] = 92.09, ["Mega|Fly|Ride"] = 216.79}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 28.56, ["Fly|Ride"] = 98.21, ["Neon"] = 3.84, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 25.39, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 78.78, ["Mega|Fly|Ride"] = 184.7}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 127.62, ["Neon"] = 9.54, ["Neon|Ride"] = 56.67, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 84, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 311.93}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 44.43, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 185.04, ["Neon"] = 248.98, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 480.04, ["Mega|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 211.45, ["Ride"] = 240, ["Fly|Ride"] = 420.79, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1470, ["Mega"] = 9599.46, ["Mega|Fly|Ride"] = 4677.75}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 7.28, ["Ride"] = 99.4, ["Neon"] = 26.25, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 109.22, ["Mega"] = 139.12, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 342.03}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.04, ["Fly|Ride"] = 160.82, ["Neon"] = 8.21, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 38.59, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 91.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 106.45, ["Ride"] = 28.55, ["Fly|Ride"] = 91.88, ["Neon"] = 32.82, ["Mega"] = 140.98, ["Mega|Ride"] = 348.04, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 64.97, ["Ride"] = 30.19, ["Fly|Ride"] = 116.16, ["Neon"] = 17.79, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 139, ["Mega"] = 124.69, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 144, ["Mega|Fly|Ride"] = 345.77}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.91, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 26.17, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 391.23}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 37.02, ["Ride"] = 19.04, ["Fly|Ride"] = 52.48, ["Neon"] = 7.88, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 125.85, ["Mega"] = 38.59, ["Mega|Ride"] = 99.75, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 15.75, ["Fly|Ride"] = 46.81, ["Neon"] = 14.86, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.69, ["Neon|Fly|Ride"] = 113.15, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 29.91, ["Ride"] = 32.44, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 322.3, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 527.68}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 67.49, ["Ride"] = 84.35, ["Fly|Ride"] = 139.13, ["Neon"] = 390.73, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.49, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 1975.14, ["Mega|Ride"] = 1551.14, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 17.99, ["Fly|Ride"] = 144.38, ["Neon"] = 3.76, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.01, ["Mega|Fly|Ride"] = 247.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.64, ["Fly|Ride"] = 39.37, ["Neon"] = 3.68, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 38.07, ["Mega|Fly"] = 131.21, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 96.24}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.15, ["Fly"] = 42.31, ["Ride"] = 28.77, ["Neon"] = 48.37, ["Neon|Ride"] = 135.19, ["Mega"] = 527.63, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 366.92}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4228.89, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 21.44, ["Fly"] = 99.4, ["Ride"] = 53.99, ["Fly|Ride"] = 84.36, ["Neon"] = 241.5, ["Neon|Ride"] = 174.3, ["Neon|Fly|Ride"] = 256.83, ["Mega|Ride"] = 691.39, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Fly|Ride"] = 281.33, ["Neon"] = 7.8, ["Neon|Ride"] = 48.56, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 99.41, ["Mega|Ride"] = 144.53, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 65.63, ["Fly|Ride"] = 65.63, ["Neon"] = 42.68, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 316.16}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 27.2, ["Fly"] = 169.3, ["Ride"] = 37.69, ["Fly|Ride"] = 105.35, ["Neon"] = 194.25, ["Neon|Ride"] = 272.44, ["Neon|Fly|Ride"] = 210, ["Mega"] = 2537.64, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.34, ["Ride"] = 113.43, ["Fly|Ride"] = 206.18, ["Neon"] = 430.1, ["Neon|Ride"] = 480.04, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8458.78, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Ride"] = 264.22, ["Fly|Ride"] = 382.49, ["Neon"] = 708.75, ["Neon|Ride"] = 598.03, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3377.18}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 16.13, ["Ride"] = 28.55, ["Fly|Ride"] = 141.68, ["Neon"] = 85.2, ["Neon|Fly"] = 120.02, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 420, ["Mega|Ride"] = 394.68, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.3, ["Fly|Ride"] = 43.32, ["Neon"] = 7.26, ["Neon|Ride"] = 21.16, ["Neon|Fly|Ride"] = 92.01, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 45.11, ["Ride"] = 18.38, ["Fly|Ride"] = 55.98, ["Neon"] = 31.48, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 87.04, ["Mega"] = 285.81, ["Mega|Ride"] = 411.59, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 325.5, ["Ride"] = 393.75, ["Fly|Ride"] = 640.84, ["Neon"] = 1952.5, ["Neon|Ride"] = 1818.65, ["Neon|Fly|Ride"] = 1899.01, ["Mega"] = 10150.54, ["Mega|Fly|Ride"] = 5067.57}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Neon"] = 3.94, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.58, ["Mega|Ride"] = 169.28}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.94, ["Ride"] = 16.03, ["Fly|Ride"] = 39.37, ["Neon"] = 36.88, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 96.02, ["Mega"] = 234.74, ["Mega|Ride"] = 211.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.1, ["Ride"] = 48.02, ["Neon"] = 78.75, ["Neon|Fly"] = 422.94, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 353.26, ["Mega"] = 459.38, ["Mega|Ride"] = 561.62, ["Mega|Fly|Ride"] = 637.33}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 97.84, ["Fly"] = 141.68, ["Ride"] = 108.94, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 19.66, ["Fly"] = 24.57, ["Ride"] = 25.41, ["Fly|Ride"] = 53.82, ["Neon"] = 126.9, ["Neon|Ride"] = 89.29, ["Neon|Fly|Ride"] = 139.79, ["Mega"] = 705.26, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 527.63}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.16, ["Neon"] = 3.15, ["Neon|Ride"] = 69.57, ["Mega"] = 25.73, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.65, ["Fly|Ride"] = 72.19, ["Neon"] = 2.63, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 24.34, ["Neon|Fly|Ride"] = 82.15, ["Mega"] = 26.25, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 15.75, ["Ride"] = 56.35, ["Fly|Ride"] = 209.34, ["Neon"] = 36.26, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 159.93, ["Mega|Ride"] = 191.56, ["Mega|Fly|Ride"] = 300.24}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1179.93, ["Ride"] = 1247.23, ["Fly|Ride"] = 1358.44, ["Neon|Ride"] = 7049.35, ["Neon|Fly|Ride"] = 4371.09, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 430.5, ["Ride"] = 420, ["Fly|Ride"] = 556.88, ["Neon"] = 1663.2, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 16917.56, ["Mega|Fly|Ride"] = 7175.18}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 293.99, ["Fly"] = 351.75, ["Ride"] = 343.86, ["Fly|Ride"] = 420, ["Neon"] = 787.5, ["Neon|Fly"] = 1120.87, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 734.79, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 241.49, ["Fly"] = 360.03, ["Ride"] = 296.63, ["Fly|Ride"] = 367.5, ["Neon"] = 708.75, ["Neon|Ride"] = 603.74, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2996.54}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 14.21, ["Fly|Ride"] = 39.37, ["Neon"] = 10.59, ["Neon|Ride"] = 30.06, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.57, ["Mega|Fly"] = 112.09, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 229.84, ["Fly"] = 395.41, ["Ride"] = 282.3, ["Fly|Ride"] = 509.25, ["Neon"] = 1318.53, ["Neon|Ride"] = 1255.08, ["Neon|Fly|Ride"] = 1114.32, ["Mega"] = 21429.27, ["Mega|Ride"] = 5075.27, ["Mega|Fly|Ride"] = 3949.21}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.04, ["Fly"] = 157.5, ["Ride"] = 70.26, ["Fly|Ride"] = 91.88, ["Neon"] = 24.86, ["Neon|Ride"] = 112.77, ["Neon|Fly|Ride"] = 254.63, ["Mega"] = 168.5, ["Mega|Ride"] = 283.64, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 15.88, ["Ride"] = 15.39, ["Fly|Ride"] = 39.38, ["Neon"] = 6.57, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 96.01}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.6, ["Neon"] = 2.52, ["Neon|Ride"] = 45.94, ["Mega"] = 26.25, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.55, ["Ride"] = 52.88, ["Fly|Ride"] = 459.38, ["Neon"] = 240.02, ["Neon|Ride"] = 353.17, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 6.57, ["Mega"] = 354.23, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.69, ["Mega|Ride"] = 69.8, ["Mega|Fly|Ride"] = 167.08}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 4.81, ["Fly"] = 41.25, ["Ride"] = 27.57, ["Fly|Ride"] = 78.64, ["Neon"] = 14.97, ["Neon|Fly"] = 113.15, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 80.33, ["Mega"] = 136.49, ["Mega|Ride"] = 112.74, ["Mega|Fly|Ride"] = 238.23}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 5.25, ["Fly"] = 57.1, ["Ride"] = 19.04, ["Fly|Ride"] = 50.33, ["Neon"] = 35.97, ["Neon|Fly"] = 144.03, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 19.04, ["Ride"] = 63.46, ["Neon"] = 92.9, ["Neon|Ride"] = 184, ["Neon|Fly|Ride"] = 310.79, ["Mega"] = 400.79, ["Mega|Ride"] = 791.98}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6400.96, ["Ride"] = 19.69, ["Neon"] = 48.67, ["Neon|Fly"] = 48.57, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 328.13, ["Mega|Ride"] = 417.67, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 15.75, ["Fly|Ride"] = 45.83, ["Neon"] = 6.3, ["Neon|Fly"] = 31.74, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 99.41, ["Mega"] = 45.94, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.96, ["Fly"] = 257.98, ["Ride"] = 131.25, ["Fly|Ride"] = 229.69, ["Neon"] = 844.83, ["Neon|Ride"] = 901.25, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8458.78, ["Mega|Fly|Ride"] = 3482.92}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 14.26, ["Fly|Ride"] = 35.44, ["Neon"] = 3.92, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 24.95, ["Mega|Ride"] = 51.77, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.59, ["Ride"] = 40.14, ["Fly|Ride"] = 196.88, ["Neon"] = 65.63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 768.05, ["Mega"] = 313.69, ["Mega|Fly"] = 800.37, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.11, ["Ride"] = 128.42, ["Fly|Ride"] = 170.63, ["Neon"] = 155.91, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 253.78, ["Mega"] = 786.19, ["Mega|Ride"] = 610.71, ["Mega|Fly|Ride"] = 845.88}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 192.3, ["Fly"] = 304.5, ["Ride"] = 244.42, ["Fly|Ride"] = 280.88, ["Neon"] = 796.23, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3501.75}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 14.44, ["Ride"] = 160.82, ["Fly|Ride"] = 144.03, ["Neon"] = 91.88, ["Neon|Ride"] = 211.47, ["Mega"] = 287.44, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 317.22}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.02, ["Ride"] = 57.75, ["Fly|Ride"] = 634.34, ["Neon"] = 105.75, ["Neon|Fly"] = 160.82, ["Neon|Ride"] = 207.21, ["Neon|Fly|Ride"] = 156.76, ["Mega"] = 776.1, ["Mega|Ride"] = 845.88, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 905.52, ["Ride"] = 963.29, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4650.22, ["Mega|Fly|Ride"] = 17600.62}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.64, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 93.61, ["Neon"] = 21.16, ["Neon|Fly"] = 56.98, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 228, ["Mega|Fly|Ride"] = 336.25}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 6.05, ["Fly"] = 78.75, ["Ride"] = 35.97, ["Fly|Ride"] = 53.93, ["Neon"] = 38.75, ["Neon|Ride"] = 83.54, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 524.46, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.59, ["Ride"] = 23.88, ["Fly|Ride"] = 95.16, ["Neon"] = 6.25, ["Neon|Ride"] = 46.38, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 78.75, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.69, ["Fly"] = 54.98, ["Ride"] = 39.38, ["Fly|Ride"] = 92.59, ["Neon"] = 78.75, ["Neon|Ride"] = 91.54, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 492.19, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 15.99, ["Fly|Ride"] = 51.8, ["Neon"] = 17.07, ["Neon|Fly"] = 42.74, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 109.62, ["Mega"] = 115.5, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 125.85, ["Mega|Fly|Ride"] = 186.27}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 6.17, ["Fly"] = 32.75, ["Ride"] = 26.15, ["Fly|Ride"] = 84.59, ["Neon"] = 11.57, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 200.41, ["Mega|Fly|Ride"] = 479.99}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 157.5, ["Fly"] = 235.77, ["Ride"] = 262.5, ["Fly|Ride"] = 226.26, ["Neon"] = 915.68, ["Neon|Fly|Ride"] = 1410.94}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 28.55, ["Fly|Ride"] = 108.94, ["Neon"] = 6.2, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 61.69, ["Mega|Fly"] = 422.94, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 5.8, ["Ride"] = 82.48, ["Fly|Ride"] = 88.86, ["Neon"] = 27.86, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.19, ["Fly"] = 94.73, ["Ride"] = 19.59, ["Neon"] = 10.18, ["Neon|Ride"] = 84.6, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 94.37, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.17}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.42, ["Ride"] = 127.79, ["Fly|Ride"] = 315, ["Neon"] = 480.05, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 637.24, ["Mega"] = 2537.64, ["Mega|Ride"] = 4229.39, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.36, ["Fly"] = 90.76, ["Ride"] = 42.52, ["Fly|Ride"] = 253.76, ["Neon"] = 105, ["Neon|Ride"] = 162.85, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 634.41, ["Mega|Ride"] = 606.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.57, ["Fly"] = 57.49, ["Ride"] = 32.82, ["Fly|Ride"] = 97.13, ["Neon"] = 81.38, ["Neon|Fly"] = 64.82, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 241.4, ["Mega"] = 477.93, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 457.9}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.79, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 480.05}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 40.69, ["Fly"] = 74.78, ["Ride"] = 98.44, ["Fly|Ride"] = 139.23, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 261.62, ["Neon|Fly|Ride"] = 301.88, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 52.5, ["Neon"] = 5.9, ["Neon|Ride"] = 57.11, ["Neon|Fly|Ride"] = 125.85, ["Mega"] = 57.11, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.56, ["Fly"] = 109.22, ["Ride"] = 33.44, ["Fly|Ride"] = 96.23, ["Neon"] = 69.3, ["Neon|Ride"] = 79.22, ["Neon|Fly|Ride"] = 210, ["Mega"] = 357.09, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 288, ["Mega|Fly|Ride"] = 418.72}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 44.59, ["Fly"] = 203.34, ["Ride"] = 76.13, ["Fly|Ride"] = 157.17, ["Neon"] = 262.4, ["Neon|Fly"] = 282.32, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1373.51, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.6, ["Ride"] = 15.17, ["Fly|Ride"] = 28.84, ["Neon"] = 3.94, ["Neon|Fly"] = 13.02, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 16.96, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 131.25, ["Neon"] = 20.37, ["Neon|Fly"] = 63.46, ["Neon|Ride"] = 65.6, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 226.28, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 14.18, ["Fly"] = 141.68, ["Ride"] = 40.81, ["Fly|Ride"] = 85.32, ["Neon"] = 110.13, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 465.83, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22, ["Neon"] = 2.24, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.22, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 209.36}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 23.63, ["Fly"] = 201.52, ["Ride"] = 69.62, ["Fly|Ride"] = 131.15, ["Neon"] = 118.12, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 649.22, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 535.42, ["Mega|Fly|Ride"] = 652.32}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.38, ["Fly"] = 42.41, ["Ride"] = 18.43, ["Fly|Ride"] = 98.44, ["Neon"] = 357.86, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 6.28, ["Ride"] = 47.25, ["Neon"] = 39.14, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 37.57, ["Neon|Fly|Ride"] = 705.26, ["Mega"] = 231, ["Mega|Ride"] = 263.82, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.92, ["Fly"] = 72.19, ["Ride"] = 57.1, ["Fly|Ride"] = 196.88, ["Neon"] = 48.72, ["Neon|Ride"] = 87.77, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.69, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 374.32}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.31, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Ride"] = 32.71, ["Mega"] = 69.56, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 279.16}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 57.62, ["Neon"] = 3.94, ["Neon|Ride"] = 48.02, ["Mega"] = 22.07, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 11.82}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.54, ["Fly"] = 99.4, ["Ride"] = 52.5, ["Fly|Ride"] = 79.31, ["Neon"] = 184.57, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1833.45, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.57}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.23, ["Neon|Ride"] = 27.45, ["Mega"] = 19.05, ["Mega|Ride"] = 121.05, ["Mega|Fly|Ride"] = 317.22}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 480.02, ["Fly"] = 498.75, ["Ride"] = 561.75, ["Fly|Ride"] = 600.04, ["Neon"] = 2819.96, ["Neon|Ride"] = 2008.98, ["Neon|Fly|Ride"] = 2111.03, ["Mega"] = 16917.56, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.84, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 66.62, ["Neon"] = 35.39, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 113.15, ["Mega"] = 95.86, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 3.93, ["Fly"] = 28.55, ["Ride"] = 18.38, ["Fly|Ride"] = 91.88, ["Neon"] = 19.46, ["Neon|Ride"] = 48.65, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 131.25, ["Mega|Fly"] = 282.32, ["Mega|Ride"] = 152.29, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.2, ["Fly"] = 70.86, ["Ride"] = 42.17, ["Fly|Ride"] = 70.82, ["Neon"] = 55.53, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 670.38, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.03, ["Fly"] = 57.1, ["Ride"] = 38.57, ["Fly|Ride"] = 705.17, ["Neon"] = 17.64, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.97, ["Ride"] = 95.16, ["Fly|Ride"] = 141.68, ["Neon"] = 69.57, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 292.81, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 628.08}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.88, ["Fly"] = 105, ["Ride"] = 25.6, ["Fly|Ride"] = 91.88, ["Neon"] = 27.5, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 139.58, ["Mega"] = 227.07, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.02, ["Ride"] = 13.8, ["Fly|Ride"] = 76.13, ["Neon"] = 2.1, ["Neon|Fly"] = 23.28, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 76.14, ["Mega"] = 15.23, ["Mega|Fly"] = 64.82, ["Mega|Ride"] = 35.41, ["Mega|Fly|Ride"] = 91.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 7.76, ["Fly"] = 53.93, ["Ride"] = 39.38, ["Fly|Ride"] = 105.74, ["Neon"] = 28.77, ["Neon|Fly"] = 120.02, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 193.1, ["Mega"] = 196.87, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 320.16, ["Ride"] = 318.5, ["Fly|Ride"] = 360.94, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.44, ["Mega|Ride"] = 9311.49, ["Mega|Fly|Ride"] = 4638.6}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 85.32, ["Ride"] = 111.57, ["Fly|Ride"] = 282.3, ["Neon"] = 356.57, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 582.62, ["Mega"] = 2256.39, ["Mega|Ride"] = 1820.77, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.59, ["Ride"] = 15.44, ["Fly|Ride"] = 34.55, ["Neon"] = 4.81, ["Neon|Fly"] = 28.46, ["Neon|Ride"] = 33.86, ["Neon|Fly|Ride"] = 57.11, ["Mega"] = 87.77, ["Mega|Fly"] = 64.82, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.92, ["Fly|Ride"] = 34.83, ["Neon"] = 6.57, ["Neon|Fly"] = 46.53, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 65.63, ["Mega|Fly"] = 282.32, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Fly"] = 99.4, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 99.41, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 409.21, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 268.54, ["Ride"] = 234.94, ["Fly|Ride"] = 285.46, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1038.33, ["Mega|Ride"] = 8458.78, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 3.94, ["Fly"] = 10.59, ["Ride"] = 14.6, ["Fly|Ride"] = 40.69, ["Neon"] = 13.13, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 29.94, ["Neon|Fly|Ride"] = 75.7, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 304.8}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Fly|Ride"] = 211.45, ["Neon"] = 26.42, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 157.5, ["Mega|Ride"] = 300.2, ["Mega|Fly|Ride"] = 452.55}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 7.88, ["Neon|Ride"] = 156.09, ["Mega"] = 68.16, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 13.13, ["Fly"] = 48.02, ["Ride"] = 17.43, ["Fly|Ride"] = 103.63, ["Neon"] = 118.13, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 587.9}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 52.5, ["Ride"] = 78.66, ["Fly|Ride"] = 294.98, ["Neon"] = 142.21, ["Neon|Fly"] = 211.47, ["Neon|Ride"] = 160.76, ["Neon|Fly|Ride"] = 452.55, ["Mega"] = 452.82, ["Mega|Fly"] = 2220.45, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 594.37}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 22.76, ["Fly"] = 62.39, ["Ride"] = 48.47, ["Fly|Ride"] = 98.44, ["Neon"] = 155.06, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 211.47, ["Neon|Fly|Ride"] = 307.71, ["Mega"] = 845.88, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.47, ["Ride"] = 14.95, ["Fly|Ride"] = 29.77, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 15.07, ["Neon|Fly|Ride"] = 35.97, ["Mega"] = 17.71, ["Mega|Fly"] = 422.94, ["Mega|Ride"] = 33.38, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 184.93, ["Fly"] = 259.23, ["Ride"] = 231, ["Fly|Ride"] = 272.97, ["Neon"] = 2520.95, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1078.51, ["Mega|Fly|Ride"] = 3946.03}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 42.31, ["Fly"] = 65.63, ["Ride"] = 49.86, ["Fly|Ride"] = 104.99, ["Neon"] = 78.75, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.5, ["Mega|Ride"] = 445.04, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34.11, ["Ride"] = 18.74, ["Fly|Ride"] = 42.31, ["Neon"] = 5.24, ["Neon|Fly"] = 39.98, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 59.21, ["Mega|Ride"] = 84.6, ["Mega|Fly|Ride"] = 197.74}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.43, ["Ride"] = 16.14, ["Fly|Ride"] = 45.48, ["Neon"] = 2.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 126.9, ["Mega"] = 19.69, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 74.82}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.94, ["Ride"] = 21, ["Fly|Ride"] = 72.19, ["Neon"] = 13.36, ["Neon|Fly"] = 720.05, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 103.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.44, ["Fly"] = 38.74, ["Ride"] = 20.99, ["Fly|Ride"] = 69.21, ["Neon"] = 48.27, ["Neon|Fly"] = 268.58, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 116.7, ["Mega"] = 355.69, ["Mega|Ride"] = 353.07, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.88, ["Ride"] = 65.63, ["Neon"] = 54.57, ["Neon|Fly|Ride"] = 315, ["Mega"] = 240.03, ["Mega|Ride"] = 311.93, ["Mega|Fly|Ride"] = 400.79}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 42.41, ["Neon"] = 2.5, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 99.36, ["Mega"] = 61.69, ["Mega|Ride"] = 83.6, ["Mega|Fly|Ride"] = 212.63}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.35, ["Ride"] = 27.2, ["Fly|Ride"] = 131.25, ["Neon"] = 31.84, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.87, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 249.55, ["Mega|Ride"] = 211.98, ["Mega|Fly|Ride"] = 301.2}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 84.59, ["Neon"] = 3.5, ["Neon|Fly"] = 113.15, ["Neon|Ride"] = 45.8, ["Neon|Fly|Ride"] = 102.35, ["Mega"] = 24.41, ["Mega|Ride"] = 104.71, ["Mega|Fly|Ride"] = 141.7}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45, ["Ride"] = 18.14, ["Fly|Ride"] = 40.27, ["Neon"] = 3.94, ["Neon|Ride"] = 21.63, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.74, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 78.46, ["Mega|Fly|Ride"] = 137.71}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.13, ["Ride"] = 685.12, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Ride"] = 4916.68, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12640.09}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 10.59, ["Fly|Ride"] = 36.33, ["Neon"] = 11.81, ["Neon|Fly"] = 42.32, ["Neon|Ride"] = 35.97, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 366.92}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.92, ["Ride"] = 26.25, ["Neon"] = 6.46, ["Neon|Fly"] = 740.16, ["Neon|Ride"] = 114.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.13, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 249.26, ["Mega|Fly|Ride"] = 257.15}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.77, ["Fly"] = 44.63, ["Ride"] = 23.12, ["Fly|Ride"] = 45.94, ["Neon"] = 49.71, ["Neon|Fly"] = 192.03, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 14.22, ["Fly|Ride"] = 41.99, ["Neon"] = 6.18, ["Neon|Fly"] = 148.04, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 55.77, ["Mega"] = 59.04, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 30.08, ["Fly"] = 105, ["Ride"] = 57.1, ["Fly|Ride"] = 282.3, ["Neon"] = 196.88, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 687.39, ["Mega|Ride"] = 613.28, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 16.88, ["Fly|Ride"] = 76.12, ["Neon"] = 5.2, ["Neon|Fly"] = 136.82, ["Neon|Ride"] = 26.87, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 43.22, ["Mega|Ride"] = 130.61, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.2, ["Fly"] = 73.41, ["Ride"] = 23.33, ["Fly|Ride"] = 54.02, ["Neon"] = 9.98, ["Neon|Ride"] = 41.9, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 89.1, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 158.62, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.64, ["Fly|Ride"] = 49.71, ["Neon"] = 3.82, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 111.63, ["Mega"] = 38.41, ["Mega|Fly"] = 227.39, ["Mega|Ride"] = 70.86, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.2, ["Fly"] = 21.17, ["Ride"] = 16.92, ["Fly|Ride"] = 39.37, ["Neon"] = 104.99, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 140.21, ["Mega|Ride"] = 463.14, ["Mega|Fly|Ride"] = 391.56}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 732.09, ["Fly"] = 895.48, ["Ride"] = 733.69, ["Fly|Ride"] = 860.75, ["Neon"] = 1895.25, ["Neon|Ride"] = 1596.14, ["Neon|Fly|Ride"] = 1990.86, ["Mega"] = 4654.13, ["Mega|Fly|Ride"] = 6005.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 17.75, ["Ride"] = 14.44, ["Fly|Ride"] = 27.57, ["Neon"] = 3.64, ["Neon|Fly"] = 35.97, ["Neon|Ride"] = 17.42, ["Neon|Fly|Ride"] = 42.31, ["Mega"] = 56.62, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 136.43}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 11.8, ["Ride"] = 32.81, ["Fly|Ride"] = 240.02, ["Neon"] = 48.47, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 400.79, ["Mega|Ride"] = 353.17, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 52.41, ["Fly"] = 104.9, ["Ride"] = 74.8, ["Fly|Ride"] = 105, ["Neon|Ride"] = 401.81, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 1691.76, ["Mega|Fly|Ride"] = 1407.35}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 30.19, ["Ride"] = 61.69, ["Fly|Ride"] = 105, ["Neon"] = 187.69, ["Neon|Ride"] = 222.06, ["Mega"] = 1280.34, ["Mega|Ride"] = 888.19, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.99, ["Ride"] = 26.23, ["Fly|Ride"] = 141.68, ["Neon"] = 57.11, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 265.55, ["Mega"] = 302.3, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 27.7, ["Ride"] = 52.87, ["Neon"] = 85.32, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 282.57, ["Mega|Fly"] = 520.78, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 320.39}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 16.65, ["Fly"] = 126.89, ["Ride"] = 77.44, ["Neon"] = 120.75, ["Neon|Ride"] = 320.43, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 738.23}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 9.19}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.25, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 71.91, ["Neon"] = 37.59, ["Neon|Ride"] = 41.47, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.88, ["Mega|Fly"] = 453.68, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 279.38}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.85, ["Neon"] = 10.27, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 134.3, ["Mega|Fly|Ride"] = 479.99}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 33.96, ["Fly"] = 63, ["Ride"] = 31.18, ["Fly|Ride"] = 79.31, ["Neon"] = 202.13, ["Neon|Ride"] = 168.13, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 848.36, ["Mega|Ride"] = 681.75, ["Mega|Fly|Ride"] = 733.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.28, ["Fly"] = 18.09, ["Ride"] = 15.9, ["Fly|Ride"] = 40.2, ["Neon"] = 26.16, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.52, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 198.19, ["Mega|Fly"] = 421.89, ["Mega|Ride"] = 149.35, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.24, ["Fly"] = 37.02, ["Ride"] = 27.64, ["Fly|Ride"] = 56.27, ["Neon"] = 14.44, ["Neon|Ride"] = 44.01, ["Neon|Fly|Ride"] = 128.01, ["Mega"] = 141.62, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 141.68, ["Neon"] = 3.7, ["Mega"] = 52.81, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 26.23, ["Fly"] = 78.74, ["Ride"] = 50.04, ["Fly|Ride"] = 105, ["Neon"] = 945, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 501.64, ["Mega"] = 524.99, ["Mega|Ride"] = 905.1, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 15.88, ["Fly|Ride"] = 65.63, ["Neon"] = 3.7, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 49.71, ["Mega"] = 78.66, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 12.47, ["Ride"] = 80.41, ["Fly|Ride"] = 281.24, ["Neon"] = 65.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Fly|Ride"] = 684.12}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 41.91, ["Neon"] = 16.96, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 48.01, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.94, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 291.38, ["Mega|Ride"] = 421.89, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.91, ["Ride"] = 73.7, ["Neon"] = 88.34, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 35.96, ["Ride"] = 108.94, ["Neon"] = 530.74, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 630}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.54, ["Ride"] = 113.14, ["Neon"] = 99.41, ["Neon|Ride"] = 183.75, ["Mega"] = 328.02, ["Mega|Ride"] = 380.66, ["Mega|Fly|Ride"] = 606.94}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.6, ["Ride"] = 125.99, ["Neon"] = 57.75, ["Neon|Fly"] = 211.47, ["Neon|Ride"] = 422.94, ["Mega|Ride"] = 844.83, ["Mega|Fly|Ride"] = 564.63}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 20.82, ["Ride"] = 69.57, ["Fly|Ride"] = 367.46, ["Neon"] = 107.63, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2114.7, ["Mega|Ride"] = 719.97, ["Mega|Fly|Ride"] = 733.82}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.04, ["Neon"] = 13.57, ["Neon|Ride"] = 80.41, ["Mega"] = 181.89, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 320.39}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 10.59, ["Fly|Ride"] = 42.31, ["Neon"] = 5.95, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 25.39, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 70.86, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.63, ["Fly"] = 50.76, ["Ride"] = 28.55, ["Fly|Ride"] = 69.56, ["Neon"] = 11.05, ["Neon|Ride"] = 88.82, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 74.82, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 15.75, ["Fly|Ride"] = 57.1, ["Neon"] = 5.98, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 42.2, ["Mega|Fly"] = 113.15, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 204.08}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.28, ["Fly|Ride"] = 84, ["Neon"] = 16.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 84.6, ["Mega"] = 253.78, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 6.36, ["Fly"] = 65.63, ["Ride"] = 24.39, ["Fly|Ride"] = 422.9, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 300.3, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.93, ["Fly"] = 131.25, ["Ride"] = 21.74, ["Fly|Ride"] = 70.86, ["Neon"] = 19.39, ["Neon|Fly"] = 113.15, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 292.69, ["Mega|Ride"] = 223.43, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.51, ["Fly"] = 35.48, ["Ride"] = 19.59, ["Fly|Ride"] = 49.88, ["Neon"] = 22.22, ["Neon|Ride"] = 41.86, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 253.78, ["Mega|Ride"] = 152.81, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 5.11, ["Fly"] = 65.63, ["Ride"] = 44.01, ["Fly|Ride"] = 91.86, ["Neon"] = 9.36, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 58.31, ["Neon|Fly|Ride"] = 128.43, ["Mega"] = 118.02, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 128.51, ["Mega|Fly|Ride"] = 237.51}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 17.73, ["Fly"] = 211.45, ["Ride"] = 108.94, ["Fly|Ride"] = 375.16, ["Neon"] = 137.82, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 472.5, ["Mega|Ride"] = 564.63, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.94, ["Fly"] = 164.07, ["Ride"] = 80.41, ["Fly|Ride"] = 181.85, ["Neon"] = 200.49, ["Neon|Ride"] = 259.23, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1332.36, ["Mega|Ride"] = 893.85, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.37, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.02, ["Mega|Ride"] = 47.86, ["Mega|Fly|Ride"] = 145.47}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.08, ["Ride"] = 52.5, ["Mega"] = 686.56, ["Mega|Ride"] = 676.72, ["Mega|Fly|Ride"] = 1116.57}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 46.88, ["Ride"] = 72.19, ["Neon"] = 323.69, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 844.83, ["Mega"] = 1741.46, ["Mega|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 1374.57}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.16, ["Fly"] = 190.32, ["Ride"] = 27.46, ["Fly|Ride"] = 133.88, ["Neon"] = 40.26, ["Neon|Fly"] = 128.43, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 126, ["Mega"] = 161.44, ["Mega|Ride"] = 230.52, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 5.97, ["Ride"] = 68.82, ["Neon"] = 11.44, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 168.13, ["Mega"] = 105, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 211.47, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 25.76, ["Ride"] = 15.65, ["Fly|Ride"] = 57.1, ["Neon"] = 11.43, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 101.42, ["Mega"] = 161.44, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 1.92, ["Fly"] = 16.75, ["Ride"] = 15.23, ["Fly|Ride"] = 42.15, ["Neon"] = 2.63, ["Neon|Fly"] = 30.22, ["Neon|Ride"] = 26.16, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 28.56, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.12, ["Fly|Ride"] = 46.53, ["Neon"] = 3.94, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 39.09, ["Mega|Fly"] = 106.63, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.37, ["Neon|Ride"] = 145.07, ["Mega"] = 28.23, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.22, ["Ride"] = 105, ["Neon"] = 38.99, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 184, ["Mega|Fly|Ride"] = 320.39}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.76, ["Ride"] = 34.13, ["Fly|Ride"] = 208.82, ["Neon"] = 53.72, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 223.13, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.22, ["Fly"] = 20.58, ["Ride"] = 16.7, ["Fly|Ride"] = 37.85, ["Neon"] = 30.19, ["Neon|Fly"] = 57.62, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 355.2, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 349.52}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 60.27, ["Ride"] = 160.82, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 564.63, ["Mega"] = 2399.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.92, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 84.59, ["Neon"] = 133.22, ["Neon|Fly|Ride"] = 630, ["Mega"] = 640.78, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 705.26}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 15.65, ["Fly|Ride"] = 38, ["Neon"] = 2.1, ["Neon|Fly"] = 42.31, ["Neon|Ride"] = 19.95, ["Neon|Fly|Ride"] = 57.11, ["Mega"] = 157.49, ["Mega|Ride"] = 91.58, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.16, ["Ride"] = 14.34, ["Fly|Ride"] = 35.15, ["Neon"] = 4.25, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 19.05, ["Neon|Fly|Ride"] = 43.31, ["Mega"] = 39.38, ["Mega|Fly"] = 121.61, ["Mega|Ride"] = 69.57, ["Mega|Fly|Ride"] = 91.77}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 509.25, ["Ride"] = 439.69, ["Fly|Ride"] = 505.32, ["Neon|Fly|Ride"] = 1890.56}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 8.11, ["Fly"] = 105.74, ["Ride"] = 57.1, ["Fly|Ride"] = 113.14, ["Neon"] = 39.15, ["Neon|Ride"] = 113.15, ["Mega"] = 403.5, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.43, ["Ride"] = 13.95, ["Fly|Ride"] = 32.42, ["Neon"] = 5.15, ["Neon|Fly"] = 18.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 30.44, ["Mega|Ride"] = 78.25, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.85, ["Ride"] = 97.95, ["Fly|Ride"] = 261.19, ["Neon"] = 240.85, ["Neon|Ride"] = 331.47, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 735, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 878.37}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.18, ["Fly|Ride"] = 39.37, ["Neon"] = 12.16, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.51, ["Neon|Fly|Ride"] = 70.66, ["Mega"] = 118.13, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 184.21}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 2.24, ["Neon|Fly"] = 99.41, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 74.96, ["Mega"] = 18.38, ["Mega|Ride"] = 75.09, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.35, ["Fly"] = 128, ["Ride"] = 78.72, ["Neon"] = 160.13, ["Neon|Ride"] = 157.31, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 800.37, ["Mega|Ride"] = 634.41, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.17, ["Fly|Ride"] = 146.99, ["Neon"] = 6.71, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.25, ["Mega"] = 25.99, ["Mega|Ride"] = 150.64, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 26.23, ["Ride"] = 69.57, ["Fly|Ride"] = 120.54, ["Neon"] = 422.94, ["Neon|Ride"] = 246.78, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1670.62, ["Mega|Ride"] = 1691.76, ["Mega|Fly|Ride"] = 1691.76}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.61, ["Fly"] = 70.86, ["Ride"] = 131.24, ["Fly|Ride"] = 422.9, ["Neon"] = 17.06, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 493.79, ["Mega"] = 232.8, ["Mega|Ride"] = 190.34, ["Mega|Fly|Ride"] = 317.22}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 70.86, ["Ride"] = 72.76, ["Fly|Ride"] = 70.86, ["Neon"] = 7.86, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 103.64, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.75, ["Fly"] = 141.68, ["Ride"] = 59.19, ["Fly|Ride"] = 131.25, ["Mega|Ride"] = 1691.76, ["Mega|Fly|Ride"] = 1965.63}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 438.76, ["Ride"] = 38.07, ["Neon"] = 4.9, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 157.2, ["Mega"] = 42, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 227.43}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 20.06, ["Ride"] = 19.49, ["Fly|Ride"] = 102.88, ["Neon"] = 10.18, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 72.02, ["Mega"] = 160.81, ["Mega|Fly"] = 147.6, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.48, ["Fly"] = 57.91, ["Ride"] = 32.73, ["Fly|Ride"] = 112.08, ["Neon"] = 79.37, ["Neon|Ride"] = 88.82, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 300.57, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 10.5, ["Ride"] = 30.11, ["Fly|Ride"] = 73.5, ["Neon"] = 72.19, ["Neon|Ride"] = 75.09, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 480.05, ["Mega|Ride"] = 288.46, ["Mega|Fly|Ride"] = 545.61}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 20.68, ["Fly"] = 28.55, ["Ride"] = 28.08, ["Fly|Ride"] = 53.34, ["Neon"] = 74.28, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 122.04, ["Mega"] = 393.36, ["Mega|Ride"] = 323.53, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 64.32, ["Ride"] = 114.02, ["Fly|Ride"] = 248.47, ["Neon"] = 372.2, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 422.94, ["Mega|Ride"] = 1497.22, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.55, ["Ride"] = 70.86, ["Neon"] = 28.91, ["Neon|Ride"] = 113.15, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 234.31, ["Mega|Ride"] = 296.15, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.89, ["Ride"] = 27.09, ["Fly|Ride"] = 70.86, ["Neon"] = 19.01, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 262.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.56, ["Fly"] = 287.55, ["Ride"] = 28.75, ["Fly|Ride"] = 155.36, ["Neon"] = 57.62, ["Neon|Ride"] = 84.6, ["Mega"] = 448.79, ["Mega|Ride"] = 592.13, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 14.81, ["Ride"] = 15.65, ["Fly|Ride"] = 37.21, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 15.53, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.47, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 95.76}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 51.18, ["Ride"] = 112.56, ["Fly|Ride"] = 282.3, ["Neon"] = 236.24, ["Neon|Fly"] = 2397.02, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 1056.3, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 141.68, ["Neon"] = 4.86, ["Neon|Ride"] = 28.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.49, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 18.8, ["Fly|Ride"] = 59.06, ["Neon"] = 19.49, ["Neon|Ride"] = 27.61, ["Neon|Fly|Ride"] = 90.04, ["Mega"] = 257.25, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 57.75, ["Ride"] = 92.6, ["Fly|Ride"] = 229.87, ["Neon"] = 229.69, ["Neon|Fly"] = 306.65, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 776.1, ["Mega"] = 940.75, ["Mega|Ride"] = 1363.14, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.5, ["Neon"] = 5.78, ["Neon|Ride"] = 1410.51, ["Mega"] = 69.57, ["Mega|Ride"] = 108.34, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.03}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 495.07, ["Neon"] = 6.4, ["Neon|Ride"] = 52.41, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 42.86, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.76, ["Ride"] = 162.93, ["Fly|Ride"] = 353.13, ["Neon"] = 705.26, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 800.45, ["Mega"] = 3383.52, ["Mega|Fly|Ride"] = 2670.88}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.26, ["Ride"] = 36.47, ["Fly|Ride"] = 211.45, ["Neon"] = 20.36, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 101.5, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 35.96, ["Neon"] = 2.1, ["Neon|Ride"] = 20.87, ["Mega"] = 31.4, ["Mega|Ride"] = 57.11, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.61, ["Ride"] = 21.98, ["Fly|Ride"] = 49.88, ["Neon"] = 53.37, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 409.21, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 635.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 12.69, ["Fly"] = 43.58, ["Ride"] = 21.16, ["Fly|Ride"] = 56.58, ["Neon"] = 72.17, ["Neon|Ride"] = 157.65, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 619.8, ["Mega|Ride"] = 592.13, ["Mega|Fly|Ride"] = 400.79}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.82, ["Ride"] = 58.69, ["Fly|Ride"] = 197.71, ["Neon"] = 132.96, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 479.99, ["Mega"] = 561.75, ["Mega|Ride"] = 536.72, ["Mega|Fly|Ride"] = 599.82}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 116.82, ["Fly"] = 196.77, ["Ride"] = 141.65, ["Fly|Ride"] = 225.64, ["Neon"] = 565.13, ["Neon|Fly"] = 845.88, ["Neon|Ride"] = 564.63, ["Neon|Fly|Ride"] = 656.15, ["Mega|Ride"] = 2537.64, ["Mega|Fly|Ride"] = 2812.56}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 6.41, ["Fly"] = 17.46, ["Ride"] = 17.07, ["Fly|Ride"] = 43.78, ["Neon"] = 38.56, ["Neon|Fly"] = 60.02, ["Neon|Ride"] = 32.72, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 353.17}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.6, ["Fly"] = 131.23, ["Ride"] = 16.93, ["Fly|Ride"] = 131.24, ["Neon"] = 16.78, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 141.7, ["Mega|Ride"] = 138.53, ["Mega|Fly|Ride"] = 400.79}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.86, ["Fly"] = 98.44, ["Ride"] = 28.03, ["Fly|Ride"] = 91.88, ["Neon"] = 48.54, ["Neon|Ride"] = 70.91, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 393.75, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 44.62, ["Fly"] = 99.4, ["Ride"] = 70.88, ["Fly|Ride"] = 156.49, ["Neon"] = 203.44, ["Neon|Ride"] = 206.2, ["Neon|Fly|Ride"] = 224.89, ["Mega"] = 954.19, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1037}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.18, ["Fly"] = 57.75, ["Ride"] = 63.67, ["Neon"] = 105, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 466.31, ["Mega"] = 708.65, ["Mega|Ride"] = 845.88, ["Mega|Fly|Ride"] = 1127.15}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 301.67, ["Ride"] = 480.02, ["Neon|Ride"] = 3200.56}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 21.14, ["Fly"] = 35.8, ["Ride"] = 31.5, ["Fly|Ride"] = 69.57, ["Neon"] = 421.85, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 197.74, ["Mega"] = 761.25, ["Mega|Ride"] = 730.96, ["Mega|Fly|Ride"] = 1057.35}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.11, ["Ride"] = 13.69, ["Fly|Ride"] = 42.37, ["Neon"] = 2.1, ["Neon|Ride"] = 15.18, ["Neon|Fly|Ride"] = 72.02, ["Mega"] = 20.76, ["Mega|Fly"] = 103.64, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.62, ["Ride"] = 10.59, ["Neon"] = 6.18, ["Neon|Ride"] = 42.28, ["Neon|Fly|Ride"] = 139.58, ["Mega"] = 94.96, ["Mega|Ride"] = 111.43, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.92, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 19.57, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 53.92, ["Neon|Fly|Ride"] = 986.52, ["Mega"] = 121.7, ["Mega|Fly"] = 493.79, ["Mega|Ride"] = 129.83, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 423.94, ["Fly"] = 493.74, ["Ride"] = 405.85, ["Fly|Ride"] = 466.25, ["Neon"] = 1968.75, ["Neon|Ride"] = 3172.05, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 5273.01}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.63, ["Fly"] = 37.97, ["Ride"] = 15.39, ["Fly|Ride"] = 61.34, ["Neon"] = 19.69, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 183.54, ["Mega|Ride"] = 213.94, ["Mega|Fly|Ride"] = 253.78}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 4.25, ["Fly"] = 20.1, ["Ride"] = 15.63, ["Fly|Ride"] = 39.38, ["Neon"] = 15.88, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 59.22, ["Neon|Fly|Ride"] = 91.79, ["Mega|Ride"] = 279.16, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.29, ["Fly"] = 41.91, ["Ride"] = 21.17, ["Fly|Ride"] = 78.75, ["Neon"] = 13, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 84.6, ["Mega"] = 104.74, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.16, ["Fly"] = 47.85, ["Ride"] = 26.25, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 316.16, ["Mega"] = 564.63, ["Mega|Ride"] = 844.83, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 52.87, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 9.19, ["Neon|Ride"] = 32.42, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1015.07}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.99, ["Fly"] = 65.6, ["Ride"] = 27.12, ["Fly|Ride"] = 97.55, ["Neon"] = 186.38, ["Neon|Ride"] = 108.92, ["Neon|Fly|Ride"] = 353.17, ["Mega|Ride"] = 776.1}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 3.68, ["Neon|Ride"] = 141.7, ["Mega"] = 51.1, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 8.48, ["Ride"] = 141.68, ["Neon"] = 50.8, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.47, ["Ride"] = 86.7, ["Neon"] = 90.97, ["Neon|Ride"] = 282.32, ["Mega"] = 311.93, ["Mega|Ride"] = 586.57, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.88, ["Fly"] = 25.91, ["Ride"] = 24.46, ["Fly|Ride"] = 48.37, ["Neon"] = 36.16, ["Neon|Fly"] = 120.02, ["Neon|Ride"] = 54.91, ["Neon|Fly|Ride"] = 80.57, ["Mega"] = 563.98, ["Mega|Ride"] = 240, ["Mega|Fly|Ride"] = 302.57}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 341.25, ["Fly"] = 597.8, ["Ride"] = 411.23, ["Fly|Ride"] = 425.15, ["Neon"] = 1640.63, ["Neon|Ride"] = 1573.51, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 7472.29}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 40.68, ["Neon"] = 15.65, ["Neon|Fly"] = 80.41, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 49.71, ["Mega"] = 247.44, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 301.2}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.63, ["Fly"] = 113.14, ["Ride"] = 43.2, ["Fly|Ride"] = 131.25, ["Neon"] = 57.74, ["Neon|Ride"] = 122.03, ["Neon|Fly|Ride"] = 283.39, ["Mega"] = 378.29, ["Mega|Fly"] = 705.26, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 497.98}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 20.88, ["Fly"] = 118.13, ["Ride"] = 71.51, ["Fly|Ride"] = 276.52, ["Neon"] = 120.65, ["Neon|Ride"] = 157.61, ["Neon|Fly|Ride"] = 353.17, ["Mega"] = 422.94, ["Mega|Ride"] = 352.46, ["Mega|Fly|Ride"] = 513.24}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 45.93, ["Fly"] = 146.86, ["Ride"] = 70.79, ["Fly|Ride"] = 157.5, ["Neon"] = 320.25, ["Neon|Ride"] = 282.32, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1903.23, ["Mega|Fly|Ride"] = 1678.02}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.18, ["Fly"] = 105.74, ["Ride"] = 52.5, ["Fly|Ride"] = 131.24, ["Neon"] = 32.82, ["Neon|Fly"] = 96.02, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 163.76, ["Mega|Ride"] = 257.25, ["Mega|Fly|Ride"] = 353.75}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 16.93, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 13.02, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 126.93, ["Mega"] = 65.62, ["Mega|Ride"] = 160.81, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.41, ["Ride"] = 28.55, ["Neon"] = 19.69, ["Neon|Ride"] = 105.73, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 101.07, ["Mega|Fly|Ride"] = 294.53}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.69, ["Fly"] = 137.8, ["Ride"] = 65.54, ["Fly|Ride"] = 216.57, ["Neon"] = 111.56, ["Neon|Ride"] = 141.37, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 418.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 6.36, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 202.04, ["Mega"] = 49.14, ["Mega|Fly"] = 169.32, ["Mega|Ride"] = 185.05, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 21.16, ["Ride"] = 211.45, ["Neon"] = 131.25, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 845.88, ["Mega"] = 492.19, ["Mega|Fly|Ride"] = 685.65}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.5, ["Fly"] = 1004.07, ["Ride"] = 1018.5, ["Fly|Ride"] = 1152.38, ["Neon"] = 3488.2, ["Neon|Ride"] = 3637.29, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 10292.23}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.44, ["Fly"] = 120.65, ["Ride"] = 57.3, ["Fly|Ride"] = 141.68, ["Neon"] = 59.85, ["Neon|Fly"] = 707.44, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 326.49, ["Mega|Ride"] = 328.27, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 22.75, ["Fly|Ride"] = 90.55, ["Neon"] = 6.55, ["Neon|Fly"] = 42.31, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 60.38, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 163.9}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.96, ["Ride"] = 57.1, ["Fly|Ride"] = 141.68, ["Neon"] = 57.68, ["Neon|Fly"] = 83.54, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 411.92, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 184.03, ["Neon"] = 2.63, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 15.94, ["Mega|Ride"] = 38.19, ["Mega|Fly|Ride"] = 169.19}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 53.15, ["Ride"] = 102.38, ["Fly|Ride"] = 236.24, ["Neon"] = 234.94, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 361.77, ["Mega"] = 918.75, ["Mega|Ride"] = 1038.98, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.64, ["Ride"] = 62.91, ["Fly|Ride"] = 282.3, ["Neon"] = 83.91, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 480.05, ["Mega|Ride"] = 592.13, ["Mega|Fly|Ride"] = 634.41}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.57, ["Neon"] = 6.39, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 466.31}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 15.74, ["Fly"] = 52.5, ["Ride"] = 32.82, ["Fly|Ride"] = 112.08, ["Neon"] = 50.96, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 1039.5, ["Mega|Ride"] = 351.05, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.13, ["Fly"] = 32.8, ["Ride"] = 31.49, ["Fly|Ride"] = 45.94, ["Neon"] = 119.44, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 130.35, ["Mega"] = 319.14, ["Mega|Ride"] = 226.28, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 33.27, ["Ride"] = 208.69, ["Neon"] = 163.9, ["Neon|Ride"] = 549.94, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2114.7, ["Mega|Ride"] = 2397.02, ["Mega|Fly|Ride"] = 1689.65}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 4.79, ["Ride"] = 48.27, ["Fly|Ride"] = 184.11, ["Neon"] = 13.6, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 118.13, ["Mega|Ride"] = 218.88, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 8.24, ["Fly"] = 27.5, ["Ride"] = 20.41, ["Fly|Ride"] = 89.25, ["Neon"] = 44.02, ["Neon|Fly"] = 184, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 91.77, ["Mega"] = 283.64, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 634.41}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 105.48, ["Fly"] = 393.75, ["Ride"] = 184.78, ["Fly|Ride"] = 236.25, ["Neon"] = 441, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 409.19, ["Neon|Fly|Ride"] = 649.67, ["Mega|Ride"] = 2537.64, ["Mega|Fly|Ride"] = 2181.15}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 14.44, ["Fly|Ride"] = 55.04, ["Neon"] = 11.12, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 71.74, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 206.28}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 15.26, ["Fly"] = 200.81, ["Ride"] = 38.66, ["Fly|Ride"] = 116.82, ["Neon"] = 100.85, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 522.47}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 13.13, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 27.62, ["Neon|Ride"] = 15.47, ["Neon|Fly|Ride"] = 39.64, ["Mega"] = 15.73, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 33.48, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.1, ["Fly|Ride"] = 39.38, ["Neon"] = 3.51, ["Neon|Ride"] = 42.31, ["Neon|Fly|Ride"] = 131.13, ["Mega"] = 22.32, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 168.13}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 35.96, ["Ride"] = 24.02, ["Fly|Ride"] = 133.88, ["Neon"] = 11.57, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 84.6, ["Mega"] = 85.32, ["Mega|Ride"] = 268.58, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 32.81, ["Ride"] = 54.98, ["Fly|Ride"] = 131.25, ["Neon"] = 181.73, ["Neon|Ride"] = 338.37, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 506.76, ["Mega|Ride"] = 719.01}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.88, ["Ride"] = 15.88, ["Fly|Ride"] = 36.96, ["Neon"] = 11.82, ["Neon|Fly"] = 21.16, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 55.2, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.35, ["Fly"] = 30.19, ["Ride"] = 24.94, ["Fly|Ride"] = 96.02, ["Neon"] = 30.19, ["Neon|Fly"] = 55.88, ["Neon|Ride"] = 38.84, ["Neon|Fly|Ride"] = 113.15, ["Mega"] = 231, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 305.34}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 18.09, ["Fly|Ride"] = 71.91, ["Neon"] = 8.88, ["Neon|Fly"] = 70.86, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 78.25, ["Mega|Fly"] = 80.41, ["Mega|Ride"] = 63.46, ["Mega|Fly|Ride"] = 125.9}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.71, ["Fly"] = 159.66, ["Ride"] = 23.15, ["Fly|Ride"] = 217.19, ["Neon"] = 37.29, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 232.02, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 380.66, ["Mega|Fly|Ride"] = 441.59}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.88, ["Fly"] = 42.31, ["Ride"] = 36.75, ["Neon"] = 65.63, ["Neon|Ride"] = 144.38, ["Mega"] = 682.5, ["Mega|Fly|Ride"] = 987.57}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 6.57, ["Fly"] = 10.59, ["Ride"] = 15.74, ["Fly|Ride"] = 49.1, ["Neon"] = 21, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 38.64, ["Neon|Fly|Ride"] = 104.69, ["Mega"] = 240, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 564.63}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 16.7, ["Ride"] = 14.66, ["Fly|Ride"] = 52.45, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.5, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 185.05, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 156.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 191.44, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1228.87, ["Neon|Ride"] = 1128.2, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.81, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 141.7, ["Mega"] = 122.07, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 353.17}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.68, ["Fly"] = 106.16, ["Ride"] = 22.25, ["Fly|Ride"] = 84.59, ["Neon"] = 23.39, ["Neon|Fly"] = 240.03, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 207.8, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 493.79}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.45, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 224.17, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 1.81, ["Fly"] = 16.17, ["Ride"] = 15.08, ["Fly|Ride"] = 32.34, ["Neon"] = 3.94, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 41.26, ["Mega"] = 18.21, ["Mega|Fly"] = 78.25, ["Mega|Ride"] = 42.19, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.62, ["Fly"] = 26.25, ["Ride"] = 16.52, ["Fly|Ride"] = 46.53, ["Neon"] = 14.04, ["Neon|Ride"] = 28.56, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 116.94, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 183.65}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.52, ["Ride"] = 141.68, ["Neon"] = 8.55, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 43.31, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 253.78}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 70.87, ["Fly"] = 104.99, ["Ride"] = 104.89, ["Fly|Ride"] = 175.23, ["Neon"] = 385.88, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 421.89, ["Mega|Ride"] = 3526.27, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.75, ["Fly"] = 94.5, ["Ride"] = 26.23, ["Fly|Ride"] = 99.4, ["Neon"] = 23.37, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 341.54}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 48.65, ["Ride"] = 34.12, ["Neon"] = 5.55, ["Neon|Ride"] = 80.94, ["Neon|Fly|Ride"] = 542.29, ["Mega"] = 66.94, ["Mega|Fly"] = 315, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.57, ["Fly"] = 210, ["Ride"] = 91.88, ["Fly|Ride"] = 207.23, ["Neon"] = 170.63, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 637.88}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 14.44, ["Fly|Ride"] = 32.04, ["Neon"] = 3.29, ["Neon|Fly"] = 16.7, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 19.58, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 32.93, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 105.74, ["Neon"] = 3.65, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 285.32, ["Mega"] = 24.33, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 176.06}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.31, ["Ride"] = 47.16, ["Neon"] = 10.31, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 53.72, ["Mega|Fly"] = 184, ["Mega|Ride"] = 114.75, ["Mega|Fly|Ride"] = 210.78}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 12.3, ["Fly"] = 80.07, ["Ride"] = 50.18, ["Fly|Ride"] = 128.33, ["Neon"] = 16.93, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 92.48, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 104.81, ["Mega|Fly"] = 344.4, ["Mega|Ride"] = 171.71, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 14.21, ["Fly|Ride"] = 32.42, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 21.06, ["Neon|Fly|Ride"] = 44.35, ["Mega"] = 18.36, ["Mega|Ride"] = 62.41, ["Mega|Fly|Ride"] = 78.4}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.16, ["Fly"] = 131.25, ["Ride"] = 45.94, ["Neon"] = 129.94, ["Neon|Fly"] = 422.94, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 502.26, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 736.78}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2231.25, ["Fly"] = 3150, ["Ride"] = 2208.93, ["Fly|Ride"] = 2248.16, ["Neon"] = 10573.48, ["Neon|Fly|Ride"] = 9727.6, ["Mega|Fly|Ride"] = 42292.85}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 17.01, ["Ride"] = 15.74, ["Fly|Ride"] = 32.8, ["Neon"] = 9.01, ["Neon|Fly"] = 58.52, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 78.75, ["Mega|Fly"] = 422.94, ["Mega|Ride"] = 83.92, ["Mega|Fly|Ride"] = 141.7}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 8.3, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 160.81, ["Mega|Fly|Ride"] = 282.32}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 16.37, ["Fly"] = 42.31, ["Ride"] = 25.09, ["Fly|Ride"] = 120.02, ["Neon"] = 73.48, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 459.38, ["Mega|Ride"] = 395.88, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.57, ["Fly"] = 90.93, ["Ride"] = 63.2, ["Neon"] = 187.69, ["Neon|Ride"] = 190.32, ["Mega"] = 421.4, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.11, ["Fly"] = 211.45, ["Ride"] = 156.18, ["Fly|Ride"] = 251.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 714.66, ["Neon|Fly|Ride"] = 701.01, ["Mega"] = 6344.09, ["Mega|Fly|Ride"] = 3750.44}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.46, ["Ride"] = 32.8, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 83.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Fly|Ride"] = 359.51}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.25, ["Ride"] = 35.44, ["Neon"] = 19.05, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 102, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.39, ["Neon|Fly"] = 92.01, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 73.5, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.01, ["Ride"] = 84.59, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 173.42, ["Neon|Fly|Ride"] = 498.03, ["Mega"] = 383.99, ["Mega|Ride"] = 466.31, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.31, ["Neon"] = 2.1, ["Neon|Ride"] = 33.86, ["Mega"] = 15.75, ["Mega|Fly"] = 120.01, ["Mega|Ride"] = 79.97, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 78.75, ["Fly"] = 104.9, ["Ride"] = 104.98, ["Fly|Ride"] = 141.68, ["Neon"] = 301.46, ["Neon|Fly"] = 422.94, ["Neon|Ride"] = 403.31, ["Neon|Fly|Ride"] = 305.29, ["Mega"] = 3172.05, ["Mega|Fly|Ride"] = 1685.42}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 91.83, ["Neon"] = 2.96, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 70.88, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 28.87, ["Fly"] = 101.51, ["Ride"] = 65.62, ["Fly|Ride"] = 187.69, ["Neon"] = 255.94, ["Neon|Ride"] = 338.37, ["Neon|Fly|Ride"] = 457.32, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 2519.68}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 21.17, ["Fly|Ride"] = 51.64, ["Neon"] = 3.68, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 42, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 142.8}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.91, ["Neon"] = 12.99, ["Neon|Ride"] = 98.44, ["Mega"] = 131.25, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 523.36}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.86, ["Fly"] = 77.43, ["Ride"] = 32.8, ["Neon"] = 23.63, ["Neon|Ride"] = 86.52, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 320.39, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 562.52}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 353.07, ["Ride"] = 391.96, ["Fly|Ride"] = 463.77, ["Neon"] = 966.96, ["Neon|Ride"] = 964.69, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3102.27, ["Mega|Ride"] = 2802.19, ["Mega|Fly|Ride"] = 2739.51}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 26.16, ["Fly"] = 57.1, ["Ride"] = 45.45, ["Fly|Ride"] = 126.93, ["Neon"] = 161.44, ["Neon|Ride"] = 210.42, ["Neon|Fly|Ride"] = 317.63, ["Mega"] = 1408.4, ["Mega|Ride"] = 1128.2, ["Mega|Fly|Ride"] = 1691.76}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.59, ["Fly|Ride"] = 111.57, ["Neon"] = 12.58, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.07, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 128.35, ["Mega|Ride"] = 197.74, ["Mega|Fly|Ride"] = 314.88}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 22.31, ["Fly"] = 39.29, ["Ride"] = 49.87, ["Fly|Ride"] = 163.88, ["Neon"] = 71.31, ["Neon|Fly"] = 160.82, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 183.65, ["Mega"] = 255.94, ["Mega|Fly"] = 422.94, ["Mega|Ride"] = 380.66, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 8.47, ["Ride"] = 25.86, ["Neon"] = 101.35, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 253.78, ["Mega"] = 422.94, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.94, ["Neon"] = 19.59, ["Mega"] = 91.77, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 371.15}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.94, ["Fly"] = 70.88, ["Ride"] = 20.96, ["Fly|Ride"] = 59.41, ["Neon"] = 32.05, ["Neon|Ride"] = 50.16, ["Mega"] = 160.13, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 96.02, ["Fly"] = 208.82, ["Ride"] = 129.94, ["Fly|Ride"] = 176.57, ["Neon"] = 789.86, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3520.61, ["Mega|Fly|Ride"] = 3242.9}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 24.51, ["Ride"] = 42, ["Fly|Ride"] = 91.88, ["Neon"] = 131.25, ["Neon|Ride"] = 226.28, ["Neon|Fly|Ride"] = 211.47, ["Mega"] = 567.16, ["Mega|Ride"] = 705.26, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1763.87, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 1785, ["Neon"] = 11277.38, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.51, ["Fly"] = 65625, ["Ride"] = 57.3, ["Fly|Ride"] = 196.87, ["Neon"] = 12.99, ["Neon|Fly|Ride"] = 634.41, ["Mega"] = 116.74, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 172.57, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 5.9, ["Ride"] = 57.1, ["Fly|Ride"] = 176.57, ["Neon"] = 27.57, ["Neon|Ride"] = 90.56, ["Mega"] = 138.36, ["Mega|Ride"] = 320.39, ["Mega|Fly|Ride"] = 409.21}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 813.65, ["Fly"] = 1107.73, ["Ride"] = 822.93, ["Fly|Ride"] = 866.25, ["Neon"] = 2778.57, ["Neon|Ride"] = 2582.57, ["Neon|Fly|Ride"] = 2494.79, ["Mega"] = 13951.72, ["Mega|Fly|Ride"] = 11525.1}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 32.8, ["Ride"] = 49.79, ["Fly|Ride"] = 173.35, ["Neon"] = 183.98, ["Neon|Ride"] = 153.63, ["Neon|Fly|Ride"] = 353.17, ["Mega"] = 849.97, ["Mega|Ride"] = 633.94, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.34, ["Ride"] = 23.44, ["Fly|Ride"] = 124.77, ["Neon"] = 6.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 316.16, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 141.68, ["Neon"] = 4.07, ["Neon|Ride"] = 49.14, ["Neon|Fly|Ride"] = 103.64, ["Mega"] = 19.38, ["Mega|Ride"] = 78.25, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 98.44, ["Ride"] = 129.94, ["Fly|Ride"] = 170.63, ["Neon"] = 444.04, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 634.1, ["Mega"] = 2399.88, ["Mega|Fly|Ride"] = 2114.7}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.01, ["Fly|Ride"] = 74.03, ["Neon"] = 16.05, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 107.62, ["Mega|Ride"] = 122.05, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.62, ["Fly"] = 99.4, ["Ride"] = 114.7, ["Fly|Ride"] = 240, ["Neon"] = 459.38, ["Neon|Ride"] = 421.89, ["Mega|Fly|Ride"] = 1691.76}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.5, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.25, ["Neon|Ride"] = 211.47, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 314.9, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 234.82, ["Fly"] = 380.61, ["Ride"] = 287.2, ["Fly|Ride"] = 322.1, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.04, ["Mega|Fly|Ride"] = 4648.11}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.93, ["Fly"] = 91.88, ["Ride"] = 16.49, ["Fly|Ride"] = 49.88, ["Neon"] = 28.77, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.77, ["Mega|Ride"] = 168, ["Mega|Fly|Ride"] = 257.27}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 15.1, ["Ride"] = 15.88, ["Fly|Ride"] = 34.13, ["Neon"] = 4.23, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 57.11, ["Mega"] = 42, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1266.57, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7754.6, ["Neon|Fly|Ride"] = 6626.41, ["Mega"] = 23518.67, ["Mega|Fly|Ride"] = 28196.3}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.2, ["Fly"] = 169.17, ["Ride"] = 72.19, ["Neon"] = 70.96, ["Neon|Ride"] = 126.9, ["Mega"] = 244.59, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 7.39, ["Fly"] = 39.38, ["Ride"] = 48.57, ["Fly|Ride"] = 100.17, ["Neon"] = 19.67, ["Neon|Fly"] = 57.11, ["Neon|Ride"] = 53.5, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 140.6, ["Mega|Ride"] = 254, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 26.16, ["Fly"] = 33.95, ["Ride"] = 32.41, ["Fly|Ride"] = 68.25, ["Neon"] = 146.97, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 2537.64, ["Mega|Ride"] = 1120.75, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.54, ["Fly"] = 90.93, ["Ride"] = 28.86, ["Fly|Ride"] = 78.75, ["Neon"] = 57.26, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 227.31, ["Mega"] = 367.4, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 47.92, ["Ride"] = 100.45, ["Fly|Ride"] = 412.34, ["Neon"] = 204.65, ["Neon|Ride"] = 311.93, ["Neon|Fly|Ride"] = 536.09, ["Mega"] = 845.88, ["Mega|Ride"] = 839.55, ["Mega|Fly|Ride"] = 815.22}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 282.3, ["Neon"] = 2.47, ["Neon|Fly"] = 57.11, ["Neon|Ride"] = 113.3, ["Neon|Fly|Ride"] = 105.75, ["Mega"] = 16.75, ["Mega|Fly"] = 72.14, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 78.49, ["Fly"] = 126.89, ["Ride"] = 90.56, ["Fly|Ride"] = 181.13, ["Neon"] = 446.24, ["Neon|Fly"] = 667.21, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 489.57, ["Mega"] = 3383.52, ["Mega|Fly|Ride"] = 1666.77}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 3.94, ["Fly"] = 107.62, ["Ride"] = 24.94, ["Fly|Ride"] = 67.37, ["Neon"] = 198.19, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 169.19, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.55, ["Ride"] = 18.38, ["Fly|Ride"] = 39.35, ["Neon"] = 19.59, ["Neon|Fly"] = 80.41, ["Neon|Ride"] = 70.86, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16, ["Neon|Fly"] = 139.58, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 200.91, ["Mega|Fly|Ride"] = 479.99}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.49, ["Ride"] = 160.82, ["Fly|Ride"] = 301.88, ["Neon"] = 328.13, ["Neon|Ride"] = 364.83, ["Neon|Fly|Ride"] = 422.94, ["Mega"] = 1691.76, ["Mega|Ride"] = 1452.82, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.62, ["Fly|Ride"] = 422.9, ["Neon"] = 17.12, ["Neon|Ride"] = 59.07, ["Mega"] = 126.88, ["Mega|Ride"] = 211.47, ["Mega|Fly|Ride"] = 280.26}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.16, ["Ride"] = 36.66, ["Neon"] = 2.63, ["Neon|Ride"] = 117.62, ["Neon|Fly|Ride"] = 70.86, ["Mega"] = 16.75, ["Mega|Ride"] = 192.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 35.96, ["Fly|Ride"] = 141.68, ["Neon"] = 2.1, ["Neon|Ride"] = 23.28, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 18.38, ["Mega|Ride"] = 63.46, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.04, ["Fly|Ride"] = 49.71, ["Neon"] = 5.13, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 230.9}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.14, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 15.75, ["Fly|Ride"] = 30.19, ["Neon"] = 10.07, ["Neon|Fly"] = 212.42, ["Neon|Ride"] = 31.74, ["Neon|Fly|Ride"] = 74.87, ["Mega"] = 170.63, ["Mega|Ride"] = 120.37, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 60.47, ["Ride"] = 101.73, ["Fly|Ride"] = 278.07, ["Neon"] = 211.47, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1057.35, ["Mega"] = 695.63, ["Mega|Ride"] = 756.97, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.68, ["Ride"] = 15.74, ["Fly|Ride"] = 42.63, ["Neon"] = 2.52, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 42.19, ["Mega"] = 35.44, ["Mega|Ride"] = 118.28, ["Mega|Fly|Ride"] = 96.01}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.59, ["Fly"] = 79.31, ["Ride"] = 23.83, ["Fly|Ride"] = 71.34, ["Neon"] = 28.56, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 300.57, ["Mega|Fly"] = 329.91, ["Mega|Ride"] = 301.77, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 18.14, ["Fly"] = 39.37, ["Ride"] = 40.43, ["Fly|Ride"] = 104.99, ["Neon"] = 141.95, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 620.68, ["Mega|Ride"] = 670.38, ["Mega|Fly|Ride"] = 557.82}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 7.08, ["Fly"] = 196.88, ["Neon"] = 73.5, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.28, ["Ride"] = 13.13, ["Fly|Ride"] = 32.82, ["Neon"] = 3.92, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 34.12, ["Mega|Ride"] = 38.66, ["Mega|Fly|Ride"] = 108.06}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.83, ["Fly"] = 78.25, ["Ride"] = 37.97, ["Fly|Ride"] = 51.64, ["Neon"] = 27.55, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 113.15, ["Mega"] = 170.63, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 211.47}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 980.42, ["Fly"] = 1360.85, ["Ride"] = 931.88, ["Fly|Ride"] = 1056.57, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2415, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 136.4, ["Ride"] = 238.95, ["Fly|Ride"] = 634.34, ["Neon"] = 649.15, ["Neon|Ride"] = 776.1, ["Neon|Fly|Ride"] = 916.73, ["Mega"] = 3171, ["Mega|Ride"] = 3526.27, ["Mega|Fly|Ride"] = 2520}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 3.9, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 205.14, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1128.2}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 82.58, ["Ride"] = 164.07, ["Fly|Ride"] = 262.49, ["Neon"] = 392.44, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 682.17, ["Mega"] = 1918.04, ["Mega|Ride"] = 1856.31, ["Mega|Fly|Ride"] = 1808.16}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 4.76, ["Ride"] = 21.16, ["Neon"] = 17.53, ["Neon|Fly"] = 56.42, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 282.32, ["Mega"] = 118.12, ["Mega|Ride"] = 353.47, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 240, ["Fly"] = 331.98, ["Ride"] = 248.07, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1255.08, ["Neon|Fly|Ride"] = 1280.48, ["Mega|Fly|Ride"] = 4892.36}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.25, ["Fly|Ride"] = 213.99, ["Neon"] = 31.5, ["Neon|Fly"] = 49.71, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 354.23, ["Mega|Ride"] = 564.63}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Fly"] = 15.88, ["Ride"] = 19.04, ["Fly|Ride"] = 26.25, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 26.25, ["Ride"] = 61.07, ["Fly|Ride"] = 152.42, ["Neon"] = 115.4, ["Neon|Fly"] = 422.94, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 192.03, ["Mega"] = 466.31, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 863.97}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 25.39, ["Neon|Ride"] = 196.87, ["Mega"] = 229.21, ["Mega|Ride"] = 253.32, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.15, ["Ride"] = 13.86, ["Fly|Ride"] = 28.41, ["Neon"] = 3.26, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 18.01, ["Neon|Fly|Ride"] = 35.12, ["Mega"] = 21.79, ["Mega|Ride"] = 35.97, ["Mega|Fly|Ride"] = 65.01}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.65, ["Ride"] = 5118.75, ["Fly|Ride"] = 4725, ["Neon"] = 31716.63, ["Neon|Fly|Ride"] = 19293.75, ["Mega|Fly|Ride"] = 159991.68}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.56, ["Fly"] = 84.59, ["Ride"] = 56.28, ["Neon"] = 53.45, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 215.04, ["Mega|Fly|Ride"] = 422.94}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 16.93, ["Fly|Ride"] = 42, ["Neon"] = 13.83, ["Neon|Fly"] = 28.56, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 100.5, ["Mega"] = 131.25, ["Mega|Ride"] = 95.18, ["Mega|Fly|Ride"] = 181.89}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 393.75, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 531.57, ["Neon"] = 1593.44, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1287.8, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.08, ["Ride"] = 33.78, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 141.74, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 6.56, ["Fly"] = 4227.84, ["Ride"] = 36.7, ["Neon"] = 21.16, ["Neon|Fly"] = 117.37, ["Neon|Ride"] = 51.62, ["Neon|Fly|Ride"] = 303.48, ["Mega"] = 421.89, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 493.79}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.95, ["Ride"] = 18.01, ["Fly|Ride"] = 42.02, ["Neon"] = 4.92, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.76, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 40.69, ["Mega|Ride"] = 66.94, ["Mega|Fly|Ride"] = 275.62}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Fly"] = 748.53, ["Ride"] = 612.9, ["Fly|Ride"] = 677.25, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2397.02, ["Mega|Fly|Ride"] = 9164.04}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 9.19, ["Fly"] = 131.25, ["Ride"] = 65.01, ["Fly|Ride"] = 412.98, ["Neon"] = 36.66, ["Neon|Ride"] = 104.81, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 178.5, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.01, ["Fly"] = 236.15, ["Ride"] = 42.41, ["Fly|Ride"] = 76.56, ["Neon"] = 22.95, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 262.5, ["Mega|Fly"] = 800.37, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 272.88}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.63, ["Fly"] = 34.13, ["Ride"] = 15.91, ["Fly|Ride"] = 43.3, ["Neon"] = 15.43, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 82.57, ["Mega"] = 184, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 232.2}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 24.94, ["Ride"] = 34.12, ["Fly|Ride"] = 55.6, ["Neon"] = 117.59, ["Mega"] = 844.83, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 545.61}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 422.9, ["Neon"] = 4.81, ["Neon|Ride"] = 45.48, ["Neon|Fly|Ride"] = 105.75, ["Mega"] = 32.45, ["Mega|Fly"] = 141.7, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 185.07}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Fly"] = 628.01, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2367.46, ["Mega|Ride"] = 9359.47, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.93, ["Fly"] = 105.74, ["Ride"] = 54.36, ["Fly|Ride"] = 338.33, ["Neon"] = 15.75, ["Neon|Ride"] = 77.38, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 85.32, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 338.37}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.85, ["Neon"] = 3.94, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 76.14, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42.31, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 49.71, ["Neon"] = 3.94, ["Neon|Ride"] = 56.12, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 46.53, ["Mega|Fly"] = 156.5, ["Mega|Ride"] = 117.41, ["Mega|Fly|Ride"] = 145.69}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 45.48, ["Neon|Ride"] = 48.18, ["Mega"] = 211.47, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.56, ["Fly"] = 64.32, ["Ride"] = 42, ["Fly|Ride"] = 144.37, ["Neon"] = 103.95, ["Neon|Fly"] = 211.47, ["Neon|Ride"] = 99.41, ["Neon|Fly|Ride"] = 281.27, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 547.46}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 21.15, ["Ride"] = 73.96, ["Fly|Ride"] = 105.74, ["Neon"] = 78.74, ["Neon|Ride"] = 205.14, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 382.34, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 15.64, ["Fly|Ride"] = 32.45, ["Neon"] = 28.49, ["Neon|Fly"] = 141.7, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 87.77, ["Mega"] = 244.8, ["Mega|Ride"] = 282.32, ["Mega|Fly|Ride"] = 211.47}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 11.81, ["Ride"] = 104.31, ["Fly|Ride"] = 133.22, ["Neon"] = 38.05, ["Neon|Ride"] = 141.7, ["Mega|Ride"] = 734.87}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 100.12, ["Neon"] = 5.92, ["Neon|Ride"] = 38.42, ["Neon|Fly|Ride"] = 113.15, ["Mega"] = 65.63, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.23, ["Fly"] = 112.82, ["Ride"] = 26.25, ["Fly|Ride"] = 43.21, ["Neon"] = 109.15, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 192.29, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 841.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 57.1, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 48.77, ["Fly"] = 153.58, ["Ride"] = 81.9, ["Fly|Ride"] = 91.88, ["Neon"] = 324.83, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1696.72, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 37.94, ["Fly"] = 85.44, ["Ride"] = 76.74, ["Fly|Ride"] = 128.63, ["Neon"] = 190.31, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 199.5, ["Mega"] = 551.25, ["Mega|Ride"] = 676.72, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 13.13, ["Ride"] = 57.1, ["Neon"] = 103.69, ["Neon|Ride"] = 141.7, ["Mega"] = 1050, ["Mega|Ride"] = 800.37, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 23.62, ["Fly"] = 81.73, ["Ride"] = 70.88, ["Fly|Ride"] = 193.49, ["Neon"] = 137.82, ["Neon|Fly"] = 420, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 320.39, ["Mega"] = 493.26, ["Mega|Ride"] = 565.55, ["Mega|Fly|Ride"] = 662.75}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 13.13, ["Fly|Ride"] = 26.25, ["Neon"] = 3.92, ["Neon|Fly"] = 27.07, ["Neon|Ride"] = 34.07, ["Neon|Fly|Ride"] = 53.93, ["Mega"] = 38.33, ["Mega|Fly"] = 320.39, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.3, ["Fly"] = 480.02, ["Ride"] = 97.44, ["Fly|Ride"] = 262.39, ["Neon"] = 353.75, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 556.18, ["Mega"] = 1262.48, ["Mega|Ride"] = 1499.34, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.75, ["Neon"] = 3.17, ["Neon|Fly"] = 99.41, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 296.07, ["Mega"] = 27.57, ["Mega|Ride"] = 80.37, ["Mega|Fly|Ride"] = 152.37}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 16.95, ["Ride"] = 113.14, ["Fly|Ride"] = 142.65, ["Neon"] = 126.9, ["Neon|Ride"] = 126.9, ["Neon|Fly|Ride"] = 347.82, ["Mega"] = 591.94, ["Mega|Ride"] = 493.5, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.46, ["Neon|Fly|Ride"] = 105.75, ["Mega"] = 26.17}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.19, ["Mega"] = 22.32, ["Mega|Ride"] = 141.7, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 89.99, ["Fly"] = 223.13, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 667.21, ["Mega|Ride"] = 2256.39, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 96.02, ["Neon"] = 7.8, ["Neon|Fly"] = 42.31, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon"] = 4.98, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 141.7, ["Mega"] = 30.85, ["Mega|Ride"] = 126.92, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 5.79, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.25, ["Mega"] = 103.69, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 480.05}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 87.94, ["Neon"] = 7.88, ["Neon|Ride"] = 156.09, ["Mega"] = 68.16, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 77.44, ["Ride"] = 129.94, ["Fly|Ride"] = 353.13, ["Neon"] = 428.35, ["Neon|Ride"] = 564.63, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2256.39, ["Mega|Ride"] = 2159.89, ["Mega|Fly|Ride"] = 2099.91}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.91, ["Ride"] = 73.7, ["Neon"] = 88.34, ["Neon|Ride"] = 77.43, ["Mega"] = 413.86, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 639.29}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 417.78, ["Fly|Ride"] = 513.64, ["Neon"] = 1706.25, ["Neon|Ride"] = 1410.51, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 95.75}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 53.05}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.33}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.74}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 141.68}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.74}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.57}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 157.5}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 11.87}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 32.83}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.51}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.52}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.24}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.31}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 574.62}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.67}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1207.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.17}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.04}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.38}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 34.13}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 48.56}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.94}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.13}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.63}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.76}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.93}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.89}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.23}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.12}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.81}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2932.75}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 39.8}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.05}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.84}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 9.17}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.63}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 8.54}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 105}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 24.93}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 7.88}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 25.87}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 43.3}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.36}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.31}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.84}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 12.46}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 22.29}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.18}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.39}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 7.76}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.59}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 4.91}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.65}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 17.54}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.68}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.16}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22858.18}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.91}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 27.04}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 40.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 86.54}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.49}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 208.69}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 55.13}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 37.33}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.94}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.18}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 7.11}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 13.13}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.58}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.49}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 108.84}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 4.25}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 7.88}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.94}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 13.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.81}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.87}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.86}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 14.42}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 19.68}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 16.05}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 27.19}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.5}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.92}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 6.36}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.92}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.82}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.75}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.94}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.5}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.45}},
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
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 197.71}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 11.45}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 15.88}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.91}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 40.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.93}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 112.82}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.14}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 22.19}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.93}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.53}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 4.07}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.92}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.13}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.41}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 8.48}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.48}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 5.07}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.14}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8739}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.67}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.42}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.48}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.24}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.51}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 38.38}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 11.75}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.25}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 8.48}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 42}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.53}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.32}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 6.57}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4440.12}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.48}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 33.16}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.63}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.63}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.61}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 45.94}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.22}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 104.98}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.75}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.8}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.84}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 7.56}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 27.56}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.82}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 5.25}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.22}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.24}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.94}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 28.88}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.41}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.09}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 105}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.68}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 78.58}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 6.18}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.54}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 55.12}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 26.24}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.85}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 15.65}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 4.25}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 5.25}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.43}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.37}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.26}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.35}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 13.12}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.81}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.89}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.83}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 6.57}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 60.8}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.92}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.68}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.29}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 27.56}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 6.49}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 199.57}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 5.24}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 4.95}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.51}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 4.8}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.5}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1151.18}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.51}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 203}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 13.13}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.66}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 14.34}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.59}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.31}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 17.07}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.07}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 4.81}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.84}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 8.54}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 8.48}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.39}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 9.08}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.1}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.52}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 5.24}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 11.64}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 31.5}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 120.75}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.62}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.51}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 81.29}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.67}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 54.77}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.15}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 66.31}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 47.46}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 168}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.1}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 5.5}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.32}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.56}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 31.46}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.42}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.5}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.34}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 9.19}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 12.9}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 75.24}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 28.88}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 85.3}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 27.5}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 6.36}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.92}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 10.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 78.73}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 42.68}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.69}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.39}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.56}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.66}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 354.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.08}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 6.35}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.54}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 300.57}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 64.22}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.13}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 4.04}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 55.04}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 211.51}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 77.12}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 912.39}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.89}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.47}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.25}},
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