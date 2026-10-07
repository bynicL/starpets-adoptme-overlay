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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 983.07, ["Ride"] = 1179.92, ["Fly|Ride"] = 1767.5, ["Neon"] = 6994.54, ["Neon|Fly|Ride"] = 5162.75, ["Mega"] = 22096.23, ["Mega|Fly|Ride"] = 22096.23}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 525, ["Ride"] = 523.94, ["Fly|Ride"] = 712.52, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 8587.81}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4462.5, ["Fly"] = 4396.88, ["Ride"] = 5250, ["Fly|Ride"] = 4462.5, ["Neon|Fly|Ride"] = 19148.56, ["Mega|Fly|Ride"] = 78064.53}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 209.9, ["Ride"] = 262.5, ["Fly|Ride"] = 413.17, ["Neon"] = 1166.6, ["Neon|Ride"] = 984.38, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 4829.3}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 632.63, ["Fly"] = 883.86, ["Ride"] = 472.5, ["Fly|Ride"] = 630, ["Neon|Fly|Ride"] = 1616.99, ["Mega|Fly|Ride"] = 4987.5}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9, ["Ride"] = 58.97, ["Fly|Ride"] = 129.94, ["Neon"] = 87.49, ["Neon|Ride"] = 98.33, ["Neon|Fly|Ride"] = 331.46, ["Mega"] = 353.75, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 568.32}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 5.02, ["Fly"] = 44.2, ["Ride"] = 27.43, ["Fly|Ride"] = 65.52, ["Neon"] = 29.27, ["Neon|Fly"] = 132.21, ["Neon|Ride"] = 60.38, ["Neon|Fly|Ride"] = 135.19, ["Mega"] = 206.59, ["Mega|Ride"] = 218.7, ["Mega|Fly|Ride"] = 299.25}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 97.13, ["Fly"] = 220.95, ["Ride"] = 131.38, ["Fly|Ride"] = 220.89, ["Neon"] = 425.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 1181.25, ["Mega"] = 1586.82, ["Mega|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 1767.5}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.5, ["Fly"] = 58.56, ["Ride"] = 48.57, ["Fly|Ride"] = 116.81, ["Neon"] = 275.62, ["Neon|Ride"] = 231.55, ["Neon|Fly|Ride"] = 308.44, ["Mega"] = 2100, ["Mega|Ride"] = 1178.71, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 24.73, ["Fly"] = 72.19, ["Ride"] = 37.14, ["Fly|Ride"] = 76.13, ["Neon"] = 262.5, ["Neon|Ride"] = 219.84, ["Neon|Fly|Ride"] = 210, ["Mega"] = 662.82, ["Mega|Fly|Ride"] = 610.71}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 80.07, ["Ride"] = 90.54, ["Fly|Ride"] = 259.88, ["Neon"] = 402.8, ["Neon|Ride"] = 321.57, ["Neon|Fly|Ride"] = 442.19, ["Mega|Fly|Ride"] = 2357.4}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 65.63}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 361.49, ["Fly"] = 497.07, ["Ride"] = 358.94, ["Fly|Ride"] = 409.86, ["Neon|Ride"] = 1767.5, ["Neon|Fly|Ride"] = 1286.25, ["Mega"] = 3680.82, ["Mega|Fly|Ride"] = 5043.94}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 140.43, ["Fly"] = 214.81, ["Ride"] = 131.25, ["Fly|Ride"] = 175.87, ["Neon|Fly"] = 699.37, ["Neon|Fly|Ride"] = 577.5, ["Mega"] = 4312.63, ["Mega|Fly|Ride"] = 2467.5}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.77, ["Fly"] = 80.66, ["Ride"] = 65.63, ["Fly|Ride"] = 167.35, ["Neon"] = 28.73, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 260.79, ["Mega"] = 184.49, ["Mega|Fly"] = 393.75, ["Mega|Ride"] = 327.6, ["Mega|Fly|Ride"] = 399.65}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 234.93, ["Fly"] = 292.69, ["Ride"] = 243.97, ["Fly|Ride"] = 295.61, ["Neon|Fly"] = 882.66, ["Neon|Ride"] = 1166.44, ["Neon|Fly|Ride"] = 820.68, ["Mega|Fly|Ride"] = 2751}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.38, ["Fly"] = 28.73, ["Ride"] = 21, ["Fly|Ride"] = 45.17, ["Neon"] = 28.88, ["Neon|Fly"] = 132.59, ["Neon|Ride"] = 72.84, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 170.63, ["Mega|Ride"] = 314.72, ["Mega|Fly|Ride"] = 401.49}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 144.34, ["Fly"] = 333.38, ["Ride"] = 183.74, ["Fly|Ride"] = 309.33, ["Neon"] = 524.99, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 656.12, ["Mega"] = 1832.07, ["Mega|Ride"] = 1574.9, ["Mega|Fly|Ride"] = 1832.07}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 43.29}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 85.31, ["Ride"] = 183.75, ["Fly|Ride"] = 249.78, ["Neon"] = 577.5, ["Neon|Fly|Ride"] = 787.5, ["Mega|Fly|Ride"] = 1767.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 34.13, ["Fly"] = 59.68, ["Ride"] = 58.45, ["Fly|Ride"] = 220.95, ["Neon"] = 173.25, ["Neon|Ride"] = 255.93, ["Neon|Fly|Ride"] = 383.34, ["Mega"] = 2870.59, ["Mega|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 1028.47}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 39.17, ["Fly"] = 110.49, ["Ride"] = 55.86, ["Fly|Ride"] = 115.5, ["Neon"] = 216.45, ["Neon|Ride"] = 190.03, ["Neon|Fly|Ride"] = 277.81, ["Mega"] = 1748.65, ["Mega|Fly|Ride"] = 954.57}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 43.19, ["Fly"] = 148.04, ["Ride"] = 85.32, ["Fly|Ride"] = 196.88, ["Neon"] = 210, ["Neon|Ride"] = 413.17, ["Neon|Fly|Ride"] = 311.85, ["Mega"] = 1967.44, ["Mega|Ride"] = 1767.5, ["Mega|Fly|Ride"] = 1590.75}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 30.87, ["Ride"] = 56.73, ["Fly|Ride"] = 118.23, ["Neon"] = 210, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 1207.92, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 50.47, ["Fly"] = 102.38, ["Ride"] = 71.97, ["Fly|Ride"] = 133.67, ["Neon"] = 210, ["Neon|Ride"] = 340.77, ["Neon|Fly|Ride"] = 304.5, ["Mega|Ride"] = 1166.6, ["Mega|Fly|Ride"] = 937.13}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 7.77, ["Fly"] = 32.46, ["Ride"] = 24.44, ["Fly|Ride"] = 55.27, ["Neon"] = 74.06, ["Neon|Fly"] = 280.87, ["Neon|Ride"] = 48.18, ["Neon|Fly|Ride"] = 96.15, ["Mega"] = 157.5, ["Mega|Fly"] = 27774.46, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 305.95}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 420, ["Fly"] = 551.25, ["Ride"] = 411.65, ["Fly|Ride"] = 505.45, ["Neon|Ride"] = 1689.18, ["Neon|Fly|Ride"] = 1966.13, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 9909.75}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 13.12, ["Ride"] = 31.49, ["Fly|Ride"] = 130.2, ["Neon"] = 90.57, ["Neon|Fly|Ride"] = 450.78, ["Mega|Ride"] = 413.21, ["Mega|Fly|Ride"] = 671.66}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 8.31, ["Fly"] = 43.22, ["Ride"] = 21, ["Fly|Ride"] = 43.26, ["Neon"] = 65.62, ["Neon|Ride"] = 74.07, ["Neon|Fly|Ride"] = 129.93, ["Mega|Ride"] = 441.89, ["Mega|Fly|Ride"] = 444.93}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 83.13, ["Fly"] = 85.32, ["Ride"] = 85.32, ["Fly|Ride"] = 124.06, ["Neon"] = 393.75, ["Neon|Ride"] = 499.55, ["Neon|Fly|Ride"] = 400.6, ["Mega"] = 6613.55, ["Mega|Ride"] = 5832.75, ["Mega|Fly|Ride"] = 1655.94}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 13.01, ["Ride"] = 32.07, ["Fly|Ride"] = 77.35, ["Neon"] = 91.88, ["Neon|Ride"] = 115.08, ["Neon|Fly|Ride"] = 267.86, ["Mega"] = 720.57, ["Mega|Ride"] = 749.33, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 236.25, ["Fly"] = 300.68, ["Ride"] = 271.2, ["Fly|Ride"] = 333.46, ["Neon"] = 772.2, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 752.46, ["Mega"] = 2872.2, ["Mega|Ride"] = 2763.52, ["Mega|Fly|Ride"] = 2947.29}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 22.08}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.78, ["Fly"] = 26.25, ["Ride"] = 24.76, ["Fly|Ride"] = 56.72, ["Neon"] = 25.09, ["Neon|Fly"] = 148.07, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 132.59, ["Mega"] = 148.32, ["Mega|Fly"] = 498.31, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 288.63}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1048.69, ["Fly"] = 2625, ["Ride"] = 1141.67, ["Fly|Ride"] = 1312.5, ["Neon"] = 9187.5, ["Neon|Ride"] = 6334.26, ["Neon|Fly|Ride"] = 6185.12, ["Mega|Ride"] = 56163.24, ["Mega|Fly|Ride"] = 19133.1}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 18.52, ["Fly"] = 55.4, ["Ride"] = 52.5, ["Fly|Ride"] = 105.99, ["Neon"] = 194.91, ["Neon|Ride"] = 271.77, ["Neon|Fly|Ride"] = 291.98, ["Mega"] = 1043.44, ["Mega|Ride"] = 1134.53, ["Mega|Fly|Ride"] = 820.32}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 196.87, ["Fly"] = 374.68, ["Ride"] = 236.25, ["Fly|Ride"] = 308.74, ["Neon"] = 945, ["Neon|Ride"] = 978.8, ["Neon|Fly|Ride"] = 1030.32, ["Mega"] = 4301.64, ["Mega|Ride"] = 6074.25, ["Mega|Fly|Ride"] = 4044.5}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 37.17}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 12.87, ["Fly"] = 86.8, ["Ride"] = 119.44, ["Fly|Ride"] = 148.07, ["Neon"] = 65.63, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 417.19, ["Mega"] = 586.62, ["Mega|Ride"] = 589.98, ["Mega|Fly|Ride"] = 666.9}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 117.17, ["Fly"] = 163.89, ["Ride"] = 144.08, ["Fly|Ride"] = 206.59, ["Neon"] = 689.37, ["Neon|Ride"] = 540.75, ["Neon|Fly|Ride"] = 705.9, ["Mega|Ride"] = 2333.19, ["Mega|Fly|Ride"] = 1811.24}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 111.57, ["Fly"] = 250.08, ["Ride"] = 147, ["Fly|Ride"] = 240.19, ["Neon"] = 423.62, ["Neon|Fly"] = 833.12, ["Neon|Ride"] = 434.79, ["Neon|Fly|Ride"] = 497.44, ["Mega|Ride"] = 1509.38, ["Mega|Fly|Ride"] = 1440.77}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 38.04}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 50.46, ["Fly"] = 62.99, ["Ride"] = 47.37, ["Fly|Ride"] = 77.97, ["Neon|Ride"] = 405.43, ["Neon|Fly|Ride"] = 365.24, ["Mega"] = 4419.26, ["Mega|Fly|Ride"] = 1561.77}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 7.77, ["Ride"] = 55.21, ["Fly|Ride"] = 211.01, ["Neon"] = 49.97, ["Neon|Fly"] = 223.13, ["Neon|Ride"] = 145.84, ["Neon|Fly|Ride"] = 248.57, ["Mega"] = 232.32, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 258.51, ["Mega|Fly|Ride"] = 441.94}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 603.75, ["Fly"] = 735.83, ["Ride"] = 589.77, ["Fly|Ride"] = 630.27, ["Neon"] = 1968.75, ["Neon|Fly"] = 3977.33, ["Neon|Ride"] = 3888.14, ["Neon|Fly|Ride"] = 2118.38, ["Mega|Ride"] = 15465.55, ["Mega|Fly|Ride"] = 7481.25}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 124.67, ["Fly"] = 170.63, ["Ride"] = 145.84, ["Fly|Ride"] = 204.75, ["Neon"] = 658.16, ["Neon|Ride"] = 577.83, ["Neon|Fly|Ride"] = 666.9, ["Mega"] = 2872.2, ["Mega|Fly|Ride"] = 2296.88}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3766.88, ["Ride"] = 3885, ["Fly|Ride"] = 3937.5}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 72.19, ["Fly"] = 236.45, ["Ride"] = 91.85, ["Fly|Ride"] = 201.68, ["Neon|Ride"] = 333.46, ["Neon|Fly|Ride"] = 640.74, ["Mega|Ride"] = 2065.76, ["Mega|Fly|Ride"] = 2100}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 78.75, ["Ride"] = 81.12, ["Fly|Ride"] = 105, ["Neon"] = 575.75, ["Neon|Ride"] = 552.42, ["Neon|Fly|Ride"] = 441.89, ["Mega"] = 6481.94, ["Mega|Ride"] = 2388.75, ["Mega|Fly|Ride"] = 2528.79}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 37.57, ["Fly"] = 64.66, ["Ride"] = 44.97, ["Fly|Ride"] = 104.99, ["Neon"] = 117.24, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 140.43, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 2625, ["Mega|Ride"] = 944.52, ["Mega|Fly|Ride"] = 589.92}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 4.43}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 49.88, ["Fly"] = 52.5, ["Ride"] = 66.91, ["Fly|Ride"] = 133.65, ["Neon|Ride"] = 333.46, ["Neon|Fly|Ride"] = 446.25, ["Mega|Ride"] = 1332.54, ["Mega|Fly|Ride"] = 1395.22}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 34.77}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 185.07, ["Ride"] = 194.25, ["Fly|Ride"] = 282.19, ["Neon"] = 1178.71, ["Neon|Ride"] = 1166.44, ["Neon|Fly|Ride"] = 1323.44, ["Mega|Fly|Ride"] = 4995.39}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 787.49, ["Fly"] = 826.31, ["Ride"] = 721.87, ["Fly|Ride"] = 720.57, ["Neon"] = 2625, ["Neon|Ride"] = 3092.02, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 12225.52}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 6.3}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 32.82, ["Fly"] = 62.25, ["Ride"] = 42.44, ["Fly|Ride"] = 65.54, ["Neon"] = 192.94, ["Neon|Fly"] = 287.24, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 218.29, ["Mega|Ride"] = 1192.59, ["Mega|Fly|Ride"] = 748.12}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 23.62}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5250, ["Fly"] = 7365.8, ["Ride"] = 6113.31, ["Fly|Ride"] = 4812.93, ["Neon|Ride"] = 18320.66, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 44132.92}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 15.53, ["Fly"] = 148.04, ["Ride"] = 26.25, ["Fly|Ride"] = 53.82, ["Neon"] = 89.65, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 157.4, ["Mega"] = 561.75, ["Mega|Ride"] = 490.88, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 10.4, ["Fly"] = 144.74, ["Ride"] = 39.98, ["Fly|Ride"] = 123.64, ["Neon"] = 95.82, ["Neon|Ride"] = 139.22, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 994.23, ["Mega|Ride"] = 511.88, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 65.63, ["Fly"] = 117.11, ["Ride"] = 58.16, ["Fly|Ride"] = 131.25, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 485.82, ["Mega"] = 4419.26, ["Mega|Fly|Ride"] = 1832.07}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 12.98, ["Fly"] = 74.05, ["Ride"] = 36.39, ["Fly|Ride"] = 66.3, ["Neon"] = 97.13, ["Neon|Fly"] = 220.95, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 501.38, ["Mega"] = 552.36, ["Mega|Ride"] = 816.76, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 1673.44, ["Fly"] = 1837.5, ["Ride"] = 1915.53, ["Fly|Ride"] = 1758.75, ["Neon|Fly|Ride"] = 3261.57, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 35353.96, ["Ride"] = 52500, ["Fly|Ride"] = 25265.63, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63000, ["Mega|Fly|Ride"] = 183748.69}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 19.04, ["Fly"] = 393.75, ["Ride"] = 54.79, ["Fly|Ride"] = 120.75, ["Neon"] = 150.43, ["Neon|Ride"] = 441.94, ["Neon|Fly|Ride"] = 265.14, ["Mega"] = 772.2, ["Mega|Ride"] = 1331.71, ["Mega|Fly|Ride"] = 768.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 4.2, ["Fly"] = 124.84, ["Ride"] = 49.96, ["Fly|Ride"] = 132.58, ["Neon"] = 19.67, ["Neon|Fly"] = 236.41, ["Neon|Ride"] = 79.22, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 163.41, ["Mega|Fly"] = 399.65, ["Mega|Ride"] = 245.28, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 23.26}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 8.97, ["Ride"] = 37.26, ["Fly|Ride"] = 167.45, ["Neon"] = 58.07, ["Neon|Ride"] = 108.94, ["Neon|Fly|Ride"] = 277.1, ["Mega"] = 436.36, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 560.01}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 656.25, ["Ride"] = 623.44, ["Fly|Ride"] = 724.49, ["Neon"] = 3162.64, ["Neon|Ride"] = 2362.5, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9610.74}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 941.07, ["Fly"] = 951.57, ["Ride"] = 871.5, ["Fly|Ride"] = 850.5, ["Neon|Ride"] = 3388.07, ["Neon|Fly|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 13987.07}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 13.13, ["Fly"] = 124.91, ["Ride"] = 32.68, ["Fly|Ride"] = 73.5, ["Neon"] = 87.94, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 162.75, ["Mega"] = 514.85, ["Mega|Ride"] = 481.9, ["Mega|Fly|Ride"] = 523.69}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 27.26}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 64.31, ["Fly"] = 118.13, ["Ride"] = 85.31, ["Fly|Ride"] = 118.13, ["Neon"] = 587.71, ["Neon|Ride"] = 426.57, ["Neon|Fly|Ride"] = 420, ["Mega"] = 19687.5, ["Mega|Ride"] = 2063.8, ["Mega|Fly|Ride"] = 2164.1}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 85.79, ["Ride"] = 127.05, ["Fly|Ride"] = 157.49, ["Neon"] = 450.19, ["Neon|Ride"] = 488.38, ["Neon|Fly|Ride"] = 509.15, ["Mega"] = 1437.81, ["Mega|Fly|Ride"] = 2158.95}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 6.46, ["Fly"] = 44.2, ["Ride"] = 24.31, ["Fly|Ride"] = 53.36, ["Neon"] = 49.88, ["Neon|Fly"] = 488.69, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 116.65, ["Mega|Fly|Ride"] = 363.36}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 196.87, ["Fly"] = 224.44, ["Ride"] = 203.44, ["Fly|Ride"] = 272.87, ["Neon|Ride"] = 648.38, ["Neon|Fly|Ride"] = 727.65, ["Mega"] = 5303.1, ["Mega|Fly|Ride"] = 2619.75}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 6.49, ["Ride"] = 51.23, ["Fly|Ride"] = 141.42, ["Neon"] = 47.25, ["Neon|Ride"] = 167.35, ["Mega"] = 250.79, ["Mega|Fly"] = 1137.94, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 586.61}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 12.85, ["Fly"] = 65.63, ["Ride"] = 32.81, ["Fly|Ride"] = 78.75, ["Neon"] = 126, ["Neon|Fly"] = 333.51, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 169.21, ["Mega"] = 1050, ["Mega|Fly|Ride"] = 816.38}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 28.2, ["Ride"] = 55.47, ["Fly|Ride"] = 156.19, ["Neon"] = 250.79, ["Neon|Ride"] = 215.42, ["Mega"] = 997.5, ["Mega|Ride"] = 853.13, ["Mega|Fly|Ride"] = 1011.85}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 17.96, ["Fly"] = 90.61, ["Ride"] = 40.31, ["Fly|Ride"] = 84.46, ["Neon"] = 131.25, ["Neon|Ride"] = 326.72, ["Neon|Fly|Ride"] = 353.55, ["Mega"] = 1288.22, ["Mega|Fly|Ride"] = 877.13}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6785.63, ["Ride"] = 5643.75, ["Fly|Ride"] = 5765.82, ["Neon"] = 33144.33, ["Neon|Fly|Ride"] = 30784.17}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 225.75, ["Fly"] = 314.99, ["Ride"] = 223.13, ["Fly|Ride"] = 311.79, ["Neon|Fly|Ride"] = 592.52, ["Mega|Fly|Ride"] = 2169.57}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 70.88, ["Fly"] = 286.5, ["Ride"] = 124.22, ["Fly|Ride"] = 249.38, ["Neon"] = 190.03, ["Neon|Fly"] = 309.33, ["Neon|Ride"] = 233.89, ["Neon|Fly|Ride"] = 376.82, ["Mega"] = 582.31, ["Mega|Ride"] = 555.19, ["Mega|Fly|Ride"] = 652.32}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 2.61, ["Fly"] = 92.45, ["Ride"] = 35.05, ["Fly|Ride"] = 81.37, ["Neon"] = 23.63, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 195.88, ["Mega"] = 499.8, ["Mega|Ride"] = 330.75, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 64.87, ["Fly"] = 215.34, ["Ride"] = 123.73, ["Fly|Ride"] = 222.18, ["Neon"] = 210, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 452.82, ["Mega"] = 502.26, ["Mega|Fly"] = 751.2, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 16773.75, ["Ride"] = 13415.07, ["Fly|Ride"] = 11156.25, ["Neon|Fly|Ride"] = 24766.88, ["Mega|Fly|Ride"] = 110334.14}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 336, ["Ride"] = 392.44, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1655.94, ["Neon|Fly|Ride"] = 1694.59, ["Mega|Fly|Ride"] = 7659.87}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 59.06, ["Fly"] = 90.5, ["Ride"] = 57.73, ["Fly|Ride"] = 108.94, ["Neon"] = 288.75, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 368.5, ["Mega|Fly|Ride"] = 2061.35}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 8.38, ["Ride"] = 23.39, ["Fly|Ride"] = 52.5, ["Neon"] = 67.82, ["Neon|Fly"] = 283.56, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 2627.68, ["Mega|Ride"] = 749.33, ["Mega|Fly|Ride"] = 1104.83}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 393.74, ["Ride"] = 426.57, ["Fly|Ride"] = 538.13, ["Neon"] = 1756.47, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1312.49, ["Mega|Fly|Ride"] = 4547.82}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 5.86, ["Ride"] = 32.82, ["Fly|Ride"] = 227.57, ["Neon"] = 32.09, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 180.08, ["Mega"] = 155.93, ["Mega|Fly"] = 263.92, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 282.19}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 105, ["Fly"] = 206.61, ["Ride"] = 149.87, ["Fly|Ride"] = 210, ["Neon"] = 465.94, ["Neon|Fly"] = 525, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 546, ["Mega|Fly|Ride"] = 2418.29}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13.26, ["Fly"] = 19.45, ["Ride"] = 18.18, ["Fly|Ride"] = 42.74, ["Neon|Ride"] = 196.87, ["Neon|Fly|Ride"] = 93.19, ["Mega"] = 2651.56, ["Mega|Fly|Ride"] = 633.18}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 10.4}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 72.02, ["Ride"] = 87.94, ["Fly|Ride"] = 176.76, ["Neon"] = 244.12, ["Neon|Fly"] = 551.25, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 441.89, ["Mega|Ride"] = 2061.35, ["Mega|Fly|Ride"] = 1650.41}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 14.44, ["Fly"] = 299.74, ["Ride"] = 38.56, ["Fly|Ride"] = 98.96, ["Neon"] = 85.32, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 531.57, ["Mega|Ride"] = 577.5, ["Mega|Fly|Ride"] = 1325.63}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 43.31}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 78.75, ["Fly"] = 148.04, ["Ride"] = 131.25, ["Fly|Ride"] = 441.89, ["Neon"] = 392.44, ["Neon|Ride"] = 445.44, ["Neon|Fly|Ride"] = 669.38, ["Mega|Ride"] = 1665.98, ["Mega|Fly|Ride"] = 2182.79}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 6.48, ["Fly|Ride"] = 142.38, ["Neon"] = 32.03, ["Neon|Ride"] = 144.74, ["Neon|Fly|Ride"] = 295, ["Mega"] = 163.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 333.51}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 13.01, ["Fly"] = 56.42, ["Ride"] = 31.38, ["Fly|Ride"] = 87.93, ["Neon"] = 131.25, ["Neon|Ride"] = 126.06, ["Neon|Fly|Ride"] = 219.84, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 586.69}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 499.55, ["Ride"] = 529.11, ["Fly|Ride"] = 498.75, ["Neon|Fly|Ride"] = 2842.03, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 52.47, ["Fly"] = 110.49, ["Ride"] = 77.55, ["Fly|Ride"] = 103.85, ["Neon"] = 195.57, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 776.43, ["Mega|Ride"] = 681.45, ["Mega|Fly|Ride"] = 832.99}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 49.87, ["Fly"] = 146.63, ["Ride"] = 78.66, ["Fly|Ride"] = 147.4, ["Neon"] = 270.38, ["Neon|Ride"] = 232.05, ["Neon|Fly|Ride"] = 331.42, ["Mega|Ride"] = 1099.7, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 19.28, ["Fly"] = 88.38, ["Ride"] = 65.62, ["Fly|Ride"] = 142.41, ["Neon"] = 85.32, ["Neon|Ride"] = 228.15, ["Neon|Fly|Ride"] = 262.79, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 9843.75, ["Fly"] = 10494.49, ["Ride"] = 7612.5, ["Fly|Ride"] = 8334.38, ["Neon|Fly|Ride"] = 13781.25, ["Mega|Fly|Ride"] = 38850}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1351.88, ["Fly"] = 1517.02, ["Ride"] = 1606.36, ["Fly|Ride"] = 1404.38, ["Neon|Fly|Ride"] = 3726.18, ["Mega|Fly|Ride"] = 15987.49}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 492.19, ["Ride"] = 459.38, ["Fly|Ride"] = 796.69, ["Neon"] = 2253.58, ["Neon|Fly|Ride"] = 3084.38, ["Mega"] = 22096.23, ["Mega|Fly|Ride"] = 8837.47}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 11.82, ["Fly"] = 28.48, ["Ride"] = 19.28, ["Fly|Ride"] = 39.38, ["Neon"] = 139.13, ["Neon|Ride"] = 106.09, ["Neon|Fly|Ride"] = 131.25, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.57, ["Fly"] = 78.74, ["Ride"] = 26.25, ["Fly|Ride"] = 203.28, ["Neon"] = 25.97, ["Neon|Ride"] = 63.74, ["Mega"] = 164.06, ["Mega|Ride"] = 204.49, ["Mega|Fly|Ride"] = 396.38}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 31.5, ["Fly"] = 59.98, ["Ride"] = 55.13, ["Fly|Ride"] = 100.38, ["Neon"] = 244.15, ["Neon|Ride"] = 156.19, ["Neon|Fly|Ride"] = 174.28, ["Mega|Fly|Ride"] = 660.09}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.76, ["Fly"] = 30.7, ["Ride"] = 19.6, ["Fly|Ride"] = 51.49, ["Neon"] = 43.82, ["Neon|Fly"] = 85.76, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 90.57, ["Mega"] = 325.9, ["Mega|Ride"] = 369.03, ["Mega|Fly|Ride"] = 246.23}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 327.49, ["Fly"] = 430.5, ["Ride"] = 320.95, ["Fly|Ride"] = 400.32, ["Neon"] = 1103.6, ["Neon|Ride"] = 1221.81, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 4480.92}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 19.63, ["Fly"] = 72.29, ["Ride"] = 44.63, ["Fly|Ride"] = 78.74, ["Neon"] = 144.38, ["Neon|Fly"] = 407.29, ["Neon|Ride"] = 187.01, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 1083.84, ["Mega|Fly"] = 932.9, ["Mega|Ride"] = 576.98, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.75, ["Fly"] = 21.93, ["Ride"] = 20.99, ["Fly|Ride"] = 45.92, ["Neon"] = 86.18, ["Neon|Fly"] = 124.87, ["Neon|Ride"] = 123.67, ["Neon|Fly|Ride"] = 119.61, ["Mega"] = 1575, ["Mega|Ride"] = 451.5, ["Mega|Fly|Ride"] = 423.94}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 445.69, ["Fly"] = 1048.69, ["Ride"] = 367.5, ["Fly|Ride"] = 883.86, ["Mega|Fly|Ride"] = 9971.07}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1115.63, ["Fly"] = 1473.84, ["Ride"] = 1155, ["Fly|Ride"] = 1181.25, ["Neon"] = 5359.58, ["Neon|Ride"] = 4860.61, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 13782.3}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 148.04, ["Fly"] = 148.07, ["Ride"] = 106.61, ["Fly|Ride"] = 118.44, ["Neon"] = 607.59, ["Neon|Ride"] = 515.91, ["Neon|Fly|Ride"] = 498.75, ["Mega|Ride"] = 2636.9, ["Mega|Fly|Ride"] = 2914.82}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 186.14, ["Fly"] = 196.88, ["Ride"] = 203.44, ["Fly|Ride"] = 261.19, ["Neon"] = 983.18, ["Neon|Ride"] = 692.66, ["Neon|Fly|Ride"] = 677.25, ["Mega|Ride"] = 9187.5, ["Mega|Fly|Ride"] = 2892.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 23.63, ["Fly"] = 127.05, ["Ride"] = 54.66, ["Fly|Ride"] = 95.64, ["Neon"] = 252.1, ["Neon|Ride"] = 240.56, ["Mega|Ride"] = 2209.64, ["Mega|Fly|Ride"] = 1111.69}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 242.71, ["Ride"] = 646.14, ["Fly|Ride"] = 501.55, ["Neon"] = 1220.63, ["Neon|Fly|Ride"] = 1325.63, ["Mega|Fly|Ride"] = 5892.39}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1968.75, ["Ride"] = 2482.1, ["Fly|Ride"] = 2096.95, ["Neon"] = 11048.12, ["Neon|Fly|Ride"] = 11046.82, ["Mega|Fly|Ride"] = 50821.31}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 50.06, ["Fly"] = 220.95, ["Ride"] = 52.41, ["Fly|Ride"] = 196.88, ["Neon"] = 288.75, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 343.88, ["Mega|Ride"] = 2430.6, ["Mega|Fly|Ride"] = 1451.57}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 603.74, ["Fly"] = 883.86, ["Ride"] = 619.46, ["Fly|Ride"] = 643.13, ["Neon"] = 1502.38, ["Neon|Ride"] = 1498.88, ["Neon|Fly|Ride"] = 1299.37, ["Mega|Fly|Ride"] = 3680.82}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 45.93, ["Fly"] = 65.51, ["Ride"] = 57.73, ["Fly|Ride"] = 81.54, ["Neon"] = 441.94, ["Neon|Ride"] = 334.69, ["Neon|Fly|Ride"] = 234.94, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.9, ["Fly"] = 24.94, ["Ride"] = 19.68, ["Fly|Ride"] = 71.65, ["Neon"] = 38.07, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 115.65, ["Mega"] = 183.75, ["Mega|Fly"] = 249.38, ["Mega|Ride"] = 170.62, ["Mega|Fly|Ride"] = 244.38}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 65.63, ["Ride"] = 86.18, ["Fly|Ride"] = 157.5, ["Neon"] = 285.76, ["Neon|Ride"] = 481.47, ["Neon|Fly|Ride"] = 736.84, ["Mega"] = 1620.59, ["Mega|Ride"] = 1767.5, ["Mega|Fly|Ride"] = 1753.15}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 1047.66, ["Fly"] = 1214.07, ["Ride"] = 1043.44, ["Fly|Ride"] = 1115.63, ["Neon|Ride"] = 3534.99, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13993.02}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 654.94, ["Ride"] = 828.53, ["Fly|Ride"] = 913.59, ["Neon|Fly|Ride"] = 4417.64, ["Mega|Fly|Ride"] = 20621.1}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.13, ["Fly"] = 26.25, ["Ride"] = 22.05, ["Fly|Ride"] = 43.72, ["Neon"] = 131.25, ["Neon|Fly"] = 88.38, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 157.49, ["Mega|Fly|Ride"] = 777.34}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 18.18, ["Ride"] = 24.94, ["Fly|Ride"] = 132.58, ["Neon"] = 163.5, ["Neon|Ride"] = 151.7, ["Neon|Fly|Ride"] = 231, ["Mega"] = 916.68, ["Mega|Ride"] = 1029.58, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 3.84, ["Fly"] = 70.88, ["Ride"] = 28.75, ["Fly|Ride"] = 100.54, ["Neon"] = 24.75, ["Neon|Fly"] = 326.27, ["Neon|Ride"] = 64.29, ["Neon|Fly|Ride"] = 192.23, ["Mega"] = 131.25, ["Mega|Fly"] = 583.3, ["Mega|Ride"] = 209.99, ["Mega|Fly|Ride"] = 481.69}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 44.2, ["Fly"] = 88.38, ["Ride"] = 53.69, ["Fly|Ride"] = 142.7, ["Neon"] = 325.95, ["Neon|Ride"] = 215.65, ["Neon|Fly|Ride"] = 196.87, ["Mega|Fly|Ride"] = 1031.8}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 103.28, ["Ride"] = 183.75, ["Fly|Ride"] = 368.97, ["Neon"] = 437.07, ["Neon|Ride"] = 679.39, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.13, ["Fly"] = 59.05, ["Ride"] = 26.24, ["Fly|Ride"] = 83.64, ["Neon"] = 110.49, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 203.82, ["Mega"] = 429.7, ["Mega|Ride"] = 378.06, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 33.08, ["Fly"] = 64.32, ["Ride"] = 42.77, ["Fly|Ride"] = 73.37, ["Neon"] = 242.82, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 234.94, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 1031.8}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.68, ["Fly"] = 50.43, ["Ride"] = 17.07, ["Fly|Ride"] = 42.89, ["Neon"] = 32.71, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 116.17, ["Mega"] = 434.74, ["Mega|Ride"] = 499.55, ["Mega|Fly|Ride"] = 368.82}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 8.49, ["Fly"] = 58.23, ["Ride"] = 24.98, ["Fly|Ride"] = 108.66, ["Neon"] = 60.27, ["Neon|Fly"] = 115.54, ["Neon|Ride"] = 81.05, ["Neon|Fly|Ride"] = 216.54, ["Mega"] = 552.42, ["Mega|Ride"] = 476.51, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 49.87, ["Fly"] = 72.18, ["Ride"] = 53.81, ["Fly|Ride"] = 99.9, ["Neon"] = 572.87, ["Neon|Ride"] = 279.34, ["Neon|Fly|Ride"] = 278.1, ["Mega"] = 1516.11, ["Mega|Fly|Ride"] = 1074.94}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 1312.49, ["Fly"] = 1365, ["Ride"] = 1407, ["Fly|Ride"] = 1430.63, ["Neon|Ride"] = 4995.39, ["Neon|Fly|Ride"] = 3443.34, ["Mega|Fly|Ride"] = 13013.69}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 498.74, ["Fly"] = 564.38, ["Ride"] = 523.68, ["Fly|Ride"] = 570.93, ["Neon|Ride"] = 3301.95, ["Neon|Fly|Ride"] = 2332.32, ["Mega"] = 15467.36, ["Mega|Fly|Ride"] = 9942.14}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 282.89, ["Ride"] = 315, ["Fly|Ride"] = 432.39, ["Neon"] = 1575, ["Neon|Ride"] = 1468.69, ["Neon|Fly|Ride"] = 1680, ["Mega|Ride"] = 7493.08, ["Mega|Fly|Ride"] = 7953.71}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 38.87}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 51.19, ["Ride"] = 49.77, ["Fly|Ride"] = 148.04, ["Neon"] = 329.44, ["Neon|Fly"] = 589.98, ["Neon|Ride"] = 287.52, ["Neon|Fly|Ride"] = 518.44, ["Mega|Ride"] = 1215.17, ["Mega|Fly|Ride"] = 1036.54}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 70875, ["Fly"] = 18375, ["Ride"] = 38298.3, ["Fly|Ride"] = 19024.69, ["Neon|Fly|Ride"] = 38062.5, ["Mega"] = 220936.28, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 237.98, ["Fly"] = 284.82, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon"] = 905.63, ["Neon|Fly"] = 853.13, ["Neon|Ride"] = 945.62, ["Neon|Fly|Ride"] = 912.19, ["Mega"] = 6628.89, ["Mega|Fly|Ride"] = 3281.33}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 144.38, ["Fly"] = 525, ["Ride"] = 220.95, ["Fly|Ride"] = 262.5}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 81.04, ["Fly"] = 220.95, ["Ride"] = 105, ["Fly|Ride"] = 182.43, ["Neon|Ride"] = 719.24, ["Neon|Fly|Ride"] = 596.47, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 13.13, ["Fly"] = 53.82, ["Ride"] = 30.19, ["Fly|Ride"] = 65.63, ["Neon"] = 83.69, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 159.1, ["Neon|Fly|Ride"] = 238.64, ["Mega"] = 1968.75, ["Mega|Ride"] = 736.84, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 5332.93, ["Ride"] = 4058.25, ["Fly|Ride"] = 4200, ["Neon"] = 22096.23, ["Neon|Fly|Ride"] = 15750, ["Mega|Fly|Ride"] = 83205.24}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.57, ["Fly"] = 50.22, ["Ride"] = 33.77, ["Fly|Ride"] = 62.99, ["Neon"] = 131.25, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 190.21, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 34.04, ["Fly"] = 103.85, ["Ride"] = 48.57, ["Fly|Ride"] = 90.56, ["Neon"] = 317.06, ["Neon|Fly"] = 1473.84, ["Neon|Ride"] = 202.79, ["Neon|Fly|Ride"] = 320.25, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 434.43, ["Fly"] = 563.07, ["Ride"] = 472.5, ["Fly|Ride"] = 511.88, ["Neon"] = 1174.69, ["Neon|Fly"] = 1473.66, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1322.37, ["Mega|Fly|Ride"] = 4404.39}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 12.98, ["Fly"] = 30.76, ["Ride"] = 24.94, ["Fly|Ride"] = 39.38, ["Neon"] = 131.25, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 144.38, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 12.97, ["Fly"] = 295, ["Ride"] = 35.37, ["Fly|Ride"] = 82.43, ["Neon"] = 125.95, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 215.52, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 749.33}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 103.95, ["Ride"] = 122.07, ["Fly|Ride"] = 245.44, ["Neon"] = 1010.63, ["Neon|Ride"] = 511.88, ["Neon|Fly|Ride"] = 678.28, ["Mega|Fly|Ride"] = 2275.66}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 16.42, ["Fly"] = 552.42, ["Ride"] = 87.94, ["Fly|Ride"] = 144.37, ["Neon"] = 80.94, ["Neon|Fly"] = 148.04, ["Neon|Ride"] = 140.93, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 383.25, ["Mega|Fly"] = 499.47, ["Mega|Ride"] = 286.79, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 4854.94, ["Fly"] = 6492.75, ["Ride"] = 4790.63, ["Fly|Ride"] = 4331.25, ["Neon"] = 19687.5, ["Neon|Ride"] = 12337.5, ["Neon|Fly|Ride"] = 11681.25, ["Mega"] = 66280.89, ["Mega|Fly|Ride"] = 37945.69}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 34.13, ["Fly"] = 75.13, ["Ride"] = 52.5, ["Fly|Ride"] = 165.38, ["Neon"] = 233.62, ["Neon|Ride"] = 276.01, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 1830.94, ["Mega|Fly|Ride"] = 784.88}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7481.25, ["Ride"] = 6168.75, ["Fly|Ride"] = 6168.75, ["Neon"] = 23312.18, ["Neon|Fly|Ride"] = 15223.69, ["Mega|Fly|Ride"] = 46921.88}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 3.84, ["Fly"] = 24.89, ["Ride"] = 17.57, ["Fly|Ride"] = 35.45, ["Neon"] = 28.87, ["Neon|Fly"] = 62.74, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 102.78, ["Mega"] = 242.82, ["Mega|Ride"] = 394.46, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 18.36, ["Fly"] = 32.85, ["Ride"] = 32.81, ["Fly|Ride"] = 51.93, ["Neon"] = 128.16, ["Neon|Fly"] = 244.18, ["Neon|Ride"] = 142.63, ["Neon|Fly|Ride"] = 166.19, ["Mega|Ride"] = 1030.98, ["Mega|Fly|Ride"] = 1031.9}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 10.5, ["Fly"] = 32.82, ["Ride"] = 26.02, ["Fly|Ride"] = 90.96, ["Neon"] = 131.23, ["Neon|Ride"] = 139.13, ["Neon|Fly|Ride"] = 216.09, ["Mega"] = 1049.9, ["Mega|Ride"] = 1177.76, ["Mega|Fly|Ride"] = 1152.2}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 24.94, ["Fly"] = 190.37, ["Ride"] = 44.2, ["Fly|Ride"] = 156.87, ["Neon"] = 148.04, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 255.94, ["Mega"] = 2043.92, ["Mega|Ride"] = 883.76, ["Mega|Fly|Ride"] = 832.99}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 15.75, ["Fly"] = 27.57, ["Ride"] = 23.5, ["Fly|Ride"] = 43.32, ["Neon"] = 94, ["Neon|Fly"] = 1101.52, ["Neon|Ride"] = 110.49, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 2651.56, ["Mega|Fly|Ride"] = 643.25}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8828.64}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 3018.75}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 24.92}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 199.83, ["Ride"] = 203.44, ["Fly|Ride"] = 341.24, ["Neon|Fly|Ride"] = 1234.05}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 15.41, ["Fly"] = 45.94, ["Ride"] = 36.66, ["Fly|Ride"] = 141.43, ["Neon"] = 166.35, ["Neon|Ride"] = 116.82, ["Neon|Fly|Ride"] = 265.13, ["Mega"] = 546.83, ["Mega|Ride"] = 2091.84, ["Mega|Fly|Ride"] = 546.83}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 12.59}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.59, ["Ride"] = 25.98, ["Fly|Ride"] = 88.39, ["Neon"] = 159.11, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 105, ["Mega|Fly|Ride"] = 496.12}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2489.82}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 242.82, ["Fly"] = 441.89, ["Ride"] = 262.5, ["Fly|Ride"] = 749.33, ["Neon"] = 1166.44, ["Neon|Ride"] = 1100.25, ["Neon|Fly|Ride"] = 1095.87, ["Mega|Fly|Ride"] = 3936.45}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 65.63, ["Fly"] = 485.52, ["Ride"] = 81.02, ["Fly|Ride"] = 267.31, ["Neon"] = 424.62, ["Neon|Ride"] = 342.49, ["Neon|Fly|Ride"] = 345.19, ["Mega|Fly|Ride"] = 2207.19}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 210, ["Fly"] = 267.27, ["Ride"] = 225.75, ["Fly|Ride"] = 253.21, ["Neon"] = 945, ["Neon|Ride"] = 741.57, ["Neon|Fly|Ride"] = 748.12, ["Mega|Ride"] = 3755.93, ["Mega|Fly|Ride"] = 3651.27}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 2362.5, ["Fly"] = 3388.07, ["Ride"] = 2756.25, ["Fly|Ride"] = 2559.38, ["Neon"] = 15518.19, ["Neon|Ride"] = 9994.14, ["Neon|Fly|Ride"] = 9491.23, ["Mega|Fly|Ride"] = 31499.99}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 15.25, ["Fly"] = 109.38, ["Ride"] = 57.05, ["Fly|Ride"] = 114.91, ["Neon"] = 127.32, ["Neon|Ride"] = 159.87, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 993.24, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 656.25, ["Fly"] = 2100, ["Ride"] = 832.99, ["Fly|Ride"] = 883.76, ["Neon|Fly|Ride"] = 5522.32}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 39.38}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 23.55, ["Ride"] = 48.62, ["Fly|Ride"] = 203.44, ["Neon"] = 115.5, ["Neon|Ride"] = 137.15, ["Neon|Fly|Ride"] = 250.79, ["Mega"] = 480.38, ["Mega|Ride"] = 514.56, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 9.71, ["Fly"] = 44.2, ["Ride"] = 29.99, ["Fly|Ride"] = 77.46, ["Neon"] = 72.1, ["Neon|Fly"] = 315, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 467.16, ["Mega|Ride"] = 282.26, ["Mega|Fly|Ride"] = 404.64}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 52.5}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.9, ["Fly"] = 33.15, ["Ride"] = 27.57, ["Fly|Ride"] = 57.88, ["Neon"] = 145.84, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 254.63, ["Mega|Ride"] = 1325.63, ["Mega|Fly|Ride"] = 2209.64}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 26.85, ["Fly"] = 47.48, ["Ride"] = 32.15, ["Fly|Ride"] = 59.68, ["Neon"] = 294.97, ["Neon|Fly"] = 184.49, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 293.87, ["Mega"] = 1473.84, ["Mega|Ride"] = 1872.11, ["Mega|Fly|Ride"] = 871.5}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 7067.78, ["Fly"] = 4987.5, ["Ride"] = 6613.95, ["Fly|Ride"] = 4856.23, ["Neon|Fly|Ride"] = 10500, ["Mega|Fly|Ride"] = 35437.5}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 11.19, ["Fly"] = 48.76, ["Ride"] = 31.5, ["Fly|Ride"] = 87.5, ["Neon"] = 56.59, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 238.54, ["Mega"] = 354.38, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 633.18}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 19.39}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 85.31, ["Fly"] = 391.12, ["Ride"] = 118.13, ["Fly|Ride"] = 208.57, ["Neon"] = 531.57, ["Neon|Ride"] = 499.65, ["Neon|Fly|Ride"] = 520.94, ["Mega"] = 2879.59, ["Mega|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 1850.63}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 58.94, ["Fly"] = 192.86, ["Ride"] = 84.2, ["Fly|Ride"] = 176.21, ["Neon"] = 308.44, ["Neon|Fly"] = 399.65, ["Neon|Ride"] = 317.63, ["Neon|Fly|Ride"] = 589.91, ["Mega"] = 2498.07, ["Mega|Ride"] = 999.09, ["Mega|Fly|Ride"] = 1200.94}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 19.69, ["Fly"] = 82.87, ["Ride"] = 39.29, ["Fly|Ride"] = 65.62, ["Neon"] = 174.57, ["Neon|Fly"] = 238.64, ["Neon|Ride"] = 144.27, ["Neon|Fly|Ride"] = 190.21, ["Mega"] = 1016.21, ["Mega|Fly|Ride"] = 832.99}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 8.43, ["Fly"] = 78.74, ["Ride"] = 27.46, ["Fly|Ride"] = 106.32, ["Neon"] = 33.84, ["Neon|Fly"] = 88.38, ["Neon|Ride"] = 81.15, ["Neon|Fly|Ride"] = 146.63, ["Mega"] = 219, ["Mega|Fly"] = 7299.5, ["Mega|Ride"] = 229.09, ["Mega|Fly|Ride"] = 353.99}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 11.82, ["Fly"] = 65.63, ["Ride"] = 29.89, ["Fly|Ride"] = 95.02, ["Neon"] = 87.94, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 380.63, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 22.07, ["Fly"] = 36.72, ["Ride"] = 32.45, ["Fly|Ride"] = 45.94, ["Neon"] = 278.25, ["Neon|Fly"] = 144.38, ["Neon|Ride"] = 118.12, ["Neon|Fly|Ride"] = 146.9, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 207.9}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 28.88, ["Ride"] = 91.88, ["Fly|Ride"] = 339.94, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 436.36, ["Mega"] = 866.25, ["Mega|Ride"] = 786.55, ["Mega|Fly|Ride"] = 791.31}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["Ride"] = 1473.84, ["Fly|Ride"] = 921.32, ["Neon|Fly|Ride"] = 73654.42}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 57.74, ["Fly"] = 220.95, ["Ride"] = 89.25, ["Fly|Ride"] = 139.07, ["Neon"] = 210, ["Neon|Ride"] = 342.26, ["Neon|Fly|Ride"] = 394.83, ["Mega"] = 1155.14, ["Mega|Ride"] = 1346.27, ["Mega|Fly|Ride"] = 1253.44}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 1154.98, ["Fly"] = 1246.88, ["Ride"] = 1223.25, ["Fly|Ride"] = 1286.15, ["Neon"] = 4808.07, ["Neon|Fly"] = 4808.07, ["Neon|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 13125}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 360.94, ["Fly"] = 736.93, ["Ride"] = 433.13, ["Fly|Ride"] = 562.22, ["Neon"] = 3241.53, ["Neon|Ride"] = 7954.66, ["Neon|Fly|Ride"] = 2033.07, ["Mega"] = 13256.18, ["Mega|Fly|Ride"] = 9973.69}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 60.1}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.29}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 10.5, ["Fly"] = 32.79, ["Ride"] = 23.82, ["Fly|Ride"] = 59.68, ["Neon"] = 83.69, ["Neon|Fly"] = 176.78, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 437.26, ["Mega|Ride"] = 736.84, ["Mega|Fly|Ride"] = 570.94}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 216.57, ["Fly"] = 354.38, ["Ride"] = 283.14, ["Fly|Ride"] = 384.16, ["Neon"] = 1198.91, ["Neon|Ride"] = 759.94, ["Neon|Fly|Ride"] = 874.13, ["Mega|Fly|Ride"] = 3092.02}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 18.95}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 117.17, ["Ride"] = 177.48, ["Fly|Ride"] = 282.27, ["Neon"] = 577.5, ["Neon|Fly"] = 610.32, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 736.32, ["Mega"] = 2809.03, ["Mega|Ride"] = 2503.23, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 129.83, ["Fly"] = 294.97, ["Ride"] = 150.94, ["Fly|Ride"] = 262.5, ["Neon"] = 771.08, ["Neon|Ride"] = 1032.94, ["Neon|Fly|Ride"] = 749.33, ["Mega|Fly|Ride"] = 2332.86}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 3.94, ["Fly"] = 81.76, ["Ride"] = 21.92, ["Fly|Ride"] = 220.95, ["Neon"] = 31.18, ["Neon|Ride"] = 68.51, ["Neon|Fly|Ride"] = 265.14, ["Mega"] = 170.63, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 384.44}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 12.49, ["Fly"] = 50.4, ["Ride"] = 25.2, ["Fly|Ride"] = 69.57, ["Neon"] = 177.19, ["Neon|Ride"] = 101.07, ["Neon|Fly|Ride"] = 236.41, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 12.44, ["Fly"] = 102.36, ["Ride"] = 34.5, ["Fly|Ride"] = 131.25, ["Neon"] = 85.31, ["Neon|Ride"] = 101.06, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 498.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 494.82}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 5, ["Fly"] = 176.76, ["Ride"] = 55.42, ["Fly|Ride"] = 157.49, ["Neon"] = 25.98, ["Neon|Ride"] = 69.61, ["Neon|Fly|Ride"] = 155.92, ["Mega"] = 144.96, ["Mega|Ride"] = 173.15, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 271.57, ["Ride"] = 321.57, ["Fly|Ride"] = 354.38, ["Neon"] = 1341.1, ["Neon|Ride"] = 1433.69, ["Neon|Fly|Ride"] = 1395.72, ["Mega"] = 3680.82, ["Mega|Ride"] = 5155.57, ["Mega|Fly|Ride"] = 6804.86}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 97.94, ["Fly"] = 585.21, ["Ride"] = 119.53, ["Fly|Ride"] = 194.91, ["Neon"] = 367.5, ["Neon|Ride"] = 492.19, ["Neon|Fly|Ride"] = 514.48, ["Mega"] = 2022.57, ["Mega|Ride"] = 2799.27, ["Mega|Fly|Ride"] = 2167.08}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 69.55, ["Fly"] = 167.45, ["Ride"] = 85.2, ["Fly|Ride"] = 114.96, ["Neon"] = 315, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 425.23, ["Mega|Ride"] = 1050, ["Mega|Fly|Ride"] = 1372.88}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 21, ["Fly"] = 127.32, ["Ride"] = 55.26, ["Fly|Ride"] = 294.97, ["Neon|Ride"] = 634.04, ["Neon|Fly|Ride"] = 333.46}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 14.43, ["Ride"] = 28.24, ["Fly|Ride"] = 94.78, ["Neon"] = 79.73, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 170.62, ["Mega"] = 807.18, ["Mega|Ride"] = 534.53, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.38, ["Fly"] = 43.32, ["Ride"] = 24.99, ["Fly|Ride"] = 51.59, ["Neon"] = 19.68, ["Neon|Fly"] = 87.29, ["Neon|Ride"] = 41.58, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 131.25, ["Mega|Ride"] = 181.12, ["Mega|Fly|Ride"] = 285.57}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 935.82, ["Fly"] = 918.75, ["Ride"] = 935.82, ["Fly|Ride"] = 905.63, ["Neon"] = 3211.32, ["Neon|Fly"] = 3390.62, ["Neon|Ride"] = 8838.5, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 8085}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 288.75, ["Fly"] = 342.5, ["Ride"] = 299.31, ["Fly|Ride"] = 342.46, ["Neon"] = 1325.63, ["Neon|Ride"] = 1270.5, ["Neon|Fly|Ride"] = 1760.89, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 5162.75}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 98.44, ["Fly"] = 174.17, ["Ride"] = 107.66, ["Fly|Ride"] = 167.35, ["Neon"] = 499.55, ["Neon|Ride"] = 416.61, ["Neon|Fly|Ride"] = 572.24, ["Mega"] = 1575, ["Mega|Ride"] = 1789.59, ["Mega|Fly|Ride"] = 1915.74}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 218.67, ["Fly"] = 283.5, ["Ride"] = 217.35, ["Fly|Ride"] = 240.27, ["Neon|Ride"] = 1022.44, ["Neon|Fly|Ride"] = 1091.45, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 4164.9}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.36, ["Fly"] = 59.68, ["Ride"] = 33.88, ["Fly|Ride"] = 80.07, ["Neon"] = 170.63, ["Neon|Ride"] = 113.79, ["Neon|Fly|Ride"] = 219.22, ["Mega|Ride"] = 781.02, ["Mega|Fly|Ride"] = 1028.47}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 204.75, ["Ride"] = 282.19, ["Fly|Ride"] = 418.69, ["Neon"] = 1104.69, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 1094.76, ["Mega"] = 4358.45, ["Mega|Fly|Ride"] = 4331.21}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 91.33, ["Fly"] = 126, ["Ride"] = 83.69, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 1666.22, ["Mega|Ride"] = 2357.67, ["Mega|Fly|Ride"] = 1821.75}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 2871.08, ["Ride"] = 2231.25, ["Fly|Ride"] = 2756.25, ["Neon|Ride"] = 11656.72, ["Neon|Fly|Ride"] = 7481.25, ["Mega"] = 53030.93, ["Mega|Fly|Ride"] = 31304.78}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 11.34, ["Fly"] = 85.32, ["Ride"] = 44.42, ["Fly|Ride"] = 66.3, ["Neon"] = 45.94, ["Neon|Fly"] = 173.02, ["Neon|Ride"] = 104.9, ["Neon|Fly|Ride"] = 153.2, ["Mega"] = 290.71, ["Mega|Ride"] = 347.3, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 26.25, ["Ride"] = 72.19, ["Fly|Ride"] = 94.24, ["Neon"] = 216.57, ["Neon|Ride"] = 242.82, ["Neon|Fly|Ride"] = 397.06, ["Mega|Ride"] = 882.66, ["Mega|Fly|Ride"] = 1380.87}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 77.44, ["Fly"] = 98.2, ["Ride"] = 85.32, ["Fly|Ride"] = 65.63, ["Neon"] = 525, ["Neon|Fly|Ride"] = 406.88, ["Mega|Fly|Ride"] = 1512.03}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 2231.25, ["Fly"] = 1666.22, ["Ride"] = 1073.62, ["Fly|Ride"] = 987.51, ["Neon|Ride"] = 5829.2, ["Neon|Fly|Ride"] = 3937.49, ["Mega"] = 41977.91, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 430.49, ["Fly"] = 881.55, ["Ride"] = 480.55, ["Fly|Ride"] = 534.19, ["Mega"] = 11600.52}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 70.88, ["Fly"] = 118.13, ["Ride"] = 121.95, ["Fly|Ride"] = 259.61, ["Neon"] = 453.47, ["Neon|Ride"] = 342.38, ["Neon|Fly|Ride"] = 515.91, ["Mega"] = 2651.24, ["Mega|Ride"] = 2665.06, ["Mega|Fly|Ride"] = 1761.38}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 7.61, ["Ride"] = 21, ["Fly|Ride"] = 63.24, ["Neon"] = 78.75, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 133.65, ["Mega"] = 656.25, ["Mega|Ride"] = 815.69}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.92, ["Fly"] = 68.25, ["Ride"] = 55.17, ["Fly|Ride"] = 90.04, ["Neon"] = 163.5, ["Neon|Fly"] = 368.97, ["Neon|Ride"] = 287.24, ["Neon|Fly|Ride"] = 333.46, ["Mega|Ride"] = 1187.82, ["Mega|Fly|Ride"] = 833.44}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 721.88, ["Fly"] = 1149.11, ["Ride"] = 892.5, ["Fly|Ride"] = 855.53, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2205, ["Mega|Fly|Ride"] = 8531.25}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 662.82}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 5381.25, ["Ride"] = 5906.25, ["Fly|Ride"] = 5328.75, ["Neon"] = 42000, ["Neon|Ride"] = 31664.99, ["Neon|Fly|Ride"] = 27352.5, ["Mega|Fly|Ride"] = 73645.81}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 236.25, ["Fly"] = 414.27, ["Ride"] = 351.3, ["Fly|Ride"] = 434.67, ["Neon"] = 1312.5, ["Neon|Fly|Ride"] = 2209.64, ["Mega"] = 6627, ["Mega|Fly|Ride"] = 6628.1}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 94.5, ["Ride"] = 131.25, ["Fly|Ride"] = 190.32, ["Neon"] = 2208.27, ["Neon|Ride"] = 589.98, ["Neon|Fly|Ride"] = 473.82, ["Mega|Fly|Ride"] = 1988.43}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 18.25, ["Fly"] = 74.03, ["Ride"] = 40.68, ["Fly|Ride"] = 85.32, ["Neon"] = 145.84, ["Neon|Ride"] = 174.86, ["Neon|Fly|Ride"] = 259.88, ["Mega|Ride"] = 666.9, ["Mega|Fly|Ride"] = 800.63}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 12.98, ["Fly"] = 32.82, ["Ride"] = 27.29, ["Fly|Ride"] = 50.12, ["Neon"] = 220.95, ["Neon|Fly"] = 295, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 177.19, ["Mega"] = 1312.5, ["Mega|Ride"] = 380.63, ["Mega|Fly|Ride"] = 1104.69}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 16.67, ["Fly"] = 163.47, ["Ride"] = 36.75, ["Fly|Ride"] = 105.91, ["Neon"] = 124.69, ["Neon|Ride"] = 158.8, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 645.91, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 6.23, ["Fly"] = 29.85, ["Ride"] = 23.62, ["Fly|Ride"] = 49.96, ["Neon"] = 41.2, ["Neon|Fly"] = 364.61, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 136.69, ["Mega"] = 294.97, ["Mega|Ride"] = 234.94, ["Mega|Fly|Ride"] = 266.37}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.63, ["Ride"] = 52.49, ["Fly|Ride"] = 147, ["Neon"] = 111.57, ["Neon|Fly"] = 883.86, ["Neon|Ride"] = 140.32, ["Neon|Fly|Ride"] = 330.33, ["Mega"] = 630, ["Mega|Ride"] = 736.84, ["Mega|Fly|Ride"] = 532.88}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 542.81, ["Fly"] = 590.63, ["Ride"] = 630.19, ["Fly|Ride"] = 635.25, ["Neon"] = 2651.24, ["Neon|Ride"] = 1754.25, ["Neon|Fly|Ride"] = 1809.48, ["Mega"] = 9843.75, ["Mega|Fly|Ride"] = 7364.93}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 3.2, ["Fly"] = 19.59, ["Ride"] = 15.5, ["Fly|Ride"] = 38.07, ["Neon"] = 24.99, ["Neon|Ride"] = 37.8, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 157.5, ["Mega|Ride"] = 616.35, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 39.37, ["Fly"] = 118.11, ["Ride"] = 77.44, ["Fly|Ride"] = 175.67, ["Neon"] = 186.38, ["Neon|Ride"] = 209.03, ["Neon|Fly|Ride"] = 249.38, ["Mega"] = 557.82, ["Mega|Fly"] = 883.76, ["Mega|Ride"] = 570.94, ["Mega|Fly|Ride"] = 572.25}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 787.28, ["Ride"] = 794.07, ["Fly|Ride"] = 826.88, ["Neon|Fly"] = 2098.91, ["Neon|Ride"] = 2498.15, ["Neon|Fly|Ride"] = 1690.5, ["Mega|Fly|Ride"] = 4517.61}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 33.89, ["Fly"] = 70.86, ["Ride"] = 49.88, ["Fly|Ride"] = 97.43, ["Neon"] = 280.88, ["Neon|Ride"] = 223.02, ["Neon|Fly|Ride"] = 252, ["Mega"] = 1249.04, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 883.94}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 243.32, ["Fly"] = 379.19, ["Ride"] = 280.54, ["Fly|Ride"] = 328.11, ["Neon|Fly|Ride"] = 1291.5, ["Mega|Fly|Ride"] = 4664.45}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 259.88, ["Fly"] = 397.7, ["Ride"] = 262.49, ["Fly|Ride"] = 341.25, ["Neon"] = 892.5, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 875.44, ["Mega"] = 5118.75, ["Mega|Fly|Ride"] = 4965.57}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 761.25, ["Ride"] = 721.88, ["Fly|Ride"] = 701.67, ["Neon|Ride"] = 3684.13, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 9448.69}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 15.75, ["Fly"] = 64.1, ["Ride"] = 51.21, ["Fly|Ride"] = 107.47, ["Neon"] = 49.88, ["Neon|Fly"] = 299.78, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 354.38, ["Mega|Ride"] = 286.13, ["Mega|Fly|Ride"] = 442.32}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 3346.88, ["Fly"] = 3543.75, ["Ride"] = 3399.38, ["Fly|Ride"] = 3510.94, ["Neon|Fly|Ride"] = 8027.25, ["Mega|Fly|Ride"] = 19425}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 143.06, ["Fly"] = 178.47, ["Ride"] = 146.99, ["Fly|Ride"] = 207.73, ["Neon"] = 535.5, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 581.44, ["Mega"] = 3314.06, ["Mega|Fly|Ride"] = 3457.63}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.24, ["Fly"] = 32.06, ["Ride"] = 19.52, ["Fly|Ride"] = 43.32, ["Neon"] = 26.3, ["Neon|Fly"] = 43.24, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 88.38, ["Mega"] = 183.4, ["Mega|Fly"] = 446.25, ["Mega|Ride"] = 248.24, ["Mega|Fly|Ride"] = 299.8}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 4.43, ["Ride"] = 19.69, ["Fly|Ride"] = 69.16, ["Neon"] = 24.93, ["Neon|Fly"] = 122.48, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 190.32, ["Mega|Ride"] = 295.08, ["Mega|Fly|Ride"] = 384.57}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 47.23, ["Fly"] = 59.14, ["Ride"] = 46.3, ["Fly|Ride"] = 63, ["Neon"] = 299.74, ["Neon|Ride"] = 419.79, ["Neon|Fly|Ride"] = 271.42, ["Mega|Fly|Ride"] = 1268.18}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 954.19, ["Fly"] = 1199.08, ["Ride"] = 918.75, ["Fly|Ride"] = 1105.13, ["Neon|Ride"] = 8326.06, ["Neon|Fly|Ride"] = 4986.11}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["Ride"] = 10363.14, ["Fly|Ride"] = 7875}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 19.89, ["Fly"] = 35.37, ["Ride"] = 26.25, ["Fly|Ride"] = 48.93, ["Neon"] = 176.76, ["Neon|Ride"] = 145.85, ["Neon|Fly|Ride"] = 170.61, ["Mega"] = 2520, ["Mega|Ride"] = 883.09, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 11.54, ["Ride"] = 27.07, ["Fly|Ride"] = 61.41, ["Neon"] = 123.61, ["Neon|Fly"] = 111.57, ["Neon|Ride"] = 83.71, ["Neon|Fly|Ride"] = 169.32, ["Mega"] = 668.87, ["Mega|Ride"] = 528.94, ["Mega|Fly|Ride"] = 501.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 97.13, ["Ride"] = 103.74, ["Fly|Ride"] = 145.84, ["Neon"] = 589.91, ["Neon|Ride"] = 628.63, ["Neon|Fly|Ride"] = 459.38, ["Mega|Fly|Ride"] = 2755.09}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 170.63, ["Fly"] = 1178.84, ["Ride"] = 209.99, ["Fly|Ride"] = 314.79, ["Neon"] = 1305.94, ["Neon|Ride"] = 1265.98, ["Neon|Fly|Ride"] = 1029, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 4356.87}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.94, ["Ride"] = 35.37, ["Fly|Ride"] = 72.19, ["Neon"] = 31.19, ["Neon|Fly"] = 656.25, ["Neon|Ride"] = 70.88, ["Mega"] = 139.13, ["Mega|Fly"] = 246.37, ["Mega|Ride"] = 153.05, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 202.13, ["Fly"] = 257.25, ["Ride"] = 208.38, ["Fly|Ride"] = 291.38, ["Neon"] = 654.94, ["Neon|Ride"] = 715.32, ["Neon|Fly|Ride"] = 701.67, ["Mega|Fly|Ride"] = 3110.84}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 3.12, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 39.38, ["Neon"] = 24.68, ["Neon|Fly"] = 132.58, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 121.44, ["Mega"] = 413.17, ["Mega|Fly"] = 295, ["Mega|Ride"] = 219.19, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 294.96, ["Fly"] = 354.38, ["Ride"] = 337.82, ["Fly|Ride"] = 347.82, ["Neon|Ride"] = 1473.84, ["Neon|Fly|Ride"] = 1233.75, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 5662.27}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 11.82, ["Fly"] = 104.98, ["Ride"] = 29.85, ["Fly|Ride"] = 68.25, ["Neon"] = 90.55, ["Neon|Fly"] = 317.28, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 168.92, ["Mega"] = 589.98, ["Mega|Ride"] = 455.14, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 2.63, ["Ride"] = 18.19, ["Neon"] = 7.88, ["Neon|Fly"] = 170.46, ["Neon|Ride"] = 49.54, ["Neon|Fly|Ride"] = 195.57, ["Mega"] = 94.39, ["Mega|Ride"] = 138.97, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 4.79, ["Mega"] = 23.56, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 33.9, ["Fly|Ride"] = 116.82, ["Neon"] = 7.58, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 131.23, ["Mega"] = 61.3, ["Mega|Fly"] = 191720.66, ["Mega|Ride"] = 132.58, ["Mega|Fly|Ride"] = 254.78}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 74.81, ["Fly"] = 174.56, ["Ride"] = 99.02, ["Fly|Ride"] = 183.75, ["Neon"] = 236.25, ["Neon|Ride"] = 309.23, ["Neon|Fly|Ride"] = 410.82, ["Mega|Ride"] = 1233.75, ["Mega|Fly|Ride"] = 1468.64}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 38.74, ["Ride"] = 16.41, ["Fly|Ride"] = 85.3, ["Neon"] = 8.85, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 58.86, ["Mega"] = 73.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 6.4, ["Ride"] = 150.25, ["Neon"] = 78.16, ["Neon|Fly"] = 333.46, ["Neon|Ride"] = 314.9, ["Neon|Fly|Ride"] = 368.97, ["Mega"] = 406.88, ["Mega|Ride"] = 587.71, ["Mega|Fly|Ride"] = 555.42}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Neon"] = 2.61, ["Neon|Ride"] = 56.43, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 21.9, ["Mega|Ride"] = 62.39, ["Mega|Fly|Ride"] = 256.29}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 85.54, ["Ride"] = 15.91, ["Fly|Ride"] = 87.94, ["Neon"] = 2.1, ["Neon|Fly"] = 42.38, ["Neon|Ride"] = 15, ["Neon|Fly|Ride"] = 39.38, ["Mega"] = 15.71, ["Mega|Fly"] = 36.54, ["Mega|Ride"] = 21.39, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Fly"] = 29.85, ["Ride"] = 14.44, ["Fly|Ride"] = 51.93, ["Neon"] = 2.1, ["Neon|Fly"] = 24.86, ["Neon|Ride"] = 17.16, ["Neon|Fly|Ride"] = 44.16, ["Mega"] = 18.38, ["Mega|Fly"] = 167.4, ["Mega|Ride"] = 18.76, ["Mega|Fly|Ride"] = 92.75}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 65.63, ["Mega"] = 19.08, ["Mega|Ride"] = 109.51, ["Mega|Fly|Ride"] = 250.79}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 117.91, ["Ride"] = 26.25, ["Fly|Ride"] = 52.5, ["Neon"] = 5.03, ["Neon|Fly"] = 125.95, ["Neon|Ride"] = 23.44, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 45.92, ["Mega|Fly"] = 91.88, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 3.75, ["Neon|Ride"] = 89.06, ["Neon|Fly|Ride"] = 441.89, ["Mega"] = 20.79, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 136.49}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 6.12, ["Fly"] = 52.49, ["Ride"] = 31.31, ["Fly|Ride"] = 167.35, ["Neon"] = 49.88, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 91.76, ["Neon|Fly|Ride"] = 192.4, ["Mega"] = 223.13, ["Mega|Ride"] = 259.88, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 82.78, ["Neon"] = 2.1, ["Neon|Ride"] = 42.29, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 22.12, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 139.07, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.63, ["Fly"] = 65.63, ["Fly|Ride"] = 148.04, ["Neon"] = 23.62, ["Mega"] = 119.42, ["Mega|Ride"] = 144.38}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 2.1, ["Ride"] = 26.24, ["Neon"] = 22.97, ["Mega"] = 133.61, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Fly"] = 148.07, ["Ride"] = 32.82, ["Neon"] = 3.65, ["Neon|Ride"] = 27.97, ["Neon|Fly|Ride"] = 148.07, ["Mega"] = 22.3, ["Mega|Ride"] = 47.25, ["Mega|Fly|Ride"] = 104.99}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 13.27, ["Fly|Ride"] = 40.69, ["Neon"] = 2.1, ["Neon|Fly"] = 35.32, ["Neon|Ride"] = 11.81, ["Neon|Fly|Ride"] = 34.13, ["Mega"] = 14.42, ["Mega|Fly"] = 21.91, ["Mega|Ride"] = 22.32, ["Mega|Fly|Ride"] = 51.71}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 2.1, ["Fly"] = 72.19, ["Ride"] = 54.28, ["Fly|Ride"] = 118.11, ["Neon"] = 37.8, ["Neon|Ride"] = 143.63, ["Neon|Fly|Ride"] = 736.93, ["Mega"] = 206.61, ["Mega|Ride"] = 241.5}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 42.66, ["Neon"] = 3.31, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 29.56, ["Mega|Ride"] = 166.81, ["Mega|Fly|Ride"] = 115.5}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 17.94, ["Neon|Ride"] = 195.11, ["Mega"] = 105.7, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 79.73, ["Ride"] = 28.87, ["Fly|Ride"] = 39.38, ["Neon"] = 11.47, ["Neon|Ride"] = 51.95, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 129.94, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 13.54, ["Ride"] = 11.81, ["Fly|Ride"] = 36.75, ["Neon"] = 2.1, ["Neon|Fly"] = 10.77, ["Neon|Ride"] = 12.9, ["Neon|Fly|Ride"] = 39.97, ["Mega"] = 14.04, ["Mega|Fly"] = 27.89, ["Mega|Ride"] = 20.98, ["Mega|Fly|Ride"] = 51.96}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 27.42, ["Fly|Ride"] = 52.5, ["Neon"] = 13.12, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.49, ["Neon|Fly|Ride"] = 196.76, ["Mega"] = 129.65, ["Mega|Ride"] = 160.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 5.13, ["Fly"] = 118.13, ["Ride"] = 118.21, ["Fly|Ride"] = 93.19, ["Neon"] = 73.37, ["Neon|Ride"] = 73.38, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 330.33, ["Mega|Ride"] = 297.51, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 59.68, ["Ride"] = 14.42, ["Fly|Ride"] = 41.62, ["Neon"] = 2.1, ["Neon|Fly"] = 20.06, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 51.19, ["Mega"] = 23.63, ["Mega|Fly"] = 51.93, ["Mega|Ride"] = 35.85, ["Mega|Fly|Ride"] = 87.94}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 184.52, ["Ride"] = 22.11, ["Neon"] = 11.8, ["Neon|Ride"] = 38.97, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 51.19, ["Mega|Fly"] = 167.4, ["Mega|Ride"] = 121.53, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.35, ["Ride"] = 35.43, ["Fly|Ride"] = 131.25, ["Neon"] = 3.83, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 51.98, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 32.8, ["Mega|Fly"] = 116.93, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 381.29}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 20.81, ["Fly|Ride"] = 48.55, ["Neon"] = 2.1, ["Neon|Ride"] = 35.25, ["Neon|Fly|Ride"] = 110.49, ["Mega"] = 16.41, ["Mega|Fly"] = 253.82, ["Mega|Ride"] = 73.37, ["Mega|Fly|Ride"] = 196.87}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 24.31, ["Ride"] = 19.69, ["Fly|Ride"] = 55.42, ["Neon"] = 7.35, ["Neon|Fly"] = 59.18, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 78.74, ["Mega"] = 105.21, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 29.85, ["Neon"] = 6.01, ["Neon|Ride"] = 57.75, ["Mega"] = 52.49, ["Mega|Fly"] = 217.34, ["Mega|Ride"] = 118.02, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 22.11, ["Ride"] = 18.65, ["Fly|Ride"] = 40.68, ["Neon"] = 6.44, ["Neon|Fly"] = 79.56, ["Neon|Ride"] = 26.2, ["Neon|Fly|Ride"] = 84, ["Mega"] = 114.19, ["Mega|Fly"] = 116.94, ["Mega|Ride"] = 114.91, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 31.88, ["Neon|Fly"] = 188.88, ["Neon|Fly|Ride"] = 327.3, ["Mega"] = 105, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 662.91}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 26.03, ["Ride"] = 21.46, ["Fly|Ride"] = 51.18, ["Neon"] = 6.36, ["Neon|Fly"] = 49.96, ["Neon|Ride"] = 45.93, ["Neon|Fly|Ride"] = 66.33, ["Mega"] = 106.32, ["Mega|Fly"] = 420, ["Mega|Ride"] = 83.98, ["Mega|Fly|Ride"] = 184.83}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.09, ["Ride"] = 18.38, ["Fly|Ride"] = 74.03, ["Neon"] = 10.5, ["Neon|Fly"] = 32.76, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 220.95, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 142.38, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 117.12, ["Fly|Ride"] = 148.07, ["Neon"] = 101.7, ["Neon|Fly|Ride"] = 2625, ["Mega"] = 257.28, ["Mega|Ride"] = 331.42}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 8.79, ["Ride"] = 94.94, ["Neon"] = 91.59, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 750.75}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 2.1, ["Ride"] = 57.46, ["Neon"] = 57.2, ["Neon|Ride"] = 118.21, ["Mega"] = 233.63, ["Mega|Ride"] = 367.5}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.23, ["Ride"] = 72.18, ["Fly|Ride"] = 104.99, ["Neon"] = 52.44, ["Neon|Ride"] = 75.93, ["Neon|Fly|Ride"] = 124.9, ["Mega"] = 225.68, ["Mega|Ride"] = 294.97, ["Mega|Fly|Ride"] = 448.22}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Mega"] = 19.27, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 132.59, ["Mega|Fly|Ride"] = 248.54}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 49.88}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 6.14, ["Fly"] = 32.06, ["Ride"] = 19.68, ["Fly|Ride"] = 44.2, ["Neon"] = 45.93, ["Neon|Fly"] = 189, ["Neon|Ride"] = 49.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 288.75, ["Mega|Ride"] = 208.68, ["Mega|Fly|Ride"] = 267.27}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 21, ["Neon"] = 6.28, ["Neon|Fly"] = 52.81, ["Neon|Ride"] = 24.23, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 27.57, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 70.72, ["Mega|Fly|Ride"] = 129.55}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 6.13, ["Neon|Ride"] = 34.12, ["Neon|Fly|Ride"] = 74.42, ["Mega"] = 34.12, ["Mega|Ride"] = 61.37, ["Mega|Fly|Ride"] = 136.5}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.65, ["Ride"] = 16.12, ["Fly|Ride"] = 45.73, ["Neon"] = 9.86, ["Neon|Ride"] = 24.1, ["Neon|Fly|Ride"] = 73.5, ["Mega"] = 164, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 167.4}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 2.1, ["Fly"] = 57.46, ["Ride"] = 32.81, ["Fly|Ride"] = 117.41, ["Neon"] = 48.2, ["Neon|Ride"] = 208.15, ["Neon|Fly|Ride"] = 144.37, ["Mega"] = 137.54, ["Mega|Ride"] = 345.45, ["Mega|Fly|Ride"] = 338.05}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 315, ["Mega"] = 15.74, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 163.5}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 17.18, ["Fly|Ride"] = 65.63, ["Neon"] = 6.34, ["Neon|Fly"] = 115.04, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 98.95, ["Mega"] = 39.6, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 137}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.29, ["Fly|Ride"] = 37.57, ["Neon"] = 6.03, ["Neon|Fly"] = 37.85, ["Neon|Ride"] = 21.82, ["Neon|Fly|Ride"] = 62.91, ["Mega"] = 88.38, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 129.94}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 6.55, ["Fly"] = 91.88, ["Ride"] = 49.9, ["Fly|Ride"] = 131.25, ["Neon"] = 14.42, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 93.17, ["Mega|Ride"] = 152.92, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 109.4, ["Neon|Fly|Ride"] = 160750.44, ["Mega"] = 21.09, ["Mega|Ride"] = 44, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 45.91, ["Ride"] = 20.77, ["Neon"] = 2.1, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 25.78, ["Neon|Fly|Ride"] = 67.68, ["Mega"] = 19.26, ["Mega|Fly"] = 73.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 104.98}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Neon"] = 3.34, ["Neon|Fly"] = 33.73, ["Mega"] = 19.69, ["Mega|Ride"] = 118.21}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Fly|Ride"] = 420, ["Mega"] = 25.34, ["Mega|Ride"] = 216.54, ["Mega|Fly|Ride"] = 167.35}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 26.23, ["Ride"] = 16.36, ["Fly|Ride"] = 69.56, ["Neon"] = 3.91, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 18.3, ["Neon|Fly|Ride"] = 48.89, ["Mega"] = 34.12, ["Mega|Ride"] = 51.93, ["Mega|Fly|Ride"] = 110.43}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 6.49, ["Ride"] = 78.75, ["Fly|Ride"] = 220.95, ["Neon"] = 83.69, ["Neon|Ride"] = 78.75, ["Mega"] = 369.22, ["Mega|Ride"] = 494.97, ["Mega|Fly|Ride"] = 603.18}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Ride"] = 47.52, ["Neon"] = 42.29, ["Neon|Ride"] = 157.5, ["Mega"] = 249.78, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 2.1, ["Ride"] = 33.47, ["Fly|Ride"] = 105, ["Neon"] = 25.7, ["Neon|Ride"] = 148.07, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 232.32, ["Mega|Ride"] = 280.63, ["Mega|Fly|Ride"] = 388.5}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 12.98, ["Ride"] = 12.68, ["Fly|Ride"] = 37.24, ["Neon"] = 2.1, ["Neon|Fly"] = 19.47, ["Neon|Ride"] = 13.11, ["Neon|Fly|Ride"] = 30.64, ["Mega"] = 14.7, ["Mega|Fly"] = 22.95, ["Mega|Ride"] = 27.36, ["Mega|Fly|Ride"] = 82.87}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 2.1, ["Fly"] = 118.13, ["Ride"] = 61.32, ["Neon"] = 12.04, ["Neon|Fly"] = 69.39, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 736.93, ["Mega"] = 125.95, ["Mega|Ride"] = 118.13}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.5, ["Neon"] = 2.1, ["Neon|Fly"] = 32.36, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 86.67, ["Mega"] = 14.91, ["Mega|Fly"] = 148.07, ["Mega|Fly|Ride"] = 209.99}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Neon"] = 3.04, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 127.32, ["Mega"] = 17.05, ["Mega|Fly"] = 220.95, ["Mega|Fly|Ride"] = 367.49}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.1, ["Fly"] = 147.84, ["Ride"] = 19.41, ["Fly|Ride"] = 45.55, ["Neon"] = 8.27, ["Neon|Fly"] = 59.05, ["Neon|Ride"] = 34, ["Neon|Fly|Ride"] = 90.68, ["Mega"] = 153.11, ["Mega|Ride"] = 160.13, ["Mega|Fly|Ride"] = 274.98}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 224.21, ["Ride"] = 236.25, ["Fly|Ride"] = 847.66, ["Neon|Ride"] = 949.28, ["Neon|Fly|Ride"] = 972.87, ["Mega"] = 8838.5, ["Mega|Fly|Ride"] = 3415.69}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 8.33, ["Neon|Ride"] = 64.31, ["Mega"] = 68.25, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 2.1, ["Fly"] = 103.69, ["Ride"] = 25.22, ["Fly|Ride"] = 65.62, ["Neon"] = 28.69, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 176.78, ["Mega"] = 387.21, ["Mega|Ride"] = 330.33, ["Mega|Fly|Ride"] = 350.41}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 16.19, ["Fly|Ride"] = 36.75, ["Neon"] = 4.33, ["Neon|Fly"] = 34.13, ["Neon|Ride"] = 23.62, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 49.79, ["Mega|Ride"] = 88.38, ["Mega|Fly|Ride"] = 148.04}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 73.05, ["Ride"] = 19.69, ["Fly|Ride"] = 136.86, ["Neon"] = 10.37, ["Neon|Ride"] = 72.34, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 87.5, ["Mega|Fly|Ride"] = 419.99}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 2.1, ["Fly"] = 27.96, ["Ride"] = 16.96, ["Fly|Ride"] = 43.32, ["Neon"] = 31.49, ["Neon|Fly"] = 101.25, ["Neon|Ride"] = 41.6, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 144.38, ["Mega|Ride"] = 982.19, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 3.94, ["Ride"] = 35.37, ["Fly|Ride"] = 249.6, ["Neon"] = 51.19, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 257.27, ["Mega|Ride"] = 325.9, ["Mega|Fly|Ride"] = 387.18}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.62, ["Fly"] = 24.86, ["Ride"] = 16.34, ["Fly|Ride"] = 32.82, ["Neon"] = 34.71, ["Neon|Fly"] = 97.86, ["Neon|Ride"] = 26.3, ["Neon|Fly|Ride"] = 69.95, ["Mega"] = 262.5, ["Mega|Ride"] = 383.34, ["Mega|Fly|Ride"] = 346.49}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 72.18, ["Fly"] = 78.7, ["Ride"] = 97.13, ["Fly|Ride"] = 149.41, ["Neon"] = 333.38, ["Neon|Fly"] = 450.19, ["Neon|Ride"] = 392.04, ["Neon|Fly|Ride"] = 365.97, ["Mega|Fly|Ride"] = 1468.69}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 223.13, ["Fly"] = 441.94, ["Ride"] = 223.13, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1166.6, ["Neon|Fly|Ride"] = 1296.49, ["Mega"] = 13257.75, ["Mega|Fly|Ride"] = 3684.13}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 52.5, ["Fly"] = 109.51, ["Ride"] = 65.9, ["Fly|Ride"] = 101.88, ["Neon"] = 495.96, ["Neon|Fly"] = 374.55, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 324.19, ["Mega|Fly|Ride"] = 1532.35}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 2.49, ["Fly"] = 288.3, ["Ride"] = 25.73, ["Fly|Ride"] = 122.4, ["Neon"] = 17.06, ["Neon|Ride"] = 99.31, ["Neon|Fly|Ride"] = 154.07, ["Mega"] = 238.88, ["Mega|Ride"] = 190.32, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 11.06, ["Fly"] = 81.77, ["Ride"] = 30.03, ["Fly|Ride"] = 65.63, ["Neon"] = 65.62, ["Neon|Ride"] = 101.98, ["Neon|Fly|Ride"] = 144.79, ["Mega"] = 314.9, ["Mega|Ride"] = 364.88, ["Mega|Fly|Ride"] = 379.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 37.06, ["Ride"] = 18.26, ["Fly|Ride"] = 51.93, ["Neon"] = 4.43, ["Neon|Fly"] = 57.44, ["Neon|Ride"] = 20.58, ["Neon|Fly|Ride"] = 62.16, ["Mega"] = 38.13, ["Mega|Fly"] = 152.39, ["Mega|Ride"] = 82.69, ["Mega|Fly|Ride"] = 566.99}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 10.18, ["Fly"] = 70.72, ["Ride"] = 32.8, ["Fly|Ride"] = 67.45, ["Neon"] = 109.38, ["Neon|Fly"] = 368.97, ["Neon|Ride"] = 117.11, ["Neon|Fly|Ride"] = 307.7, ["Mega"] = 530.25, ["Mega|Ride"] = 566.99, ["Mega|Fly|Ride"] = 546.83}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 42, ["Ride"] = 17.69, ["Fly|Ride"] = 38.07, ["Neon"] = 19.66, ["Neon|Fly"] = 53.05, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 90.32, ["Mega"] = 144.23, ["Mega|Ride"] = 264.89, ["Mega|Fly|Ride"] = 291.06}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Fly"] = 39.79, ["Ride"] = 20.75, ["Fly|Ride"] = 328.13, ["Neon"] = 27.9, ["Neon|Ride"] = 74.03, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 207.37, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 236.41, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 27.67, ["Ride"] = 19.37, ["Neon"] = 2.1, ["Neon|Ride"] = 19.29, ["Neon|Fly|Ride"] = 57.74, ["Mega"] = 15.29, ["Mega|Ride"] = 44.2, ["Mega|Fly|Ride"] = 78.73}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 25.43, ["Ride"] = 19.13, ["Fly|Ride"] = 44.63, ["Neon"] = 12.99, ["Neon|Fly"] = 110.5, ["Neon|Ride"] = 37.48, ["Neon|Fly|Ride"] = 147, ["Mega"] = 78.72, ["Mega|Fly"] = 110.49, ["Mega|Ride"] = 109.39, ["Mega|Fly|Ride"] = 217.23}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.1, ["Fly"] = 61.04, ["Ride"] = 21.38, ["Fly|Ride"] = 78.82, ["Neon"] = 23.33, ["Neon|Ride"] = 47.25, ["Mega"] = 144.37, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 273.98}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 106.31, ["Fly"] = 183.4, ["Ride"] = 145.84, ["Fly|Ride"] = 199.95, ["Neon"] = 406.88, ["Neon|Ride"] = 515.23, ["Neon|Fly|Ride"] = 584.07, ["Mega"] = 2498.07, ["Mega|Fly|Ride"] = 1975.32}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 5.22, ["Ride"] = 240.93, ["Fly|Ride"] = 131.25, ["Neon"] = 33.66, ["Neon|Ride"] = 98.43, ["Neon|Fly|Ride"] = 216.57, ["Mega"] = 280.88, ["Mega|Ride"] = 284.81, ["Mega|Fly|Ride"] = 376.82}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 3.93, ["Fly"] = 44.24, ["Ride"] = 15.73, ["Fly|Ride"] = 62.87, ["Neon"] = 14.86, ["Neon|Ride"] = 62.99, ["Neon|Fly|Ride"] = 128.64, ["Mega"] = 223.13, ["Mega|Ride"] = 185.8, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 21.92, ["Ride"] = 39.38, ["Fly|Ride"] = 167.23, ["Neon"] = 98.44, ["Neon|Ride"] = 167.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 520.84, ["Mega|Fly"] = 883.86, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 696.1}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.84}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 2.1, ["Ride"] = 99.44, ["Fly|Ride"] = 131.48, ["Neon"] = 59.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 499.55, ["Mega|Ride"] = 647.36, ["Mega|Fly|Ride"] = 883.86}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 22.32, ["Fly"] = 28.34, ["Ride"] = 24.92, ["Fly|Ride"] = 53.91, ["Neon"] = 90.57, ["Neon|Fly"] = 132.58, ["Neon|Ride"] = 141.43, ["Neon|Fly|Ride"] = 150.9, ["Mega"] = 1426.32, ["Mega|Fly|Ride"] = 666.9}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.82, ["Neon|Ride"] = 44.6, ["Neon|Fly|Ride"] = 140.31, ["Mega"] = 28.82, ["Mega|Fly"] = 189, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 195.33}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.34, ["Fly"] = 26.22, ["Ride"] = 21.25, ["Fly|Ride"] = 65.63, ["Neon"] = 66.3, ["Mega"] = 288.62, ["Mega|Fly"] = 417.19, ["Mega|Ride"] = 275.63, ["Mega|Fly|Ride"] = 530.25}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Fly"] = 28.96, ["Ride"] = 18.9, ["Fly|Ride"] = 41.13, ["Neon"] = 16.29, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 43.05, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 148.04, ["Mega|Ride"] = 223.38, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 82.87, ["Neon"] = 4.19, ["Neon|Fly"] = 280.61, ["Neon|Ride"] = 41.99, ["Mega"] = 65.62, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 26.22, ["Fly"] = 105, ["Ride"] = 66.32, ["Fly|Ride"] = 98.44, ["Neon"] = 177.61, ["Neon|Ride"] = 179.82, ["Neon|Fly|Ride"] = 576.19, ["Mega"] = 874.81, ["Mega|Fly"] = 656.36, ["Mega|Ride"] = 689.07, ["Mega|Fly|Ride"] = 759.06}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 2.1, ["Ride"] = 48.57, ["Fly|Ride"] = 210, ["Neon"] = 96.12, ["Neon|Ride"] = 43.73, ["Mega|Ride"] = 331.42}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 10.01, ["Fly"] = 24.94, ["Ride"] = 20.99, ["Fly|Ride"] = 44.2, ["Neon"] = 11.54, ["Neon|Fly"] = 88.38, ["Neon|Ride"] = 31.81, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 120.1, ["Mega|Ride"] = 154.37, ["Mega|Fly|Ride"] = 278.58}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 64.32, ["Fly"] = 145.01, ["Ride"] = 130.37, ["Neon"] = 441.89, ["Neon|Ride"] = 590.63, ["Neon|Fly|Ride"] = 534.87, ["Mega"] = 4664.45, ["Mega|Ride"] = 1575, ["Mega|Fly|Ride"] = 2385.59}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.45, ["Fly"] = 46.51, ["Ride"] = 24.86, ["Fly|Ride"] = 57.27, ["Neon"] = 35.48, ["Neon|Ride"] = 48.45, ["Neon|Fly|Ride"] = 145.84, ["Mega"] = 262.48, ["Mega|Ride"] = 237.47, ["Mega|Fly|Ride"] = 317.09}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 72.7, ["Fly"] = 143.07, ["Ride"] = 118.12, ["Fly|Ride"] = 220.95, ["Neon"] = 262.4, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 368.5, ["Mega"] = 1076.25, ["Mega|Ride"] = 1615.06, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.95, ["Ride"] = 62.96, ["Fly|Ride"] = 167.62, ["Neon"] = 77.83, ["Neon|Ride"] = 104.23, ["Neon|Fly|Ride"] = 167.41, ["Mega"] = 349.53, ["Mega|Ride"] = 347.82, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 4.24, ["Fly"] = 39.38, ["Ride"] = 26.3, ["Fly|Ride"] = 72.43, ["Neon"] = 100.87, ["Neon|Fly|Ride"] = 148.07, ["Mega"] = 666.9, ["Mega|Ride"] = 587.77, ["Mega|Fly|Ride"] = 648.55}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 16.71, ["Ride"] = 53.82, ["Fly|Ride"] = 105, ["Neon"] = 61.74, ["Neon|Ride"] = 142.77, ["Neon|Fly|Ride"] = 220.95, ["Mega"] = 459.38, ["Mega|Fly"] = 538, ["Mega|Ride"] = 382.92, ["Mega|Fly|Ride"] = 415.75}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 7.46, ["Ride"] = 32.75, ["Fly|Ride"] = 66.3, ["Neon"] = 38.68, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 144.96, ["Mega"] = 223.13, ["Mega|Ride"] = 292.22, ["Mega|Fly|Ride"] = 448.33}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.6, ["Neon|Fly"] = 103.85, ["Neon|Ride"] = 88.38, ["Mega"] = 19.49, ["Mega|Ride"] = 148.04}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.83, ["Ride"] = 70.72, ["Fly|Ride"] = 325.9, ["Neon"] = 42.42, ["Neon|Ride"] = 245.25, ["Mega"] = 238.88, ["Mega|Ride"] = 522.38, ["Mega|Fly|Ride"] = 751.54}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 131.49, ["Ride"] = 29.85, ["Neon"] = 19.69, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 249.78, ["Mega|Ride"] = 428.64, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 4.87, ["Ride"] = 32.8, ["Neon"] = 17.07, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 187.69, ["Mega|Ride"] = 295, ["Mega|Fly|Ride"] = 519.74}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 525, ["Ride"] = 557.81, ["Fly|Ride"] = 630, ["Neon"] = 2209.37, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1706.25, ["Mega|Fly|Ride"] = 4830}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.96, ["Fly"] = 45.47, ["Ride"] = 23.29, ["Fly|Ride"] = 64.32, ["Neon"] = 43.11, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 341.24, ["Mega"] = 206.61, ["Mega|Ride"] = 382.33, ["Mega|Fly|Ride"] = 366.78}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 6.2, ["Fly"] = 64.29, ["Ride"] = 20.95, ["Fly|Ride"] = 55.21, ["Neon"] = 95.25, ["Neon|Fly"] = 315, ["Neon|Ride"] = 98.34, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 331.88, ["Mega|Ride"] = 405.43, ["Mega|Fly|Ride"] = 681.45}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.49, ["Fly"] = 24.93, ["Ride"] = 17.07, ["Fly|Ride"] = 50.79, ["Neon"] = 16.45, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 198.19, ["Mega|Ride"] = 265.14}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 65.62, ["Ride"] = 23.36, ["Fly|Ride"] = 90.57, ["Neon"] = 8.53, ["Neon|Ride"] = 37.48, ["Neon|Fly|Ride"] = 165.72, ["Mega"] = 74.69, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Ride"] = 24.11, ["Neon"] = 2.58, ["Neon|Ride"] = 32.01, ["Neon|Fly|Ride"] = 198.98, ["Mega"] = 22.05, ["Mega|Ride"] = 83.69, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1378.13}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 12.17, ["Ride"] = 57.22, ["Fly|Ride"] = 182.77, ["Neon"] = 71.67, ["Neon|Ride"] = 112.87, ["Neon|Fly|Ride"] = 368.43, ["Mega"] = 334.69, ["Mega|Ride"] = 368.43, ["Mega|Fly|Ride"] = 446.25}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 19.25, ["Neon"] = 6.34, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 1031.8, ["Mega"] = 39.38, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 183.1}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 4.68, ["Fly"] = 335.13, ["Ride"] = 91.88, ["Fly|Ride"] = 148.07, ["Neon"] = 32.82, ["Neon|Ride"] = 111.71, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 270.82, ["Mega|Fly"] = 551.25, ["Mega|Ride"] = 364.58, ["Mega|Fly|Ride"] = 498.32}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 407.51, ["Ride"] = 446.24, ["Fly|Ride"] = 531.57, ["Neon"] = 1723.41, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1311.45, ["Mega"] = 8286.09, ["Mega|Fly|Ride"] = 6357.75}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 2.45, ["Fly"] = 196.88, ["Ride"] = 40.69, ["Fly|Ride"] = 132.58, ["Neon"] = 210, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 199.86, ["Mega"] = 366.78, ["Mega|Ride"] = 362.77, ["Mega|Fly|Ride"] = 530.32}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 97.43, ["Ride"] = 35.63, ["Fly|Ride"] = 118.12, ["Neon"] = 3.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 99.44, ["Mega"] = 38.87, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 143.53}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 95.82, ["Neon"] = 5.25, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 30.18, ["Mega|Ride"] = 81.77, ["Mega|Fly|Ride"] = 435.75}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 34.13, ["Fly"] = 110.49, ["Ride"] = 104.57, ["Fly|Ride"] = 176.76, ["Neon"] = 129.94, ["Neon|Fly"] = 167.35, ["Neon|Ride"] = 440.78, ["Neon|Fly|Ride"] = 441.31, ["Mega"] = 667.24, ["Mega|Ride"] = 722.48, ["Mega|Fly|Ride"] = 714.66}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 8.4, ["Neon"] = 95.19, ["Neon|Ride"] = 277.32, ["Neon|Fly|Ride"] = 883.86, ["Mega"] = 583.23, ["Mega|Ride"] = 485.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.36, ["Ride"] = 76.13, ["Fly|Ride"] = 225.86, ["Neon"] = 101.07, ["Neon|Ride"] = 176.76, ["Mega"] = 683.23, ["Mega|Ride"] = 653.99, ["Mega|Fly|Ride"] = 1325.8}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 14.44, ["Ride"] = 33.92, ["Fly|Ride"] = 226.9, ["Neon"] = 131.25, ["Neon|Ride"] = 170.46, ["Neon|Fly|Ride"] = 241.5, ["Mega"] = 723.19, ["Mega|Ride"] = 810.85, ["Mega|Fly|Ride"] = 649.42}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.82, ["Fly|Ride"] = 751.2, ["Neon"] = 918.75, ["Neon|Ride"] = 1473.66, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 6.12, ["Ride"] = 60.27, ["Fly|Ride"] = 147.07, ["Neon"] = 148.32, ["Neon|Ride"] = 196.17, ["Mega|Ride"] = 561.1, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 4.27, ["Ride"] = 27.72, ["Fly|Ride"] = 127.32, ["Neon"] = 104.99, ["Neon|Ride"] = 148.04, ["Mega"] = 170.63, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 629.99}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 44.41, ["Ride"] = 144.99, ["Fly|Ride"] = 452.82, ["Neon"] = 183.74, ["Neon|Ride"] = 258.16, ["Neon|Fly|Ride"] = 547.35, ["Mega"] = 384.57, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Fly"] = 59.68, ["Ride"] = 72.19, ["Fly|Ride"] = 220.98, ["Neon"] = 7.58, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 286.13, ["Mega"] = 39.38, ["Mega|Ride"] = 176.76, ["Mega|Fly|Ride"] = 281.06}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 46.99, ["Ride"] = 95.8, ["Neon"] = 262.42, ["Neon|Ride"] = 359.63, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 1601.99, ["Mega|Ride"] = 2925.56, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 109.38, ["Ride"] = 28.24, ["Neon"] = 9.24, ["Neon|Fly"] = 192.27, ["Neon|Ride"] = 42.38, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 72.07, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Ride"] = 54.49, ["Fly|Ride"] = 102.42, ["Neon"] = 3.71, ["Neon|Fly"] = 59.68, ["Neon|Ride"] = 37.57, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 40, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 70.6, ["Mega|Fly|Ride"] = 294.97}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.1, ["Ride"] = 27.78, ["Fly|Ride"] = 133.66, ["Neon"] = 11.68, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 88.6, ["Mega|Ride"] = 108.29, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 62.81, ["Fly"] = 105, ["Ride"] = 72.19, ["Fly|Ride"] = 152.39, ["Neon"] = 300.57, ["Neon|Ride"] = 437.07, ["Neon|Fly|Ride"] = 499.55, ["Mega|Ride"] = 1162.28, ["Mega|Fly|Ride"] = 1115.63}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 5.01, ["Ride"] = 33.73, ["Neon"] = 18.75, ["Neon|Fly"] = 350.44, ["Neon|Ride"] = 49.87, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 69.82, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 21.19, ["Neon"] = 8.32, ["Neon|Ride"] = 27.57, ["Mega"] = 52.5, ["Mega|Fly"] = 210, ["Mega|Ride"] = 95.82, ["Mega|Fly|Ride"] = 241.4}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 2.1, ["Fly"] = 110.49, ["Ride"] = 32.82, ["Fly|Ride"] = 98.44, ["Neon"] = 32.82, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 351.3, ["Mega|Ride"] = 351.56, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 6.33, ["Fly"] = 78.75, ["Ride"] = 59.18, ["Fly|Ride"] = 154.87, ["Neon"] = 28.28, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 178.67, ["Mega"] = 190.32, ["Mega|Ride"] = 148.12, ["Mega|Fly|Ride"] = 383.41}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 71.61, ["Neon"] = 6.05, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 29.81, ["Mega|Ride"] = 118.21, ["Mega|Fly|Ride"] = 294.97}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 19.44, ["Fly|Ride"] = 62.86, ["Neon"] = 4.17, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 28.87, ["Neon|Fly|Ride"] = 99.38, ["Mega"] = 42, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 262.12}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.23, ["Fly"] = 27.5, ["Ride"] = 21.48, ["Fly|Ride"] = 57.74, ["Neon"] = 6.59, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 118.21, ["Mega"] = 165.74, ["Mega|Ride"] = 141.75, ["Mega|Fly|Ride"] = 249.74}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 24.31, ["Fly"] = 74.03, ["Ride"] = 29.08, ["Fly|Ride"] = 82.88, ["Neon"] = 144.36, ["Neon|Ride"] = 249.78, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 485.63, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 666.9}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 62.98, ["Ride"] = 90.56, ["Fly|Ride"] = 145.85, ["Neon"] = 363.83, ["Neon|Fly"] = 430.64, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 465.94, ["Mega"] = 2195.02, ["Mega|Ride"] = 1988.43, ["Mega|Fly|Ride"] = 1515.32}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Ride"] = 19.51, ["Fly|Ride"] = 170.63, ["Neon"] = 3.94, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 34.02, ["Neon|Fly|Ride"] = 146.73, ["Mega"] = 35.53, ["Mega|Fly"] = 672, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 259.34}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 17.53, ["Ride"] = 15.65, ["Fly|Ride"] = 43.72, ["Neon"] = 4.18, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 17.46, ["Neon|Fly|Ride"] = 61.69, ["Mega"] = 36.75, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 78.75}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.1, ["Fly"] = 44.2, ["Ride"] = 38.03, ["Fly|Ride"] = 110.49, ["Neon"] = 40.68, ["Neon|Ride"] = 160.12, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 560.16, ["Mega|Ride"] = 275.62, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 393.74, ["Ride"] = 613.14, ["Fly|Ride"] = 584.07, ["Neon"] = 4419.26, ["Neon|Fly|Ride"] = 1771.88, ["Mega|Fly|Ride"] = 6163.5}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 18.18, ["Fly"] = 103.85, ["Ride"] = 55.67, ["Fly|Ride"] = 137.15, ["Neon"] = 150.47, ["Neon|Ride"] = 236.41, ["Neon|Fly|Ride"] = 219.01, ["Mega"] = 720.57, ["Mega|Ride"] = 859.46, ["Mega|Fly|Ride"] = 922.42}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 25.48, ["Fly|Ride"] = 91.87, ["Neon"] = 7.71, ["Neon|Ride"] = 51.45, ["Neon|Fly|Ride"] = 72.19, ["Mega"] = 105, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 291.65}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 88.24, ["Ride"] = 62.37, ["Fly|Ride"] = 261.98, ["Neon"] = 73.38, ["Mega"] = 157.5}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 30.09, ["Fly"] = 169.32, ["Ride"] = 47.16, ["Fly|Ride"] = 78.75, ["Neon"] = 194.25, ["Neon|Ride"] = 236.25, ["Neon|Fly|Ride"] = 267.27, ["Mega"] = 2651.56, ["Mega|Ride"] = 2100, ["Mega|Fly|Ride"] = 1002.75}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 108.94, ["Ride"] = 128.63, ["Fly|Ride"] = 182.77, ["Neon"] = 430.1, ["Neon|Fly"] = 839.57, ["Neon|Ride"] = 546.83, ["Neon|Fly|Ride"] = 446.25, ["Mega"] = 3241.53, ["Mega|Fly|Ride"] = 2576.14}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 249.38, ["Ride"] = 304.5, ["Fly|Ride"] = 551.25, ["Neon"] = 938.44, ["Neon|Ride"] = 800.63, ["Neon|Fly|Ride"] = 1035.57, ["Mega|Fly|Ride"] = 2867.82}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 7.59, ["Ride"] = 34.13, ["Fly|Ride"] = 206.59, ["Neon"] = 80.55, ["Neon|Ride"] = 88.27, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 871.5, ["Mega|Ride"] = 404.04, ["Mega|Fly|Ride"] = 433.13}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.97, ["Ride"] = 16.42, ["Fly|Ride"] = 38.85, ["Neon"] = 7.08, ["Neon|Ride"] = 27.49, ["Neon|Fly|Ride"] = 61.34, ["Mega"] = 103.85, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 187.94}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 2.43, ["Fly"] = 50.38, ["Ride"] = 21.86, ["Fly|Ride"] = 45.02, ["Neon"] = 26.24, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 41.16, ["Neon|Fly|Ride"] = 97.12, ["Mega"] = 288.7, ["Mega|Ride"] = 266.44, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 328.13, ["Ride"] = 374.06, ["Fly|Ride"] = 779.92, ["Neon"] = 1470.67, ["Neon|Fly|Ride"] = 2209.37, ["Mega"] = 11048.12, ["Mega|Fly|Ride"] = 6037.5}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 34.28, ["Neon"] = 10.4, ["Neon|Ride"] = 139.41, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 27.84, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 453}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.73, ["Fly"] = 24.99, ["Ride"] = 16.37, ["Fly|Ride"] = 43.14, ["Neon"] = 24.43, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 79.48, ["Mega"] = 163.5, ["Mega|Ride"] = 146.99, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 13.77, ["Ride"] = 57.29, ["Neon"] = 84, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 104.99, ["Neon|Fly|Ride"] = 144.38, ["Mega"] = 551.25, ["Mega|Ride"] = 582.25, ["Mega|Fly|Ride"] = 736.84}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 120.63, ["Fly"] = 59.07, ["Ride"] = 154.1, ["Fly|Ride"] = 165.38, ["Neon|Ride"] = 832.99, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2181.76}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 17.34, ["Fly"] = 37.82, ["Ride"] = 27.92, ["Fly|Ride"] = 56.43, ["Neon"] = 102.92, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 147, ["Mega"] = 875.44, ["Mega|Ride"] = 401.49, ["Mega|Fly|Ride"] = 481.23}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 37.44, ["Neon"] = 3.49, ["Neon|Ride"] = 65.63, ["Mega"] = 25.87, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Fly"] = 32.7, ["Ride"] = 17.07, ["Fly|Ride"] = 86.16, ["Neon"] = 2.1, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 27.34, ["Neon|Fly|Ride"] = 87.82, ["Mega"] = 22.32, ["Mega|Fly"] = 96.12, ["Mega|Ride"] = 43.32, ["Mega|Fly|Ride"] = 220.95}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 12.84, ["Fly"] = 103.28, ["Ride"] = 65.62, ["Fly|Ride"] = 271.77, ["Neon"] = 39.27, ["Neon|Ride"] = 100.69, ["Neon|Fly|Ride"] = 219.27, ["Mega"] = 147.67, ["Mega|Ride"] = 212.4, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1181.24, ["Ride"] = 1168.13, ["Fly|Ride"] = 1312.5, ["Neon"] = 3543.75, ["Neon|Ride"] = 4418.74, ["Neon|Fly|Ride"] = 4017.24, ["Mega|Fly|Ride"] = 10498.95}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 393.74, ["Ride"] = 511.88, ["Fly|Ride"] = 519.75, ["Neon"] = 1680, ["Neon|Ride"] = 1443.74, ["Neon|Fly|Ride"] = 1509.38, ["Mega"] = 15467.36, ["Mega|Fly|Ride"] = 6186.23}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 320.24, ["Fly"] = 422.13, ["Ride"] = 354.22, ["Fly|Ride"] = 440.79, ["Neon"] = 759.94, ["Neon|Fly"] = 883.76, ["Neon|Ride"] = 708.75, ["Neon|Fly|Ride"] = 724.5, ["Mega|Ride"] = 3684.13, ["Mega|Fly|Ride"] = 2916.24}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 242.82, ["Fly"] = 288.75, ["Ride"] = 291.36, ["Fly|Ride"] = 341.25, ["Neon"] = 654.89, ["Neon|Ride"] = 695.63, ["Neon|Fly|Ride"] = 650.22, ["Mega|Fly|Ride"] = 3462.09}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 42.2, ["Ride"] = 19.93, ["Fly|Ride"] = 49.87, ["Neon"] = 4.99, ["Neon|Ride"] = 34.86, ["Neon|Fly|Ride"] = 110.49, ["Mega"] = 81.76, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 167.41}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 282.19, ["Fly"] = 1473.84, ["Ride"] = 354.38, ["Fly|Ride"] = 375.37, ["Neon"] = 1312.5, ["Neon|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 1443.75, ["Mega"] = 22391.21, ["Mega|Ride"] = 5892.39, ["Mega|Fly|Ride"] = 4860.61}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 6.54, ["Fly"] = 183.74, ["Ride"] = 52.5, ["Neon"] = 28.74, ["Neon|Fly|Ride"] = 291.29, ["Mega"] = 224.44, ["Mega|Ride"] = 351.3, ["Mega|Fly|Ride"] = 837.36}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 23.56, ["Ride"] = 16.47, ["Fly|Ride"] = 39.38, ["Neon"] = 6.22, ["Neon|Ride"] = 55.26, ["Neon|Fly|Ride"] = 53.81, ["Mega"] = 128.63, ["Mega|Ride"] = 192.31, ["Mega|Fly|Ride"] = 131.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Neon"] = 3.93, ["Mega"] = 22.31, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 177.62}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 31.49, ["Ride"] = 131.24, ["Fly|Ride"] = 459.38, ["Neon"] = 236.25, ["Neon|Ride"] = 359.73, ["Mega"] = 1050, ["Mega|Ride"] = 523.69, ["Mega|Fly|Ride"] = 773.07}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.1, ["Fly"] = 8327.25, ["Ride"] = 32.82, ["Fly|Ride"] = 68.25, ["Neon"] = 18.57, ["Mega"] = 366.78, ["Mega|Ride"] = 300.53, ["Mega|Fly|Ride"] = 446.24}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 29.85, ["Neon"] = 2.48, ["Neon|Ride"] = 57.72, ["Neon|Fly|Ride"] = 141.93, ["Mega"] = 19.27, ["Mega|Ride"] = 167.4, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 87.62, ["Ride"] = 66.25, ["Fly|Ride"] = 91.87, ["Neon"] = 25.87, ["Neon|Fly"] = 110.49, ["Neon|Ride"] = 85.65, ["Neon|Fly|Ride"] = 175.88, ["Mega"] = 212.94, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 320.25}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 3.06, ["Fly"] = 22.11, ["Ride"] = 18.38, ["Fly|Ride"] = 50.94, ["Neon"] = 27.57, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 238.85, ["Mega|Ride"] = 236.41, ["Mega|Fly|Ride"] = 1321.69}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 8.47, ["Ride"] = 38.07, ["Fly|Ride"] = 167.35, ["Neon"] = 59.07, ["Neon|Ride"] = 176.76, ["Neon|Fly|Ride"] = 333.46, ["Mega"] = 524.99, ["Mega|Ride"] = 574.58}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.1, ["Fly"] = 6662.3, ["Ride"] = 23.63, ["Fly|Ride"] = 190.32, ["Neon"] = 65.62, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 749.33, ["Mega"] = 393.75, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 71.31, ["Ride"] = 15.69, ["Fly|Ride"] = 41.23, ["Neon"] = 4.03, ["Neon|Fly"] = 81.65, ["Neon|Ride"] = 28.66, ["Mega"] = 38.06, ["Mega|Fly|Ride"] = 232.35}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 192.93, ["Fly"] = 244.15, ["Ride"] = 190.19, ["Fly|Ride"] = 196.88, ["Neon"] = 1001.96, ["Neon|Ride"] = 1056.08, ["Neon|Fly|Ride"] = 1111.34, ["Mega"] = 8838.5, ["Mega|Fly|Ride"] = 4495.87}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 24.7, ["Ride"] = 17.69, ["Fly|Ride"] = 29.57, ["Neon"] = 2.56, ["Neon|Fly"] = 37.5, ["Neon|Ride"] = 20.61, ["Neon|Fly|Ride"] = 48.57, ["Mega"] = 55.17, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 147}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 7.66, ["Ride"] = 44.21, ["Fly|Ride"] = 235.1, ["Neon"] = 52.5, ["Neon|Ride"] = 117.43, ["Neon|Fly|Ride"] = 767.54, ["Mega"] = 499.55, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 26.25, ["Ride"] = 97.22, ["Fly|Ride"] = 183.75, ["Neon"] = 216.55, ["Neon|Ride"] = 355.69, ["Neon|Fly|Ride"] = 414.23, ["Mega"] = 780.13, ["Mega|Ride"] = 1029.06, ["Mega|Fly|Ride"] = 944.99}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 216.07, ["Fly"] = 274.36, ["Ride"] = 238.05, ["Fly|Ride"] = 314.22, ["Neon"] = 832.99, ["Neon|Fly"] = 1666.22, ["Neon|Ride"] = 711.38, ["Neon|Fly|Ride"] = 721.88, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["default"] = 13.13, ["Fly"] = 133.66, ["Ride"] = 167.4, ["Neon"] = 141.38, ["Neon|Ride"] = 190.28, ["Neon|Fly|Ride"] = 441.89, ["Mega"] = 276.05, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 437.49}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 6.56, ["Ride"] = 58.45, ["Fly|Ride"] = 147.9, ["Neon"] = 165.38, ["Neon|Fly"] = 167.4, ["Neon|Ride"] = 330.33, ["Neon|Fly|Ride"] = 220.95, ["Mega"] = 1767.72, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 736.84}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 950.25, ["Fly"] = 1787.7, ["Ride"] = 931.88, ["Fly|Ride"] = 1028.99, ["Neon"] = 5118.75, ["Neon|Ride"] = 4383.75, ["Neon|Fly|Ride"] = 3937.5, ["Mega|Fly|Ride"] = 17673.81}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 4.03, ["Fly"] = 28.88, ["Ride"] = 18.88, ["Fly|Ride"] = 45.93, ["Neon"] = 49.12, ["Neon|Fly"] = 72.19, ["Neon|Ride"] = 77.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 249.78, ["Mega|Fly|Ride"] = 302.3}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 3.72, ["Fly"] = 262.5, ["Ride"] = 41.14, ["Fly|Ride"] = 135.19, ["Neon"] = 30.19, ["Neon|Ride"] = 124.9, ["Mega"] = 196.88, ["Mega|Fly"] = 1260, ["Mega|Ride"] = 332.07, ["Mega|Fly|Ride"] = 341.23}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 2.1, ["Fly"] = 87.61, ["Ride"] = 24.31, ["Fly|Ride"] = 81.76, ["Neon"] = 11.46, ["Neon|Ride"] = 49.96, ["Neon|Fly|Ride"] = 74.03, ["Mega"] = 81.23, ["Mega|Ride"] = 368.97, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 12.22, ["Ride"] = 35.33, ["Fly|Ride"] = 124.83, ["Neon"] = 59.07, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 257.24, ["Mega"] = 446.25, ["Mega|Ride"] = 423.21, ["Mega|Fly|Ride"] = 452.51}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 2.1, ["Fly"] = 24.51, ["Ride"] = 21.58, ["Fly|Ride"] = 43.32, ["Neon"] = 14.96, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 73.37, ["Mega"] = 146.5, ["Mega|Fly"] = 280.98, ["Mega|Ride"] = 169.32, ["Mega|Fly|Ride"] = 184.53}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 36.27, ["Ride"] = 26.17, ["Fly|Ride"] = 131.25, ["Neon"] = 15.64, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 50.8, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 152.14, ["Mega|Ride"] = 227.07, ["Mega|Fly|Ride"] = 275.61}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 259.88, ["Ride"] = 339.14, ["Fly|Ride"] = 441.94, ["Neon"] = 1214.07, ["Neon|Fly|Ride"] = 1183.01, ["Mega|Fly|Ride"] = 3497.28}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.63, ["Fly"] = 31.5, ["Ride"] = 27.57, ["Fly|Ride"] = 105.59, ["Neon"] = 7.62, ["Neon|Ride"] = 72.18, ["Neon|Fly|Ride"] = 293.87, ["Mega"] = 77.44, ["Mega|Ride"] = 131.3, ["Mega|Fly|Ride"] = 342.2}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 2.1, ["Ride"] = 65.61, ["Fly|Ride"] = 88.86, ["Neon"] = 17.31, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 195.57, ["Mega|Ride"] = 353.55}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 2.1, ["Fly"] = 94.76, ["Ride"] = 39.38, ["Neon"] = 10.17, ["Neon|Ride"] = 50.93, ["Neon|Fly|Ride"] = 106.07, ["Mega"] = 99.75, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 515.91}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 65.63, ["Ride"] = 131.04, ["Fly|Ride"] = 260.4, ["Neon"] = 309.33, ["Neon|Ride"] = 483, ["Neon|Fly|Ride"] = 548.63, ["Mega"] = 1489.13, ["Mega|Ride"] = 1544.37, ["Mega|Fly|Ride"] = 1586.33}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 21.8, ["Fly"] = 89.87, ["Ride"] = 59.68, ["Fly|Ride"] = 282.83, ["Neon"] = 128.58, ["Neon|Ride"] = 437.85, ["Neon|Fly|Ride"] = 341.93, ["Mega"] = 682.5, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.38, ["Fly"] = 253, ["Ride"] = 32.81, ["Fly|Ride"] = 117.11, ["Neon"] = 85.85, ["Neon|Ride"] = 114.19, ["Neon|Fly|Ride"] = 210, ["Mega"] = 589.91, ["Mega|Ride"] = 445.69, ["Mega|Fly|Ride"] = 577}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 3.94, ["Ride"] = 41.35, ["Neon"] = 20.97, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 146.73, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 31.18, ["Fly"] = 91.88, ["Ride"] = 77.09, ["Fly|Ride"] = 155.92, ["Neon"] = 328.13, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 288.75, ["Mega|Fly|Ride"] = 1151.07}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 15.75, ["Fly|Ride"] = 216.09, ["Neon"] = 6.18, ["Neon|Fly|Ride"] = 131.49, ["Mega"] = 91.88, ["Mega|Ride"] = 295, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 16.83, ["Fly"] = 39.38, ["Ride"] = 28.88, ["Fly|Ride"] = 69.57, ["Neon"] = 64.55, ["Neon|Fly"] = 84, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 360.7, ["Mega|Fly"] = 971.25, ["Mega|Ride"] = 396.6, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 43.66, ["Fly"] = 203.42, ["Ride"] = 86.67, ["Fly|Ride"] = 131.25, ["Neon"] = 262.5, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 282.17, ["Neon|Fly|Ride"] = 351.75, ["Mega|Ride"] = 1511.22, ["Mega|Fly|Ride"] = 1254.75}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 19.74, ["Ride"] = 16.11, ["Fly|Ride"] = 53.05, ["Neon"] = 2.6, ["Neon|Fly"] = 25.43, ["Neon|Ride"] = 17.56, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 18.76, ["Mega|Ride"] = 39.9, ["Mega|Fly|Ride"] = 78.69}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 3.02, ["Fly"] = 105, ["Ride"] = 28.98, ["Fly|Ride"] = 64.97, ["Neon"] = 13.13, ["Neon|Ride"] = 51.99, ["Neon|Fly|Ride"] = 168, ["Mega"] = 166.51, ["Mega|Ride"] = 221.03, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 9.19, ["Ride"] = 41.91, ["Fly|Ride"] = 117.25, ["Neon"] = 116.81, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 270.27, ["Mega"] = 722.48, ["Mega|Ride"] = 432.04, ["Mega|Fly|Ride"] = 570.04}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 16.58, ["Neon"] = 2.1, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 97.79, ["Mega"] = 22.2, ["Mega|Ride"] = 55.26, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 30.85, ["Fly"] = 210, ["Ride"] = 72.19, ["Fly|Ride"] = 277.32, ["Neon"] = 149.92, ["Neon|Ride"] = 267.31, ["Neon|Fly|Ride"] = 418.69, ["Mega"] = 740.5, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 718.19, ["Mega|Fly|Ride"] = 795.47}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 11.34, ["Fly"] = 44.2, ["Ride"] = 26.48, ["Fly|Ride"] = 97.11, ["Neon"] = 240.87, ["Neon|Ride"] = 136.64, ["Neon|Fly|Ride"] = 170.14, ["Mega"] = 472.82, ["Mega|Ride"] = 458.07, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 5.16, ["Ride"] = 61.7, ["Neon"] = 56.65, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 67.44, ["Neon|Fly|Ride"] = 219.84, ["Mega"] = 246.75, ["Mega|Ride"] = 369.7, ["Mega|Fly|Ride"] = 441.89}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 6.57, ["Fly"] = 74.03, ["Ride"] = 84.09, ["Fly|Ride"] = 257.28, ["Neon"] = 43.23, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 196.87, ["Mega"] = 287.44, ["Mega|Ride"] = 441.94, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Ride"] = 37.57, ["Fly|Ride"] = 196.88, ["Neon"] = 6.55, ["Neon|Fly"] = 210, ["Neon|Ride"] = 37.82, ["Mega"] = 69.57, ["Mega|Fly"] = 220.95, ["Mega|Ride"] = 91.71, ["Mega|Fly|Ride"] = 294.97}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Fly|Ride"] = 86.63, ["Neon"] = 3.02, ["Neon|Ride"] = 37.23, ["Neon|Fly|Ride"] = 167.35, ["Mega"] = 44.63, ["Mega|Ride"] = 93.45, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 17.07}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 42.95, ["Fly"] = 78.75, ["Ride"] = 58.5, ["Fly|Ride"] = 97.09, ["Neon"] = 196.88, ["Neon|Ride"] = 220.95, ["Neon|Fly|Ride"] = 312.38, ["Mega"] = 1854.36, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 832.99}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Fly"] = 85.32, ["Ride"] = 65.63, ["Fly|Ride"] = 110.49, ["Neon"] = 2.1, ["Neon|Ride"] = 27.19, ["Mega"] = 23.38, ["Mega|Ride"] = 176.76, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 498.74, ["Ride"] = 525, ["Fly|Ride"] = 572.25, ["Neon"] = 3977.33, ["Mega"] = 13257.75, ["Mega|Fly|Ride"] = 10500}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 9.95, ["Fly"] = 49.38, ["Ride"] = 34.12, ["Fly|Ride"] = 58.27, ["Neon"] = 72.97, ["Neon|Fly"] = 183.75, ["Neon|Ride"] = 117.43, ["Mega"] = 333.46, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 648.55}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 2.1, ["Fly"] = 29.11, ["Ride"] = 17.98, ["Fly|Ride"] = 59.96, ["Neon"] = 21.57, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 164.07, ["Mega|Fly"] = 192.23, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 252}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 9.75, ["Ride"] = 44.2, ["Fly|Ride"] = 589.98, ["Neon"] = 112.88, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 515.91, ["Mega|Ride"] = 388.5, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 44.2, ["Ride"] = 38.57, ["Fly|Ride"] = 74.03, ["Neon"] = 45.47, ["Neon|Fly"] = 74.03, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 282.19, ["Mega|Ride"] = 293.87, ["Mega|Fly|Ride"] = 515.96}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 6.3, ["Ride"] = 32.49, ["Fly|Ride"] = 196.88, ["Neon"] = 85.31, ["Neon|Ride"] = 99.74, ["Neon|Fly|Ride"] = 145.84, ["Mega"] = 546.83, ["Mega|Ride"] = 415.8, ["Mega|Fly|Ride"] = 522.8}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 7.51, ["Ride"] = 21, ["Fly|Ride"] = 103.85, ["Neon"] = 32.8, ["Neon|Fly"] = 105, ["Neon|Ride"] = 99.38, ["Neon|Fly|Ride"] = 284.64, ["Mega"] = 207.93, ["Mega|Ride"] = 368.43, ["Mega|Fly|Ride"] = 350.44}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 48.74, ["Ride"] = 13.82, ["Fly|Ride"] = 34.13, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.44, ["Neon|Fly|Ride"] = 36.49, ["Mega"] = 15.59, ["Mega|Fly"] = 67.45, ["Mega|Ride"] = 33.15, ["Mega|Fly|Ride"] = 76.13}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 5.92, ["Fly"] = 56.35, ["Ride"] = 56.43, ["Fly|Ride"] = 110.5, ["Neon"] = 70.64, ["Neon|Fly"] = 124.9, ["Neon|Ride"] = 78.74, ["Neon|Fly|Ride"] = 151.16, ["Mega"] = 212.18, ["Mega|Ride"] = 148.07, ["Mega|Fly|Ride"] = 424.6}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 252, ["Ride"] = 269.07, ["Fly|Ride"] = 489.57, ["Neon"] = 1298.81, ["Neon|Ride"] = 1010.63, ["Neon|Fly|Ride"] = 1003.12, ["Mega"] = 4994.15, ["Mega|Ride"] = 9692.43, ["Mega|Fly|Ride"] = 4566.76}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 76.13, ["Ride"] = 104.97, ["Fly|Ride"] = 262.5, ["Neon"] = 458.07, ["Neon|Fly"] = 945.74, ["Neon|Ride"] = 479.07, ["Neon|Fly|Ride"] = 522.38, ["Mega"] = 2357.67, ["Mega|Ride"] = 1837.5, ["Mega|Fly|Ride"] = 1543.5}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 15.01, ["Fly|Ride"] = 57.46, ["Neon"] = 7.44, ["Neon|Fly"] = 103.87, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 62.51, ["Mega"] = 50.84, ["Mega|Fly"] = 219.87, ["Mega|Ride"] = 128.13, ["Mega|Fly|Ride"] = 248.73}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 14.42, ["Fly|Ride"] = 38.07, ["Neon"] = 7.54, ["Neon|Fly"] = 32.81, ["Neon|Ride"] = 25.89, ["Neon|Fly|Ride"] = 53.46, ["Mega"] = 67.16, ["Mega|Fly"] = 294.97, ["Mega|Ride"] = 101.58, ["Mega|Fly|Ride"] = 150.52}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.1, ["Fly"] = 103.87, ["Ride"] = 22.3, ["Fly|Ride"] = 98.44, ["Neon"] = 116.82, ["Neon|Ride"] = 43.73, ["Neon|Fly|Ride"] = 157.5, ["Mega|Ride"] = 444.77, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 196.87, ["Ride"] = 234.94, ["Fly|Ride"] = 346.5, ["Neon"] = 1215.17, ["Neon|Ride"] = 1244.99, ["Neon|Fly|Ride"] = 1063.08, ["Mega|Ride"] = 8838.5, ["Mega|Fly|Ride"] = 3937.5}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 42.49, ["Ride"] = 16.2, ["Fly|Ride"] = 49.96, ["Neon"] = 19.44, ["Neon|Fly"] = 104.97, ["Neon|Ride"] = 24.93, ["Neon|Fly|Ride"] = 73.49, ["Mega"] = 262.5, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 331.42}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 2.1, ["Ride"] = 78.75, ["Fly|Ride"] = 196.87, ["Neon"] = 29.78, ["Neon|Ride"] = 112.7, ["Mega"] = 250.79, ["Mega|Ride"] = 305.16, ["Mega|Fly|Ride"] = 441.94}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.48, ["Neon|Ride"] = 44.2, ["Mega"] = 118.35, ["Mega|Ride"] = 339.2}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 12.97, ["Fly"] = 58.12, ["Ride"] = 19.68, ["Fly|Ride"] = 55.86, ["Neon"] = 99.49, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 367.5, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 37.54, ["Ride"] = 90.57, ["Fly|Ride"] = 262.5, ["Neon"] = 107.71, ["Neon|Fly"] = 656.15, ["Neon|Ride"] = 164.07, ["Neon|Fly|Ride"] = 315.13, ["Mega"] = 459.37, ["Mega|Fly"] = 2320.12, ["Mega|Ride"] = 514.54, ["Mega|Fly|Ride"] = 649.59}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 27.55, ["Fly"] = 44.23, ["Ride"] = 49.97, ["Fly|Ride"] = 103.92, ["Neon"] = 144.38, ["Neon|Fly"] = 286.43, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 203.28, ["Mega|Ride"] = 700.88, ["Mega|Fly|Ride"] = 840}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 16.67, ["Ride"] = 16.33, ["Fly|Ride"] = 37.57, ["Neon"] = 2.1, ["Neon|Fly"] = 32.64, ["Neon|Ride"] = 17.18, ["Neon|Fly|Ride"] = 45.92, ["Mega"] = 32.06, ["Mega|Fly"] = 43.31, ["Mega|Ride"] = 32.49, ["Mega|Fly|Ride"] = 90.3}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 216.57, ["Ride"] = 246.74, ["Fly|Ride"] = 341.25, ["Neon"] = 3488.84, ["Neon|Ride"] = 1281.45, ["Neon|Fly|Ride"] = 1399.64, ["Mega|Fly|Ride"] = 5270.45}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 7.85, ["Fly"] = 101.18, ["Ride"] = 24.89, ["Fly|Ride"] = 107.14, ["Neon"] = 74.86, ["Neon|Ride"] = 141.42, ["Neon|Fly|Ride"] = 458.47, ["Mega"] = 378.16, ["Mega|Ride"] = 501.6, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 37.57, ["Ride"] = 19.03, ["Fly|Ride"] = 51.93, ["Neon"] = 6.01, ["Neon|Fly"] = 38.58, ["Neon|Ride"] = 29.85, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 45.94, ["Mega|Fly"] = 236.45, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 259.88}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 24.09, ["Fly|Ride"] = 87.66, ["Neon"] = 2.1, ["Neon|Fly"] = 81.99, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 112.43, ["Mega"] = 24.94, ["Mega|Fly"] = 144.38, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 146.63}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.45, ["Ride"] = 22.11, ["Fly|Ride"] = 98.44, ["Neon"] = 13.12, ["Neon|Fly"] = 749.43, ["Neon|Ride"] = 33.73, ["Mega"] = 155.54, ["Mega|Ride"] = 158.24, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 6, ["Fly"] = 32.82, ["Ride"] = 24.93, ["Fly|Ride"] = 69.57, ["Neon"] = 47.25, ["Neon|Fly"] = 250.45, ["Neon|Ride"] = 48.12, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 262.5, ["Mega|Ride"] = 325.9, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 5.07, ["Ride"] = 32.82, ["Neon"] = 134.79, ["Neon|Ride"] = 152.49, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 275.63, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 301.87}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Ride"] = 59.68, ["Neon"] = 2.63, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 118.21, ["Mega"] = 19.26, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 192.23}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 5.15, ["Fly"] = 83.99, ["Ride"] = 33.15, ["Fly|Ride"] = 148.04, ["Neon"] = 39.38, ["Neon|Fly"] = 146.63, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 142.96, ["Mega"] = 174.57, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 31.48, ["Neon"] = 3.93, ["Neon|Fly"] = 118.21, ["Neon|Ride"] = 29.59, ["Neon|Fly|Ride"] = 108.26, ["Mega"] = 29.27, ["Mega|Ride"] = 124.84, ["Mega|Fly|Ride"] = 325.9}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 57.24, ["Ride"] = 17.82, ["Fly|Ride"] = 45.94, ["Neon"] = 3.74, ["Neon|Ride"] = 25.18, ["Neon|Fly|Ride"] = 122.63, ["Mega"] = 45.94, ["Mega|Ride"] = 131.15, ["Mega|Fly|Ride"] = 281.69}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 630, ["Ride"] = 636.69, ["Fly|Ride"] = 771.75, ["Neon"] = 2625, ["Neon|Ride"] = 3497.28, ["Neon|Fly|Ride"] = 3150, ["Mega|Fly|Ride"] = 9620.63}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 18.34, ["Ride"] = 15.65, ["Fly|Ride"] = 39.38, ["Neon"] = 19.9, ["Neon|Fly"] = 44.2, ["Neon|Ride"] = 26.99, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly|Ride"] = 335.58}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 51.93, ["Neon"] = 7.69, ["Neon|Fly"] = 773.38, ["Neon|Ride"] = 58.3, ["Neon|Fly|Ride"] = 155.93, ["Mega"] = 89.24, ["Mega|Fly"] = 167.35, ["Mega|Ride"] = 111.57, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 8.43, ["Fly"] = 22.92, ["Ride"] = 21, ["Fly|Ride"] = 50.89, ["Neon"] = 32.81, ["Neon|Fly"] = 198.41, ["Neon|Ride"] = 49.96, ["Neon|Fly|Ride"] = 115.76, ["Mega"] = 485.63, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 376.67}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 43.72, ["Ride"] = 15.84, ["Fly|Ride"] = 38.07, ["Neon"] = 7.5, ["Neon|Fly"] = 52.48, ["Neon|Ride"] = 23.39, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 69.57, ["Mega|Ride"] = 94.56, ["Mega|Fly|Ride"] = 127.35}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 41.73, ["Ride"] = 59.07, ["Neon"] = 219.84, ["Neon|Ride"] = 295, ["Mega"] = 978.7, ["Mega|Ride"] = 788.76, ["Mega|Fly|Ride"] = 810.94}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 18.8, ["Fly|Ride"] = 148.04, ["Neon"] = 6.56, ["Neon|Fly"] = 142.41, ["Neon|Ride"] = 37.82, ["Neon|Fly|Ride"] = 113.38, ["Mega"] = 46.77, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 106.32, ["Mega|Fly|Ride"] = 277.3}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 21.83, ["Fly|Ride"] = 85.59, ["Neon"] = 10.68, ["Neon|Ride"] = 40.31, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 114.09, ["Mega|Ride"] = 198.6, ["Mega|Fly|Ride"] = 325.5}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Ride"] = 44.2, ["Fly|Ride"] = 65.84, ["Neon"] = 12.13, ["Neon|Fly|Ride"] = 110.49, ["Mega"] = 103.69, ["Mega|Ride"] = 165.72}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 2490.79, ["Ride"] = 18.65, ["Fly|Ride"] = 69.45, ["Neon"] = 4.2, ["Neon|Fly"] = 72.39, ["Neon|Ride"] = 21.34, ["Neon|Fly|Ride"] = 86.63, ["Mega"] = 65.19, ["Mega|Fly"] = 229.69, ["Mega|Ride"] = 71.52}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 11.82, ["Fly"] = 21.39, ["Ride"] = 19.68, ["Fly|Ride"] = 38.07, ["Neon"] = 124.69, ["Neon|Ride"] = 103.85, ["Neon|Fly|Ride"] = 143.63, ["Mega|Ride"] = 550.75, ["Mega|Fly|Ride"] = 488.95}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 721.88, ["Fly"] = 1104.69, ["Ride"] = 776.12, ["Fly|Ride"] = 820.32, ["Neon"] = 1584.19, ["Neon|Ride"] = 1771.88, ["Neon|Fly|Ride"] = 1837.5, ["Mega"] = 8633.84, ["Mega|Ride"] = 4068.75, ["Mega|Fly|Ride"] = 4462.5}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.1, ["Fly"] = 22.32, ["Ride"] = 15.74, ["Fly|Ride"] = 47.53, ["Neon"] = 2.1, ["Neon|Fly"] = 44.2, ["Neon|Ride"] = 23.12, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 37.42, ["Mega|Ride"] = 148.07, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 6.57, ["Ride"] = 36.75, ["Fly|Ride"] = 206.59, ["Neon"] = 167.35, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 432.98, ["Mega|Ride"] = 199.86, ["Mega|Fly|Ride"] = 531.57}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 49.88, ["Ride"] = 70.89, ["Fly|Ride"] = 114.93, ["Neon"] = 315, ["Neon|Ride"] = 313.69, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 2475.65}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 26.25, ["Fly"] = 146.73, ["Ride"] = 58.23, ["Fly|Ride"] = 100.56, ["Neon"] = 176.76, ["Neon|Ride"] = 129.22, ["Neon|Fly|Ride"] = 250.79, ["Mega"] = 828.53, ["Mega|Ride"] = 971.03, ["Mega|Fly|Ride"] = 785.11}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 11.3, ["Fly"] = 97.43, ["Ride"] = 42.94, ["Fly|Ride"] = 65.63, ["Neon"] = 63.95, ["Neon|Ride"] = 126, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 305.36, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 467.78}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 18.17, ["Ride"] = 72.45, ["Fly|Ride"] = 148.07, ["Neon"] = 111.99, ["Neon|Ride"] = 106.32, ["Neon|Fly|Ride"] = 341.25, ["Mega"] = 390.48, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 397.69}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 23.02, ["Ride"] = 163.36, ["Neon"] = 148.19, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 383.34, ["Mega"] = 546.83, ["Mega|Ride"] = 476.44, ["Mega|Fly|Ride"] = 634.17}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 7.2}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.74, ["Ride"] = 26.25, ["Fly|Ride"] = 105, ["Neon"] = 25.85, ["Neon|Ride"] = 99.44, ["Neon|Fly|Ride"] = 213.97, ["Mega"] = 178.5, ["Mega|Fly"] = 458.27, ["Mega|Ride"] = 233.72, ["Mega|Fly|Ride"] = 308.05}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.1, ["Neon"] = 20.15, ["Mega"] = 139.32, ["Mega|Fly|Ride"] = 385.88}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 25.97, ["Fly"] = 62.99, ["Ride"] = 32.5, ["Fly|Ride"] = 86.63, ["Neon"] = 165.38, ["Neon|Fly"] = 295, ["Neon|Ride"] = 211.01, ["Neon|Fly|Ride"] = 242.97, ["Mega"] = 1285.53, ["Mega|Ride"] = 775.68, ["Mega|Fly|Ride"] = 691.87}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.42, ["Fly"] = 23.22, ["Ride"] = 15.93, ["Fly|Ride"] = 36.29, ["Neon"] = 22.22, ["Neon|Fly"] = 100.42, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 78.22, ["Mega"] = 222.31, ["Mega|Fly"] = 441.89, ["Mega|Ride"] = 183.74, ["Mega|Fly|Ride"] = 200.1}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 3.93, ["Fly"] = 108.22, ["Ride"] = 26.25, ["Fly|Ride"] = 42.77, ["Neon"] = 24.94, ["Neon|Ride"] = 47.7, ["Neon|Fly|Ride"] = 128.63, ["Mega"] = 157.49, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 254.62}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 6.43, ["Mega"] = 52.46, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 258.57}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 32.21, ["Ride"] = 49.96, ["Fly|Ride"] = 148.04, ["Neon"] = 192.23, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 441.89, ["Mega"] = 616.88, ["Mega|Ride"] = 1767.72, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 33.34, ["Fly|Ride"] = 58.15, ["Neon"] = 7.64, ["Neon|Fly"] = 203.44, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 141.36, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 6.3, ["Ride"] = 45.94, ["Fly|Ride"] = 293.87, ["Neon"] = 56.6, ["Neon|Ride"] = 110.49, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 397.69, ["Mega|Fly"] = 589.91, ["Mega|Ride"] = 413.17, ["Mega|Fly|Ride"] = 547.94}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 15.52, ["Neon"] = 14.32, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 100.34, ["Mega"] = 194.25, ["Mega|Ride"] = 155.28, ["Mega|Fly|Ride"] = 288.74}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 2.1, ["Fly"] = 52.49, ["Ride"] = 19.53, ["Fly|Ride"] = 49.81, ["Neon"] = 51.19, ["Neon|Fly"] = 72.93, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 298.53, ["Mega|Ride"] = 397.74, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 6.23, ["Mega"] = 418.06, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 57.16, ["Ride"] = 117.94, ["Fly|Ride"] = 148.04, ["Neon"] = 291.38, ["Neon|Ride"] = 393.75, ["Neon|Fly|Ride"] = 883.76, ["Mega"] = 1442.73, ["Mega|Ride"] = 1498.63, ["Mega|Fly|Ride"] = 1286.25}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 15.33, ["Ride"] = 59.77, ["Fly|Ride"] = 161.28, ["Neon"] = 107.63, ["Neon|Ride"] = 149.16, ["Mega"] = 421.32, ["Mega|Ride"] = 418.69, ["Mega|Fly|Ride"] = 689.73}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 2.52, ["Ride"] = 115.25, ["Neon"] = 146.64, ["Neon|Fly"] = 220.98, ["Neon|Ride"] = 170.63, ["Mega|Ride"] = 459.38}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 24.91, ["Ride"] = 131.48, ["Fly|Ride"] = 367.49, ["Neon"] = 153.07, ["Neon|Fly"] = 269.58, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 726.9, ["Mega|Fly"] = 2209.64, ["Mega|Ride"] = 656.2, ["Mega|Fly|Ride"] = 842.92}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 2.1, ["Neon"] = 22.55, ["Mega"] = 196.88, ["Mega|Ride"] = 276.19, ["Mega|Fly|Ride"] = 333.46}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 17.5, ["Fly|Ride"] = 41.99, ["Neon"] = 3.76, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 24.89, ["Neon|Fly|Ride"] = 62.52, ["Mega"] = 65.7, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 29.84, ["Fly|Ride"] = 82.66, ["Neon"] = 15.11, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 164.06, ["Mega"] = 90.57, ["Mega|Ride"] = 104.98, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 147.84, ["Ride"] = 19.68, ["Fly|Ride"] = 72.01, ["Neon"] = 5.06, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 99.16, ["Mega"] = 55.11, ["Mega|Ride"] = 84, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 3.63, ["Fly"] = 65.63, ["Ride"] = 20.89, ["Fly|Ride"] = 74.05, ["Neon"] = 22.09, ["Neon|Ride"] = 148.07, ["Neon|Fly|Ride"] = 220.98, ["Mega"] = 328.02, ["Mega|Ride"] = 336, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 2.51, ["Fly"] = 62.73, ["Ride"] = 26.25, ["Fly|Ride"] = 441.94, ["Neon"] = 29.85, ["Neon|Fly"] = 315, ["Neon|Ride"] = 87.94, ["Mega"] = 313.74, ["Mega|Ride"] = 287.47, ["Mega|Fly|Ride"] = 1104.83}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 9.19, ["Fly"] = 131.24, ["Ride"] = 23.73, ["Fly|Ride"] = 58.75, ["Neon"] = 27.68, ["Neon|Fly"] = 135.69, ["Neon|Ride"] = 55.42, ["Neon|Fly|Ride"] = 102.9, ["Mega|Ride"] = 441.89, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 35.49, ["Ride"] = 16.57, ["Fly|Ride"] = 52.41, ["Neon"] = 29.37, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 154.68, ["Mega"] = 274.98, ["Mega|Ride"] = 166.83, ["Mega|Fly|Ride"] = 188.07}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 2.1, ["Fly"] = 288.73, ["Ride"] = 47.22, ["Neon"] = 13.13, ["Neon|Fly"] = 437.06, ["Neon|Ride"] = 89.25, ["Neon|Fly|Ride"] = 192.23, ["Mega"] = 113.81, ["Mega|Fly"] = 216.8, ["Mega|Ride"] = 126.06, ["Mega|Fly|Ride"] = 272.71}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 22.32, ["Ride"] = 82.69, ["Fly|Ride"] = 332.07, ["Neon"] = 82.69, ["Neon|Ride"] = 233.59, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 367.05, ["Mega|Ride"] = 735.74, ["Mega|Fly|Ride"] = 649.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 45.8, ["Fly"] = 164.07, ["Ride"] = 97.22, ["Fly|Ride"] = 187.69, ["Neon"] = 187.01, ["Neon|Ride"] = 275.43, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1619.48, ["Mega|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 1089.38}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Ride"] = 22.11, ["Fly|Ride"] = 53.05, ["Neon"] = 2.1, ["Neon|Ride"] = 21.72, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 53.82, ["Mega|Ride"] = 72.93, ["Mega|Fly|Ride"] = 123.38}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 6.28, ["Ride"] = 105, ["Neon"] = 105.94, ["Mega"] = 692.66, ["Mega|Fly|Ride"] = 1164.36}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 57.75, ["Ride"] = 68.25, ["Fly|Ride"] = 174.75, ["Neon"] = 249.37, ["Neon|Ride"] = 295.32, ["Neon|Fly|Ride"] = 883.76, ["Mega"] = 1820.74, ["Mega|Ride"] = 1473.66, ["Mega|Fly|Ride"] = 1603.88}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.64, ["Fly"] = 190.32, ["Ride"] = 27.75, ["Fly|Ride"] = 133.88, ["Neon"] = 31.19, ["Neon|Fly"] = 133.55, ["Neon|Ride"] = 88.38, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 267.46, ["Mega|Fly"] = 753.85, ["Mega|Ride"] = 241.5, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 2.63, ["Fly|Ride"] = 132.58, ["Neon"] = 12.43, ["Neon|Ride"] = 70.65, ["Neon|Fly|Ride"] = 210, ["Mega"] = 81.04, ["Mega|Fly"] = 282.17, ["Mega|Ride"] = 133.34, ["Mega|Fly|Ride"] = 265.46}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 34.13, ["Ride"] = 20.99, ["Fly|Ride"] = 45.93, ["Neon"] = 10.5, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 37.61, ["Neon|Fly|Ride"] = 97.46, ["Mega"] = 147.41, ["Mega|Fly"] = 196.87, ["Mega|Ride"] = 105}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 18.9, ["Ride"] = 14.56, ["Fly|Ride"] = 52.4, ["Neon"] = 2.21, ["Neon|Fly"] = 130.08, ["Neon|Ride"] = 23.14, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 24.78, ["Mega|Ride"] = 74.96, ["Mega|Fly|Ride"] = 160.06}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 20.83, ["Fly|Ride"] = 42, ["Neon"] = 4.15, ["Neon|Ride"] = 22.91, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 37.16, ["Mega|Fly"] = 166.32, ["Mega|Ride"] = 51.48, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 2.1, ["Neon|Ride"] = 29.85, ["Mega"] = 23.93, ["Mega|Fly|Ride"] = 441}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 3.69, ["Ride"] = 40.94, ["Neon"] = 48.24, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 141.75, ["Mega"] = 417.19, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 440.84}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 3.84, ["Ride"] = 26.24, ["Fly|Ride"] = 219.81, ["Neon"] = 62.34, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 231, ["Mega"] = 286.79, ["Mega|Ride"] = 233.89, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 4.13, ["Fly"] = 26.24, ["Ride"] = 17.74, ["Fly|Ride"] = 40.31, ["Neon"] = 52.5, ["Neon|Ride"] = 38.61, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 364.58, ["Mega|Ride"] = 279.37, ["Mega|Fly|Ride"] = 311.72}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 92.8, ["Ride"] = 97.46, ["Fly|Ride"] = 124.69, ["Neon"] = 393.75, ["Neon|Ride"] = 487.24, ["Neon|Fly|Ride"] = 736.93, ["Mega"] = 2497.71, ["Mega|Ride"] = 1665.87, ["Mega|Fly|Ride"] = 1544.82}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 19.25, ["Fly"] = 82.69, ["Ride"] = 58.97, ["Neon"] = 1028.43, ["Neon|Fly|Ride"] = 630, ["Mega"] = 464.63, ["Mega|Ride"] = 879.38, ["Mega|Fly|Ride"] = 1090.05}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.3, ["Fly|Ride"] = 41.57, ["Neon"] = 2.63, ["Neon|Fly"] = 44.2, ["Neon|Ride"] = 21, ["Neon|Fly|Ride"] = 56.44, ["Mega"] = 28.88, ["Mega|Ride"] = 93.44, ["Mega|Fly|Ride"] = 133.88}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 16.38, ["Ride"] = 16.2, ["Fly|Ride"] = 33.47, ["Neon"] = 3.93, ["Neon|Fly"] = 27.54, ["Neon|Ride"] = 20.92, ["Neon|Fly|Ride"] = 44.63, ["Mega"] = 39.25, ["Mega|Ride"] = 49.87, ["Mega|Fly|Ride"] = 113.21}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 411.6, ["Fly"] = 586.98, ["Ride"] = 460.06, ["Fly|Ride"] = 524.97, ["Neon"] = 2430.31, ["Neon|Fly|Ride"] = 2098.69, ["Mega|Fly|Ride"] = 6661.35}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 3.62, ["Ride"] = 63.49, ["Neon"] = 48.55, ["Neon|Ride"] = 90.57, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 413.17, ["Mega|Ride"] = 736.84, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 15.41, ["Ride"] = 17.07, ["Fly|Ride"] = 38.74, ["Neon"] = 5.01, ["Neon|Fly"] = 25.43, ["Neon|Ride"] = 22.19, ["Neon|Fly|Ride"] = 56.42, ["Mega"] = 33.6, ["Mega|Ride"] = 146.73, ["Mega|Fly|Ride"] = 118.23}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 44.12, ["Ride"] = 131.29, ["Fly|Ride"] = 736.84, ["Neon"] = 157.5, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 525, ["Mega"] = 737.62, ["Mega|Ride"] = 748.13, ["Mega|Fly|Ride"] = 796.19}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 28.98, ["Ride"] = 19.68, ["Fly|Ride"] = 55.13, ["Neon"] = 15.73, ["Neon|Fly"] = 101.37, ["Neon|Ride"] = 27.55, ["Neon|Fly|Ride"] = 77.83, ["Mega"] = 118.13, ["Mega|Ride"] = 124.69, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Ride"] = 20.81, ["Fly|Ride"] = 196.88, ["Neon"] = 2.63, ["Neon|Fly"] = 103.85, ["Neon|Ride"] = 144.22, ["Neon|Fly|Ride"] = 111.57, ["Mega"] = 18.38, ["Mega|Ride"] = 53.81, ["Mega|Fly|Ride"] = 236.41}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 39.35, ["Fly"] = 129.94, ["Ride"] = 77.44, ["Fly|Ride"] = 215.25, ["Neon"] = 150.94, ["Neon|Ride"] = 249.71, ["Neon|Fly|Ride"] = 438.38, ["Mega"] = 733.53, ["Mega|Ride"] = 647.05, ["Mega|Fly|Ride"] = 714.21}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 23.63, ["Fly|Ride"] = 146.99, ["Neon"] = 6.51, ["Neon|Ride"] = 23.64, ["Neon|Fly|Ride"] = 88.38, ["Mega"] = 63.52, ["Mega|Ride"] = 189.53, ["Mega|Fly|Ride"] = 255.94}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 28.07, ["Ride"] = 69.51, ["Fly|Ride"] = 118.13, ["Neon"] = 283.23, ["Neon|Fly"] = 294.97, ["Neon|Ride"] = 229.69, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 1181.25, ["Mega|Ride"] = 1325.63, ["Mega|Fly|Ride"] = 1334.93}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 4.67, ["Ride"] = 131.25, ["Fly|Ride"] = 441.89, ["Neon"] = 31.15, ["Neon|Ride"] = 231, ["Neon|Fly|Ride"] = 506.2, ["Mega"] = 144.38, ["Mega|Ride"] = 427.52}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.1, ["Fly"] = 33.73, ["Ride"] = 94.5, ["Fly|Ride"] = 59.68, ["Neon"] = 9.84, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 449.66, ["Mega"] = 117.6, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 205.73}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 51.16, ["Fly"] = 192.23, ["Ride"] = 183.42, ["Fly|Ride"] = 167.35, ["Mega|Ride"] = 2756.25, ["Mega|Fly|Ride"] = 2063.56}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 587.49, ["Ride"] = 28.63, ["Neon"] = 4.65, ["Neon|Ride"] = 58.71, ["Neon|Fly|Ride"] = 118.21, ["Mega"] = 38.97, ["Mega|Fly"] = 220.95, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 283.5}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 24.67, ["Ride"] = 24.09, ["Fly|Ride"] = 102.88, ["Neon"] = 5.24, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 19.68, ["Neon|Fly|Ride"] = 99.92, ["Mega"] = 74.03, ["Mega|Fly"] = 153.64, ["Mega|Ride"] = 81.37, ["Mega|Fly|Ride"] = 224.81}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 5.24, ["Fly"] = 58.51, ["Ride"] = 38.52, ["Fly|Ride"] = 199.86, ["Neon"] = 72.19, ["Neon|Ride"] = 84, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 262.5, ["Mega|Ride"] = 275.5, ["Mega|Fly|Ride"] = 405.12}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 3.93, ["Fly"] = 65.63, ["Ride"] = 25.17, ["Fly|Ride"] = 74.94, ["Neon"] = 52.59, ["Neon|Ride"] = 49.26, ["Neon|Fly|Ride"] = 140.38, ["Mega"] = 354.38, ["Mega|Ride"] = 371.44, ["Mega|Fly|Ride"] = 420.05}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 17.53, ["Fly"] = 28.88, ["Ride"] = 33.73, ["Fly|Ride"] = 51.93, ["Neon"] = 52.5, ["Neon|Ride"] = 74.82, ["Neon|Fly|Ride"] = 157.94, ["Mega"] = 408.98, ["Mega|Ride"] = 327.45, ["Mega|Fly|Ride"] = 379.32}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 66.94, ["Ride"] = 122.92, ["Fly|Ride"] = 255.84, ["Neon"] = 315, ["Neon|Ride"] = 321.56, ["Neon|Fly|Ride"] = 459.38, ["Mega|Ride"] = 1766.4, ["Mega|Fly|Ride"] = 1757.56}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 7.16, ["Ride"] = 117.06, ["Fly|Ride"] = 262.5, ["Neon"] = 58.11, ["Neon|Fly"] = 99.92, ["Neon|Ride"] = 141.49, ["Neon|Fly|Ride"] = 356.98, ["Mega"] = 254.63, ["Mega|Ride"] = 413.17, ["Mega|Fly|Ride"] = 656.2}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 3.83, ["Ride"] = 25.58, ["Fly|Ride"] = 78.73, ["Neon"] = 22.5, ["Neon|Ride"] = 44.63, ["Mega"] = 176.76, ["Mega|Ride"] = 176.76, ["Mega|Fly|Ride"] = 499.55}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 6.57, ["Fly"] = 135.19, ["Ride"] = 29.99, ["Fly|Ride"] = 115.5, ["Neon"] = 44.15, ["Neon|Fly"] = 105, ["Neon|Ride"] = 42.38, ["Neon|Fly|Ride"] = 364.79, ["Mega"] = 309.33, ["Mega|Ride"] = 883.76, ["Mega|Fly|Ride"] = 497.44}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.99, ["Fly|Ride"] = 44.1, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 14.86, ["Neon|Fly|Ride"] = 43.24, ["Mega"] = 15.24, ["Mega|Fly"] = 42, ["Mega|Ride"] = 28.83, ["Mega|Fly|Ride"] = 115.49}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 45.9, ["Fly"] = 164.07, ["Ride"] = 107.62, ["Neon"] = 229.23, ["Neon|Fly"] = 2504.62, ["Neon|Ride"] = 294, ["Neon|Fly|Ride"] = 497.13, ["Mega"] = 1104.83, ["Mega|Ride"] = 813.75, ["Mega|Fly|Ride"] = 905.63}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 25.43, ["Fly|Ride"] = 148.04, ["Neon"] = 5.23, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 33.44, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 17.61, ["Fly|Ride"] = 45.93, ["Neon"] = 17.46, ["Neon|Ride"] = 21.28, ["Neon|Fly|Ride"] = 64.32, ["Mega"] = 257.25, ["Mega|Ride"] = 200.1}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 53.69, ["Ride"] = 91.88, ["Fly|Ride"] = 177.19, ["Neon"] = 227.38, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 409.5, ["Mega"] = 836.14, ["Mega|Ride"] = 800.63, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 72.19, ["Fly|Ride"] = 44.2, ["Neon"] = 5.8, ["Neon|Ride"] = 39.38, ["Mega"] = 44.77, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 273.66}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 5.52}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Ride"] = 35.44, ["Fly|Ride"] = 139.59, ["Neon"] = 6.44, ["Neon|Ride"] = 93.33, ["Neon|Fly|Ride"] = 218.91, ["Mega"] = 96.36, ["Mega|Ride"] = 107.85, ["Mega|Fly|Ride"] = 249.78}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 131.24, ["Ride"] = 183.75, ["Fly|Ride"] = 313.69, ["Neon"] = 666.9, ["Neon|Ride"] = 630, ["Neon|Fly|Ride"] = 678.57, ["Mega"] = 6628.1, ["Mega|Ride"] = 3331.15, ["Mega|Fly|Ride"] = 2451.03}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 3.93, ["Ride"] = 37.57, ["Fly|Ride"] = 220.98, ["Neon"] = 31.8, ["Neon|Fly"] = 148.07, ["Neon|Ride"] = 103.58, ["Neon|Fly|Ride"] = 219.43, ["Mega"] = 178.5, ["Mega|Ride"] = 227.85, ["Mega|Fly|Ride"] = 308.44}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 24.92, ["Neon"] = 3.9, ["Neon|Ride"] = 21.77, ["Mega"] = 45.88, ["Mega|Fly"] = 196.88, ["Mega|Ride"] = 68.51, ["Mega|Fly|Ride"] = 427.02}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 4.18, ["Ride"] = 36.74, ["Fly|Ride"] = 131.25, ["Neon"] = 65.52, ["Neon|Ride"] = 95.03, ["Neon|Fly|Ride"] = 163.5, ["Mega"] = 515.96, ["Mega|Ride"] = 579.12, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 7.35, ["Fly"] = 57.86, ["Ride"] = 19.69, ["Fly|Ride"] = 64.1, ["Neon"] = 101.04, ["Neon|Ride"] = 131.41, ["Neon|Fly|Ride"] = 220.98, ["Mega"] = 634.1, ["Mega|Ride"] = 440.78, ["Mega|Fly|Ride"] = 492.19}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 19.83, ["Ride"] = 56.76, ["Fly|Ride"] = 176.76, ["Neon"] = 147, ["Neon|Ride"] = 214.33, ["Neon|Fly|Ride"] = 339.14, ["Mega"] = 552.57, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 148.18, ["Fly"] = 196.88, ["Ride"] = 184.54, ["Fly|Ride"] = 236.23, ["Neon"] = 639.3, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 2504.33}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 5.25, ["Fly"] = 20.99, ["Ride"] = 17.84, ["Fly|Ride"] = 35.32, ["Neon"] = 70.09, ["Neon|Fly"] = 59.68, ["Neon|Ride"] = 56.44, ["Neon|Fly|Ride"] = 77.94, ["Mega"] = 331.42, ["Mega|Ride"] = 333.46, ["Mega|Fly|Ride"] = 372.28}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 74.03, ["Ride"] = 29.59, ["Fly|Ride"] = 131.25, ["Neon"] = 18.77, ["Neon|Ride"] = 39.36, ["Neon|Fly|Ride"] = 117.41, ["Mega"] = 159.1, ["Mega|Ride"] = 209.92, ["Mega|Fly|Ride"] = 291.98}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 6.57, ["Fly"] = 43.19, ["Ride"] = 40.69, ["Fly|Ride"] = 76.13, ["Neon"] = 45.46, ["Neon|Fly"] = 74.03, ["Neon|Ride"] = 51.44, ["Neon|Fly|Ride"] = 152.49, ["Mega"] = 463.93, ["Mega|Ride"] = 435.75, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 45.94, ["Fly"] = 82.62, ["Ride"] = 65.63, ["Fly|Ride"] = 135.89, ["Neon"] = 164.07, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 257.28, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 1000.85, ["Mega|Ride"] = 925.32, ["Mega|Fly|Ride"] = 964.68}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.34, ["Fly"] = 57.75, ["Ride"] = 267.35, ["Neon"] = 196.87, ["Neon|Ride"] = 233.59, ["Mega"] = 752.75, ["Mega|Ride"] = 700.39, ["Mega|Fly|Ride"] = 839.57}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 383.15, ["Ride"] = 350.44, ["Fly|Ride"] = 420, ["Neon"] = 1312.5, ["Neon|Ride"] = 1665.98, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 6923.86}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 13.13, ["Fly"] = 58.65, ["Ride"] = 25.54, ["Fly|Ride"] = 69.45, ["Neon"] = 256.3, ["Neon|Ride"] = 133.07, ["Neon|Fly|Ride"] = 280.61, ["Mega"] = 761.25, ["Mega|Ride"] = 753.54, ["Mega|Fly|Ride"] = 916.84}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 40.71, ["Ride"] = 13.86, ["Fly|Ride"] = 124.47, ["Neon"] = 2.1, ["Neon|Fly"] = 22.11, ["Neon|Ride"] = 16.91, ["Neon|Fly|Ride"] = 49.88, ["Mega"] = 23.31, ["Mega|Fly"] = 117.12, ["Mega|Ride"] = 73.38, ["Mega|Fly|Ride"] = 123.69}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 2.1, ["Ride"] = 41.08, ["Neon"] = 22.05, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 167.4, ["Mega"] = 148.32, ["Mega|Ride"] = 166.86, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.82, ["Ride"] = 32.82, ["Fly|Ride"] = 144.21, ["Neon"] = 18.38, ["Neon|Ride"] = 87.29, ["Neon|Fly|Ride"] = 1181.23, ["Mega"] = 141.54, ["Mega|Fly"] = 575.01, ["Mega|Ride"] = 393.28, ["Mega|Fly|Ride"] = 341.92}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 387.19, ["Fly"] = 393.75, ["Ride"] = 407.46, ["Fly|Ride"] = 446.25, ["Neon"] = 1968.75, ["Neon|Ride"] = 2063.8, ["Neon|Fly|Ride"] = 1914.94, ["Mega|Fly|Ride"] = 5662.27}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 16.41, ["Fly|Ride"] = 69.95, ["Neon"] = 18.89, ["Neon|Ride"] = 36.03, ["Neon|Fly|Ride"] = 113.74, ["Mega"] = 236.25, ["Mega|Ride"] = 220.95, ["Mega|Fly|Ride"] = 230.99}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 3.84, ["Fly"] = 28.73, ["Ride"] = 19.18, ["Fly|Ride"] = 32.82, ["Neon"] = 48.16, ["Neon|Fly"] = 156.45, ["Neon|Ride"] = 61.88, ["Neon|Fly|Ride"] = 139.13, ["Mega|Ride"] = 294.97, ["Mega|Fly|Ride"] = 315.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.76, ["Fly"] = 41.91, ["Ride"] = 28.73, ["Fly|Ride"] = 63.79, ["Neon"] = 15.58, ["Neon|Fly"] = 94.48, ["Neon|Ride"] = 44.2, ["Neon|Fly|Ride"] = 115.77, ["Mega"] = 94.5, ["Mega|Fly"] = 128.64, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 21.96, ["Fly"] = 58.71, ["Ride"] = 36.74, ["Fly|Ride"] = 132.58, ["Neon"] = 220.5, ["Neon|Ride"] = 209.99, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 1207.5, ["Mega|Ride"] = 862.32, ["Mega|Fly|Ride"] = 793.19}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 52.5, ["Fly|Ride"] = 51.85, ["Neon"] = 12.57, ["Neon|Ride"] = 67.45, ["Neon|Fly|Ride"] = 210, ["Mega"] = 165.4, ["Mega|Ride"] = 205.23, ["Mega|Fly|Ride"] = 1050.67}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 12.74, ["Fly"] = 93.13, ["Ride"] = 54.2, ["Neon"] = 146.99, ["Neon|Ride"] = 159.1, ["Neon|Fly|Ride"] = 259.23, ["Mega|Ride"] = 918.75}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 16.58, ["Neon"] = 5.25, ["Neon|Ride"] = 38.34, ["Mega"] = 65.63, ["Mega|Fly"] = 86304.75, ["Mega|Ride"] = 144.37, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 4.98, ["Neon"] = 57.75, ["Mega"] = 136.02, ["Mega|Ride"] = 219.84, ["Mega|Fly|Ride"] = 801.29}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 7.76, ["Ride"] = 44.2, ["Fly|Ride"] = 63, ["Neon"] = 45.5, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 883.86, ["Mega|Ride"] = 574.45, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 10.49, ["Fly"] = 34.13, ["Ride"] = 26.25, ["Fly|Ride"] = 59.96, ["Neon"] = 54.03, ["Neon|Fly"] = 117.41, ["Neon|Ride"] = 56.97, ["Neon|Fly|Ride"] = 98.87, ["Mega"] = 551.25, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 414.5, ["Fly"] = 624.44, ["Ride"] = 444.91, ["Fly|Ride"] = 525, ["Neon"] = 1659, ["Neon|Fly"] = 2072.89, ["Neon|Ride"] = 2842.38, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 7600.22}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Ride"] = 18.38, ["Fly|Ride"] = 40.69, ["Neon"] = 15.65, ["Neon|Fly"] = 83.71, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 269.58, ["Mega|Ride"] = 196.77, ["Mega|Fly|Ride"] = 313.48}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 6.33, ["Fly"] = 72.93, ["Ride"] = 59.68, ["Fly|Ride"] = 206.59, ["Neon"] = 103.68, ["Neon|Ride"] = 131.23, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 406.88, ["Mega|Fly"] = 736.84, ["Mega|Ride"] = 551.25, ["Mega|Fly|Ride"] = 554.56}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 24.68, ["Ride"] = 75.64, ["Fly|Ride"] = 220.4, ["Neon"] = 85.32, ["Neon|Ride"] = 213.94, ["Neon|Fly|Ride"] = 383.41, ["Mega"] = 307.83, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 44.51, ["Fly"] = 219.84, ["Ride"] = 84, ["Fly|Ride"] = 124.69, ["Neon"] = 356.83, ["Neon|Ride"] = 334.68, ["Neon|Fly|Ride"] = 380.63, ["Mega"] = 2542.7, ["Mega|Fly|Ride"] = 1756.47}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 6.06, ["Ride"] = 52.5, ["Neon"] = 37.64, ["Neon|Ride"] = 97.76, ["Neon|Fly|Ride"] = 198.19, ["Mega"] = 192.93, ["Mega|Fly"] = 366.16, ["Mega|Ride"] = 224.44, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Fly"] = 28.87, ["Ride"] = 17.07, ["Fly|Ride"] = 58.46, ["Neon"] = 18.34, ["Neon|Ride"] = 33.53, ["Neon|Fly|Ride"] = 119.51, ["Mega"] = 102.38, ["Mega|Ride"] = 146.24, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 3.73, ["Ride"] = 69.79, ["Neon"] = 24.43, ["Neon|Ride"] = 125.95, ["Neon|Fly|Ride"] = 174.57, ["Mega"] = 128.64, ["Mega|Fly"] = 262.95, ["Mega|Ride"] = 194.44, ["Mega|Fly|Ride"] = 278.92}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 50.22, ["Fly"] = 183.72, ["Ride"] = 88.44, ["Fly|Ride"] = 195.87, ["Neon"] = 115.77, ["Neon|Ride"] = 157.4, ["Neon|Fly|Ride"] = 271.03, ["Mega"] = 421.31, ["Mega|Ride"] = 450.86, ["Mega|Fly|Ride"] = 477.16}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 85.28, ["Neon"] = 8.28, ["Neon|Ride"] = 103.76, ["Neon|Fly|Ride"] = 190.32, ["Mega"] = 66.66, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 363.43}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 24.93, ["Ride"] = 103.85, ["Neon"] = 124.69, ["Neon|Ride"] = 382.24, ["Mega"] = 787.5, ["Mega|Fly|Ride"] = 874.93}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 918.9, ["Fly"] = 1194.38, ["Ride"] = 1008.31, ["Fly|Ride"] = 1100.21, ["Neon"] = 3684.13, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2884.88, ["Mega"] = 10016.18, ["Mega|Fly|Ride"] = 7875}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 20.79, ["Fly"] = 118.13, ["Ride"] = 45.94, ["Fly|Ride"] = 186.56, ["Neon"] = 85.32, ["Neon|Fly"] = 735.82, ["Neon|Ride"] = 186.74, ["Neon|Fly|Ride"] = 392.44, ["Mega"] = 466.74, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 542.41}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 50.37, ["Ride"] = 27.57, ["Fly|Ride"] = 85.86, ["Neon"] = 11.8, ["Neon|Fly"] = 74.03, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 87.61, ["Mega"] = 72.18, ["Mega|Ride"] = 99.47, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 14.34, ["Ride"] = 131.24, ["Fly|Ride"] = 148.04, ["Neon"] = 71.07, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 385.89, ["Mega"] = 288.73, ["Mega|Ride"] = 430.61, ["Mega|Fly|Ride"] = 499.63}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.63, ["Fly|Ride"] = 192.27, ["Neon"] = 2.1, ["Neon|Ride"] = 26.98, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 17.84, ["Mega|Ride"] = 55.26, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 50.32, ["Fly"] = 132.58, ["Ride"] = 98.44, ["Fly|Ride"] = 275.92, ["Neon"] = 190.32, ["Neon|Fly"] = 354.38, ["Neon|Ride"] = 261.19, ["Neon|Fly|Ride"] = 385.75, ["Mega"] = 993.24, ["Mega|Ride"] = 980.44, ["Mega|Fly|Ride"] = 945}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 12.59, ["Ride"] = 62.89, ["Fly|Ride"] = 292.3, ["Neon"] = 169.32, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 220.98, ["Mega"] = 576.19, ["Mega|Ride"] = 1028.47, ["Mega|Fly|Ride"] = 1031.8}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 2.72, ["Ride"] = 23.75, ["Neon"] = 9.17, ["Neon|Ride"] = 43.57, ["Neon|Fly|Ride"] = 220.98, ["Mega"] = 99.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 494.91}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 16.85, ["Fly"] = 163.53, ["Ride"] = 35.42, ["Fly|Ride"] = 106.55, ["Neon"] = 89.39, ["Neon|Ride"] = 95.81, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 487.17, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 771.08}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 6.57, ["Fly"] = 99.45, ["Ride"] = 28.67, ["Fly|Ride"] = 59.07, ["Neon"] = 26.25, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 52.01, ["Neon|Fly|Ride"] = 149.87, ["Mega"] = 262.4, ["Mega|Ride"] = 552.36, ["Mega|Fly|Ride"] = 368.97}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 42.73, ["Ride"] = 122.63, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 589.91, ["Mega"] = 2578.34, ["Mega|Ride"] = 1878.19, ["Mega|Fly|Ride"] = 1832.07}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.94, ["Ride"] = 44.2, ["Fly|Ride"] = 198.86, ["Neon"] = 12.85, ["Neon|Ride"] = 64.31, ["Neon|Fly|Ride"] = 665.44, ["Mega"] = 59.38, ["Mega|Ride"] = 114.91, ["Mega|Fly|Ride"] = 256.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 5.16, ["Fly"] = 37.57, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 38.89, ["Neon|Fly"] = 192.27, ["Neon|Ride"] = 62.46, ["Neon|Fly|Ride"] = 149.52, ["Mega"] = 301.88, ["Mega|Ride"] = 276.05, ["Mega|Fly|Ride"] = 338.63}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 116.82, ["Fly"] = 218.75, ["Ride"] = 184.78, ["Fly|Ride"] = 200.82, ["Neon"] = 498.74, ["Neon|Ride"] = 546.96, ["Neon|Fly|Ride"] = 525, ["Mega|Ride"] = 1834.96, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 27.88, ["Ride"] = 15.74, ["Fly|Ride"] = 48.62, ["Neon"] = 26.41, ["Neon|Fly"] = 57.66, ["Neon|Ride"] = 22.73, ["Neon|Fly|Ride"] = 89.25, ["Mega"] = 144.27, ["Mega|Ride"] = 167.41, ["Mega|Fly|Ride"] = 187.68}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 22.5, ["Fly"] = 267.04, ["Ride"] = 73.32, ["Fly|Ride"] = 178.74, ["Neon"] = 171.25, ["Neon|Ride"] = 215.88, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 663.07, ["Mega|Ride"] = 687.75, ["Mega|Fly|Ride"] = 781.02}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 18.89, ["Ride"] = 12.79, ["Fly|Ride"] = 63, ["Neon"] = 2.1, ["Neon|Fly"] = 29.65, ["Neon|Ride"] = 15.75, ["Neon|Fly|Ride"] = 43.32, ["Mega"] = 14.67, ["Mega|Ride"] = 30.93, ["Mega|Fly|Ride"] = 67.46}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 59.68, ["Neon"] = 3.38, ["Neon|Fly|Ride"] = 137.01, ["Mega"] = 20.07, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 159.41}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 3.91, ["Fly"] = 37.57, ["Ride"] = 31.49, ["Fly|Ride"] = 173.37, ["Neon"] = 15.16, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 148.07, ["Mega"] = 105, ["Mega|Ride"] = 287.56, ["Mega|Fly|Ride"] = 247.42}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 34.13, ["Fly|Ride"] = 131.25, ["Neon"] = 132.56, ["Neon|Ride"] = 167.4, ["Neon|Fly|Ride"] = 415.97, ["Mega"] = 515.83, ["Mega|Ride"] = 662.82}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 19.06, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 12.98, ["Neon|Fly"] = 28.55, ["Neon|Ride"] = 28.73, ["Neon|Fly|Ride"] = 59.04, ["Mega"] = 137.58, ["Mega|Fly"] = 267.23, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 5.25, ["Fly"] = 59.58, ["Ride"] = 47.48, ["Fly|Ride"] = 100.52, ["Neon"] = 49.06, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 59.7, ["Neon|Fly|Ride"] = 98.51, ["Mega"] = 381.33, ["Mega|Fly"] = 449.59, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 2.1, ["Fly"] = 26.77, ["Ride"] = 17.53, ["Fly|Ride"] = 68.61, ["Neon"] = 13.44, ["Neon|Fly"] = 98.41, ["Neon|Ride"] = 29.99, ["Neon|Fly|Ride"] = 61.73, ["Mega"] = 54.33, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 63.67, ["Mega|Fly|Ride"] = 144.23}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 9.08, ["Fly"] = 166.84, ["Ride"] = 32.48, ["Fly|Ride"] = 217.2, ["Neon"] = 42, ["Neon|Ride"] = 49.96, ["Neon|Fly|Ride"] = 295, ["Mega"] = 293.87, ["Mega|Ride"] = 546.83}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 3.6, ["Ride"] = 39.38, ["Fly|Ride"] = 196.88, ["Neon"] = 49.96, ["Neon|Ride"] = 73.5, ["Mega"] = 249.78, ["Mega|Ride"] = 317.06, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.94, ["Fly"] = 39.8, ["Ride"] = 20.07, ["Fly|Ride"] = 58.25, ["Neon"] = 19.69, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 35.28, ["Neon|Fly|Ride"] = 122.8, ["Mega"] = 233.63, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 223.13}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 24.89, ["Ride"] = 16.28, ["Fly|Ride"] = 53.05, ["Neon"] = 16.15, ["Neon|Fly"] = 70.51, ["Neon|Ride"] = 26.42, ["Neon|Fly|Ride"] = 86.18, ["Mega"] = 148.07, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 293.87}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 195.57, ["Fly"] = 393.75, ["Ride"] = 299.74, ["Fly|Ride"] = 440.78, ["Neon"] = 1311.28, ["Neon|Ride"] = 1498.63, ["Neon|Fly|Ride"] = 1174.69, ["Mega"] = 4330.37, ["Mega|Fly|Ride"] = 4165.68}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 3.67, ["Ride"] = 114.17, ["Neon"] = 43.22, ["Mega"] = 123.38, ["Mega|Ride"] = 667, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Fly"] = 110.49, ["Ride"] = 24.77, ["Fly|Ride"] = 88.38, ["Neon"] = 32.06, ["Neon|Fly"] = 250.81, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 149.89, ["Mega"] = 247.48, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 3.9, ["Fly|Ride"] = 736.93, ["Neon"] = 35.97, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 603.74, ["Mega"] = 498.32, ["Mega|Ride"] = 501.55, ["Mega|Fly|Ride"] = 418.04}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.58, ["Ride"] = 16.58, ["Fly|Ride"] = 31.14, ["Neon"] = 2.1, ["Neon|Fly"] = 22.11, ["Neon|Ride"] = 17.04, ["Neon|Fly|Ride"] = 44.2, ["Mega"] = 19.34, ["Mega|Fly"] = 59.07, ["Mega|Ride"] = 28.87, ["Mega|Fly|Ride"] = 72.19}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 51.93, ["Ride"] = 21.78, ["Fly|Ride"] = 53.67, ["Neon"] = 21.69, ["Neon|Ride"] = 37.22, ["Neon|Fly|Ride"] = 90.04, ["Mega"] = 120.75, ["Mega|Ride"] = 156.62, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.14, ["Ride"] = 121.07, ["Neon"] = 13.13, ["Neon|Ride"] = 295, ["Neon|Fly|Ride"] = 485.63, ["Mega"] = 39.38, ["Mega|Ride"] = 152.25, ["Mega|Fly|Ride"] = 342.57}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 65.55, ["Fly"] = 105, ["Ride"] = 94.5, ["Fly|Ride"] = 150.94, ["Neon"] = 315, ["Neon|Ride"] = 368.82, ["Neon|Fly|Ride"] = 393.75, ["Mega|Ride"] = 3684.56, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.21, ["Fly"] = 103.87, ["Ride"] = 23.61, ["Fly|Ride"] = 87.29, ["Neon"] = 22.23, ["Neon|Ride"] = 69.57, ["Mega"] = 169.31, ["Mega|Ride"] = 295.87, ["Mega|Fly|Ride"] = 270.38}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Ride"] = 43.32, ["Neon"] = 5.02, ["Neon|Ride"] = 154.87, ["Neon|Fly|Ride"] = 560.4, ["Mega"] = 60.5, ["Mega|Fly"] = 314.99, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 42, ["Fly"] = 131.25, ["Ride"] = 78.75, ["Fly|Ride"] = 179.11, ["Neon"] = 147, ["Neon|Ride"] = 178.4, ["Neon|Fly|Ride"] = 275.63, ["Mega"] = 471.19, ["Mega|Ride"] = 589.91, ["Mega|Fly|Ride"] = 719.25}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 13.27, ["Fly|Ride"] = 36.54, ["Neon"] = 2.1, ["Neon|Fly"] = 22.63, ["Neon|Ride"] = 16.42, ["Neon|Fly|Ride"] = 43.16, ["Mega"] = 16.64, ["Mega|Fly"] = 49.88, ["Mega|Ride"] = 35.68, ["Mega|Fly|Ride"] = 52.5}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Fly|Ride"] = 99.44, ["Neon"] = 2.23, ["Neon|Fly"] = 45.94, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 163.29, ["Mega"] = 24.32, ["Mega|Fly"] = 148.04, ["Mega|Ride"] = 92.7, ["Mega|Fly|Ride"] = 1325.8}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 2.58, ["Ride"] = 39.38, ["Fly|Ride"] = 161.34, ["Neon"] = 7.88, ["Neon|Ride"] = 102.8, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 65.62, ["Mega|Fly"] = 192.27, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 238.88}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 4.97, ["Ride"] = 42.84, ["Fly|Ride"] = 106.32, ["Neon"] = 19.58, ["Neon|Fly"] = 110.49, ["Neon|Ride"] = 84.63, ["Neon|Fly|Ride"] = 158.41, ["Mega"] = 110.13, ["Mega|Fly"] = 336.45, ["Mega|Ride"] = 130.7, ["Mega|Fly|Ride"] = 280.88}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 19, ["Ride"] = 15.62, ["Fly|Ride"] = 33.73, ["Neon"] = 2.1, ["Neon|Fly"] = 25.38, ["Neon|Ride"] = 42.37, ["Neon|Fly|Ride"] = 59.05, ["Mega"] = 19.5, ["Mega|Ride"] = 61.34, ["Mega|Fly|Ride"] = 118.12}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 18.4, ["Fly"] = 130.37, ["Ride"] = 48.57, ["Neon"] = 188.81, ["Neon|Ride"] = 187.81, ["Neon|Fly|Ride"] = 383.34, ["Mega"] = 816.38, ["Mega|Fly|Ride"] = 839.57}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2215.5, ["Fly"] = 3150, ["Ride"] = 2310.96, ["Fly|Ride"] = 2205, ["Neon|Fly|Ride"] = 7415.63, ["Mega|Fly|Ride"] = 45849.65}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 16.2, ["Fly|Ride"] = 32.82, ["Neon"] = 10.42, ["Neon|Fly"] = 49.87, ["Neon|Ride"] = 26.3, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 107.63, ["Mega|Fly"] = 294.97, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 161.13}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 9.85, ["Neon|Ride"] = 72.19, ["Mega"] = 104.88, ["Mega|Ride"] = 124.58, ["Mega|Fly|Ride"] = 495.96}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 13.13, ["Fly"] = 105, ["Ride"] = 32.82, ["Fly|Ride"] = 148.04, ["Neon"] = 77.18, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 279.88, ["Mega"] = 431.81, ["Mega|Ride"] = 458.42, ["Mega|Fly|Ride"] = 722.98}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 26.48, ["Fly"] = 148.07, ["Ride"] = 73.49, ["Neon"] = 187.69, ["Mega"] = 707.01, ["Mega|Ride"] = 705.9, ["Mega|Fly|Ride"] = 666.9}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 136.47, ["Fly"] = 548.42, ["Ride"] = 170.63, ["Fly|Ride"] = 244.4, ["Neon"] = 647.07, ["Neon|Ride"] = 774.38, ["Neon|Fly|Ride"] = 652.32, ["Mega"] = 6628.89, ["Mega|Fly|Ride"] = 4165.5}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 8.6, ["Ride"] = 64.97, ["Fly|Ride"] = 675.94, ["Neon"] = 15.75, ["Neon|Ride"] = 32.88, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 146.86, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 387.8}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 24.82, ["Neon"] = 16.83, ["Neon|Ride"] = 114.85, ["Neon|Fly|Ride"] = 210, ["Mega"] = 179.82, ["Mega|Ride"] = 354.38, ["Mega|Fly|Ride"] = 267.09}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 2.1, ["Fly"] = 101.99, ["Ride"] = 32.68, ["Fly|Ride"] = 87.29, ["Neon"] = 8.32, ["Neon|Fly"] = 130.37, ["Neon|Ride"] = 33.77, ["Neon|Fly|Ride"] = 101.36, ["Mega"] = 68.39, ["Mega|Ride"] = 111.55, ["Mega|Fly|Ride"] = 237.79}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 14.42, ["Ride"] = 71.47, ["Fly|Ride"] = 131.25, ["Neon"] = 148.04, ["Neon|Ride"] = 1251.84, ["Neon|Fly|Ride"] = 364.88, ["Mega"] = 589.91, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 429.85}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Ride"] = 26.53, ["Neon"] = 2.62, ["Neon|Ride"] = 28.93, ["Mega"] = 20.74, ["Mega|Ride"] = 143.79}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 97.89, ["Ride"] = 117.41, ["Fly|Ride"] = 168, ["Neon"] = 311.85, ["Neon|Fly"] = 472.82, ["Neon|Ride"] = 407.38, ["Neon|Fly|Ride"] = 515.91, ["Mega"] = 3314.46, ["Mega|Ride"] = 1178.71, ["Mega|Fly|Ride"] = 1325.63}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Fly"] = 46.41, ["Ride"] = 91.87, ["Neon"] = 13.86, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 220.98, ["Mega"] = 64.05, ["Mega|Ride"] = 294.97, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 46.2, ["Fly"] = 233.59, ["Ride"] = 85.32, ["Fly|Ride"] = 183.4, ["Neon"] = 255.94, ["Neon|Ride"] = 360.71, ["Neon|Fly|Ride"] = 420, ["Mega"] = 2625, ["Mega|Fly|Ride"] = 1575}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 64.21, ["Ride"] = 17.72, ["Fly|Ride"] = 43.66, ["Neon"] = 5, ["Neon|Fly"] = 87.45, ["Neon|Ride"] = 74.05, ["Neon|Fly|Ride"] = 83.97, ["Mega"] = 42, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 2.1, ["Neon"] = 7.6, ["Neon|Ride"] = 87.94, ["Mega"] = 38.3, ["Mega|Ride"] = 167.41, ["Mega|Fly|Ride"] = 368.97}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 2.97, ["Fly"] = 74.05, ["Ride"] = 24.54, ["Fly|Ride"] = 90.57, ["Neon"] = 25.47, ["Neon|Fly"] = 110.49, ["Neon|Ride"] = 72.47, ["Mega"] = 141.74, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 296.63, ["Fly"] = 749.33, ["Ride"] = 402.89, ["Fly|Ride"] = 574.45, ["Neon"] = 918.74, ["Neon|Ride"] = 982.8, ["Neon|Fly|Ride"] = 1191.71, ["Mega"] = 3188.12, ["Mega|Ride"] = 2428.13, ["Mega|Fly|Ride"] = 3285.34}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 42, ["Fly"] = 65.63, ["Ride"] = 54.66, ["Fly|Ride"] = 87.94, ["Neon"] = 199.83, ["Neon|Ride"] = 249.38, ["Neon|Fly|Ride"] = 216.57, ["Mega|Fly"] = 2813.18, ["Mega|Ride"] = 1767.5, ["Mega|Fly|Ride"] = 1089.23}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Ride"] = 32.81, ["Fly|Ride"] = 127.15, ["Neon"] = 27.23, ["Neon|Fly"] = 101.07, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 131.06, ["Mega"] = 142, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 288.51}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 21.48, ["Fly"] = 219.01, ["Ride"] = 69.57, ["Fly|Ride"] = 141.93, ["Neon"] = 78.75, ["Neon|Fly"] = 410.57, ["Neon|Ride"] = 108.82, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 294.97, ["Mega|Fly"] = 1027.95, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 494.27}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 6.82, ["Ride"] = 19.67, ["Neon"] = 101.36, ["Neon|Ride"] = 132.59, ["Mega"] = 666.9, ["Mega|Ride"] = 249.78, ["Mega|Fly|Ride"] = 311.07}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.15, ["Neon"] = 10.49, ["Neon|Ride"] = 157.5, ["Mega"] = 106.98, ["Mega|Ride"] = 333.46}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 74.05, ["Ride"] = 19.68, ["Fly|Ride"] = 62.97, ["Neon"] = 59.07, ["Neon|Ride"] = 146.73, ["Neon|Fly|Ride"] = 217.31, ["Mega"] = 262.5, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 87.94, ["Fly"] = 249.82, ["Ride"] = 120.9, ["Fly|Ride"] = 192.3, ["Neon"] = 839.67, ["Neon|Ride"] = 518.45, ["Neon|Fly|Ride"] = 524.99, ["Mega"] = 2887.5, ["Mega|Ride"] = 2625, ["Mega|Fly|Ride"] = 2231.25}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 21, ["Ride"] = 55.57, ["Fly|Ride"] = 85.32, ["Neon"] = 123.43, ["Neon|Ride"] = 189, ["Neon|Fly|Ride"] = 348.5, ["Mega"] = 551.25, ["Mega|Ride"] = 587.71, ["Mega|Fly|Ride"] = 736.84}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 1953.79, ["Fly"] = 2498.07, ["Ride"] = 1706.24, ["Fly|Ride"] = 1955.63, ["Neon"] = 11785.03, ["Neon|Fly|Ride"] = 7019.25, ["Mega|Fly|Ride"] = 24675}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 3.12, ["Fly"] = 131250, ["Ride"] = 124.82, ["Fly|Ride"] = 196.87, ["Neon"] = 31.76, ["Neon|Ride"] = 97.32, ["Mega"] = 183.75, ["Mega|Ride"] = 244.79, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 4.93, ["Fly"] = 59.88, ["Ride"] = 42, ["Fly|Ride"] = 124.9, ["Neon"] = 20.06, ["Neon|Ride"] = 95.02, ["Mega"] = 187.81, ["Mega|Ride"] = 397.7, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 885.42, ["Ride"] = 853.13, ["Fly|Ride"] = 1017.19, ["Neon"] = 2778.57, ["Neon|Ride"] = 2572.76, ["Neon|Fly|Ride"] = 2887.49, ["Mega|Ride"] = 14156.43, ["Mega|Fly|Ride"] = 13321.43}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 29.34, ["Ride"] = 52.5, ["Fly|Ride"] = 105, ["Neon"] = 144.37, ["Neon|Ride"] = 328.79, ["Mega"] = 867.21, ["Mega|Ride"] = 795.39, ["Mega|Fly|Ride"] = 854.44}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 2.1, ["Ride"] = 22.04, ["Fly|Ride"] = 128.15, ["Neon"] = 12.43, ["Neon|Fly"] = 167.4, ["Neon|Ride"] = 83.99, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 157.5, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 57.75, ["Ride"] = 148.07, ["Neon"] = 5.11, ["Neon|Fly"] = 157.5, ["Neon|Ride"] = 49.83, ["Neon|Fly|Ride"] = 114.91, ["Mega"] = 23.62, ["Mega|Ride"] = 61.31, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 91.88, ["Fly"] = 441.94, ["Ride"] = 138.65, ["Fly|Ride"] = 157.5, ["Neon"] = 459.38, ["Neon|Ride"] = 515.91, ["Neon|Fly|Ride"] = 640.5, ["Mega"] = 2498.07, ["Mega|Fly|Ride"] = 2456.83}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 2.1, ["Ride"] = 35.32, ["Fly|Ride"] = 77.35, ["Neon"] = 12.43, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 74.03, ["Mega"] = 91.87, ["Mega|Ride"] = 167.4, ["Mega|Fly|Ride"] = 224.32}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 78.66, ["Fly"] = 154.68, ["Ride"] = 102.1, ["Neon"] = 610.32, ["Neon|Ride"] = 721.88, ["Neon|Fly|Ride"] = 501.55, ["Mega"] = 2209.37, ["Mega|Fly|Ride"] = 1690.18}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 3.67, ["Fly"] = 105, ["Fly|Ride"] = 102.89, ["Neon"] = 32.47, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 269.06, ["Mega"] = 360.84, ["Mega|Ride"] = 325.9}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 236.25, ["Fly"] = 427.52, ["Ride"] = 294, ["Fly|Ride"] = 329.44, ["Neon"] = 1148.82, ["Neon|Ride"] = 833.31, ["Neon|Fly|Ride"] = 879.37, ["Mega|Fly|Ride"] = 3922.87}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 6.64, ["Fly"] = 65.63, ["Ride"] = 25.75, ["Fly|Ride"] = 118.21, ["Neon"] = 47.24, ["Neon|Ride"] = 82.69, ["Neon|Fly|Ride"] = 114.91, ["Mega"] = 250.69, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 223.13}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 15.75, ["Fly|Ride"] = 47.48, ["Neon"] = 4.82, ["Neon|Fly"] = 38.07, ["Neon|Ride"] = 18.67, ["Neon|Fly|Ride"] = 55.31, ["Mega"] = 48.29, ["Mega|Ride"] = 83.71, ["Mega|Fly|Ride"] = 126}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 1380.87, ["Ride"] = 1050, ["Fly|Ride"] = 1254.75, ["Neon|Ride"] = 8102.7, ["Neon|Fly|Ride"] = 7357.2, ["Mega"] = 24980.43, ["Mega|Fly|Ride"] = 25776.64}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 10.5, ["Ride"] = 80.78, ["Neon"] = 73.38, ["Neon|Ride"] = 314.98, ["Neon|Fly|Ride"] = 551.25, ["Mega"] = 427.88, ["Mega|Ride"] = 475.44, ["Mega|Fly|Ride"] = 564.38}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 4.45, ["Fly"] = 53.46, ["Ride"] = 37.77, ["Fly|Ride"] = 58.97, ["Neon"] = 17.07, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 115.63, ["Mega"] = 171.42, ["Mega|Ride"] = 166.04, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 26.25, ["Fly"] = 38.64, ["Ride"] = 30.86, ["Fly|Ride"] = 74.71, ["Neon|Ride"] = 339.7, ["Neon|Fly|Ride"] = 187.2, ["Mega"] = 2651.56, ["Mega|Ride"] = 1166.6, ["Mega|Fly|Ride"] = 779.63}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 12.48, ["Fly"] = 74.03, ["Ride"] = 29.1, ["Fly|Ride"] = 72.19, ["Neon"] = 66.94, ["Neon|Ride"] = 88.23, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 367.5, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 584.75}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 77.44, ["Ride"] = 131.25, ["Fly|Ride"] = 644.01, ["Neon"] = 437.99, ["Neon|Fly"] = 589.91, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 736.84, ["Mega"] = 3976.86, ["Mega|Fly|Ride"] = 1054.99}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.1, ["Ride"] = 116.61, ["Neon"] = 2.63, ["Neon|Fly"] = 55.27, ["Neon|Ride"] = 110.73, ["Neon|Fly|Ride"] = 110.49, ["Mega"] = 16.8, ["Mega|Ride"] = 144.47, ["Mega|Fly|Ride"] = 217.81}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 101.88, ["Fly"] = 170.61, ["Ride"] = 140.43, ["Fly|Ride"] = 217.88, ["Neon"] = 548.34, ["Neon|Fly"] = 490.88, ["Neon|Ride"] = 643.12, ["Neon|Fly|Ride"] = 682.5, ["Mega"] = 3535.42, ["Mega|Fly|Ride"] = 2493.75}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 748.35, ["Ride"] = 23.82, ["Fly|Ride"] = 68.04, ["Neon"] = 229.67, ["Neon|Ride"] = 83.98, ["Mega"] = 773.71, ["Mega|Ride"] = 424.62, ["Mega|Fly|Ride"] = 490.88}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18, ["Fly|Ride"] = 39.36, ["Neon"] = 13.13, ["Neon|Fly"] = 83.71, ["Neon|Ride"] = 88.38, ["Neon|Fly|Ride"] = 69.98, ["Mega|Ride"] = 277.86}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 2.1, ["Ride"] = 126, ["Neon"] = 15.74, ["Neon|Fly"] = 145.85, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 214.86, ["Mega"] = 86.43}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 87.94, ["Fly"] = 247.55, ["Ride"] = 203.44, ["Fly|Ride"] = 424.22, ["Neon"] = 538.26, ["Neon|Ride"] = 589.91, ["Neon|Fly|Ride"] = 721.88, ["Mega"] = 2205, ["Mega|Ride"] = 1680, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 3.83, ["Ride"] = 39.38, ["Fly|Ride"] = 441.89, ["Neon"] = 22.32, ["Neon|Ride"] = 59.07, ["Mega"] = 118.21, ["Mega|Ride"] = 161.3, ["Mega|Fly|Ride"] = 333.46}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 25.43, ["Mega"] = 18.33, ["Mega|Ride"] = 218.91, ["Mega|Fly|Ride"] = 196.64}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 102.93, ["Ride"] = 19.69, ["Fly|Ride"] = 148.07, ["Neon"] = 2.1, ["Neon|Fly"] = 86.2, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 205.49, ["Mega"] = 19.31, ["Mega|Fly"] = 57.36, ["Mega|Ride"] = 39.79, ["Mega|Fly|Ride"] = 139.99}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 36.74, ["Ride"] = 23.61, ["Fly|Ride"] = 52.49, ["Neon"] = 8.59, ["Neon|Ride"] = 20.01, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 63, ["Mega|Ride"] = 131.24, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 28.88, ["Fly|Ride"] = 115.53, ["Neon"] = 10.38, ["Mega"] = 137.82, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 22.31, ["Ride"] = 16.11, ["Fly|Ride"] = 40.13, ["Neon"] = 9.19, ["Neon|Fly"] = 88.39, ["Neon|Ride"] = 40.94, ["Neon|Fly|Ride"] = 103.85, ["Mega"] = 236.25, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 228.38}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 57.07, ["Fly|Ride"] = 290.51, ["Neon"] = 203.44, ["Neon|Ride"] = 378, ["Neon|Fly|Ride"] = 636.26, ["Mega"] = 643.13, ["Mega|Ride"] = 764.63, ["Mega|Fly|Ride"] = 881.55}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 17.07, ["Ride"] = 13.13, ["Fly|Ride"] = 49.23, ["Neon"] = 2.1, ["Neon|Fly"] = 32.8, ["Neon|Ride"] = 17.97, ["Neon|Fly|Ride"] = 47.23, ["Mega"] = 17.73, ["Mega|Fly"] = 44.2, ["Mega|Ride"] = 167.35, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 8.71, ["Fly"] = 56.06, ["Ride"] = 33.23, ["Fly|Ride"] = 74.11, ["Neon"] = 39.51, ["Neon|Fly"] = 59.07, ["Neon|Ride"] = 66.93, ["Neon|Fly|Ride"] = 132.84, ["Mega"] = 301.88, ["Mega|Fly"] = 589.98, ["Mega|Ride"] = 275.07, ["Mega|Fly|Ride"] = 314.98}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 24.92, ["Fly"] = 58.59, ["Ride"] = 44.92, ["Fly|Ride"] = 143.07, ["Neon"] = 163.06, ["Neon|Fly"] = 137.82, ["Neon|Ride"] = 198.35, ["Neon|Fly|Ride"] = 228.38, ["Mega"] = 665.94, ["Mega|Ride"] = 883.76, ["Mega|Fly|Ride"] = 714}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 6.42, ["Fly"] = 209.98, ["Neon"] = 90.03, ["Neon|Ride"] = 105, ["Mega"] = 666.9, ["Mega|Ride"] = 783.68, ["Mega|Fly|Ride"] = 877.13}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 18.43, ["Ride"] = 16.58, ["Fly|Ride"] = 39.79, ["Neon"] = 4.34, ["Neon|Fly"] = 81.27, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 74.94, ["Mega"] = 40.67, ["Mega|Ride"] = 59.07, ["Mega|Fly|Ride"] = 118.77}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 12.88, ["Fly"] = 78.74, ["Ride"] = 86.18, ["Neon"] = 85.31, ["Neon|Ride"] = 206.06, ["Neon|Fly|Ride"] = 1168.13, ["Mega"] = 267.75, ["Mega|Fly"] = 586.61, ["Mega|Ride"] = 547.32, ["Mega|Fly|Ride"] = 634.1}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 984.38, ["Fly"] = 1311.28, ["Ride"] = 1010.63, ["Fly|Ride"] = 1043.44, ["Neon"] = 2491.13, ["Neon|Ride"] = 2744.43, ["Neon|Fly|Ride"] = 2296.88, ["Mega|Fly|Ride"] = 6168.75}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 216.44, ["Ride"] = 262.5, ["Fly|Ride"] = 590.63, ["Neon"] = 721.88, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1325.63, ["Mega"] = 3664.12, ["Mega|Ride"] = 3829.94, ["Mega|Fly|Ride"] = 3579.18}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.1, ["Fly|Ride"] = 392.44, ["Neon"] = 9.47, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 264.03, ["Mega"] = 60.38, ["Mega|Fly|Ride"] = 1178.84}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 109.14, ["Fly"] = 183.75, ["Ride"] = 215.99, ["Fly|Ride"] = 413.44, ["Neon"] = 636.57, ["Neon|Ride"] = 695.62, ["Neon|Fly|Ride"] = 883.76, ["Mega|Ride"] = 2220.73, ["Mega|Fly|Ride"] = 2165.63}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.1, ["Fly"] = 41.99, ["Ride"] = 23.05, ["Fly|Ride"] = 96.14, ["Neon"] = 17.07, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 37.32, ["Neon|Fly|Ride"] = 320.41, ["Mega"] = 115.96, ["Mega|Ride"] = 117.41, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 257.24, ["Fly"] = 437.96, ["Ride"] = 288.75, ["Fly|Ride"] = 330.75, ["Neon|Ride"] = 1380.87, ["Neon|Fly|Ride"] = 1198.16, ["Mega|Fly|Ride"] = 4995.06}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 77.18, ["Ride"] = 23.63, ["Fly|Ride"] = 230.91, ["Neon"] = 17.07, ["Neon|Ride"] = 57.99, ["Mega"] = 393.75, ["Mega|Fly"] = 370.13, ["Mega|Ride"] = 441.89}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 40.2, ["Mega"] = 249.38, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 22.1, ["Ride"] = 52.5, ["Fly|Ride"] = 148.04, ["Neon"] = 102.8, ["Neon|Fly"] = 441.94, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 194.65, ["Mega"] = 839.27, ["Mega|Ride"] = 595.88, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.76, ["Neon"] = 17.07, ["Neon|Ride"] = 196.88, ["Mega"] = 249.78, ["Mega|Ride"] = 265.04, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 16.25, ["Ride"] = 15.61, ["Fly|Ride"] = 39.37, ["Neon"] = 2.1, ["Neon|Fly"] = 20.79, ["Neon|Ride"] = 26.23, ["Neon|Fly|Ride"] = 54.03, ["Mega"] = 27.66, ["Mega|Fly"] = 55.13, ["Mega|Ride"] = 36.8, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 5662.27, ["Ride"] = 4536, ["Fly|Ride"] = 4709.25, ["Neon"] = 33144.33, ["Neon|Fly|Ride"] = 20505.31, ["Mega|Fly|Ride"] = 52500}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 6.44, ["Fly"] = 88.39, ["Ride"] = 41.99, ["Neon"] = 88.38, ["Neon|Fly"] = 393.32, ["Neon|Ride"] = 101.64, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 210, ["Mega|Ride"] = 276.94, ["Mega|Fly|Ride"] = 440.84}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 28.28, ["Ride"] = 19.69, ["Fly|Ride"] = 45.93, ["Neon"] = 13.13, ["Neon|Fly"] = 45.93, ["Neon|Ride"] = 33.15, ["Neon|Fly|Ride"] = 84, ["Mega"] = 144.37, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 242.18}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 459.38, ["Fly"] = 547.78, ["Ride"] = 501.37, ["Fly|Ride"] = 584.06, ["Neon"] = 1672.7, ["Neon|Ride"] = 1181.25, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Fly|Ride"] = 5114.82}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 2.1, ["Ride"] = 49.97, ["Neon"] = 14.43, ["Neon|Ride"] = 291.38, ["Mega"] = 132.58, ["Mega|Ride"] = 175.67, ["Mega|Fly|Ride"] = 693}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 3.94, ["Fly"] = 145.69, ["Ride"] = 19.69, ["Neon"] = 64.32, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 229.69, ["Mega"] = 875.61, ["Mega|Ride"] = 401.62, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 74.05, ["Ride"] = 19.97, ["Fly|Ride"] = 65.62, ["Neon"] = 6.08, ["Neon|Fly"] = 124.69, ["Neon|Ride"] = 24.33, ["Neon|Fly|Ride"] = 91.75, ["Mega"] = 72.18, ["Mega|Ride"] = 70.87, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 640.5, ["Fly"] = 899.33, ["Ride"] = 767.81, ["Fly|Ride"] = 656.25, ["Neon|Ride"] = 2126.25, ["Neon|Fly|Ride"] = 2099.99, ["Mega|Fly|Ride"] = 9058.41}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 7.35, ["Ride"] = 65.63, ["Fly|Ride"] = 131.25, ["Neon"] = 45.93, ["Neon|Fly"] = 328.12, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 192.23, ["Mega"] = 208.69, ["Mega|Fly"] = 441.89, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 520.32}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 13.13, ["Fly"] = 106.2, ["Ride"] = 47.86, ["Fly|Ride"] = 210, ["Neon"] = 30.7, ["Neon|Ride"] = 57.46, ["Neon|Fly|Ride"] = 150.94, ["Mega"] = 248.07, ["Mega|Fly"] = 832.49, ["Mega|Ride"] = 185.07, ["Mega|Fly|Ride"] = 365.67}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 37.3, ["Ride"] = 18.76, ["Fly|Ride"] = 47.75, ["Neon"] = 14.02, ["Neon|Fly"] = 199.5, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 85.52, ["Mega"] = 165.38, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 170.63}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 15.75, ["Fly"] = 39.38, ["Ride"] = 39.8, ["Fly|Ride"] = 65.63, ["Neon"] = 127.09, ["Neon|Ride"] = 114.18, ["Neon|Fly|Ride"] = 294.97, ["Mega"] = 652.88, ["Mega|Ride"] = 622.13, ["Mega|Fly|Ride"] = 1680}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Ride"] = 43.31, ["Fly|Ride"] = 294.97, ["Neon"] = 3.08, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 31.49, ["Mega|Fly"] = 159.1, ["Mega|Ride"] = 101.33, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 590.63, ["Fly"] = 692.66, ["Ride"] = 683.82, ["Fly|Ride"] = 682.5, ["Neon"] = 2299.96, ["Neon|Ride"] = 2355.22, ["Neon|Fly|Ride"] = 2391.62, ["Mega|Ride"] = 9741, ["Mega|Fly|Ride"] = 7874.99}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 72.18, ["Fly|Ride"] = 180.08, ["Neon"] = 10.49, ["Neon|Ride"] = 73.4, ["Neon|Fly|Ride"] = 461.16, ["Mega"] = 56.44, ["Mega|Ride"] = 148.04, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 50.21, ["Fly|Ride"] = 196.88, ["Neon"] = 6.17, ["Neon|Fly"] = 294.97, ["Neon|Ride"] = 59.68, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 39.38, ["Mega|Ride"] = 125.95, ["Mega|Fly|Ride"] = 294.97}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 61.07, ["Neon"] = 3.42, ["Neon|Ride"] = 40.32, ["Neon|Fly|Ride"] = 7365.8, ["Mega"] = 57.46, ["Mega|Fly"] = 163.53, ["Mega|Ride"] = 127.21, ["Mega|Fly|Ride"] = 216.5}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 10.39, ["Mega"] = 253.01, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 28.73, ["Fly"] = 72.19, ["Ride"] = 44.62, ["Fly|Ride"] = 218.56, ["Neon"] = 104.99, ["Neon|Ride"] = 49.96, ["Neon|Fly|Ride"] = 393.74, ["Mega"] = 441.89, ["Mega|Ride"] = 539.24, ["Mega|Fly|Ride"] = 581.99}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 17.06, ["Ride"] = 59.07, ["Fly|Ride"] = 159.1, ["Neon"] = 87.42, ["Neon|Ride"] = 148.04, ["Neon|Fly|Ride"] = 294, ["Mega"] = 551.25, ["Mega|Ride"] = 499.55, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 2.1, ["Fly"] = 21.42, ["Ride"] = 16.94, ["Fly|Ride"] = 40.35, ["Neon"] = 28.25, ["Neon|Ride"] = 36.61, ["Neon|Fly|Ride"] = 86.61, ["Mega"] = 299.92, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 328.13}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 4.88, ["Ride"] = 29.85, ["Fly|Ride"] = 149.87, ["Neon"] = 65.63, ["Neon|Ride"] = 163.5, ["Mega|Ride"] = 441.89}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Ride"] = 21, ["Fly|Ride"] = 109.5, ["Neon"] = 12.87, ["Neon|Ride"] = 55.26, ["Neon|Fly|Ride"] = 127.34, ["Mega"] = 82.67, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 249.78}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 21, ["Fly"] = 26.25, ["Ride"] = 29.53, ["Fly|Ride"] = 55.11, ["Neon"] = 115.76, ["Neon|Ride"] = 128.64, ["Neon|Fly|Ride"] = 160.14, ["Mega"] = 853.13, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 44.63, ["Fly"] = 874.13, ["Neon"] = 117.41, ["Mega"] = 278.88, ["Mega|Fly"] = 662.82, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 735.67}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 52.5, ["Fly"] = 84, ["Ride"] = 86.2, ["Fly|Ride"] = 244.4, ["Neon"] = 263.61, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 374.07, ["Mega"] = 1995.27, ["Mega|Fly|Ride"] = 1299.38}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 32.82, ["Fly"] = 148.04, ["Ride"] = 77.99, ["Fly|Ride"] = 236.41, ["Neon"] = 105, ["Neon|Ride"] = 180.08, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 502.85, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 710.07}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 17.06, ["Ride"] = 63.4, ["Neon"] = 140.21, ["Neon|Ride"] = 108.5, ["Mega"] = 502.69, ["Mega|Ride"] = 639.43, ["Mega|Fly|Ride"] = 852.84}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 35.4, ["Fly"] = 65.63, ["Ride"] = 104.99, ["Fly|Ride"] = 204.77, ["Neon"] = 210.1, ["Neon|Ride"] = 268.24, ["Neon|Fly|Ride"] = 499.55, ["Mega"] = 787.34, ["Mega|Ride"] = 796.27, ["Mega|Fly|Ride"] = 838.88}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 19.09, ["Ride"] = 16.34, ["Fly|Ride"] = 32.82, ["Neon"] = 3.78, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 58.15, ["Mega"] = 39.78, ["Mega|Fly"] = 333.51, ["Mega|Ride"] = 55.13, ["Mega|Fly|Ride"] = 146.9}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 787.5}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 105, ["Ride"] = 176.85, ["Fly|Ride"] = 374.22, ["Neon"] = 508.11, ["Neon|Ride"] = 627.47, ["Neon|Fly|Ride"] = 860.61, ["Mega"] = 1640.63, ["Mega|Ride"] = 1694.8, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 79.76, ["Neon"] = 4.08, ["Neon|Fly"] = 103.87, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 306.86, ["Mega"] = 38.87, ["Mega|Ride"] = 89.66, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 30.08, ["Ride"] = 78.75, ["Fly|Ride"] = 220.95, ["Neon"] = 89.14, ["Neon|Ride"] = 99.75, ["Neon|Fly|Ride"] = 395.07, ["Mega"] = 591.93, ["Mega|Ride"] = 589.91, ["Mega|Fly|Ride"] = 618.71}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 2.41, ["Neon|Fly|Ride"] = 148.04, ["Mega"] = 19.68}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Ride"] = 65.63, ["Neon"] = 3.94, ["Mega"] = 23.49, ["Mega|Ride"] = 112.73, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 98.44, ["Fly"] = 1842.85, ["Ride"] = 143.63, ["Neon"] = 666.9, ["Neon|Ride"] = 459.38, ["Neon|Fly|Ride"] = 645.75, ["Mega|Ride"] = 6864.4, ["Mega|Fly|Ride"] = 2056.91}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 90.57, ["Ride"] = 19.71, ["Fly|Ride"] = 71.91, ["Neon"] = 3.94, ["Neon|Fly"] = 44.2, ["Neon|Ride"] = 32.29, ["Neon|Fly|Ride"] = 99.73, ["Mega"] = 91.87, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 18.9, ["Fly|Ride"] = 66.94, ["Neon"] = 5.15, ["Neon|Ride"] = 36.74, ["Neon|Fly|Ride"] = 419.9, ["Mega"] = 34.92, ["Mega|Ride"] = 129.15, ["Mega|Fly|Ride"] = 217.87}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 3.94, ["Ride"] = 41.35, ["Neon"] = 20.97, ["Neon|Fly"] = 262.5, ["Neon|Ride"] = 262.5, ["Mega"] = 146.73, ["Mega|Fly|Ride"] = 589.91}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 131.25, ["Neon"] = 6.48, ["Neon|Ride"] = 44.2, ["Mega"] = 118.35, ["Mega|Ride"] = 339.2}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 103.28, ["Ride"] = 183.75, ["Fly|Ride"] = 368.97, ["Neon"] = 437.07, ["Neon|Ride"] = 679.39, ["Neon|Fly|Ride"] = 695.63, ["Mega"] = 1874.25, ["Mega|Fly|Ride"] = 3150}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 6.23, ["Mega"] = 418.06, ["Mega|Ride"] = 376.95, ["Mega|Fly|Ride"] = 645.74}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 367.5, ["Ride"] = 431.82, ["Fly|Ride"] = 751.2, ["Neon"] = 918.75, ["Neon|Ride"] = 1473.66, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 3346.87}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 74.81}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.62}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 15.59}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 17.69}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 48.48}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 116.81}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 13.12}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 5.15}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 192.92}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 18.27}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 45.89}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 6.45}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 7.88}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 944.99}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 3.94}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 4.93}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 3.94}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 6.28}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 40.6}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 729.11}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 490.05}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 10.5}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1414.93}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2860616529"] = {name = "Convertible", prices = {["default"] = 52.5}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 5.83}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 17.07}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 30.62}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 22}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 62.99}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 21.51}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 11.81}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 2.23}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 52.5}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.1}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 12.88}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 11.71}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 6.63}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 2732.89}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 91.49}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 280.88}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 3.97}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.63}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 12.59}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 28.38}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 31.5}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 262.47}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.9}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 9.18}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 157.56}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 52.49}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 3.94}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 26.25}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 11.33}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 105}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 29.73}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.19}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 24.93}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.59}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 7.88}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 2.63}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 28.87}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 93.19}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 319.76}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 6.26}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 332.43}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.94}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 102.86}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 21.93}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 24855.54}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 124.69}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 37.95}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 40.69}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 32.16}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 58.97}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 31.4}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 51.18}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 91.88}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 82.1}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 34.13}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 108.93}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 49.86}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 44.44}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 79.56}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 252.11}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 7.4}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 6.34}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.24}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 27.42}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 148.32}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 2.61}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 3.94}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 5.8}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 17.06}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 219.33}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 830.82}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 616.87}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 13.13}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.18}},
    ["rbxassetid://1265142495"] = {name = "Snow Snowboard", prices = {["default"] = 231}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 41.97}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 99.71}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 20.9}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 41.56}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 71.31}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 15.74}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 2.1}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 7.72}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 2.1}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 6.09}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 10.06}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 36.74}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 2.1}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.1}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.07}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 17.07}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 185.07}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8925104785"] = {name = "Gyrocopter", prices = {["default"] = 31.48}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 207.98}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 4.94}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 12.51}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 7.04}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 26.24}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 61.68}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 6.49}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://8190703329"] = {name = "Toy Rescue Helicopter", prices = {["default"] = 9.19}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 2.63}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 7.58}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 18.12}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 14.2}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.79}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 6.57}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.86}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 6.49}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.67}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 2.78}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.1}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 7218.75}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 6.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 17.04}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 4.39}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 4.9}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://1257273388"] = {name = "Christmas Doge Rattle", prices = {["default"] = 22.32}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 5.25}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 3.86}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 4.11}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 4.39}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.19}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 42.3}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 5.81}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.35}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 5.36}},
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
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 42}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 3.34}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 80.64}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 2.36}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 3.94}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 129.94}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 2.1}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 3.93}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 6.57}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.2}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.09}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.62}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 13.86}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.77}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 2.24}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 4.5}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 21}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.43}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.37}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 7.88}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 104.9}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 70.48}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 11.23}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 2.6}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 1367.23}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 84.34}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 2.15}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 38.07}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 36.75}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.63}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 5.88}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 7.39}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 19.68}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 14}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 14.34}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 2.63}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 5.16}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 14.75}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 4.46}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 3.46}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 14.91}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 7.77}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 86.62}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 17.84}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 2.59}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 47.91}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 108.84}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 15.6}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 26.25}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 23.5}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 3.94}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 5.43}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 3.71}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 146.64}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 153.57}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 13.26}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 1030.32}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 188.9}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 5.97}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 9.75}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 57.66}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 4.81}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.52}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 91.87}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 10.39}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 3.59}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.34}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 2.18}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 32.82}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 6.47}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 62.98}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 2.1}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.83}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 4.4}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 12.45}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 113.91}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 10.85}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 65.52}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 3.93}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 6.24}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.24}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 55.12}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978200"] = {name = "Sailor Cap", prices = {["default"] = 52.41}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 65.63}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 2.19}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 58.31}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.58}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 143.07}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 26.24}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 46.54}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 61.69}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 8.8}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 29.86}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 6.14}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 7.24}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 17.75}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 369.15}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 66.94}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 3.68}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 13.13}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 35.35}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 29.68}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 31.5}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 92.96}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 70.39}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 24.71}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1994.99}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 8.74}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 6.57}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 23}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 263.45}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.38}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 8.38}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 30.19}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 14.43}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 346.39}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 63}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 45.71}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 52.5}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 164.04}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 111.57}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1143.45}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 183.75}},
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