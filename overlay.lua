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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 983.07, ["Ride"] = 1079.31, ["Fly|Ride"] = 1706.25, ["Neon"] = 6839.48, ["Neon|Fly|Ride"] = 5048.93, ["Mega"] = 21592.46}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 582.75, ["Ride"] = 530.25, ["Fly|Ride"] = 680.4, ["Neon|Fly|Ride"] = 2439.22, ["Mega"] = 10792.9, ["Mega|Fly|Ride"] = 8188.58}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4593.74, ["Fly|Ride"] = 4908.75, ["Neon|Fly|Ride"] = 18276.68, ["Mega|Fly|Ride"] = 76270.03}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 199.5, ["Fly"] = 262.5, ["Ride"] = 229.69, ["Fly|Ride"] = 488.54, ["Neon"] = 1140.57, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 984.38, ["Mega|Fly|Ride"] = 4722.85}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.62, ["Fly"] = 863.75, ["Ride"] = 588, ["Fly|Ride"] = 627.38, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 6431.25}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 11.82, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 84, ["Neon|Fly"] = 288.27, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 323.8, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 539.89}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 6.46, ["Fly"] = 44.63, ["Ride"] = 23.63, ["Fly|Ride"] = 65.37, ["Neon"] = 32.05, ["Neon|Fly"] = 63, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 112.88, ["Mega"] = 177.19, ["Mega|Ride"] = 218.7, ["Mega|Fly|Ride"] = 297.94}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 114.19, ["Fly"] = 215.87, ["Ride"] = 141.75, ["Fly|Ride"] = 214.31, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 2158.58}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.69, ["Fly"] = 97.76, ["Ride"] = 48.8, ["Fly|Ride"] = 114.08, ["Neon"] = 275.62, ["Neon|Ride"] = 229.28, ["Neon|Fly|Ride"] = 295.32, ["Mega"] = 2100, ["Mega|Ride"] = 1151.61, ["Mega|Fly|Ride"] = 830.82}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 20.5, ["Fly"] = 72.19, ["Ride"] = 33.32, ["Fly|Ride"] = 75.35, ["Neon"] = 201.06, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 210, ["Mega"] = 647.59, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Fly"] = 216.57, ["Ride"] = 110.25, ["Fly|Ride"] = 189.58, ["Neon"] = 392.74, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 433.38, ["Mega|Fly|Ride"] = 1509.94}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 62.98}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 361.48, ["Fly"] = 490.17, ["Ride"] = 357.67, ["Fly|Ride"] = 407.13, ["Neon"] = 1295.16, ["Neon|Ride"] = 1402.02, ["Neon|Fly|Ride"] = 1273.13, ["Mega|Fly|Ride"] = 5175.2}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.42, ["Fly"] = 189.97, ["Ride"] = 131.25, ["Fly|Ride"] = 159.87, ["Neon|Fly"] = 683.95, ["Neon|Ride"] = 561.24, ["Neon|Fly|Ride"] = 563.07, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 4.33, ["Fly"] = 79.85, ["Ride"] = 52.5, ["Fly|Ride"] = 163.68, ["Neon"] = 24.84, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 160.13, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 325.97, ["Mega|Fly|Ride"] = 388.56}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 232.32, ["Fly"] = 274.17, ["Ride"] = 233.63, ["Fly|Ride"] = 279.55, ["Neon|Ride"] = 1394.78, ["Neon|Fly|Ride"] = 779.65, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.63, ["Fly"] = 27.8, ["Ride"] = 19.81, ["Fly|Ride"] = 43.8, ["Neon"] = 28.3, ["Neon|Fly"] = 129.57, ["Neon|Ride"] = 71.25, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 170.63, ["Mega|Ride"] = 307.74, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 141.48, ["Fly"] = 288.15, ["Ride"] = 162.75, ["Fly|Ride"] = 328.13, ["Neon"] = 485.63, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 523.69, ["Mega"] = 1648.28, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 1916.25}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 78.74, ["Ride"] = 185.07, ["Fly|Ride"] = 244.28, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1583.1}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 33.49, ["Fly"] = 393.75, ["Ride"] = 58.28, ["Fly|Ride"] = 215.87, ["Neon"] = 262.5, ["Neon|Ride"] = 354.02, ["Neon|Fly|Ride"] = 374.54, ["Mega"] = 1151.61, ["Mega|Ride"] = 1151.61, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 38.89, ["Fly"] = 81.84, ["Ride"] = 56.44, ["Fly|Ride"] = 114.35, ["Neon"] = 216.45, ["Neon|Ride"] = 209.35, ["Neon|Fly|Ride"] = 279.57, ["Mega"] = 1709.88, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.19, ["Fly"] = 249.61, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 161.93, ["Neon|Ride"] = 399.63, ["Neon|Fly|Ride"] = 311.85, ["Mega"] = 1967.44, ["Mega|Ride"] = 1726.88, ["Mega|Fly|Ride"] = 1553.11}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 49.88, ["Ride"] = 53.74, ["Fly|Ride"] = 115.49, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 32.16, ["Fly"] = 102.38, ["Ride"] = 66.94, ["Fly|Ride"] = 114.82, ["Neon"] = 144.71, ["Neon|Ride"] = 307.77, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1140.57, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.88, ["Fly"] = 32.45, ["Ride"] = 26.24, ["Fly|Ride"] = 52.5, ["Neon"] = 57.42, ["Neon|Fly"] = 144.64, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 100.05, ["Mega"] = 152.25, ["Mega|Fly"] = 27385.76, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 427.4}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 407.52, ["Fly"] = 538.58, ["Ride"] = 339.39, ["Fly|Ride"] = 472.5, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 10796.68, ["Mega|Fly|Ride"] = 9690.08}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.65, ["Ride"] = 31.49, ["Fly|Ride"] = 127.38, ["Neon"] = 219.18, ["Mega|Ride"] = 403.67, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 7.43, ["Fly"] = 43.23, ["Ride"] = 21, ["Fly|Ride"] = 47.8, ["Neon"] = 64.31, ["Neon|Ride"] = 97.16, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 269.07, ["Mega|Ride"] = 338.35, ["Mega|Fly|Ride"] = 534.19}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 80.07, ["Fly"] = 85.32, ["Ride"] = 82.69, ["Fly|Ride"] = 131.25, ["Neon"] = 393.75, ["Neon|Ride"] = 439.68, ["Neon|Fly|Ride"] = 400.6, ["Mega"] = 6471.99, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1439.48}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 16.21, ["Ride"] = 34.21, ["Fly|Ride"] = 69.12, ["Neon"] = 83.32, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 720.57, ["Mega|Ride"] = 732.71, ["Mega|Fly|Ride"] = 538.58}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 226.98, ["Fly"] = 262.5, ["Ride"] = 266.89, ["Fly|Ride"] = 340.2, ["Neon"] = 754.44, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 732.81, ["Mega"] = 2806.17, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 3094.83}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 26.24}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.28, ["Fly"] = 26.25, ["Ride"] = 21, ["Fly|Ride"] = 54.46, ["Neon"] = 24.99, ["Neon|Fly"] = 144.69, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 129.52, ["Mega"] = 148.32, ["Mega|Fly"] = 488.56, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.15}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1023.75, ["Fly"] = 2625, ["Ride"] = 854.44, ["Fly|Ride"] = 1294.94, ["Neon"] = 9187.5, ["Neon|Ride"] = 5756.93, ["Neon|Fly|Ride"] = 5037.04, ["Mega|Ride"] = 54961.15, ["Mega|Fly|Ride"] = 18693.28}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.39, ["Fly"] = 53.2, ["Ride"] = 51.96, ["Fly|Ride"] = 105.99, ["Neon"] = 192.95, ["Neon|Ride"] = 265.52, ["Neon|Fly|Ride"] = 279.37, ["Mega"] = 1043.44, ["Mega|Ride"] = 1108.46, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 214.74, ["Fly"] = 366.36, ["Ride"] = 236.25, ["Fly|Ride"] = 328.13, ["Neon"] = 921.38, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4202.77, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4031.15}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.16}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 18.51, ["Fly"] = 86.63, ["Ride"] = 119.44, ["Fly|Ride"] = 144.64, ["Neon"] = 65.63, ["Neon|Ride"] = 128.62, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 586.62, ["Mega|Ride"] = 576.53, ["Mega|Fly|Ride"] = 652.11}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 118.13, ["Fly"] = 163.89, ["Ride"] = 157.5, ["Fly|Ride"] = 170.63, ["Neon"] = 430.65, ["Neon|Fly"] = 430.65, ["Neon|Ride"] = 530.25, ["Neon|Fly|Ride"] = 486.77, ["Mega|Ride"] = 2281.12, ["Mega|Fly|Ride"] = 1808.62}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 114.19, ["Fly"] = 249.34, ["Ride"] = 151.08, ["Fly|Ride"] = 196.88, ["Neon"] = 427.79, ["Neon|Fly"] = 576.35, ["Neon|Ride"] = 430.65, ["Neon|Fly|Ride"] = 497.43, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1560.57}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.04}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 49.44, ["Fly"] = 62.99, ["Ride"] = 45.92, ["Fly|Ride"] = 77.96, ["Neon|Ride"] = 396.12, ["Neon|Fly|Ride"] = 354.38, ["Mega"] = 4318.51, ["Mega|Fly|Ride"] = 1591.96}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 8.19, ["Ride"] = 41.58, ["Fly|Ride"] = 157.5, ["Neon"] = 40.62, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 94.97, ["Neon|Fly|Ride"] = 144.63, ["Mega"] = 208.69, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 256.88, ["Mega|Fly|Ride"] = 431.72}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 743.9, ["Ride"] = 560.27, ["Fly|Ride"] = 619.5, ["Neon"] = 1968.75, ["Neon|Fly"] = 3886.65, ["Neon|Ride"] = 3886.65, ["Neon|Fly|Ride"] = 2016.12, ["Mega|Ride"] = 15110.05, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 114.72, ["Fly"] = 170.63, ["Ride"] = 131.25, ["Fly|Ride"] = 203.44, ["Neon"] = 498.75, ["Neon|Ride"] = 565.57, ["Neon|Fly|Ride"] = 616.88, ["Mega"] = 2806.17, ["Mega|Ride"] = 2590.3, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 4068.75, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5, ["Neon|Fly|Ride"] = 15108.96}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 62.34, ["Fly"] = 231.07, ["Ride"] = 94.5, ["Fly|Ride"] = 201.68, ["Neon|Ride"] = 417.69, ["Neon|Fly|Ride"] = 505.32, ["Mega|Ride"] = 2018.28, ["Mega|Fly|Ride"] = 2013.77}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 72.19, ["Fly|Ride"] = 131.64, ["Neon"] = 575.75, ["Neon|Ride"] = 429.19, ["Neon|Fly|Ride"] = 429.58, ["Mega"] = 6334.43, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 1873.46}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 32.99, ["Fly"] = 81.29, ["Ride"] = 42, ["Fly|Ride"] = 118.12, ["Neon"] = 152.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 136.24, ["Neon|Fly|Ride"] = 195.8, ["Mega"] = 2625, ["Mega|Ride"] = 906.62, ["Mega|Fly|Ride"] = 577.38}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.33}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 57.75, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 130.68, ["Neon|Ride"] = 331.37, ["Neon|Fly|Ride"] = 604.42, ["Mega|Ride"] = 1303.16, ["Mega|Fly|Ride"] = 1363.16}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 33.49}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 177.19, ["Fly|Ride"] = 282.19, ["Neon"] = 1151.61, ["Neon|Ride"] = 1140.57, ["Neon|Fly|Ride"] = 1293, ["Mega|Fly|Ride"] = 4884.6}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 787.48, ["Fly"] = 809.48, ["Ride"] = 717.93, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Ride"] = 2878.47, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 11800.95}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.57}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 33.37, ["Fly"] = 59.13, ["Ride"] = 39.37, ["Fly|Ride"] = 64.32, ["Neon"] = 238.54, ["Neon|Fly"] = 280.63, ["Neon|Ride"] = 159.75, ["Neon|Fly|Ride"] = 213.74, ["Mega|Ride"] = 1171.71, ["Mega|Fly|Ride"] = 718.6}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 22.98}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 5774.21, ["Ride"] = 7915.51, ["Fly|Ride"] = 4900.67, ["Neon|Ride"] = 17911.81, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 35969.47}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 14.44, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 78.71, ["Neon"] = 78.75, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 561.24, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 518.44}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 9.87, ["Fly"] = 141.44, ["Ride"] = 34.13, ["Fly|Ride"] = 120.93, ["Neon"] = 83.06, ["Neon|Ride"] = 133.77, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 971.37, ["Mega|Ride"] = 475.98, ["Mega|Fly|Ride"] = 1079.31}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 76.13, ["Fly"] = 114.42, ["Ride"] = 112.11, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 485.63, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4318.69, ["Mega|Fly|Ride"] = 1791.68}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.72, ["Fly"] = 72.35, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 97.02, ["Neon|Fly"] = 215.87, ["Neon|Ride"] = 131.15, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 485.7, ["Mega|Ride"] = 798.65, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1640.63, ["Fly"] = 1837.5, ["Ride"] = 1970.07, ["Fly|Ride"] = 1739.07, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 27562.5, ["Fly"] = 34549.35, ["Ride"] = 34125, ["Fly|Ride"] = 24937.5, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.11, ["Fly"] = 393.75, ["Ride"] = 54.89, ["Fly|Ride"] = 120.74, ["Neon"] = 258.14, ["Neon|Ride"] = 208.69, ["Neon|Fly|Ride"] = 259.04, ["Mega"] = 754.44, ["Mega|Ride"] = 1303.2, ["Mega|Fly|Ride"] = 749.04}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.67, ["Fly"] = 58.3, ["Ride"] = 49.26, ["Fly|Ride"] = 171.02, ["Neon"] = 23.78, ["Neon|Fly"] = 230.98, ["Neon|Ride"] = 84.36, ["Neon|Fly|Ride"] = 163.68, ["Mega"] = 135.19, ["Mega|Fly"] = 302.22, ["Mega|Ride"] = 244.28, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.89}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.92, ["Ride"] = 37.26, ["Fly|Ride"] = 131.25, ["Neon"] = 56.44, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 274.33, ["Mega"] = 423.09, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 749.04}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 702.63, ["Ride"] = 712.81, ["Fly|Ride"] = 708.75, ["Neon"] = 3094.95, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9389.82}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 939.75, ["Fly"] = 951.57, ["Ride"] = 840, ["Fly|Ride"] = 846.57, ["Neon|Ride"] = 3257.26, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13676.86}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 11.89, ["Fly"] = 122.14, ["Ride"] = 31.5, ["Fly|Ride"] = 77.97, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 502.97, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 523.95}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.56}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 84, ["Fly"] = 117.26, ["Ride"] = 91.88, ["Fly|Ride"] = 135.06, ["Neon"] = 375.6, ["Neon|Ride"] = 377.76, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2016.12, ["Mega|Fly|Ride"] = 2116.5}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 103.69, ["Ride"] = 122.07, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Ride"] = 469.03, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1405.07, ["Mega|Fly|Ride"] = 2158.95}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 5.41, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 64.32, ["Neon"] = 48.88, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 116.65, ["Mega|Fly|Ride"] = 667.99}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 181.79, ["Fly"] = 216.57, ["Ride"] = 204.75, ["Fly|Ride"] = 257.25, ["Neon|Ride"] = 611.03, ["Neon|Fly|Ride"] = 701.86, ["Mega"] = 5182.21, ["Mega|Fly|Ride"] = 2623.69}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.35, ["Ride"] = 49.26, ["Fly|Ride"] = 141.75, ["Neon"] = 47.24, ["Neon|Ride"] = 163.68, ["Mega"] = 249.38, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 342.02, ["Mega|Fly|Ride"] = 469.51}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.56, ["Ride"] = 31.81, ["Fly|Ride"] = 65.5, ["Neon"] = 126, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 787.89}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 27.57, ["Ride"] = 57.73, ["Fly|Ride"] = 156.19, ["Neon"] = 223.59, ["Neon|Ride"] = 210.48, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 15.74, ["Fly"] = 88.52, ["Ride"] = 40.31, ["Fly|Ride"] = 81.94, ["Neon"] = 131.25, ["Neon|Ride"] = 326.06, ["Neon|Fly|Ride"] = 321.64, ["Mega"] = 1258.47, ["Mega|Fly|Ride"] = 862.37}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 6168.75, ["Fly|Ride"] = 5761.88, ["Neon"] = 35988.15, ["Neon|Ride"] = 28875, ["Neon|Fly|Ride"] = 30076.53}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 225.75, ["Fly"] = 275.23, ["Ride"] = 223.02, ["Fly|Ride"] = 276.93, ["Neon"] = 646.5, ["Neon|Fly|Ride"] = 568.32, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 63, ["Fly"] = 170.63, ["Ride"] = 124.71, ["Fly|Ride"] = 243.94, ["Neon"] = 194.9, ["Neon|Ride"] = 256.41, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 486.68, ["Mega|Ride"] = 485.7, ["Mega|Fly|Ride"] = 639.19}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.51, ["Fly"] = 90.39, ["Ride"] = 34.21, ["Fly|Ride"] = 81.37, ["Neon"] = 22.43, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 431.72, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 64.19, ["Fly"] = 163.68, ["Ride"] = 123.92, ["Fly|Ride"] = 257.15, ["Neon"] = 210, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 557.82, ["Mega"] = 504, ["Mega|Fly"] = 733.92, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16549.81, ["Ride"] = 13415.07, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 107641.69}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 334.69, ["Ride"] = 360.51, ["Fly|Ride"] = 556.5, ["Neon|Ride"] = 1683.7, ["Neon|Fly|Ride"] = 1655.63, ["Mega|Fly|Ride"] = 7195.62}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 42.75, ["Fly"] = 90.5, ["Ride"] = 59.06, ["Fly|Ride"] = 91.88, ["Neon"] = 288.75, ["Neon|Ride"] = 328.12, ["Neon|Fly|Ride"] = 374.54, ["Mega|Fly|Ride"] = 2013.97}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 7.72, ["Ride"] = 23.15, ["Fly|Ride"] = 69.09, ["Neon"] = 67.47, ["Neon|Fly"] = 326.06, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 525, ["Mega|Ride"] = 732.81, ["Mega|Fly|Ride"] = 486.77}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.73, ["Ride"] = 421.32, ["Fly|Ride"] = 479.07, ["Neon"] = 1716.08, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.97, ["Ride"] = 42, ["Fly|Ride"] = 150.24, ["Neon"] = 30.19, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 169.32, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 201.85, ["Ride"] = 153.57, ["Fly|Ride"] = 194.91, ["Neon"] = 599.64, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2240.44}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.06, ["Fly"] = 19.19, ["Ride"] = 17.72, ["Fly|Ride"] = 35.44, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 2591.22, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 68.42, ["Ride"] = 87.94, ["Fly|Ride"] = 170.98, ["Neon"] = 244.12, ["Neon|Fly"] = 538.58, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 431.72, ["Mega|Ride"] = 2013.97, ["Mega|Fly|Ride"] = 1583.33}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 13.12, ["Fly"] = 293.09, ["Ride"] = 38.07, ["Fly|Ride"] = 90.57, ["Neon"] = 85.32, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 181.91, ["Mega"] = 547.21, ["Mega|Ride"] = 567.72, ["Mega|Fly|Ride"] = 593.63}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 40.69}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 74.82, ["Fly"] = 144.64, ["Ride"] = 118.13, ["Fly|Ride"] = 431.72, ["Neon"] = 384.59, ["Neon|Ride"] = 431.72, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1629.26, ["Mega|Fly|Ride"] = 2116.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 5.58, ["Fly|Ride"] = 139.26, ["Neon"] = 22.61, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 288.27, ["Mega"] = 131.25, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 326.06}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 12.74, ["Fly"] = 56.42, ["Ride"] = 33.47, ["Fly|Ride"] = 87.84, ["Neon"] = 131.25, ["Neon|Ride"] = 121.05, ["Neon|Fly|Ride"] = 214.8, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 537.96, ["Ride"] = 524.25, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2805.08, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 35.44, ["Fly"] = 107.94, ["Ride"] = 74.47, ["Fly|Ride"] = 100.42, ["Neon"] = 195.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 646.5, ["Mega|Fly|Ride"] = 719.83}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 44.63, ["Fly"] = 144.54, ["Ride"] = 78.66, ["Fly|Ride"] = 146.9, ["Neon"] = 270.38, ["Neon|Ride"] = 232.16, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1070.67, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 18.37, ["Ride"] = 85.32, ["Fly|Ride"] = 130.7, ["Neon"] = 85.32, ["Neon|Ride"] = 219.85, ["Neon|Fly|Ride"] = 262.79, ["Mega"] = 440.35, ["Mega|Fly"] = 525, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 574.88}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 10361.19, ["Ride"] = 8862, ["Fly|Ride"] = 8518.13, ["Neon|Fly|Ride"] = 13650, ["Mega|Fly|Ride"] = 38846.25}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1641.94, ["Fly"] = 1517.02, ["Ride"] = 1606.36, ["Fly|Ride"] = 1371.56, ["Neon"] = 4893.5, ["Neon|Fly|Ride"] = 4170.36, ["Mega|Fly|Ride"] = 14388.23}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 504.05, ["Ride"] = 459.38, ["Fly|Ride"] = 796.69, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 21593.35, ["Mega|Fly|Ride"] = 8634.31}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.15, ["Fly"] = 29.16, ["Ride"] = 21, ["Fly|Ride"] = 41.47, ["Neon"] = 72.19, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.3, ["Fly"] = 78.74, ["Ride"] = 24.44, ["Fly|Ride"] = 198.61, ["Neon"] = 24.95, ["Neon|Ride"] = 56.11, ["Mega"] = 146.99, ["Mega|Ride"] = 204.49, ["Mega|Fly|Ride"] = 345.39}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 37.65, ["Fly"] = 54.73, ["Ride"] = 54.6, ["Fly|Ride"] = 100.09, ["Neon"] = 238.54, ["Neon|Ride"] = 144.23, ["Neon|Fly|Ride"] = 163.63, ["Mega|Fly|Ride"] = 538.58}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.56, ["Fly"] = 29.01, ["Ride"] = 18.05, ["Fly|Ride"] = 38.07, ["Neon"] = 31.7, ["Neon|Fly"] = 83.2, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 114.19, ["Mega"] = 287.05, ["Mega|Ride"] = 360.51, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 311.11, ["Fly"] = 430.5, ["Ride"] = 318.94, ["Fly|Ride"] = 393.63, ["Neon"] = 1078.22, ["Neon|Ride"] = 1151.61, ["Neon|Fly|Ride"] = 1151.61, ["Mega|Fly|Ride"] = 4480.92}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.04, ["Fly"] = 71.25, ["Ride"] = 44.63, ["Fly|Ride"] = 58.3, ["Neon"] = 144.37, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 141.75, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 863.44, ["Mega|Fly"] = 912.21, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 10.48, ["Fly"] = 21.93, ["Ride"] = 19.69, ["Fly|Ride"] = 43.19, ["Neon"] = 84.2, ["Neon|Fly"] = 122.01, ["Neon|Ride"] = 120.93, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 1575, ["Mega|Ride"] = 615.47, ["Mega|Fly|Ride"] = 417.69}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 505.12, ["Fly|Ride"] = 863.71, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1122.28, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon"] = 5240.76, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13670.27}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 144.64, ["Fly"] = 144.64, ["Ride"] = 98.44, ["Fly|Ride"] = 107.34, ["Neon"] = 971.25, ["Neon|Ride"] = 652.19, ["Neon|Fly|Ride"] = 496.13, ["Mega|Ride"] = 2588.15, ["Mega|Fly|Ride"] = 2850.57}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.14, ["Fly"] = 196.88, ["Ride"] = 196.64, ["Fly|Ride"] = 258.56, ["Neon"] = 960.58, ["Neon|Ride"] = 633.56, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 22.23, ["Fly"] = 124.13, ["Ride"] = 53.81, ["Fly|Ride"] = 103.63, ["Neon"] = 242.1, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2158.58, ["Mega|Fly|Ride"] = 1093.09}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 325.5, ["Ride"] = 431.72, ["Fly|Ride"] = 490.01, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1295.16, ["Mega|Fly|Ride"] = 5756.93}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Fly"] = 2446.76, ["Ride"] = 2446.76, ["Fly|Ride"] = 2068.11, ["Neon|Fly|Ride"] = 10792.9, ["Mega|Fly|Ride"] = 37287.75}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 49.54, ["Fly"] = 215.87, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2375.28, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 656.25, ["Fly"] = 777.11, ["Ride"] = 590.63, ["Fly|Ride"] = 648.37, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3018.75}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.93, ["Fly"] = 64.85, ["Ride"] = 53.97, ["Fly|Ride"] = 99.75, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 242.81, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 6.57, ["Fly"] = 48.86, ["Ride"] = 21, ["Fly|Ride"] = 65.63, ["Neon"] = 28.88, ["Neon|Fly"] = 77.44, ["Neon|Ride"] = 48.6, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 183.74, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 268.7}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.63, ["Ride"] = 84.2, ["Fly|Ride"] = 157.5, ["Neon"] = 196.77, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 719.9, ["Mega"] = 1583.33, ["Mega|Ride"] = 1726.88, ["Mega|Fly|Ride"] = 1712.85}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1023.75, ["Fly"] = 1186.15, ["Ride"] = 1032.56, ["Fly|Ride"] = 1099.88, ["Neon|Ride"] = 3453.74, ["Neon|Fly|Ride"] = 3084.38, ["Mega|Fly|Ride"] = 13299.57}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 651, ["Ride"] = 809.48, ["Fly|Ride"] = 905.54, ["Neon|Fly|Ride"] = 4316.08, ["Mega|Fly|Ride"] = 20147.08}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 13.82, ["Fly"] = 26.25, ["Ride"] = 21.86, ["Fly|Ride"] = 51.19, ["Neon"] = 131.25, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 150.94, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 17.8, ["Ride"] = 43.32, ["Fly|Ride"] = 128.25, ["Neon"] = 144.64, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 230.99, ["Mega"] = 896.34, ["Mega|Ride"] = 1005.92, ["Mega|Fly|Ride"] = 861}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 5.66, ["Fly"] = 70.88, ["Ride"] = 37.09, ["Fly|Ride"] = 133.88, ["Neon"] = 26.17, ["Neon|Fly"] = 326.12, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 230.9, ["Mega"] = 157.5, ["Mega|Fly"] = 570.29, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 41.52, ["Fly"] = 55.12, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 403.67, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 234.05, ["Mega|Ride"] = 1085.77, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.17, ["Ride"] = 131.25, ["Fly|Ride"] = 360.51, ["Neon"] = 426.57, ["Neon|Ride"] = 568.4, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2916.38}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 12.83, ["Fly"] = 58.94, ["Ride"] = 34.13, ["Fly|Ride"] = 95.82, ["Neon"] = 107.94, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 197.8, ["Mega"] = 425.39, ["Mega|Ride"] = 362.98, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 32.08, ["Fly"] = 64.32, ["Ride"] = 36.75, ["Fly|Ride"] = 78, ["Neon"] = 242.82, ["Neon|Ride"] = 257.97, ["Neon|Fly|Ride"] = 241.68, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1008.07}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.81, ["Fly"] = 49.3, ["Ride"] = 16.87, ["Fly|Ride"] = 41.18, ["Neon"] = 25.99, ["Neon|Ride"] = 53.99, ["Neon|Fly|Ride"] = 102.38, ["Mega"] = 434.74, ["Mega|Ride"] = 488.54, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 7.77, ["Fly"] = 55.13, ["Ride"] = 36.74, ["Fly|Ride"] = 106.26, ["Neon"] = 51.98, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 79.9, ["Neon|Fly|Ride"] = 209.49, ["Mega"] = 539.44, ["Mega|Ride"] = 476.51, ["Mega|Fly|Ride"] = 582.75}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 48.57, ["Fly"] = 72.18, ["Ride"] = 53.45, ["Fly|Ride"] = 100.8, ["Neon"] = 572.87, ["Neon|Ride"] = 215.87, ["Neon|Fly|Ride"] = 275.31, ["Mega"] = 1482.7, ["Mega|Fly|Ride"] = 1074.93}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1428, ["Fly"] = 1410.94, ["Ride"] = 1407, ["Fly|Ride"] = 1378.13, ["Neon|Ride"] = 4885.29, ["Neon|Fly|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 12576.37}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.73, ["Fly"] = 525, ["Ride"] = 525, ["Fly|Ride"] = 564.38, ["Neon|Ride"] = 3258.05, ["Neon|Fly|Ride"] = 2362.5, ["Mega"] = 15115.35}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 255.93, ["Fly"] = 323.73, ["Ride"] = 351.74, ["Fly|Ride"] = 387.19, ["Neon"] = 1575, ["Neon|Ride"] = 1378.13, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Ride"] = 7327.9, ["Mega|Fly|Ride"] = 7770.89}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 48.54, ["Ride"] = 49.77, ["Fly|Ride"] = 110.25, ["Neon"] = 323.8, ["Neon|Ride"] = 287.52, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 1187.24, ["Mega|Fly|Ride"] = 971.37}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 18375, ["Ride"] = 37448.93, ["Fly|Ride"] = 16929.94, ["Neon|Fly|Ride"] = 37931.25, ["Mega"] = 215857.53, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 210, ["Fly"] = 277.37, ["Ride"] = 249.38, ["Fly|Ride"] = 313.69, ["Neon"] = 902.99, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 923.88, ["Neon|Fly|Ride"] = 912.19, ["Mega"] = 6478.03, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 123.05, ["Fly"] = 525, ["Ride"] = 211.45, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 135.63, ["Fly"] = 213.68, ["Ride"] = 111.57, ["Fly|Ride"] = 198.19, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 566.64, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.12, ["Fly"] = 64.79, ["Ride"] = 30.19, ["Fly|Ride"] = 63, ["Neon"] = 81.84, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 233.15, ["Mega"] = 1968.75, ["Mega|Ride"] = 719.9, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5209.75, ["Ride"] = 4058.25, ["Fly|Ride"] = 4200, ["Neon"] = 21593.35, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 81424.32}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 28.67, ["Fly"] = 47.74, ["Ride"] = 35.33, ["Fly|Ride"] = 58.59, ["Neon"] = 131.25, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 186.41, ["Mega|Ride"] = 1439.79, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 33.5, ["Fly"] = 101.47, ["Ride"] = 39.38, ["Fly|Ride"] = 89.25, ["Neon"] = 301.53, ["Neon|Fly"] = 274.17, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 320.25, ["Mega|Fly|Ride"] = 1439.79}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 419.99, ["Fly"] = 446.25, ["Ride"] = 479.85, ["Fly|Ride"] = 524.95, ["Neon"] = 1410.94, ["Neon|Ride"] = 1141.88, ["Neon|Fly|Ride"] = 1305.94, ["Mega|Ride"] = 4318.51, ["Mega|Fly|Ride"] = 4302.37}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 14.44, ["Fly"] = 30.76, ["Ride"] = 24.82, ["Fly|Ride"] = 49.88, ["Neon"] = 131.25, ["Neon|Ride"] = 111.19, ["Neon|Fly|Ride"] = 150.94, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 638.9}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.81, ["Fly"] = 288.27, ["Ride"] = 30.19, ["Fly|Ride"] = 80.61, ["Neon"] = 105, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 732.81}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.95, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 662.7, ["Mega|Fly|Ride"] = 4072.55}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 15.28, ["Fly"] = 539.85, ["Ride"] = 53.82, ["Fly|Ride"] = 105, ["Neon"] = 90.39, ["Neon|Fly"] = 144.64, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 444.68, ["Mega"] = 429.58, ["Mega|Fly"] = 488.54, ["Mega|Ride"] = 288.09, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4305, ["Fly"] = 6334.98, ["Ride"] = 4423.13, ["Fly|Ride"] = 4331.25, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 11576.14, ["Mega"] = 64757.26, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.13, ["Fly"] = 73.41, ["Ride"] = 51.45, ["Fly|Ride"] = 152.25, ["Neon"] = 233.62, ["Neon|Fly"] = 275.63, ["Neon|Ride"] = 258.57, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 863.44, ["Mega|Ride"] = 1791.75, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7986.75, ["Ride"] = 6857.82, ["Fly|Ride"] = 6129.38, ["Neon"] = 22798.3, ["Neon|Fly|Ride"] = 15159.38, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.84, ["Fly"] = 23.87, ["Ride"] = 17.73, ["Fly|Ride"] = 33.62, ["Neon"] = 33.47, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 100.19, ["Mega"] = 210, ["Mega|Ride"] = 394.46, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.35, ["Fly"] = 33.99, ["Ride"] = 32.82, ["Fly|Ride"] = 55.07, ["Neon"] = 125.22, ["Neon|Fly"] = 238.54, ["Neon|Ride"] = 141.41, ["Neon|Fly|Ride"] = 144.64, ["Mega|Ride"] = 1008.38, ["Mega|Fly|Ride"] = 863.44}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.33}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.49, ["Fly"] = 32.82, ["Ride"] = 30.19, ["Fly|Ride"] = 88.73, ["Neon"] = 91.88, ["Neon|Ride"] = 138.21, ["Mega"] = 1049.9, ["Mega|Ride"] = 1150.94, ["Mega|Fly|Ride"] = 1125.71}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.43, ["Fly"] = 190.37, ["Ride"] = 32.82, ["Fly|Ride"] = 63, ["Neon"] = 144.64, ["Neon|Ride"] = 255.94, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 863.44, ["Mega|Fly|Ride"] = 814.52}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 14.66, ["Fly"] = 27.57, ["Ride"] = 20.99, ["Fly|Ride"] = 42.76, ["Neon"] = 94, ["Neon|Fly"] = 1076.44, ["Neon|Ride"] = 101.47, ["Neon|Fly|Ride"] = 127.98, ["Mega"] = 2591.22, ["Mega|Fly|Ride"] = 628.17}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8625.68}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2958.67}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.42}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 259.04, ["Ride"] = 203.44, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1206.51}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.04, ["Fly"] = 97.72, ["Ride"] = 36.66, ["Fly|Ride"] = 138.16, ["Neon"] = 163.68, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 431.64, ["Mega|Ride"] = 2037.17, ["Mega|Fly|Ride"] = 534.27}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.23}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 6.57, ["Ride"] = 26.24, ["Fly|Ride"] = 86.36, ["Neon"] = 155.44, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2440.26}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 236.25, ["Fly"] = 431.72, ["Ride"] = 262.5, ["Fly|Ride"] = 732.71, ["Neon"] = 1140.57, ["Neon|Ride"] = 1075.99, ["Neon|Fly|Ride"] = 1070.67, ["Mega|Ride"] = 4173.63, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 64.32, ["Fly"] = 475.13, ["Ride"] = 79.26, ["Fly|Ride"] = 244.28, ["Neon"] = 415.26, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 720.13, ["Mega|Fly|Ride"] = 2001.02}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 208.68, ["Fly"] = 261.34, ["Ride"] = 211.8, ["Fly|Ride"] = 285.29, ["Neon"] = 944.99, ["Neon|Ride"] = 820.28, ["Neon|Fly|Ride"] = 787.5, ["Mega|Ride"] = 3669.59, ["Mega|Fly|Ride"] = 3163.31}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2489.82, ["Fly"] = 3310.19, ["Ride"] = 2537.27, ["Fly|Ride"] = 2996.53, ["Neon"] = 15159.68, ["Neon|Ride"] = 9770.53, ["Neon|Fly|Ride"] = 9282.02, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 14.44, ["Fly"] = 105.82, ["Ride"] = 56.05, ["Fly|Ride"] = 112.26, ["Neon"] = 127.32, ["Neon|Ride"] = 156.35, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 970.3, ["Mega|Ride"] = 1008.07, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 560.6, ["Fly"] = 2100, ["Ride"] = 814.64, ["Fly|Ride"] = 863.44, ["Neon|Fly|Ride"] = 5395.38}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 41.99}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 22.09, ["Ride"] = 48.18, ["Fly|Ride"] = 203.44, ["Neon"] = 105, ["Neon|Ride"] = 137.15, ["Neon|Fly|Ride"] = 245.01, ["Mega"] = 480.38, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 8.5, ["Fly"] = 42.73, ["Ride"] = 29.16, ["Fly|Ride"] = 75.73, ["Neon"] = 72.1, ["Neon|Ride"] = 103.95, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 456.72, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 270.92}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 51.19}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 28.07, ["Fly"] = 32.4, ["Ride"] = 26.18, ["Fly|Ride"] = 59.07, ["Neon|Ride"] = 215.87, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1223.94, ["Mega|Fly|Ride"] = 2159.27}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.18, ["Fly"] = 46.43, ["Ride"] = 32.15, ["Fly|Ride"] = 45.94, ["Neon"] = 288.18, ["Neon|Fly"] = 238.54, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 287.11, ["Mega"] = 1440.29, ["Mega|Ride"] = 1832.06, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6745.56, ["Fly"] = 4987.5, ["Ride"] = 6332.2, ["Fly|Ride"] = 5197.49, ["Neon|Fly|Ride"] = 10237.5, ["Mega|Fly|Ride"] = 31654.29}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.48, ["Fly"] = 46.82, ["Ride"] = 34.02, ["Fly|Ride"] = 86.36, ["Neon"] = 56.44, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 233.25, ["Mega"] = 354.38, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 619.23}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.49}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.31, ["Fly"] = 382.22, ["Ride"] = 116.94, ["Fly|Ride"] = 203.96, ["Neon"] = 504.05, ["Neon|Ride"] = 488.54, ["Neon|Fly|Ride"] = 535.5, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 58.93, ["Fly"] = 192.86, ["Ride"] = 84, ["Fly|Ride"] = 174.71, ["Neon"] = 287.11, ["Neon|Fly"] = 390.78, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 576.35, ["Mega"] = 2442.68, ["Mega|Ride"] = 977.07, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 23.14, ["Fly"] = 82.05, ["Ride"] = 31.84, ["Fly|Ride"] = 65.58, ["Neon"] = 172.71, ["Neon|Fly"] = 233.15, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 1016.21, ["Mega|Ride"] = 896.34, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 6.42, ["Fly"] = 78.74, ["Ride"] = 31.2, ["Fly|Ride"] = 106.32, ["Neon"] = 32.22, ["Neon|Fly"] = 86.36, ["Neon|Ride"] = 78.19, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 213.94, ["Mega|Fly"] = 7197.86, ["Mega|Ride"] = 225.25, ["Mega|Fly|Ride"] = 335.55}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 14.03, ["Fly"] = 65.63, ["Ride"] = 26.25, ["Fly|Ride"] = 97.16, ["Neon"] = 80.56, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 220.5, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 538.58}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 21.83, ["Fly"] = 28.87, ["Ride"] = 27.22, ["Fly|Ride"] = 52.2, ["Neon"] = 278.25, ["Neon|Fly"] = 81.84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.4, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 206.05}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 25.91, ["Ride"] = 136.01, ["Fly|Ride"] = 288.18, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 863.44, ["Mega|Ride"] = 768.46, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 188.89, ["Fly"] = 576.35, ["Ride"] = 188.89, ["Fly|Ride"] = 576.35, ["Neon|Fly|Ride"] = 28781.38}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 52.82, ["Fly"] = 215.87, ["Ride"] = 89.25, ["Fly|Ride"] = 139.07, ["Neon"] = 210, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1153.69, ["Mega|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 1019.82}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1246.88, ["Ride"] = 1148.44, ["Fly|Ride"] = 1220.63, ["Neon"] = 4701.43, ["Neon|Fly"] = 4701.43, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3656.61, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 374.07, ["Fly"] = 720.13, ["Ride"] = 393.75, ["Fly|Ride"] = 536.52, ["Neon"] = 3600.57, ["Neon|Ride"] = 1629.26, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 12951.46, ["Mega|Fly|Ride"] = 9842.44}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 39.38}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 2.63}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.07, ["Fly"] = 32.79, ["Ride"] = 24.81, ["Fly|Ride"] = 53.82, ["Neon"] = 72.33, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 437.26, ["Mega|Ride"] = 719.9, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 228.38, ["Fly"] = 339.99, ["Ride"] = 283.14, ["Fly|Ride"] = 351.75, ["Neon"] = 846.02, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 954.19, ["Mega|Fly|Ride"] = 2982.09}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 17.05}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 111.22, ["Ride"] = 163.36, ["Fly|Ride"] = 245.44, ["Neon"] = 656.25, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 584.07, ["Neon|Fly|Ride"] = 714, ["Mega"] = 2734.45, ["Mega|Ride"] = 2446.76, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 288.18, ["Ride"] = 157.5, ["Fly|Ride"] = 262.5, ["Neon"] = 719.9, ["Neon|Ride"] = 431.72, ["Neon|Fly|Ride"] = 931.88, ["Mega|Fly|Ride"] = 4068.75}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 6.22, ["Fly"] = 79.9, ["Ride"] = 25.38, ["Fly|Ride"] = 215.87, ["Neon"] = 31.5, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 247.51, ["Mega"] = 170.63, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 241.5}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.5, ["Fly"] = 50.4, ["Ride"] = 24.7, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 326.06, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 11.42, ["Fly"] = 102.36, ["Ride"] = 34.5, ["Fly|Ride"] = 129.52, ["Neon"] = 85.31, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 6.22, ["Fly"] = 172.71, ["Ride"] = 45.94, ["Fly|Ride"] = 118.13, ["Neon"] = 31.8, ["Neon|Fly"] = 105, ["Neon|Ride"] = 76.12, ["Neon|Fly|Ride"] = 206.15, ["Mega"] = 144.37, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 288.16}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.36, ["Ride"] = 315, ["Fly|Ride"] = 341.25, ["Neon"] = 1439.79, ["Neon|Ride"] = 1401.89, ["Neon|Fly|Ride"] = 1395.72, ["Mega|Fly|Ride"] = 6648.44}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 92.67, ["Fly"] = 576.53, ["Ride"] = 128.63, ["Fly|Ride"] = 208.69, ["Neon"] = 393.75, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 509.25, ["Mega"] = 2158.58, ["Mega|Ride"] = 2734.93, ["Mega|Fly|Ride"] = 1727.31}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 65.62, ["Fly"] = 167.45, ["Ride"] = 78.66, ["Fly|Ride"] = 110.4, ["Neon"] = 315, ["Neon|Ride"] = 341.22, ["Neon|Fly|Ride"] = 420, ["Mega|Ride"] = 1629.26, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Fly"] = 127.32, ["Ride"] = 53.99, ["Fly|Ride"] = 288.18, ["Neon|Ride"] = 620.48, ["Neon|Fly|Ride"] = 326.06}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.47, ["Ride"] = 34.11, ["Fly|Ride"] = 91.85, ["Neon"] = 79.42, ["Neon|Ride"] = 86.36, ["Neon|Fly|Ride"] = 126, ["Mega"] = 791.12, ["Mega|Ride"] = 488.54, ["Mega|Fly|Ride"] = 576.35}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.68, ["Fly"] = 43.32, ["Ride"] = 22.54, ["Fly|Ride"] = 51.14, ["Neon"] = 19.69, ["Neon|Fly"] = 85.29, ["Neon|Ride"] = 40.55, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.25, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 285.57}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 892.5, ["Fly"] = 918.75, ["Ride"] = 913.5, ["Fly|Ride"] = 927.68, ["Neon"] = 3137.52, ["Neon|Fly"] = 3315.89, ["Neon|Ride"] = 8634.31, ["Neon|Fly|Ride"] = 2257.5, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 288.75, ["Fly"] = 328.13, ["Ride"] = 299.25, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1401.75, ["Mega"] = 10796.68, ["Mega|Fly|Ride"] = 5048.93}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 95.99, ["Fly"] = 172.71, ["Ride"] = 116.94, ["Fly|Ride"] = 163.68, ["Neon"] = 423.82, ["Neon|Ride"] = 377.76, ["Neon|Fly|Ride"] = 559.09, ["Mega"] = 1312.5, ["Mega|Ride"] = 1742, ["Mega|Fly|Ride"] = 1873.26}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 209.99, ["Fly"] = 278.49, ["Ride"] = 183.74, ["Fly|Ride"] = 223.13, ["Neon"] = 918.75, ["Neon|Ride"] = 1022.44, ["Neon|Fly|Ride"] = 1050, ["Mega"] = 10796.68, ["Mega|Fly|Ride"] = 4072.55}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 21, ["Fly"] = 58.3, ["Ride"] = 33.74, ["Fly|Ride"] = 69.57, ["Neon"] = 169.32, ["Neon|Ride"] = 107.94, ["Neon|Fly|Ride"] = 215.87, ["Mega|Ride"] = 763.08, ["Mega|Fly|Ride"] = 1004.83}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 204.75, ["Ride"] = 271.32, ["Fly|Ride"] = 392.44, ["Neon"] = 1050.53, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1221.77, ["Mega"] = 3236.68, ["Mega|Fly|Ride"] = 4234.32}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 86.66, ["Fly"] = 125.99, ["Ride"] = 78.57, ["Fly|Ride"] = 129.52, ["Neon|Ride"] = 1629.31, ["Neon|Fly|Ride"] = 863.44, ["Mega|Ride"] = 2304.03, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 3182.32, ["Ride"] = 2231.13, ["Fly|Ride"] = 2546.25, ["Neon|Ride"] = 11398.21, ["Neon|Fly|Ride"] = 7052.08, ["Mega"] = 51824.04, ["Mega|Fly|Ride"] = 29307.54}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 12.99, ["Fly"] = 72.23, ["Ride"] = 44.61, ["Fly|Ride"] = 108.93, ["Neon"] = 52.49, ["Neon|Fly"] = 173.02, ["Neon|Ride"] = 100.96, ["Neon|Fly|Ride"] = 172.75, ["Mega"] = 290.71, ["Mega|Ride"] = 295.74, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 46.77, ["Ride"] = 59.07, ["Fly|Ride"] = 92.84, ["Neon"] = 216.57, ["Neon|Ride"] = 224.35, ["Neon|Fly|Ride"] = 381.32, ["Mega|Ride"] = 862.37, ["Mega|Fly|Ride"] = 1288.69}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.43, ["Fly"] = 94.29, ["Ride"] = 85.31, ["Fly|Ride"] = 89.25, ["Neon"] = 525, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2203.69, ["Fly"] = 1629.31, ["Ride"] = 1073.62, ["Fly|Ride"] = 987.51, ["Neon|Ride"] = 5699.98, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 36983.96, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 430.49, ["Fly"] = 861.29, ["Ride"] = 755.51, ["Fly|Ride"] = 534.19, ["Neon|Fly|Ride"] = 1575}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 118.13, ["Ride"] = 107.94, ["Fly|Ride"] = 279.55, ["Neon"] = 440.87, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 504.05, ["Mega"] = 2590.3, ["Mega|Ride"] = 2605.94, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.87, ["Ride"] = 23.72, ["Fly|Ride"] = 63.24, ["Neon"] = 86.63, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 133.58, ["Mega"] = 656.25, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 36.96, ["Fly"] = 68.25, ["Ride"] = 53.99, ["Fly|Ride"] = 84.62, ["Neon"] = 161.93, ["Neon|Fly"] = 360.51, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 339.94, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 1049.99}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 720.57, ["Fly"] = 1123.66, ["Ride"] = 862.37, ["Fly|Ride"] = 823.46, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2100, ["Mega|Fly|Ride"] = 9689.93}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 649.61}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5250, ["Ride"] = 5906.25, ["Fly|Ride"] = 5250, ["Neon"] = 42000, ["Neon|Ride"] = 30943.06, ["Neon|Fly|Ride"] = 27349.88, ["Mega|Fly|Ride"] = 107962.22}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 404.75, ["Ride"] = 343.23, ["Fly|Ride"] = 424.98, ["Neon"] = 1312.5, ["Neon|Fly|Ride"] = 2159.35, ["Mega"] = 6474.66, ["Mega|Fly|Ride"] = 6475.73}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 98.12, ["Ride"] = 157.4, ["Fly|Ride"] = 190.32, ["Neon"] = 1151.61, ["Neon|Ride"] = 576.35, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 1942.74}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 16.7, ["Fly"] = 72.33, ["Ride"] = 40.05, ["Fly|Ride"] = 78.75, ["Neon"] = 141.75, ["Neon|Ride"] = 179.18, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 863.44, ["Mega|Fly|Ride"] = 792.22}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.7, ["Fly"] = 32.82, ["Ride"] = 25.33, ["Fly|Ride"] = 51.82, ["Neon"] = 215.87, ["Neon|Ride"] = 326.1, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1079.31}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 15.11, ["Ride"] = 38.05, ["Fly|Ride"] = 105.91, ["Neon"] = 124.69, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 641.1}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.16, ["Fly"] = 29.16, ["Ride"] = 22.32, ["Fly|Ride"] = 48.86, ["Neon"] = 37.83, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.31, ["Mega"] = 668.25, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 259.62}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 18.38, ["Ride"] = 40.69, ["Fly|Ride"] = 138.16, ["Neon"] = 158.17, ["Neon|Fly"] = 863.44, ["Neon|Ride"] = 137.09, ["Neon|Fly|Ride"] = 322.73, ["Mega"] = 630, ["Mega|Ride"] = 719.9}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 538.13, ["Fly"] = 590.63, ["Ride"] = 590.63, ["Fly|Ride"] = 616.88, ["Neon"] = 1712.85, ["Neon|Ride"] = 1713.93, ["Neon|Fly|Ride"] = 1627.5, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 6412.97}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.35, ["Fly"] = 19.69, ["Ride"] = 16.21, ["Fly|Ride"] = 38.07, ["Neon"] = 22.52, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 157.5, ["Mega|Ride"] = 203.98, ["Mega|Fly|Ride"] = 207.38}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 44.62, ["Fly"] = 118.1, ["Ride"] = 81.36, ["Fly|Ride"] = 131.15, ["Neon"] = 196.88, ["Neon|Ride"] = 210.18, ["Neon|Fly|Ride"] = 258.46, ["Mega"] = 564.37, ["Mega|Fly"] = 863.44, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 594.56}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 771.61, ["Ride"] = 754.69, ["Fly|Ride"] = 792.73, ["Neon|Fly"] = 2136.62, ["Neon|Ride"] = 2734.93, ["Neon|Fly|Ride"] = 1575, ["Mega|Fly|Ride"] = 4287.82}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 27.2, ["Fly"] = 70.86, ["Ride"] = 41.98, ["Fly|Ride"] = 97.13, ["Neon"] = 262.5, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 251.99, ["Mega"] = 1221.34, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 881.51}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 312.5, ["Fly"] = 364.16, ["Ride"] = 262.5, ["Fly|Ride"] = 328.07, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4561.64}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 254.69, ["Fly"] = 330.75, ["Ride"] = 249.35, ["Fly|Ride"] = 324.96, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 4821.2}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 752.17, ["Ride"] = 697.95, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3599.44, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9186.19}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.48, ["Fly"] = 62.62, ["Ride"] = 47.25, ["Fly|Ride"] = 107.47, ["Neon"] = 49.88, ["Neon|Fly"] = 293.13, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 164.8, ["Mega"] = 328.13, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 451.5}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3346.88, ["Fly"] = 3543.75, ["Ride"] = 3386.25, ["Fly|Ride"] = 3476.82, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19333.13}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 147, ["Fly"] = 178.47, ["Ride"] = 147, ["Fly|Ride"] = 262.5, ["Neon"] = 535.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 637.87, ["Mega"] = 3237.87, ["Mega|Fly|Ride"] = 3311.21}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.61, ["Fly"] = 30.69, ["Ride"] = 19.03, ["Fly|Ride"] = 43.22, ["Neon"] = 25.91, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 86.36, ["Mega"] = 142.77, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 164.07, ["Mega|Fly|Ride"] = 274.17}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.93, ["Ride"] = 28.07, ["Fly|Ride"] = 69.16, ["Neon"] = 25.08, ["Neon|Fly"] = 119.7, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 280.6, ["Mega|Fly|Ride"] = 373.05}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 47.2, ["Fly"] = 42, ["Ride"] = 42, ["Fly|Ride"] = 63.29, ["Neon"] = 293.13, ["Neon|Ride"] = 410.15, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1236.62}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 724.5, ["Fly"] = 1172.31, ["Ride"] = 918.73, ["Fly|Ride"] = 1048.69, ["Neon"] = 4316.39, ["Neon|Ride"] = 4885.29, ["Neon|Fly|Ride"] = 4805.9}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Ride"] = 8634.31, ["Fly|Ride"] = 5906.25}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 23.63, ["Fly"] = 27.57, ["Ride"] = 27.55, ["Fly|Ride"] = 48.57, ["Neon"] = 452.12, ["Neon|Ride"] = 122.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 2520, ["Mega|Ride"] = 863.37, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.33, ["Fly"] = 59.07, ["Ride"] = 28.82, ["Fly|Ride"] = 65.63, ["Neon"] = 120.65, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 89.15, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 104.99, ["Ride"] = 101.6, ["Fly|Ride"] = 156.18, ["Neon|Ride"] = 430.5, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2734.93}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 223.13, ["Fly"] = 1152.02, ["Ride"] = 236.24, ["Fly|Ride"] = 280.6, ["Neon"] = 1302.97, ["Neon|Ride"] = 1182.93, ["Neon|Fly|Ride"] = 1029, ["Mega"] = 10792.9, ["Mega|Fly|Ride"] = 3584.34}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.93, ["Ride"] = 34.56, ["Fly|Ride"] = 72.19, ["Neon"] = 30.56, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 70.88, ["Mega"] = 133.79, ["Mega|Fly"] = 240.7, ["Mega|Ride"] = 153.04, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 194.24, ["Fly"] = 257.25, ["Ride"] = 208.37, ["Fly|Ride"] = 290.07, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 727.13, ["Mega|Fly|Ride"] = 3107.32}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.78, ["Fly"] = 25.62, ["Ride"] = 17.06, ["Fly|Ride"] = 48.86, ["Neon"] = 26.25, ["Neon|Fly"] = 129.52, ["Neon|Ride"] = 43.99, ["Neon|Fly|Ride"] = 124.13, ["Mega"] = 183.75, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 262.5, ["Fly"] = 328.13, ["Ride"] = 253.64, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1410.97, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 10796.68, ["Mega|Fly|Ride"] = 5537.46}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.81, ["Fly"] = 104.98, ["Ride"] = 26.25, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 310.25, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 576.56, ["Mega|Ride"] = 444.68, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 6.48, ["Ride"] = 24.94, ["Neon"] = 7.88, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 48.57, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 90.57, ["Mega|Ride"] = 136.16, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.79, ["Mega"] = 22.6, ["Mega|Ride"] = 144.64, ["Mega|Fly|Ride"] = 180.77}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 73.29, ["Fly|Ride"] = 115.49, ["Neon"] = 7.28, ["Neon|Ride"] = 28.01, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 64.56, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 85.83, ["Mega|Fly|Ride"] = 249.13}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 72.16, ["Fly"] = 167.02, ["Ride"] = 110.24, ["Fly|Ride"] = 181.89, ["Neon"] = 281.54, ["Neon|Ride"] = 308.44, ["Neon|Fly|Ride"] = 410.82, ["Mega|Fly|Ride"] = 1792.71}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 43.19, ["Ride"] = 17.07, ["Fly|Ride"] = 84.2, ["Neon"] = 5.25, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 58.7, ["Mega"] = 82.05, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 10.5, ["Ride"] = 84, ["Neon"] = 82.27, ["Neon|Fly"] = 326.06, ["Neon|Ride"] = 212.42, ["Neon|Fly|Ride"] = 360.51, ["Mega"] = 406.88, ["Mega|Ride"] = 574.2, ["Mega|Fly|Ride"] = 547.43}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.1, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 163.68, ["Mega"] = 16.89, ["Mega|Fly"] = 53.82, ["Mega|Ride"] = 57.16, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.54, ["Ride"] = 11.82, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 43.81, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 36.74, ["Mega"] = 14.59, ["Mega|Fly"] = 36.54, ["Mega|Ride"] = 19.98, ["Mega|Fly|Ride"] = 49.65}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.16, ["Ride"] = 16.21, ["Fly|Ride"] = 80.97, ["Neon"] = 2.1, ["Neon|Fly"] = 23.69, ["Neon|Ride"] = 17.16, ["Neon|Fly|Ride"] = 41.15, ["Mega"] = 18.36, ["Mega|Fly"] = 163.59, ["Mega|Ride"] = 32.41, ["Mega|Fly|Ride"] = 91.68}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 18.38, ["Mega|Ride"] = 108.94, ["Mega|Fly|Ride"] = 245.01}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.9, ["Ride"] = 21, ["Fly|Ride"] = 52.5, ["Neon"] = 4.81, ["Neon|Fly"] = 123.05, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 41.53, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 42, ["Mega|Fly|Ride"] = 89.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 2.62, ["Neon|Ride"] = 89.06, ["Neon|Fly|Ride"] = 431.72, ["Mega"] = 20.81, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 140.44}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6, ["Fly"] = 47.24, ["Ride"] = 31.5, ["Fly|Ride"] = 163.66, ["Neon"] = 45.93, ["Neon|Fly"] = 144.64, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 177.09, ["Mega"] = 223.11, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 351.75}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 26.88, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 24.94, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 137.09, ["Mega|Fly|Ride"] = 195.43}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.6, ["Fly"] = 65.63, ["Fly|Ride"] = 144.64, ["Neon"] = 23.62, ["Mega"] = 119.42, ["Mega|Fly"] = 315, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 22.97, ["Mega"] = 133.61, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 144.69, ["Ride"] = 32.82, ["Neon"] = 3.62, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 22.29, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.56, ["Ride"] = 16.21, ["Fly|Ride"] = 40.68, ["Neon"] = 2.1, ["Neon|Fly"] = 35.21, ["Neon|Ride"] = 15.48, ["Neon|Fly|Ride"] = 34.01, ["Mega"] = 23.78, ["Mega|Fly"] = 21.91, ["Mega|Ride"] = 22.31, ["Mega|Fly|Ride"] = 51.19}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.94, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 37.8, ["Neon|Ride"] = 140.32, ["Mega"] = 201.9, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Fly|Ride"] = 48.86, ["Neon"] = 3.42, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 36.71, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 26.85, ["Mega|Ride"] = 166.69, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.56, ["Neon"] = 17.55, ["Neon|Ride"] = 195.11, ["Mega"] = 105.7, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 331.46}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 39.38, ["Neon"] = 11.71, ["Neon|Ride"] = 50.76, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 163.41, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 12.59, ["Ride"] = 11.81, ["Fly|Ride"] = 36.71, ["Neon"] = 2.1, ["Neon|Fly"] = 16.21, ["Neon|Ride"] = 12.6, ["Neon|Fly|Ride"] = 31.5, ["Mega"] = 13.62, ["Mega|Fly"] = 27.87, ["Mega|Ride"] = 23.63, ["Mega|Fly|Ride"] = 51.95}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27.42, ["Fly|Ride"] = 144.38, ["Neon"] = 12.96, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 24.44, ["Neon"] = 72.19, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 304.5, ["Mega|Ride"] = 297.5, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 13.13, ["Fly|Ride"] = 41.62, ["Neon"] = 2.1, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 23.63, ["Mega|Fly"] = 50.72, ["Mega|Ride"] = 35.56, ["Mega|Fly|Ride"] = 84.07}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 3.94, ["Fly"] = 180.31, ["Ride"] = 45.93, ["Neon"] = 9.1, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 163.68, ["Mega"] = 38.07, ["Mega|Fly"] = 163.68, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.43, ["Fly|Ride"] = 131.25, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 32.79, ["Mega|Fly"] = 116.93, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 381.29}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Ride"] = 20.81, ["Neon"] = 2.1, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 107.94, ["Mega"] = 15.32, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 71.25, ["Mega|Fly|Ride"] = 196.86}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 23.78, ["Ride"] = 19.69, ["Fly|Ride"] = 55.42, ["Neon"] = 7.09, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 74.8, ["Mega"] = 72.33, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 28.59, ["Neon"] = 5.14, ["Neon|Ride"] = 58.11, ["Mega"] = 47.25, ["Mega|Fly"] = 215.87, ["Mega|Ride"] = 115.4, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 21.59, ["Ride"] = 18.24, ["Fly|Ride"] = 40.68, ["Neon"] = 6.44, ["Neon|Fly"] = 77.73, ["Neon|Ride"] = 16.21, ["Neon|Fly|Ride"] = 84, ["Mega"] = 114.19, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 111.19, ["Mega|Fly|Ride"] = 274.17}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 16.21, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 323.91, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 183.75}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 19.29, ["Fly|Ride"] = 47.5, ["Neon"] = 6.46, ["Neon|Fly"] = 48.86, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 137.09, ["Mega|Fly"] = 420, ["Mega|Ride"] = 83.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 21.6, ["Fly|Ride"] = 64.75, ["Neon"] = 13.01, ["Neon|Fly"] = 32.1, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 49.66, ["Mega"] = 215.87, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 135.36, ["Mega|Fly|Ride"] = 248.25}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 114.45, ["Fly|Ride"] = 144.64, ["Neon"] = 101.47, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 323.8}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 6.35, ["Ride"] = 81.84, ["Neon"] = 93.92, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 41.58, ["Neon"] = 56.44, ["Neon|Ride"] = 115.49, ["Mega"] = 233.63, ["Mega|Ride"] = 259.04}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 6.56, ["Ride"] = 63, ["Fly|Ride"] = 104.99, ["Neon"] = 52.43, ["Neon|Ride"] = 75.92, ["Neon|Fly|Ride"] = 127.38, ["Mega"] = 225.68, ["Mega|Ride"] = 287.24, ["Mega|Fly|Ride"] = 446.92}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Mega"] = 15.75, ["Mega|Fly"] = 214.8, ["Mega|Ride"] = 129.57, ["Mega|Fly|Ride"] = 243.94}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 42.88}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.55, ["Fly"] = 23.63, ["Ride"] = 19.68, ["Fly|Ride"] = 47.25, ["Neon"] = 45.92, ["Neon|Fly"] = 187.7, ["Neon|Ride"] = 49.6, ["Neon|Fly|Ride"] = 124.13, ["Mega"] = 288.75, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 258.93}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 20.51, ["Neon"] = 5.2, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 27.56, ["Mega|Fly"] = 144.64, ["Mega|Ride"] = 64.78, ["Mega|Fly|Ride"] = 129.54}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.17, ["Neon"] = 5.69, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 74.43, ["Mega"] = 34.01, ["Mega|Ride"] = 59.17, ["Mega|Fly|Ride"] = 135.19}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.65, ["Ride"] = 15.27, ["Fly|Ride"] = 45.73, ["Neon"] = 9.55, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 161.93, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 161.91}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 56.14, ["Ride"] = 32.81, ["Fly|Ride"] = 112.88, ["Neon"] = 17.28, ["Neon|Ride"] = 208.14, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 133.42, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 259.04}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 18.25, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 161.93}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.18, ["Fly|Ride"] = 59.07, ["Neon"] = 5.25, ["Neon|Fly"] = 114.81, ["Neon|Ride"] = 17.81, ["Neon|Fly|Ride"] = 94.99, ["Mega"] = 38.69, ["Mega|Fly"] = 144.64, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 127.38}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.29, ["Fly|Ride"] = 35.94, ["Neon"] = 5.9, ["Neon|Fly"] = 92.02, ["Neon|Ride"] = 19.94, ["Neon|Fly|Ride"] = 62.79, ["Mega"] = 85.31, ["Mega|Fly"] = 144.64, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 129.93}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 4.18, ["Fly"] = 91.88, ["Ride"] = 40.69, ["Neon"] = 11.46, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 80.07, ["Mega|Ride"] = 152.92, ["Mega|Fly|Ride"] = 283.82}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 107.84, ["Neon|Fly|Ride"] = 157309.77, ["Mega"] = 15.18, ["Mega|Fly"] = 128.46, ["Mega|Ride"] = 48.57, ["Mega|Fly|Ride"] = 146.9}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 20.77, ["Fly|Ride"] = 51.19, ["Neon"] = 3.93, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 67.68, ["Mega"] = 19.15, ["Mega|Fly"] = 72.26, ["Mega|Ride"] = 38.48, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 32.99, ["Mega"] = 17.07, ["Mega|Ride"] = 114.82}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.1, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 420, ["Mega"] = 22.32, ["Mega|Ride"] = 206.15, ["Mega|Fly|Ride"] = 144.64}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 15.75, ["Fly|Ride"] = 69.56, ["Neon"] = 3.12, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 18.2, ["Neon|Fly|Ride"] = 48.89, ["Mega"] = 32.81, ["Mega|Ride"] = 32.4, ["Mega|Fly|Ride"] = 107.66}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.48, ["Ride"] = 78.75, ["Fly|Ride"] = 215.87, ["Neon"] = 79.28, ["Neon|Ride"] = 78.75, ["Mega"] = 362.69, ["Mega|Ride"] = 483.71, ["Mega|Fly|Ride"] = 589.31}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 46.43, ["Neon"] = 43.32, ["Neon|Ride"] = 157.5, ["Mega"] = 244.26, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 32.99, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 274.24, ["Mega"] = 230.35, ["Mega|Ride"] = 235.1, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 14.96, ["Ride"] = 13.1, ["Fly|Ride"] = 26.24, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 11.57, ["Neon|Fly|Ride"] = 40.34, ["Mega"] = 14.14, ["Mega|Fly"] = 22.95, ["Mega|Ride"] = 22.56, ["Mega|Fly|Ride"] = 54.55}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 60.45, ["Neon"] = 10.4, ["Neon|Fly"] = 69.09, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 720.13, ["Mega"] = 123.05, ["Mega|Ride"] = 144.64}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.42, ["Mega|Fly"] = 144.64, ["Mega|Fly|Ride"] = 188.89}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 2.97, ["Neon|Ride"] = 127.32, ["Mega"] = 25.99, ["Mega|Fly"] = 215.87, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 144.56, ["Ride"] = 20.01, ["Fly|Ride"] = 46.65, ["Neon"] = 6.42, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 33.49, ["Neon|Fly|Ride"] = 80.71, ["Mega"] = 167.9, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 244.2}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 214.15, ["Ride"] = 236.25, ["Fly|Ride"] = 814.08, ["Neon|Ride"] = 928.25, ["Neon|Fly|Ride"] = 951.42, ["Mega"] = 8637.36, ["Mega|Fly|Ride"] = 3290.7}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 7.55, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.68, ["Ride"] = 24.95, ["Fly|Ride"] = 65.63, ["Neon"] = 28.07, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 172.75, ["Mega"] = 387.21, ["Mega|Ride"] = 277.25, ["Mega|Fly|Ride"] = 343.33}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 14, ["Fly|Ride"] = 32.81, ["Neon"] = 4.03, ["Neon|Fly"] = 33.47, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 58.29, ["Mega"] = 49.77, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 84.2, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 72.35, ["Ride"] = 19.69, ["Fly|Ride"] = 131.33, ["Neon"] = 8.65, ["Neon|Ride"] = 72.34, ["Mega"] = 85.2, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 3.83, ["Fly"] = 27.67, ["Ride"] = 16.12, ["Fly|Ride"] = 41.58, ["Neon"] = 31.49, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 7.24, ["Ride"] = 34.56, ["Fly|Ride"] = 117.26, ["Neon"] = 51.19, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 244.62, ["Mega|Ride"] = 318.41, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.74, ["Fly|Ride"] = 34.13, ["Neon"] = 32.82, ["Neon|Fly"] = 95.28, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 262.5, ["Mega|Ride"] = 374.54, ["Mega|Fly|Ride"] = 327.92}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 76.13, ["Ride"] = 94.5, ["Fly|Ride"] = 149.41, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 372.44, ["Neon|Fly|Ride"] = 365.97, ["Mega"] = 2016.12, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 431.86, ["Ride"] = 210, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 1140.57, ["Neon|Fly|Ride"] = 1296.49, ["Mega|Fly|Ride"] = 5037.04}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.47, ["Fly"] = 109.51, ["Ride"] = 63.38, ["Fly|Ride"] = 104.99, ["Neon"] = 488.48, ["Neon|Fly"] = 365.9, ["Neon|Ride"] = 296.83, ["Neon|Fly|Ride"] = 323.8, ["Mega|Ride"] = 1295.16, ["Mega|Fly|Ride"] = 1871.5}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 3.94, ["Fly"] = 288.3, ["Ride"] = 23.63, ["Neon"] = 16.59, ["Neon|Fly"] = 101.2, ["Neon|Ride"] = 99.31, ["Neon|Fly|Ride"] = 472.07, ["Mega"] = 238.88, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 9.79, ["Ride"] = 30.05, ["Fly|Ride"] = 65.63, ["Neon"] = 65.61, ["Neon|Ride"] = 93.92, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 313.59, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 17.31, ["Fly|Ride"] = 50.74, ["Neon"] = 6.49, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 20.15, ["Neon|Fly|Ride"] = 60.68, ["Mega"] = 36.66, ["Mega|Fly"] = 149.03, ["Mega|Ride"] = 80.88, ["Mega|Fly|Ride"] = 554.43}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 7.41, ["Fly"] = 69.09, ["Ride"] = 32.78, ["Fly|Ride"] = 81.2, ["Neon"] = 104.73, ["Neon|Fly"] = 288.18, ["Neon|Ride"] = 114.42, ["Neon|Fly|Ride"] = 273.8, ["Mega"] = 518.07, ["Mega|Ride"] = 554.49, ["Mega|Fly|Ride"] = 534.27}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.19, ["Fly|Ride"] = 45.93, ["Neon"] = 18.27, ["Neon|Fly"] = 51.82, ["Neon|Ride"] = 28.11, ["Neon|Fly|Ride"] = 88.41, ["Mega"] = 144.22, ["Mega|Ride"] = 103.69, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 4.85, ["Fly"] = 38.87, ["Ride"] = 20.33, ["Fly|Ride"] = 328.13, ["Neon"] = 22.98, ["Neon|Ride"] = 114.82, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 230.98, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 14.95, ["Mega|Ride"] = 43.19, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.82, ["Ride"] = 18.94, ["Fly|Ride"] = 44.63, ["Neon"] = 13.12, ["Neon|Fly"] = 107.99, ["Neon|Ride"] = 36.67, ["Neon|Fly|Ride"] = 146.55, ["Mega"] = 78.72, ["Mega|Ride"] = 106.86, ["Mega|Fly|Ride"] = 144.64}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 60.38, ["Ride"] = 22.28, ["Fly|Ride"] = 74.87, ["Neon"] = 22.74, ["Neon|Ride"] = 47.25, ["Mega"] = 144.38, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 267.68}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 106.32, ["Fly"] = 179.18, ["Ride"] = 144.38, ["Fly|Ride"] = 196.88, ["Neon"] = 430.39, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 578.22, ["Mega"] = 2442.74, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.83, ["Ride"] = 240.7, ["Fly|Ride"] = 131.25, ["Neon"] = 24.94, ["Neon|Ride"] = 98.42, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 265.47, ["Mega|Ride"] = 284.82, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Fly"] = 44.24, ["Ride"] = 17.07, ["Fly|Ride"] = 58.3, ["Neon"] = 14.77, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 126.07, ["Mega"] = 223.13, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.07, ["Ride"] = 39.38, ["Fly|Ride"] = 163.89, ["Neon"] = 99.29, ["Neon|Ride"] = 161.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 508.83, ["Mega|Fly"] = 863.75, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 806.1}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 9.19}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 95.82, ["Fly|Ride"] = 128.46, ["Neon"] = 39.38, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 485.63, ["Mega|Ride"] = 598.5, ["Mega|Fly|Ride"] = 863.44}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 23.37, ["Fly"] = 28.34, ["Ride"] = 29.38, ["Fly|Ride"] = 57.75, ["Neon"] = 90.57, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 141.68, ["Neon|Fly|Ride"] = 150.9, ["Mega"] = 1393.81, ["Mega|Fly|Ride"] = 646.5}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.84, ["Neon|Ride"] = 44.6, ["Neon|Fly|Ride"] = 41.5, ["Mega"] = 27.17, ["Mega|Fly"] = 189, ["Mega|Ride"] = 70.73, ["Mega|Fly|Ride"] = 230.35}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 2.56, ["Fly"] = 26.21, ["Ride"] = 21.25, ["Fly|Ride"] = 65.54, ["Neon"] = 64.78, ["Mega"] = 288.18, ["Mega|Fly"] = 407.94, ["Mega|Ride"] = 325.97, ["Mega|Fly|Ride"] = 518.07}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 18.53, ["Fly|Ride"] = 32.89, ["Neon"] = 7.88, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 64.78, ["Mega"] = 183.75, ["Mega|Ride"] = 188.09, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 80.97, ["Neon"] = 2.1, ["Neon|Fly"] = 274.17, ["Neon|Ride"] = 29.16, ["Mega"] = 62.37, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 228.44}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.63, ["Fly"] = 91.88, ["Ride"] = 94.99, ["Fly|Ride"] = 99.74, ["Neon"] = 144.64, ["Neon|Ride"] = 242.86, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 835.24, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 43.19, ["Fly|Ride"] = 210, ["Neon"] = 79.9, ["Neon|Ride"] = 42.77, ["Mega|Ride"] = 323.8}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 3.9, ["Fly"] = 24.84, ["Ride"] = 22.02, ["Fly|Ride"] = 58.64, ["Neon"] = 11.46, ["Neon|Fly"] = 86.36, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 91.64, ["Mega"] = 200.17, ["Mega|Ride"] = 150.55, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 63.67, ["Fly"] = 145.01, ["Ride"] = 127.38, ["Neon"] = 319.49, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4561.01, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 3830.06}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 5.97, ["Fly"] = 46.4, ["Ride"] = 24.94, ["Fly|Ride"] = 54.99, ["Neon"] = 33.71, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 122.73, ["Mega"] = 252.95, ["Mega|Ride"] = 222.95, ["Mega|Fly|Ride"] = 322.73}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 70.86, ["Fly"] = 131.24, ["Ride"] = 118.11, ["Fly|Ride"] = 209.99, ["Neon"] = 245.01, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 360.28, ["Mega"] = 1019.82, ["Mega|Ride"] = 1075.99, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 17.71, ["Ride"] = 45.94, ["Fly|Ride"] = 167.31, ["Neon"] = 78.74, ["Neon|Ride"] = 94.97, ["Neon|Fly|Ride"] = 214.8, ["Mega"] = 346.03, ["Mega|Ride"] = 345.75, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 7.88, ["Fly"] = 39.38, ["Ride"] = 25.89, ["Fly|Ride"] = 72.43, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 570.29, ["Mega|Ride"] = 574.2, ["Mega|Fly|Ride"] = 633.77}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 15.75, ["Ride"] = 48.57, ["Fly|Ride"] = 102.92, ["Neon"] = 61.1, ["Neon|Ride"] = 129.5, ["Neon|Fly|Ride"] = 254.04, ["Mega"] = 288.15, ["Mega|Fly"] = 525.63, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 399.28}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.54, ["Ride"] = 30.18, ["Fly|Ride"] = 64.78, ["Neon"] = 38.68, ["Neon|Ride"] = 72.07, ["Neon|Fly|Ride"] = 139.2, ["Mega"] = 265.02, ["Mega|Ride"] = 346.5, ["Mega|Fly|Ride"] = 442.56}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 101.47, ["Neon|Ride"] = 86.36, ["Mega"] = 19.4, ["Mega|Ride"] = 144.64}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 4.51, ["Ride"] = 31.49, ["Fly|Ride"] = 325.9, ["Neon"] = 40.31, ["Neon|Ride"] = 207.24, ["Mega"] = 237.44, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 733.92}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 128.5, ["Ride"] = 29.16, ["Neon"] = 26.22, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 212.62, ["Mega|Ride"] = 418.79, ["Mega|Fly|Ride"] = 312.38}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.5, ["Ride"] = 32.8, ["Neon"] = 15.88, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 144.64, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 517.13}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 496.65, ["Ride"] = 557.81, ["Fly|Ride"] = 568.32, ["Neon"] = 1856.55, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1443.75, ["Mega|Fly|Ride"] = 5932.5}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.5, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 59.87, ["Neon"] = 42.14, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 331.53, ["Mega"] = 201.85, ["Mega|Ride"] = 374.96, ["Mega|Fly|Ride"] = 358.34}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 7.88, ["Fly"] = 61.73, ["Ride"] = 19.46, ["Fly|Ride"] = 51.39, ["Neon"] = 90.68, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 331.87, ["Mega|Ride"] = 245.01, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Fly"] = 24.93, ["Ride"] = 17.07, ["Fly|Ride"] = 50.79, ["Neon"] = 16.45, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 259.04}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23, ["Fly|Ride"] = 90.57, ["Neon"] = 7.65, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 75.9, ["Mega|Ride"] = 120.85, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 24.05, ["Neon"] = 3.63, ["Neon|Ride"] = 32, ["Neon|Fly|Ride"] = 129.5, ["Mega"] = 23.62, ["Mega|Ride"] = 79.86, ["Mega|Fly|Ride"] = 230.98}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.12}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 8.94, ["Ride"] = 43.19, ["Fly|Ride"] = 129.5, ["Neon"] = 70.26, ["Neon|Ride"] = 107.49, ["Neon|Fly|Ride"] = 360.26, ["Mega"] = 427.42, ["Mega|Ride"] = 360.3, ["Mega|Fly|Ride"] = 408.19}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.13, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 1008.07, ["Mega"] = 39.38, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 3.81, ["Fly"] = 331.78, ["Ride"] = 91.88, ["Fly|Ride"] = 431.86, ["Neon"] = 59.05, ["Neon|Ride"] = 170.52, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 261.37, ["Mega|Fly"] = 538.58, ["Mega|Ride"] = 356.19, ["Mega|Fly|Ride"] = 488.48}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 398.77, ["Ride"] = 446.24, ["Fly|Ride"] = 525, ["Neon"] = 1685.42, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1365, ["Mega"] = 8094.66, ["Mega|Fly|Ride"] = 6298.69}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 7.39, ["Fly"] = 196.88, ["Ride"] = 31.5, ["Fly|Ride"] = 129.52, ["Neon"] = 72.27, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 195.4, ["Mega"] = 306.57, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 518.25}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 95.28, ["Ride"] = 35.26, ["Fly|Ride"] = 118.12, ["Neon"] = 3.61, ["Neon|Ride"] = 35.58, ["Neon|Fly|Ride"] = 86.36, ["Mega"] = 37.96, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 3.9, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 29.39, ["Mega|Ride"] = 58.28, ["Mega|Fly|Ride"] = 242.82}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 29.56, ["Fly"] = 29.14, ["Ride"] = 92.84, ["Fly|Ride"] = 172.71, ["Neon"] = 129.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 432.48, ["Mega"] = 705.87, ["Mega|Ride"] = 590.26, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 12.05, ["Neon"] = 95.82, ["Neon|Ride"] = 271, ["Neon|Fly|Ride"] = 863.71, ["Mega"] = 570.29, ["Mega|Ride"] = 499.42, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 4.29, ["Ride"] = 76.13, ["Fly|Ride"] = 221.33, ["Neon"] = 101.07, ["Neon|Ride"] = 172.71, ["Mega"] = 662.7, ["Mega|Ride"] = 638.96, ["Mega|Fly|Ride"] = 1268.67}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 14.3, ["Ride"] = 56.36, ["Fly|Ride"] = 217.9, ["Neon"] = 131.25, ["Neon|Ride"] = 163.7, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 652.11, ["Mega|Ride"] = 792.22, ["Mega|Fly|Ride"] = 635.1}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.49, ["Ride"] = 431.81, ["Fly|Ride"] = 786.54, ["Neon"] = 1069.69, ["Neon|Ride"] = 1295.16, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.29, ["Ride"] = 60.27, ["Fly|Ride"] = 139.71, ["Neon"] = 148.32, ["Neon|Ride"] = 194.25, ["Neon|Fly|Ride"] = 145.4, ["Mega|Fly"] = 590.63, ["Mega|Ride"] = 562.42, ["Mega|Fly|Ride"] = 863.44}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.15, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 65.97, ["Neon|Ride"] = 144.64, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 38.98, ["Ride"] = 141.04, ["Fly|Ride"] = 307.13, ["Neon"] = 178.5, ["Neon|Ride"] = 200.76, ["Neon|Fly|Ride"] = 539.6, ["Mega"] = 384.56, ["Mega|Ride"] = 473.81, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.63, ["Ride"] = 31.5, ["Fly|Ride"] = 215.94, ["Neon"] = 7.42, ["Neon|Fly"] = 84.3, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 279.55, ["Mega"] = 76.13, ["Mega|Ride"] = 172.71, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 48.57, ["Ride"] = 92, ["Neon"] = 262.42, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1648.56, ["Mega|Ride"] = 2858.98, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 106.86, ["Ride"] = 28.25, ["Neon"] = 9.05, ["Neon|Fly"] = 187.81, ["Neon|Ride"] = 36.67, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 68.55, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 194.25}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 48.85, ["Fly|Ride"] = 100.16, ["Neon"] = 3.77, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 37.79, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 32.81, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 70.6, ["Mega|Fly|Ride"] = 288.18}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 37.97, ["Fly|Ride"] = 130.7, ["Neon"] = 11.32, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 163.68, ["Mega"] = 84, ["Mega|Ride"] = 116.59, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 56.44, ["Ride"] = 63.49, ["Fly|Ride"] = 149.03, ["Neon"] = 288.15, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 509.44, ["Mega|Ride"] = 1151.61, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 9.79, ["Ride"] = 36.09, ["Neon"] = 20.61, ["Neon|Fly"] = 350.44, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 262.5, ["Mega|Ride"] = 196.88}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 22.31, ["Fly|Ride"] = 78.75, ["Neon"] = 7.16, ["Neon|Ride"] = 72.32, ["Mega"] = 52.5, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 107.94, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 163.66, ["Mega"] = 339.8, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 3.83, ["Fly"] = 78.75, ["Ride"] = 47.25, ["Fly|Ride"] = 101.07, ["Neon"] = 19.29, ["Neon|Ride"] = 69.9, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 189, ["Mega|Ride"] = 209.44, ["Mega|Fly|Ride"] = 360.05}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 5.92, ["Neon|Ride"] = 93.92, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 78.66, ["Mega|Fly|Ride"] = 309.77}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 22.32, ["Fly|Ride"] = 61.6, ["Neon"] = 4.19, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 95.43, ["Mega"] = 40.68, ["Mega|Ride"] = 105.04, ["Mega|Fly|Ride"] = 235.99}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.63, ["Fly"] = 27.5, ["Ride"] = 20.51, ["Fly|Ride"] = 57.74, ["Neon"] = 18.09, ["Neon|Fly"] = 102.59, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 163.68, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 243.48}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 24.72, ["Fly"] = 72.33, ["Ride"] = 28.79, ["Fly|Ride"] = 80.97, ["Neon"] = 140.75, ["Neon|Ride"] = 244.28, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 459.38, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 646.75}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 58.3, ["Ride"] = 90.56, ["Fly|Ride"] = 139.13, ["Neon"] = 363.72, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 288.18, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2144.57, ["Mega|Ride"] = 1942.74, ["Mega|Fly|Ride"] = 1515.32}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.5, ["Fly|Ride"] = 144.38, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 35.44, ["Neon|Fly|Ride"] = 144.68, ["Mega"] = 33.3, ["Mega|Fly"] = 672, ["Mega|Ride"] = 92.85, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.31, ["Ride"] = 15.65, ["Fly|Ride"] = 42.95, ["Neon"] = 4.08, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.63, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 39.38, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 8.56, ["Fly"] = 43.19, ["Ride"] = 38.03, ["Fly|Ride"] = 65.63, ["Neon"] = 40.68, ["Neon|Ride"] = 48.86, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 547.21, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.73, ["Ride"] = 496.49, ["Fly|Ride"] = 577.5, ["Neon"] = 4318.51, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 20.69, ["Fly"] = 99.75, ["Ride"] = 53.81, ["Fly|Ride"] = 130.23, ["Neon"] = 150.94, ["Neon|Ride"] = 228.92, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 720.57, ["Mega|Ride"] = 840, ["Mega|Fly|Ride"] = 888.27}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.76, ["Fly|Ride"] = 91.87, ["Neon"] = 7.55, ["Neon|Ride"] = 49.41, ["Neon|Fly|Ride"] = 65.54, ["Mega"] = 86.36, ["Mega|Ride"] = 127.34, ["Mega|Fly|Ride"] = 318.41}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 86.46, ["Ride"] = 61.13, ["Fly|Ride"] = 261.97, ["Neon"] = 72.33, ["Mega"] = 150.94}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 38.17, ["Fly"] = 169.31, ["Ride"] = 37.7, ["Fly|Ride"] = 78.75, ["Neon"] = 190.38, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 261.37, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.94, ["Ride"] = 128.63, ["Fly|Ride"] = 175.51, ["Neon"] = 378.86, ["Neon|Fly"] = 820.28, ["Neon|Ride"] = 488.54, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3167.63, ["Mega|Fly|Ride"] = 6478.03}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 219.19, ["Ride"] = 295.32, ["Fly|Ride"] = 538.58, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.49, ["Ride"] = 39.37, ["Fly|Ride"] = 201.85, ["Neon"] = 99.75, ["Neon|Ride"] = 88.49, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 871.77, ["Mega|Ride"] = 389.12, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 16.42, ["Fly|Ride"] = 38.75, ["Neon"] = 6.97, ["Neon|Ride"] = 26.78, ["Neon|Fly|Ride"] = 61.34, ["Mega"] = 99.31, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 6.42, ["Fly"] = 47.25, ["Ride"] = 21.4, ["Fly|Ride"] = 63, ["Neon"] = 34.56, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 97.11, ["Mega"] = 274.17, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 321.64}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 315, ["Ride"] = 374.06, ["Fly|Ride"] = 761.99, ["Neon"] = 1470.67, ["Neon|Ride"] = 1709.86, ["Neon|Fly|Ride"] = 2116.5, ["Mega"] = 10796.23, ["Mega|Fly|Ride"] = 6037.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Neon"] = 10.5, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 26.88, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 442.65}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.83, ["Ride"] = 15.75, ["Fly|Ride"] = 40.58, ["Neon"] = 23.92, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 79.47, ["Mega"] = 213.71, ["Mega|Ride"] = 144.61, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 12.75, ["Fly"] = 6562.5, ["Ride"] = 57.29, ["Neon"] = 105, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 551.25, ["Mega|Ride"] = 568.8, ["Mega|Fly|Ride"] = 719.9}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 119.33, ["Fly"] = 157.5, ["Ride"] = 144.64, ["Fly|Ride"] = 165.37, ["Neon|Ride"] = 814.52, ["Neon|Fly|Ride"] = 719.9, ["Mega|Fly|Ride"] = 2920.32}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 14.96, ["Fly"] = 26.25, ["Ride"] = 27.56, ["Fly|Ride"] = 56.44, ["Neon"] = 105, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 147, ["Mega"] = 439.56, ["Mega|Ride"] = 381.42, ["Mega|Fly|Ride"] = 475.89}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 35.95, ["Neon"] = 3.94, ["Neon|Ride"] = 76.65, ["Mega"] = 25.16, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 17.07, ["Fly|Ride"] = 86.16, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 23.44, ["Mega|Fly"] = 93.92, ["Mega|Ride"] = 46.43, ["Mega|Fly|Ride"] = 144.64}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 14.27, ["Fly"] = 103.28, ["Ride"] = 90.57, ["Fly|Ride"] = 260.08, ["Neon"] = 37.66, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 165.38, ["Mega|Ride"] = 212.4, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.24, ["Fly"] = 1524.22, ["Ride"] = 1179.94, ["Fly|Ride"] = 1344.03, ["Neon"] = 3281.25, ["Neon|Ride"] = 4317.16, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 452.82, ["Ride"] = 503.99, ["Fly|Ride"] = 544.69, ["Neon"] = 1680, ["Neon|Ride"] = 1942.74, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 6313.84}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 301.88, ["Fly"] = 395.04, ["Ride"] = 350.44, ["Fly|Ride"] = 426.56, ["Neon"] = 759.94, ["Neon|Fly"] = 1140.74, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 727.13, ["Mega|Ride"] = 3453.74, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 220.5, ["Fly"] = 288.75, ["Ride"] = 286.13, ["Fly|Ride"] = 360.45, ["Neon"] = 653.63, ["Neon|Ride"] = 682.5, ["Neon|Fly|Ride"] = 643.13, ["Mega|Fly|Ride"] = 3378.18}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 41.68, ["Ride"] = 17.07, ["Fly|Ride"] = 46.91, ["Neon"] = 4.9, ["Neon|Ride"] = 34.51, ["Neon|Fly|Ride"] = 105, ["Mega"] = 64.78, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 267.75, ["Fly"] = 1439.79, ["Ride"] = 315, ["Fly|Ride"] = 389.82, ["Neon"] = 1312.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1371.54, ["Mega"] = 21881.63, ["Mega|Ride"] = 5468.76, ["Mega|Fly|Ride"] = 4738.13}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.45, ["Fly"] = 157.5, ["Ride"] = 52.49, ["Neon"] = 27.28, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 213.67, ["Mega|Ride"] = 343.04, ["Mega|Fly|Ride"] = 749.04}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 22.98, ["Ride"] = 16.47, ["Fly|Ride"] = 39.38, ["Neon"] = 6.42, ["Neon|Ride"] = 53.99, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 128.46, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 131.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93, ["Mega"] = 21.87, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.47, ["Ride"] = 131.25, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8141.41, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 18.57, ["Neon|Ride"] = 64.32, ["Mega"] = 358.34, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 42.11, ["Neon"] = 2.45, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.16, ["Mega|Ride"] = 163.32, ["Mega|Fly|Ride"] = 101.46}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 6.04, ["Fly"] = 86.25, ["Ride"] = 41.41, ["Fly|Ride"] = 91.88, ["Neon"] = 32.82, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 76.65, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 192.05, ["Mega|Ride"] = 196.86, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 2.97, ["Fly"] = 32.43, ["Ride"] = 18.37, ["Fly|Ride"] = 48.9, ["Neon"] = 27.57, ["Neon|Fly"] = 146.57, ["Neon|Ride"] = 141.45, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 251.07, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.11, ["Ride"] = 38.07, ["Fly|Ride"] = 146.55, ["Neon"] = 28.4, ["Neon|Ride"] = 172.71, ["Neon|Fly|Ride"] = 326.1, ["Mega"] = 524.99, ["Mega|Ride"] = 561.84}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.52, ["Fly"] = 6514.74, ["Ride"] = 22.32, ["Fly|Ride"] = 190.32, ["Neon"] = 64.97, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 732.71, ["Mega"] = 367.5, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 552.61}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 70.6, ["Ride"] = 15.86, ["Fly|Ride"] = 42.08, ["Neon"] = 3.76, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.66, ["Neon|Fly|Ride"] = 32.4, ["Mega"] = 46.36, ["Mega|Fly|Ride"] = 227.17}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 190.98, ["Fly"] = 238.54, ["Ride"] = 190.19, ["Fly|Ride"] = 196.88, ["Neon"] = 978.93, ["Neon|Ride"] = 1022.1, ["Neon|Fly|Ride"] = 1396.36, ["Mega"] = 8637.36, ["Mega|Fly|Ride"] = 3598.69}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.27, ["Fly|Ride"] = 36.88, ["Neon"] = 2.1, ["Neon|Fly"] = 36.65, ["Neon|Ride"] = 28.07, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 52.5, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 10.48, ["Ride"] = 71.25, ["Fly|Ride"] = 230.98, ["Neon"] = 48.57, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 759.87, ["Mega"] = 326.1, ["Mega|Ride"] = 306.48, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.91, ["Ride"] = 94.97, ["Fly|Ride"] = 183.75, ["Neon"] = 216.44, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 760.62, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 199.49, ["Fly"] = 274.36, ["Ride"] = 236.25, ["Fly|Ride"] = 341.07, ["Neon"] = 849.41, ["Neon|Ride"] = 711.38, ["Neon|Fly|Ride"] = 732.12, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.01, ["Fly"] = 130.68, ["Ride"] = 163.68, ["Neon"] = 141.38, ["Neon|Ride"] = 182.06, ["Neon|Fly|Ride"] = 431.72, ["Mega"] = 265.11, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 403.67}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.44, ["Ride"] = 58.19, ["Fly|Ride"] = 147.9, ["Neon"] = 161.32, ["Neon|Fly"] = 163.66, ["Neon|Ride"] = 201.85, ["Mega"] = 1726.88, ["Mega|Ride"] = 1439.79, ["Mega|Fly|Ride"] = 716.51}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 950.15, ["Fly"] = 1134.35, ["Ride"] = 1048.69, ["Fly|Ride"] = 1023.75, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 3740.63, ["Mega|Fly|Ride"] = 17267.54}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 7.88, ["Fly"] = 27.72, ["Ride"] = 18.88, ["Fly|Ride"] = 45.93, ["Neon"] = 47.25, ["Neon|Fly"] = 68.58, ["Neon|Ride"] = 62.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 244.26, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.56, ["Fly"] = 78.75, ["Ride"] = 44.61, ["Fly|Ride"] = 135.19, ["Neon"] = 27.91, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 326.12, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 85.5, ["Ride"] = 23.73, ["Fly|Ride"] = 79.9, ["Neon"] = 11.46, ["Neon|Ride"] = 47.64, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 81.23, ["Mega|Ride"] = 360.51, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 11.45, ["Ride"] = 35.33, ["Fly|Ride"] = 124.83, ["Neon"] = 65.61, ["Neon|Fly"] = 187.81, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 253.94, ["Mega"] = 446.24, ["Mega|Ride"] = 421.32, ["Mega|Fly|Ride"] = 434.51}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.41, ["Ride"] = 17.07, ["Fly|Ride"] = 43.32, ["Neon"] = 14.96, ["Neon|Fly"] = 41.03, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 72.28, ["Mega"] = 192.27, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 175.3}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 15.62, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 36.71, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 144.27, ["Mega|Ride"] = 227.06, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.04, ["Ride"] = 262.5, ["Fly|Ride"] = 431.86, ["Neon"] = 935.76, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3419.75}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 32.81, ["Ride"] = 27.56, ["Fly|Ride"] = 105.59, ["Neon"] = 7.87, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 73.5, ["Mega|Ride"] = 127.37, ["Mega|Fly|Ride"] = 334.61}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.97, ["Ride"] = 144.64, ["Fly|Ride"] = 88.86, ["Neon"] = 18.22, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 345.39}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 34.92, ["Neon"] = 9.98, ["Neon|Ride"] = 50.42, ["Neon|Fly|Ride"] = 103.63, ["Mega"] = 62.9, ["Mega|Ride"] = 120.65, ["Mega|Fly|Ride"] = 504.05}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 78.75, ["Ride"] = 130.94, ["Fly|Ride"] = 249.38, ["Neon"] = 360.51, ["Neon|Ride"] = 457.76, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 1454.9, ["Mega|Ride"] = 1508.87, ["Mega|Fly|Ride"] = 1553.11}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 20.41, ["Fly"] = 89.87, ["Ride"] = 58.3, ["Fly|Ride"] = 274.17, ["Neon"] = 127.29, ["Neon|Ride"] = 431.45, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 679.97, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 17.55, ["Fly"] = 242.97, ["Ride"] = 32.82, ["Fly|Ride"] = 114.42, ["Neon"] = 82.43, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 187.81, ["Mega"] = 610.67, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 576.99}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 41.35, ["Neon"] = 20.99, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 140.14, ["Mega|Fly|Ride"] = 489.57}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 42, ["Fly"] = 57.75, ["Ride"] = 75.28, ["Fly|Ride"] = 107.92, ["Neon"] = 318.94, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 229.68, ["Neon|Fly|Ride"] = 163.64, ["Mega|Fly|Ride"] = 1151.07}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 216.09, ["Neon"] = 6.05, ["Neon|Fly|Ride"] = 128.5, ["Mega"] = 91.88, ["Mega|Ride"] = 287.11, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 15.92, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 69.57, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 203.44, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 376.18, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 49.84, ["Fly"] = 203.41, ["Ride"] = 82.32, ["Fly|Ride"] = 107.92, ["Neon"] = 262.5, ["Neon|Fly"] = 431.72, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 328.13, ["Mega|Ride"] = 1476.48, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.74, ["Ride"] = 16.1, ["Fly|Ride"] = 25.99, ["Neon"] = 2.1, ["Neon|Fly"] = 28.07, ["Neon|Ride"] = 15.33, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 19.36, ["Mega|Ride"] = 40.95, ["Mega|Fly|Ride"] = 74.33}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.41, ["Fly"] = 105, ["Ride"] = 27.57, ["Fly|Ride"] = 64.97, ["Neon"] = 19.67, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 168, ["Mega"] = 161.44, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 378.62}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 9.18, ["Ride"] = 41.91, ["Fly|Ride"] = 118.13, ["Neon"] = 116.81, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 270.27, ["Mega"] = 705.87, ["Mega|Ride"] = 432.04, ["Mega|Fly|Ride"] = 586.26}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 21.38, ["Neon"] = 2.1, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 19.25, ["Mega|Ride"] = 53.99, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 31.5, ["Fly"] = 210, ["Ride"] = 65.63, ["Fly|Ride"] = 245.01, ["Neon"] = 170.39, ["Neon|Ride"] = 172.67, ["Neon|Fly|Ride"] = 417.14, ["Mega"] = 715.59, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 667.88, ["Mega|Fly|Ride"] = 748.89}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.06, ["Fly"] = 43.19, ["Ride"] = 26.48, ["Fly|Ride"] = 94.99, ["Neon"] = 376.69, ["Neon|Ride"] = 123.05, ["Neon|Fly|Ride"] = 166.23, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 3.84, ["Ride"] = 61.07, ["Neon"] = 32.82, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.79, ["Neon|Fly|Ride"] = 214.8, ["Mega"] = 246.75, ["Mega|Ride"] = 351.79, ["Mega|Fly|Ride"] = 488.54}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 9.09, ["Fly"] = 72.33, ["Ride"] = 68.16, ["Fly|Ride"] = 249.61, ["Neon"] = 43.24, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.86, ["Mega"] = 259.88, ["Mega|Ride"] = 302.22, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.63, ["Ride"] = 36.71, ["Fly|Ride"] = 196.88, ["Neon"] = 8.55, ["Neon|Fly"] = 210, ["Neon|Ride"] = 39.38, ["Mega"] = 69.57, ["Mega|Fly"] = 215.87, ["Mega|Ride"] = 101.47, ["Mega|Fly|Ride"] = 288.18}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 32.96, ["Neon|Fly|Ride"] = 163.66, ["Mega"] = 78.75, ["Mega|Ride"] = 144.64, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 16.42}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42.86, ["Fly"] = 78.75, ["Ride"] = 72.19, ["Fly|Ride"] = 91.88, ["Neon"] = 191.97, ["Neon|Ride"] = 215.87, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 888.56}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Fly|Ride"] = 107.94, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 23.63, ["Mega|Ride"] = 172.71, ["Mega|Fly|Ride"] = 323.8}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 498.74, ["Ride"] = 525, ["Fly|Ride"] = 561.24, ["Neon"] = 4318.69, ["Neon|Ride"] = 2698.24, ["Neon|Fly|Ride"] = 3885.46, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 7.88, ["Fly"] = 49.38, ["Ride"] = 34.13, ["Fly|Ride"] = 58.27, ["Neon"] = 72.23, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 115.49, ["Mega"] = 326.06, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 633.56}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.63, ["Fly"] = 28.59, ["Ride"] = 23.62, ["Fly|Ride"] = 48.57, ["Neon"] = 21.57, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 163.66, ["Mega|Fly"] = 187.81, ["Mega|Ride"] = 154.25, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 7.9, ["Ride"] = 43.19, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 525.63, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 576.35}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 43.2, ["Ride"] = 38.57, ["Fly|Ride"] = 72.33, ["Neon"] = 43.56, ["Neon|Fly"] = 72.33, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 287.11, ["Mega|Fly|Ride"] = 504.23}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 9, ["Ride"] = 31.5, ["Fly|Ride"] = 196.88, ["Neon"] = 101.66, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 142.48, ["Mega"] = 534.27, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 532.09}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 4.85, ["Ride"] = 37.68, ["Fly|Ride"] = 101.47, ["Neon"] = 32.13, ["Neon|Fly"] = 105, ["Neon|Ride"] = 97.37, ["Neon|Fly|Ride"] = 278.49, ["Mega"] = 229.69, ["Mega|Ride"] = 310.24, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 47.64, ["Ride"] = 13.81, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 15.59, ["Mega|Ride"] = 31.28, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 3.98, ["Fly"] = 26.25, ["Ride"] = 30.19, ["Fly|Ride"] = 107.98, ["Neon"] = 52.54, ["Neon|Fly"] = 122.16, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.18, ["Mega|Ride"] = 215.87, ["Mega|Fly|Ride"] = 416.73}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 252, ["Ride"] = 257.28, ["Fly|Ride"] = 488.24, ["Neon"] = 1270.18, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 1013.25, ["Mega"] = 4884.07, ["Mega|Ride"] = 9477.57, ["Mega|Fly|Ride"] = 4221.05}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.72, ["Ride"] = 104.97, ["Fly|Ride"] = 256.88, ["Neon"] = 458.07, ["Neon|Fly"] = 924.2, ["Neon|Ride"] = 420, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2303.94, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.04, ["Ride"] = 14.59, ["Fly|Ride"] = 32.82, ["Neon"] = 7.44, ["Neon|Fly"] = 101.5, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 49.66, ["Mega|Fly"] = 214.88, ["Mega|Ride"] = 113.11, ["Mega|Fly|Ride"] = 259.23}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 41.08, ["Ride"] = 14.31, ["Fly|Ride"] = 34.13, ["Neon"] = 7.21, ["Neon|Fly"] = 32.13, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 43.18, ["Mega"] = 63, ["Mega|Fly"] = 288.18, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 3.29, ["Fly"] = 101.5, ["Ride"] = 22.31, ["Fly|Ride"] = 98.44, ["Neon"] = 114.42, ["Neon|Ride"] = 42.77, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 436.94, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 209.99, ["Ride"] = 223.64, ["Fly|Ride"] = 346.5, ["Neon"] = 1187.24, ["Neon|Ride"] = 1139.75, ["Neon|Fly|Ride"] = 1060.77, ["Mega|Ride"] = 3776.45, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 32.97, ["Ride"] = 15.65, ["Fly|Ride"] = 48.86, ["Neon"] = 19.14, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 287.11}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 77.97, ["Fly|Ride"] = 196.88, ["Neon"] = 19.1, ["Neon|Ride"] = 110.13, ["Mega"] = 196.88, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 431.86}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 15.06, ["Neon|Ride"] = 43.19, ["Mega"] = 115.99}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 11.82, ["Fly"] = 58.11, ["Ride"] = 25.9, ["Fly|Ride"] = 55.3, ["Neon"] = 96.91, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 259.04, ["Mega"] = 367.5, ["Mega|Ride"] = 501.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 36.28, ["Ride"] = 87.61, ["Fly|Ride"] = 318.41, ["Neon"] = 111.57, ["Neon|Fly"] = 656.04, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 393.75, ["Mega|Fly"] = 2267.32, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 26.17, ["Fly"] = 43.19, ["Ride"] = 47.24, ["Fly|Ride"] = 99.45, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.93, ["Neon|Fly|Ride"] = 223.13, ["Mega"] = 863.71, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 15.82, ["Ride"] = 16.1, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 17.29, ["Neon|Fly|Ride"] = 45.91, ["Mega"] = 40.23, ["Mega|Fly"] = 43.19, ["Mega|Ride"] = 32.34, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 215.25, ["Ride"] = 236.25, ["Fly|Ride"] = 276.03, ["Neon"] = 3419.82, ["Neon|Ride"] = 1223.94, ["Neon|Fly|Ride"] = 1295.16, ["Mega|Fly|Ride"] = 5034.3}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 8.89, ["Fly"] = 101.19, ["Ride"] = 23.61, ["Fly|Ride"] = 102.88, ["Neon"] = 76.39, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 447.92, ["Mega"] = 363.18, ["Mega|Ride"] = 576.35, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 36.71, ["Ride"] = 18.79, ["Fly|Ride"] = 50.74, ["Neon"] = 5.71, ["Neon|Fly"] = 38.19, ["Neon|Ride"] = 29.16, ["Neon|Fly|Ride"] = 107.94, ["Mega"] = 45.94, ["Mega|Fly"] = 230.98, ["Mega|Ride"] = 85.29, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 18.41, ["Fly|Ride"] = 86.24, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 109.94, ["Mega"] = 26.14, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.1, ["Ride"] = 35.37, ["Fly|Ride"] = 144.64, ["Neon"] = 13.12, ["Neon|Fly"] = 732.83, ["Neon|Ride"] = 59.07, ["Mega"] = 155.54, ["Mega|Ride"] = 155.06, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 8.68, ["Fly"] = 47.23, ["Ride"] = 24.42, ["Fly|Ride"] = 59.07, ["Neon"] = 47.25, ["Neon|Fly"] = 245.01, ["Neon|Ride"] = 47.61, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 262.5, ["Mega|Ride"] = 318.41, ["Mega|Fly|Ride"] = 366.45}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.53, ["Ride"] = 32.81, ["Neon"] = 131.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 259.04, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 24.84, ["Neon"] = 3.83, ["Neon|Ride"] = 52.24, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 18.56, ["Mega|Ride"] = 93.92, ["Mega|Fly|Ride"] = 175.54}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.12, ["Fly"] = 83.99, ["Ride"] = 32.4, ["Fly|Ride"] = 144.64, ["Neon"] = 32.99, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 170.5, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 321.64, ["Mega|Fly|Ride"] = 360.51}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 2.6, ["Neon|Fly"] = 115.49, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 21.45, ["Mega|Ride"] = 121.98, ["Mega|Fly|Ride"] = 259.04}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 54.42, ["Ride"] = 17.06, ["Fly|Ride"] = 45.94, ["Neon"] = 3.73, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 130.7, ["Mega"] = 45.94, ["Mega|Ride"] = 131.14, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 629.99, ["Ride"] = 524.9, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3419.22, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 17.64, ["Ride"] = 15.48, ["Fly|Ride"] = 32.99, ["Neon"] = 19.91, ["Neon|Fly"] = 43.14, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 85.32}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 50.25, ["Neon"] = 7.87, ["Neon|Fly"] = 755.78, ["Neon|Ride"] = 54.27, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 80.07, ["Mega|Fly"] = 163.68, ["Mega|Ride"] = 129.52, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 7.88, ["Fly"] = 24.44, ["Ride"] = 22.72, ["Fly|Ride"] = 48.61, ["Neon"] = 31.49, ["Neon|Fly"] = 194.86, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 113.44, ["Mega"] = 485.63, ["Mega|Ride"] = 308.43, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 20.51, ["Ride"] = 14.44, ["Fly|Ride"] = 50.74, ["Neon"] = 9.09, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 22.09, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 61.95, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 174.86}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 40.48, ["Ride"] = 59.07, ["Neon"] = 200.67, ["Neon|Ride"] = 287.11, ["Mega"] = 965.97, ["Mega|Ride"] = 792.22, ["Mega|Fly|Ride"] = 712.35}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 91.88, ["Neon"] = 7.88, ["Neon|Fly"] = 139.22, ["Neon|Ride"] = 37.82, ["Neon|Fly|Ride"] = 108.89, ["Mega"] = 47.25, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 271.1}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.87, ["Fly"] = 32.82, ["Ride"] = 21.61, ["Fly|Ride"] = 82.19, ["Neon"] = 10.68, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 114.09, ["Mega|Ride"] = 107.94, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 43.2, ["Fly|Ride"] = 65.83, ["Neon"] = 11.82, ["Neon|Fly"] = 24.44, ["Neon|Fly|Ride"] = 107.94, ["Mega"] = 97.13, ["Mega|Ride"] = 161.93, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2392.15, ["Ride"] = 17.22, ["Fly|Ride"] = 69.45, ["Neon"] = 3.76, ["Neon|Fly"] = 72.24, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 42, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 75.66, ["Mega|Fly|Ride"] = 133.85}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 8.91, ["Fly"] = 21.39, ["Ride"] = 19.04, ["Fly|Ride"] = 43.18, ["Neon"] = 122.14, ["Neon|Ride"] = 97.72, ["Neon|Fly|Ride"] = 140.32, ["Mega|Ride"] = 538.61, ["Mega|Fly|Ride"] = 495.41}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 656.25, ["Fly"] = 1079.31, ["Ride"] = 774.38, ["Fly|Ride"] = 826.88, ["Neon"] = 1584.19, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 4855.73, ["Mega|Fly|Ride"] = 4383.75}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 17.54, ["Ride"] = 15.75, ["Fly|Ride"] = 47.25, ["Neon"] = 3.68, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 22.64, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 36.75, ["Mega|Ride"] = 68.25, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 5.84, ["Ride"] = 36.75, ["Fly|Ride"] = 201.85, ["Neon"] = 163.66, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 515.26}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 51.19, ["Ride"] = 64.65, ["Fly|Ride"] = 116.7, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2442.74}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 23.94, ["Fly"] = 146.73, ["Ride"] = 52.5, ["Fly|Ride"] = 98.24, ["Neon"] = 115.48, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 245.01, ["Mega"] = 1465.4, ["Mega|Ride"] = 935.55, ["Mega|Fly|Ride"] = 761.25}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 10.4, ["Ride"] = 32.16, ["Neon"] = 63.74, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 305.36, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.11, ["Ride"] = 63.7, ["Fly|Ride"] = 144.68, ["Neon"] = 109.89, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 210, ["Mega"] = 385.62, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.01, ["Ride"] = 40.69, ["Neon"] = 148.19, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 374.54, ["Mega"] = 534.27, ["Mega|Fly"] = 567, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 718.82}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.07}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 7.56, ["Ride"] = 17.07, ["Fly|Ride"] = 105, ["Neon"] = 32.99, ["Neon|Ride"] = 97.16, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 210, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 188.89, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 19.72, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 31.39, ["Fly"] = 62.99, ["Ride"] = 39.38, ["Fly|Ride"] = 86.62, ["Neon"] = 165.38, ["Neon|Fly"] = 288.27, ["Neon|Ride"] = 155.44, ["Neon|Fly|Ride"] = 230.9, ["Mega"] = 1258.02, ["Mega|Ride"] = 775.68, ["Mega|Fly|Ride"] = 683.1}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 5.16, ["Fly"] = 25.38, ["Ride"] = 15.59, ["Fly|Ride"] = 32.81, ["Neon"] = 25.17, ["Neon|Fly"] = 72.08, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 76.64, ["Mega"] = 233.15, ["Mega|Fly"] = 431.72, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 200.81}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 6.34, ["Fly"] = 108.22, ["Ride"] = 26.25, ["Fly|Ride"] = 41.71, ["Neon"] = 23.63, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 128.62, ["Mega"] = 354.02, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 254.62}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.29, ["Mega"] = 42.76, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.03, ["Ride"] = 55.36, ["Fly|Ride"] = 144.64, ["Neon"] = 163.62, ["Neon|Ride"] = 220.5, ["Mega"] = 590.63, ["Mega|Ride"] = 854.81, ["Mega|Fly|Ride"] = 798}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 33.33, ["Fly|Ride"] = 58.15, ["Neon"] = 7.65, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 141.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.13, ["Ride"] = 65.63, ["Fly|Ride"] = 287.11, ["Neon"] = 52.5, ["Neon|Ride"] = 107.94, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 576.35, ["Mega|Ride"] = 374.54, ["Mega|Fly|Ride"] = 535.35}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.5, ["Fly|Ride"] = 44.63, ["Neon"] = 10.5, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 99.74, ["Mega"] = 194.25, ["Mega|Ride"] = 154.23, ["Mega|Fly|Ride"] = 288.18}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 3.94, ["Fly"] = 52.49, ["Ride"] = 18.93, ["Fly|Ride"] = 47.31, ["Neon"] = 51.19, ["Neon|Fly"] = 71.25, ["Neon|Ride"] = 140.8, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 610.7, ["Mega|Ride"] = 431.88, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 10.19, ["Mega"] = 418.06, ["Mega|Ride"] = 373.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 51.98, ["Ride"] = 91.88, ["Fly|Ride"] = 288.18, ["Neon"] = 314.9, ["Neon|Ride"] = 494.32, ["Neon|Fly|Ride"] = 1439.79, ["Mega"] = 1407.41, ["Mega|Ride"] = 1302.76, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 14.04, ["Ride"] = 78.66, ["Fly|Ride"] = 161.28, ["Neon"] = 107.62, ["Neon|Ride"] = 145.72, ["Mega"] = 421.31, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 679.23}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 15.75, ["Ride"] = 115.25, ["Neon"] = 143.7, ["Neon|Fly"] = 215.87, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 862.67}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.81, ["Ride"] = 105, ["Fly|Ride"] = 367.49, ["Neon"] = 145.53, ["Neon|Fly"] = 263.37, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 705.87, ["Mega|Fly"] = 2159.35, ["Mega|Ride"] = 641.1, ["Mega|Fly|Ride"] = 842.92}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 20.98, ["Mega"] = 196.88, ["Mega|Fly|Ride"] = 326.06}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 19.69, ["Fly|Ride"] = 42.02, ["Neon"] = 3.86, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 24.89, ["Neon|Fly|Ride"] = 65.1, ["Mega"] = 58.28, ["Mega|Ride"] = 144.39, ["Mega|Fly|Ride"] = 144.36}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.14, ["Fly|Ride"] = 81, ["Neon"] = 13.02, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 90.57, ["Mega|Ride"] = 103.38, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 144.64, ["Ride"] = 19.67, ["Fly|Ride"] = 72.01, ["Neon"] = 6.41, ["Neon|Ride"] = 29.16, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 53.72, ["Mega|Ride"] = 82.78, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.28, ["Fly"] = 65.63, ["Ride"] = 19.49, ["Fly|Ride"] = 72.33, ["Neon"] = 21.86, ["Neon|Ride"] = 107.94, ["Neon|Fly|Ride"] = 215.87, ["Mega"] = 328.02, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 3.9, ["Fly"] = 60.23, ["Ride"] = 26.24, ["Fly|Ride"] = 431.86, ["Neon"] = 29.87, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 306.53, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1079.69}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 8.66, ["Fly"] = 131.24, ["Ride"] = 24.04, ["Fly|Ride"] = 68.4, ["Neon"] = 29.16, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 56.14, ["Neon|Fly|Ride"] = 94.49, ["Mega|Ride"] = 431.72, ["Mega|Fly|Ride"] = 472.75}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 16.32, ["Fly|Ride"] = 63.7, ["Neon"] = 28.07, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 151.13, ["Mega"] = 274.17, ["Mega|Ride"] = 162.99, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 3.84, ["Fly"] = 288.73, ["Ride"] = 47.23, ["Neon"] = 14.6, ["Neon|Fly"] = 437.07, ["Neon|Ride"] = 71.55, ["Neon|Fly|Ride"] = 107.92, ["Mega"] = 105, ["Mega|Fly"] = 216.57, ["Mega|Ride"] = 123.53, ["Mega|Fly|Ride"] = 272.71}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 12.95, ["Fly"] = 113.34, ["Ride"] = 106.32, ["Fly|Ride"] = 331.37, ["Neon"] = 82.69, ["Neon|Ride"] = 191.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 351.16, ["Mega|Ride"] = 632.71, ["Mega|Fly|Ride"] = 584.07}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 39.38, ["Fly"] = 164.07, ["Ride"] = 79.9, ["Fly|Ride"] = 180.77, ["Neon"] = 240.9, ["Neon|Ride"] = 275.63, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1582.26, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1127.15}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 21.6, ["Fly|Ride"] = 51.82, ["Neon"] = 2.1, ["Neon|Ride"] = 29.86, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 27.57, ["Mega|Ride"] = 71.14, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 5.51, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 676.73, ["Mega|Fly|Ride"] = 1137.6}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 53.27, ["Ride"] = 68.25, ["Fly|Ride"] = 170.55, ["Neon"] = 249.37, ["Neon|Ride"] = 357, ["Neon|Fly|Ride"] = 388.48, ["Mega"] = 1778.68, ["Mega|Fly|Ride"] = 1458.19}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.26, ["Fly"] = 190.32, ["Ride"] = 27.75, ["Fly|Ride"] = 133.88, ["Neon"] = 39.38, ["Neon|Fly"] = 130.7, ["Neon|Ride"] = 86.36, ["Neon|Fly|Ride"] = 122.16, ["Mega"] = 267.46, ["Mega|Fly"] = 737.72, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.8, ["Fly|Ride"] = 129.52, ["Neon"] = 12.86, ["Neon|Ride"] = 58.2, ["Neon|Fly|Ride"] = 210, ["Mega"] = 87.94, ["Mega|Fly"] = 282.18, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 252.74}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 33.54, ["Ride"] = 20.99, ["Fly|Ride"] = 57.75, ["Neon"] = 12.99, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 37.59, ["Neon|Fly|Ride"] = 111.16, ["Mega"] = 163.66, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 163.68}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.19, ["Ride"] = 14.25, ["Fly|Ride"] = 52.4, ["Neon"] = 2.2, ["Neon|Fly"] = 120.48, ["Neon|Ride"] = 23.38, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 23.62, ["Mega|Ride"] = 73.12, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 18.84, ["Fly|Ride"] = 36.75, ["Neon"] = 3.71, ["Neon|Ride"] = 23.42, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.94, ["Mega|Fly"] = 123.77, ["Mega|Ride"] = 50.24, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.2, ["Neon|Ride"] = 145.08, ["Mega"] = 23.03, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 6.46, ["Ride"] = 157.49, ["Neon"] = 46.31, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 407.95, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 430.65}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 6.56, ["Ride"] = 26.24, ["Fly|Ride"] = 214.93, ["Neon"] = 62.33, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 285.48, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 466.28}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 3.7, ["Fly"] = 19.29, ["Ride"] = 19.23, ["Fly|Ride"] = 38.48, ["Neon"] = 49.87, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 356.19, ["Mega|Ride"] = 248.07, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 72.05, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 476.13, ["Neon|Fly|Ride"] = 720.15, ["Mega"] = 2442.32, ["Mega|Ride"] = 1627.6, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 13.13, ["Fly"] = 82.69, ["Ride"] = 59.07, ["Fly|Ride"] = 115.49, ["Neon"] = 1006.41, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.05, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1004.73}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 20.5, ["Fly|Ride"] = 36.71, ["Neon"] = 2.1, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 23.55, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 323.8}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.17, ["Ride"] = 15.75, ["Fly|Ride"] = 28.77, ["Neon"] = 3.75, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.29, ["Neon|Fly|Ride"] = 41.58, ["Mega"] = 39.25, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 105}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 402.94, ["Fly"] = 573.96, ["Ride"] = 450.85, ["Fly|Ride"] = 524.9, ["Neon"] = 2374.45, ["Neon|Ride"] = 2034.38, ["Neon|Fly|Ride"] = 2097.38, ["Mega|Fly|Ride"] = 6836.22}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 2.52, ["Ride"] = 33.78, ["Neon"] = 48.55, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 403.67, ["Mega|Ride"] = 719.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 15.74, ["Fly|Ride"] = 49.69, ["Neon"] = 4.99, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 22.18, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.6, ["Mega|Ride"] = 144.64, ["Mega|Fly|Ride"] = 119.84}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 43.32, ["Ride"] = 123.05, ["Fly|Ride"] = 288.15, ["Neon"] = 199.49, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 718.82, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 796.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 27.82, ["Ride"] = 21.92, ["Fly|Ride"] = 60.92, ["Neon"] = 14.14, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 30.95, ["Neon|Fly|Ride"] = 77.83, ["Mega"] = 112.88, ["Mega|Ride"] = 123.38, ["Mega|Fly|Ride"] = 232.32}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 196.88, ["Neon"] = 3.61, ["Neon|Fly"] = 101.47, ["Neon|Ride"] = 64.78, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 15.75, ["Mega|Ride"] = 52.48, ["Mega|Fly|Ride"] = 230.98}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 38.85, ["Fly"] = 129.94, ["Ride"] = 76.65, ["Fly|Ride"] = 214.8, ["Neon"] = 147, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 705.72, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 731.76}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.44, ["Neon|Ride"] = 41.03, ["Neon|Fly|Ride"] = 86.36, ["Mega"] = 62.62, ["Mega|Ride"] = 176.25, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 22.73, ["Ride"] = 68.12, ["Fly|Ride"] = 118.13, ["Neon"] = 283.23, ["Neon|Ride"] = 326.82, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 1181.25, ["Mega|Ride"] = 1295.16, ["Mega|Fly|Ride"] = 1334.02}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 5.25, ["Ride"] = 131.25, ["Fly|Ride"] = 431.72, ["Neon"] = 30.51, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 503.49, ["Mega"] = 131.25, ["Mega|Ride"] = 417.69}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 72.33, ["Ride"] = 81.34, ["Fly|Ride"] = 58.3, ["Neon"] = 9.54, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 437.97, ["Mega"] = 117.6, ["Mega|Ride"] = 128.64, ["Mega|Fly|Ride"] = 195.44}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 41.7, ["Fly"] = 187.81, ["Ride"] = 118.13, ["Fly|Ride"] = 163.24, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2016.12}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.49, ["Ride"] = 35.36, ["Neon"] = 5.16, ["Neon|Ride"] = 57.42, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 43.18, ["Mega|Fly"] = 215.87, ["Mega|Ride"] = 88.52, ["Mega|Fly|Ride"] = 282.79}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 21.8, ["Ride"] = 23.54, ["Fly|Ride"] = 102.88, ["Neon"] = 5.25, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 25.91, ["Neon|Fly|Ride"] = 81.84, ["Mega"] = 59.13, ["Mega|Fly"] = 150.24, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 219.84}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 6.57, ["Fly"] = 57.92, ["Ride"] = 38.06, ["Fly|Ride"] = 195.43, ["Neon"] = 81.86, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 203.98, ["Mega"] = 262.5, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 6.43, ["Fly"] = 65.63, ["Ride"] = 25.17, ["Fly|Ride"] = 69.11, ["Neon"] = 52.5, ["Neon|Ride"] = 47.31, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 354.38, ["Mega|Ride"] = 356.62, ["Mega|Fly|Ride"] = 410.08}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 13.13, ["Fly"] = 28.88, ["Ride"] = 32.82, ["Fly|Ride"] = 65.96, ["Neon"] = 51.98, ["Neon|Ride"] = 71.07, ["Neon|Fly|Ride"] = 151.68, ["Mega"] = 403.67, ["Mega|Ride"] = 327.45, ["Mega|Fly|Ride"] = 318.41}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 65.01, ["Ride"] = 114.79, ["Fly|Ride"] = 245.84, ["Neon"] = 314.99, ["Neon|Ride"] = 311.85, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 1575, ["Mega|Ride"] = 1665.37, ["Mega|Fly|Ride"] = 1465.58}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 6.33, ["Ride"] = 115.4, ["Fly|Ride"] = 262.5, ["Neon"] = 65.63, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 351.86, ["Mega"] = 252, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 640.99}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.68, ["Ride"] = 25.57, ["Fly|Ride"] = 78.73, ["Neon"] = 41.53, ["Neon|Ride"] = 44.63, ["Mega"] = 977.1, ["Mega|Ride"] = 170.55, ["Mega|Fly|Ride"] = 431.72}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.25, ["Fly"] = 135.19, ["Ride"] = 41.2, ["Fly|Ride"] = 163.66, ["Neon"] = 76.13, ["Neon|Ride"] = 112.26, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 317.63, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.13, ["Fly|Ride"] = 43.22, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.32, ["Neon|Fly|Ride"] = 55.07, ["Mega"] = 14.77, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.84, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.4, ["Fly"] = 164.07, ["Ride"] = 103.69, ["Neon"] = 236.25, ["Neon|Fly"] = 2447.64, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 485.7, ["Mega"] = 1079.31, ["Mega|Ride"] = 984.38, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 24.5, ["Fly|Ride"] = 144.64, ["Neon"] = 8.55, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 86.73, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 29.16, ["Ride"] = 17.61, ["Fly|Ride"] = 45.94, ["Neon"] = 19.53, ["Neon|Ride"] = 29.16, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 257.25, ["Mega|Ride"] = 200.1, ["Mega|Fly|Ride"] = 234.94}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.36, ["Ride"] = 90.57, ["Fly|Ride"] = 170.63, ["Neon"] = 227.27, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 339.94, ["Mega"] = 787.5, ["Mega|Ride"] = 1014.55, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 29.16, ["Neon"] = 5.8, ["Neon|Ride"] = 52.5, ["Mega"] = 42.53, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 446.22}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 2.43}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 138.2, ["Neon"] = 6.57, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 215.77, ["Mega"] = 72.98, ["Mega|Fly"] = 193.2, ["Mega|Ride"] = 107.85, ["Mega|Fly|Ride"] = 290.64}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.24, ["Ride"] = 183.75, ["Fly|Ride"] = 352.94, ["Neon"] = 652.19, ["Neon|Ride"] = 617.4, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6475.73, ["Mega|Ride"] = 3256.82, ["Mega|Fly|Ride"] = 2381.45}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 2.63, ["Ride"] = 36.71, ["Fly|Ride"] = 122.12, ["Neon"] = 32.45, ["Neon|Fly"] = 144.64, ["Neon|Ride"] = 103.47, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 140.8, ["Mega|Ride"] = 223.65, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.84, ["Neon|Ride"] = 21.55, ["Mega"] = 45.42, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 66.93, ["Mega|Fly|Ride"] = 420.93}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 2.98, ["Ride"] = 36.73, ["Fly|Ride"] = 131.25, ["Neon"] = 65.52, ["Neon|Ride"] = 89.59, ["Neon|Fly|Ride"] = 159.75, ["Mega"] = 431.72, ["Mega|Ride"] = 576.35, ["Mega|Fly|Ride"] = 676.97}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.33, ["Fly"] = 54.96, ["Ride"] = 19.88, ["Fly|Ride"] = 62.62, ["Neon"] = 101.04, ["Neon|Ride"] = 128.46, ["Neon|Fly|Ride"] = 289.42, ["Mega"] = 261.37, ["Mega|Ride"] = 430.65, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.69, ["Ride"] = 56.75, ["Fly|Ride"] = 172.5, ["Neon"] = 136.5, ["Neon|Ride"] = 183.49, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 559.38, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 147, ["Fly"] = 196.88, ["Ride"] = 190.31, ["Fly|Ride"] = 216.57, ["Neon"] = 639.3, ["Neon|Fly"] = 863.44, ["Neon|Ride"] = 576.24, ["Neon|Fly|Ride"] = 656.15, ["Mega|Fly|Ride"] = 2303.65}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 4.9, ["Fly"] = 19.59, ["Ride"] = 19.68, ["Fly|Ride"] = 40.69, ["Neon"] = 58.32, ["Neon|Fly"] = 58.3, ["Neon|Ride"] = 65.31, ["Neon|Fly|Ride"] = 77.94, ["Mega"] = 323.8, ["Mega|Ride"] = 322.48, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 72.33, ["Ride"] = 28.07, ["Fly|Ride"] = 131.25, ["Neon"] = 18.76, ["Neon|Ride"] = 39.35, ["Neon|Fly|Ride"] = 114.81, ["Mega"] = 159.75, ["Mega|Ride"] = 205.08, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 7.76, ["Fly"] = 42.76, ["Ride"] = 37.88, ["Fly|Ride"] = 76.13, ["Neon"] = 39.38, ["Neon|Fly"] = 72.33, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 172.71, ["Mega"] = 461.95, ["Mega|Ride"] = 430.65, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 46.78, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 129.99, ["Neon"] = 167.9, ["Neon|Ride"] = 254.69, ["Neon|Fly|Ride"] = 262.49, ["Mega"] = 975.7, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 962.81}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 15.44, ["Fly"] = 57.75, ["Ride"] = 261.2, ["Neon"] = 196.87, ["Neon|Ride"] = 259.04, ["Mega"] = 863.35, ["Mega|Ride"] = 698.32, ["Mega|Fly|Ride"] = 820.28}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 328.13, ["Ride"] = 350.44, ["Fly|Ride"] = 420, ["Neon"] = 1953.86, ["Neon|Ride"] = 3257.31, ["Mega|Fly|Ride"] = 5179.51}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 19.46, ["Fly"] = 58.65, ["Ride"] = 27.18, ["Fly|Ride"] = 69.47, ["Neon"] = 237.91, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 269.07, ["Mega"] = 761.25, ["Mega|Ride"] = 753.43, ["Mega|Fly|Ride"] = 896.72}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 13.85, ["Fly|Ride"] = 72.33, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 20.9, ["Mega|Fly"] = 114.45, ["Mega|Ride"] = 65.97, ["Mega|Fly|Ride"] = 120.1}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.08, ["Neon"] = 20.43, ["Neon|Ride"] = 29.14, ["Neon|Fly|Ride"] = 163.66, ["Mega"] = 163.68, ["Mega|Ride"] = 144.8, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 28.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 133.87, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 383.16, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 360.93, ["Fly"] = 393.75, ["Ride"] = 418.68, ["Fly|Ride"] = 551.25, ["Neon"] = 1898.49, ["Neon|Ride"] = 2016.83, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5537.46}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.4, ["Fly|Ride"] = 68.4, ["Neon"] = 32.71, ["Neon|Ride"] = 36.67, ["Neon|Fly|Ride"] = 111.13, ["Mega"] = 223.02, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 6.25, ["Fly"] = 28.07, ["Ride"] = 19.56, ["Fly|Ride"] = 43.19, ["Neon"] = 45.65, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 139.13, ["Mega"] = 212.52, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 302.64}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.71, ["Fly"] = 42, ["Ride"] = 28.07, ["Fly|Ride"] = 61.25, ["Neon"] = 15.57, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 42.11, ["Neon|Fly|Ride"] = 107.77, ["Mega"] = 94.5, ["Mega|Fly"] = 128.64, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 38.98, ["Fly"] = 57.42, ["Ride"] = 36.75, ["Fly|Ride"] = 78.75, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 322.73, ["Mega"] = 1294.89, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 12.57, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 165.4, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 1036.14}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 11.54, ["Fly"] = 93.13, ["Ride"] = 32.82, ["Neon"] = 170.63, ["Neon|Ride"] = 201.79, ["Neon|Fly|Ride"] = 259.23, ["Mega"] = 748.13, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 792.22}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 4.8, ["Neon|Ride"] = 38.34, ["Mega"] = 64.32, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 107.94, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 5.25, ["Neon"] = 53.76, ["Mega"] = 136.02, ["Mega|Ride"] = 326.12, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 6.08, ["Ride"] = 43.19, ["Fly|Ride"] = 63, ["Neon"] = 45.5, ["Neon|Ride"] = 288.18, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 560.17, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 9.19, ["Fly"] = 26.17, ["Ride"] = 27.06, ["Fly|Ride"] = 56.74, ["Neon"] = 54.03, ["Neon|Fly"] = 114.81, ["Neon|Ride"] = 55.7, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 538.58, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 433.11, ["Fly"] = 610.67, ["Ride"] = 440.46, ["Fly|Ride"] = 522.38, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 2677.14, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7425.52}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.35, ["Fly|Ride"] = 40.69, ["Neon"] = 15.75, ["Neon|Fly"] = 81.84, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 171.29, ["Mega"] = 245.01, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 306.58}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.18, ["Fly"] = 71.25, ["Ride"] = 80.97, ["Fly|Ride"] = 187.81, ["Neon"] = 89.25, ["Neon|Ride"] = 128.46, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 719.9, ["Mega|Ride"] = 568.2, ["Mega|Fly|Ride"] = 541.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.59, ["Ride"] = 97.46, ["Fly|Ride"] = 220.67, ["Neon"] = 84.46, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 374.91, ["Mega"] = 307.85, ["Mega|Ride"] = 431.72, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 54.9, ["Fly"] = 214.8, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 345.23, ["Neon|Ride"] = 334.67, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 1840.54}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 9.99, ["Ride"] = 42, ["Neon"] = 55.99, ["Neon|Ride"] = 90.98, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 170.51, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 206.87, ["Mega|Fly|Ride"] = 353.45}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 32.82, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 113.52, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 5.04, ["Ride"] = 67.02, ["Neon"] = 25.7, ["Neon|Ride"] = 123.05, ["Neon|Fly|Ride"] = 173.92, ["Mega"] = 157.5, ["Mega|Fly"] = 256.88, ["Mega|Ride"] = 195.37, ["Mega|Fly|Ride"] = 277.6}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 50.93, ["Fly"] = 183.72, ["Ride"] = 94.5, ["Fly|Ride"] = 197.75, ["Neon"] = 118.13, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 267.75, ["Mega"] = 388.5, ["Mega|Ride"] = 450.86, ["Mega|Fly|Ride"] = 477.16}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 6.88, ["Neon|Ride"] = 94.37, ["Neon|Fly|Ride"] = 189, ["Mega"] = 66.07, ["Mega|Ride"] = 169.78}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 17.1, ["Ride"] = 97.16, ["Neon"] = 173.25, ["Neon|Ride"] = 373.46, ["Mega"] = 741.57, ["Mega|Fly|Ride"] = 849.27}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.75, ["Fly"] = 1194.38, ["Ride"] = 1017.19, ["Fly|Ride"] = 1050, ["Neon"] = 3599.44, ["Neon|Ride"] = 2611.88, ["Neon|Fly|Ride"] = 2884.88, ["Mega|Fly|Ride"] = 9187.5}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 19.15, ["Fly"] = 118.13, ["Ride"] = 45.48, ["Fly|Ride"] = 179.16, ["Neon"] = 85.32, ["Neon|Fly"] = 717.94, ["Neon|Ride"] = 183.01, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 448.87, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 525.63}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.37, ["Ride"] = 21.6, ["Fly|Ride"] = 79.93, ["Neon"] = 10.5, ["Neon|Fly"] = 79.83, ["Neon|Ride"] = 31.32, ["Neon|Fly|Ride"] = 83.22, ["Mega"] = 65.63, ["Mega|Ride"] = 97.79, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.02, ["Ride"] = 131.25, ["Fly|Ride"] = 144.64, ["Neon"] = 67.51, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 385.89, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 924}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 187.87, ["Neon"] = 2.56, ["Neon|Ride"] = 26.98, ["Neon|Fly|Ride"] = 107.94, ["Mega"] = 18.22, ["Mega|Ride"] = 48.83, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 56.44, ["Fly"] = 129.52, ["Ride"] = 100.63, ["Fly|Ride"] = 266.44, ["Neon"] = 220.49, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 384.74, ["Mega"] = 993.24, ["Mega|Ride"] = 892.5, ["Mega|Fly|Ride"] = 934.5}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 11.54, ["Ride"] = 62.89, ["Fly|Ride"] = 285.32, ["Neon"] = 169.32, ["Neon|Ride"] = 442.54, ["Neon|Fly|Ride"] = 215.87, ["Mega"] = 490.01, ["Mega|Ride"] = 1004.83, ["Mega|Fly|Ride"] = 1005.71}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.63, ["Ride"] = 23.21, ["Neon"] = 10.87, ["Neon|Ride"] = 42.25, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 99.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 431.72}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 18.32, ["Fly"] = 159.79, ["Ride"] = 45.35, ["Fly|Ride"] = 105.87, ["Neon"] = 87.84, ["Neon|Ride"] = 95.7, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 472.19, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 741.29}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 97.15, ["Ride"] = 29.16, ["Fly|Ride"] = 59.07, ["Neon"] = 43.14, ["Neon|Fly"] = 130.68, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 156.32, ["Mega"] = 358.34, ["Mega|Ride"] = 539.66, ["Mega|Fly|Ride"] = 430.5}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.19, ["Ride"] = 91.88, ["Neon"] = 323.73, ["Neon|Ride"] = 323.73, ["Neon|Fly|Ride"] = 576.35, ["Mega"] = 2519.07, ["Mega|Ride"] = 2442.68, ["Mega|Fly|Ride"] = 2158.58}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.82, ["Fly|Ride"] = 194.29, ["Neon"] = 12.39, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 652.21, ["Mega"] = 66.94, ["Mega|Ride"] = 115.5, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.24, ["Fly"] = 36.71, ["Ride"] = 23.63, ["Fly|Ride"] = 71.25, ["Neon"] = 39.29, ["Neon|Fly"] = 187.87, ["Neon|Ride"] = 64.76, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 301.55, ["Mega|Ride"] = 252.11, ["Mega|Fly|Ride"] = 323.54}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 115.96, ["Fly"] = 393.75, ["Ride"] = 167.99, ["Fly|Ride"] = 228.92, ["Neon"] = 480.17, ["Neon|Ride"] = 546.69, ["Neon|Fly|Ride"] = 555.19, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1964.08}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 27.29, ["Ride"] = 19.04, ["Fly|Ride"] = 48.86, ["Neon"] = 13.11, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 23.91, ["Neon|Fly|Ride"] = 78.88, ["Mega"] = 137.82, ["Mega|Ride"] = 163.03, ["Mega|Fly|Ride"] = 187.69}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 24.69, ["Fly"] = 267.04, ["Ride"] = 68.25, ["Fly|Ride"] = 172.71, ["Neon"] = 170.63, ["Neon|Ride"] = 207.33, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 609.02, ["Mega|Ride"] = 602.44, ["Mega|Fly|Ride"] = 938.44}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 12.17, ["Fly|Ride"] = 62.99, ["Neon"] = 2.1, ["Neon|Fly"] = 29.65, ["Neon|Ride"] = 17.07, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 15.38, ["Mega|Fly"] = 47.64, ["Mega|Ride"] = 31.29, ["Mega|Fly|Ride"] = 71.49}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 58.3, ["Neon"] = 2.63, ["Neon|Fly|Ride"] = 133.9, ["Mega"] = 20.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.15, ["Fly"] = 36.71, ["Ride"] = 28.88, ["Fly|Ride"] = 173.37, ["Neon"] = 14.58, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 247.41}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 28.76, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 345.39, ["Neon|Fly|Ride"] = 399.49, ["Mega"] = 515.83, ["Mega|Ride"] = 646.5}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 3.94, ["Fly"] = 16.89, ["Ride"] = 16.99, ["Fly|Ride"] = 39.38, ["Neon"] = 14.18, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 58.47, ["Mega"] = 131.25, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 7.77, ["Fly"] = 55.16, ["Ride"] = 33.47, ["Fly|Ride"] = 96.79, ["Neon"] = 48.57, ["Neon|Fly"] = 110.84, ["Neon|Ride"] = 55.04, ["Neon|Fly|Ride"] = 86.36, ["Mega"] = 373.7, ["Mega|Fly"] = 439.68, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 354.25}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.49, ["Ride"] = 18.26, ["Fly|Ride"] = 68.61, ["Neon"] = 8.32, ["Neon|Fly"] = 98.42, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 61.74, ["Mega"] = 51.4, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 63.66, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.19, ["Fly"] = 163.04, ["Ride"] = 24.94, ["Fly|Ride"] = 217.2, ["Neon"] = 40.69, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 163.68, ["Mega"] = 288.18, ["Mega|Ride"] = 534.27, ["Mega|Fly|Ride"] = 488.54}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 5.15, ["Ride"] = 51.82, ["Fly|Ride"] = 170.63, ["Neon"] = 51.19, ["Neon|Ride"] = 73.5, ["Mega"] = 241.5, ["Mega|Ride"] = 302.22, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 4.6, ["Fly"] = 47.08, ["Ride"] = 19.93, ["Fly|Ride"] = 57.08, ["Neon"] = 27, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 146.37, ["Mega"] = 233.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 242.82}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.88, ["Ride"] = 16.27, ["Fly|Ride"] = 51.82, ["Neon"] = 16.15, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.42, ["Neon|Fly|Ride"] = 84.2, ["Mega"] = 144.64, ["Mega|Ride"] = 115.49, ["Mega|Fly|Ride"] = 287.11}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 194.25, ["Fly"] = 393.75, ["Ride"] = 273, ["Fly|Ride"] = 430.65, ["Neon"] = 1151.61, ["Neon|Ride"] = 1281.14, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4233.73, ["Mega|Fly|Ride"] = 4062.19}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 2.89, ["Ride"] = 114.17, ["Neon"] = 42.35, ["Neon|Ride"] = 144.64, ["Mega"] = 122.14, ["Mega|Ride"] = 652.2, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 107.94, ["Ride"] = 24.77, ["Fly|Ride"] = 86.36, ["Neon"] = 32.06, ["Neon|Fly"] = 245.01, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 146.57, ["Mega"] = 246.65, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.81, ["Fly|Ride"] = 720.15, ["Neon"] = 49.66, ["Neon|Ride"] = 230.98, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 166.23, ["Mega|Ride"] = 490.01, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.21, ["Ride"] = 14.43, ["Fly|Ride"] = 32.82, ["Neon"] = 2.1, ["Neon|Fly"] = 21.6, ["Neon|Ride"] = 16.68, ["Neon|Fly|Ride"] = 42.11, ["Mega"] = 18.17, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.18}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 3.84, ["Fly"] = 47.16, ["Ride"] = 16.7, ["Fly|Ride"] = 103.63, ["Neon"] = 21.57, ["Neon|Ride"] = 36.7, ["Neon|Fly|Ride"] = 88.11, ["Mega"] = 156.15, ["Mega|Ride"] = 210.48, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.15, ["Ride"] = 121.07, ["Neon"] = 10.5, ["Neon|Ride"] = 288.27, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 52.34, ["Mega|Ride"] = 168.92, ["Mega|Fly|Ride"] = 284.94}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 72.19, ["Fly"] = 105, ["Ride"] = 92.61, ["Fly|Ride"] = 137.81, ["Neon"] = 315, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 3599.44, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.85, ["Fly"] = 72.33, ["Ride"] = 23.61, ["Fly|Ride"] = 85.2, ["Neon"] = 21.75, ["Neon|Ride"] = 69.57, ["Mega"] = 169.3, ["Mega|Ride"] = 273.78, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.2, ["Neon"] = 5, ["Neon|Ride"] = 177.05, ["Neon|Fly|Ride"] = 548.41, ["Mega"] = 58.68, ["Mega|Fly"] = 314.99, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 40.43, ["Fly"] = 131.25, ["Ride"] = 71.63, ["Fly|Ride"] = 190.32, ["Neon"] = 150.94, ["Neon|Ride"] = 176.6, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 511.88, ["Mega|Ride"] = 636.57, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 14.34, ["Ride"] = 12.84, ["Fly|Ride"] = 46.43, ["Neon"] = 2.1, ["Neon|Fly"] = 22.63, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 16.64, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.68, ["Mega|Fly|Ride"] = 62.91}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 58.28, ["Fly|Ride"] = 97.16, ["Neon"] = 3.83, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 26.24, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 23.63, ["Mega|Fly"] = 144.64, ["Mega|Ride"] = 92.7, ["Mega|Fly|Ride"] = 288.18}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.6, ["Ride"] = 39.38, ["Fly|Ride"] = 161.34, ["Neon"] = 7.6, ["Neon|Ride"] = 96.95, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 64.32, ["Mega|Fly"] = 187.87, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 237.88}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 5.91, ["Fly"] = 122.07, ["Ride"] = 36.74, ["Fly|Ride"] = 155.44, ["Neon"] = 19.68, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 115.49, ["Neon|Fly|Ride"] = 459.38, ["Mega"] = 104.35, ["Mega|Fly"] = 331.46, ["Mega|Ride"] = 169.18, ["Mega|Fly|Ride"] = 269.07}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 14.56, ["Fly|Ride"] = 43.19, ["Neon"] = 2.1, ["Neon|Fly"] = 24.84, ["Neon|Ride"] = 26.32, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 20.51, ["Mega|Ride"] = 61.34, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.01, ["Fly"] = 127.38, ["Ride"] = 69.71, ["Neon"] = 164.07, ["Neon|Ride"] = 194.29, ["Neon|Fly|Ride"] = 431.72, ["Mega"] = 797.62, ["Mega|Fly|Ride"] = 719.9}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2625, ["Fly"] = 3150, ["Ride"] = 2256.19, ["Fly|Ride"] = 2163, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 44806.19}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 16.1, ["Fly|Ride"] = 45.94, ["Neon"] = 8.65, ["Neon|Fly"] = 71.25, ["Neon|Ride"] = 24.25, ["Neon|Fly|Ride"] = 57.75, ["Mega"] = 63.68, ["Mega|Fly"] = 476.15, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 161.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 9.85, ["Mega"] = 102.78, ["Mega|Fly"] = 441, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 488.48}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.11, ["Fly"] = 105, ["Ride"] = 32.81, ["Fly|Ride"] = 144.64, ["Neon"] = 73.37, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 279.87, ["Mega"] = 431.81, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 676.73}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 15.75, ["Fly"] = 144.64, ["Ride"] = 71.92, ["Neon"] = 161.44, ["Neon|Ride"] = 196.88, ["Mega"] = 679.87, ["Mega|Ride"] = 689.69, ["Mega|Fly|Ride"] = 652.19}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 143.51, ["Fly"] = 548.42, ["Ride"] = 188.87, ["Fly|Ride"] = 242.82, ["Neon"] = 647.07, ["Neon|Ride"] = 766.63, ["Neon|Fly|Ride"] = 652.32, ["Mega|Fly|Ride"] = 4073.25}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 12.75, ["Ride"] = 64.97, ["Fly|Ride"] = 86.35, ["Neon"] = 15.74, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 144.45, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 378.98}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 24.44, ["Neon"] = 16.83, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.82, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.46, ["Fly"] = 101.5, ["Ride"] = 33.47, ["Fly|Ride"] = 85.29, ["Neon"] = 7.76, ["Neon|Fly"] = 127.38, ["Neon|Ride"] = 32.16, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 65.63, ["Mega|Ride"] = 113.02, ["Mega|Fly|Ride"] = 237.79}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 10.49, ["Ride"] = 71.47, ["Fly|Ride"] = 131.25, ["Neon"] = 130.94, ["Neon|Ride"] = 1225.04, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 576.35, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 25.92, ["Neon"] = 2.1, ["Neon|Ride"] = 29.33, ["Mega"] = 19.59, ["Mega|Ride"] = 90.04}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Ride"] = 129.52, ["Fly|Ride"] = 167.9, ["Neon"] = 311.85, ["Neon|Fly"] = 378.86, ["Neon|Ride"] = 378.86, ["Neon|Fly|Ride"] = 431.72, ["Mega"] = 3239.02, ["Mega|Fly|Ride"] = 1397.69}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 45.35, ["Ride"] = 91.85, ["Neon"] = 13.57, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 215.87, ["Mega"] = 64.05, ["Mega|Ride"] = 288.18, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 51.19, ["Fly"] = 105, ["Ride"] = 84, ["Fly|Ride"] = 177.01, ["Neon"] = 240.71, ["Neon|Ride"] = 255.04, ["Neon|Fly|Ride"] = 429.58, ["Mega"] = 2625}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 63.72, ["Ride"] = 17.72, ["Fly|Ride"] = 43.22, ["Neon"] = 4.73, ["Neon|Fly"] = 85.52, ["Neon|Ride"] = 72.35, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 41.58, ["Mega|Fly"] = 146.46, ["Mega|Ride"] = 72.08, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.51, ["Neon|Ride"] = 115.49, ["Mega"] = 39.64, ["Mega|Ride"] = 171.02, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 3.9, ["Fly"] = 72.35, ["Ride"] = 24.55, ["Fly|Ride"] = 90.57, ["Neon"] = 20.96, ["Neon|Fly"] = 107.94, ["Neon|Ride"] = 72.47, ["Mega"] = 141.74, ["Mega|Ride"] = 326.1, ["Mega|Fly|Ride"] = 576.35}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 364.88, ["Fly"] = 732.71, ["Ride"] = 393.74, ["Fly|Ride"] = 588, ["Neon"] = 853.12, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1158.19, ["Mega"] = 3114.84, ["Mega|Ride"] = 2165.63, ["Mega|Fly|Ride"] = 3017.44}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 40.58, ["Fly"] = 65.63, ["Ride"] = 54.65, ["Fly|Ride"] = 87.92, ["Neon"] = 185.71, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 196.88, ["Mega|Fly"] = 2752.96, ["Mega|Ride"] = 1726.88, ["Mega|Fly|Ride"] = 1064.19}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 5.25, ["Fly"] = 61.62, ["Ride"] = 32.81, ["Fly|Ride"] = 123.48, ["Neon"] = 27.22, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 79.9, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 139.15, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 15.59, ["Fly"] = 215.87, ["Ride"] = 65.97, ["Fly|Ride"] = 149.63, ["Neon"] = 76.39, ["Neon|Fly"] = 374.07, ["Neon|Ride"] = 81.84, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 287.82, ["Mega|Fly"] = 1005.02, ["Mega|Ride"] = 280.63, ["Mega|Fly|Ride"] = 491.21}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.49, ["Ride"] = 19.69, ["Neon"] = 101.36, ["Neon|Ride"] = 122.16, ["Neon|Fly|Ride"] = 488.54, ["Mega"] = 652.11, ["Mega|Ride"] = 283.88, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 2.6, ["Neon"] = 13.13, ["Neon|Ride"] = 157.5, ["Mega"] = 107.63, ["Mega|Ride"] = 335.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 72.33, ["Ride"] = 19.68, ["Fly|Ride"] = 62.97, ["Neon"] = 59.07, ["Neon|Fly"] = 101.5, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 212.49, ["Mega"] = 262.5, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 105, ["Fly"] = 244.29, ["Ride"] = 98.44, ["Fly|Ride"] = 192.3, ["Neon"] = 787.5, ["Neon|Ride"] = 518.45, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 20.44, ["Ride"] = 56.13, ["Fly|Ride"] = 85.32, ["Neon"] = 118.53, ["Neon|Ride"] = 172.71, ["Neon|Fly|Ride"] = 194.25, ["Mega"] = 537.48, ["Mega|Ride"] = 574.2, ["Mega|Fly|Ride"] = 718.68}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1765.79, ["Fly"] = 2158.58, ["Ride"] = 1968.75, ["Fly|Ride"] = 1962.19, ["Neon"] = 11516.35, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24279.94}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.76, ["Fly"] = 131250, ["Ride"] = 68.25, ["Fly|Ride"] = 196.87, ["Neon"] = 19.59, ["Neon|Ride"] = 81.83, ["Mega"] = 164.07, ["Mega|Fly"] = 786.19, ["Mega|Ride"] = 230.98, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.68, ["Ride"] = 52.49, ["Fly|Ride"] = 97.68, ["Neon"] = 28.76, ["Neon|Ride"] = 88.62, ["Neon|Fly|Ride"] = 218.63, ["Mega"] = 150.93, ["Mega|Ride"] = 159.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 879.38, ["Ride"] = 840, ["Fly|Ride"] = 1010.63, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.49, ["Mega|Ride"] = 13840.5, ["Mega|Fly|Ride"] = 10252.16}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.33, ["Ride"] = 52.5, ["Fly|Ride"] = 173.35, ["Neon"] = 144.36, ["Neon|Ride"] = 323.54, ["Mega"] = 853.21, ["Mega|Ride"] = 835.38, ["Mega|Fly|Ride"] = 835.42}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.03, ["Fly|Ride"] = 128.15, ["Neon"] = 12.17, ["Neon|Fly"] = 163.68, ["Neon|Ride"] = 64.78, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 353.07}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 144.68, ["Neon"] = 3.04, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.83, ["Neon|Fly|Ride"] = 107.92, ["Mega"] = 23.37, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 163.68}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.86, ["Fly"] = 431.86, ["Ride"] = 130.7, ["Fly|Ride"] = 215.87, ["Neon"] = 459.38, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2442.68, ["Mega|Fly|Ride"] = 2374.45}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 34.56, ["Fly|Ride"] = 75.57, ["Neon"] = 12.42, ["Neon|Ride"] = 34.56, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 91.87, ["Mega|Ride"] = 127.32, ["Mega|Fly|Ride"] = 147.63}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.66, ["Fly"] = 151.13, ["Ride"] = 98.04, ["Fly|Ride"] = 288.15, ["Neon"] = 610.32, ["Neon|Ride"] = 721.88, ["Mega"] = 2158.58, ["Mega|Fly|Ride"] = 1651.33}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.59, ["Fly"] = 105, ["Fly|Ride"] = 129.57, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.84, ["Mega|Ride"] = 318.41}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 251.68, ["Fly"] = 417.38, ["Ride"] = 294, ["Fly|Ride"] = 301.88, ["Neon"] = 1148.82, ["Neon|Ride"] = 1295.16, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 8.39, ["Fly"] = 65.63, ["Ride"] = 24.84, ["Fly|Ride"] = 115.4, ["Neon"] = 29.33, ["Neon|Ride"] = 73.41, ["Neon|Fly|Ride"] = 115.49, ["Mega"] = 335.88, ["Mega|Ride"] = 617.82, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 23.22, ["Ride"] = 15.64, ["Fly|Ride"] = 39.38, ["Neon"] = 4.6, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 20.52, ["Neon|Fly|Ride"] = 63.52, ["Mega"] = 39.38, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 125.99}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1349.13, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 7918.29, ["Neon|Fly|Ride"] = 7052.08, ["Mega"] = 24426.7, ["Mega|Fly|Ride"] = 23025.54}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 8.45, ["Ride"] = 77.58, ["Fly|Ride"] = 215.87, ["Neon"] = 91.73, ["Neon|Ride"] = 314.99, ["Mega"] = 417.69, ["Mega|Ride"] = 463.86, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 5.23, ["Fly"] = 50.82, ["Ride"] = 38.56, ["Fly|Ride"] = 104.89, ["Neon"] = 25.1, ["Neon|Ride"] = 51.97, ["Neon|Fly|Ride"] = 121.98, ["Mega"] = 162.84, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 24.14, ["Fly"] = 34.7, ["Ride"] = 36.39, ["Fly|Ride"] = 74.46, ["Neon|Ride"] = 173.18, ["Neon|Fly|Ride"] = 189.08, ["Mega"] = 2591.22, ["Mega|Ride"] = 1140.75, ["Mega|Fly|Ride"] = 779.63}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 11.79, ["Fly"] = 71.59, ["Ride"] = 31.52, ["Fly|Ride"] = 71.47, ["Neon"] = 56.2, ["Neon|Ride"] = 84.72, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 561.24}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 65.96, ["Ride"] = 157.5, ["Fly|Ride"] = 644.01, ["Neon"] = 437.98, ["Neon|Fly"] = 576.35, ["Neon|Ride"] = 534.27, ["Neon|Fly|Ride"] = 719.9, ["Mega"] = 1008.07, ["Mega|Fly|Ride"] = 969.12}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.1, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 108.5, ["Neon|Fly|Ride"] = 107.94, ["Mega"] = 17.07, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 99.75, ["Fly"] = 164.07, ["Ride"] = 142.91, ["Fly|Ride"] = 163.68, ["Neon"] = 651.39, ["Neon|Fly"] = 681.06, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 646.5, ["Mega|Fly|Ride"] = 2298.49}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 748.35, ["Ride"] = 52.43, ["Fly|Ride"] = 68.04, ["Neon"] = 227.37, ["Neon|Ride"] = 72.18, ["Mega"] = 773.71, ["Mega|Ride"] = 412.79, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.63, ["Fly|Ride"] = 39.36, ["Neon"] = 16.21, ["Neon|Fly"] = 81.84, ["Neon|Ride"] = 86.36, ["Neon|Fly|Ride"] = 120.41, ["Mega|Ride"] = 277.86}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 142.53, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.86}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 78.75, ["Fly"] = 247.55, ["Ride"] = 203.44, ["Fly|Ride"] = 414.46, ["Neon"] = 426.24, ["Neon|Ride"] = 576.35, ["Neon|Fly|Ride"] = 646.5, ["Mega"] = 2205, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.83, ["Ride"] = 39.38, ["Fly|Ride"] = 431.72, ["Neon"] = 22.31, ["Neon|Ride"] = 59.07, ["Mega"] = 126.87, ["Mega|Ride"] = 157.59, ["Mega|Fly|Ride"] = 326.06}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Ride"] = 37.79, ["Mega"] = 18.11, ["Mega|Ride"] = 92.74, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 19.69, ["Fly|Ride"] = 144.68, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 18.34, ["Mega"] = 18.27, ["Mega|Fly"] = 56.2, ["Mega|Ride"] = 46.09, ["Mega|Fly|Ride"] = 137.33}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.22, ["Fly|Ride"] = 52.49, ["Neon"] = 6.18, ["Neon|Ride"] = 24.49, ["Neon|Fly|Ride"] = 77.96, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 101.49}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.54, ["Neon"] = 24.44, ["Mega"] = 130.7, ["Mega|Ride"] = 129.52, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 15.65, ["Fly|Ride"] = 38.92, ["Neon"] = 16.45, ["Neon|Fly"] = 86.4, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 101.47, ["Mega"] = 236.25, ["Mega|Ride"] = 144.64, ["Mega|Fly|Ride"] = 222.34}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 55.81, ["Ride"] = 148.89, ["Fly|Ride"] = 290.51, ["Neon"] = 203.44, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 636.26, ["Mega"] = 755.52, ["Mega|Ride"] = 761.25, ["Mega|Fly|Ride"] = 862.37}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 18.38, ["Fly|Ride"] = 42.95, ["Neon"] = 2.1, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 46.31, ["Mega"] = 46.43, ["Mega|Ride"] = 163.66, ["Mega|Fly|Ride"] = 97.13}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.52, ["Fly"] = 32.71, ["Ride"] = 33.23, ["Fly|Ride"] = 73.78, ["Neon"] = 38.07, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 66.92, ["Neon|Fly|Ride"] = 124.69, ["Mega"] = 301.88, ["Mega|Fly"] = 576.56, ["Mega|Ride"] = 294, ["Mega|Fly|Ride"] = 314.97}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 28.87, ["Fly"] = 59.07, ["Ride"] = 39.38, ["Fly|Ride"] = 129.52, ["Neon"] = 138.71, ["Neon|Ride"] = 198.23, ["Neon|Fly|Ride"] = 221.58, ["Mega"] = 616.88, ["Mega|Ride"] = 863.44, ["Mega|Fly|Ride"] = 655.02}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 4.55, ["Fly"] = 196.88, ["Ride"] = 18.33, ["Neon"] = 91.88, ["Neon|Ride"] = 105, ["Mega"] = 566.87, ["Mega|Ride"] = 777.11, ["Mega|Fly|Ride"] = 716.66}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 21, ["Ride"] = 16.44, ["Fly|Ride"] = 38.87, ["Neon"] = 3.84, ["Neon|Fly"] = 81.27, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 71.8, ["Mega"] = 40.66, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 122.07}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 11.61, ["Fly"] = 65.63, ["Ride"] = 66.93, ["Neon"] = 85.31, ["Neon|Ride"] = 206.05, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 509.59, ["Mega|Fly"] = 573.13, ["Mega|Ride"] = 547.21, ["Mega|Fly|Ride"] = 576.35}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1046.07, ["Fly"] = 1243.37, ["Ride"] = 1003.96, ["Fly|Ride"] = 1030.32, ["Neon"] = 2491.13, ["Neon|Fly"] = 2913.02, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2494.8, ["Mega|Fly|Ride"] = 6168.74}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 195.57, ["Ride"] = 249.38, ["Fly|Ride"] = 590.63, ["Neon"] = 656.25, ["Neon|Ride"] = 896.34, ["Neon|Fly|Ride"] = 1295.16, ["Mega"] = 3583.35, ["Mega|Ride"] = 3741.91, ["Mega|Fly|Ride"] = 3496.9}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 9.16, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 257.97, ["Mega"] = 63, ["Mega|Fly|Ride"] = 1151.61}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 129.93, ["Fly"] = 183.75, ["Ride"] = 196.88, ["Fly|Ride"] = 377.89, ["Neon"] = 636.57, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 800.63, ["Mega|Ride"] = 2561.87, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 7.7, ["Fly"] = 41.04, ["Ride"] = 22.58, ["Fly|Ride"] = 93.94, ["Neon"] = 18.11, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 38.88, ["Neon|Fly|Ride"] = 313.1, ["Mega"] = 115.96, ["Mega|Ride"] = 259.04, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 255.92, ["Fly"] = 431.86, ["Ride"] = 288.75, ["Fly|Ride"] = 334.69, ["Neon"] = 1441.19, ["Neon|Ride"] = 1583.33, ["Neon|Fly|Ride"] = 1209.13, ["Mega|Fly|Ride"] = 4884.07}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 225.96, ["Neon"] = 19.44, ["Neon|Ride"] = 56.54, ["Mega"] = 393.74, ["Mega|Fly"] = 361.69, ["Mega|Ride"] = 431.72}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 41.87, ["Neon|Ride"] = 53.75, ["Mega"] = 249.38, ["Mega|Ride"] = 345.51}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 21.95, ["Fly"] = 52.5, ["Ride"] = 52.5, ["Fly|Ride"] = 144.64, ["Neon"] = 102.94, ["Neon|Fly"] = 431.86, ["Neon|Ride"] = 124.69, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 839.27, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 244.28, ["Mega|Ride"] = 265.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.29, ["Fly|Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 26.22, ["Neon|Fly|Ride"] = 51.89, ["Mega"] = 26.45, ["Mega|Ride"] = 48.76, ["Mega|Fly|Ride"] = 97.22}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5236.72, ["Ride"] = 4536, ["Fly|Ride"] = 4593.75, ["Neon"] = 32390.02, ["Neon|Fly|Ride"] = 19687.5, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.07, ["Fly"] = 86.36, ["Ride"] = 41.99, ["Neon"] = 86.36, ["Neon|Fly"] = 384.38, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 215.25, ["Mega|Fly|Ride"] = 430.79}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 24.95, ["Ride"] = 19.56, ["Fly|Ride"] = 45.93, ["Neon"] = 19.26, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 83.06, ["Mega"] = 137.81, ["Mega|Ride"] = 128.46, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 471.36, ["Fly"] = 547.21, ["Ride"] = 454.78, ["Fly|Ride"] = 580.13, ["Neon"] = 1634.06, ["Neon|Ride"] = 1155, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 3.21, ["Ride"] = 48.86, ["Neon"] = 14.14, ["Neon|Ride"] = 291.38, ["Mega"] = 144.64, ["Mega|Ride"] = 171.62, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.34, ["Fly"] = 145.69, ["Ride"] = 131.25, ["Neon"] = 52.5, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 72.33, ["Ride"] = 19.76, ["Fly|Ride"] = 65.62, ["Neon"] = 3.66, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 56.09, ["Mega|Ride"] = 70.88, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 878.55, ["Ride"] = 748.13, ["Fly|Ride"] = 721.75, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 8490.78}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 5.44, ["Ride"] = 85.29, ["Fly|Ride"] = 144.63, ["Neon"] = 32.16, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 183.91, ["Mega"] = 200.82, ["Mega|Fly"] = 431.72, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 484.61}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 5.16, ["Fly"] = 106.2, ["Ride"] = 45.94, ["Fly|Ride"] = 123.05, ["Neon"] = 26.25, ["Neon|Ride"] = 59.05, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 174.57, ["Mega|Fly"] = 814.66, ["Mega|Ride"] = 185.15, ["Mega|Fly|Ride"] = 324.9}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 35.44, ["Ride"] = 18.56, ["Fly|Ride"] = 47.16, ["Neon"] = 14.13, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 29.89, ["Neon|Fly|Ride"] = 85.32, ["Mega"] = 165.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 239.77}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.11, ["Fly"] = 39.38, ["Ride"] = 41.03, ["Fly|Ride"] = 65.63, ["Neon"] = 196.88, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 288.18, ["Mega"] = 835.22, ["Mega|Ride"] = 610.59, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 288.18, ["Neon"] = 5.25, ["Neon|Ride"] = 144.64, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 30.06, ["Mega|Fly"] = 146.57, ["Mega|Ride"] = 101.32, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 575.87, ["Fly"] = 676.73, ["Ride"] = 665.84, ["Fly|Ride"] = 682.5, ["Neon"] = 2589.57, ["Neon|Ride"] = 2295.66, ["Neon|Fly|Ride"] = 2303.22, ["Mega|Ride"] = 9524.96, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 3.62, ["Ride"] = 72.18, ["Fly|Ride"] = 262.5, ["Neon"] = 12.92, ["Neon|Ride"] = 72.33, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 53.25, ["Mega|Ride"] = 205.08, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 50.19, ["Neon"] = 4.33, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 37.79, ["Mega|Ride"] = 123.05, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 61.07, ["Neon"] = 3.86, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7197.86, ["Mega"] = 39.37, ["Mega|Fly"] = 159.75, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 144.64}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 17.07, ["Mega"] = 236.38, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 27.85, ["Fly"] = 72.19, ["Ride"] = 58.3, ["Fly|Ride"] = 213.71, ["Neon"] = 103.94, ["Neon|Ride"] = 133.44, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 427.33, ["Mega|Ride"] = 539.24, ["Mega|Fly|Ride"] = 581.44}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 13.13, ["Ride"] = 36.75, ["Fly|Ride"] = 155.17, ["Neon"] = 87.41, ["Neon|Ride"] = 135.58, ["Neon|Fly|Ride"] = 288.29, ["Mega"] = 551.25, ["Mega|Ride"] = 520.3, ["Mega|Fly|Ride"] = 575.74}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 20.99, ["Ride"] = 16.87, ["Fly|Ride"] = 40.4, ["Neon"] = 51.24, ["Neon|Ride"] = 36.24, ["Neon|Fly|Ride"] = 50.74, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 9.1, ["Ride"] = 78.75, ["Fly|Ride"] = 146.57, ["Neon"] = 63.98, ["Neon|Ride"] = 91.88, ["Mega|Ride"] = 431.72}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Fly|Ride"] = 109.5, ["Neon"] = 11.84, ["Neon|Ride"] = 51.82, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.67, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 244.26}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 22.32, ["Fly"] = 26.25, ["Ride"] = 24.71, ["Fly|Ride"] = 45.94, ["Neon"] = 115.76, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 153.79, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 35.54, ["Fly"] = 874.13, ["Neon"] = 118.13, ["Mega"] = 278.88, ["Mega|Fly"] = 647.59, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 729.17}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 51.96, ["Fly"] = 86.62, ["Ride"] = 79.9, ["Fly|Ride"] = 215.87, ["Neon"] = 263.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 1954.12, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 33.78, ["Fly"] = 144.64, ["Ride"] = 76.13, ["Fly|Ride"] = 236.92, ["Neon"] = 125.89, ["Neon|Ride"] = 168, ["Neon|Fly|Ride"] = 315, ["Mega"] = 502.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.92, ["Ride"] = 32.71, ["Neon"] = 139.79, ["Neon|Ride"] = 223.12, ["Mega"] = 502.69, ["Mega|Ride"] = 625.24, ["Mega|Fly|Ride"] = 823.34}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 38.87, ["Fly"] = 65.63, ["Ride"] = 98.44, ["Fly|Ride"] = 144.38, ["Neon"] = 210.1, ["Neon|Fly"] = 318.34, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 483.52, ["Mega"] = 738.25, ["Mega|Ride"] = 560.12, ["Mega|Fly|Ride"] = 662.7}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 15.75, ["Fly|Ride"] = 32.82, ["Neon"] = 3.18, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 43.52, ["Mega|Fly"] = 326.06, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 146.99}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 98.44, ["Ride"] = 149.43, ["Fly|Ride"] = 374.22, ["Neon"] = 508.11, ["Neon|Ride"] = 576.52, ["Neon|Fly|Ride"] = 849.41, ["Mega"] = 2046.35, ["Mega|Ride"] = 1647.74, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 76.6, ["Neon"] = 3.84, ["Neon|Fly"] = 101.47, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 302.22, ["Mega"] = 37.68, ["Mega|Ride"] = 87.95, ["Mega|Fly|Ride"] = 150.94}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 25.91, ["Ride"] = 78.75, ["Fly|Ride"] = 215.87, ["Neon"] = 118.13, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 395.07, ["Mega"] = 591.93, ["Mega|Ride"] = 570.6, ["Mega|Fly|Ride"] = 604.42}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.15, ["Neon|Fly|Ride"] = 144.64, ["Mega"] = 19.71}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.94, ["Mega"] = 23.48, ["Mega|Ride"] = 112.73, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 91.88, ["Fly"] = 1800.27, ["Ride"] = 150.39, ["Neon"] = 594.8, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 551.25, ["Mega|Ride"] = 6717.48, ["Mega|Fly|Ride"] = 2056.91}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 21.6, ["Fly|Ride"] = 66.94, ["Neon"] = 7.24, ["Neon|Fly"] = 43.19, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.87, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 37.3, ["Fly|Ride"] = 65.63, ["Neon"] = 3.42, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 34.81, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Ride"] = 41.35, ["Neon"] = 20.99, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 140.14, ["Mega|Fly|Ride"] = 489.57}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 15.06, ["Neon|Ride"] = 43.19, ["Mega"] = 115.99}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.17, ["Ride"] = 131.25, ["Fly|Ride"] = 360.51, ["Neon"] = 426.57, ["Neon|Ride"] = 568.4, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 2916.38}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 10.19, ["Mega"] = 418.06, ["Mega|Ride"] = 373.19, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.49, ["Ride"] = 431.81, ["Fly|Ride"] = 786.54, ["Neon"] = 1069.69, ["Neon|Ride"] = 1295.16, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 76.13}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 51.07}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 32.42}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.69}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 49.26}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.81}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 17.06}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 7.46}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.92}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 37.79}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 65.63}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 8.46}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 12.78}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 897.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.88}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 5.83}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.29}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 39.38}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 695.63}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 473.49}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 11.82}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1430.63}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.47}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.15}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 29.58}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 21}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 61.58}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 21}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.65}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.23}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 50.75}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.63}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 12.91}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 18.33}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.2}},
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
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 274.21}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.93}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 3.94}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.59}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 28.37}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.19}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 254.66}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 12.57}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 154.4}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 41.91}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.62}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 28.88}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 8.17}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 6.49}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 31.78}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 8.91}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.83}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.8}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.94}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.87}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 91.32}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 308.74}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.15}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 325.97}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.69}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 92.57}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 20.99}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24304.56}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.53}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 62.62}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 31.48}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 59.07}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 29.59}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 45.93}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 122.75}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 31.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 106.76}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.44}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 57.42}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 247.06}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 6.57}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.03}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 26.25}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 148.31}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.1}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.86}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 9.19}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 19.84}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 208.69}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.81}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 8.5}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.87}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 10.5}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 32.82}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 32.47}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 71.31}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.63}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.46}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 5.86}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 9.96}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.01}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 3.93}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 9.79}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.05}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 128.64}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 30.85}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 203.81}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 10.65}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 11.81}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 11.58}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.24}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 27.57}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 5.24}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 7.88}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 9.19}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.33}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 29.14}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 13.76}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 6.57}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 5.92}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 5.25}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 5.25}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.42}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.68}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.54}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 6825}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.49}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 16.7}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.24}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.5}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.74}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.93}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.31}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 3.98}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.29}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 41.45}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.92}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.43}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.01}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 3.29}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3937.5}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 16.06}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 31.5}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.26}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 79.71}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 6.57}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 8.66}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 6.36}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.49}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 37.67}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.27}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.55}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.83}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.67}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.94}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 20.06}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.52}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 5.97}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.39}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 102.72}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 102.38}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.45}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.3}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1345.31}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 76.13}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 34.13}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.74}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.58}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 17.07}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14.44}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.13}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.29}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 3.81}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 12.49}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 3.94}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 15.33}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 4.31}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 6.56}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 84.89}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.84}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 6.36}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 421.32}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.83}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 14.39}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 25.7}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 18.59}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 4.9}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 4.61}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.56}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 144.64}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 153.56}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 12.98}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1017.19}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 4.34}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 192.94}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.19}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 56.44}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.63}},
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
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.18}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 61.3}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 108.25}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 65.62}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.68}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 11.55}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.92}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 6.57}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 76.13}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.21}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 52.74}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 53.82}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 94.05}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 5.25}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 57.75}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 4.86}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 6.56}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 38.59}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 57.75}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.7}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 29.16}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.48}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.24}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 17.19}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 39.38}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 5.25}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 12.59}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 34.8}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 28.34}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 29.58}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 89.13}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 23.63}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.13}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 8.51}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 26.24}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.34}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.01}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.77}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 30.35}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 6.2}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 14.33}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 301.88}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 70.88}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 47.13}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 51.19}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 164.04}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 91.49}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1018.69}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 182.44}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 6.03}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 1692.88}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 573.57}},
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