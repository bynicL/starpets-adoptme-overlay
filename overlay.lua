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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 984.38, ["Ride"] = 1179.92, ["Fly|Ride"] = 1364.45, ["Neon"] = 6826.74, ["Neon|Fly|Ride"] = 5036.24, ["Mega"] = 21568.93, ["Mega|Fly|Ride"] = 21568.93}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 582.75, ["Fly"] = 650.44, ["Ride"] = 530.25, ["Fly|Ride"] = 525, ["Neon|Fly|Ride"] = 2342.42, ["Mega"] = 10774.62, ["Mega|Fly|Ride"] = 8202.86}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4410, ["Fly"] = 4396.88, ["Ride"] = 5250, ["Fly|Ride"] = 4957.32, ["Neon|Fly|Ride"] = 18355.34, ["Mega|Fly|Ride"] = 76135.29}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 204.75, ["Fly"] = 262.5, ["Ride"] = 262.5, ["Fly|Ride"] = 402.98, ["Neon"] = 1137.86, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4710.99}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 646.8, ["Ride"] = 590.63, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 1912.77, ["Mega|Fly|Ride"] = 4593.75}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.32, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 84, ["Neon|Fly"] = 287.97, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 323.26, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 539.89}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.94, ["Fly"] = 38.59, ["Ride"] = 24.29, ["Fly|Ride"] = 65.62, ["Neon"] = 28.59, ["Neon|Fly"] = 128.17, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 123.03, ["Mega"] = 176.8, ["Mega|Ride"] = 215.97, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 114.19, ["Fly"] = 215.52, ["Ride"] = 131.38, ["Fly|Ride"] = 218.68, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2154.94}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.69, ["Fly"] = 95.04, ["Ride"] = 48.57, ["Fly|Ride"] = 111.96, ["Neon"] = 275.62, ["Neon|Ride"] = 226.28, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 2100, ["Mega|Ride"] = 1149.67, ["Mega|Fly|Ride"] = 831.17}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.9, ["Fly"] = 33.38, ["Ride"] = 34.01, ["Fly|Ride"] = 76.13, ["Neon"] = 215.84, ["Neon|Ride"] = 214.43, ["Neon|Fly|Ride"] = 209.04, ["Mega"] = 646.5, ["Mega|Fly|Ride"] = 610.32}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Ride"] = 109.67, ["Fly|Ride"] = 192.75, ["Neon"] = 392.74, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 433.38, ["Mega|Fly|Ride"] = 2012.71}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 64.18}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 393.75, ["Fly"] = 403.59, ["Ride"] = 351.75, ["Fly|Ride"] = 412.13, ["Neon|Ride"] = 1440.45, ["Neon|Fly|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 5166.45}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.43, ["Fly"] = 209.56, ["Ride"] = 131.25, ["Fly|Ride"] = 178.5, ["Neon|Fly"] = 682.23, ["Neon|Fly|Ride"] = 563.07, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.64, ["Fly"] = 79.85, ["Ride"] = 65.63, ["Fly|Ride"] = 163.26, ["Neon"] = 25.91, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 157.5, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 325.42, ["Mega|Fly|Ride"] = 387.91}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 232.32, ["Fly"] = 185.11, ["Ride"] = 234.05, ["Fly|Ride"] = 279.55, ["Neon|Fly"] = 860.92, ["Neon|Ride"] = 1137.86, ["Neon|Fly|Ride"] = 779.65, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.69, ["Fly"] = 27.8, ["Ride"] = 21, ["Fly|Ride"] = 45.17, ["Neon"] = 28.87, ["Neon|Fly"] = 129.43, ["Neon|Ride"] = 71.13, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 422.63}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 144.37, ["Ride"] = 162.75, ["Fly|Ride"] = 259.17, ["Neon"] = 519.75, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 525, ["Mega"] = 1787.18, ["Mega|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 1787.18}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 78.74, ["Ride"] = 185.07, ["Fly|Ride"] = 243.66, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1721.81}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 33.5, ["Fly"] = 58.2, ["Ride"] = 72.19, ["Fly|Ride"] = 215.52, ["Neon"] = 262.5, ["Neon|Ride"] = 353.42, ["Neon|Fly|Ride"] = 373.9, ["Mega"] = 2154.94, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1003.13}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.81, ["Fly"] = 107.77, ["Ride"] = 64.32, ["Fly|Ride"] = 115.5, ["Neon"] = 216.45, ["Neon|Ride"] = 209.94, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 1706.7, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.19, ["Fly"] = 249.61, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 402.98, ["Neon|Fly|Ride"] = 311.85, ["Mega"] = 1967.44, ["Mega|Ride"] = 1723.96, ["Mega|Fly|Ride"] = 1552.36}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 26.25, ["Ride"] = 54.47, ["Fly|Ride"] = 115.31, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 29.16, ["Fly"] = 102.38, ["Ride"] = 72.19, ["Fly|Ride"] = 130.37, ["Neon"] = 373.9, ["Neon|Ride"] = 310.89, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1137.86, ["Mega|Fly|Ride"] = 934.18}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 6.29, ["Fly"] = 32.46, ["Ride"] = 26.24, ["Fly|Ride"] = 61.25, ["Neon"] = 73.5, ["Neon|Fly"] = 280.87, ["Neon|Ride"] = 49.88, ["Neon|Fly|Ride"] = 101.07, ["Mega"] = 152.25, ["Mega|Fly"] = 28792.56, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 427.61}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 411.65, ["Fly"] = 537.68, ["Ride"] = 364.47, ["Fly|Ride"] = 456.68, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10783.75, ["Mega|Fly|Ride"] = 9672.02}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 12.77, ["Ride"] = 31.49, ["Fly|Ride"] = 127.16, ["Neon"] = 90.57, ["Neon|Fly|Ride"] = 440.02, ["Mega|Ride"] = 402.98, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.87, ["Fly"] = 43.23, ["Ride"] = 21.58, ["Fly|Ride"] = 47.79, ["Neon"] = 75.02, ["Neon|Ride"] = 75.45, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 431, ["Mega|Fly|Ride"] = 534.01}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 81.38, ["Fly"] = 119.61, ["Ride"] = 85.32, ["Fly|Ride"] = 139.95, ["Neon"] = 393.75, ["Neon|Ride"] = 464.4, ["Neon|Fly|Ride"] = 400.31, ["Mega"] = 6457.85, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 11.2, ["Ride"] = 34.5, ["Fly|Ride"] = 72.21, ["Neon"] = 83.32, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 267.86, ["Mega"] = 720.57, ["Mega|Ride"] = 730.97, ["Mega|Fly|Ride"] = 537.68}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 226.98, ["Fly"] = 262.5, ["Ride"] = 269.38, ["Fly|Ride"] = 336.39, ["Neon"] = 753.16, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 2801.4, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3087.06}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.17}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.76, ["Fly"] = 26.25, ["Ride"] = 24.13, ["Fly|Ride"] = 54.46, ["Neon"] = 24.84, ["Neon|Fly"] = 144.54, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 148.32, ["Mega|Fly"] = 487.49, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1047.38, ["Fly"] = 2625, ["Ride"] = 1135.32, ["Fly|Ride"] = 1298.07, ["Neon"] = 9187.5, ["Neon|Ride"] = 6178.17, ["Neon|Fly|Ride"] = 5745.04, ["Mega|Ride"] = 54841.06, ["Mega|Fly|Ride"] = 18661.63}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.5, ["Fly"] = 53.2, ["Ride"] = 51.97, ["Fly|Ride"] = 105.99, ["Neon"] = 194.91, ["Neon|Ride"] = 265.07, ["Neon|Fly|Ride"] = 285.05, ["Mega"] = 1043.44, ["Mega|Ride"] = 1106.56, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.75, ["Fly"] = 365.5, ["Ride"] = 236.25, ["Fly|Ride"] = 311.84, ["Neon"] = 921.38, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4195.66, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4020.22}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.16}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 15.65, ["Fly"] = 86.63, ["Ride"] = 119.44, ["Fly|Ride"] = 144.39, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 586.62, ["Mega|Ride"] = 575.9, ["Mega|Fly|Ride"] = 650.56}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 118.31, ["Fly"] = 163.89, ["Ride"] = 163.26, ["Fly|Ride"] = 170.63, ["Neon"] = 672.49, ["Neon|Ride"] = 532.87, ["Neon|Fly|Ride"] = 688.51, ["Mega|Ride"] = 2275.7, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.19, ["Fly"] = 248.91, ["Ride"] = 145.53, ["Fly|Ride"] = 240.19, ["Neon"] = 417.84, ["Neon|Fly"] = 575.38, ["Neon|Ride"] = 434.78, ["Neon|Fly|Ride"] = 497.44, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 37.67}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.46, ["Fly"] = 77.98, ["Ride"] = 46.41, ["Fly|Ride"] = 77.96, ["Neon|Ride"] = 382.51, ["Neon|Fly|Ride"] = 365.24, ["Mega"] = 4313.8, ["Mega|Fly|Ride"] = 1561.77}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.65, ["Ride"] = 41.58, ["Fly|Ride"] = 157.5, ["Neon"] = 48.75, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 142.24, ["Neon|Fly|Ride"] = 242.44, ["Mega"] = 183.75, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 252.13, ["Mega|Fly|Ride"] = 441.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 735.83, ["Ride"] = 560.27, ["Fly|Ride"] = 623.96, ["Neon"] = 1968.75, ["Neon|Fly"] = 3882.42, ["Neon|Ride"] = 3882.42, ["Neon|Fly|Ride"] = 2103.67, ["Mega|Ride"] = 15084.46, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 127.32, ["Fly"] = 170.63, ["Ride"] = 131.25, ["Fly|Ride"] = 203.44, ["Neon"] = 511.88, ["Neon|Ride"] = 537.26, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 2801.4, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 62.34, ["Fly"] = 230.79, ["Ride"] = 102.43, ["Fly|Ride"] = 201.68, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 505.32, ["Mega|Ride"] = 2014.87, ["Mega|Fly|Ride"] = 2068.74}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 72.19, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 428.85, ["Mega"] = 6326.83, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2274.01}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 27.57, ["Fly"] = 81.29, ["Ride"] = 44.61, ["Fly|Ride"] = 111.57, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.44, ["Neon|Fly|Ride"] = 195.8, ["Mega"] = 2625, ["Mega|Ride"] = 906.65, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.32}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 49.88, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 130.37, ["Neon|Ride"] = 325.28, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1299.88, ["Mega|Fly|Ride"] = 1360.85}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.37}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 157.5, ["Fly|Ride"] = 282.19, ["Neon"] = 1149.67, ["Neon|Ride"] = 1137.86, ["Neon|Fly|Ride"] = 1290.81, ["Mega|Fly|Ride"] = 4872.99}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 787.49, ["Fly"] = 805.95, ["Ride"] = 721.88, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11780.97}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 27.27, ["Fly"] = 59.13, ["Ride"] = 38.98, ["Fly|Ride"] = 65.59, ["Neon"] = 187.51, ["Neon|Fly"] = 280.14, ["Neon|Ride"] = 163.68, ["Neon|Fly|Ride"] = 215.91, ["Mega|Ride"] = 1169.54, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 21.83}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Ride"] = 7902.11, ["Fly|Ride"] = 4812.93, ["Neon|Ride"] = 17869.26, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 43856.86}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.43, ["Fly"] = 144.39, ["Ride"] = 26.25, ["Fly|Ride"] = 69.13, ["Neon"] = 89.65, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 560.28, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 9.87, ["Fly"] = 141.29, ["Ride"] = 39, ["Fly|Ride"] = 120.63, ["Neon"] = 83.03, ["Neon|Ride"] = 133.62, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 969.73, ["Mega|Ride"] = 475.17, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 78.74, ["Fly"] = 114.22, ["Ride"] = 112.11, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4313.5, ["Mega|Fly|Ride"] = 1787.18}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.72, ["Fly"] = 72.28, ["Ride"] = 36.71, ["Fly|Ride"] = 78.74, ["Neon"] = 97.02, ["Neon|Fly"] = 215.52, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 538.75, ["Mega|Ride"] = 796.74, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1640.63, ["Fly"] = 1837.5, ["Ride"] = 2299.33, ["Fly|Ride"] = 1745.52, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34507.93, ["Ride"] = 33042.5, ["Fly|Ride"] = 25134.38, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.28, ["Fly"] = 393.75, ["Ride"] = 54.89, ["Fly|Ride"] = 120.74, ["Neon"] = 258.14, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 258.61, ["Mega"] = 753.16, ["Mega|Ride"] = 1300.36, ["Mega|Fly|Ride"] = 749.93}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.67, ["Fly"] = 121.77, ["Ride"] = 50.36, ["Fly|Ride"] = 199.49, ["Neon"] = 26.24, ["Neon|Fly"] = 230.6, ["Neon|Ride"] = 84.36, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 163.41, ["Mega|Fly"] = 389.85, ["Mega|Ride"] = 242.44, ["Mega|Fly|Ride"] = 219.18}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 24.17}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 10.48, ["Ride"] = 36.65, ["Fly|Ride"] = 131.25, ["Neon"] = 58.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 274.33, ["Mega"] = 388.57, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 747.78}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 676.82, ["Ride"] = 689.76, ["Fly|Ride"] = 656.25, ["Neon"] = 3088.18, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 1949.2, ["Mega|Fly|Ride"] = 9136.86}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 941.07, ["Fly"] = 951.57, ["Ride"] = 840, ["Fly|Ride"] = 846.57, ["Neon|Ride"] = 3249.08, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13644.37}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.13, ["Fly"] = 121.84, ["Ride"] = 34.84, ["Fly|Ride"] = 77.97, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 500.85, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 26.25}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 84, ["Fly"] = 116.96, ["Ride"] = 91.88, ["Fly|Ride"] = 135.06, ["Neon"] = 573.22, ["Neon|Ride"] = 405.62, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2012.71, ["Mega|Fly|Ride"] = 2110.76}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 91.88, ["Ride"] = 122.07, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Ride"] = 469.03, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1403.38, ["Mega|Fly|Ride"] = 2158.95}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.86, ["Fly"] = 43.12, ["Ride"] = 25.88, ["Fly|Ride"] = 68.16, ["Neon"] = 48.39, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 116.65, ["Mega|Fly|Ride"] = 352.97}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 196.85, ["Fly"] = 202.78, ["Ride"] = 209.98, ["Fly|Ride"] = 262.49, ["Neon|Ride"] = 623.44, ["Neon|Fly|Ride"] = 708.95, ["Mega"] = 5176.56, ["Mega|Fly|Ride"] = 2619.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.41, ["Ride"] = 49.26, ["Fly|Ride"] = 137.94, ["Neon"] = 47.24, ["Neon|Ride"] = 163.26, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 283.5, ["Mega|Fly|Ride"] = 488.52}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.57, ["Fly"] = 65.63, ["Ride"] = 31.81, ["Fly|Ride"] = 90.95, ["Neon"] = 126, ["Neon|Fly"] = 325.5, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 796.26}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.2, ["Ride"] = 57.75, ["Fly|Ride"] = 156.19, ["Neon"] = 227.83, ["Neon|Ride"] = 201.75, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.75, ["Fly"] = 88.45, ["Ride"] = 39.51, ["Fly|Ride"] = 83.61, ["Neon"] = 131.25, ["Neon|Ride"] = 325.28, ["Neon|Fly|Ride"] = 321.64, ["Mega"] = 1256.33, ["Mega|Fly|Ride"] = 853.83}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 5643.75, ["Fly|Ride"] = 5764.5, ["Neon"] = 35948.94, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30025.61, ["Mega|Fly|Ride"] = 84000}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 224.44, ["Fly"] = 288.33, ["Ride"] = 230.97, ["Fly|Ride"] = 309.75, ["Neon"] = 812.6, ["Neon|Fly|Ride"] = 568.57, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 68.06, ["Fly"] = 252.11, ["Ride"] = 105, ["Fly|Ride"] = 244.9, ["Neon"] = 196.88, ["Neon|Fly"] = 301.7, ["Neon|Ride"] = 273, ["Neon|Fly|Ride"] = 376.68, ["Mega"] = 565.95, ["Mega|Ride"] = 576.62, ["Mega|Fly|Ride"] = 639.32}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.26, ["Fly"] = 90.22, ["Ride"] = 34.22, ["Fly|Ride"] = 81.37, ["Neon"] = 22.44, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 196.1, ["Mega"] = 431, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 64.28, ["Fly"] = 215.34, ["Ride"] = 123.21, ["Fly|Ride"] = 262.11, ["Neon"] = 220.5, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 342.56, ["Mega"] = 502.26, ["Mega|Fly"] = 732.68, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16376.34, ["Ride"] = 13415.07, ["Fly|Ride"] = 11550, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 107459.48}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 334.69, ["Ride"] = 387.19, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1680.84, ["Neon|Fly|Ride"] = 1652.83, ["Mega|Fly|Ride"] = 7194.6}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 58.46, ["Fly"] = 90.5, ["Ride"] = 59.06, ["Fly|Ride"] = 108.93, ["Neon"] = 288.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 377.12, ["Mega|Fly|Ride"] = 2010.56}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.87, ["Ride"] = 23.15, ["Fly|Ride"] = 72.12, ["Neon"] = 67.47, ["Neon|Fly"] = 325.28, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 730.97, ["Mega|Fly|Ride"] = 486.99}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 358.31, ["Ride"] = 401.18, ["Fly|Ride"] = 526.24, ["Neon"] = 1713.17, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.93, ["Ride"] = 37.7, ["Fly|Ride"] = 149.86, ["Neon"] = 31.23, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 157.5, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 201.51, ["Ride"] = 162.42, ["Fly|Ride"] = 196.88, ["Neon"] = 633.51, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2240.44}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.16, ["Fly"] = 18.93, ["Ride"] = 18.09, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 2588.11, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 9.19}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 68.42, ["Ride"] = 87.94, ["Fly|Ride"] = 171.05, ["Neon"] = 244.13, ["Neon|Fly"] = 537.68, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 431, ["Mega|Ride"] = 2010.56, ["Mega|Fly|Ride"] = 1609.74}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.64, ["Fly"] = 292.4, ["Ride"] = 32.82, ["Fly|Ride"] = 90.57, ["Neon"] = 85.32, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 181.92, ["Mega"] = 543.06, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1281.72}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 36.75}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 74.82, ["Fly"] = 144.39, ["Ride"] = 118.13, ["Fly|Ride"] = 430.32, ["Neon"] = 392.44, ["Neon|Ride"] = 439.69, ["Neon|Fly|Ride"] = 288.15, ["Mega|Ride"] = 1625.16, ["Mega|Fly|Ride"] = 2122.61}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.58, ["Fly|Ride"] = 138.9, ["Neon"] = 28.88, ["Neon|Ride"] = 141.17, ["Neon|Fly|Ride"] = 287.97, ["Mega"] = 148.32, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 325.28}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 10.5, ["Fly"] = 56.42, ["Ride"] = 33.43, ["Fly|Ride"] = 87.84, ["Neon|Ride"] = 121.05, ["Neon|Fly|Ride"] = 214.43, ["Mega|Ride"] = 431, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.68, ["Ride"] = 524.25, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2800.33, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.44, ["Fly"] = 107.77, ["Ride"] = 74.47, ["Fly|Ride"] = 101.3, ["Neon"] = 173.04, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 812.49}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 45.02, ["Fly"] = 144.31, ["Ride"] = 78.66, ["Fly|Ride"] = 147, ["Neon"] = 270.38, ["Neon|Ride"] = 232.05, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1072.09, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.47, ["Fly"] = 86.21, ["Ride"] = 59.07, ["Fly|Ride"] = 130.37, ["Neon"] = 85.32, ["Neon|Ride"] = 222.08, ["Neon|Fly|Ride"] = 262.79, ["Mega"] = 446.25, ["Mega|Fly"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 8334.38, ["Fly"] = 10343.64, ["Ride"] = 8862, ["Fly|Ride"] = 8400, ["Neon|Fly|Ride"] = 13781.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1641.94, ["Fly"] = 1517.02, ["Ride"] = 1606.36, ["Fly|Ride"] = 1387.32, ["Neon"] = 4965.34, ["Neon|Fly|Ride"] = 4287.38, ["Mega|Fly|Ride"] = 16377.42}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 488.28, ["Ride"] = 459.38, ["Fly|Ride"] = 796.69, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21567.47, ["Mega|Fly|Ride"] = 8619.7}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.45, ["Fly"] = 29.12, ["Ride"] = 21.72, ["Fly|Ride"] = 41.61, ["Neon"] = 136.85, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 129.31, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 5.25, ["Fly"] = 78.74, ["Ride"] = 39.38, ["Fly|Ride"] = 198.27, ["Neon"] = 25.2, ["Neon|Ride"] = 56.11, ["Mega"] = 147, ["Mega|Ride"] = 204.49, ["Mega|Fly|Ride"] = 345.39}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 38.06, ["Fly"] = 53.08, ["Ride"] = 55.82, ["Fly|Ride"] = 99.75, ["Neon"] = 238.12, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 159.15, ["Mega|Fly|Ride"] = 640.03}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.77, ["Fly"] = 29.01, ["Ride"] = 18.19, ["Fly|Ride"] = 39.37, ["Neon"] = 31.56, ["Neon|Fly"] = 84.9, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 106, ["Mega"] = 311.9, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 311, ["Fly"] = 430.5, ["Ride"] = 318.94, ["Fly|Ride"] = 393.75, ["Neon"] = 1076.4, ["Neon|Ride"] = 1151.66, ["Neon|Fly|Ride"] = 1292.88, ["Mega|Fly|Ride"] = 4480.92}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 15.75, ["Fly"] = 71.13, ["Ride"] = 44.63, ["Fly|Ride"] = 72.19, ["Neon"] = 144.38, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 187.51, ["Mega"] = 861.98, ["Mega|Fly"] = 910.04, ["Mega|Ride"] = 562.85, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9, ["Fly"] = 21.56, ["Ride"] = 23.78, ["Fly|Ride"] = 45.92, ["Neon"] = 84.05, ["Neon|Fly"] = 121.88, ["Neon|Ride"] = 120.7, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 416.99}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 346.5, ["Fly|Ride"] = 862.77, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1239.11, ["Fly"] = 1438.66, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon"] = 5230.99, ["Neon|Ride"] = 4740.85, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13648.21}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 144.39, ["Fly"] = 86.51, ["Ride"] = 99.24, ["Fly|Ride"] = 108.43, ["Neon"] = 971.25, ["Neon|Ride"] = 650.56, ["Neon|Fly|Ride"] = 496.13, ["Mega|Ride"] = 2583.78, ["Mega|Fly|Ride"] = 2843.4}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.14, ["Fly"] = 196.88, ["Ride"] = 196.64, ["Fly|Ride"] = 258.57, ["Neon"] = 958.96, ["Neon|Ride"] = 675.6, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 23.63, ["Fly"] = 123.94, ["Ride"] = 53.89, ["Fly|Ride"] = 95.64, ["Neon"] = 242.1, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2154.94, ["Mega|Fly|Ride"] = 1090.35}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 223.13, ["Ride"] = 431, ["Fly|Ride"] = 489.18, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1292.96, ["Mega|Fly|Ride"] = 5747.19}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2442.61, ["Ride"] = 2442.61, ["Fly|Ride"] = 2096.95, ["Neon|Fly|Ride"] = 7087.5, ["Mega|Fly|Ride"] = 26906.25}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 50.05, ["Fly"] = 215.52, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2372.44, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 582.75, ["Fly"] = 862.77, ["Ride"] = 604.02, ["Fly|Ride"] = 628.69, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.93, ["Fly"] = 65.51, ["Ride"] = 57.33, ["Fly|Ride"] = 105, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 4.18, ["Fly"] = 41.52, ["Ride"] = 23.16, ["Fly|Ride"] = 74.82, ["Neon"] = 37.68, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 50.31, ["Neon|Fly|Ride"] = 116.23, ["Mega"] = 183.75, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 187.39, ["Mega|Fly|Ride"] = 234.69}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 44.81, ["Ride"] = 84.05, ["Fly|Ride"] = 157.5, ["Neon"] = 196.88, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 718.68, ["Mega"] = 1580.65, ["Mega|Ride"] = 1723.96, ["Mega|Fly|Ride"] = 1709.95}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 994.02, ["Fly"] = 1184.14, ["Ride"] = 1036.88, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 3447.89, ["Neon|Fly|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 13299.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 654.84, ["Ride"] = 808.12, ["Fly|Ride"] = 863.43, ["Neon|Fly|Ride"] = 4308.8, ["Mega|Fly|Ride"] = 20112.98}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.84, ["Fly"] = 26.25, ["Ride"] = 22.32, ["Fly|Ride"] = 41.44, ["Neon"] = 131.25, ["Neon|Fly"] = 86.21, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 144.39, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 17.8, ["Ride"] = 43.31, ["Fly|Ride"] = 129.31, ["Neon"] = 159.49, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 230.99, ["Mega"] = 894.22, ["Mega|Ride"] = 1004.59, ["Mega|Fly|Ride"] = 1054.85}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.8, ["Fly"] = 70.88, ["Ride"] = 36.75, ["Fly|Ride"] = 133.88, ["Neon"] = 24.29, ["Neon|Fly"] = 325.4, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 187.51, ["Mega"] = 157.5, ["Mega|Fly"] = 568.94, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 43.11, ["Fly"] = 86.21, ["Ride"] = 59.06, ["Fly|Ride"] = 124.65, ["Neon"] = 402.98, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 203.44, ["Mega|Ride"] = 1083.04, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.27, ["Ride"] = 183.75, ["Fly|Ride"] = 359.89, ["Neon"] = 437.07, ["Neon|Ride"] = 574.14, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.99, ["Fly"] = 59.05, ["Ride"] = 42.71, ["Fly|Ride"] = 127.34, ["Neon"] = 107.77, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 198.77, ["Mega"] = 425.39, ["Mega|Ride"] = 362.87, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 30.91, ["Fly"] = 64.32, ["Ride"] = 38.88, ["Fly|Ride"] = 73.37, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 244.13, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1006.37}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.15, ["Fly"] = 49.41, ["Ride"] = 16.88, ["Fly|Ride"] = 41.18, ["Neon"] = 47.16, ["Neon|Ride"] = 53.89, ["Neon|Fly|Ride"] = 112.29, ["Mega"] = 434.74, ["Mega|Ride"] = 487.31, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 8.29, ["Fly"] = 55.31, ["Ride"] = 36.74, ["Fly|Ride"] = 106, ["Neon"] = 51.98, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 79.75, ["Neon|Fly|Ride"] = 211.2, ["Mega"] = 539.24, ["Mega|Ride"] = 476.51, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 49.4, ["Fly"] = 72.18, ["Ride"] = 53.72, ["Fly|Ride"] = 102.37, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 278.1, ["Mega"] = 1478.97, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1437.19, ["Fly"] = 1410.94, ["Ride"] = 1407, ["Fly|Ride"] = 1435.88, ["Neon|Ride"] = 4872.99, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 12551.2}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 525, ["Ride"] = 453.24, ["Fly|Ride"] = 564.38, ["Neon|Ride"] = 3221.06, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15098.26, ["Mega|Fly|Ride"] = 9258.69}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 257.25, ["Fly"] = 378.23, ["Ride"] = 345.55, ["Fly|Ride"] = 462, ["Neon"] = 1575, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1575, ["Mega|Ride"] = 7309.49, ["Mega|Fly|Ride"] = 7757.74}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 41.79}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 48.54, ["Ride"] = 49.77, ["Fly|Ride"] = 110.25, ["Neon"] = 323.26, ["Neon|Fly"] = 575.38, ["Neon|Ride"] = 180.28, ["Neon|Fly|Ride"] = 560.81, ["Mega|Ride"] = 1185.22, ["Mega|Fly|Ride"] = 1008.2}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 18375, ["Ride"] = 37359.95, ["Fly|Ride"] = 16929.94, ["Neon|Fly|Ride"] = 37931.25, ["Mega"] = 215492.15, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 236.25, ["Fly"] = 284.82, ["Ride"] = 259.88, ["Fly|Ride"] = 315, ["Neon"] = 903, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 863.75, ["Neon|Fly|Ride"] = 912.18, ["Mega"] = 6470.25, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 144.38, ["Fly"] = 525, ["Ride"] = 101.48, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 76.99, ["Fly"] = 213.68, ["Ride"] = 106.46, ["Fly|Ride"] = 196.1, ["Neon|Ride"] = 675.6, ["Neon|Fly|Ride"] = 566.64, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 64.72, ["Ride"] = 33.43, ["Fly|Ride"] = 65.63, ["Neon"] = 81.63, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 155.17, ["Neon|Fly|Ride"] = 232.76, ["Mega"] = 1968.75, ["Mega|Ride"] = 718.68, ["Mega|Fly|Ride"] = 877.07}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4463.36, ["Ride"] = 4058.25, ["Fly|Ride"] = 4200, ["Neon"] = 21567.47, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81246.42}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.04, ["Fly"] = 47.74, ["Ride"] = 34.85, ["Fly|Ride"] = 59.29, ["Neon"] = 131.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 186.41, ["Mega|Ride"] = 1437.35, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 34.04, ["Fly"] = 101.3, ["Ride"] = 37.31, ["Fly|Ride"] = 89.63, ["Neon"] = 301.53, ["Neon|Fly"] = 287.69, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 320.25, ["Mega|Fly|Ride"] = 1437.35}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 434.43, ["Fly"] = 563.07, ["Ride"] = 480.27, ["Fly|Ride"] = 525, ["Neon"] = 1174.69, ["Neon|Fly"] = 1473.66, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1305.94, ["Mega|Fly|Ride"] = 4293.7}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 15.41, ["Fly"] = 30.76, ["Ride"] = 27.6, ["Fly|Ride"] = 43.73, ["Neon"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 150.94, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 640.03}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.82, ["Fly"] = 287.97, ["Ride"] = 34.5, ["Fly|Ride"] = 80.41, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 730.97}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.95, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 678.28, ["Mega|Fly|Ride"] = 4062.86}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.12, ["Fly"] = 539.21, ["Ride"] = 77.57, ["Fly|Ride"] = 144.39, ["Neon"] = 90.2, ["Neon|Fly"] = 144.39, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 443.93, ["Mega"] = 383.25, ["Mega|Fly"] = 487.31, ["Mega|Ride"] = 280.77}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4854.94, ["Fly"] = 6333.69, ["Ride"] = 4423.13, ["Fly|Ride"] = 4331.25, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 11576.14, ["Mega"] = 64702.35, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 32.82, ["Fly"] = 73.28, ["Ride"] = 51.45, ["Fly|Ride"] = 152.25, ["Neon"] = 233.62, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 861.98, ["Mega|Ride"] = 1787.83, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Ride"] = 6168.75, ["Fly|Ride"] = 6168.75, ["Neon"] = 22741, ["Neon|Fly|Ride"] = 15159.38, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.62, ["Fly"] = 23.87, ["Ride"] = 17.46, ["Fly|Ride"] = 33.62, ["Neon"] = 78.75, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 100.19, ["Mega"] = 210, ["Mega|Ride"] = 394.46, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.35, ["Fly"] = 29.58, ["Ride"] = 32.81, ["Fly|Ride"] = 52.5, ["Neon"] = 125, ["Neon|Fly"] = 238.12, ["Neon|Ride"] = 141.17, ["Neon|Fly|Ride"] = 168, ["Mega|Ride"] = 1007.28, ["Mega|Fly|Ride"] = 861.98}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.59}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.49, ["Fly"] = 32.82, ["Ride"] = 30.19, ["Fly|Ride"] = 89.45, ["Neon"] = 131.23, ["Neon|Ride"] = 137.94, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 1049.9, ["Mega|Ride"] = 1149.57, ["Mega|Fly|Ride"] = 1123.81}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.69, ["Fly"] = 190.37, ["Ride"] = 32.82, ["Fly|Ride"] = 153.01, ["Neon"] = 144.39, ["Neon|Ride"] = 272.87, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 1995, ["Mega|Ride"] = 861.98, ["Mega|Fly|Ride"] = 812.6}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.65, ["Fly"] = 27.57, ["Ride"] = 21, ["Fly|Ride"] = 42.66, ["Neon|Fly"] = 1075.15, ["Neon|Ride"] = 101.3, ["Neon|Fly|Ride"] = 127.98, ["Mega"] = 2588.11, ["Mega|Ride"] = 431.66, ["Mega|Fly|Ride"] = 627.1}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8611.08}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 23.63}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 194.86, ["Ride"] = 203.44, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1203.64}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.24, ["Fly"] = 97.48, ["Ride"] = 36.66, ["Fly|Ride"] = 137.94, ["Neon"] = 163.26, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 533.36, ["Mega|Ride"] = 2034.56, ["Mega|Fly|Ride"] = 533.36}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 11.69}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 26.25, ["Fly|Ride"] = 86.21, ["Neon"] = 155.17, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2489.82}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 240.19, ["Fly"] = 431, ["Ride"] = 262.5, ["Fly|Ride"] = 730.97, ["Neon"] = 1137.86, ["Neon|Ride"] = 650.56, ["Neon|Fly|Ride"] = 1068.85, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 64.32, ["Fly"] = 474.09, ["Ride"] = 79.93, ["Fly|Ride"] = 243.66, ["Neon"] = 414.22, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2012.71}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 182.44, ["Fly"] = 260.72, ["Ride"] = 225.75, ["Fly|Ride"] = 285.29, ["Neon"] = 945, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3663.38, ["Mega|Fly|Ride"] = 3161.28}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2625, ["Fly"] = 3304.59, ["Ride"] = 2537.27, ["Fly|Ride"] = 2546.25, ["Neon"] = 15134.03, ["Neon|Ride"] = 9745.98, ["Neon|Fly|Ride"] = 9258.69, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.25, ["Fly"] = 106.68, ["Ride"] = 55.95, ["Fly|Ride"] = 112.06, ["Neon"] = 127.32, ["Neon|Ride"] = 155.95, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 968.66, ["Mega|Ride"] = 1006.37, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 665.17, ["Fly"] = 2100, ["Ride"] = 701.64, ["Fly|Ride"] = 646.8, ["Neon|Fly|Ride"] = 5386.24}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 34.93}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 26.24, ["Ride"] = 47.43, ["Fly|Ride"] = 203.44, ["Neon"] = 105, ["Neon|Ride"] = 137.09, ["Neon|Fly|Ride"] = 244.6, ["Mega"] = 480.38, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.19, ["Fly"] = 42.73, ["Ride"] = 29.09, ["Fly|Ride"] = 75.55, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 455.63, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 394.73}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 51.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 21.1, ["Fly"] = 32.33, ["Ride"] = 26.25, ["Fly|Ride"] = 55.57, ["Neon"] = 142.24, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1221.86, ["Mega|Fly|Ride"] = 2156.9}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.18, ["Fly"] = 46.31, ["Ride"] = 32.15, ["Fly|Ride"] = 58.2, ["Neon"] = 287.69, ["Neon|Fly"] = 238.12, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 286.63, ["Mega"] = 1438.66, ["Mega|Ride"] = 1828.05, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7183.45, ["Fly"] = 4987.5, ["Ride"] = 6498.15, ["Fly|Ride"] = 5118.75, ["Neon|Fly|Ride"] = 10490.17, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.49, ["Fly"] = 46.82, ["Ride"] = 34.02, ["Fly|Ride"] = 86.21, ["Neon"] = 56.44, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 232.7, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 617.67}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 18.25}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.31, ["Fly"] = 381.76, ["Ride"] = 118.13, ["Fly|Ride"] = 203.46, ["Neon"] = 503.47, ["Neon|Ride"] = 487.31, ["Neon|Fly|Ride"] = 520.94, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 58.94, ["Fly"] = 192.86, ["Ride"] = 84.2, ["Fly|Ride"] = 174.71, ["Neon"] = 288.19, ["Neon|Fly"] = 389.85, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 575.38, ["Mega"] = 2438.15, ["Mega|Ride"] = 974.6, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.32, ["Fly"] = 81.9, ["Ride"] = 32.5, ["Fly|Ride"] = 65.62, ["Neon"] = 172.4, ["Neon|Fly"] = 232.76, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.21, ["Mega"] = 1016.21, ["Mega|Ride"] = 775.8, ["Mega|Fly|Ride"] = 812.6}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.57, ["Fly"] = 78.74, ["Ride"] = 30.85, ["Fly|Ride"] = 106.32, ["Neon"] = 32.89, ["Neon|Fly"] = 86.21, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 146.63, ["Mega"] = 250.69, ["Mega|Fly"] = 7189.92, ["Mega|Ride"] = 229.09, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.45, ["Fly"] = 65.63, ["Ride"] = 30.24, ["Fly|Ride"] = 96.98, ["Neon"] = 81.38, ["Neon|Ride"] = 119.41, ["Neon|Fly|Ride"] = 220.89, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 537.68}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.05, ["Fly"] = 29.84, ["Ride"] = 28.08, ["Fly|Ride"] = 51.19, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.4, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 207.38}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 23.72, ["Ride"] = 164.06, ["Fly|Ride"] = 287.69, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 425.62, ["Mega"] = 813.75, ["Mega|Ride"] = 767.17, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["Fly"] = 647.9, ["Ride"] = 1437.35, ["Fly|Ride"] = 647.9, ["Neon|Fly|Ride"] = 28732.67}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 54.01, ["Fly"] = 215.52, ["Ride"] = 89.25, ["Fly|Ride"] = 163.26, ["Neon"] = 210, ["Neon|Ride"] = 333.81, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1153.69, ["Mega|Ride"] = 1301.49, ["Mega|Fly|Ride"] = 1217.76}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1246.88, ["Ride"] = 1181.25, ["Fly|Ride"] = 1228.5, ["Neon"] = 4690.27, ["Neon|Fly"] = 4690.27, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3668.34, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 374.07, ["Fly"] = 719.34, ["Ride"] = 430.5, ["Fly|Ride"] = 563.03, ["Neon"] = 3164.18, ["Neon|Ride"] = 2117.72, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12929.55, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 57.74}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 32.79, ["Ride"] = 24.81, ["Fly|Ride"] = 63.58, ["Neon"] = 81.63, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 437.26, ["Mega|Ride"] = 718.68, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 223.5, ["Fly"] = 352.34, ["Ride"] = 283.14, ["Fly|Ride"] = 357, ["Neon"] = 846.02, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3015.83}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.38}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 112.25, ["Ride"] = 178.5, ["Fly|Ride"] = 316.76, ["Neon"] = 656.25, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2809.03, ["Mega|Ride"] = 2441.54, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 287.69, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 752.09, ["Neon|Ride"] = 431.79, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.29, ["Fly"] = 79.75, ["Ride"] = 28.59, ["Fly|Ride"] = 215.52, ["Neon"] = 31.18, ["Neon|Ride"] = 66.82, ["Neon|Fly|Ride"] = 252.13, ["Mega"] = 170.63, ["Mega|Ride"] = 209.9, ["Mega|Fly|Ride"] = 374.97}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.64, ["Fly"] = 50.4, ["Ride"] = 24.95, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 230.6, ["Mega|Ride"] = 754.24, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.82, ["Fly"] = 102.36, ["Ride"] = 34.5, ["Fly|Ride"] = 129.31, ["Neon"] = 85.31, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5.25, ["Fly"] = 172.4, ["Ride"] = 48.57, ["Fly|Ride"] = 155.97, ["Neon"] = 30.96, ["Neon|Fly"] = 105, ["Neon|Ride"] = 76.13, ["Neon|Fly|Ride"] = 205.82, ["Mega"] = 144.38, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 304.5}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.46, ["Ride"] = 315, ["Fly|Ride"] = 354.38, ["Neon"] = 1308.06, ["Neon|Ride"] = 1398.56, ["Neon|Fly|Ride"] = 1395.72, ["Mega"] = 3590.11, ["Mega|Ride"] = 5028.52, ["Mega|Fly|Ride"] = 6637.18}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 93.18, ["Fly"] = 575.9, ["Ride"] = 129.94, ["Fly|Ride"] = 213.98, ["Neon"] = 367.5, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 2022.57, ["Mega|Ride"] = 2730.31, ["Mega|Fly|Ride"] = 2076.82}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 67.4, ["Fly"] = 167.45, ["Ride"] = 81.79, ["Fly|Ride"] = 110.4, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 1625.16, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Fly"] = 127.32, ["Ride"] = 53.89, ["Fly|Ride"] = 287.69, ["Neon|Ride"] = 619.11, ["Neon|Fly|Ride"] = 325.28}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 13.13, ["Ride"] = 34.11, ["Fly|Ride"] = 91.85, ["Neon"] = 79.42, ["Neon|Ride"] = 86.37, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 791.12, ["Mega|Ride"] = 521.42, ["Mega|Fly|Ride"] = 575.38}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.14, ["Fly"] = 43.32, ["Ride"] = 24.38, ["Fly|Ride"] = 51.59, ["Neon"] = 19.69, ["Neon|Fly"] = 85.14, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 131.25, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 285.57}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 918.75, ["Ride"] = 913.5, ["Fly|Ride"] = 937.13, ["Neon"] = 3211.32, ["Neon|Fly"] = 3307.56, ["Neon|Ride"] = 8619.7, ["Neon|Fly|Ride"] = 2257.5, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 288.75, ["Fly"] = 334.03, ["Ride"] = 299.31, ["Fly|Ride"] = 341.25, ["Neon"] = 1824.54, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1402.66, ["Mega"] = 10783.75, ["Mega|Fly|Ride"] = 5036.24}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 96, ["Fly"] = 172.4, ["Ride"] = 130.71, ["Fly|Ride"] = 158.29, ["Neon"] = 422.75, ["Neon|Ride"] = 409.35, ["Neon|Fly|Ride"] = 558.15, ["Mega"] = 1575, ["Mega|Ride"] = 1742.79, ["Mega|Fly|Ride"] = 1868.82}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.99, ["Fly"] = 278, ["Ride"] = 216.57, ["Fly|Ride"] = 240.27, ["Neon|Ride"] = 1022.44, ["Neon|Fly|Ride"] = 1062.39, ["Mega"] = 10783.75, ["Mega|Fly|Ride"] = 4062.86}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 18.38, ["Fly"] = 58.2, ["Ride"] = 33.88, ["Fly|Ride"] = 80.07, ["Neon"] = 169.32, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 761.79, ["Mega|Fly|Ride"] = 1003.13}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 204.75, ["Ride"] = 275.63, ["Fly|Ride"] = 393.75, ["Neon"] = 1050.53, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1067.78, ["Mega"] = 4292.24, ["Mega|Fly|Ride"] = 4223.67}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 86.77, ["Fly"] = 126, ["Ride"] = 78.57, ["Fly|Ride"] = 129.31, ["Neon|Ride"] = 1626.23, ["Mega|Ride"] = 2301.43, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2800.33, ["Ride"] = 2330.09, ["Fly|Ride"] = 2546.25, ["Neon|Ride"] = 11371.13, ["Neon|Fly|Ride"] = 7350, ["Mega"] = 51761.9, ["Mega|Fly|Ride"] = 29309.69}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.58, ["Fly"] = 72.21, ["Ride"] = 44.63, ["Fly|Ride"] = 108.94, ["Neon"] = 45.93, ["Neon|Fly"] = 173.02, ["Neon|Ride"] = 101.74, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 273.69, ["Mega|Ride"] = 330.77, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 25.99, ["Ride"] = 59.07, ["Fly|Ride"] = 92.61, ["Neon"] = 216.57, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 381.32, ["Mega|Ride"] = 860.92, ["Mega|Fly|Ride"] = 1346.84}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.44, ["Fly"] = 94.29, ["Ride"] = 85.31, ["Fly|Ride"] = 71.9, ["Neon"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2231.24, ["Fly"] = 1626.23, ["Ride"] = 1073.62, ["Fly|Ride"] = 987.51, ["Neon|Ride"] = 5689.36, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 37001.1, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 430.49, ["Fly"] = 859.85, ["Ride"] = 773.29, ["Fly|Ride"] = 534.19}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 74.78, ["Fly"] = 118.13, ["Ride"] = 120.75, ["Fly|Ride"] = 253.22, ["Neon"] = 440.87, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 503.19, ["Mega"] = 2585.92, ["Mega|Ride"] = 2599.75, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.37, ["Ride"] = 18.9, ["Fly|Ride"] = 63.25, ["Neon"] = 86.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 130.37, ["Mega"] = 656.25, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 37.34, ["Fly"] = 68.25, ["Ride"] = 53.89, ["Fly|Ride"] = 84.73, ["Neon"] = 159.49, ["Neon|Fly"] = 359.89, ["Neon|Ride"] = 153.51, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 720.46, ["Fly"] = 1121.55, ["Ride"] = 890, ["Fly|Ride"] = 827.69, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 662.81}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5906.25, ["Fly|Ride"] = 5328.75, ["Neon"] = 42000, ["Neon|Ride"] = 30909.35, ["Neon|Fly|Ride"] = 27352.5, ["Mega|Fly|Ride"] = 71831.09}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 404.07, ["Ride"] = 342.65, ["Fly|Ride"] = 423.97, ["Neon"] = 1312.5, ["Neon|Fly|Ride"] = 2156.9, ["Mega"] = 6463.7, ["Mega|Fly|Ride"] = 6464.78}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 157.4, ["Fly|Ride"] = 190.32, ["Neon"] = 2153.86, ["Neon|Ride"] = 575.38, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 1939.45}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.36, ["Fly"] = 72.21, ["Ride"] = 40.14, ["Fly|Ride"] = 91.88, ["Neon"] = 142.24, ["Neon|Ride"] = 170.57, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 861.98, ["Mega|Fly|Ride"] = 786.56}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.85, ["Fly"] = 32.82, ["Ride"] = 25.86, ["Fly|Ride"] = 47.57, ["Neon"] = 215.52, ["Neon|Fly"] = 287.97, ["Neon|Ride"] = 101.3, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1077.47}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.6, ["Ride"] = 39.69, ["Fly|Ride"] = 103.79, ["Neon"] = 124.69, ["Neon|Ride"] = 158.8, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 641.1}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.11, ["Fly"] = 29.12, ["Ride"] = 22.32, ["Fly|Ride"] = 48.75, ["Neon"] = 37.83, ["Neon|Fly"] = 355.91, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 259.71}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 19.67, ["Ride"] = 51.18, ["Fly|Ride"] = 147, ["Neon"] = 159.49, ["Neon|Fly"] = 862.77, ["Neon|Ride"] = 136.85, ["Neon|Fly|Ride"] = 322.19, ["Mega"] = 630, ["Mega|Ride"] = 577.46, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 459.38, ["Fly"] = 590.63, ["Ride"] = 623.7, ["Fly|Ride"] = 630, ["Neon"] = 2585.92, ["Neon|Ride"] = 1711.02, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 7087.5}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.93, ["Fly"] = 19.69, ["Ride"] = 10.5, ["Fly|Ride"] = 38.07, ["Neon"] = 27.81, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 157.5, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 45.02, ["Fly"] = 118.11, ["Ride"] = 78.75, ["Fly|Ride"] = 141.75, ["Neon"] = 190.32, ["Neon|Ride"] = 210.18, ["Neon|Fly|Ride"] = 258.47, ["Mega"] = 551.25, ["Mega|Fly"] = 861.98, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 601.6}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.28, ["Fly"] = 970.74, ["Ride"] = 754.69, ["Fly|Ride"] = 825.57, ["Neon|Fly"] = 2154.94, ["Neon|Ride"] = 2299.33, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4287.94}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 26.74, ["Fly"] = 70.86, ["Ride"] = 49.88, ["Fly|Ride"] = 95.49, ["Neon"] = 280.88, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1219.08, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 883.94}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 360.96, ["Fly"] = 364.17, ["Ride"] = 266.52, ["Fly|Ride"] = 328.11, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4550.16}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 257.28, ["Fly"] = 330.75, ["Ride"] = 249.36, ["Fly|Ride"] = 362.25, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 4827.04}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 761.25, ["Ride"] = 721.88, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3593.35, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.48, ["Fly"] = 62.51, ["Ride"] = 71.13, ["Fly|Ride"] = 107.47, ["Neon"] = 49.88, ["Neon|Fly"] = 292.6, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 164.49, ["Mega"] = 347.31, ["Mega|Ride"] = 342.65, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3346.88, ["Fly"] = 3543.75, ["Ride"] = 3386.25, ["Fly|Ride"] = 3465, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19333.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 143.06, ["Fly"] = 178.47, ["Ride"] = 147, ["Fly|Ride"] = 204.98, ["Neon"] = 535.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 581.44, ["Mega"] = 3232.4, ["Mega|Fly|Ride"] = 3368.96}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 3.14, ["Fly"] = 30.69, ["Ride"] = 19.03, ["Fly|Ride"] = 43.12, ["Neon"] = 25.94, ["Neon|Fly"] = 43.12, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 86.21, ["Mega"] = 145.69, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 229.69, ["Mega|Fly|Ride"] = 292.4}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 29.16, ["Fly|Ride"] = 69.16, ["Neon"] = 29.18, ["Neon|Fly"] = 119.48, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 283.9, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 47.23, ["Fly"] = 55.34, ["Ride"] = 46.07, ["Fly|Ride"] = 65.81, ["Neon"] = 292.4, ["Neon|Ride"] = 409.45, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1236.94}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 918.75, ["Fly"] = 1169.54, ["Ride"] = 918.74, ["Fly|Ride"] = 1050, ["Neon"] = 4417.6, ["Neon|Ride"] = 5759.6, ["Neon|Fly|Ride"] = 4863.25}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Fly|Ride"] = 9100.47}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.69, ["Fly"] = 27.57, ["Ride"] = 27.56, ["Fly|Ride"] = 49.88, ["Neon"] = 176.76, ["Neon|Ride"] = 140.07, ["Neon|Fly|Ride"] = 170.5, ["Mega"] = 2520, ["Mega|Ride"] = 861.32, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.44, ["Fly"] = 58.2, ["Ride"] = 28.83, ["Fly|Ride"] = 76.74, ["Neon"] = 120.75, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 96.46, ["Ride"] = 103.74, ["Fly|Ride"] = 153.06, ["Neon|Ride"] = 624.94, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2755.09}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 173.25, ["Fly"] = 1150.64, ["Ride"] = 210, ["Fly|Ride"] = 314.79, ["Neon"] = 1299.88, ["Neon|Ride"] = 1234.78, ["Neon|Fly|Ride"] = 1029, ["Mega"] = 10774.62, ["Mega|Fly|Ride"] = 4249.51}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 34.5, ["Fly|Ride"] = 80.82, ["Neon"] = 31.19, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 70.88, ["Mega"] = 139.13, ["Mega|Fly"] = 240.29, ["Mega|Ride"] = 153.04, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 199.5, ["Fly"] = 257.25, ["Ride"] = 208.38, ["Fly|Ride"] = 290.07, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 727.13, ["Mega|Fly|Ride"] = 3110.84}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 25.73, ["Ride"] = 16.68, ["Fly|Ride"] = 48.69, ["Neon"] = 28.88, ["Neon|Fly"] = 129.31, ["Neon|Ride"] = 43.96, ["Neon|Fly|Ride"] = 123.94, ["Mega"] = 183.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 294.96, ["Fly"] = 354.38, ["Ride"] = 336, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1438.66, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 10784.47, ["Mega|Fly|Ride"] = 5523.54}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 7.88, ["Fly"] = 104.98, ["Ride"] = 28.88, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 309.66, ["Neon|Ride"] = 144.39, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 575.9, ["Mega|Ride"] = 443.93, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.1, ["Ride"] = 24.94, ["Neon"] = 8.49, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.32, ["Neon|Fly|Ride"] = 106.87, ["Mega"] = 94.38, ["Mega|Ride"] = 136.16, ["Mega|Fly|Ride"] = 276.56}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.79, ["Mega"] = 23.17, ["Mega|Ride"] = 144.39, ["Mega|Fly|Ride"] = 180.76}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.56, ["Fly|Ride"] = 115.31, ["Neon"] = 7.28, ["Neon|Ride"] = 28.29, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 72.27, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 248.54}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 72.19, ["Fly"] = 168.71, ["Ride"] = 104.99, ["Fly|Ride"] = 181.91, ["Neon"] = 281.54, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 402.98, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1432.67}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 37.79, ["Ride"] = 16.72, ["Fly|Ride"] = 84.05, ["Neon"] = 6.57, ["Neon|Ride"] = 28.02, ["Neon|Fly|Ride"] = 58.86, ["Mega"] = 73.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.56, ["Ride"] = 84, ["Neon"] = 82.27, ["Neon|Fly"] = 325.28, ["Neon|Ride"] = 211.99, ["Neon|Fly|Ride"] = 359.89, ["Mega"] = 406.88, ["Mega|Ride"] = 573.22, ["Mega|Fly|Ride"] = 575.38}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 17.05, ["Mega|Ride"] = 57.15, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.54, ["Ride"] = 11.58, ["Fly|Ride"] = 65.63, ["Neon"] = 2.1, ["Neon|Fly"] = 41.53, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 36.75, ["Mega"] = 12.98, ["Mega|Fly"] = 36.54, ["Mega|Ride"] = 20.18, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 16.17, ["Fly|Ride"] = 80.82, ["Neon"] = 2.1, ["Neon|Fly"] = 26.17, ["Neon|Ride"] = 17.16, ["Neon|Fly|Ride"] = 44.18, ["Mega"] = 17.79, ["Mega|Fly"] = 163.26, ["Mega|Ride"] = 35.81, ["Mega|Fly|Ride"] = 92.75}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 19.68, ["Mega|Ride"] = 109.51, ["Mega|Fly|Ride"] = 244.6}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.91, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 4.81, ["Neon|Fly"] = 122.84, ["Neon|Ride"] = 23.44, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.27, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 90.67}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 24.38, ["Neon|Fly|Ride"] = 431, ["Mega"] = 17.05, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.57, ["Fly"] = 53.13, ["Ride"] = 30.75, ["Fly|Ride"] = 163.26, ["Neon"] = 32.82, ["Neon|Fly"] = 144.39, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 184.31, ["Mega"] = 223.11, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 353.97}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 41.44, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 17.07, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 136.85, ["Mega|Fly|Ride"] = 194.94}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Fly|Ride"] = 144.39, ["Neon"] = 23.62, ["Mega"] = 119.42, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.63, ["Ride"] = 26.24, ["Neon"] = 22.97, ["Mega"] = 133.61, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.54, ["Ride"] = 32.82, ["Neon"] = 3.64, ["Neon|Ride"] = 27.4, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 22.29, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.52, ["Ride"] = 16.17, ["Fly|Ride"] = 40.68, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 15.17, ["Neon|Fly|Ride"] = 34.12, ["Mega"] = 14.23, ["Mega|Fly"] = 21.91, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.7}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 5.25, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.12, ["Neon"] = 39.8, ["Neon|Ride"] = 140.07, ["Mega"] = 201.69, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Fly|Ride"] = 48.75, ["Neon"] = 3.42, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 28.29, ["Mega|Ride"] = 166.8, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.14, ["Neon"] = 17.56, ["Neon|Ride"] = 195.11, ["Mega"] = 105.7, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 38.07, ["Neon"] = 11.71, ["Neon|Ride"] = 50.7, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.27, ["Ride"] = 11.81, ["Fly|Ride"] = 36.65, ["Neon"] = 2.1, ["Neon|Fly"] = 19.88, ["Neon|Ride"] = 12.75, ["Neon|Fly|Ride"] = 30.55, ["Mega"] = 13.63, ["Mega|Fly"] = 27.89, ["Mega|Ride"] = 23.29, ["Mega|Fly|Ride"] = 51.96}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.94, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 3.48, ["Fly"] = 118.13, ["Ride"] = 28.88, ["Fly|Ride"] = 93.19, ["Neon"] = 72.21, ["Neon|Ride"] = 72.21, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 304.5, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 58.2, ["Ride"] = 13.13, ["Fly|Ride"] = 41.62, ["Neon"] = 2.1, ["Neon|Fly"] = 20.06, ["Neon|Ride"] = 15.43, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 23.16, ["Mega|Fly"] = 50.66, ["Mega|Ride"] = 35.85, ["Mega|Fly|Ride"] = 84.07}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 180.12, ["Ride"] = 21.56, ["Neon"] = 11.66, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 46.24, ["Mega|Fly"] = 163.37, ["Mega|Ride"] = 119.61, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.43, ["Fly|Ride"] = 131.25, ["Neon"] = 2.63, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 32.8, ["Mega|Fly"] = 116.93, ["Mega|Ride"] = 79.75, ["Mega|Fly|Ride"] = 381.29}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 27.57, ["Neon"] = 2.63, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 15.74, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 72.21, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.72, ["Ride"] = 23.63, ["Fly|Ride"] = 55.42, ["Neon"] = 7.21, ["Neon|Fly"] = 58.2, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 74.81, ["Mega"] = 105.21, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.59, ["Neon"] = 6, ["Neon|Ride"] = 58.11, ["Mega"] = 47.25, ["Mega|Fly"] = 215.52, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 17.97, ["Fly|Ride"] = 40.68, ["Neon"] = 6.44, ["Neon|Fly"] = 77.59, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 84, ["Mega"] = 114.19, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 112.06, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 32.32, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 323.55, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 647.04}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 21.45, ["Fly|Ride"] = 47.43, ["Neon"] = 6.36, ["Neon|Fly"] = 48.75, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 215.25, ["Mega|Fly"] = 420, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 163.49}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.1, ["Ride"] = 21.17, ["Fly|Ride"] = 64.66, ["Neon"] = 13.01, ["Neon|Fly"] = 32.1, ["Neon|Ride"] = 29.58, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 215.52, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 135.22, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.35, ["Fly|Ride"] = 144.39, ["Neon"] = 101.3, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 323.26}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.51, ["Ride"] = 92.61, ["Neon"] = 90.53, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 41.58, ["Neon"] = 56.44, ["Neon|Ride"] = 115.31, ["Mega"] = 233.63, ["Mega|Ride"] = 259.17}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.23, ["Ride"] = 72.18, ["Fly|Ride"] = 120.75, ["Neon"] = 52.44, ["Neon|Ride"] = 75.93, ["Neon|Fly|Ride"] = 123.94, ["Mega"] = 224.24, ["Mega|Ride"] = 287.24, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 16.8, ["Mega|Fly"] = 214.43, ["Mega|Ride"] = 129.42, ["Mega|Fly|Ride"] = 244.6}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 3.94, ["Fly"] = 23.63, ["Ride"] = 20.58, ["Fly|Ride"] = 54.96, ["Neon"] = 45.93, ["Neon|Fly"] = 187.51, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 288.75, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 193.46}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.5, ["Neon"] = 5.2, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 28.02, ["Mega|Fly"] = 144.39, ["Mega|Ride"] = 68.06, ["Mega|Fly|Ride"] = 129.55}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.12, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 34.12, ["Mega|Ride"] = 61.37, ["Mega|Fly|Ride"] = 135.78}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.65, ["Ride"] = 16.12, ["Fly|Ride"] = 45.73, ["Neon"] = 9.66, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 161.94, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 162.03}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 56.03, ["Ride"] = 32.15, ["Fly|Ride"] = 114.53, ["Neon"] = 48.2, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 132.22, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 258.61}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 2.63, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 18.37, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 50.76, ["Mega|Fly|Ride"] = 161.63}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.18, ["Fly|Ride"] = 59.07, ["Neon"] = 6.32, ["Neon|Fly"] = 114.6, ["Neon|Ride"] = 18, ["Neon|Fly|Ride"] = 97.48, ["Mega"] = 39.63, ["Mega|Fly"] = 144.39, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 133.62}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 17.92, ["Fly|Ride"] = 36.31, ["Neon"] = 5.9, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 21.38, ["Neon|Fly|Ride"] = 62.9, ["Mega"] = 86.21, ["Mega|Fly"] = 144.39, ["Mega|Ride"] = 121.88, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 5.24, ["Fly"] = 91.88, ["Ride"] = 40.69, ["Fly|Ride"] = 131.25, ["Neon"] = 13.63, ["Neon|Ride"] = 72.21, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 82.05, ["Mega|Ride"] = 152.94, ["Mega|Fly|Ride"] = 288.19}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 156966.06, ["Mega"] = 15.28, ["Mega|Fly"] = 128.5, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.35, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.78, ["Neon|Fly|Ride"] = 67.68, ["Mega"] = 19.25, ["Mega|Fly"] = 72.21, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 32.91, ["Mega"] = 17.07, ["Mega|Ride"] = 131.25}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.32, ["Mega|Ride"] = 207.24, ["Mega|Fly|Ride"] = 163.26}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 15.89, ["Fly|Ride"] = 69.56, ["Neon"] = 3.14, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 18.29, ["Neon|Fly|Ride"] = 48.89, ["Mega"] = 32.82, ["Mega|Ride"] = 50.66, ["Mega|Fly|Ride"] = 107.67}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.3, ["Ride"] = 78.75, ["Fly|Ride"] = 215.52, ["Neon"] = 81.63, ["Neon|Ride"] = 78.75, ["Mega"] = 367.52, ["Mega|Ride"] = 483.13, ["Mega|Fly|Ride"] = 588.3}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 46.34, ["Neon"] = 43.32, ["Neon|Ride"] = 157.5, ["Mega"] = 243.66, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.91, ["Fly|Ride"] = 105, ["Neon"] = 25.17, ["Neon|Ride"] = 144.39, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 230.35, ["Mega|Ride"] = 273.94, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.65, ["Ride"] = 10.5, ["Fly|Ride"] = 25.27, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 11.58, ["Neon|Fly|Ride"] = 41.16, ["Mega"] = 14.15, ["Mega|Fly"] = 22.95, ["Mega|Ride"] = 22.66, ["Mega|Fly|Ride"] = 54.57}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.35, ["Neon"] = 10.59, ["Neon|Fly"] = 68.98, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 719.34, ["Mega"] = 122.84, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.42, ["Mega|Fly"] = 144.39, ["Mega|Fly|Ride"] = 188.98}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.04, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 26.25, ["Mega|Fly"] = 215.52, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.39, ["Ride"] = 20.02, ["Fly|Ride"] = 46.65, ["Neon"] = 6.57, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 33.48, ["Neon|Fly|Ride"] = 85.07, ["Mega"] = 168, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 216.33, ["Ride"] = 236.25, ["Fly|Ride"] = 814.08, ["Neon|Ride"] = 926.5, ["Neon|Fly|Ride"] = 949.04, ["Mega"] = 8626.99, ["Mega|Fly|Ride"] = 3311.73}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.33, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.69, ["Ride"] = 24.95, ["Fly|Ride"] = 65.62, ["Neon"] = 28.02, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 172.56, ["Mega"] = 387.21, ["Mega|Ride"] = 276.56, ["Mega|Fly|Ride"] = 343.23}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 14.44, ["Fly|Ride"] = 32.81, ["Neon"] = 4.13, ["Neon|Fly"] = 33.43, ["Neon|Ride"] = 23.15, ["Neon|Fly|Ride"] = 58.2, ["Mega"] = 49.77, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 84.17, ["Mega|Fly|Ride"] = 115.31}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.28, ["Ride"] = 19.69, ["Fly|Ride"] = 131.33, ["Neon"] = 9.49, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 85.14, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 16.12, ["Fly|Ride"] = 43.32, ["Neon"] = 30.86, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 958.71, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Ride"] = 34.5, ["Fly|Ride"] = 117.26, ["Neon"] = 51.19, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 244.62, ["Mega|Ride"] = 238.12, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 23.88, ["Ride"] = 16.95, ["Fly|Ride"] = 32.82, ["Neon"] = 35.44, ["Neon|Fly"] = 95.04, ["Neon|Ride"] = 26.17, ["Neon|Fly|Ride"] = 81.63, ["Mega"] = 262.5, ["Mega|Ride"] = 373.9, ["Mega|Fly|Ride"] = 343.03}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.36, ["Ride"] = 78.75, ["Fly|Ride"] = 149.41, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 372.44, ["Neon|Fly|Ride"] = 365.97, ["Mega"] = 2012.71, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 431.39, ["Ride"] = 242.82, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1137.86, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 12940.49, ["Mega|Fly|Ride"] = 3593.35}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 107.77, ["Ride"] = 64.03, ["Fly|Ride"] = 116.06, ["Neon"] = 487.31, ["Neon|Fly"] = 365.28, ["Neon|Ride"] = 299.25, ["Neon|Fly|Ride"] = 344.79, ["Mega|Fly|Ride"] = 1868.34}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.3, ["Fly"] = 288.3, ["Ride"] = 23.16, ["Neon"] = 16.95, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Neon|Fly|Ride"] = 154.07, ["Mega"] = 238.88, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.03, ["Fly"] = 79.83, ["Ride"] = 30.05, ["Fly|Ride"] = 65.63, ["Neon"] = 65.63, ["Neon|Ride"] = 93.92, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 313.59, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 36.18, ["Ride"] = 18.26, ["Fly|Ride"] = 50.66, ["Neon"] = 5.25, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 20.16, ["Neon|Fly|Ride"] = 59.95, ["Mega"] = 36.61, ["Mega|Fly"] = 148.74, ["Mega|Ride"] = 80.88, ["Mega|Fly|Ride"] = 553.1}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.69, ["Fly"] = 68.98, ["Ride"] = 32.8, ["Fly|Ride"] = 65.81, ["Neon"] = 106.68, ["Neon|Fly"] = 287.69, ["Neon|Ride"] = 114.22, ["Neon|Fly|Ride"] = 273.8, ["Mega"] = 517.19, ["Mega|Ride"] = 553.1, ["Mega|Fly|Ride"] = 533.36}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.26, ["Fly|Ride"] = 45.94, ["Neon"] = 18.38, ["Neon|Fly"] = 51.74, ["Neon|Ride"] = 28.05, ["Neon|Fly|Ride"] = 89.32, ["Mega"] = 144.22, ["Mega|Ride"] = 254.39, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.9, ["Fly"] = 38.81, ["Ride"] = 20.33, ["Fly|Ride"] = 328.13, ["Neon"] = 26.37, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 203.72, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 230.6, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.38, ["Neon"] = 2.1, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 15.27, ["Mega|Ride"] = 43.12, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.8, ["Ride"] = 18.93, ["Fly|Ride"] = 44.63, ["Neon"] = 13.12, ["Neon|Fly"] = 107.85, ["Neon|Ride"] = 33.43, ["Neon|Fly|Ride"] = 146.18, ["Mega"] = 78.72, ["Mega|Fly"] = 107.77, ["Mega|Ride"] = 106.68, ["Mega|Fly|Ride"] = 214.6}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 60.38, ["Ride"] = 20.95, ["Fly|Ride"] = 74.87, ["Neon"] = 22.74, ["Neon|Ride"] = 47.25, ["Mega"] = 144.38, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 267.23}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 106.31, ["Fly"] = 178.87, ["Ride"] = 145.83, ["Fly|Ride"] = 194.25, ["Neon"] = 430.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 2438.15, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 4.82, ["Ride"] = 240.29, ["Fly|Ride"] = 131.25, ["Neon"] = 33.66, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 21.56, ["Fly|Ride"] = 58.2, ["Neon"] = 13.13, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 127.35, ["Mega"] = 223.13, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.48, ["Ride"] = 39.38, ["Fly|Ride"] = 165.55, ["Neon"] = 99.29, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 520.84, ["Mega|Fly"] = 862.71, ["Mega|Ride"] = 446.25, ["Mega|Fly|Ride"] = 677.55}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.68}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 6.14, ["Ride"] = 95.82, ["Fly|Ride"] = 128.23, ["Neon"] = 52.5, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 485.63, ["Mega|Ride"] = 631.41, ["Mega|Fly|Ride"] = 861.98}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 21.14, ["Fly"] = 42, ["Ride"] = 29.94, ["Fly|Ride"] = 48.33, ["Neon"] = 90.57, ["Neon|Fly"] = 107.77, ["Neon|Ride"] = 137.94, ["Neon|Fly|Ride"] = 150.91, ["Mega"] = 1392.29, ["Mega|Fly|Ride"] = 675.6}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Neon|Ride"] = 44.6, ["Neon|Fly|Ride"] = 62.14, ["Mega"] = 27.46, ["Mega|Fly"] = 189, ["Mega|Ride"] = 70.02, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.03, ["Fly"] = 26.21, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 64.66, ["Mega"] = 287.69, ["Mega|Fly"] = 407.17, ["Mega|Ride"] = 325.42, ["Mega|Fly|Ride"] = 517.19}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 18.53, ["Fly|Ride"] = 32.99, ["Neon"] = 16.27, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 29.16, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 194.31, ["Mega|Ride"] = 219.82, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 80.82, ["Neon"] = 3.68, ["Neon|Fly"] = 273.69, ["Neon|Ride"] = 29.12, ["Mega"] = 64.07, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 44.25, ["Fly"] = 105, ["Ride"] = 79.86, ["Fly|Ride"] = 105, ["Neon"] = 177.61, ["Neon|Ride"] = 242.44, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 859.85, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 48.57, ["Fly|Ride"] = 210, ["Neon"] = 93.76, ["Neon|Ride"] = 42.66, ["Mega|Ride"] = 323.26}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 2.1, ["Fly"] = 24.8, ["Ride"] = 22.02, ["Fly|Ride"] = 60.38, ["Neon"] = 10.5, ["Neon|Fly"] = 86.21, ["Neon|Ride"] = 31.17, ["Neon|Fly|Ride"] = 96.47, ["Mega"] = 200.17, ["Mega|Ride"] = 150.55, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 63.74, ["Fly"] = 145.01, ["Ride"] = 127.16, ["Neon"] = 576.45, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4550.16, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 3830.06}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 7.59, ["Fly"] = 46.51, ["Ride"] = 24.94, ["Fly|Ride"] = 55.55, ["Neon"] = 33.71, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 123.38, ["Mega"] = 262.4, ["Mega|Ride"] = 222.95, ["Mega|Fly|Ride"] = 309.26}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.17, ["Fly"] = 143.07, ["Ride"] = 118.11, ["Fly|Ride"] = 210, ["Neon"] = 245.13, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 359.4, ["Mega"] = 1019.82, ["Mega|Ride"] = 1073.29, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 14.44, ["Ride"] = 45.94, ["Fly|Ride"] = 167.02, ["Neon"] = 59.07, ["Neon|Ride"] = 95.08, ["Neon|Fly|Ride"] = 214.8, ["Mega"] = 346.03, ["Mega|Ride"] = 344.61, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 25.89, ["Fly|Ride"] = 72.43, ["Neon"] = 98.84, ["Neon|Fly|Ride"] = 144.54, ["Mega"] = 570.33, ["Mega|Ride"] = 573.22, ["Mega|Fly|Ride"] = 633.07}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 16.21, ["Ride"] = 53.82, ["Fly|Ride"] = 103.95, ["Neon"] = 59.29, ["Neon|Ride"] = 137.11, ["Neon|Fly|Ride"] = 258.61, ["Mega"] = 398.95, ["Mega|Fly"] = 524.74, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 399.28}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.29, ["Ride"] = 29.39, ["Fly|Ride"] = 64.66, ["Neon"] = 38.68, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 139.2, ["Mega"] = 223.02, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 454.07}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.24, ["Neon|Fly"] = 101.3, ["Neon|Ride"] = 86.21, ["Mega"] = 19.49, ["Mega|Ride"] = 144.39}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.61, ["Ride"] = 141.75, ["Fly|Ride"] = 325.9, ["Neon"] = 40.72, ["Neon|Ride"] = 207.24, ["Mega"] = 238.88, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 732.68}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.36, ["Ride"] = 29.12, ["Neon"] = 26.22, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 227.73, ["Mega|Ride"] = 418.07, ["Mega|Fly|Ride"] = 325.28}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.68, ["Ride"] = 32.8, ["Neon"] = 15.88, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.39, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 514.55, ["Ride"] = 557.81, ["Fly|Ride"] = 630, ["Neon"] = 2154.94, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5932.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.81, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 64.32, ["Neon"] = 42.07, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 331.53, ["Mega"] = 201.51, ["Mega|Ride"] = 374.27, ["Mega|Fly|Ride"] = 357.73}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 14.39, ["Fly"] = 61.73, ["Ride"] = 19.46, ["Fly|Ride"] = 55.21, ["Neon"] = 93.76, ["Neon|Fly"] = 315, ["Neon|Ride"] = 97.48, ["Neon|Fly|Ride"] = 90.04, ["Mega"] = 331.87, ["Mega|Ride"] = 395.45, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.07, ["Fly|Ride"] = 50.7, ["Neon"] = 16.45, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 258.61}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 23.09, ["Fly|Ride"] = 90.57, ["Neon"] = 7.88, ["Neon|Ride"] = 38.81, ["Neon|Fly|Ride"] = 161.63, ["Mega"] = 95.71, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Neon"] = 2.1, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 195.07, ["Mega"] = 23.63, ["Mega|Ride"] = 81.63, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.12}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 10.5, ["Ride"] = 42.32, ["Fly|Ride"] = 182.77, ["Neon"] = 70.88, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 359.4, ["Mega"] = 334.69, ["Mega|Ride"] = 359.4, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.34, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1006.37, ["Mega"] = 39.38, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.94, ["Fly"] = 331.77, ["Ride"] = 91.88, ["Fly|Ride"] = 431.39, ["Neon"] = 59.06, ["Neon|Ride"] = 111.71, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Fly"] = 537.68, ["Mega|Ride"] = 355.59, ["Mega|Fly|Ride"] = 487.31}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.5, ["Ride"] = 446.24, ["Fly|Ride"] = 531.57, ["Neon"] = 1681.2, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1311.45, ["Mega"] = 8080.98, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.5, ["Fly"] = 196.88, ["Ride"] = 32.82, ["Fly|Ride"] = 129.31, ["Neon"] = 210, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 194.94, ["Mega"] = 306.57, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 517.67}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.04, ["Ride"] = 35.27, ["Fly|Ride"] = 118.11, ["Neon"] = 3.68, ["Neon|Ride"] = 31.4, ["Neon|Fly|Ride"] = 101.3, ["Mega"] = 37.97, ["Mega|Ride"] = 58.06, ["Mega|Fly|Ride"] = 194.91}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Neon"] = 2.63, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 31.5, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 29.57, ["Fly"] = 107.77, ["Ride"] = 100.42, ["Fly|Ride"] = 172.4, ["Neon"] = 129.84, ["Neon|Fly"] = 163.26, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 441.31, ["Mega"] = 650.82, ["Mega|Ride"] = 704.67, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.24, ["Neon"] = 95.82, ["Neon|Ride"] = 270.71, ["Neon|Fly|Ride"] = 862.77, ["Mega"] = 568.94, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.36, ["Ride"] = 76.13, ["Fly|Ride"] = 215.97, ["Neon"] = 101.07, ["Neon|Ride"] = 172.4, ["Mega"] = 666.4, ["Mega|Ride"] = 637.87, ["Mega|Fly|Ride"] = 1268.67}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 14.44, ["Ride"] = 56.36, ["Fly|Ride"] = 217.9, ["Neon"] = 131.25, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 652.16, ["Mega|Ride"] = 790.88, ["Mega|Fly|Ride"] = 633.51}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.82, ["Fly|Ride"] = 732.68, ["Neon"] = 1069.69, ["Neon|Ride"] = 1294.92, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.29, ["Ride"] = 60.27, ["Fly|Ride"] = 139.71, ["Neon"] = 148.32, ["Neon|Ride"] = 193.96, ["Mega|Ride"] = 562.42, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.19, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 91.88, ["Neon|Ride"] = 144.39, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 36.75, ["Ride"] = 141.8, ["Fly|Ride"] = 452.82, ["Neon"] = 182.43, ["Neon|Ride"] = 263.93, ["Neon|Fly|Ride"] = 538.75, ["Mega"] = 384.56, ["Mega|Ride"] = 478.41, ["Mega|Fly|Ride"] = 601.47}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 59.07, ["Fly|Ride"] = 215.71, ["Neon"] = 7.58, ["Neon|Fly"] = 84.3, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 279.08, ["Mega"] = 76.13, ["Mega|Ride"] = 172.4, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.57, ["Ride"] = 92, ["Neon"] = 262.42, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1644.65, ["Mega|Ride"] = 2855.54, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 106.68, ["Ride"] = 28.54, ["Neon"] = 9.06, ["Neon|Fly"] = 187.51, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 72.06, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 195.57}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 48.75, ["Fly|Ride"] = 99.9, ["Neon"] = 3.77, ["Neon|Fly"] = 58.2, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 32.82, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 70.6, ["Mega|Fly|Ride"] = 287.69}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 130.46, ["Neon"] = 11.44, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 84, ["Mega|Ride"] = 101.51, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 60.31, ["Fly"] = 105, ["Ride"] = 72.19, ["Fly|Ride"] = 148.74, ["Neon"] = 300.57, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 487.31, ["Mega|Ride"] = 1149.67, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 3.93, ["Ride"] = 36.65, ["Neon"] = 25.99, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 32.99, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 125.99, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 20.76, ["Fly|Ride"] = 78.75, ["Neon"] = 7.23, ["Neon|Ride"] = 78.75, ["Mega"] = 52.5, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 107.77, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 163.37, ["Mega"] = 342.65, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 4.99, ["Fly"] = 78.75, ["Ride"] = 58.31, ["Fly|Ride"] = 154.87, ["Neon"] = 19.69, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 201.51, ["Mega"] = 189, ["Mega|Ride"] = 198.61, ["Mega|Fly|Ride"] = 366.12}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.63, ["Ride"] = 71.61, ["Neon"] = 5.92, ["Neon|Ride"] = 99.15, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 96.98, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 287.69}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.43, ["Fly|Ride"] = 62.23, ["Neon"] = 5.09, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.76, ["Neon|Fly|Ride"] = 95.43, ["Mega"] = 40.69, ["Mega|Ride"] = 104.78, ["Mega|Fly|Ride"] = 262.12}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 27.51, ["Ride"] = 20.51, ["Fly|Ride"] = 57.74, ["Neon"] = 18.09, ["Neon|Fly"] = 102.46, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 163.26, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 19.67, ["Fly"] = 72.21, ["Ride"] = 29.08, ["Fly|Ride"] = 80.82, ["Neon"] = 140.75, ["Neon|Ride"] = 243.66, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 459.38, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 650.56}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.98, ["Ride"] = 90.56, ["Fly|Ride"] = 139.13, ["Neon"] = 363.72, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2140.93, ["Mega|Ride"] = 1939.45, ["Mega|Fly|Ride"] = 1515.32}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.51, ["Fly|Ride"] = 144.38, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 33.34, ["Neon|Fly|Ride"] = 144.54, ["Mega"] = 34.8, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.76, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.65, ["Fly|Ride"] = 42.95, ["Neon"] = 4.18, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 40.68, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 43.12, ["Ride"] = 38.03, ["Fly|Ride"] = 107.77, ["Neon"] = 40.68, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 546.28, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.73, ["Ride"] = 496.4, ["Fly|Ride"] = 577.5, ["Neon"] = 4313.8, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.79, ["Fly"] = 99.75, ["Ride"] = 56.57, ["Fly|Ride"] = 130.24, ["Neon"] = 150.94, ["Neon|Ride"] = 228.43, ["Neon|Fly|Ride"] = 215.52, ["Mega"] = 720.57, ["Mega|Ride"] = 838.28, ["Mega|Fly|Ride"] = 893.01}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.87, ["Fly|Ride"] = 91.87, ["Neon"] = 7.71, ["Neon|Ride"] = 49.41, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 131.25, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 288.29}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 86.46, ["Ride"] = 61.13, ["Fly|Ride"] = 261.97, ["Neon"] = 72.21, ["Mega"] = 157.5}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 78.75, ["Fly"] = 169.31, ["Ride"] = 37.73, ["Fly|Ride"] = 78.66, ["Neon"] = 190.38, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 260.72, ["Mega"] = 2588.11, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.94, ["Ride"] = 128.63, ["Fly|Ride"] = 175.51, ["Neon"] = 430.1, ["Neon|Fly"] = 818.89, ["Neon|Ride"] = 533.36, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3164.18, ["Mega|Fly|Ride"] = 6470.25}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 241.98, ["Ride"] = 295.32, ["Fly|Ride"] = 537.68, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 8.7, ["Ride"] = 39.38, ["Fly|Ride"] = 201.51, ["Neon"] = 65.63, ["Neon|Ride"] = 88.49, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 862.71, ["Mega|Ride"] = 391.1, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 10.5, ["Fly|Ride"] = 38.75, ["Neon"] = 7.07, ["Neon|Ride"] = 26.81, ["Neon|Fly|Ride"] = 61.34, ["Mega"] = 101.3, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.63, ["Fly"] = 47.25, ["Ride"] = 21.41, ["Fly|Ride"] = 63, ["Neon"] = 26.23, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 97.11, ["Mega"] = 284.46, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Ride"] = 374.06, ["Fly|Ride"] = 760.7, ["Neon"] = 1470.67, ["Neon|Fly|Ride"] = 2112.92, ["Mega"] = 10784.47, ["Mega|Fly|Ride"] = 6037.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 33.43, ["Neon"] = 9.98, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 35.25, ["Mega|Ride"] = 172.4, ["Mega|Fly|Ride"] = 442.18}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 2.1, ["Ride"] = 16.04, ["Fly|Ride"] = 41, ["Neon"] = 24.43, ["Neon|Ride"] = 38.81, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 159.49, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.08, ["Ride"] = 57.29, ["Neon"] = 105, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 538.84, ["Mega|Ride"] = 567.83, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 119.41, ["Fly"] = 157.5, ["Ride"] = 144.64, ["Fly|Ride"] = 165.38, ["Neon|Ride"] = 812.6, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2128}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 15.33, ["Fly"] = 37.05, ["Ride"] = 27.56, ["Fly|Ride"] = 56.44, ["Neon"] = 102.92, ["Neon|Ride"] = 111.57, ["Neon|Fly|Ride"] = 147, ["Mega"] = 875.44, ["Mega|Ride"] = 381.42, ["Mega|Fly|Ride"] = 477.43}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 35.95, ["Neon"] = 2.1, ["Neon|Ride"] = 76.52, ["Mega"] = 25.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 17.07, ["Fly|Ride"] = 86.16, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 22.3, ["Mega|Fly"] = 93.76, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 215.52}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 13.64, ["Fly"] = 103.28, ["Ride"] = 98.95, ["Fly|Ride"] = 260.08, ["Neon"] = 38.07, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 228.03, ["Mega"] = 165.38, ["Mega|Ride"] = 212.4, ["Mega|Fly|Ride"] = 312.37}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.25, ["Fly"] = 1520.38, ["Ride"] = 1179.94, ["Fly|Ride"] = 1390.64, ["Neon"] = 3543.75, ["Neon|Ride"] = 4309.86, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 452.82, ["Ride"] = 463.1, ["Fly|Ride"] = 545.99, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 15097.24, ["Mega|Fly|Ride"] = 6316.77}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 320.24, ["Fly"] = 411.78, ["Ride"] = 354.21, ["Fly|Ride"] = 426.57, ["Neon"] = 759.94, ["Neon|Fly"] = 1137.86, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 724.5, ["Mega|Ride"] = 3593.35, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 227.67, ["Fly"] = 288.75, ["Ride"] = 288.33, ["Fly|Ride"] = 367.5, ["Neon"] = 654.89, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 649.85, ["Mega|Fly|Ride"] = 3238.3}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 41.26, ["Ride"] = 19.53, ["Fly|Ride"] = 47.39, ["Neon"] = 4.99, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 79.75, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 163.26}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 270.11, ["Fly"] = 1437.35, ["Ride"] = 359.63, ["Fly|Ride"] = 389.82, ["Neon"] = 1312.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1360.32, ["Mega"] = 21856.88, ["Mega|Ride"] = 5747.19, ["Mega|Fly|Ride"] = 4174.14}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 3.94, ["Fly"] = 157.5, ["Ride"] = 52.49, ["Neon"] = 27.87, ["Neon|Fly|Ride"] = 286.63, ["Mega"] = 219.95, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 748.06}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 22.98, ["Ride"] = 16.47, ["Fly|Ride"] = 39.38, ["Neon"] = 6.33, ["Neon|Ride"] = 53.89, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 128.23, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 131.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.88, ["Mega"] = 21.88, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.49, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8122.05, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 18.47, ["Mega"] = 357.73, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 29.12, ["Neon"] = 2.48, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.26, ["Mega|Ride"] = 163.32, ["Mega|Fly|Ride"] = 112.21}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 3.94, ["Fly"] = 86.21, ["Ride"] = 41.48, ["Fly|Ride"] = 91.88, ["Neon"] = 26.97, ["Neon|Fly"] = 107.77, ["Neon|Ride"] = 84.79, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 192.05, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.97, ["Fly"] = 32.43, ["Ride"] = 22.3, ["Fly|Ride"] = 48.9, ["Neon"] = 27.57, ["Neon|Ride"] = 144.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 244.83, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 7.93, ["Ride"] = 38.07, ["Fly|Ride"] = 146.21, ["Neon"] = 28.4, ["Neon|Ride"] = 172.4, ["Neon|Fly|Ride"] = 325.28, ["Mega"] = 524.99, ["Mega|Ride"] = 560.8}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6502.48, ["Ride"] = 21.87, ["Fly|Ride"] = 190.32, ["Neon"] = 64.96, ["Neon|Ride"] = 214.43, ["Neon|Fly|Ride"] = 730.97, ["Mega"] = 367.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 554.49}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 70.6, ["Ride"] = 17.07, ["Fly|Ride"] = 42.08, ["Neon"] = 2.1, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.66, ["Mega"] = 46.37, ["Mega|Fly|Ride"] = 226.61}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 162.75, ["Fly"] = 238.12, ["Ride"] = 190.19, ["Fly|Ride"] = 196.88, ["Neon"] = 977.27, ["Neon|Ride"] = 1030.07, ["Neon|Fly|Ride"] = 1400.7, ["Mega"] = 8626.99, ["Mega|Fly|Ride"] = 4385.71}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 24.2, ["Ride"] = 17.26, ["Fly|Ride"] = 36.88, ["Neon"] = 2.1, ["Neon|Fly"] = 36.57, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.5, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 144.39}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.48, ["Ride"] = 43.34, ["Fly|Ride"] = 230.6, ["Neon"] = 48.57, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 759.87, ["Mega"] = 405.09, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 27.48, ["Ride"] = 87.62, ["Fly|Ride"] = 183.75, ["Neon"] = 216.55, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 406.91, ["Mega"] = 760.62, ["Mega|Ride"] = 1029.06, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 183.75, ["Ride"] = 240.48, ["Fly|Ride"] = 345.99, ["Neon"] = 847.97, ["Neon|Fly"] = 1625.16, ["Neon|Ride"] = 711.38, ["Neon|Fly|Ride"] = 732.12, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.12, ["Fly"] = 130.37, ["Ride"] = 163.37, ["Neon"] = 141.38, ["Neon|Ride"] = 185.77, ["Neon|Fly|Ride"] = 431, ["Mega"] = 265.11, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 593.72}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.13, ["Ride"] = 57.75, ["Fly|Ride"] = 147.9, ["Neon"] = 161.32, ["Neon|Fly"] = 163.26, ["Neon|Ride"] = 201.51, ["Mega"] = 1723.96, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 853.13, ["Fly"] = 1743.33, ["Ride"] = 951.57, ["Fly|Ride"] = 1023.75, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 3936.19, ["Mega|Fly|Ride"] = 17238.31}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 5.16, ["Fly"] = 28.29, ["Ride"] = 18.51, ["Fly|Ride"] = 45.93, ["Neon"] = 48.63, ["Neon|Fly"] = 68.58, ["Neon|Ride"] = 62.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 243.66, ["Mega|Ride"] = 236.35, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.72, ["Fly"] = 262.5, ["Ride"] = 44.61, ["Fly|Ride"] = 135.19, ["Neon"] = 28.3, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.5, ["Ride"] = 23.72, ["Fly|Ride"] = 79.75, ["Neon"] = 10.71, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.55, ["Ride"] = 35.33, ["Fly|Ride"] = 124.83, ["Neon"] = 65.61, ["Neon|Fly"] = 187.51, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 253.41, ["Mega"] = 446.25, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 434.51}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.41, ["Ride"] = 21.56, ["Fly|Ride"] = 43.32, ["Neon"] = 10.5, ["Neon|Fly"] = 40.95, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 72.28, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.25, ["Fly|Ride"] = 131.25, ["Neon"] = 15.46, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 151.6, ["Mega|Ride"] = 227.06, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 262.5, ["Fly|Ride"] = 431.39, ["Neon"] = 1184.14, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3413.38}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 31.5, ["Ride"] = 27.57, ["Fly|Ride"] = 105.59, ["Neon"] = 5.2, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 286.63, ["Mega"] = 73.41, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 333.81}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.03, ["Ride"] = 65.61, ["Fly|Ride"] = 88.86, ["Neon"] = 18.23, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 344.93}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 39.38, ["Neon"] = 9.98, ["Neon|Ride"] = 50.42, ["Neon|Fly|Ride"] = 103.46, ["Mega"] = 78.75, ["Mega|Ride"] = 120.95, ["Mega|Fly|Ride"] = 503.19}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 64.31, ["Ride"] = 129.31, ["Fly|Ride"] = 249.38, ["Neon"] = 309, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 1452.43, ["Mega|Ride"] = 1506.31, ["Mega|Fly|Ride"] = 1550.48}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.41, ["Fly"] = 89.87, ["Ride"] = 58.2, ["Fly|Ride"] = 274.2, ["Neon"] = 128.58, ["Neon|Ride"] = 430.9, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 678.82, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.08, ["Fly"] = 242.97, ["Ride"] = 32.82, ["Fly|Ride"] = 114.22, ["Neon"] = 82.44, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 187.51, ["Mega"] = 575.38, ["Mega|Ride"] = 436.1, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 6.54, ["Ride"] = 41.35, ["Neon"] = 39.38, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 140.14, ["Mega|Fly"] = 205.89, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 59.06, ["Fly"] = 91.88, ["Ride"] = 76.13, ["Fly|Ride"] = 145.69, ["Neon"] = 328.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1151.07}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.56, ["Fly|Ride"] = 216.09, ["Neon"] = 6.12, ["Neon|Fly|Ride"] = 128.35, ["Mega"] = 91.88, ["Mega|Ride"] = 287.97, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.08, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 69.57, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 375.24, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.86, ["Fly"] = 203.41, ["Ride"] = 82.32, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1473.98, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.51, ["Ride"] = 16.11, ["Fly|Ride"] = 41.66, ["Neon"] = 2.63, ["Neon|Fly"] = 28.02, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 45.27, ["Mega"] = 19.43, ["Mega|Ride"] = 39.9, ["Mega|Fly|Ride"] = 74.33}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 2.63, ["Fly"] = 105, ["Ride"] = 27.57, ["Fly|Ride"] = 64.97, ["Neon"] = 21.56, ["Neon|Ride"] = 43.82, ["Neon|Fly|Ride"] = 168, ["Mega"] = 161.44, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 378.63}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 9.18, ["Ride"] = 41.91, ["Fly|Ride"] = 117.25, ["Neon"] = 116.81, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 270.27, ["Mega"] = 704.67, ["Mega|Ride"] = 432.04, ["Mega|Fly|Ride"] = 555.99}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.56, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 19.36, ["Mega|Ride"] = 53.89, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 22.08, ["Fly"] = 210, ["Ride"] = 72.18, ["Fly|Ride"] = 245.42, ["Neon"] = 141.9, ["Neon|Ride"] = 260.61, ["Neon|Fly|Ride"] = 416.99, ["Mega"] = 720.03, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 701.67, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.29, ["Fly"] = 43.12, ["Ride"] = 28.88, ["Fly|Ride"] = 94.83, ["Neon"] = 235.12, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 165.95, ["Mega"] = 461.18, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.74}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.94, ["Ride"] = 61.08, ["Neon"] = 38.59, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 42.11, ["Neon|Fly|Ride"] = 213.35, ["Mega"] = 245.44, ["Mega|Ride"] = 359.89, ["Mega|Fly|Ride"] = 441.89}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 5.25, ["Fly"] = 72.21, ["Ride"] = 68.25, ["Fly|Ride"] = 254.69, ["Neon"] = 43.22, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 262.5, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 36.68, ["Fly|Ride"] = 196.88, ["Neon"] = 6.55, ["Neon|Fly"] = 210, ["Neon|Ride"] = 37.05, ["Mega"] = 69.57, ["Mega|Fly"] = 215.52, ["Mega|Ride"] = 85.78, ["Mega|Fly|Ride"] = 287.69}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 52.5, ["Mega|Ride"] = 94.4, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.68}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 34.04, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 97.09, ["Neon"] = 191.97, ["Neon|Ride"] = 215.52, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 853.36}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 85.32, ["Ride"] = 65.63, ["Fly|Ride"] = 107.77, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 23.63, ["Mega|Ride"] = 172.4, ["Mega|Fly|Ride"] = 323.26}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 525, ["Ride"] = 525, ["Fly|Ride"] = 560.28, ["Neon"] = 3882.16, ["Neon|Ride"] = 2693.66, ["Mega"] = 12940.49, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 9.95, ["Fly"] = 49.38, ["Ride"] = 34.13, ["Fly|Ride"] = 58.27, ["Neon"] = 72.21, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 114.53, ["Mega"] = 325.28, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 633.07}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.11, ["Ride"] = 23.62, ["Fly|Ride"] = 58.49, ["Neon"] = 21.57, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 163.26, ["Mega|Fly"] = 187.51, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 8.97, ["Ride"] = 43.12, ["Fly|Ride"] = 575.87, ["Neon"] = 113.31, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 503.19, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 619.25}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 43.15, ["Ride"] = 38.57, ["Fly|Ride"] = 72.21, ["Neon"] = 43.65, ["Neon|Fly"] = 72.21, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 286.63, ["Mega|Fly|Ride"] = 503.65}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.46, ["Ride"] = 31.5, ["Fly|Ride"] = 196.88, ["Neon"] = 82.22, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 142.24, ["Mega"] = 533.36, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 522.8}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 6.57, ["Ride"] = 53.45, ["Fly|Ride"] = 101.3, ["Neon"] = 32.46, ["Neon|Fly"] = 105, ["Neon|Ride"] = 97.48, ["Neon|Fly|Ride"] = 278, ["Mega"] = 229.69, ["Mega|Ride"] = 359.4, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.54, ["Ride"] = 13.81, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 35.76, ["Mega"] = 15.59, ["Mega|Fly"] = 65.81, ["Mega|Ride"] = 31.28, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.81, ["Fly"] = 26.25, ["Ride"] = 56.43, ["Fly|Ride"] = 107.86, ["Neon"] = 67.73, ["Neon|Fly"] = 121.84, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.18, ["Mega|Ride"] = 220.95, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 252, ["Ride"] = 259.88, ["Fly|Ride"] = 382.22, ["Neon"] = 1267, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 1013.25, ["Mega"] = 4871.78, ["Mega|Ride"] = 9459.91, ["Mega|Fly|Ride"] = 4221.05}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 73.53, ["Ride"] = 104.97, ["Fly|Ride"] = 256.45, ["Neon"] = 458.07, ["Neon|Fly"] = 923.12, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2301.43, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 9.19, ["Ride"] = 19.43, ["Fly|Ride"] = 32.82, ["Neon"] = 7.44, ["Neon|Fly"] = 101.38, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 58.3, ["Mega"] = 49.58, ["Mega|Fly"] = 214.6, ["Mega|Ride"] = 113.11, ["Mega|Fly|Ride"] = 259.23}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 41.08, ["Ride"] = 15.67, ["Fly|Ride"] = 34.13, ["Neon"] = 7.44, ["Neon|Fly"] = 32.46, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 52.4, ["Mega"] = 65.63, ["Mega|Fly"] = 287.69, ["Mega|Ride"] = 99.91, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Fly"] = 101.39, ["Ride"] = 22.3, ["Fly|Ride"] = 98.44, ["Neon"] = 114.22, ["Neon|Ride"] = 42.66, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 436.33, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 223.13, ["Ride"] = 223.65, ["Fly|Ride"] = 346.5, ["Neon"] = 1185.22, ["Neon|Ride"] = 1214.31, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 3778.19, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 32.96, ["Ride"] = 15.65, ["Fly|Ride"] = 48.75, ["Neon"] = 19.44, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 24.68, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 323.26}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 77.96, ["Fly|Ride"] = 196.88, ["Neon"] = 19.1, ["Neon|Ride"] = 110.01, ["Mega"] = 196.88, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 431.39}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 9.19, ["Neon|Ride"] = 43.12, ["Mega"] = 117.16}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 10.5, ["Fly"] = 58.12, ["Ride"] = 24.93, ["Fly|Ride"] = 55.3, ["Neon"] = 97.01, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 367.5, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 812.6}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 26.25, ["Ride"] = 78.75, ["Fly|Ride"] = 302.14, ["Neon"] = 88.24, ["Neon|Fly"] = 656.04, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 302.64, ["Mega"] = 393.75, ["Mega|Fly"] = 2264.61, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.25, ["Fly"] = 43.12, ["Ride"] = 47.24, ["Fly|Ride"] = 99.41, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.93, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 862.77, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.83, ["Ride"] = 16.17, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 41.06, ["Mega|Fly"] = 43.12, ["Mega|Ride"] = 32.33, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 216.43, ["Ride"] = 246.1, ["Fly|Ride"] = 282.19, ["Neon"] = 3412.35, ["Neon|Ride"] = 1249.87, ["Neon|Fly|Ride"] = 1365.16, ["Mega|Fly|Ride"] = 5140.57}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.85, ["Fly"] = 101.19, ["Ride"] = 23.85, ["Fly|Ride"] = 102.88, ["Neon"] = 74.86, ["Neon|Ride"] = 144.39, ["Neon|Fly|Ride"] = 447.16, ["Mega"] = 363.18, ["Mega|Ride"] = 489.18, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.65, ["Ride"] = 19.03, ["Fly|Ride"] = 50.66, ["Neon"] = 5.82, ["Neon|Fly"] = 38.58, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 45.94, ["Mega|Fly"] = 230.6, ["Mega|Ride"] = 86.21, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 24.38, ["Fly|Ride"] = 86.21, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 109.74, ["Mega"] = 26.14, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 35.37, ["Fly|Ride"] = 98.44, ["Neon"] = 12.86, ["Neon|Fly"] = 731.46, ["Neon|Ride"] = 59.07, ["Mega"] = 155.54, ["Mega|Ride"] = 155.07, ["Mega|Fly|Ride"] = 283}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.99, ["Fly"] = 47.23, ["Ride"] = 28.88, ["Fly|Ride"] = 65.72, ["Neon"] = 45.94, ["Neon|Fly"] = 244.6, ["Neon|Ride"] = 47.62, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 262.5, ["Mega|Ride"] = 295.32, ["Mega|Fly|Ride"] = 370.14}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 4.87, ["Ride"] = 32.81, ["Neon"] = 51.19, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 258.61, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 24.84, ["Neon"] = 2.63, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 18.97, ["Mega|Ride"] = 72.36, ["Mega|Fly|Ride"] = 175.54}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.35, ["Ride"] = 32.33, ["Fly|Ride"] = 144.39, ["Neon"] = 32.91, ["Neon|Fly"] = 144.31, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 171.33, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 359.89}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 2.1, ["Neon|Fly"] = 115.31, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 26.17, ["Mega|Ride"] = 121.77, ["Mega|Fly|Ride"] = 273.69}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 55.53, ["Ride"] = 17.07, ["Fly|Ride"] = 45.94, ["Neon"] = 3.73, ["Neon|Ride"] = 23.94, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 45.94, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.99, ["Ride"] = 636.69, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3411.1, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 19.43, ["Neon|Fly"] = 43.12, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly|Ride"] = 335.58}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 50.66, ["Neon"] = 7.88, ["Neon|Fly"] = 754.88, ["Neon|Ride"] = 57.12, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 78.75, ["Mega|Fly"] = 163.26, ["Mega|Ride"] = 129.81, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.25, ["Fly"] = 24.43, ["Ride"] = 22.44, ["Fly|Ride"] = 48.64, ["Neon"] = 31.82, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 114.59, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 42.95, ["Ride"] = 15.75, ["Fly|Ride"] = 39.38, ["Neon"] = 7.39, ["Neon|Fly"] = 150.87, ["Neon|Ride"] = 27.21, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 65.63, ["Mega|Ride"] = 94.56, ["Mega|Fly|Ride"] = 125.9}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.31, ["Ride"] = 59.07, ["Neon"] = 205.09, ["Neon|Ride"] = 286.63, ["Mega"] = 964.27, ["Mega|Ride"] = 767.11, ["Mega|Fly|Ride"] = 719.92}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 28.87, ["Fly|Ride"] = 91.88, ["Neon"] = 6.56, ["Neon|Fly"] = 138.9, ["Neon|Ride"] = 37.05, ["Neon|Fly|Ride"] = 108.89, ["Mega"] = 47.25, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 270.46}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.63, ["Fly"] = 32.82, ["Ride"] = 21.61, ["Fly|Ride"] = 82.19, ["Neon"] = 10.68, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 114.09, ["Mega|Ride"] = 107.77, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.15, ["Fly|Ride"] = 65.83, ["Neon"] = 11.82, ["Neon|Fly"] = 73.22, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 97.13, ["Mega|Ride"] = 161.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2392.15, ["Ride"] = 17.8, ["Fly|Ride"] = 69.45, ["Neon"] = 3.94, ["Neon|Fly"] = 72.21, ["Neon|Ride"] = 20.91, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 53.81, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 115.31}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 9.84, ["Fly"] = 21.4, ["Ride"] = 19.67, ["Fly|Ride"] = 48.75, ["Neon"] = 121.84, ["Neon|Ride"] = 86.36, ["Neon|Fly|Ride"] = 140.07, ["Mega|Ride"] = 537.26, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 703.84, ["Fly"] = 1104.69, ["Ride"] = 774.38, ["Fly|Ride"] = 826.88, ["Neon"] = 1584.19, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 4857.98, ["Mega|Fly|Ride"] = 4396.88}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 22.23, ["Ride"] = 15.6, ["Fly|Ride"] = 47.25, ["Neon"] = 2.52, ["Neon|Fly"] = 43.15, ["Neon|Ride"] = 22.77, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 37.43, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 150.29}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.07, ["Ride"] = 36.75, ["Fly|Ride"] = 201.51, ["Neon"] = 42, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 236.25, ["Mega|Ride"] = 194.94, ["Mega|Fly|Ride"] = 515.26}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 39.38, ["Ride"] = 69.46, ["Fly|Ride"] = 116.7, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2437.4}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 24.34, ["Fly"] = 144.54, ["Ride"] = 58.23, ["Fly|Ride"] = 98.05, ["Neon"] = 236.41, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 244.6, ["Mega"] = 808.12, ["Mega|Ride"] = 947.1, ["Mega|Fly|Ride"] = 765.49}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.29, ["Fly"] = 95.04, ["Ride"] = 36.71, ["Neon"] = 63.95, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 305.36, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.11, ["Ride"] = 63.7, ["Fly|Ride"] = 144.54, ["Neon"] = 109.67, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 386.54, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.01, ["Ride"] = 40.69, ["Neon"] = 148.19, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 373.9, ["Mega"] = 533.36, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 717.61}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 5.25}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 105, ["Neon"] = 34.86, ["Neon|Ride"] = 96.98, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 178.5, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 227.83, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 19.72, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 25.97, ["Fly"] = 62.99, ["Ride"] = 45.27, ["Fly|Ride"] = 86.63, ["Neon"] = 165.38, ["Neon|Fly"] = 287.97, ["Neon|Ride"] = 155.45, ["Neon|Fly|Ride"] = 230.6, ["Mega"] = 1255.27, ["Mega|Ride"] = 775.68, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 2.59, ["Fly"] = 25.39, ["Ride"] = 15.92, ["Fly|Ride"] = 32.82, ["Neon"] = 22.22, ["Neon|Fly"] = 72.21, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.22, ["Mega"] = 262.5, ["Mega|Fly"] = 431, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 5.24, ["Fly"] = 108.22, ["Ride"] = 25.92, ["Fly|Ride"] = 41.71, ["Neon"] = 24.05, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 165.04, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 254.62}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.44, ["Mega"] = 49.88, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 31.07, ["Ride"] = 53.82, ["Fly|Ride"] = 144.39, ["Neon"] = 163.62, ["Neon|Ride"] = 183.75, ["Mega|Ride"] = 1725.41, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 32.66, ["Fly|Ride"] = 58.15, ["Neon"] = 7.66, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 141.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 5.25, ["Ride"] = 65.63, ["Fly|Ride"] = 286.63, ["Neon"] = 45.94, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 397.69, ["Mega|Fly"] = 575.38, ["Mega|Ride"] = 373.9, ["Mega|Fly|Ride"] = 534.43}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.51, ["Neon"] = 10.5, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 99.8, ["Mega"] = 194.25, ["Mega|Ride"] = 154.23, ["Mega|Fly|Ride"] = 287.7}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.34, ["Fly|Ride"] = 49.81, ["Neon"] = 51.19, ["Neon|Fly"] = 71.13, ["Neon|Ride"] = 140.8, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 291.37, ["Mega|Ride"] = 388.25, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 13.44, ["Mega"] = 418.06, ["Mega|Ride"] = 373.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 42, ["Ride"] = 215.52, ["Fly|Ride"] = 288.18, ["Neon"] = 262.5, ["Neon|Ride"] = 493.49, ["Neon|Fly|Ride"] = 859.85, ["Mega"] = 1405.02, ["Mega|Ride"] = 1461.91, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.06, ["Ride"] = 78.75, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Neon|Ride"] = 145.49, ["Mega"] = 421.31, ["Mega|Ride"] = 418.59, ["Mega|Fly|Ride"] = 679.23}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 5.69, ["Ride"] = 115.25, ["Neon"] = 143.7, ["Neon|Fly"] = 215.52, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.81, ["Ride"] = 128.23, ["Fly|Ride"] = 538.75, ["Neon"] = 145.53, ["Neon|Fly"] = 262.91, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 704.67, ["Mega|Fly"] = 2156.77, ["Mega|Ride"] = 640.03, ["Mega|Fly|Ride"] = 842.92}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 22.1, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 325.28}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.69, ["Fly|Ride"] = 42.02, ["Neon"] = 3.94, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 24.89, ["Neon|Fly|Ride"] = 60.03, ["Mega"] = 65.7, ["Mega|Ride"] = 144.39, ["Mega|Fly|Ride"] = 144.37}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.25, ["Fly|Ride"] = 81, ["Neon"] = 14.8, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 90.57, ["Mega|Ride"] = 104.83, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.39, ["Ride"] = 19.68, ["Fly|Ride"] = 72.01, ["Neon"] = 6.41, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 53.72, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.49, ["Fly"] = 65.63, ["Ride"] = 20.89, ["Fly|Ride"] = 72.21, ["Neon"] = 21.53, ["Neon|Ride"] = 107.77, ["Neon|Fly|Ride"] = 215.52, ["Mega"] = 330.7, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.1, ["Fly"] = 60.23, ["Ride"] = 26.25, ["Fly|Ride"] = 431.39, ["Neon"] = 29.87, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 306.02, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1078.4}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 9.69, ["Fly"] = 131.24, ["Ride"] = 24.29, ["Fly|Ride"] = 70.88, ["Neon"] = 35.83, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 56.15, ["Neon|Fly|Ride"] = 94.54, ["Mega"] = 236.25, ["Mega|Ride"] = 431, ["Mega|Fly|Ride"] = 472.9}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 16.32, ["Fly|Ride"] = 63.58, ["Neon"] = 28.84, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 150.87, ["Mega"] = 273.69, ["Mega|Ride"] = 162.71, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 288.73, ["Ride"] = 47.23, ["Neon"] = 14.87, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 71.56, ["Neon|Fly|Ride"] = 201.51, ["Mega"] = 107.77, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 123.53, ["Mega|Fly|Ride"] = 272.71}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 15.6, ["Ride"] = 82.69, ["Fly|Ride"] = 330.81, ["Neon"] = 68.25, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 359.89, ["Mega|Ride"] = 647.9, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 42, ["Fly"] = 164.07, ["Ride"] = 90.66, ["Fly|Ride"] = 180.26, ["Neon"] = 189, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1579.57, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1435.2}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.56, ["Fly|Ride"] = 51.74, ["Neon"] = 2.1, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 22.68, ["Mega|Ride"] = 71.03, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 5.61, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 675.6, ["Mega|Fly|Ride"] = 1135.66}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.8, ["Ride"] = 68.25, ["Fly|Ride"] = 170.57, ["Neon"] = 249.37, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 431, ["Mega"] = 1775.67, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.43, ["Fly"] = 190.32, ["Ride"] = 27.75, ["Fly|Ride"] = 133.88, ["Neon"] = 30.87, ["Neon|Fly"] = 130.41, ["Neon|Ride"] = 86.21, ["Neon|Fly|Ride"] = 122.08, ["Mega"] = 267.46, ["Mega|Fly"] = 736.1, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Fly|Ride"] = 129.31, ["Neon"] = 13, ["Neon|Ride"] = 68.98, ["Neon|Fly|Ride"] = 105, ["Mega"] = 81.03, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 133.35, ["Mega|Fly|Ride"] = 260.57}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.04, ["Ride"] = 21.91, ["Fly|Ride"] = 45.94, ["Neon"] = 12.78, ["Neon|Ride"] = 37.61, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 163.26, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 163.26}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.01, ["Ride"] = 14.26, ["Fly|Ride"] = 52.4, ["Neon"] = 2.35, ["Neon|Fly"] = 126.82, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 23.62, ["Mega|Ride"] = 73.12, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Fly|Ride"] = 93.09, ["Neon"] = 3.72, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 42, ["Mega|Fly"] = 150.26, ["Mega|Ride"] = 51.48, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 145.08, ["Mega"] = 23.93, ["Mega|Ride"] = 99.9, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.69, ["Ride"] = 157.49, ["Neon"] = 46.31, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 407.17, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 429.94}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.56, ["Ride"] = 26.24, ["Fly|Ride"] = 214.43, ["Neon"] = 65.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 285.48, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 2.63, ["Fly"] = 14.44, ["Ride"] = 20.96, ["Fly|Ride"] = 38.98, ["Neon"] = 51.74, ["Neon|Ride"] = 41.14, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 355.59, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 90.53, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 475.61, ["Neon|Fly|Ride"] = 719.34, ["Mega"] = 2436.5, ["Mega|Ride"] = 1624.82, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.44, ["Fly"] = 82.69, ["Ride"] = 59.07, ["Fly|Ride"] = 115.52, ["Neon"] = 1004.21, ["Neon|Fly|Ride"] = 630, ["Mega"] = 462.95, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1004.73}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.5, ["Fly|Ride"] = 36.65, ["Neon"] = 2.1, ["Neon|Fly"] = 43.12, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 26.25, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 15.95, ["Ride"] = 16.17, ["Fly|Ride"] = 28.88, ["Neon"] = 3.9, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.76, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 39.25, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 112.07}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 403.37, ["Fly"] = 572.59, ["Ride"] = 450.85, ["Fly|Ride"] = 524.97, ["Neon"] = 2370.44, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 6498.15}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.56, ["Ride"] = 34.13, ["Neon"] = 48.55, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 402.98, ["Mega|Ride"] = 718.68, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 15.74, ["Fly|Ride"] = 49.64, ["Neon"] = 5, ["Neon|Fly"] = 23.25, ["Neon|Ride"] = 22.19, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.6, ["Mega|Ride"] = 144.39, ["Mega|Fly|Ride"] = 119.61}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 43.22, ["Ride"] = 128.23, ["Fly|Ride"] = 719.3, ["Neon"] = 156.19, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 498.75, ["Mega"] = 737.62, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 796.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 21.92, ["Fly|Ride"] = 60.9, ["Neon"] = 14.15, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 30.93, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 112.88, ["Mega|Ride"] = 127.31, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 19.35, ["Fly|Ride"] = 196.88, ["Neon"] = 2.1, ["Neon|Fly"] = 101.3, ["Neon|Ride"] = 77.98, ["Neon|Fly|Ride"] = 144.54, ["Mega"] = 17.29, ["Mega|Ride"] = 54.94, ["Mega|Fly|Ride"] = 230.6}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 26.25, ["Fly"] = 129.94, ["Ride"] = 76.67, ["Fly|Ride"] = 214.43, ["Neon"] = 150.93, ["Neon|Ride"] = 215.97, ["Neon|Fly|Ride"] = 408.13, ["Mega"] = 715.45, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 727.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.37, ["Neon|Ride"] = 40.95, ["Neon|Fly|Ride"] = 86.21, ["Mega"] = 62.51, ["Mega|Ride"] = 178.14, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 23.2, ["Ride"] = 68.12, ["Fly|Ride"] = 118.13, ["Neon"] = 283.23, ["Neon|Ride"] = 331.09, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 1181.25, ["Mega|Ride"] = 1292.96, ["Mega|Fly|Ride"] = 1331.77}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Fly|Ride"] = 431, ["Neon"] = 30.52, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 503.19, ["Mega"] = 99.75, ["Mega|Ride"] = 416.99}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 32.91, ["Ride"] = 81.34, ["Fly|Ride"] = 58.2, ["Neon"] = 9.74, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 117.6, ["Mega|Ride"] = 128.64, ["Mega|Fly|Ride"] = 195.44}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 51.16, ["Fly"] = 187.51, ["Ride"] = 118.13, ["Fly|Ride"] = 163.24, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2012.71}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.49, ["Ride"] = 34.5, ["Neon"] = 5.25, ["Neon|Ride"] = 57.27, ["Neon|Fly|Ride"] = 115.31, ["Mega"] = 47.25, ["Mega|Fly"] = 215.52, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 282.31}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 23.54, ["Fly|Ride"] = 102.88, ["Neon"] = 5.24, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 86.89, ["Mega"] = 59.13, ["Mega|Fly"] = 149.96, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.31}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.55, ["Fly"] = 58.51, ["Ride"] = 38.51, ["Fly|Ride"] = 195.07, ["Neon"] = 81.87, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 262.5, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.57, ["Fly"] = 65.63, ["Ride"] = 25.17, ["Fly|Ride"] = 69.81, ["Neon"] = 52.59, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 143.09, ["Mega"] = 354.38, ["Mega|Ride"] = 366.3, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 14.04, ["Fly"] = 28.88, ["Ride"] = 33.43, ["Fly|Ride"] = 50.66, ["Neon"] = 51.98, ["Neon|Ride"] = 71.07, ["Neon|Fly|Ride"] = 151.68, ["Mega"] = 402.98, ["Mega|Ride"] = 327.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.63, ["Ride"] = 122.57, ["Fly|Ride"] = 248.33, ["Neon"] = 314.99, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 603.75, ["Mega|Ride"] = 1665.77, ["Mega|Fly|Ride"] = 1682.33}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.46, ["Ride"] = 115.31, ["Fly|Ride"] = 262.5, ["Neon"] = 54.12, ["Neon|Fly"] = 97.48, ["Neon|Ride"] = 115.31, ["Neon|Fly|Ride"] = 351.27, ["Mega"] = 252, ["Mega|Ride"] = 402.98, ["Mega|Fly|Ride"] = 640.03}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.82, ["Ride"] = 25.58, ["Fly|Ride"] = 78.73, ["Neon"] = 24.38, ["Neon|Ride"] = 47.25, ["Mega"] = 143.07, ["Mega|Ride"] = 170.26, ["Mega|Fly|Ride"] = 431.23}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.42, ["Fly"] = 135.19, ["Ride"] = 42.03, ["Fly|Ride"] = 115.5, ["Neon"] = 44.15, ["Neon|Ride"] = 112.06, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 301.7, ["Mega|Ride"] = 861.98, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 14, ["Fly|Ride"] = 43.22, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.33, ["Neon|Fly|Ride"] = 54.96, ["Mega"] = 15.07, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 44.93, ["Fly"] = 164.07, ["Ride"] = 103.69, ["Neon"] = 230.35, ["Neon|Fly"] = 2444.69, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 484.87, ["Mega"] = 1077.47, ["Mega|Ride"] = 1091.08, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.8, ["Fly|Ride"] = 144.39, ["Neon"] = 6.57, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 86.58, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.12, ["Ride"] = 17.26, ["Fly|Ride"] = 45.94, ["Neon"] = 17.07, ["Neon|Ride"] = 29.12, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 257.25, ["Mega|Ride"] = 200.1, ["Mega|Fly|Ride"] = 288.05}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 45.75, ["Ride"] = 91.88, ["Fly|Ride"] = 177.19, ["Neon"] = 227.37, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 787.5, ["Mega|Ride"] = 1008.16, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 29.16, ["Neon"] = 5.25, ["Neon|Ride"] = 31.5, ["Mega"] = 42.96, ["Mega|Fly"] = 163.26, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 273.66}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 2.63}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 52.5, ["Neon"] = 6.57, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 215.41, ["Mega"] = 115.35, ["Mega|Ride"] = 107.63, ["Mega|Fly|Ride"] = 280.14}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.25, ["Ride"] = 183.75, ["Fly|Ride"] = 352.34, ["Neon"] = 650.56, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6464.78, ["Mega|Ride"] = 3249.08, ["Mega|Fly|Ride"] = 2451.03}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 36.65, ["Fly|Ride"] = 215.71, ["Neon"] = 31.16, ["Neon|Fly"] = 144.39, ["Neon|Ride"] = 103.58, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 140.8, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.94, ["Neon|Ride"] = 21.77, ["Mega"] = 45.42, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 66.82, ["Mega|Fly|Ride"] = 420.21}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 3.93, ["Ride"] = 49.58, ["Fly|Ride"] = 131.25, ["Neon"] = 65.52, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 159.49, ["Mega"] = 503.61, ["Mega|Ride"] = 575.38, ["Mega|Fly|Ride"] = 676.19}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 9.19, ["Fly"] = 54.96, ["Ride"] = 22.32, ["Fly|Ride"] = 62.51, ["Neon"] = 101.04, ["Neon|Ride"] = 128.39, ["Neon|Fly|Ride"] = 215.71, ["Mega"] = 260.72, ["Mega|Ride"] = 406.91, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 13.13, ["Ride"] = 53.9, ["Fly|Ride"] = 172.4, ["Neon"] = 139.64, ["Neon|Ride"] = 209.04, ["Neon|Fly|Ride"] = 328.25, ["Mega"] = 552.57, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 152.25, ["Fly"] = 196.88, ["Ride"] = 190.21, ["Fly|Ride"] = 216.57, ["Neon"] = 639.3, ["Neon|Ride"] = 575.39, ["Neon|Fly|Ride"] = 656.15, ["Mega|Fly|Ride"] = 2442.61}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 3.94, ["Fly"] = 19.95, ["Ride"] = 18.6, ["Fly|Ride"] = 35.32, ["Neon"] = 56.49, ["Neon|Fly"] = 58.2, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 77.94, ["Mega"] = 323.26, ["Mega|Ride"] = 322.48, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 72.21, ["Ride"] = 28.09, ["Fly|Ride"] = 131.25, ["Neon"] = 18.76, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 114.53, ["Mega"] = 155.17, ["Mega|Ride"] = 204.73, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.88, ["Fly"] = 42.75, ["Ride"] = 37.79, ["Fly|Ride"] = 76.13, ["Neon"] = 45.46, ["Neon|Fly"] = 72.21, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 148.84, ["Mega"] = 461.18, ["Mega|Ride"] = 429.94, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 39.38, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 129.99, ["Neon"] = 167.9, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 976.2, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 964.68}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.85, ["Fly"] = 57.75, ["Neon"] = 196.87, ["Neon|Ride"] = 227.97, ["Mega"] = 861.96, ["Mega|Ride"] = 689.59, ["Mega|Fly|Ride"] = 818.89}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 288.75, ["Ride"] = 350.44, ["Fly|Ride"] = 420, ["Neon"] = 1312.5, ["Neon|Ride"] = 1625.16, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6752.46}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 17.89, ["Fly"] = 58.65, ["Ride"] = 27.19, ["Fly|Ride"] = 69.45, ["Neon"] = 237.91, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 269.51, ["Mega"] = 761.25, ["Mega|Ride"] = 753.43, ["Mega|Fly|Ride"] = 894.22}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 13.57, ["Fly|Ride"] = 121.97, ["Neon"] = 2.1, ["Neon|Fly"] = 21.56, ["Neon|Ride"] = 16.91, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 20.9, ["Mega|Fly"] = 114.35, ["Mega|Ride"] = 73.37, ["Mega|Fly|Ride"] = 120.1}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.08, ["Neon"] = 21.56, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 163.26, ["Mega"] = 148.32, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 25.68, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.87, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 383.61, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 387.19, ["Fly"] = 393.75, ["Ride"] = 418.69, ["Fly|Ride"] = 446.25, ["Neon"] = 1968.75, ["Neon|Ride"] = 2014.41, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5523.54}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.4, ["Fly|Ride"] = 68.23, ["Neon"] = 18.52, ["Neon|Ride"] = 32.32, ["Neon|Fly|Ride"] = 111.13, ["Mega"] = 223.13, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 226.09}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.49, ["Fly"] = 28.02, ["Ride"] = 18.79, ["Fly|Ride"] = 32.82, ["Neon"] = 45.74, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 138.99, ["Mega"] = 211.99, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 302.64}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 2.1, ["Fly"] = 41.91, ["Ride"] = 28.02, ["Fly|Ride"] = 61.25, ["Neon"] = 15.58, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 43.12, ["Neon|Fly|Ride"] = 113.45, ["Mega"] = 92.68, ["Mega|Fly"] = 128.64, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 39.38, ["Fly"] = 57.27, ["Ride"] = 36.75, ["Fly|Ride"] = 129.31, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 322.19, ["Mega"] = 1207.5, ["Mega|Ride"] = 861.7, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 12.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 165.4, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 1034.38}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 10.5, ["Fly"] = 93.13, ["Ride"] = 52.03, ["Neon"] = 146.99, ["Neon|Ride"] = 155.17, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.99, ["Neon|Ride"] = 38.34, ["Mega"] = 64.32, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 107.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.77, ["Neon"] = 57.75, ["Mega"] = 136.02, ["Mega|Ride"] = 314.92, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 7.66, ["Ride"] = 43.12, ["Neon"] = 45.5, ["Neon|Ride"] = 287.69, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 862.71, ["Mega|Ride"] = 560.28, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.39, ["Fly"] = 26.25, ["Ride"] = 31.49, ["Fly|Ride"] = 56.69, ["Neon"] = 53.48, ["Neon|Fly"] = 114.53, ["Neon|Ride"] = 61.69, ["Neon|Fly|Ride"] = 98.6, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 495.66}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 417.38, ["Fly"] = 609.13, ["Ride"] = 444.91, ["Fly|Ride"] = 522.38, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 2772.74, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7412.95}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.36, ["Fly|Ride"] = 40.69, ["Neon"] = 15.65, ["Neon|Fly"] = 81.71, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 171.29, ["Mega"] = 252.12, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 305.8}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 5.25, ["Fly"] = 71.13, ["Ride"] = 71.78, ["Fly|Ride"] = 187.51, ["Neon"] = 89.25, ["Neon|Ride"] = 128.51, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 718.68, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 540.9}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.94, ["Ride"] = 97.46, ["Fly|Ride"] = 220.4, ["Neon"] = 84.67, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 374.03, ["Mega"] = 307.55, ["Mega|Ride"] = 309.75, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 44.49, ["Fly"] = 214.43, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 285.41, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 1713.17}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.23, ["Ride"] = 42, ["Neon"] = 37.97, ["Neon|Ride"] = 91.9, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 170.63, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 206.87, ["Mega|Fly|Ride"] = 356.72}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 58.46, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 113.52, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 6.48, ["Ride"] = 67.02, ["Neon"] = 26.22, ["Neon|Ride"] = 79.9, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 144.66, ["Mega|Fly"] = 256.45, ["Mega|Ride"] = 265.13, ["Mega|Fly|Ride"] = 276.04}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 52.5, ["Fly"] = 183.72, ["Ride"] = 84, ["Fly|Ride"] = 197.86, ["Neon"] = 123.37, ["Neon|Ride"] = 177.19, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 421.31, ["Mega|Ride"] = 450.86, ["Mega|Fly|Ride"] = 477.16}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 8.54, ["Neon|Ride"] = 99.35, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 66.75, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 20.5, ["Ride"] = 96.98, ["Neon"] = 173.25, ["Neon|Ride"] = 372.82, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 851.21}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 951.56, ["Fly"] = 1194.38, ["Ride"] = 1017.19, ["Fly|Ride"] = 1050, ["Neon"] = 3593.35, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2884.88, ["Mega"] = 9498.89, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.14, ["Fly"] = 116.94, ["Ride"] = 45.94, ["Fly|Ride"] = 179.16, ["Neon"] = 90.96, ["Neon|Fly"] = 717.94, ["Neon|Ride"] = 184.87, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 448.87, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 533.36}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.37, ["Ride"] = 22.32, ["Fly|Ride"] = 85.86, ["Neon"] = 10.81, ["Neon|Fly"] = 72.21, ["Neon|Ride"] = 31.85, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 69.93, ["Mega|Ride"] = 99.1, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.33, ["Ride"] = 131.25, ["Fly|Ride"] = 144.39, ["Neon"] = 67.51, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 385.89, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.65, ["Neon"] = 2.63, ["Neon|Ride"] = 26.98, ["Neon|Fly|Ride"] = 107.96, ["Mega"] = 17.83, ["Mega|Ride"] = 49.33, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.82, ["Fly"] = 129.31, ["Ride"] = 100.64, ["Fly|Ride"] = 275.91, ["Neon"] = 210, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 384.68, ["Mega"] = 993.24, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.82, ["Ride"] = 62.89, ["Fly|Ride"] = 285.41, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 215.52, ["Mega"] = 490.24, ["Mega|Ride"] = 1003.13, ["Mega|Fly|Ride"] = 1006.37}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.76, ["Ride"] = 23.16, ["Neon"] = 9.17, ["Neon|Ride"] = 43.13, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 97.54, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 431}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.49, ["Fly"] = 159.63, ["Ride"] = 35.42, ["Fly|Ride"] = 106.55, ["Neon"] = 45.94, ["Neon|Ride"] = 95.81, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 472.19, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 741.29}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 97.07, ["Ride"] = 27.86, ["Fly|Ride"] = 59.07, ["Neon"] = 27.13, ["Neon|Fly"] = 130.37, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 146.21, ["Mega"] = 359.89, ["Mega|Ride"] = 538.75, ["Mega|Fly|Ride"] = 359.89}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.62, ["Ride"] = 119.61, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 575.38, ["Mega"] = 2514.82, ["Mega|Ride"] = 1833.37, ["Mega|Fly|Ride"] = 2154.94}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.84, ["Fly|Ride"] = 193.96, ["Neon"] = 12.77, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 650.99, ["Mega"] = 59.06, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 3.94, ["Fly"] = 36.65, ["Ride"] = 23.63, ["Fly|Ride"] = 71.13, ["Neon"] = 39.29, ["Neon|Fly"] = 187.67, ["Neon|Ride"] = 60.93, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 301.67, ["Mega|Ride"] = 252.11, ["Mega|Fly|Ride"] = 324.14}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 117.15, ["Fly"] = 213.35, ["Ride"] = 168, ["Fly|Ride"] = 229.63, ["Neon"] = 480.17, ["Neon|Ride"] = 546.79, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 27.3, ["Ride"] = 19.04, ["Fly|Ride"] = 47.43, ["Neon"] = 15.74, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 23.91, ["Neon|Fly|Ride"] = 78.88, ["Mega"] = 144.27, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 25.46, ["Fly"] = 267.04, ["Ride"] = 68.95, ["Fly|Ride"] = 174.57, ["Neon"] = 208.68, ["Neon|Ride"] = 207.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 652.38, ["Mega|Ride"] = 666.75, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.88, ["Ride"] = 12.53, ["Fly|Ride"] = 62.99, ["Neon"] = 2.1, ["Neon|Fly"] = 29.65, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 15.36, ["Mega|Ride"] = 31.29, ["Mega|Fly|Ride"] = 71.5}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.2, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 133.74, ["Mega"] = 19.69, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.63, ["Fly"] = 36.65, ["Ride"] = 31, ["Fly|Ride"] = 173.37, ["Neon"] = 14.89, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 247.41}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.88, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 163.37, ["Neon|Fly|Ride"] = 399.49, ["Mega"] = 515.83, ["Mega|Ride"] = 646.5}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 23.15, ["Ride"] = 16.99, ["Fly|Ride"] = 34.13, ["Neon"] = 14.44, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 21.61, ["Neon|Fly|Ride"] = 57.08, ["Mega"] = 134.25, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 9.19, ["Fly"] = 56.13, ["Ride"] = 48.22, ["Fly|Ride"] = 96.8, ["Neon"] = 49.05, ["Neon|Fly"] = 110.84, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 93.57, ["Mega"] = 373.7, ["Mega|Fly"] = 438.59, ["Mega|Ride"] = 282.19, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.76, ["Ride"] = 18.26, ["Fly|Ride"] = 68.61, ["Neon"] = 13.11, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 52.45, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 144.24}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 8.9, ["Fly"] = 162.88, ["Ride"] = 24.94, ["Fly|Ride"] = 217.2, ["Neon"] = 41.16, ["Neon|Ride"] = 48.75, ["Neon|Fly|Ride"] = 163.66, ["Mega"] = 286.63, ["Mega|Ride"] = 533.36, ["Mega|Fly|Ride"] = 487.23}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.24, ["Ride"] = 51.74, ["Fly|Ride"] = 170.63, ["Neon"] = 51.19, ["Neon|Ride"] = 247.05, ["Mega"] = 241.5, ["Mega|Ride"] = 302.23, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.14, ["Fly"] = 49.48, ["Ride"] = 19.59, ["Fly|Ride"] = 58.25, ["Neon"] = 20.47, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 34.57, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 233.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 365.5}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.38, ["Ride"] = 16.28, ["Fly|Ride"] = 51.74, ["Neon"] = 16.15, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.42, ["Neon|Fly|Ride"] = 84.05, ["Mega"] = 144.39, ["Mega|Ride"] = 115.31, ["Mega|Fly|Ride"] = 286.63}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 187.8, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 429.94, ["Neon"] = 1278.97, ["Neon|Ride"] = 1278.97, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4223.67, ["Mega|Fly|Ride"] = 4062.19}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.24, ["Ride"] = 114.17, ["Neon"] = 39.1, ["Neon|Ride"] = 144.57, ["Mega"] = 122.14, ["Mega|Ride"] = 650.99, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 3.8, ["Fly"] = 107.77, ["Ride"] = 24.77, ["Fly|Ride"] = 86.21, ["Neon"] = 32.06, ["Neon|Fly"] = 244.6, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 146.31, ["Mega"] = 247.37, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 215.52}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.9, ["Fly|Ride"] = 719.3, ["Neon"] = 48.75, ["Neon|Ride"] = 287.97, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 486.1, ["Mega|Ride"] = 488.52, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 14.44, ["Fly|Ride"] = 30.51, ["Neon"] = 2.1, ["Neon|Fly"] = 21.56, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 18.38, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 47.43, ["Ride"] = 22.86, ["Fly|Ride"] = 90.57, ["Neon"] = 21.68, ["Neon|Ride"] = 36.65, ["Neon|Fly|Ride"] = 88.11, ["Mega|Ride"] = 210.11, ["Mega|Fly|Ride"] = 256.54}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.26, ["Ride"] = 121.07, ["Neon"] = 6.57, ["Neon|Ride"] = 287.97, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 52.5, ["Mega|Ride"] = 168.92, ["Mega|Fly|Ride"] = 288.23}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 105, ["Ride"] = 94.5, ["Fly|Ride"] = 137.81, ["Neon"] = 315, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 3593.35, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.21, ["Fly"] = 101.39, ["Ride"] = 23.61, ["Fly|Ride"] = 85.14, ["Neon"] = 21.66, ["Neon|Ride"] = 69.57, ["Mega"] = 169.3, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.15, ["Neon"] = 5.01, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 547.21, ["Mega"] = 58.68, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 39.61, ["Fly"] = 131.25, ["Ride"] = 62.37, ["Fly|Ride"] = 179.11, ["Neon"] = 143.26, ["Neon|Ride"] = 178.39, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 511.88, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Ride"] = 12.94, ["Fly|Ride"] = 35.81, ["Neon"] = 2.1, ["Neon|Fly"] = 22.63, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 41.61, ["Mega"] = 19.56, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 33.83, ["Mega|Fly|Ride"] = 63.03}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Fly|Ride"] = 96.98, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 23.63, ["Mega|Fly"] = 144.39, ["Mega|Ride"] = 79.26, ["Mega|Fly|Ride"] = 187.85}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Fly|Ride"] = 161.34, ["Neon"] = 5.25, ["Neon|Ride"] = 102.8, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 38.98, ["Mega|Fly"] = 187.67, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 235.49}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 6.04, ["Ride"] = 43.32, ["Fly|Ride"] = 106.32, ["Neon"] = 19.69, ["Neon|Fly"] = 82.69, ["Neon|Ride"] = 101.3, ["Neon|Fly|Ride"] = 158.82, ["Mega"] = 108.94, ["Mega|Fly"] = 331.09, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 14.56, ["Fly|Ride"] = 43.12, ["Neon"] = 2.1, ["Neon|Fly"] = 24.8, ["Neon|Ride"] = 26.32, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 20.51, ["Mega|Ride"] = 61.34, ["Mega|Fly|Ride"] = 118.13}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 17.9, ["Fly"] = 127.16, ["Ride"] = 55.13, ["Neon"] = 151.05, ["Neon|Ride"] = 183.19, ["Neon|Fly|Ride"] = 431, ["Mega"] = 796.26, ["Mega|Fly|Ride"] = 818.89}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2691.51, ["Fly"] = 3150, ["Ride"] = 2334.73, ["Fly|Ride"] = 2163, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44606.89}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 54.96, ["Ride"] = 16.44, ["Fly|Ride"] = 32.82, ["Neon"] = 10.32, ["Neon|Fly"] = 71.13, ["Neon|Ride"] = 25.53, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 84.25, ["Mega|Fly"] = 475.58, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 161.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 9.85, ["Mega"] = 102.78, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 487.31}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 11.81, ["Fly"] = 105, ["Ride"] = 32.33, ["Fly|Ride"] = 144.39, ["Neon"] = 73.37, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 279.87, ["Mega"] = 431.81, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 715.45}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 19.69, ["Fly"] = 144.39, ["Ride"] = 73.49, ["Neon"] = 161.44, ["Mega"] = 678.71, ["Mega|Ride"] = 688.51, ["Mega|Fly|Ride"] = 650.28}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 121.92, ["Fly"] = 548.42, ["Ride"] = 189, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6470.25, ["Mega|Fly|Ride"] = 4065.56}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 13.02, ["Ride"] = 64.97, ["Fly|Ride"] = 675.94, ["Neon"] = 17.07, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.39, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 378.55}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 24.38, ["Neon"] = 16.48, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.82, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.39, ["Ride"] = 33.43, ["Fly|Ride"] = 85.14, ["Neon"] = 7.88, ["Neon|Fly"] = 127.16, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 74.51, ["Mega|Ride"] = 106.37, ["Mega|Fly|Ride"] = 237.79}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.5, ["Ride"] = 71.47, ["Fly|Ride"] = 131.25, ["Neon"] = 130.94, ["Neon|Ride"] = 1222.36, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 575.38, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 25.88, ["Neon"] = 2.1, ["Neon|Ride"] = 28.34, ["Mega"] = 19.69, ["Mega|Ride"] = 90.04}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Ride"] = 129.31, ["Fly|Ride"] = 168, ["Neon"] = 311.85, ["Neon|Fly"] = 461.18, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 503.19, ["Mega"] = 3235.13, ["Mega|Ride"] = 1149.67, ["Mega|Fly|Ride"] = 1151.77}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 45.27, ["Ride"] = 91.85, ["Neon"] = 13.58, ["Neon|Ride"] = 144.39, ["Neon|Fly|Ride"] = 215.52, ["Mega"] = 64.05, ["Mega|Ride"] = 287.69, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 46.69, ["Fly"] = 105, ["Ride"] = 84, ["Fly|Ride"] = 176.93, ["Neon"] = 243.14, ["Neon|Ride"] = 309.61, ["Neon|Fly|Ride"] = 416.99, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.65, ["Ride"] = 17.72, ["Fly|Ride"] = 43.22, ["Neon"] = 4.85, ["Neon|Fly"] = 85.35, ["Neon|Ride"] = 72.28, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 42, ["Mega|Fly"] = 146.48, ["Mega|Ride"] = 67.9, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 115.31, ["Mega"] = 36.74, ["Mega|Ride"] = 170.57, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 5.11, ["Fly"] = 72.28, ["Ride"] = 24.55, ["Fly|Ride"] = 90.57, ["Neon"] = 21.18, ["Neon|Fly"] = 107.77, ["Neon|Ride"] = 72.47, ["Mega"] = 141.74, ["Mega|Ride"] = 325.5, ["Mega|Fly|Ride"] = 575.38}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 374.07, ["Fly"] = 730.97, ["Ride"] = 391.13, ["Fly|Ride"] = 588, ["Neon"] = 810.46, ["Neon|Ride"] = 853.13, ["Neon|Fly|Ride"] = 1156.44, ["Mega"] = 3109.56, ["Mega|Ride"] = 2111.49, ["Mega|Fly|Ride"] = 3012.62}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 42, ["Fly"] = 65.63, ["Ride"] = 54.09, ["Fly|Ride"] = 96.98, ["Neon"] = 192.65, ["Neon|Ride"] = 122.16, ["Neon|Fly|Ride"] = 210, ["Mega|Fly"] = 2746.94, ["Mega|Ride"] = 1723.96, ["Mega|Fly|Ride"] = 1062.39}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 61.62, ["Ride"] = 32.81, ["Fly|Ride"] = 123.48, ["Neon"] = 26.67, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 139.15, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 22.32, ["Fly"] = 215.52, ["Ride"] = 63, ["Fly|Ride"] = 149.63, ["Neon"] = 77.96, ["Neon|Fly"] = 374.07, ["Neon|Ride"] = 107.72, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 287.69, ["Mega|Fly"] = 1002.63, ["Mega|Ride"] = 326.1, ["Mega|Fly|Ride"] = 488.03}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.82, ["Ride"] = 32.33, ["Neon"] = 101.36, ["Neon|Ride"] = 124.52, ["Neon|Fly|Ride"] = 487.31, ["Mega"] = 650.56, ["Mega|Ride"] = 243.66, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.56, ["Neon"] = 17.07, ["Neon|Ride"] = 157.5, ["Mega"] = 91.88, ["Mega|Ride"] = 342.65}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 72.21, ["Ride"] = 19.68, ["Fly|Ride"] = 62.97, ["Neon"] = 59.07, ["Neon|Fly"] = 106.91, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 211.99, ["Mega"] = 262.5, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 118.13, ["Fly"] = 243.83, ["Ride"] = 119.68, ["Fly|Ride"] = 192.3, ["Neon"] = 787.5, ["Neon|Ride"] = 518.45, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.45, ["Ride"] = 56.14, ["Fly|Ride"] = 85.32, ["Neon"] = 118.53, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 204.74, ["Mega"] = 537.48, ["Mega|Ride"] = 573.22, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1783.64, ["Fly"] = 2432.51, ["Ride"] = 1968.75, ["Fly|Ride"] = 1967.44, ["Neon"] = 11503.8, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24364.92}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.76, ["Fly"] = 131250, ["Ride"] = 68.25, ["Fly|Ride"] = 196.87, ["Neon"] = 26.25, ["Neon|Ride"] = 95.37, ["Mega"] = 166.37, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 236.92, ["Mega|Fly|Ride"] = 324.84}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.73, ["Fly"] = 59.88, ["Ride"] = 57.16, ["Fly|Ride"] = 121.84, ["Neon"] = 19.49, ["Neon|Ride"] = 90.44, ["Neon|Fly|Ride"] = 218.08, ["Mega"] = 150.94, ["Mega|Ride"] = 332.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 885.3, ["Ride"] = 840, ["Fly|Ride"] = 1010.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.49, ["Mega|Ride"] = 13807.62, ["Mega|Fly|Ride"] = 12995.04}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.33, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 230.6, ["Neon|Ride"] = 323.54, ["Mega"] = 852.05, ["Mega|Ride"] = 763.43, ["Mega|Fly|Ride"] = 835.49}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.04, ["Fly|Ride"] = 128.15, ["Neon"] = 12.17, ["Neon|Fly"] = 163.37, ["Neon|Ride"] = 83.99, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 144.54, ["Neon"] = 3.84, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.83, ["Neon|Fly|Ride"] = 112.06, ["Mega"] = 23.61, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 72.19, ["Fly"] = 431.39, ["Ride"] = 130.61, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2438.15, ["Mega|Fly|Ride"] = 2396.29}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.5, ["Fly|Ride"] = 75.45, ["Neon"] = 12.42, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 91.87, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 194.38}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.66, ["Fly"] = 150.87, ["Ride"] = 98.04, ["Fly|Ride"] = 114.44, ["Neon"] = 609.13, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 489.18, ["Mega"] = 2154.94, ["Mega|Fly|Ride"] = 1648.53}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.59, ["Fly"] = 105, ["Fly|Ride"] = 129.43, ["Neon"] = 32.47, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.84, ["Mega|Ride"] = 317.87}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 251.68, ["Fly"] = 416.99, ["Ride"] = 294, ["Fly|Ride"] = 322.85, ["Neon"] = 1148.82, ["Neon|Ride"] = 1292.96, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3857.32}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 5.38, ["Fly"] = 65.63, ["Ride"] = 24.84, ["Fly|Ride"] = 115.31, ["Neon"] = 47.23, ["Neon|Ride"] = 81.85, ["Neon|Fly|Ride"] = 112.06, ["Mega"] = 247.76, ["Mega|Ride"] = 617.82, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 17.74, ["Ride"] = 16.69, ["Fly|Ride"] = 39.38, ["Neon"] = 4.82, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 20.5, ["Neon|Fly|Ride"] = 64.81, ["Mega"] = 44.63, ["Mega|Ride"] = 115.23, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1346.84, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7908.79, ["Neon|Fly|Ride"] = 7175.9, ["Mega"] = 24381.15, ["Mega|Fly|Ride"] = 23025.26}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 9.08, ["Ride"] = 77.58, ["Fly|Ride"] = 215.52, ["Neon"] = 73.38, ["Neon|Ride"] = 314.99, ["Neon|Fly|Ride"] = 537.68, ["Mega"] = 422.06, ["Mega|Ride"] = 475.44, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.25, ["Fly"] = 51.34, ["Ride"] = 38.57, ["Fly|Ride"] = 104.89, ["Neon"] = 20.69, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 114.53, ["Mega"] = 162.84, ["Mega|Ride"] = 164.73, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 25.91, ["Fly"] = 35.34, ["Ride"] = 30.85, ["Fly|Ride"] = 70.53, ["Neon|Ride"] = 173.18, ["Neon|Fly|Ride"] = 189.09, ["Mega"] = 2588.11, ["Mega|Ride"] = 1138.62, ["Mega|Fly|Ride"] = 779.63}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.81, ["Fly"] = 71.59, ["Ride"] = 31.52, ["Fly|Ride"] = 71.47, ["Neon"] = 56.05, ["Neon|Ride"] = 84.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 575.3}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 94.5, ["Ride"] = 157.5, ["Fly|Ride"] = 644.01, ["Neon"] = 437.99, ["Neon|Fly"] = 575.38, ["Neon|Ride"] = 534.33, ["Neon|Fly|Ride"] = 718.68, ["Mega"] = 1008.25, ["Mega|Ride"] = 1079.1, ["Mega|Fly|Ride"] = 1028.99}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 108.51, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 16.8, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 74.43, ["Fly"] = 167.2, ["Ride"] = 142.93, ["Fly|Ride"] = 208.69, ["Neon"] = 812.44, ["Neon|Fly"] = 681.03, ["Neon|Ride"] = 319.93, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 3451.04, ["Mega|Fly|Ride"] = 2299.33}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 748.35, ["Ride"] = 52.44, ["Fly|Ride"] = 68.04, ["Neon"] = 227.37, ["Neon|Ride"] = 72.19, ["Mega"] = 773.71, ["Mega|Ride"] = 412.79, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.81, ["Fly|Ride"] = 39.36, ["Neon"] = 24.38, ["Neon|Fly"] = 81.71, ["Neon|Ride"] = 86.21, ["Neon|Fly|Ride"] = 120.41, ["Mega|Ride"] = 277.86}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 142.37, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.65}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 85.88, ["Fly"] = 247.55, ["Ride"] = 203.44, ["Fly|Ride"] = 413.76, ["Neon"] = 504, ["Neon|Ride"] = 575.38, ["Neon|Fly|Ride"] = 718.68, ["Mega"] = 2205, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.94, ["Ride"] = 39.38, ["Fly|Ride"] = 431, ["Neon"] = 21, ["Neon|Ride"] = 59.07, ["Mega"] = 115.31, ["Mega|Ride"] = 157.34, ["Mega|Fly|Ride"] = 325.28}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 101.3, ["Mega"] = 18.32, ["Mega|Ride"] = 215.52, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 36.65, ["Fly|Ride"] = 144.54, ["Neon"] = 2.63, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 200.42, ["Mega"] = 18.38, ["Mega|Fly"] = 56.2, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 136.86}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.16, ["Fly|Ride"] = 52.49, ["Neon"] = 8.59, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 114.19}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.41, ["Neon"] = 10.38, ["Mega"] = 137.82, ["Mega|Ride"] = 129.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.75, ["Fly|Ride"] = 39.32, ["Neon"] = 13.01, ["Neon|Fly"] = 86.28, ["Neon|Ride"] = 42.03, ["Neon|Fly|Ride"] = 101.3, ["Mega"] = 236.25, ["Mega|Ride"] = 144.39, ["Mega|Fly|Ride"] = 224.12}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.82, ["Fly|Ride"] = 290.51, ["Neon"] = 229.66, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 632.48, ["Mega"] = 643.13, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 859.85}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 19.31, ["Fly|Ride"] = 43.12, ["Neon"] = 2.1, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 47.3, ["Mega"] = 21, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9.19, ["Fly"] = 32.82, ["Ride"] = 33.23, ["Fly|Ride"] = 76.33, ["Neon"] = 37.84, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 105, ["Mega"] = 301.88, ["Mega|Fly"] = 575.87, ["Mega|Ride"] = 268.3, ["Mega|Fly|Ride"] = 314.97}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 29.5, ["Fly"] = 59.07, ["Ride"] = 43.13, ["Fly|Ride"] = 129.55, ["Neon"] = 138.72, ["Neon|Ride"] = 198.24, ["Neon|Fly|Ride"] = 223.82, ["Mega"] = 650.56, ["Mega|Ride"] = 861.98, ["Mega|Fly|Ride"] = 677.06}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 19.69, ["Neon"] = 90.03, ["Neon|Ride"] = 105, ["Mega"] = 566.87, ["Mega|Ride"] = 776.72, ["Mega|Fly|Ride"] = 715.84}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.43, ["Ride"] = 16.44, ["Fly|Ride"] = 38.81, ["Neon"] = 4.3, ["Neon|Fly"] = 81.26, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 73.12, ["Mega"] = 40.66, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 11.82, ["Fly"] = 65.63, ["Ride"] = 66.82, ["Neon"] = 84.34, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 267.75, ["Mega|Fly"] = 572.15, ["Mega|Ride"] = 546.25, ["Mega|Fly|Ride"] = 575.33}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1047.38, ["Fly"] = 1278.97, ["Ride"] = 1003.96, ["Fly|Ride"] = 656.25, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2520, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 196.88, ["Ride"] = 249.38, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 894.22, ["Neon|Fly|Ride"] = 1035.93, ["Mega"] = 3574.34, ["Mega|Ride"] = 3735.57, ["Mega|Fly|Ride"] = 3490.99}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 9.26, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 257.54, ["Mega"] = 39.38, ["Mega|Fly|Ride"] = 1149.67}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 108.94, ["Fly"] = 183.75, ["Ride"] = 189.08, ["Fly|Ride"] = 413.44, ["Neon"] = 636.57, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 805.53, ["Mega|Ride"] = 2548.88, ["Mega|Fly|Ride"] = 1983.19}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.88, ["Fly"] = 41, ["Ride"] = 22.58, ["Fly|Ride"] = 93.84, ["Neon"] = 18.11, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 36.57, ["Neon|Fly|Ride"] = 312.77, ["Mega"] = 115.96, ["Mega|Ride"] = 230.6, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 255.94, ["Fly"] = 431.39, ["Ride"] = 288.75, ["Fly|Ride"] = 334.69, ["Neon|Ride"] = 1580.65, ["Neon|Fly|Ride"] = 1198.16, ["Mega|Fly|Ride"] = 4865.69}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 225.47, ["Neon"] = 19.43, ["Neon|Ride"] = 56.54, ["Mega"] = 393.74, ["Mega|Fly"] = 361.29, ["Mega|Ride"] = 431}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 39.39, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 21.95, ["Ride"] = 52.5, ["Fly|Ride"] = 144.39, ["Neon"] = 102.8, ["Neon|Fly"] = 431.39, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 839.27, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 852.78}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 243.66, ["Mega|Ride"] = 265.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.61, ["Fly|Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 51.89, ["Mega"] = 27.66, ["Mega|Ride"] = 48.75, ["Mega|Fly|Ride"] = 97.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5523.54, ["Ride"] = 4536, ["Fly|Ride"] = 4706.63, ["Neon"] = 32351.18, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.36, ["Fly"] = 86.21, ["Ride"] = 41.99, ["Neon"] = 86.21, ["Neon|Fly"] = 383.93, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.52, ["Mega|Fly|Ride"] = 430.32}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 19.51, ["Fly|Ride"] = 45.93, ["Neon"] = 19.43, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 129.31, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 488.25, ["Fly"] = 546.28, ["Ride"] = 459.38, ["Fly|Ride"] = 581.44, ["Neon"] = 1631.3, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 48.78, ["Neon"] = 14.43, ["Neon|Ride"] = 291.38, ["Mega"] = 129.21, ["Mega|Ride"] = 171.33, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.93, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 64.32, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.21, ["Ride"] = 19.76, ["Fly|Ride"] = 65.62, ["Neon"] = 3.86, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 59.07, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 877.07, ["Ride"] = 720.15, ["Fly|Ride"] = 761.25, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 7771.83}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.19, ["Ride"] = 85.3, ["Fly|Ride"] = 287.69, ["Neon"] = 34.01, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 183.91, ["Mega"] = 203.44, ["Mega|Fly"] = 431, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 483.79}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 13.13, ["Fly"] = 106.2, ["Ride"] = 46.05, ["Fly|Ride"] = 123.06, ["Neon"] = 19.69, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 215.52, ["Mega|Fly"] = 812.88, ["Mega|Ride"] = 185.15, ["Mega|Fly|Ride"] = 380.75}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 36.02, ["Ride"] = 18.76, ["Fly|Ride"] = 47.65, ["Neon"] = 14.02, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 30.87, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 165.38, ["Mega|Ride"] = 163.26, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.44, ["Fly"] = 39.38, ["Ride"] = 39.82, ["Fly|Ride"] = 65.63, ["Neon"] = 196.88, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 287.69, ["Mega"] = 636.8, ["Mega|Ride"] = 609.13, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 287.69, ["Neon"] = 3.07, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.17, ["Mega|Fly"] = 146.14, ["Mega|Ride"] = 101.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 575.88, ["Fly"] = 675.6, ["Ride"] = 663.74, ["Fly|Ride"] = 682.5, ["Neon"] = 2243.29, ["Neon|Ride"] = 2291.78, ["Neon|Fly|Ride"] = 2304.29, ["Mega|Ride"] = 9502.34, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Fly|Ride"] = 262.49, ["Neon"] = 12.99, ["Neon|Ride"] = 73.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 53.27, ["Mega|Ride"] = 159.49, ["Mega|Fly|Ride"] = 215.21}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 50.19, ["Fly|Ride"] = 196.88, ["Neon"] = 6.22, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 42, ["Mega|Ride"] = 122.84, ["Mega|Fly|Ride"] = 287.69}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 31.69, ["Neon"] = 3.94, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7365.8, ["Mega"] = 39.37, ["Mega|Fly"] = 159.49, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Mega"] = 238.12, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.13, ["Fly"] = 72.19, ["Ride"] = 58.2, ["Fly|Ride"] = 213.21, ["Neon"] = 103.94, ["Neon|Ride"] = 133.44, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 427.33, ["Mega|Ride"] = 537.8, ["Mega|Fly|Ride"] = 581.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 14.26, ["Ride"] = 36.75, ["Fly|Ride"] = 155.17, ["Neon"] = 87.42, ["Neon|Ride"] = 135.49, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 487.31, ["Mega|Fly|Ride"] = 575.38}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 16.89, ["Fly|Ride"] = 39.62, ["Neon"] = 24.94, ["Neon|Ride"] = 36.61, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.96, ["Ride"] = 29.12, ["Fly|Ride"] = 146.21, ["Neon"] = 63.99, ["Neon|Ride"] = 159.49, ["Mega|Ride"] = 431}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 109.5, ["Neon"] = 12.86, ["Neon|Ride"] = 51.84, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.67, ["Mega|Ride"] = 101.3, ["Mega|Fly|Ride"] = 243.66}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 26.25, ["Fly"] = 26.25, ["Ride"] = 24.61, ["Fly|Ride"] = 45.94, ["Neon"] = 115.76, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 153.79, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 857.68}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.9, ["Fly"] = 874.13, ["Neon"] = 118.13, ["Mega"] = 278.88, ["Mega|Fly"] = 646.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 729.17}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.96, ["Fly"] = 86.63, ["Ride"] = 79.86, ["Fly|Ride"] = 242.82, ["Neon"] = 263.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 1949.2, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 30.76, ["Fly"] = 144.39, ["Ride"] = 76.74, ["Fly|Ride"] = 230.6, ["Neon"] = 97.01, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 502.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 13.13, ["Ride"] = 58.3, ["Neon"] = 139.79, ["Neon|Ride"] = 223.12, ["Mega"] = 502.69, ["Mega|Ride"] = 623.76, ["Mega|Fly|Ride"] = 829.2}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 41.91, ["Fly"] = 65.63, ["Ride"] = 103.94, ["Fly|Ride"] = 196.64, ["Neon"] = 196.88, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 576.08, ["Mega"] = 749.09, ["Mega|Ride"] = 696.55, ["Mega|Fly|Ride"] = 838.88}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 18.71, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 39.38, ["Mega|Fly"] = 325.28, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 105, ["Ride"] = 150.94, ["Fly|Ride"] = 374.22, ["Neon"] = 508.11, ["Neon|Ride"] = 610.97, ["Neon|Fly|Ride"] = 847.97, ["Mega"] = 1622.67, ["Mega|Ride"] = 1650.69, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 76.6, ["Neon"] = 3.94, ["Neon|Fly"] = 101.3, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 301.7, ["Mega"] = 38.07, ["Mega|Ride"] = 87.74, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 26.25, ["Ride"] = 78.75, ["Fly|Ride"] = 215.52, ["Neon"] = 86.21, ["Neon|Ride"] = 228.37, ["Neon|Fly|Ride"] = 395.07, ["Mega"] = 591.93, ["Mega|Ride"] = 575.38, ["Mega|Fly|Ride"] = 616.31}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly|Ride"] = 144.39, ["Mega"] = 24.94}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 3.93, ["Mega"] = 23.49, ["Mega|Ride"] = 112.06, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 97.13, ["Fly"] = 1797.22, ["Ride"] = 148.52, ["Neon"] = 593.31, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 6702.81, ["Mega|Fly|Ride"] = 2056.91}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.56, ["Fly|Ride"] = 71.91, ["Neon"] = 7.17, ["Neon|Fly"] = 43.12, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 91.87, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 37.3, ["Ride"] = 18.53, ["Fly|Ride"] = 65.63, ["Neon"] = 4.85, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 34.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 6.54, ["Ride"] = 41.35, ["Neon"] = 39.38, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 140.14, ["Mega|Fly"] = 205.89, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 9.19, ["Neon|Ride"] = 43.12, ["Mega"] = 117.16}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.27, ["Ride"] = 183.75, ["Fly|Ride"] = 359.89, ["Neon"] = 437.07, ["Neon|Ride"] = 574.14, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 13.44, ["Mega"] = 418.06, ["Mega|Ride"] = 373.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.82, ["Fly|Ride"] = 732.68, ["Neon"] = 1069.69, ["Neon|Ride"] = 1294.92, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 81.38}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 52.49}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.43}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.69}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 49.48}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.81}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.58}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.88}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.92}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 37.79}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 107.23}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.25}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 897.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.67}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.88}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.29}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 40.39}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 695.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 473.49}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.51}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1430.63}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.48}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.25}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 30.61}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 61.69}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 17.07}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.79}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.17}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 50.85}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 12.88}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 18.31}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.34}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2732.89}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 87.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 280.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 4.11}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.59}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 28.38}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.19}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 257.24}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.55}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 154.4}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 72.36}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.86}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.83}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 10.99}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 34.13}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 10.28}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.68}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.1}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.87}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 311.87}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.57}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 325.5}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 93.52}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21.93}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24259.27}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.91}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 62.51}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 32.16}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 59.07}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 30.61}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.94}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 82.09}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.5}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 106.76}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.44}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 57.27}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 247.06}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.4}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.24}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.41}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 148.31}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 3.42}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.8}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 13.13}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 208.69}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.77}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 615.57}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 36.49}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.75}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 39.01}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 71.31}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.46}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.96}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.05}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.75}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 163.96}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 31.17}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 203.81}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 8.68}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 11.82}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.05}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.24}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 32.82}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.49}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.1}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.58}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 29.95}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.2}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.79}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.18}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.56}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.68}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.6}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7218.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.48}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.05}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.1}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.74}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.24}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.77}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.03}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.29}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 41.45}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.16}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.29}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.16}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 40.69}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.27}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 79.84}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.65}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 8.64}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 29.93}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.27}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 12.55}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.83}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.73}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.6}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.69}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.71}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.9}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 70.48}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.82}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.36}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1345.32}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 84}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.15}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 36.39}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.74}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.39}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 19.67}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.43}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.63}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.94}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 6.56}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 4.99}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 21}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.56}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 14.61}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.88}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 84.89}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.84}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.43}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 421.76}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.84}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.68}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 25.71}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 19.59}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.9}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.23}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.72}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 144.39}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 153.57}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 12.98}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.43}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 196.88}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.64}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 56.44}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.39}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 52.5}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.94}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.32}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 6.43}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 58.14}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 11.03}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 65.63}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 4.6}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.85}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 9.19}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 112.87}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 10.74}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.12}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.21}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 53.82}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 129.94}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.9}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.75}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 151.82}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.63}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 7.23}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 38.98}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.6}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.8}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 29.12}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.14}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.34}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 17.75}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 84.06}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 40.65}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 2.59}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.74}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 34.8}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.67}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 30.19}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 89.31}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.31}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.94}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.7}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 17.73}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.79}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 30.35}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.35}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 14.33}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 321.57}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 63}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.7}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 51.45}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 164.04}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.49}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1050}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.74}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 5.92}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1727.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 576.19}},
    ["rbxassetid://8604215904"] = {name = "RGB Reward Box", prices = {["default"] = 2.63}},
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