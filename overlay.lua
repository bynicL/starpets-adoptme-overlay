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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 1141.88, ["Ride"] = 1050, ["Fly|Ride"] = 1312.5, ["Neon"] = 6805.19, ["Neon|Fly|Ride"] = 5118.75, ["Mega|Fly|Ride"] = 18634.04}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 392.44, ["Ride"] = 473.92, ["Fly|Ride"] = 610.17, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 12152.11, ["Mega|Fly|Ride"] = 7066.78}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 5936.44, ["Ride"] = 5250, ["Fly|Ride"] = 4917.94, ["Neon|Fly|Ride"] = 14700, ["Mega|Fly|Ride"] = 71381.89}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 161.44, ["Fly"] = 210, ["Ride"] = 220.96, ["Fly|Ride"] = 278.4, ["Neon"] = 1000.08, ["Neon|Ride"] = 979.13, ["Neon|Fly|Ride"] = 1069.67, ["Mega|Fly|Ride"] = 4265.63}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 548.63, ["Fly"] = 856.59, ["Ride"] = 547.03, ["Fly|Ride"] = 557.71, ["Neon|Fly|Ride"] = 1719.19, ["Mega|Fly|Ride"] = 7023.93}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 7.9, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 70.74, ["Neon|Fly"] = 285.9, ["Neon|Ride"] = 84.13, ["Neon|Fly|Ride"] = 404.25, ["Mega"] = 313.15, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.84, ["Fly"] = 44.43, ["Ride"] = 28.23, ["Fly|Ride"] = 65.63, ["Neon"] = 31.5, ["Neon|Fly"] = 99.75, ["Neon|Ride"] = 62.55, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 131.25, ["Mega|Ride"] = 242.01, ["Mega|Fly|Ride"] = 297.84}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 111.57, ["Ride"] = 185.07, ["Fly|Ride"] = 227.75, ["Neon"] = 498.75, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 714.18, ["Mega"] = 1586.82, ["Mega|Ride"] = 1847.13, ["Mega|Fly|Ride"] = 2795.67}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 36.37, ["Fly"] = 97.75, ["Ride"] = 48.06, ["Fly|Ride"] = 97.76, ["Neon"] = 257.62, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 325.5, ["Mega"] = 1428.36, ["Mega|Ride"] = 1135.02, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 26.24, ["Fly"] = 57.84, ["Ride"] = 32.4, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 197.03, ["Neon|Fly|Ride"] = 164.07, ["Mega|Ride"] = 449.03, ["Mega|Fly|Ride"] = 701.32}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 58.46, ["Fly"] = 128.5, ["Ride"] = 70.88, ["Fly|Ride"] = 154.2, ["Neon"] = 341.84, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 428.31, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 59.07}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 353.35, ["Fly"] = 399, ["Ride"] = 323.52, ["Fly|Ride"] = 383.32, ["Neon|Ride"] = 1048.69, ["Neon|Fly|Ride"] = 1135.32, ["Mega|Fly|Ride"] = 5137.34}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 115.5, ["Fly"] = 137.81, ["Ride"] = 110.44, ["Fly|Ride"] = 168, ["Neon|Fly"] = 702.41, ["Neon|Ride"] = 573.57, ["Neon|Fly|Ride"] = 618.21, ["Mega|Fly|Ride"] = 3119.46}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.38, ["Fly"] = 131.25, ["Ride"] = 54.51, ["Fly|Ride"] = 131.25, ["Neon"] = 19.59, ["Neon|Ride"] = 47.76, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 131.25, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 323.37, ["Mega|Fly|Ride"] = 255.22}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 190.11, ["Fly"] = 287.44, ["Ride"] = 204.12, ["Fly|Ride"] = 210, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 649.47, ["Mega|Fly|Ride"] = 2729.9}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.5, ["Fly"] = 24.3, ["Ride"] = 21.44, ["Fly|Ride"] = 38.56, ["Neon"] = 28.86, ["Neon|Fly"] = 128.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 204.75, ["Mega|Fly"] = 364.58, ["Mega|Fly|Ride"] = 413.19}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 90.2, ["Fly"] = 162.85, ["Ride"] = 123.44, ["Fly|Ride"] = 157.5, ["Neon"] = 335.57, ["Neon|Ride"] = 374.51, ["Neon|Fly|Ride"] = 421.89, ["Mega"] = 1703.79, ["Mega|Ride"] = 1419.5, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.49}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 65.54, ["Ride"] = 166.57, ["Fly|Ride"] = 214.16, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 714.18, ["Mega|Fly|Ride"] = 2000.13}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 14.3, ["Fly"] = 55.69, ["Ride"] = 32.81, ["Fly|Ride"] = 134.92, ["Neon"] = 262.5, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2625, ["Mega|Ride"] = 714.18, ["Mega|Fly|Ride"] = 714.18}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.05, ["Fly"] = 143.5, ["Ride"] = 57.75, ["Fly|Ride"] = 102.38, ["Neon"] = 214.16, ["Neon|Ride"] = 220.49, ["Neon|Fly|Ride"] = 246.87, ["Mega"] = 1701.31, ["Mega|Ride"] = 1027.9, ["Mega|Fly|Ride"] = 930.79}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 45.94, ["Fly"] = 78.75, ["Ride"] = 111.56, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Fly"] = 403.46, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 467.25, ["Mega"] = 1967.44, ["Mega|Ride"] = 1642.5, ["Mega|Fly|Ride"] = 1296.65}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 28.87, ["Ride"] = 31.5, ["Fly|Ride"] = 156.85, ["Neon"] = 120.65, ["Neon|Ride"] = 213.08, ["Neon|Fly|Ride"] = 252.77, ["Mega"] = 1207.92, ["Mega|Ride"] = 1242.06, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 31.49, ["Fly"] = 136.75, ["Ride"] = 57.66, ["Fly|Ride"] = 162.85, ["Neon"] = 325.5, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 262.49, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 977.82}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 5.25, ["Fly"] = 23.63, ["Ride"] = 23.39, ["Fly|Ride"] = 62.52, ["Neon"] = 32.81, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 57.83, ["Neon|Fly|Ride"] = 87.27, ["Mega"] = 128.63, ["Mega|Fly"] = 27000.57, ["Mega|Ride"] = 165.38, ["Mega|Fly|Ride"] = 246.66}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 393.75, ["Ride"] = 420, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1964.82, ["Mega"] = 10707.24, ["Mega|Fly|Ride"] = 9137.56}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 19.59, ["Ride"] = 32.81, ["Fly|Ride"] = 114.26, ["Neon"] = 212.66, ["Neon|Fly|Ride"] = 256.99, ["Mega|Ride"] = 813.77, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.3, ["Fly"] = 38.07, ["Ride"] = 20.73, ["Fly|Ride"] = 45.39, ["Neon"] = 51.95, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 123.45, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 530.01}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 76.12, ["Fly"] = 106.01, ["Ride"] = 77.97, ["Fly|Ride"] = 131.25, ["Neon"] = 373.09, ["Neon|Fly"] = 375.84, ["Neon|Ride"] = 392.97, ["Neon|Fly|Ride"] = 399, ["Mega"] = 6439.41, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1785}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.81, ["Ride"] = 32.23, ["Fly|Ride"] = 75.21, ["Neon"] = 88.04, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 199.19, ["Mega"] = 701.53, ["Mega|Ride"] = 729.15, ["Mega|Fly|Ride"] = 777.75}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 190.32, ["Fly"] = 288.75, ["Ride"] = 223.39, ["Fly|Ride"] = 282.69, ["Neon"] = 794.76, ["Neon|Ride"] = 713.12, ["Neon|Fly|Ride"] = 972.18, ["Mega"] = 6424.36, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2933.6}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.76, ["Fly"] = 35.43, ["Ride"] = 24.64, ["Fly|Ride"] = 55.12, ["Neon"] = 20.99, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 105, ["Mega"] = 141.75, ["Mega|Fly"] = 483.68, ["Mega|Ride"] = 160.62, ["Mega|Fly|Ride"] = 276.26}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 840, ["Fly"] = 2625, ["Ride"] = 787.5, ["Fly|Ride"] = 917.44, ["Neon"] = 6423.29, ["Neon|Ride"] = 4854.68, ["Neon|Fly|Ride"] = 4281.84, ["Mega|Ride"] = 54684.46, ["Mega|Fly|Ride"] = 17131.58}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 14.44, ["Fly"] = 49.41, ["Ride"] = 34.13, ["Fly|Ride"] = 91.88, ["Neon"] = 129.94, ["Neon|Ride"] = 100.67, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 787.5, ["Mega|Ride"] = 796.63, ["Mega|Fly|Ride"] = 810.55}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 171.93, ["Fly"] = 364.58, ["Ride"] = 220.89, ["Fly|Ride"] = 315.88, ["Neon"] = 830.82, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 47.13}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 14.32, ["Fly"] = 114.58, ["Ride"] = 65.63, ["Fly|Ride"] = 143.5, ["Neon"] = 85.03, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 342.65, ["Mega"] = 349.69, ["Mega|Ride"] = 561.51, ["Mega|Fly|Ride"] = 534.31}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 111.18, ["Ride"] = 158.82, ["Fly|Ride"] = 262.5, ["Neon"] = 639.19, ["Neon|Ride"] = 486.1, ["Neon|Fly|Ride"] = 491.15, ["Mega|Fly|Ride"] = 2157.52}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 98.44, ["Fly"] = 157.49, ["Ride"] = 149.51, ["Fly|Ride"] = 262.5, ["Neon"] = 360.94, ["Neon|Fly"] = 571.78, ["Neon|Ride"] = 340.27, ["Neon|Fly|Ride"] = 472.5, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1241.63}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 41.33}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 59.07, ["Fly"] = 79.25, ["Ride"] = 58.47, ["Fly|Ride"] = 63.27, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 4282.9, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 5.97, ["Fly"] = 42.84, ["Ride"] = 57.84, ["Fly|Ride"] = 157.5, ["Neon"] = 40.69, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 240.93, ["Mega"] = 129.94, ["Mega|Fly"] = 364.58, ["Mega|Ride"] = 298.96, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 549.94, ["Fly"] = 614.95, ["Ride"] = 477.75, ["Fly|Ride"] = 557.82, ["Neon|Fly"] = 3854.62, ["Neon|Ride"] = 1846.49, ["Neon|Fly|Ride"] = 1745.63, ["Mega|Ride"] = 14990.13, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 94.75, ["Fly"] = 158.48, ["Ride"] = 129.94, ["Fly|Ride"] = 168.7, ["Neon"] = 477.75, ["Neon|Ride"] = 556.5, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 2568.67, ["Mega|Fly|Ride"] = 2536.21}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4052.74, ["Ride"] = 3885, ["Fly|Ride"] = 3675, ["Neon|Fly|Ride"] = 14989.07}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 52.5, ["Fly"] = 119.89, ["Ride"] = 56.94, ["Fly|Ride"] = 131.15, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1925.18, ["Mega|Ride"] = 2141.46, ["Mega|Fly|Ride"] = 1548.75}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 63, ["Ride"] = 70.88, ["Fly|Ride"] = 142.43, ["Neon"] = 575.75, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 426.05, ["Mega"] = 6281.94, ["Mega|Ride"] = 2284.94, ["Mega|Fly|Ride"] = 2209.56}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 28.18, ["Fly"] = 57.75, ["Ride"] = 44.63, ["Fly|Ride"] = 93.56, ["Neon"] = 139.21, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 139.86, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1000.08, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.44}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.7, ["Ride"] = 77.11, ["Fly|Ride"] = 71.61, ["Neon|Ride"] = 324.48, ["Neon|Fly|Ride"] = 311.11, ["Mega|Ride"] = 1296.65, ["Mega|Fly|Ride"] = 1493.63}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 39.76}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 214.16, ["Ride"] = 233.89, ["Fly|Ride"] = 282.19, ["Neon|Ride"] = 1128.57, ["Neon|Fly|Ride"] = 1109.28, ["Mega|Fly|Ride"] = 4616.97}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 715.31, ["Ride"] = 754.69, ["Fly|Ride"] = 783.57, ["Neon"] = 2362.5, ["Neon|Fly|Ride"] = 2624.99, ["Mega|Fly|Ride"] = 11018.33}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 13.11}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.88, ["Fly"] = 39.38, ["Ride"] = 38.07, ["Fly|Ride"] = 70.26, ["Neon"] = 229.71, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 215.7, ["Mega"] = 2141.46, ["Mega|Ride"] = 1145.85, ["Mega|Fly|Ride"] = 770.44}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 19.46}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 5650.32, ["Fly|Ride"] = 4482.63, ["Neon|Ride"] = 17824.71, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43747.56}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 11.44, ["Fly"] = 55.11, ["Ride"] = 22.25, ["Fly|Ride"] = 64.26, ["Neon"] = 65.63, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 211.45, ["Mega"] = 561.75, ["Mega|Ride"] = 487.31, ["Mega|Fly|Ride"] = 586.14}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.99, ["Fly"] = 139.89, ["Ride"] = 30.19, ["Fly|Ride"] = 85.67, ["Neon"] = 97.13, ["Neon|Ride"] = 122.07, ["Neon|Fly|Ride"] = 256.98, ["Mega"] = 748.46, ["Mega|Ride"] = 770.2, ["Mega|Fly|Ride"] = 977.82}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 110.44, ["Fly"] = 285.9, ["Ride"] = 59.07, ["Fly|Ride"] = 90.44, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 476.14, ["Mega"] = 4282.9}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 10.33, ["Fly"] = 71.76, ["Ride"] = 26.25, ["Fly|Ride"] = 61.69, ["Neon"] = 63, ["Neon|Ride"] = 176.55, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 1428.36, ["Mega|Ride"] = 761.96, ["Mega|Fly|Ride"] = 813.75}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1783.68, ["Fly"] = 2070.8, ["Ride"] = 1601.25, ["Fly|Ride"] = 1640.52, ["Neon|Fly|Ride"] = 3149.99, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27431.25, ["Fly"] = 34263.15, ["Ride"] = 52500, ["Fly|Ride"] = 25593.75, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 74209.24, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 21, ["Fly"] = 393.75, ["Ride"] = 39.38, ["Fly|Ride"] = 128.14, ["Neon"] = 321.23, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 963.66, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 1395.07}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.72, ["Fly"] = 63, ["Ride"] = 44.63, ["Fly|Ride"] = 152.15, ["Neon"] = 22.32, ["Neon|Fly"] = 131.24, ["Neon|Ride"] = 56.01, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 118.13, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 25.19}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 9.19, ["Ride"] = 36.47, ["Fly|Ride"] = 124.68, ["Neon"] = 58.46, ["Neon|Ride"] = 116.79, ["Neon|Fly|Ride"] = 213.54, ["Mega"] = 413.44, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 654.94, ["Fly"] = 810.55, ["Ride"] = 749.45, ["Fly|Ride"] = 785.92, ["Neon"] = 2783.9, ["Neon|Ride"] = 2569.75, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 9565.85}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 1093.71, ["Fly"] = 975.19, ["Ride"] = 917.36, ["Fly|Ride"] = 947.24, ["Neon"] = 4140.5, ["Neon|Fly|Ride"] = 3109.32, ["Mega|Fly|Ride"] = 11498.45}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.97, ["Fly"] = 121.53, ["Ride"] = 29.65, ["Fly|Ride"] = 78.75, ["Neon"] = 78.75, ["Neon|Ride"] = 100.92, ["Neon|Fly|Ride"] = 208.81, ["Mega"] = 1204.13, ["Mega|Ride"] = 481.69, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.39}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 58.36, ["Fly"] = 107.09, ["Ride"] = 78.75, ["Fly|Ride"] = 126, ["Neon"] = 420, ["Neon|Ride"] = 428.31, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 19687.5, ["Mega|Ride"] = 2096.5, ["Mega|Fly|Ride"] = 1962.19}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 78.74, ["Ride"] = 98.44, ["Fly|Ride"] = 157.5, ["Neon"] = 420, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1393.44, ["Mega|Ride"] = 1927.31, ["Mega|Fly|Ride"] = 1884.09}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 4.28, ["Fly"] = 32.16, ["Ride"] = 18.35, ["Fly|Ride"] = 45.94, ["Neon"] = 45.48, ["Neon|Fly"] = 524.98, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 342.65, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 140.43, ["Fly"] = 173.25, ["Ride"] = 162.21, ["Fly|Ride"] = 203.76, ["Neon"] = 612.84, ["Neon|Ride"] = 570.94, ["Neon|Fly|Ride"] = 580.23, ["Mega"] = 5139.48, ["Mega|Fly|Ride"] = 2411.07}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 4.02, ["Ride"] = 47.07, ["Fly|Ride"] = 220.5, ["Neon"] = 31.06, ["Neon|Fly"] = 171.33, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 210.33, ["Mega"] = 173.25, ["Mega|Ride"] = 470.31, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 13.99, ["Fly"] = 63.56, ["Ride"] = 32.71, ["Fly|Ride"] = 81, ["Neon"] = 78.75, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 671.35, ["Mega|Ride"] = 828.75, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 32.7, ["Ride"] = 59.07, ["Fly|Ride"] = 156.19, ["Neon"] = 216.57, ["Neon|Ride"] = 282.19, ["Mega"] = 1296.65, ["Mega|Ride"] = 1161.57, ["Mega|Fly|Ride"] = 923.25}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.53, ["Fly"] = 210.3, ["Ride"] = 35.77, ["Fly|Ride"] = 64.26, ["Neon"] = 91.88, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 214.16, ["Mega|Fly|Ride"] = 1000.08}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6300, ["Ride"] = 6555.94, ["Fly|Ride"] = 5767.12, ["Neon"] = 35691.49, ["Neon|Ride"] = 24937.5, ["Neon|Fly|Ride"] = 25983.25}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 242.71, ["Fly"] = 242.15, ["Ride"] = 239.24, ["Fly|Ride"] = 295.51, ["Neon|Fly|Ride"] = 558.59, ["Mega|Fly|Ride"] = 2231.15}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 43.3, ["Fly"] = 144.8, ["Ride"] = 94.4, ["Fly|Ride"] = 199.29, ["Neon"] = 147, ["Neon|Fly"] = 242.01, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 265.12, ["Mega"] = 406.88, ["Mega|Fly"] = 656.22, ["Mega|Ride"] = 430.5, ["Mega|Fly|Ride"] = 559.13}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.28, ["Fly"] = 89.95, ["Ride"] = 18.38, ["Fly|Ride"] = 50.34, ["Neon"] = 22.32, ["Neon|Fly"] = 70.68, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 194.88, ["Mega"] = 341.25, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 69.57, ["Fly"] = 164.07, ["Ride"] = 102.38, ["Fly|Ride"] = 197.76, ["Neon"] = 196.87, ["Neon|Fly"] = 428.31, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 539.85, ["Mega|Ride"] = 695.63, ["Mega|Fly|Ride"] = 660.8}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14384.99, ["Ride"] = 12468.75, ["Fly|Ride"] = 12309.94, ["Neon|Fly|Ride"] = 27562.5, ["Mega|Fly|Ride"] = 114210.8}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 275.42, ["Ride"] = 334.69, ["Fly|Ride"] = 361.92, ["Neon"] = 1623.23, ["Neon|Ride"] = 1428.36, ["Neon|Fly|Ride"] = 1428.36, ["Mega|Fly|Ride"] = 6564.62}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 49.9, ["Fly"] = 91.43, ["Ride"] = 65.52, ["Fly|Ride"] = 91.88, ["Neon"] = 1050, ["Neon|Ride"] = 311.7, ["Neon|Fly|Ride"] = 385.88, ["Mega|Fly|Ride"] = 3303.2}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 10.32, ["Ride"] = 22.96, ["Fly|Ride"] = 72.12, ["Neon"] = 67.46, ["Neon|Fly"] = 275.86, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 108.94, ["Mega"] = 393.75, ["Mega|Ride"] = 1142.48, ["Mega|Fly|Ride"] = 1070.73}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 368.81, ["Fly"] = 856.59, ["Ride"] = 393.74, ["Fly|Ride"] = 480.77, ["Neon"] = 1568.76, ["Neon|Ride"] = 1376.76, ["Neon|Fly|Ride"] = 1827.74, ["Mega|Fly|Ride"] = 5115.93}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.21, ["Fly"] = 104.12, ["Ride"] = 42, ["Fly|Ride"] = 138.8, ["Neon"] = 33.75, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 85.67, ["Neon|Fly|Ride"] = 227.26, ["Mega"] = 137.82, ["Mega|Fly"] = 301.39, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 521.07}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105.36, ["Fly"] = 216.29, ["Ride"] = 142.06, ["Fly|Ride"] = 195.57, ["Neon"] = 443.52, ["Neon|Ride"] = 514.33, ["Neon|Fly|Ride"] = 498.75, ["Mega|Fly|Ride"] = 2419.98}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 11.81, ["Fly"] = 18.15, ["Ride"] = 18.71, ["Fly|Ride"] = 39.29, ["Neon"] = 162.85, ["Neon|Fly"] = 80.64, ["Neon|Ride"] = 196.86, ["Neon|Fly|Ride"] = 103.68, ["Mega"] = 2569.75, ["Mega|Fly|Ride"] = 645.75}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.76}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 65.01, ["Ride"] = 85.32, ["Fly|Ride"] = 213.08, ["Neon"] = 385.88, ["Neon|Fly"] = 427.24, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 486.1, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1621.1}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 15.63, ["Fly"] = 106.01, ["Ride"] = 32.82, ["Fly|Ride"] = 84, ["Neon"] = 98.43, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 185.74, ["Mega"] = 607.62, ["Mega|Ride"] = 560.44, ["Mega|Fly|Ride"] = 577.96}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 22.78}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 51.84, ["Fly"] = 143.5, ["Ride"] = 78.75, ["Fly|Ride"] = 280.88, ["Neon"] = 301.39, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1606.11, ["Mega|Ride"] = 1583.61, ["Mega|Fly|Ride"] = 1642.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 6.57, ["Ride"] = 29.23, ["Fly|Ride"] = 136.57, ["Neon"] = 21, ["Neon|Ride"] = 114.26, ["Neon|Fly|Ride"] = 256.99, ["Mega"] = 118.13, ["Mega|Ride"] = 301.39, ["Mega|Fly|Ride"] = 295.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.71, ["Fly"] = 56.44, ["Ride"] = 28.93, ["Fly|Ride"] = 98.99, ["Neon"] = 162.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 213.08, ["Mega"] = 569.64, ["Mega|Ride"] = 642.45, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 484.32, ["Fly"] = 572.84, ["Ride"] = 505.32, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2720.94, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.18, ["Fly"] = 100.67, ["Ride"] = 57.59, ["Fly|Ride"] = 131.25, ["Neon"] = 235.64, ["Neon|Ride"] = 186.33, ["Neon|Fly|Ride"] = 373.09, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 535.4}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.03, ["Fly"] = 119.89, ["Ride"] = 70.88, ["Fly|Ride"] = 118.44, ["Neon"] = 236.64, ["Neon|Ride"] = 190.32, ["Neon|Fly|Ride"] = 322.88, ["Mega|Fly|Ride"] = 943.32}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.85, ["Fly"] = 85.67, ["Ride"] = 71.66, ["Fly|Ride"] = 112.25, ["Neon"] = 97.12, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 367.5, ["Mega|Fly"] = 525, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 598.56}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8201.71, ["Neon|Fly|Ride"] = 15487.5, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1486.62, ["Ride"] = 1443.75, ["Fly|Ride"] = 1496.25, ["Neon|Fly|Ride"] = 3896.83, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 585.69, ["Ride"] = 571.78, ["Fly|Ride"] = 538.13, ["Neon"] = 3540.9, ["Neon|Fly|Ride"] = 3212.19, ["Mega"] = 21414.47, ["Mega|Fly|Ride"] = 8587.9}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 10.99, ["Fly"] = 23.63, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 65.64, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 567.52}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.25, ["Fly"] = 78.74, ["Ride"] = 30.81, ["Fly|Ride"] = 183.11, ["Neon"] = 28.61, ["Neon|Ride"] = 51.19, ["Mega"] = 131.25, ["Mega|Ride"] = 196.21, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 29.98, ["Fly"] = 75.35, ["Ride"] = 49.79, ["Fly|Ride"] = 93.54, ["Neon"] = 546.87, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 179.2, ["Mega|Ride"] = 749.52, ["Mega|Fly|Ride"] = 605.9}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.92, ["Fly"] = 21.05, ["Ride"] = 20.96, ["Fly|Ride"] = 42.61, ["Neon"] = 45.94, ["Neon|Fly"] = 86.62, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 88.26, ["Mega"] = 288.75, ["Mega|Ride"] = 200.24, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 304.5, ["Fly"] = 369.5, ["Ride"] = 306.55, ["Fly|Ride"] = 380.52, ["Neon|Ride"] = 1228.14, ["Neon|Fly|Ride"] = 1257.04, ["Mega|Fly|Ride"] = 3654}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 25.67, ["Fly"] = 59.06, ["Ride"] = 30.95, ["Fly|Ride"] = 84.16, ["Neon"] = 208.95, ["Neon|Fly"] = 312.72, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 671.35, ["Mega|Ride"] = 787.4, ["Mega|Fly|Ride"] = 701.32}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 13.13, ["Fly"] = 21, ["Ride"] = 19.48, ["Fly|Ride"] = 41.99, ["Neon"] = 71.76, ["Neon|Fly"] = 122.08, ["Neon|Ride"] = 70.83, ["Neon|Fly|Ride"] = 103.69, ["Mega"] = 1575, ["Mega|Ride"] = 612.48, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 571.78, ["Fly"] = 1048.69, ["Ride"] = 535.38, ["Fly|Ride"] = 637.81, ["Neon|Fly|Ride"] = 2855.64, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1130.07, ["Ride"] = 1136.63, ["Fly|Ride"] = 1400.34, ["Neon"] = 4997.08, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 136.42, ["Fly"] = 140.28, ["Ride"] = 94.9, ["Fly|Ride"] = 97.23, ["Neon"] = 591.06, ["Neon|Ride"] = 585.46, ["Neon|Fly|Ride"] = 505.32, ["Mega|Fly|Ride"] = 2567.61}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 162.85, ["Fly"] = 212.14, ["Ride"] = 190.31, ["Fly|Ride"] = 234.94, ["Neon"] = 868.38, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 643.91, ["Mega"] = 2855.64, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2855.9}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 31.4, ["Fly"] = 57.84, ["Ride"] = 32.7, ["Fly|Ride"] = 112.25, ["Neon"] = 236.24, ["Neon|Ride"] = 272.99, ["Mega|Ride"] = 1428.36, ["Mega|Fly|Ride"] = 1075.03}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 210, ["Ride"] = 315, ["Fly|Ride"] = 414.39, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1361.06, ["Mega|Fly|Ride"] = 6424.36}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 2213.21, ["Ride"] = 1653.65, ["Fly|Ride"] = 1837.5, ["Neon|Fly|Ride"] = 10707.24, ["Mega|Fly|Ride"] = 29975.59}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 53.72, ["Fly"] = 214.16, ["Ride"] = 52.4, ["Fly|Ride"] = 65.54, ["Neon"] = 288.75, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 1428.36, ["Mega|Ride"] = 1142.48, ["Mega|Fly|Ride"] = 1154.99}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 695.62, ["Ride"] = 661.5, ["Fly|Ride"] = 700.88, ["Neon|Ride"] = 1920.05, ["Neon|Fly|Ride"] = 1234.4, ["Mega|Fly|Ride"] = 3451.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 39.38, ["Fly"] = 70.88, ["Ride"] = 50.58, ["Fly|Ride"] = 93.56, ["Neon|Ride"] = 238.2, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.24}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.81, ["Fly"] = 46.19, ["Ride"] = 18.89, ["Fly|Ride"] = 58.59, ["Neon"] = 34.28, ["Neon|Fly"] = 115.5, ["Neon|Ride"] = 45.55, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 153.56, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 184.98, ["Mega|Fly|Ride"] = 324.44}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 45.02, ["Ride"] = 128.34, ["Fly|Ride"] = 208.81, ["Neon"] = 259.77, ["Neon|Ride"] = 422.29, ["Neon|Fly|Ride"] = 714.18, ["Mega"] = 1565.41}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 771.75, ["Fly"] = 987.83, ["Ride"] = 866.25, ["Fly|Ride"] = 904.58, ["Neon|Ride"] = 3254.99, ["Neon|Fly|Ride"] = 2908.18, ["Mega|Fly|Ride"] = 11550}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 590.63, ["Ride"] = 706.69, ["Fly|Ride"] = 841.3, ["Neon"] = 10993.13, ["Neon|Fly|Ride"] = 4273.26, ["Mega|Fly|Ride"] = 15559.76}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 11.71, ["Fly"] = 22.32, ["Ride"] = 21.44, ["Fly|Ride"] = 41.91, ["Neon"] = 160.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 810.55, ["Mega|Fly|Ride"] = 700.95}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 11.34, ["Ride"] = 26.24, ["Fly|Ride"] = 89.95, ["Neon"] = 143.5, ["Neon|Ride"] = 86.63, ["Neon|Fly|Ride"] = 250.04, ["Mega"] = 568.57, ["Mega|Ride"] = 568.57, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.01, ["Fly"] = 61.64, ["Ride"] = 23.39, ["Fly|Ride"] = 111.37, ["Neon"] = 21, ["Neon|Fly"] = 318.57, ["Neon|Ride"] = 61.36, ["Neon|Fly|Ride"] = 209.15, ["Mega"] = 173.71, ["Mega|Fly"] = 538.13, ["Mega|Ride"] = 200.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 40.27, ["Fly"] = 50.68, ["Ride"] = 46.78, ["Fly|Ride"] = 102.03, ["Neon"] = 243.07, ["Neon|Ride"] = 220.59, ["Neon|Fly|Ride"] = 210, ["Mega|Fly|Ride"] = 1262.01}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 64.86, ["Ride"] = 124.69, ["Fly|Ride"] = 486.1, ["Neon"] = 424.07, ["Neon|Ride"] = 519.75, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1606.11, ["Mega|Fly|Ride"] = 1606.11}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.13, ["Fly"] = 45.93, ["Ride"] = 36.75, ["Fly|Ride"] = 79.4, ["Neon"] = 106.32, ["Neon|Fly"] = 128.13, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 421.13, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 459.37}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 35.99, ["Fly"] = 65.63, ["Ride"] = 45.84, ["Fly|Ride"] = 76.83, ["Neon"] = 242.71, ["Neon|Fly"] = 1428.36, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Ride"] = 1195.86, ["Mega|Fly|Ride"] = 1233.75}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.12, ["Fly"] = 21, ["Ride"] = 18.38, ["Fly|Ride"] = 31.49, ["Neon"] = 20.99, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 749.52, ["Mega|Ride"] = 486.1, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 5.25, ["Fly"] = 49.37, ["Ride"] = 41.91, ["Fly|Ride"] = 65.63, ["Neon"] = 39.51, ["Neon|Fly"] = 111.37, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 179.87, ["Mega"] = 328.73, ["Mega|Ride"] = 337.84, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 81.39, ["Fly"] = 56.18, ["Ride"] = 56.43, ["Fly|Ride"] = 94.5, ["Neon"] = 223.13, ["Neon|Fly"] = 211.3, ["Neon|Ride"] = 203.44, ["Neon|Fly|Ride"] = 236.15, ["Mega|Fly|Ride"] = 1074.91}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1417.5, ["Fly"] = 1903.13, ["Ride"] = 1496.88, ["Fly|Ride"] = 1509.37, ["Neon|Fly|Ride"] = 3715.06, ["Mega|Fly|Ride"] = 17418.54}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 459.38, ["Fly"] = 524.99, ["Ride"] = 455.44, ["Fly|Ride"] = 478.96, ["Neon|Ride"] = 3712.22, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 14990.13, ["Mega|Fly|Ride"] = 9422.37}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 275.62, ["Ride"] = 301.88, ["Fly|Ride"] = 393.75, ["Neon"] = 1214.21, ["Neon|Ride"] = 1541.86, ["Neon|Fly|Ride"] = 1606.11, ["Mega|Fly|Ride"] = 6420.07}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 23, ["Ride"] = 42.84, ["Fly|Ride"] = 97.13, ["Neon"] = 325.5, ["Neon|Ride"] = 217.88, ["Neon|Fly|Ride"] = 350.44, ["Mega|Ride"] = 1569.7, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 37118.76, ["Fly"] = 23555.91, ["Ride"] = 24304.21, ["Fly|Ride"] = 17981.25, ["Neon|Fly|Ride"] = 35437.5, ["Mega"] = 214144.58, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 258, ["Fly"] = 287.83, ["Ride"] = 301.87, ["Fly|Ride"] = 334.69, ["Neon"] = 1093.71, ["Neon|Fly"] = 1085.74, ["Neon|Ride"] = 927.63, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 3747.55, ["Mega|Ride"] = 4281.84, ["Mega|Fly|Ride"] = 3297.72}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 216.57, ["Fly"] = 525, ["Ride"] = 210.25, ["Fly|Ride"] = 196.88, ["Neon|Fly|Ride"] = 1782.73}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 196.88, ["Fly"] = 285.9, ["Ride"] = 157.5, ["Fly|Ride"] = 256.99, ["Neon|Ride"] = 714.18, ["Neon|Fly|Ride"] = 603.75, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.62, ["Fly"] = 62.99, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 726.71, ["Mega|Ride"] = 714.18, ["Mega|Fly|Ride"] = 1070.73}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 3714.38, ["Ride"] = 3727.5, ["Fly|Ride"] = 3937.5, ["Neon"] = 27838.81, ["Neon|Fly|Ride"] = 17418.54}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 23.63, ["Fly"] = 45.92, ["Ride"] = 28.92, ["Fly|Ride"] = 54.45, ["Neon"] = 214.16, ["Neon|Ride"] = 150.59, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 1142.48, ["Mega|Ride"] = 1428.36, ["Mega|Fly|Ride"] = 728.11}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 45.72, ["Fly"] = 128.5, ["Ride"] = 56.6, ["Fly|Ride"] = 102.65, ["Neon"] = 314.26, ["Neon|Fly"] = 1428.36, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 262.48, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 459.27, ["Fly"] = 656.25, ["Ride"] = 630.88, ["Fly|Ride"] = 590.63, ["Neon"] = 2180.1, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.44, ["Fly"] = 23.39, ["Ride"] = 24.31, ["Fly|Ride"] = 42.75, ["Neon"] = 118.12, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 141.74, ["Mega|Ride"] = 785.92, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 10.4, ["Ride"] = 34.54, ["Fly|Ride"] = 80.15, ["Neon"] = 95.82, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 206.98, ["Mega|Ride"] = 753.44}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 107.51, ["Ride"] = 128.63, ["Fly|Ride"] = 156.19, ["Neon"] = 728.11, ["Neon|Ride"] = 1023.63, ["Neon|Fly|Ride"] = 1051.32, ["Mega|Fly|Ride"] = 2739.19}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 14.33, ["Fly"] = 128, ["Ride"] = 71.76, ["Fly|Ride"] = 118.13, ["Neon"] = 67.38, ["Neon|Ride"] = 113.43, ["Neon|Fly|Ride"] = 224.42, ["Mega"] = 275.63, ["Mega|Fly"] = 739.46, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3806.25, ["Fly"] = 6319.11, ["Ride"] = 3806.25, ["Fly|Ride"] = 4095, ["Neon"] = 14990.13, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 9842.44, ["Mega"] = 42827.86, ["Mega|Fly|Ride"] = 36942.4}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.47, ["Fly"] = 143.09, ["Ride"] = 70.22, ["Fly|Ride"] = 157.5, ["Neon"] = 173.01, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 504, ["Mega"] = 785.92, ["Mega|Ride"] = 1782.73, ["Mega|Fly|Ride"] = 782.25}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 6562.5, ["Fly"] = 8851.68, ["Ride"] = 6857.82, ["Fly|Ride"] = 6223.81, ["Neon|Fly|Ride"] = 16800, ["Mega|Fly|Ride"] = 66431.89}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.09, ["Fly"] = 23.54, ["Ride"] = 16.42, ["Fly|Ride"] = 31.5, ["Neon"] = 24.62, ["Neon|Fly"] = 59.97, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 80.32, ["Mega"] = 186.33, ["Mega|Ride"] = 372.75, ["Mega|Fly|Ride"] = 357.63}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 14.9, ["Fly"] = 25.73, ["Ride"] = 32.46, ["Fly|Ride"] = 55.92, ["Neon"] = 85.67, ["Neon|Fly"] = 236.64, ["Neon|Ride"] = 140.94, ["Neon|Fly|Ride"] = 159.83, ["Mega|Ride"] = 978.48, ["Mega|Fly|Ride"] = 928.33}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.2}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.44, ["Ride"] = 31.48, ["Fly|Ride"] = 116.02, ["Neon"] = 94.5, ["Neon|Ride"] = 85.5, ["Neon|Fly|Ride"] = 323.37, ["Mega"] = 1049.9, ["Mega|Ride"] = 856.59, ["Mega|Fly|Ride"] = 804.14}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.64, ["Fly"] = 190.37, ["Ride"] = 48.62, ["Fly|Ride"] = 99.73, ["Neon"] = 203.44, ["Neon|Ride"] = 162.85, ["Neon|Fly|Ride"] = 318.94, ["Mega"] = 945, ["Mega|Ride"] = 856.59, ["Mega|Fly|Ride"] = 1063.13}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 11.46, ["Fly"] = 24.35, ["Ride"] = 25.46, ["Fly|Ride"] = 36.38, ["Neon|Ride"] = 114.58, ["Neon|Fly|Ride"] = 179.55, ["Mega"] = 2569.75, ["Mega|Ride"] = 606.4, ["Mega|Fly|Ride"] = 555.73}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8709.27}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2624.99}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 28.93}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 233.52, ["Ride"] = 392.97, ["Fly|Ride"] = 259.88, ["Mega|Fly|Ride"] = 4200}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 14.73, ["Fly"] = 131.57, ["Ride"] = 37.46, ["Fly|Ride"] = 125.9, ["Neon"] = 100.67, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 525, ["Mega|Ride"] = 531.57, ["Mega|Fly|Ride"] = 1179.94}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.16}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 10.5, ["Fly"] = 45.94, ["Ride"] = 32.15, ["Fly|Ride"] = 85.67, ["Neon|Ride"] = 249.38, ["Mega"] = 1570.76}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2628.94}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 139.13, ["Fly"] = 428.31, ["Ride"] = 262.49, ["Fly|Ride"] = 428.31, ["Neon"] = 971.17, ["Neon|Ride"] = 785.92, ["Neon|Fly|Ride"] = 928.33, ["Mega|Ride"] = 4140.5, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 76.58, ["Ride"] = 93.16, ["Fly|Ride"] = 214.16, ["Neon"] = 785.92, ["Neon|Ride"] = 598.56, ["Neon|Fly|Ride"] = 648.94, ["Mega|Ride"] = 2141.46, ["Mega|Fly|Ride"] = 1837.5}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 143.5, ["Fly"] = 315, ["Ride"] = 143.5, ["Fly|Ride"] = 214.9, ["Neon"] = 944.98, ["Neon|Ride"] = 787.4, ["Neon|Fly|Ride"] = 840, ["Mega|Ride"] = 3258.94, ["Mega|Fly|Ride"] = 3726.13}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2388.74, ["Fly"] = 3283.92, ["Ride"] = 2186.85, ["Fly|Ride"] = 2295.57, ["Neon"] = 15039.39, ["Neon|Ride"] = 8506.49, ["Neon|Fly|Ride"] = 6825, ["Mega|Fly|Ride"] = 25265.63}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 18.38, ["Fly"] = 71.76, ["Ride"] = 57.75, ["Fly|Ride"] = 99.75, ["Neon"] = 127.32, ["Neon|Fly"] = 162.85, ["Neon|Ride"] = 154.62, ["Neon|Fly|Ride"] = 242.82, ["Mega"] = 962.59, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 686.44, ["Fly"] = 2100, ["Ride"] = 748.13, ["Fly|Ride"] = 735, ["Neon|Ride"] = 4198.31, ["Neon|Fly|Ride"] = 4213.15, ["Mega|Fly|Ride"] = 17012.94}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 14.31, ["Ride"] = 55.69, ["Fly|Ride"] = 91.88, ["Neon"] = 81.38, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 106.5, ["Neon|Fly|Ride"] = 256.99, ["Mega"] = 436.12, ["Mega|Fly"] = 972.18, ["Mega|Ride"] = 480.77, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.55, ["Fly"] = 74.97, ["Ride"] = 27.45, ["Fly|Ride"] = 106.01, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 209.94, ["Mega"] = 454.5, ["Mega|Ride"] = 393.75}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 58.7}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 29.18, ["Fly"] = 104.62, ["Ride"] = 25.99, ["Fly|Ride"] = 83.53, ["Neon|Ride"] = 105.74, ["Neon|Fly|Ride"] = 254.62, ["Mega|Ride"] = 1000.08, ["Mega|Fly|Ride"] = 1522.5}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 24.5, ["Fly"] = 39.37, ["Ride"] = 33.54, ["Fly|Ride"] = 52.41, ["Neon"] = 210, ["Neon|Fly"] = 236.64, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 336, ["Mega"] = 1458.28, ["Mega|Ride"] = 1822.83, ["Mega|Fly|Ride"] = 961.53}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6037.49, ["Fly"] = 10237.5, ["Ride"] = 6638.49, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 9843.75, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.87, ["Fly"] = 65.63, ["Ride"] = 32.49, ["Fly|Ride"] = 81.37, ["Neon"] = 56.44, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 200.24, ["Mega"] = 285.9, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 533.4}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.94}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 99.75, ["Fly"] = 379.05, ["Ride"] = 137.7, ["Fly|Ride"] = 158.48, ["Neon"] = 531.57, ["Neon|Ride"] = 399.71, ["Neon|Fly|Ride"] = 716.99, ["Mega"] = 2879.59, ["Mega|Ride"] = 2284.94, ["Mega|Fly|Ride"] = 2059.01}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 51.19, ["Fly"] = 140.9, ["Ride"] = 74.46, ["Fly|Ride"] = 112.25, ["Neon"] = 291.38, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2430.43, ["Mega|Ride"] = 2890.97, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 17.82, ["Fly"] = 70.26, ["Ride"] = 29.79, ["Fly|Ride"] = 63.51, ["Neon"] = 128.77, ["Neon|Fly"] = 231.3, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 192.74, ["Mega"] = 1016.21, ["Mega|Ride"] = 874.96, ["Mega|Fly|Ride"] = 780.93}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.88, ["Fly"] = 41.66, ["Ride"] = 27.46, ["Fly|Ride"] = 60.3, ["Neon"] = 30.4, ["Neon|Ride"] = 49.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 164.07, ["Mega|Fly"] = 228.36, ["Mega|Ride"] = 196.67, ["Mega|Fly|Ride"] = 270.17}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 9.18, ["Fly"] = 71.76, ["Ride"] = 31.49, ["Fly|Ride"] = 95.99, ["Neon"] = 91.49, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 216.57, ["Mega|Ride"] = 648.94, ["Mega|Fly|Ride"] = 610.33}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 18.69, ["Fly"] = 26.25, ["Ride"] = 23.87, ["Fly|Ride"] = 49.37, ["Neon"] = 371.56, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 142.92, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 208.68}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.93, ["Ride"] = 131.21, ["Fly|Ride"] = 285.9, ["Neon"] = 192.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 426.54, ["Mega"] = 708.75, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 200.24, ["Ride"] = 246.28, ["Neon|Ride"] = 17131.58, ["Neon|Fly|Ride"] = 28552.98}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 44.09, ["Fly"] = 212.42, ["Ride"] = 86.51, ["Fly|Ride"] = 178.28, ["Neon"] = 315, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 843.38, ["Mega|Ride"] = 971.25, ["Mega|Fly|Ride"] = 1135.49}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 971.15, ["Fly"] = 1336.75, ["Ride"] = 984.38, ["Fly|Ride"] = 1049.97, ["Neon|Ride"] = 4295.79, ["Neon|Fly|Ride"] = 3609.38, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 391.02, ["Fly"] = 714.18, ["Ride"] = 380.62, ["Fly|Ride"] = 488.12, ["Neon"] = 2141.46, ["Neon|Ride"] = 2569.75, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12152.11, ["Mega|Fly|Ride"] = 9120.57}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 58.47}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 23, ["Ride"] = 23.89, ["Fly|Ride"] = 51.19, ["Neon"] = 78.75, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 437.26, ["Mega|Ride"] = 714.18, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 236.15, ["Fly"] = 406.65, ["Ride"] = 277.94, ["Fly|Ride"] = 380.62, ["Neon"] = 1139.27, ["Neon|Ride"] = 954.19, ["Neon|Fly|Ride"] = 1075.45, ["Mega|Fly|Ride"] = 3337.85}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 15.49}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 113.93, ["Fly"] = 290.45, ["Ride"] = 161.32, ["Fly|Ride"] = 287.27, ["Neon"] = 577.5, ["Neon|Ride"] = 753.44, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 3570.88, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1914.84}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 111.57, ["Fly"] = 214.16, ["Ride"] = 128.77, ["Fly|Ride"] = 214.16, ["Neon"] = 1142.48, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 913.5, ["Mega|Fly|Ride"] = 2569.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.54, ["Ride"] = 28.93, ["Fly|Ride"] = 174.55, ["Neon"] = 38.07, ["Neon|Ride"] = 87.5, ["Neon|Fly|Ride"] = 242.01, ["Mega"] = 264.75, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 855.52}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 11.08, ["Fly"] = 71.54, ["Ride"] = 25.75, ["Fly|Ride"] = 52.5, ["Neon"] = 177.19, ["Neon|Ride"] = 149.92, ["Neon|Fly|Ride"] = 324.48, ["Mega|Ride"] = 1428.36, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 13.12, ["Fly"] = 102.36, ["Ride"] = 32.82, ["Fly|Ride"] = 104.09, ["Neon"] = 84.95, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 256.57, ["Mega"] = 498.75, ["Mega|Ride"] = 519.75, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.88, ["Fly"] = 98.07, ["Ride"] = 58.8, ["Fly|Ride"] = 214.16, ["Neon"] = 24.76, ["Neon|Ride"] = 69.78, ["Neon|Fly|Ride"] = 154.87, ["Mega"] = 140.77, ["Mega|Fly"] = 271.98, ["Mega|Ride"] = 191.42, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 240.35, ["Ride"] = 261.19, ["Fly|Ride"] = 365.59, ["Neon"] = 1597.53, ["Neon|Ride"] = 1382.93, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Fly|Ride"] = 5653.43}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 97.23, ["Fly"] = 157.5, ["Ride"] = 134.87, ["Fly|Ride"] = 241.5, ["Neon"] = 393.75, ["Neon|Fly"] = 577.14, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 523.69, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 2541.91}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.27, ["Fly"] = 167.45, ["Ride"] = 70.14, ["Fly|Ride"] = 131.25, ["Neon"] = 380.63, ["Neon|Ride"] = 349.13, ["Neon|Fly|Ride"] = 408.19, ["Mega|Fly|Ride"] = 1801.15}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 15.75, ["Fly"] = 78.75, ["Ride"] = 28.93, ["Fly|Ride"] = 285.9, ["Neon"] = 115.5, ["Neon|Ride"] = 617.34, ["Neon|Fly|Ride"] = 500.05}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.13, ["Fly"] = 42.84, ["Ride"] = 32.81, ["Fly|Ride"] = 66.94, ["Neon"] = 77.43, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 374.3, ["Mega|Fly"] = 525, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.55, ["Fly"] = 52.47, ["Ride"] = 19.69, ["Fly|Ride"] = 49.84, ["Neon"] = 18.38, ["Neon|Fly"] = 84, ["Neon|Ride"] = 57.14, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 139.13, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 232.21}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 846.56, ["Fly"] = 1082.72, ["Ride"] = 930.91, ["Fly|Ride"] = 918.75, ["Neon"] = 4282.9, ["Neon|Ride"] = 8565.8, ["Neon|Fly|Ride"] = 2754.94, ["Mega|Fly|Ride"] = 11231.9}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 320.15, ["Fly"] = 486.12, ["Ride"] = 328.13, ["Fly|Ride"] = 420, ["Neon|Ride"] = 1428.36, ["Neon|Fly|Ride"] = 1685.33, ["Mega"] = 10707.24, ["Mega|Fly|Ride"] = 5996.07}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 84.96, ["Fly"] = 114.58, ["Ride"] = 107.85, ["Fly|Ride"] = 190.6, ["Neon"] = 328.73, ["Neon|Ride"] = 277.92, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1312.5, ["Mega|Ride"] = 1537.57, ["Mega|Fly|Ride"] = 1642.5}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 210, ["Fly"] = 283.5, ["Ride"] = 196.88, ["Fly|Ride"] = 258.79, ["Neon|Ride"] = 1110.72, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 10707.24, ["Mega|Fly|Ride"] = 4997.08}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 25.99, ["Fly"] = 52.5, ["Ride"] = 28.27, ["Fly|Ride"] = 76.13, ["Neon"] = 169.32, ["Neon|Ride"] = 182.61, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 570.08, ["Mega|Fly|Ride"] = 810.55}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 188.37, ["Ride"] = 210, ["Fly|Ride"] = 463.67, ["Neon"] = 786.19, ["Neon|Ride"] = 942.27, ["Neon|Fly|Ride"] = 971.25, ["Mega"] = 4173.65, ["Mega|Ride"] = 4711.19, ["Mega|Fly|Ride"] = 3818.31}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 65.63, ["Fly"] = 125.98, ["Ride"] = 79.41, ["Fly|Ride"] = 106.46, ["Neon|Ride"] = 486.1, ["Mega|Fly|Ride"] = 1529.07}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1968.75, ["Ride"] = 2231.25, ["Fly|Ride"] = 2021.25, ["Neon|Ride"] = 11342.78, ["Neon|Fly|Ride"] = 8423.4, ["Mega"] = 51394.71, ["Mega|Fly|Ride"] = 25126.67}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 57.75, ["Fly"] = 77.25, ["Ride"] = 59.16, ["Fly|Ride"] = 96.06, ["Neon"] = 66.38, ["Neon|Fly"] = 236.64, ["Neon|Ride"] = 105.72, ["Neon|Fly|Ride"] = 212.62, ["Mega"] = 324.48, ["Mega|Fly"] = 564.47, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 440.08}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 53.82, ["Fly"] = 121.53, ["Ride"] = 68.25, ["Fly|Ride"] = 137.69, ["Neon"] = 223.13, ["Neon|Ride"] = 357.63, ["Neon|Fly|Ride"] = 571.78, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 89.91, ["Fly"] = 91.85, ["Ride"] = 78.1, ["Fly|Ride"] = 96.56, ["Neon"] = 525, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1879.82}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3240.98, ["Fly"] = 1621.1, ["Ride"] = 1048.69, ["Fly|Ride"] = 1168.13, ["Neon|Ride"] = 5185.31, ["Neon|Fly|Ride"] = 5833.02, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 485.63, ["Fly"] = 525, ["Ride"] = 749.52, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 3240.98, ["Mega|Fly|Ride"] = 11421.41}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 69.56, ["Fly"] = 170.63, ["Ride"] = 101.93, ["Fly|Ride"] = 196.88, ["Neon"] = 433.13, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 5711.26, ["Mega|Ride"] = 2593.27, ["Mega|Fly|Ride"] = 1442.89}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.74, ["Ride"] = 26.25, ["Fly|Ride"] = 63, ["Neon"] = 73.59, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 70.55, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 603.75, ["Mega|Ride"] = 767.46}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.34, ["Fly"] = 54.63, ["Ride"] = 42, ["Fly|Ride"] = 107.09, ["Neon"] = 284.82, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 222.39, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 1706.25, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1043.44}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1118.01, ["Ride"] = 735, ["Fly|Ride"] = 826.88, ["Neon"] = 3141.51, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2218.13, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 591.94}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 6168.75, ["Ride"] = 5610.94, ["Fly|Ride"] = 5512.5, ["Neon"] = 42000, ["Neon|Ride"] = 30688.01, ["Neon|Fly|Ride"] = 17584.88, ["Mega|Fly|Ride"] = 91369.08}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.48, ["Fly"] = 400.39, ["Ride"] = 328.13, ["Neon"] = 1713.17, ["Neon|Ride"] = 1856.65, ["Neon|Fly|Ride"] = 2141.46, ["Mega"] = 6423.29, ["Mega|Fly|Ride"] = 6424.36}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 70.66, ["Fly"] = 285.9, ["Ride"] = 129.83, ["Fly|Ride"] = 336, ["Neon"] = 427.24, ["Neon|Ride"] = 671.35, ["Neon|Fly|Ride"] = 638.16, ["Mega|Fly|Ride"] = 2200.35}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 14.85, ["Fly"] = 42.09, ["Ride"] = 34.13, ["Fly|Ride"] = 71.76, ["Neon"] = 172.57, ["Neon|Fly"] = 1296.65, ["Neon|Ride"] = 116.94, ["Neon|Fly|Ride"] = 203.94, ["Mega"] = 997.92, ["Mega|Ride"] = 856.59, ["Mega|Fly|Ride"] = 826.62}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 10.5, ["Fly"] = 26.24, ["Ride"] = 23.63, ["Fly|Ride"] = 48.14, ["Neon"] = 214.16, ["Neon|Ride"] = 318.68, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 2141.46}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.23, ["Fly"] = 285.9, ["Ride"] = 30.19, ["Fly|Ride"] = 97.23, ["Neon"] = 118.46, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 645.75, ["Mega|Ride"] = 500.05, ["Mega|Fly|Ride"] = 626.07}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.94, ["Fly"] = 79.25, ["Ride"] = 21.44, ["Fly|Ride"] = 48.57, ["Neon"] = 31.39, ["Neon|Ride"] = 56.11, ["Neon|Fly|Ride"] = 121.53, ["Mega"] = 321.23, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 27.85, ["Fly"] = 90.57, ["Ride"] = 39.37, ["Fly|Ride"] = 183.75, ["Neon"] = 139.13, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 451.5, ["Mega"] = 628.69, ["Mega|Ride"] = 1260, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 474.93, ["Fly"] = 465.94, ["Ride"] = 460.82, ["Fly|Ride"] = 518.34, ["Neon"] = 1606.11, ["Neon|Ride"] = 1499.03, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 7875, ["Mega|Fly|Ride"] = 5566.71}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.58, ["Fly"] = 19.55, ["Ride"] = 17.07, ["Fly|Ride"] = 36.42, ["Neon"] = 23.35, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 105, ["Mega"] = 231.3, ["Mega|Ride"] = 227, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 41.47, ["Fly"] = 110.06, ["Ride"] = 83.16, ["Fly|Ride"] = 118.13, ["Neon"] = 155.93, ["Neon|Fly"] = 333.15, ["Neon|Ride"] = 201.38, ["Neon|Fly|Ride"] = 272.86, ["Mega"] = 496.13, ["Mega|Ride"] = 556.49, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 793.96, ["Ride"] = 805.62, ["Fly|Ride"] = 810.42, ["Neon|Ride"] = 1988.23, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 3937.49}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 39.42, ["Fly"] = 90.56, ["Ride"] = 44.5, ["Fly|Ride"] = 85.32, ["Neon"] = 392.44, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 164.06, ["Neon|Fly|Ride"] = 249.35, ["Mega"] = 1215.22, ["Mega|Fly|Ride"] = 851.81}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 357, ["Fly"] = 486.1, ["Ride"] = 296.44, ["Fly|Ride"] = 320.1, ["Neon|Ride"] = 1856.65, ["Neon|Fly|Ride"] = 1387.97}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 183.75, ["Fly"] = 178.48, ["Ride"] = 170.63, ["Fly|Ride"] = 227.39, ["Neon"] = 1000.08, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 850.18, ["Mega"] = 4326, ["Mega|Fly|Ride"] = 3555.89}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 834.74, ["Ride"] = 783.57, ["Fly|Ride"] = 869.82, ["Neon|Ride"] = 3727.06, ["Neon|Fly|Ride"] = 3055.05, ["Mega|Fly|Ride"] = 7873.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 19.46, ["Fly"] = 85.67, ["Ride"] = 42, ["Fly|Ride"] = 111.57, ["Neon"] = 87.94, ["Neon|Fly"] = 291.67, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 354.38, ["Mega|Ride"] = 412.13, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4084.49, ["Fly"] = 3404.1, ["Ride"] = 3543.75, ["Fly|Ride"] = 3326.4, ["Neon|Fly|Ride"] = 7350, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 102.27, ["Fly"] = 178.5, ["Ride"] = 138.54, ["Fly|Ride"] = 182.33, ["Neon"] = 459.38, ["Neon|Fly"] = 607.11, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 593.25, ["Mega|Ride"] = 2713.23, ["Mega|Fly|Ride"] = 2734.65}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 28.93, ["Ride"] = 16.89, ["Fly|Ride"] = 38.54, ["Neon"] = 18.69, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 85.67, ["Mega"] = 149.3, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 166.32, ["Mega|Fly|Ride"] = 227}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.91, ["Ride"] = 25.71, ["Fly|Ride"] = 57.71, ["Neon"] = 21, ["Neon|Fly"] = 119.11, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 137.17, ["Mega|Ride"] = 208.69, ["Mega|Fly|Ride"] = 361.59}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 44.99, ["Fly"] = 38.45, ["Ride"] = 42.41, ["Fly|Ride"] = 55.92, ["Neon"] = 291.67, ["Neon|Fly|Ride"] = 284.83, ["Mega|Fly|Ride"] = 1085.18}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 924, ["Fly"] = 1257.76, ["Ride"] = 1035.57, ["Fly|Ride"] = 1110.38, ["Neon|Fly|Ride"] = 3999.16}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6693.75, ["Fly|Ride"] = 6431.25, ["Mega|Fly|Ride"] = 82196.63}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 18.18, ["Fly"] = 44.94, ["Ride"] = 24.97, ["Fly|Ride"] = 43.84, ["Neon"] = 452.13, ["Neon|Ride"] = 158.48, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 2520, ["Mega|Fly|Ride"] = 712.23}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 12.99, ["Ride"] = 28.83, ["Fly|Ride"] = 59.07, ["Neon"] = 71.37, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 655.54, ["Mega|Ride"] = 483.99, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 80.06, ["Fly"] = 157.5, ["Ride"] = 87.83, ["Fly|Ride"] = 138.87, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 402.7, ["Mega|Fly|Ride"] = 1928.56}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 237.77, ["Fly"] = 241.5, ["Ride"] = 219.56, ["Fly|Ride"] = 277.96, ["Neon|Ride"] = 1070.73, ["Neon|Fly|Ride"] = 974.53, ["Mega"] = 8565.8, ["Mega|Fly|Ride"] = 3502.35}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 32.71, ["Fly|Ride"] = 92.3, ["Neon"] = 15.75, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 48.62, ["Mega"] = 160.13, ["Mega|Fly"] = 235.76, ["Mega|Ride"] = 191.22, ["Mega|Fly|Ride"] = 315.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 183.75, ["Fly"] = 231.7, ["Ride"] = 209.27, ["Fly|Ride"] = 291.05, ["Neon"] = 856.59, ["Neon|Ride"] = 735, ["Neon|Fly|Ride"] = 843.94, ["Mega"] = 3282.85, ["Mega|Fly|Ride"] = 3402.6}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.63, ["Fly"] = 42, ["Ride"] = 18.38, ["Fly|Ride"] = 102.1, ["Neon"] = 23.51, ["Neon|Fly"] = 71.76, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 108.82, ["Mega"] = 225.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 208.57, ["Fly"] = 344.78, ["Ride"] = 184.73, ["Fly|Ride"] = 232.39, ["Neon|Ride"] = 1215.22, ["Neon|Fly|Ride"] = 759.64, ["Mega"] = 10707.24, ["Mega|Fly|Ride"] = 5509.77}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.71, ["Fly"] = 77.44, ["Ride"] = 27.57, ["Fly|Ride"] = 68.25, ["Neon"] = 73.5, ["Neon|Fly"] = 308.68, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 500.05, ["Mega|Ride"] = 479.7, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.43, ["Fly"] = 71.76, ["Ride"] = 19.69, ["Fly|Ride"] = 72.19, ["Neon"] = 8.87, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 139.21, ["Mega"] = 78.62, ["Mega|Ride"] = 108.91, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.75, ["Mega"] = 17.62, ["Mega|Ride"] = 145.84, ["Mega|Fly|Ride"] = 321.23}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 4.75, ["Fly"] = 52.49, ["Ride"] = 35.33, ["Fly|Ride"] = 110.31, ["Neon"] = 6.21, ["Neon|Ride"] = 37.68, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 71.22, ["Mega|Fly"] = 162028.81, ["Mega|Ride"] = 136, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 67.57, ["Fly"] = 525, ["Ride"] = 110.44, ["Fly|Ride"] = 207.38, ["Neon"] = 313.69, ["Neon|Fly"] = 406.89, ["Neon|Ride"] = 291.06, ["Neon|Fly|Ride"] = 321.22, ["Mega|Fly|Ride"] = 1048.59}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.44, ["Ride"] = 15.74, ["Fly|Ride"] = 78.75, ["Neon"] = 7.3, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 52.5, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 262.47}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 59.17, ["Ride"] = 112.88, ["Fly|Ride"] = 81.39, ["Neon"] = 88.2, ["Neon|Fly"] = 274.19, ["Neon|Ride"] = 250.35, ["Neon|Fly|Ride"] = 223.11, ["Mega"] = 393.75, ["Mega|Ride"] = 542.88}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Ride"] = 56.8, ["Neon"] = 2.63, ["Neon|Ride"] = 53.86, ["Neon|Fly|Ride"] = 147.62, ["Mega"] = 16.02, ["Mega|Fly"] = 87.82, ["Mega|Ride"] = 49.38, ["Mega|Fly|Ride"] = 321.23}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 67.66, ["Ride"] = 15.79, ["Fly|Ride"] = 24.92, ["Neon"] = 2.1, ["Neon|Fly"] = 26.24, ["Neon|Ride"] = 14.42, ["Neon|Fly|Ride"] = 28.3, ["Mega"] = 13.11, ["Mega|Fly"] = 40.7, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 19.57, ["Ride"] = 15.63, ["Fly|Ride"] = 66.8, ["Neon"] = 3.93, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 24.94, ["Mega|Fly"] = 162.85, ["Mega|Ride"] = 32.83, ["Mega|Fly|Ride"] = 81.38}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 66.89, ["Mega"] = 19.49, ["Mega|Ride"] = 105}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 91.85, ["Ride"] = 31.61, ["Fly|Ride"] = 107.61, ["Neon"] = 3.94, ["Neon|Fly"] = 168, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 24.71, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42.88, ["Mega|Fly|Ride"] = 101.07}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 82.08, ["Neon|Fly|Ride"] = 410.49, ["Mega"] = 17.09, ["Mega|Fly"] = 128.5, ["Mega|Ride"] = 114.58}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 3.47, ["Fly"] = 77.24, ["Ride"] = 30.19, ["Fly|Ride"] = 143.07, ["Neon"] = 17.71, ["Neon|Fly"] = 69.28, ["Neon|Ride"] = 46.19, ["Neon|Fly|Ride"] = 104.98, ["Mega"] = 158.82, ["Mega|Fly"] = 122.07, ["Mega|Ride"] = 116.94, ["Mega|Fly|Ride"] = 253.89}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.24, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 321.62, ["Mega"] = 13.13, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 68.16, ["Mega|Fly|Ride"] = 131.24}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Ride"] = 144.56, ["Fly|Ride"] = 143.5, ["Neon"] = 18.13, ["Mega"] = 162.75, ["Mega|Fly"] = 315, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 28.93, ["Neon"] = 19.69, ["Mega"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 571.78}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 16.08, ["Neon"] = 3.94, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 20.79, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.02, ["Ride"] = 14.32, ["Fly|Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 35.21, ["Neon|Ride"] = 13.81, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 12.89, ["Mega|Fly"] = 28.93, ["Mega|Ride"] = 19.65, ["Mega|Fly|Ride"] = 49.86}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.93, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 118.11, ["Neon"] = 40.49, ["Neon|Ride"] = 140.95, ["Mega"] = 189, ["Mega|Ride"] = 240.19}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 27.85, ["Neon"] = 3.9, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 35.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 70.88, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 4.47, ["Neon"] = 12.75, ["Mega"] = 85.76, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 243.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.19, ["Fly"] = 65.63, ["Ride"] = 16.08, ["Fly|Ride"] = 59.07, ["Neon"] = 14.32, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 124.69, ["Mega|Ride"] = 143.06, ["Mega|Fly|Ride"] = 194.45}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 11.82, ["Fly|Ride"] = 28.3, ["Neon"] = 2.1, ["Neon|Fly"] = 15.61, ["Neon|Ride"] = 12.86, ["Neon|Fly|Ride"] = 29.86, ["Mega"] = 14.91, ["Mega|Fly"] = 26.17, ["Mega|Ride"] = 18.93, ["Mega|Fly|Ride"] = 51.98}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 27.4, ["Fly|Ride"] = 143.5, ["Neon"] = 10.26, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.47, ["Mega"] = 129.54, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.56, ["Fly"] = 112.52, ["Ride"] = 27.84, ["Fly|Ride"] = 59.06, ["Neon"] = 44.52, ["Neon|Ride"] = 67.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 261.19, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 281.54}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 32.45, ["Ride"] = 13.71, ["Fly|Ride"] = 36.75, ["Neon"] = 2.45, ["Neon|Fly"] = 15.65, ["Neon|Ride"] = 14.55, ["Neon|Fly|Ride"] = 42, ["Mega"] = 19.82, ["Mega|Ride"] = 26.25, ["Mega|Fly|Ride"] = 79.17}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.37, ["Fly"] = 178.83, ["Ride"] = 31.5, ["Neon"] = 5.97, ["Neon|Ride"] = 28.93, ["Neon|Fly|Ride"] = 167.25, ["Mega"] = 64.03, ["Mega|Fly"] = 171.33, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 13.13, ["Neon"] = 5.19, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 324.48, ["Mega"] = 27.28, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 125.18, ["Mega|Fly|Ride"] = 311.73}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 30.19, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 21.1, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 14.44, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 28.88, ["Mega|Fly|Ride"] = 143.5}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 71.76, ["Ride"] = 14.18, ["Fly|Ride"] = 46.45, ["Neon"] = 4.69, ["Neon|Fly"] = 53.64, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 58.47, ["Mega"] = 79.87, ["Mega|Ride"] = 100.67, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 57.83, ["Neon"] = 4.71, ["Neon|Ride"] = 63.18, ["Mega"] = 34.68, ["Mega|Fly"] = 243.06, ["Mega|Ride"] = 98.24, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 23.57, ["Ride"] = 13.13, ["Fly|Ride"] = 47.13, ["Neon"] = 4.76, ["Neon|Fly"] = 81.43, ["Neon|Ride"] = 20.48, ["Neon|Fly|Ride"] = 57.54, ["Mega"] = 103.69, ["Mega|Ride"] = 90.55, ["Mega|Fly|Ride"] = 120.91}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.94, ["Ride"] = 38.19, ["Neon"] = 30.78, ["Neon|Fly"] = 188.89, ["Neon|Ride"] = 50.34, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 98.44, ["Mega|Fly"] = 341.25}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 14.44, ["Fly|Ride"] = 32.03, ["Neon"] = 11.8, ["Neon|Fly"] = 48.2, ["Neon|Ride"] = 30.58, ["Neon|Fly|Ride"] = 70.76, ["Mega"] = 263.82, ["Mega|Fly"] = 420, ["Mega|Ride"] = 140.99, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.24, ["Fly"] = 20.04, ["Ride"] = 17.06, ["Fly|Ride"] = 57.75, ["Neon"] = 13.02, ["Neon|Fly"] = 63.18, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 168, ["Mega|Fly"] = 161.95, ["Mega|Ride"] = 428.31, ["Mega|Fly|Ride"] = 177.18}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 112.65, ["Fly|Ride"] = 143.5, ["Neon"] = 26.25, ["Neon|Ride"] = 105.74, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 175.94, ["Mega|Ride"] = 236.24}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 23.33, ["Ride"] = 56.44, ["Neon"] = 202, ["Mega"] = 571.78, ["Mega|Ride"] = 714.18, ["Mega|Fly|Ride"] = 812.69}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.17, ["Ride"] = 54.03, ["Neon"] = 45.84, ["Neon|Ride"] = 106.55, ["Mega"] = 237.57, ["Mega|Ride"] = 364.23}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.25, ["Ride"] = 31.39, ["Fly|Ride"] = 120.75, ["Neon"] = 47.67, ["Neon|Ride"] = 57.84, ["Mega"] = 428.31, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 366.58}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 65.01, ["Mega"] = 19.49, ["Mega|Fly"] = 123.15, ["Mega|Ride"] = 128.5, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 47.25}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.08, ["Fly"] = 23.61, ["Ride"] = 18.15, ["Fly|Ride"] = 43.32, ["Neon"] = 64.26, ["Neon|Fly"] = 188.48, ["Neon|Ride"] = 49.84, ["Neon|Fly|Ride"] = 78.64, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 337.29}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 14.69, ["Fly|Ride"] = 86.63, ["Neon"] = 2.62, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 160.42, ["Mega"] = 24.93, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 3.61, ["Neon|Ride"] = 35.6, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 39.37, ["Mega|Ride"] = 243.07, ["Mega|Fly|Ride"] = 143.5}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 51.47, ["Ride"] = 15.74, ["Fly|Ride"] = 42.84, ["Neon"] = 6.25, ["Neon|Ride"] = 18.94, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 141.75, ["Mega|Ride"] = 118.01, ["Mega|Fly|Ride"] = 229.95}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 4.6, ["Ride"] = 41.91, ["Fly|Ride"] = 57.75, ["Neon"] = 28.29, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 328.12, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 320.17}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 32.47, ["Neon"] = 2.41, ["Mega"] = 20.37, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 63.15, ["Mega|Fly|Ride"] = 119.89}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.67, ["Fly|Ride"] = 59.07, ["Neon"] = 3.55, ["Neon|Fly"] = 21.44, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 28.87, ["Mega|Fly"] = 143.16, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 103.95}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 28.93, ["Ride"] = 16.08, ["Fly|Ride"] = 28.93, ["Neon"] = 3.94, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 61.04, ["Mega"] = 47.95, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 3.94, ["Fly"] = 28.93, ["Ride"] = 32.15, ["Fly|Ride"] = 115.5, ["Neon"] = 9.08, ["Neon|Ride"] = 33.21, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 54.57, ["Mega|Ride"] = 82.51, ["Mega|Fly|Ride"] = 248.06}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 156517.83, ["Mega"] = 50.58, ["Mega|Fly"] = 97.23, ["Mega|Ride"] = 111.41, ["Mega|Fly|Ride"] = 136.48}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.9, ["Ride"] = 16.59, ["Fly|Ride"] = 52.5, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.37, ["Neon|Fly|Ride"] = 81.38, ["Mega"] = 27.28, ["Mega|Fly"] = 64.26, ["Mega|Ride"] = 46.92, ["Mega|Fly|Ride"] = 102.1}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.81, ["Neon|Ride"] = 40.7, ["Mega"] = 19.69, ["Mega|Ride"] = 139.02, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.63, ["Neon"] = 3.75, ["Neon|Ride"] = 324.48, ["Neon|Fly|Ride"] = 420, ["Mega"] = 27.28, ["Mega|Ride"] = 182.33, ["Mega|Fly|Ride"] = 265.55}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 14.43, ["Fly|Ride"] = 50.39, ["Neon"] = 2.6, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 40.5, ["Mega|Fly"] = 45.05, ["Mega|Ride"] = 53.34, ["Mega|Fly|Ride"] = 107.54}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 12.47, ["Fly"] = 39.38, ["Ride"] = 59.06, ["Fly|Ride"] = 214.16, ["Neon"] = 107.09, ["Mega"] = 571.78, ["Mega|Ride"] = 496.13, ["Mega|Fly|Ride"] = 714.18}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 6.56, ["Fly"] = 6562.5, ["Ride"] = 56.79, ["Neon"] = 45.94, ["Neon|Ride"] = 212.02, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 6.3, ["Ride"] = 31.58, ["Fly|Ride"] = 178.76, ["Neon"] = 26.24, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 250.08, ["Mega|Ride"] = 447.57, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.96, ["Ride"] = 11.67, ["Fly|Ride"] = 27.6, ["Neon"] = 2.1, ["Neon|Fly"] = 15.63, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 28.06, ["Mega"] = 13.38, ["Mega|Fly"] = 33.21, ["Mega|Ride"] = 19.69, ["Mega|Fly|Ride"] = 42}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 3.25, ["Fly"] = 118.12, ["Ride"] = 59.97, ["Neon"] = 4.88, ["Neon|Fly"] = 67.79, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 714.18, ["Mega"] = 77.41, ["Mega|Ride"] = 140.95, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 71.76, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Fly"] = 31.56, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 84.16, ["Mega"] = 13.13, ["Mega|Fly"] = 85.67, ["Mega|Ride"] = 69.45, ["Mega|Fly|Ride"] = 128.5}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.66, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 18.36, ["Mega|Fly|Ride"] = 314.98}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.24, ["Fly"] = 42, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 7.87, ["Neon|Fly"] = 71.17, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 75.8, ["Mega"] = 169.32, ["Mega|Fly"] = 243.06, ["Mega|Ride"] = 406.89, ["Mega|Fly|Ride"] = 292.69}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 153.21, ["Fly"] = 183.75, ["Ride"] = 196.64, ["Fly|Ride"] = 413.19, ["Neon"] = 934.76, ["Neon|Fly|Ride"] = 971.17, ["Mega"] = 8565.8, ["Mega|Ride"] = 3283.92, ["Mega|Fly|Ride"] = 3361.01}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 24.31, ["Neon"] = 8.04, ["Neon|Ride"] = 64.31, ["Mega"] = 68.06, ["Mega|Ride"] = 186.33, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 3.94, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 61.56, ["Neon"] = 31.2, ["Neon|Ride"] = 170.84, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 377.99, ["Mega|Ride"] = 534.31, ["Mega|Fly|Ride"] = 648.87}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 15.37, ["Fly|Ride"] = 31.5, ["Neon"] = 5.17, ["Neon|Fly"] = 33.21, ["Neon|Ride"] = 29.78, ["Neon|Fly|Ride"] = 47.41, ["Mega"] = 39.29, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 143.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 71.76, ["Ride"] = 18.13, ["Fly|Ride"] = 92.59, ["Neon"] = 7.07, ["Neon|Fly"] = 571.78, ["Neon|Ride"] = 60.27, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 70.35, ["Mega|Ride"] = 194.45, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.63, ["Fly"] = 25.46, ["Ride"] = 15.65, ["Fly|Ride"] = 36.83, ["Neon"] = 30.19, ["Neon|Fly"] = 98.85, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 77.95, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 243.06}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 9.18, ["Ride"] = 28.93, ["Fly|Ride"] = 254.4, ["Neon"] = 44.72, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 262.49, ["Mega|Ride"] = 306.59, ["Mega|Fly|Ride"] = 349.99}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 4.3, ["Fly"] = 18.79, ["Ride"] = 15.92, ["Fly|Ride"] = 36.51, ["Neon"] = 23.67, ["Neon|Fly"] = 66.94, ["Neon|Ride"] = 36.24, ["Neon|Fly|Ride"] = 77.09, ["Mega"] = 210, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 79.8, ["Ride"] = 91.23, ["Fly|Ride"] = 143.5, ["Neon"] = 341.24, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1430.63}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 192.93, ["Fly"] = 428.31, ["Ride"] = 246.75, ["Fly|Ride"] = 308.43, ["Neon"] = 1135.02, ["Neon|Ride"] = 1142.48, ["Neon|Fly|Ride"] = 970.09, ["Mega"] = 10707.24, ["Mega|Fly|Ride"] = 4993.87}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 53.47, ["Fly"] = 143.5, ["Ride"] = 77.09, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Ride"] = 256.99, ["Neon|Fly|Ride"] = 361.89, ["Mega|Fly|Ride"] = 1360.71}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.43, ["Fly"] = 42.84, ["Ride"] = 23.04, ["Neon"] = 28.93, ["Neon|Fly"] = 85.67, ["Neon|Ride"] = 122.8, ["Neon|Fly|Ride"] = 181.12, ["Mega"] = 262.49, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.07}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 6.56, ["Ride"] = 19.69, ["Fly|Ride"] = 70.18, ["Neon"] = 81.02, ["Neon|Ride"] = 59.66, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 355.68, ["Mega|Ride"] = 310.97, ["Mega|Fly|Ride"] = 1278.46}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 31.16, ["Ride"] = 15.32, ["Fly|Ride"] = 44.54, ["Neon"] = 2.62, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 80.32, ["Mega"] = 49.26, ["Mega|Fly"] = 148.26, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 366.61}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 6.12, ["Fly"] = 39.38, ["Ride"] = 23.01, ["Fly|Ride"] = 81.2, ["Neon"] = 399, ["Neon|Fly"] = 357.63, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 184.46, ["Mega"] = 1837.5, ["Mega|Ride"] = 551.72, ["Mega|Fly|Ride"] = 732.38}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 15.69, ["Fly|Ride"] = 34.65, ["Neon"] = 4.88, ["Neon|Fly"] = 81.43, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 65.64, ["Mega|Fly"] = 162.85, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 180.28}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.63, ["Ride"] = 24.64, ["Fly|Ride"] = 328.13, ["Neon"] = 22.32, ["Neon|Ride"] = 35.76, ["Mega"] = 186.33, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.57, ["Ride"] = 19.35, ["Neon"] = 2.1, ["Neon|Ride"] = 19.67, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 14.88, ["Mega|Ride"] = 42.84, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.63, ["Fly"] = 24.64, ["Ride"] = 18.38, ["Fly|Ride"] = 42.84, ["Neon"] = 15.39, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 159.92}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 3.94, ["Fly"] = 25.71, ["Ride"] = 18.51, ["Fly|Ride"] = 62.05, ["Neon"] = 21.44, ["Neon|Ride"] = 47.25, ["Mega"] = 118.13, ["Mega|Ride"] = 207.74, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 118.1, ["Fly"] = 179.29, ["Ride"] = 139.55, ["Fly|Ride"] = 189.7, ["Neon"] = 472.49, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 525, ["Mega"] = 4282.9, ["Mega|Fly|Ride"] = 2255.93}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.44, ["Ride"] = 37.01, ["Fly|Ride"] = 130.05, ["Neon"] = 48.87, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 271.98, ["Mega"] = 326.82, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 28.93, ["Ride"] = 15.74, ["Fly|Ride"] = 39.38, ["Neon"] = 12.86, ["Neon|Ride"] = 29.18, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 243.06, ["Mega|Ride"] = 263.74, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 23.43, ["Ride"] = 58.01, ["Fly|Ride"] = 170.63, ["Neon"] = 131.25, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 564.36, ["Mega"] = 1051.32, ["Mega|Fly"] = 856.59, ["Mega|Ride"] = 683.82, ["Mega|Fly|Ride"] = 642.45}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.57, ["Ride"] = 28.84, ["Fly|Ride"] = 125.14, ["Neon"] = 46.47, ["Neon|Ride"] = 119.26, ["Neon|Fly|Ride"] = 357.63, ["Mega"] = 297.67, ["Mega|Ride"] = 502.69, ["Mega|Fly|Ride"] = 891.98}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.37, ["Fly"] = 41.91, ["Ride"] = 36.25, ["Fly|Ride"] = 51.98, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.64, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 1382.32, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 19.07, ["Fly|Ride"] = 65.63, ["Neon"] = 4.56, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.17, ["Neon|Fly|Ride"] = 106.31, ["Mega"] = 23.62, ["Mega|Fly"] = 188.99, ["Mega|Ride"] = 57.08, ["Mega|Fly|Ride"] = 228.79}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 4.55, ["Fly"] = 28.4, ["Ride"] = 19.81, ["Fly|Ride"] = 65.54, ["Neon"] = 55.13, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 64.26, ["Mega"] = 285.9, ["Mega|Fly"] = 405.9, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 426.16}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.74, ["Fly|Ride"] = 46.81, ["Neon"] = 17.75, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 28.93, ["Neon|Fly|Ride"] = 71.31, ["Mega"] = 137.49, ["Mega|Ride"] = 184.86, ["Mega|Fly|Ride"] = 323.26}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 28.75, ["Fly|Ride"] = 195.97, ["Neon"] = 2.63, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 32.69, ["Mega"] = 26.22, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 28.73, ["Ride"] = 74.82, ["Fly|Ride"] = 94.49, ["Neon"] = 162.65, ["Neon|Ride"] = 209.68, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 850.64, ["Mega|Ride"] = 1000.08}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 3.93, ["Fly"] = 28.93, ["Ride"] = 28.93, ["Fly|Ride"] = 210, ["Neon"] = 92.65, ["Mega"] = 143.5, ["Mega|Ride"] = 342.65}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 4.88, ["Fly"] = 28.8, ["Ride"] = 20.84, ["Fly|Ride"] = 41.91, ["Neon"] = 26.78, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 34.17, ["Neon|Fly|Ride"] = 74.72, ["Mega"] = 383.97, ["Mega|Ride"] = 289.11, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 68.25, ["Fly"] = 433.12, ["Ride"] = 393.75, ["Fly|Ride"] = 262.48, ["Neon"] = 367.5, ["Neon|Ride"] = 236.25, ["Mega"] = 4538.82, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 2427.36}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 9.59, ["Fly"] = 44.94, ["Ride"] = 21, ["Fly|Ride"] = 57.66, ["Neon"] = 59.06, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 105, ["Mega"] = 242.82, ["Mega|Ride"] = 236.06, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 68.86, ["Fly"] = 143.06, ["Ride"] = 104.99, ["Fly|Ride"] = 149.43, ["Neon"] = 261.28, ["Neon|Fly"] = 299.82, ["Neon|Ride"] = 234.94, ["Neon|Fly|Ride"] = 312.27, ["Mega"] = 1087.63, ["Mega|Ride"] = 901.78, ["Mega|Fly|Ride"] = 968.25}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 20.9, ["Ride"] = 47.25, ["Fly|Ride"] = 143.5, ["Neon"] = 80.54, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 354.38, ["Mega|Ride"] = 333.65, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 3.82, ["Fly"] = 41.36, ["Ride"] = 28.84, ["Fly|Ride"] = 70.13, ["Neon"] = 85.67, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 386.46, ["Mega"] = 214.16, ["Mega|Ride"] = 1606.11, ["Mega|Fly|Ride"] = 534.31}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 18.38, ["Fly"] = 70.68, ["Ride"] = 49.86, ["Fly|Ride"] = 162.85, ["Neon"] = 61.99, ["Neon|Ride"] = 74.41, ["Neon|Fly|Ride"] = 328.02, ["Mega"] = 263.8, ["Mega|Ride"] = 280.87, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.57, ["Ride"] = 29.3, ["Fly|Ride"] = 89.96, ["Neon"] = 32.61, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 263.74, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Ride"] = 69.4, ["Neon"] = 2.24, ["Neon|Fly"] = 92.84, ["Neon|Ride"] = 91.68, ["Mega"] = 19.29, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.55, ["Ride"] = 57.78, ["Neon"] = 24.3, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 196.88, ["Mega|Ride"] = 271.98, ["Mega|Fly|Ride"] = 426.16}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 126.36, ["Ride"] = 27.76, ["Neon"] = 28.76, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 186.33, ["Mega"] = 186.33, ["Mega|Ride"] = 196.6, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.93, ["Ride"] = 32.79, ["Fly|Ride"] = 121.53, ["Neon"] = 31.06, ["Neon|Ride"] = 80.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 123.38, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 530.24, ["Fly|Ride"] = 612.38, ["Neon"] = 1820.24, ["Neon|Ride"] = 1811.25, ["Neon|Fly|Ride"] = 1555.52, ["Mega|Fly|Ride"] = 5880}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 6.91, ["Fly"] = 45.47, ["Ride"] = 20.43, ["Fly|Ride"] = 56.34, ["Neon"] = 40.95, ["Neon|Ride"] = 62.91, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 157.5, ["Mega|Ride"] = 368.03, ["Mega|Fly|Ride"] = 354.42}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 9.19, ["Fly"] = 66.94, ["Ride"] = 24.64, ["Fly|Ride"] = 51.54, ["Neon"] = 39.38, ["Neon|Fly"] = 315, ["Neon|Ride"] = 92.09, ["Neon|Fly|Ride"] = 161.21, ["Mega"] = 331.87, ["Mega|Ride"] = 427.24, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 6.43, ["Fly"] = 24.93, ["Ride"] = 24.94, ["Fly|Ride"] = 50.79, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 158.48}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.59, ["Ride"] = 24.05, ["Fly|Ride"] = 52.41, ["Neon"] = 7.74, ["Neon|Ride"] = 30.35, ["Neon|Fly|Ride"] = 103.83, ["Mega"] = 58.47, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 88.66, ["Mega|Fly|Ride"] = 214.14}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 71.76, ["Ride"] = 16.95, ["Neon"] = 3.29, ["Neon|Ride"] = 23.58, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 18.38, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 77.35, ["Mega|Fly|Ride"] = 221.55}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1108.96}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 5.64, ["Ride"] = 18.38, ["Fly|Ride"] = 59.07, ["Neon"] = 54.57, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 324.48, ["Mega"] = 405.9, ["Mega|Ride"] = 854.45, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 27.3, ["Neon"] = 3.83, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 982.1, ["Mega"] = 39.29, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 250.04}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.28, ["Fly"] = 27.45, ["Ride"] = 65.63, ["Neon"] = 30.87, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 196.87, ["Mega|Ride"] = 324.48, ["Mega|Fly|Ride"] = 414.39}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 420, ["Ride"] = 424.03, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1555.05, ["Neon|Fly|Ride"] = 1312.49, ["Mega"] = 8912.36, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 4.96, ["Fly"] = 196.88, ["Ride"] = 57.84, ["Fly|Ride"] = 428.31, ["Neon"] = 30.18, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 194.45, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.23, ["Fly|Ride"] = 118.13, ["Neon"] = 3.82, ["Neon|Ride"] = 36.9, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 35.44, ["Mega|Fly"] = 142.79, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Neon|Ride"] = 133.94, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 32.82, ["Mega|Ride"] = 136.15, ["Mega|Fly|Ride"] = 375.38}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 19.13, ["Fly"] = 107.88, ["Ride"] = 80.07, ["Fly|Ride"] = 143.5, ["Neon"] = 152.69, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 622.91, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 539.24}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 13.22, ["Ride"] = 71.31, ["Neon"] = 83.53, ["Neon|Ride"] = 291.38, ["Neon|Fly|Ride"] = 486.1, ["Mega"] = 405.9, ["Mega|Ride"] = 479.73, ["Mega|Fly|Ride"] = 571.78}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 5.25, ["Ride"] = 31.5, ["Neon"] = 96.94, ["Neon|Ride"] = 183.38, ["Mega"] = 664.74, ["Mega|Ride"] = 785.92, ["Mega|Fly|Ride"] = 1284.89}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 9.97, ["Ride"] = 23.85, ["Fly|Ride"] = 236.25, ["Neon"] = 131.25, ["Neon|Ride"] = 177.5, ["Neon|Fly|Ride"] = 247.35, ["Mega"] = 616.88, ["Mega|Ride"] = 1300.04, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 389.15, ["Fly|Ride"] = 520.13, ["Neon"] = 1365, ["Neon|Ride"] = 1428.36, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3570.88, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.57, ["Fly"] = 42, ["Ride"] = 26.25, ["Fly|Ride"] = 82.18, ["Neon"] = 190.32, ["Neon|Ride"] = 164.05, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 881.22}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.57, ["Ride"] = 42.68, ["Fly|Ride"] = 127.32, ["Neon"] = 56.22, ["Neon|Ride"] = 285.9, ["Mega"] = 169.19, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 24.94, ["Ride"] = 80.07, ["Fly|Ride"] = 236.25, ["Neon"] = 80.07, ["Neon|Ride"] = 158.63, ["Neon|Fly|Ride"] = 260.78, ["Mega"] = 308.43, ["Mega|Fly"] = 714.18, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 42.84, ["Fly|Ride"] = 214.16, ["Neon"] = 7.38, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 36.75, ["Mega|Ride"] = 128.29, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 39.38, ["Ride"] = 87.5, ["Neon"] = 315, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 513.96, ["Mega"] = 1976.57, ["Mega|Ride"] = 1093.71, ["Mega|Fly|Ride"] = 1283.64}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 521, ["Ride"] = 26.25, ["Fly|Ride"] = 196.88, ["Neon"] = 6.57, ["Neon|Fly"] = 186.33, ["Neon|Ride"] = 37.01, ["Neon|Fly|Ride"] = 108.53, ["Mega"] = 72.19, ["Mega|Ride"] = 93.9, ["Mega|Fly|Ride"] = 261.85}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.52, ["Fly"] = 26.24, ["Ride"] = 27.97, ["Neon"] = 3.49, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 32.82, ["Mega|Fly"] = 114.26, ["Mega|Ride"] = 76.61, ["Mega|Fly|Ride"] = 170.52}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.96, ["Fly|Ride"] = 127.52, ["Neon"] = 9.74, ["Neon|Ride"] = 62.12, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 81.43, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 243.06}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 45.65, ["Fly"] = 65.61, ["Ride"] = 60.37, ["Fly|Ride"] = 157.5, ["Neon"] = 236.25, ["Neon|Ride"] = 320.46, ["Neon|Fly|Ride"] = 486.1, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 258.57, ["Ride"] = 254.63, ["Fly|Ride"] = 427.24, ["Neon"] = 1462.13, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 9721.69, ["Mega|Fly|Ride"] = 4629.19}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 32.81, ["Neon"] = 32.82, ["Neon|Fly"] = 350.44, ["Mega"] = 110.44, ["Mega|Fly"] = 19687.5, ["Mega|Ride"] = 214.16, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.63, ["Fly"] = 71.76, ["Ride"] = 23.63, ["Fly|Ride"] = 162.85, ["Neon"] = 6.11, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 140.43, ["Mega"] = 38.07, ["Mega|Fly"] = 164.07, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 6.3, ["Fly"] = 105, ["Ride"] = 28.41, ["Fly|Ride"] = 81.43, ["Neon"] = 32.82, ["Mega"] = 122.08, ["Mega|Ride"] = 344.55, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 63.67, ["Ride"] = 30.05, ["Fly|Ride"] = 374.42, ["Neon"] = 15.54, ["Neon|Ride"] = 52.47, ["Mega"] = 124.59, ["Mega|Fly"] = 237.71, ["Mega|Ride"] = 140.37, ["Mega|Fly|Ride"] = 299.82}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 59.06, ["Neon"] = 8.54, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 31.19, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 37.49, ["Ride"] = 17.93, ["Fly|Ride"] = 52.49, ["Neon"] = 5.19, ["Neon|Fly"] = 81.43, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 127.43, ["Mega"] = 43.32, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 249.37}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 26.25, ["Ride"] = 17.8, ["Fly|Ride"] = 41.32, ["Neon"] = 15.18, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 38.5, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 156.15, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 171.33}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 29.78, ["Fly"] = 28.88, ["Ride"] = 32.43, ["Fly|Ride"] = 128.83, ["Neon"] = 143.5, ["Neon|Ride"] = 280.88, ["Neon|Fly|Ride"] = 318.05, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 64.95, ["Ride"] = 84.32, ["Fly|Ride"] = 139.13, ["Neon"] = 410.82, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 455.44, ["Mega"] = 2000.13, ["Mega|Ride"] = 1415.51, ["Mega|Fly|Ride"] = 1515.94}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 18.95, ["Fly|Ride"] = 144.38, ["Neon"] = 3.73, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 126.13, ["Mega"] = 44.99, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.8, ["Mega|Fly|Ride"] = 246.11}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 14.22, ["Ride"] = 15.64, ["Fly|Ride"] = 39.37, ["Neon"] = 3.42, ["Neon|Fly"] = 28.41, ["Neon|Ride"] = 21.44, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 37.98, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 67.6, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 3.01, ["Fly"] = 42.84, ["Ride"] = 28.35, ["Fly|Ride"] = 131.25, ["Neon"] = 48.2, ["Neon|Ride"] = 135.19, ["Mega"] = 527.62, ["Mega|Ride"] = 274.32, ["Mega|Fly|Ride"] = 477.75}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.65, ["Fly"] = 518.44, ["Ride"] = 472.5, ["Fly|Ride"] = 577.5, ["Neon"] = 4282.9, ["Neon|Ride"] = 2430.43, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 8101.82}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 45.83, ["Fly"] = 100.67, ["Ride"] = 41.99, ["Fly|Ride"] = 108.94, ["Neon"] = 223.13, ["Neon|Ride"] = 225.74, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 765.05, ["Mega|Fly|Ride"] = 1296.65}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 22.52, ["Fly|Ride"] = 281.33, ["Neon"] = 6.57, ["Neon|Ride"] = 47.91, ["Neon|Fly|Ride"] = 143.07, ["Mega"] = 102.38, ["Mega|Ride"] = 144.33, ["Mega|Fly|Ride"] = 272.99}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 91.87, ["Ride"] = 65.62, ["Fly|Ride"] = 65.54, ["Neon"] = 14.25, ["Neon|Ride"] = 72.34, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 20.86, ["Fly"] = 169.3, ["Ride"] = 37.49, ["Fly|Ride"] = 87.12, ["Neon"] = 194.25, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 280.81, ["Mega"] = 2569.75, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1284.89}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 90.95, ["Fly"] = 105, ["Ride"] = 112.28, ["Fly|Ride"] = 192.75, ["Neon"] = 430.1, ["Neon|Ride"] = 486.1, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 8565.8, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 229.68, ["Ride"] = 295.32, ["Fly|Ride"] = 349.07, ["Neon"] = 874.96, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 3636.19}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 19.69, ["Ride"] = 61.6, ["Fly|Ride"] = 145.84, ["Neon"] = 85.22, ["Neon|Ride"] = 85.32, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 389.79, ["Mega|Ride"] = 404.79, ["Mega|Fly|Ride"] = 1070.73}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 19.58, ["Ride"] = 16.96, ["Fly|Ride"] = 43.2, ["Neon"] = 7.24, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 88.77, ["Mega"] = 93.18, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 170.42}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 4.13, ["Fly"] = 39.3, ["Ride"] = 17.75, ["Fly|Ride"] = 50.34, ["Neon"] = 30.87, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 39.59, ["Neon|Fly|Ride"] = 85.29, ["Mega"] = 371.56, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 384.5, ["Ride"] = 427.24, ["Fly|Ride"] = 648.94, ["Neon"] = 1575, ["Neon|Ride"] = 2141.46, ["Mega"] = 10278.95, ["Mega|Fly|Ride"] = 4957.32}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 8.44, ["Neon|Ride"] = 285.9, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 28.88, ["Mega|Ride"] = 170.99, ["Mega|Fly|Ride"] = 450.13}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.66, ["Fly"] = 42.84, ["Ride"] = 15.65, ["Fly|Ride"] = 55.69, ["Neon"] = 24.31, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 237.71, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.3, ["Ride"] = 65.33, ["Neon"] = 106.32, ["Neon|Fly"] = 428.31, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 454.78, ["Mega|Ride"] = 609, ["Mega|Fly|Ride"] = 612.56}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 85.32, ["Fly"] = 143.5, ["Ride"] = 104.99, ["Fly|Ride"] = 127.03, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 546.19, ["Mega|Fly|Ride"] = 2379.57}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 13.13, ["Fly"] = 24.33, ["Ride"] = 24.94, ["Fly|Ride"] = 53.26, ["Neon"] = 127.43, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 713.12, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 21.44, ["Neon"] = 3.24, ["Neon|Ride"] = 143.5, ["Mega"] = 23.62, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.53, ["Fly|Ride"] = 71.76, ["Neon"] = 2.37, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 81.32, ["Mega"] = 26.23, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 32.82, ["Mega|Fly|Ride"] = 109.98}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 11.81, ["Ride"] = 56.41, ["Fly|Ride"] = 160.08, ["Neon"] = 31.48, ["Neon|Ride"] = 84.38, ["Neon|Fly|Ride"] = 201.39, ["Mega"] = 171.01, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 302.13}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1168.13, ["Ride"] = 1443.75, ["Fly|Ride"] = 1325.63, ["Neon"] = 4376.12, ["Neon|Ride"] = 7138.52, ["Neon|Fly|Ride"] = 4397.47, ["Mega|Fly|Ride"] = 12597.38}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 426.57, ["Ride"] = 426.56, ["Fly|Ride"] = 595.88, ["Neon"] = 1646.57, ["Neon|Ride"] = 1640.63, ["Neon|Fly|Ride"] = 1753.5, ["Mega"] = 17131.58, ["Mega|Fly|Ride"] = 7207.05}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 310.32, ["Fly"] = 424.03, ["Ride"] = 348.86, ["Fly|Ride"] = 441.77, ["Neon"] = 787.5, ["Neon|Fly"] = 1135.02, ["Neon|Ride"] = 672.81, ["Neon|Fly|Ride"] = 786.09, ["Mega|Fly|Ride"] = 2916.23}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 321.22, ["Fly"] = 359.79, ["Ride"] = 304.49, ["Fly|Ride"] = 458.07, ["Neon"] = 708.75, ["Neon|Ride"] = 745.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 3232.47}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 64.32, ["Ride"] = 17.14, ["Fly|Ride"] = 38.61, ["Neon"] = 5.24, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 105, ["Mega"] = 69.44, ["Mega|Fly"] = 113.51, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 367.4, ["Fly"] = 1428.36, ["Ride"] = 357, ["Fly|Ride"] = 498.75, ["Neon"] = 1284.89, ["Neon|Ride"] = 1261.33, ["Neon|Fly|Ride"] = 1359.75, ["Mega"] = 21700.35, ["Mega|Ride"] = 5139.48, ["Mega|Fly|Ride"] = 4318.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.88, ["Fly"] = 157.5, ["Ride"] = 65.64, ["Fly|Ride"] = 112.88, ["Neon"] = 22.75, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 252, ["Mega"] = 138.01, ["Mega|Ride"] = 243.01, ["Mega|Fly|Ride"] = 370.77}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 18.12, ["Ride"] = 15.12, ["Fly|Ride"] = 38.58, ["Neon"] = 20.35, ["Neon|Ride"] = 40.7, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 104.81, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Neon"] = 3.94, ["Neon|Ride"] = 45.94, ["Mega"] = 28.76, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 236.64}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 28.87, ["Ride"] = 52.59, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 351.29, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 8038.15, ["Ride"] = 26.25, ["Fly|Ride"] = 66.89, ["Neon"] = 24.31, ["Mega"] = 359.79, ["Mega|Ride"] = 294.53, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 2.63, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 19.88, ["Mega|Ride"] = 69.28, ["Mega|Fly|Ride"] = 166.04}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 4.97, ["Fly"] = 41.03, ["Ride"] = 27.36, ["Fly|Ride"] = 65.54, ["Neon"] = 15.74, ["Neon|Fly"] = 113.9, ["Neon|Ride"] = 32.83, ["Neon|Fly|Ride"] = 80.12, ["Mega"] = 131.25, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 230.6}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 4.3, ["Fly"] = 57.84, ["Ride"] = 19.23, ["Fly|Ride"] = 49.83, ["Neon"] = 35.77, ["Neon|Fly"] = 145.84, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.82, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 14.22, ["Ride"] = 48.62, ["Neon"] = 92.9, ["Neon|Ride"] = 171.33, ["Neon|Fly|Ride"] = 313.53, ["Mega"] = 380.12, ["Mega|Ride"] = 801.98, ["Mega|Fly|Ride"] = 714.18}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 3.91, ["Fly"] = 6266.55, ["Ride"] = 18.38, ["Fly|Ride"] = 42.84, ["Neon"] = 46.1, ["Neon|Fly"] = 47.92, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 328.02, ["Mega|Ride"] = 422.94, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 65, ["Ride"] = 18.38, ["Fly|Ride"] = 45.83, ["Neon"] = 3.94, ["Neon|Fly"] = 32.15, ["Neon|Ride"] = 28.14, ["Neon|Fly|Ride"] = 100.67, ["Mega"] = 44.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 163.61, ["Fly"] = 261.28, ["Ride"] = 157.5, ["Fly|Ride"] = 229.69, ["Neon"] = 812.69, ["Neon|Ride"] = 912.63, ["Neon|Fly|Ride"] = 838.69, ["Mega"] = 8565.8, ["Mega|Fly|Ride"] = 3492.2}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 13.94, ["Fly|Ride"] = 35.42, ["Neon"] = 2.63, ["Neon|Fly"] = 40.7, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 37.68, ["Mega|Ride"] = 54.68, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.11, ["Ride"] = 42.47, ["Fly|Ride"] = 174.57, ["Neon"] = 55.13, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 313.69, ["Mega|Fly"] = 810.55, ["Mega|Ride"] = 449.72, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 81.25, ["Fly|Ride"] = 170.63, ["Neon"] = 152.8, ["Neon|Ride"] = 278.4, ["Neon|Fly|Ride"] = 256.99, ["Mega"] = 786.19, ["Mega|Ride"] = 569.18, ["Mega|Fly|Ride"] = 850.18}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 191.62, ["Fly"] = 304.5, ["Ride"] = 232.32, ["Fly|Ride"] = 288.75, ["Neon"] = 788.26, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 756, ["Mega|Fly|Ride"] = 3452.03}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 23.38, ["Ride"] = 158.3, ["Fly|Ride"] = 145.84, ["Neon"] = 91.88, ["Neon|Ride"] = 143.5, ["Mega"] = 287.44, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 271.98}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.56, ["Ride"] = 57.75, ["Fly|Ride"] = 182.44, ["Neon"] = 105.19, ["Neon|Fly"] = 162.85, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 146.08, ["Mega"] = 771.89, ["Mega|Ride"] = 856.59, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 951.57, ["Fly"] = 1050, ["Ride"] = 1007.01, ["Fly|Ride"] = 1050, ["Neon|Ride"] = 4790.63, ["Neon|Fly|Ride"] = 4992.8, ["Mega|Fly|Ride"] = 17824.71}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.85, ["Fly"] = 21, ["Ride"] = 20.78, ["Fly|Ride"] = 43.32, ["Neon"] = 20.35, ["Neon|Fly"] = 53.05, ["Neon|Ride"] = 55.12, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 230.91, ["Mega|Ride"] = 228.48, ["Mega|Fly|Ride"] = 342.65}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 4.03, ["Fly"] = 78.75, ["Ride"] = 35.44, ["Fly|Ride"] = 135.19, ["Neon"] = 37.05, ["Neon|Ride"] = 84.6, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 531.09, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1000.08}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 84.6, ["Ride"] = 23.78, ["Fly|Ride"] = 69.57, ["Neon"] = 9.19, ["Neon|Ride"] = 45.82, ["Mega"] = 78.75, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.11, ["Fly"] = 55.69, ["Ride"] = 32.82, ["Fly|Ride"] = 87.51, ["Neon"] = 59.07, ["Neon|Ride"] = 90.72, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 437.07, ["Mega|Ride"] = 344.33, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.63, ["Fly"] = 20.47, ["Ride"] = 21, ["Fly|Ride"] = 50.34, ["Neon"] = 16.7, ["Neon|Fly"] = 42.73, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 105.74, ["Mega"] = 157.5, ["Mega|Fly"] = 256.99, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 192.78}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Neon"] = 10.49, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 59.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 124.48, ["Mega|Ride"] = 199.38, ["Mega|Fly|Ride"] = 427.24}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 175.62, ["Fly"] = 238.8, ["Ride"] = 262.5, ["Fly|Ride"] = 229.15, ["Neon|Fly|Ride"] = 1182.57}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.5, ["Fly"] = 32.8, ["Ride"] = 24.64, ["Fly|Ride"] = 108.94, ["Neon"] = 5.97, ["Neon|Fly"] = 34.17, ["Neon|Ride"] = 45.45, ["Neon|Fly|Ride"] = 127.42, ["Mega|Fly"] = 428.31, ["Mega|Ride"] = 122.06, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 4.88, ["Ride"] = 82.01, ["Fly|Ride"] = 88.86, ["Neon"] = 27.57, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.15, ["Mega"] = 175.88, ["Mega|Ride"] = 324.48, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.19, ["Fly"] = 98.86, ["Ride"] = 25.47, ["Neon"] = 13.38, ["Neon|Ride"] = 84.14, ["Mega"] = 85.31, ["Mega|Ride"] = 120.51, ["Mega|Fly|Ride"] = 459.05}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 88.35, ["Ride"] = 127.32, ["Fly|Ride"] = 315, ["Neon"] = 493.86, ["Neon|Ride"] = 642.45, ["Neon|Fly|Ride"] = 674.57, ["Mega"] = 2763.39, ["Mega|Ride"] = 4282.9, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 23.45, ["Fly"] = 90.76, ["Ride"] = 48.62, ["Fly|Ride"] = 255.03, ["Neon"] = 150.83, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 634.33, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 19.57, ["Fly"] = 57.49, ["Ride"] = 34.13, ["Fly|Ride"] = 97.13, ["Neon"] = 85.32, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 243.07, ["Mega"] = 469.11, ["Mega|Ride"] = 435.74, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 4.19, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.14, ["Mega"] = 77.44, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 61.07, ["Fly"] = 78.75, ["Ride"] = 83.91, ["Fly|Ride"] = 158.82, ["Neon"] = 315, ["Neon|Fly"] = 216.57, ["Neon|Ride"] = 247.22, ["Neon|Fly|Ride"] = 301.77, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 42.84, ["Neon"] = 5.66, ["Neon|Ride"] = 57.69, ["Neon|Fly|Ride"] = 127.43, ["Mega"] = 58.91, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 19.3, ["Fly"] = 106.96, ["Ride"] = 26.25, ["Fly|Ride"] = 121.53, ["Neon"] = 68.61, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 353.51, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 290.45, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 51.36, ["Fly"] = 203.44, ["Ride"] = 76.13, ["Fly|Ride"] = 186.33, ["Neon"] = 229.69, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1390.88, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 14.44, ["Ride"] = 13.2, ["Fly|Ride"] = 27.85, ["Neon"] = 2.5, ["Neon|Fly"] = 24.64, ["Neon|Ride"] = 12.7, ["Neon|Fly|Ride"] = 39.29, ["Mega"] = 14.85, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 5.25, ["Ride"] = 27.57, ["Fly|Ride"] = 131.25, ["Neon"] = 19.46, ["Neon|Ride"] = 64.26, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 229.15, ["Mega|Ride"] = 285.59, ["Mega|Fly|Ride"] = 392.43}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 19.43, ["Ride"] = 43.22, ["Fly|Ride"] = 85.32, ["Neon"] = 105, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 210, ["Mega"] = 434.15, ["Mega|Ride"] = 444.94, ["Mega|Fly|Ride"] = 651}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.78, ["Neon"] = 2.63, ["Neon|Ride"] = 28.86, ["Neon|Fly|Ride"] = 95.81, ["Mega"] = 19.68, ["Mega|Ride"] = 79.25, ["Mega|Fly|Ride"] = 200.24}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 19.37, ["Fly"] = 199.4, ["Ride"] = 57.75, ["Fly|Ride"] = 125.99, ["Neon"] = 115.66, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 627.99, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 491.75, ["Mega|Fly|Ride"] = 614.23}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 18.37, ["Fly"] = 41.91, ["Ride"] = 26.25, ["Fly|Ride"] = 98.44, ["Neon"] = 357.86, ["Neon|Ride"] = 97.46, ["Neon|Fly|Ride"] = 129.94, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 4.18, ["Ride"] = 46.31, ["Neon"] = 25.51, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 714.18, ["Mega"] = 231, ["Mega|Ride"] = 254.63, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.25, ["Fly"] = 72.19, ["Ride"] = 56.79, ["Fly|Ride"] = 196.88, ["Neon"] = 13.13, ["Neon|Ride"] = 121.7, ["Neon|Fly|Ride"] = 6480.73, ["Mega"] = 397.25, ["Mega|Ride"] = 364.06, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 42.84, ["Ride"] = 19.38, ["Fly|Ride"] = 196.88, ["Neon"] = 3.94, ["Neon|Ride"] = 32.51, ["Mega"] = 69.57, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 145.69, ["Mega|Fly|Ride"] = 282.69}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.34, ["Neon"] = 3.93, ["Neon|Ride"] = 45.26, ["Mega"] = 21.73, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 233.89}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 18.56}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 36.3, ["Fly"] = 100.67, ["Ride"] = 52.5, ["Fly|Ride"] = 59.07, ["Neon"] = 184.54, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 1854.57, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 850.54}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.61, ["Neon|Ride"] = 27.56, ["Mega"] = 18.37, ["Mega|Ride"] = 119.81, ["Mega|Fly|Ride"] = 321.23}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 486.1, ["Fly"] = 498.75, ["Ride"] = 551.25, ["Fly|Ride"] = 907.77, ["Neon"] = 2855.64, ["Neon|Fly|Ride"] = 2089.91, ["Mega"] = 17131.58, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 4.82, ["Fly"] = 26.25, ["Ride"] = 33.72, ["Fly|Ride"] = 66.26, ["Neon"] = 35.28, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 285.9, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 91.33, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 5.04, ["Fly"] = 52.49, ["Ride"] = 19.68, ["Fly|Ride"] = 83.79, ["Neon"] = 19.44, ["Neon|Ride"] = 47.86, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 143.5, ["Mega|Fly"] = 214.16, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 39.38, ["Fly"] = 71.76, ["Ride"] = 29.18, ["Fly|Ride"] = 69.57, ["Neon"] = 55.53, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 678.85, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 4.3, ["Fly"] = 57.84, ["Ride"] = 28.93, ["Fly|Ride"] = 714.18, ["Neon"] = 16.7, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 275.63, ["Mega|Ride"] = 243.06, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 8.29, ["Ride"] = 72.19, ["Fly|Ride"] = 157.5, ["Neon"] = 59.07, ["Neon|Ride"] = 114.58, ["Mega"] = 292.81, ["Mega|Ride"] = 472.2, ["Mega|Fly|Ride"] = 599.62}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.88, ["Fly"] = 105, ["Ride"] = 34.28, ["Fly|Ride"] = 133.88, ["Neon"] = 34, ["Neon|Ride"] = 79.97, ["Neon|Fly|Ride"] = 141.35, ["Mega"] = 262.5, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 42.55, ["Ride"] = 13.79, ["Fly|Ride"] = 76.34, ["Neon"] = 2.1, ["Neon|Fly"] = 61.05, ["Neon|Ride"] = 15.65, ["Neon|Fly|Ride"] = 75.51, ["Mega"] = 14.91, ["Mega|Fly"] = 48.62, ["Mega|Ride"] = 28.93, ["Mega|Fly|Ride"] = 118.79}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 6.57, ["Fly"] = 54.63, ["Ride"] = 39.38, ["Fly|Ride"] = 106.32, ["Neon"] = 29.18, ["Neon|Fly"] = 121.53, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 224.96, ["Mega"] = 196.87, ["Mega|Ride"] = 208.59, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 309.14, ["Ride"] = 315, ["Fly|Ride"] = 388.5, ["Neon"] = 1312.5, ["Neon|Ride"] = 1246.88, ["Neon|Fly|Ride"] = 1252.12, ["Mega|Ride"] = 9430.04, ["Mega|Fly|Ride"] = 4692.99}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 90.95, ["Ride"] = 114.19, ["Fly|Ride"] = 284.82, ["Neon"] = 458.07, ["Neon|Ride"] = 391.13, ["Neon|Fly|Ride"] = 585.27, ["Mega"] = 2284.94, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1518.57}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 15.44, ["Fly|Ride"] = 34.16, ["Neon"] = 4.6, ["Neon|Fly"] = 27.88, ["Neon|Ride"] = 34.28, ["Neon|Fly|Ride"] = 64.07, ["Mega"] = 143.5, ["Mega|Fly"] = 213.08, ["Mega|Ride"] = 106.01, ["Mega|Fly|Ride"] = 233.89}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.26, ["Fly|Ride"] = 32.82, ["Neon"] = 6.43, ["Neon|Fly"] = 52.41, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 55.65, ["Mega"] = 65.54, ["Mega|Fly"] = 285.9, ["Mega|Ride"] = 81.43, ["Mega|Fly|Ride"] = 171.94}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.83, ["Fly"] = 100.67, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 65.63, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 285.9, ["Mega|Ride"] = 458.28, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 266.37, ["Ride"] = 252, ["Fly|Ride"] = 285.87, ["Neon"] = 1181.25, ["Neon|Ride"] = 1081.44, ["Neon|Fly|Ride"] = 1584.69, ["Mega|Ride"] = 8565.8, ["Mega|Fly|Ride"] = 3434.82}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 23.63, ["Ride"] = 16.45, ["Fly|Ride"] = 42.68, ["Neon"] = 15.75, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 89.95, ["Mega"] = 255.93, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 648.94}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.68, ["Fly"] = 324.48, ["Ride"] = 77.18, ["Fly|Ride"] = 210.33, ["Neon"] = 35.79, ["Neon|Ride"] = 42.72, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 253.32, ["Mega|Ride"] = 300.44, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 6.28, ["Neon|Ride"] = 155.92, ["Mega"] = 65.54, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 16.53, ["Fly"] = 48.62, ["Ride"] = 25.62, ["Fly|Ride"] = 76.23, ["Neon"] = 118.13, ["Neon|Ride"] = 99.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 460.69, ["Mega|Ride"] = 438.38, ["Mega|Fly|Ride"] = 576.19}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 43.31, ["Fly"] = 121.53, ["Ride"] = 78.44, ["Fly|Ride"] = 196.88, ["Neon"] = 154.2, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 393.75, ["Mega|Fly"] = 2248.53, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 578.87}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.34, ["Fly"] = 62.05, ["Ride"] = 39.37, ["Fly|Ride"] = 98.44, ["Neon"] = 157.4, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 198.19, ["Neon|Fly|Ride"] = 285.89, ["Mega"] = 856.59, ["Mega|Ride"] = 700.87, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.96, ["Ride"] = 14.95, ["Fly|Ride"] = 42.55, ["Neon"] = 2.1, ["Neon|Fly"] = 28.25, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 47.16, ["Mega"] = 16.7, ["Mega|Fly"] = 428.31, ["Mega|Ride"] = 33.43, ["Mega|Fly|Ride"] = 94.23}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 207.31, ["Fly"] = 262.49, ["Ride"] = 240.49, ["Fly|Ride"] = 364.06, ["Neon"] = 2349.65, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 997.92, ["Mega|Fly|Ride"] = 3999.16}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 12.44, ["Fly"] = 65.63, ["Ride"] = 49.42, ["Fly|Ride"] = 105, ["Neon"] = 98.44, ["Neon|Ride"] = 209.87, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 462, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 34, ["Ride"] = 18.38, ["Fly|Ride"] = 42.09, ["Neon"] = 7.77, ["Neon|Fly"] = 32.15, ["Neon|Ride"] = 27.35, ["Neon|Fly|Ride"] = 113.51, ["Mega"] = 58.62, ["Mega|Ride"] = 77.93, ["Mega|Fly|Ride"] = 158.48}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 16.14, ["Fly|Ride"] = 44.63, ["Neon"] = 2.61, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 21.89, ["Neon|Fly|Ride"] = 118.86, ["Mega"] = 24.31, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 62.61, ["Mega|Fly|Ride"] = 140.28}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 3.82, ["Ride"] = 28.74, ["Fly|Ride"] = 72.19, ["Neon"] = 12.92, ["Neon|Fly"] = 729.15, ["Neon|Ride"] = 49.88, ["Mega"] = 103.69, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 13.76, ["Fly"] = 38.74, ["Ride"] = 23.63, ["Fly|Ride"] = 64.32, ["Neon"] = 50.02, ["Neon|Fly"] = 271.98, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 115.6, ["Mega"] = 355.59, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 421.08}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.98, ["Ride"] = 57.84, ["Fly|Ride"] = 72.19, ["Neon"] = 54.03, ["Neon|Fly|Ride"] = 314.99, ["Mega"] = 253.32, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 41.89, ["Neon"] = 3.93, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 98.36, ["Mega"] = 61.6, ["Mega|Ride"] = 78.66, ["Mega|Fly|Ride"] = 319.09}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.33, ["Fly"] = 100.67, ["Ride"] = 26.81, ["Fly|Ride"] = 131.25, ["Neon"] = 29.58, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 46.39, ["Neon|Fly|Ride"] = 278.4, ["Mega"] = 254.85, ["Mega|Ride"] = 212.63, ["Mega|Fly|Ride"] = 291.67}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Fly"] = 71.76, ["Ride"] = 81.39, ["Neon"] = 3.94, ["Neon|Fly"] = 114.58, ["Neon|Ride"] = 45.78, ["Neon|Fly|Ride"] = 102.32, ["Mega"] = 24.91, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 107.09}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 44.52, ["Ride"] = 17.47, ["Fly|Ride"] = 39.85, ["Neon"] = 3.69, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 105.48, ["Mega"] = 54.5, ["Mega|Fly"] = 143.5, ["Mega|Ride"] = 80.06, ["Mega|Fly|Ride"] = 198.23}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.12, ["Ride"] = 702.19, ["Fly|Ride"] = 735, ["Neon"] = 2624.99, ["Neon|Fly|Ride"] = 3674.97, ["Mega|Fly|Ride"] = 12962.65}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 15.33, ["Fly|Ride"] = 42, ["Neon"] = 8.58, ["Neon|Fly"] = 140.9, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 74.97, ["Mega|Fly|Ride"] = 371.56}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 3.9, ["Ride"] = 45.93, ["Neon"] = 9.08, ["Neon|Fly"] = 749.52, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 55.1, ["Mega|Fly"] = 214.16, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 257.14}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.49, ["Fly"] = 40.66, ["Ride"] = 25.24, ["Fly|Ride"] = 51.97, ["Neon"] = 50.34, ["Neon|Fly"] = 193.27, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 87.44, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.44, ["Fly|Ride"] = 32.83, ["Neon"] = 6.38, ["Neon|Fly"] = 64.32, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 54.9, ["Mega"] = 55.13, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 85.22, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 28.88, ["Fly"] = 105, ["Ride"] = 56.8, ["Fly|Ride"] = 285.9, ["Neon"] = 111.99, ["Neon|Ride"] = 223.12, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 680.5, ["Mega|Ride"] = 714.18}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 17.07, ["Fly|Ride"] = 64.36, ["Neon"] = 6.2, ["Neon|Fly"] = 130.67, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 54.51, ["Mega|Ride"] = 125.28, ["Mega|Fly|Ride"] = 198.19}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.62, ["Fly"] = 32.83, ["Ride"] = 23.2, ["Fly|Ride"] = 64.26, ["Neon"] = 9.19, ["Neon|Ride"] = 41.89, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 95.82, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly|Ride"] = 78.75, ["Neon"] = 26.25, ["Mega"] = 97.12, ["Mega|Ride"] = 160.62, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.07, ["Fly|Ride"] = 49.95, ["Neon"] = 3.87, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 32.83, ["Mega|Fly"] = 225.11, ["Mega|Ride"] = 70.26, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.49, ["Fly"] = 20.96, ["Ride"] = 18.38, ["Fly|Ride"] = 36.75, ["Neon"] = 105, ["Neon|Ride"] = 80.85, ["Neon|Fly|Ride"] = 128.5, ["Mega|Ride"] = 468.99, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 734.99, ["Fly"] = 940.59, ["Ride"] = 700.88, ["Fly|Ride"] = 808.5, ["Neon"] = 1798.13, ["Neon|Ride"] = 2015.24, ["Neon|Fly|Ride"] = 1990.75, ["Mega"] = 4654.13, ["Mega|Ride"] = 6139.54, ["Mega|Fly|Ride"] = 6281.94}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.8, ["Fly|Ride"] = 37.68, ["Neon"] = 5.07, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.09, ["Mega"] = 51.19, ["Mega|Ride"] = 54.57, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.57, ["Ride"] = 32.81, ["Fly|Ride"] = 241.65, ["Neon"] = 18.38, ["Neon|Ride"] = 112.51, ["Neon|Fly|Ride"] = 208.68, ["Mega"] = 403.57, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 393.73}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.37, ["Fly"] = 104.9, ["Ride"] = 74.7, ["Fly|Ride"] = 105, ["Neon|Ride"] = 428.31, ["Neon|Fly|Ride"] = 421.32, ["Mega"] = 1713.17, ["Mega|Fly|Ride"] = 1523.89}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 27.57, ["Ride"] = 57.88, ["Fly|Ride"] = 104.9, ["Neon"] = 157.5, ["Neon|Ride"] = 224.87, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 1142.48, ["Mega|Ride"] = 896.44, ["Mega|Fly|Ride"] = 1098.58}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 9.98, ["Ride"] = 26.23, ["Fly|Ride"] = 143.5, ["Neon"] = 56.8, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 126.12, ["Mega"] = 283.03, ["Mega|Fly|Ride"] = 460.68}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 26.24, ["Ride"] = 57.14, ["Neon"] = 103.69, ["Neon|Ride"] = 328.46, ["Neon|Fly|Ride"] = 243.07, ["Mega"] = 236.25, ["Mega|Fly"] = 527.42, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 15.44, ["Fly|Ride"] = 158.47, ["Neon"] = 124.59, ["Neon|Ride"] = 171.33, ["Neon|Fly|Ride"] = 525, ["Mega"] = 924, ["Mega|Ride"] = 584.63, ["Mega|Fly|Ride"] = 571.78}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 16.88}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 6.97, ["Fly"] = 131248.69, ["Ride"] = 24.92, ["Fly|Ride"] = 72.82, ["Neon"] = 36.61, ["Neon|Ride"] = 42.09, ["Neon|Fly|Ride"] = 213.62, ["Mega"] = 196.27, ["Mega|Fly"] = 449.13, ["Mega|Ride"] = 227.26, ["Mega|Fly|Ride"] = 287.81}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.51, ["Ride"] = 28.93, ["Neon"] = 10.15, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 140.44, ["Mega|Fly|Ride"] = 486.1}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 59.07, ["Fly"] = 62.99, ["Ride"] = 52.27, ["Fly|Ride"] = 86.63, ["Neon"] = 200.82, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 714.18, ["Mega|Ride"] = 674.92, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 6.21, ["Fly"] = 17.9, ["Ride"] = 17.05, ["Fly|Ride"] = 44.57, ["Neon"] = 26.14, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 35.51, ["Neon|Fly|Ride"] = 73.41, ["Mega"] = 198.19, ["Mega|Fly"] = 427.24, ["Mega|Ride"] = 139.17, ["Mega|Fly|Ride"] = 233.42}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 8.43, ["Fly"] = 37.37, ["Ride"] = 26.25, ["Fly|Ride"] = 55.13, ["Neon"] = 19.69, ["Neon|Ride"] = 43.28, ["Neon|Fly|Ride"] = 123.97, ["Mega"] = 137.82, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 199.5}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.83, ["Mega"] = 38.98, ["Mega|Ride"] = 196.6, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 30.64, ["Fly"] = 77.96, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 186.33, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 310.53, ["Mega"] = 765.58, ["Mega|Ride"] = 854.31, ["Mega|Fly|Ride"] = 801.94}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 20.99, ["Fly|Ride"] = 65.63, ["Neon"] = 3.84, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.93, ["Mega"] = 72.19, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 461.9}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.29, ["Ride"] = 81.43, ["Fly|Ride"] = 284.83, ["Neon"] = 59.76, ["Neon|Ride"] = 77.97, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 399, ["Mega|Ride"] = 397.39, ["Mega|Fly|Ride"] = 714.18}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 15.06, ["Fly|Ride"] = 41.49, ["Neon"] = 93.35, ["Neon|Ride"] = 30.09, ["Neon|Fly|Ride"] = 76.67, ["Mega"] = 194.25, ["Mega|Ride"] = 208.04, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 4.88, ["Fly"] = 52.49, ["Ride"] = 22.61, ["Fly|Ride"] = 65.17, ["Neon"] = 40.69, ["Neon|Ride"] = 143.5, ["Mega"] = 291.38, ["Mega|Ride"] = 427.24, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 5.15, ["Ride"] = 67.48, ["Neon"] = 52.27, ["Neon|Ride"] = 227.06, ["Mega"] = 389.82, ["Mega|Ride"] = 972.18, ["Mega|Fly|Ride"] = 632.89}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 46.78, ["Ride"] = 131.25, ["Neon"] = 385.48, ["Neon|Ride"] = 393.74, ["Neon|Fly|Ride"] = 630, ["Mega"] = 1782.73, ["Mega|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 45.85, ["Ride"] = 94.5, ["Neon"] = 100.67, ["Neon|Ride"] = 183.75, ["Mega"] = 349.13, ["Mega|Ride"] = 368.34, ["Mega|Fly|Ride"] = 624.1}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 16.74, ["Ride"] = 125.98, ["Fly|Ride"] = 131.25, ["Neon"] = 63.39, ["Neon|Fly"] = 214.16, ["Neon|Ride"] = 428.31, ["Mega|Ride"] = 855.52}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 22.32, ["Ride"] = 69.57, ["Fly|Ride"] = 367.46, ["Neon"] = 81.43, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 610.71, ["Mega|Fly"] = 2141.46, ["Mega|Ride"] = 729.15, ["Mega|Fly|Ride"] = 731.8}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.63, ["Neon"] = 13.12, ["Neon|Ride"] = 48.62, ["Mega"] = 157.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 27.85, ["Ride"] = 14.21, ["Fly|Ride"] = 42.84, ["Neon"] = 5.25, ["Neon|Fly"] = 43.01, ["Neon|Ride"] = 31.98, ["Neon|Fly|Ride"] = 97.23, ["Mega"] = 66.7, ["Mega|Ride"] = 79.61, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 4.3, ["Fly"] = 45.94, ["Ride"] = 28.93, ["Fly|Ride"] = 69.57, ["Neon"] = 11.78, ["Neon|Ride"] = 53.12, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 87.93, ["Mega|Ride"] = 162.85, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.4, ["Ride"] = 15.75, ["Fly|Ride"] = 57.84, ["Neon"] = 3.93, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 107.62, ["Mega"] = 42.88, ["Mega|Fly"] = 114.58, ["Mega|Ride"] = 83.91, ["Mega|Fly|Ride"] = 201.96}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.94, ["Fly"] = 65.62, ["Ride"] = 23.57, ["Fly|Ride"] = 114.58, ["Neon"] = 18.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 322.8, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 4.18, ["Fly"] = 65.63, ["Ride"] = 19.69, ["Fly|Ride"] = 428.31, ["Neon"] = 28.09, ["Neon|Fly"] = 315, ["Neon|Ride"] = 78.75, ["Mega"] = 302.45, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1070.73}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 4.64, ["Fly"] = 131.25, ["Ride"] = 25.08, ["Fly|Ride"] = 45.68, ["Neon"] = 17.07, ["Neon|Fly"] = 114.58, ["Neon|Ride"] = 40.7, ["Neon|Fly|Ride"] = 99.03, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 283.74}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 3.49, ["Fly"] = 35.48, ["Ride"] = 17.97, ["Fly|Ride"] = 49.88, ["Neon"] = 15.65, ["Neon|Ride"] = 41.44, ["Neon|Fly|Ride"] = 107.09, ["Mega"] = 250.57, ["Mega|Ride"] = 186.33, ["Mega|Fly|Ride"] = 184.31}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.85, ["Fly"] = 57.75, ["Ride"] = 43.73, ["Fly|Ride"] = 91.86, ["Neon"] = 11.82, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 128.44, ["Mega"] = 111.64, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 132.56, ["Mega|Fly|Ride"] = 209.25}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 18.38, ["Fly"] = 214.16, ["Ride"] = 107.63, ["Fly|Ride"] = 242.81, ["Neon"] = 131.24, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 588, ["Mega|Ride"] = 540.54, ["Mega|Fly|Ride"] = 644.44}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 48.12, ["Fly"] = 164.07, ["Ride"] = 91.88, ["Fly|Ride"] = 170.63, ["Neon"] = 200.43, ["Neon|Ride"] = 256.49, ["Neon|Fly|Ride"] = 283.75, ["Mega"] = 1318.71, ["Mega|Ride"] = 1063.02, ["Mega|Fly|Ride"] = 1059.83}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 50.97, ["Ride"] = 18.36, ["Fly|Ride"] = 118.12, ["Neon"] = 2.63, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 26.99, ["Mega|Ride"] = 47.66, ["Mega|Fly|Ride"] = 143.92}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.07, ["Ride"] = 52.5, ["Neon"] = 285.9, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1067.53}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 47.95, ["Ride"] = 72.19, ["Fly|Ride"] = 183.75, ["Neon"] = 296.16, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 1753.85, ["Mega|Ride"] = 1617.88, ["Mega|Fly|Ride"] = 1348.05}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 5.27, ["Fly"] = 190.32, ["Ride"] = 28.64, ["Fly|Ride"] = 122.08, ["Neon"] = 38.75, ["Neon|Fly"] = 130.05, ["Neon|Ride"] = 70.87, ["Neon|Fly|Ride"] = 210, ["Mega"] = 191.01, ["Mega|Ride"] = 229.15, ["Mega|Fly|Ride"] = 454.5}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.54, ["Ride"] = 28.75, ["Neon"] = 12.64, ["Neon|Ride"] = 69.05, ["Neon|Fly|Ride"] = 140.28, ["Mega"] = 104.16, ["Mega|Ride"] = 162.85, ["Mega|Fly|Ride"] = 400.32}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 3.17, ["Fly"] = 25.5, ["Ride"] = 17.07, ["Fly|Ride"] = 38.98, ["Neon"] = 10.49, ["Neon|Ride"] = 37.02, ["Neon|Fly|Ride"] = 84, ["Mega"] = 158.48, ["Mega|Fly"] = 196.86, ["Mega|Ride"] = 318.41, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 16.75, ["Ride"] = 14.75, ["Fly|Ride"] = 31.5, ["Neon"] = 2.61, ["Neon|Fly"] = 29.61, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 48.62, ["Mega"] = 28.88, ["Mega|Ride"] = 69.56, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 15.23, ["Fly|Ride"] = 41.91, ["Neon"] = 3.93, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 38.57, ["Mega|Fly"] = 167.72, ["Mega|Ride"] = 56.44, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Neon"] = 2.61, ["Neon|Ride"] = 85.67, ["Mega"] = 26.25, ["Mega|Fly|Ride"] = 328.02}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.46, ["Ride"] = 157.5, ["Neon"] = 35.83, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 642.45, ["Mega"] = 183.01, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.14, ["Ride"] = 34.11, ["Fly|Ride"] = 207.82, ["Neon"] = 53.06, ["Neon|Ride"] = 100.67, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 223.13, ["Mega|Ride"] = 262.4, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.17, ["Fly"] = 23.62, ["Ride"] = 21, ["Fly|Ride"] = 45.94, ["Neon"] = 64.46, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 82.46, ["Mega|Ride"] = 222.86, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 59.07, ["Fly|Ride"] = 262.5, ["Neon"] = 472.5, ["Neon|Ride"] = 597.19, ["Mega"] = 2430.43, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 16.75, ["Fly"] = 82.69, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 118.13, ["Neon|Fly|Ride"] = 630, ["Mega"] = 635.92, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 714.18}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 26.76, ["Ride"] = 16.05, ["Fly|Ride"] = 38, ["Neon"] = 4.3, ["Neon|Fly"] = 36.42, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 59.97, ["Mega"] = 32.82, ["Mega|Ride"] = 90.65, ["Mega|Fly|Ride"] = 188.99}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 21.2, ["Ride"] = 14.44, ["Fly|Ride"] = 28.93, ["Neon"] = 3.67, ["Neon|Fly"] = 28.3, ["Neon|Ride"] = 19.46, ["Neon|Fly|Ride"] = 53.82, ["Mega"] = 39.38, ["Mega|Fly"] = 123.15, ["Mega|Ride"] = 57.37, ["Mega|Fly|Ride"] = 90.96}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 393.74, ["Ride"] = 446.24, ["Fly|Ride"] = 500.39, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Fly|Ride"] = 7852.69}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 7.87, ["Fly"] = 107.09, ["Ride"] = 45.94, ["Fly|Ride"] = 535.38, ["Neon"] = 39.25, ["Neon|Ride"] = 114.58, ["Neon|Fly|Ride"] = 156.35, ["Mega"] = 403.49, ["Mega|Ride"] = 400.32, ["Mega|Fly|Ride"] = 838.69}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.25, ["Ride"] = 14.04, ["Fly|Ride"] = 32.06, ["Neon"] = 6.44, ["Neon|Fly"] = 18.38, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 49.26, ["Mega|Ride"] = 77.84, ["Mega|Fly|Ride"] = 114.03}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 51.19, ["Ride"] = 93.92, ["Fly|Ride"] = 261.19, ["Neon"] = 224.03, ["Neon|Ride"] = 308.34, ["Neon|Fly|Ride"] = 367.26, ["Mega"] = 734.99, ["Mega|Ride"] = 761.24, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.63, ["Fly"] = 19.48, ["Ride"] = 15.74, ["Fly|Ride"] = 55.13, ["Neon"] = 11.82, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 50.34, ["Mega"] = 111.57, ["Mega|Fly"] = 214.16, ["Mega|Ride"] = 140.43, ["Mega|Fly|Ride"] = 203.34}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 21.44, ["Ride"] = 20.35, ["Neon"] = 3.34, ["Neon|Fly"] = 100.67, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 74.82, ["Mega"] = 17.45, ["Mega|Ride"] = 60.88, ["Mega|Fly|Ride"] = 190.88}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 35.32, ["Fly"] = 128.83, ["Ride"] = 78.71, ["Fly|Ride"] = 211.42, ["Neon"] = 160.13, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 830.82, ["Mega|Ride"] = 634.15, ["Mega|Fly|Ride"] = 717.94}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.97, ["Fly|Ride"] = 32.82, ["Neon"] = 5.92, ["Neon|Ride"] = 39.99, ["Neon|Fly|Ride"] = 79.25, ["Mega"] = 36.75, ["Mega|Ride"] = 149, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 36.75, ["Ride"] = 68.75, ["Fly|Ride"] = 120.75, ["Neon"] = 342.65, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1782.73, ["Mega|Ride"] = 1713.17, ["Mega|Fly|Ride"] = 1712.1}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.6, ["Fly"] = 71.76, ["Ride"] = 131.24, ["Fly|Ride"] = 162.77, ["Neon"] = 22.38, ["Neon|Ride"] = 230.9, ["Neon|Fly|Ride"] = 500.05, ["Mega"] = 170.63, ["Mega|Ride"] = 170.63}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Ride"] = 70.59, ["Fly|Ride"] = 70.49, ["Neon"] = 8.64, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 429.19, ["Mega"] = 91.16, ["Mega|Ride"] = 100.67, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 38.97, ["Fly"] = 143.5, ["Ride"] = 52.5, ["Fly|Ride"] = 535.38, ["Mega"] = 3211.11, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2000.13}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.5, ["Fly"] = 52.5, ["Ride"] = 27.57, ["Fly|Ride"] = 937.11, ["Neon"] = 4.65, ["Neon|Ride"] = 41.25, ["Neon|Fly|Ride"] = 159.21, ["Mega"] = 44.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 109.38, ["Mega|Fly|Ride"] = 226.96}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.95, ["Ride"] = 18, ["Fly|Ride"] = 65.63, ["Neon"] = 11.34, ["Neon|Fly"] = 48.62, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 62.12, ["Mega"] = 97.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.56, ["Fly"] = 57.91, ["Ride"] = 32.05, ["Fly|Ride"] = 77.11, ["Neon"] = 81.81, ["Neon|Ride"] = 79.24, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 328.12, ["Mega|Ride"] = 300.56, ["Mega|Fly|Ride"] = 337.83}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 7.87, ["Fly"] = 42.84, ["Ride"] = 27.57, ["Fly|Ride"] = 69.54, ["Neon"] = 52.5, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 749.52, ["Mega|Ride"] = 458.28, ["Mega|Fly|Ride"] = 536.18}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 21.32, ["Fly"] = 51.18, ["Ride"] = 26.25, ["Fly|Ride"] = 53.34, ["Neon"] = 70.88, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 120.77, ["Mega"] = 381.62, ["Mega|Ride"] = 298.86, ["Mega|Fly|Ride"] = 693.83}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 63, ["Fly"] = 136.5, ["Ride"] = 89.25, ["Fly|Ride"] = 252, ["Neon"] = 285.9, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 1496.88, ["Mega|Fly|Ride"] = 1309.88}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.24, ["Fly"] = 143.5, ["Ride"] = 65.39, ["Fly|Ride"] = 411.97, ["Neon"] = 54.68, ["Neon|Ride"] = 114.58, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 234.94, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 398.33}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 4.6, ["Ride"] = 26.88, ["Fly|Ride"] = 78.74, ["Neon"] = 18.27, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 162.9, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.36, ["Fly"] = 287.55, ["Ride"] = 28.45, ["Fly|Ride"] = 115.5, ["Neon"] = 65.63, ["Neon|Ride"] = 105, ["Mega"] = 454.5, ["Mega|Ride"] = 571.78, ["Mega|Fly|Ride"] = 728.11}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 14.44, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 21.69, ["Neon|Ride"] = 14.3, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 13.13, ["Mega|Ride"] = 33.21, ["Mega|Fly|Ride"] = 95.75}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.94, ["Ride"] = 112.56, ["Fly|Ride"] = 285.9, ["Neon"] = 236.24, ["Neon|Fly"] = 2427.35, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 488.15, ["Mega"] = 1069.67, ["Mega|Ride"] = 856.59, ["Mega|Fly|Ride"] = 1034.25}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 21.69, ["Fly|Ride"] = 143.5, ["Neon"] = 2.1, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.4, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 28.93, ["Ride"] = 16.69, ["Fly|Ride"] = 59.06, ["Neon"] = 10.49, ["Neon|Ride"] = 32.13, ["Neon|Fly|Ride"] = 89.13, ["Mega"] = 257.25, ["Mega|Ride"] = 192.94, ["Mega|Fly|Ride"] = 280.73}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 58.69, ["Ride"] = 76.77, ["Fly|Ride"] = 229.87, ["Neon"] = 294.46, ["Neon|Ride"] = 320.17, ["Mega"] = 931.33, ["Mega|Ride"] = 1177.8, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 25.26, ["Neon"] = 10.73, ["Neon|Ride"] = 27.85, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 58.47, ["Mega|Ride"] = 108.04, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 4.79}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 19.66, ["Fly|Ride"] = 489.97, ["Neon"] = 6.43, ["Neon|Ride"] = 31.49, ["Neon|Fly|Ride"] = 124.23, ["Mega"] = 42.88, ["Mega|Ride"] = 97.01, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 128.49, ["Ride"] = 162.93, ["Fly|Ride"] = 236.25, ["Neon"] = 836.07, ["Neon|Ride"] = 786.19, ["Neon|Fly|Ride"] = 917.44, ["Mega"] = 3426.32, ["Mega|Ride"] = 2506.88, ["Mega|Fly|Ride"] = 2751.25}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 32.82, ["Fly|Ride"] = 214.16, ["Neon"] = 19.59, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.39, ["Mega|Ride"] = 210.67, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 36.42, ["Neon"] = 3.93, ["Neon|Ride"] = 20.65, ["Mega"] = 28.84, ["Mega|Ride"] = 97.23, ["Mega|Fly|Ride"] = 315.88}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.94, ["Fly"] = 39.38, ["Ride"] = 21.54, ["Fly|Ride"] = 39.38, ["Neon"] = 52.01, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 162.84, ["Mega"] = 411.17, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 637.1}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 14.69, ["Fly"] = 40.58, ["Ride"] = 21.36, ["Fly|Ride"] = 56.57, ["Neon"] = 101.03, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 307.79, ["Mega"] = 613.59, ["Mega|Ride"] = 588, ["Mega|Fly|Ride"] = 405.9}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 21.53, ["Ride"] = 64.32, ["Fly|Ride"] = 158.48, ["Neon"] = 155.36, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 486.1, ["Mega"] = 560.44, ["Mega|Ride"] = 642.45, ["Mega|Fly|Ride"] = 598.49}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 129.93, ["Fly"] = 196.77, ["Ride"] = 150.94, ["Fly|Ride"] = 218.35, ["Neon"] = 565.13, ["Neon|Fly"] = 689.05, ["Neon|Ride"] = 571.78, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2407}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.55, ["Fly"] = 17.07, ["Ride"] = 21.04, ["Fly|Ride"] = 37.43, ["Neon"] = 39.38, ["Neon|Fly"] = 155.74, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 78.65, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 284.83}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.3, ["Fly"] = 131.23, ["Ride"] = 20.9, ["Fly|Ride"] = 129.93, ["Neon"] = 16.61, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 139.21, ["Mega|Ride"] = 211.32, ["Mega|Fly|Ride"] = 323.26}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.83, ["Fly"] = 98.44, ["Ride"] = 27.57, ["Fly|Ride"] = 91.87, ["Neon"] = 51.19, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 65.4, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 380.63, ["Mega|Ride"] = 433.13, ["Mega|Fly|Ride"] = 571.78}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 54.51, ["Fly"] = 100.67, ["Ride"] = 71.47, ["Fly|Ride"] = 223.13, ["Neon"] = 209.9, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 965.81, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1171.38}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 22.31, ["Ride"] = 63.25, ["Neon"] = 105, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 472.2, ["Mega"] = 688.96, ["Mega|Ride"] = 561.91}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 327.39, ["Ride"] = 615.57, ["Neon|Ride"] = 3240.98, ["Neon|Fly|Ride"] = 1713.17}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 39.11, ["Fly"] = 35.07, ["Ride"] = 32.61, ["Fly|Ride"] = 68.25, ["Neon"] = 226.37, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 324.48, ["Mega"] = 761.25, ["Mega|Ride"] = 721.16, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 38.99, ["Ride"] = 13.69, ["Fly|Ride"] = 35.44, ["Neon"] = 2.57, ["Neon|Ride"] = 17.83, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 20.29, ["Mega|Fly"] = 104.94, ["Mega|Ride"] = 37.68, ["Mega|Fly|Ride"] = 105.97}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.27, ["Neon"] = 8.87, ["Neon|Ride"] = 41.01, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 148.32, ["Mega|Ride"] = 107.01, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.57, ["Ride"] = 23.63, ["Fly|Ride"] = 144.21, ["Neon"] = 19.45, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 999.97, ["Mega"] = 115.4, ["Mega|Fly"] = 498.61, ["Mega|Ride"] = 129.93, ["Mega|Fly|Ride"] = 340.27}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 498.6, ["Ride"] = 406.88, ["Fly|Ride"] = 458.07, ["Neon"] = 1535.43, ["Neon|Ride"] = 2060.63, ["Neon|Fly|Ride"] = 1246.87, ["Mega|Fly|Ride"] = 5185.69}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.93, ["Fly"] = 21, ["Ride"] = 14.95, ["Fly|Ride"] = 44.63, ["Neon"] = 19.69, ["Neon|Ride"] = 47.65, ["Neon|Fly|Ride"] = 96.48, ["Mega"] = 183.44, ["Mega|Ride"] = 213.93, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.39, ["Fly"] = 19.99, ["Ride"] = 15.65, ["Fly|Ride"] = 32.82, ["Neon"] = 14.34, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 59.97, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 273.05, ["Mega|Fly|Ride"] = 321.23}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.38, ["Fly"] = 32.71, ["Ride"] = 21.27, ["Fly|Ride"] = 78.75, ["Neon"] = 10.39, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 37.49, ["Neon|Fly|Ride"] = 84, ["Mega"] = 111.56, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 26.25, ["Fly"] = 46.55, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 220.29, ["Neon|Ride"] = 192.75, ["Neon|Fly|Ride"] = 320.17, ["Mega"] = 1312.5, ["Mega|Ride"] = 855.52, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 34.12, ["Fly|Ride"] = 51.22, ["Neon"] = 9.18, ["Neon|Ride"] = 32.26, ["Neon|Fly|Ride"] = 210, ["Mega"] = 162.1, ["Mega|Ride"] = 457.8, ["Mega|Fly|Ride"] = 919.42}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 6.39, ["Fly"] = 65.59, ["Ride"] = 28.88, ["Fly|Ride"] = 91.87, ["Neon"] = 185.73, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 294.46, ["Mega|Fly|Ride"] = 846.57}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Neon"] = 3.66, ["Neon|Ride"] = 35.44, ["Mega"] = 54.39, ["Mega|Ride"] = 122.08, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 9.44, ["Neon"] = 39.38, ["Mega|Ride"] = 324.48, ["Mega|Fly|Ride"] = 699.57}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.03, ["Ride"] = 79.25, ["Neon"] = 86.59, ["Neon|Ride"] = 70.88, ["Mega"] = 315.88, ["Mega|Ride"] = 540.65, ["Mega|Fly|Ride"] = 509.25}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.65, ["Fly"] = 37.68, ["Ride"] = 23.89, ["Fly|Ride"] = 47.98, ["Neon"] = 46.99, ["Neon|Fly"] = 114.22, ["Neon|Ride"] = 52.74, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 571.17, ["Mega|Ride"] = 314.93, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 331.34, ["Fly"] = 590.77, ["Ride"] = 399.36, ["Fly|Ride"] = 420, ["Neon"] = 1642.41, ["Neon|Ride"] = 1573.51, ["Neon|Fly|Ride"] = 1670.34, ["Mega|Fly|Ride"] = 7424.41}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 15.54, ["Fly|Ride"] = 51.41, ["Neon"] = 15.65, ["Neon|Fly"] = 81.43, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 131.92, ["Mega"] = 214.16, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 305.04}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.25, ["Fly"] = 107.09, ["Ride"] = 45.02, ["Fly|Ride"] = 131.15, ["Neon"] = 60.11, ["Neon|Ride"] = 120.8, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 351.21, ["Mega|Fly"] = 714.18, ["Mega|Ride"] = 411.64, ["Mega|Fly|Ride"] = 504.32}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 23.62, ["Fly"] = 87.67, ["Ride"] = 83.91, ["Fly|Ride"] = 428.31, ["Neon"] = 76.13, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 422.63, ["Mega|Ride"] = 348.84, ["Mega|Fly|Ride"] = 506.76}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 64.99, ["Fly"] = 146.86, ["Ride"] = 96.38, ["Fly|Ride"] = 194.91, ["Neon"] = 320.25, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2492.09, ["Mega|Ride"] = 1892.83, ["Mega|Fly|Ride"] = 1536.32}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 24.63, ["Fly"] = 105.19, ["Ride"] = 44.63, ["Fly|Ride"] = 131.25, ["Neon"] = 42.84, ["Neon|Ride"] = 106.52, ["Neon|Fly|Ride"] = 169.19, ["Mega"] = 171.33, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 17.05, ["Ride"] = 17.07, ["Fly|Ride"] = 58.47, ["Neon"] = 12.91, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 126, ["Mega"] = 65.61, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.06, ["Ride"] = 40.49, ["Neon"] = 25.69, ["Neon|Ride"] = 100.67, ["Neon|Fly|Ride"] = 157.49, ["Mega"] = 176.77, ["Mega|Ride"] = 162.75}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 53.82, ["Fly"] = 137.82, ["Ride"] = 101.73, ["Fly|Ride"] = 216.57, ["Neon"] = 141.75, ["Neon|Ride"] = 141.09, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 439.69, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.32, ["Neon"] = 4.88, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 199.31, ["Mega"] = 48.57, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 414.39}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 20.74, ["Neon"] = 142.42, ["Neon|Ride"] = 401.03, ["Neon|Fly|Ride"] = 856.59, ["Mega"] = 553.04, ["Mega|Fly|Ride"] = 678.85}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 984.38, ["Fly"] = 1004.07, ["Ride"] = 1039.5, ["Fly|Ride"] = 1128.75, ["Neon"] = 3412.4, ["Neon|Ride"] = 3683.31, ["Neon|Fly|Ride"] = 3281.22, ["Mega|Fly|Ride"] = 10850.73}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 14.28, ["Fly"] = 54.63, ["Ride"] = 32.82, ["Fly|Ride"] = 143.5, ["Neon"] = 64.32, ["Neon|Fly"] = 707.44, ["Neon|Ride"] = 223.61, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 326.47, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 708.75}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 3.94, ["Fly"] = 49.37, ["Ride"] = 24.99, ["Fly|Ride"] = 83.44, ["Neon"] = 11.8, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 77.44, ["Mega|Ride"] = 126.36, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.26, ["Ride"] = 50.34, ["Fly|Ride"] = 143.5, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 393.73, ["Mega"] = 428.31, ["Mega|Ride"] = 541.96, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 20.35, ["Fly|Ride"] = 62.12, ["Neon"] = 2.56, ["Neon|Fly"] = 57.84, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 85.67, ["Mega"] = 15.75, ["Mega|Ride"] = 45.63, ["Mega|Fly|Ride"] = 176.54}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 64.94, ["Ride"] = 138.54, ["Fly|Ride"] = 236.24, ["Neon"] = 244.02, ["Neon|Ride"] = 282.97, ["Neon|Fly|Ride"] = 397.25, ["Mega"] = 899.07, ["Mega|Ride"] = 1017.19, ["Mega|Fly|Ride"] = 913.02}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 7.74, ["Ride"] = 61.69, ["Fly|Ride"] = 280.2, ["Neon"] = 81.38, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 561.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.87, ["Ride"] = 19.57, ["Neon"] = 8.91, ["Neon|Ride"] = 65.63, ["Mega"] = 89.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 472.2}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 42.4, ["Fly"] = 52.5, ["Ride"] = 28.93, ["Fly|Ride"] = 104.94, ["Neon"] = 61.69, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 140.91, ["Mega"] = 1039.49, ["Mega|Ride"] = 391.11, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.15, ["Fly"] = 33.21, ["Ride"] = 34.13, ["Fly|Ride"] = 81.43, ["Neon"] = 65.63, ["Neon|Ride"] = 77.84, ["Neon|Fly|Ride"] = 121.46, ["Mega"] = 428.31, ["Mega|Ride"] = 535.38, ["Mega|Fly|Ride"] = 509.69}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 63, ["Ride"] = 208.69, ["Neon"] = 232.45, ["Neon|Ride"] = 214.16, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2103.24, ["Mega|Ride"] = 1713.17, ["Mega|Fly|Ride"] = 1713.17}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 6.46, ["Ride"] = 48.56, ["Fly|Ride"] = 196.6, ["Neon"] = 21.44, ["Neon|Ride"] = 81.81, ["Neon|Fly|Ride"] = 209.99, ["Mega"] = 137.07, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 225.73}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 6.87, ["Ride"] = 19.69, ["Fly|Ride"] = 89.25, ["Neon"] = 33.79, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 116.73, ["Mega"] = 295.32, ["Mega|Ride"] = 351.75, ["Mega|Fly|Ride"] = 685.28}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 112.86, ["Fly"] = 393.75, ["Ride"] = 181.31, ["Fly|Ride"] = 257.25, ["Neon"] = 459.38, ["Neon|Ride"] = 448.17, ["Neon|Fly|Ride"] = 786.19, ["Mega|Fly|Ride"] = 1945.79}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.24, ["Fly"] = 24.42, ["Ride"] = 17.72, ["Fly|Ride"] = 55.04, ["Neon"] = 13.13, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 145.69, ["Mega|Ride"] = 229.15, ["Mega|Fly|Ride"] = 206.28}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 11.01, ["Fly"] = 200.81, ["Ride"] = 31.5, ["Fly|Ride"] = 114.85, ["Neon"] = 82.25, ["Neon|Ride"] = 90.96, ["Neon|Fly|Ride"] = 178.83, ["Mega"] = 452.82, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 501.21}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.37, ["Ride"] = 14.93, ["Fly|Ride"] = 52.4, ["Neon"] = 2.1, ["Neon|Fly"] = 27.09, ["Neon|Ride"] = 15, ["Neon|Fly|Ride"] = 39.63, ["Mega"] = 15.28, ["Mega|Fly"] = 39.38, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 68.86}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 57.84, ["Fly|Ride"] = 39.38, ["Neon"] = 2.6, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 132.79, ["Mega"] = 20.77, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 138.8}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.61, ["Fly"] = 36.42, ["Ride"] = 25.99, ["Fly|Ride"] = 133.88, ["Neon"] = 12.17, ["Neon|Ride"] = 55.55, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 84, ["Mega|Ride"] = 271.98, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.99, ["Fly|Ride"] = 131.25, ["Neon"] = 231, ["Neon|Ride"] = 342.65, ["Neon|Fly|Ride"] = 433.13, ["Mega"] = 481.26, ["Mega|Ride"] = 728.11, ["Mega|Fly|Ride"] = 1070.73}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 4.19, ["Fly"] = 18.78, ["Ride"] = 15.71, ["Fly|Ride"] = 35.44, ["Neon"] = 11.82, ["Neon|Fly"] = 32.12, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 54.65, ["Mega"] = 111.57, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 152.23}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.16, ["Fly"] = 26.25, ["Ride"] = 24.9, ["Fly|Ride"] = 88.26, ["Neon"] = 32.82, ["Neon|Fly"] = 55.76, ["Neon|Ride"] = 47.55, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 229.48, ["Mega|Fly"] = 433.13, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 298.45}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.81, ["Fly"] = 17.94, ["Ride"] = 18.09, ["Fly|Ride"] = 72.82, ["Neon"] = 8.58, ["Neon|Fly"] = 36.42, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 89.24, ["Mega"] = 80.32, ["Mega|Fly"] = 220.4, ["Mega|Ride"] = 64.26, ["Mega|Fly|Ride"] = 126.73}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.44, ["Fly"] = 161.69, ["Ride"] = 23, ["Fly|Ride"] = 217.19, ["Neon"] = 26.24, ["Neon|Ride"] = 79.8, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 261.74, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 383.35, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 7.33, ["Fly"] = 131.25, ["Ride"] = 157.5, ["Neon"] = 65.63, ["Neon|Ride"] = 262.4, ["Mega"] = 642.45, ["Mega|Fly|Ride"] = 1000.08}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.63, ["Fly"] = 22.83, ["Ride"] = 17.91, ["Fly|Ride"] = 48.47, ["Neon"] = 27.09, ["Neon|Fly"] = 196.76, ["Neon|Ride"] = 38.26, ["Neon|Fly|Ride"] = 104.68, ["Mega"] = 238.74, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 305.82, ["Mega|Fly|Ride"] = 484.32}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.85, ["Ride"] = 14.03, ["Fly|Ride"] = 36.47, ["Neon"] = 20.35, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 46.05, ["Mega"] = 187.39, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 291.67}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 190.31, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 392.44, ["Neon"] = 1070.73, ["Neon|Ride"] = 1270.97, ["Neon|Fly|Ride"] = 1174.69, ["Mega|Fly|Ride"] = 4122.57}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 4.92, ["Ride"] = 65.63, ["Neon"] = 35.44, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 428.31, ["Mega"] = 107.09, ["Mega|Ride"] = 648.94, ["Mega|Fly|Ride"] = 357.63}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.12, ["Fly"] = 104.9, ["Ride"] = 21, ["Fly|Ride"] = 84.14, ["Neon"] = 23.14, ["Neon|Fly"] = 243.07, ["Neon|Ride"] = 42.84, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 205.62, ["Mega|Ride"] = 194.9, ["Mega|Fly|Ride"] = 495.76}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 7.88, ["Fly|Ride"] = 212.89, ["Neon"] = 36.66, ["Neon|Ride"] = 227, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 596.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 416.72}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 15.96, ["Ride"] = 14.45, ["Fly|Ride"] = 30.61, ["Neon"] = 2.63, ["Neon|Fly"] = 28.88, ["Neon|Ride"] = 16.83, ["Neon|Fly|Ride"] = 39.37, ["Mega"] = 18.38, ["Mega|Fly"] = 79.25, ["Mega|Ride"] = 40.57, ["Mega|Fly|Ride"] = 88.61}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 4.73, ["Fly"] = 24.93, ["Ride"] = 16.68, ["Fly|Ride"] = 41.56, ["Neon"] = 11.45, ["Neon|Ride"] = 28.55, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 115.4, ["Mega|Ride"] = 128.62, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 143.5, ["Neon"] = 7.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 98.44, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 727.13}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 69.57, ["Fly"] = 105, ["Ride"] = 97.35, ["Fly|Ride"] = 175.23, ["Neon"] = 393.75, ["Neon|Ride"] = 384.02, ["Neon|Fly|Ride"] = 571.78, ["Mega|Ride"] = 3570.88, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 4.59, ["Fly"] = 94.5, ["Ride"] = 26.23, ["Fly|Ride"] = 98.6, ["Neon"] = 23.13, ["Neon|Ride"] = 66.27, ["Mega"] = 167.99, ["Mega|Ride"] = 229.5, ["Mega|Fly|Ride"] = 577.14}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.26, ["Ride"] = 33.78, ["Fly|Ride"] = 131.25, ["Neon"] = 5.1, ["Neon|Ride"] = 81.43, ["Neon|Fly|Ride"] = 535.86, ["Mega"] = 66.94, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 125.9, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 109.23, ["Fly|Ride"] = 183.75, ["Neon"] = 145.68, ["Neon|Ride"] = 200.81, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 523.69, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 601.13}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.09, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 16.68, ["Neon|Ride"] = 15.58, ["Neon|Fly|Ride"] = 32.15, ["Mega"] = 19.57, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 34.13, ["Mega|Fly|Ride"] = 93.05}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 107.09, ["Neon"] = 2.63, ["Neon|Ride"] = 44.99, ["Neon|Fly|Ride"] = 285.31, ["Mega"] = 26.25, ["Mega|Ride"] = 98.87, ["Mega|Fly|Ride"] = 175.88}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 44.63, ["Neon"] = 8.81, ["Neon|Ride"] = 89.95, ["Neon|Fly|Ride"] = 140.34, ["Mega"] = 63.47, ["Mega|Fly"] = 186.33, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 297.68}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 7.74, ["Fly"] = 79.25, ["Ride"] = 49.87, ["Fly|Ride"] = 51.41, ["Neon"] = 17.74, ["Neon|Fly"] = 91.55, ["Neon|Ride"] = 94.5, ["Neon|Fly|Ride"] = 140.44, ["Mega"] = 98.44, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 234.27, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 20.22, ["Ride"] = 13.13, ["Fly|Ride"] = 42.09, ["Neon"] = 2.1, ["Neon|Fly"] = 28.93, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 44.24, ["Mega"] = 18.04, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 117.48}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.83, ["Fly"] = 131.25, ["Ride"] = 65.63, ["Neon"] = 129.94, ["Neon|Fly"] = 428.31, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1312.5, ["Mega"] = 571.78, ["Mega|Ride"] = 567.52, ["Mega|Fly|Ride"] = 704.84}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2610.57, ["Fly"] = 3150, ["Ride"] = 2231.24, ["Fly|Ride"] = 2473.33, ["Neon"] = 10707.24, ["Neon|Fly|Ride"] = 9565.85, ["Mega|Fly|Ride"] = 42827.86}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 16.94, ["Ride"] = 15.64, ["Fly|Ride"] = 42.84, ["Neon"] = 6.56, ["Neon|Fly"] = 64.35, ["Neon|Ride"] = 23.82, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 72.19, ["Mega|Fly"] = 428.31, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 170.98}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Neon"] = 7.76, ["Mega"] = 107.01, ["Mega|Fly"] = 441, ["Mega|Ride"] = 159.87, ["Mega|Fly|Ride"] = 214.16}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 31.39, ["Fly"] = 42.84, ["Ride"] = 25.1, ["Fly|Ride"] = 121.53, ["Neon"] = 73.46, ["Neon|Ride"] = 114.57, ["Neon|Fly|Ride"] = 212.63, ["Mega"] = 393.75, ["Mega|Ride"] = 394.16, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.05, ["Fly"] = 88.88, ["Ride"] = 45.94, ["Neon"] = 161.44, ["Neon|Ride"] = 190.32, ["Mega"] = 701.32, ["Mega|Ride"] = 606.04, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 154.42, ["Fly"] = 243.07, ["Ride"] = 184.74, ["Fly|Ride"] = 249.38, ["Neon"] = 1312.5, ["Neon|Fly"] = 678.57, ["Neon|Ride"] = 714.65, ["Neon|Fly|Ride"] = 630, ["Mega"] = 6424.36, ["Mega|Fly|Ride"] = 3533.39}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.36, ["Ride"] = 31.5, ["Fly|Ride"] = 675.94, ["Neon"] = 19.68, ["Neon|Ride"] = 82.84, ["Neon|Fly|Ride"] = 158, ["Mega"] = 144.45, ["Mega|Fly"] = 13125, ["Mega|Ride"] = 227.26, ["Mega|Fly|Ride"] = 364.06}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.61, ["Ride"] = 35.44, ["Fly|Ride"] = 71.76, ["Neon"] = 24.31, ["Neon|Ride"] = 114.85, ["Mega"] = 245.44, ["Mega|Ride"] = 333.27, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.49, ["Fly"] = 100.04, ["Ride"] = 26.24, ["Fly|Ride"] = 131.25, ["Neon"] = 7.87, ["Neon|Fly"] = 79.25, ["Neon|Ride"] = 30.19, ["Mega"] = 72.19, ["Mega|Ride"] = 102.56, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 17.07, ["Ride"] = 59.07, ["Neon"] = 98.24, ["Neon|Ride"] = 1218.88, ["Neon|Fly|Ride"] = 504.32, ["Mega"] = 380.63, ["Mega|Ride"] = 428.31, ["Mega|Fly|Ride"] = 597.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.49, ["Neon|Ride"] = 48.62, ["Mega"] = 22.1, ["Mega|Fly"] = 121.53, ["Mega|Ride"] = 57.66, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 89.25, ["Fly"] = 105, ["Ride"] = 104.9, ["Fly|Ride"] = 158.48, ["Neon"] = 346.5, ["Neon|Fly"] = 428.31, ["Neon|Ride"] = 399.27, ["Neon|Fly|Ride"] = 330.88, ["Mega"] = 3212.19, ["Mega|Fly|Ride"] = 1677.01}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 21.44, ["Ride"] = 91.83, ["Neon"] = 4.11, ["Neon|Ride"] = 71.76, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 45.94, ["Mega|Ride"] = 281.54, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.52, ["Fly"] = 102.8, ["Ride"] = 74.72, ["Fly|Ride"] = 183.75, ["Neon"] = 285.9, ["Neon|Ride"] = 383.09, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 3575.06}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 20.96, ["Fly|Ride"] = 51.32, ["Neon"] = 3.94, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 37.68, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 210.25}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Fly|Ride"] = 104.01, ["Neon"] = 8.57, ["Neon|Ride"] = 98.44, ["Mega"] = 100.71, ["Mega|Ride"] = 143.07, ["Mega|Fly|Ride"] = 503.26}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 8.58, ["Fly"] = 77.43, ["Ride"] = 33.21, ["Neon"] = 28.93, ["Neon|Ride"] = 86.63, ["Mega"] = 318.72, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 567}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 334.69, ["Ride"] = 393.75, ["Fly|Ride"] = 499.38, ["Neon"] = 918.75, ["Neon|Ride"] = 964.67, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 3224.65, ["Mega|Ride"] = 2802.19, ["Mega|Fly|Ride"] = 3379.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.17, ["Fly"] = 85.67, ["Ride"] = 42, ["Fly|Ride"] = 107.57, ["Neon"] = 161.44, ["Neon|Ride"] = 169.19, ["Neon|Fly|Ride"] = 224.87, ["Mega"] = 1426.22, ["Mega|Ride"] = 1142.48, ["Mega|Fly|Ride"] = 1713.17}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 19.56, ["Fly|Ride"] = 85.67, ["Neon"] = 11.92, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 24.07, ["Neon|Fly|Ride"] = 98.34, ["Mega"] = 124.69, ["Mega|Ride"] = 175, ["Mega|Fly|Ride"] = 314.87}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 19.69, ["Fly"] = 39.38, ["Ride"] = 49.86, ["Fly|Ride"] = 170.63, ["Neon"] = 59.06, ["Neon|Fly"] = 162.85, ["Neon|Ride"] = 124.68, ["Neon|Fly|Ride"] = 183.54, ["Mega"] = 246.87, ["Mega|Fly"] = 1000.13, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.4, ["Fly"] = 57.84, ["Ride"] = 37.7, ["Fly|Ride"] = 196.88, ["Neon"] = 144.56, ["Neon|Ride"] = 112.25, ["Neon|Fly|Ride"] = 256.99, ["Mega"] = 428.31, ["Mega|Ride"] = 327.66, ["Mega|Fly|Ride"] = 425.81}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.99, ["Neon"] = 17.07, ["Mega"] = 80.99, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 282.69}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.55, ["Fly"] = 70.88, ["Ride"] = 20.74, ["Fly|Ride"] = 58.7, ["Neon"] = 32.05, ["Neon|Ride"] = 45.94, ["Mega"] = 111.57, ["Mega|Ride"] = 486.93, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 91.23, ["Ride"] = 125.99, ["Fly|Ride"] = 175.63, ["Neon"] = 799.84, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 568.52, ["Mega"] = 2887.5, ["Mega|Fly|Ride"] = 3212.19}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 23.24, ["Ride"] = 38.19, ["Fly|Ride"] = 124.69, ["Neon"] = 166.03, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 284.47, ["Mega"] = 571.78, ["Mega|Ride"] = 714.18, ["Mega|Fly|Ride"] = 571.78}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2030.44, ["Fly"] = 2030.44, ["Ride"] = 2040.02, ["Fly|Ride"] = 2231.25, ["Neon"] = 11421.41, ["Neon|Fly|Ride"] = 6954.94, ["Mega|Fly|Ride"] = 23622.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.16, ["Fly"] = 65625, ["Ride"] = 56.6, ["Fly|Ride"] = 196.87, ["Neon"] = 19.63, ["Neon|Ride"] = 58.52, ["Neon|Fly|Ride"] = 642.45, ["Mega"] = 111.03, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 171.94, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 10.61, ["Ride"] = 21, ["Fly|Ride"] = 111.07, ["Neon"] = 52.5, ["Neon|Ride"] = 112.88, ["Neon|Fly|Ride"] = 232.38, ["Mega"] = 136.98, ["Mega|Ride"] = 318.72, ["Mega|Fly|Ride"] = 324.48}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 944.9, ["Fly"] = 1107.73, ["Ride"] = 891.09, ["Fly|Ride"] = 976.38, ["Neon"] = 2778.57, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2487.19, ["Mega"] = 13705.27, ["Mega|Fly|Ride"] = 11670.89}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 24.94, ["Ride"] = 49.88, ["Fly|Ride"] = 173.35, ["Neon"] = 157.5, ["Neon|Ride"] = 154, ["Neon|Fly|Ride"] = 357.63, ["Mega"] = 839.9, ["Mega|Ride"] = 628.52, ["Mega|Fly|Ride"] = 668.07}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 124.23, ["Neon"] = 10.9, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 157.5, ["Mega|Ride"] = 319.09, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 143.5, ["Neon"] = 3.65, ["Neon|Ride"] = 48.55, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 19.69, ["Mega|Ride"] = 79.25, ["Mega|Fly|Ride"] = 285.9}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 107.09, ["Ride"] = 128.63, ["Fly|Ride"] = 170.63, ["Neon"] = 385.48, ["Neon|Ride"] = 454.5, ["Neon|Fly|Ride"] = 627.76, ["Mega"] = 2430.43, ["Mega|Fly|Ride"] = 2141.46}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 3.93, ["Ride"] = 36.75, ["Fly|Ride"] = 74.02, ["Neon"] = 16.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 114.58, ["Mega"] = 107.51, ["Mega|Ride"] = 120.94, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 58.47, ["Fly"] = 100.67, ["Ride"] = 126, ["Fly|Ride"] = 243.07, ["Neon"] = 459.38, ["Neon|Ride"] = 427.24, ["Mega"] = 1713.17, ["Mega|Fly|Ride"] = 1818.11}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 5.15, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 26.24, ["Neon|Ride"] = 214.16, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.5, ["Mega|Ride"] = 315.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 230.99, ["Fly"] = 354.38, ["Ride"] = 306.99, ["Fly|Ride"] = 322.88, ["Neon"] = 1000.08, ["Neon|Ride"] = 1064.63, ["Neon|Fly|Ride"] = 853.13, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.32, ["Fly"] = 91.88, ["Ride"] = 16.7, ["Fly|Ride"] = 48.57, ["Neon"] = 30.09, ["Neon|Ride"] = 57.66, ["Neon|Fly|Ride"] = 112.23, ["Mega|Ride"] = 318.94, ["Mega|Fly|Ride"] = 683.82}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 16.95, ["Fly|Ride"] = 32.82, ["Neon"] = 5.25, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 56.7, ["Mega"] = 40.43, ["Mega|Ride"] = 81.43, ["Mega|Fly|Ride"] = 125.98}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1255.71, ["Ride"] = 1050, ["Fly|Ride"] = 1254.19, ["Neon|Ride"] = 7852.69, ["Neon|Fly|Ride"] = 6710.23, ["Mega"] = 23818.13, ["Mega|Fly|Ride"] = 28487.82}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.07, ["Fly"] = 171.33, ["Ride"] = 72.19, ["Neon"] = 71.47, ["Neon|Ride"] = 308.64, ["Mega"] = 244.13, ["Mega|Ride"] = 530.01, ["Mega|Fly|Ride"] = 564.08}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.25, ["Fly"] = 39.38, ["Ride"] = 36.75, ["Fly|Ride"] = 99.17, ["Neon"] = 19.67, ["Neon|Fly"] = 46.05, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 196.88, ["Mega|Ride"] = 205.24, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 35.44, ["Fly"] = 51.34, ["Ride"] = 36.63, ["Fly|Ride"] = 81.65, ["Neon|Ride"] = 209.79, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 2569.75, ["Mega|Ride"] = 1135.02, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.44, ["Fly"] = 85.67, ["Ride"] = 27.56, ["Fly|Ride"] = 77.44, ["Neon"] = 52.5, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 93.18, ["Neon|Fly|Ride"] = 191.02, ["Mega"] = 367.4, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 45.85, ["Ride"] = 101.73, ["Fly|Ride"] = 417.6, ["Neon"] = 183.65, ["Neon|Ride"] = 498.98, ["Neon|Fly|Ride"] = 542.88, ["Mega"] = 856.59, ["Mega|Ride"] = 671.35, ["Mega|Fly|Ride"] = 700.26}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Fly|Ride"] = 285.9, ["Neon"] = 2.96, ["Neon|Ride"] = 112.2, ["Neon|Fly|Ride"] = 105.16, ["Mega"] = 15.75, ["Mega|Fly"] = 72.19, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 84.69, ["Fly"] = 121.53, ["Ride"] = 105.72, ["Fly|Ride"] = 176.99, ["Neon"] = 446.24, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 474.59, ["Mega"] = 3426.32, ["Mega|Fly|Ride"] = 1666.53}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 107.62, ["Ride"] = 19.69, ["Fly|Ride"] = 67.37, ["Neon"] = 85.67, ["Neon|Ride"] = 113.51, ["Neon|Fly|Ride"] = 171.33, ["Mega"] = 773.07, ["Mega|Ride"] = 432.48, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 28.93, ["Ride"] = 18.37, ["Fly|Ride"] = 39.35, ["Neon"] = 18.38, ["Neon|Fly"] = 81.43, ["Neon|Ride"] = 68.55, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 3.93, ["Ride"] = 126, ["Neon"] = 16.03, ["Neon|Fly"] = 141.35, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 203.44, ["Mega|Fly|Ride"] = 486.1}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 49.68, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 328.12, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 1606.11, ["Mega|Ride"] = 1471.19, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.08, ["Fly|Ride"] = 428.31, ["Neon"] = 25.35, ["Mega"] = 126.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 258.65}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Fly"] = 21.44, ["Ride"] = 36.66, ["Neon"] = 2.5, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 71.76, ["Mega"] = 21, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 393.65}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.94, ["Ride"] = 35.4, ["Fly|Ride"] = 136, ["Neon"] = 2.98, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 17.72, ["Mega|Ride"] = 61.68, ["Mega|Fly|Ride"] = 137.49}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 24.57, ["Ride"] = 16.03, ["Fly|Ride"] = 49.25, ["Neon"] = 5.25, ["Neon|Ride"] = 30.37, ["Neon|Fly|Ride"] = 87.94, ["Mega"] = 61.69, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 179.45}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 112.53, ["Neon"] = 24.94, ["Mega"] = 118.1, ["Mega|Ride"] = 106.29, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 38.06, ["Ride"] = 15.74, ["Fly|Ride"] = 32.85, ["Neon"] = 8.01, ["Neon|Fly"] = 210.29, ["Neon|Ride"] = 28.93, ["Neon|Fly|Ride"] = 100.67, ["Mega"] = 168.67, ["Mega|Ride"] = 162.85, ["Mega|Fly|Ride"] = 241.49}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 58.47, ["Ride"] = 101.72, ["Fly|Ride"] = 271.98, ["Neon"] = 210.31, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 1070.73, ["Mega"] = 656.25, ["Mega|Ride"] = 749.4, ["Mega|Fly|Ride"] = 1128.1}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 15.8, ["Ride"] = 19.69, ["Fly|Ride"] = 40.49, ["Neon"] = 2.52, ["Neon|Fly"] = 27.78, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 42.17, ["Mega"] = 27.57, ["Mega|Ride"] = 32.71, ["Mega|Fly|Ride"] = 109.04}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.49, ["Fly"] = 78.66, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 27.18, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 428.31, ["Mega|Ride"] = 236.15, ["Mega|Fly|Ride"] = 278.25}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 17.73, ["Fly"] = 28.88, ["Ride"] = 40.47, ["Fly|Ride"] = 104.98, ["Neon"] = 152.51, ["Neon|Fly"] = 171.33, ["Neon|Ride"] = 137.71, ["Neon|Fly|Ride"] = 182.96, ["Mega"] = 787.5, ["Mega|Ride"] = 783.79, ["Mega|Fly|Ride"] = 662.65}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 3.56, ["Fly"] = 196.88, ["Neon"] = 65.54, ["Neon|Ride"] = 71.76, ["Mega"] = 366.19, ["Mega|Ride"] = 324.48, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14.39, ["Fly|Ride"] = 32.82, ["Neon"] = 3.56, ["Neon|Fly"] = 24.64, ["Neon|Ride"] = 21.05, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 38.14, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 106.77}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.7, ["Fly"] = 77.83, ["Ride"] = 37.97, ["Neon"] = 26.25, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 112.53, ["Mega"] = 144.38, ["Mega|Fly"] = 735, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 444.36}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 968.01, ["Fly"] = 1378.07, ["Ride"] = 1039.5, ["Fly|Ride"] = 1036.88, ["Neon|Ride"] = 2421.56, ["Neon|Fly|Ride"] = 2425.94, ["Mega|Fly|Ride"] = 7199.07}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 123.44, ["Ride"] = 232.32, ["Fly|Ride"] = 357.63, ["Neon"] = 571.78, ["Neon|Ride"] = 599.62, ["Neon|Fly|Ride"] = 853.13, ["Mega"] = 3211.11, ["Mega|Ride"] = 2427.35, ["Mega|Fly|Ride"] = 2388.75}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly"] = 57.84, ["Ride"] = 39.38, ["Fly|Ride"] = 392.44, ["Neon"] = 7.17, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 208.81, ["Mega"] = 109.38, ["Mega|Fly|Ride"] = 1142.48}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 77.96, ["Ride"] = 158.82, ["Fly|Ride"] = 236.25, ["Neon"] = 392.43, ["Neon|Fly"] = 446.25, ["Neon|Ride"] = 433.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1964.42, ["Mega|Ride"] = 1797.17, ["Mega|Fly|Ride"] = 1706.15}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 5.25, ["Ride"] = 21.44, ["Neon"] = 17.53, ["Neon|Fly"] = 42.84, ["Neon|Ride"] = 52.67, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 118.13, ["Mega|Ride"] = 324.48, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 255.94, ["Fly"] = 301.88, ["Ride"] = 298.86, ["Fly|Ride"] = 353.07, ["Neon|Ride"] = 1299.87, ["Neon|Fly|Ride"] = 1296.64, ["Mega|Fly|Ride"] = 4854.68}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 41.77, ["Fly|Ride"] = 211.85, ["Neon"] = 31.5, ["Neon|Fly"] = 36.42, ["Neon|Ride"] = 54.37, ["Mega"] = 241.35, ["Mega|Fly"] = 334.07, ["Mega|Ride"] = 571.78}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.63, ["Fly"] = 28.93, ["Neon"] = 43.65, ["Mega"] = 131.25, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 41.33, ["Ride"] = 61.69, ["Fly|Ride"] = 151.5, ["Neon"] = 114.09, ["Neon|Fly"] = 428.31, ["Neon|Ride"] = 124.69, ["Mega"] = 453.69, ["Mega|Ride"] = 593.72, ["Mega|Fly|Ride"] = 874.96}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.63, ["Ride"] = 49.74, ["Fly|Ride"] = 285.9, ["Neon"] = 20.79, ["Neon|Ride"] = 196.87, ["Mega"] = 243.06, ["Mega|Ride"] = 253.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 15.11, ["Ride"] = 13.85, ["Fly|Ride"] = 28.93, ["Neon"] = 2.44, ["Neon|Fly"] = 28.85, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 35, ["Mega"] = 28.87, ["Mega|Ride"] = 35.78, ["Mega|Fly|Ride"] = 100.87}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4672.5, ["Ride"] = 5118.75, ["Fly|Ride"] = 4698.75, ["Neon"] = 32121.7, ["Neon|Fly|Ride"] = 18559.92, ["Mega|Fly|Ride"] = 162028.81}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 13.02, ["Fly"] = 85.67, ["Ride"] = 55.86, ["Neon"] = 53.44, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 110.31, ["Mega"] = 192.94, ["Mega|Ride"] = 214.45, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.69, ["Ride"] = 16.91, ["Fly|Ride"] = 42, ["Neon"] = 11.82, ["Neon|Fly"] = 45.91, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 131.25, ["Mega|Ride"] = 175.88, ["Mega|Fly|Ride"] = 180.86}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 437.07, ["Fly"] = 547.77, ["Ride"] = 500.05, ["Fly|Ride"] = 589.32, ["Neon"] = 1612.22, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1274.91, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.63, ["Ride"] = 15.75, ["Neon"] = 22.31, ["Neon|Ride"] = 291.38, ["Mega"] = 179.87, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.84, ["Fly"] = 4281.84, ["Ride"] = 36.75, ["Neon"] = 37.68, ["Neon|Fly"] = 118.86, ["Neon|Ride"] = 51.06, ["Neon|Fly|Ride"] = 307.32, ["Mega"] = 427.24, ["Mega|Ride"] = 401.63, ["Mega|Fly|Ride"] = 419.35}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 17.75, ["Neon"] = 3.19, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 28.19, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 37.94, ["Mega|Ride"] = 100.67, ["Mega|Fly|Ride"] = 205.59}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 656.24, ["Ride"] = 727.65, ["Fly|Ride"] = 689.07, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9279.98}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 10.43, ["Ride"] = 56.9, ["Fly|Ride"] = 428.31, ["Neon"] = 37.97, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 285.9, ["Mega"] = 175.41, ["Mega|Ride"] = 229.67, ["Mega|Fly|Ride"] = 415.96}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 3.69, ["Fly"] = 236.15, ["Ride"] = 34.54, ["Fly|Ride"] = 76.85, ["Neon"] = 22.45, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 360.94, ["Mega|Fly"] = 810.55, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 4.05, ["Fly"] = 34.12, ["Ride"] = 17.51, ["Fly|Ride"] = 59.97, ["Neon"] = 12.08, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 81.37, ["Mega"] = 183.02, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 227.15}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 18.36, ["Ride"] = 34.12, ["Fly|Ride"] = 55.59, ["Neon"] = 117.5, ["Neon|Fly|Ride"] = 321.23, ["Mega"] = 855.52, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 856.59}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 42.87, ["Fly|Ride"] = 428.31, ["Neon"] = 6.34, ["Neon|Ride"] = 45.05, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 33.08, ["Mega|Fly"] = 57.84, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 519.75, ["Ride"] = 538.12, ["Fly|Ride"] = 616.88, ["Neon"] = 2589.57, ["Neon|Ride"] = 2608.3, ["Neon|Fly|Ride"] = 2343.78, ["Mega|Ride"] = 9478.66, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Fly"] = 107.09, ["Ride"] = 83.53, ["Neon"] = 15.22, ["Neon|Ride"] = 93.09, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 77.44, ["Mega|Ride"] = 162.85, ["Mega|Fly|Ride"] = 342.65}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 33.65, ["Neon"] = 5.25, ["Neon|Fly"] = 143.5, ["Neon|Ride"] = 214.81, ["Neon|Fly|Ride"] = 214.16, ["Mega"] = 42.51, ["Mega|Ride"] = 143.5, ["Mega|Fly|Ride"] = 283.49}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 41.66, ["Neon"] = 3.93, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 143.5, ["Mega"] = 42.41, ["Mega|Fly"] = 158.48, ["Mega|Ride"] = 111.46, ["Mega|Fly|Ride"] = 145.68}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 26.25, ["Neon"] = 13.02, ["Neon|Ride"] = 48.18, ["Mega"] = 214.16, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 26.15, ["Fly"] = 64.32, ["Ride"] = 49.8, ["Fly|Ride"] = 103.95, ["Neon"] = 98.44, ["Neon|Fly"] = 214.16, ["Neon|Ride"] = 139.21, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 601.55, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 556.36}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.19, ["Fly"] = 39.38, ["Ride"] = 59.07, ["Fly|Ride"] = 93.17, ["Neon"] = 84, ["Neon|Ride"] = 145.84, ["Neon|Fly|Ride"] = 236.15, ["Mega"] = 381.84, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 560.81}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 15.22, ["Fly|Ride"] = 32.46, ["Neon"] = 21.88, ["Neon|Fly"] = 71.76, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 88.01, ["Mega"] = 213.89, ["Mega|Ride"] = 285.9, ["Mega|Fly|Ride"] = 255.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 7.74, ["Ride"] = 56.04, ["Fly|Ride"] = 134.92, ["Neon"] = 28.93, ["Neon|Ride"] = 141.35, ["Mega|Ride"] = 744.17}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 196.88, ["Ride"] = 19.59, ["Fly|Ride"] = 87.05, ["Neon"] = 9.33, ["Neon|Ride"] = 49.33, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.32, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.62, ["Fly"] = 114.26, ["Ride"] = 26.24, ["Fly|Ride"] = 57.48, ["Neon"] = 207.89, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 158.48, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 841.32}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 32.7, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega"] = 328.13, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 492.85}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 45.47, ["Fly"] = 153.58, ["Ride"] = 85.32, ["Fly|Ride"] = 124.69, ["Neon"] = 321.59, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 406.89, ["Mega|Ride"] = 1718.32, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 36.75, ["Fly"] = 139.77, ["Ride"] = 76.73, ["Fly|Ride"] = 213.08, ["Neon"] = 143.42, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 535.5, ["Mega|Ride"] = 685.28, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 25.59, ["Ride"] = 57.5, ["Neon"] = 114.27, ["Neon|Ride"] = 223.12, ["Mega"] = 1050, ["Mega|Ride"] = 785.92, ["Mega|Fly|Ride"] = 807.19}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 22.31, ["Fly"] = 428.3, ["Ride"] = 52.5, ["Fly|Ride"] = 194.15, ["Neon"] = 136.43, ["Neon|Fly"] = 420, ["Neon|Ride"] = 143.5, ["Neon|Fly|Ride"] = 321.57, ["Mega"] = 455.12, ["Mega|Ride"] = 563.93, ["Mega|Fly|Ride"] = 641.21}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.91, ["Ride"] = 15.65, ["Fly|Ride"] = 32.73, ["Neon"] = 3.93, ["Neon|Fly"] = 26.8, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 53.65, ["Mega"] = 36.39, ["Mega|Fly"] = 63, ["Mega|Ride"] = 57.7, ["Mega|Fly|Ride"] = 118.79}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 866.24}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 54.48, ["Fly"] = 486.1, ["Ride"] = 97.13, ["Fly|Ride"] = 157.5, ["Neon"] = 343.29, ["Neon|Ride"] = 458.07, ["Neon|Fly|Ride"] = 487.61, ["Mega"] = 1278.46, ["Mega|Ride"] = 1506.75, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 79.74, ["Neon"] = 2.63, ["Neon|Fly"] = 100.67, ["Neon|Ride"] = 43.2, ["Neon|Fly|Ride"] = 298.04, ["Mega"] = 26.25, ["Mega|Ride"] = 84.95, ["Mega|Fly|Ride"] = 162.85}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 22.91, ["Ride"] = 70.48, ["Fly|Ride"] = 113.98, ["Neon"] = 105, ["Neon|Ride"] = 133.86, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 524.99, ["Mega|Ride"] = 493.4, ["Mega|Fly|Ride"] = 706.69}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 24.69}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 23.55, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.44, ["Fly"] = 223.13, ["Ride"] = 145.84, ["Fly|Ride"] = 364.58, ["Neon"] = 437.07, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 668.42, ["Mega|Ride"] = 2132.71, ["Mega|Fly|Ride"] = 2049.37}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.53, ["Fly|Ride"] = 97.23, ["Neon"] = 6.46, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 90.17, ["Mega|Ride"] = 115.63, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Fly|Ride"] = 53.27, ["Neon"] = 5.24, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 140.84, ["Mega"] = 30.42, ["Mega|Ride"] = 126.19, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 53.82, ["Neon"] = 4.19, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.14, ["Mega"] = 77.44, ["Mega|Ride"] = 163.13, ["Mega|Fly|Ride"] = 428.31}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 83.35, ["Neon"] = 6.28, ["Neon|Ride"] = 155.92, ["Mega"] = 65.54, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 64.86, ["Ride"] = 124.69, ["Fly|Ride"] = 486.1, ["Neon"] = 424.07, ["Neon|Ride"] = 519.75, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 1606.11, ["Mega|Fly|Ride"] = 1606.11}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 5.15, ["Ride"] = 67.48, ["Neon"] = 52.27, ["Neon|Ride"] = 227.06, ["Mega"] = 389.82, ["Mega|Ride"] = 972.18, ["Mega|Fly|Ride"] = 632.89}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 380.63, ["Ride"] = 389.15, ["Fly|Ride"] = 520.13, ["Neon"] = 1365, ["Neon|Ride"] = 1428.36, ["Neon|Fly|Ride"] = 1076.25, ["Mega"] = 3570.88, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 90.45}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 49.88}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.05}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 15.73}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 143.09}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.79}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.9}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 8.4}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 236.25}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 37.78}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 48.57}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.09}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 577.49}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 5.07}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 5.71}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 2.5}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 10.5}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 13.13}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 577.5}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 713.12}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.12}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1246.88}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 70.03}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 8.98}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 33.34}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 3.93}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 15.36}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 32.82}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 48.57}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 16.93}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.84}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.06}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 3.62}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 14.34}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 3.6}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 3.94}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 196.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 147.77}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 7.3}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 4.77}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2783.9}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 33.65}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 307.93}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 7.66}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 10.14}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 8.47}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 112.88}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.77}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 243.07}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 33.37}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 12.99}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.35}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 73.89}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 30.66}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 4.39}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 179.87}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 104.99}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.24}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.67}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.62}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.75}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 42.71}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 92.97}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 229.69}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 3.92}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 9.19}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 78.69}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 19.49}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 23147.34}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 164.07}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 41.5}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 71.76}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.55}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 32.45}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 27.03}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 38.98}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 83.91}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.29}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 77.11}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 76.04}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 200.33}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 45.94}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 37.14}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 213.93}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 15.65}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.49}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.82}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 12.87}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 52.41}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 127.08}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.84}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 8.58}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.5}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.88}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 14.26}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 270.13}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 1127.44}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 11.71}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 583.68}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 15.26}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.62}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.63}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 27.57}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 115.5}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 16.88}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 26.25}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 44.37}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 5.24}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 8.71}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.24}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.57}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 4.88}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 31.5}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 5.43}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 3.94}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 8.58}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 26.25}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 177.18}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.06}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 186.33}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 9.09}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 9.51}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 6.57}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 38.99}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 7.88}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.72}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 11.8}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 17.53}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 15.78}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.28}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 32.82}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 5.46}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 13.13}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.24}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 3.94}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.49}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.2}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 6.46}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 7.16}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.52}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 4.13}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.73}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 8265.64}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 33.34}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.2}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 8.97}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 6.56}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.39}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 31.11}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.71}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 4.13}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 7.67}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 5.07}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 39.38}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 13.15}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.89}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 7.88}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.83}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.12}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 4496.29}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.4}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 32.45}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 4.3}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.59}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.55}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 32.82}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 104.98}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 15.74}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.94}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 7.88}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.35}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 26.24}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.24}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 9.18}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 3.8}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 3.82}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.37}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 6.56}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.15}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 23.15}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.61}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 11.12}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 264.48}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.66}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 72.58}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 5.08}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 4.71}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1201.4}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 52.5}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 3.93}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 5.24}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 30.19}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 27.15}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 11.68}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 7.87}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.76}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 14.21}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 15.75}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 19.98}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.22}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.63}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.92}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 19.69}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 10.12}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.63}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 22.91}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.91}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.68}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 19.99}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 59.76}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 3.9}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 16.68}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 89.63}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 8.28}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 8.58}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 81.38}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 36.71}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.62}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.13}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.94}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.94}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.04}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.68}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 79.11}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 155.93}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 9.19}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1187.82}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 3.76}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 208.69}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 9.08}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 6.17}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 51.98}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 9.08}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.44}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 74.82}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.38}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 16.89}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.15}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 39.38}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.47}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 59.06}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 3.84}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 57.75}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 4.3}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 3.94}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.62}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.3}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 4.91}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 29.63}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 128}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 6.44}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.45}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 80.17}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.41}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 8.66}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 7.34}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 58.28}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.52}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 67.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.6}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 256.99}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.7}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 65.58}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 4.13}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 124.59}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.73}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 3.82}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 9.45}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 35.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 54.91}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 61.68}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 4.13}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 7.46}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 100.67}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 13}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 74.46}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 34.55}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 23.63}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 55.69}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 53.82}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 6.49}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 26.09}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 12.86}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 75.39}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.62}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 39.85}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 40.68}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 10.49}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 19.65}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 321.57}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 23.57}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.19}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 33.21}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 10.39}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 314.9}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 56.6}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 51.18}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 5.24}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 62.9}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 228.38}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 73.5}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 918.75}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 210}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 15.63}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2361.19}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 551.23}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.33}},
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