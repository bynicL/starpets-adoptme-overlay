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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 983.07, ["Ride"] = 1179.91, ["Fly|Ride"] = 1690.5, ["Neon"] = 6869.49, ["Neon|Ride"] = 9187.5, ["Neon|Fly|Ride"] = 5070.56, ["Mega"] = 21679.44}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 536.26, ["Ride"] = 516.11, ["Fly|Ride"] = 647.15, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 8124.26}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 5250, ["Fly|Ride"] = 4698.74, ["Neon|Fly|Ride"] = 17718.75, ["Mega|Fly|Ride"] = 72270.43}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 210, ["Fly"] = 236.25, ["Ride"] = 285.13, ["Fly|Ride"] = 289.47, ["Neon"] = 1145.74, ["Neon|Ride"] = 1156.61, ["Neon|Fly|Ride"] = 905.63, ["Mega|Fly|Ride"] = 4900.14}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 867.29, ["Ride"] = 558.9, ["Fly|Ride"] = 616.81, ["Neon|Fly|Ride"] = 1922.7, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 13.49, ["Ride"] = 59.06, ["Fly|Ride"] = 129.94, ["Neon"] = 80.67, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 606.03}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 4.76, ["Fly"] = 58.5, ["Ride"] = 32.05, ["Fly|Ride"] = 73.49, ["Neon"] = 56.39, ["Neon|Fly"] = 132.57, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 112.76, ["Mega"] = 185.05, ["Mega|Ride"] = 216.56, ["Mega|Fly|Ride"] = 414.6}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 114.19, ["Ride"] = 141.75, ["Fly|Ride"] = 185.87, ["Neon"] = 572.88, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2168.21}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 38.06, ["Fly"] = 97.76, ["Ride"] = 46.19, ["Fly|Ride"] = 103.49, ["Neon"] = 275.62, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1214.07, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 19.63, ["Fly"] = 49.08, ["Ride"] = 29.52, ["Fly|Ride"] = 70.88, ["Neon"] = 154.35, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 650.4, ["Mega|Fly|Ride"] = 866.21}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 74.82, ["Fly"] = 216.57, ["Ride"] = 105, ["Fly|Ride"] = 195.57, ["Neon"] = 326.82, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 414.37, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.19}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Fly"] = 399, ["Ride"] = 353.75, ["Fly|Ride"] = 367.5, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 5189.6}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.41, ["Fly"] = 171.3, ["Ride"] = 135.19, ["Fly|Ride"] = 177.18, ["Neon|Fly"] = 686.88, ["Neon|Ride"] = 573.03, ["Neon|Fly|Ride"] = 536.82, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.75, ["Fly"] = 79.03, ["Ride"] = 65.06, ["Fly|Ride"] = 131.25, ["Neon"] = 23.14, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 325.2, ["Mega|Fly|Ride"] = 375.84}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 210, ["Fly"] = 284.82, ["Ride"] = 233.63, ["Fly|Ride"] = 272.56, ["Neon|Ride"] = 1400.74, ["Neon|Fly|Ride"] = 735, ["Mega|Fly|Ride"] = 2749.69}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.63, ["Fly"] = 26.88, ["Ride"] = 21, ["Fly|Ride"] = 40.31, ["Neon"] = 22.32, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 58.26, ["Neon|Fly|Ride"] = 77.18, ["Mega"] = 164.07, ["Mega|Ride"] = 309.1, ["Mega|Fly|Ride"] = 381.42}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 130.39, ["Fly"] = 289.47, ["Ride"] = 160.13, ["Fly|Ride"] = 324.22, ["Neon"] = 468.35, ["Neon|Ride"] = 480.53, ["Neon|Fly|Ride"] = 570.94, ["Mega"] = 1799.37, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1777.73}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 37.3}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 80.99, ["Ride"] = 131.25, ["Fly|Ride"] = 244.36, ["Neon"] = 419.56, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1472.05}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 31.4, ["Fly"] = 58.56, ["Ride"] = 54.24, ["Fly|Ride"] = 433.65, ["Neon"] = 262.5, ["Neon|Ride"] = 351.02, ["Neon|Fly|Ride"] = 355.56, ["Mega"] = 1009.32, ["Mega|Ride"] = 1065.56, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 33.13, ["Fly"] = 110.59, ["Ride"] = 62.99, ["Fly|Ride"] = 114.09, ["Neon"] = 216.56, ["Neon|Ride"] = 195.56, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 1717.19, ["Mega|Fly|Ride"] = 892.03}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 46.81, ["Fly"] = 247.11, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 160.47, ["Neon|Ride"] = 380.02, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1967.44, ["Mega|Ride"] = 1734.36, ["Mega|Fly|Ride"] = 1560.04}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 35.44, ["Ride"] = 46.04, ["Fly|Ride"] = 110.59, ["Neon"] = 210, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 260.16, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 36.39, ["Fly"] = 145.28, ["Ride"] = 72.97, ["Fly|Ride"] = 129.94, ["Neon"] = 236.25, ["Neon|Fly"] = 409.68, ["Neon|Ride"] = 229.23, ["Neon|Fly|Ride"] = 322.88, ["Mega|Ride"] = 1145.62, ["Mega|Fly|Ride"] = 1040.75}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.23, ["Fly"] = 34.05, ["Ride"] = 29.25, ["Fly|Ride"] = 61.06, ["Neon"] = 45.94, ["Neon|Fly"] = 272.99, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 101.03, ["Mega"] = 157.49, ["Mega|Fly"] = 26016.46, ["Mega|Ride"] = 225.74, ["Mega|Fly|Ride"] = 301.86}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 395.17, ["Ride"] = 415.8, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 9732.59}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 16.28, ["Ride"] = 32.82, ["Fly|Ride"] = 118.13, ["Neon"] = 219.18, ["Mega|Ride"] = 823.83, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 5.08, ["Fly"] = 43.32, ["Ride"] = 24.81, ["Fly|Ride"] = 45.94, ["Neon"] = 63, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 104.97, ["Mega|Ride"] = 332.79, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 86.91, ["Fly"] = 119.6, ["Ride"] = 77.44, ["Fly|Ride"] = 114.93, ["Neon"] = 266.37, ["Neon|Fly"] = 392.56, ["Neon|Ride"] = 361.85, ["Neon|Fly|Ride"] = 400.59, ["Mega"] = 6499.48, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 14.34, ["Fly"] = 26.25, ["Ride"] = 36.66, ["Fly|Ride"] = 77.31, ["Neon"] = 77.44, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 260.16, ["Mega"] = 720.57, ["Mega|Ride"] = 735.95, ["Mega|Fly|Ride"] = 540.99}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 223.13, ["Fly"] = 288.75, ["Ride"] = 250.68, ["Fly|Ride"] = 331.44, ["Neon"] = 650.48, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 688.33, ["Mega"] = 3467.64, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3002.96}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 23.67}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.44, ["Fly"] = 26.25, ["Ride"] = 24.93, ["Fly|Ride"] = 67.17, ["Neon"] = 22.32, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 196.88, ["Mega|Fly"] = 488.5, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 787.5, ["Fly"] = 2625, ["Ride"] = 840, ["Fly|Ride"] = 905.63, ["Neon"] = 5059.5, ["Neon|Ride"] = 5492.5, ["Neon|Fly|Ride"] = 5058.92, ["Mega|Ride"] = 55194.63, ["Mega|Fly|Ride"] = 18791.8}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 13.13, ["Fly"] = 55.4, ["Ride"] = 51.94, ["Fly|Ride"] = 106.25, ["Neon"] = 188.65, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 214.65, ["Mega"] = 1036.88, ["Mega|Ride"] = 1113.26, ["Mega|Fly|Ride"] = 1145.74}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.75, ["Fly"] = 368.02, ["Ride"] = 236.22, ["Fly|Ride"] = 328.13, ["Neon"] = 917.44, ["Neon|Ride"] = 892.5, ["Neon|Fly|Ride"] = 1030.31, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 44.29}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.2, ["Fly"] = 144.65, ["Ride"] = 72.65, ["Fly|Ride"] = 145.28, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 409.68, ["Mega|Ride"] = 576.13, ["Mega|Fly|Ride"] = 607.23}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.16}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 91.77, ["Fly"] = 162.24, ["Ride"] = 131.25, ["Fly|Ride"] = 219.19, ["Neon"] = 650.48, ["Neon|Ride"] = 404.25, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 2383.67, ["Mega|Ride"] = 2291.21, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 99.65, ["Fly"] = 157.49, ["Ride"] = 157.5, ["Fly|Ride"] = 238.16, ["Neon"] = 374.1, ["Neon|Fly"] = 578.92, ["Neon|Ride"] = 409.78, ["Neon|Fly|Ride"] = 497.43, ["Mega"] = 1625.97, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1522.34}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 35.32}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.38, ["Fly"] = 79.9, ["Ride"] = 55.11, ["Fly|Ride"] = 84, ["Neon|Ride"] = 397.83, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 4335.9, ["Mega|Fly|Ride"] = 1539.18}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.18, ["Fly"] = 101.92, ["Ride"] = 49.85, ["Fly|Ride"] = 157.5, ["Neon"] = 43.38, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 93.19, ["Neon|Fly|Ride"] = 243.91, ["Mega"] = 186.38, ["Mega|Ride"] = 229.38, ["Mega|Fly|Ride"] = 458.8}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 577.5, ["Fly"] = 693.83, ["Ride"] = 524.99, ["Fly|Ride"] = 538.13, ["Neon|Fly"] = 3902.77, ["Neon|Ride"] = 3884.91, ["Neon|Fly|Ride"] = 1956.57, ["Mega|Ride"] = 15175.61, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 120.75, ["Fly"] = 170.63, ["Ride"] = 132.81, ["Fly|Ride"] = 216.57, ["Neon"] = 498.75, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 695.63, ["Mega|Ride"] = 2601.55, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 61.57, ["Fly"] = 116.02, ["Ride"] = 98.43, ["Fly|Ride"] = 188.65, ["Neon"] = 329.3, ["Neon|Ride"] = 327.51, ["Neon|Fly|Ride"] = 505.32, ["Mega"] = 2167.95, ["Mega|Ride"] = 2027.04, ["Mega|Fly|Ride"] = 1895.25}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 65.63, ["Ride"] = 72.19, ["Fly|Ride"] = 131.64, ["Neon"] = 575.75, ["Neon|Ride"] = 427.88, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 6359.69, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2079.79}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 31.5, ["Fly"] = 65.62, ["Ride"] = 33.13, ["Fly|Ride"] = 102.89, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 179.84, ["Neon|Fly|Ride"] = 198.02, ["Mega"] = 2625, ["Mega|Ride"] = 905.13, ["Mega|Fly|Ride"] = 577.48}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 6.41}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 54.23, ["Fly"] = 393.75, ["Ride"] = 53.82, ["Fly|Ride"] = 131.28, ["Neon|Ride"] = 327.51, ["Neon|Fly|Ride"] = 607.04, ["Mega|Ride"] = 1308.75, ["Mega|Fly|Ride"] = 1300.93}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 35.42}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 212.62, ["Ride"] = 210, ["Fly|Ride"] = 282.19, ["Neon"] = 1156.75, ["Neon|Ride"] = 1156.61, ["Neon|Fly|Ride"] = 1298.61, ["Mega|Fly|Ride"] = 4906.78}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 715.21, ["Ride"] = 641.82, ["Fly|Ride"] = 804.77, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 4335.9, ["Mega|Fly|Ride"] = 10119}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 7.25}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 35.44, ["Fly"] = 56.45, ["Ride"] = 36.75, ["Fly|Ride"] = 64.29, ["Neon"] = 246.75, ["Neon|Fly"] = 273.2, ["Neon|Ride"] = 195.57, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 2167.95, ["Mega|Ride"] = 1175.64, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 20.35}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 7950.8, ["Fly|Ride"] = 5250, ["Neon|Ride"] = 17991.01, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 41195.79}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.65, ["Fly"] = 58.56, ["Ride"] = 26.16, ["Fly|Ride"] = 57.83, ["Neon"] = 87.93, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 197.49, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.5, ["Fly"] = 142.04, ["Ride"] = 31.5, ["Fly|Ride"] = 121.46, ["Neon"] = 91.88, ["Neon|Ride"] = 127.92, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 867.19, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 74.26, ["Ride"] = 91.88, ["Fly|Ride"] = 85.32, ["Neon|Ride"] = 405.42, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4335.9, ["Mega|Fly|Ride"] = 1799.57}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 9.86, ["Fly"] = 72.65, ["Ride"] = 36.73, ["Fly|Ride"] = 78.75, ["Neon"] = 93.09, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 315, ["Mega"] = 555.01, ["Mega|Ride"] = 769.07, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1575, ["Fly"] = 2400.22, ["Ride"] = 1852.19, ["Fly|Ride"] = 1650.18, ["Neon|Fly|Ride"] = 3281.25, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34691.2, ["Ride"] = 33970.27, ["Fly|Ride"] = 27319.32, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 26.25, ["Fly"] = 393.75, ["Ride"] = 55.13, ["Fly|Ride"] = 137.7, ["Neon"] = 214.78, ["Neon|Ride"] = 198.26, ["Neon|Fly|Ride"] = 582.75, ["Mega"] = 1050, ["Mega|Ride"] = 1308.75, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.49, ["Fly"] = 104.08, ["Ride"] = 52.49, ["Fly|Ride"] = 157.5, ["Neon"] = 22.31, ["Neon|Fly"] = 145.16, ["Neon|Ride"] = 72.1, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 196.88, ["Mega|Fly"] = 392.51, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.13}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.59, ["Ride"] = 60.38, ["Fly|Ride"] = 131.25, ["Neon"] = 56.44, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 411.92, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 802.25, ["Ride"] = 739.9, ["Fly|Ride"] = 738.86, ["Neon"] = 3108.46, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 10386.42}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 939.54, ["Fly"] = 1076.15, ["Ride"] = 1078.69, ["Fly|Ride"] = 987, ["Neon"] = 3615.48, ["Neon|Ride"] = 3121.85, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13738.97}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 12.9, ["Fly"] = 122.68, ["Ride"] = 32.48, ["Fly|Ride"] = 77.18, ["Neon"] = 87.93, ["Neon|Ride"] = 51.54, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 496.53, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 23.55}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 78.89, ["Fly"] = 91.01, ["Ride"] = 91.34, ["Fly|Ride"] = 144.38, ["Neon"] = 578.92, ["Neon|Ride"] = 361.85, ["Neon|Fly|Ride"] = 411.65, ["Mega"] = 19687.5, ["Mega|Ride"] = 2024.88, ["Mega|Fly|Ride"] = 2372.02}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 100.33, ["Ride"] = 122.07, ["Fly|Ride"] = 216.84, ["Neon"] = 450.19, ["Neon|Ride"] = 423.81, ["Neon|Fly|Ride"] = 553.77, ["Mega"] = 1410.68, ["Mega|Ride"] = 1951.16, ["Mega|Fly|Ride"] = 2149.79}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.19, ["Fly"] = 32.41, ["Ride"] = 24.17, ["Fly|Ride"] = 52.41, ["Neon"] = 49.88, ["Neon|Fly"] = 524.99, ["Neon|Ride"] = 99.73, ["Neon|Fly|Ride"] = 110.92, ["Mega|Fly|Ride"] = 670.93}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 158.81, ["Fly"] = 192.92, ["Ride"] = 164.38, ["Fly|Ride"] = 262.5, ["Neon|Ride"] = 648.37, ["Neon|Fly|Ride"] = 590.62, ["Mega"] = 5203.08, ["Mega|Fly|Ride"] = 2623.68}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.07, ["Fly"] = 43.38, ["Ride"] = 33.13, ["Fly|Ride"] = 141.75, ["Neon"] = 39.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 343.45, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.01, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 15.74, ["Ride"] = 39.27, ["Fly|Ride"] = 65.29, ["Neon"] = 120.75, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 144.25, ["Mega"] = 654.99, ["Mega|Fly|Ride"] = 791.4}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 36.75, ["Ride"] = 53.82, ["Fly|Ride"] = 148.38, ["Neon"] = 226.5, ["Neon|Ride"] = 245.33, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 18.02, ["Fly"] = 58.56, ["Ride"] = 37.31, ["Fly|Ride"] = 79.48, ["Neon"] = 131.25, ["Neon|Ride"] = 140.94, ["Neon|Fly|Ride"] = 328.47, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6784.32, ["Ride"] = 5512.5, ["Fly|Ride"] = 5589.94, ["Neon"] = 36137.39, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30207.05}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 190.32, ["Fly"] = 249.37, ["Ride"] = 242.81, ["Fly|Ride"] = 288.75, ["Neon"] = 818.23, ["Neon|Fly"] = 693.83, ["Neon|Fly|Ride"] = 647.08, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 61.04, ["Fly"] = 170.1, ["Ride"] = 110.24, ["Fly|Ride"] = 227.06, ["Neon"] = 175.03, ["Neon|Ride"] = 250.68, ["Neon|Fly|Ride"] = 342.57, ["Mega"] = 486.68, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 90.79, ["Ride"] = 21.86, ["Fly|Ride"] = 81.37, ["Neon"] = 22.14, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 64.28, ["Fly"] = 215.34, ["Ride"] = 137.71, ["Fly|Ride"] = 256.17, ["Neon"] = 199.5, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 388.5, ["Mega"] = 483, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16623.6, ["Ride"] = 13415.07, ["Fly|Ride"] = 11808.57, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 85282.87}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 282.19, ["Ride"] = 341.25, ["Fly|Ride"] = 478.11, ["Neon|Ride"] = 2167.95, ["Neon|Fly|Ride"] = 1662.84, ["Mega|Fly|Ride"] = 8672.81}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 57.75, ["Fly"] = 65.63, ["Ride"] = 64.19, ["Fly|Ride"] = 105, ["Neon"] = 1049.99, ["Neon|Ride"] = 328.11, ["Neon|Fly|Ride"] = 385.88, ["Mega|Fly|Ride"] = 2025.11}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.7, ["Ride"] = 24.94, ["Fly|Ride"] = 61.69, ["Neon"] = 59.06, ["Neon|Fly"] = 327.54, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 421.32, ["Mega|Ride"] = 735.95, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.5, ["Fly"] = 867.29, ["Ride"] = 406.87, ["Fly|Ride"] = 491.77, ["Neon"] = 1721.56, ["Neon|Ride"] = 1442.44, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.45, ["Ride"] = 41.98, ["Fly|Ride"] = 199.5, ["Neon"] = 30.19, ["Neon|Ride"] = 93.17, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 158.82, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 100.42, ["Fly"] = 167.92, ["Ride"] = 156.33, ["Fly|Ride"] = 199.49, ["Neon"] = 563.74, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 522.37, ["Mega"] = 2146.28, ["Mega|Fly|Ride"] = 2167.95}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 10.5, ["Fly"] = 17.36, ["Ride"] = 18.26, ["Fly|Ride"] = 38.6, ["Neon"] = 116.02, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 106.24, ["Mega"] = 2601.55, ["Mega|Fly|Ride"] = 498.74}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 8.18}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 68.42, ["Ride"] = 87.94, ["Fly|Ride"] = 131.25, ["Neon"] = 327.54, ["Neon|Fly"] = 540.92, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 432.52, ["Mega|Ride"] = 2022.7, ["Mega|Fly|Ride"] = 1734.56}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.19, ["Fly"] = 80.07, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 91.88, ["Neon|Ride"] = 137.81, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 584.27, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 573.13}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 38.06}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 76.11, ["Fly"] = 145.28, ["Ride"] = 116.94, ["Fly|Ride"] = 327.54, ["Neon"] = 261.19, ["Neon|Ride"] = 439.69, ["Neon|Fly|Ride"] = 610.3, ["Mega|Fly|Ride"] = 2059.8}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.83, ["Ride"] = 29.24, ["Fly|Ride"] = 137.82, ["Neon"] = 21.84, ["Neon|Ride"] = 142.01, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 140.44, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 323.54}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 11.82, ["Fly"] = 56.44, ["Ride"] = 33.49, ["Fly|Ride"] = 87.65, ["Neon"] = 131.25, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 215.73, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.96, ["Fly"] = 542.07, ["Ride"] = 485.63, ["Fly|Ride"] = 498.74, ["Neon|Fly|Ride"] = 2817.25, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 41.63, ["Fly"] = 108.43, ["Ride"] = 66.54, ["Fly|Ride"] = 99.1, ["Neon"] = 195.57, ["Neon|Ride"] = 185.22, ["Neon|Fly|Ride"] = 327.51, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 719.86}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.34, ["Fly"] = 144.46, ["Ride"] = 51.45, ["Fly|Ride"] = 144.27, ["Neon"] = 236.25, ["Neon|Ride"] = 161.72, ["Neon|Fly|Ride"] = 327.51, ["Mega|Ride"] = 1066.65, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.53, ["Fly"] = 43.38, ["Ride"] = 84, ["Fly|Ride"] = 127.38, ["Neon"] = 107.63, ["Neon|Ride"] = 143.2, ["Neon|Fly|Ride"] = 311.1, ["Mega"] = 405.42, ["Mega|Fly"] = 525, ["Mega|Ride"] = 527.9, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10500, ["Ride"] = 8862, ["Fly|Ride"] = 8071.87, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1443.75, ["Fly"] = 1501.85, ["Ride"] = 1509.38, ["Fly|Ride"] = 1364.98, ["Neon|Fly|Ride"] = 4068.75, ["Mega|Fly|Ride"] = 24573.3}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 619.03, ["Ride"] = 583.92, ["Fly|Ride"] = 721.66, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21679.44, ["Mega|Fly|Ride"] = 7227.71}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.73, ["Fly"] = 29.29, ["Ride"] = 19.24, ["Fly|Ride"] = 39.46, ["Neon"] = 90.79, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 121.45, ["Mega|Fly|Ride"] = 577.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 3.11, ["Fly"] = 78.74, ["Ride"] = 37.82, ["Fly|Ride"] = 119.12, ["Neon"] = 22.32, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 145.03, ["Mega|Ride"] = 202.44, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 30.19, ["Fly"] = 41.91, ["Ride"] = 49.88, ["Fly|Ride"] = 98.64, ["Neon"] = 239.4, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 177.18, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 2.58, ["Fly"] = 26.25, ["Ride"] = 20.28, ["Fly|Ride"] = 39.36, ["Neon"] = 35.44, ["Neon|Fly"] = 86.63, ["Neon|Ride"] = 43.37, ["Neon|Fly|Ride"] = 109.72, ["Mega"] = 281.86, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 245.43}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 305.11, ["Fly"] = 430.5, ["Ride"] = 301.44, ["Fly|Ride"] = 354.37, ["Neon"] = 1626.16, ["Neon|Ride"] = 1083.98, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4436.11}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 17.07, ["Fly"] = 60.6, ["Ride"] = 42.19, ["Fly|Ride"] = 72.19, ["Neon"] = 170.62, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 159.67, ["Neon|Fly|Ride"] = 227.73, ["Mega"] = 867.19, ["Mega|Fly"] = 916.25, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 718.8}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 5.16, ["Fly"] = 22.31, ["Ride"] = 25.64, ["Fly|Ride"] = 29.29, ["Neon"] = 84.57, ["Neon|Fly"] = 122.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 441.23, ["Fly"] = 1048.69, ["Ride"] = 590.63, ["Fly|Ride"] = 866.58, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1221.63, ["Fly"] = 1446.21, ["Ride"] = 1155, ["Fly|Ride"] = 1181.24, ["Neon"] = 5263.76, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13731.21}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 115.49, ["Fly"] = 145.28, ["Ride"] = 99.23, ["Fly|Ride"] = 107.63, ["Neon"] = 971.25, ["Neon|Ride"] = 596.21, ["Neon|Fly|Ride"] = 492.19, ["Mega|Fly|Ride"] = 2854.52}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 196.87, ["Fly"] = 262.5, ["Ride"] = 211.28, ["Fly|Ride"] = 273, ["Neon"] = 1012.56, ["Neon|Ride"] = 735.95, ["Neon|Fly|Ride"] = 630, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2457.67}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.17, ["Fly"] = 124.68, ["Ride"] = 52.5, ["Fly|Ride"] = 104.08, ["Neon"] = 242.04, ["Neon|Ride"] = 240.55, ["Mega|Ride"] = 2167.95, ["Mega|Fly|Ride"] = 1097.91}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 393.75, ["Ride"] = 431.16, ["Fly|Ride"] = 492.2, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 5782.61}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2457.67, ["Ride"] = 1968.65, ["Fly|Ride"] = 2042.57, ["Neon|Fly|Ride"] = 10839.72, ["Mega|Fly|Ride"] = 37457.05}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.54, ["Fly"] = 216.84, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 216.84, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 2384.75, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 589.32, ["Fly"] = 867.29, ["Ride"] = 625.49, ["Fly|Ride"] = 643.13, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1140.57, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.8, ["Fly"] = 72.19, ["Ride"] = 55.78, ["Fly|Ride"] = 91.88, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1083.98, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.68, ["Fly"] = 41.56, ["Ride"] = 22.32, ["Fly|Ride"] = 58.29, ["Neon"] = 28.14, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 166.67, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 187.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 63, ["Ride"] = 84.57, ["Fly|Ride"] = 157.5, ["Neon"] = 196.77, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 1586.95, ["Mega|Ride"] = 1734.36, ["Mega|Fly|Ride"] = 1720.48}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 990.93, ["Ride"] = 945, ["Fly|Ride"] = 1036.87, ["Neon|Ride"] = 3468.72, ["Neon|Fly|Ride"] = 3081.75, ["Mega|Fly|Ride"] = 11564.11}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 651, ["Ride"] = 809.85, ["Fly|Ride"] = 909.57, ["Neon|Fly|Ride"] = 4334.81, ["Mega|Fly|Ride"] = 17345.61}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 15.65, ["Fly"] = 26.24, ["Ride"] = 21.67, ["Fly|Ride"] = 47.25, ["Neon"] = 91.88, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 144.38, ["Mega|Fly|Ride"] = 722.52}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 17.59, ["Ride"] = 41.16, ["Fly|Ride"] = 129.02, ["Neon"] = 143.03, ["Neon|Ride"] = 148.32, ["Neon|Fly|Ride"] = 143.1, ["Mega"] = 1734.36, ["Mega|Ride"] = 997.27, ["Mega|Fly|Ride"] = 630}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.27, ["Fly"] = 70.88, ["Ride"] = 36.74, ["Fly|Ride"] = 144.38, ["Neon"] = 20.69, ["Neon|Fly"] = 326.17, ["Neon|Ride"] = 68.71, ["Neon|Fly|Ride"] = 201.48, ["Mega"] = 196.87, ["Mega|Fly"] = 572.81, ["Mega|Ride"] = 204.75, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.55, ["Fly"] = 67.24, ["Ride"] = 50.42, ["Fly|Ride"] = 105, ["Neon"] = 202.74, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 216.68, ["Mega|Ride"] = 904.05, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 327.54, ["Fly|Ride"] = 362.11, ["Neon"] = 413.44, ["Neon|Ride"] = 613.29, ["Neon|Fly|Ride"] = 612.07, ["Mega|Ride"] = 2746.79, ["Mega|Fly|Ride"] = 2877.21}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.72, ["Fly"] = 57.66, ["Ride"] = 33.63, ["Fly|Ride"] = 104.99, ["Neon"] = 107.63, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 268.84, ["Mega"] = 429.7, ["Mega|Ride"] = 362.86, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 27.57, ["Fly"] = 63, ["Ride"] = 42.78, ["Fly|Ride"] = 77.26, ["Neon"] = 233.08, ["Neon|Ride"] = 239.57, ["Neon|Fly|Ride"] = 215.7, ["Mega"] = 1951.16, ["Mega|Fly|Ride"] = 1246.88}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.31, ["Fly"] = 45.94, ["Ride"] = 18.41, ["Fly|Ride"] = 39.52, ["Neon"] = 28.84, ["Neon|Ride"] = 54.01, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 434.74, ["Mega|Ride"] = 490.63, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.37, ["Fly"] = 53.82, ["Ride"] = 36.75, ["Fly|Ride"] = 33246.09, ["Neon"] = 51.19, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 243.91, ["Mega"] = 367.5, ["Mega|Ride"] = 441, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.1, ["Fly"] = 72.18, ["Ride"] = 53.45, ["Fly|Ride"] = 102.38, ["Neon"] = 145.28, ["Neon|Ride"] = 361.85, ["Neon|Fly|Ride"] = 272.54, ["Mega|Fly|Ride"] = 1074.92}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1396.5, ["Fly"] = 1410.93, ["Ride"] = 1364.95, ["Fly|Ride"] = 1351.88, ["Neon|Ride"] = 4906.2, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 472.5, ["Fly"] = 524.99, ["Ride"] = 498.75, ["Fly|Ride"] = 524.98, ["Neon|Ride"] = 2453.11, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15175.61, ["Mega|Fly|Ride"] = 9395.91}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 275.63, ["Fly"] = 378.23, ["Ride"] = 345.54, ["Fly|Ride"] = 420, ["Neon"] = 1575, ["Neon|Ride"] = 1468.69, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7350}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.79}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 44.01, ["Ride"] = 55.22, ["Fly|Ride"] = 110.24, ["Neon"] = 325.25, ["Neon|Fly"] = 289.47, ["Neon|Ride"] = 246.07, ["Neon|Fly|Ride"] = 506.23, ["Mega|Ride"] = 1192.38, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 27464.59, ["Ride"] = 37618.98, ["Fly|Ride"] = 16406.24, ["Neon|Fly|Ride"] = 37798.69, ["Mega"] = 216794.31, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 240.19, ["Fly"] = 284.71, ["Ride"] = 255.94, ["Fly|Ride"] = 275.5, ["Neon"] = 787.5, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 918.65, ["Neon|Fly|Ride"] = 913.5, ["Mega"] = 6503.84, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 118.13, ["Fly"] = 525, ["Ride"] = 289.47, ["Fly|Ride"] = 262.49}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 114.75, ["Fly"] = 161.44, ["Ride"] = 110.15, ["Fly|Ride"] = 145.28, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 551.25, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 14.34, ["Fly"] = 65.06, ["Ride"] = 33.63, ["Fly|Ride"] = 76.07, ["Neon"] = 82.21, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 240.65, ["Mega"] = 733.49, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 802.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5050.84, ["Ride"] = 3936.19, ["Fly|Ride"] = 4199.99, ["Neon"] = 21682, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81779.9}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 29.73, ["Fly"] = 43.87, ["Ride"] = 33.56, ["Fly|Ride"] = 59.07, ["Neon"] = 131.25, ["Neon|Ride"] = 215.73, ["Neon|Fly|Ride"] = 173.25, ["Mega|Ride"] = 1446.04, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 37.3, ["Fly"] = 86.75, ["Ride"] = 57.66, ["Fly|Ride"] = 85.3, ["Neon"] = 287.44, ["Neon|Fly"] = 1446.04, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1429.84}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 389.59, ["Fly"] = 563.06, ["Ride"] = 443.63, ["Fly|Ride"] = 524.99, ["Neon"] = 1168.13, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1438.5, ["Mega|Ride"] = 4119.1, ["Mega|Fly|Ride"] = 4191.74}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.6, ["Fly"] = 30.19, ["Ride"] = 23.63, ["Fly|Ride"] = 40.69, ["Neon"] = 131.25, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 111.18, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 605.83}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 14.33, ["Ride"] = 34.55, ["Fly|Ride"] = 82.21, ["Neon"] = 91.88, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 211.21, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 736.03}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 105, ["Ride"] = 105.67, ["Fly|Ride"] = 245.44, ["Neon"] = 736.03, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 739.29, ["Mega|Fly|Ride"] = 2617.77}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.59, ["Fly"] = 539.33, ["Ride"] = 74.71, ["Fly|Ride"] = 131.25, ["Neon"] = 84.96, ["Neon|Ride"] = 118.27, ["Neon|Fly|Ride"] = 280.45, ["Mega"] = 319.79, ["Mega|Fly"] = 487.1, ["Mega|Ride"] = 424.93, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4265.51, ["Fly"] = 6378.81, ["Ride"] = 3937.5, ["Fly|Ride"] = 4011, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 10460.63, ["Mega"] = 49140.78, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 39.36, ["Fly"] = 145.28, ["Ride"] = 51.98, ["Fly|Ride"] = 165.62, ["Neon"] = 223.13, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 867.19, ["Mega|Ride"] = 1799.37, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 6857.82, ["Fly|Ride"] = 6126.74, ["Neon"] = 22898.68, ["Neon|Fly|Ride"] = 15146.25, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.45, ["Fly"] = 21.97, ["Ride"] = 17.79, ["Fly|Ride"] = 38.07, ["Neon"] = 25.78, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 99.16, ["Mega"] = 210, ["Mega|Ride"] = 210.31, ["Mega|Fly|Ride"] = 262.54}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 15.75, ["Fly"] = 26.25, ["Ride"] = 26.24, ["Fly|Ride"] = 58.21, ["Neon"] = 188.65, ["Neon|Fly"] = 239.6, ["Neon|Ride"] = 141.91, ["Neon|Fly|Ride"] = 144.65, ["Mega|Ride"] = 1004.73, ["Mega|Fly|Ride"] = 735}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.31}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 12.5, ["Fly"] = 32.82, ["Ride"] = 27.57, ["Fly|Ride"] = 87.02, ["Neon"] = 78.74, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 145.27, ["Mega|Ride"] = 1082.91, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.93, ["Fly"] = 190.37, ["Ride"] = 30.45, ["Fly|Ride"] = 118.13, ["Neon"] = 145.28, ["Neon|Ride"] = 154.37, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 1099.88}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 12.39, ["Fly"] = 28.88, ["Ride"] = 22.32, ["Fly|Ride"] = 41.83, ["Neon|Fly"] = 1080.74, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 121.45, ["Mega"] = 2601.55, ["Mega|Ride"] = 429.27, ["Mega|Fly|Ride"] = 622.3}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8664.13}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2747.12}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 15.49}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 243.89, ["Ride"] = 157.5, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1211.84}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.14, ["Fly"] = 97.07, ["Ride"] = 32.8, ["Fly|Ride"] = 138.77, ["Neon"] = 118.57, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega|Ride"] = 2045.9, ["Mega|Fly|Ride"] = 532.31}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.7}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.45, ["Ride"] = 26.24, ["Fly|Ride"] = 86.75, ["Neon"] = 156.13, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 184.29}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2329.69}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 210, ["Fly"] = 433.65, ["Ride"] = 157.5, ["Fly|Ride"] = 367.5, ["Neon"] = 1012.56, ["Neon|Ride"] = 866.12, ["Neon|Fly|Ride"] = 1082.91, ["Mega|Ride"] = 4191.74, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 60.37, ["Fly"] = 477.2, ["Ride"] = 58.56, ["Fly|Ride"] = 245.35, ["Neon"] = 393.75, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 578.86, ["Mega|Fly|Ride"] = 2009.95}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 190.3, ["Fly"] = 275.63, ["Ride"] = 198.8, ["Fly|Ride"] = 181.57, ["Neon"] = 944.99, ["Neon|Ride"] = 792.4, ["Neon|Fly|Ride"] = 828.3, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2488.5, ["Fly"] = 3324.95, ["Ride"] = 2730, ["Fly|Ride"] = 2953.12, ["Neon"] = 15227.27, ["Neon|Ride"] = 9812.39, ["Neon|Fly|Ride"] = 8859.38, ["Mega|Fly|Ride"] = 28909.7}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.43, ["Fly"] = 106.25, ["Ride"] = 54.07, ["Fly|Ride"] = 112.76, ["Neon"] = 127.32, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 974.51, ["Mega|Ride"] = 1012.45, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 630, ["Fly"] = 2100, ["Ride"] = 839.11, ["Fly|Ride"] = 867.29, ["Neon|Fly|Ride"] = 4252.45}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 35.35}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 20.37, ["Ride"] = 43.32, ["Fly|Ride"] = 105, ["Neon"] = 105, ["Neon|Ride"] = 136.6, ["Neon|Fly|Ride"] = 264.5, ["Mega"] = 444.94, ["Mega|Fly"] = 981.25, ["Mega|Ride"] = 458.74, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.08, ["Fly"] = 36.87, ["Ride"] = 30.18, ["Fly|Ride"] = 128.63, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 100.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 458.74, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 397.46}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 49.76}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 19.4, ["Ride"] = 26.14, ["Fly|Ride"] = 82.21, ["Neon|Ride"] = 234.29, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1229.24, ["Mega|Fly|Ride"] = 2168.21}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 23.63, ["Fly"] = 45.93, ["Ride"] = 42, ["Fly|Ride"] = 58.56, ["Neon|Fly"] = 239.57, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 288.35, ["Mega"] = 1446.04, ["Mega|Ride"] = 1839.85, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7227.71, ["Fly"] = 4921.88, ["Ride"] = 6928.5, ["Fly|Ride"] = 5117.44, ["Neon|Fly|Ride"] = 10548.33, ["Mega|Fly|Ride"] = 34691.2}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 8.81, ["Fly"] = 43.38, ["Ride"] = 32.82, ["Fly|Ride"] = 81.83, ["Neon"] = 55.13, ["Neon|Ride"] = 87.65, ["Neon|Fly|Ride"] = 234.29, ["Mega"] = 354.38, ["Mega|Ride"] = 288.74, ["Mega|Fly|Ride"] = 547.12}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 20.76}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 83.58, ["Fly"] = 383.79, ["Ride"] = 118.13, ["Fly|Ride"] = 196.88, ["Neon"] = 459.38, ["Neon|Ride"] = 484.81, ["Neon|Fly|Ride"] = 535.49, ["Mega"] = 2879.59, ["Mega|Ride"] = 1764.77, ["Mega|Fly|Ride"] = 2023.43}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 48.62, ["Fly"] = 190.93, ["Ride"] = 91.76, ["Fly|Ride"] = 167.16, ["Neon"] = 254.78, ["Neon|Fly"] = 392.56, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 2453.11, ["Mega|Ride"] = 1191.3, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 21.94, ["Fly"] = 82.41, ["Ride"] = 32.81, ["Fly|Ride"] = 72.19, ["Neon"] = 173.46, ["Neon|Fly"] = 234.15, ["Neon|Ride"] = 147, ["Neon|Fly|Ride"] = 182.44, ["Mega"] = 1016.21, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 803.25}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 5.2, ["Fly"] = 78.74, ["Ride"] = 29.53, ["Fly|Ride"] = 65.63, ["Neon"] = 28.88, ["Neon|Ride"] = 78.22, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 162.74, ["Mega|Fly"] = 7226.85, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 345.63}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 12.46, ["Fly"] = 65.63, ["Ride"] = 30.39, ["Fly|Ride"] = 98.06, ["Neon"] = 87.94, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 210, ["Mega"] = 380.63, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 561.45}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 23.63, ["Fly"] = 32.8, ["Ride"] = 28.23, ["Fly|Ride"] = 51.98, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 140.6, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 196.87}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.16, ["Ride"] = 131.25, ["Fly|Ride"] = 289.47, ["Neon"] = 170.63, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 367.99, ["Mega"] = 795.65, ["Mega|Ride"] = 591.87, ["Mega|Fly|Ride"] = 752.38}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 245.35, ["Fly"] = 72.65, ["Ride"] = 1446.21, ["Fly|Ride"] = 433.65, ["Neon|Fly|Ride"] = 28906.28}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 53.81, ["Fly"] = 199.61, ["Ride"] = 86.18, ["Fly|Ride"] = 220.5, ["Neon"] = 210, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1140.57, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1259.88}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1114.32, ["Fly"] = 1246.88, ["Ride"] = 1114.32, ["Fly|Ride"] = 1162.88, ["Neon|Fly"] = 4722.78, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3674.41, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 387.19, ["Fly"] = 723.11, ["Ride"] = 418.68, ["Fly|Ride"] = 525, ["Neon"] = 2756.25, ["Neon|Ride"] = 2167.95, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 13007.67, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.43}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 11.18, ["Fly"] = 31.49, ["Ride"] = 24.92, ["Fly|Ride"] = 52.5, ["Neon"] = 79.8, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 85.25, ["Neon|Fly|Ride"] = 143.06, ["Mega"] = 437.26, ["Mega|Ride"] = 723.02, ["Mega|Fly|Ride"] = 573.57}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 234.87, ["Fly"] = 524.99, ["Ride"] = 285.87, ["Fly|Ride"] = 354.38, ["Neon"] = 838.69, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 945, ["Mega|Fly|Ride"] = 3199.53}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 13.13}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 112.18, ["Ride"] = 171.33, ["Fly|Ride"] = 294.33, ["Neon"] = 459.38, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 561.01, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 2809.03, ["Mega|Ride"] = 2457.38, ["Mega|Fly|Ride"] = 2296.77}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 104.99, ["Fly"] = 145.28, ["Ride"] = 144.69, ["Fly|Ride"] = 232.02, ["Neon"] = 723.11, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 2891.31}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 5.85, ["Fly"] = 80.24, ["Ride"] = 31.4, ["Fly|Ride"] = 176.73, ["Neon"] = 32.47, ["Neon|Ride"] = 69.39, ["Neon|Fly|Ride"] = 239.54, ["Mega"] = 216.81, ["Mega|Ride"] = 190.2, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 15.44, ["Fly"] = 51.43, ["Ride"] = 27.57, ["Fly|Ride"] = 72.1, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 327.51, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 14.23, ["Fly"] = 102.36, ["Ride"] = 32.54, ["Fly|Ride"] = 118.12, ["Neon"] = 81.17, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 496.13}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.29, ["Fly"] = 131.23, ["Ride"] = 38.56, ["Fly|Ride"] = 144.38, ["Neon"] = 28.25, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 200.78, ["Mega"] = 184.96, ["Mega|Ride"] = 173.14, ["Mega|Fly|Ride"] = 322.88}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 262.49, ["Ride"] = 309.64, ["Fly|Ride"] = 347.81, ["Neon"] = 1446.21, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6613.03}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 87.83, ["Fly"] = 173.46, ["Ride"] = 129.83, ["Fly|Ride"] = 192.36, ["Neon"] = 420, ["Neon|Ride"] = 492.18, ["Neon|Fly|Ride"] = 588.78, ["Mega"] = 2600.46, ["Mega|Ride"] = 1808.08, ["Mega|Fly|Ride"] = 1870.95}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.62, ["Fly"] = 167.45, ["Ride"] = 86.1, ["Fly|Ride"] = 116.11, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 415.8, ["Mega|Ride"] = 1799.37, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 17.36, ["Ride"] = 54.23, ["Fly|Ride"] = 289.47, ["Neon|Ride"] = 623.11, ["Neon|Fly|Ride"] = 506.23}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.13, ["Ride"] = 29.25, ["Fly|Ride"] = 57.75, ["Neon"] = 78.74, ["Neon|Fly"] = 145.28, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 126, ["Mega"] = 433.6, ["Mega|Ride"] = 490.63, ["Mega|Fly|Ride"] = 618.28}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 2.46, ["Fly"] = 42, ["Ride"] = 21.4, ["Fly|Ride"] = 69.47, ["Neon"] = 24.15, ["Neon|Fly"] = 42, ["Neon|Ride"] = 41.36, ["Neon|Fly|Ride"] = 86.73, ["Mega"] = 166.69, ["Mega|Ride"] = 179.82, ["Mega|Fly|Ride"] = 282.72}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 840, ["Fly"] = 918.75, ["Ride"] = 905.62, ["Fly|Ride"] = 931.87, ["Neon"] = 3035.49, ["Neon|Fly"] = 3330.49, ["Neon|Fly|Ride"] = 2336.25, ["Mega|Fly|Ride"] = 7221.76}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 314.98, ["Fly"] = 319.82, ["Ride"] = 299.31, ["Fly|Ride"] = 315, ["Neon|Ride"] = 1549.14, ["Neon|Fly|Ride"] = 1273.13, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5071.16}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 91.88, ["Fly"] = 173.46, ["Ride"] = 119.68, ["Fly|Ride"] = 173.25, ["Neon"] = 422.63, ["Neon|Ride"] = 364.23, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1312.5, ["Mega|Ride"] = 1749.55, ["Mega|Fly|Ride"] = 1879.84}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 173.15, ["Fly"] = 216.84, ["Ride"] = 188.9, ["Fly|Ride"] = 240.27, ["Neon|Ride"] = 997.5, ["Neon|Fly|Ride"] = 870.19, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 19.36, ["Fly"] = 58.56, ["Ride"] = 30.17, ["Fly|Ride"] = 68.25, ["Neon"] = 169.32, ["Neon|Ride"] = 230.61, ["Neon|Fly|Ride"] = 213.68, ["Mega|Ride"] = 755.5, ["Mega|Fly|Ride"] = 956.2}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 239.36, ["Ride"] = 282.19, ["Fly|Ride"] = 374.07, ["Neon"] = 955.11, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 3248.6, ["Mega|Fly|Ride"] = 4247.22}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 77.35, ["Fly"] = 125.99, ["Ride"] = 81.38, ["Fly|Ride"] = 129.55, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 867.19, ["Mega|Ride"] = 2313.21, ["Mega|Fly|Ride"] = 1734.57}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 3196.77, ["Ride"] = 2887.49, ["Fly|Ride"] = 2472.75, ["Neon|Ride"] = 11448.61, ["Neon|Fly|Ride"] = 7696.22, ["Mega"] = 52030.65, ["Mega|Fly|Ride"] = 29440.62}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 13.02, ["Fly"] = 65.63, ["Ride"] = 34.91, ["Fly|Ride"] = 78.75, ["Neon"] = 57.18, ["Neon|Fly"] = 173.04, ["Neon|Ride"] = 67.19, ["Neon|Fly|Ride"] = 164.66, ["Mega"] = 255.61, ["Mega|Ride"] = 335.22, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 59.43, ["Ride"] = 82.57, ["Fly|Ride"] = 145.28, ["Neon"] = 236.25, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 452.1, ["Mega|Ride"] = 931.88, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.41, ["Fly"] = 86.92, ["Ride"] = 82.6, ["Fly|Ride"] = 87.94, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.81, ["Mega|Fly|Ride"] = 2023.43}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1636.43, ["Ride"] = 1069.69, ["Fly|Ride"] = 997.49, ["Neon|Ride"] = 5724.31, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37144.47, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 420, ["Fly"] = 865.12, ["Ride"] = 758.89, ["Fly|Ride"] = 534.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.87, ["Fly"] = 105, ["Ride"] = 116.02, ["Fly|Ride"] = 254.78, ["Neon"] = 380.63, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2167.95, ["Mega|Ride"] = 1712.69, ["Mega|Fly|Ride"] = 1730.24}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 9.09, ["Fly"] = 32.82, ["Ride"] = 23.61, ["Fly|Ride"] = 86.75, ["Neon"] = 86.63, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 187.69, ["Mega"] = 553.88, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.73, ["Fly"] = 62.67, ["Ride"] = 47.25, ["Fly|Ride"] = 69.66, ["Neon"] = 212.63, ["Neon|Fly"] = 362.11, ["Neon|Ride"] = 281.86, ["Neon|Fly|Ride"] = 346.89, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1012.56}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1128.58, ["Ride"] = 874.13, ["Fly|Ride"] = 892.49, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 9723}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 616.86}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 12266.93, ["Ride"] = 5250, ["Fly|Ride"] = 5117.44, ["Neon"] = 42000, ["Neon|Ride"] = 31067.73, ["Neon|Fly|Ride"] = 25906.94, ["Mega|Fly|Ride"] = 108409.96}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 262.5, ["Fly"] = 406.55, ["Ride"] = 341.25, ["Fly|Ride"] = 426.91, ["Neon"] = 1734.57, ["Neon|Fly|Ride"] = 2167.95, ["Mega"] = 6502.76, ["Mega|Fly|Ride"] = 6504.61}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 103.69, ["Ride"] = 157.39, ["Fly|Ride"] = 289.47, ["Neon"] = 1146.99, ["Neon|Ride"] = 563.69, ["Neon|Fly|Ride"] = 490.63}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.7, ["Fly"] = 101.92, ["Ride"] = 40.69, ["Fly|Ride"] = 63, ["Neon"] = 145.28, ["Neon|Ride"] = 179.09, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 13.01, ["Fly"] = 28.88, ["Ride"] = 24.82, ["Fly|Ride"] = 51.19, ["Neon"] = 146.5, ["Neon|Ride"] = 76.98, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 13.12, ["Fly"] = 163.47, ["Ride"] = 27.54, ["Fly|Ride"] = 106.98, ["Neon"] = 118.13, ["Neon|Ride"] = 126.87, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 641.81}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 4.27, ["Fly"] = 29.29, ["Ride"] = 22.32, ["Fly|Ride"] = 48.99, ["Neon"] = 31.4, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 234.93}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 19.95, ["Ride"] = 39.38, ["Fly|Ride"] = 130.92, ["Neon"] = 156.58, ["Neon|Fly"] = 867.19, ["Neon|Ride"] = 234.15, ["Neon|Fly|Ride"] = 327.51, ["Mega"] = 630, ["Mega|Ride"] = 723.02}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 551.25, ["Fly"] = 577.5, ["Ride"] = 590.63, ["Fly|Ride"] = 611.63, ["Neon"] = 1951.39, ["Neon|Ride"] = 2100, ["Neon|Fly|Ride"] = 1614.38, ["Mega"] = 9187.5, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.18, ["Fly"] = 19.69, ["Ride"] = 16.95, ["Fly|Ride"] = 38.05, ["Neon"] = 21.15, ["Neon|Ride"] = 32.81, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 170.63, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 42.87, ["Fly"] = 116.81, ["Ride"] = 80.28, ["Fly|Ride"] = 65.63, ["Neon"] = 207.38, ["Neon|Fly"] = 361.58, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 564.38, ["Mega|Fly"] = 867.19, ["Mega|Ride"] = 523.59, ["Mega|Fly|Ride"] = 593.15}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 740.95, ["Ride"] = 807.18, ["Fly|Ride"] = 805.62, ["Neon|Ride"] = 2126.85, ["Neon|Fly|Ride"] = 1548.75, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 35.43, ["Fly"] = 90.55, ["Ride"] = 33.13, ["Fly|Ride"] = 94.49, ["Neon"] = 262.5, ["Neon|Fly"] = 249.38, ["Neon|Ride"] = 188.9, ["Neon|Fly|Ride"] = 251.99, ["Mega"] = 1308.75, ["Mega|Fly|Ride"] = 880.68}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 282.79, ["Fly"] = 329.04, ["Ride"] = 280.54, ["Fly|Ride"] = 315, ["Neon"] = 1626.16, ["Neon|Ride"] = 1408.1, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4481.68}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 246.88, ["Fly"] = 330.75, ["Ride"] = 262.49, ["Fly|Ride"] = 301.87, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5042.65, ["Mega|Fly|Ride"] = 4192.23}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 656.25, ["Ride"] = 698.25, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3615.06, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 10550.47}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 16.89, ["Fly"] = 62.9, ["Ride"] = 45.94, ["Fly|Ride"] = 107.47, ["Neon"] = 80.06, ["Neon|Fly"] = 294.38, ["Neon|Ride"] = 89.98, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 262.5, ["Mega|Ride"] = 394.58, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4192.23, ["Fly"] = 3543.75, ["Ride"] = 3346.88, ["Fly|Ride"] = 3211.69, ["Neon|Fly|Ride"] = 8020.69, ["Mega|Fly|Ride"] = 18897.38}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 144.38, ["Fly"] = 178.49, ["Ride"] = 157.17, ["Fly|Ride"] = 206.91, ["Neon"] = 535.5, ["Neon|Fly"] = 662.34, ["Neon|Ride"] = 654.94, ["Neon|Fly|Ride"] = 511.88, ["Mega|Ride"] = 3208.56, ["Mega|Fly|Ride"] = 3215.63}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.52, ["Fly"] = 32.54, ["Ride"] = 18.38, ["Fly|Ride"] = 43.31, ["Neon"] = 21, ["Neon|Fly"] = 101.82, ["Neon|Ride"] = 36.18, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 216.81, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 245.02}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 2.63, ["Ride"] = 27.98, ["Fly|Ride"] = 65.62, ["Neon"] = 19.69, ["Neon|Fly"] = 120.22, ["Neon|Ride"] = 49.08, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 171.67, ["Mega|Ride"] = 260.16, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 37.3, ["Fly"] = 41.16, ["Ride"] = 34.13, ["Fly|Ride"] = 48.88, ["Neon"] = 294.42, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1225.04}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 853.13, ["Fly"] = 1226.71, ["Ride"] = 892.5, ["Fly|Ride"] = 1181.25, ["Neon"] = 4228, ["Neon|Ride"] = 4581.17, ["Neon|Fly|Ride"] = 4798.76}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 8022.35, ["Fly|Ride"] = 7586.54}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 20.99, ["Fly"] = 43.32, ["Ride"] = 27.22, ["Fly|Ride"] = 44.6, ["Neon"] = 452.13, ["Neon|Ride"] = 138.76, ["Neon|Fly|Ride"] = 162.65, ["Mega"] = 2520, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 13, ["Fly"] = 43.32, ["Ride"] = 29.97, ["Fly|Ride"] = 77.96, ["Neon"] = 102.38, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 77.35, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 104.98, ["Ride"] = 101.41, ["Fly|Ride"] = 145.28, ["Neon|Ride"] = 453.32, ["Neon|Fly|Ride"] = 506.23, ["Mega|Fly|Ride"] = 1677.12}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 236.15, ["Fly"] = 236.25, ["Ride"] = 236.25, ["Fly|Ride"] = 262.19, ["Neon"] = 1286.25, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 681.19, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 4049.13}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.59, ["Ride"] = 26.17, ["Fly|Ride"] = 57.75, ["Neon"] = 22.67, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 43.37, ["Neon|Fly|Ride"] = 125.9, ["Mega"] = 225.48, ["Mega|Fly"] = 241.74, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 168.13, ["Fly"] = 231.72, ["Ride"] = 196.87, ["Fly|Ride"] = 283, ["Neon"] = 721.88, ["Neon|Fly"] = 834.06, ["Neon|Ride"] = 643.13, ["Neon|Fly|Ride"] = 780.94, ["Mega|Ride"] = 3685.52, ["Mega|Fly|Ride"] = 3045.99}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.72, ["Fly"] = 26.16, ["Ride"] = 15.74, ["Fly|Ride"] = 49.17, ["Neon"] = 23.63, ["Neon|Fly"] = 130.11, ["Neon|Ride"] = 43.92, ["Neon|Fly|Ride"] = 122.67, ["Mega"] = 246.07, ["Mega|Ride"] = 208.23, ["Mega|Fly|Ride"] = 212.63}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 199.5, ["Fly"] = 355.61, ["Ride"] = 273.2, ["Fly|Ride"] = 314.99, ["Neon|Ride"] = 1242.94, ["Neon|Fly|Ride"] = 1115.63, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 4906.78}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.85, ["Fly"] = 104.98, ["Ride"] = 28.49, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 311.59, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 578.86, ["Mega|Ride"] = 446.61, ["Mega|Fly|Ride"] = 665.65}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 98.16, ["Neon"] = 6.35, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 195.56, ["Mega"] = 80.58, ["Mega|Ride"] = 136.13, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.71, ["Mega"] = 23.36, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 136.61}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 115.47, ["Neon"] = 7.23, ["Neon|Ride"] = 28.24, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 59.59, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 233.05}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 73.5, ["Fly"] = 131.25, ["Ride"] = 97.75, ["Fly|Ride"] = 137.8, ["Neon"] = 288.75, ["Neon|Fly"] = 376.16, ["Neon|Ride"] = 276.94, ["Neon|Fly|Ride"] = 393.68, ["Mega|Fly|Ride"] = 1625.08}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.05, ["Ride"] = 16.55, ["Fly|Ride"] = 84.57, ["Neon"] = 11.21, ["Neon|Ride"] = 28.08, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 91.88, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 7.4, ["Ride"] = 73.5, ["Neon"] = 52.5, ["Neon|Fly"] = 327.54, ["Neon|Ride"] = 212.57, ["Mega"] = 315, ["Mega|Ride"] = 576.69, ["Mega|Fly|Ride"] = 490.69}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 56.4, ["Neon|Fly|Ride"] = 199.46, ["Mega"] = 15.75, ["Mega|Ride"] = 52.47, ["Mega|Fly|Ride"] = 259.11}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 11.82, ["Fly|Ride"] = 49.88, ["Neon"] = 2.1, ["Neon|Fly"] = 40.67, ["Neon|Ride"] = 12.83, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 13.13, ["Mega|Fly"] = 36.17, ["Mega|Ride"] = 18.15, ["Mega|Fly|Ride"] = 48.57}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 16.05, ["Fly|Ride"] = 81.04, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 14.73, ["Neon|Fly|Ride"] = 31.49, ["Mega"] = 19.69, ["Mega|Fly"] = 164.37, ["Mega|Ride"] = 32.39, ["Mega|Fly|Ride"] = 90.36}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Mega"] = 18.38, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 433.65}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 21, ["Fly|Ride"] = 49.88, ["Neon"] = 3.33, ["Neon|Fly"] = 123.6, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 41.49, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 143.73}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 82.09, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 18.26, ["Mega|Ride"] = 65.02, ["Mega|Fly|Ride"] = 152.25}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.36, ["Fly"] = 55.37, ["Ride"] = 65.61, ["Fly|Ride"] = 131.25, ["Neon"] = 41.66, ["Neon|Fly"] = 133.29, ["Neon|Ride"] = 71.51, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 202.13, ["Mega|Fly"] = 401.09, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.94, ["Neon|Fly|Ride"] = 326.92, ["Mega"] = 22.03, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 66.25, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 146.37, ["Fly|Ride"] = 145.28, ["Neon"] = 19.67, ["Mega"] = 108.94, ["Mega|Fly"] = 315, ["Mega|Ride"] = 274.31, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.83, ["Ride"] = 26.24, ["Neon"] = 20.99, ["Mega"] = 131.25, ["Mega|Ride"] = 173.45, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 145.28, ["Ride"] = 32.81, ["Neon"] = 2.63, ["Neon|Ride"] = 27.13, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 22.26, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 98.01}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.61, ["Ride"] = 13.13, ["Fly|Ride"] = 40.27, ["Neon"] = 2.1, ["Neon|Fly"] = 35.21, ["Neon|Ride"] = 15.15, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 14.31, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 20.99, ["Mega|Fly|Ride"] = 51.18}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.71, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 34.92, ["Neon|Ride"] = 72.64, ["Mega"] = 183.74, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Neon"] = 3.19, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 22.32, ["Mega|Ride"] = 65.5, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 2.1, ["Neon"] = 15.8, ["Neon|Ride"] = 195.11, ["Mega"] = 101.5, ["Mega|Ride"] = 179.08, ["Mega|Fly|Ride"] = 311.06}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.52, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 45.94, ["Neon"] = 11.71, ["Neon|Ride"] = 50.96, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 36.16, ["Ride"] = 16.28, ["Fly|Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 19.87, ["Neon|Ride"] = 13.02, ["Neon|Fly|Ride"] = 31.39, ["Mega"] = 18.38, ["Mega|Fly"] = 27.58, ["Mega|Ride"] = 20.86, ["Mega|Fly|Ride"] = 47.24}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 29.25, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 196.56, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 4.81, ["Ride"] = 24.54, ["Fly|Ride"] = 59.07, ["Neon"] = 66.13, ["Neon|Ride"] = 72.3, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 291.38, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.56, ["Ride"] = 14.41, ["Fly|Ride"] = 41.3, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 40.62, ["Mega"] = 21, ["Mega|Fly"] = 50.96, ["Mega|Ride"] = 32.81, ["Mega|Fly|Ride"] = 84.07}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.63, ["Fly"] = 181.07, ["Ride"] = 45.91, ["Neon"] = 6.49, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 51.19, ["Mega|Fly"] = 173.45, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 262.48}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.44, ["Fly|Ride"] = 131.24, ["Neon"] = 3.57, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 31.49, ["Mega|Fly"] = 115.75, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.56, ["Neon"] = 2.1, ["Neon|Ride"] = 35.26, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 14.27, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 156.19}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.87, ["Ride"] = 19.57, ["Fly|Ride"] = 52.64, ["Neon"] = 6.46, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 33.32, ["Neon|Fly|Ride"] = 74.8, ["Mega"] = 105.21, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 22.6, ["Neon"] = 5.91, ["Neon|Ride"] = 57.75, ["Mega"] = 52.47, ["Mega|Fly"] = 327.51, ["Mega|Ride"] = 114.19, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 19.53, ["Ride"] = 17.2, ["Fly|Ride"] = 72.18, ["Neon"] = 3.84, ["Neon|Fly"] = 81.89, ["Neon|Ride"] = 25.94, ["Neon|Fly|Ride"] = 83.98, ["Mega"] = 114.19, ["Mega|Fly"] = 115.77, ["Mega|Ride"] = 83.09, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 3.31, ["Ride"] = 37.03, ["Neon"] = 14.97, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 104.74, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 25.77, ["Ride"] = 15.75, ["Fly|Ride"] = 47.24, ["Neon"] = 9.19, ["Neon|Fly"] = 49.08, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 89.98, ["Mega"] = 137.68, ["Mega|Fly"] = 420, ["Mega|Ride"] = 80.9, ["Mega|Fly|Ride"] = 172.46}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 6.46, ["Fly"] = 14.23, ["Ride"] = 16.54, ["Fly|Ride"] = 64.75, ["Neon"] = 14.34, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 29.96, ["Neon|Fly|Ride"] = 108.32, ["Mega"] = 105, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 135.36, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.93, ["Neon"] = 101.75, ["Neon|Ride"] = 87.09, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 325.2}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 5.15, ["Ride"] = 65.63, ["Neon"] = 72.33, ["Neon|Ride"] = 170.63, ["Mega"] = 675.33, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 981.37}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 40.69, ["Neon"] = 26.25, ["Neon|Ride"] = 108.32, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 223.13, ["Mega|Ride"] = 253.52}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 3.91, ["Ride"] = 45.94, ["Fly|Ride"] = 130.11, ["Neon"] = 48.3, ["Neon|Ride"] = 69.46, ["Neon|Fly|Ride"] = 127.29, ["Mega"] = 225.67, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.68, ["Neon|Ride"] = 52.5, ["Mega"] = 17.99, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 58.55, ["Mega|Fly|Ride"] = 236.18}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 45.93}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.23, ["Fly"] = 21, ["Ride"] = 22.31, ["Fly|Ride"] = 45.94, ["Neon"] = 38.07, ["Neon|Fly"] = 187.7, ["Neon|Ride"] = 45.73, ["Neon|Fly|Ride"] = 111.57, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 327.51}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.28, ["Neon"] = 3.93, ["Neon|Fly"] = 52.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 28.86, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 56.39, ["Mega|Fly|Ride"] = 129.54}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 3.84, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 72.18, ["Mega"] = 32.02, ["Mega|Ride"] = 56.46, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.18, ["Ride"] = 16.13, ["Fly|Ride"] = 45.27, ["Neon"] = 12.5, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 65.45, ["Mega"] = 162.31, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 153.95}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 3.73, ["Fly"] = 72.65, ["Ride"] = 27.22, ["Fly|Ride"] = 82.21, ["Neon"] = 41.99, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 328.13, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 3.76, ["Neon|Fly|Ride"] = 103, ["Mega"] = 21, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.7, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 27.7, ["Ride"] = 17.18, ["Fly|Ride"] = 59.06, ["Neon"] = 3.07, ["Neon|Fly"] = 115.05, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 31.4, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 51.96, ["Mega|Fly|Ride"] = 138.77}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.37, ["Ride"] = 18.31, ["Fly|Ride"] = 27.57, ["Neon"] = 4.6, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 16.28, ["Neon|Fly|Ride"] = 61.32, ["Mega"] = 84.57, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 120.35}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 91.88, ["Ride"] = 26.25, ["Fly|Ride"] = 144.38, ["Neon"] = 9.75, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 80.04, ["Mega|Ride"] = 145.68, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 2.1, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157978.06, ["Mega"] = 19.8, ["Mega|Fly"] = 114.92, ["Mega|Ride"] = 86.99, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 19.57, ["Neon"] = 2.16, ["Neon|Fly"] = 28.23, ["Neon|Ride"] = 24.2, ["Neon|Fly|Ride"] = 90.62, ["Mega"] = 18.77, ["Mega|Fly"] = 32.82, ["Mega|Ride"] = 36.39, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Mega"] = 10.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.31, ["Mega|Fly"] = 24.94, ["Mega|Ride"] = 207.06, ["Mega|Fly|Ride"] = 147.21}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 16.28, ["Fly|Ride"] = 68.25, ["Neon"] = 3.84, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 17.89, ["Neon|Fly|Ride"] = 48.38, ["Mega"] = 37.94, ["Mega|Ride"] = 72.64, ["Mega|Fly|Ride"] = 76.65}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 7.88, ["Ride"] = 78.75, ["Fly|Ride"] = 216.84, ["Neon"] = 72.84, ["Neon|Ride"] = 78.75, ["Mega"] = 389.81, ["Mega|Ride"] = 483.47, ["Mega|Fly|Ride"] = 593.01}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 26.25, ["Neon"] = 25.73, ["Neon|Ride"] = 157.5, ["Mega"] = 211.39, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.13, ["Fly|Ride"] = 131.25, ["Neon"] = 46.64, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 232.31, ["Mega|Ride"] = 298.11, ["Mega|Fly|Ride"] = 388.4}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.2, ["Ride"] = 11.82, ["Fly|Ride"] = 25.25, ["Neon"] = 2.1, ["Neon|Fly"] = 19.36, ["Neon|Ride"] = 13.43, ["Neon|Fly|Ride"] = 31.39, ["Mega"] = 14.42, ["Mega|Fly"] = 104.98, ["Mega|Ride"] = 22.18, ["Mega|Fly|Ride"] = 49.01}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.38, ["Neon"] = 9.43, ["Neon|Fly"] = 68.59, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 723.02, ["Mega"] = 118.12, ["Mega|Ride"] = 145.27}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 86.66, ["Mega"] = 14.27, ["Mega|Fly"] = 145.27, ["Mega|Fly|Ride"] = 181.07}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.26, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 20.63, ["Mega|Fly"] = 216.81, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 19.68, ["Fly|Ride"] = 44.34, ["Neon"] = 9.19, ["Neon|Fly"] = 59.06, ["Neon|Ride"] = 40.6, ["Neon|Fly|Ride"] = 78.66, ["Mega"] = 173.25, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 245.35}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 192.4, ["Ride"] = 236.24, ["Fly|Ride"] = 798.44, ["Neon|Ride"] = 932.18, ["Neon|Fly|Ride"] = 955.49, ["Mega"] = 8671.79, ["Mega|Fly|Ride"] = 3281.58}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 7.27, ["Neon|Ride"] = 64.31, ["Mega"] = 65.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.62, ["Fly"] = 103.68, ["Ride"] = 24.69, ["Fly|Ride"] = 65.63, ["Neon"] = 42.3, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 387.18, ["Mega|Ride"] = 229.38, ["Mega|Fly|Ride"] = 653.84}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 15.74, ["Ride"] = 11.93, ["Fly|Ride"] = 32.45, ["Neon"] = 4.09, ["Neon|Fly"] = 33.62, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 49.67, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 19.69, ["Fly|Ride"] = 131.15, ["Neon"] = 8.91, ["Neon|Ride"] = 80.07, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 85.05, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.82, ["Fly"] = 27.96, ["Ride"] = 16.75, ["Fly|Ride"] = 40.69, ["Neon"] = 31.5, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.31, ["Neon|Fly|Ride"] = 84.9, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.73, ["Ride"] = 34.7, ["Fly|Ride"] = 115.33, ["Neon"] = 50.66, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 257.25, ["Mega|Ride"] = 260.16, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.5, ["Fly"] = 19.48, ["Ride"] = 15.75, ["Fly|Ride"] = 28.88, ["Neon"] = 31.5, ["Neon|Fly"] = 95.16, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.1, ["Mega"] = 262.5, ["Mega|Ride"] = 376.16, ["Mega|Fly|Ride"] = 282.3}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 55.46, ["Ride"] = 93.55, ["Fly|Ride"] = 142.93, ["Neon"] = 332.83, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 377.23, ["Neon|Fly|Ride"] = 365.97, ["Mega|Fly|Ride"] = 1378.13}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 247.59, ["Fly"] = 433.65, ["Ride"] = 232.02, ["Fly|Ride"] = 301.87, ["Neon|Ride"] = 1128.75, ["Neon|Fly|Ride"] = 1115.63, ["Mega|Fly|Ride"] = 4336.41}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 59.83, ["Fly"] = 109.51, ["Ride"] = 51.54, ["Fly|Ride"] = 120.75, ["Neon"] = 490.69, ["Neon|Fly"] = 367.47, ["Neon|Ride"] = 293.29, ["Neon|Fly|Ride"] = 429.26, ["Mega|Fly|Ride"] = 1877.46}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 5.25, ["Fly"] = 288.2, ["Ride"] = 28.28, ["Neon"] = 43.22, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Mega"] = 262.5, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.19, ["Ride"] = 26.22, ["Fly|Ride"] = 65.63, ["Neon"] = 62.99, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 301.23, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 518.16}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 34.53, ["Ride"] = 16.17, ["Fly|Ride"] = 39.51, ["Neon"] = 3.3, ["Neon|Ride"] = 20.14, ["Neon|Fly|Ride"] = 63, ["Mega"] = 36.75, ["Mega|Fly"] = 149.65, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 547.12}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.62, ["Fly"] = 69.39, ["Ride"] = 32.79, ["Fly|Ride"] = 66.05, ["Neon"] = 98.79, ["Neon|Fly"] = 289.44, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 520.32, ["Mega|Ride"] = 506.23, ["Mega|Fly|Ride"] = 607.11}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 15.65, ["Fly|Ride"] = 45.94, ["Neon"] = 16.96, ["Neon|Fly"] = 52.04, ["Neon|Ride"] = 27.29, ["Neon|Fly|Ride"] = 85.77, ["Mega"] = 144.22, ["Mega|Ride"] = 164.37, ["Mega|Fly|Ride"] = 290.07}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 3.47, ["Ride"] = 27.98, ["Fly|Ride"] = 328.13, ["Neon"] = 25.82, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 204.85, ["Mega"] = 207.38, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 310.55}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Fly"] = 47.25, ["Neon|Ride"] = 19.5, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 14.48, ["Mega|Ride"] = 43.37, ["Mega|Fly|Ride"] = 78.74}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.82, ["Ride"] = 19.09, ["Fly|Ride"] = 43.38, ["Neon"] = 25.47, ["Neon|Fly"] = 108.43, ["Neon|Ride"] = 36.82, ["Neon|Fly|Ride"] = 139.83, ["Mega"] = 78.72, ["Mega|Fly|Ride"] = 226.42}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 56.05, ["Ride"] = 19.08, ["Fly|Ride"] = 71.11, ["Neon"] = 19.69, ["Neon|Ride"] = 47.25, ["Mega"] = 131.25, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 266.72}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 103.94, ["Fly"] = 164.12, ["Ride"] = 144.38, ["Fly|Ride"] = 215.64, ["Neon"] = 430.39, ["Neon|Ride"] = 463.08, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 3924.97, ["Mega|Fly|Ride"] = 3437.3}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.87, ["Ride"] = 130.11, ["Fly|Ride"] = 131.25, ["Neon"] = 47.67, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.8, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.01, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 28.88, ["Neon|Ride"] = 62.97, ["Neon|Fly|Ride"] = 119.86, ["Mega"] = 210, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 16.96, ["Ride"] = 28.77, ["Fly|Ride"] = 159.01, ["Neon"] = 72.6, ["Neon|Ride"] = 161.34, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 490.93, ["Mega|Fly"] = 867.19, ["Mega|Fly|Ride"] = 834.17}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.94}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 3.73, ["Ride"] = 29.29, ["Fly|Ride"] = 129.02, ["Neon"] = 39.37, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 300.57, ["Mega|Ride"] = 490.63, ["Mega|Fly|Ride"] = 865.56}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.95, ["Fly"] = 33.38, ["Ride"] = 26.25, ["Fly|Ride"] = 56.35, ["Neon"] = 89.25, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 162.65, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 1399.41, ["Mega|Fly|Ride"] = 591.95}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 52.39, ["Neon"] = 2.1, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 34.33, ["Mega|Fly"] = 189, ["Mega|Ride"] = 87.94, ["Mega|Fly|Ride"] = 232.83}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.12, ["Fly"] = 15.74, ["Ride"] = 28.01, ["Fly|Ride"] = 65.54, ["Neon"] = 65.06, ["Mega"] = 288.33, ["Mega|Fly"] = 409.68, ["Mega|Ride"] = 327.37}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 19.36, ["Fly|Ride"] = 48.56, ["Neon"] = 11.96, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 37.97, ["Neon|Fly|Ride"] = 74.34, ["Mega"] = 183.75, ["Mega|Ride"] = 221.15, ["Mega|Fly|Ride"] = 197.5}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 275.35, ["Neon|Ride"] = 41.65, ["Mega"] = 32.45, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 232.02}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 21.95, ["Fly"] = 89.14, ["Ride"] = 86.16, ["Fly|Ride"] = 136.5, ["Neon"] = 163.02, ["Neon|Ride"] = 173.25, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 836.84, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 8.49, ["Fly"] = 29.29, ["Ride"] = 48.56, ["Fly|Ride"] = 210, ["Neon"] = 93.94, ["Mega|Ride"] = 325.2, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 20.99, ["Fly|Ride"] = 63.66, ["Neon"] = 34.13, ["Neon|Fly"] = 86.75, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.81, ["Mega|Fly|Ride"] = 246.65}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.31, ["Fly"] = 433.12, ["Ride"] = 130.11, ["Neon"] = 580, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4581.17, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.1, ["Fly"] = 45.85, ["Ride"] = 24.43, ["Fly|Ride"] = 49.17, ["Neon"] = 35.43, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 120.75, ["Mega"] = 239.85, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 361.89}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 71.47, ["Fly"] = 131.24, ["Ride"] = 116.94, ["Fly|Ride"] = 206.07, ["Neon"] = 241.84, ["Neon|Ride"] = 205.8, ["Neon|Fly|Ride"] = 348.55, ["Mega"] = 1018.5, ["Mega|Ride"] = 983.18, ["Mega|Fly|Ride"] = 1093.93}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 17.07, ["Ride"] = 58.56, ["Fly|Ride"] = 169.32, ["Neon"] = 78.75, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 210, ["Mega"] = 353.06, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 439.69}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 17.71, ["Fly"] = 39.38, ["Ride"] = 26.03, ["Fly|Ride"] = 72.42, ["Neon"] = 97.13, ["Neon|Fly|Ride"] = 390.06, ["Mega"] = 572.81, ["Mega|Ride"] = 576.69, ["Mega|Fly|Ride"] = 628.79}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 14.44, ["Fly"] = 100.61, ["Ride"] = 65.63, ["Fly|Ride"] = 83.15, ["Neon"] = 57.75, ["Neon|Ride"] = 117.01, ["Neon|Fly|Ride"] = 237.05, ["Mega"] = 311.56, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 399.16}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 8.93, ["Ride"] = 30.18, ["Neon"] = 42, ["Neon|Ride"] = 65.05, ["Neon|Fly|Ride"] = 105, ["Mega"] = 276.84, ["Mega|Ride"] = 303.53, ["Mega|Fly|Ride"] = 451.44}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 95.65, ["Neon|Ride"] = 131.24, ["Mega"] = 19.69, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 5.07, ["Ride"] = 128.63, ["Fly|Ride"] = 325.9, ["Neon"] = 36.28, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 201.54, ["Mega"] = 236.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 737.2}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 129.02, ["Ride"] = 29.29, ["Neon"] = 28.88, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 211.97, ["Mega|Ride"] = 327.51, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 3.92, ["Ride"] = 32.8, ["Neon"] = 15.88, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 130.09, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 498.65, ["Fly"] = 709.02, ["Ride"] = 577.49, ["Fly|Ride"] = 656.15, ["Neon"] = 2168.21, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1608.45, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.92, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 61.74, ["Neon"] = 42.3, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 326.82, ["Mega"] = 145.27, ["Mega|Ride"] = 376.57, ["Mega|Fly|Ride"] = 359.94}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.86, ["Fly"] = 66.94, ["Ride"] = 20.94, ["Fly|Ride"] = 55.21, ["Neon"] = 95.24, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.13, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 331.87, ["Mega|Ride"] = 273.53, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.24, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 50.59, ["Neon"] = 13.12, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 72.64}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 43.19, ["Ride"] = 32.82, ["Fly|Ride"] = 65.63, ["Neon"] = 11.92, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 68.24, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Fly|Ride"] = 65.06, ["Neon"] = 2.58, ["Neon|Ride"] = 24.54, ["Neon|Fly|Ride"] = 116, ["Mega"] = 24.94, ["Mega|Fly"] = 202.72, ["Mega|Ride"] = 159.36, ["Mega|Fly|Ride"] = 232.02}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1312.5}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 7.7, ["Ride"] = 55.04, ["Fly|Ride"] = 182.77, ["Neon"] = 69.47, ["Neon|Ride"] = 112.87, ["Mega"] = 409.68, ["Mega|Ride"] = 376.16, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.26, ["Neon"] = 6.02, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 1007.55, ["Mega"] = 39.38, ["Mega|Ride"] = 127.65, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.12, ["Fly"] = 321.92, ["Ride"] = 72.39, ["Fly|Ride"] = 58.56, ["Neon"] = 19.95, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Fly"] = 540.92, ["Mega|Ride"] = 357.73, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.51, ["Ride"] = 446.24, ["Fly|Ride"] = 514.49, ["Neon"] = 1692.86, ["Neon|Ride"] = 1709.81, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8129.81, ["Mega|Fly|Ride"] = 6164.82}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.07, ["Fly"] = 196.88, ["Ride"] = 58.56, ["Fly|Ride"] = 130.11, ["Neon"] = 71.54, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 306.57, ["Mega|Ride"] = 497.56, ["Mega|Fly|Ride"] = 518.22}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.69, ["Ride"] = 33.08, ["Fly|Ride"] = 118.11, ["Neon"] = 3.71, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 39.56, ["Neon|Fly|Ride"] = 88.91, ["Mega"] = 41.35, ["Mega|Fly"] = 145.06, ["Mega|Ride"] = 86.62, ["Mega|Fly|Ride"] = 205.7}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.75, ["Neon|Ride"] = 144.45, ["Neon|Fly|Ride"] = 144.89, ["Mega"] = 31.19, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 26.25, ["Fly"] = 107.91, ["Ride"] = 81.15, ["Fly|Ride"] = 120.75, ["Neon"] = 141.75, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 362.07, ["Mega"] = 693.75, ["Mega|Ride"] = 708.93, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 7.88, ["Ride"] = 82.21, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 867.19, ["Mega"] = 572.81, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.81, ["Ride"] = 76.13, ["Neon"] = 120.75, ["Neon|Ride"] = 173.45, ["Mega"] = 663.41, ["Mega|Fly|Ride"] = 818.23}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 17.07, ["Ride"] = 27.57, ["Fly|Ride"] = 217.84, ["Neon"] = 91.88, ["Neon|Ride"] = 163.66, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 643.13, ["Mega|Ride"] = 780.48, ["Mega|Fly|Ride"] = 607.23}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.48, ["Ride"] = 427.32, ["Fly|Ride"] = 737.2, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 5.15, ["Fly"] = 41.89, ["Ride"] = 34.13, ["Fly|Ride"] = 115.91, ["Neon"] = 148.32, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 143.94, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 3.34, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 52.5, ["Neon|Ride"] = 221.82, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 32.82, ["Fly"] = 346.92, ["Ride"] = 91.88, ["Fly|Ride"] = 307.13, ["Neon"] = 152.25, ["Neon|Ride"] = 196.77, ["Neon|Fly|Ride"] = 490.63, ["Mega"] = 426.47, ["Mega|Ride"] = 413.44, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Fly"] = 39.38, ["Ride"] = 43.38, ["Fly|Ride"] = 216.84, ["Neon"] = 7.84, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 280.76, ["Mega"] = 65.63, ["Mega|Ride"] = 173.45, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 57.57, ["Ride"] = 52.5, ["Neon"] = 262.5, ["Neon|Ride"] = 341.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1655.85, ["Mega|Ride"] = 1590.2, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 26.23, ["Neon"] = 14.44, ["Neon|Fly"] = 188.65, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 147.2, ["Mega"] = 65.24, ["Mega|Ride"] = 90.83, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 28.88, ["Fly|Ride"] = 97.49, ["Neon"] = 3.93, ["Neon|Fly"] = 63.55, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 137.68, ["Mega"] = 32.47, ["Mega|Fly"] = 112.88, ["Mega|Ride"] = 77.13, ["Mega|Fly|Ride"] = 245.35}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 131.07, ["Neon"] = 11.82, ["Neon|Ride"] = 53.95, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 72.19, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 53.25, ["Fly"] = 65.63, ["Ride"] = 61.58, ["Fly|Ride"] = 247.19, ["Neon"] = 248.07, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 490.63, ["Mega|Ride"] = 1156.61, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 2168.21}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 6.46, ["Ride"] = 35.28, ["Neon"] = 20.69, ["Neon|Fly"] = 350.44, ["Mega"] = 236.15, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 19.62, ["Fly|Ride"] = 78.75, ["Neon"] = 9.09, ["Neon|Ride"] = 72.19, ["Mega"] = 47.24, ["Mega|Fly"] = 210, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 3.08, ["Fly"] = 108.43, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Mega"] = 310.09, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 5.87, ["Ride"] = 44.01, ["Fly|Ride"] = 131.25, ["Neon"] = 27.19, ["Neon|Ride"] = 82.05, ["Neon|Fly|Ride"] = 143.73, ["Mega"] = 178.5, ["Mega|Ride"] = 198.2, ["Mega|Fly|Ride"] = 358.96}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.6, ["Neon"] = 6.46, ["Neon|Ride"] = 94.32, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 77.44, ["Mega|Fly|Ride"] = 870.55}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.69, ["Fly|Ride"] = 51.98, ["Neon"] = 3.84, ["Neon|Ride"] = 26.03, ["Neon|Fly|Ride"] = 99.8, ["Mega"] = 41.99, ["Mega|Ride"] = 99.68, ["Mega|Fly|Ride"] = 235.99}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 27.5, ["Ride"] = 20.09, ["Fly|Ride"] = 57.74, ["Neon"] = 17.87, ["Neon|Fly"] = 103, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 116, ["Mega"] = 156.16, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 32.82, ["Fly"] = 72.65, ["Ride"] = 26.92, ["Fly|Ride"] = 78.75, ["Neon"] = 144.35, ["Neon|Ride"] = 98.15, ["Mega"] = 459.38, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 655.07}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 58.62, ["Ride"] = 57.75, ["Fly|Ride"] = 139.13, ["Neon"] = 367.4, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2153.86, ["Mega|Ride"] = 1625.97, ["Mega|Fly|Ride"] = 1457.98}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.41, ["Fly|Ride"] = 144.38, ["Neon"] = 3.94, ["Neon|Fly"] = 16.28, ["Neon|Ride"] = 34.37, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 32.45, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.42, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.64, ["Fly|Ride"] = 43.24, ["Neon"] = 4.27, ["Neon|Fly"] = 36.86, ["Neon|Ride"] = 20.89, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 40.64, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 15.75, ["Fly|Ride"] = 65.62, ["Neon"] = 40.67, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 549.6, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 432.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 472.5, ["Ride"] = 496.49, ["Fly|Ride"] = 446.25, ["Neon"] = 4336.41, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 5906.25}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.41, ["Fly"] = 99.74, ["Ride"] = 52.49, ["Fly|Ride"] = 115.33, ["Neon"] = 217.74, ["Neon|Ride"] = 226.62, ["Neon|Fly|Ride"] = 170.63}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 287.81, ["Neon"] = 9.19, ["Neon|Ride"] = 49.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 67.97, ["Mega|Ride"] = 118.59, ["Mega|Fly|Ride"] = 294.71}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 84.7, ["Ride"] = 54.66, ["Fly|Ride"] = 261.97, ["Neon"] = 72.35, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 26.16, ["Fly"] = 169.31, ["Ride"] = 33.28, ["Fly|Ride"] = 101.92, ["Neon"] = 194.25, ["Neon|Ride"] = 219.45, ["Neon|Fly|Ride"] = 286.18, ["Mega|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.05, ["Fly"] = 188.65, ["Ride"] = 128.62, ["Fly|Ride"] = 175.48, ["Neon"] = 430.1, ["Neon|Fly"] = 823.94, ["Neon|Ride"] = 578.86, ["Neon|Fly|Ride"] = 610.32, ["Mega"] = 3180.38, ["Mega|Fly|Ride"] = 6504.61}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.92, ["Ride"] = 262.5, ["Fly|Ride"] = 540.99, ["Neon"] = 771.75, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 10.4, ["Ride"] = 53.55, ["Fly|Ride"] = 59.07, ["Neon"] = 98.44, ["Neon|Ride"] = 87.93, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 818.12, ["Mega|Ride"] = 404.04, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 16.41, ["Fly|Ride"] = 38.07, ["Neon"] = 7.88, ["Neon|Ride"] = 23.5, ["Neon|Fly|Ride"] = 84, ["Mega"] = 80.89, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 158.82}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.46, ["Fly"] = 40.69, ["Ride"] = 20.55, ["Fly|Ride"] = 63, ["Neon"] = 33.97, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.36, ["Neon|Fly|Ride"] = 142.38, ["Mega"] = 275.35, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 317.63, ["Ride"] = 350.44, ["Fly|Ride"] = 721.88, ["Neon"] = 1562.54, ["Neon|Ride"] = 2059.56, ["Neon|Fly|Ride"] = 2024.88, ["Mega"] = 10839.72, ["Mega|Fly|Ride"] = 5089.86}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.47, ["Neon"] = 9.1, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 27.77, ["Mega|Ride"] = 91.88}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.83, ["Ride"] = 15.75, ["Fly|Ride"] = 42.69, ["Neon"] = 22.32, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 98.04, ["Mega"] = 211.39, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.02, ["Fly"] = 6562.5, ["Ride"] = 59.07, ["Neon"] = 94.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 302.55, ["Mega"] = 551.25, ["Mega|Ride"] = 649.69, ["Mega|Fly|Ride"] = 723.11}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 114.19, ["Fly"] = 157.5, ["Ride"] = 126, ["Fly|Ride"] = 157.5, ["Neon|Ride"] = 818.12, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2920.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 16.76, ["Fly"] = 38.37, ["Ride"] = 28.47, ["Fly|Ride"] = 58.96, ["Neon"] = 143.07, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 114.71, ["Mega"] = 875.44, ["Mega|Ride"] = 422.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 62.44, ["Neon"] = 3.82, ["Neon|Ride"] = 81.31, ["Mega"] = 26.09, ["Mega|Ride"] = 123.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 17.06, ["Fly|Ride"] = 86.57, ["Neon"] = 3.03, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 84.34, ["Mega"] = 24.68, ["Mega|Fly"] = 101.91, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 131.15}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.81, ["Ride"] = 78.73, ["Fly|Ride"] = 311.16, ["Neon"] = 38.58, ["Neon|Ride"] = 105.86, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 164.37, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1155, ["Fly"] = 1530.93, ["Ride"] = 1312.5, ["Fly|Ride"] = 1181.25, ["Neon"] = 3281.25, ["Neon|Ride"] = 4265.44, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 12337.5}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 413.31, ["Ride"] = 459.38, ["Fly|Ride"] = 577.5, ["Neon"] = 1680, ["Neon|Ride"] = 2024.88, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6543.18}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 311.83, ["Fly"] = 414.64, ["Ride"] = 353.14, ["Fly|Ride"] = 437.63, ["Neon"] = 787.5, ["Neon|Fly"] = 1145.74, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 818.12, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 236.73, ["Fly"] = 331.74, ["Ride"] = 283.48, ["Fly|Ride"] = 363.16, ["Neon"] = 647.07, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 3302.18}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 21.7, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 5.2, ["Neon|Ride"] = 34.76, ["Neon|Fly|Ride"] = 105, ["Mega"] = 55.13, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 278.77, ["Fly"] = 466.15, ["Ride"] = 301.88, ["Fly|Ride"] = 360.94, ["Neon"] = 1050, ["Neon|Ride"] = 1359.31, ["Neon|Fly|Ride"] = 1637.56, ["Mega"] = 21968.87, ["Mega|Ride"] = 5492.5, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 8.38, ["Fly"] = 183.75, ["Ride"] = 52.49, ["Neon"] = 38.66, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 291.29, ["Mega"] = 175.88, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 21.7, ["Fly|Ride"] = 39.38, ["Neon"] = 6.22, ["Neon|Ride"] = 55.3, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 117.84, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 159.12}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.76, ["Mega"] = 21.86, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.38, ["Ride"] = 91.88, ["Fly|Ride"] = 459.38, ["Neon"] = 199.5, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 983.29}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8178.37, ["Ride"] = 19.69, ["Fly|Ride"] = 68.25, ["Neon"] = 23.62, ["Neon|Ride"] = 62.37, ["Mega"] = 359.89, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 55.13, ["Neon"] = 3.75, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.69, ["Mega|Ride"] = 164.37, ["Mega|Fly|Ride"] = 96.37}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.77, ["Fly"] = 86, ["Ride"] = 41.1, ["Fly|Ride"] = 85.32, ["Neon"] = 24.86, ["Neon|Fly"] = 116, ["Neon|Ride"] = 54.5, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 157.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 307.65}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.68, ["Fly"] = 32.43, ["Ride"] = 22.31, ["Fly|Ride"] = 46.87, ["Neon"] = 28.87, ["Neon|Fly"] = 147.21, ["Neon|Ride"] = 145.27, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.83, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.95}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.46, ["Fly"] = 27, ["Ride"] = 38.06, ["Fly|Ride"] = 147.21, ["Neon"] = 27.57, ["Neon|Ride"] = 173.45, ["Neon|Fly|Ride"] = 327.51, ["Mega"] = 532.33, ["Mega|Ride"] = 811.91}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.6, ["Fly"] = 6543.18, ["Ride"] = 17.07, ["Fly|Ride"] = 131.24, ["Neon"] = 59.07, ["Neon|Ride"] = 215.4, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 366.19, ["Mega|Ride"] = 506.23, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 68.39, ["Ride"] = 16.35, ["Fly|Ride"] = 45.94, ["Neon"] = 5.15, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.18, ["Mega"] = 43.32, ["Mega|Fly|Ride"] = 164.38}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 155.98, ["Fly"] = 264.54, ["Ride"] = 170.63, ["Fly|Ride"] = 284.82, ["Neon"] = 867.29, ["Neon|Ride"] = 1026.54, ["Neon|Fly|Ride"] = 954.19, ["Mega"] = 8671.79, ["Mega|Fly|Ride"] = 4416.11}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 22.97, ["Ride"] = 13.51, ["Fly|Ride"] = 36.66, ["Neon"] = 3.73, ["Neon|Fly"] = 36.82, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 50.3, ["Mega|Fly"] = 111.3, ["Mega|Ride"] = 55.35, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 5.25, ["Ride"] = 72.65, ["Fly|Ride"] = 230.9, ["Neon"] = 64.99, ["Neon|Ride"] = 133.51, ["Neon|Fly|Ride"] = 785.01, ["Mega"] = 334.69, ["Mega|Ride"] = 303.85, ["Mega|Fly|Ride"] = 385.91}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 29.9, ["Ride"] = 101.92, ["Fly|Ride"] = 183.75, ["Neon"] = 189, ["Neon|Ride"] = 302.96, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 786.19, ["Mega|Ride"] = 918.74, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 181.27, ["Fly"] = 223.13, ["Ride"] = 245.44, ["Fly|Ride"] = 301.87, ["Neon"] = 812.4, ["Neon|Ride"] = 702.19, ["Neon|Fly|Ride"] = 851.82, ["Mega|Fly|Ride"] = 3615.48}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 11.81, ["Fly"] = 131.28, ["Ride"] = 150.06, ["Neon"] = 168, ["Neon|Ride"] = 176.65, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 265.04, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 405.46}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 8.47, ["Ride"] = 57.74, ["Fly|Ride"] = 147.9, ["Neon"] = 145.28, ["Neon|Fly"] = 164.38, ["Neon|Ride"] = 202.72, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 1734.36, ["Mega|Ride"] = 1446.04, ["Mega|Fly|Ride"] = 719.86}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 944.9, ["Fly"] = 1226.71, ["Ride"] = 1017.06, ["Fly|Ride"] = 1029, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 5116.36, ["Mega|Fly|Ride"] = 17331.51}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.35, ["Fly"] = 26.24, ["Ride"] = 19.26, ["Fly|Ride"] = 45.93, ["Neon"] = 47.25, ["Neon|Fly"] = 68.58, ["Neon|Ride"] = 49.13, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 231.98, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 2.35, ["Fly"] = 78.75, ["Ride"] = 49.87, ["Fly|Ride"] = 135.19, ["Neon"] = 27.91, ["Neon|Ride"] = 84.57, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 212.47, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 332.48}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 77.44, ["Ride"] = 28.28, ["Fly|Ride"] = 105, ["Neon"] = 9.19, ["Neon|Ride"] = 47.85, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 360.34, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 13.1, ["Ride"] = 34.04, ["Fly|Ride"] = 115.57, ["Neon"] = 67.99, ["Neon|Fly"] = 188.36, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 446.23, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 434.51}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.05, ["Ride"] = 21.58, ["Fly|Ride"] = 59.07, ["Neon"] = 14.48, ["Neon|Fly"] = 41.02, ["Neon|Ride"] = 31.76, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 145.69, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.29}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Ride"] = 20.72, ["Neon"] = 9.18, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 131.15, ["Mega|Ride"] = 188.62, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 262.49, ["Fly|Ride"] = 433.13, ["Neon"] = 939.92, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3937.46}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 4.35, ["Fly"] = 32.82, ["Ride"] = 26.16, ["Fly|Ride"] = 145.28, ["Neon"] = 7.76, ["Neon|Ride"] = 58.97, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 65.51, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 344.76}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.93, ["Ride"] = 84.57, ["Fly|Ride"] = 88.86, ["Neon"] = 19.2, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 346.89}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 3.39, ["Fly"] = 94.75, ["Ride"] = 32.82, ["Neon"] = 15.75, ["Neon|Ride"] = 71.55, ["Mega"] = 93.19, ["Mega|Ride"] = 120.56, ["Mega|Fly|Ride"] = 504.2}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 82.69, ["Ride"] = 131.24, ["Fly|Ride"] = 249.38, ["Neon"] = 419.5, ["Neon|Ride"] = 433.6, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 2601.55, ["Mega|Ride"] = 4335.9, ["Mega|Fly|Ride"] = 1539.44}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 22.31, ["Fly"] = 88.08, ["Ride"] = 26.25, ["Fly|Ride"] = 269.9, ["Neon"] = 141.75, ["Neon|Ride"] = 289.33, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 656.25, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 893.31}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.65, ["Fly"] = 242.89, ["Ride"] = 42, ["Fly|Ride"] = 115.81, ["Neon"] = 80.56, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 609, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.62, ["Ride"] = 71.58, ["Neon"] = 15.53, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 131.25, ["Mega|Ride"] = 173.45, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 32.68, ["Fly"] = 63, ["Ride"] = 71.28, ["Fly|Ride"] = 139.13, ["Neon"] = 318.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.58, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1011.71}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 78.75, ["Neon"] = 4.6, ["Neon|Fly|Ride"] = 129.01, ["Mega"] = 71.55, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.49, ["Fly"] = 39.38, ["Ride"] = 32.82, ["Fly|Ride"] = 93.24, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 82.19, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 433.65}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.92, ["Fly"] = 203.41, ["Ride"] = 81.38, ["Fly|Ride"] = 118.13, ["Neon"] = 262.5, ["Neon|Fly"] = 433.6, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 359.62, ["Mega|Ride"] = 2024.88, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.46, ["Ride"] = 16.25, ["Fly|Ride"] = 41.24, ["Neon"] = 2.1, ["Neon|Fly"] = 21.7, ["Neon|Ride"] = 16.93, ["Neon|Fly|Ride"] = 45.04, ["Mega"] = 20.5, ["Mega|Ride"] = 40.82, ["Mega|Fly|Ride"] = 83.51}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.88, ["Fly"] = 105, ["Ride"] = 23.63, ["Fly|Ride"] = 64.31, ["Neon"] = 18.92, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 287.7, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 380.28}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 13.01, ["Fly"] = 43.38, ["Ride"] = 41.57, ["Fly|Ride"] = 116.82, ["Neon"] = 110.97, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 271.38, ["Mega"] = 708.93, ["Mega|Ride"] = 454.77, ["Mega|Fly|Ride"] = 588.82}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.37, ["Neon"] = 2.1, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 21, ["Mega|Ride"] = 54.22, ["Mega|Fly|Ride"] = 216.84}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 29.3, ["Fly"] = 210, ["Ride"] = 45.94, ["Fly|Ride"] = 215.45, ["Neon"] = 145.86, ["Neon|Ride"] = 166.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 646.61, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 646.06, ["Mega|Fly|Ride"] = 704.68}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 13.55, ["Fly"] = 43.38, ["Ride"] = 26.25, ["Fly|Ride"] = 95.42, ["Neon"] = 376.69, ["Neon|Ride"] = 121.8, ["Neon|Fly|Ride"] = 166.94, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.4, ["Ride"] = 55.88, ["Neon"] = 43.32, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 82.06, ["Neon|Fly|Ride"] = 723.02, ["Mega"] = 233.61, ["Mega|Ride"] = 327.05, ["Mega|Fly|Ride"] = 486.77}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 8.31, ["Fly"] = 72.19, ["Ride"] = 68.16, ["Fly|Ride"] = 242.19, ["Neon"] = 39.37, ["Neon|Ride"] = 88.91, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 247.11, ["Mega|Ride"] = 490.63, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.75, ["Fly|Ride"] = 196.88, ["Neon"] = 10.29, ["Neon|Ride"] = 37.43, ["Mega"] = 69.57, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 58.9, ["Neon"] = 3.15, ["Neon|Ride"] = 43.21, ["Neon|Fly|Ride"] = 145.29, ["Mega"] = 65.5, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 219.19}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 20.93}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 49.38, ["Fly"] = 101.07, ["Ride"] = 52.5, ["Fly|Ride"] = 91.87, ["Neon"] = 182.44, ["Neon|Ride"] = 216.81, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.58}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly|Ride"] = 108.43, ["Neon"] = 2.52, ["Neon|Ride"] = 37.95, ["Mega"] = 21, ["Mega|Ride"] = 115.32, ["Mega|Fly|Ride"] = 325.25}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Ride"] = 525, ["Fly|Ride"] = 674.7, ["Neon"] = 2891.31, ["Neon|Ride"] = 2709.94, ["Neon|Fly|Ride"] = 2600.46, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.69, ["Fly"] = 48.86, ["Ride"] = 33.73, ["Fly|Ride"] = 66.13, ["Neon"] = 46.5, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.9, ["Mega"] = 327.51, ["Mega|Ride"] = 195.57, ["Mega|Fly|Ride"] = 636.39}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.26, ["Fly"] = 26.25, ["Ride"] = 23.6, ["Fly|Ride"] = 58.9, ["Neon"] = 26.17, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 140.94, ["Mega|Fly"] = 289.44, ["Mega|Ride"] = 164.37, ["Mega|Fly|Ride"] = 225.75}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 10.18, ["Ride"] = 38.07, ["Neon"] = 112.87, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 313.69, ["Mega"] = 527.9, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 506.29}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.41, ["Fly"] = 58.56, ["Ride"] = 38.56, ["Fly|Ride"] = 72.65, ["Neon"] = 39.25, ["Neon|Fly"] = 72.64, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 506.29}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 11.82, ["Ride"] = 59.07, ["Fly|Ride"] = 196.88, ["Neon"] = 72.19, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 143.1, ["Mega"] = 536.59, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 500.18}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.14, ["Ride"] = 25.99, ["Fly|Ride"] = 91.88, ["Neon"] = 29.88, ["Neon|Ride"] = 82.19, ["Neon|Fly|Ride"] = 279.68, ["Mega"] = 227.07, ["Mega|Ride"] = 277.65, ["Mega|Fly|Ride"] = 349.13}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.57, ["Ride"] = 13.13, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 16.42, ["Mega|Fly"] = 66.25, ["Mega|Ride"] = 49.08, ["Mega|Fly|Ride"] = 97.79}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.83, ["Fly"] = 19.69, ["Ride"] = 56.43, ["Fly|Ride"] = 108.43, ["Neon"] = 44.68, ["Neon|Fly"] = 122.67, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 212.17, ["Mega|Ride"] = 275.35, ["Mega|Fly|Ride"] = 415.42}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 258.56, ["Ride"] = 288.75, ["Fly|Ride"] = 383.84, ["Neon"] = 1156.75, ["Neon|Ride"] = 1043.44, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 9518.02, ["Mega|Fly|Ride"] = 4329.94}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 87.84, ["Ride"] = 140.44, ["Fly|Ride"] = 258.03, ["Neon"] = 458.07, ["Neon|Fly"] = 928.01, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 525, ["Mega"] = 2313.21, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1827}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.03, ["Ride"] = 15.75, ["Fly|Ride"] = 36.75, ["Neon"] = 7.33, ["Neon|Fly"] = 101.91, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 80.97, ["Mega"] = 145.27, ["Mega|Fly"] = 215.73, ["Mega|Ride"] = 108.41, ["Mega|Fly|Ride"] = 260.54}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 23.71, ["Ride"] = 14.43, ["Fly|Ride"] = 35.44, ["Neon"] = 8.71, ["Neon|Fly"] = 27.6, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 59.06, ["Mega"] = 51.19, ["Mega|Fly"] = 289.44, ["Mega|Ride"] = 89.65, ["Mega|Fly|Ride"] = 144.34}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.02, ["Fly"] = 101.92, ["Ride"] = 22.32, ["Fly|Ride"] = 98.44, ["Neon"] = 105, ["Neon|Ride"] = 42.95, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 332.05, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.98, ["Fly"] = 327.54, ["Ride"] = 246.11, ["Fly|Ride"] = 315, ["Neon"] = 1192.52, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1055.8, ["Mega|Ride"] = 8671.79, ["Mega|Fly|Ride"] = 3615.48}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 31.65, ["Ride"] = 16.69, ["Fly|Ride"] = 43.08, ["Neon"] = 15.16, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 5.4, ["Ride"] = 75.64, ["Fly|Ride"] = 216.01, ["Neon"] = 24.47, ["Neon|Ride"] = 110.58, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 264.95, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 432.57}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.81, ["Neon|Ride"] = 137.82, ["Mega"] = 103.95}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.71, ["Fly"] = 50.15, ["Ride"] = 27.44, ["Fly|Ride"] = 57.82, ["Neon"] = 65.63, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 190.31, ["Mega"] = 328.13, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 655.07}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 31.08, ["Ride"] = 100.82, ["Fly|Ride"] = 289.91, ["Neon"] = 102.27, ["Neon|Fly"] = 655.95, ["Neon|Ride"] = 178.49, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 567.91, ["Mega|Fly"] = 2276.35, ["Mega|Ride"] = 486.33, ["Mega|Fly|Ride"] = 668.35}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 23.55, ["Fly"] = 26.25, ["Ride"] = 47.7, ["Fly|Ride"] = 91.88, ["Neon"] = 155.8, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 223.12, ["Mega"] = 867.19, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.7, ["Ride"] = 13.75, ["Fly|Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 13.13, ["Mega|Fly"] = 43.21, ["Mega|Ride"] = 27.18, ["Mega|Fly|Ride"] = 89.25}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 230.24, ["Ride"] = 246.75, ["Fly|Ride"] = 297.05, ["Neon"] = 3434.75, ["Neon|Ride"] = 1185.89, ["Neon|Fly|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 4332.07}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.27, ["Fly"] = 101.18, ["Ride"] = 23.12, ["Fly|Ride"] = 92.94, ["Neon"] = 21, ["Neon|Ride"] = 66.25, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 380.63, ["Mega|Ride"] = 578.86, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.35, ["Ride"] = 18.77, ["Fly|Ride"] = 50.71, ["Neon"] = 3.93, ["Neon|Fly"] = 36.67, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 108.41, ["Mega"] = 62.57, ["Mega|Fly"] = 231.98, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 201.41}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 32.54, ["Ride"] = 18.4, ["Fly|Ride"] = 82.05, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.16, ["Neon|Fly|Ride"] = 58.55, ["Mega"] = 37.95, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 163.71}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 72.18, ["Neon"] = 12.38, ["Neon|Fly"] = 736.03, ["Neon|Ride"] = 53.32, ["Mega"] = 155.54, ["Mega|Ride"] = 140.09, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.07, ["Fly"] = 47.23, ["Ride"] = 26.14, ["Fly|Ride"] = 81.33, ["Neon"] = 47.25, ["Neon|Fly"] = 246.07, ["Neon|Ride"] = 47.16, ["Neon|Fly|Ride"] = 143.1, ["Mega"] = 288.14, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 374.07}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 53.82, ["Ride"] = 101.92, ["Neon"] = 111.57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 253.67, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 57.75, ["Neon"] = 2.3, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 108.34, ["Mega"] = 19.48, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 169.31}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 8.48, ["Fly"] = 83.99, ["Ride"] = 33.88, ["Fly|Ride"] = 103.01, ["Neon"] = 38.21, ["Neon|Fly"] = 102.8, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 160.13, ["Mega|Ride"] = 319.6, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.49, ["Neon"] = 3.71, ["Neon|Fly"] = 116, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.17, ["Mega|Ride"] = 122.5, ["Mega|Fly|Ride"] = 202.74}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 50.68, ["Ride"] = 17.28, ["Fly|Ride"] = 44.63, ["Neon"] = 5.25, ["Neon|Ride"] = 24.92, ["Neon|Fly|Ride"] = 131.02, ["Mega"] = 45.92, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 207.09}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 623.44, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3434.34, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 16.48, ["Ride"] = 16.8, ["Fly|Ride"] = 34.13, ["Neon"] = 18.38, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 27.28, ["Neon|Fly|Ride"] = 85.31}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.63, ["Ride"] = 57.65, ["Neon"] = 9.19, ["Neon|Fly"] = 758.89, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 89.25, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 163.59, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.64, ["Fly"] = 23.62, ["Ride"] = 21.87, ["Fly|Ride"] = 48.57, ["Neon"] = 41.73, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 104.99, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.34, ["Fly|Ride"] = 36.75, ["Neon"] = 8.78, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 16.28, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 62.89, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 36.75, ["Ride"] = 59.07, ["Fly|Ride"] = 324.16, ["Neon"] = 236.25, ["Neon|Ride"] = 288.35, ["Mega"] = 752.3, ["Mega|Ride"] = 758.79, ["Mega|Fly|Ride"] = 771.89}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 24.92, ["Fly|Ride"] = 84, ["Neon"] = 9.18, ["Neon|Fly"] = 139.86, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 119.44, ["Mega"] = 47.24, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 279.57}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 19.69, ["Fly|Ride"] = 78.9, ["Neon"] = 13.11, ["Neon|Ride"] = 68.25, ["Mega"] = 113.9, ["Mega|Ride"] = 198.59, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.38, ["Fly|Ride"] = 65.83, ["Neon"] = 11.7, ["Mega"] = 97.12, ["Mega|Ride"] = 92.37, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 15.65, ["Fly|Ride"] = 69.21, ["Neon"] = 3.94, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 23.26, ["Neon|Fly|Ride"] = 108.15, ["Mega"] = 44.72, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 134.44}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 10.28, ["Fly"] = 22.16, ["Ride"] = 18.38, ["Fly|Ride"] = 39.79, ["Neon"] = 118.13, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 140.94, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 456.16}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 724.5, ["Fly"] = 1084.12, ["Ride"] = 773.05, ["Fly|Ride"] = 780.94, ["Neon"] = 1884.37, ["Neon|Ride"] = 1785, ["Neon|Fly|Ride"] = 2164.32, ["Mega"] = 8671.79, ["Mega|Ride"] = 5701.7, ["Mega|Fly|Ride"] = 4508.44}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 16.37, ["Fly|Ride"] = 45.94, ["Neon"] = 3.82, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 58.55, ["Mega|Ride"] = 90.78, ["Mega|Fly|Ride"] = 295.32}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 9.08, ["Fly"] = 26.25, ["Ride"] = 36.74, ["Fly|Ride"] = 72.65, ["Neon"] = 72.65, ["Neon|Ride"] = 216.57, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 570.93}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.03, ["Fly"] = 51.54, ["Ride"] = 70.89, ["Fly|Ride"] = 98.44, ["Neon"] = 262.5, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2439.83, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 31.5, ["Fly"] = 146.86, ["Ride"] = 49.88, ["Fly|Ride"] = 102.38, ["Neon"] = 145.28, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 1471.86, ["Mega|Ride"] = 938.44, ["Mega|Fly|Ride"] = 728.44}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.06, ["Fly"] = 95.69, ["Ride"] = 28.17, ["Fly|Ride"] = 65.63, ["Neon"] = 55.13, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 273, ["Mega"] = 305.34, ["Mega|Ride"] = 432.52, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 19.45, ["Ride"] = 59.07, ["Fly|Ride"] = 145.28, ["Neon"] = 105, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 152.25, ["Mega"] = 339.28, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 20.9, ["Ride"] = 40.69, ["Neon"] = 146.46, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 525, ["Mega"] = 536.59, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 756.72}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 3.84}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.84, ["Ride"] = 28.88, ["Fly|Ride"] = 78.75, ["Neon"] = 31.5, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 18.17, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 32.45, ["Fly"] = 62.99, ["Ride"] = 40.51, ["Fly|Ride"] = 81.92, ["Neon"] = 220.5, ["Neon|Fly"] = 289.44, ["Neon|Ride"] = 210.31, ["Neon|Fly|Ride"] = 239.54, ["Mega|Ride"] = 607.04, ["Mega|Fly|Ride"] = 676.58}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.52, ["Fly"] = 17.95, ["Ride"] = 18.1, ["Fly|Ride"] = 36.75, ["Neon"] = 33.67, ["Neon|Fly"] = 69.57, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 232.31, ["Mega|Fly"] = 432.52, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 198.17}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.12, ["Fly"] = 31.91, ["Ride"] = 24.75, ["Fly|Ride"] = 54.23, ["Neon"] = 20.97, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 220.16, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 246.75}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Mega"] = 40.69, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 26.24, ["Ride"] = 52.5, ["Fly|Ride"] = 145.28, ["Neon"] = 163.62, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 433.6, ["Mega|Ride"] = 858.52, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 58.43, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.74, ["Mega|Ride"] = 139.94}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 7.88, ["Ride"] = 87.94, ["Fly|Ride"] = 288.39, ["Neon"] = 59.07, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 250.69, ["Mega|Fly"] = 578.86, ["Mega|Ride"] = 400.77, ["Mega|Fly|Ride"] = 655.07}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.92, ["Ride"] = 16.95, ["Fly|Ride"] = 44.63, ["Neon"] = 18.11, ["Neon|Ride"] = 24.19, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 202.79, ["Mega|Fly|Ride"] = 288.39}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 18.18, ["Fly|Ride"] = 44.93, ["Neon"] = 49.65, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 613.29, ["Mega|Ride"] = 432.52, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.63, ["Ride"] = 34.7, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 50.96, ["Ride"] = 105, ["Fly|Ride"] = 480.26, ["Neon"] = 361.89, ["Neon|Ride"] = 486.72, ["Neon|Fly|Ride"] = 853.1, ["Mega|Fly|Ride"] = 1951.39}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 13.7, ["Ride"] = 78.65, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Mega"] = 393.75, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 715.98}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 8.49, ["Ride"] = 112.94, ["Neon"] = 43.38, ["Neon|Fly"] = 216.84, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 866.12}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 23.62, ["Ride"] = 105, ["Fly|Ride"] = 367.48, ["Neon"] = 134.16, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 679.66, ["Mega|Fly"] = 2167.95, ["Mega|Ride"] = 639.56, ["Mega|Fly|Ride"] = 813.09}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.35, ["Neon"] = 19.93, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 184.29, ["Mega|Ride"] = 255.14, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.57, ["Fly|Ride"] = 41.91, ["Neon"] = 3.26, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 32.97, ["Neon|Fly|Ride"] = 98.15, ["Mega"] = 69.57, ["Mega|Ride"] = 76.13, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27, ["Fly|Ride"] = 77.84, ["Neon"] = 14.97, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 89.25, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 145.28, ["Ride"] = 19.69, ["Fly|Ride"] = 71.91, ["Neon"] = 4.85, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 91.26, ["Mega"] = 52.5, ["Mega|Ride"] = 85.63, ["Mega|Fly|Ride"] = 167.76}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.3, ["Fly"] = 65.62, ["Ride"] = 19.2, ["Fly|Ride"] = 72.65, ["Neon"] = 18.47, ["Neon|Ride"] = 108.41, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 328.13, ["Mega|Ride"] = 331.71, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.94, ["Fly"] = 57.82, ["Ride"] = 24.54, ["Fly|Ride"] = 433.65, ["Neon"] = 30.19, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 307.86, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1084.12}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 3.48, ["Fly"] = 131.25, ["Ride"] = 19.69, ["Fly|Ride"] = 56.36, ["Neon"] = 32.63, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 82.69, ["Mega"] = 306.66, ["Mega|Ride"] = 292.68, ["Mega|Fly|Ride"] = 466.59}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.48, ["Ride"] = 21.7, ["Fly|Ride"] = 52.41, ["Neon"] = 26.25, ["Neon|Ride"] = 69.08, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 268.84, ["Mega|Ride"] = 315.67, ["Mega|Fly|Ride"] = 186.18}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.82, ["Fly"] = 288.72, ["Ride"] = 47.22, ["Fly|Ride"] = 131.25, ["Neon"] = 13.69, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 202.72, ["Mega"] = 118.13, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 269.98}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 16.28, ["Fly"] = 113.85, ["Ride"] = 102.55, ["Fly|Ride"] = 330.75, ["Neon"] = 147, ["Neon|Fly"] = 288.75, ["Neon|Ride"] = 262.49, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 791.2, ["Mega|Fly|Ride"] = 648.38}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 51.83, ["Fly"] = 105, ["Ride"] = 89.99, ["Fly|Ride"] = 165.38, ["Neon"] = 240.9, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 336, ["Mega"] = 1589.12, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1369.67}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.58, ["Fly|Ride"] = 52.05, ["Neon"] = 2.3, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 27.54, ["Mega|Ride"] = 71.04, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 10.22, ["Neon"] = 105.94, ["Mega"] = 686.56, ["Mega|Fly|Ride"] = 1142.66}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.91, ["Ride"] = 91.91, ["Neon"] = 249.37, ["Neon|Ride"] = 344.37, ["Neon|Fly|Ride"] = 866.12, ["Mega"] = 1786.4, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.17, ["Fly"] = 190.32, ["Ride"] = 25.82, ["Fly|Ride"] = 133.88, ["Neon"] = 44.63, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 127.92, ["Mega"] = 267.46, ["Mega|Fly"] = 740.84, ["Mega|Ride"] = 242.82, ["Mega|Fly|Ride"] = 271.69}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.28, ["Fly|Ride"] = 98.16, ["Neon"] = 13.13, ["Neon|Ride"] = 77.46, ["Mega"] = 91.02, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 128.94, ["Mega|Fly|Ride"] = 265.46}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 33.91, ["Ride"] = 17.07, ["Fly|Ride"] = 46.92, ["Neon"] = 14.95, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 84, ["Mega"] = 173.25, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 131.15}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 17.11, ["Ride"] = 14.39, ["Fly|Ride"] = 52.31, ["Neon"] = 2.1, ["Neon|Fly"] = 130.09, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 52.41, ["Mega"] = 23.62, ["Mega|Ride"] = 73.61, ["Mega|Fly|Ride"] = 154.8}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.58, ["Fly|Ride"] = 93.09, ["Neon"] = 4.31, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 42.73, ["Mega|Fly"] = 99.05, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 173.25}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 42.3, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.89, ["Ride"] = 157.5, ["Neon"] = 53.33, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 409.68, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 428.54}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 4.92, ["Ride"] = 26.25, ["Fly|Ride"] = 215.91, ["Neon"] = 58.62, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 285.48, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 334.69}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 5.71, ["Fly"] = 24.54, ["Ride"] = 18.17, ["Fly|Ride"] = 49.73, ["Neon"] = 30.19, ["Neon|Fly"] = 116.02, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 91.87, ["Mega"] = 351.22, ["Mega|Ride"] = 311.37, ["Mega|Fly|Ride"] = 401.63}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 62.9, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 432.52, ["Neon|Fly|Ride"] = 723.02, ["Mega"] = 2453.11, ["Mega|Ride"] = 1633.56, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 20.53, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Fly|Ride"] = 116.02, ["Neon"] = 58.56, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1037.54}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.68, ["Ride"] = 15.54, ["Fly|Ride"] = 41.56, ["Neon"] = 2.3, ["Neon|Fly"] = 43.37, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 17.73, ["Mega|Ride"] = 93.44}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.44, ["Fly|Ride"] = 35.15, ["Neon"] = 4.98, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.07, ["Neon|Fly|Ride"] = 45.85, ["Mega"] = 54.22, ["Mega|Ride"] = 49.37, ["Mega|Fly|Ride"] = 98.99}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 406.87, ["Fly"] = 576.57, ["Ride"] = 407.38, ["Fly|Ride"] = 518.44, ["Neon"] = 1995.83, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2097.38, ["Mega|Fly|Ride"] = 6866.7}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.84, ["Ride"] = 40.69, ["Neon"] = 40.68, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.5, ["Mega|Ride"] = 721.94, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.72, ["Ride"] = 13.13, ["Fly|Ride"] = 49.88, ["Neon"] = 3.73, ["Neon|Fly"] = 19.49, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 43.05, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 115.19}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 44.51, ["Ride"] = 116.82, ["Fly|Ride"] = 286.22, ["Neon"] = 150.93, ["Neon|Ride"] = 259.51, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 737.63, ["Mega|Ride"] = 682.49, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 24.87, ["Ride"] = 21.18, ["Fly|Ride"] = 122.68, ["Neon"] = 17.73, ["Neon|Fly"] = 122.07, ["Neon|Ride"] = 29.4, ["Neon|Fly|Ride"] = 93.17, ["Mega"] = 131.25, ["Mega|Ride"] = 129.92, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 54.23, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 101.92, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 17.73, ["Mega|Ride"] = 53.81, ["Mega|Fly|Ride"] = 231.82}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 31.49, ["Fly"] = 129.94, ["Ride"] = 77.44, ["Fly|Ride"] = 215.54, ["Neon"] = 131.15, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 708.93, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 19.69, ["Fly|Ride"] = 146.99, ["Neon"] = 5.2, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 86.73, ["Mega"] = 62.89, ["Mega|Ride"] = 158.94, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.87, ["Ride"] = 61.5, ["Fly|Ride"] = 104.99, ["Neon"] = 283.23, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 288.46, ["Mega"] = 1181.25, ["Mega|Ride"] = 1300.78, ["Mega|Fly|Ride"] = 1333.83}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.84, ["Fly"] = 72.65, ["Ride"] = 131.25, ["Fly|Ride"] = 433.65, ["Neon"] = 17.42, ["Neon|Ride"] = 28.21, ["Neon|Fly|Ride"] = 164.37, ["Mega"] = 169.32, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 72.65, ["Ride"] = 79.7, ["Fly|Ride"] = 58.56, ["Neon"] = 11.29, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 117.6, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 55.12, ["Fly"] = 188.65, ["Ride"] = 111.57, ["Fly|Ride"] = 163.24, ["Neon|Ride"] = 419.11, ["Mega"] = 2024.88, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2025.11}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.48, ["Ride"] = 29.4, ["Neon"] = 8.88, ["Neon|Ride"] = 57.67, ["Neon|Fly|Ride"] = 116, ["Mega"] = 47.16, ["Mega|Fly"] = 216.81, ["Mega|Ride"] = 89.24, ["Mega|Fly|Ride"] = 275.38}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 19.86, ["Ride"] = 19.49, ["Fly|Ride"] = 36.87, ["Neon"] = 10.5, ["Neon|Fly"] = 42, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 73.33, ["Mega"] = 59.13, ["Mega|Fly"] = 150.89, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.43}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 15.4, ["Fly"] = 57.91, ["Ride"] = 37.26, ["Fly|Ride"] = 195.96, ["Neon"] = 80.21, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 196.26, ["Mega"] = 328.12, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 355.61}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 9.61, ["Fly"] = 43.38, ["Ride"] = 31.5, ["Fly|Ride"] = 65.92, ["Neon"] = 52.41, ["Neon|Ride"] = 81.15, ["Neon|Fly|Ride"] = 139.81, ["Mega"] = 354.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 22.16, ["Fly"] = 51.19, ["Ride"] = 32.16, ["Fly|Ride"] = 66.25, ["Neon"] = 91, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 149.93, ["Mega"] = 408.98, ["Mega|Ride"] = 327.44, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 70.88, ["Ride"] = 115.49, ["Fly|Ride"] = 196.88, ["Neon"] = 257.25, ["Neon|Ride"] = 283.5, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 1575, ["Mega|Ride"] = 1647.65, ["Mega|Fly|Ride"] = 1633.56}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.88, ["Ride"] = 115.4, ["Fly|Ride"] = 101.92, ["Neon"] = 61.02, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 299.25, ["Mega"] = 241.5, ["Mega|Fly"] = 576.69, ["Mega|Ride"] = 404.25, ["Mega|Fly|Ride"] = 607.11}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.5, ["Ride"] = 29.29, ["Fly|Ride"] = 78.73, ["Neon"] = 20.9, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 163.7, ["Mega|Ride"] = 173.45, ["Mega|Fly|Ride"] = 490.69}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 10.95, ["Fly"] = 135.19, ["Ride"] = 36.38, ["Fly|Ride"] = 115.5, ["Neon"] = 57.66, ["Neon|Ride"] = 112.75, ["Neon|Fly|Ride"] = 175.1, ["Mega"] = 249.38, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 10.85, ["Ride"] = 11.71, ["Fly|Ride"] = 41.49, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 55.11, ["Mega"] = 14.44, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.8, ["Mega|Fly|Ride"] = 115.48}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 47.16, ["Fly"] = 164.07, ["Ride"] = 102.38, ["Neon"] = 236.15, ["Neon|Fly"] = 2457.38, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 487.8, ["Mega"] = 1083.98, ["Mega|Ride"] = 1097.77, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.04, ["Neon"] = 7.64, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 87.09, ["Mega|Fly|Ride"] = 313.68}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.15, ["Ride"] = 15.75, ["Fly|Ride"] = 45.94, ["Neon"] = 18.25, ["Neon|Ride"] = 25.93, ["Neon|Fly|Ride"] = 64.31, ["Mega"] = 257.25, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 57.17, ["Fly"] = 108.43, ["Ride"] = 72.19, ["Fly|Ride"] = 170.63, ["Neon"] = 196.88, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 325.2, ["Mega"] = 836.14, ["Mega|Ride"] = 1145.62, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Neon"] = 8.9, ["Neon|Ride"] = 1446.04, ["Mega"] = 69.39, ["Mega|Fly"] = 159.47, ["Mega|Ride"] = 116.81, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 2.63}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 32.96, ["Fly|Ride"] = 71.53, ["Neon"] = 6.18, ["Neon|Ride"] = 21.68, ["Neon|Fly|Ride"] = 119.43, ["Mega"] = 103.59, ["Mega|Fly"] = 188.62, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.14, ["Ride"] = 196.08, ["Fly|Ride"] = 340.43, ["Neon"] = 637.9, ["Neon|Ride"] = 580.91, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6503.84, ["Mega|Ride"] = 3271.22, ["Mega|Fly|Ride"] = 2648.47}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 5.01, ["Ride"] = 36.87, ["Fly|Ride"] = 122.68, ["Neon"] = 23.35, ["Neon|Fly"] = 145.27, ["Neon|Ride"] = 65.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 178.48, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 99.94, ["Neon"] = 3.78, ["Neon|Ride"] = 20.68, ["Mega"] = 36.75, ["Mega|Fly"] = 65.63, ["Mega|Ride"] = 71.15, ["Mega|Fly|Ride"] = 346.65}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.66, ["Ride"] = 32.82, ["Fly|Ride"] = 131.25, ["Neon"] = 57.67, ["Neon|Ride"] = 89.63, ["Neon|Fly|Ride"] = 160.43, ["Mega"] = 298.11, ["Mega|Ride"] = 419.51, ["Mega|Fly|Ride"] = 669.99}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.74, ["Fly"] = 40.47, ["Ride"] = 22.32, ["Fly|Ride"] = 58.54, ["Neon"] = 101.03, ["Neon|Ride"] = 184.42, ["Neon|Fly|Ride"] = 197.54, ["Mega"] = 634.1, ["Mega|Ride"] = 646.06, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 20.68, ["Ride"] = 55.13, ["Fly|Ride"] = 172.5, ["Neon"] = 128.63, ["Neon|Ride"] = 188.62, ["Neon|Fly|Ride"] = 329.55, ["Mega"] = 561.75, ["Mega|Ride"] = 509.8, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 157.5, ["Fly"] = 196.77, ["Ride"] = 191.61, ["Fly|Ride"] = 249.26, ["Neon"] = 577.5, ["Neon|Fly"] = 785.1, ["Neon|Ride"] = 566.9, ["Neon|Fly|Ride"] = 643.02, ["Mega|Fly|Ride"] = 2325.83}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.92, ["Fly"] = 23.05, ["Ride"] = 21.7, ["Fly|Ride"] = 43.53, ["Neon"] = 50.3, ["Neon|Fly"] = 58.55, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 86.63, ["Mega|Fly|Ride"] = 368.03}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 27.77, ["Fly|Ride"] = 65.63, ["Neon"] = 18.74, ["Neon|Ride"] = 39.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 140.36, ["Mega|Ride"] = 188.62, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 4.72, ["Fly"] = 23.63, ["Ride"] = 37.7, ["Fly|Ride"] = 90.56, ["Neon"] = 28.88, ["Neon|Fly"] = 72.64, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 458.07, ["Mega|Ride"] = 429.85, ["Mega|Fly|Ride"] = 1307.44}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 41.99, ["Fly"] = 110.42, ["Ride"] = 64.2, ["Fly|Ride"] = 133.37, ["Neon"] = 209.99, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 229.32, ["Neon|Fly|Ride"] = 257.28, ["Mega"] = 955, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 958.12}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.75, ["Fly"] = 57.75, ["Ride"] = 261.06, ["Neon"] = 185.24, ["Neon|Ride"] = 260.16, ["Neon|Fly|Ride"] = 478.05, ["Mega"] = 809.74, ["Mega|Ride"] = 1932, ["Mega|Fly|Ride"] = 823.94}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.75, ["Ride"] = 350.44, ["Neon"] = 1636.43, ["Neon|Ride"] = 3271.22, ["Mega|Fly|Ride"] = 5203.7}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 21, ["Fly"] = 58.64, ["Ride"] = 33.92, ["Fly|Ride"] = 69.45, ["Neon"] = 215.91, ["Neon|Ride"] = 130.01, ["Neon|Fly|Ride"] = 201.64, ["Mega"] = 761.25, ["Mega|Ride"] = 753.27, ["Mega|Fly|Ride"] = 844.91}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 43.38, ["Ride"] = 13.13, ["Fly|Ride"] = 70.17, ["Neon"] = 2.2, ["Neon|Ride"] = 15.73, ["Neon|Fly|Ride"] = 43.37, ["Mega"] = 21, ["Mega|Fly"] = 114.92, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 117.47}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.57, ["Ride"] = 29.29, ["Neon"] = 15.44, ["Neon|Ride"] = 86.73, ["Neon|Fly|Ride"] = 164.37, ["Mega"] = 111.57, ["Mega|Ride"] = 164.18, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.02, ["Fly"] = 32.82, ["Ride"] = 30.85, ["Fly|Ride"] = 144.2, ["Neon"] = 24.68, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.62, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 377.23, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 393.75, ["Fly"] = 505.32, ["Ride"] = 418.69, ["Fly|Ride"] = 567, ["Neon"] = 1968.75, ["Neon|Ride"] = 2007.53, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 5493.14}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 3.73, ["Fly"] = 39.38, ["Ride"] = 17.03, ["Fly|Ride"] = 56.45, ["Neon"] = 26.16, ["Neon|Ride"] = 62.88, ["Neon|Fly|Ride"] = 111.13, ["Mega"] = 221.61, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 311.59}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.61, ["Fly"] = 22.32, ["Ride"] = 19.53, ["Fly|Ride"] = 42.95, ["Neon"] = 43.25, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 181.55, ["Mega|Ride"] = 289.44, ["Mega|Fly|Ride"] = 302.55}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.51, ["Fly"] = 42, ["Ride"] = 26.25, ["Fly|Ride"] = 54.76, ["Neon"] = 13.79, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.14, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 94.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.56}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 29.28, ["Fly"] = 57.67, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 220.4, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 324.13, ["Mega"] = 1300.78, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 51.19, ["Fly|Ride"] = 51.85, ["Neon"] = 11.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 457.79, ["Mega|Fly|Ride"] = 985.04}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 93.12, ["Ride"] = 27.57, ["Neon"] = 170.62, ["Neon|Ride"] = 246.07, ["Neon|Fly|Ride"] = 259.23, ["Mega"] = 748.13, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 789.25}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 4.55, ["Neon|Ride"] = 27.98, ["Neon|Fly|Ride"] = 115.32, ["Mega"] = 55.11, ["Mega|Ride"] = 145.17, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.25, ["Ride"] = 24.26, ["Neon"] = 50.97, ["Mega"] = 136.02, ["Mega|Ride"] = 327.51, ["Mega|Fly|Ride"] = 761.92}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 5.25, ["Ride"] = 33.13, ["Neon"] = 71.56, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 319.79, ["Mega|Ride"] = 562.1, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.5, ["Fly"] = 32.82, ["Ride"] = 32.37, ["Fly|Ride"] = 56.39, ["Neon"] = 51.19, ["Neon|Fly"] = 42, ["Neon|Ride"] = 56.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 540.92, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 462, ["Fly"] = 607.23, ["Ride"] = 440.46, ["Fly|Ride"] = 522.38, ["Neon"] = 1642.41, ["Neon|Ride"] = 1962.49, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7458.62}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 16.28, ["Fly|Ride"] = 39.37, ["Neon"] = 29.46, ["Neon|Fly"] = 82.19, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 164.73, ["Mega"] = 246.07, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 307.91}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.57, ["Fly"] = 71.56, ["Ride"] = 78.05, ["Fly|Ride"] = 188.65, ["Neon"] = 64.32, ["Neon|Ride"] = 127.24, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 359.63, ["Mega|Fly"] = 723.02, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 588.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 25.64, ["Fly"] = 87.68, ["Ride"] = 90.57, ["Fly|Ride"] = 241.64, ["Neon"] = 81.03, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 350.44, ["Mega"] = 322.34, ["Mega|Ride"] = 342.57, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 55.88, ["Fly"] = 156.1, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 170.63, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2517.26, ["Mega|Ride"] = 2890.97, ["Mega|Fly|Ride"] = 1848.65}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 10.39, ["Ride"] = 46.1, ["Fly|Ride"] = 170.63, ["Neon"] = 36.2, ["Neon|Ride"] = 79.84, ["Neon|Fly|Ride"] = 268.84, ["Mega"] = 165.26, ["Mega|Ride"] = 194.15, ["Mega|Fly|Ride"] = 332.71}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.88, ["Ride"] = 17.07, ["Fly|Ride"] = 57.87, ["Neon"] = 18.22, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 202.13, ["Mega"] = 102.38, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.81, ["Ride"] = 45.69, ["Neon"] = 19.69, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 107, ["Mega|Fly"] = 246.07, ["Mega|Ride"] = 152.43, ["Mega|Fly|Ride"] = 265.44}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 43.19, ["Fly"] = 183.72, ["Ride"] = 107.33, ["Fly|Ride"] = 197.73, ["Neon"] = 118.12, ["Neon|Ride"] = 162.74, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 388.5, ["Mega|Ride"] = 446.35, ["Mega|Fly|Ride"] = 486.86}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 9.09, ["Neon|Ride"] = 101.91, ["Neon|Fly|Ride"] = 231.98, ["Mega"] = 33.13, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 433.6}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 24.94, ["Ride"] = 91.88, ["Neon"] = 118.01, ["Neon|Ride"] = 374.06, ["Mega"] = 650.4, ["Mega|Ride"] = 795.65, ["Mega|Fly|Ride"] = 797.82}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.56, ["Fly"] = 1194.38, ["Ride"] = 1008, ["Fly|Ride"] = 1017.18, ["Neon"] = 3615.48, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2859.94, ["Mega|Fly|Ride"] = 11101.19}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 16.25, ["Fly"] = 114.6, ["Ride"] = 44.18, ["Fly|Ride"] = 179.1, ["Neon"] = 65.62, ["Neon|Fly"] = 721.88, ["Neon|Ride"] = 116, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 259.87, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.87, ["Ride"] = 23.87, ["Fly|Ride"] = 96.47, ["Neon"] = 11.02, ["Neon|Ride"] = 32.71, ["Neon|Fly|Ride"] = 89.92, ["Mega"] = 64.31, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 7.88, ["Ride"] = 131.25, ["Fly|Ride"] = 145.28, ["Neon"] = 63, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 385.89, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.69, ["Neon"] = 2.1, ["Neon|Ride"] = 26.69, ["Neon|Fly|Ride"] = 101.91, ["Mega"] = 20.06, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 52.38, ["Fly"] = 130.11, ["Ride"] = 91.88, ["Fly|Ride"] = 266.44, ["Neon"] = 196.88, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 269.07, ["Mega"] = 943.05, ["Mega|Ride"] = 888.57, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 10.4, ["Ride"] = 62.89, ["Fly|Ride"] = 276.83, ["Neon"] = 156.19, ["Neon|Ride"] = 143.1, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 492.14, ["Mega|Ride"] = 847.69, ["Mega|Fly|Ride"] = 818.23}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.1, ["Ride"] = 23.2, ["Neon"] = 11.82, ["Neon|Ride"] = 40.99, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 98.14, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 485.69}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 17.36, ["Fly"] = 160.47, ["Ride"] = 40.66, ["Fly|Ride"] = 96.07, ["Neon"] = 81.37, ["Neon|Ride"] = 95.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 409.17, ["Mega|Ride"] = 419.99, ["Mega|Fly|Ride"] = 490.08}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 5.97, ["Fly"] = 97.59, ["Ride"] = 27.05, ["Fly|Ride"] = 173.46, ["Neon"] = 28.17, ["Neon|Fly"] = 131.28, ["Neon|Ride"] = 57.75, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 196.88, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 33.49, ["Ride"] = 91.88, ["Neon"] = 260.21, ["Neon|Ride"] = 260.16, ["Neon|Fly|Ride"] = 578.86, ["Mega"] = 2530, ["Mega|Ride"] = 2453.11, ["Mega|Fly|Ride"] = 2168.21}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 2.41, ["Ride"] = 49.29, ["Fly|Ride"] = 192.94, ["Neon"] = 11.46, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 651, ["Mega"] = 71.18, ["Mega|Ride"] = 111.55, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.01, ["Ride"] = 18.18, ["Fly|Ride"] = 90.57, ["Neon"] = 39.29, ["Neon|Fly"] = 188.65, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 118.02, ["Mega"] = 300.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 290.82}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 108.54, ["Fly"] = 393.75, ["Ride"] = 156.19, ["Fly|Ride"] = 260.21, ["Neon"] = 485.37, ["Neon|Ride"] = 544.69, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 2109.69}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 23.33, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 24.86, ["Neon|Fly"] = 57.32, ["Neon|Ride"] = 28.48, ["Neon|Fly|Ride"] = 65.06, ["Mega"] = 131.25, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 182.44}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 20.9, ["Fly"] = 85.32, ["Ride"] = 60.26, ["Fly|Ride"] = 101.92, ["Neon"] = 159.63, ["Neon|Ride"] = 179.71, ["Neon|Fly|Ride"] = 262.48, ["Mega"] = 578.86, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 736.26}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.27, ["Ride"] = 13.13, ["Fly|Ride"] = 64.31, ["Neon"] = 2.1, ["Neon|Fly"] = 28.92, ["Neon|Ride"] = 17.06, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 16.29, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 32.8, ["Mega|Fly|Ride"] = 70.45}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly|Ride"] = 130.09, ["Mega"] = 20.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.42}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.1, ["Fly"] = 36.85, ["Ride"] = 27.01, ["Fly|Ride"] = 173.36, ["Neon"] = 15, ["Neon|Ride"] = 58.55, ["Neon|Fly|Ride"] = 136.6, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 246.1}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 26.24, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 346.89, ["Neon|Fly|Ride"] = 399.37, ["Mega"] = 511.88, ["Mega|Ride"] = 649.31, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.64, ["Ride"] = 15.42, ["Fly|Ride"] = 32.48, ["Neon"] = 13.02, ["Neon|Fly"] = 28.86, ["Neon|Ride"] = 28.52, ["Neon|Fly|Ride"] = 57.17, ["Mega"] = 121.96, ["Mega|Fly"] = 267.22, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 171.08}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 10.49, ["Fly"] = 49.08, ["Ride"] = 38.74, ["Fly|Ride"] = 91.87, ["Neon"] = 54.6, ["Neon|Fly"] = 108.43, ["Neon|Ride"] = 55.02, ["Neon|Fly|Ride"] = 107.63, ["Mega"] = 341.25, ["Mega|Fly"] = 441.57, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 347.82}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 16.89, ["Ride"] = 18.37, ["Fly|Ride"] = 68.61, ["Neon"] = 7.95, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 33.35, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 5.16, ["Fly"] = 163.71, ["Ride"] = 24.93, ["Fly|Ride"] = 217.2, ["Neon"] = 37.7, ["Neon|Ride"] = 93.15, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 324.13, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 490.69}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.59, ["Ride"] = 52.05, ["Fly|Ride"] = 65.63, ["Neon"] = 45.94, ["Neon|Ride"] = 232.44, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 236.25, ["Mega|Ride"] = 303.19, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 39.79, ["Ride"] = 18.41, ["Fly|Ride"] = 54.8, ["Neon"] = 36.29, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 39.44, ["Neon|Fly|Ride"] = 144.19, ["Mega"] = 232.32, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 18.3, ["Ride"] = 15.31, ["Fly|Ride"] = 52.56, ["Neon"] = 19.53, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 84.57, ["Mega"] = 164.37, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 216.57, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 393.75, ["Neon"] = 1257.57, ["Neon|Ride"] = 1286.69, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4252.45, ["Mega|Fly|Ride"] = 4062.19}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.11, ["Ride"] = 105, ["Neon"] = 35.7, ["Neon|Ride"] = 45.94, ["Mega"] = 123.38, ["Mega|Ride"] = 654.99, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.36, ["Fly"] = 108.43, ["Ride"] = 20.61, ["Fly|Ride"] = 86.75, ["Neon"] = 31.29, ["Neon|Fly"] = 246.11, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 147.2, ["Mega"] = 234.15, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.41, ["Fly|Ride"] = 723.11, ["Neon"] = 45.84, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 204.1, ["Mega|Ride"] = 409.68, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 16.25, ["Fly|Ride"] = 28.01, ["Neon"] = 2.1, ["Neon|Fly"] = 21.7, ["Neon|Ride"] = 15.1, ["Neon|Fly|Ride"] = 33.13, ["Mega"] = 26.25, ["Mega|Fly"] = 81.31, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.17}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 44.89, ["Ride"] = 18.41, ["Fly|Ride"] = 103.63, ["Neon"] = 18.38, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 160.43, ["Mega|Ride"] = 200.54, ["Mega|Fly|Ride"] = 234.75}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.63, ["Ride"] = 119.85, ["Neon"] = 10.23, ["Neon|Ride"] = 289.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.5, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 286.22}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.13, ["Fly"] = 104.99, ["Ride"] = 89.81, ["Fly|Ride"] = 141.74, ["Neon"] = 315, ["Neon|Fly"] = 720.07, ["Neon|Ride"] = 409.5, ["Neon|Fly|Ride"] = 486.72, ["Mega|Ride"] = 3615.06, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.63, ["Fly"] = 72.65, ["Ride"] = 28.88, ["Fly|Ride"] = 71.43, ["Neon"] = 22.31, ["Neon|Ride"] = 68.16, ["Mega"] = 169.3, ["Mega|Ride"] = 213.94}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 49.88, ["Ride"] = 34.13, ["Neon"] = 7.22, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 550.74, ["Mega"] = 56.35, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 45.75, ["Fly"] = 85.32, ["Ride"] = 77.97, ["Fly|Ride"] = 174.36, ["Neon"] = 143.06, ["Neon|Ride"] = 176.6, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 564.38, ["Mega|Ride"] = 636.56, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 15.2, ["Fly|Ride"] = 28.88, ["Neon"] = 2.63, ["Neon|Fly"] = 22.3, ["Neon|Ride"] = 15.82, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 16.7, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 33.74, ["Mega|Fly|Ride"] = 51.18}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Fly|Ride"] = 97.59, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 41.21, ["Mega|Fly"] = 145.27, ["Mega|Ride"] = 74.72, ["Mega|Fly|Ride"] = 287.44}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 51.56, ["Fly|Ride"] = 161.34, ["Neon"] = 7.68, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.11, ["Mega"] = 62.37, ["Mega|Fly"] = 188.62, ["Mega|Ride"] = 125.53, ["Mega|Fly|Ride"] = 300.57}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.57, ["Fly"] = 101.92, ["Ride"] = 28.77, ["Fly|Ride"] = 130.73, ["Neon"] = 22.32, ["Neon|Fly"] = 101.92, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 132.4, ["Mega|Fly"] = 332.79, ["Mega|Ride"] = 433.6, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 18.79, ["Ride"] = 13.6, ["Fly|Ride"] = 43.38, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 23.34, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 19.57, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 117.91}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 20.31, ["Fly"] = 131.25, ["Ride"] = 53.27, ["Neon"] = 129.83, ["Neon|Ride"] = 202.57, ["Neon|Fly|Ride"] = 433.6, ["Mega|Ride"] = 719.99, ["Mega|Fly|Ride"] = 818.23}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 1968.75, ["Fly"] = 3150, ["Ride"] = 2244.38, ["Fly|Ride"] = 2165.63, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44990.14}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 18.41, ["Ride"] = 15.91, ["Fly|Ride"] = 53.43, ["Neon"] = 7.76, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 23.55, ["Neon|Fly|Ride"] = 65.01, ["Mega"] = 75.9, ["Mega|Fly"] = 433.6, ["Mega|Ride"] = 89.23, ["Mega|Fly|Ride"] = 152.24}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 28.21, ["Neon"] = 9.09, ["Mega"] = 98.66, ["Mega|Fly"] = 441, ["Mega|Fly|Ride"] = 490.69}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.42, ["Fly"] = 105, ["Ride"] = 19.69, ["Fly|Ride"] = 157.5, ["Neon"] = 82.21, ["Neon|Fly"] = 103, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 431.82, ["Mega|Ride"] = 405.42, ["Mega|Fly|Ride"] = 686.97}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 27.43, ["Fly"] = 108.43, ["Ride"] = 68.96, ["Neon"] = 140.44, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 245.33, ["Mega"] = 650.4, ["Mega|Ride"] = 649.31, ["Mega|Fly|Ride"] = 655.07}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.71, ["Fly"] = 1446.21, ["Ride"] = 183.75, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 758.96, ["Neon|Fly|Ride"] = 652.32, ["Mega|Fly|Ride"] = 4184.63}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 6.02, ["Ride"] = 65.54, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 144.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 380.52}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 36.87, ["Neon"] = 15.44, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 179.82, ["Mega|Ride"] = 330.65, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.92, ["Ride"] = 27.85, ["Fly|Ride"] = 72.65, ["Neon"] = 11.68, ["Neon|Fly"] = 127.95, ["Neon|Ride"] = 32.8, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 64.97, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 229.69}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.34, ["Ride"] = 70.74, ["Fly|Ride"] = 131.25, ["Neon"] = 129.94, ["Neon|Ride"] = 181.55, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 272.09, ["Mega|Ride"] = 476.61, ["Mega|Fly|Ride"] = 571.6}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 28.23, ["Neon"] = 2.1, ["Neon|Ride"] = 20.37, ["Mega"] = 35.35, ["Mega|Fly"] = 122.67, ["Mega|Ride"] = 81.08, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Fly"] = 202.74, ["Ride"] = 114.93, ["Fly|Ride"] = 144.38, ["Neon"] = 304.5, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 362.07, ["Mega"] = 3251.93, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 41.73, ["Ride"] = 91.85, ["Neon"] = 10.8, ["Neon|Ride"] = 144.65, ["Neon|Fly|Ride"] = 216.81, ["Mega"] = 63, ["Mega|Ride"] = 288.35, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 38.07, ["Fly"] = 105, ["Ride"] = 73.5, ["Fly|Ride"] = 170.62, ["Neon"] = 230.9, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.98, ["Ride"] = 18.38, ["Fly|Ride"] = 41.49, ["Neon"] = 4.15, ["Neon|Fly"] = 85.88, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 116, ["Mega"] = 61.69, ["Mega|Fly"] = 147.2, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 21, ["Neon|Ride"] = 115.45, ["Mega"] = 210, ["Mega|Ride"] = 162.61, ["Mega|Fly|Ride"] = 387.19}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 6.5, ["Fly"] = 77.44, ["Ride"] = 32.54, ["Fly|Ride"] = 90.57, ["Neon"] = 25.47, ["Neon|Ride"] = 68.25, ["Mega"] = 141.74, ["Mega|Ride"] = 327.51, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 341.25, ["Fly"] = 499.28, ["Ride"] = 419.99, ["Fly|Ride"] = 558.58, ["Neon"] = 773.07, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1115.62, ["Mega"] = 3128.35, ["Mega|Ride"] = 3130.32, ["Mega|Fly|Ride"] = 3130.53}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 30.19, ["Fly"] = 86.75, ["Ride"] = 47.25, ["Fly|Ride"] = 95.42, ["Neon"] = 157.68, ["Neon|Ride"] = 242.87, ["Neon|Fly|Ride"] = 196.88, ["Mega|Ride"] = 1734.36, ["Mega|Fly|Ride"] = 1068.94}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 61.62, ["Ride"] = 32.8, ["Fly|Ride"] = 116.18, ["Neon"] = 24.83, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 80.22, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 136.5, ["Mega|Ride"] = 262.48, ["Mega|Fly|Ride"] = 282.76}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 13.6, ["Fly"] = 214.25, ["Ride"] = 57.67, ["Fly|Ride"] = 149.63, ["Neon"] = 58.97, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 98.66, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 289.22, ["Mega|Fly"] = 1009.46, ["Mega|Ride"] = 306.81, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.77, ["Ride"] = 23.61, ["Neon"] = 101.36, ["Neon|Ride"] = 121.45, ["Neon|Fly|Ride"] = 490.63, ["Mega"] = 654.99, ["Mega|Ride"] = 692.67, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.93, ["Neon"] = 24.92, ["Neon|Ride"] = 157.5, ["Mega"] = 91.88, ["Mega|Ride"] = 338.22}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 3.59, ["Fly"] = 72.65, ["Ride"] = 24.94, ["Fly|Ride"] = 62.97, ["Neon"] = 18.41, ["Neon|Fly"] = 94.33, ["Neon|Ride"] = 144.67, ["Neon|Fly|Ride"] = 212.14, ["Mega"] = 249.38, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 88.36, ["Fly"] = 245.35, ["Ride"] = 120.87, ["Fly|Ride"] = 196.88, ["Neon"] = 525, ["Neon|Ride"] = 523.68, ["Neon|Fly|Ride"] = 524.98, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 3271.59}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 31.49, ["Ride"] = 55.56, ["Fly|Ride"] = 144.63, ["Neon"] = 118.12, ["Neon|Ride"] = 171.28, ["Neon|Fly|Ride"] = 194.25, ["Mega"] = 536.82, ["Mega|Ride"] = 617.54}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1888.69, ["Fly"] = 2311.32, ["Ride"] = 1968.75, ["Fly|Ride"] = 1837.5, ["Neon"] = 11564.11, ["Neon|Fly|Ride"] = 6070.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.96, ["Fly"] = 65625, ["Ride"] = 72.19, ["Fly|Ride"] = 196.87, ["Neon"] = 19.16, ["Neon|Ride"] = 62.23, ["Mega"] = 143.07, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 209.35, ["Mega|Fly|Ride"] = 1300.93}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 7.25, ["Fly"] = 72.65, ["Ride"] = 51.19, ["Fly|Ride"] = 147.21, ["Neon"] = 24.86, ["Neon|Ride"] = 90.09, ["Mega"] = 144.37, ["Mega|Ride"] = 231.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.38, ["Ride"] = 918.75, ["Fly|Ride"] = 1010.52, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2891.43, ["Mega|Ride"] = 13901.7, ["Mega|Fly|Ride"] = 15177.41}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 26.24, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 145.28, ["Neon|Ride"] = 188.62, ["Mega"] = 855.65, ["Mega|Ride"] = 823.83, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 21.79, ["Fly|Ride"] = 128.15, ["Neon"] = 9.92, ["Neon|Ride"] = 64.84, ["Neon|Fly|Ride"] = 215.73, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 145.28, ["Neon"] = 2.44, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 112.75, ["Mega"] = 23.22, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 131.28}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.85, ["Ride"] = 120.51, ["Fly|Ride"] = 170.63, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2453.11, ["Mega|Fly|Ride"] = 2313.48}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.7, ["Fly|Ride"] = 75.9, ["Neon"] = 13.77, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 90.57, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 212.33}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 77.44, ["Fly"] = 151.79, ["Ride"] = 102.1, ["Fly|Ride"] = 289.47, ["Neon"] = 433.65, ["Neon|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1768.9}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.08, ["Fly"] = 105, ["Fly|Ride"] = 130.11, ["Neon"] = 59.06, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 328.02, ["Mega|Ride"] = 319.79}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Fly"] = 284.82, ["Ride"] = 259.88, ["Fly|Ride"] = 307.13, ["Neon"] = 1137.32, ["Neon|Ride"] = 981.25, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 3899.56}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.24, ["Fly"] = 59.07, ["Ride"] = 22.23, ["Fly|Ride"] = 115.4, ["Neon"] = 65.06, ["Neon|Ride"] = 65.06, ["Neon|Fly|Ride"] = 114.19, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.21, ["Ride"] = 16.5, ["Fly|Ride"] = 49.85, ["Neon"] = 3.94, ["Neon|Fly"] = 37.97, ["Neon|Ride"] = 21.7, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 40.69, ["Mega|Ride"] = 72.82, ["Mega|Fly|Ride"] = 145.27}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1357.31, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7949.86, ["Neon|Fly|Ride"] = 7045.83, ["Mega"] = 24530.96, ["Mega|Fly|Ride"] = 19513.8}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Ride"] = 71.52, ["Fly|Ride"] = 202.74, ["Neon"] = 98.09, ["Neon|Ride"] = 314.98, ["Mega"] = 341.25, ["Mega|Ride"] = 434.85, ["Mega|Fly|Ride"] = 564.27}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 6.49, ["Fly"] = 54.91, ["Ride"] = 39.38, ["Fly|Ride"] = 80.75, ["Neon"] = 28.59, ["Neon|Fly"] = 103, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 120.33, ["Mega"] = 419.99, ["Mega|Ride"] = 162.1, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 27.2, ["Fly"] = 40.26, ["Ride"] = 38.87, ["Fly|Ride"] = 74.79, ["Neon"] = 241.78, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 189.09, ["Mega"] = 2601.55, ["Mega|Ride"] = 1145.62, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 8.86, ["Fly"] = 71.56, ["Ride"] = 27.46, ["Fly|Ride"] = 88.92, ["Neon"] = 48.57, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 431.71}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 68.25, ["Ride"] = 157.49, ["Fly|Ride"] = 644.01, ["Neon"] = 288.75, ["Neon|Fly"] = 578.92, ["Neon|Ride"] = 433.6, ["Mega"] = 947.4, ["Mega|Ride"] = 1080.74, ["Mega|Fly|Ride"] = 966}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 54.71, ["Neon|Ride"] = 100.04, ["Neon|Fly|Ride"] = 108.41, ["Mega"] = 16.96, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 84, ["Fly"] = 118.12, ["Ride"] = 125.9, ["Fly|Ride"] = 183.73, ["Neon"] = 579.95, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 524.99, ["Neon|Fly|Ride"] = 643.12, ["Mega"] = 2167.95, ["Mega|Fly|Ride"] = 1994.52}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 144.38, ["Ride"] = 23.82, ["Fly|Ride"] = 67.36, ["Neon"] = 198.19, ["Neon|Ride"] = 72.19, ["Mega"] = 773.71, ["Mega|Ride"] = 437.73, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 18.38, ["Fly|Ride"] = 39.34, ["Neon"] = 24.52, ["Neon|Fly"] = 82.21, ["Neon|Ride"] = 72.64, ["Neon|Fly|Ride"] = 122.85, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 101.92, ["Neon|Fly"] = 143.1, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.76, ["Mega"] = 86.43}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 83.96, ["Fly"] = 247.55, ["Ride"] = 223.13, ["Fly|Ride"] = 289.47, ["Neon"] = 363.32, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 787.5, ["Mega"] = 1879.63, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1758.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.81, ["Fly|Ride"] = 433.65, ["Neon"] = 20.3, ["Neon|Ride"] = 59.07, ["Mega"] = 131.25, ["Mega|Ride"] = 158.28, ["Mega|Fly|Ride"] = 327.54}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 38.57, ["Neon"] = 2.1, ["Neon|Ride"] = 101.91, ["Mega"] = 16.62, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 32.82, ["Fly|Ride"] = 144.44, ["Neon"] = 3.94, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 31.91, ["Mega"] = 21, ["Mega|Fly"] = 56.44, ["Mega|Ride"] = 46.61, ["Mega|Fly|Ride"] = 127.5}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.28, ["Fly|Ride"] = 52.47, ["Neon"] = 5.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 29.28, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 63, ["Mega|Ride"] = 131.23, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.49, ["Neon"] = 24.36, ["Neon|Ride"] = 131.25, ["Mega"] = 118.13, ["Mega|Ride"] = 130.09, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 16.95, ["Fly|Ride"] = 37.35, ["Neon"] = 16.3, ["Neon|Fly"] = 86.73, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 82.19, ["Mega"] = 223.13, ["Mega|Ride"] = 142.01, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 52.71, ["Ride"] = 131.25, ["Fly|Ride"] = 275.63, ["Neon"] = 232.02, ["Neon|Ride"] = 393.75, ["Mega"] = 786.19, ["Mega|Ride"] = 715.32, ["Mega|Fly|Ride"] = 867.29}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 16.96, ["Ride"] = 17.5, ["Fly|Ride"] = 43.16, ["Neon"] = 2.1, ["Neon|Fly"] = 32.45, ["Neon|Ride"] = 20.48, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 19.69, ["Mega|Fly"] = 72.64, ["Mega|Ride"] = 148.19, ["Mega|Fly|Ride"] = 101.06}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 7.88, ["Fly"] = 28.88, ["Ride"] = 26.25, ["Fly|Ride"] = 69.27, ["Neon"] = 32.81, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 301.88, ["Mega|Fly"] = 578.86, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 24.62, ["Fly"] = 55.13, ["Ride"] = 45.94, ["Fly|Ride"] = 114.34, ["Neon"] = 103.68, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 124.59, ["Neon|Fly|Ride"] = 203.43, ["Mega"] = 1300.78, ["Mega|Ride"] = 867.19, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 10.5, ["Fly"] = 196.88, ["Fly|Ride"] = 67.24, ["Neon"] = 85.31, ["Neon|Ride"] = 103.69, ["Mega"] = 549.94, ["Mega|Ride"] = 700.26, ["Mega|Fly|Ride"] = 719.86}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.43, ["Ride"] = 17.27, ["Fly|Ride"] = 32.93, ["Neon"] = 3.94, ["Neon|Fly"] = 28.11, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 40.69, ["Mega|Fly"] = 89.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 7.88, ["Fly"] = 52.5, ["Ride"] = 61.81, ["Neon"] = 76.31, ["Neon|Ride"] = 134.43, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 326.82, ["Mega|Fly"] = 536.59, ["Mega|Ride"] = 379.4, ["Mega|Fly|Ride"] = 568.08}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1257.57, ["Ride"] = 1004.06, ["Fly|Ride"] = 1065.49, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.44, ["Neon|Fly|Ride"] = 2372.08, ["Mega|Fly|Ride"] = 8071.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 183.74, ["Ride"] = 313.69, ["Fly|Ride"] = 525, ["Neon"] = 840, ["Neon|Ride"] = 947.4, ["Neon|Fly|Ride"] = 1036.3, ["Mega"] = 36303.75, ["Mega|Ride"] = 3758.14, ["Mega|Fly|Ride"] = 3484.31}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 392.44, ["Neon"] = 3.93, ["Neon|Ride"] = 111.55, ["Neon|Fly|Ride"] = 259.09, ["Mega"] = 91.88, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 125.99, ["Ride"] = 194.25, ["Fly|Ride"] = 359.94, ["Neon"] = 616.88, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 792.62, ["Mega|Ride"] = 2564.63, ["Mega|Fly|Ride"] = 1836.19}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 3.8, ["Fly"] = 41.21, ["Ride"] = 19.94, ["Fly|Ride"] = 65.63, ["Neon"] = 14.86, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 289.44, ["Mega"] = 115.96, ["Mega|Ride"] = 490.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 223.13, ["Fly"] = 433.65, ["Ride"] = 315, ["Fly|Ride"] = 428.24, ["Neon"] = 1192.52, ["Neon|Ride"] = 1430.86, ["Neon|Fly|Ride"] = 1373.4, ["Mega|Fly|Ride"] = 4906.78}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 19.69, ["Fly|Ride"] = 225.5, ["Neon"] = 33.45, ["Neon|Ride"] = 51.19, ["Mega"] = 393.74, ["Mega|Fly"] = 363.14, ["Mega|Ride"] = 157.5}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Fly"] = 29.29, ["Ride"] = 26.25, ["Neon"] = 43.65, ["Neon|Ride"] = 53.99, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 15.75, ["Fly"] = 52.5, ["Ride"] = 67.44, ["Fly|Ride"] = 143.12, ["Neon"] = 125.77, ["Neon|Fly"] = 433.6, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 839.27, ["Mega|Ride"] = 721.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 21.7, ["Neon|Ride"] = 196.88, ["Mega"] = 245.33, ["Mega|Ride"] = 257.19, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.08, ["Ride"] = 14.65, ["Fly|Ride"] = 39.26, ["Neon"] = 2.57, ["Neon|Fly"] = 20.69, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 24.94, ["Mega|Ride"] = 34.44, ["Mega|Fly|Ride"] = 97.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5492.07, ["Ride"] = 4461.19, ["Fly|Ride"] = 4515, ["Neon"] = 32523, ["Neon|Fly|Ride"] = 19656.76, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 4.11, ["Fly"] = 86.75, ["Ride"] = 41.91, ["Neon"] = 86.38, ["Neon|Fly"] = 385.91, ["Neon|Ride"] = 106.31, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.15, ["Mega|Fly|Ride"] = 428.24}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 19.69, ["Fly|Ride"] = 45.92, ["Neon"] = 18.66, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 84.6, ["Mega"] = 131.25, ["Mega|Ride"] = 145.27, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 456.75, ["Fly"] = 547.77, ["Ride"] = 511.88, ["Fly|Ride"] = 566.53, ["Neon"] = 1641.34, ["Neon|Ride"] = 1292.82, ["Neon|Fly|Ride"] = 1391.25, ["Mega|Fly|Ride"] = 4873.32}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 6.35, ["Ride"] = 49.08, ["Neon"] = 13.85, ["Neon|Ride"] = 291.38, ["Mega"] = 142.01, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 4.11, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 32.82, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 409.68, ["Mega|Ride"] = 401.62}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.53, ["Fly|Ride"] = 65.62, ["Neon"] = 6.02, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.74, ["Mega"] = 56.35, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 145.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.48, ["Fly"] = 882.48, ["Ride"] = 722.51, ["Fly|Ride"] = 759.99, ["Neon|Ride"] = 2126.27, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8672.81}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 11.79, ["Fly"] = 101.92, ["Ride"] = 79.08, ["Fly|Ride"] = 312.82, ["Neon"] = 38.06, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 188.62, ["Mega"] = 262.5, ["Mega|Fly"] = 433.6, ["Mega|Ride"] = 243.95, ["Mega|Fly|Ride"] = 394.58}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.77, ["Fly"] = 236.25, ["Ride"] = 38.07, ["Fly|Ride"] = 130.01, ["Neon"] = 23.27, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 169.32, ["Mega|Fly"] = 818.12, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 304.86}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 21.6, ["Fly|Ride"] = 41.96, ["Neon"] = 17.07, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.82, ["Neon|Fly|Ride"] = 82.97, ["Mega"] = 165.38, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 23.6, ["Fly"] = 39.38, ["Ride"] = 36.75, ["Fly|Ride"] = 62.34, ["Neon"] = 117.6, ["Neon|Ride"] = 114.18, ["Mega"] = 867.19, ["Mega|Ride"] = 613.29, ["Mega|Fly|Ride"] = 1156.75}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 82.21, ["Neon"] = 3.73, ["Neon|Ride"] = 143.07, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 32.12, ["Mega|Fly"] = 147.2, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 575.87, ["Fly"] = 714.44, ["Ride"] = 630.19, ["Fly|Ride"] = 630, ["Neon"] = 2589.57, ["Neon|Ride"] = 2313.21, ["Neon|Fly|Ride"] = 2391.38, ["Mega|Ride"] = 9567.08, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.62, ["Ride"] = 70.35, ["Fly|Ride"] = 262.5, ["Neon"] = 12.23, ["Neon|Ride"] = 70.88, ["Neon|Fly|Ride"] = 433.6, ["Mega"] = 55.27, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 318.33}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 49.56, ["Neon"] = 5.23, ["Neon|Fly"] = 246.07, ["Neon|Ride"] = 220.79, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 52.48, ["Mega|Fly|Ride"] = 289.47}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 60.45, ["Neon"] = 4.55, ["Neon|Ride"] = 56.17, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 60.73, ["Mega|Fly"] = 160.43, ["Mega|Ride"] = 127.2, ["Mega|Fly|Ride"] = 215.76}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.66, ["Ride"] = 26.25, ["Neon"] = 7.88, ["Neon|Ride"] = 48.69, ["Mega"] = 237.4, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 20.1, ["Fly"] = 72.19, ["Ride"] = 59.76, ["Fly|Ride"] = 207.38, ["Neon"] = 103.93, ["Neon|Fly"] = 278.44, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 511.88, ["Mega|Ride"] = 510.06, ["Mega|Fly|Ride"] = 575.61}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 10.26, ["Ride"] = 65.54, ["Fly|Ride"] = 156.13, ["Neon"] = 84.68, ["Neon|Ride"] = 114.84, ["Neon|Fly|Ride"] = 283.5, ["Mega"] = 551.25, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 575.74}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.36, ["Ride"] = 16.96, ["Fly|Ride"] = 47.84, ["Neon"] = 30.19, ["Neon|Ride"] = 35.86, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 298.6, ["Mega|Ride"] = 367.47, ["Mega|Fly|Ride"] = 245.02}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 5.9, ["Ride"] = 78.73, ["Fly|Ride"] = 147.21, ["Neon"] = 38.06, ["Neon|Ride"] = 91.88, ["Mega"] = 325.2, ["Mega|Ride"] = 563.69}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Fly|Ride"] = 109.5, ["Neon"] = 10.28, ["Neon|Ride"] = 52.04, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.66, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 254.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 18.15, ["Fly"] = 19.68, ["Ride"] = 23.7, ["Fly|Ride"] = 58.56, ["Neon"] = 110.25, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 212.47, ["Mega"] = 906.43, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.43, ["Fly"] = 874.13, ["Neon"] = 131.25, ["Mega"] = 332.07, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 578.92}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 39.38, ["Fly"] = 153.58, ["Ride"] = 65.63, ["Fly|Ride"] = 128.7, ["Neon"] = 262.5, ["Neon|Ride"] = 314.12, ["Neon|Fly|Ride"] = 436.86, ["Mega"] = 1961.27, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 31.21, ["Fly"] = 145.28, ["Ride"] = 76.72, ["Fly|Ride"] = 223.13, ["Neon"] = 125.58, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 315, ["Mega"] = 629.28, ["Mega|Ride"] = 2026.5, ["Mega|Fly|Ride"] = 955}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.38, ["Ride"] = 41.21, ["Neon"] = 139.78, ["Neon|Ride"] = 223.12, ["Mega"] = 607.04, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 819.6}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 27.42, ["Fly"] = 81.74, ["Ride"] = 86.63, ["Fly|Ride"] = 144.38, ["Neon"] = 196.87, ["Neon|Fly"] = 319.79, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 466.87, ["Mega"] = 714.57, ["Mega|Ride"] = 615.55, ["Mega|Fly|Ride"] = 752.48}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 14.74, ["Fly|Ride"] = 32.8, ["Neon"] = 4.18, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 41.68, ["Mega|Fly"] = 327.51, ["Mega|Ride"] = 55.12, ["Mega|Fly|Ride"] = 145.04}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1486.76}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 97.02, ["Ride"] = 201.66, ["Fly|Ride"] = 374.07, ["Neon"] = 433.34, ["Neon|Ride"] = 527.9, ["Neon|Fly|Ride"] = 650.4, ["Mega"] = 1631.44, ["Mega|Ride"] = 1619.47, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 76.58, ["Neon"] = 2.52, ["Neon|Fly"] = 101.91, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 303.3, ["Mega"] = 36.66, ["Mega|Ride"] = 66.25, ["Mega|Fly|Ride"] = 141.75}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 27.32, ["Ride"] = 49.02, ["Fly|Ride"] = 216.84, ["Neon"] = 106.74, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 544.69, ["Mega"] = 591.93, ["Mega|Ride"] = 518.89, ["Mega|Fly|Ride"] = 653.62}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 24.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 74.82, ["Neon"] = 3.82, ["Mega"] = 21.67, ["Mega|Ride"] = 107.16, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 85.75, ["Fly"] = 1312.5, ["Ride"] = 143.47, ["Fly|Ride"] = 196.88, ["Neon"] = 549.65, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 6746.02, ["Mega|Fly|Ride"] = 2033.78}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.69, ["Fly|Ride"] = 100.8, ["Neon"] = 5.15, ["Neon|Fly"] = 43.38, ["Neon|Ride"] = 32.28, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 91.88, ["Mega|Ride"] = 118.11, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Fly|Ride"] = 64.32, ["Neon"] = 3.84, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 28.87, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.62, ["Ride"] = 71.58, ["Neon"] = 15.53, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 230.79, ["Mega"] = 131.25, ["Mega|Ride"] = 173.45, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 11.81, ["Neon|Ride"] = 137.82, ["Mega"] = 103.95}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 65.63, ["Ride"] = 327.54, ["Fly|Ride"] = 362.11, ["Neon"] = 413.44, ["Neon|Ride"] = 613.29, ["Neon|Fly|Ride"] = 612.07, ["Mega|Ride"] = 2746.79, ["Mega|Fly|Ride"] = 2877.21}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.63, ["Ride"] = 34.7, ["Neon"] = 262.5, ["Neon|Fly|Ride"] = 145.27, ["Mega"] = 418.06, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.48, ["Ride"] = 427.32, ["Fly|Ride"] = 737.2, ["Neon"] = 1069.69, ["Neon|Ride"] = 1050, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 94.5}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.19}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 59.07}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 50.9}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 52.5}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 15.36}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 6.33}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 190.3}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 18.57}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 104.16}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 32.7}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 11.82}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 7.6}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 9.19}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.57}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 31.2}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 748.13}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 462}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 9.1}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1512.04}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.4}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 6.49}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 93.45}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 24.67}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 58.58}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 19.25}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 12.11}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 19.95}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 6.43}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 26.17}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 196.87}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 13.62}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.56}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 3045}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 83.49}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 247.53}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.85}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 23.62}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 23}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 30.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 213.94}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 10.5}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.85}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 148.23}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 51.01}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 6.29}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 31.43}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.28}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.07}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.57}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 7.79}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 16.89}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 8.3}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.51}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.63}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.32}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 259.86}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.62}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 3.94}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 315.89}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.34}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 91.88}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.57}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24411.19}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 35.35}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 39.73}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 27.57}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.7}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 24.94}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 37.41}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.59}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 81.81}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 29.32}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.69}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 431.78}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.42}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 115.31}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 242.05}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 13.12}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 9.19}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.07}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 23.51}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 143.87}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.41}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 2.5}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 7.46}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 16.7}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 195.57}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.8}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.67}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.85}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 11.81}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 30.56}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.64}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 19.68}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 31.49}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.29}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.63}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 9.15}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 3.94}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.19}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 32.82}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.51}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.04}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 14.02}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 179.45}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 52.08}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 179.06}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 26.25}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 26.24}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 36.86}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 23.63}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 21}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 3.94}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 7.88}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 6.57}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 27.56}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.75}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 3.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.52}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 36.87}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.57}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 9.07}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.44}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7875}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.52}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 16.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.26}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.13}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 4.24}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 15.75}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.86}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 2.41}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.36}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 3.89}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 40.2}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.61}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 3.94}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 4.6}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 3.5}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.28}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 8.97}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 29.88}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 2.98}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 72.51}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.26}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 4.98}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.65}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 4.39}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 24.83}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 2.87}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.52}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 11.83}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.66}},
    ["rbxassetid://3009779565"] = {name = "Rainbow Rattle", prices = {["default"] = 289093.59}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.05}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 3.81}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 19.35}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.83}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 6.98}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.79}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 129.92}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.7}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1291.4}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 65.4}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 23.63}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.52}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 8.68}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 15.75}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 52.5}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 19.27}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.59}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 11.81}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.27}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 18.37}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.85}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.57}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 69.47}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.63}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 13.12}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.39}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 396.58}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 91.88}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 13.67}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 3.94}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 24.94}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 18.38}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.93}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.15}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.62}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 5.94}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 125.87}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 161.42}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 11.71}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1015.87}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.73}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.63}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 44.6}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.93}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.98}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 81.38}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 18.26}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 48.4}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 3.93}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.37}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 9.01}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 57.66}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 5.24}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 59.48}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.51}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 4.2}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.45}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 16.27}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 112.88}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 5.5}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 86.4}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 7.24}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 9.75}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 52.4}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 52.74}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 97.13}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.25}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.66}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 15.88}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 4.95}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 42.6}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.38}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 28.88}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.34}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 5.16}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.33}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 15.59}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 216.84}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 30.86}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.6}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 39.38}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.75}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 28.86}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 145.28}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 56.42}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.6}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 21}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 16.89}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 9.18}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 17.8}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.46}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 11.78}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 280.88}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 70.87}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 43.19}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 3.46}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 51.1}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 155.86}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 78.31}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 965.87}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 194.25}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 5.52}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1642.41}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 570.42}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 3.72}},
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