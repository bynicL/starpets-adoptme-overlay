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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1139.08, ["Ride"] = 1049.99, ["Fly|Ride"] = 1424.11, ["Neon"] = 6773.79, ["Neon|Fly|Ride"] = 5694.27, ["Mega|Fly|Ride"] = 21350.78}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 393.74, ["Fly"] = 645.91, ["Ride"] = 518.46, ["Fly|Ride"] = 544.69, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 12090.84, ["Mega|Fly|Ride"] = 7259.28}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 6015.43, ["Ride"] = 5250, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 25618.81, ["Mega|Fly|Ride"] = 71169.61}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 131.25, ["Ride"] = 183.75, ["Fly|Ride"] = 309.74, ["Neon"] = 1054.75, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 1067.55, ["Mega|Fly|Ride"] = 4528.13}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 854.05, ["Ride"] = 534.19, ["Fly|Ride"] = 565.13, ["Neon|Fly|Ride"] = 1685.13, ["Mega|Fly|Ride"] = 6975.31}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 8.32, ["Ride"] = 57.69, ["Fly|Ride"] = 129.94, ["Neon"] = 72.19, ["Neon|Fly"] = 285.05, ["Neon|Ride"] = 61.74, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 354.38, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 37.27, ["Ride"] = 26.24, ["Fly|Ride"] = 64.07, ["Neon"] = 31.49, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 56.8, ["Neon|Fly|Ride"] = 131.15, ["Mega"] = 188.35, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 116.94, ["Fly"] = 213.52, ["Ride"] = 185.07, ["Fly|Ride"] = 235.94, ["Neon"] = 564.9, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 672.56, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2814.06}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 34.97, ["Fly"] = 79.02, ["Ride"] = 41.98, ["Fly|Ride"] = 98.38, ["Neon"] = 257.62, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 317.02, ["Mega"] = 1424.11, ["Mega|Ride"] = 1129.23, ["Mega|Fly|Ride"] = 918.73}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 21.37, ["Fly"] = 57.67, ["Ride"] = 27.45, ["Fly|Ride"] = 70.75, ["Neon"] = 210.49, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 196.45, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 783.59}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 54.48, ["Fly"] = 128.13, ["Ride"] = 72.19, ["Fly|Ride"] = 162.74, ["Neon"] = 327.72, ["Neon|Ride"] = 328.81, ["Neon|Fly|Ride"] = 399.27, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1281.06}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 69.5}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 366.35, ["Fly"] = 369.38, ["Ride"] = 327.76, ["Fly|Ride"] = 390.71, ["Neon"] = 1387.81, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4840.24}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 114.19, ["Fly"] = 128.06, ["Ride"] = 138.17, ["Fly|Ride"] = 157.5, ["Neon|Fly"] = 629, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 610.99, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.68, ["Ride"] = 57.5, ["Fly|Ride"] = 131.25, ["Neon"] = 21.38, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 202.73, ["Mega"] = 154.88, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 194.91, ["Fly"] = 262.5, ["Ride"] = 219.93, ["Fly|Ride"] = 223.12, ["Neon|Ride"] = 960.81, ["Neon|Fly|Ride"] = 695.63, ["Mega|Fly|Ride"] = 3294.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.62, ["Fly"] = 25.85, ["Ride"] = 15.71, ["Fly|Ride"] = 40.58, ["Neon"] = 27.84, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 53.4, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 208.18, ["Mega|Ride"] = 322.83, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 83.91, ["Fly"] = 162.09, ["Ride"] = 127.32, ["Fly|Ride"] = 244.13, ["Neon"] = 288.75, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 484.4, ["Mega"] = 1703.79, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 1424.11}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 68.25, ["Ride"] = 135.14, ["Fly|Ride"] = 241.94, ["Neon"] = 321.57, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 2135.09, ["Mega|Fly|Ride"] = 1814.84}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 21, ["Fly"] = 55.53, ["Ride"] = 32.82, ["Fly|Ride"] = 355.69, ["Neon"] = 213.94, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 326.69, ["Mega"] = 2780.91, ["Mega|Ride"] = 955.47, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.25, ["Fly"] = 65.34, ["Ride"] = 57.06, ["Fly|Ride"] = 103.68, ["Neon"] = 211.38, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 1692.73, ["Mega|Ride"] = 1024.85, ["Mega|Fly|Ride"] = 941.99}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.58, ["Fly"] = 262.5, ["Ride"] = 111.57, ["Fly|Ride"] = 196.88, ["Neon"] = 213.52, ["Neon|Ride"] = 395, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1290.1, ["Mega|Ride"] = 1338.7, ["Mega|Fly|Ride"] = 1477.49}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 20.14, ["Ride"] = 33.42, ["Fly|Ride"] = 85.31, ["Neon"] = 120.65, ["Neon|Ride"] = 213.52, ["Neon|Fly|Ride"] = 245.56, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 39.25, ["Fly"] = 138.8, ["Ride"] = 59.22, ["Fly|Ride"] = 179.36, ["Neon"] = 325.5, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.49, ["Fly"] = 28.35, ["Ride"] = 19.69, ["Fly|Ride"] = 52.47, ["Neon"] = 39.38, ["Neon|Fly"] = 80.07, ["Neon|Ride"] = 54.46, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 174.57, ["Mega|Fly"] = 24426.34, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 498.75, ["Fly|Ride"] = 510.57, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 9188.47}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 11.2, ["Ride"] = 28.87, ["Fly|Ride"] = 65.63, ["Neon"] = 216.99, ["Neon|Ride"] = 129.94, ["Mega|Ride"] = 811.34, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.16, ["Fly"] = 37.68, ["Ride"] = 21.16, ["Fly|Ride"] = 46.61, ["Neon"] = 52.5, ["Neon|Ride"] = 73.68, ["Neon|Fly|Ride"] = 123.47, ["Mega|Ride"] = 315.93, ["Mega|Fly|Ride"] = 433.18}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.2, ["Fly"] = 118.52, ["Ride"] = 103.95, ["Fly|Ride"] = 112.22, ["Neon"] = 284.82, ["Neon|Ride"] = 382.19, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6406.95, ["Mega|Ride"] = 2418.03, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.61, ["Ride"] = 34.08, ["Fly|Ride"] = 75.96, ["Neon"] = 117.27, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 710.01, ["Mega|Ride"] = 533.19}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 205.42, ["Fly"] = 262.5, ["Ride"] = 205.64, ["Fly|Ride"] = 295.32, ["Neon"] = 635.2, ["Neon|Ride"] = 806.8, ["Neon|Fly|Ride"] = 746.22, ["Mega"] = 3273.09, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.61}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.68, ["Fly"] = 32.81, ["Ride"] = 26.4, ["Fly|Ride"] = 56.82, ["Neon"] = 26.25, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.42, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 149.94, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 826.88, ["Fly"] = 2625, ["Ride"] = 908.25, ["Fly|Ride"] = 941.07, ["Neon"] = 4128.18, ["Neon|Ride"] = 4840.24, ["Neon|Fly|Ride"] = 4768.72, ["Mega|Ride"] = 54405.32, ["Mega|Fly|Ride"] = 17045.44}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 12.5, ["Fly"] = 36.52, ["Ride"] = 40.36, ["Fly|Ride"] = 91.59, ["Neon"] = 158.01, ["Neon|Ride"] = 151.61, ["Neon|Fly|Ride"] = 181.13, ["Mega"] = 1009.32, ["Mega|Ride"] = 1093.17, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 183.75, ["Fly"] = 362.9, ["Ride"] = 264.58, ["Fly|Ride"] = 285.05, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 4128.18, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 38.07}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.47, ["Fly"] = 127.74, ["Ride"] = 49.69, ["Fly|Ride"] = 143.07, ["Neon"] = 90.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 341.62, ["Mega"] = 356.57, ["Mega|Ride"] = 566.19, ["Mega|Fly|Ride"] = 598.47}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 85.32, ["Ride"] = 144.24, ["Fly|Ride"] = 272.24, ["Neon"] = 639.19, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 516.7, ["Mega"] = 2135.09, ["Mega|Ride"] = 2253.6, ["Mega|Fly|Ride"] = 2071.98}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 95.82, ["Fly"] = 157.49, ["Ride"] = 115.81, ["Fly|Ride"] = 220.5, ["Neon"] = 387.19, ["Neon|Fly"] = 570.08, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 496.12, ["Mega|Ride"] = 1378.13, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 60.86, ["Fly"] = 61.36, ["Ride"] = 51.08, ["Fly|Ride"] = 64.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 1344.55}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.15, ["Fly"] = 98.44, ["Ride"] = 41.65, ["Fly|Ride"] = 206.54, ["Neon"] = 34.18, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 240.21, ["Mega"] = 170.62, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 275.44, ["Mega|Fly|Ride"] = 381.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 533.78, ["Fly"] = 700.87, ["Ride"] = 393.65, ["Fly|Ride"] = 545.3, ["Neon|Fly"] = 3843.15, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1766.77, ["Mega|Ride"] = 14945.55, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 90.46, ["Fly"] = 158.01, ["Ride"] = 121.71, ["Fly|Ride"] = 168.71, ["Neon"] = 479.07, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2562.11, ["Mega|Fly|Ride"] = 2579.19}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4033.85, ["Ride"] = 3885, ["Fly|Ride"] = 3937.49, ["Neon|Fly|Ride"] = 14944.49}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 55.11, ["Fly"] = 121.71, ["Ride"] = 57.51, ["Fly|Ride"] = 137.82, ["Neon"] = 443.04, ["Neon|Ride"] = 314.5, ["Neon|Fly|Ride"] = 292.69, ["Mega"] = 1919.45, ["Mega|Ride"] = 1269.19, ["Mega|Fly|Ride"] = 1647.19}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 73.06, ["Ride"] = 53.24, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 384.34, ["Mega"] = 6263.27, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1999.91}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.56, ["Fly"] = 57.67, ["Ride"] = 42.87, ["Fly|Ride"] = 91.87, ["Neon"] = 130.25, ["Neon|Fly"] = 290.32, ["Neon|Ride"] = 139.88, ["Neon|Fly|Ride"] = 202.3, ["Mega"] = 997.11, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.42}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 53.23, ["Fly"] = 393.75, ["Ride"] = 65.34, ["Fly|Ride"] = 81.05, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 427.03, ["Mega|Ride"] = 1290.03, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.12}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 182.96, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1108.12, ["Neon|Fly|Ride"] = 1135.88, ["Mega|Fly|Ride"] = 4603.24}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 635.23, ["Ride"] = 635.39, ["Fly|Ride"] = 723.19, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10220.25}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.55}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 25.88, ["Fly"] = 47.25, ["Ride"] = 35.81, ["Fly|Ride"] = 71.31, ["Neon"] = 226.21, ["Neon|Ride"] = 177.84, ["Neon|Fly|Ride"] = 220.48, ["Mega"] = 2135.09, ["Mega|Ride"] = 1160.65, ["Mega|Fly|Ride"] = 761.24}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 18.9}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4528.13, ["Neon|Ride"] = 17742.02, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43524.26}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 9.96, ["Fly"] = 55.12, ["Ride"] = 21.59, ["Fly|Ride"] = 55.86, ["Neon"] = 89.7, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 203.13, ["Mega"] = 463.1, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 625.83}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.49, ["Fly"] = 139.86, ["Ride"] = 30.19, ["Neon"] = 100.36, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 105, ["Mega"] = 746.22, ["Mega|Ride"] = 844.44, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 67.11, ["Ride"] = 56.43, ["Fly|Ride"] = 80.9, ["Neon|Ride"] = 396.06, ["Neon|Fly|Ride"] = 480.96, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 1773.63}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 7.69, ["Fly"] = 71.54, ["Ride"] = 26.16, ["Fly|Ride"] = 61.69, ["Neon"] = 73.33, ["Neon|Ride"] = 128.37, ["Neon|Fly|Ride"] = 162.03, ["Mega"] = 1424.11, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1765.83, ["Fly"] = 1640.63, ["Ride"] = 1640.62, ["Fly|Ride"] = 1679.99, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27300, ["Fly"] = 34161.25, ["Ride"] = 35437.5, ["Fly|Ride"] = 27300, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 61950, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21.37, ["Fly"] = 393.75, ["Ride"] = 55.13, ["Fly|Ride"] = 127.05, ["Neon"] = 285.05, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 570.08, ["Mega"] = 997.11, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1387.96}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 2.1, ["Fly"] = 63, ["Ride"] = 41.78, ["Fly|Ride"] = 113.81, ["Neon"] = 19.49, ["Neon|Fly"] = 131.23, ["Neon|Ride"] = 58.7, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 131.25, ["Mega|Fly"] = 307.43, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 363.56}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 19.69}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.17, ["Ride"] = 38.07, ["Fly|Ride"] = 105, ["Neon"] = 59.07, ["Neon|Ride"] = 116.8, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 427.03, ["Mega|Ride"] = 422.76, ["Mega|Fly|Ride"] = 725.42}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.94, ["Fly"] = 903.59, ["Ride"] = 675.94, ["Fly|Ride"] = 777.16, ["Neon"] = 2775.62, ["Neon|Ride"] = 2818.31, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10105.33}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 787.5, ["Fly"] = 968.27, ["Ride"] = 947.92, ["Fly|Ride"] = 1010.18, ["Neon"] = 4128.18, ["Neon|Ride"] = 3270.99, ["Neon|Fly|Ride"] = 3675, ["Mega|Fly|Ride"] = 11806.99}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.56, ["Fly"] = 120.98, ["Ride"] = 24.21, ["Fly|Ride"] = 72.18, ["Neon"] = 85.3, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 161.32, ["Mega"] = 1209.72, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 571.14}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 64.84, ["Fly"] = 89.25, ["Ride"] = 85.31, ["Fly|Ride"] = 105, ["Neon"] = 570.08, ["Neon|Ride"] = 491.09, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2090.25, ["Mega|Fly|Ride"] = 2108.4}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Ride"] = 89.13, ["Fly|Ride"] = 213.52, ["Neon"] = 321.81, ["Neon|Ride"] = 386.78, ["Neon|Fly|Ride"] = 553.88, ["Mega"] = 1416.07, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1861.89}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.78, ["Fly"] = 28.37, ["Ride"] = 18.37, ["Fly|Ride"] = 45.94, ["Neon"] = 28.88, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 41.65, ["Neon|Fly|Ride"] = 110.92, ["Mega"] = 285.05, ["Mega|Ride"] = 290.39, ["Mega|Fly|Ride"] = 661.35}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 124.69, ["Fly"] = 179.03, ["Ride"] = 158.45, ["Fly|Ride"] = 212.96, ["Neon"] = 606.71, ["Neon|Ride"] = 576.19, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 5124.2, ["Mega|Fly|Ride"] = 2546.25}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 3.72, ["Ride"] = 47.65, ["Fly|Ride"] = 143.07, ["Neon"] = 30.97, ["Neon|Fly"] = 170.82, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 398.64, ["Mega"] = 194.31, ["Mega|Fly"] = 339.5, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 419.54}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 11.64, ["Fly"] = 39.04, ["Ride"] = 32.67, ["Fly|Ride"] = 81, ["Neon"] = 128.63, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 669.36, ["Mega|Ride"] = 826.29, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.17, ["Ride"] = 68.22, ["Fly|Ride"] = 156.19, ["Neon"] = 210.49, ["Neon|Ride"] = 223.13, ["Mega"] = 918.75, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 922.37}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.1, ["Fly"] = 213.52, ["Ride"] = 37.43, ["Fly|Ride"] = 63.94, ["Neon"] = 103.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 285.05, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5643.75, ["Neon"] = 35585.34, ["Neon|Ride"] = 28468.07, ["Neon|Fly|Ride"] = 25620.94}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 201.17, ["Fly"] = 195.57, ["Ride"] = 210, ["Fly|Ride"] = 284.8, ["Neon"] = 712.06, ["Neon|Ride"] = 725.75, ["Neon|Fly|Ride"] = 564.36, ["Mega|Fly|Ride"] = 1968.74}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 51.77, ["Fly"] = 71.54, ["Ride"] = 96.14, ["Fly|Ride"] = 207.9, ["Neon"] = 156.19, ["Neon|Fly"] = 243.42, ["Neon|Ride"] = 185.94, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 459.38, ["Mega|Fly"] = 645.67, ["Mega|Ride"] = 493.9, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.1, ["Fly"] = 89.52, ["Ride"] = 27.61, ["Fly|Ride"] = 52.49, ["Neon"] = 24.94, ["Neon|Fly"] = 70.47, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 361.51}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 65.51, ["Fly"] = 182.56, ["Ride"] = 96.09, ["Fly|Ride"] = 208.3, ["Neon"] = 241.5, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 561.27, ["Mega|Ride"] = 549.07, ["Mega|Fly|Ride"] = 692.24}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14383.69, ["Ride"] = 13415.07, ["Fly|Ride"] = 12796.88, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 113871.16}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 267.74, ["Ride"] = 331.8, ["Fly|Ride"] = 427.03, ["Neon|Ride"] = 1424.11, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 7254.06}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 50.02, ["Fly"] = 80.59, ["Ride"] = 52.49, ["Fly|Ride"] = 98.43, ["Neon"] = 405.68, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 287.74, ["Mega|Fly|Ride"] = 3095.89}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.03, ["Fly"] = 28.85, ["Ride"] = 24.57, ["Fly|Ride"] = 65.34, ["Neon"] = 67.47, ["Neon|Ride"] = 67.27, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 393.75, ["Mega|Ride"] = 399.27, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 854.05, ["Ride"] = 433.04, ["Fly|Ride"] = 483.38, ["Neon"] = 1677.45, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 5209.6}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.86, ["Ride"] = 32.81, ["Fly|Ride"] = 189.05, ["Neon"] = 34.44, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 142.67, ["Mega|Fly"] = 256.23, ["Mega|Ride"] = 212.67, ["Mega|Fly|Ride"] = 345.9}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 103.93, ["Fly"] = 164.07, ["Ride"] = 131.25, ["Fly|Ride"] = 170.63, ["Neon"] = 385.81, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 516.88, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 12.83, ["Fly"] = 18.16, ["Ride"] = 18.04, ["Fly|Ride"] = 31.17, ["Neon"] = 162.1, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 78.71, ["Mega"] = 2562.11, ["Mega|Fly|Ride"] = 424.9}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.18}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.51, ["Ride"] = 85.53, ["Fly|Ride"] = 177.22, ["Neon"] = 359.63, ["Neon|Fly"] = 425.97, ["Neon|Ride"] = 406.87, ["Neon|Fly|Ride"] = 356.57, ["Mega"] = 1564.57, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1851.13}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 10.88, ["Fly"] = 79.02, ["Ride"] = 31.28, ["Fly|Ride"] = 65.63, ["Neon"] = 98.44, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 194.87, ["Mega"] = 554.07, ["Mega|Ride"] = 562.61, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 36.3}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 47.15, ["Fly"] = 143.07, ["Ride"] = 101.07, ["Fly|Ride"] = 285.05, ["Neon"] = 298.93, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 511.87, ["Mega|Ride"] = 1612.84, ["Mega|Fly|Ride"] = 1678.18}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.15, ["Ride"] = 29.22, ["Fly|Ride"] = 136.57, ["Neon"] = 23.85, ["Neon|Ride"] = 113.72, ["Neon|Fly|Ride"] = 186.83, ["Mega"] = 152.04, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.76, ["Fly"] = 56.44, ["Ride"] = 30.97, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 191.1, ["Mega|Ride"] = 640.54, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 493.5, ["Fly"] = 533.78, ["Ride"] = 484.67, ["Fly|Ride"] = 541.66, ["Neon|Fly|Ride"] = 5694.27, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 38.45, ["Fly"] = 106.77, ["Ride"] = 57.66, ["Fly|Ride"] = 97.13, ["Neon"] = 103.69, ["Neon|Ride"] = 213.09, ["Neon|Fly|Ride"] = 290.19, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 733.41}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.87, ["Fly"] = 142.54, ["Ride"] = 52.5, ["Fly|Ride"] = 123.85, ["Neon"] = 235.94, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 813.48, ["Mega|Fly|Ride"] = 1002.44}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.19, ["Fly"] = 85.2, ["Ride"] = 71.8, ["Fly|Ride"] = 103.69, ["Neon"] = 78.75, ["Neon|Ride"] = 141.62, ["Neon|Fly|Ride"] = 258.57, ["Mega"] = 434.09, ["Mega|Fly"] = 525, ["Mega|Ride"] = 384.34, ["Mega|Fly|Ride"] = 595.33}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8268.75, ["Neon|Fly|Ride"] = 14700, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1437.19, ["Fly"] = 1486.7, ["Ride"] = 1253.42, ["Fly|Ride"] = 1290.19, ["Neon|Fly|Ride"] = 4772.25, ["Mega|Fly|Ride"] = 17080.63}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 604.24, ["Ride"] = 666.5, ["Fly|Ride"] = 683.24, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3196.1, ["Mega"] = 21350.78, ["Mega|Fly|Ride"] = 9593.98}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.23, ["Fly"] = 23.21, ["Ride"] = 18.27, ["Fly|Ride"] = 35.43, ["Neon"] = 64.07, ["Neon|Ride"] = 90.27, ["Neon|Fly|Ride"] = 122.79, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.88, ["Fly"] = 78.74, ["Ride"] = 32.67, ["Fly|Ride"] = 157.5, ["Neon"] = 19.68, ["Neon|Ride"] = 56, ["Mega"] = 167.77, ["Mega|Ride"] = 198.19, ["Mega|Fly|Ride"] = 277.58}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 32.64, ["Fly"] = 45.28, ["Ride"] = 41.26, ["Fly|Ride"] = 99.75, ["Neon"] = 544.34, ["Neon|Ride"] = 150.92, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 747.3, ["Mega|Fly|Ride"] = 666.75}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.72, ["Fly"] = 16.85, ["Ride"] = 16.15, ["Fly|Ride"] = 38.05, ["Neon"] = 30.19, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 44.85, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 302.12, ["Mega|Ride"] = 496.41, ["Mega|Fly|Ride"] = 355.69}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 288.54, ["Fly"] = 369.5, ["Ride"] = 276.94, ["Fly|Ride"] = 354.37, ["Neon"] = 1281.06, ["Neon|Ride"] = 1336.58, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3987.27}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 18.04, ["Fly"] = 60.44, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 105, ["Neon|Fly"] = 427.03, ["Neon|Ride"] = 141.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 669.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 706.73}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 3.9, ["Fly"] = 21, ["Ride"] = 19.19, ["Fly|Ride"] = 34.12, ["Neon"] = 83.28, ["Neon|Fly"] = 120.65, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 104.21, ["Mega"] = 1575, ["Mega|Ride"] = 609.35, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 595.74, ["Fly"] = 1048.69, ["Ride"] = 590.63, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1114.21, ["Ride"] = 1192.67, ["Fly|Ride"] = 1291.39, ["Neon"] = 4982.21, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 12526.52}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 143.07, ["Fly"] = 187.69, ["Ride"] = 106.36, ["Fly|Ride"] = 111.87, ["Neon"] = 470.8, ["Neon|Ride"] = 587.15, ["Neon|Fly|Ride"] = 426.57, ["Mega|Fly|Ride"] = 2768.63}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 163.96, ["Fly"] = 212.14, ["Ride"] = 157.49, ["Fly|Ride"] = 250.04, ["Neon"] = 581.12, ["Neon|Ride"] = 551.25, ["Neon|Fly|Ride"] = 648.64, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2929.5}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 28.85, ["Fly"] = 57.67, ["Ride"] = 34.13, ["Fly|Ride"] = 113.91, ["Neon"] = 236.24, ["Neon|Ride"] = 238.13, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 1080.36}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 328.13, ["Ride"] = 315, ["Fly|Ride"] = 413.16, ["Neon"] = 1220.63, ["Neon|Fly"] = 967.67, ["Neon|Fly|Ride"] = 1139.08, ["Mega"] = 5694.27, ["Mega|Fly|Ride"] = 5694.27}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2419.1, ["Ride"] = 1675.96, ["Fly|Ride"] = 1837.48, ["Neon|Fly|Ride"] = 10675.4, ["Mega|Fly|Ride"] = 32240.61}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.85, ["Fly"] = 213.52, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 269.04, ["Mega"] = 1424.11, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1249.49}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 551.25, ["Fly"] = 806.79, ["Ride"] = 578.22, ["Fly|Ride"] = 665.44, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1155, ["Mega|Fly|Ride"] = 3451.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 35.05, ["Fly"] = 59.07, ["Ride"] = 60.37, ["Fly|Ride"] = 74.72, ["Neon"] = 262.5, ["Neon|Ride"] = 237.09, ["Neon|Fly|Ride"] = 246.87, ["Mega|Fly|Ride"] = 1048.23}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.56, ["Fly"] = 36.31, ["Ride"] = 17.34, ["Fly|Ride"] = 57.75, ["Neon"] = 37.7, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 43.64, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 170.62, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 185.2, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 56.6, ["Ride"] = 128.35, ["Fly|Ride"] = 157.5, ["Neon"] = 262.5, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 1560.76, ["Mega|Ride"] = 1708.08}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 822.94, ["Fly"] = 1092, ["Ride"] = 826.88, ["Fly|Ride"] = 918.22, ["Neon|Ride"] = 3255, ["Neon|Fly|Ride"] = 2937.89, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 653.63, ["Ride"] = 580.62, ["Fly|Ride"] = 811.34, ["Neon|Fly|Ride"] = 4269.11, ["Mega|Fly|Ride"] = 15513.48}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.01, ["Fly"] = 21, ["Ride"] = 23.44, ["Fly|Ride"] = 45.82, ["Neon"] = 144.38, ["Neon|Ride"] = 126.05, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 783.59, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.43, ["Ride"] = 27.57, ["Fly|Ride"] = 91.83, ["Neon"] = 165.37, ["Neon|Ride"] = 84.33, ["Neon|Fly|Ride"] = 210, ["Mega"] = 859.69, ["Mega|Ride"] = 698.18, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.83, ["Ride"] = 26.17, ["Fly|Ride"] = 113.7, ["Neon"] = 23.22, ["Neon|Fly"] = 321.62, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 204.75, ["Mega"] = 186.38, ["Mega|Fly"] = 548.93, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 355.6}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 38.28, ["Fly"] = 51.18, ["Ride"] = 47.37, ["Fly|Ride"] = 93.09, ["Neon"] = 298.93, ["Neon|Ride"] = 220.5, ["Neon|Fly|Ride"] = 223.13, ["Mega|Ride"] = 952.71, ["Mega|Fly|Ride"] = 956.76}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 90.57, ["Ride"] = 131.24, ["Fly|Ride"] = 356.57, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2278.14, ["Mega|Ride"] = 2176.22, ["Mega|Fly|Ride"] = 2121.21}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 9.08, ["Fly"] = 50.16, ["Ride"] = 35.43, ["Fly|Ride"] = 90.57, ["Neon"] = 106.32, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 159.56, ["Mega"] = 478.28, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 443.04}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 28.75, ["Fly"] = 59.07, ["Ride"] = 41.99, ["Fly|Ride"] = 87.26, ["Neon"] = 242.82, ["Neon|Ride"] = 166.52, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1241.59}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.49, ["Fly"] = 16.03, ["Ride"] = 17.41, ["Fly|Ride"] = 36.18, ["Neon"] = 23.62, ["Neon|Ride"] = 50.19, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 213.52, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 533.78}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.8, ["Fly"] = 47.37, ["Ride"] = 42, ["Fly|Ride"] = 66.93, ["Neon"] = 39.38, ["Neon|Fly"] = 111.04, ["Neon|Ride"] = 81.9, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 416.06, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 55.69, ["Fly"] = 56.8, ["Ride"] = 48.76, ["Fly|Ride"] = 97.16, ["Neon"] = 525, ["Neon|Ride"] = 214.67, ["Neon|Fly|Ride"] = 228.38, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1403.07, ["Fly"] = 1410.93, ["Ride"] = 1259.99, ["Fly|Ride"] = 1428, ["Neon|Ride"] = 4909.62, ["Neon|Fly|Ride"] = 3790.5, ["Mega|Fly|Ride"] = 11550}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 462, ["Fly"] = 524.99, ["Ride"] = 446.25, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 2847.14, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14945.55, ["Mega|Fly|Ride"] = 8946.67}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 236.25, ["Fly"] = 378.23, ["Ride"] = 341.25, ["Fly|Ride"] = 393.75, ["Neon"] = 1312.5, ["Neon|Ride"] = 1842.65, ["Neon|Fly|Ride"] = 1552.22}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 37.7}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 28.24, ["Ride"] = 45.34, ["Fly|Ride"] = 97.13, ["Neon"] = 325.5, ["Neon|Ride"] = 208.18, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 23485.86, ["Ride"] = 36288.08, ["Fly|Ride"] = 15750, ["Neon|Fly|Ride"] = 37800, ["Mega"] = 213507.74, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 223.13, ["Fly"] = 262.5, ["Ride"] = 232.32, ["Fly|Ride"] = 287.61, ["Neon"] = 919.31, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 950.24, ["Neon|Fly|Ride"] = 797.7, ["Mega"] = 6405.25, ["Mega|Ride"] = 4269.11, ["Mega|Fly|Ride"] = 3567.38}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.46, ["Fly"] = 525, ["Ride"] = 213.52, ["Fly|Ride"] = 257.25, ["Neon|Fly|Ride"] = 1773.74}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 128.16, ["Fly"] = 144.38, ["Ride"] = 131.87, ["Fly|Ride"] = 196.88, ["Neon"] = 506.82, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 616.88, ["Mega|Fly|Ride"] = 3132.18}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.8, ["Fly"] = 65.63, ["Ride"] = 30.97, ["Fly|Ride"] = 65.63, ["Neon"] = 131.25, ["Neon|Ride"] = 106.77, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 723.05, ["Mega|Ride"] = 712.06, ["Mega|Fly|Ride"] = 940.52}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4541.25, ["Ride"] = 3937.5, ["Fly|Ride"] = 4035.94, ["Neon"] = 27756.02, ["Neon|Fly|Ride"] = 15750}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.43, ["Fly"] = 42, ["Ride"] = 28.44, ["Fly|Ride"] = 52.41, ["Neon"] = 131.25, ["Neon|Ride"] = 213.52, ["Neon|Fly|Ride"] = 199.5, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 733.41}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 41.85, ["Ride"] = 42, ["Fly|Ride"] = 105.38, ["Neon"] = 311.32, ["Neon|Fly"] = 1424.11, ["Neon|Ride"] = 200.71, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1374.41}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 406.88, ["Fly"] = 563.07, ["Ride"] = 446.25, ["Fly|Ride"] = 558.26, ["Neon"] = 1311.19, ["Neon|Fly"] = 1566.1, ["Neon|Ride"] = 1181.12, ["Neon|Fly|Ride"] = 1220.63, ["Mega|Fly|Ride"] = 5319.65}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 16.82, ["Fly"] = 23.28, ["Ride"] = 22.32, ["Fly|Ride"] = 38.09, ["Neon"] = 123.38, ["Neon|Fly"] = 161.21, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 783.59, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 7.86, ["Ride"] = 26.24, ["Fly|Ride"] = 80.15, ["Neon"] = 98.43, ["Neon|Ride"] = 66.96, ["Neon|Fly|Ride"] = 209.08, ["Mega"] = 517.51, ["Mega|Ride"] = 573.08, ["Mega|Fly|Ride"] = 725.42}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 104.99, ["Ride"] = 103.68, ["Fly|Ride"] = 226.33, ["Neon"] = 1010.63, ["Neon|Ride"] = 637.79, ["Neon|Fly|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 2740.83}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.25, ["Fly"] = 128.13, ["Ride"] = 51.45, ["Fly|Ride"] = 157.5, ["Neon"] = 49.88, ["Neon|Ride"] = 91.83, ["Neon|Fly|Ride"] = 236.23, ["Mega"] = 210, ["Mega|Fly"] = 423.94, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 443.39}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3930.84, ["Fly"] = 6289.66, ["Ride"] = 4034.61, ["Fly|Ride"] = 3804.94, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10106.25, ["Mega"] = 42701.55, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.38, ["Fly"] = 42.72, ["Ride"] = 70.22, ["Fly|Ride"] = 144.38, ["Neon"] = 144.38, ["Neon|Ride"] = 232.32, ["Neon|Fly|Ride"] = 399.02, ["Mega"] = 854.05, ["Mega|Ride"] = 1773.63, ["Mega|Fly|Ride"] = 782.24}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7684.16, ["Fly"] = 7579.53, ["Ride"] = 6857.82, ["Fly|Ride"] = 6168.75, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 42701.55}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 17.88, ["Ride"] = 15.65, ["Fly|Ride"] = 32.67, ["Neon"] = 24.5, ["Neon|Fly"] = 57.67, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 233.81, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 248.07}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.39, ["Fly"] = 21, ["Ride"] = 32.46, ["Fly|Ride"] = 54.59, ["Neon"] = 143.07, ["Neon|Fly"] = 235.94, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 166.32, ["Mega|Ride"] = 991.6, ["Mega|Fly|Ride"] = 935.82}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.68}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.69, ["Ride"] = 25.64, ["Fly|Ride"] = 57.67, ["Neon"] = 98.44, ["Neon|Ride"] = 100.51, ["Neon|Fly|Ride"] = 322.85, ["Mega"] = 1050, ["Mega|Ride"] = 997.11, ["Mega|Fly|Ride"] = 789.99}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 20.98, ["Fly"] = 190.37, ["Ride"] = 42, ["Fly|Ride"] = 99.74, ["Neon"] = 203.44, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 945, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.45, ["Fly"] = 25.64, ["Ride"] = 19.69, ["Fly|Ride"] = 39.21, ["Neon|Fly"] = 1064.35, ["Neon|Ride"] = 118.52, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 2562.11, ["Mega|Fly|Ride"] = 533.19}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8683.37}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 14.44}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 236.15, ["Ride"] = 307.47, ["Fly|Ride"] = 262.49, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 12.66, ["Fly"] = 134.25, ["Ride"] = 32.82, ["Fly|Ride"] = 123.85, ["Neon"] = 113.72, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 162.03, ["Mega"] = 525, ["Mega|Ride"] = 533.19, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 9.98}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.16, ["Ride"] = 26.25, ["Fly|Ride"] = 85.41, ["Neon|Ride"] = 249.38, ["Mega"] = 1566.1}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2239.13}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 123.26, ["Fly"] = 339.5, ["Ride"] = 170.82, ["Fly|Ride"] = 427.03, ["Neon"] = 945, ["Neon|Ride"] = 852.97, ["Neon|Fly|Ride"] = 1566.1, ["Mega|Ride"] = 4128.18, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 68.23, ["Fly"] = 213.52, ["Ride"] = 93.16, ["Fly|Ride"] = 241.94, ["Neon"] = 665.09, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 940.52, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 144.38, ["Fly"] = 196.88, ["Ride"] = 170.63, ["Fly|Ride"] = 230.61, ["Neon"] = 907.43, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3274.16, ["Mega|Fly|Ride"] = 3255.08}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.75, ["Fly"] = 3274.16, ["Ride"] = 2428.13, ["Fly|Ride"] = 2295.57, ["Neon"] = 14994.66, ["Neon|Ride"] = 9676.58, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 27045.04}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.73, ["Fly"] = 105.7, ["Ride"] = 34.89, ["Fly|Ride"] = 100.08, ["Neon"] = 120.98, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 154.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 959.73, ["Mega|Ride"] = 997.11, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 602.44, ["Fly"] = 2100, ["Ride"] = 882.88, ["Fly|Ride"] = 787.5, ["Neon|Fly|Ride"] = 4191.91}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.9, ["Ride"] = 52.03, ["Fly|Ride"] = 341.13, ["Neon"] = 94.5, ["Neon|Fly"] = 236.25, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 256.23, ["Mega"] = 463.78, ["Mega|Fly"] = 967.21, ["Mega|Ride"] = 484.67, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 5.64, ["Fly"] = 32.63, ["Ride"] = 27.57, ["Fly|Ride"] = 105.45, ["Neon"] = 42, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.93, ["Neon|Fly|Ride"] = 178.5, ["Mega"] = 452.22, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 60.22}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.92, ["Fly"] = 42.72, ["Ride"] = 21.3, ["Fly|Ride"] = 78.74, ["Neon|Ride"] = 193.55, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 997.11, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 29.96, ["Fly"] = 39.38, ["Ride"] = 34.58, ["Fly|Ride"] = 53.4, ["Neon|Fly"] = 235.94, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 212.46, ["Mega"] = 1450.92, ["Mega|Ride"] = 1813.53, ["Mega|Fly|Ride"] = 989.63}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6469.3, ["Fly"] = 10237.5, ["Ride"] = 6289.95, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 9450, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 6.56, ["Fly"] = 65.62, ["Ride"] = 21.37, ["Fly|Ride"] = 81.37, ["Neon"] = 52.5, ["Neon|Ride"] = 68.21, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 512.44, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 535.5}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.21}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 91.88, ["Fly"] = 377.92, ["Ride"] = 131.25, ["Fly|Ride"] = 150.94, ["Neon"] = 531.57, ["Neon|Ride"] = 428.89, ["Neon|Fly|Ride"] = 481.42, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2121.21}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.86, ["Fly"] = 143.07, ["Ride"] = 64.32, ["Fly|Ride"] = 183.63, ["Neon"] = 147, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2418.19, ["Mega|Ride"] = 2882.37, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.81, ["Fly"] = 49.12, ["Ride"] = 30.98, ["Fly|Ride"] = 65.34, ["Neon"] = 128.77, ["Neon|Fly"] = 230.61, ["Neon|Ride"] = 143.96, ["Neon|Fly|Ride"] = 199.64, ["Mega"] = 1016.21, ["Mega|Ride"] = 870.5, ["Mega|Fly|Ride"] = 786.19}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 4.31, ["Fly"] = 68.95, ["Ride"] = 23.63, ["Fly|Ride"] = 63.96, ["Neon"] = 31.49, ["Neon|Ride"] = 71.93, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 161.13, ["Mega|Fly"] = 284.45, ["Mega|Ride"] = 210.39, ["Mega|Fly|Ride"] = 299.32}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.46, ["Ride"] = 22.32, ["Fly|Ride"] = 98.06, ["Neon"] = 91.59, ["Neon|Ride"] = 97.16, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 427.03, ["Mega|Ride"] = 484.67, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.71, ["Fly"] = 32.8, ["Ride"] = 24.82, ["Fly|Ride"] = 56.41, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 142.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 199.48}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 17.1, ["Ride"] = 131.23, ["Fly|Ride"] = 158.01, ["Neon"] = 194.31, ["Neon|Ride"] = 233.8, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 708.75, ["Mega|Fly|Ride"] = 678.57}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 197.91, ["Ride"] = 930.57, ["Neon|Ride"] = 17080.63, ["Neon|Fly|Ride"] = 28468.07}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 47.24, ["Fly"] = 208.98, ["Ride"] = 80.07, ["Fly|Ride"] = 164.07, ["Neon"] = 252, ["Neon|Ride"] = 341.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 851.9, ["Mega|Ride"] = 1108.12, ["Mega|Fly|Ride"] = 1208.46}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.9, ["Fly"] = 1050, ["Ride"] = 1022.42, ["Fly|Ride"] = 1049.97, ["Neon|Fly"] = 4387.14, ["Neon|Ride"] = 3914.68, ["Neon|Fly|Ride"] = 3281.25, ["Mega"] = 14509.02, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 346.5, ["Fly"] = 645.91, ["Ride"] = 380.62, ["Fly|Ride"] = 426.57, ["Neon"] = 2493.75, ["Neon|Ride"] = 1909.69, ["Neon|Fly|Ride"] = 1994.99, ["Mega"] = 12252.86, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 9.96, ["Fly"] = 24.1, ["Ride"] = 27.71, ["Fly|Ride"] = 38.45, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 84.35, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 437.26, ["Mega|Ride"] = 712.06, ["Mega|Fly|Ride"] = 550.87}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 249.12, ["Fly"] = 406.65, ["Ride"] = 280.75, ["Fly|Ride"] = 326.82, ["Neon"] = 1173.24, ["Neon|Ride"] = 926.33, ["Neon|Fly|Ride"] = 840, ["Mega|Fly|Ride"] = 2788}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.5}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 83.28, ["Ride"] = 171.02, ["Fly|Ride"] = 234.94, ["Neon"] = 583.95, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2135.09, ["Mega|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 1987.4}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 123.33, ["Fly"] = 213.52, ["Ride"] = 131.04, ["Fly|Ride"] = 143.89, ["Neon"] = 1139.08, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 917.7, ["Mega|Fly|Ride"] = 2562.11}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.84, ["Ride"] = 24.85, ["Fly|Ride"] = 52.5, ["Neon"] = 39.38, ["Neon|Ride"] = 64.07, ["Neon|Fly|Ride"] = 242.34, ["Mega"] = 264.76, ["Mega|Ride"] = 189.84, ["Mega|Fly|Ride"] = 335.23}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.34, ["Fly"] = 71.54, ["Ride"] = 27.15, ["Fly|Ride"] = 78.64, ["Neon"] = 143.07, ["Neon|Ride"] = 149.47, ["Neon|Fly|Ride"] = 319.48, ["Mega|Ride"] = 1424.11, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 9.19, ["Fly"] = 102.36, ["Ride"] = 28.88, ["Fly|Ride"] = 104.89, ["Neon"] = 85.32, ["Neon|Ride"] = 66.21, ["Neon|Fly|Ride"] = 260.49, ["Mega"] = 424.9, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 564.62}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 3.83, ["Fly"] = 98.44, ["Ride"] = 31.74, ["Fly|Ride"] = 137.71, ["Neon"] = 22.32, ["Neon|Ride"] = 65.4, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 131.25, ["Mega|Fly"] = 274.47, ["Mega|Ride"] = 166.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 236.25, ["Ride"] = 290.05, ["Fly|Ride"] = 379.83, ["Neon"] = 1336.58, ["Neon|Ride"] = 1378.93, ["Neon|Fly|Ride"] = 1424.07, ["Mega|Fly|Ride"] = 5665.45}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 62.34, ["Fly"] = 570.08, ["Ride"] = 129.93, ["Fly|Ride"] = 242.81, ["Neon"] = 429.18, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 566.88, ["Mega"] = 2024.07, ["Mega|Ride"] = 1903.13, ["Mega|Fly|Ride"] = 1887.42}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 56.11, ["Fly"] = 75.81, ["Ride"] = 72.19, ["Fly|Ride"] = 126, ["Neon"] = 380.63, ["Neon|Ride"] = 278.99, ["Neon|Fly|Ride"] = 411.9, ["Mega|Ride"] = 1773.63, ["Mega|Fly|Ride"] = 1800.94}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 11.96, ["Fly"] = 37.38, ["Ride"] = 36.3, ["Fly|Ride"] = 285.05, ["Neon"] = 131.25, ["Neon|Ride"] = 614.49, ["Neon|Fly|Ride"] = 498.57, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 11.75, ["Fly"] = 75.63, ["Ride"] = 27.57, ["Fly|Ride"] = 70.47, ["Neon"] = 77.44, ["Neon|Ride"] = 121.71, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 378.99, ["Mega|Fly"] = 525, ["Mega|Ride"] = 383.25, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.5, ["Fly"] = 52.5, ["Ride"] = 20.87, ["Fly|Ride"] = 57.48, ["Neon"] = 23, ["Neon|Fly"] = 68.3, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 164.06, ["Mega|Fly"] = 213.52, ["Mega|Ride"] = 170.38, ["Mega|Fly|Ride"] = 243.16}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 787.49, ["Fly"] = 1082.73, ["Ride"] = 787.5, ["Fly|Ride"] = 853.13, ["Neon"] = 4270.17, ["Neon|Fly"] = 3284, ["Neon|Ride"] = 3224.64, ["Neon|Fly|Ride"] = 2849.43, ["Mega|Fly|Ride"] = 8098.23}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 309.81, ["Fly"] = 712.06, ["Ride"] = 288.75, ["Fly|Ride"] = 322.98, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 8540.32}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 134.52, ["Ride"] = 112.88, ["Fly|Ride"] = 162.89, ["Neon"] = 393.74, ["Neon|Fly"] = 483.84, ["Neon|Ride"] = 329.62, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1594.92, ["Mega|Fly|Ride"] = 1648.29}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 178.5, ["Fly"] = 283.5, ["Ride"] = 182.91, ["Fly|Ride"] = 196.87, ["Neon|Ride"] = 1290.1, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 4483.67}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.95, ["Fly"] = 37.38, ["Ride"] = 27.77, ["Fly|Ride"] = 76.13, ["Neon"] = 139.86, ["Neon|Ride"] = 158.01, ["Neon|Fly|Ride"] = 204.75, ["Mega|Fly|Ride"] = 892.47}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 231.26, ["Ride"] = 255.68, ["Fly|Ride"] = 358.32, ["Neon"] = 811.8, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4198.69, ["Mega|Fly|Ride"] = 3773.76}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.43, ["Fly"] = 125.98, ["Ride"] = 80.06, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 570.08, ["Neon|Fly|Ride"] = 427.03, ["Mega|Fly|Ride"] = 1559.25}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2310, ["Ride"] = 2256.19, ["Fly|Ride"] = 2056.69, ["Neon|Ride"] = 8540.32, ["Neon|Fly|Ride"] = 7089.54, ["Mega"] = 51241.86, ["Mega|Fly|Ride"] = 24180.15}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.44, ["Fly"] = 78.03, ["Ride"] = 41.91, ["Fly|Ride"] = 98.83, ["Neon"] = 105, ["Neon|Fly"] = 235.94, ["Neon|Ride"] = 106.77, ["Neon|Fly|Ride"] = 217.51, ["Mega"] = 288.74, ["Mega|Fly"] = 570.08, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 45.77, ["Fly"] = 93.95, ["Ride"] = 83.28, ["Fly|Ride"] = 155.88, ["Neon"] = 196.88, ["Neon|Fly|Ride"] = 443.04, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 78.88, ["Fly"] = 91.87, ["Ride"] = 81.38, ["Fly|Ride"] = 99.75, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3701.16, ["Fly"] = 1613.56, ["Ride"] = 1069.69, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 5161.26, ["Neon|Fly|Ride"] = 4725, ["Mega"] = 34873.3, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 525, ["Fly"] = 525, ["Ride"] = 568.53, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3224.64, ["Mega|Fly|Ride"] = 11387.44}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.46, ["Fly"] = 170.63, ["Ride"] = 107.62, ["Fly|Ride"] = 208.69, ["Neon"] = 395.55, ["Neon|Ride"] = 342.43, ["Neon|Fly|Ride"] = 518.44, ["Mega"] = 1994.19, ["Mega|Ride"] = 2580.04, ["Mega|Fly|Ride"] = 1563.33}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 5.07, ["Fly"] = 41.13, ["Ride"] = 21.55, ["Fly|Ride"] = 64.78, ["Neon"] = 42.61, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 130.56, ["Mega"] = 553.88, ["Mega|Ride"] = 772.92}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 32.81, ["Fly"] = 68.25, ["Ride"] = 42.69, ["Fly|Ride"] = 123.85, ["Neon"] = 284.82, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 334.68, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 917.44}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 728.44, ["Fly"] = 1112.79, ["Ride"] = 746.87, ["Fly|Ride"] = 830.82, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.51}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 6652.83, ["Fly|Ride"] = 5250, ["Neon"] = 42000, ["Neon|Ride"] = 30596.74, ["Neon|Fly|Ride"] = 18375, ["Mega|Fly|Ride"] = 106611.9}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.48, ["Fly"] = 400.35, ["Ride"] = 328.13, ["Fly|Ride"] = 420.96, ["Neon"] = 1312.5, ["Neon|Ride"] = 1851.13, ["Neon|Fly|Ride"] = 1706.25, ["Mega"] = 6404.18, ["Mega|Ride"] = 6114.88, ["Mega|Fly|Ride"] = 6121.28}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 78.75, ["Fly"] = 285.05, ["Ride"] = 131.15, ["Fly|Ride"] = 336, ["Neon"] = 425.97, ["Neon|Ride"] = 746.22, ["Neon|Fly|Ride"] = 636.26}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.56, ["Fly"] = 96.09, ["Ride"] = 31.5, ["Fly|Ride"] = 84.36, ["Neon"] = 156.92, ["Neon|Fly"] = 1290.63, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 622.39, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.83, ["Fly"] = 26.23, ["Ride"] = 19.69, ["Fly|Ride"] = 49.12, ["Neon"] = 128.13, ["Neon|Ride"] = 322.85, ["Neon|Fly|Ride"] = 98.49, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 14.05, ["Fly"] = 285.05, ["Ride"] = 31.4, ["Fly|Ride"] = 89.79, ["Neon"] = 124.69, ["Neon|Ride"] = 113.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 645.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 5.25, ["Fly"] = 63, ["Ride"] = 19.23, ["Fly|Ride"] = 48.55, ["Neon"] = 31.38, ["Neon|Ride"] = 44.86, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 695.67, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 277.58}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.54, ["Fly"] = 90.57, ["Ride"] = 39.38, ["Fly|Ride"] = 139.13, ["Neon"] = 203.44, ["Neon|Fly"] = 854.05, ["Neon|Ride"] = 230.61, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 630, ["Mega|Ride"] = 783.59}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 483, ["Fly"] = 538.13, ["Ride"] = 380.63, ["Fly|Ride"] = 486.28, ["Neon"] = 1921.59, ["Neon|Ride"] = 1879.96, ["Neon|Fly|Ride"] = 1476.57, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5678.26}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.1, ["Fly"] = 21.29, ["Ride"] = 14.43, ["Fly|Ride"] = 28.85, ["Neon"] = 24.21, ["Neon|Ride"] = 38.59, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 170.63, ["Mega|Ride"] = 225.77, ["Mega|Fly|Ride"] = 213.53}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.69, ["Fly"] = 99.09, ["Ride"] = 82.22, ["Fly|Ride"] = 149.52, ["Neon"] = 212.45, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 224.93, ["Neon|Fly|Ride"] = 282.19, ["Mega"] = 524.79, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 603.64}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 872.97, ["Ride"] = 767.82, ["Fly|Ride"] = 792.58, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1634.07, ["Mega|Fly|Ride"] = 4199.99}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 29.96, ["Fly"] = 90.55, ["Ride"] = 44.63, ["Fly|Ride"] = 77.14, ["Neon"] = 256.23, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 1209.1, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 339.5, ["Fly"] = 288.75, ["Ride"] = 262.5, ["Fly|Ride"] = 337.21, ["Neon"] = 1566.1, ["Neon|Ride"] = 1851.13, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6448.85}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.75, ["Fly"] = 279.71, ["Ride"] = 183.75, ["Fly|Ride"] = 236.23, ["Neon"] = 997.11, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 918.75, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3774.21}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 806.79, ["Ride"] = 783.77, ["Fly|Ride"] = 931.88, ["Neon|Ride"] = 3805.32, ["Neon|Fly|Ride"] = 3416.14, ["Mega|Fly|Ride"] = 8398.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.49, ["Fly"] = 85.41, ["Ride"] = 40.58, ["Fly|Ride"] = 111.57, ["Neon"] = 78.75, ["Neon|Fly"] = 290.32, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 125.98, ["Mega"] = 354.38, ["Mega|Ride"] = 327.78, ["Mega|Fly|Ride"] = 624.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3957.38, ["Fly"] = 3543.75, ["Ride"] = 3281.25, ["Fly|Ride"] = 2992.5, ["Neon|Fly|Ride"] = 7218.75, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 106.3, ["Fly"] = 136.5, ["Ride"] = 127.05, ["Fly|Ride"] = 184.54, ["Neon"] = 483.86, ["Neon|Fly"] = 712.69, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 637.88, ["Mega|Ride"] = 2705.16, ["Mega|Fly|Ride"] = 2847.14}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 15.22, ["Fly|Ride"] = 38.97, ["Neon"] = 21, ["Neon|Fly"] = 59.79, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 100.85, ["Mega"] = 154.88, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 370.44, ["Mega|Fly|Ride"] = 233.81}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.1, ["Ride"] = 24.57, ["Fly|Ride"] = 57.71, ["Neon"] = 23.63, ["Neon|Fly"] = 118.55, ["Neon|Ride"] = 64.3, ["Neon|Fly|Ride"] = 162.03, ["Mega"] = 164.62, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 30.35, ["Fly"] = 40.48, ["Ride"] = 31.83, ["Fly|Ride"] = 56.31, ["Neon"] = 290.32, ["Neon|Ride"] = 274.47, ["Neon|Fly|Ride"] = 292.52, ["Mega|Fly|Ride"] = 1103.85}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 853.13, ["Fly"] = 1251.9, ["Ride"] = 997.11, ["Fly|Ride"] = 971.24, ["Neon"] = 4413.22, ["Neon|Fly|Ride"] = 4413.22}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6298.69, ["Ride"] = 8042.86, ["Fly|Ride"] = 6431.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 16.69, ["Fly"] = 28.85, ["Ride"] = 23, ["Fly|Ride"] = 35.34, ["Neon"] = 452.13, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13.19, ["Fly"] = 48.4, ["Ride"] = 28.84, ["Fly|Ride"] = 68.25, ["Neon"] = 71.25, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 158, ["Mega"] = 662.17, ["Mega|Ride"] = 362.25, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 92.64, ["Fly"] = 157.5, ["Ride"] = 87.94, ["Fly|Ride"] = 142.93, ["Neon|Ride"] = 446.24, ["Neon|Fly|Ride"] = 366.18, ["Mega|Fly|Ride"] = 1635.98}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 253.11, ["Fly"] = 241.5, ["Ride"] = 221.82, ["Fly|Ride"] = 322.98, ["Neon"] = 918.75, ["Neon|Ride"] = 1145.63, ["Neon|Fly|Ride"] = 1102.5, ["Mega"] = 8540.32, ["Mega|Fly"] = 4032.06, ["Mega|Fly|Ride"] = 4515.67}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.44, ["Ride"] = 32.71, ["Fly|Ride"] = 57.67, ["Neon"] = 21.98, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 61.93, ["Mega"] = 160.12, ["Mega|Fly"] = 238.08, ["Mega|Ride"] = 191.42, ["Mega|Fly|Ride"] = 236.24}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 184.28, ["Fly"] = 231.7, ["Ride"] = 203.44, ["Fly|Ride"] = 310.49, ["Neon"] = 699.91, ["Neon|Ride"] = 752.96, ["Neon|Fly|Ride"] = 781.34, ["Mega|Fly|Ride"] = 2576.44}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 19.23, ["Fly|Ride"] = 60.1, ["Neon"] = 28.85, ["Neon|Fly"] = 71.54, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 225.75, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 289.31}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 190.32, ["Fly"] = 345.9, ["Ride"] = 207.9, ["Fly|Ride"] = 244.13, ["Neon|Ride"] = 1209.58, ["Neon|Fly|Ride"] = 934.95, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 5481.65}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.77, ["Fly"] = 77.44, ["Ride"] = 27.77, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 307.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 570.08, ["Mega|Ride"] = 498.57, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 4.86, ["Ride"] = 21.08, ["Fly|Ride"] = 85.41, ["Neon"] = 11.18, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 142.72, ["Mega"] = 82.69, ["Mega|Ride"] = 117.37, ["Mega|Fly|Ride"] = 271.17}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.67, ["Mega"] = 19.67, ["Mega|Ride"] = 152.35, ["Mega|Fly|Ride"] = 168.69}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 3.36, ["Ride"] = 31.99, ["Fly|Ride"] = 114.01, ["Neon"] = 6.44, ["Neon|Ride"] = 27.9, ["Neon|Fly|Ride"] = 89.43, ["Mega"] = 81.02, ["Mega|Fly"] = 161201.76, ["Mega|Ride"] = 76.01, ["Mega|Fly|Ride"] = 256.4}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 57.74, ["Fly"] = 105, ["Ride"] = 91.87, ["Fly|Ride"] = 262.5, ["Neon"] = 336.29, ["Neon|Fly"] = 327.97, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 369.43, ["Mega|Fly|Ride"] = 1393.25}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 35.1, ["Ride"] = 17.06, ["Fly|Ride"] = 78.75, ["Neon"] = 7.5, ["Neon|Fly"] = 49.12, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 91.88, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 5.24, ["Ride"] = 114.23, ["Neon"] = 65.63, ["Neon|Fly"] = 274.19, ["Neon|Ride"] = 249.19, ["Mega"] = 261.19, ["Mega|Ride"] = 427.03}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 55.23, ["Mega"] = 15.86, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 157.25}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 71.28, ["Ride"] = 15.65, ["Fly|Ride"] = 24.93, ["Neon"] = 2.1, ["Neon|Fly"] = 37.08, ["Neon|Ride"] = 14.21, ["Neon|Fly|Ride"] = 28.79, ["Mega"] = 11.8, ["Mega|Fly"] = 29.17, ["Mega|Ride"] = 21, ["Mega|Fly|Ride"] = 57.66}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 11.82, ["Fly|Ride"] = 67.27, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 14.04, ["Neon|Fly|Ride"] = 42.83, ["Mega"] = 18.38, ["Mega|Fly"] = 162.02, ["Mega|Ride"] = 34.18, ["Mega|Fly|Ride"] = 60.9}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 71.54, ["Neon"] = 2.62, ["Neon|Ride"] = 65.62, ["Mega"] = 19.69, ["Mega|Ride"] = 85.41, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.86, ["Ride"] = 31.46, ["Fly|Ride"] = 107.62, ["Neon"] = 3.8, ["Neon|Fly"] = 121.43, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 82.38, ["Mega"] = 26.25, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 38.07, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 15.74, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 72.12, ["Mega|Fly|Ride"] = 212.85}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.86, ["Fly"] = 77.43, ["Ride"] = 36.36, ["Fly|Ride"] = 156.47, ["Neon"] = 18.59, ["Neon|Fly"] = 96.68, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 131.23, ["Mega|Fly"] = 292.52, ["Mega|Ride"] = 144.36, ["Mega|Fly|Ride"] = 212.61}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 321.62, ["Mega"] = 13.27, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 70.7, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 16.04, ["Fly|Ride"] = 143.07, ["Neon"] = 18.14, ["Mega"] = 135.19, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Neon"] = 19.23, ["Neon|Ride"] = 71.39, ["Mega"] = 111.55, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.82, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 20.97, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.37, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 16.04, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 37.78, ["Mega"] = 13.12, ["Mega|Fly"] = 32.76, ["Mega|Ride"] = 19.59, ["Mega|Fly|Ride"] = 49.87}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.1, ["Neon"] = 31.48, ["Neon|Ride"] = 140.95, ["Mega"] = 213.52, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 31.52, ["Neon"] = 3.49, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 23.51, ["Mega|Ride"] = 48.09, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 13.13, ["Mega"] = 82.69, ["Mega|Ride"] = 162.28, ["Mega|Fly|Ride"] = 255.15}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 78.92, ["Ride"] = 19.69, ["Fly|Ride"] = 194.31, ["Neon"] = 9.11, ["Neon|Ride"] = 42.71, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 124.69, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 193.45}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.13, ["Ride"] = 13.75, ["Fly|Ride"] = 28.85, ["Neon"] = 2.1, ["Neon|Fly"] = 15.64, ["Neon|Ride"] = 13.79, ["Neon|Fly|Ride"] = 37.38, ["Mega"] = 12.9, ["Mega|Fly"] = 28.18, ["Mega|Ride"] = 24.85, ["Mega|Fly|Ride"] = 53.25}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 27.41, ["Fly|Ride"] = 143.07, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 129.64, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 162.02}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 9.08, ["Fly"] = 16.04, ["Ride"] = 40.58, ["Fly|Ride"] = 52.5, ["Neon"] = 55.04, ["Neon|Ride"] = 68.16, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 228.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 226.1}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.51, ["Ride"] = 14.43, ["Fly|Ride"] = 28.76, ["Neon"] = 2.1, ["Neon|Fly"] = 16.04, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 32.04, ["Mega"] = 19.81, ["Mega|Ride"] = 31.5, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 178.29, ["Ride"] = 31.5, ["Neon"] = 6.93, ["Neon|Ride"] = 35.47, ["Neon|Fly|Ride"] = 169.76, ["Mega"] = 64.93, ["Mega|Fly"] = 170.82, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 35.43, ["Fly|Ride"] = 131.25, ["Neon"] = 3.61, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 284.1, ["Mega"] = 26.58, ["Mega|Fly"] = 59.79, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 314.94}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 32.67, ["Ride"] = 15.75, ["Neon"] = 2.1, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 11.81, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 40.21, ["Mega|Fly|Ride"] = 156.18}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 27.77, ["Ride"] = 14.86, ["Fly|Ride"] = 46.56, ["Neon"] = 7.87, ["Neon|Fly"] = 54.41, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 57.46, ["Mega"] = 71.64, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 185.77}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 57.67, ["Neon"] = 6.76, ["Neon|Ride"] = 68.25, ["Mega"] = 40, ["Mega|Fly"] = 241.84, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.5, ["Ride"] = 15.65, ["Fly|Ride"] = 50.19, ["Neon"] = 11.46, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 21.19, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 111.57, ["Mega|Ride"] = 90.56, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.41, ["Ride"] = 38.98, ["Neon"] = 32.04, ["Neon|Fly"] = 188.89, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 101.07, ["Mega|Fly"] = 341.25, ["Mega|Ride"] = 210}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Ride"] = 15.6, ["Fly|Ride"] = 32.04, ["Neon"] = 10.17, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 32.23, ["Neon|Fly|Ride"] = 85.2, ["Mega"] = 185.77, ["Mega|Fly"] = 420, ["Mega|Ride"] = 121.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.05, ["Ride"] = 15.1, ["Fly|Ride"] = 73.47, ["Neon"] = 11.45, ["Neon|Fly"] = 66.59, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 170.82, ["Mega|Fly"] = 161.95, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 113.17, ["Neon"] = 7.88, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 206.73, ["Mega|Ride"] = 309.6}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 6.25, ["Ride"] = 56.44, ["Neon"] = 200.07, ["Neon|Fly|Ride"] = 794.07, ["Mega"] = 640.54, ["Mega|Ride"] = 753.69, ["Mega|Fly|Ride"] = 981.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.22, ["Ride"] = 41.22, ["Fly|Ride"] = 106.77, ["Neon"] = 44.61, ["Neon|Ride"] = 106.55, ["Mega"] = 162.03, ["Mega|Ride"] = 364.23, ["Mega|Fly|Ride"] = 321.62}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 4.66, ["Ride"] = 31.49, ["Fly|Ride"] = 120.75, ["Neon"] = 32.78, ["Neon|Ride"] = 71.54, ["Mega"] = 283.98, ["Mega|Ride"] = 413.16, ["Mega|Fly|Ride"] = 395.07}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Ride"] = 28.85, ["Neon"] = 3.94, ["Neon|Ride"] = 65.02, ["Mega"] = 17.06, ["Mega|Fly"] = 122.79, ["Mega|Ride"] = 77.39, ["Mega|Fly|Ride"] = 191.71}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 41.89}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.93, ["Fly"] = 23.63, ["Ride"] = 18.41, ["Fly|Ride"] = 43.31, ["Neon"] = 41.99, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 53.4, ["Neon|Fly|Ride"] = 89.57, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 278.59}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.79, ["Ride"] = 15.75, ["Fly|Ride"] = 64.56, ["Neon"] = 2.1, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 16.92, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 5.75, ["Neon|Ride"] = 36.73, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 32.04, ["Mega|Ride"] = 64.99, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 42.63, ["Ride"] = 15.6, ["Fly|Ride"] = 32.78, ["Neon"] = 7.76, ["Neon|Ride"] = 19.23, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 142.72, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 234.64}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.41, ["Fly"] = 42.72, ["Ride"] = 44.86, ["Fly|Ride"] = 57.75, ["Neon"] = 43.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 216.56, ["Mega"] = 170.82, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 319.22}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.12, ["Neon"] = 3.93, ["Mega"] = 20.81, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 341.62}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 16.69, ["Fly|Ride"] = 34.07, ["Neon"] = 2.1, ["Neon|Fly"] = 112.9, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 96.74, ["Mega"] = 26.6, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 39.26, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.65, ["Ride"] = 15.63, ["Fly|Ride"] = 41.99, ["Neon"] = 11.68, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 18.16, ["Neon|Fly|Ride"] = 36.2, ["Mega"] = 64.07, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 85.45}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.45, ["Fly"] = 91.88, ["Ride"] = 36.89, ["Fly|Ride"] = 131.25, ["Neon"] = 3.73, ["Neon|Ride"] = 39.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 52.5, ["Mega|Ride"] = 85.83, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 155728.7, ["Mega"] = 17.72, ["Mega|Fly"] = 106.77, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 17.42, ["Neon"] = 2.62, ["Neon|Fly"] = 27.83, ["Neon|Ride"] = 20.39, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 15.75, ["Mega|Fly"] = 63.89, ["Mega|Ride"] = 37.77, ["Mega|Fly|Ride"] = 89.98}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 42.72, ["Neon"] = 2.63, ["Neon|Ride"] = 40.58, ["Mega"] = 19.69, ["Mega|Ride"] = 425.8}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.61, ["Neon|Fly|Ride"] = 420, ["Mega"] = 30.84, ["Mega|Ride"] = 192.18, ["Mega|Fly|Ride"] = 264.76}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.75, ["Fly|Ride"] = 52.49, ["Neon"] = 5.51, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 42.6, ["Mega"] = 26.25, ["Mega|Fly"] = 45.92, ["Mega|Ride"] = 53.4, ["Mega|Fly|Ride"] = 107.56}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 9.17, ["Ride"] = 72.19, ["Fly|Ride"] = 213.52, ["Neon"] = 123.85, ["Neon|Ride"] = 98.89, ["Mega"] = 406.88, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 712.06}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 38.72, ["Neon"] = 32.82, ["Neon|Ride"] = 157.5, ["Mega"] = 195.37, ["Mega|Fly|Ride"] = 566.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.56, ["Ride"] = 31.95, ["Fly|Ride"] = 181.5, ["Neon"] = 18.16, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 250.08, ["Mega|Fly|Ride"] = 377.89}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.83, ["Ride"] = 11.82, ["Fly|Ride"] = 27.7, ["Neon"] = 2.1, ["Neon|Fly"] = 9.19, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 24.69, ["Mega"] = 14.33, ["Mega|Fly"] = 19.15, ["Mega|Ride"] = 19.16, ["Mega|Fly|Ride"] = 41.7}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.94, ["Fly"] = 118.12, ["Ride"] = 59.79, ["Neon"] = 5.44, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 77.4, ["Mega|Ride"] = 65.63}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.95, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 86.65, ["Mega"] = 12.47, ["Mega|Fly"] = 64.07, ["Mega|Ride"] = 71.54, ["Mega|Fly|Ride"] = 135.59}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 13, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 42.72, ["Ride"] = 16.67, ["Fly|Ride"] = 43.22, ["Neon"] = 8.8, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 32.64, ["Neon|Fly|Ride"] = 76.11, ["Mega"] = 169.31, ["Mega|Fly"] = 193.45, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 292.04}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 127.21, ["Ride"] = 224.2, ["Fly|Ride"] = 382.19, ["Neon|Fly|Ride"] = 977.88, ["Mega"] = 8540.32, ["Mega|Ride"] = 3345.68, ["Mega|Fly|Ride"] = 3360.62}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.21, ["Neon"] = 4.74, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 196.45, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.83, ["Fly"] = 103.68, ["Ride"] = 26.25, ["Fly|Ride"] = 62.91, ["Neon"] = 32.49, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 381.89, ["Mega|Ride"] = 531.44, ["Mega|Fly|Ride"] = 643.22}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 15.7, ["Fly|Ride"] = 30.19, ["Neon"] = 5.12, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 29.79, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 46.98, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 18.16, ["Fly|Ride"] = 92.59, ["Neon"] = 8.55, ["Neon|Ride"] = 75.35, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 51.19, ["Mega|Ride"] = 193.45, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.73, ["Fly"] = 25.99, ["Ride"] = 15.74, ["Fly|Ride"] = 31.49, ["Neon"] = 26.28, ["Neon|Fly"] = 100.05, ["Neon|Ride"] = 33.78, ["Neon|Fly|Ride"] = 77.96, ["Mega|Ride"] = 280.77, ["Mega|Fly|Ride"] = 293.99}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.55, ["Ride"] = 34.29, ["Fly|Ride"] = 118.13, ["Neon"] = 48.06, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 257.25, ["Mega|Ride"] = 360.17, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.49, ["Fly|Ride"] = 34.09, ["Neon"] = 26.76, ["Neon|Fly"] = 68.65, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 62.99, ["Mega"] = 262.5, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 232.55}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 54.84, ["Fly"] = 111.04, ["Ride"] = 79.83, ["Fly|Ride"] = 149.1, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 397.69, ["Neon|Fly|Ride"] = 428.3, ["Mega|Fly|Ride"] = 1468.68}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 196.77, ["Fly"] = 427.03, ["Ride"] = 246.75, ["Fly|Ride"] = 308.44, ["Neon|Ride"] = 1281.06, ["Neon|Fly|Ride"] = 965.51, ["Mega"] = 10675.4, ["Mega|Fly|Ride"] = 4979.01}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 85.2, ["Ride"] = 67.64, ["Fly|Ride"] = 118.12, ["Neon"] = 262.5, ["Neon|Ride"] = 290.34, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1400.62}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.15, ["Fly"] = 287.99, ["Ride"] = 23.39, ["Neon"] = 26.17, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 284.1, ["Mega"] = 262.5, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 10.01, ["Fly"] = 71.54, ["Ride"] = 31.23, ["Fly|Ride"] = 93.3, ["Neon"] = 76.13, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 416.07, ["Mega|Ride"] = 314.15, ["Mega|Fly|Ride"] = 397.3}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.49, ["Ride"] = 14.69, ["Fly|Ride"] = 44.79, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 19.69, ["Mega|Fly"] = 147.52, ["Mega|Ride"] = 118.52, ["Mega|Fly|Ride"] = 527.66}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 8.47, ["Fly"] = 72.12, ["Ride"] = 24.46, ["Fly|Ride"] = 81.2, ["Neon"] = 152.42, ["Neon|Fly"] = 285.05, ["Neon|Ride"] = 113.05, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 1837.5, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 14.93, ["Fly|Ride"] = 36.3, ["Neon"] = 10.13, ["Neon|Fly"] = 81.05, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 143.07, ["Mega|Ride"] = 183.93, ["Mega|Fly|Ride"] = 215.08}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 30.97, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 36.3, ["Mega"] = 199.64, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.36, ["Neon"] = 2.1, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.74, ["Mega|Ride"] = 42.72, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 19.59, ["Ride"] = 18.84, ["Fly|Ride"] = 32.04, ["Neon"] = 11.86, ["Neon|Fly"] = 106.77, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Ride"] = 106.4, ["Mega|Fly|Ride"] = 200.17}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 25.99, ["Ride"] = 17.38, ["Fly|Ride"] = 62.79, ["Neon"] = 18.19, ["Neon|Ride"] = 47.25, ["Mega"] = 131.18, ["Mega|Ride"] = 283.98, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 98.64, ["Fly"] = 143.07, ["Ride"] = 143.05, ["Fly|Ride"] = 189.7, ["Neon"] = 489.56, ["Neon|Fly"] = 645.92, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 530.24, ["Mega"] = 4270.17, ["Mega|Fly|Ride"] = 2255.96}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.85, ["Ride"] = 72.59, ["Fly|Ride"] = 129.44, ["Neon"] = 41.13, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 326.82, ["Mega|Ride"] = 440.09, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 16.41, ["Fly|Ride"] = 26.24, ["Neon"] = 18.37, ["Neon|Ride"] = 28.79, ["Neon|Fly|Ride"] = 120.64, ["Mega"] = 246.75, ["Mega|Ride"] = 187.69, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 19.68, ["Ride"] = 58.08, ["Fly|Ride"] = 170.63, ["Neon"] = 124.69, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 711, ["Mega"] = 506.02, ["Mega|Fly"] = 854.05, ["Mega|Ride"] = 689.06, ["Mega|Fly|Ride"] = 645.63}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 4.86}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.37, ["Ride"] = 28.84, ["Fly|Ride"] = 126.84, ["Neon"] = 36.74, ["Neon|Fly"] = 89.25, ["Neon|Ride"] = 160.15, ["Neon|Fly|Ride"] = 327.75, ["Mega"] = 832.7, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 884.14}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21, ["Fly"] = 36.88, ["Ride"] = 28.13, ["Fly|Ride"] = 47.09, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.03, ["Neon|Fly|Ride"] = 153.2, ["Mega"] = 1378.21, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.48, ["Fly|Ride"] = 52.5, ["Neon"] = 3.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.29, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 23.63, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 65.51, ["Mega|Fly|Ride"] = 229.43}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 12.11, ["Fly"] = 28.85, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 57.48, ["Neon|Ride"] = 64.07, ["Mega"] = 285.05, ["Mega|Fly"] = 403.82, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 493.21}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 14.33, ["Fly|Ride"] = 48.56, ["Neon"] = 3.94, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 182.56, ["Mega|Ride"] = 199.13, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.75, ["Fly|Ride"] = 213.52, ["Neon"] = 3.69, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 32.71, ["Mega"] = 22.2, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 125.55}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.21, ["Fly"] = 138.91, ["Ride"] = 67.45, ["Fly|Ride"] = 94.49, ["Neon"] = 111.98, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 568.37, ["Mega"] = 995.06, ["Mega|Fly"] = 656.36, ["Mega|Ride"] = 860.43}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.4, ["Fly"] = 28.85, ["Ride"] = 42, ["Fly|Ride"] = 210, ["Neon"] = 95.82, ["Mega|Ride"] = 525}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 14.67, ["Fly|Ride"] = 61.15, ["Neon"] = 20.78, ["Neon|Fly"] = 85.41, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 71.8, ["Mega"] = 387.85, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 273.67}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.86, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.5, ["Neon"] = 388.5, ["Neon|Ride"] = 656.25, ["Mega"] = 4515.94, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2818.31}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 3.62, ["Fly"] = 45.45, ["Ride"] = 20.9, ["Fly|Ride"] = 57.74, ["Neon"] = 23.63, ["Neon|Ride"] = 58.06, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 256.69, ["Mega|Ride"] = 202.25, ["Mega|Fly|Ride"] = 319.79}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.88, ["Fly"] = 143.06, ["Ride"] = 111.2, ["Fly|Ride"] = 156.19, ["Neon"] = 216.56, ["Neon|Fly"] = 324.55, ["Neon|Ride"] = 178.5, ["Neon|Fly|Ride"] = 314.74, ["Mega"] = 1039.8, ["Mega|Ride"] = 958.13, ["Mega|Fly|Ride"] = 919.86}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 19.4, ["Ride"] = 42.65, ["Fly|Ride"] = 149.04, ["Neon"] = 92.89, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 315, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 367.47, ["Mega|Fly|Ride"] = 414.58}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.12, ["Fly"] = 41.36, ["Ride"] = 28.85, ["Fly|Ride"] = 70.13, ["Neon"] = 106.77, ["Neon|Ride"] = 191.56, ["Neon|Fly|Ride"] = 384.5, ["Mega"] = 162.03, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 541.26}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.17, ["Fly"] = 70.47, ["Ride"] = 45.48, ["Fly|Ride"] = 131.25, ["Neon"] = 38.06, ["Neon|Fly"] = 120.98, ["Neon|Ride"] = 74.42, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 236.91, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.18, ["Ride"] = 30.35, ["Fly|Ride"] = 65.63, ["Neon"] = 32.69, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 276.63, ["Mega|Ride"] = 265.22, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 71.54, ["Neon"] = 2.1, ["Neon|Fly"] = 94.74, ["Neon|Ride"] = 101.19, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 16.67, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 2.1, ["Ride"] = 71.3, ["Neon"] = 32.67, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 233.63, ["Mega|Ride"] = 427.03, ["Mega|Fly|Ride"] = 456.92}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 127.05, ["Ride"] = 28.53, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 185.77, ["Mega"] = 178.96, ["Mega|Ride"] = 283.02, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 2.1, ["Ride"] = 32.8, ["Fly|Ride"] = 120.98, ["Neon"] = 30.97, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 122.79, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 515.07, ["Fly"] = 626.59, ["Ride"] = 498.75, ["Fly|Ride"] = 560.05, ["Neon"] = 1814.84, ["Neon|Fly"] = 1816.97, ["Neon|Ride"] = 1855.4, ["Neon|Fly|Ride"] = 1611.82, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 7.16, ["Fly"] = 45.47, ["Ride"] = 20.42, ["Fly|Ride"] = 50.85, ["Neon"] = 118.56, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 183.75, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 353.37}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 5.8, ["Fly"] = 66.94, ["Ride"] = 17.06, ["Fly|Ride"] = 51.55, ["Neon"] = 75.49, ["Neon|Fly"] = 315, ["Neon|Ride"] = 72.37, ["Neon|Fly|Ride"] = 164.41, ["Mega"] = 331.87, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 396.06}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 3.93, ["Fly"] = 24.93, ["Ride"] = 21.31, ["Fly|Ride"] = 50.78, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 241.28}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.61, ["Ride"] = 24.36, ["Fly|Ride"] = 89.14, ["Neon"] = 6.57, ["Neon|Ride"] = 35.59, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 52.48, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 106.05, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 16.95, ["Neon"] = 2.1, ["Neon|Ride"] = 23.85, ["Neon|Fly|Ride"] = 114.09, ["Mega"] = 23.5, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 226.33}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1115.52}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.8, ["Ride"] = 30.19, ["Fly|Ride"] = 332.06, ["Neon"] = 65.54, ["Neon|Ride"] = 100.08, ["Mega"] = 397.15, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.98, ["Neon"] = 5.24, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 994, ["Mega"] = 37.14, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.73, ["Fly"] = 28.75, ["Ride"] = 50.23, ["Neon"] = 20.69, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 240.19, ["Mega|Ride"] = 362.72, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 416.06, ["Ride"] = 381.94, ["Fly|Ride"] = 519.85, ["Neon|Ride"] = 1350.91, ["Neon|Fly|Ride"] = 1155, ["Mega"] = 8867.43, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Ride"] = 21.37, ["Fly|Ride"] = 128.13, ["Neon"] = 42.37, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 193.47, ["Mega"] = 392.87, ["Mega|Ride"] = 244.4, ["Mega|Fly|Ride"] = 758.06}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 94.37, ["Ride"] = 28.23, ["Fly|Ride"] = 118.11, ["Neon"] = 3.62, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 32.02, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 77.04, ["Mega|Fly|Ride"] = 154.49}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 198.58, ["Mega"] = 32.8, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 21.53, ["Fly"] = 107.9, ["Ride"] = 39.38, ["Fly|Ride"] = 143.07, ["Neon"] = 68.25, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 548.93, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 544.69}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 5.35, ["Ride"] = 71.31, ["Neon"] = 105.26, ["Neon|Ride"] = 181.29, ["Neon|Fly|Ride"] = 483.65, ["Mega"] = 403.85, ["Mega|Ride"] = 482.35, ["Mega|Fly|Ride"] = 640.54}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.71, ["Ride"] = 32.64, ["Neon"] = 95.82, ["Neon|Ride"] = 185.24, ["Mega"] = 621.33, ["Mega|Ride"] = 1088.91, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 10.96, ["Ride"] = 24.1, ["Fly|Ride"] = 262.5, ["Neon"] = 167.37, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 630, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 517.73, ["Neon"] = 1752.19, ["Neon|Ride"] = 1424.11, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 3.72, ["Fly"] = 78.75, ["Ride"] = 28.87, ["Fly|Ride"] = 64.4, ["Neon"] = 198.19, ["Neon|Ride"] = 164.05, ["Neon|Fly|Ride"] = 200.71, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 708.86}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.81, ["Ride"] = 30.97, ["Fly|Ride"] = 127.32, ["Neon"] = 38.57, ["Neon|Ride"] = 221.82, ["Mega"] = 168.69, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 24.93, ["Ride"] = 85.2, ["Neon"] = 74.81, ["Neon|Ride"] = 176.27, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 353.29, ["Mega|Ride"] = 354.35, ["Mega|Fly|Ride"] = 465.92}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 42.72, ["Fly|Ride"] = 213.52, ["Neon"] = 7.31, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 133.46, ["Mega"] = 38.45, ["Mega|Ride"] = 128.3, ["Mega|Fly|Ride"] = 269.04}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.51, ["Ride"] = 99.75, ["Neon"] = 328.13, ["Neon|Ride"] = 262.01, ["Neon|Fly|Ride"] = 508.16, ["Mega"] = 1632.27, ["Mega|Ride"] = 2096.43, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 76.88, ["Ride"] = 26.25, ["Fly|Ride"] = 262.5, ["Neon"] = 7.48, ["Neon|Fly"] = 185.77, ["Neon|Ride"] = 48.2, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 52.5, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.58, ["Fly|Ride"] = 101.56, ["Neon"] = 4.24, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 48.97, ["Neon|Fly|Ride"] = 105, ["Mega"] = 32.81, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 68.24, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.94, ["Fly|Ride"] = 127.62, ["Neon"] = 6.57, ["Neon|Ride"] = 53.55, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 67.89, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 46.57, ["Fly"] = 65.61, ["Ride"] = 61.57, ["Fly|Ride"] = 186.83, ["Neon"] = 262.63, ["Neon|Ride"] = 323.71, ["Neon|Fly|Ride"] = 483.65, ["Mega|Ride"] = 1139.08, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 203.05, ["Ride"] = 247.68, ["Fly|Ride"] = 271.69, ["Neon"] = 1708.08, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1496.25, ["Mega"] = 9672.68, ["Mega|Fly|Ride"] = 4724.99}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.68, ["Ride"] = 100.36, ["Neon"] = 21.3, ["Neon|Fly"] = 350.44, ["Mega"] = 90.95, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 262.4}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.22, ["Fly|Ride"] = 162.1, ["Neon"] = 8.21, ["Neon|Ride"] = 43.89, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 36.36, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 91.65, ["Mega|Fly|Ride"] = 196.76}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 106.45, ["Ride"] = 28.85, ["Fly|Ride"] = 91.88, ["Neon"] = 32.81, ["Mega"] = 222.07, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 94.85, ["Ride"] = 31.45, ["Fly|Ride"] = 116.16, ["Neon"] = 18.75, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 139.12, ["Mega"] = 119.68, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.07, ["Neon"] = 8.44, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 39.26, ["Mega|Ride"] = 85.52, ["Mega|Fly|Ride"] = 399.27}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 37.38, ["Ride"] = 19.04, ["Fly|Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 28.25, ["Neon|Fly|Ride"] = 101.42, ["Mega"] = 40.17, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.8, ["Fly|Ride"] = 48.4, ["Neon"] = 14.34, ["Neon|Fly"] = 101.42, ["Neon|Ride"] = 39.8, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 18.38, ["Ride"] = 34.15, ["Fly|Ride"] = 78.75, ["Neon"] = 105, ["Neon|Ride"] = 197.05, ["Neon|Fly|Ride"] = 806.48, ["Mega"] = 393.75, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 528.45}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 56.17, ["Ride"] = 85.32, ["Fly|Ride"] = 139.13, ["Neon"] = 390.73, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 456.92, ["Mega"] = 1994.19, ["Mega|Ride"] = 1842.59, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 18.16, ["Fly|Ride"] = 144.38, ["Neon"] = 3.81, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 32.69, ["Mega|Fly"] = 672, ["Mega|Ride"] = 88.61, ["Mega|Fly|Ride"] = 247.53}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 15.65, ["Fly|Ride"] = 42.53, ["Neon"] = 3.56, ["Neon|Fly"] = 28.75, ["Neon|Ride"] = 20.88, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 39.67, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 68.13, ["Mega|Fly|Ride"] = 93.95}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.17, ["Fly"] = 42.72, ["Ride"] = 24.21, ["Neon"] = 48.4, ["Neon|Ride"] = 137.82, ["Mega"] = 532.72, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 370.44}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Ride"] = 472.5, ["Fly|Ride"] = 446.25, ["Neon"] = 4270.17, ["Neon|Ride"] = 6562.5, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5701.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 19.37, ["Fly"] = 76.13, ["Ride"] = 49.25, ["Fly|Ride"] = 87.06, ["Neon"] = 215, ["Neon|Ride"] = 188.74, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 812.61, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.2, ["Fly|Ride"] = 283.1, ["Neon"] = 8.47, ["Neon|Ride"] = 49.21, ["Neon|Fly|Ride"] = 141.63, ["Mega"] = 71.54, ["Mega|Ride"] = 178.29, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 83.85, ["Ride"] = 79.02, ["Fly|Ride"] = 65.63, ["Neon"] = 49.88, ["Neon|Ride"] = 72.34, ["Mega|Fly|Ride"] = 319.22}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 34.18, ["Fly"] = 169.31, ["Ride"] = 37.95, ["Fly|Ride"] = 109.44, ["Neon"] = 194.25, ["Neon|Ride"] = 274.47, ["Neon|Fly|Ride"] = 322.85, ["Mega"] = 2562.11, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 95.82, ["Fly"] = 119.34, ["Ride"] = 114.58, ["Fly|Ride"] = 208.18, ["Neon"] = 356.85, ["Neon|Fly"] = 712.06, ["Neon|Ride"] = 483.84, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8540.32, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 236.69, ["Ride"] = 223.13, ["Fly|Ride"] = 532.72, ["Neon"] = 708.75, ["Neon|Ride"] = 654.69, ["Neon|Fly|Ride"] = 1027.73, ["Mega|Fly|Ride"] = 3470.58}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 9.19, ["Ride"] = 32.82, ["Fly|Ride"] = 143.07, ["Neon"] = 66.94, ["Neon|Fly"] = 120.98, ["Neon|Ride"] = 90.09, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 389.8, ["Mega|Ride"] = 405, ["Mega|Fly|Ride"] = 479.92}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 24.99, ["Ride"] = 14.22, ["Fly|Ride"] = 43.32, ["Neon"] = 7.69, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 92.89, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.1, ["Fly"] = 45.11, ["Ride"] = 15.43, ["Fly|Ride"] = 47.25, ["Neon"] = 32.04, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 89.72, ["Mega"] = 282.02, ["Mega|Ride"] = 437.68, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 314.9, ["Ride"] = 393.75, ["Fly|Ride"] = 725.78, ["Neon"] = 1569.1, ["Neon|Fly|Ride"] = 1851.13, ["Mega"] = 10248.39, ["Mega|Ride"] = 6618.75, ["Mega|Fly|Ride"] = 5118.75}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 16.04, ["Neon"] = 5.18, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 28.59, ["Mega|Ride"] = 104.64}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Ride"] = 16.03, ["Fly|Ride"] = 39.38, ["Neon"] = 10.49, ["Neon|Ride"] = 38.01, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 211.38, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.32, ["Ride"] = 65.33, ["Neon"] = 78.75, ["Neon|Fly"] = 427.03, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 369.3, ["Mega"] = 548.62, ["Mega|Ride"] = 585.9, ["Mega|Fly|Ride"] = 636.74}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 108.84, ["Fly"] = 143.07, ["Ride"] = 117.8, ["Fly|Ride"] = 130.97, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 18.24, ["Fly"] = 33.11, ["Ride"] = 26.04, ["Fly|Ride"] = 49.5, ["Neon"] = 131.92, ["Neon|Ride"] = 89.3, ["Neon|Fly|Ride"] = 105, ["Mega"] = 712.06, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 550.79}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 2.63, ["Neon|Ride"] = 142.63, ["Mega"] = 25.99, ["Mega|Ride"] = 127.95, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.72, ["Fly|Ride"] = 85.22, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 21.79, ["Neon|Fly|Ride"] = 83.29, ["Mega"] = 20.35, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 31.18, ["Mega|Fly|Ride"] = 109.99}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.97, ["Ride"] = 42.61, ["Fly|Ride"] = 170.22, ["Neon"] = 26.25, ["Neon|Ride"] = 89.69, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 172.65, ["Mega|Ride"] = 207.5, ["Mega|Fly|Ride"] = 302.78}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1179.94, ["Ride"] = 1181.25, ["Fly|Ride"] = 1422.94, ["Neon"] = 4376.12, ["Neon|Ride"] = 4935.08, ["Neon|Fly|Ride"] = 4380.13, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 381.54, ["Ride"] = 446.25, ["Fly|Ride"] = 563.07, ["Neon"] = 1680, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1746.51, ["Mega"] = 17080.63, ["Mega|Fly|Ride"] = 7245.39}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 262.5, ["Fly"] = 419.75, ["Ride"] = 328.13, ["Fly|Ride"] = 393.75, ["Neon"] = 577.5, ["Neon|Fly"] = 1129.76, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 207.38, ["Fly"] = 362.9, ["Ride"] = 279.56, ["Fly|Ride"] = 355.66, ["Neon"] = 708.75, ["Neon|Ride"] = 603.74, ["Neon|Fly|Ride"] = 656.23, ["Mega|Fly|Ride"] = 3044.64}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 15.62, ["Ride"] = 15.06, ["Fly|Ride"] = 39.38, ["Neon"] = 5.25, ["Neon|Ride"] = 30.44, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.57, ["Mega|Fly"] = 113.17, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 242.82, ["Fly"] = 1424.11, ["Ride"] = 301.88, ["Fly|Ride"] = 433.13, ["Neon"] = 1318.08, ["Neon|Ride"] = 1365, ["Neon|Fly|Ride"] = 984.38, ["Mega"] = 21635.82, ["Mega|Ride"] = 5124.2, ["Mega|Fly|Ride"] = 4327.82}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.93, ["Fly"] = 157.5, ["Ride"] = 70.27, ["Fly|Ride"] = 91.87, ["Neon"] = 25.98, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 255.29, ["Mega"] = 172.53, ["Mega|Ride"] = 288.44, ["Mega|Fly|Ride"] = 371.18}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 16.04, ["Fly|Ride"] = 39.38, ["Neon"] = 7.88, ["Neon|Ride"] = 42.65, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.9, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 106.4}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.18, ["Neon"] = 2.1, ["Neon|Ride"] = 45.94, ["Mega"] = 32.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.87, ["Ride"] = 57.7, ["Fly|Ride"] = 459.38, ["Neon"] = 244.13, ["Neon|Ride"] = 355.56, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8064.07, ["Ride"] = 26.62, ["Fly|Ride"] = 68.25, ["Neon"] = 3.94, ["Neon|Ride"] = 61.13, ["Mega"] = 358.71, ["Mega|Ride"] = 413.16, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.1, ["Neon|Ride"] = 55.11, ["Neon|Fly|Ride"] = 118.11, ["Mega"] = 20.29, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 158.01}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 42.52, ["Ride"] = 31.04, ["Fly|Ride"] = 78.75, ["Neon"] = 16.89, ["Neon|Fly"] = 114.23, ["Neon|Ride"] = 42.2, ["Neon|Fly|Ride"] = 118.5, ["Mega"] = 137.81, ["Mega|Ride"] = 113.89, ["Mega|Fly|Ride"] = 235.94}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 6.06, ["Fly"] = 57.67, ["Ride"] = 19.23, ["Fly|Ride"] = 52.5, ["Neon"] = 30.19, ["Neon|Fly"] = 145.17, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 9.85, ["Ride"] = 52.5, ["Neon"] = 92.9, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 318.01, ["Mega"] = 427.03, ["Mega|Ride"] = 799.6}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 19.69, ["Neon"] = 49.69, ["Neon|Fly"] = 49.49, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 328.13, ["Mega|Ride"] = 322.83, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65.01, ["Ride"] = 18.36, ["Fly|Ride"] = 45.83, ["Neon"] = 3.9, ["Neon|Fly"] = 32.04, ["Neon|Ride"] = 28.54, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 44.42, ["Mega|Fly|Ride"] = 227}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 157.5, ["Fly"] = 228.46, ["Ride"] = 164.01, ["Fly|Ride"] = 241.5, ["Neon"] = 960.81, ["Neon|Ride"] = 908.4, ["Neon|Fly|Ride"] = 827.35, ["Mega"] = 8540.32, ["Mega|Fly|Ride"] = 3975.2}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 15.29, ["Fly|Ride"] = 35.44, ["Neon"] = 2.47, ["Neon|Fly"] = 40.58, ["Neon|Ride"] = 21.31, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 30.98, ["Mega|Ride"] = 57.75, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 6.27, ["Ride"] = 40.25, ["Fly|Ride"] = 196.88, ["Neon"] = 55.59, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 773.82, ["Mega"] = 313.69, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.13, ["Ride"] = 309.67, ["Fly|Ride"] = 170.63, ["Neon"] = 155.92, ["Neon|Ride"] = 299.86, ["Neon|Fly|Ride"] = 136.4, ["Mega"] = 786.19, ["Mega|Ride"] = 681.47, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 194.24, ["Fly"] = 304.5, ["Ride"] = 248.29, ["Fly|Ride"] = 297.94, ["Neon"] = 812.4, ["Neon|Fly"] = 806.8, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3518.63}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.55, ["Ride"] = 159.91, ["Fly|Ride"] = 145.17, ["Neon"] = 59.07, ["Neon|Ride"] = 213.52, ["Mega"] = 242.82, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 320.28}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 7.7, ["Fly"] = 96.78, ["Ride"] = 57.75, ["Fly|Ride"] = 639.08, ["Neon"] = 118.57, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 211.7, ["Neon|Fly|Ride"] = 171.64, ["Mega"] = 712.06, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 906.73, ["Fly"] = 1209.56, ["Ride"] = 948.82, ["Fly|Ride"] = 1046.36, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4688.64, ["Mega|Fly|Ride"] = 17079.57}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 3.94, ["Fly"] = 21.31, ["Ride"] = 20.79, ["Fly|Ride"] = 61.93, ["Neon"] = 21.37, ["Neon|Fly"] = 62.42, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 219.19, ["Mega|Fly|Ride"] = 339.5}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.84, ["Fly"] = 78.75, ["Ride"] = 36.3, ["Fly|Ride"] = 80.08, ["Neon"] = 40.36, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 162.03, ["Mega"] = 529.51, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 210}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.41, ["Ride"] = 23.79, ["Fly|Ride"] = 89.52, ["Neon"] = 6.34, ["Neon|Ride"] = 46.38, ["Mega"] = 69.57, ["Mega|Ride"] = 355.68, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 10.88, ["Fly"] = 26.25, ["Ride"] = 39.16, ["Fly|Ride"] = 93.54, ["Neon"] = 67.55, ["Neon|Fly"] = 143.83, ["Neon|Ride"] = 91.74, ["Neon|Fly|Ride"] = 142.64, ["Mega"] = 435.62, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 20.48, ["Ride"] = 15.81, ["Fly|Ride"] = 51.91, ["Neon"] = 19.24, ["Neon|Fly"] = 45.92, ["Neon|Ride"] = 29.87, ["Neon|Fly|Ride"] = 63, ["Mega"] = 115.5, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 106.77, ["Mega|Fly|Ride"] = 192.78}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 32.75, ["Ride"] = 24.92, ["Neon"] = 9.19, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 185.77, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 150.94, ["Fly"] = 238.08, ["Ride"] = 165.48, ["Fly|Ride"] = 427.03, ["Neon"] = 924.51, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3773.76}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 26.25, ["Fly|Ride"] = 108.94, ["Neon"] = 3.9, ["Neon|Fly"] = 34.18, ["Neon|Ride"] = 47.99, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 58.02, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.9, ["Ride"] = 83.07, ["Fly|Ride"] = 88.86, ["Neon"] = 27.86, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.26, ["Mega"] = 175.88, ["Mega|Ride"] = 322.83, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.5, ["Fly"] = 94.73, ["Ride"] = 19.59, ["Neon"] = 10.5, ["Neon|Ride"] = 85.28, ["Mega"] = 101.07, ["Mega|Ride"] = 120.52, ["Mega|Fly|Ride"] = 459.27}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 69.43, ["Ride"] = 105, ["Fly|Ride"] = 315, ["Neon"] = 493.86, ["Neon|Ride"] = 392.44, ["Neon|Fly|Ride"] = 645.67, ["Mega"] = 2562.11, ["Mega|Ride"] = 1612.84, ["Mega|Fly|Ride"] = 1277.07}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 18.31, ["Fly"] = 90.76, ["Ride"] = 48.4, ["Fly|Ride"] = 256.23, ["Neon"] = 175.09, ["Neon|Ride"] = 163.96, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 640.54, ["Mega|Ride"] = 612.78, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 20.67, ["Fly"] = 57.49, ["Ride"] = 35.43, ["Fly|Ride"] = 97.13, ["Neon"] = 68.25, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 144.14, ["Neon|Fly|Ride"] = 241.86, ["Mega"] = 425.96, ["Mega|Ride"] = 392.77, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.22, ["Neon"] = 8.47, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 106.97, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 38.97, ["Fly"] = 74.78, ["Ride"] = 77.97, ["Fly|Ride"] = 131.24, ["Neon"] = 262.49, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 309.23, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Fly|Ride"] = 52.49, ["Neon"] = 3.86, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 127.05, ["Mega"] = 60.86, ["Mega|Ride"] = 283.98, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 18.38, ["Fly"] = 113.72, ["Ride"] = 33.78, ["Fly|Ride"] = 78.75, ["Neon"] = 70.11, ["Neon|Ride"] = 79.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 370.44, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 314.94, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 36.53, ["Fly"] = 203.34, ["Ride"] = 76.11, ["Fly|Ride"] = 131.25, ["Neon"] = 259.76, ["Neon|Fly"] = 427.03, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1386.75, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 14.23, ["Fly|Ride"] = 28.84, ["Neon"] = 2.1, ["Neon|Fly"] = 24.57, ["Neon|Ride"] = 16.04, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.47, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 36.19, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.1, ["Ride"] = 22.09, ["Fly|Ride"] = 131.25, ["Neon"] = 20.58, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 196.88, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 10.5, ["Fly"] = 143.07, ["Ride"] = 44.01, ["Fly|Ride"] = 85.32, ["Neon"] = 110.14, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 519.77, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 22.23, ["Neon"] = 2.1, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.23, ["Mega|Ride"] = 54.59, ["Mega|Fly|Ride"] = 211.38}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 18.19, ["Fly"] = 203.65, ["Ride"] = 69.62, ["Fly|Ride"] = 177.92, ["Neon"] = 120.65, ["Neon|Ride"] = 173.36, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 672.95, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 549.01, ["Mega|Fly|Ride"] = 673.64}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 9.75, ["Fly"] = 42.49, ["Ride"] = 19.01, ["Fly|Ride"] = 71.54, ["Neon"] = 376.69, ["Neon|Ride"] = 118.18, ["Neon|Fly|Ride"] = 129.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 40.36, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 59.87, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 231, ["Mega|Ride"] = 271.04, ["Mega|Fly|Ride"] = 470.8}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.37, ["Fly"] = 72.19, ["Ride"] = 42.57, ["Fly|Ride"] = 196.88, ["Neon"] = 32.8, ["Neon|Ride"] = 72.59, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 213.69, ["Mega|Ride"] = 442.32, ["Mega|Fly|Ride"] = 362.72}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.72, ["Ride"] = 19.48, ["Fly|Ride"] = 196.88, ["Neon"] = 6.23, ["Neon|Ride"] = 39.38, ["Mega"] = 53.81, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 281.84}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.08, ["Neon"] = 3.15, ["Neon|Ride"] = 42.72, ["Mega"] = 22.31, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 11.69}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 37.1, ["Fly"] = 100.36, ["Ride"] = 66.27, ["Fly|Ride"] = 79.9, ["Neon"] = 184.57, ["Neon|Ride"] = 213.52, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1851.13, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Mega"] = 20.97, ["Mega|Ride"] = 121.47, ["Mega|Fly|Ride"] = 320.28}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 459.38, ["Fly"] = 498.75, ["Ride"] = 561.75, ["Fly|Ride"] = 604.83, ["Neon"] = 2847.14, ["Neon|Ride"] = 2026.21, ["Neon|Fly|Ride"] = 2705.16, ["Mega"] = 17080.63, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 3.85, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 68.33, ["Neon"] = 35.4, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.23, ["Mega"] = 95.86, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 626.67}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 16.94, ["Fly|Ride"] = 57.67, ["Neon"] = 19.67, ["Neon|Ride"] = 62.81, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 118.13, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 157.58, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.4, ["Fly"] = 71.54, ["Ride"] = 42.17, ["Fly|Ride"] = 71.54, ["Neon"] = 55.53, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 261.19, ["Mega"] = 676.83, ["Mega|Ride"] = 561.75, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 57.67, ["Ride"] = 38.57, ["Fly|Ride"] = 712.06, ["Neon"] = 28.88, ["Neon|Fly"] = 36.3, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 5.63, ["Ride"] = 96.09, ["Fly|Ride"] = 149.62, ["Neon"] = 73.55, ["Neon|Ride"] = 145.1, ["Neon|Fly|Ride"] = 273.02, ["Mega"] = 292.81, ["Mega|Ride"] = 330.95, ["Mega|Fly|Ride"] = 698.18}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 3.93, ["Fly"] = 105, ["Ride"] = 25.6, ["Fly|Ride"] = 72.19, ["Neon"] = 27.77, ["Neon|Ride"] = 79.19, ["Neon|Fly|Ride"] = 105, ["Mega"] = 227.07, ["Mega|Ride"] = 313.69, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.36, ["Ride"] = 13.8, ["Fly|Ride"] = 76.67, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 15.88, ["Neon|Fly|Ride"] = 76.88, ["Mega"] = 15.48, ["Mega|Fly"] = 65.3, ["Mega|Ride"] = 36.35, ["Mega|Fly|Ride"] = 91.38}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.75, ["Fly"] = 54.46, ["Ride"] = 38.43, ["Fly|Ride"] = 106.32, ["Neon"] = 20.47, ["Neon|Fly"] = 120.98, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 228.46, ["Mega"] = 156.19, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 281.84}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 326.71, ["Fly"] = 374.97, ["Ride"] = 318.89, ["Fly|Ride"] = 363.57, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1253.31, ["Mega|Ride"] = 9381.91, ["Mega|Fly|Ride"] = 4261.55}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 80.63, ["Ride"] = 114.19, ["Fly|Ride"] = 267.96, ["Neon"] = 356.57, ["Neon|Fly"] = 913.83, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 586.83, ["Mega"] = 2278.14, ["Mega|Ride"] = 1699.55, ["Mega|Fly|Ride"] = 1442.63}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.65, ["Fly|Ride"] = 34.97, ["Neon"] = 5.24, ["Neon|Fly"] = 44.01, ["Neon|Ride"] = 34.18, ["Neon|Fly|Ride"] = 64.07, ["Mega"] = 88.61, ["Mega|Fly"] = 65.3, ["Mega|Ride"] = 78.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 22.57, ["Ride"] = 13.94, ["Fly|Ride"] = 34.84, ["Neon"] = 6.28, ["Neon|Fly"] = 46.98, ["Neon|Ride"] = 25.62, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 65.63, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 170.9}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 100.36, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 100.06, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 427.03, ["Mega|Fly|Ride"] = 328.12}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Fly"] = 322.96, ["Ride"] = 215.36, ["Fly|Ride"] = 288.75, ["Neon"] = 1181.25, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1582.11, ["Mega|Ride"] = 8540.32, ["Mega|Fly|Ride"] = 3435.14}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 16.65, ["Ride"] = 14.6, ["Fly|Ride"] = 40.68, ["Neon"] = 14.44, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 75.7, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 274.52}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 75.54, ["Fly|Ride"] = 213.52, ["Neon"] = 16.04, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 196.88, ["Mega|Ride"] = 300.19, ["Mega|Fly|Ride"] = 456.92}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 89.24, ["Neon"] = 7.88, ["Neon|Ride"] = 156.09, ["Mega"] = 91.88, ["Mega|Ride"] = 337.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.4, ["Fly"] = 32.67, ["Ride"] = 17.95, ["Fly|Ride"] = 67.27, ["Neon"] = 143.07, ["Neon|Ride"] = 99.65, ["Neon|Fly|Ride"] = 139.86, ["Mega"] = 460.69, ["Mega|Ride"] = 456.75, ["Mega|Fly|Ride"] = 587.99}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 38.14, ["Ride"] = 75.81, ["Fly|Ride"] = 297.11, ["Neon"] = 103.68, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 169.29, ["Neon|Fly|Ride"] = 302.75, ["Mega"] = 393.75, ["Mega|Fly"] = 2241.84, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 25.72, ["Fly"] = 64.07, ["Ride"] = 48.2, ["Fly|Ride"] = 78.66, ["Neon"] = 157.53, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 158.01, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 854.05, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 14.95, ["Fly|Ride"] = 29.22, ["Neon"] = 2.1, ["Neon|Fly"] = 31.39, ["Neon|Ride"] = 15.27, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 17.59, ["Mega|Fly"] = 426.01, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 182.43, ["Fly"] = 261.28, ["Ride"] = 231, ["Fly|Ride"] = 272.96, ["Neon"] = 2759.66, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1056.76, ["Mega|Fly|Ride"] = 3984.07}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 6.06, ["Fly"] = 65.63, ["Ride"] = 42, ["Fly|Ride"] = 92.94, ["Neon"] = 105, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 430.5, ["Mega|Ride"] = 488.08, ["Mega|Fly|Ride"] = 392.44}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 35.86, ["Ride"] = 18.74, ["Fly|Ride"] = 42.72, ["Neon"] = 5.25, ["Neon|Fly"] = 40.69, ["Neon|Ride"] = 27.77, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 59.21, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 199.64}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.14, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 25.64, ["Neon|Fly|Ride"] = 113.67, ["Mega"] = 19.23, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 64.07, ["Mega|Fly|Ride"] = 82.69}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 24.04, ["Fly|Ride"] = 72.19, ["Neon"] = 14.43, ["Neon|Fly"] = 725.75, ["Neon|Ride"] = 49.87, ["Mega"] = 103.69, ["Mega|Ride"] = 131.78, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.17, ["Fly"] = 38.66, ["Ride"] = 22.15, ["Fly|Ride"] = 67.31, ["Neon"] = 48.26, ["Neon|Fly"] = 271.17, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 348.04, ["Mega|Ride"] = 370.12, ["Mega|Fly|Ride"] = 355.35}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 6.39, ["Ride"] = 64.97, ["Neon"] = 52.5, ["Neon|Ride"] = 149.47, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 235.94, ["Mega|Ride"] = 314.94, ["Mega|Fly|Ride"] = 413.16}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 57.51, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 171.69}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 6.3, ["Ride"] = 27.88, ["Fly|Ride"] = 131.25, ["Neon"] = 32.17, ["Neon|Fly"] = 96.78, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 160.13, ["Mega|Ride"] = 213.22, ["Mega|Fly|Ride"] = 257.28}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 85.41, ["Neon"] = 3.94, ["Neon|Fly"] = 114.23, ["Neon|Ride"] = 45.8, ["Neon|Fly|Ride"] = 102.36, ["Mega"] = 24.93, ["Mega|Ride"] = 85.08, ["Mega|Fly|Ride"] = 142.64}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 45.47, ["Ride"] = 18.8, ["Fly|Ride"] = 40.68, ["Neon"] = 3.94, ["Neon|Ride"] = 22.41, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 54.3, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 79.26, ["Mega|Fly|Ride"] = 142.96}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.14, ["Ride"] = 702.19, ["Fly|Ride"] = 748.12, ["Neon|Ride"] = 4964.07, ["Neon|Fly|Ride"] = 3674.98, ["Mega|Fly|Ride"] = 12775.7}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 14.96, ["Ride"] = 15.49, ["Fly|Ride"] = 36.33, ["Neon"] = 11.82, ["Neon|Fly"] = 42.59, ["Neon|Ride"] = 36.3, ["Neon|Fly|Ride"] = 98.44, ["Mega|Fly|Ride"] = 370.44}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 4.28, ["Ride"] = 43.62, ["Neon"] = 9.12, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 106.77, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 56.44, ["Mega|Fly"] = 149.47, ["Mega|Ride"] = 249.37, ["Mega|Fly|Ride"] = 257.22}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.24, ["Fly"] = 43.57, ["Ride"] = 22.09, ["Fly|Ride"] = 58.95, ["Neon"] = 41.58, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 108.66, ["Mega"] = 485.63, ["Mega|Ride"] = 244.4, ["Mega|Fly|Ride"] = 347.8}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 17.1, ["Ride"] = 14.33, ["Fly|Ride"] = 27.57, ["Neon"] = 4.19, ["Neon|Fly"] = 149.47, ["Neon|Ride"] = 22.73, ["Neon|Fly|Ride"] = 63.32, ["Mega"] = 45.94, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 176.44}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 35.58, ["Ride"] = 57.49, ["Fly|Ride"] = 271.17, ["Neon"] = 169.36, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 425.97, ["Mega|Ride"] = 640.54}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 17.62, ["Fly|Ride"] = 76.13, ["Neon"] = 4.29, ["Neon|Fly"] = 137.9, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 44.43, ["Mega|Ride"] = 128.19, ["Mega|Fly|Ride"] = 229.68}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 73.41, ["Ride"] = 24.49, ["Fly|Ride"] = 56.86, ["Neon"] = 11.57, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 69.46, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 353.37}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 21.3, ["Mega"] = 97.12, ["Mega|Ride"] = 160.15, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 14.64, ["Fly|Ride"] = 57.48, ["Neon"] = 3.42, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 113.3, ["Mega"] = 36.11, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 81.48, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.19, ["Fly"] = 21.18, ["Ride"] = 16.04, ["Fly|Ride"] = 32.82, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 141.63, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 390.04}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 714.65, ["Fly"] = 936.25, ["Ride"] = 721.88, ["Fly|Ride"] = 826.88, ["Neon"] = 1914.41, ["Neon|Ride"] = 1747.29, ["Neon|Fly|Ride"] = 1959.16, ["Mega"] = 4654.5, ["Mega|Ride"] = 5694.27, ["Mega|Fly|Ride"] = 5682.35}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 16.04, ["Ride"] = 14.21, ["Fly|Ride"] = 29.71, ["Neon"] = 3.87, ["Neon|Fly"] = 30.22, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 42.75, ["Mega"] = 54.46, ["Mega|Ride"] = 66.53, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.15, ["Ride"] = 32.81, ["Fly|Ride"] = 241.65, ["Neon"] = 48.81, ["Neon|Ride"] = 112.52, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 403.85, ["Mega|Ride"] = 355.69, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 45.93, ["Fly"] = 104.9, ["Ride"] = 71.05, ["Fly|Ride"] = 105, ["Neon"] = 315, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 1417.71}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 29.89, ["Ride"] = 61.69, ["Fly|Ride"] = 104.9, ["Neon"] = 185.77, ["Neon|Ride"] = 224.19, ["Mega"] = 1290.1, ["Mega|Ride"] = 896.75, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.1, ["Ride"] = 26.48, ["Fly|Ride"] = 143.07, ["Neon"] = 57.67, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 266.25, ["Mega"] = 305.82, ["Mega|Ride"] = 261.19, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 23.63, ["Ride"] = 53.4, ["Fly|Ride"] = 48.4, ["Neon"] = 85.32, ["Neon|Ride"] = 331.77, ["Neon|Fly|Ride"] = 147.72, ["Mega"] = 283.98, ["Mega|Fly"] = 524.73, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 428.01}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 17.06, ["Fly"] = 128.13, ["Ride"] = 77.44, ["Neon"] = 105, ["Neon|Ride"] = 322.96, ["Neon|Fly|Ride"] = 525, ["Mega"] = 525, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 741.57}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.28}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.48, ["Fly"] = 131248.69, ["Ride"] = 24.93, ["Fly|Ride"] = 72.6, ["Neon"] = 40.47, ["Neon|Ride"] = 53.1, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 207.16, ["Mega|Fly"] = 482.54, ["Mega|Ride"] = 204.81, ["Mega|Fly|Ride"] = 287.82}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Ride"] = 46.86, ["Neon"] = 10.48, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 140.6, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 25.5, ["Fly"] = 63, ["Ride"] = 31.49, ["Fly|Ride"] = 57.74, ["Neon"] = 203.34, ["Neon|Ride"] = 228.69, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 648.94, ["Mega|Fly|Ride"] = 718.22}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.93, ["Fly"] = 18.19, ["Ride"] = 14.44, ["Fly|Ride"] = 36.39, ["Neon"] = 18.8, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 28.7, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 198.19, ["Mega|Fly"] = 425.97, ["Mega|Ride"] = 163.54, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.59, ["Fly"] = 37.37, ["Ride"] = 21.29, ["Fly|Ride"] = 56.27, ["Neon"] = 17.64, ["Neon|Ride"] = 45.64, ["Neon|Fly|Ride"] = 128.18, ["Mega"] = 158.26, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Ride"] = 71.54, ["Neon"] = 6.34, ["Mega"] = 56.85, ["Mega|Ride"] = 203.43, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 28.28, ["Fly"] = 78.75, ["Ride"] = 49.53, ["Fly|Ride"] = 120.74, ["Neon"] = 213.52, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 505.41, ["Mega"] = 524.99, ["Mega|Ride"] = 913.83, ["Mega|Fly|Ride"] = 871.49}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 65.62, ["Neon"] = 4.67, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 85.22, ["Mega"] = 57.98, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.88, ["Ride"] = 81.05, ["Fly|Ride"] = 283.98, ["Neon"] = 66.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 399, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 691.79}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 15.26, ["Fly|Ride"] = 42.26, ["Neon"] = 19.69, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 23.94, ["Fly|Ride"] = 68.61, ["Neon"] = 40.69, ["Neon|Ride"] = 36.75, ["Mega"] = 399.27, ["Mega|Ride"] = 425.97, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 75.99, ["Neon"] = 89.06, ["Neon|Ride"] = 39.38, ["Mega"] = 422.29, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 38.43, ["Ride"] = 132.39, ["Neon"] = 182.44, ["Neon|Ride"] = 421.32, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1067.55, ["Mega|Ride"] = 1309.88, ["Mega|Fly|Ride"] = 1052.61}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.81, ["Ride"] = 106.77, ["Neon"] = 107.62, ["Neon|Ride"] = 183.75, ["Mega"] = 349.13, ["Mega|Ride"] = 555.13, ["Mega|Fly|Ride"] = 624.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 7.59, ["Ride"] = 125.99, ["Neon"] = 57.75, ["Neon|Fly"] = 213.52, ["Neon|Ride"] = 170.63, ["Mega"] = 806.48, ["Mega|Ride"] = 851.91, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 18.2, ["Ride"] = 69.57, ["Fly|Ride"] = 367.47, ["Neon"] = 108.94, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 643.13, ["Mega|Fly"] = 2135.09, ["Mega|Ride"] = 725.42, ["Mega|Fly|Ride"] = 746.22}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.84, ["Neon"] = 16.36, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 185.77, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.77, ["Ride"] = 14.69, ["Fly|Ride"] = 36.3, ["Neon"] = 5.96, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 22.56, ["Neon|Fly|Ride"] = 96.74, ["Mega"] = 68.24, ["Mega|Ride"] = 71.31, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 48.4, ["Ride"] = 23.44, ["Fly|Ride"] = 69.57, ["Neon"] = 11.66, ["Neon|Ride"] = 71.54, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 52.49, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.8, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 4.15, ["Neon|Ride"] = 19.08, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 43.32, ["Mega|Fly"] = 114.23, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 207.12}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.41, ["Fly"] = 65.63, ["Ride"] = 23.49, ["Fly|Ride"] = 84, ["Neon"] = 18.8, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 256.23, ["Mega|Ride"] = 324.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.12, ["Fly"] = 49.6, ["Ride"] = 24.39, ["Fly|Ride"] = 53.82, ["Neon"] = 28.69, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 302.45, ["Mega|Ride"] = 287.46, ["Mega|Fly|Ride"] = 1067.55}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 22.2, ["Fly|Ride"] = 71.31, ["Neon"] = 26.25, ["Neon|Fly"] = 114.23, ["Neon|Ride"] = 29.75, ["Neon|Fly|Ride"] = 92.54, ["Mega"] = 216.57, ["Mega|Ride"] = 244.63, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 23.63, ["Fly|Ride"] = 49.88, ["Neon"] = 22.23, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 256.23, ["Mega|Ride"] = 174.67, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.94, ["Fly"] = 32.82, ["Ride"] = 44.73, ["Fly|Ride"] = 91.86, ["Neon"] = 9.96, ["Neon|Fly"] = 437.05, ["Neon|Ride"] = 62.65, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 90.49, ["Mega|Fly"] = 210, ["Mega|Ride"] = 132.11, ["Mega|Fly|Ride"] = 213.52}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 19.22, ["Fly"] = 213.52, ["Ride"] = 105.52, ["Fly|Ride"] = 375.26, ["Neon"] = 170.82, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 378, ["Mega"] = 588, ["Mega|Ride"] = 594.47, ["Mega|Fly|Ride"] = 623.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 44.38, ["Fly"] = 164.07, ["Ride"] = 98.89, ["Fly|Ride"] = 189, ["Neon"] = 200.5, ["Neon|Ride"] = 184.69, ["Neon|Fly|Ride"] = 352.05, ["Mega"] = 1338.7, ["Mega|Ride"] = 793.19, ["Mega|Fly|Ride"] = 1059.83}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.08, ["Ride"] = 18.37, ["Fly|Ride"] = 118.12, ["Neon"] = 2.1, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 24.94, ["Mega|Ride"] = 56.59, ["Mega|Fly|Ride"] = 145.58}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.3, ["Ride"] = 52.5, ["Neon"] = 117.7, ["Mega"] = 686.56, ["Mega|Ride"] = 712.06, ["Mega|Fly|Ride"] = 1121.99}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.04, ["Ride"] = 91.9, ["Neon"] = 381.8, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 852.97, ["Mega"] = 1707, ["Mega|Ride"] = 1613.06, ["Mega|Fly|Ride"] = 1419.84}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.6, ["Fly"] = 190.32, ["Ride"] = 28.33, ["Fly|Ride"] = 133.88, ["Neon"] = 40.67, ["Neon|Fly"] = 129.44, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 126, ["Mega"] = 192.94, ["Mega|Ride"] = 228.46, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.1, ["Ride"] = 68.84, ["Neon"] = 10.5, ["Neon|Ride"] = 68.23, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 97.13, ["Mega|Fly"] = 306.41, ["Mega|Ride"] = 140.44, ["Mega|Fly|Ride"] = 258.5}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 26.3, ["Ride"] = 16.98, ["Fly|Ride"] = 45.94, ["Neon"] = 12.66, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 98.23, ["Mega"] = 105, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 63.52, ["Mega|Fly|Ride"] = 271.17}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 15.49, ["Fly|Ride"] = 42.2, ["Neon"] = 2.1, ["Neon|Fly"] = 19.08, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 28.87, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 150.73}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.64, ["Fly|Ride"] = 85.17, ["Neon"] = 3.75, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 40.3, ["Mega|Fly"] = 116.76, ["Mega|Ride"] = 57.67, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Ride"] = 145.07, ["Mega"] = 32.82, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 4.23, ["Ride"] = 104.99, ["Neon"] = 37.97, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 185.77, ["Mega|Fly|Ride"] = 322.83}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.93, ["Ride"] = 24.94, ["Fly|Ride"] = 212.9, ["Neon"] = 35.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 196.88, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.84, ["Fly"] = 21.37, ["Ride"] = 16.53, ["Fly|Ride"] = 40.55, ["Neon"] = 28.25, ["Neon|Fly"] = 58.08, ["Neon|Ride"] = 31.39, ["Neon|Fly|Ride"] = 83.51, ["Mega"] = 314.94, ["Mega|Ride"] = 244, ["Mega|Fly|Ride"] = 352.11}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.15, ["Ride"] = 88.54, ["Fly|Ride"] = 262.5, ["Neon"] = 393.75, ["Neon|Ride"] = 425.97, ["Neon|Fly|Ride"] = 712.06, ["Mega"] = 2418.19, ["Mega|Ride"] = 1290.03, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.94, ["Fly"] = 82.69, ["Ride"] = 43.22, ["Fly|Ride"] = 51.19, ["Neon"] = 285.05, ["Neon|Fly|Ride"] = 630, ["Mega"] = 645.67, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 735.67}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 15.64, ["Ride"] = 16.04, ["Fly|Ride"] = 38.78, ["Neon"] = 2.1, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 57.67, ["Mega"] = 30.34, ["Mega|Fly"] = 71.54, ["Mega|Ride"] = 92.51, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.21, ["Ride"] = 14.78, ["Fly|Ride"] = 31.27, ["Neon"] = 3.67, ["Neon|Fly"] = 28.84, ["Neon|Ride"] = 17.37, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 39.38, ["Mega|Fly"] = 122.79, ["Mega|Ride"] = 65.3, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.88, ["Fly"] = 564.9, ["Ride"] = 439.69, ["Fly|Ride"] = 505.32, ["Neon|Fly|Ride"] = 1900.24}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.2, ["Fly"] = 52.5, ["Ride"] = 48.3, ["Fly|Ride"] = 114.23, ["Neon"] = 39.24, ["Neon|Fly"] = 48.4, ["Neon|Ride"] = 81.02, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.59, ["Ride"] = 19, ["Fly|Ride"] = 33.29, ["Neon"] = 6.42, ["Neon|Fly"] = 18.12, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 26.25, ["Mega|Ride"] = 79.86, ["Mega|Fly|Ride"] = 106.42}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.87, ["Ride"] = 98.05, ["Fly|Ride"] = 261.19, ["Neon"] = 227.07, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 392.43, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 873.93}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.98, ["Ride"] = 14.42, ["Fly|Ride"] = 45.94, ["Neon"] = 13.61, ["Neon|Fly"] = 75.88, ["Neon|Ride"] = 25.12, ["Neon|Fly|Ride"] = 70.67, ["Mega"] = 124.67, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 193.81}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 32.82, ["Fly|Ride"] = 196.88, ["Neon"] = 2.47, ["Neon|Fly"] = 100.36, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 75.17, ["Mega"] = 19.17, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 208.95}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.5, ["Fly"] = 128.23, ["Ride"] = 78.72, ["Fly|Ride"] = 213.55, ["Neon"] = 174.65, ["Neon|Ride"] = 191.29, ["Neon|Fly|Ride"] = 420, ["Mega"] = 806.48, ["Mega|Ride"] = 640.57, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 18.38, ["Fly|Ride"] = 147, ["Neon"] = 6.82, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 79.02, ["Mega"] = 32.03, ["Mega|Ride"] = 152.38, ["Mega|Fly|Ride"] = 251.99}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 31.95, ["Ride"] = 79.89, ["Fly|Ride"] = 121.71, ["Neon"] = 207.12, ["Neon|Ride"] = 249.27, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1773.74, ["Mega|Ride"] = 1708.08}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 2.1, ["Fly"] = 71.54, ["Ride"] = 131.24, ["Fly|Ride"] = 40.69, ["Neon"] = 22.39, ["Neon|Ride"] = 31.45, ["Neon|Fly|Ride"] = 497.12, ["Mega"] = 213.52, ["Mega|Ride"] = 213.52}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Ride"] = 72.02, ["Fly|Ride"] = 71.54, ["Neon"] = 8.12, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 432.36, ["Mega"] = 100.36, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 36.27, ["Fly"] = 143.07, ["Ride"] = 59.19, ["Fly|Ride"] = 196.88, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1986.71}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 480.36, ["Ride"] = 28.73, ["Neon"] = 6.56, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 114.32, ["Mega"] = 42.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 227.64}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 21.12, ["Ride"] = 15.49, ["Fly|Ride"] = 102.88, ["Neon"] = 11.68, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 64.07, ["Mega"] = 86.63, ["Mega|Fly"] = 148.74, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.88, ["Fly"] = 57.91, ["Ride"] = 32.75, ["Fly|Ride"] = 169.26, ["Neon"] = 80.05, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 144.27, ["Mega"] = 328.12, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 3.6, ["Fly"] = 31.5, ["Ride"] = 23.63, ["Fly|Ride"] = 71.54, ["Neon"] = 64.25, ["Neon|Ride"] = 83.28, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 456.92, ["Mega|Ride"] = 374.43, ["Mega|Fly|Ride"] = 563.67}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 19.14, ["Fly"] = 24.21, ["Ride"] = 28.08, ["Fly|Ride"] = 55, ["Neon"] = 75.04, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 138.9, ["Mega"] = 399.27, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 60.35, ["Ride"] = 114.19, ["Fly|Ride"] = 256.23, ["Neon"] = 304.5, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 1575, ["Mega|Ride"] = 1520.19, ["Mega|Fly|Ride"] = 1312.49}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 4.94, ["Ride"] = 110.62, ["Neon"] = 21, ["Neon|Ride"] = 114.23, ["Neon|Fly|Ride"] = 296.09, ["Mega"] = 236.69, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 454.79}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.56, ["Ride"] = 27.27, ["Fly|Ride"] = 78.74, ["Neon"] = 15.51, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 228.46, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 246.62}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.39, ["Fly"] = 135.19, ["Ride"] = 35.43, ["Fly|Ride"] = 156.94, ["Neon"] = 57.67, ["Neon|Ride"] = 96.78, ["Mega"] = 285.05, ["Mega|Ride"] = 597.84, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 15.65, ["Fly|Ride"] = 38.26, ["Neon"] = 2.1, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 15.54, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.76, ["Mega|Ride"] = 26.76, ["Mega|Fly|Ride"] = 95.8}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 51.18, ["Ride"] = 112.56, ["Fly|Ride"] = 285.05, ["Neon"] = 236.25, ["Neon|Fly"] = 2420.13, ["Neon|Ride"] = 282.19, ["Neon|Fly|Ride"] = 488.25, ["Mega"] = 1066.49, ["Mega|Ride"] = 944.99, ["Mega|Fly|Ride"] = 879.38}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 15.9, ["Fly|Ride"] = 143.07, ["Neon"] = 5.04, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 19.15, ["Fly|Ride"] = 59.06, ["Neon"] = 18.37, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 90.03, ["Mega"] = 257.25, ["Mega|Ride"] = 193.1, ["Mega|Fly|Ride"] = 283.98}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 45.92, ["Ride"] = 78.75, ["Fly|Ride"] = 229.87, ["Neon"] = 203.68, ["Neon|Ride"] = 262.49, ["Mega"] = 940.74, ["Mega|Ride"] = 1281.06, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 27.77, ["Neon"] = 5.97, ["Neon|Ride"] = 1424.11, ["Mega"] = 61.68, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.08}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 23, ["Fly|Ride"] = 497.48, ["Neon"] = 7.88, ["Neon|Fly"] = 32.67, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 113.9, ["Mega"] = 42.86, ["Mega|Ride"] = 97.12, ["Mega|Fly|Ride"] = 204.75}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 112.88, ["Ride"] = 162.93, ["Fly|Ride"] = 356.57, ["Neon"] = 712.06, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 665.05, ["Mega"] = 3416.14, ["Mega|Ride"] = 3224.43, ["Mega|Fly|Ride"] = 2586.76}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.52, ["Ride"] = 36.33, ["Fly|Ride"] = 213.52, ["Neon"] = 14.44, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.3, ["Neon"] = 2.1, ["Neon|Ride"] = 21.09, ["Mega"] = 31.49, ["Mega|Ride"] = 57.67, ["Mega|Fly|Ride"] = 314.03}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.04, ["Ride"] = 23.87, ["Fly|Ride"] = 49.88, ["Neon"] = 54.34, ["Neon|Ride"] = 85.41, ["Neon|Fly|Ride"] = 153.55, ["Mega"] = 427.03, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 635.2}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 6.57, ["Fly"] = 47.76, ["Ride"] = 21.37, ["Fly|Ride"] = 56.58, ["Neon"] = 72.18, ["Neon|Ride"] = 157.65, ["Neon|Fly|Ride"] = 309.1, ["Mega"] = 626.07, ["Mega|Ride"] = 449.77, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 17.83, ["Ride"] = 58.94, ["Fly|Ride"] = 128.23, ["Neon"] = 137.07, ["Neon|Ride"] = 178.56, ["Neon|Fly|Ride"] = 483.65, ["Mega"] = 498.57, ["Mega|Ride"] = 465.63, ["Mega|Fly|Ride"] = 599.79}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 118.11, ["Fly"] = 162.09, ["Ride"] = 161.86, ["Fly|Ride"] = 225.64, ["Neon"] = 565.13, ["Neon|Fly"] = 685.84, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 542.11, ["Mega|Ride"] = 2562.11, ["Mega|Fly|Ride"] = 3150.32}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 8.45, ["Fly"] = 19.32, ["Ride"] = 18.25, ["Fly|Ride"] = 34.97, ["Neon"] = 38.98, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.04, ["Neon|Fly|Ride"] = 78.56, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 370.13}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 15.75, ["Fly|Ride"] = 131.24, ["Neon"] = 15.65, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 143.7, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 403.82}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 16.62, ["Fly"] = 41.5, ["Ride"] = 28.03, ["Fly|Ride"] = 128.13, ["Neon"] = 36.75, ["Neon|Ride"] = 40.55, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 420, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 38.88, ["Fly"] = 100.36, ["Ride"] = 71.54, ["Fly|Ride"] = 158.01, ["Neon"] = 194.91, ["Neon|Ride"] = 197.11, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 954.19, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 1043.56}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 18.18, ["Fly"] = 57.75, ["Ride"] = 64.07, ["Neon"] = 111.57, ["Neon|Ride"] = 187.85, ["Neon|Fly|Ride"] = 470.8, ["Mega"] = 1050, ["Mega|Ride"] = 1579.95, ["Mega|Fly|Ride"] = 836.73}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.47, ["Ride"] = 517.73, ["Neon|Ride"] = 3224.64}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Fly"] = 43.86, ["Ride"] = 30.09, ["Fly|Ride"] = 69.56, ["Neon"] = 185.77, ["Neon|Ride"] = 158.04, ["Neon|Fly|Ride"] = 267.22, ["Mega"] = 761.25, ["Mega|Ride"] = 733.69, ["Mega|Fly|Ride"] = 967.21}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 39.2, ["Ride"] = 13.85, ["Fly|Ride"] = 42.95, ["Neon"] = 2.1, ["Neon|Ride"] = 16.05, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 21.92, ["Mega|Fly"] = 104.64, ["Mega|Ride"] = 39.16, ["Mega|Fly|Ride"] = 112.23}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 3.89, ["Neon"] = 6.57, ["Neon|Ride"] = 42.3, ["Neon|Fly|Ride"] = 140.93, ["Mega"] = 94.96, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 25.99, ["Fly|Ride"] = 90.76, ["Neon"] = 11.83, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 48.44, ["Neon|Fly|Ride"] = 996.02, ["Mega"] = 125.51, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 320.28}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 425.24, ["Fly"] = 498.57, ["Ride"] = 418.69, ["Fly|Ride"] = 498.62, ["Neon"] = 1547.96, ["Neon|Ride"] = 3202.63, ["Neon|Fly|Ride"] = 1246.87, ["Mega|Fly|Ride"] = 5124.2}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 15.65, ["Fly|Ride"] = 41.47, ["Neon"] = 22.75, ["Neon|Ride"] = 32.17, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 183.65, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 567.73}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 5.11, ["Fly"] = 21.37, ["Ride"] = 15.64, ["Fly|Ride"] = 32.82, ["Neon"] = 20.29, ["Neon|Fly"] = 33.01, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 100.52, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.42, ["Fly"] = 42, ["Ride"] = 21.48, ["Fly|Ride"] = 61.24, ["Neon"] = 13.11, ["Neon|Fly"] = 94.5, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 104.74, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 19.69, ["Fly"] = 47.85, ["Ride"] = 32.81, ["Fly|Ride"] = 65.63, ["Neon"] = 220.4, ["Neon|Ride"] = 196.85, ["Neon|Fly|Ride"] = 319.22, ["Mega"] = 712.06, ["Mega|Ride"] = 852.97, ["Mega|Fly|Ride"] = 602.44}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 53.4, ["Ride"] = 34.12, ["Fly|Ride"] = 51.85, ["Neon"] = 11.59, ["Neon|Ride"] = 32.67, ["Neon|Fly|Ride"] = 210, ["Mega"] = 163.74, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 1011.29}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.28, ["Fly"] = 65.6, ["Ride"] = 27.12, ["Fly|Ride"] = 72.18, ["Neon"] = 168.9, ["Neon|Ride"] = 109.98, ["Neon|Fly|Ride"] = 320.28, ["Mega|Ride"] = 783.59, ["Mega|Fly|Ride"] = 1069.68}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 3.82, ["Neon|Ride"] = 30.19, ["Mega"] = 51.1, ["Mega|Ride"] = 120.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.29, ["Ride"] = 143.07, ["Neon"] = 41.62, ["Mega"] = 367.5, ["Mega|Ride"] = 322.83, ["Mega|Fly|Ride"] = 705.48}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.23, ["Ride"] = 71.54, ["Neon"] = 93.69, ["Neon|Ride"] = 285.05, ["Neon|Fly|Ride"] = 179.36, ["Mega"] = 292.52, ["Mega|Ride"] = 593.64, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.01, ["Fly"] = 26, ["Ride"] = 24, ["Fly|Ride"] = 48.37, ["Neon"] = 36.27, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 568.29, ["Mega|Ride"] = 314.94, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 341.24, ["Fly"] = 556.4, ["Ride"] = 420, ["Fly|Ride"] = 425.25, ["Neon"] = 1642.41, ["Neon|Ride"] = 1656.34, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 8060.47}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 15.75, ["Neon|Fly"] = 81.05, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 158.17, ["Mega"] = 228.46, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 303.48}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.42, ["Ride"] = 48.26, ["Fly|Ride"] = 143.07, ["Neon"] = 57.74, ["Neon|Ride"] = 123.35, ["Neon|Fly|Ride"] = 185.77, ["Mega"] = 389.62, ["Mega|Fly"] = 712.06, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 532.72}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 20.12, ["Fly"] = 118.13, ["Ride"] = 74.8, ["Fly|Ride"] = 285.08, ["Neon"] = 92.89, ["Neon|Ride"] = 208.84, ["Neon|Fly|Ride"] = 356.57, ["Mega"] = 296.33, ["Mega|Ride"] = 356.03, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 49.13, ["Fly"] = 146.86, ["Ride"] = 71.54, ["Fly|Ride"] = 169.31, ["Neon"] = 320.25, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1950.41, ["Mega|Fly|Ride"] = 1485.25}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.49, ["Fly"] = 106.45, ["Ride"] = 32.81, ["Fly|Ride"] = 131.24, ["Neon"] = 33.42, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 245.44, ["Mega"] = 143.07, ["Mega|Fly"] = 181.59, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 339}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 19.59, ["Fly|Ride"] = 58.46, ["Neon"] = 17.46, ["Neon|Ride"] = 33.5, ["Neon|Fly|Ride"] = 127.32, ["Mega"] = 65.62, ["Mega|Ride"] = 176.53, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.01, ["Ride"] = 28.85, ["Neon"] = 19.09, ["Neon|Ride"] = 105.95, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 100.36, ["Mega|Ride"] = 150.17, ["Mega|Fly|Ride"] = 289.42}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 40.88, ["Fly"] = 137.8, ["Ride"] = 72.1, ["Fly|Ride"] = 129.94, ["Neon"] = 112.44, ["Neon|Ride"] = 155.93, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 396.81, ["Mega|Ride"] = 411, ["Mega|Fly|Ride"] = 542.78}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 3.28, ["Ride"] = 131.25, ["Neon"] = 5.25, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 201.93, ["Mega"] = 49.13, ["Mega|Fly"] = 162.03, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 23.37, ["Ride"] = 213.52, ["Neon"] = 144.38, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 854.05, ["Mega"] = 568.05, ["Mega|Fly|Ride"] = 682.18}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 892.4, ["Fly"] = 1004.07, ["Ride"] = 918.75, ["Fly|Ride"] = 964.69, ["Neon"] = 3202.63, ["Neon|Ride"] = 3277.36, ["Neon|Fly|Ride"] = 3281.24, ["Mega|Fly|Ride"] = 10818.45}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 11.82, ["Fly"] = 108.51, ["Ride"] = 36.26, ["Fly|Ride"] = 173.25, ["Neon"] = 64.32, ["Neon|Fly"] = 711, ["Neon|Ride"] = 193.55, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 338.56, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.37, ["Ride"] = 19.5, ["Fly|Ride"] = 90.55, ["Neon"] = 7.11, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 28.85, ["Neon|Fly|Ride"] = 86.59, ["Mega"] = 60.38, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 191.1}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 8.97, ["Ride"] = 58.8, ["Fly|Ride"] = 143.07, ["Neon"] = 42, ["Neon|Fly"] = 84.35, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 266.13, ["Mega|Ride"] = 412.02, ["Mega|Fly|Ride"] = 481.2}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 185.19, ["Neon"] = 2.63, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 16.47, ["Mega|Ride"] = 40, ["Mega|Fly|Ride"] = 176.54}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 48.05, ["Ride"] = 98.44, ["Fly|Ride"] = 236.25, ["Neon"] = 237.38, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 379.6, ["Mega"] = 1029.08, ["Mega|Ride"] = 889.28, ["Mega|Fly|Ride"] = 913.24}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.21, ["Ride"] = 62.91, ["Fly|Ride"] = 278.21, ["Neon"] = 78.75, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 570.08, ["Mega|Ride"] = 603.31, ["Mega|Fly|Ride"] = 640.54}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 19.67, ["Neon"] = 5.25, ["Neon|Ride"] = 35.44, ["Mega"] = 90.93, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 14.13, ["Fly"] = 52.5, ["Ride"] = 35.62, ["Fly|Ride"] = 113.17, ["Neon"] = 51.07, ["Neon|Ride"] = 86.05, ["Neon|Fly|Ride"] = 197.04, ["Mega"] = 409.17, ["Mega|Ride"] = 356.57, ["Mega|Fly|Ride"] = 391.13}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 3.74, ["Fly"] = 33.11, ["Ride"] = 31.5, ["Fly|Ride"] = 52.5, ["Neon"] = 67.43, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 144.18, ["Mega"] = 349.41, ["Mega|Ride"] = 292.6, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 19.69, ["Ride"] = 208.69, ["Neon"] = 165.48, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2135.09, ["Mega|Ride"] = 2418.03, ["Mega|Fly|Ride"] = 1723.02}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.81, ["Ride"] = 48.57, ["Fly|Ride"] = 184.11, ["Neon"] = 10.5, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 118.13, ["Mega|Ride"] = 149.47, ["Mega|Fly|Ride"] = 227.05}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.73, ["Fly"] = 27.77, ["Ride"] = 15.74, ["Fly|Ride"] = 89.25, ["Neon"] = 33.38, ["Neon|Fly"] = 185.77, ["Neon|Ride"] = 59.45, ["Neon|Fly|Ride"] = 91.59, ["Mega"] = 280.51, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 655.49}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 110.15, ["Fly"] = 393.75, ["Ride"] = 154.47, ["Fly|Ride"] = 236.25, ["Neon"] = 433.13, ["Neon|Fly"] = 426.57, ["Neon|Ride"] = 452.81, ["Neon|Fly|Ride"] = 628.45, ["Mega|Ride"] = 2297.13, ["Mega|Fly|Ride"] = 1926.32}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 24.92, ["Ride"] = 15.53, ["Fly|Ride"] = 36.75, ["Neon"] = 11.82, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 77.4, ["Mega"] = 145.69, ["Mega|Ride"] = 239.49, ["Mega|Fly|Ride"] = 190.03}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.23, ["Fly"] = 200.81, ["Ride"] = 38.07, ["Fly|Ride"] = 95.82, ["Neon"] = 68.24, ["Neon|Ride"] = 106.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 452.81, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 548.73}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.32, ["Fly|Ride"] = 64.32, ["Neon"] = 2.1, ["Neon|Fly"] = 31.21, ["Neon|Ride"] = 16.57, ["Neon|Fly|Ride"] = 41.3, ["Mega"] = 13.13, ["Mega|Fly"] = 50.79, ["Mega|Ride"] = 37.56, ["Mega|Fly|Ride"] = 80.06}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.67, ["Fly|Ride"] = 39.38, ["Neon"] = 3.56, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 132.39, ["Mega"] = 19.68, ["Mega|Fly"] = 118.11, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 169.76}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.3, ["Ride"] = 18.69, ["Fly|Ride"] = 133.88, ["Neon"] = 9.44, ["Neon|Ride"] = 55.54, ["Neon|Fly|Ride"] = 100.36, ["Mega"] = 85.32, ["Mega|Ride"] = 272.24, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 34.39, ["Ride"] = 42.11, ["Fly|Ride"] = 131.25, ["Neon"] = 128.62, ["Neon|Ride"] = 341.62, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 459.38, ["Mega|Ride"] = 638.4}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.87, ["Fly|Ride"] = 30.9, ["Neon"] = 9.24, ["Neon|Fly"] = 32.12, ["Neon|Ride"] = 28.83, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 125.98, ["Mega|Fly|Ride"] = 160.31}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 6.56, ["Fly"] = 31.84, ["Ride"] = 25.98, ["Fly|Ride"] = 99.58, ["Neon"] = 33.1, ["Neon|Fly"] = 71.54, ["Neon|Ride"] = 42.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 231, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 170.85, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 18.09, ["Fly|Ride"] = 74.74, ["Neon"] = 8.98, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 54.33, ["Mega|Fly"] = 81.02, ["Mega|Ride"] = 58.47, ["Mega|Fly|Ride"] = 126.73}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 5.96, ["Fly"] = 161.21, ["Ride"] = 23.39, ["Fly|Ride"] = 217.3, ["Neon"] = 37.67, ["Neon|Ride"] = 46.98, ["Neon|Fly|Ride"] = 854.05, ["Mega"] = 254.04, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 384.34, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.31, ["Ride"] = 36.75, ["Neon"] = 50.56, ["Neon|Ride"] = 144.38, ["Mega"] = 357.65, ["Mega|Ride"] = 483.61, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 28.43, ["Ride"] = 19.08, ["Fly|Ride"] = 49.71, ["Neon"] = 22.32, ["Neon|Fly"] = 196.87, ["Neon|Ride"] = 39.45, ["Neon|Fly|Ride"] = 105.7, ["Mega"] = 262.49, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 246.44, ["Mega|Fly|Ride"] = 570.08}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.74, ["Ride"] = 15.54, ["Fly|Ride"] = 52.54, ["Neon"] = 11.46, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 27.61, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 94.49, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 228.46}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 203.44, ["Fly"] = 393.75, ["Ride"] = 196.88, ["Fly|Ride"] = 392.43, ["Neon"] = 1238.65, ["Neon|Ride"] = 1139.08, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4191.91, ["Mega|Fly|Ride"] = 4499.25}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.94, ["Ride"] = 65.63, ["Neon"] = 21, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 427.03, ["Mega"] = 123.37, ["Mega|Ride"] = 638.67, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.87, ["Fly"] = 106.36, ["Ride"] = 23.65, ["Fly|Ride"] = 85.17, ["Neon"] = 24.25, ["Neon|Fly"] = 242.34, ["Neon|Ride"] = 59.79, ["Neon|Fly|Ride"] = 149.47, ["Mega"] = 225.7, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 524.98}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 2.48, ["Fly|Ride"] = 212.89, ["Neon"] = 36.75, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 479.73, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.4, ["Fly|Ride"] = 32.34, ["Neon"] = 2.1, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.21, ["Mega|Fly"] = 79.02, ["Mega|Ride"] = 41.91, ["Mega|Fly|Ride"] = 88.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 6.57, ["Fly"] = 42.54, ["Ride"] = 17.07, ["Fly|Ride"] = 57.75, ["Neon"] = 14.89, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 113.17, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 196.77}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.1, ["Ride"] = 143.07, ["Neon"] = 8.55, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 41.55, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 256.23}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 68.91, ["Fly"] = 99.75, ["Ride"] = 107.92, ["Fly|Ride"] = 175.23, ["Neon"] = 301.88, ["Neon|Fly"] = 435.47, ["Neon|Ride"] = 409.49, ["Neon|Fly|Ride"] = 427.03, ["Mega|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.83, ["Fly"] = 71.54, ["Ride"] = 26.23, ["Fly|Ride"] = 141.73, ["Neon"] = 24.18, ["Neon|Ride"] = 66.94, ["Mega"] = 167.99, ["Mega|Ride"] = 167.48, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.33, ["Fly"] = 49.12, ["Ride"] = 34.12, ["Neon"] = 6.27, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 541.42, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 44.61, ["Fly"] = 131.25, ["Ride"] = 91.88, ["Fly|Ride"] = 179.84, ["Neon"] = 135.14, ["Neon|Ride"] = 162.56, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 538.12, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 28.73, ["Ride"] = 13.9, ["Fly|Ride"] = 31.16, ["Neon"] = 2.1, ["Neon|Fly"] = 17.1, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 32.45, ["Mega"] = 19.57, ["Mega|Fly"] = 45.49, ["Mega|Ride"] = 30.18, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 3.62, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 71.6, ["Mega"] = 22.74, ["Mega|Ride"] = 78.63, ["Mega|Fly|Ride"] = 176.07}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 3.84, ["Ride"] = 47.76, ["Neon"] = 6.34, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 142.65, ["Mega"] = 59.85, ["Mega|Fly"] = 185.77, ["Mega|Ride"] = 113.54, ["Mega|Fly|Ride"] = 169.41}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.14, ["Fly"] = 90.75, ["Ride"] = 50.18, ["Fly|Ride"] = 128.34, ["Neon"] = 19.48, ["Neon|Fly"] = 91.83, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 157.81, ["Mega"] = 115.49, ["Mega|Fly"] = 347.02, ["Mega|Ride"] = 174.99, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.89, ["Ride"] = 14.22, ["Fly|Ride"] = 24.91, ["Neon"] = 2.1, ["Neon|Fly"] = 24.5, ["Neon|Ride"] = 17.98, ["Neon|Fly|Ride"] = 44.54, ["Mega"] = 17.04, ["Mega|Ride"] = 64.31, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.27, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 65.63, ["Neon|Fly"] = 427.03, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 507.1, ["Mega|Ride"] = 590.62, ["Mega|Fly|Ride"] = 720.61}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2100, ["Fly"] = 2757.79, ["Ride"] = 2401.25, ["Fly|Ride"] = 2321.71, ["Neon"] = 10675.4, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44302.88}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 15.08, ["Fly|Ride"] = 30.19, ["Neon"] = 3.94, ["Neon|Fly"] = 58.5, ["Neon|Ride"] = 23.66, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 70.65, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 84.08, ["Mega|Fly|Ride"] = 141.73}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 53.55, ["Neon"] = 8.6, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 162.02, ["Mega|Fly|Ride"] = 356.57}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 10.17, ["Fly"] = 143.07, ["Ride"] = 27.71, ["Fly|Ride"] = 131.25, ["Neon"] = 73.49, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 459.38, ["Mega|Ride"] = 399, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 24.85, ["Fly"] = 91.83, ["Ride"] = 64.2, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 461.76, ["Mega|Ride"] = 597.84, ["Mega|Fly|Ride"] = 700.32}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 103.95, ["Fly"] = 213.52, ["Ride"] = 156.18, ["Fly|Ride"] = 255.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 716.98, ["Mega"] = 6405.25, ["Mega|Fly|Ride"] = 3815.4}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 7.2, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 19.69, ["Neon|Ride"] = 92.89, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 226.1, ["Mega|Fly|Ride"] = 362.98}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.3, ["Neon"] = 13.01, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 102, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 6.54, ["Neon|Fly"] = 106.77, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 211.38, ["Mega"] = 58.06, ["Mega|Ride"] = 111.18, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.17, ["Ride"] = 50.84, ["Fly|Ride"] = 131.25, ["Neon"] = 98.44, ["Neon|Ride"] = 176.61, ["Neon|Fly|Ride"] = 502.83, ["Mega"] = 386.92, ["Mega|Ride"] = 470.8, ["Mega|Fly|Ride"] = 584.73}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 42.72, ["Neon"] = 2.37, ["Neon|Ride"] = 26.25, ["Mega"] = 16.04, ["Mega|Fly"] = 120.91, ["Mega|Ride"] = 80.07, ["Mega|Fly|Ride"] = 134.54}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 72.19, ["Fly"] = 106.77, ["Ride"] = 104.99, ["Fly|Ride"] = 155.88, ["Neon"] = 346.5, ["Neon|Fly"] = 456.92, ["Neon|Ride"] = 413.16, ["Neon|Fly|Ride"] = 337.61, ["Mega"] = 3202.63, ["Mega|Fly|Ride"] = 1870.36}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 91.83, ["Fly|Ride"] = 51.19, ["Neon"] = 3.53, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 213.52, ["Mega"] = 70.88, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 34.12, ["Fly"] = 102.51, ["Ride"] = 65.62, ["Fly|Ride"] = 280.77, ["Neon"] = 255.94, ["Neon|Ride"] = 389.84, ["Neon|Fly|Ride"] = 452.22, ["Mega"] = 2625, ["Mega|Ride"] = 1708.08, ["Mega|Fly|Ride"] = 1773.63}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 21.37, ["Fly|Ride"] = 51.64, ["Neon"] = 3.72, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 44.31, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Ride"] = 57.67, ["Fly|Ride"] = 109.98, ["Neon"] = 9.18, ["Neon|Ride"] = 98.44, ["Mega"] = 53.55, ["Mega|Ride"] = 143.08, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.94, ["Fly"] = 77.43, ["Ride"] = 33.11, ["Fly|Ride"] = 143.07, ["Neon"] = 19.37, ["Neon|Ride"] = 94.33, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 301.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 567.95}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 313.69, ["Ride"] = 404.51, ["Fly|Ride"] = 472.5, ["Neon"] = 970.51, ["Neon|Ride"] = 980.42, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3274.16, ["Mega|Ride"] = 2361.19, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 32.67, ["Fly"] = 57.67, ["Ride"] = 44.86, ["Fly|Ride"] = 131.23, ["Neon"] = 183.75, ["Neon|Ride"] = 233.81, ["Neon|Fly|Ride"] = 255.84, ["Mega|Ride"] = 1131.61, ["Mega|Fly|Ride"] = 1708.08}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 45.01, ["Ride"] = 16.11, ["Fly|Ride"] = 111.57, ["Neon"] = 13.13, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 28.79, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 128.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 314.89}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 14.42, ["Fly"] = 65.63, ["Ride"] = 49.88, ["Fly|Ride"] = 131.25, ["Neon"] = 77.06, ["Neon|Fly"] = 162.09, ["Neon|Ride"] = 144.12, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 287.44, ["Mega|Fly"] = 427.03, ["Mega|Ride"] = 403.82, ["Mega|Fly|Ride"] = 454.79}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 3.94, ["Ride"] = 30.87, ["Neon"] = 54.46, ["Neon|Ride"] = 122.06, ["Neon|Fly|Ride"] = 256.23, ["Mega"] = 1139.08, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.28, ["Neon"] = 19.69, ["Mega"] = 91.88, ["Mega|Ride"] = 320.28, ["Mega|Fly|Ride"] = 409.96}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.94, ["Fly"] = 71.54, ["Ride"] = 20.96, ["Fly|Ride"] = 65.51, ["Neon"] = 36.75, ["Neon|Ride"] = 50.16, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 160.13, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 97.81, ["Fly"] = 226.2, ["Ride"] = 117.43, ["Fly|Ride"] = 162.1, ["Neon"] = 797.47, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Ride"] = 3547.25, ["Mega|Fly|Ride"] = 3202.63}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.69, ["Ride"] = 41.58, ["Fly|Ride"] = 91.88, ["Neon"] = 154.88, ["Neon|Ride"] = 235.94, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 620.91, ["Mega|Ride"] = 725.94, ["Mega|Fly|Ride"] = 731.07}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1818.43, ["Fly"] = 2058.97, ["Ride"] = 2034.38, ["Fly|Ride"] = 2100, ["Neon"] = 11387.44, ["Neon|Fly|Ride"] = 6300, ["Mega|Fly|Ride"] = 21654.94}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.55, ["Fly"] = 65625, ["Ride"] = 18.38, ["Fly|Ride"] = 196.87, ["Neon"] = 12.86, ["Neon|Fly|Ride"] = 640.54, ["Mega"] = 118.13, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 177.85, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 3.93, ["Ride"] = 36.75, ["Fly|Ride"] = 131.25, ["Neon"] = 30.02, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 138.36, ["Mega|Fly"] = 271.17, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 826.77, ["Fly"] = 1480.69, ["Ride"] = 787.49, ["Fly|Ride"] = 866.04, ["Neon"] = 2778.57, ["Neon|Ride"] = 2359.19, ["Neon|Fly|Ride"] = 2302.04, ["Mega|Fly|Ride"] = 11445.69}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 26.25, ["Ride"] = 49.88, ["Fly|Ride"] = 173.35, ["Neon"] = 212.91, ["Neon|Ride"] = 223.79, ["Neon|Fly|Ride"] = 356.57, ["Mega"] = 845.16, ["Mega|Ride"] = 678.57, ["Mega|Fly|Ride"] = 751.55}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.29, ["Ride"] = 23.44, ["Fly|Ride"] = 100.36, ["Neon"] = 6.54, ["Neon|Ride"] = 42.6, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 322.02, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 143.07, ["Neon"] = 4.29, ["Neon|Ride"] = 49.31, ["Neon|Fly|Ride"] = 104.64, ["Mega"] = 22.18, ["Mega|Ride"] = 79.02, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 77.44, ["Ride"] = 130.69, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 636.26, ["Mega"] = 2418.19, ["Mega|Fly|Ride"] = 2135.09}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 71.54, ["Fly|Ride"] = 74.03, ["Neon"] = 9.84, ["Neon|Ride"] = 45.98, ["Neon|Fly|Ride"] = 128.13, ["Mega"] = 109.27, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 52.5, ["Fly"] = 100.36, ["Ride"] = 126, ["Fly|Ride"] = 242.34, ["Neon"] = 427.03, ["Neon|Ride"] = 562.61, ["Mega|Fly|Ride"] = 1743.39}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.81, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 35.35, ["Neon|Fly|Ride"] = 315, ["Mega"] = 315, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 210, ["Fly"] = 322.98, ["Ride"] = 262.5, ["Fly|Ride"] = 320.77, ["Neon"] = 1137.32, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 879.15, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 3.13, ["Fly"] = 91.88, ["Ride"] = 16.93, ["Fly|Ride"] = 36.75, ["Neon"] = 20.68, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 321.63, ["Mega|Ride"] = 209.3, ["Mega|Fly|Ride"] = 265.79}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.75, ["Ride"] = 14.6, ["Fly|Ride"] = 31.59, ["Neon"] = 4.24, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 42, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1277.31, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7829.34, ["Neon|Fly|Ride"] = 6533.36, ["Mega"] = 23698.04, ["Mega|Fly|Ride"] = 28468.07}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 6.92, ["Fly"] = 994.12, ["Ride"] = 72.19, ["Neon"] = 76.04, ["Neon|Ride"] = 128.13, ["Mega"] = 244.59, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.99, ["Fly"] = 39.38, ["Ride"] = 31.97, ["Fly|Ride"] = 122.06, ["Neon"] = 19.69, ["Neon|Fly"] = 285.05, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 102.37, ["Mega"] = 140.6, ["Mega|Ride"] = 263.82, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 32.82, ["Fly"] = 34.08, ["Ride"] = 32.34, ["Fly|Ride"] = 70.06, ["Neon"] = 427.03, ["Neon|Fly"] = 213.52, ["Neon|Ride"] = 209.9, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 2562.11, ["Mega|Ride"] = 1129.23, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 13.13, ["Fly"] = 100.36, ["Ride"] = 28.58, ["Fly|Ride"] = 78.75, ["Neon"] = 58.45, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 100.36, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 429.26}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 48.3, ["Ride"] = 128.13, ["Fly|Ride"] = 497.37, ["Neon"] = 204.75, ["Neon|Fly"] = 319.22, ["Neon|Ride"] = 271.17, ["Neon|Fly|Ride"] = 370.44, ["Mega"] = 1024.85, ["Mega|Ride"] = 912.76, ["Mega|Fly|Ride"] = 912.76}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 285.05, ["Neon"] = 3.65, ["Neon|Ride"] = 113.72, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 16.51, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 80.07, ["Fly"] = 128.13, ["Ride"] = 91.77, ["Fly|Ride"] = 191.44, ["Neon"] = 446.24, ["Neon|Fly"] = 564.89, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 3416.14, ["Mega|Fly|Ride"] = 1666.88}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.43, ["Fly|Ride"] = 66.68, ["Neon"] = 143.07, ["Neon|Ride"] = 95.95, ["Neon|Fly|Ride"] = 170.82, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 427.03}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 16.04, ["Fly|Ride"] = 38.16, ["Neon"] = 20.22, ["Neon|Fly"] = 81.05, ["Neon|Ride"] = 75.81, ["Neon|Fly|Ride"] = 122.85, ["Mega"] = 72544.99, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 16.04, ["Neon|Fly"] = 140.93, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 202.34, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 54.57, ["Ride"] = 196.77, ["Fly|Ride"] = 358.05, ["Neon"] = 328.13, ["Neon|Ride"] = 408.89, ["Neon|Fly|Ride"] = 727.12, ["Mega"] = 1830.85, ["Mega|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 2.73, ["Fly|Ride"] = 427.03, ["Neon"] = 18.67, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 122.79, ["Mega"] = 126.88, ["Mega|Ride"] = 213.52, ["Mega|Fly|Ride"] = 281.84}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.37, ["Ride"] = 36.66, ["Neon"] = 2.63, ["Neon|Ride"] = 118.55, ["Neon|Fly|Ride"] = 71.54, ["Mega"] = 16.96, ["Mega|Ride"] = 194.28, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.92, ["Ride"] = 36.11, ["Fly|Ride"] = 142.72, ["Neon"] = 3.8, ["Neon|Ride"] = 21.37, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 19.39, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.04, ["Fly|Ride"] = 52.41, ["Neon"] = 5.25, ["Neon|Ride"] = 32.04, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.7}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 113.89, ["Neon"] = 24.35, ["Neon|Ride"] = 65.63, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 14.42, ["Fly|Ride"] = 30.19, ["Neon"] = 9.97, ["Neon|Fly"] = 213.05, ["Neon|Ride"] = 31.99, ["Neon|Fly|Ride"] = 94.17, ["Mega"] = 170.63, ["Mega|Ride"] = 131.81, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 53.82, ["Ride"] = 101.72, ["Fly|Ride"] = 280.77, ["Neon"] = 217.74, ["Neon|Ride"] = 324.07, ["Neon|Fly|Ride"] = 1067.55, ["Mega"] = 695.63, ["Mega|Ride"] = 854.05, ["Mega|Fly|Ride"] = 1129.23}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.69, ["Ride"] = 15.74, ["Fly|Ride"] = 42.72, ["Neon"] = 2.1, ["Neon|Fly"] = 21.37, ["Neon|Ride"] = 17.05, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 42, ["Mega|Ride"] = 124.5, ["Mega|Fly|Ride"] = 95.82}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 6.57, ["Fly"] = 80.08, ["Ride"] = 23.83, ["Fly|Ride"] = 78.75, ["Neon"] = 31.49, ["Neon|Fly"] = 91.76, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 98.4, ["Mega"] = 301.87, ["Mega|Fly"] = 285.05, ["Mega|Ride"] = 321.57, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 16.95, ["Fly"] = 57.67, ["Ride"] = 40.43, ["Fly|Ride"] = 103.69, ["Neon"] = 128.1, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 209.89, ["Mega"] = 787.5, ["Mega|Ride"] = 676.83, ["Mega|Fly|Ride"] = 587.35}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.33, ["Fly"] = 196.88, ["Neon"] = 74.69, ["Neon|Ride"] = 103.69, ["Mega"] = 393.75, ["Mega|Ride"] = 448.28, ["Mega|Fly|Ride"] = 357}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.38, ["Ride"] = 15.75, ["Fly|Ride"] = 32.81, ["Neon"] = 3.89, ["Neon|Fly"] = 28.1, ["Neon|Ride"] = 18.11, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 39.29, ["Mega|Ride"] = 46.13, ["Mega|Fly|Ride"] = 112.6}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 5.91, ["Fly"] = 78.82, ["Ride"] = 37.97, ["Fly|Ride"] = 54.36, ["Neon"] = 28.85, ["Neon|Ride"] = 127.76, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 196.87, ["Mega|Fly"] = 735, ["Mega|Ride"] = 301.87, ["Mega|Fly|Ride"] = 443.04}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1352.59, ["Ride"] = 979.12, ["Fly|Ride"] = 1056.57, ["Neon"] = 3132.18, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 7199.06}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 95.81, ["Ride"] = 285.05, ["Fly|Ride"] = 636.41, ["Neon"] = 712.06, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 945, ["Mega"] = 3201.56, ["Mega|Ride"] = 3560.26, ["Mega|Fly|Ride"] = 2546.25}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 6.16, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.18, ["Mega"] = 78.49, ["Mega|Fly|Ride"] = 1139.08}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 82.68, ["Ride"] = 162.1, ["Fly|Ride"] = 285.05, ["Neon"] = 447.55, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1967.44, ["Mega|Ride"] = 1921.59, ["Mega|Fly|Ride"] = 1857.97}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Ride"] = 20.67, ["Neon"] = 15.21, ["Neon|Fly"] = 56.87, ["Neon|Ride"] = 53.21, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 118.12, ["Mega|Ride"] = 477.41, ["Mega|Fly|Ride"] = 285.05}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 254.35, ["Fly"] = 335.23, ["Ride"] = 247.54, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1267.19, ["Neon|Fly|Ride"] = 1365, ["Mega|Fly|Ride"] = 4953.39}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.65, ["Fly|Ride"] = 223.79, ["Neon"] = 23.9, ["Neon|Ride"] = 54.37, ["Mega"] = 241.84, ["Mega|Fly"] = 357.65, ["Mega|Ride"] = 570.08}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 28.85, ["Ride"] = 19.23, ["Neon"] = 43.65, ["Mega"] = 164.07, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 15.64, ["Ride"] = 61.93, ["Fly|Ride"] = 153.64, ["Neon"] = 116.85, ["Neon|Fly"] = 427.03, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 241.84, ["Mega"] = 484.67, ["Mega|Ride"] = 593.57, ["Mega|Fly|Ride"] = 903.15}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.74, ["Neon"] = 31.85, ["Neon|Ride"] = 196.87, ["Mega"] = 241.84, ["Mega|Ride"] = 254.6, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 14.36, ["Fly|Ride"] = 32.47, ["Neon"] = 2.1, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 26.21, ["Neon|Fly|Ride"] = 35.33, ["Mega"] = 19.23, ["Mega|Ride"] = 37.38, ["Mega|Fly|Ride"] = 47.25}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4593.75, ["Ride"] = 4461.19, ["Fly|Ride"] = 5250, ["Neon"] = 32026.17, ["Neon|Fly|Ride"] = 21201.33, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 7.23, ["Fly"] = 85.41, ["Ride"] = 56.44, ["Neon"] = 53.27, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 178.5, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 409.96}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 18.14, ["Fly|Ride"] = 42.61, ["Neon"] = 14.44, ["Neon|Fly"] = 37.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 131.25, ["Mega|Ride"] = 179.36, ["Mega|Fly|Ride"] = 190.03}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 433.13, ["Fly"] = 547.77, ["Ride"] = 459.38, ["Fly|Ride"] = 497.44, ["Neon"] = 1050, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1304.81, ["Mega|Fly|Ride"] = 4725}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.29, ["Ride"] = 40.73, ["Neon"] = 11.82, ["Neon|Ride"] = 291.38, ["Mega"] = 143.07, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 2.63, ["Fly"] = 4269.11, ["Ride"] = 36.3, ["Neon"] = 32.04, ["Neon|Fly"] = 118.52, ["Neon|Ride"] = 65.31, ["Neon|Fly|Ride"] = 306.41, ["Mega"] = 425.97, ["Mega|Ride"] = 284.67, ["Mega|Fly|Ride"] = 498.57}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 50.96, ["Ride"] = 21.38, ["Fly|Ride"] = 48.29, ["Neon"] = 4.92, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 44.52, ["Mega|Ride"] = 67.33, ["Mega|Fly|Ride"] = 131.33}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 611.02, ["Fly"] = 755.84, ["Ride"] = 576.19, ["Fly|Ride"] = 654.91, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2135.44, ["Mega|Fly|Ride"] = 9252.37}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.23, ["Fly"] = 210, ["Ride"] = 65.24, ["Fly|Ride"] = 136.62, ["Neon"] = 32.34, ["Neon|Ride"] = 104.98, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 191.63, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 428.01}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 4.92, ["Fly"] = 236.15, ["Ride"] = 44.51, ["Fly|Ride"] = 76.56, ["Neon"] = 18.17, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 142.71, ["Mega|Fly"] = 806.48, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 272.51}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 16.02, ["Fly|Ride"] = 43.31, ["Neon"] = 15.6, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 82.47, ["Mega"] = 284.19, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 310.68}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 16.75, ["Ride"] = 34.13, ["Fly|Ride"] = 55.6, ["Neon"] = 117.59, ["Neon|Fly|Ride"] = 320.28, ["Mega"] = 570.08, ["Mega|Ride"] = 472.49, ["Mega|Fly|Ride"] = 550.87}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 427.03, ["Neon"] = 6.46, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 140.51, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 32.58, ["Mega|Fly"] = 143.07, ["Mega|Ride"] = 64.31, ["Mega|Fly|Ride"] = 185.22}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 551.25, ["Fly"] = 669.36, ["Ride"] = 538.12, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Ride"] = 9430.28, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.28, ["Ride"] = 80.16, ["Fly|Ride"] = 341.62, ["Neon"] = 11.82, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 446.24, ["Mega"] = 44.86, ["Mega|Ride"] = 262.63}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 34.1, ["Neon"] = 3.83, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 76.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 40.58, ["Mega|Ride"] = 134.22, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.38, ["Neon"] = 4.29, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 46.98, ["Mega|Fly"] = 158.01, ["Mega|Ride"] = 118.52, ["Mega|Fly|Ride"] = 170.82}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 20.29, ["Mega"] = 213.52, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 22.77, ["Fly"] = 64.97, ["Ride"] = 48.4, ["Fly|Ride"] = 144.37, ["Neon"] = 105, ["Neon|Fly"] = 213.52, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 511.88, ["Mega|Ride"] = 437.06, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 16, ["Ride"] = 74.71, ["Fly|Ride"] = 129.44, ["Neon"] = 65.63, ["Neon|Ride"] = 186.83, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 510.29, ["Mega|Ride"] = 441.13, ["Mega|Fly|Ride"] = 550.04}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 14.44, ["Fly|Ride"] = 33.15, ["Neon"] = 28.75, ["Neon|Fly"] = 143.07, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 88.1, ["Mega"] = 249.1, ["Mega|Ride"] = 285.05, ["Mega|Fly|Ride"] = 319.52}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.61, ["Ride"] = 143.07, ["Fly|Ride"] = 134.52, ["Neon"] = 38.05, ["Neon|Ride"] = 143.07}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.16, ["Fly|Ride"] = 100.12, ["Neon"] = 6.35, ["Neon|Ride"] = 38.72, ["Neon|Fly|Ride"] = 114.23, ["Mega"] = 69.57, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 273.26}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 20.44, ["Fly"] = 113.71, ["Ride"] = 26.25, ["Fly|Ride"] = 43.57, ["Neon"] = 109.15, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 196.45, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 849.78}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 29.23, ["Fly"] = 874.13, ["Neon"] = 133.88, ["Mega"] = 384.34, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 38.95, ["Fly"] = 153.58, ["Ride"] = 59.06, ["Fly|Ride"] = 91.88, ["Neon"] = 324.83, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 415.79, ["Mega|Ride"] = 1709.55, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 38.36, ["Fly"] = 85.05, ["Ride"] = 62.92, ["Fly|Ride"] = 131.25, ["Neon"] = 150.61, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 309.75, ["Mega"] = 551.25, ["Mega|Ride"] = 691.79, ["Mega|Fly|Ride"] = 632}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 11.95, ["Ride"] = 57.5, ["Neon"] = 114.27, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 806.43, ["Mega|Fly|Ride"] = 809.22}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 15.75, ["Fly"] = 81.73, ["Ride"] = 52.5, ["Fly|Ride"] = 194.33, ["Neon"] = 101.35, ["Neon|Fly"] = 249.82, ["Neon|Ride"] = 212.14, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 540.04, ["Mega|Ride"] = 583.95, ["Mega|Fly|Ride"] = 644.72}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.95, ["Ride"] = 14.43, ["Fly|Ride"] = 32.74, ["Neon"] = 3.46, ["Neon|Fly"] = 27.36, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 54.3, ["Mega"] = 38.64, ["Mega|Fly"] = 322.83, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.23}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 64.19, ["Fly"] = 483.86, ["Ride"] = 108.19, ["Fly|Ride"] = 262.39, ["Neon"] = 378, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1417.5, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 3.19, ["Neon|Fly"] = 100.36, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 298.04, ["Mega"] = 27.57, ["Mega|Ride"] = 84.96, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.2, ["Ride"] = 114.23, ["Fly|Ride"] = 142.65, ["Neon"] = 127.32, ["Neon|Ride"] = 128.13, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 497.44, ["Mega|Fly|Ride"] = 721.87}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.57, ["Neon|Fly|Ride"] = 106.77, ["Mega"] = 26.16}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Mega"] = 21.37, ["Mega|Ride"] = 152.35, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 85.22, ["Fly"] = 223.13, ["Ride"] = 144.37, ["Fly|Ride"] = 328.13, ["Neon"] = 433.13, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.32, ["Mega|Ride"] = 2577.63, ["Mega|Fly|Ride"] = 2098.52}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 96.78, ["Neon"] = 7.8, ["Neon|Fly"] = 42.72, ["Neon|Ride"] = 32.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.19, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 53.82, ["Neon"] = 5.2, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 31.18, ["Mega|Ride"] = 95.52, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 61.22, ["Neon"] = 8.47, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 236.15, ["Mega"] = 106.97, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 483.61}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 89.24, ["Neon"] = 7.88, ["Neon|Ride"] = 156.09, ["Mega"] = 91.88, ["Mega|Ride"] = 337.57, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 90.57, ["Ride"] = 131.24, ["Fly|Ride"] = 356.57, ["Neon"] = 437.07, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 2278.14, ["Mega|Ride"] = 2176.22, ["Mega|Fly|Ride"] = 2121.21}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.93, ["Ride"] = 75.99, ["Neon"] = 89.06, ["Neon|Ride"] = 39.38, ["Mega"] = 422.29, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 393.65, ["Ride"] = 421.19, ["Fly|Ride"] = 517.73, ["Neon"] = 1752.19, ["Neon|Ride"] = 1424.11, ["Neon|Fly|Ride"] = 1102.5, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 87.26}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.65}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.75}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.07}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 41.99}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 12.5}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.74}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 144.38}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 13.41}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 34.04}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 839.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 4.67}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.25}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.25}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 3.72}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 14.16}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 591.09}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 6.48}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1312.5}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.41}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 9.18}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 34.11}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 16.2}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 36.68}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 50.16}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.06}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 14.2}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.19}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.84}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 13.01}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 4.71}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.15}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 20.9}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 5.07}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2989.12}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 42.41}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 311.05}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.14}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 12.18}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 212.62}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 7.16}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.08}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 144.38}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 21.94}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 8.56}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 25.55}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.5}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 106.32}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 20.99}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 6.57}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 20.9}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 6.46}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 7.77}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.86}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 233.63}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 5.18}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 7.34}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 18.17}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.85}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 61.68}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24070.01}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 42}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 36.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.56}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 40.58}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 85.89}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.38}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.08}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 85.3}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 422.71}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 65.34}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 39.31}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 5197.5}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 9.19}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.44}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 3.94}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.05}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 106.21}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.24}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 3.92}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 11.46}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1128.23}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.24}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 584.07}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.16}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 26.15}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 91.88}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 15.44}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 28.55}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.51}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.92}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.86}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.83}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 5.17}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.68}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 3.4}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.3}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 145.69}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 51.54}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.63}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 213.52}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 12.89}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.08}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.58}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 24.93}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.76}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.85}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 3.94}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 5.94}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 16.89}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 16.11}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.59}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 2.97}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.35}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 8.18}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 2.27}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 2.94}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.93}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 3.19}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 6.17}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 9394.35}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 11.67}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 52.41}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.15}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.46}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.88}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.17}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.19}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.3}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.1}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.93}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4517.68}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 3.93}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 33.39}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.41}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.39}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 56.26}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.89}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 105}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 7.88}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.42}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.99}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 18.25}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 5.51}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 5.23}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.51}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.45}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.92}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 15.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 4.56}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 10.4}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 275.42}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 79.71}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 9}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.29}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1213.94}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 64.18}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.25}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.62}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 24.32}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 4.98}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 6.42}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 13.55}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 16.51}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 10.5}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.01}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 7.8}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 6.57}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 20.88}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 9.19}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 58.86}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.92}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 131.06}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 90.57}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.73}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 4.11}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 199.6}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 3.94}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 6.07}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.93}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 75.51}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 157.5}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 10.16}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.9}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.52}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 9.19}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 4.5}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 58.7}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 14.44}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.49}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 106.77}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 15.99}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 17.25}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.56}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.42}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.39}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 12.81}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.91}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.58}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.6}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 5.91}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 32.72}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 132.4}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.67}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 82.74}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.01}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.35}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 57.37}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 48.45}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 99.01}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 59.17}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 6.14}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 127.93}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 26.25}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 51.19}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.69}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 7.76}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.28}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 11.82}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13.12}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 74.4}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 38.07}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 85.41}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 14.23}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 19.69}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 23.14}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 11.46}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 53.82}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 43.99}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 26.23}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.33}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 354.38}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 15.39}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 5.91}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 5.25}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.8}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 318.83}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 57}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 54.51}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 192.95}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 73.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 155.91}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 7.67}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2362.5}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.24}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 4.29}},
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