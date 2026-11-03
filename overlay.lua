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
    ["rbxassetid://137637490639925"] = {name = "Royal Mistletroll", prices = {["default"] = 945.68, ["Ride"] = 1179.94, ["Fly|Ride"] = 1048.69, ["Neon"] = 9187.5, ["Neon|Fly|Ride"] = 3921.75, ["Mega|Fly|Ride"] = 24925.25}},
    ["rbxassetid://140355753768438"] = {name = "Moonbeam Peacock", prices = {["default"] = 494.82, ["Fly"] = 568.11, ["Ride"] = 458.06, ["Fly|Ride"] = 539.17, ["Neon|Ride"] = 2077.11, ["Neon|Fly|Ride"] = 2073.75}},
    ["rbxassetid://18117855573"] = {name = "Balloon Unicorn", prices = {["default"] = 4856.25, ["Ride"] = 4829.99, ["Fly|Ride"] = 4328.62, ["Neon|Fly|Ride"] = 20079.38, ["Mega|Fly|Ride"] = 69237.13}},
    ["rbxassetid://75782719698946"] = {name = "Red Dutch Guinea Pig", prices = {["default"] = 129.83, ["Ride"] = 183.75, ["Fly|Ride"] = 311.58, ["Neon"] = 1409.12, ["Neon|Ride"] = 821.63, ["Neon|Fly|Ride"] = 783.23, ["Mega"] = 4154.22, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://5067924142"] = {name = "Albino Monkey", prices = {["default"] = 590.63, ["Fly"] = 830.86, ["Ride"] = 539.44, ["Fly|Ride"] = 566.35, ["Neon|Ride"] = 1758.75, ["Neon|Fly|Ride"] = 1612.82, ["Mega|Fly|Ride"] = 6300}},
    ["rbxassetid://108312620331321"] = {name = "Villain Gibbon", prices = {["default"] = 9.14, ["Ride"] = 34.08, ["Fly|Ride"] = 153.72, ["Neon"] = 72.19, ["Neon|Ride"] = 77.91, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 285.27, ["Mega|Ride"] = 469.7, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://17255958862"] = {name = "Alicorn", prices = {["default"] = 3.73, ["Fly"] = 33.68, ["Ride"] = 26.25, ["Fly|Ride"] = 74.82, ["Neon"] = 32.81, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 44.63, ["Neon|Fly|Ride"] = 108.02, ["Mega"] = 141.37, ["Mega|Fly"] = 266.57, ["Mega|Ride"] = 200.82, ["Mega|Fly|Ride"] = 280.85}},
    ["rbxassetid://90170598608675"] = {name = "Moonbeam Butterfly", prices = {["default"] = 131.61, ["Ride"] = 139.18, ["Fly|Ride"] = 182.43, ["Neon"] = 554.6, ["Neon|Ride"] = 600.29, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 2594.31}},
    ["rbxassetid://7126722445"] = {name = "Goldhorn", prices = {["default"] = 31.05, ["Fly"] = 78.75, ["Ride"] = 55.13, ["Fly|Ride"] = 97.48, ["Neon"] = 207.73, ["Neon|Ride"] = 204.46, ["Neon|Fly|Ride"] = 259.88, ["Mega"] = 1385.45, ["Mega|Ride"] = 1291.65, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://13186021971"] = {name = "Cuddly Candle", prices = {["default"] = 18.38, ["Fly"] = 42, ["Ride"] = 36.75, ["Fly|Ride"] = 62.33, ["Neon"] = 139.18, ["Neon|Ride"] = 136.5, ["Neon|Fly|Ride"] = 233.68, ["Mega|Ride"] = 1349.09, ["Mega|Fly|Ride"] = 931.76}},
    ["rbxassetid://14146196672"] = {name = "Gargoyle", prices = {["default"] = 56.44, ["Fly"] = 206.07, ["Ride"] = 78.56, ["Fly|Ride"] = 131.25, ["Neon"] = 360.39, ["Neon|Fly"] = 413.36, ["Neon|Ride"] = 301.88, ["Neon|Fly|Ride"] = 262.5, ["Mega|Fly|Ride"] = 1557.84}},
    ["rbxassetid://129762233626342"] = {name = "Royal Moon Egg", prices = {["default"] = 51.08}},
    ["rbxassetid://89693546199400"] = {name = "Cupid Dragon", prices = {["default"] = 379.32, ["Fly"] = 395, ["Ride"] = 357, ["Fly|Ride"] = 386.6, ["Neon"] = 1277.43, ["Neon|Ride"] = 1409.1, ["Neon|Fly|Ride"] = 1223.24, ["Mega|Fly|Ride"] = 4833.44}},
    ["rbxassetid://8665606875"] = {name = "Dancing Dragon", prices = {["default"] = 103.69, ["Fly"] = 118.57, ["Ride"] = 114.66, ["Fly|Ride"] = 145.68, ["Neon|Ride"] = 564.38, ["Neon|Fly|Ride"] = 525, ["Mega|Fly|Ride"] = 2561.08}},
    ["rbxassetid://110411427278536"] = {name = "Huntsman Robin", prices = {["default"] = 3.68, ["Fly"] = 115.13, ["Ride"] = 51.35, ["Fly|Ride"] = 205.4, ["Neon"] = 22.32, ["Neon|Fly"] = 96.41, ["Neon|Ride"] = 65.62, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 142.96, ["Mega|Ride"] = 189, ["Mega|Fly|Ride"] = 388.68}},
    ["rbxassetid://10925517718"] = {name = "Lava Dragon", prices = {["default"] = 157.5, ["Fly"] = 196.88, ["Ride"] = 148.99, ["Fly|Ride"] = 183.73, ["Neon"] = 939.41, ["Neon|Ride"] = 747.78, ["Neon|Fly|Ride"] = 572.99, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://4797806482"] = {name = "Diamond Griffin", prices = {["default"] = 3.56, ["Fly"] = 26.67, ["Ride"] = 19.69, ["Fly|Ride"] = 48.83, ["Neon"] = 27.57, ["Neon|Ride"] = 43.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 262.5, ["Mega|Ride"] = 326.82, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://122648024705835"] = {name = "Scarebear", prices = {["default"] = 72.19, ["Fly"] = 262.5, ["Ride"] = 127.63, ["Fly|Ride"] = 251.77, ["Neon"] = 251.06, ["Neon|Fly"] = 469.74, ["Neon|Ride"] = 288.74, ["Neon|Fly|Ride"] = 426.57, ["Mega"] = 1385.45, ["Mega|Ride"] = 1076.15, ["Mega|Fly|Ride"] = 1102.5}},
    ["rbxassetid://13104102169"] = {name = "Danger Egg", prices = {["default"] = 49.87}},
    ["rbxassetid://133163961974577"] = {name = "2D Doggy", prices = {["default"] = 56.9, ["Ride"] = 105, ["Fly|Ride"] = 235.76, ["Neon"] = 577.5, ["Neon|Ride"] = 679.23, ["Neon|Fly|Ride"] = 2362.5}},
    ["rbxassetid://126071806166898"] = {name = "Evil Chick", prices = {["default"] = 12.49, ["Fly"] = 374.07, ["Ride"] = 59.07, ["Fly|Ride"] = 223.12, ["Neon"] = 203.34, ["Neon|Ride"] = 94.53, ["Neon|Fly|Ride"] = 249.27, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 1661.7}},
    ["rbxassetid://5721843247"] = {name = "Dodo", prices = {["default"] = 52.8, ["Fly"] = 95.19, ["Ride"] = 52.29, ["Fly|Ride"] = 100.59, ["Neon"] = 207.73, ["Neon|Ride"] = 204.35, ["Neon|Fly|Ride"] = 218.3, ["Mega"] = 1643.95, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://119640582603552"] = {name = "Violet Butterfly", prices = {["default"] = 39.37, ["Fly"] = 277.31, ["Ride"] = 117.44, ["Fly|Ride"] = 136.5, ["Neon"] = 131.25, ["Neon|Fly"] = 389.89, ["Neon|Ride"] = 273.16, ["Neon|Fly|Ride"] = 298.08, ["Mega"] = 1079.07, ["Mega|Ride"] = 1242.13, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://16088264958"] = {name = "Volcanic Rhino", prices = {["default"] = 22.31, ["Ride"] = 30.18, ["Fly|Ride"] = 131.24, ["Neon|Ride"] = 166.19, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1207.92, ["Mega|Ride"] = 2075.04, ["Mega|Fly|Ride"] = 1023.75}},
    ["rbxassetid://75251818654427"] = {name = "Apple Owl", prices = {["default"] = 63.42, ["Fly"] = 611.79, ["Ride"] = 69.57, ["Fly|Ride"] = 147.96, ["Neon"] = 181.76, ["Neon|Fly"] = 555.64, ["Neon|Ride"] = 298.29, ["Neon|Fly|Ride"] = 315, ["Mega|Ride"] = 1124.82, ["Mega|Fly|Ride"] = 943.69}},
    ["rbxassetid://3181727433"] = {name = "Dragon", prices = {["default"] = 4.79, ["Fly"] = 29.57, ["Ride"] = 27.57, ["Fly|Ride"] = 39.38, ["Neon"] = 27.03, ["Neon|Fly"] = 51.95, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 103.94, ["Mega"] = 145.69, ["Mega|Fly"] = 21305.69, ["Mega|Ride"] = 178.5, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://121496682360324"] = {name = "Sugar Axolotl", prices = {["default"] = 375.8, ["Ride"] = 394.94, ["Fly|Ride"] = 442.32, ["Neon|Ride"] = 1443.75, ["Neon|Fly|Ride"] = 1666.88, ["Mega"] = 12462.63, ["Mega|Fly|Ride"] = 7269.87}},
    ["rbxassetid://11694854226"] = {name = "Shetland Pony Light Brown", prices = {["default"] = 15.64, ["Ride"] = 35.24, ["Fly|Ride"] = 105.18, ["Neon"] = 249.27, ["Neon|Fly|Ride"] = 423.74, ["Mega|Fly|Ride"] = 922.25}},
    ["rbxassetid://4797806957"] = {name = "Golden Unicorn", prices = {["default"] = 3.5, ["Fly"] = 41.11, ["Ride"] = 23.37, ["Fly|Ride"] = 49.89, ["Neon"] = 50.04, ["Neon|Ride"] = 66.94, ["Neon|Fly|Ride"] = 137.12, ["Mega"] = 313.53, ["Mega|Ride"] = 619.5, ["Mega|Fly|Ride"] = 410.22}},
    ["rbxassetid://110822620060051"] = {name = "Frost Phoenix", prices = {["default"] = 106.87, ["Fly"] = 113.53, ["Ride"] = 102.72, ["Fly|Ride"] = 123.3, ["Neon"] = 414.4, ["Neon|Fly"] = 458.01, ["Neon|Ride"] = 385.75, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2063.61, ["Mega|Ride"] = 7290.94, ["Mega|Fly|Ride"] = 1990.83}},
    ["rbxassetid://13894724323"] = {name = "Billy Goat", prices = {["default"] = 9.18, ["Ride"] = 33.25, ["Fly|Ride"] = 75.22, ["Neon"] = 150.93, ["Neon|Ride"] = 145.69, ["Neon|Fly|Ride"] = 161.44, ["Mega"] = 704.57, ["Mega|Ride"] = 788.28, ["Mega|Fly|Ride"] = 483}},
    ["rbxassetid://123037843357105"] = {name = "Glormy Leo", prices = {["default"] = 221.55, ["Fly"] = 351.04, ["Ride"] = 232.57, ["Fly|Ride"] = 298.08, ["Neon"] = 934.71, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 829.82, ["Mega"] = 6231.32, ["Mega|Ride"] = 2887.5, ["Mega|Fly|Ride"] = 2859.17}},
    ["rbxassetid://12479078933"] = {name = "Southeast Asia Egg", prices = {["default"] = 30.14}},
    ["rbxassetid://122739780018633"] = {name = "Quetzalcoatl", prices = {["default"] = 3.94, ["Fly"] = 36.37, ["Ride"] = 22.85, ["Fly|Ride"] = 60.13, ["Neon"] = 31.18, ["Neon|Fly"] = 4635.63, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 135.06, ["Mega"] = 157.5, ["Mega|Fly"] = 281.82, ["Mega|Ride"] = 246.47, ["Mega|Fly|Ride"] = 234.86}},
    ["rbxassetid://70953296065239"] = {name = "Frostbite Bear", prices = {["default"] = 1246.28, ["Fly"] = 3281.25, ["Ride"] = 1940.03, ["Fly|Ride"] = 2205, ["Neon"] = 7158.38, ["Neon|Ride"] = 5906.25, ["Neon|Fly|Ride"] = 7290.94, ["Mega|Ride"] = 52839.7, ["Mega|Fly|Ride"] = 26772.12}},
    ["rbxassetid://14978701948"] = {name = "Scarecrow Crow", prices = {["default"] = 10.42, ["Fly"] = 68.1, ["Ride"] = 26.24, ["Fly|Ride"] = 133.89, ["Neon"] = 102.69, ["Neon|Ride"] = 103.87, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 526.57, ["Mega|Ride"] = 664.69, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://11191341630"] = {name = "Jousting Horse", prices = {["default"] = 131.93, ["Ride"] = 143.07, ["Fly|Ride"] = 249.38, ["Neon"] = 830.86, ["Neon|Ride"] = 616.91, ["Neon|Fly|Ride"] = 895.69, ["Mega|Ride"] = 3992.21, ["Mega|Fly|Ride"] = 2756.34}},
    ["rbxassetid://76801905892592"] = {name = "Royal Aztec Egg", prices = {["default"] = 40.01}},
    ["rbxassetid://98801943598121"] = {name = "Priceless Shrimp", prices = {["default"] = 22.32, ["Fly"] = 68.84, ["Ride"] = 83.1, ["Fly|Ride"] = 139.18, ["Neon"] = 98.44, ["Neon|Ride"] = 117.44, ["Neon|Fly|Ride"] = 472.5, ["Mega"] = 670.9, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 736.24}},
    ["rbxassetid://95214789806437"] = {name = "Aztec Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://18515755354"] = {name = "Cheetah", prices = {["default"] = 139.13, ["Ride"] = 325.5, ["Fly|Ride"] = 190.31, ["Neon"] = 525, ["Neon|Ride"] = 498.52, ["Mega|Fly|Ride"] = 2382.19}},
    ["rbxassetid://18117855114"] = {name = "Corn Doggo", prices = {["default"] = 103.94, ["Ride"] = 201.49, ["Fly|Ride"] = 335.47, ["Neon"] = 436.21, ["Neon|Ride"] = 367.5, ["Neon|Fly|Ride"] = 437.07, ["Mega"] = 1968.75, ["Mega|Ride"] = 1509.37, ["Mega|Fly|Ride"] = 1786.33}},
    ["rbxassetid://8972175010"] = {name = "Woodland Egg", prices = {["default"] = 61.02}},
    ["rbxassetid://3710823011"] = {name = "Golden Penguin", prices = {["default"] = 63.03, ["Fly"] = 45.94, ["Ride"] = 63.42, ["Fly|Ride"] = 65.63, ["Neon"] = 623.15, ["Neon|Ride"] = 371.82, ["Neon|Fly|Ride"] = 292.48, ["Mega"] = 4154.22, ["Mega|Fly|Ride"] = 1509.38}},
    ["rbxassetid://136490701345923"] = {name = "Glormy Crab", prices = {["default"] = 6.25, ["Ride"] = 39.32, ["Fly|Ride"] = 111.14, ["Neon"] = 94.5, ["Neon|Ride"] = 123.65, ["Neon|Fly|Ride"] = 231.6, ["Mega"] = 223.12, ["Mega|Fly"] = 267.75, ["Mega|Ride"] = 220.5, ["Mega|Fly|Ride"] = 409.5}},
    ["rbxassetid://14782580581"] = {name = "Vampire Dragon", prices = {["default"] = 406.88, ["Fly"] = 423.94, ["Ride"] = 436.2, ["Fly|Ride"] = 484.32, ["Neon|Ride"] = 1568.73, ["Neon|Fly|Ride"] = 1181.24, ["Mega|Fly|Ride"] = 6273.75}},
    ["rbxassetid://88405494856204"] = {name = "Solaris", prices = {["default"] = 86.63, ["Fly"] = 111.14, ["Ride"] = 91.88, ["Fly|Ride"] = 131.25, ["Neon"] = 446.25, ["Neon|Ride"] = 502.62, ["Neon|Fly|Ride"] = 437.07, ["Mega|Ride"] = 2479.04, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://84468510887759"] = {name = "Orchid Butterfly", prices = {["default"] = 3696, ["Ride"] = 3433.5, ["Fly|Ride"] = 3018.75, ["Neon|Fly|Ride"] = 14538.69}},
    ["rbxassetid://11109286837"] = {name = "Lava Wolf", prices = {["default"] = 37.63, ["Fly"] = 110.1, ["Ride"] = 54.02, ["Fly|Ride"] = 91.88, ["Neon"] = 393.75, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 407.48, ["Mega|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 1022.44}},
    ["rbxassetid://12403863809"] = {name = "Albino Gorilla", prices = {["default"] = 81.38, ["Fly"] = 83.1, ["Ride"] = 78.75, ["Fly|Ride"] = 103.69, ["Neon"] = 585.96, ["Neon|Ride"] = 346.89, ["Neon|Fly|Ride"] = 692.73, ["Mega"] = 6231.32, ["Mega|Fly|Ride"] = 1648.2}},
    ["rbxassetid://6060988121"] = {name = "Snow Owl", prices = {["default"] = 34.71, ["Fly"] = 74.67, ["Ride"] = 73.76, ["Fly|Ride"] = 112.88, ["Neon"] = 262.5, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 218.43, ["Mega"] = 2625, ["Mega|Ride"] = 730.75, ["Mega|Fly|Ride"] = 668.49}},
    ["rbxassetid://112630556645658"] = {name = "Moon Egg", prices = {["default"] = 8.33}},
    ["rbxassetid://10357473556"] = {name = "Golden Chow-Chow", prices = {["default"] = 45.93, ["Ride"] = 47.25, ["Fly|Ride"] = 95.82, ["Neon"] = 328.13, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 548.37, ["Mega|Fly|Ride"] = 1566.42}},
    ["rbxassetid://5721843384"] = {name = "Fossil Egg", prices = {["default"] = 37.98}},
    ["rbxassetid://92775688228060"] = {name = "Papa Moose", prices = {["default"] = 210, ["Ride"] = 196.88, ["Fly|Ride"] = 317.81, ["Neon|Ride"] = 1385.45, ["Neon|Fly|Ride"] = 2201.97}},
    ["rbxassetid://12479991588"] = {name = "Frost Unicorn", prices = {["default"] = 1107.75, ["Ride"] = 787.5, ["Fly|Ride"] = 998.82, ["Neon|Ride"] = 3916.36, ["Neon|Fly|Ride"] = 3916.11, ["Mega|Fly|Ride"] = 15578.28}},
    ["rbxassetid://9661880325"] = {name = "Zodiac Minion Egg", prices = {["default"] = 10.5}},
    ["rbxassetid://7126719832"] = {name = "Phoenix", prices = {["default"] = 31.5, ["Fly"] = 61.09, ["Ride"] = 27.02, ["Fly|Ride"] = 65.63, ["Neon"] = 178.5, ["Neon|Ride"] = 157.21, ["Neon|Fly|Ride"] = 221.45, ["Mega|Ride"] = 866.17, ["Mega|Fly|Ride"] = 845.45}},
    ["rbxassetid://119386690822810"] = {name = "Royal Fairytale Egg", prices = {["default"] = 11.39}},
    ["rbxassetid://4440866299"] = {name = "Crow", prices = {["default"] = 5919.76, ["Ride"] = 5587.42, ["Fly|Ride"] = 4265.63, ["Neon|Fly|Ride"] = 10827.6, ["Mega|Fly|Ride"] = 40434.98}},
    ["rbxassetid://4797806531"] = {name = "Diamond Unicorn", prices = {["default"] = 12.91, ["Fly"] = 28.06, ["Ride"] = 27.74, ["Fly|Ride"] = 59.06, ["Neon"] = 91.41, ["Neon|Ride"] = 120.75, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 624.75, ["Mega|Ride"] = 479.88, ["Mega|Fly|Ride"] = 519.29}},
    ["rbxassetid://88817325500927"] = {name = "Kraken", prices = {["default"] = 12.55, ["Fly"] = 41.56, ["Ride"] = 35.33, ["Fly|Ride"] = 116.27, ["Neon"] = 111.57, ["Neon|Ride"] = 132.57, ["Neon|Fly|Ride"] = 247.19, ["Mega"] = 1045.09, ["Mega|Ride"] = 651.19, ["Mega|Fly|Ride"] = 970.02}},
    ["rbxassetid://9490243442"] = {name = "Diamond King Penguin", prices = {["default"] = 80.07, ["Fly"] = 250.08, ["Ride"] = 55.54, ["Fly|Ride"] = 110.4, ["Neon"] = 1385.45, ["Neon|Fly|Ride"] = 630, ["Mega"] = 4154.22}},
    ["rbxassetid://107787284008278"] = {name = "Primal Kaijunior", prices = {["default"] = 8.33, ["Ride"] = 35.44, ["Fly|Ride"] = 139.65, ["Neon"] = 78.75, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 361.43, ["Mega|Ride"] = 501.42, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://4506837037"] = {name = "Arctic Reindeer", prices = {["default"] = 2624.99, ["Fly"] = 2122.32, ["Ride"] = 2191.7, ["Fly|Ride"] = 2092.92, ["Neon|Fly|Ride"] = 4412.63, ["Mega|Fly|Ride"] = 12468.75}},
    ["rbxassetid://4184878149"] = {name = "Bat Dragon", prices = {["default"] = 29400, ["Fly"] = 35071.17, ["Ride"] = 52500, ["Fly|Ride"] = 22320.88, ["Neon|Ride"] = 65625, ["Neon|Fly|Ride"] = 63819, ["Mega"] = 210000, ["Mega|Fly|Ride"] = 183750}},
    ["rbxassetid://118641789458122"] = {name = "Gilded Snake", prices = {["default"] = 15.59, ["Fly"] = 220.19, ["Ride"] = 48.83, ["Fly|Ride"] = 89.93, ["Neon"] = 139.18, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 257.6, ["Mega"] = 830.86, ["Mega|Ride"] = 1141.88, ["Mega|Fly|Ride"] = 826.88}},
    ["rbxassetid://71844856693163"] = {name = "Purrowl", prices = {["default"] = 3.93, ["Fly"] = 45.81, ["Ride"] = 33.98, ["Fly|Ride"] = 165.38, ["Neon"] = 24.86, ["Neon|Fly"] = 96.94, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 188.92, ["Mega|Ride"] = 196.87, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://7195311687"] = {name = "Mythic Egg", prices = {["default"] = 22.29}},
    ["rbxassetid://102330087609546"] = {name = "Fire Mare", prices = {["default"] = 7.26, ["Ride"] = 36.74, ["Fly|Ride"] = 111.57, ["Neon"] = 56.44, ["Neon|Ride"] = 106.87, ["Neon|Fly|Ride"] = 463.21, ["Mega"] = 355.2, ["Mega|Ride"] = 291.38, ["Mega|Fly|Ride"] = 545.57}},
    ["rbxassetid://16659215347"] = {name = "Candyfloss Chick", prices = {["default"] = 629.99, ["Ride"] = 769.49, ["Fly|Ride"] = 774.38, ["Neon|Ride"] = 2935.8, ["Neon|Fly|Ride"] = 2656.63, ["Mega|Fly|Ride"] = 10960.14}},
    ["rbxassetid://9281950769"] = {name = "Sugar Glider", prices = {["default"] = 997.5, ["Fly"] = 962.07, ["Ride"] = 857.46, ["Fly|Ride"] = 892.5, ["Neon"] = 4154.22, ["Neon|Ride"] = 3254.84, ["Neon|Fly|Ride"] = 3109.31, ["Mega|Fly|Ride"] = 11191.45}},
    ["rbxassetid://15485137935"] = {name = "Fleur De Ice", prices = {["default"] = 28.06, ["Fly"] = 117.44, ["Ride"] = 41.54, ["Fly|Ride"] = 98.44, ["Neon"] = 97.63, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 203.57, ["Mega"] = 1026.81, ["Mega|Ride"] = 685.13}},
    ["rbxassetid://6498256269"] = {name = "Ocean Egg", prices = {["default"] = 32.91}},
    ["rbxassetid://8704877940"] = {name = "Lavender Dragon", prices = {["default"] = 61.3, ["Fly"] = 93.19, ["Ride"] = 76.13, ["Fly|Ride"] = 120.9, ["Neon|Ride"] = 415.44, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 2033.5, ["Mega|Fly|Ride"] = 1846.56}},
    ["rbxassetid://13685038182"] = {name = "Leviathan", prices = {["default"] = 52.5, ["Ride"] = 64.31, ["Fly|Ride"] = 274.32, ["Neon"] = 332.35, ["Neon|Fly"] = 533.84, ["Neon|Ride"] = 394.67, ["Neon|Fly|Ride"] = 311.07, ["Mega"] = 1744.79, ["Mega|Fly|Ride"] = 1715.18}},
    ["rbxassetid://4797806358"] = {name = "Diamond Dragon", prices = {["default"] = 3.92, ["Fly"] = 36.28, ["Ride"] = 20, ["Fly|Ride"] = 56.1, ["Neon"] = 37.41, ["Neon|Fly"] = 525, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 236.25, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://5862774327"] = {name = "Cerberus", prices = {["default"] = 97.43, ["Fly"] = 105, ["Ride"] = 121.45, ["Fly|Ride"] = 170.63, ["Neon|Ride"] = 387.4, ["Neon|Fly|Ride"] = 353.06, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://74012786571707"] = {name = "Three Blind Mice", prices = {["default"] = 5.09, ["Ride"] = 42.34, ["Fly|Ride"] = 144.45, ["Neon"] = 63.36, ["Neon|Ride"] = 136.5, ["Mega"] = 224.56, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 506.03}},
    ["rbxassetid://15931348363"] = {name = "Criosphinx", prices = {["default"] = 14.56, ["Fly"] = 40.28, ["Ride"] = 39.37, ["Fly|Ride"] = 78.75, ["Neon"] = 103.87, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 173.25, ["Mega"] = 734.27, ["Mega|Fly|Ride"] = 721.88}},
    ["rbxassetid://118278167134251"] = {name = "Influencer Gibbon", prices = {["default"] = 26.24, ["Ride"] = 63.42, ["Fly|Ride"] = 156.19, ["Neon"] = 245.44, ["Neon|Ride"] = 328.19, ["Mega"] = 694.25, ["Mega|Ride"] = 548.37, ["Mega|Fly|Ride"] = 866.17}},
    ["rbxassetid://17059982206"] = {name = "Dimorphodon", prices = {["default"] = 19.68, ["Fly"] = 117.97, ["Ride"] = 32.82, ["Fly|Ride"] = 76.86, ["Neon"] = 91.88, ["Neon|Fly"] = 554.6, ["Neon|Ride"] = 143.34, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 828.78, ["Mega|Fly|Ride"] = 947.63}},
    ["rbxassetid://119212313534429"] = {name = "Giant Panda", prices = {["default"] = 6924.04, ["Fly"] = 6924.04, ["Ride"] = 6693.75, ["Fly|Ride"] = 6076.61, ["Neon"] = 34619.09, ["Neon|Fly|Ride"] = 22432.73}},
    ["rbxassetid://6060998707"] = {name = "Frost Fury", prices = {["default"] = 252.11, ["Fly"] = 249.27, ["Ride"] = 218.67, ["Fly|Ride"] = 264, ["Neon"] = 783.24, ["Neon|Fly|Ride"] = 570.94, ["Mega|Fly|Ride"] = 2046.14}},
    ["rbxassetid://88882779021298"] = {name = "Kitty Bat", prices = {["default"] = 34.13, ["Fly"] = 69.6, ["Ride"] = 65.63, ["Fly|Ride"] = 134.67, ["Neon"] = 67.54, ["Neon|Fly"] = 241.5, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 369.1, ["Mega|Fly"] = 554.6, ["Mega|Ride"] = 361.24, ["Mega|Fly|Ride"] = 456.69}},
    ["rbxassetid://16441372760"] = {name = "Diamond Mahi Mahi", prices = {["default"] = 3.88, ["Ride"] = 20.55, ["Fly|Ride"] = 97.63, ["Neon"] = 31.5, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 201.99, ["Mega"] = 499.8}},
    ["rbxassetid://3199974169"] = {name = "Royal Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://84714602656867"] = {name = "Slimingo", prices = {["default"] = 31.5, ["Fly"] = 5322.86, ["Ride"] = 111.14, ["Fly|Ride"] = 195.57, ["Neon"] = 110.4, ["Neon|Fly"] = 330.27, ["Neon|Ride"] = 129.94, ["Neon|Fly|Ride"] = 275.43, ["Mega"] = 435.75, ["Mega|Ride"] = 536.42, ["Mega|Fly|Ride"] = 584.72}},
    ["rbxassetid://3409443710"] = {name = "Giraffe", prices = {["default"] = 14070, ["Ride"] = 13848.07, ["Fly|Ride"] = 10899, ["Neon|Fly|Ride"] = 25865.82, ["Mega|Fly|Ride"] = 107593.95}},
    ["rbxassetid://121215031043780"] = {name = "Velocirooster", prices = {["default"] = 165.37, ["Ride"] = 217.88, ["Fly|Ride"] = 249.38, ["Neon"] = 1422.83, ["Neon|Ride"] = 1523.58, ["Neon|Fly|Ride"] = 943.69, ["Mega|Fly|Ride"] = 4668.3}},
    ["rbxassetid://5067925034"] = {name = "Ninja Monkey", prices = {["default"] = 68.75, ["Fly"] = 107.15, ["Ride"] = 77.44, ["Fly|Ride"] = 103.87, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 378.12, ["Mega|Fly|Ride"] = 2234.98}},
    ["rbxassetid://10618035564"] = {name = "Baku", prices = {["default"] = 11.28, ["Fly"] = 28.53, ["Ride"] = 25.87, ["Fly|Ride"] = 69.6, ["Neon"] = 86.91, ["Neon|Ride"] = 68.83, ["Neon|Fly|Ride"] = 118.12, ["Mega"] = 2492.55, ["Mega|Fly|Ride"] = 970.02}},
    ["rbxassetid://13665641282"] = {name = "Shark Puppy", prices = {["default"] = 367.49, ["Fly"] = 490.85, ["Ride"] = 412.39, ["Fly|Ride"] = 468.09, ["Neon"] = 1639.32, ["Neon|Ride"] = 1299.38, ["Neon|Fly|Ride"] = 1509.38, ["Mega|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 4558.83}},
    ["rbxassetid://119447343321908"] = {name = "Tealwood Monster", prices = {["default"] = 6.38, ["Ride"] = 38.07, ["Fly|Ride"] = 124.65, ["Neon"] = 26.24, ["Neon|Ride"] = 63.42, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 138.33, ["Mega|Fly"] = 194.22, ["Mega|Ride"] = 164.06, ["Mega|Fly|Ride"] = 276.94}},
    ["rbxassetid://85568505745239"] = {name = "Latte Kitsune", prices = {["default"] = 255.92, ["Ride"] = 336, ["Fly|Ride"] = 410.25, ["Neon"] = 970.02, ["Neon|Ride"] = 922.25, ["Neon|Fly|Ride"] = 1048.69, ["Mega|Fly|Ride"] = 3463.59}},
    ["rbxassetid://3181727727"] = {name = "Griffin", prices = {["default"] = 13, ["Fly"] = 15.71, ["Ride"] = 17.61, ["Fly|Ride"] = 36.66, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 104.97, ["Mega"] = 2492.55, ["Mega|Fly|Ride"] = 682.5}},
    ["rbxassetid://4822753215"] = {name = "Golden Egg", prices = {["default"] = 12.24}},
    ["rbxassetid://116463571924920"] = {name = "Prismatic Butterfly", prices = {["default"] = 62.33, ["Ride"] = 91.88, ["Fly|Ride"] = 525, ["Neon"] = 414.4, ["Neon|Fly"] = 1661.7, ["Neon|Ride"] = 315, ["Neon|Fly|Ride"] = 3081.75, ["Mega"] = 1108.14, ["Mega|Ride"] = 1246.28, ["Mega|Fly|Ride"] = 1174.23}},
    ["rbxassetid://8596153183"] = {name = "Chameleon", prices = {["default"] = 10.41, ["Fly"] = 65.63, ["Ride"] = 41.56, ["Fly|Ride"] = 84.67, ["Neon"] = 76.86, ["Neon|Ride"] = 115.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 514.11, ["Mega|Ride"] = 547.34, ["Mega|Fly|Ride"] = 546}},
    ["rbxassetid://110774856122162"] = {name = "Gemstone Egg", prices = {["default"] = 17.8}},
    ["rbxassetid://14892649590"] = {name = "Dire Stag", prices = {["default"] = 36.74, ["Fly"] = 111.57, ["Ride"] = 87.25, ["Fly|Ride"] = 313.53, ["Neon"] = 237.57, ["Neon|Ride"] = 258.54, ["Neon|Fly|Ride"] = 276.27, ["Mega"] = 1108.14, ["Mega|Ride"] = 929.52, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://106744890070136"] = {name = "Oakee Wizard", prices = {["default"] = 3.93, ["Ride"] = 29.23, ["Fly|Ride"] = 132.2, ["Neon"] = 27.02, ["Neon|Ride"] = 105.7, ["Neon|Fly|Ride"] = 136.07, ["Mega"] = 131.25, ["Mega|Fly|Ride"] = 462.67}},
    ["rbxassetid://9938967576"] = {name = "Chocolate Chow-Chow", prices = {["default"] = 15.6, ["Fly"] = 69.6, ["Ride"] = 27.75, ["Fly|Ride"] = 52.5, ["Neon"] = 249.38, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 220.19, ["Mega|Ride"] = 502.59, ["Mega|Fly|Ride"] = 810.09}},
    ["rbxassetid://9174893483"] = {name = "Mechapup", prices = {["default"] = 415.44, ["Ride"] = 380.39, ["Fly|Ride"] = 409.5, ["Neon|Fly|Ride"] = 2631.7, ["Mega|Fly|Ride"] = 8723.85}},
    ["rbxassetid://15292843858"] = {name = "Mecha Meow", prices = {["default"] = 27.26, ["Fly"] = 103.87, ["Ride"] = 57.37, ["Fly|Ride"] = 103.67, ["Neon"] = 223.13, ["Neon|Ride"] = 170.63, ["Neon|Fly|Ride"] = 235.76, ["Mega"] = 718.69, ["Mega|Ride"] = 679.23, ["Mega|Fly|Ride"] = 655.23}},
    ["rbxassetid://15931200262"] = {name = "Cactus Friend", prices = {["default"] = 55.12, ["Fly"] = 92.3, ["Ride"] = 72.19, ["Fly|Ride"] = 110.25, ["Neon"] = 458.01, ["Neon|Ride"] = 272.9, ["Neon|Fly|Ride"] = 346.5, ["Mega|Fly|Ride"] = 1232.77}},
    ["rbxassetid://127221459636244"] = {name = "Strawberry Shortcake Ducky", prices = {["default"] = 33.45, ["Ride"] = 65.63, ["Fly|Ride"] = 110.25, ["Neon"] = 111.56, ["Neon|Fly"] = 313.57, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 238.88, ["Mega"] = 288.75, ["Mega|Ride"] = 396.38, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://4470748644"] = {name = "Frost Dragon", prices = {["default"] = 11287.5, ["Fly"] = 8491.88, ["Ride"] = 9995.9, ["Fly|Ride"] = 7855.32, ["Neon|Fly|Ride"] = 14724.94, ["Mega|Fly|Ride"] = 39373.69}},
    ["rbxassetid://15365667976"] = {name = "Chocolate Chip Bat Dragon", prices = {["default"] = 1652.44, ["Ride"] = 1561.88, ["Fly|Ride"] = 1677.38, ["Neon|Ride"] = 5310.26, ["Neon|Fly|Ride"] = 3937.5, ["Mega"] = 21463.76, ["Mega|Fly|Ride"] = 15093.75}},
    ["rbxassetid://16898343164"] = {name = "Pirate Ghost Capuchin Monkey", prices = {["default"] = 497.93, ["Ride"] = 500.26, ["Fly|Ride"] = 563.66, ["Neon"] = 2271.33, ["Neon|Fly|Ride"] = 1800.86, ["Mega"] = 16616.84, ["Mega|Fly|Ride"] = 6741.26}},
    ["rbxassetid://6404812772"] = {name = "Golden Ladybug", prices = {["default"] = 12.47, ["Fly"] = 23.62, ["Ride"] = 20.99, ["Fly|Ride"] = 45.02, ["Neon"] = 108.78, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 153.71, ["Mega|Fly|Ride"] = 472.49}},
    ["rbxassetid://95029455226760"] = {name = "Easter Bunny", prices = {["default"] = 6.38, ["Fly"] = 32.82, ["Ride"] = 161.09, ["Neon"] = 28.06, ["Neon|Ride"] = 68.63, ["Neon|Fly|Ride"] = 147, ["Mega"] = 157.5, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 263.82}},
    ["rbxassetid://5307473113"] = {name = "Kitsune", prices = {["default"] = 41.28, ["Fly"] = 53.79, ["Ride"] = 52.45, ["Fly|Ride"] = 105, ["Neon"] = 272.12, ["Neon|Ride"] = 158.82, ["Neon|Fly|Ride"] = 174.57, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://4797806780"] = {name = "Golden Dragon", prices = {["default"] = 3.74, ["Fly"] = 23.14, ["Ride"] = 20.74, ["Fly|Ride"] = 41.46, ["Neon"] = 23.49, ["Neon|Fly"] = 91.87, ["Neon|Ride"] = 51.69, ["Neon|Fly|Ride"] = 98.95, ["Mega"] = 472.5, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 259.66}},
    ["rbxassetid://135649428081307"] = {name = "Sakura Spirit", prices = {["default"] = 291.26, ["Fly"] = 320.25, ["Ride"] = 277.35, ["Fly|Ride"] = 367.5, ["Neon"] = 1060.56, ["Neon|Ride"] = 1166.82, ["Neon|Fly|Ride"] = 1137.94, ["Mega|Fly|Ride"] = 6231.32}},
    ["rbxassetid://11109110190"] = {name = "White Amazon", prices = {["default"] = 27.01, ["Fly"] = 60.09, ["Ride"] = 41.56, ["Fly|Ride"] = 74.79, ["Neon"] = 105.94, ["Neon|Fly"] = 157.37, ["Neon|Ride"] = 156.96, ["Neon|Fly|Ride"] = 189.04, ["Mega|Ride"] = 582.75, ["Mega|Fly|Ride"] = 594.06}},
    ["rbxassetid://9475753542"] = {name = "Golden Albatross", prices = {["default"] = 9.39, ["Fly"] = 27.02, ["Ride"] = 22.32, ["Fly|Ride"] = 41.11, ["Neon"] = 56.1, ["Neon|Fly"] = 133.89, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 1575, ["Mega|Ride"] = 618.19, ["Mega|Fly|Ride"] = 426.57}},
    ["rbxassetid://12778628831"] = {name = "Emperor Gorilla", prices = {["default"] = 392.44, ["Fly"] = 787.5, ["Ride"] = 343.01, ["Fly|Ride"] = 679.23, ["Neon|Ride"] = 2803.06, ["Mega|Fly|Ride"] = 8619.19}},
    ["rbxassetid://13672542902"] = {name = "Hot Doggo", prices = {["default"] = 1128.54, ["Fly"] = 1409.2, ["Ride"] = 1283.84, ["Fly|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 3570, ["Mega|Fly|Ride"] = 24925.25}},
    ["rbxassetid://8070897995"] = {name = "Ice Golem", prices = {["default"] = 89.99, ["Fly"] = 102.15, ["Ride"] = 99.71, ["Fly|Ride"] = 108.94, ["Neon"] = 415.44, ["Neon|Ride"] = 1713.09, ["Neon|Fly|Ride"] = 392.2, ["Mega|Fly|Ride"] = 3916.03}},
    ["rbxassetid://128225904426926"] = {name = "Rose Dragon", prices = {["default"] = 150.94, ["Fly"] = 212.13, ["Ride"] = 157.5, ["Fly|Ride"] = 223.13, ["Neon"] = 439.69, ["Neon|Ride"] = 692.73, ["Neon|Fly|Ride"] = 525, ["Mega"] = 5539.65, ["Mega|Ride"] = 8596.88, ["Mega|Fly|Ride"] = 2640.75}},
    ["rbxassetid://13883274830"] = {name = "Pirate Hermit Crab", prices = {["default"] = 26.25, ["Ride"] = 39.38, ["Fly|Ride"] = 277.31, ["Neon"] = 232.74, ["Neon|Fly"] = 415.44, ["Neon|Ride"] = 272.99, ["Neon|Fly|Ride"] = 373.9, ["Mega"] = 656.25, ["Mega|Ride"] = 2077.11, ["Mega|Fly|Ride"] = 893.18}},
    ["rbxassetid://95213400890066"] = {name = "Diamond Hummingbird", prices = {["default"] = 128.63, ["Ride"] = 415.43, ["Fly|Ride"] = 277.31, ["Neon|Fly|Ride"] = 1315.16, ["Mega|Fly|Ride"] = 2967.26}},
    ["rbxassetid://10453528102"] = {name = "Diamond Butterfly", prices = {["default"] = 1796.6, ["Ride"] = 2483.25, ["Fly|Ride"] = 1993.43, ["Neon|Fly|Ride"] = 7062.17, ["Mega|Fly|Ride"] = 47773.39}},
    ["rbxassetid://12778628650"] = {name = "Astronaut Gorilla", prices = {["default"] = 45.01, ["Ride"] = 52.5, ["Fly|Ride"] = 196.87, ["Neon"] = 310.54, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 343.87, ["Mega"] = 2077.11, ["Mega|Ride"] = 2284.83, ["Mega|Fly|Ride"] = 1628.65}},
    ["rbxassetid://4708551306"] = {name = "Kangaroo", prices = {["default"] = 616.88, ["Fly"] = 803.85, ["Ride"] = 628.81, ["Fly|Ride"] = 641.82, ["Neon|Ride"] = 1517.25, ["Neon|Fly|Ride"] = 1148.44, ["Mega|Fly|Ride"] = 3105.27}},
    ["rbxassetid://9542440966"] = {name = "Capricorn", prices = {["default"] = 44.94, ["Fly"] = 69.59, ["Ride"] = 50.94, ["Fly|Ride"] = 105, ["Neon"] = 332.35, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 242.82, ["Mega|Fly|Ride"] = 1094.64}},
    ["rbxassetid://9678195673"] = {name = "Ancient Dragon", prices = {["default"] = 3.82, ["Fly"] = 30.17, ["Ride"] = 21.17, ["Fly|Ride"] = 46.98, ["Neon"] = 38.93, ["Neon|Fly"] = 79.75, ["Neon|Ride"] = 46.99, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 204.33, ["Mega|Fly"] = 249.26, ["Mega|Ride"] = 188.96, ["Mega|Fly|Ride"] = 245.44}},
    ["rbxassetid://132388343771587"] = {name = "Kelp Captain", prices = {["default"] = 43, ["Ride"] = 105, ["Fly|Ride"] = 252, ["Neon"] = 259.87, ["Neon|Ride"] = 414.4, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 763.27, ["Mega|Ride"] = 1385.45, ["Mega|Fly|Ride"] = 824.2}},
    ["rbxassetid://15148532648"] = {name = "Werewolf", prices = {["default"] = 669.38, ["Fly"] = 1566.56, ["Ride"] = 656.25, ["Fly|Ride"] = 708.75, ["Neon|Ride"] = 2451.99, ["Neon|Fly|Ride"] = 1826.46, ["Mega|Fly|Ride"] = 6861.75}},
    ["rbxassetid://86323568215409"] = {name = "Tortoiseshell Guinea Pig", prices = {["default"] = 544.69, ["Ride"] = 630, ["Fly|Ride"] = 866.25, ["Neon"] = 5192.77, ["Neon|Fly|Ride"] = 3115.67, ["Mega|Fly|Ride"] = 13848.07}},
    ["rbxassetid://5973019152"] = {name = "Robo Dog", prices = {["default"] = 14.15, ["Fly"] = 34.61, ["Ride"] = 26.17, ["Fly|Ride"] = 44.89, ["Neon"] = 207.73, ["Neon|Ride"] = 124.65, ["Neon|Fly|Ride"] = 117.97, ["Mega|Fly|Ride"] = 627.05}},
    ["rbxassetid://7734928470"] = {name = "Halloween Golden Mummy Cat", prices = {["default"] = 8.33, ["Ride"] = 22.8, ["Fly|Ride"] = 64.4, ["Neon"] = 84, ["Neon|Ride"] = 91.87, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 970.02, ["Mega|Ride"] = 388.58, ["Mega|Fly|Ride"] = 378.67}},
    ["rbxassetid://137429532189183"] = {name = "Fire Stallion", prices = {["default"] = 4.61, ["Ride"] = 31.5, ["Fly|Ride"] = 111.45, ["Neon"] = 22.07, ["Neon|Fly"] = 313.57, ["Neon|Ride"] = 51.76, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 260.7, ["Mega|Fly"] = 454.44, ["Mega|Ride"] = 233.63, ["Mega|Fly|Ride"] = 303.19}},
    ["rbxassetid://7215324578"] = {name = "Axolotl", prices = {["default"] = 32.82, ["Fly"] = 53.82, ["Ride"] = 61.68, ["Fly|Ride"] = 105.77, ["Neon"] = 290.81, ["Neon|Ride"] = 210, ["Neon|Fly|Ride"] = 236.25, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://111805565268081"] = {name = "Black Widow", prices = {["default"] = 38.06, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.44, ["Neon|Ride"] = 479.25, ["Neon|Fly|Ride"] = 692.73, ["Mega|Fly|Ride"] = 1786.33}},
    ["rbxassetid://103653773461193"] = {name = "Sunglider", prices = {["default"] = 13.11, ["Fly"] = 59.07, ["Ride"] = 27.57, ["Fly|Ride"] = 81.47, ["Neon"] = 91.23, ["Neon|Fly"] = 157.37, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 157.36, ["Mega"] = 340.28, ["Mega|Ride"] = 406.88, ["Mega|Fly|Ride"] = 482.99}},
    ["rbxassetid://6498256069"] = {name = "Shark", prices = {["default"] = 39.38, ["Fly"] = 65.96, ["Ride"] = 38.07, ["Fly|Ride"] = 111.57, ["Neon"] = 196.88, ["Neon|Ride"] = 222.26, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 2100, ["Mega|Fly|Ride"] = 787.5}},
    ["rbxassetid://8663440945"] = {name = "Lunar Gold Tiger", prices = {["default"] = 3.11, ["Fly"] = 23.9, ["Ride"] = 15.75, ["Fly|Ride"] = 44.63, ["Neon"] = 33.93, ["Neon|Ride"] = 39.37, ["Neon|Fly|Ride"] = 90.08, ["Mega"] = 525, ["Mega|Ride"] = 277.31, ["Mega|Fly|Ride"] = 344.81}},
    ["rbxassetid://94185217299816"] = {name = "Dracula Parrot", prices = {["default"] = 6.18, ["Fly"] = 31.19, ["Ride"] = 27.57, ["Fly|Ride"] = 72.1, ["Neon"] = 25.46, ["Neon|Fly"] = 70.64, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 166.19, ["Mega"] = 346.89, ["Mega|Fly"] = 471.52, ["Mega|Ride"] = 288.75, ["Mega|Fly|Ride"] = 513.19}},
    ["rbxassetid://4621220431"] = {name = "Golden Rat", prices = {["default"] = 47.25, ["Fly"] = 65.6, ["Ride"] = 40.74, ["Fly|Ride"] = 59.07, ["Neon"] = 407.48, ["Neon|Ride"] = 276.27, ["Neon|Fly|Ride"] = 273, ["Mega|Fly|Ride"] = 919.09}},
    ["rbxassetid://11506045996"] = {name = "Strawberry Shortcake Bat Dragon", prices = {["default"] = 2054.07, ["Fly"] = 2118.66, ["Ride"] = 1706.25, ["Fly|Ride"] = 1651.74, ["Neon|Fly"] = 4990.84, ["Neon|Fly|Ride"] = 3734.07, ["Mega|Fly|Ride"] = 16284.02}},
    ["rbxassetid://11758583912"] = {name = "Winged Tiger", prices = {["default"] = 523.69, ["Fly"] = 547.46, ["Ride"] = 393.75, ["Fly|Ride"] = 531.15, ["Neon"] = 3131.72, ["Neon|Ride"] = 2492.55, ["Neon|Fly|Ride"] = 2362.5, ["Mega|Fly|Ride"] = 9661.66}},
    ["rbxassetid://101160794933271"] = {name = "Matcha Cat", prices = {["default"] = 236.25, ["Ride"] = 326.12, ["Fly|Ride"] = 444.51, ["Neon"] = 1412.44, ["Neon|Ride"] = 1453.98, ["Neon|Fly|Ride"] = 1260, ["Mega|Fly|Ride"] = 6825}},
    ["rbxassetid://13892790514"] = {name = "Urban Egg", prices = {["default"] = 52.49}},
    ["rbxassetid://13104109574"] = {name = "Spinosaurus", prices = {["default"] = 26.31, ["Ride"] = 40.01, ["Fly|Ride"] = 97.13, ["Neon"] = 328.75, ["Neon|Fly"] = 415.44, ["Neon|Ride"] = 306.38, ["Neon|Fly|Ride"] = 1968.75, ["Mega|Ride"] = 934.71, ["Mega|Fly|Ride"] = 1038.19}},
    ["rbxassetid://4115248712"] = {name = "Shadow Dragon", prices = {["default"] = 34619.09, ["Fly"] = 23625, ["Ride"] = 34781.25, ["Fly|Ride"] = 16155.3, ["Neon|Fly|Ride"] = 38062.5, ["Mega|Fly|Ride"] = 89250}},
    ["rbxassetid://71457697470071"] = {name = "Arctic Dusk Dragon", prices = {["default"] = 459.38, ["Fly"] = 437.07, ["Ride"] = 450.75, ["Fly|Ride"] = 524.99, ["Neon|Ride"] = 1566.55, ["Neon|Fly|Ride"] = 1558.23, ["Mega"] = 6231.32, ["Mega|Fly|Ride"] = 3845.62}},
    ["rbxassetid://8566683457"] = {name = "Giant Gold Scarab", prices = {["default"] = 157.37, ["Ride"] = 128.48, ["Fly|Ride"] = 155.38, ["Neon|Fly|Ride"] = 830.86, ["Mega|Fly|Ride"] = 4154.22}},
    ["rbxassetid://16116063171"] = {name = "Rainbow Dragon", prices = {["default"] = 124.58, ["Fly"] = 262.49, ["Ride"] = 131.48, ["Fly|Ride"] = 207.38, ["Neon"] = 702.22, ["Neon|Ride"] = 509.73, ["Neon|Fly|Ride"] = 595.35, ["Mega|Fly|Ride"] = 5192.77}},
    ["rbxassetid://9938967130"] = {name = "Black Chow-Chow", prices = {["default"] = 15.6, ["Fly"] = 94.5, ["Ride"] = 34.08, ["Fly|Ride"] = 98.48, ["Neon"] = 274.3, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 204.37, ["Mega"] = 691.69}},
    ["rbxassetid://116467943923352"] = {name = "Haetae", prices = {["default"] = 4754.51, ["Ride"] = 4708.81, ["Fly|Ride"] = 3937.49, ["Neon|Fly|Ride"] = 17297.09}},
    ["rbxassetid://6531232495"] = {name = "Peacock", prices = {["default"] = 27.66, ["Fly"] = 32.81, ["Ride"] = 29.98, ["Fly|Ride"] = 61.1, ["Neon"] = 333.94, ["Neon|Ride"] = 205.65, ["Neon|Fly|Ride"] = 180.72, ["Mega|Fly|Ride"] = 828.78}},
    ["rbxassetid://12557346746"] = {name = "Naga Dragon", prices = {["default"] = 51.19, ["Fly"] = 114.26, ["Ride"] = 61.69, ["Fly|Ride"] = 101.98, ["Neon|Fly"] = 1385.45, ["Neon|Ride"] = 381.94, ["Neon|Fly|Ride"] = 431.82, ["Mega"] = 1566.45, ["Mega|Fly|Ride"] = 1245.24}},
    ["rbxassetid://127697654557674"] = {name = "Candicorn", prices = {["default"] = 609, ["Fly"] = 787.5, ["Ride"] = 627.38, ["Fly|Ride"] = 708.75, ["Neon"] = 1706.25, ["Neon|Ride"] = 1863.75, ["Neon|Fly|Ride"] = 1571.71, ["Mega"] = 5262.35, ["Mega|Ride"] = 5539.65, ["Mega|Fly|Ride"] = 5249.99}},
    ["rbxassetid://4281674580"] = {name = "King Bee", prices = {["default"] = 17.07, ["Fly"] = 27.75, ["Ride"] = 22.92, ["Fly|Ride"] = 50.48, ["Neon"] = 118.12, ["Neon|Fly"] = 157.37, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 588.88, ["Mega|Fly|Ride"] = 517.18}},
    ["rbxassetid://17822543288"] = {name = "Blue Betta Fish", prices = {["default"] = 11.69, ["Fly"] = 73.76, ["Ride"] = 28.06, ["Fly|Ride"] = 490.21, ["Neon"] = 77.7, ["Neon|Ride"] = 191.43, ["Neon|Fly|Ride"] = 249.38, ["Mega|Ride"] = 526.57}},
    ["rbxassetid://102300026415493"] = {name = "Moose Calf", prices = {["default"] = 95.76, ["Ride"] = 131.25, ["Fly|Ride"] = 196.88, ["Neon"] = 527.71, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 704.57, ["Mega|Fly|Ride"] = 2093.73}},
    ["rbxassetid://78419574214060"] = {name = "Christmas Spirit", prices = {["default"] = 25.73, ["Ride"] = 139.18, ["Fly|Ride"] = 145.69, ["Neon"] = 94.5, ["Neon|Fly"] = 193.18, ["Neon|Ride"] = 98.44, ["Neon|Fly|Ride"] = 246.18, ["Mega"] = 318.94, ["Mega|Ride"] = 301.88, ["Mega|Fly|Ride"] = 689.61}},
    ["rbxassetid://130642623661179"] = {name = "Cryptid", prices = {["default"] = 3675, ["Fly"] = 5087.88, ["Ride"] = 3583.13, ["Fly|Ride"] = 3673.95, ["Neon|Ride"] = 11598.56, ["Neon|Fly|Ride"] = 8596.88, ["Mega"] = 41490.5, ["Mega|Fly|Ride"] = 34445.62}},
    ["rbxassetid://101130894252942"] = {name = "Peach Owl", prices = {["default"] = 50.68, ["Ride"] = 47.16, ["Fly|Ride"] = 135.95, ["Neon"] = 485.01, ["Neon|Fly"] = 207.73, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 290.84, ["Mega|Ride"] = 970.02, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://4440866649"] = {name = "Owl", prices = {["default"] = 7218.75, ["Fly"] = 7581.45, ["Ride"] = 7581.45, ["Fly|Ride"] = 6260.63, ["Neon|Fly|Ride"] = 15925.16, ["Mega|Fly|Ride"] = 64390.2}},
    ["rbxassetid://6836687169"] = {name = "Golden Griffin", prices = {["default"] = 2.1, ["Fly"] = 18.62, ["Ride"] = 18.47, ["Fly|Ride"] = 30.55, ["Neon"] = 78.75, ["Neon|Fly"] = 62.62, ["Neon|Ride"] = 43.32, ["Neon|Fly|Ride"] = 93.18, ["Mega"] = 454.44, ["Mega|Ride"] = 180.72, ["Mega|Fly|Ride"] = 261.17}},
    ["rbxassetid://76198828333546"] = {name = "Hippogriff", prices = {["default"] = 26.25, ["Fly"] = 23.5, ["Ride"] = 33.25, ["Fly|Ride"] = 52.38, ["Neon"] = 111.14, ["Neon|Ride"] = 165.15, ["Neon|Fly|Ride"] = 153.72, ["Mega|Ride"] = 1365.68, ["Mega|Fly|Ride"] = 939.39}},
    ["rbxassetid://112567270488274"] = {name = "Crystal Egg", prices = {["default"] = 4.17}},
    ["rbxassetid://10695038557"] = {name = "Maneki-Neko", prices = {["default"] = 13.13, ["Ride"] = 44.63, ["Fly|Ride"] = 91.88, ["Neon"] = 194.22, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 606.53, ["Mega"] = 829.82, ["Mega|Ride"] = 967.94, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://16911441596"] = {name = "Royal Capuchin Monkey", prices = {["default"] = 35.18, ["Fly"] = 262.5, ["Ride"] = 35.44, ["Fly|Ride"] = 137.11, ["Neon"] = 182.43, ["Neon|Ride"] = 153.18, ["Neon|Fly|Ride"] = 239.76, ["Mega"] = 840, ["Mega|Fly|Ride"] = 1050}},
    ["rbxassetid://6963387165"] = {name = "Cobra", prices = {["default"] = 17.48, ["Fly"] = 27.01, ["Ride"] = 22.29, ["Fly|Ride"] = 38.35, ["Neon"] = 83.1, ["Neon|Ride"] = 97.62, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 2492.55, ["Mega|Ride"] = 585.95, ["Mega|Fly|Ride"] = 675.2}},
    ["rbxassetid://3409444171"] = {name = "Safari Egg", prices = {["default"] = 8266.89}},
    ["rbxassetid://3743740864"] = {name = "Jungle Egg", prices = {["default"] = 2715.56}},
    ["rbxassetid://10321884333"] = {name = "Japan Egg", prices = {["default"] = 19.09}},
    ["rbxassetid://11109117895"] = {name = "Diamond Amazon", prices = {["default"] = 177.12, ["Fly"] = 174.57, ["Ride"] = 174.57, ["Fly|Ride"] = 183.74, ["Neon|Fly|Ride"] = 1096.76}},
    ["rbxassetid://102144672439627"] = {name = "Berry Cool Cube", prices = {["default"] = 20.24, ["Fly"] = 111.14, ["Ride"] = 47.73, ["Fly|Ride"] = 140.93, ["Neon"] = 113.96, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 274.2, ["Mega|Ride"] = 939.39, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183502626"] = {name = "Garden Egg", prices = {["default"] = 10.19}},
    ["rbxassetid://16722909609"] = {name = "Striped Eggy", prices = {["default"] = 5.44, ["Fly|Ride"] = 56.1, ["Neon"] = 49.87, ["Neon|Ride"] = 69.6, ["Neon|Fly|Ride"] = 124.65, ["Mega|Fly|Ride"] = 465.94}},
    ["rbxassetid://4440866155"] = {name = "Farm Egg", prices = {["default"] = 2572.5}},
    ["rbxassetid://88361277330582"] = {name = "Naughty Mistletroll", prices = {["default"] = 144.38, ["Ride"] = 150.57, ["Fly|Ride"] = 413.36, ["Neon"] = 701.37, ["Neon|Ride"] = 678.11, ["Mega|Ride"] = 3449.04, ["Mega|Fly|Ride"] = 3449.04}},
    ["rbxassetid://12778919221"] = {name = "Yule Log Dog", prices = {["default"] = 135.01, ["Ride"] = 236.25, ["Fly|Ride"] = 469.71, ["Neon"] = 675.68, ["Neon|Ride"] = 692.73, ["Neon|Fly|Ride"] = 1108.14, ["Mega"] = 2216.28, ["Mega|Ride"] = 3323.38, ["Mega|Fly|Ride"] = 2270.94}},
    ["rbxassetid://13104112588"] = {name = "Owlbear", prices = {["default"] = 164.07, ["Fly"] = 261.74, ["Ride"] = 196.88, ["Fly|Ride"] = 262.5, ["Neon"] = 799.32, ["Neon|Ride"] = 840, ["Neon|Fly|Ride"] = 872.68, ["Mega"] = 4569.64, ["Mega|Fly|Ride"] = 3489.55}},
    ["rbxassetid://11192035130"] = {name = "Undead Jousting Horse", prices = {["default"] = 1520.46, ["Fly"] = 2492.55, ["Ride"] = 1435.59, ["Fly|Ride"] = 1470, ["Neon"] = 6263.43, ["Neon|Ride"] = 4567.56, ["Neon|Fly|Ride"] = 4593.75, ["Mega|Fly|Ride"] = 27695.08}},
    ["rbxassetid://106575933009346"] = {name = "Fairytale Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://96044273915258"] = {name = "Endangered Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://129993159377616"] = {name = "Peahen", prices = {["default"] = 13.13, ["Fly"] = 81.02, ["Ride"] = 39.4, ["Fly|Ride"] = 91.41, ["Neon"] = 136.07, ["Neon|Ride"] = 166.19, ["Neon|Fly|Ride"] = 219.19, ["Mega"] = 829.82, ["Mega|Ride"] = 900.44, ["Mega|Fly|Ride"] = 1095.68}},
    ["rbxassetid://12732812236"] = {name = "Tio De Nadal", prices = {["default"] = 649.69, ["Fly"] = 2100, ["Ride"] = 658.46, ["Fly|Ride"] = 970.02, ["Neon|Fly|Ride"] = 4016.1}},
    ["rbxassetid://13936755787"] = {name = "Wrapped Doll", prices = {["default"] = 42}},
    ["rbxassetid://136441478335419"] = {name = "Emberlight", prices = {["default"] = 15.27, ["Ride"] = 43.29, ["Fly|Ride"] = 681.8, ["Neon"] = 85.56, ["Neon|Ride"] = 119.44, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 393.65, ["Mega|Ride"] = 457.95, ["Mega|Fly|Ride"] = 549.94}},
    ["rbxassetid://17120184484"] = {name = "Rosy Maple Moth", prices = {["default"] = 6.96, ["Fly"] = 257.28, ["Ride"] = 27.02, ["Fly|Ride"] = 94.79, ["Neon"] = 41.88, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 918.75, ["Mega|Ride"] = 360.39, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://15932251755"] = {name = "Royal Desert Egg", prices = {["default"] = 87.26}},
    ["rbxassetid://8143039289"] = {name = "Golden Walrus", prices = {["default"] = 20.41, ["Fly"] = 108.92, ["Ride"] = 25.99, ["Fly|Ride"] = 55.13, ["Neon"] = 196.88, ["Neon|Ride"] = 207.73, ["Neon|Fly|Ride"] = 192.94, ["Mega"] = 787.5, ["Mega|Ride"] = 783.22, ["Mega|Fly|Ride"] = 1387.72}},
    ["rbxassetid://12187391973"] = {name = "Firefly", prices = {["default"] = 39.48, ["Fly"] = 76.86, ["Ride"] = 36.75, ["Fly|Ride"] = 60.75, ["Neon"] = 236.25, ["Neon|Ride"] = 413.36, ["Neon|Fly|Ride"] = 249.27, ["Mega"] = 947.62, ["Mega|Ride"] = 1761.34, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://3743647944"] = {name = "Parrot", prices = {["default"] = 6230.28, ["Fly"] = 10954, ["Ride"] = 4987.5, ["Fly|Ride"] = 5248.69, ["Neon|Ride"] = 16616.84, ["Neon|Fly|Ride"] = 10498.69, ["Mega|Fly|Ride"] = 31156.55}},
    ["rbxassetid://128454622445076"] = {name = "Dimension Drifter", prices = {["default"] = 10.37, ["Fly"] = 41.56, ["Ride"] = 31.18, ["Fly|Ride"] = 93.95, ["Neon"] = 64.97, ["Neon|Ride"] = 78.6, ["Mega"] = 526.07, ["Mega|Ride"] = 540.06, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://15931761708"] = {name = "Desert Egg", prices = {["default"] = 22.09}},
    ["rbxassetid://17747001377"] = {name = "Majestic Pony", prices = {["default"] = 90.6, ["Fly"] = 367.66, ["Ride"] = 134.95, ["Fly|Ride"] = 188.99, ["Neon"] = 418.69, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 658.88, ["Mega|Fly|Ride"] = 1850.37}},
    ["rbxassetid://94487786469241"] = {name = "Vanilla Penguin", prices = {["default"] = 76.12, ["Fly"] = 96.48, ["Ride"] = 111.57, ["Fly|Ride"] = 276.78, ["Neon"] = 327.6, ["Neon|Ride"] = 357.28, ["Neon|Fly|Ride"] = 554.6, ["Mega"] = 2348.49, ["Mega|Ride"] = 2804.1, ["Mega|Fly|Ride"] = 1246.28}},
    ["rbxassetid://6498256211"] = {name = "Octopus", prices = {["default"] = 22.65, ["Fly"] = 70.46, ["Ride"] = 28.05, ["Fly|Ride"] = 59.91, ["Neon"] = 196.88, ["Neon|Ride"] = 116.81, ["Neon|Fly|Ride"] = 133.88, ["Mega|Ride"] = 679.23, ["Mega|Fly|Ride"] = 656.22}},
    ["rbxassetid://110654583245787"] = {name = "Sea Turtle", prices = {["default"] = 7.06, ["Fly"] = 45.72, ["Ride"] = 30.18, ["Fly|Ride"] = 82.69, ["Neon"] = 30.93, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 157.36, ["Mega"] = 144.37, ["Mega|Fly"] = 6924.04, ["Mega|Ride"] = 202.13, ["Mega|Fly|Ride"] = 274.32}},
    ["rbxassetid://8596147681"] = {name = "Squid", prices = {["default"] = 13.34, ["Ride"] = 31.35, ["Fly|Ride"] = 83.1, ["Neon"] = 94.53, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 185.54, ["Mega"] = 471.52, ["Mega|Ride"] = 393.75, ["Mega|Fly|Ride"] = 498.52}},
    ["rbxassetid://9226723356"] = {name = "Winged Horse", prices = {["default"] = 19.56, ["Fly"] = 24.81, ["Ride"] = 23.88, ["Fly|Ride"] = 60.37, ["Neon"] = 205.65, ["Neon|Ride"] = 261.21, ["Neon|Fly|Ride"] = 136.07, ["Mega|Fly|Ride"] = 762.32}},
    ["rbxassetid://4733386633"] = {name = "Aussie Egg", prices = {["default"] = 207.38}},
    ["rbxassetid://121951206021245"] = {name = "Kiwi Kiwi", prices = {["default"] = 22.32, ["Ride"] = 96.86, ["Neon"] = 169.32, ["Neon|Ride"] = 166.19, ["Mega"] = 523.69, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 941.98}},
    ["rbxassetid://9602676771"] = {name = "Diamond Albatross", prices = {["default"] = 191.1, ["Fly"] = 219.59, ["Ride"] = 222.26, ["Fly|Ride"] = 262.5, ["Neon"] = 554.6, ["Neon|Ride"] = 820.32, ["Neon|Fly|Ride"] = 692.73}},
    ["rbxassetid://79965389436178"] = {name = "Sushi Penguin", prices = {["default"] = 32.8, ["Fly"] = 212.01, ["Ride"] = 98.67, ["Fly|Ride"] = 244.27, ["Neon"] = 328.13, ["Neon|Ride"] = 385.88, ["Neon|Fly|Ride"] = 420, ["Mega"] = 1179.94, ["Mega|Ride"] = 1287.82, ["Mega|Fly|Ride"] = 1220.63}},
    ["rbxassetid://126930507653265"] = {name = "Grim Dragon", prices = {["default"] = 888.57, ["Fly"] = 903.5, ["Ride"] = 866.25, ["Fly|Ride"] = 829.5, ["Neon|Fly"] = 2700.93, ["Neon|Ride"] = 2591.73, ["Neon|Fly|Ride"] = 2275.56, ["Mega|Fly|Ride"] = 10368.75}},
    ["rbxassetid://87328715505907"] = {name = "Silverback Gorilla", prices = {["default"] = 259.88, ["Fly"] = 469.74, ["Ride"] = 229.23, ["Fly|Ride"] = 233.89, ["Neon"] = 1181.25, ["Neon|Ride"] = 2036.28, ["Neon|Fly|Ride"] = 1575, ["Mega"] = 8204.58, ["Mega|Fly|Ride"] = 4154.22}},
    ["rbxassetid://12733311267"] = {name = "Fool Egg", prices = {["default"] = 68.56}},
    ["rbxassetid://139472202653768"] = {name = "Admin Abuse Egg", prices = {["default"] = 3.94}},
    ["rbxassetid://8938702589"] = {name = "Hawk", prices = {["default"] = 15.11, ["Fly"] = 27.57, ["Ride"] = 27.57, ["Fly|Ride"] = 52.5, ["Neon"] = 65.63, ["Neon|Fly"] = 230.99, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 154.88, ["Mega"] = 437.26, ["Mega|Ride"] = 691.69, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://8938703243"] = {name = "Fallow Deer", prices = {["default"] = 275.63, ["Fly"] = 762.36, ["Ride"] = 316.3, ["Fly|Ride"] = 414.59, ["Neon"] = 1086.75, ["Neon|Ride"] = 866.25, ["Neon|Fly|Ride"] = 1038.68, ["Mega|Fly|Ride"] = 3809.42}},
    ["rbxassetid://4822753124"] = {name = "Diamond Egg", prices = {["default"] = 22.33}},
    ["rbxassetid://114823420678686"] = {name = "Dragonfruit Fox", prices = {["default"] = 156.19, ["Fly"] = 267.96, ["Ride"] = 202.92, ["Fly|Ride"] = 257.25, ["Neon"] = 653.62, ["Neon|Fly"] = 1661.7, ["Neon|Ride"] = 656.25, ["Neon|Fly|Ride"] = 761.25, ["Mega"] = 2136.23, ["Mega|Ride"] = 2646.25, ["Mega|Fly|Ride"] = 2361.69}},
    ["rbxassetid://102844319137806"] = {name = "Pineapple Owl", prices = {["default"] = 118.13, ["Fly"] = 194.22, ["Ride"] = 131.25, ["Fly|Ride"] = 157.5, ["Neon"] = 830.86, ["Neon|Ride"] = 1005.38, ["Neon|Fly|Ride"] = 934.71}},
    ["rbxassetid://82296650763619"] = {name = "Angus Bull", prices = {["default"] = 4.35, ["Ride"] = 31.18, ["Fly|Ride"] = 207.73, ["Neon"] = 39.35, ["Neon|Ride"] = 85.31, ["Neon|Fly|Ride"] = 224.34, ["Mega"] = 236.25, ["Mega|Ride"] = 346.89, ["Mega|Fly|Ride"] = 654.94}},
    ["rbxassetid://12917347755"] = {name = "Sunrise Duckling", prices = {["default"] = 14.44, ["Fly"] = 63, ["Ride"] = 29.29, ["Fly|Ride"] = 76.13, ["Neon"] = 110.4, ["Neon|Ride"] = 173.82, ["Neon|Fly|Ride"] = 234.44, ["Mega|Ride"] = 549.94, ["Mega|Fly|Ride"] = 577.31}},
    ["rbxassetid://139217275750567"] = {name = "Winter Buck", prices = {["default"] = 18.38, ["Fly"] = 102.31, ["Ride"] = 44.63, ["Fly|Ride"] = 128.82, ["Neon"] = 85.32, ["Neon|Ride"] = 140.94, ["Neon|Fly|Ride"] = 235.76, ["Mega"] = 498.65, ["Mega|Ride"] = 455.34, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://114331718573822"] = {name = "Mochi Meow", prices = {["default"] = 4.17, ["Fly"] = 124.65, ["Ride"] = 60.25, ["Fly|Ride"] = 154.29, ["Neon"] = 28.18, ["Neon|Fly"] = 234.88, ["Neon|Ride"] = 53.82, ["Neon|Fly|Ride"] = 155.26, ["Mega"] = 149.43, ["Mega|Ride"] = 182.44, ["Mega|Fly|Ride"] = 294}},
    ["rbxassetid://112560568221286"] = {name = "Strawberry Penguin", prices = {["default"] = 268.44, ["Fly"] = 283.5, ["Ride"] = 289.14, ["Fly|Ride"] = 304.5, ["Neon"] = 1219.28, ["Neon|Ride"] = 1214.07, ["Neon|Fly|Ride"] = 1390.33}},
    ["rbxassetid://116818749091454"] = {name = "Dango Penguins", prices = {["default"] = 130.89, ["Fly"] = 1050, ["Ride"] = 181.13, ["Fly|Ride"] = 309.75, ["Neon"] = 505.32, ["Neon|Ride"] = 681.19, ["Neon|Fly|Ride"] = 786.19, ["Mega"] = 9346.98, ["Mega|Ride"] = 2436.52, ["Mega|Fly|Ride"] = 2072.96}},
    ["rbxassetid://12480100169"] = {name = "Tree Kangaroo", prices = {["default"] = 72.16, ["Fly"] = 167.45, ["Ride"] = 94.06, ["Fly|Ride"] = 105.94, ["Neon"] = 415.44, ["Neon|Ride"] = 410.25, ["Neon|Fly|Ride"] = 494.36, ["Mega|Fly|Ride"] = 1509.67}},
    ["rbxassetid://75106733244906"] = {name = "Golden Hummingbird", prices = {["default"] = 18.72, ["Ride"] = 57.75, ["Fly|Ride"] = 117.44, ["Neon|Ride"] = 596.56, ["Neon|Fly|Ride"] = 481.9, ["Mega|Ride"] = 615.57, ["Mega|Fly|Ride"] = 1653.39}},
    ["rbxassetid://76354526914534"] = {name = "Frostclaw", prices = {["default"] = 15.63, ["Fly"] = 75.63, ["Ride"] = 41.56, ["Fly|Ride"] = 65.63, ["Neon"] = 76.4, ["Neon|Ride"] = 83.1, ["Neon|Fly|Ride"] = 125.66, ["Mega"] = 358.32, ["Mega|Fly"] = 525, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 448.88}},
    ["rbxassetid://121712578077668"] = {name = "Blue Whale", prices = {["default"] = 3.42, ["Fly"] = 45.71, ["Ride"] = 22.85, ["Fly|Ride"] = 88.09, ["Neon"] = 21.63, ["Neon|Fly"] = 91.88, ["Neon|Ride"] = 37.97, ["Neon|Fly|Ride"] = 108.07, ["Mega"] = 129.94, ["Mega|Ride"] = 173.25, ["Mega|Fly|Ride"] = 220.5}},
    ["rbxassetid://76035105070441"] = {name = "Fairy Bat Dragon", prices = {["default"] = 984.38, ["Fly"] = 1082.72, ["Ride"] = 975.56, ["Fly|Ride"] = 924, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 2492.44, ["Mega|Fly|Ride"] = 10802.8}},
    ["rbxassetid://105346917979221"] = {name = "Aurora Fox", prices = {["default"] = 364.24, ["Ride"] = 374.07, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1680, ["Neon|Fly|Ride"] = 2769.83, ["Mega"] = 10385.52, ["Mega|Fly|Ride"] = 7325.96}},
    ["rbxassetid://120475294381736"] = {name = "Glormy Hound", prices = {["default"] = 70.51, ["Fly"] = 131.25, ["Ride"] = 103.83, ["Fly|Ride"] = 180.45, ["Neon"] = 306.38, ["Neon|Ride"] = 305.82, ["Neon|Fly|Ride"] = 401.93, ["Mega"] = 1596.98, ["Mega|Ride"] = 1501.77, ["Mega|Fly|Ride"] = 1495.53}},
    ["rbxassetid://15570696642"] = {name = "Glacier Kitsune", prices = {["default"] = 298.29, ["Fly"] = 249.37, ["Ride"] = 275.63, ["Fly|Ride"] = 282.19, ["Neon"] = 1331.6, ["Neon|Ride"] = 1409.2, ["Neon|Fly|Ride"] = 1281.59, ["Mega"] = 10385.52, ["Mega|Fly|Ride"] = 5927.45}},
    ["rbxassetid://16548792521"] = {name = "Golden Hamster", prices = {["default"] = 20.99, ["Fly"] = 139.18, ["Ride"] = 29.29, ["Fly|Ride"] = 63.72, ["Neon"] = 139.18, ["Neon|Ride"] = 118.4, ["Neon|Fly|Ride"] = 229.68, ["Mega|Ride"] = 627.05, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://12935498875"] = {name = "Field Mouse", prices = {["default"] = 207.77, ["Ride"] = 276.27, ["Fly|Ride"] = 554.6, ["Neon"] = 1419.05, ["Neon|Ride"] = 942.38, ["Neon|Fly|Ride"] = 2387.65, ["Mega"] = 4133.74, ["Mega|Ride"] = 4293.38, ["Mega|Fly|Ride"] = 4140.72}},
    ["rbxassetid://16548793509"] = {name = "Diamond Hamster", prices = {["default"] = 56.6, ["Fly"] = 125.99, ["Ride"] = 78.74, ["Fly|Ride"] = 100.84, ["Neon"] = 346.89, ["Neon|Ride"] = 496.44, ["Neon|Fly|Ride"] = 450.75, ["Mega|Fly|Ride"] = 1136.63}},
    ["rbxassetid://78823655016197"] = {name = "Jekyll Hydra", prices = {["default"] = 1512.15, ["Ride"] = 1703.24, ["Fly|Ride"] = 1509.38, ["Neon|Fly|Ride"] = 4154.22, ["Mega"] = 49850.49, ["Mega|Fly|Ride"] = 21879.17}},
    ["rbxassetid://96735424372947"] = {name = "Glormy Dolphin", prices = {["default"] = 14.42, ["Fly"] = 61.68, ["Ride"] = 42, ["Fly|Ride"] = 90.86, ["Neon"] = 63.63, ["Neon|Fly"] = 172.06, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 181.76, ["Mega"] = 306.18, ["Mega|Fly"] = 374.07, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 436.56}},
    ["rbxassetid://16898331554"] = {name = "Princess Capuchin Monkey", prices = {["default"] = 41.04, ["Fly"] = 119.1, ["Ride"] = 76.86, ["Fly|Ride"] = 161.43, ["Neon"] = 277.31, ["Neon|Ride"] = 282.39, ["Neon|Fly|Ride"] = 262.5, ["Mega|Ride"] = 1016.76, ["Mega|Fly|Ride"] = 1037.53}},
    ["rbxassetid://4315743450"] = {name = "Queen Bee", prices = {["default"] = 75.6, ["Fly"] = 70.43, ["Ride"] = 76.86, ["Fly|Ride"] = 102.38, ["Neon|Ride"] = 410.82, ["Neon|Fly|Ride"] = 367.5, ["Mega|Fly|Ride"] = 1466.47}},
    ["rbxassetid://5067924789"] = {name = "Monkey King", prices = {["default"] = 3460.46, ["Ride"] = 1409.12, ["Fly|Ride"] = 1155, ["Neon|Fly|Ride"] = 4199.99, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://10284283561"] = {name = "Black-Chested Pheasant", prices = {["default"] = 366.45, ["Fly"] = 828.78, ["Ride"] = 518.25, ["Fly|Ride"] = 530.78, ["Neon|Fly|Ride"] = 2740.68, ["Mega|Fly|Ride"] = 14090.6}},
    ["rbxassetid://15504845135"] = {name = "Candy Hare", prices = {["default"] = 98.44, ["Fly"] = 313.57, ["Ride"] = 135.19, ["Fly|Ride"] = 206.07, ["Neon"] = 443.63, ["Neon|Fly"] = 554.6, ["Neon|Ride"] = 472.5, ["Neon|Fly|Ride"] = 584.26, ["Mega"] = 4154.22, ["Mega|Ride"] = 2631.7, ["Mega|Fly|Ride"] = 2394.98}},
    ["rbxassetid://11758575657"] = {name = "Lunar Moon Bear", prices = {["default"] = 8.1, ["Ride"] = 27.57, ["Fly|Ride"] = 91.68, ["Neon"] = 87.93, ["Neon|Ride"] = 68.92, ["Neon|Fly|Ride"] = 128.63, ["Mega|Ride"] = 747.53, ["Mega|Fly|Ride"] = 721.81}},
    ["rbxassetid://10318105392"] = {name = "Green Butterfly", prices = {["default"] = 39.6, ["Fly"] = 93.97, ["Ride"] = 48.3, ["Fly|Ride"] = 108.05, ["Neon"] = 204.75, ["Neon|Fly"] = 414.4, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 288.75, ["Mega|Ride"] = 1065.02, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://84813815094145"] = {name = "Mermicorn", prices = {["default"] = 815.41, ["Ride"] = 820.32, ["Fly|Ride"] = 891.55, ["Neon"] = 2348.5, ["Neon|Ride"] = 2231.25, ["Neon|Fly|Ride"] = 2508.42, ["Mega|Fly|Ride"] = 31312.81}},
    ["rbxassetid://4507163112"] = {name = "Christmas Egg", prices = {["default"] = 774.38}},
    ["rbxassetid://14689005829"] = {name = "Blazing Lion", prices = {["default"] = 4921.88, ["Ride"] = 5190.69, ["Fly|Ride"] = 4408.69, ["Neon"] = 42000, ["Neon|Ride"] = 29765.94, ["Neon|Fly|Ride"] = 21741.04, ["Mega|Fly|Ride"] = 88623.76}},
    ["rbxassetid://123647431892215"] = {name = "Hero Gibbon", prices = {["default"] = 223.13, ["Fly"] = 402.74, ["Ride"] = 277.31, ["Neon"] = 1246.88, ["Neon|Fly|Ride"] = 1385.45, ["Mega"] = 5815.91, ["Mega|Fly|Ride"] = 5955.07}},
    ["rbxassetid://106457467498193"] = {name = "Scorching Kaijunior", prices = {["default"] = 72.19, ["Fly"] = 277.31, ["Ride"] = 78.75, ["Fly|Ride"] = 336, ["Neon"] = 277.31, ["Neon|Ride"] = 488, ["Neon|Fly|Ride"] = 970.02, ["Mega|Fly|Ride"] = 2099.99}},
    ["rbxassetid://10926054030"] = {name = "Chimera", prices = {["default"] = 15.73, ["Fly"] = 72.19, ["Ride"] = 34.13, ["Fly|Ride"] = 103.87, ["Neon"] = 111.14, ["Neon|Ride"] = 85.17, ["Neon|Fly|Ride"] = 183.75, ["Mega|Ride"] = 623.15, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://9490242683"] = {name = "Golden King Penguin", prices = {["default"] = 27.57, ["Fly"] = 38.07, ["Ride"] = 23.63, ["Fly|Ride"] = 51.19, ["Neon|Fly"] = 277.31, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 177.18, ["Mega"] = 1312.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://17119623510"] = {name = "Mushroom Friend", prices = {["default"] = 18.24, ["Fly"] = 277.31, ["Ride"] = 41.55, ["Fly|Ride"] = 72.19, ["Neon"] = 125.66, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 209.82, ["Mega|Ride"] = 623.15, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://17174656536"] = {name = "Golden Tortoise Beetle", prices = {["default"] = 3.95, ["Fly"] = 56.1, ["Ride"] = 19.69, ["Fly|Ride"] = 56.1, ["Neon"] = 35.44, ["Neon|Fly"] = 342.74, ["Neon|Ride"] = 45.94, ["Neon|Fly|Ride"] = 187.86, ["Mega"] = 178.5, ["Mega|Ride"] = 193.18, ["Mega|Fly|Ride"] = 306.38}},
    ["rbxassetid://84310117840681"] = {name = "Super Saru", prices = {["default"] = 23.68, ["Ride"] = 39.95, ["Fly|Ride"] = 183.75, ["Neon"] = 164.11, ["Neon|Fly"] = 830.86, ["Neon|Ride"] = 155.43, ["Neon|Fly|Ride"] = 307.4, ["Mega"] = 726.99, ["Mega|Ride"] = 1237.69, ["Mega|Fly|Ride"] = 687.94}},
    ["rbxassetid://77177643028234"] = {name = "Phantom Dragon", prices = {["default"] = 309.49, ["Fly"] = 415.44, ["Ride"] = 315, ["Fly|Ride"] = 382.49, ["Neon"] = 1409.12, ["Neon|Ride"] = 1033.37, ["Neon|Fly|Ride"] = 958.12, ["Mega"] = 7875, ["Mega|Fly"] = 3945.46, ["Mega|Ride"] = 3738.8, ["Mega|Fly|Ride"] = 3281.25}},
    ["rbxassetid://6245080265"] = {name = "Metal Ox", prices = {["default"] = 2.62, ["Fly"] = 22.86, ["Ride"] = 14.44, ["Fly|Ride"] = 41.56, ["Neon"] = 25.34, ["Neon|Ride"] = 36.01, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 277.31, ["Mega|Ride"] = 219.59, ["Mega|Fly|Ride"] = 261.19}},
    ["rbxassetid://3181728194"] = {name = "Unicorn", prices = {["default"] = 41.88, ["Fly"] = 86.21, ["Ride"] = 82.66, ["Fly|Ride"] = 131.25, ["Neon"] = 170.63, ["Neon|Fly"] = 276.94, ["Neon|Ride"] = 192.23, ["Neon|Fly|Ride"] = 231.94, ["Mega"] = 523.59, ["Mega|Fly"] = 830.86, ["Mega|Ride"] = 548.63, ["Mega|Fly|Ride"] = 556.5}},
    ["rbxassetid://4708551322"] = {name = "Turtle", prices = {["default"] = 756.46, ["Fly"] = 962.96, ["Ride"] = 738.63, ["Fly|Ride"] = 796.69, ["Neon|Ride"] = 1940.03, ["Neon|Fly|Ride"] = 1640.63, ["Mega|Fly|Ride"] = 3609.92}},
    ["rbxassetid://5721844281"] = {name = "T-Rex", prices = {["default"] = 41.84, ["Fly"] = 91.88, ["Ride"] = 45.5, ["Fly|Ride"] = 94.23, ["Neon"] = 178.76, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 288.74, ["Mega"] = 1575, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 748.13}},
    ["rbxassetid://16127039676"] = {name = "Midnight Dragon", prices = {["default"] = 393.75, ["Fly"] = 328.13, ["Ride"] = 262.5, ["Fly|Ride"] = 341.25, ["Neon|Ride"] = 1370.91, ["Neon|Fly|Ride"] = 1021.13, ["Mega|Fly|Ride"] = 7201.34}},
    ["rbxassetid://7734925172"] = {name = "Halloween White Ghost Dragon", prices = {["default"] = 121.96, ["Fly"] = 139.02, ["Ride"] = 133.88, ["Fly|Ride"] = 177.49, ["Neon|Ride"] = 679.23, ["Neon|Fly|Ride"] = 564.38, ["Mega|Fly|Ride"] = 2756.24}},
    ["rbxassetid://18508016126"] = {name = "Bush Elephant", prices = {["default"] = 551.25, ["Ride"] = 603.74, ["Fly|Ride"] = 720.65, ["Neon|Ride"] = 2572.5, ["Neon|Fly|Ride"] = 2270.99, ["Mega|Fly|Ride"] = 7612.5}},
    ["rbxassetid://78218981883168"] = {name = "Coconut Friend", prices = {["default"] = 22.95, ["Ride"] = 43.32, ["Fly|Ride"] = 92.55, ["Neon"] = 77.44, ["Neon|Fly"] = 281.86, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 311.58, ["Mega|Ride"] = 342.17, ["Mega|Fly|Ride"] = 392.2}},
    ["rbxassetid://4184878050"] = {name = "Evil Unicorn", prices = {["default"] = 4016.1, ["Ride"] = 3934.88, ["Fly|Ride"] = 3281.25, ["Neon|Fly|Ride"] = 6562.5, ["Mega|Fly|Ride"] = 25058.25}},
    ["rbxassetid://103896000727935"] = {name = "Aestus", prices = {["default"] = 99.71, ["Fly"] = 140.93, ["Ride"] = 110.4, ["Fly|Ride"] = 161.44, ["Neon"] = 380.63, ["Neon|Ride"] = 485.01, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 1968.75}},
    ["rbxassetid://9922229151"] = {name = "Dragonfly", prices = {["default"] = 2.1, ["Fly"] = 26.86, ["Ride"] = 17.07, ["Fly|Ride"] = 41.41, ["Neon"] = 23.24, ["Neon|Fly"] = 83.1, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 90.37, ["Mega"] = 152.18, ["Mega|Fly"] = 452.82, ["Mega|Ride"] = 270.14, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://82820245821381"] = {name = "Temple Friend", prices = {["default"] = 3.51, ["Ride"] = 27.98, ["Fly|Ride"] = 82.69, ["Neon"] = 18, ["Neon|Ride"] = 46.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 161.44, ["Mega|Ride"] = 199.48, ["Mega|Fly|Ride"] = 238.56}},
    ["rbxassetid://6404812861"] = {name = "Diamond Ladybug", prices = {["default"] = 86.63, ["Fly"] = 140.07, ["Ride"] = 37.41, ["Fly|Ride"] = 64.31, ["Neon"] = 274.79, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 276.27, ["Mega|Fly|Ride"] = 984.38}},
    ["rbxassetid://107535752953647"] = {name = "Strawberry Tortle", prices = {["default"] = 997.5, ["Ride"] = 1050, ["Fly|Ride"] = 1234.93, ["Neon"] = 6093.2, ["Neon|Fly|Ride"] = 6217.82}},
    ["rbxassetid://95844539868957"] = {name = "Amethyst Penguin", prices = {["default"] = 6037.5, ["Ride"] = 7045.48, ["Fly|Ride"] = 6299.99, ["Neon|Fly|Ride"] = 23625}},
    ["rbxassetid://6240249282"] = {name = "Guardian Lion", prices = {["default"] = 21.8, ["Fly"] = 26.25, ["Ride"] = 28.06, ["Fly|Ride"] = 58.17, ["Neon"] = 207.73, ["Neon|Ride"] = 144.8, ["Neon|Fly|Ride"] = 157.36, ["Mega"] = 2428.13, ["Mega|Fly|Ride"] = 656.24}},
    ["rbxassetid://11496077150"] = {name = "Ice Moth Dragon", prices = {["default"] = 14.15, ["Fly"] = 48.83, ["Ride"] = 34.61, ["Fly|Ride"] = 77.49, ["Neon"] = 94.4, ["Neon|Ride"] = 89.45, ["Neon|Fly|Ride"] = 180.47, ["Mega"] = 642.48, ["Mega|Ride"] = 526.57, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://5862774166"] = {name = "Skele-Rex", prices = {["default"] = 59.17, ["Fly"] = 157.49, ["Ride"] = 64.32, ["Fly|Ride"] = 109.07, ["Neon"] = 328.13, ["Neon|Ride"] = 375.8, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1108.14, ["Mega|Ride"] = 1805.02, ["Mega|Fly|Ride"] = 918.75}},
    ["rbxassetid://11773429123"] = {name = "Nessie", prices = {["default"] = 209.99, ["Fly"] = 313.57, ["Ride"] = 238.88, ["Fly|Ride"] = 297.21, ["Neon|Ride"] = 976.5, ["Neon|Fly|Ride"] = 880.89, ["Mega"] = 10385.52, ["Mega|Fly|Ride"] = 3974.56}},
    ["rbxassetid://121782270350526"] = {name = "Dark Choccybunny", prices = {["default"] = 3.74, ["Ride"] = 36.37, ["Fly|Ride"] = 86.63, ["Neon"] = 32.22, ["Neon|Fly"] = 656.24, ["Neon|Ride"] = 92.42, ["Neon|Fly|Ride"] = 244.27, ["Mega"] = 158.81, ["Mega|Ride"] = 163.7, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://129591977577854"] = {name = "Ballet Swan", prices = {["default"] = 187.06, ["Fly"] = 270.04, ["Ride"] = 226.01, ["Fly|Ride"] = 298.08, ["Neon"] = 929.52, ["Neon|Ride"] = 858.89, ["Neon|Fly|Ride"] = 1108.14, ["Mega|Fly|Ride"] = 3737.76}},
    ["rbxassetid://9669227320"] = {name = "Zodiac Minion Chick", prices = {["default"] = 2.1, ["Fly"] = 20.65, ["Ride"] = 15.73, ["Fly|Ride"] = 35.33, ["Neon"] = 18.5, ["Neon|Fly"] = 123.03, ["Neon|Ride"] = 59.07, ["Neon|Fly|Ride"] = 98.43, ["Mega"] = 196.88, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 239.48}},
    ["rbxassetid://13462536955"] = {name = "Caelum Cervi", prices = {["default"] = 225.75, ["Fly"] = 267.96, ["Ride"] = 278.25, ["Fly|Ride"] = 261.74, ["Neon|Ride"] = 783.28, ["Neon|Fly|Ride"] = 939.41, ["Mega"] = 10385.52, ["Mega|Fly|Ride"] = 4140.72}},
    ["rbxassetid://10137833794"] = {name = "Green-Chested Pheasant", prices = {["default"] = 14.9, ["Fly"] = 83.61, ["Ride"] = 28.91, ["Fly|Ride"] = 61.63, ["Neon"] = 81.38, ["Neon|Fly"] = 298.29, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 520.2, ["Mega|Ride"] = 581.6, ["Mega|Fly|Ride"] = 449.5}},
    ["rbxassetid://16994954002"] = {name = "Brachiosaurus", prices = {["default"] = 3.59, ["Ride"] = 82.06, ["Fly|Ride"] = 86.63, ["Neon"] = 18.38, ["Neon|Fly"] = 170.45, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 173.23, ["Mega"] = 103.87, ["Mega|Ride"] = 91.87, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://121938982134212"] = {name = "Gecko Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 28.06, ["Mega"] = 23.63, ["Mega|Ride"] = 138.41}},
    ["rbxassetid://17649624018"] = {name = "Kid Goat", prices = {["default"] = 2.1, ["Fly"] = 52.48, ["Ride"] = 311.58, ["Fly|Ride"] = 187.89, ["Neon"] = 9.19, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 111.56, ["Mega"] = 66.94, ["Mega|Fly"] = 156565.73, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 159.86}},
    ["rbxassetid://4440867127"] = {name = "Chicken", prices = {["default"] = 67.4, ["Fly"] = 136.83, ["Ride"] = 118.13, ["Fly|Ride"] = 162.65, ["Neon"] = 317.81, ["Neon|Fly"] = 405.05, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 393.75, ["Mega|Fly|Ride"] = 983.39}},
    ["rbxassetid://5721844165"] = {name = "Tasmanian Tiger", prices = {["default"] = 2.1, ["Fly"] = 33.72, ["Ride"] = 17.07, ["Fly|Ride"] = 84.26, ["Neon"] = 9.08, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 129.94, ["Mega|Ride"] = 121.96, ["Mega|Fly|Ride"] = 257.25}},
    ["rbxassetid://14146063876"] = {name = "Cockroach", prices = {["default"] = 11.8, ["Ride"] = 116.26, ["Neon"] = 65.63, ["Neon|Ride"] = 111.57, ["Mega"] = 551.49, ["Mega|Ride"] = 579.74}},
    ["rbxassetid://135555287601448"] = {name = "Rubber Ducky", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 42.4, ["Neon|Fly|Ride"] = 272.71, ["Mega"] = 27.57, ["Mega|Ride"] = 45.94, ["Mega|Fly|Ride"] = 137.18}},
    ["rbxassetid://9664487060"] = {name = "Ant", prices = {["default"] = 2.1, ["Fly"] = 20.67, ["Ride"] = 14.83, ["Fly|Ride"] = 33.44, ["Neon"] = 2.1, ["Neon|Fly"] = 14.44, ["Neon|Ride"] = 12.93, ["Neon|Fly|Ride"] = 39.48, ["Mega"] = 18.04, ["Mega|Fly"] = 30.19, ["Mega|Ride"] = 21.15, ["Mega|Fly|Ride"] = 65.63}},
    ["rbxassetid://3293758505"] = {name = "Otter", prices = {["default"] = 2.1, ["Ride"] = 14.9, ["Fly|Ride"] = 30.14, ["Neon"] = 3.38, ["Neon|Fly"] = 19.56, ["Neon|Ride"] = 15.6, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 26.16, ["Mega|Fly"] = 155.32, ["Mega|Ride"] = 54.13, ["Mega|Fly|Ride"] = 97.12}},
    ["rbxassetid://79698905581979"] = {name = "Ms. Muffet", prices = {["default"] = 2.1, ["Ride"] = 33.63, ["Fly|Ride"] = 124.65, ["Neon"] = 2.1, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 78.64, ["Mega"] = 13.92, ["Mega|Ride"] = 147.96, ["Mega|Fly|Ride"] = 554.6}},
    ["rbxassetid://13620861015"] = {name = "Flying Fish", prices = {["default"] = 2.1, ["Fly"] = 118.12, ["Ride"] = 17.62, ["Fly|Ride"] = 107.62, ["Neon"] = 3.89, ["Neon|Fly"] = 137.85, ["Neon|Ride"] = 20.99, ["Neon|Fly|Ride"] = 45.94, ["Mega"] = 34.08, ["Mega|Fly"] = 85.32, ["Mega|Ride"] = 96.47, ["Mega|Fly|Ride"] = 120.75}},
    ["rbxassetid://100439668574210"] = {name = "Jiggly Jerboa", prices = {["default"] = 2.1, ["Neon"] = 4.17, ["Neon|Fly|Ride"] = 203.19, ["Mega"] = 23, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 410.83}},
    ["rbxassetid://14815828879"] = {name = "Ghost", prices = {["default"] = 2.1, ["Fly"] = 58.17, ["Ride"] = 16.72, ["Fly|Ride"] = 52.5, ["Neon"] = 12.08, ["Neon|Fly"] = 57.75, ["Neon|Ride"] = 22.71, ["Neon|Fly|Ride"] = 62.25, ["Mega"] = 65.54, ["Mega|Fly"] = 172.17, ["Mega|Ride"] = 87.19, ["Mega|Fly|Ride"] = 137.81}},
    ["rbxassetid://140565380261180"] = {name = "Galapagos Sea Lion", prices = {["default"] = 2.1, ["Ride"] = 47.79, ["Neon"] = 2.1, ["Neon|Ride"] = 64.96, ["Neon|Fly|Ride"] = 105, ["Mega"] = 15.75, ["Mega|Fly"] = 98.44, ["Mega|Ride"] = 35.72, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://14146188240"] = {name = "Bluebottle Fly", prices = {["default"] = 2.62, ["Fly|Ride"] = 524.99, ["Neon"] = 14.2, ["Neon|Ride"] = 37.41, ["Mega"] = 277.31, ["Mega|Fly"] = 315, ["Mega|Ride"] = 344.97}},
    ["rbxassetid://15930540035"] = {name = "Sandfish", prices = {["default"] = 3.66, ["Ride"] = 41.49, ["Neon"] = 9.83, ["Neon|Ride"] = 31.18, ["Mega"] = 83.1, ["Mega|Fly|Ride"] = 537.62}},
    ["rbxassetid://74774507671765"] = {name = "Island Tarsier", prices = {["default"] = 2.1, ["Ride"] = 32.82, ["Neon"] = 3.56, ["Neon|Ride"] = 26.71, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 39.38, ["Mega|Ride"] = 174.98, ["Mega|Fly|Ride"] = 131.14}},
    ["rbxassetid://9678196095"] = {name = "Mouse", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 17.62, ["Fly|Ride"] = 30.09, ["Neon"] = 2.1, ["Neon|Fly"] = 35.44, ["Neon|Ride"] = 11.99, ["Neon|Fly|Ride"] = 25.88, ["Mega"] = 20.79, ["Mega|Ride"] = 17.07, ["Mega|Fly|Ride"] = 66.94}},
    ["rbxassetid://100695038890951"] = {name = "Basic Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13104111122"] = {name = "Piranha", prices = {["default"] = 3.03, ["Fly"] = 72.19, ["Ride"] = 229.68, ["Fly|Ride"] = 84, ["Neon"] = 27.15, ["Neon|Ride"] = 140.95, ["Mega"] = 277.31}},
    ["rbxassetid://110856597065248"] = {name = "Bakeneko", prices = {["default"] = 2.1, ["Ride"] = 18.32, ["Neon"] = 4.17, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 133.88, ["Mega"] = 23.63, ["Mega|Fly"] = 78.75, ["Mega|Ride"] = 60.55, ["Mega|Fly|Ride"] = 160.13}},
    ["rbxassetid://128979941112615"] = {name = "Dirty Ducky", prices = {["default"] = 3.94, ["Neon"] = 18.41, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 95.69, ["Mega|Ride"] = 110.07, ["Mega|Fly|Ride"] = 216.57}},
    ["rbxassetid://12479656052"] = {name = "Maleo Bird", prices = {["default"] = 2.1, ["Fly"] = 656.24, ["Ride"] = 32.81, ["Fly|Ride"] = 189.04, ["Neon"] = 15.49, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 223.02, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 117.36}},
    ["rbxassetid://3200646599"] = {name = "Cat", prices = {["default"] = 2.1, ["Fly"] = 39.36, ["Ride"] = 13.36, ["Fly|Ride"] = 26.15, ["Neon"] = 2.1, ["Neon|Fly"] = 20.56, ["Neon|Ride"] = 12.93, ["Neon|Fly|Ride"] = 27.49, ["Mega"] = 14.15, ["Mega|Fly"] = 18.38, ["Mega|Ride"] = 31.71, ["Mega|Fly|Ride"] = 52.47}},
    ["rbxassetid://12479810452"] = {name = "Bali Starling", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.66, ["Fly|Ride"] = 86.63, ["Neon"] = 22.5, ["Neon|Ride"] = 112.74, ["Neon|Fly|Ride"] = 84, ["Mega"] = 78.75, ["Mega|Ride"] = 152.6, ["Mega|Fly|Ride"] = 249.27}},
    ["rbxassetid://9982819219"] = {name = "Dugong", prices = {["default"] = 2.34, ["Fly"] = 41.56, ["Ride"] = 23, ["Fly|Ride"] = 58.46, ["Neon"] = 71.47, ["Neon|Ride"] = 120.48, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 211.14, ["Mega|Ride"] = 277.31, ["Mega|Fly|Ride"] = 380.63}},
    ["rbxassetid://3181727229"] = {name = "Buffalo", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 15.27, ["Fly|Ride"] = 45.71, ["Neon"] = 3.19, ["Neon|Fly"] = 20.24, ["Neon|Ride"] = 12.98, ["Neon|Fly|Ride"] = 56.09, ["Mega"] = 15.75, ["Mega|Fly"] = 156.19, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 98.43}},
    ["rbxassetid://99694153348188"] = {name = "Urchin", prices = {["default"] = 2.1, ["Fly"] = 173.45, ["Ride"] = 48.74, ["Neon"] = 9.19, ["Neon|Fly"] = 76.86, ["Neon|Ride"] = 40.68, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 45.94, ["Mega|Fly"] = 164.39, ["Mega|Ride"] = 84}},
    ["rbxassetid://84089584046947"] = {name = "Blue Butterfly", prices = {["default"] = 2.1, ["Ride"] = 26.72, ["Fly|Ride"] = 83.1, ["Neon"] = 4.82, ["Neon|Fly"] = 116.94, ["Neon|Ride"] = 35.33, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 32.82, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 157.5}},
    ["rbxassetid://124485808787576"] = {name = "Tegu", prices = {["default"] = 2.1, ["Fly"] = 43.63, ["Ride"] = 16.72, ["Neon"] = 2.39, ["Neon|Fly"] = 41.5, ["Neon|Ride"] = 30.18, ["Neon|Fly|Ride"] = 97.13, ["Mega"] = 16.86, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 108.65}},
    ["rbxassetid://8938703774"] = {name = "Bullfrog", prices = {["default"] = 2.1, ["Fly"] = 97.63, ["Ride"] = 18.36, ["Fly|Ride"] = 42.02, ["Neon"] = 9.42, ["Neon|Fly"] = 47.21, ["Neon|Ride"] = 19.07, ["Neon|Fly|Ride"] = 72.03, ["Mega"] = 78.69, ["Mega|Ride"] = 77.44, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://102746202827395"] = {name = "Hopbop", prices = {["default"] = 2.1, ["Ride"] = 105, ["Neon"] = 4.81, ["Neon|Ride"] = 43.3, ["Neon|Fly|Ride"] = 93.95, ["Mega"] = 35.44, ["Mega|Ride"] = 110.25}},
    ["rbxassetid://6498255997"] = {name = "Stingray", prices = {["default"] = 2.1, ["Fly"] = 28.75, ["Ride"] = 17.03, ["Fly|Ride"] = 36.05, ["Neon"] = 4.71, ["Neon|Fly"] = 79.98, ["Neon|Ride"] = 18.88, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 89.24, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 157.4}},
    ["rbxassetid://13104106555"] = {name = "Mosquito", prices = {["default"] = 8.54, ["Ride"] = 27.98, ["Neon"] = 36.16, ["Mega"] = 267.94, ["Mega|Fly|Ride"] = 821.63}},
    ["rbxassetid://5721843483"] = {name = "Ground Sloth", prices = {["default"] = 2.1, ["Fly"] = 27.02, ["Ride"] = 16.53, ["Fly|Ride"] = 47.79, ["Neon"] = 15.75, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 157.5, ["Mega|Ride"] = 129.94, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://4506925908"] = {name = "Robin", prices = {["default"] = 2.1, ["Fly"] = 21.15, ["Ride"] = 16.62, ["Fly|Ride"] = 48.57, ["Neon"] = 15.31, ["Neon|Fly"] = 25.45, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 81.44, ["Mega"] = 197.34, ["Mega|Fly"] = 414.4, ["Mega|Ride"] = 154.88, ["Mega|Fly|Ride"] = 189.7}},
    ["rbxassetid://10382786163"] = {name = "Sado Mole", prices = {["default"] = 2.1, ["Fly"] = 110.93, ["Ride"] = 17.62, ["Fly|Ride"] = 137.7, ["Neon"] = 19.69, ["Mega"] = 123.3, ["Mega|Ride"] = 406.88}},
    ["rbxassetid://14471275373"] = {name = "Ash Zebra", prices = {["default"] = 10.49, ["Ride"] = 28.06, ["Neon|Ride"] = 139.18, ["Mega"] = 692.73, ["Mega|Ride"] = 931.6, ["Mega|Fly|Ride"] = 794.07}},
    ["rbxassetid://15923574361"] = {name = "Armadillo", prices = {["default"] = 6.57, ["Ride"] = 79.86, ["Neon"] = 41.56, ["Neon|Ride"] = 91.88, ["Mega"] = 206.69, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 722.54}},
    ["rbxassetid://15921927876"] = {name = "Coyote", prices = {["default"] = 5.25, ["Fly|Ride"] = 139.13, ["Neon"] = 61.46, ["Neon|Ride"] = 56.01, ["Mega"] = 248.07, ["Mega|Ride"] = 255.94, ["Mega|Fly|Ride"] = 353.72}},
    ["rbxassetid://74353184935672"] = {name = "Sheepdog Ducky", prices = {["default"] = 2.1, ["Neon"] = 3.29, ["Neon|Ride"] = 64.99, ["Mega"] = 23.49, ["Mega|Ride"] = 139.13, ["Mega|Fly|Ride"] = 148.32}},
    ["rbxassetid://4748889845"] = {name = "Easter 2020 Egg", prices = {["default"] = 46.31}},
    ["rbxassetid://4752655872"] = {name = "Chick", prices = {["default"] = 4.72, ["Fly"] = 21.51, ["Ride"] = 23.49, ["Fly|Ride"] = 45.93, ["Neon"] = 26.25, ["Neon|Ride"] = 47.79, ["Neon|Fly|Ride"] = 91.59, ["Mega"] = 273, ["Mega|Fly"] = 332.35, ["Mega|Ride"] = 270.04, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://17174085645"] = {name = "Garden Snake", prices = {["default"] = 2.1, ["Fly"] = 70.88, ["Ride"] = 18.37, ["Fly|Ride"] = 65.63, ["Neon"] = 3.94, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 52.5, ["Mega"] = 28.06, ["Mega|Fly|Ride"] = 1312.5}},
    ["rbxassetid://17661844380"] = {name = "Show Pony", prices = {["default"] = 2.1, ["Ride"] = 36.37, ["Neon"] = 3.94, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 406.66, ["Mega"] = 157.5, ["Mega|Ride"] = 68.72, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://8077196440"] = {name = "Walrus", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 14.44, ["Fly|Ride"] = 55.65, ["Neon"] = 11.39, ["Neon|Ride"] = 20.67, ["Neon|Fly|Ride"] = 106.88, ["Mega"] = 141.75, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://13104118499"] = {name = "Liger", prices = {["default"] = 13.11, ["Ride"] = 97.63, ["Fly|Ride"] = 60.25, ["Neon"] = 45.26, ["Neon|Ride"] = 83.1, ["Neon|Fly|Ride"] = 191.63, ["Mega"] = 290.81, ["Mega|Ride"] = 269.96, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://120937667166493"] = {name = "Aye Aye", prices = {["default"] = 2.1, ["Neon"] = 3.94, ["Neon|Ride"] = 48.72, ["Mega"] = 19.16, ["Mega|Fly"] = 118.13, ["Mega|Ride"] = 42.95, ["Mega|Fly|Ride"] = 276.27}},
    ["rbxassetid://3199974297"] = {name = "Cracked Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15348350458"] = {name = "Beluga Whale", prices = {["default"] = 2.1, ["Fly"] = 16.64, ["Ride"] = 15.44, ["Fly|Ride"] = 276947.42, ["Neon"] = 3.52, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 30.55, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 35.42, ["Mega|Fly"] = 200.81, ["Mega|Ride"] = 137.11, ["Mega|Fly|Ride"] = 104.9}},
    ["rbxassetid://7126719464"] = {name = "Wolpertinger", prices = {["default"] = 2.1, ["Fly"] = 26.54, ["Ride"] = 17.07, ["Fly|Ride"] = 34.13, ["Neon"] = 3.94, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 69.6, ["Mega"] = 47.94, ["Mega|Ride"] = 51.33, ["Mega|Fly|Ride"] = 139.19}},
    ["rbxassetid://125112456358906"] = {name = "Frankenfeline", prices = {["default"] = 2.1, ["Fly"] = 210, ["Ride"] = 36.74, ["Fly|Ride"] = 118.13, ["Neon"] = 3.74, ["Neon|Ride"] = 27.03, ["Neon|Fly|Ride"] = 110.1, ["Mega"] = 23.15, ["Mega|Ride"] = 62.35, ["Mega|Fly|Ride"] = 111.14}},
    ["rbxassetid://80556114592490"] = {name = "Japanese Snow Fairy", prices = {["default"] = 2.62, ["Neon"] = 3.73, ["Neon|Ride"] = 164.37, ["Neon|Fly|Ride"] = 151240.57, ["Mega"] = 77.67, ["Mega|Fly"] = 104.99, ["Mega|Ride"] = 85.76, ["Mega|Fly|Ride"] = 200.91}},
    ["rbxassetid://124671555129102"] = {name = "Ratatoskr", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 17.64, ["Fly|Ride"] = 76.67, ["Neon"] = 4.71, ["Neon|Fly"] = 26.25, ["Neon|Ride"] = 26.25, ["Neon|Fly|Ride"] = 77.52, ["Mega"] = 25.74, ["Mega|Ride"] = 44.63, ["Mega|Fly|Ride"] = 103.87}},
    ["rbxassetid://116184296449988"] = {name = "Pinkypillar", prices = {["default"] = 2.1, ["Ride"] = 45.94, ["Neon"] = 2.57, ["Mega"] = 31.71, ["Mega|Ride"] = 104.9, ["Mega|Fly|Ride"] = 166.19}},
    ["rbxassetid://74353532164157"] = {name = "Red Panda Ducky", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Ride"] = 155.6, ["Mega"] = 41.56, ["Mega|Fly"] = 117.44, ["Mega|Ride"] = 118.27, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://4708551264"] = {name = "Bandicoot", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 14.33, ["Fly|Ride"] = 49.87, ["Neon"] = 5.19, ["Neon|Ride"] = 20.69, ["Neon|Fly|Ride"] = 135.13, ["Mega"] = 166.19, ["Mega|Ride"] = 47.82, ["Mega|Fly|Ride"] = 157.36}},
    ["rbxassetid://12480314681"] = {name = "Malaysian Tapir", prices = {["default"] = 10.49, ["Fly"] = 56.1, ["Ride"] = 137.76, ["Neon"] = 98.44, ["Neon|Ride"] = 313.57, ["Mega"] = 480.73, ["Mega|Ride"] = 450.19, ["Mega|Fly|Ride"] = 762.32}},
    ["rbxassetid://17482380743"] = {name = "Classic Teapot", prices = {["default"] = 2.1, ["Fly"] = 6562.5, ["Ride"] = 17.07, ["Neon"] = 191.1, ["Neon|Ride"] = 205.65, ["Mega"] = 1581.72, ["Mega|Ride"] = 341.92}},
    ["rbxassetid://14146142724"] = {name = "Mongoose", prices = {["default"] = 3.45, ["Ride"] = 26.24, ["Fly|Ride"] = 410.87, ["Neon"] = 28.59, ["Neon|Ride"] = 26.25, ["Mega"] = 98.44, ["Mega|Ride"] = 234.86, ["Mega|Fly|Ride"] = 349.65}},
    ["rbxassetid://3181727351"] = {name = "Dog", prices = {["default"] = 2.1, ["Fly"] = 17.62, ["Ride"] = 12.32, ["Neon"] = 2.1, ["Neon|Fly"] = 11.75, ["Neon|Ride"] = 12.99, ["Neon|Fly|Ride"] = 27.57, ["Mega"] = 12.89, ["Mega|Fly"] = 45.71, ["Mega|Ride"] = 27.98, ["Mega|Fly|Ride"] = 82.06}},
    ["rbxassetid://14267322852"] = {name = "Angelfish", prices = {["default"] = 5.25, ["Fly"] = 118.12, ["Ride"] = 20.79, ["Fly|Ride"] = 69.6, ["Neon"] = 17.43, ["Neon|Fly"] = 90.36, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 692.73, ["Mega"] = 116.09, ["Mega|Ride"] = 97.63}},
    ["rbxassetid://110130591707207"] = {name = "California Condor", prices = {["default"] = 2.1, ["Ride"] = 31.4, ["Neon"] = 2.1, ["Neon|Fly"] = 30.83, ["Neon|Ride"] = 23.63, ["Neon|Fly|Ride"] = 77.9, ["Mega"] = 14.44, ["Mega|Fly"] = 75.92, ["Mega|Ride"] = 77.97, ["Mega|Fly|Ride"] = 99.56}},
    ["rbxassetid://123567499475377"] = {name = "Forest Sprite", prices = {["default"] = 2.1, ["Ride"] = 92.78, ["Neon"] = 3.57, ["Neon|Fly"] = 60.9, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 120.48, ["Mega"] = 30.55, ["Mega|Ride"] = 101.79, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://8663441035"] = {name = "Lunar White Tiger", prices = {["default"] = 2.63, ["Fly"] = 15.75, ["Ride"] = 17.61, ["Fly|Ride"] = 54.02, ["Neon"] = 9.86, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 30.19, ["Neon|Fly|Ride"] = 88.34, ["Mega"] = 157.39, ["Mega|Ride"] = 190.12, ["Mega|Fly|Ride"] = 352.29}},
    ["rbxassetid://16000498338"] = {name = "Groundhog", prices = {["default"] = 165.93, ["Ride"] = 211.31, ["Fly|Ride"] = 255.5, ["Neon"] = 1050, ["Neon|Ride"] = 822.94, ["Mega"] = 8308.43, ["Mega|Fly|Ride"] = 3308.84}},
    ["rbxassetid://73268582142443"] = {name = "Kelp Raider", prices = {["default"] = 2.1, ["Neon"] = 6.57, ["Neon|Fly"] = 56, ["Neon|Ride"] = 68.25, ["Mega"] = 64.03, ["Mega|Ride"] = 89.25, ["Mega|Fly|Ride"] = 720.77}},
    ["rbxassetid://16369178617"] = {name = "Ornate Horned Frog", prices = {["default"] = 4.04, ["Fly"] = 103.68, ["Ride"] = 36.37, ["Neon"] = 28.06, ["Neon|Ride"] = 39.95, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 350.83, ["Mega|Ride"] = 564.38, ["Mega|Fly|Ride"] = 414.4}},
    ["rbxassetid://6245080170"] = {name = "Lunar Ox", prices = {["default"] = 2.1, ["Fly"] = 650.62, ["Ride"] = 12.74, ["Fly|Ride"] = 32.78, ["Neon"] = 6.9, ["Neon|Fly"] = 31.4, ["Neon|Ride"] = 28.96, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 131.25, ["Mega|Ride"] = 73.61, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://92652981666929"] = {name = "Starmite", prices = {["default"] = 2.1, ["Fly"] = 51.19, ["Ride"] = 19.27, ["Fly|Ride"] = 52.5, ["Neon"] = 117.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 95.71, ["Mega|Ride"] = 136.5, ["Mega|Fly|Ride"] = 581.6}},
    ["rbxassetid://9482496753"] = {name = "King Penguin", prices = {["default"] = 4.87, ["Fly"] = 23.67, ["Ride"] = 17.45, ["Fly|Ride"] = 35.41, ["Neon"] = 31.18, ["Neon|Ride"] = 45.71, ["Neon|Fly|Ride"] = 91.88, ["Mega"] = 157.5, ["Mega|Ride"] = 166.19, ["Mega|Fly|Ride"] = 313.53}},
    ["rbxassetid://10489161125"] = {name = "Tanuki", prices = {["default"] = 2.1, ["Fly"] = 41.56, ["Ride"] = 41.56, ["Fly|Ride"] = 249.58, ["Neon"] = 39.38, ["Neon|Ride"] = 128.26, ["Neon|Fly|Ride"] = 616.91, ["Mega"] = 333.38, ["Mega|Fly|Ride"] = 399}},
    ["rbxassetid://7126720060"] = {name = "Wyvern", prices = {["default"] = 2.1, ["Fly"] = 13.13, ["Ride"] = 13.13, ["Fly|Ride"] = 36.75, ["Neon"] = 13.13, ["Neon|Fly"] = 68.16, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 66.96, ["Mega|Fly"] = 253.43, ["Mega|Ride"] = 692.73, ["Mega|Fly|Ride"] = 231}},
    ["rbxassetid://4506925800"] = {name = "Swan", prices = {["default"] = 64.31, ["Fly"] = 98.8, ["Ride"] = 100.47, ["Fly|Ride"] = 163.49, ["Neon"] = 450.75, ["Neon|Fly"] = 410.82, ["Neon|Ride"] = 387.19, ["Neon|Fly|Ride"] = 437.33, ["Mega|Fly|Ride"] = 1644.57}},
    ["rbxassetid://13621428133"] = {name = "Tortuga de la Isla", prices = {["default"] = 205.7, ["Fly"] = 329.53, ["Ride"] = 253.32, ["Fly|Ride"] = 301.88, ["Neon"] = 986.39, ["Neon|Ride"] = 1453.98, ["Neon|Fly|Ride"] = 1037.31, ["Mega"] = 10385.52, ["Mega|Fly|Ride"] = 4002.59}},
    ["rbxassetid://6684832189"] = {name = "Lamb", prices = {["default"] = 40.52, ["Fly"] = 137.62, ["Ride"] = 91.88, ["Fly|Ride"] = 120.74, ["Neon"] = 277.31, ["Neon|Ride"] = 277.68, ["Neon|Fly|Ride"] = 312.38, ["Mega|Fly|Ride"] = 1300.4}},
    ["rbxassetid://122365328950491"] = {name = "Blossom Snake", prices = {["default"] = 4.65, ["Fly"] = 26.25, ["Ride"] = 24.86, ["Fly|Ride"] = 139.18, ["Neon"] = 21.15, ["Neon|Ride"] = 69.57, ["Neon|Fly|Ride"] = 124.65, ["Mega"] = 191.41, ["Mega|Ride"] = 363.57, ["Mega|Fly|Ride"] = 346.89}},
    ["rbxassetid://14360919997"] = {name = "Toasty Red Panda", prices = {["default"] = 13, ["Fly"] = 68.81, ["Ride"] = 30.82, ["Fly|Ride"] = 81.14, ["Neon"] = 139.19, ["Neon|Ride"] = 97.08, ["Neon|Fly|Ride"] = 173.45, ["Mega"] = 351.75, ["Mega|Ride"] = 364.54, ["Mega|Fly|Ride"] = 1163.19}},
    ["rbxassetid://3181727278"] = {name = "Rabbit", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 18.37, ["Fly|Ride"] = 34.08, ["Neon"] = 6.57, ["Neon|Fly"] = 25.85, ["Neon|Ride"] = 18.64, ["Neon|Fly|Ride"] = 69.57, ["Mega"] = 66.48, ["Mega|Fly"] = 211.38, ["Mega|Ride"] = 93.19, ["Mega|Fly|Ride"] = 410.25}},
    ["rbxassetid://14782579567"] = {name = "Nightmare Owl", prices = {["default"] = 5.99, ["Fly"] = 68.8, ["Ride"] = 22.2, ["Fly|Ride"] = 313.53, ["Neon"] = 52.35, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 134.93, ["Mega"] = 824.62, ["Mega|Ride"] = 589.91, ["Mega|Fly|Ride"] = 554.6}},
    ["rbxassetid://6498256342"] = {name = "Narwhal", prices = {["default"] = 2.1, ["Fly"] = 30.55, ["Ride"] = 15.44, ["Fly|Ride"] = 41.88, ["Neon"] = 11.58, ["Neon|Fly"] = 145.69, ["Neon|Ride"] = 36.37, ["Neon|Fly|Ride"] = 101.55, ["Mega"] = 131.25, ["Mega|Ride"] = 166.19, ["Mega|Fly|Ride"] = 179.82}},
    ["rbxassetid://9227407648"] = {name = "Ibex", prices = {["default"] = 2.1, ["Ride"] = 20.46, ["Fly|Ride"] = 125.66, ["Neon"] = 52.98, ["Neon|Ride"] = 55.48, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 207.37, ["Mega|Ride"] = 206.69, ["Mega|Fly|Ride"] = 337.84}},
    ["rbxassetid://16440727263"] = {name = "Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 34.35, ["Ride"] = 36.37, ["Neon"] = 2.18, ["Neon|Ride"] = 19.66, ["Neon|Fly|Ride"] = 47.24, ["Mega"] = 15.1, ["Mega|Ride"] = 50.91, ["Mega|Fly|Ride"] = 209664.94}},
    ["rbxassetid://10318106327"] = {name = "Yellow Butterfly", prices = {["default"] = 2.1, ["Fly"] = 45.94, ["Ride"] = 17.43, ["Fly|Ride"] = 39.38, ["Neon"] = 14.44, ["Neon|Fly"] = 103.87, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 97.99, ["Mega"] = 84, ["Mega|Ride"] = 99.62, ["Mega|Fly|Ride"] = 170.62}},
    ["rbxassetid://13894169749"] = {name = "Black Kite", prices = {["default"] = 2.63, ["Fly"] = 24.93, ["Ride"] = 17.06, ["Fly|Ride"] = 45.93, ["Neon"] = 45.94, ["Neon|Ride"] = 47.25, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 283.5, ["Mega|Ride"] = 180.72, ["Mega|Fly|Ride"] = 224.3}},
    ["rbxassetid://4506925595"] = {name = "Polar Bear", prices = {["default"] = 174.57, ["Fly"] = 286.53, ["Ride"] = 223.13, ["Fly|Ride"] = 261.19, ["Neon"] = 700.88, ["Neon|Ride"] = 787.5, ["Neon|Fly|Ride"] = 735, ["Mega|Ride"] = 3478.13, ["Mega|Fly|Ride"] = 2887.5}},
    ["rbxassetid://14639006189"] = {name = "Canada Goose", prices = {["default"] = 7.54, ["Ride"] = 240.92, ["Fly|Ride"] = 206.07, ["Neon"] = 61.2, ["Neon|Ride"] = 160.13, ["Neon|Fly|Ride"] = 656.25, ["Mega"] = 337.02, ["Mega|Ride"] = 469.7, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://5721844402"] = {name = "Triceratops", prices = {["default"] = 2.1, ["Ride"] = 15.07, ["Fly|Ride"] = 43.32, ["Neon"] = 23.21, ["Neon|Ride"] = 115.4, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 183.75, ["Mega|Ride"] = 221.82, ["Mega|Fly|Ride"] = 274.2}},
    ["rbxassetid://83805820117149"] = {name = "Golden Jaguar", prices = {["default"] = 22.31, ["Ride"] = 39.71, ["Fly|Ride"] = 170.63, ["Neon"] = 115.67, ["Neon|Ride"] = 148.31, ["Neon|Fly|Ride"] = 386.55, ["Mega"] = 540.28, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://13936754497"] = {name = "Pinocchio", prices = {["default"] = 3.29}},
    ["rbxassetid://17059776562"] = {name = "Ankylosaurus", prices = {["default"] = 5.25, ["Ride"] = 27.02, ["Neon"] = 68.16, ["Neon|Ride"] = 46.99, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 304.5, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 691.69}},
    ["rbxassetid://3181727813"] = {name = "Horse", prices = {["default"] = 30.87, ["Fly"] = 77.67, ["Ride"] = 35.33, ["Fly|Ride"] = 56.35, ["Neon|Fly"] = 101818.18, ["Neon|Ride"] = 143.28, ["Neon|Fly|Ride"] = 219.85, ["Mega"] = 2077.11, ["Mega|Fly|Ride"] = 828.78}},
    ["rbxassetid://101098195340953"] = {name = "Mexican Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Fly|Ride"] = 78.75, ["Neon"] = 3.69, ["Neon|Ride"] = 52.99, ["Neon|Fly|Ride"] = 105, ["Mega"] = 26.23, ["Mega|Fly"] = 414.4, ["Mega|Ride"] = 76.86, ["Mega|Fly|Ride"] = 131.06}},
    ["rbxassetid://13894408663"] = {name = "Seagull", prices = {["default"] = 3.93, ["Fly"] = 27.2, ["Ride"] = 28.06, ["Fly|Ride"] = 112.54, ["Neon"] = 15.75, ["Neon|Ride"] = 34.95, ["Mega"] = 222.26, ["Mega|Fly"] = 392.2, ["Mega|Ride"] = 147, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://6998403532"] = {name = "Sasquatch", prices = {["default"] = 2.1, ["Ride"] = 16.95, ["Fly|Ride"] = 45.65, ["Neon"] = 14.15, ["Neon|Fly"] = 186.9, ["Neon|Ride"] = 32.82, ["Neon|Fly|Ride"] = 60.38, ["Mega"] = 124.69, ["Mega|Ride"] = 156.19, ["Mega|Fly|Ride"] = 241.61}},
    ["rbxassetid://108348392849720"] = {name = "Water Opossum", prices = {["default"] = 2.1, ["Ride"] = 36.37, ["Neon"] = 5.25, ["Neon|Ride"] = 31.11, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 26.25, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://11758575705"] = {name = "Moon Rabbit", prices = {["default"] = 24.68, ["Ride"] = 131.25, ["Neon"] = 218.7, ["Neon|Ride"] = 235.76, ["Neon|Fly|Ride"] = 581.63, ["Mega"] = 869.02, ["Mega|Ride"] = 1045.84, ["Mega|Fly|Ride"] = 988.67}},
    ["rbxassetid://15922874831"] = {name = "Roadrunner", prices = {["default"] = 5.81, ["Ride"] = 50.69, ["Neon"] = 80.07, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 276.27, ["Mega|Ride"] = 277.31}},
    ["rbxassetid://6060988175"] = {name = "Snowman", prices = {["default"] = 16.64, ["Fly"] = 87.04, ["Ride"] = 38.07, ["Fly|Ride"] = 69.56, ["Neon"] = 91.35, ["Neon|Fly"] = 314.99, ["Neon|Ride"] = 125.51, ["Neon|Fly|Ride"] = 144.38}},
    ["rbxassetid://12720029414"] = {name = "Wood Pigeon", prices = {["default"] = 60.26, ["Fly"] = 97.63, ["Ride"] = 103.69, ["Fly|Ride"] = 262.44, ["Neon"] = 411.28, ["Neon|Ride"] = 415.44, ["Neon|Fly|Ride"] = 616.91, ["Mega|Ride"] = 2034.38, ["Mega|Fly|Ride"] = 1246.28}},
    ["rbxassetid://136340738568203"] = {name = "Mr Whiskerpips", prices = {["default"] = 6.57, ["Fly"] = 39.38, ["Ride"] = 28.85, ["Fly|Ride"] = 56.38, ["Neon"] = 69.57, ["Neon|Ride"] = 81.38, ["Neon|Fly|Ride"] = 136.5, ["Mega"] = 263.82, ["Mega|Ride"] = 256.1, ["Mega|Fly|Ride"] = 502.59}},
    ["rbxassetid://127204329704553"] = {name = "German Shepherd", prices = {["default"] = 77.44, ["Fly"] = 143.07, ["Ride"] = 124.69, ["Neon"] = 203.44, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 927.69, ["Mega|Ride"] = 939.39, ["Mega|Fly|Ride"] = 844.59}},
    ["rbxassetid://99868640713300"] = {name = "Puptune", prices = {["default"] = 18.27, ["Fly"] = 124.65, ["Ride"] = 84, ["Fly|Ride"] = 139.18, ["Neon"] = 87.94, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 830.86, ["Mega"] = 389.86, ["Mega|Ride"] = 294.55, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://9993276067"] = {name = "2022 Uplift Butterfly", prices = {["default"] = 5.1, ["Fly"] = 69.51, ["Ride"] = 27.57, ["Fly|Ride"] = 69.6, ["Neon"] = 82.68, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 373.43, ["Mega"] = 139.18, ["Mega|Ride"] = 1038.57, ["Mega|Fly|Ride"] = 399.25}},
    ["rbxassetid://136574776317301"] = {name = "Sweetheart Rat", prices = {["default"] = 65.63, ["Ride"] = 111.14, ["Fly|Ride"] = 142.76, ["Neon"] = 78.75, ["Neon|Ride"] = 111.56, ["Neon|Fly|Ride"] = 298.28, ["Mega"] = 255.18, ["Mega|Fly"] = 501.64, ["Mega|Ride"] = 307.13, ["Mega|Fly|Ride"] = 413.44}},
    ["rbxassetid://17649489402"] = {name = "Cow Calf", prices = {["default"] = 6.62, ["Ride"] = 32.22, ["Fly|Ride"] = 135.61, ["Neon"] = 41.56, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 136.07, ["Mega"] = 306.38, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 330.92}},
    ["rbxassetid://77869404304609"] = {name = "Budgie Witch", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Fly"] = 54.02, ["Neon|Ride"] = 56.25, ["Mega"] = 15.63, ["Mega|Fly"] = 139.18, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://111676861947081"] = {name = "The Black Dog", prices = {["default"] = 3.46, ["Ride"] = 22.32, ["Fly|Ride"] = 431.02, ["Neon"] = 19.68, ["Neon|Fly"] = 124.65, ["Neon|Ride"] = 118.13, ["Neon|Fly|Ride"] = 202.78, ["Mega"] = 95.81, ["Mega|Ride"] = 492.99, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://13104122472"] = {name = "Borhyaena Gigantica", prices = {["default"] = 2.1, ["Fly"] = 17.62, ["Neon"] = 23.61, ["Neon|Ride"] = 207.73, ["Mega"] = 137.82, ["Mega|Ride"] = 139.98, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://105232492496005"] = {name = "Firefighter Gibbon", prices = {["default"] = 7.06, ["Ride"] = 32.78, ["Fly|Ride"] = 116.27, ["Neon"] = 15.75, ["Neon|Ride"] = 82.95, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 123.37, ["Mega|Ride"] = 212.26, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://3409443514"] = {name = "Elephant", prices = {["default"] = 497.44, ["Ride"] = 581.44, ["Fly|Ride"] = 614.7, ["Neon"] = 1721.93, ["Neon|Ride"] = 1439.24, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 5878.95}},
    ["rbxassetid://10137833682"] = {name = "Brown-Chested Pheasant", prices = {["default"] = 5.1, ["Fly"] = 28.06, ["Ride"] = 23.49, ["Fly|Ride"] = 56.1, ["Neon"] = 26.25, ["Neon|Ride"] = 69.6, ["Neon|Fly|Ride"] = 210, ["Mega"] = 157.36, ["Mega|Ride"] = 401.6, ["Mega|Fly|Ride"] = 498.52}},
    ["rbxassetid://12490691849"] = {name = "Gecko", prices = {["default"] = 11.61, ["Fly"] = 39.38, ["Ride"] = 26.25, ["Fly|Ride"] = 60.38, ["Neon"] = 62.33, ["Neon|Ride"] = 63.42, ["Neon|Fly|Ride"] = 201.49, ["Mega"] = 273.27, ["Mega|Ride"] = 288.65, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://9913459163"] = {name = "Trapdoor Snail", prices = {["default"] = 2.1, ["Ride"] = 19.76, ["Fly|Ride"] = 311.58, ["Neon|Ride"] = 102.83, ["Neon|Fly|Ride"] = 151.65, ["Mega"] = 264.23, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://124413732651376"] = {name = "Gumball Caterpillar", prices = {["default"] = 2.1, ["Fly"] = 61.14, ["Ride"] = 23.29, ["Fly|Ride"] = 90.57, ["Neon"] = 10.41, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 91.62, ["Mega"] = 81.02, ["Mega|Fly"] = 170.63, ["Mega|Ride"] = 96.71, ["Mega|Fly|Ride"] = 233.63}},
    ["rbxassetid://96107383056013"] = {name = "Gummy Guana", prices = {["default"] = 2.1, ["Fly"] = 69.6, ["Ride"] = 13.13, ["Neon"] = 3.94, ["Neon|Ride"] = 30.14, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 23.63, ["Mega|Ride"] = 62.53, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://3261465951"] = {name = "Blue Egg", prices = {["default"] = 1107.73}},
    ["rbxassetid://11245006051"] = {name = "Therapy Dog", prices = {["default"] = 3.41, ["Ride"] = 36.37, ["Fly|Ride"] = 68.81, ["Neon"] = 61.69, ["Neon|Ride"] = 72.16, ["Neon|Fly|Ride"] = 173.45, ["Mega|Ride"] = 830.86, ["Mega|Fly|Ride"] = 854.74}},
    ["rbxassetid://76323474173289"] = {name = "Kelp Crewmate", prices = {["default"] = 2.1, ["Ride"] = 28.26, ["Neon"] = 5.13, ["Neon|Ride"] = 40.69, ["Mega"] = 38.66, ["Mega|Ride"] = 143.34, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://14978701264"] = {name = "Scarecrow Horse", prices = {["default"] = 2.1, ["Fly"] = 97.63, ["Ride"] = 40.52, ["Fly|Ride"] = 574.39, ["Neon"] = 11.44, ["Neon|Fly"] = 124.65, ["Neon|Ride"] = 68.85, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 153.78, ["Mega|Ride"] = 244.13, ["Mega|Fly|Ride"] = 309.73}},
    ["rbxassetid://3409443801"] = {name = "Lion", prices = {["default"] = 446.23, ["Ride"] = 482.39, ["Fly|Ride"] = 459.38, ["Neon|Ride"] = 1523.58, ["Neon|Fly|Ride"] = 1483.13, ["Mega|Fly|Ride"] = 6562.5}},
    ["rbxassetid://13979014954"] = {name = "Fossa", prices = {["default"] = 5.25, ["Fly"] = 196.88, ["Ride"] = 97.63, ["Neon"] = 101.79, ["Neon|Ride"] = 115.29, ["Neon|Fly|Ride"] = 186.63, ["Mega"] = 411.28, ["Mega|Ride"] = 414.4, ["Mega|Fly|Ride"] = 554.6}},
    ["rbxassetid://137886461285917"] = {name = "Angus Cow", prices = {["default"] = 2.1, ["Fly"] = 111.14, ["Fly|Ride"] = 164.11, ["Neon"] = 4.71, ["Neon|Ride"] = 34.26, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 37.95, ["Mega|Fly"] = 189, ["Mega|Ride"] = 118.12, ["Mega|Fly|Ride"] = 200.82}},
    ["rbxassetid://128343324254978"] = {name = "Blue Cat", prices = {["default"] = 2.1, ["Ride"] = 830.86, ["Neon"] = 3.94, ["Neon|Ride"] = 107.65, ["Neon|Fly|Ride"] = 263.82, ["Mega"] = 21.63, ["Mega|Ride"] = 83.1, ["Mega|Fly|Ride"] = 197.34}},
    ["rbxassetid://79274485636628"] = {name = "Indian Flying Fox", prices = {["default"] = 14.52, ["Fly"] = 107.61, ["Ride"] = 41.56, ["Fly|Ride"] = 178.5, ["Neon"] = 65.54, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 290.81, ["Mega"] = 554.6, ["Mega|Fly|Ride"] = 584.01}},
    ["rbxassetid://96039704958671"] = {name = "Singularity Pisces", prices = {["default"] = 30.19, ["Ride"] = 111.14, ["Neon"] = 98.67, ["Neon|Ride"] = 110.4, ["Neon|Fly|Ride"] = 170.63, ["Mega"] = 393.75, ["Mega|Ride"] = 479.72, ["Mega|Fly|Ride"] = 1063.79}},
    ["rbxassetid://12489494348"] = {name = "Komodo Dragon", prices = {["default"] = 3.94, ["Ride"] = 39.38, ["Fly|Ride"] = 139.18, ["Neon"] = 105, ["Neon|Ride"] = 157.36, ["Mega"] = 634.46, ["Mega|Ride"] = 692.72, ["Mega|Fly|Ride"] = 1246.28}},
    ["rbxassetid://14360919129"] = {name = "Flaming Zebra", prices = {["default"] = 46.73, ["Ride"] = 65.63, ["Neon"] = 198.38, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 459.38, ["Mega|Ride"] = 613.6, ["Mega|Fly|Ride"] = 665.44}},
    ["rbxassetid://108242367048842"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 422.7, ["Fly|Ride"] = 616.88, ["Neon"] = 1659.62, ["Neon|Ride"] = 1523.58, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3601.33}},
    ["rbxassetid://11119262646"] = {name = "Evil Chickatrice", prices = {["default"] = 4.56, ["Fly"] = 69.65, ["Ride"] = 22.82, ["Fly|Ride"] = 51.95, ["Neon"] = 96.48, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 137.67, ["Mega"] = 554.6, ["Mega|Ride"] = 315, ["Mega|Fly|Ride"] = 855.78}},
    ["rbxassetid://120631772928905"] = {name = "Subzero Scorpion", prices = {["default"] = 28.88, ["Ride"] = 125.98, ["Fly|Ride"] = 78.75, ["Mega"] = 367.5, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 783.22}},
    ["rbxassetid://70394243440806"] = {name = "Ghostly Cat", prices = {["default"] = 16.62, ["Ride"] = 62.33, ["Fly|Ride"] = 259.52, ["Neon"] = 52.41, ["Neon|Ride"] = 111.28, ["Neon|Fly|Ride"] = 220.19, ["Mega"] = 249.38, ["Mega|Fly"] = 415.44, ["Mega|Ride"] = 259.94, ["Mega|Fly|Ride"] = 314.36}},
    ["rbxassetid://108186720416551"] = {name = "Storm Condor", prices = {["default"] = 2.1, ["Ride"] = 42, ["Fly|Ride"] = 124.65, ["Neon"] = 15.6, ["Neon|Ride"] = 157.48, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 43.73, ["Mega|Fly"] = 105, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 140.93}},
    ["rbxassetid://11181152874"] = {name = "Mule", prices = {["default"] = 52.49, ["Ride"] = 150.93, ["Neon"] = 257.58, ["Neon|Ride"] = 298.08, ["Neon|Fly|Ride"] = 467.36, ["Mega"] = 2492.55, ["Mega|Ride"] = 1339.74, ["Mega|Fly|Ride"] = 2060.63}},
    ["rbxassetid://94781392732758"] = {name = "Onza", prices = {["default"] = 2.1, ["Fly"] = 56.44, ["Ride"] = 36.36, ["Neon"] = 11.76, ["Neon|Fly"] = 156.97, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 85.32, ["Mega|Ride"] = 95.81, ["Mega|Fly|Ride"] = 211.87}},
    ["rbxassetid://102763887893057"] = {name = "Cherub Chipmunk", prices = {["default"] = 2.1, ["Fly"] = 90.37, ["Ride"] = 35.33, ["Fly|Ride"] = 105, ["Neon"] = 10.41, ["Neon|Fly"] = 415.44, ["Neon|Ride"] = 51.19, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 56.44, ["Mega|Fly|Ride"] = 177.19}},
    ["rbxassetid://104845330408668"] = {name = "Icy Porcupine", prices = {["default"] = 2.63, ["Fly"] = 1519.88, ["Ride"] = 28.88, ["Fly|Ride"] = 111.14, ["Neon"] = 139.18, ["Neon|Ride"] = 55.13, ["Neon|Fly|Ride"] = 177.19, ["Mega|Fly"] = 459.38, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://12597275903"] = {name = "White Sand Dollar", prices = {["default"] = 63.39, ["Ride"] = 65.63, ["Neon"] = 437.07, ["Neon|Ride"] = 313.57, ["Neon|Fly|Ride"] = 622.11, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://9901393350"] = {name = "Irish Water Spaniel", prices = {["default"] = 274.32, ["Ride"] = 289.7, ["Fly|Ride"] = 367.27, ["Neon|Ride"] = 918.75, ["Neon|Fly|Ride"] = 1033.37, ["Mega"] = 12462.63, ["Mega|Fly|Ride"] = 4331.25}},
    ["rbxassetid://128640048014369"] = {name = "River Otter", prices = {["default"] = 9.19, ["Neon"] = 51.63, ["Neon|Ride"] = 139.18, ["Mega"] = 86.63, ["Mega|Ride"] = 204.33, ["Mega|Fly|Ride"] = 406.09}},
    ["rbxassetid://138984599254588"] = {name = "Tree Sasquatch", prices = {["default"] = 3.73, ["Neon"] = 16.64, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 105.7, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://15870220155"] = {name = "Vulture", prices = {["default"] = 5.25, ["Fly"] = 155.57, ["Ride"] = 20.56, ["Fly|Ride"] = 176.29, ["Neon"] = 36.75, ["Mega"] = 345.85, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 346.5}},
    ["rbxassetid://7734902490"] = {name = "Halloween Black Mummy Cat", prices = {["default"] = 2.1, ["Fly"] = 57.72, ["Ride"] = 19.29, ["Fly|Ride"] = 65.63, ["Neon"] = 7.29, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 137.91, ["Mega"] = 63.03, ["Mega|Ride"] = 93.84, ["Mega|Fly|Ride"] = 236.23}},
    ["rbxassetid://116677376014234"] = {name = "Sunflower Friend", prices = {["default"] = 2.1, ["Ride"] = 27.76, ["Fly|Ride"] = 277.31, ["Neon"] = 12.47, ["Mega"] = 41.56, ["Mega|Fly"] = 139.18, ["Mega|Ride"] = 692.73, ["Mega|Fly|Ride"] = 273.16}},
    ["rbxassetid://13186022212"] = {name = "Grinmoire", prices = {["default"] = 2.1, ["Fly"] = 65.54, ["Ride"] = 15.6, ["Fly|Ride"] = 41.98, ["Neon"] = 4.36, ["Neon|Ride"] = 18.38, ["Neon|Fly|Ride"] = 56.1, ["Mega"] = 42, ["Mega|Ride"] = 74.79, ["Mega|Fly|Ride"] = 139.18}},
    ["rbxassetid://11119263014"] = {name = "Chickatrice", prices = {["default"] = 2.1, ["Fly"] = 90.36, ["Ride"] = 20.79, ["Fly|Ride"] = 56.1, ["Neon"] = 8.87, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 63.38, ["Mega"] = 156.14, ["Mega|Ride"] = 233.68, ["Mega|Fly|Ride"] = 437.07}},
    ["rbxassetid://13104110160"] = {name = "Blue Ringed Octopus", prices = {["default"] = 35.15, ["Ride"] = 44.08, ["Fly|Ride"] = 82.56, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 459.38, ["Mega|Fly"] = 525, ["Mega|Ride"] = 472.5, ["Mega|Fly|Ride"] = 720.99}},
    ["rbxassetid://16088265753"] = {name = "Flaming Fox", prices = {["default"] = 86.91, ["Fly"] = 582.75, ["Ride"] = 82.06, ["Fly|Ride"] = 160.13, ["Neon"] = 328.02, ["Neon|Ride"] = 400, ["Mega"] = 1409.1, ["Mega|Ride"] = 1382.83, ["Mega|Fly|Ride"] = 1352.5}},
    ["rbxassetid://84105347355723"] = {name = "Gibbon", prices = {["default"] = 2.1, ["Fly"] = 34.74, ["Ride"] = 23.24, ["Fly|Ride"] = 131.25, ["Neon"] = 3.93, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 27.56, ["Mega"] = 44.63, ["Mega|Ride"] = 61.66}},
    ["rbxassetid://9543194411"] = {name = "Swordfish", prices = {["default"] = 2.1, ["Fly"] = 15.49, ["Ride"] = 15.72, ["Fly|Ride"] = 35.43, ["Neon"] = 4.03, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 20.33, ["Neon|Fly|Ride"] = 61.68, ["Mega"] = 48.56, ["Mega|Fly"] = 131.2, ["Mega|Ride"] = 49.88, ["Mega|Fly|Ride"] = 124.69}},
    ["rbxassetid://11706157391"] = {name = "Steppe Lion", prices = {["default"] = 2.63, ["Fly"] = 28.06, ["Ride"] = 51.19, ["Fly|Ride"] = 131.25, ["Neon"] = 15.75, ["Neon|Ride"] = 46.47, ["Neon|Fly|Ride"] = 276.27, ["Mega"] = 627.05, ["Mega|Ride"] = 413.36, ["Mega|Fly|Ride"] = 543.18}},
    ["rbxassetid://18119064023"] = {name = "Bald Eagle", prices = {["default"] = 367.5, ["Fly"] = 393.74, ["Ride"] = 540.06, ["Fly|Ride"] = 498.75, ["Neon|Ride"] = 1800.86, ["Neon|Fly|Ride"] = 1050, ["Mega|Fly|Ride"] = 6646.75}},
    ["rbxassetid://6060991172"] = {name = "Lynx", prices = {["default"] = 40.52, ["Fly"] = 90.17, ["Ride"] = 84, ["Fly|Ride"] = 91.88, ["Neon"] = 250.11, ["Neon|Ride"] = 162.88, ["Neon|Fly|Ride"] = 219.19, ["Mega|Ride"] = 1244.2, ["Mega|Fly|Ride"] = 1065.02}},
    ["rbxassetid://10614198346"] = {name = "Pomeranian", prices = {["default"] = 2.1, ["Ride"] = 61.29, ["Fly|Ride"] = 78.75, ["Neon"] = 10.35, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 105, ["Mega"] = 78.75, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.49}},
    ["rbxassetid://13663102008"] = {name = "Angler Fish", prices = {["default"] = 2.1, ["Fly"] = 207.73, ["Ride"] = 65.62, ["Fly|Ride"] = 142.7, ["Neon"] = 131.15}},
    ["rbxassetid://5067925193"] = {name = "Toy Monkey", prices = {["default"] = 52.49, ["Fly"] = 76.86, ["Ride"] = 39.38, ["Fly|Ride"] = 68.82, ["Neon|Ride"] = 279.11, ["Neon|Fly|Ride"] = 527.63, ["Mega"] = 2492.55, ["Mega|Ride"] = 918.75, ["Mega|Fly|Ride"] = 1102.96}},
    ["rbxassetid://15698960105"] = {name = "Kookaburra", prices = {["default"] = 106.4, ["Ride"] = 140.93, ["Fly|Ride"] = 153.72, ["Neon"] = 422.29, ["Neon|Ride"] = 468.4, ["Neon|Fly|Ride"] = 479.07, ["Mega"] = 3047.13, ["Mega|Fly|Ride"] = 1869.41}},
    ["rbxassetid://14266900917"] = {name = "Ring-tailed Lemur", prices = {["default"] = 219.62, ["Ride"] = 229.69, ["Fly|Ride"] = 459.37, ["Neon"] = 830.86, ["Neon|Ride"] = 887.98, ["Neon|Fly|Ride"] = 970.02, ["Mega|Fly|Ride"] = 2889.27}},
    ["rbxassetid://10467419131"] = {name = "Leopard Cat", prices = {["default"] = 77.44, ["Fly"] = 70.64, ["Ride"] = 61.29, ["Fly|Ride"] = 211.87, ["Neon"] = 65.63, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 183.75, ["Mega"] = 360.94, ["Mega|Ride"] = 341.25, ["Mega|Fly|Ride"] = 475.34}},
    ["rbxassetid://6498256485"] = {name = "Crab", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 17.89, ["Fly|Ride"] = 40.63, ["Neon"] = 7.87, ["Neon|Ride"] = 17.62, ["Neon|Fly|Ride"] = 63.42, ["Mega"] = 91.23, ["Mega|Ride"] = 104.99, ["Mega|Fly|Ride"] = 189}},
    ["rbxassetid://5721843587"] = {name = "Glyptodon", prices = {["default"] = 5.25, ["Fly"] = 32.9, ["Ride"] = 21, ["Fly|Ride"] = 637.69, ["Neon"] = 25.61, ["Neon|Fly"] = 145.42, ["Neon|Ride"] = 51.95, ["Neon|Fly|Ride"] = 102.69, ["Mega"] = 288.75, ["Mega|Ride"] = 274.23, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://13979141397"] = {name = "Giant Anteater", prices = {["default"] = 285.87, ["Fly"] = 485.01, ["Ride"] = 389.79, ["Fly|Ride"] = 406.88, ["Neon"] = 1566.47, ["Neon|Ride"] = 1312.5, ["Neon|Fly|Ride"] = 1246.88, ["Mega|Ride"] = 4154.22, ["Mega|Fly|Ride"] = 5760.86}},
    ["rbxassetid://109730629255705"] = {name = "Ruddy Duck", prices = {["default"] = 2.1, ["Ride"] = 60.74, ["Neon"] = 11.73, ["Neon|Fly|Ride"] = 118125, ["Mega"] = 277.1, ["Mega|Ride"] = 178.7, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://6498259006"] = {name = "Clownfish", prices = {["default"] = 3.84, ["Fly"] = 21.15, ["Ride"] = 13.78, ["Fly|Ride"] = 41.09, ["Neon"] = 30.55, ["Neon|Ride"] = 38.06, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 177.61, ["Mega|Fly"] = 204.9, ["Mega|Ride"] = 186.37, ["Mega|Fly|Ride"] = 245.11}},
    ["rbxassetid://11758569695"] = {name = "Amami Rabbit", prices = {["default"] = 14.74, ["Ride"] = 114.19, ["Neon"] = 150.94, ["Neon|Fly"] = 415.44, ["Neon|Ride"] = 121.87, ["Neon|Fly|Ride"] = 387.19, ["Mega"] = 472.5, ["Mega|Ride"] = 521.07, ["Mega|Fly|Ride"] = 472.5}},
    ["rbxassetid://11505509482"] = {name = "Ice Wolf", prices = {["default"] = 129.28, ["Fly"] = 130.47, ["Ride"] = 119.81, ["Fly|Ride"] = 139.18, ["Neon|Ride"] = 734.27, ["Neon|Fly|Ride"] = 649.69, ["Mega|Fly|Ride"] = 2010.75}},
    ["rbxassetid://9994480266"] = {name = "Royal Palace Spaniel", prices = {["default"] = 23.63, ["Fly"] = 41.56, ["Ride"] = 34.08, ["Fly|Ride"] = 46.96, ["Neon"] = 76.13, ["Neon|Ride"] = 103.69, ["Neon|Fly|Ride"] = 157.5, ["Mega"] = 623.15, ["Mega|Ride"] = 507.66, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://100897154120273"] = {name = "Clumpty", prices = {["default"] = 2.1, ["Ride"] = 41.2, ["Neon"] = 3.91, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 692.73, ["Mega"] = 26.25, ["Mega|Ride"] = 276.27, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://11108831285"] = {name = "Ocelot", prices = {["default"] = 2.1, ["Ride"] = 22.32, ["Fly|Ride"] = 52.5, ["Neon"] = 2.1, ["Neon|Fly"] = 157.37, ["Neon|Ride"] = 22.86, ["Neon|Fly|Ride"] = 41.25, ["Mega"] = 53.62, ["Mega|Fly"] = 97.12, ["Mega|Ride"] = 53.82, ["Mega|Fly|Ride"] = 110.44}},
    ["rbxassetid://99323773370664"] = {name = "Dire Wolf", prices = {["default"] = 8.9, ["Fly"] = 415.44, ["Ride"] = 60.25, ["Neon"] = 32.16, ["Neon|Ride"] = 95.69, ["Neon|Fly|Ride"] = 174.77, ["Mega"] = 150.92, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 277.9}},
    ["rbxassetid://17649307413"] = {name = "Mini Pig", prices = {["default"] = 1446.38, ["Ride"] = 1312.49, ["Fly|Ride"] = 1470, ["Neon"] = 4200, ["Neon|Ride"] = 6924.04, ["Neon|Fly|Ride"] = 4985.07, ["Mega|Fly|Ride"] = 12600}},
    ["rbxassetid://12720029753"] = {name = "Border Collie", prices = {["default"] = 420, ["Ride"] = 459.37, ["Fly|Ride"] = 497.65, ["Neon"] = 1759.32, ["Neon|Ride"] = 1575, ["Neon|Fly|Ride"] = 1523.58, ["Mega"] = 16616.84, ["Mega|Fly|Ride"] = 7084.88}},
    ["rbxassetid://4440866760"] = {name = "Pig", prices = {["default"] = 319.75, ["Fly"] = 465.94, ["Ride"] = 353.87, ["Fly|Ride"] = 430.49, ["Neon"] = 653.63, ["Neon|Fly"] = 1253.01, ["Neon|Ride"] = 617.67, ["Neon|Fly|Ride"] = 656.25, ["Mega|Fly|Ride"] = 3067.32}},
    ["rbxassetid://4506925854"] = {name = "Arctic Fox", prices = {["default"] = 313.35, ["Fly"] = 413.22, ["Ride"] = 360.51, ["Fly|Ride"] = 505.32, ["Neon"] = 1232.77, ["Neon|Fly"] = 1385.45, ["Neon|Ride"] = 968.63, ["Neon|Fly|Ride"] = 1038.57, ["Mega|Fly|Ride"] = 4431.51}},
    ["rbxassetid://11758575618"] = {name = "Black Moon Bear", prices = {["default"] = 2.1, ["Fly"] = 21.98, ["Ride"] = 15.65, ["Fly|Ride"] = 45.71, ["Neon"] = 7.34, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 82.29, ["Mega"] = 63.62, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 144.38}},
    ["rbxassetid://15547272520"] = {name = "Christmas Pudding Pup", prices = {["default"] = 475.74, ["Ride"] = 514.49, ["Fly|Ride"] = 629.47, ["Neon"] = 1680, ["Neon|Ride"] = 1643.25, ["Neon|Fly|Ride"] = 1878.79, ["Mega|Fly|Ride"] = 8306.36}},
    ["rbxassetid://78519945248690"] = {name = "Zombie Chick", prices = {["default"] = 2.1, ["Fly"] = 183.75, ["Ride"] = 27.99, ["Neon"] = 8.71, ["Neon|Ride"] = 64.02, ["Neon|Fly|Ride"] = 155.36, ["Mega"] = 58.19, ["Mega|Ride"] = 110.1, ["Mega|Fly|Ride"] = 274.2}},
    ["rbxassetid://10357178561"] = {name = "Ibis", prices = {["default"] = 2.1, ["Fly"] = 24.94, ["Ride"] = 20.12, ["Fly|Ride"] = 36.37, ["Neon"] = 10.41, ["Neon|Ride"] = 48.83, ["Neon|Fly|Ride"] = 99.82, ["Mega"] = 105, ["Mega|Ride"] = 192.93}},
    ["rbxassetid://96759122303055"] = {name = "Clubtail Dragonfly", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 39.37, ["Mega"] = 23.63, ["Mega|Fly"] = 157.36, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://12778628897"] = {name = "Karate Gorilla", prices = {["default"] = 44.54, ["Ride"] = 65.63, ["Fly|Ride"] = 459.38, ["Neon"] = 210, ["Neon|Ride"] = 346.89, ["Mega"] = 2077.11, ["Mega|Fly|Ride"] = 1010.63}},
    ["rbxassetid://13104121371"] = {name = "Poison Dart Frog", prices = {["default"] = 2.63, ["Fly"] = 8038.15, ["Ride"] = 19.69, ["Fly|Ride"] = 59.24, ["Neon"] = 23, ["Mega"] = 328.13, ["Mega|Ride"] = 236.25}},
    ["rbxassetid://71881209536633"] = {name = "Humbug", prices = {["default"] = 2.1, ["Ride"] = 39.38, ["Neon"] = 5.67, ["Neon|Fly"] = 118.02, ["Neon|Ride"] = 19.76, ["Neon|Fly|Ride"] = 95.82, ["Mega"] = 57.44, ["Mega|Fly"] = 692.73, ["Mega|Ride"] = 154.81, ["Mega|Fly|Ride"] = 107.63}},
    ["rbxassetid://11109314958"] = {name = "Ghost Wolf", prices = {["default"] = 2.1, ["Fly"] = 35.9, ["Ride"] = 20.65, ["Fly|Ride"] = 59.77, ["Neon"] = 9.19, ["Neon|Fly"] = 52.49, ["Neon|Ride"] = 30.5, ["Neon|Fly|Ride"] = 75.89, ["Mega"] = 65.63, ["Mega|Fly"] = 173.45, ["Mega|Ride"] = 98, ["Mega|Fly|Ride"] = 176.61}},
    ["rbxassetid://16088267136"] = {name = "Wildfire Hawk", prices = {["default"] = 7.97, ["Fly"] = 55.99, ["Ride"] = 18.68, ["Fly|Ride"] = 51.45, ["Neon"] = 153.72, ["Neon|Fly"] = 74.79, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 157.36, ["Mega"] = 237.57, ["Mega|Ride"] = 300.51, ["Mega|Fly|Ride"] = 309.75}},
    ["rbxassetid://16898328648"] = {name = "Preppy Capuchin Monkey", prices = {["default"] = 11.8, ["Ride"] = 52.5, ["Neon"] = 56.44, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 313.53, ["Mega"] = 251.3, ["Mega|Ride"] = 373.9, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://15921713413"] = {name = "Thorny Devil", prices = {["default"] = 2.52, ["Fly"] = 6263.43, ["Ride"] = 26.92, ["Neon"] = 36.42, ["Neon|Ride"] = 125.55, ["Neon|Fly|Ride"] = 704.57, ["Mega"] = 439.03, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://16441364976"] = {name = "Gold Mahi Mahi", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 18.16, ["Fly|Ride"] = 55.2, ["Neon"] = 4.72, ["Neon|Fly"] = 31.18, ["Neon|Ride"] = 24.97, ["Mega"] = 41.99, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 311.58}},
    ["rbxassetid://8077189117"] = {name = "Puffin", prices = {["default"] = 224.32, ["Ride"] = 258.57, ["Fly|Ride"] = 233.63, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1149.69, ["Mega"] = 8308.43, ["Mega|Fly|Ride"] = 5480.08}},
    ["rbxassetid://8663441120"] = {name = "Lunar Tiger", prices = {["default"] = 2.1, ["Fly"] = 15.44, ["Ride"] = 14.8, ["Fly|Ride"] = 35.33, ["Neon"] = 4.58, ["Neon|Fly"] = 28.06, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 51.95, ["Mega"] = 35.33, ["Mega|Ride"] = 51.56, ["Mega|Fly|Ride"] = 111.57}},
    ["rbxassetid://17174216294"] = {name = "Skunk", prices = {["default"] = 9.08, ["Ride"] = 86.67, ["Fly|Ride"] = 131.25, ["Neon"] = 59.07, ["Neon|Ride"] = 100.66, ["Mega"] = 375.98, ["Mega|Fly|Ride"] = 464.35}},
    ["rbxassetid://13981141292"] = {name = "Kiwi", prices = {["default"] = 39.38, ["Fly"] = 210, ["Ride"] = 124.69, ["Fly|Ride"] = 105, ["Neon"] = 262.5, ["Neon|Ride"] = 311.93, ["Mega"] = 829.82, ["Mega|Ride"] = 858.89, ["Mega|Fly|Ride"] = 920.17}},
    ["rbxassetid://3409443617"] = {name = "Meerkat", prices = {["default"] = 160.68, ["Fly"] = 306.38, ["Ride"] = 235.09, ["Fly|Ride"] = 335.24, ["Neon"] = 783.24, ["Neon|Ride"] = 699.57, ["Neon|Fly|Ride"] = 727.02, ["Mega|Ride"] = 3323.38, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://99042906016947"] = {name = "Seafoam Butterfly", prices = {["Fly"] = 168.88, ["Ride"] = 36.3, ["Fly|Ride"] = 140.93, ["Neon"] = 65.63, ["Neon|Ride"] = 277.31, ["Mega"] = 286.79, ["Mega|Ride"] = 346.89, ["Mega|Fly|Ride"] = 431.02}},
    ["rbxassetid://15504847683"] = {name = "Gingerbread Hare", prices = {["default"] = 27.98, ["Ride"] = 125.66, ["Fly|Ride"] = 623.15, ["Neon"] = 1453.98, ["Neon|Ride"] = 192.94, ["Mega"] = 828.78, ["Mega|Ride"] = 1661.7, ["Mega|Fly|Ride"] = 2077.11}},
    ["rbxassetid://15302316802"] = {name = "Peppermint Penguin", prices = {["default"] = 1207.5, ["Fly"] = 1457.1, ["Ride"] = 1155, ["Fly|Ride"] = 1393.84, ["Neon|Ride"] = 4431.51, ["Neon|Fly|Ride"] = 4200, ["Mega|Fly|Ride"] = 17169.34}},
    ["rbxassetid://10318106124"] = {name = "Scarlet Butterfly", prices = {["default"] = 15.31, ["Fly"] = 21, ["Ride"] = 26.25, ["Fly|Ride"] = 63, ["Neon"] = 180.72, ["Neon|Fly"] = 109.33, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 273.16, ["Mega|Ride"] = 207.73, ["Mega|Fly|Ride"] = 327.15}},
    ["rbxassetid://14145989411"] = {name = "Toy Poodle", prices = {["default"] = 9.19, ["Fly"] = 13708.89, ["Ride"] = 35.44, ["Neon"] = 29.64, ["Neon|Ride"] = 103.87, ["Neon|Fly|Ride"] = 554.6, ["Mega"] = 346.42, ["Mega|Ride"] = 207.73, ["Mega|Fly|Ride"] = 359.35}},
    ["rbxassetid://82833859118891"] = {name = "Snowy Mammoth", prices = {["default"] = 4.72, ["Fly"] = 82.06, ["Ride"] = 39.48, ["Fly|Ride"] = 69.57, ["Neon"] = 124.59, ["Mega"] = 111.14, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 485.63}},
    ["rbxassetid://12917346501"] = {name = "Happy Duckling", prices = {["default"] = 14.43, ["Fly"] = 692.73, ["Ride"] = 32.82, ["Fly|Ride"] = 78.75, ["Neon"] = 82.16, ["Neon|Ride"] = 108.05, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 328.13, ["Mega|Ride"] = 369.7, ["Mega|Fly|Ride"] = 458.01}},
    ["rbxassetid://7064993901"] = {name = "2021 Uplift Butterfly", prices = {["default"] = 3.14, ["Fly"] = 20.98, ["Ride"] = 19.02, ["Fly|Ride"] = 45.94, ["Neon"] = 22.3, ["Neon|Fly"] = 78.69, ["Neon|Ride"] = 31.29, ["Neon|Fly|Ride"] = 52.49, ["Mega"] = 145.42, ["Mega|Ride"] = 273.26, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://10926054144"] = {name = "Slug", prices = {["default"] = 2.1, ["Fly"] = 414.4, ["Ride"] = 22.33, ["Neon"] = 9.7, ["Neon|Fly"] = 13125, ["Neon|Ride"] = 68.22, ["Neon|Fly|Ride"] = 830.86, ["Mega"] = 91.24, ["Mega|Fly"] = 139.18, ["Mega|Ride"] = 191.02, ["Mega|Fly|Ride"] = 272.92}},
    ["rbxassetid://11571113906"] = {name = "Glacier Moth", prices = {["default"] = 349.13, ["Ride"] = 437.07, ["Fly|Ride"] = 595.35, ["Neon|Ride"] = 1331.69, ["Neon|Fly|Ride"] = 1355.09}},
    ["rbxassetid://73641371341710"] = {name = "Ice Cube", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 19.69, ["Fly|Ride"] = 65.44, ["Neon"] = 9.42, ["Neon|Fly"] = 83.1, ["Neon|Ride"] = 39.95, ["Mega"] = 104.35, ["Mega|Ride"] = 157.36, ["Mega|Fly|Ride"] = 245.11}},
    ["rbxassetid://13077767764"] = {name = "Eel", prices = {["default"] = 3.94, ["Ride"] = 22.23, ["Neon"] = 131.25, ["Neon|Fly"] = 196.88, ["Neon|Ride"] = 188.27, ["Mega"] = 1037.53, ["Mega|Fly|Ride"] = 311.84}},
    ["rbxassetid://134995672989153"] = {name = "Hammerhead Shark", prices = {["default"] = 26.17, ["Fly"] = 84.16, ["Ride"] = 18.38, ["Fly|Ride"] = 105, ["Neon"] = 12.48, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 84.94, ["Mega|Ride"] = 246.75, ["Mega|Fly|Ride"] = 340.6}},
    ["rbxassetid://15555939727"] = {name = "Snow Monkey", prices = {["default"] = 257.59, ["Ride"] = 240.76, ["Fly|Ride"] = 692.73, ["Neon"] = 967.94, ["Neon|Ride"] = 945, ["Neon|Fly|Ride"] = 1050, ["Mega|Ride"] = 4293.38, ["Mega|Fly|Ride"] = 2625}},
    ["rbxassetid://11758575992"] = {name = "Water Rabbit", prices = {["default"] = 26.03, ["Fly"] = 52.06, ["Ride"] = 39.38, ["Fly|Ride"] = 65.63, ["Neon"] = 116.81, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 725.73, ["Mega|Ride"] = 525, ["Mega|Fly|Ride"] = 725.82}},
    ["rbxassetid://90987982535884"] = {name = "Great Pyrenees", prices = {["default"] = 15.75, ["Ride"] = 41.56, ["Fly|Ride"] = 139.18, ["Neon"] = 124.68, ["Neon|Ride"] = 132.5, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 501.21, ["Mega|Ride"] = 420, ["Mega|Fly|Ride"] = 472.47}},
    ["rbxassetid://84560154336174"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.51, ["Neon|Ride"] = 43.28, ["Mega"] = 25.79, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://4506847061"] = {name = "Reindeer", prices = {["default"] = 74.82, ["Fly"] = 5871.59, ["Ride"] = 124.65, ["Fly|Ride"] = 220.85, ["Neon"] = 318.94, ["Neon|Fly"] = 469.74, ["Neon|Ride"] = 412.2, ["Neon|Fly|Ride"] = 328.1, ["Mega|Fly|Ride"] = 1048.69}},
    ["rbxassetid://98687388677942"] = {name = "Moonpine", prices = {["default"] = 2.1, ["Ride"] = 18.64, ["Fly|Ride"] = 69.6, ["Neon"] = 4.17, ["Neon|Ride"] = 55.49, ["Neon|Fly|Ride"] = 588, ["Mega"] = 46.98, ["Mega|Fly|Ride"] = 414.4}},
    ["rbxassetid://11109032702"] = {name = "Green Amazon", prices = {["default"] = 26.94, ["Fly"] = 125.66, ["Ride"] = 31.18, ["Fly|Ride"] = 64.97, ["Neon"] = 56.02, ["Neon|Ride"] = 123.38, ["Neon|Fly|Ride"] = 248.07, ["Mega"] = 382.05, ["Mega|Ride"] = 405.57, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://3743730108"] = {name = "Black Panther", prices = {["default"] = 45.3, ["Fly"] = 110.06, ["Ride"] = 78.75, ["Fly|Ride"] = 117.36, ["Neon"] = 301.2, ["Neon|Ride"] = 288.75, ["Neon|Fly|Ride"] = 353.12, ["Mega|Ride"] = 1328.32, ["Mega|Fly|Ride"] = 1089.97}},
    ["rbxassetid://3181727398"] = {name = "Chocolate Labrador", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 14.6, ["Fly|Ride"] = 29.93, ["Neon"] = 2.52, ["Neon|Fly"] = 27.75, ["Neon|Ride"] = 16.69, ["Neon|Fly|Ride"] = 49.87, ["Mega"] = 31.71, ["Mega|Fly"] = 55.2, ["Mega|Ride"] = 40.69, ["Mega|Fly|Ride"] = 87.84}},
    ["rbxassetid://134636987874448"] = {name = "Nebula Snake", prices = {["default"] = 4.24, ["Ride"] = 33.57, ["Fly|Ride"] = 1346.59, ["Neon"] = 23.71, ["Neon|Ride"] = 60.25, ["Neon|Fly|Ride"] = 168, ["Mega"] = 472.5, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 420}},
    ["rbxassetid://13104122150"] = {name = "Hippo", prices = {["default"] = 104.9, ["Fly"] = 139.18, ["Ride"] = 49.88, ["Neon"] = 103.68, ["Neon|Ride"] = 143.35, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 586.69, ["Mega|Ride"] = 519.74, ["Mega|Fly|Ride"] = 623.15}},
    ["rbxassetid://103821295208934"] = {name = "Black Rhino", prices = {["default"] = 2.1, ["Ride"] = 26.78, ["Neon"] = 2.1, ["Neon|Ride"] = 18.37, ["Neon|Fly|Ride"] = 95.8, ["Mega"] = 28.06, ["Mega|Ride"] = 137.82, ["Mega|Fly|Ride"] = 207.73}},
    ["rbxassetid://14782580070"] = {name = "Undead Elk", prices = {["default"] = 11.45, ["Ride"] = 42, ["Fly|Ride"] = 120.75, ["Neon"] = 84.71, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 187.89, ["Mega"] = 554.6, ["Mega|Fly"] = 787.5, ["Mega|Ride"] = 304.2, ["Mega|Fly|Ride"] = 406.86}},
    ["rbxassetid://8566683782"] = {name = "Giant Blue Scarab", prices = {["default"] = 20.89, ["Fly"] = 41.27, ["Ride"] = 27.65, ["Fly|Ride"] = 45.94, ["Neon"] = 202.07, ["Neon|Ride"] = 72.19, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 310.54, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 656.25}},
    ["rbxassetid://14850232913"] = {name = "Cute-A-Cabra", prices = {["default"] = 2.19, ["Ride"] = 52.49, ["Fly|Ride"] = 76.02, ["Neon"] = 39.08, ["Neon|Fly"] = 699.57, ["Neon|Ride"] = 65.61, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 129.94, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 326.12}},
    ["rbxassetid://15508248825"] = {name = "Eggnog Dog", prices = {["default"] = 27.02, ["Fly"] = 2077.11, ["Ride"] = 93.17, ["Neon"] = 219.59, ["Neon|Ride"] = 144.38, ["Neon|Fly|Ride"] = 6262.23, ["Mega"] = 413.36, ["Mega|Ride"] = 485.01, ["Mega|Fly|Ride"] = 546.67}},
    ["rbxassetid://17822797244"] = {name = "Orange Betta Fish", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 137.62, ["Fly|Ride"] = 196.87, ["Neon"] = 8.99, ["Neon|Fly"] = 56.1, ["Neon|Ride"] = 68.83, ["Mega"] = 68.25, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 122.14, ["Mega|Fly|Ride"] = 272.27}},
    ["rbxassetid://9922274393"] = {name = "Retired Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://103431939950304"] = {name = "Pink Dog", prices = {["default"] = 2.1, ["Ride"] = 77.52, ["Neon"] = 3.59, ["Neon|Ride"] = 26.25, ["Mega"] = 26.25, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 207.19}},
    ["rbxassetid://15227882502"] = {name = "Christmas Future Egg", prices = {["default"] = 29.56}},
    ["rbxassetid://12597276740"] = {name = "Red Sand Dollar", prices = {["default"] = 46.99, ["Fly"] = 102.38, ["Ride"] = 78.69, ["Fly|Ride"] = 207.73, ["Neon"] = 204.33, ["Neon|Ride"] = 204.53, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 1237.98, ["Mega|Ride"] = 787.5, ["Mega|Fly|Ride"] = 836.21}},
    ["rbxassetid://136447612467002"] = {name = "Glyptodon Ducky", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 3.92, ["Mega"] = 27.57, ["Mega|Ride"] = 166.19, ["Mega|Fly|Ride"] = 149.63}},
    ["rbxassetid://101033810950061"] = {name = "Sea Slug", prices = {["default"] = 458.07, ["Ride"] = 446.25, ["Fly|Ride"] = 641.82, ["Neon"] = 2625, ["Neon|Fly|Ride"] = 2072.96, ["Mega"] = 16616.84, ["Mega|Fly|Ride"] = 15750}},
    ["rbxassetid://14353536658"] = {name = "Birthday Butterfly 2023", prices = {["default"] = 2.45, ["Fly"] = 26.25, ["Ride"] = 39.37, ["Fly|Ride"] = 89.33, ["Neon"] = 13.13, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 129.94, ["Mega"] = 67.08, ["Mega|Ride"] = 139.19, ["Mega|Fly|Ride"] = 164.41}},
    ["rbxassetid://9938967851"] = {name = "Tan Chow-Chow", prices = {["default"] = 6.18, ["Fly"] = 152.86, ["Ride"] = 18.72, ["Fly|Ride"] = 61.69, ["Neon"] = 9.19, ["Neon|Ride"] = 38.07, ["Neon|Fly|Ride"] = 99.65, ["Mega"] = 137.82, ["Mega|Ride"] = 176.57, ["Mega|Fly|Ride"] = 306.38}},
    ["rbxassetid://14448124117"] = {name = "Chipmunk", prices = {["default"] = 11.82, ["Fly"] = 77.9, ["Ride"] = 72.19, ["Fly|Ride"] = 519.29, ["Neon"] = 78.75, ["Neon|Ride"] = 180.86, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 518.25, ["Mega|Ride"] = 397.38, ["Mega|Fly|Ride"] = 671.96}},
    ["rbxassetid://13104108894"] = {name = "Lammergeier", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 31.83, ["Neon"] = 54.02, ["Mega"] = 255.94}},
    ["rbxassetid://14446659851"] = {name = "Raccoon", prices = {["default"] = 7.87, ["Fly"] = 43.16, ["Ride"] = 92.09, ["Fly|Ride"] = 157.49, ["Neon"] = 52.5, ["Neon|Ride"] = 91.88, ["Neon|Fly|Ride"] = 359, ["Mega|Ride"] = 460.3, ["Mega|Fly|Ride"] = 970.02}},
    ["rbxassetid://84477079324217"] = {name = "Peachick", prices = {["default"] = 15.6, ["Fly"] = 104.99, ["Ride"] = 23.9, ["Fly|Ride"] = 186.96, ["Neon"] = 55.48, ["Neon|Ride"] = 66.09, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 216.47, ["Mega|Fly"] = 479.82, ["Mega|Ride"] = 230.57}},
    ["rbxassetid://9718162456"] = {name = "Donkey", prices = {["default"] = 2.1, ["Fly"] = 26.17, ["Ride"] = 13.5, ["Fly|Ride"] = 66.94, ["Neon"] = 2.1, ["Neon|Fly"] = 41.99, ["Neon|Ride"] = 14.84, ["Neon|Fly|Ride"] = 75.28, ["Mega"] = 15.75, ["Mega|Fly"] = 61.07, ["Mega|Ride"] = 51.59, ["Mega|Fly|Ride"] = 78.66}},
    ["rbxassetid://93800993117604"] = {name = "Love Bird", prices = {["default"] = 8.26, ["Fly"] = 277.31, ["Ride"] = 27.57, ["Fly|Ride"] = 157.36, ["Neon"] = 22.32, ["Neon|Fly"] = 117.45, ["Neon|Ride"] = 69.6, ["Neon|Fly|Ride"] = 110.4, ["Mega"] = 144.38, ["Mega|Fly"] = 206.69, ["Mega|Ride"] = 167.99, ["Mega|Fly|Ride"] = 401.93}},
    ["rbxassetid://13665143675"] = {name = "Lion Cub", prices = {["default"] = 262.49, ["Fly"] = 401.93, ["Ride"] = 315, ["Fly|Ride"] = 379.98, ["Neon"] = 1246.28, ["Neon|Ride"] = 1242.13, ["Neon|Fly|Ride"] = 1039.5, ["Mega|Fly|Ride"] = 4223.81}},
    ["rbxassetid://13883284001"] = {name = "Ice Cream Hermit Crab", prices = {["default"] = 78.74, ["Ride"] = 137.27, ["Fly|Ride"] = 298.08, ["Neon"] = 601.33, ["Neon|Ride"] = 414.75, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 4154.22, ["Mega|Ride"] = 2077.11, ["Mega|Fly|Ride"] = 1701}},
    ["rbxassetid://8938701212"] = {name = "Woodpecker", prices = {["default"] = 2.1, ["Fly"] = 16.72, ["Ride"] = 15.1, ["Fly|Ride"] = 39.38, ["Neon"] = 135.17, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 33.25, ["Neon|Fly|Ride"] = 62.56, ["Mega"] = 60.25, ["Mega|Fly"] = 206.69, ["Mega|Ride"] = 124.65, ["Mega|Fly|Ride"] = 166.19}},
    ["rbxassetid://4800190034"] = {name = "Toucan", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 14.6, ["Fly|Ride"] = 22.33, ["Neon"] = 6.46, ["Neon|Fly"] = 39.38, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 55.11, ["Mega"] = 85.32, ["Mega|Fly"] = 346.89, ["Mega|Ride"] = 72.19, ["Mega|Fly|Ride"] = 150.93}},
    ["rbxassetid://15886122789"] = {name = "Deathstalker Scorpion", prices = {["default"] = 2.63, ["Ride"] = 15.6, ["Fly|Ride"] = 98.44, ["Neon"] = 38.07, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 139.18, ["Mega|Ride"] = 139.18}},
    ["rbxassetid://12139402705"] = {name = "Sheeeeep", prices = {["default"] = 248.07, ["Fly"] = 420, ["Ride"] = 262.5, ["Fly|Ride"] = 328.13, ["Neon|Ride"] = 941.98, ["Neon|Fly|Ride"] = 1323.13, ["Mega|Ride"] = 8308.43, ["Mega|Fly|Ride"] = 3675}},
    ["rbxassetid://7126720389"] = {name = "Hydra", prices = {["default"] = 2.1, ["Fly"] = 19.29, ["Ride"] = 16.61, ["Fly|Ride"] = 40.69, ["Neon"] = 14.44, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 156.95, ["Mega"] = 224.44, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 341.24}},
    ["rbxassetid://17662289865"] = {name = "Punk Pony", prices = {["default"] = 3.03, ["Fly"] = 157.37, ["Ride"] = 96.48, ["Fly|Ride"] = 207.73, ["Neon"] = 31.06, ["Neon|Ride"] = 35.44, ["Mega"] = 247.19, ["Mega|Ride"] = 259.87, ["Mega|Fly|Ride"] = 301.88}},
    ["rbxassetid://84009422958505"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.34, ["Neon|Ride"] = 131.23, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://9473352533"] = {name = "Space Whale", prices = {["default"] = 21, ["Ride"] = 23.63, ["Fly|Ride"] = 57.23, ["Neon"] = 78.4, ["Neon|Ride"] = 90.36, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 728.44, ["Mega|Ride"] = 501.38, ["Mega|Fly|Ride"] = 590.52}},
    ["rbxassetid://71528203783155"] = {name = "Pupcake", prices = {["default"] = 76.13, ["Fly"] = 114.19, ["Ride"] = 65.63, ["Fly|Ride"] = 209.99, ["Neon"] = 187.89, ["Neon|Fly"] = 393.75, ["Neon|Ride"] = 216.44, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 457.8, ["Mega|Fly"] = 2180.97, ["Mega|Ride"] = 459.37, ["Mega|Fly|Ride"] = 551.25}},
    ["rbxassetid://4440867010"] = {name = "Drake", prices = {["default"] = 21.94, ["Fly"] = 68.25, ["Ride"] = 32.82, ["Fly|Ride"] = 92.67, ["Neon"] = 118.16, ["Neon|Fly"] = 290.07, ["Neon|Ride"] = 137.62, ["Neon|Fly|Ride"] = 189.58, ["Mega|Ride"] = 692.73, ["Mega|Fly|Ride"] = 746.74}},
    ["rbxassetid://9708962205"] = {name = "Parakeet", prices = {["default"] = 2.1, ["Fly"] = 20.79, ["Ride"] = 14.86, ["Fly|Ride"] = 31.71, ["Neon"] = 2.1, ["Neon|Fly"] = 19.83, ["Neon|Ride"] = 15.74, ["Neon|Fly|Ride"] = 61.29, ["Mega"] = 24.65, ["Mega|Fly"] = 412.51, ["Mega|Ride"] = 40.6, ["Mega|Fly|Ride"] = 114.35}},
    ["rbxassetid://4883302468"] = {name = "Shrew", prices = {["default"] = 228.03, ["Ride"] = 292.91, ["Fly|Ride"] = 392.22, ["Neon"] = 1242.13, ["Neon|Ride"] = 950.25, ["Neon|Fly|Ride"] = 1300.69, ["Mega|Fly|Ride"] = 4401.39}},
    ["rbxassetid://11507151679"] = {name = "Irish Elk", prices = {["default"] = 14.44, ["Fly"] = 61.61, ["Ride"] = 58, ["Fly|Ride"] = 131.92, ["Neon"] = 97.13, ["Neon|Ride"] = 197.08, ["Neon|Fly|Ride"] = 328.12, ["Mega"] = 415.44, ["Mega|Ride"] = 410.25, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://17163957321"] = {name = "Blue Jay", prices = {["default"] = 2.1, ["Fly"] = 32.38, ["Ride"] = 16.19, ["Fly|Ride"] = 39.38, ["Neon"] = 9.4, ["Neon|Ride"] = 24.04, ["Neon|Fly|Ride"] = 110.1, ["Mega"] = 59.14, ["Mega|Fly"] = 277.31, ["Mega|Ride"] = 144.38, ["Mega|Fly|Ride"] = 269}},
    ["rbxassetid://8705079225"] = {name = "Abyssinian Cat", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Ride"] = 18.72, ["Fly|Ride"] = 55.47, ["Neon"] = 3.65, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 22.85, ["Neon|Fly|Ride"] = 102.33, ["Mega"] = 26.13, ["Mega|Fly"] = 139.18, ["Mega|Ride"] = 48.7, ["Mega|Fly|Ride"] = 165.15}},
    ["rbxassetid://17059483392"] = {name = "Velociraptor", prices = {["default"] = 2.63, ["Ride"] = 28.77, ["Fly|Ride"] = 69.27, ["Neon"] = 10.28, ["Neon|Ride"] = 63.42, ["Neon|Fly|Ride"] = 110.4, ["Mega"] = 129.94, ["Mega|Ride"] = 128.63, ["Mega|Fly|Ride"] = 373.9}},
    ["rbxassetid://16548686870"] = {name = "Hamster", prices = {["default"] = 9.39, ["Fly"] = 38.72, ["Ride"] = 23.81, ["Fly|Ride"] = 68.25, ["Neon"] = 44.63, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 123.37, ["Mega"] = 328.37, ["Mega|Ride"] = 314.9, ["Mega|Fly|Ride"] = 343.87}},
    ["rbxassetid://13883285383"] = {name = "Castle Hermit Crab", prices = {["default"] = 7.88, ["Fly"] = 56.1, ["Ride"] = 26.25, ["Fly|Ride"] = 72.19, ["Neon"] = 45.94, ["Neon|Ride"] = 137.11, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 321.97, ["Mega|Ride"] = 364.02, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://82240382561696"] = {name = "Cocoadile", prices = {["default"] = 2.1, ["Neon"] = 3.84, ["Neon|Ride"] = 38.45, ["Neon|Fly|Ride"] = 99.75, ["Mega"] = 27.02, ["Mega|Ride"] = 63, ["Mega|Fly|Ride"] = 127.32}},
    ["rbxassetid://74702714943302"] = {name = "Grave Owl", prices = {["default"] = 7.87, ["Ride"] = 24.93, ["Fly|Ride"] = 69.6, ["Neon"] = 28.85, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 31.18, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 157.5, ["Mega|Ride"] = 212.62, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://97556530589327"] = {name = "Bison", prices = {["default"] = 2.1, ["Ride"] = 108.65, ["Neon"] = 3.84, ["Neon|Fly"] = 97.63, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 102.3, ["Mega"] = 24.19, ["Mega|Ride"] = 91.35, ["Mega|Fly|Ride"] = 313.53}},
    ["rbxassetid://11694855214"] = {name = "Shetland Pony Dark Brown", prices = {["default"] = 2.1, ["Fly"] = 36.52, ["Ride"] = 17.62, ["Fly|Ride"] = 118.13, ["Neon"] = 6.19, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 68.56, ["Mega"] = 47.16, ["Mega|Ride"] = 78.75, ["Mega|Fly|Ride"] = 204}},
    ["rbxassetid://14398823196"] = {name = "Alpaca", prices = {["default"] = 656.25, ["Ride"] = 689.07, ["Fly|Ride"] = 735, ["Neon"] = 3633.91, ["Neon|Ride"] = 2625, ["Neon|Fly|Ride"] = 3192, ["Mega|Fly|Ride"] = 12750.83}},
    ["rbxassetid://5721843716"] = {name = "Pterodactyl", prices = {["default"] = 2.1, ["Fly"] = 15.57, ["Ride"] = 14.84, ["Fly|Ride"] = 34.13, ["Neon"] = 15.6, ["Neon|Fly"] = 33.03, ["Neon|Ride"] = 40.52, ["Neon|Fly|Ride"] = 43.32, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 236.25}},
    ["rbxassetid://82057257613990"] = {name = "Unicorn Ducky", prices = {["default"] = 2.1, ["Ride"] = 35.33, ["Fly|Ride"] = 164.11, ["Neon"] = 14.44, ["Neon|Fly"] = 830.86, ["Neon|Ride"] = 41.99, ["Neon|Fly|Ride"] = 137.82, ["Mega"] = 56.44, ["Mega|Fly"] = 157.36, ["Mega|Ride"] = 115.77, ["Mega|Fly|Ride"] = 220.49}},
    ["rbxassetid://4708551366"] = {name = "Frog", prices = {["default"] = 12.48, ["Fly"] = 32.7, ["Ride"] = 21.08, ["Fly|Ride"] = 60.38, ["Neon"] = 47.15, ["Neon|Fly"] = 123.22, ["Neon|Ride"] = 48.26, ["Neon|Fly|Ride"] = 101, ["Mega|Ride"] = 308.44, ["Mega|Fly|Ride"] = 366.19}},
    ["rbxassetid://4800189682"] = {name = "Starfish", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.67, ["Fly|Ride"] = 32.92, ["Neon"] = 15.49, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 58.97, ["Mega"] = 103.87, ["Mega|Ride"] = 52.49, ["Mega|Fly|Ride"] = 196.1}},
    ["rbxassetid://16736753854"] = {name = "Candy Cane Snail", prices = {["default"] = 31.73, ["Ride"] = 139.18, ["Fly|Ride"] = 206.69, ["Neon"] = 255.94, ["Neon|Ride"] = 257.44, ["Mega"] = 896.44, ["Mega|Ride"] = 1103.78}},
    ["rbxassetid://10393730410"] = {name = "Orca", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Neon"] = 4.73, ["Neon|Fly"] = 133.89, ["Neon|Ride"] = 36.75, ["Neon|Fly|Ride"] = 118.23, ["Mega"] = 59.07, ["Mega|Ride"] = 113.99, ["Mega|Fly|Ride"] = 354.38}},
    ["rbxassetid://111642509798043"] = {name = "Toxic Kaijunior", prices = {["default"] = 3.84, ["Fly"] = 73.5, ["Ride"] = 20.23, ["Fly|Ride"] = 65.63, ["Neon"] = 8.33, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 62.33, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 105, ["Mega|Ride"] = 219.75, ["Mega|Fly|Ride"] = 164.07}},
    ["rbxassetid://14146181621"] = {name = "Tawny Frogmouth", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Neon"] = 15.16, ["Neon|Fly"] = 63.42, ["Mega"] = 104.35, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://9474010501"] = {name = "Ribbon Seal", prices = {["default"] = 2.1, ["Fly"] = 65.63, ["Ride"] = 18.38, ["Fly|Ride"] = 88.33, ["Neon"] = 3.94, ["Neon|Fly"] = 31.5, ["Neon|Ride"] = 21.14, ["Neon|Fly|Ride"] = 65.02, ["Mega"] = 89.25, ["Mega|Fly"] = 199.42, ["Mega|Ride"] = 60.38, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://6776872152"] = {name = "Red Squirrel", prices = {["default"] = 14.15, ["Fly"] = 65.63, ["Ride"] = 22.31, ["Fly|Ride"] = 41.56, ["Neon"] = 137.65, ["Neon|Ride"] = 105, ["Neon|Fly|Ride"] = 122.07, ["Mega"] = 830.86, ["Mega|Ride"] = 518.25, ["Mega|Fly|Ride"] = 450.75}},
    ["rbxassetid://84140820920420"] = {name = "Siamese Cat", prices = {["default"] = 763.58, ["Ride"] = 812.64, ["Fly|Ride"] = 925.32, ["Neon"] = 1837.5, ["Neon|Ride"] = 1947.77, ["Neon|Fly|Ride"] = 1968.75, ["Mega"] = 8292.01, ["Mega|Ride"] = 7612.5, ["Mega|Fly|Ride"] = 6247.49}},
    ["rbxassetid://3181727773"] = {name = "Bunny", prices = {["default"] = 2.09, ["Fly"] = 15.6, ["Ride"] = 15.11, ["Fly|Ride"] = 26.25, ["Neon"] = 8.27, ["Neon|Fly"] = 139.19, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 60.34, ["Mega"] = 83.1, ["Mega|Ride"] = 81.02, ["Mega|Fly|Ride"] = 135.18}},
    ["rbxassetid://17120012859"] = {name = "Praying Mantis", prices = {["default"] = 4.81, ["Ride"] = 38.67, ["Fly|Ride"] = 117.44, ["Neon"] = 69.29, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 115.29, ["Neon|Fly|Ride"] = 271.8, ["Mega"] = 194.22, ["Mega|Ride"] = 351.21, ["Mega|Fly|Ride"] = 485.01}},
    ["rbxassetid://4440866528"] = {name = "Turkey", prices = {["default"] = 74.79, ["Ride"] = 78.7, ["Fly|Ride"] = 104.99, ["Neon"] = 229.69, ["Neon|Ride"] = 471.52, ["Neon|Fly|Ride"] = 439.18, ["Mega"] = 3150.32, ["Mega|Fly|Ride"] = 1612.86}},
    ["rbxassetid://9287841987"] = {name = "Black Springer Spaniel", prices = {["default"] = 52.5, ["Fly"] = 137.82, ["Ride"] = 80.07, ["Fly|Ride"] = 102.79, ["Neon"] = 103.94, ["Neon|Ride"] = 213.94, ["Mega"] = 1037.53, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 729.23}},
    ["rbxassetid://87613898139280"] = {name = "Ranger Beaver", prices = {["default"] = 14.6, ["Ride"] = 24.69, ["Neon"] = 123.37, ["Neon|Ride"] = 125.78, ["Neon|Fly|Ride"] = 288.75, ["Mega"] = 346.4, ["Mega|Ride"] = 367.66, ["Mega|Fly|Ride"] = 456.75}},
    ["rbxassetid://88389663444803"] = {name = "Mirai Moth", prices = {["default"] = 30.14, ["Ride"] = 69.6, ["Neon"] = 72.19, ["Neon|Ride"] = 360.53, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 277.31, ["Mega|Fly"] = 509.63, ["Mega|Ride"] = 346.89, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://128469688002747"] = {name = "Moonlight Moth", prices = {["default"] = 28.06, ["Ride"] = 88.54, ["Neon"] = 177.19, ["Neon|Fly"] = 131.25, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 392.2, ["Mega"] = 525, ["Mega|Ride"] = 728.44, ["Mega|Fly|Ride"] = 775}},
    ["rbxassetid://13936753561"] = {name = "Dylan", prices = {["default"] = 4.86}},
    ["rbxassetid://10606175827"] = {name = "Koi Carp", prices = {["default"] = 3.71, ["Fly"] = 131248.69, ["Ride"] = 32.22, ["Fly|Ride"] = 78.75, ["Neon"] = 27.48, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 204.33, ["Mega|Fly"] = 454.63, ["Mega|Ride"] = 216.57, ["Mega|Fly|Ride"] = 257.58}},
    ["rbxassetid://84529929751558"] = {name = "Old King Coal", prices = {["default"] = 2.51, ["Neon"] = 14.43, ["Mega"] = 877.17}},
    ["rbxassetid://11706110842"] = {name = "Snowball Pet", prices = {["default"] = 102.26, ["Fly"] = 410.68, ["Ride"] = 140.93, ["Fly|Ride"] = 415.44, ["Neon"] = 281.84, ["Neon|Ride"] = 236.24, ["Neon|Fly|Ride"] = 284.73, ["Mega|Ride"] = 1661.7, ["Mega|Fly|Ride"] = 2077.11}},
    ["rbxassetid://6404812664"] = {name = "Ladybug", prices = {["default"] = 3.38, ["Fly"] = 21.83, ["Ride"] = 18.27, ["Fly|Ride"] = 32.82, ["Neon"] = 22.31, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 23.24, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 262.5, ["Mega|Fly"] = 414.4, ["Mega|Ride"] = 199.5, ["Mega|Fly|Ride"] = 280.66}},
    ["rbxassetid://95046891836017"] = {name = "Clover Cow", prices = {["default"] = 4.64, ["Fly"] = 83.1, ["Ride"] = 25.72, ["Fly|Ride"] = 76.86, ["Neon"] = 23.49, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 136.23, ["Mega"] = 146.76, ["Mega|Ride"] = 177.19, ["Mega|Fly|Ride"] = 277.37}},
    ["rbxassetid://123759251940984"] = {name = "Oakee Knight", prices = {["default"] = 2.1, ["Neon"] = 5.25, ["Neon|Ride"] = 199.64, ["Mega"] = 47.46, ["Mega|Ride"] = 96.6, ["Mega|Fly|Ride"] = 137.82}},
    ["rbxassetid://9287842106"] = {name = "Brown Springer Spaniel", prices = {["default"] = 41.97, ["Fly"] = 65.63, ["Ride"] = 60.25, ["Fly|Ride"] = 120.74, ["Neon"] = 153.56, ["Neon|Ride"] = 131.24, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 1108.14, ["Mega|Ride"] = 13848.07, ["Mega|Fly|Ride"] = 971.25}},
    ["rbxassetid://83890934284839"] = {name = "Zeopod", prices = {["default"] = 2.1, ["Ride"] = 25.03, ["Neon"] = 5.25, ["Neon|Fly"] = 291.38, ["Neon|Ride"] = 66, ["Mega"] = 90.37, ["Mega|Ride"] = 114.53, ["Mega|Fly|Ride"] = 309.68}},
    ["rbxassetid://107096792267421"] = {name = "General Sheepdog", prices = {["default"] = 10.05, ["Ride"] = 74.79, ["Fly|Ride"] = 274.2, ["Neon"] = 91.88, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 359.66, ["Mega|Ride"] = 874.13, ["Mega|Fly|Ride"] = 728.02}},
    ["rbxassetid://5721844511"] = {name = "Woolly Mammoth", prices = {["default"] = 2.1, ["Fly"] = 23.62, ["Ride"] = 15.1, ["Fly|Ride"] = 61.69, ["Neon"] = 17.49, ["Neon|Ride"] = 30.16, ["Neon|Fly|Ride"] = 59.89, ["Mega"] = 144.37, ["Mega|Ride"] = 265.89, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://8143039445"] = {name = "Summer Walrus", prices = {["default"] = 5.01, ["Fly"] = 52.49, ["Ride"] = 20.68, ["Fly|Ride"] = 53.06, ["Neon"] = 157.5, ["Neon|Ride"] = 410.78, ["Mega"] = 157.36, ["Mega|Ride"] = 277.31, ["Mega|Fly|Ride"] = 415.44}},
    ["rbxassetid://136696735147963"] = {name = "Chilling Spider", prices = {["default"] = 3.29, ["Ride"] = 46.98, ["Fly|Ride"] = 131.25, ["Neon"] = 35.33, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://133768672320906"] = {name = "Catte", prices = {["default"] = 34.73, ["Ride"] = 65.63, ["Neon"] = 229.53, ["Neon|Ride"] = 518.25, ["Neon|Fly|Ride"] = 367.5, ["Mega"] = 1181.25, ["Mega|Fly|Ride"] = 1245.57}},
    ["rbxassetid://12139319231"] = {name = "Feesh", prices = {["default"] = 18.71, ["Ride"] = 78.48, ["Fly|Ride"] = 139.18, ["Neon"] = 98.44, ["Neon|Fly|Ride"] = 145.42, ["Mega"] = 411.69, ["Mega|Ride"] = 330.27, ["Mega|Fly|Ride"] = 498.75}},
    ["rbxassetid://13685039170"] = {name = "Lobster", prices = {["default"] = 32.71, ["Fly"] = 65.63, ["Ride"] = 105, ["Fly|Ride"] = 277.31, ["Neon"] = 47.48, ["Neon|Ride"] = 105, ["Mega"] = 415.44, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 1661.7}},
    ["rbxassetid://87668315398037"] = {name = "Mecha R4BBIT", prices = {["default"] = 21, ["Ride"] = 105, ["Fly|Ride"] = 520.66, ["Neon"] = 102.83, ["Neon|Ride"] = 111.14, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 692.73, ["Mega|Ride"] = 734.93, ["Mega|Fly|Ride"] = 1149.69}},
    ["rbxassetid://120262676323297"] = {name = "Kelp Hunter", prices = {["default"] = 3.84, ["Neon"] = 105, ["Neon|Ride"] = 277.31, ["Mega"] = 157.88, ["Mega|Ride"] = 223.13, ["Mega|Fly|Ride"] = 313.53}},
    ["rbxassetid://12403864254"] = {name = "Gorilla", prices = {["default"] = 2.1, ["Fly"] = 26.24, ["Ride"] = 17.46, ["Fly|Ride"] = 56.1, ["Neon"] = 6.18, ["Neon|Fly"] = 43.02, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 76.13, ["Mega"] = 49.29, ["Mega|Ride"] = 86.21, ["Mega|Fly|Ride"] = 148.28}},
    ["rbxassetid://124908510040897"] = {name = "Mistletroll", prices = {["default"] = 3.94, ["Ride"] = 76.13, ["Fly|Ride"] = 68.25, ["Neon"] = 56.95, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 109.62, ["Mega"] = 191.63, ["Mega|Ride"] = 277.31, ["Mega|Fly|Ride"] = 397.57}},
    ["rbxassetid://11189235896"] = {name = "Persian Cat", prices = {["default"] = 2.1, ["Fly"] = 29.71, ["Ride"] = 17.73, ["Fly|Ride"] = 41.56, ["Neon"] = 4.17, ["Neon|Ride"] = 19.69, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 55.12, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 124.68}},
    ["rbxassetid://14457148635"] = {name = "Magma Snail", prices = {["default"] = 2.1, ["Ride"] = 28.06, ["Fly|Ride"] = 68.25, ["Neon"] = 13.92, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 249.38, ["Mega|Ride"] = 170.63, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://11694853423"] = {name = "Shetland Pony White", prices = {["default"] = 5.25, ["Ride"] = 31.5, ["Fly|Ride"] = 97.63, ["Neon"] = 29.29, ["Neon|Fly"] = 315, ["Neon|Ride"] = 102.83, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 302.45, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 1038.57}},
    ["rbxassetid://4621220568"] = {name = "Rat", prices = {["default"] = 5.13, ["Fly"] = 131.25, ["Ride"] = 25.18, ["Fly|Ride"] = 41, ["Neon"] = 20.54, ["Neon|Fly"] = 111.53, ["Neon|Ride"] = 40.72, ["Neon|Fly|Ride"] = 65.63, ["Mega|Ride"] = 254.67, ["Mega|Fly|Ride"] = 227.33}},
    ["rbxassetid://8938702150"] = {name = "Pine Marten", prices = {["default"] = 2.1, ["Fly"] = 34.41, ["Ride"] = 22.32, ["Fly|Ride"] = 39.38, ["Neon"] = 17.07, ["Neon|Fly"] = 83.1, ["Neon|Ride"] = 40.52, ["Neon|Fly|Ride"] = 103.87, ["Mega"] = 168, ["Mega|Ride"] = 229.53}},
    ["rbxassetid://120359009390464"] = {name = "Turtle Doves", prices = {["default"] = 9.09, ["Fly"] = 301.87, ["Ride"] = 43.32, ["Fly|Ride"] = 179.82, ["Neon"] = 27.02, ["Neon|Fly"] = 170.47, ["Neon|Ride"] = 56.1, ["Neon|Fly|Ride"] = 196.1, ["Mega"] = 219.59, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://71032455578324"] = {name = "Chihuahua", prices = {["default"] = 8.33, ["Fly"] = 139.18, ["Ride"] = 103.69, ["Fly|Ride"] = 255.13, ["Neon"] = 85.32, ["Neon|Ride"] = 271.28, ["Neon|Fly|Ride"] = 469.71, ["Mega"] = 393.75, ["Mega|Ride"] = 509, ["Mega|Fly|Ride"] = 628.69}},
    ["rbxassetid://11505487641"] = {name = "Ram", prices = {["default"] = 55.13, ["Ride"] = 109.91, ["Fly|Ride"] = 191.63, ["Neon"] = 246.88, ["Neon|Fly"] = 382.2, ["Neon|Ride"] = 263.82, ["Neon|Fly|Ride"] = 401.93, ["Mega"] = 1217.2, ["Mega|Ride"] = 1063.13, ["Mega|Fly|Ride"] = 1191.48}},
    ["rbxassetid://117821626163847"] = {name = "Chanekeh", prices = {["default"] = 2.1, ["Fly"] = 51.09, ["Ride"] = 18.38, ["Fly|Ride"] = 65.63, ["Neon"] = 3.29, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 55.2, ["Mega"] = 28.06, ["Mega|Ride"] = 68.81, ["Mega|Fly|Ride"] = 130.62}},
    ["rbxassetid://14266737982"] = {name = "Cassowary", prices = {["default"] = 32.38, ["Mega"] = 908.92, ["Mega|Ride"] = 829.82, ["Mega|Fly|Ride"] = 1246.28}},
    ["rbxassetid://13693650831"] = {name = "Leopard Shark", prices = {["default"] = 48.2, ["Fly"] = 105, ["Ride"] = 94.53, ["Neon"] = 293.57, ["Neon|Ride"] = 196.88, ["Neon|Fly|Ride"] = 469.71, ["Mega"] = 1692.86, ["Mega|Ride"] = 1100.88, ["Mega|Fly|Ride"] = 1252.9}},
    ["rbxassetid://100909868233186"] = {name = "Kappakid", prices = {["default"] = 6.45, ["Fly"] = 190.32, ["Ride"] = 34.2, ["Fly|Ride"] = 125.99, ["Neon"] = 26.25, ["Neon|Ride"] = 65.63, ["Mega"] = 277.31, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 326.82}},
    ["rbxassetid://127061844219486"] = {name = "Patchy Bear", prices = {["default"] = 3.29, ["Ride"] = 110.44, ["Fly|Ride"] = 137.45, ["Neon"] = 5.25, ["Neon|Ride"] = 32, ["Mega"] = 53.27, ["Mega|Fly"] = 262.5, ["Mega|Ride"] = 62.84, ["Mega|Fly|Ride"] = 118.02}},
    ["rbxassetid://6998402749"] = {name = "Merhorse", prices = {["default"] = 2.1, ["Fly"] = 35.09, ["Ride"] = 17.06, ["Fly|Ride"] = 46.4, ["Neon"] = 13.05, ["Neon|Fly"] = 27.19, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 102.18, ["Mega"] = 194.22, ["Mega|Fly"] = 346.89, ["Mega|Ride"] = 312.36, ["Mega|Fly|Ride"] = 173.82}},
    ["rbxassetid://3181727196"] = {name = "Beaver", prices = {["default"] = 2.1, ["Fly"] = 15.75, ["Ride"] = 15.56, ["Fly|Ride"] = 31.68, ["Neon"] = 2.63, ["Neon|Ride"] = 27.56, ["Neon|Fly|Ride"] = 52.48, ["Mega"] = 24.94, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://10377935981"] = {name = "Badger", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 72.77, ["Neon"] = 5.58, ["Neon|Ride"] = 20.64, ["Neon|Fly|Ride"] = 83.1, ["Mega"] = 54, ["Mega|Fly"] = 168, ["Mega|Ride"] = 62.33, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://118143096743818"] = {name = "Granny Wolf", prices = {["default"] = 2.1, ["Ride"] = 52.49, ["Fly|Ride"] = 157.36, ["Neon"] = 2.63, ["Neon|Ride"] = 36.37, ["Mega"] = 21.66, ["Mega|Fly|Ride"] = 275.63}},
    ["rbxassetid://18819382634"] = {name = "Singularity Beetle", prices = {["default"] = 5.22, ["Ride"] = 44.67, ["Neon"] = 36.98, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 139.13, ["Mega|Ride"] = 231, ["Mega|Fly|Ride"] = 230.86}},
    ["rbxassetid://13664716167"] = {name = "Ostrich", prices = {["default"] = 5.15, ["Ride"] = 37.41, ["Fly|Ride"] = 189.96, ["Neon"] = 71.93, ["Neon|Ride"] = 103.87, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 405.05, ["Mega|Ride"] = 304.5, ["Mega|Fly|Ride"] = 393.75}},
    ["rbxassetid://3710822879"] = {name = "Penguin", prices = {["default"] = 6.8, ["Fly"] = 19.69, ["Ride"] = 21.84, ["Fly|Ride"] = 58.07, ["Neon"] = 34.64, ["Neon|Fly"] = 65.54, ["Neon|Ride"] = 37.32, ["Neon|Fly|Ride"] = 91.75, ["Mega|Ride"] = 277.31, ["Mega|Fly|Ride"] = 360.94}},
    ["rbxassetid://12778628745"] = {name = "Chef Gorilla", prices = {["default"] = 51.35, ["Ride"] = 193.18, ["Fly|Ride"] = 262.5, ["Neon"] = 346.89, ["Neon|Ride"] = 597.19, ["Neon|Fly|Ride"] = 634.57, ["Mega|Fly|Ride"] = 1771.88}},
    ["rbxassetid://138841259551372"] = {name = "Vermilion Butterfly", prices = {["default"] = 15.65, ["Fly"] = 71.73, ["Ride"] = 32.82, ["Fly|Ride"] = 124.65, ["Neon"] = 66.48, ["Mega"] = 627.05, ["Mega|Ride"] = 830.82}},
    ["rbxassetid://3181727125"] = {name = "Snow Puma", prices = {["default"] = 2.1, ["Fly"] = 18.72, ["Ride"] = 16.26, ["Fly|Ride"] = 49.87, ["Neon"] = 2.51, ["Neon|Fly"] = 28, ["Neon|Ride"] = 20.63, ["Neon|Fly|Ride"] = 51.18, ["Mega"] = 36.37, ["Mega|Ride"] = 94.5, ["Mega|Fly|Ride"] = 183.75}},
    ["rbxassetid://3181728160"] = {name = "Shiba Inu", prices = {["default"] = 2.1, ["Fly"] = 31.18, ["Ride"] = 14.79, ["Fly|Ride"] = 31.24, ["Neon"] = 4.71, ["Neon|Fly"] = 25.72, ["Neon|Ride"] = 19.04, ["Neon|Fly|Ride"] = 32.82, ["Mega"] = 44.62, ["Mega|Fly"] = 73.76, ["Mega|Ride"] = 47.24, ["Mega|Fly|Ride"] = 103.42}},
    ["rbxassetid://3261465893"] = {name = "Blue Dog", prices = {["default"] = 374.07, ["Ride"] = 438.61, ["Fly|Ride"] = 471.19, ["Neon|Fly|Ride"] = 1522.5}},
    ["rbxassetid://15504846154"] = {name = "Eggnog Hare", prices = {["default"] = 16.64, ["Ride"] = 131.24, ["Neon"] = 89.33, ["Mega|Ride"] = 440.62, ["Mega|Fly|Ride"] = 1246.28}},
    ["rbxassetid://4708551244"] = {name = "Dingo", prices = {["default"] = 2.1, ["Fly"] = 18.72, ["Ride"] = 14.44, ["Fly|Ride"] = 32.22, ["Neon"] = 4.35, ["Neon|Fly"] = 69.6, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 38.98, ["Mega"] = 39.38, ["Mega|Ride"] = 74.82, ["Mega|Fly|Ride"] = 102.38}},
    ["rbxassetid://140434791311540"] = {name = "French Bulldog", prices = {["default"] = 86.21, ["Fly|Ride"] = 277.31, ["Neon"] = 237.96, ["Neon|Ride"] = 305.85, ["Neon|Fly|Ride"] = 1140.35, ["Mega"] = 656.25, ["Mega|Ride"] = 802.46, ["Mega|Fly|Ride"] = 1260.82}},
    ["rbxassetid://5067924710"] = {name = "Monkey", prices = {["default"] = 2.1, ["Fly"] = 18.56, ["Ride"] = 15.57, ["Fly|Ride"] = 41.42, ["Neon"] = 12.5, ["Neon|Fly"] = 41.37, ["Neon|Ride"] = 26.6, ["Neon|Fly|Ride"] = 56.25, ["Mega"] = 83.81, ["Mega|Fly"] = 136.07, ["Mega|Ride"] = 128.39, ["Mega|Fly|Ride"] = 179.01}},
    ["rbxassetid://73677246948616"] = {name = "Black Tiger", prices = {["default"] = 2.1, ["Fly"] = 69.6, ["Ride"] = 20.79, ["Fly|Ride"] = 1312.5, ["Neon"] = 2.1, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 89.33, ["Mega"] = 23.92, ["Mega|Fly"] = 263.82, ["Mega|Ride"] = 52.5, ["Mega|Fly|Ride"] = 208.58}},
    ["rbxassetid://17662893972"] = {name = "Pretty Pony", prices = {["default"] = 49.87, ["Fly"] = 139.12, ["Ride"] = 86.6, ["Fly|Ride"] = 115.5, ["Neon"] = 179.81, ["Neon|Ride"] = 187.91, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 654.94, ["Mega|Ride"] = 629.98, ["Mega|Fly|Ride"] = 774.38}},
    ["rbxassetid://16722908853"] = {name = "Dotted Eggy", prices = {["default"] = 2.1, ["Ride"] = 19.68, ["Fly|Ride"] = 52.5, ["Neon"] = 9.39, ["Neon|Ride"] = 26.24, ["Mega"] = 40.59, ["Mega|Ride"] = 143.34, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://3409443896"] = {name = "Wild Boar", prices = {["default"] = 33.79, ["Ride"] = 64.94, ["Fly|Ride"] = 83.1, ["Neon"] = 313.53, ["Neon|Ride"] = 302.24, ["Neon|Fly|Ride"] = 358.32, ["Mega"] = 1640.93, ["Mega|Ride"] = 1659.62, ["Mega|Fly|Ride"] = 1158}},
    ["rbxassetid://12432807176"] = {name = "Possum", prices = {["default"] = 3.73, ["Ride"] = 49.33, ["Fly|Ride"] = 157.88, ["Neon"] = 20.16, ["Neon|Ride"] = 274.32, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 204.33, ["Mega|Ride"] = 207.73, ["Mega|Fly|Ride"] = 469.7}},
    ["rbxassetid://94550121082603"] = {name = "Lionfish", prices = {["default"] = 2.63, ["Fly"] = 69.6, ["Ride"] = 19.27, ["Fly|Ride"] = 66.48, ["Neon"] = 10.41, ["Neon|Fly"] = 77.9, ["Neon|Ride"] = 36.42, ["Neon|Fly|Ride"] = 406.88, ["Mega"] = 82.69, ["Mega|Ride"] = 728.43, ["Mega|Fly|Ride"] = 519.75}},
    ["rbxassetid://15096097714"] = {name = "Evil Rock", prices = {["default"] = 26.24, ["Ride"] = 56.1, ["Fly|Ride"] = 393.74, ["Neon"] = 178.5, ["Neon|Ride"] = 206.69, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 2062.57, ["Mega|Ride"] = 2598.75, ["Mega|Fly|Ride"] = 1107.1}},
    ["rbxassetid://117664495619345"] = {name = "Fire Foal", prices = {["default"] = 2.1, ["Fly"] = 188.28, ["Ride"] = 39.38, ["Fly|Ride"] = 908.98, ["Neon"] = 5.24, ["Neon|Ride"] = 34.94, ["Neon|Fly|Ride"] = 168, ["Mega"] = 45.94, ["Mega|Fly"] = 227.98, ["Mega|Ride"] = 90.57, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://8938701683"] = {name = "Red Cardinal", prices = {["default"] = 2.1, ["Fly"] = 15.15, ["Ride"] = 19.69, ["Fly|Ride"] = 102.88, ["Neon"] = 9.19, ["Neon|Fly"] = 41.1, ["Neon|Ride"] = 63, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 207.73, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://12489700965"] = {name = "Tarsier", prices = {["default"] = 7.88, ["Fly"] = 39.48, ["Ride"] = 28.06, ["Fly|Ride"] = 82.06, ["Neon"] = 58.7, ["Neon|Ride"] = 108.67, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 344.81, ["Mega|Ride"] = 393.74, ["Mega|Fly|Ride"] = 393.72}},
    ["rbxassetid://11765322595"] = {name = "Gingerbread Reindeer", prices = {["default"] = 52.5, ["Ride"] = 64.32, ["Fly|Ride"] = 111.14, ["Neon"] = 139.18, ["Neon|Fly|Ride"] = 970.02, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 830.86}},
    ["rbxassetid://16382424275"] = {name = "Nautilus", prices = {["default"] = 23.62, ["Fly"] = 56.1, ["Ride"] = 28.88, ["Fly|Ride"] = 73.95, ["Neon"] = 79.86, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 157.36, ["Mega"] = 537.12, ["Mega|Ride"] = 262.5, ["Mega|Fly|Ride"] = 469.88}},
    ["rbxassetid://93997399823425"] = {name = "Chocolate Dutch Guinea Pig", prices = {["default"] = 54.02, ["Ride"] = 127.1, ["Fly|Ride"] = 262.5, ["Neon"] = 328.13, ["Neon|Ride"] = 328.13, ["Neon|Fly|Ride"] = 703.38, ["Mega"] = 1544.34, ["Mega|Ride"] = 1302, ["Mega|Fly|Ride"] = 1417.5}},
    ["rbxassetid://75866760046580"] = {name = "Skelebat", prices = {["default"] = 5.13, ["Ride"] = 39.19, ["Neon"] = 27.02, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 305.82, ["Mega"] = 201.41, ["Mega|Ride"] = 299.25, ["Mega|Fly|Ride"] = 338.58}},
    ["rbxassetid://111661922676557"] = {name = "Momma Moose", prices = {["default"] = 6.14, ["Ride"] = 26.46, ["Fly|Ride"] = 78.74, ["Neon"] = 22.33, ["Neon|Ride"] = 52.5, ["Mega"] = 257.58, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 288.75}},
    ["rbxassetid://17059860310"] = {name = "Elasmosaurus", prices = {["default"] = 26.49, ["Fly"] = 65.63, ["Ride"] = 31.5, ["Fly|Ride"] = 93.95, ["Neon"] = 47.04, ["Neon|Ride"] = 139.13, ["Mega"] = 518.44, ["Mega|Ride"] = 692.73, ["Mega|Fly|Ride"] = 463.32}},
    ["rbxassetid://10306934599"] = {name = "Camel", prices = {["default"] = 2.1, ["Fly"] = 15.65, ["Ride"] = 12.48, ["Fly|Ride"] = 32.22, ["Neon"] = 2.1, ["Neon|Fly"] = 39.37, ["Neon|Ride"] = 15.53, ["Neon|Fly|Ride"] = 59.9, ["Mega"] = 14.44, ["Mega|Fly"] = 78.69, ["Mega|Ride"] = 65.54, ["Mega|Fly|Ride"] = 93.17}},
    ["rbxassetid://13104107016"] = {name = "Puffer Fish", prices = {["default"] = 60.38, ["Fly"] = 220.19, ["Ride"] = 90.96, ["Fly|Ride"] = 277.1, ["Neon"] = 183.75, ["Neon|Fly"] = 2354.42, ["Neon|Ride"] = 290.81, ["Neon|Fly|Ride"] = 301.88, ["Mega"] = 1383.37, ["Mega|Ride"] = 1059.34, ["Mega|Fly|Ride"] = 853.13}},
    ["rbxassetid://17183022910"] = {name = "Mole", prices = {["default"] = 2.1, ["Ride"] = 18, ["Fly|Ride"] = 108.02, ["Neon"] = 3.94, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 129.93, ["Mega"] = 31.5, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 311.85}},
    ["rbxassetid://5721844051"] = {name = "Stegosaurus", prices = {["default"] = 2.1, ["Fly"] = 27.98, ["Ride"] = 14.89, ["Fly|Ride"] = 39.87, ["Neon"] = 11.46, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 30.14, ["Neon|Fly|Ride"] = 81.34, ["Mega"] = 193.93, ["Mega|Ride"] = 202.71}},
    ["rbxassetid://114921997566126"] = {name = "S'mores Raccoon", prices = {["default"] = 82.32, ["Ride"] = 139.18, ["Fly|Ride"] = 249.27, ["Neon"] = 207.73, ["Neon|Ride"] = 354.38, ["Neon|Fly|Ride"] = 518.44, ["Mega"] = 1153.69, ["Mega|Ride"] = 1212, ["Mega|Fly|Ride"] = 1181.25}},
    ["rbxassetid://93038040448121"] = {name = "Nurse Shark", prices = {["default"] = 2.1, ["Ride"] = 19.69, ["Neon"] = 6.46, ["Neon|Ride"] = 65.63, ["Mega"] = 54.24, ["Mega|Ride"] = 118.4, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13936750528"] = {name = "River", prices = {["default"] = 6.46}},
    ["rbxassetid://103142927308458"] = {name = "Black-Footed Ferret", prices = {["default"] = 2.1, ["Fly"] = 41.56, ["Ride"] = 35.22, ["Fly|Ride"] = 294.97, ["Neon"] = 6.54, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 137.64, ["Mega"] = 44.66, ["Mega|Ride"] = 116.29, ["Mega|Fly|Ride"] = 213.27}},
    ["rbxassetid://3199974219"] = {name = "Pet Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://13803784751"] = {name = "Happy Clam", prices = {["default"] = 129.28, ["Ride"] = 193.1, ["Fly|Ride"] = 272.12, ["Neon"] = 538.13, ["Neon|Ride"] = 689.34, ["Neon|Fly|Ride"] = 708.75, ["Mega"] = 3601.4, ["Mega|Ride"] = 2191.88, ["Mega|Fly|Ride"] = 2490.47}},
    ["rbxassetid://13665210525"] = {name = "Warthog", prices = {["default"] = 6.25, ["Ride"] = 41.48, ["Neon"] = 31.71, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 195.26, ["Mega"] = 155.3, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 367.5}},
    ["rbxassetid://18515939072"] = {name = "Black Marlin", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 28.06, ["Neon"] = 3.78, ["Neon|Ride"] = 20.79, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 21, ["Mega|Ride"] = 137.6, ["Mega|Fly|Ride"] = 119.62}},
    ["rbxassetid://16075008092"] = {name = "Fanghorn Tortoise", prices = {["default"] = 5.25, ["Ride"] = 18.8, ["Neon"] = 41.5, ["Neon|Ride"] = 109.88, ["Neon|Fly|Ride"] = 118.13, ["Mega|Ride"] = 207.73, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://8566684181"] = {name = "Giant Black Scarab", prices = {["default"] = 10.41, ["Fly"] = 52.5, ["Ride"] = 22.6, ["Fly|Ride"] = 54.32, ["Neon"] = 77.04, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 397.79, ["Mega|Ride"] = 328.13, ["Mega|Fly|Ride"] = 444.51}},
    ["rbxassetid://118691035196137"] = {name = "Shiver Wolf", prices = {["default"] = 37.59, ["Ride"] = 139.12, ["Neon"] = 181.13, ["Neon|Ride"] = 182.44, ["Neon|Fly|Ride"] = 626.57, ["Mega"] = 656.25, ["Mega|Ride"] = 796.59, ["Mega|Fly|Ride"] = 739.48}},
    ["rbxassetid://3743735223"] = {name = "Brown Bear", prices = {["default"] = 128.13, ["Fly"] = 247.56, ["Ride"] = 170.42, ["Fly|Ride"] = 192.94, ["Neon"] = 680.59, ["Neon|Fly"] = 762.32, ["Neon|Ride"] = 498.75, ["Neon|Fly|Ride"] = 590.63, ["Mega|Fly|Ride"] = 2172.19}},
    ["rbxassetid://3934251801"] = {name = "Sloth", prices = {["default"] = 19.65, ["Fly"] = 28.88, ["Ride"] = 29.27, ["Fly|Ride"] = 52.08, ["Neon"] = 168, ["Neon|Fly"] = 6189.85, ["Neon|Ride"] = 128.63, ["Neon|Fly|Ride"] = 157.29, ["Mega|Fly|Ride"] = 577.5}},
    ["rbxassetid://12139338880"] = {name = "Frogspawn", prices = {["default"] = 2.1, ["Fly"] = 131.23, ["Ride"] = 20.79, ["Fly|Ride"] = 91.41, ["Neon"] = 16.72, ["Neon|Fly"] = 69.02, ["Neon|Ride"] = 87.94, ["Neon|Fly|Ride"] = 194.91, ["Mega"] = 78.75, ["Mega|Ride"] = 100.92, ["Mega|Fly|Ride"] = 346.89}},
    ["rbxassetid://8070926551"] = {name = "Snow Leopard", prices = {["default"] = 3.84, ["Fly"] = 153.72, ["Ride"] = 139.18, ["Neon"] = 72.63, ["Mega"] = 282.51, ["Mega|Ride"] = 411.28, ["Mega|Fly|Ride"] = 1252.52}},
    ["rbxassetid://76712147705770"] = {name = "Tuxedo Cat", prices = {["default"] = 48.57, ["Ride"] = 78.74, ["Fly|Ride"] = 131.25, ["Neon"] = 161.27, ["Neon|Ride"] = 245.44, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 1059.34, ["Mega|Ride"] = 1023.75, ["Mega|Fly|Ride"] = 1060.12}},
    ["rbxassetid://15685468962"] = {name = "Tasmanian Devil", prices = {["default"] = 16.88, ["Ride"] = 85.25, ["Neon"] = 157.36, ["Neon|Ride"] = 238.26, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 683.82, ["Mega|Ride"] = 747.78, ["Mega|Fly|Ride"] = 554.6}},
    ["rbxassetid://123288277753363"] = {name = "Tri-horned Treehopper", prices = {["default"] = 325.4, ["Ride"] = 410.25, ["Neon"] = 1472.52, ["Neon|Ride"] = 1108.14, ["Mega"] = 4631.95, ["Mega|Fly|Ride"] = 4631.95}},
    ["rbxassetid://6060987821"] = {name = "Yeti", prices = {["default"] = 34.13, ["Ride"] = 61.07, ["Fly|Ride"] = 91.88, ["Neon"] = 276.27, ["Neon|Ride"] = 311.58, ["Neon|Fly|Ride"] = 315, ["Mega"] = 1034.25, ["Mega|Ride"] = 900.38, ["Mega|Fly|Ride"] = 1092}},
    ["rbxassetid://9549841158"] = {name = "Zebra", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 15.41, ["Fly|Ride"] = 78.74, ["Neon"] = 2.1, ["Neon|Ride"] = 14.43, ["Neon|Fly|Ride"] = 57.41, ["Mega"] = 22.32, ["Mega|Ride"] = 41.05, ["Mega|Fly|Ride"] = 113.91}},
    ["rbxassetid://13883282884"] = {name = "Hermit Crab", prices = {["default"] = 6.24, ["Neon"] = 16.49, ["Neon|Ride"] = 92.64, ["Neon|Fly|Ride"] = 166.19, ["Mega"] = 157.36, ["Mega|Ride"] = 180.72, ["Mega|Fly|Ride"] = 394.67}},
    ["rbxassetid://92626539723202"] = {name = "Sea Angel", prices = {["default"] = 3.94, ["Ride"] = 262.49, ["Fly|Ride"] = 46.98, ["Neon"] = 17.07, ["Neon|Fly"] = 87.94, ["Neon|Ride"] = 69.6, ["Neon|Fly|Ride"] = 554.6, ["Mega"] = 105, ["Mega|Fly"] = 540.06, ["Mega|Ride"] = 168.27, ["Mega|Fly|Ride"] = 274.17}},
    ["rbxassetid://15848329383"] = {name = "Jellyfish", prices = {["default"] = 328.13, ["Fly"] = 627.06, ["Ride"] = 413.34, ["Fly|Ride"] = 564.38, ["Neon"] = 1387.72, ["Neon|Ride"] = 1246.28, ["Neon|Fly|Ride"] = 1371.57, ["Mega|Ride"] = 6096.32, ["Mega|Fly|Ride"] = 5033.44}},
    ["rbxassetid://5721843846"] = {name = "Sabertooth", prices = {["default"] = 2.61, ["Fly"] = 66.89, ["Ride"] = 17.07, ["Fly|Ride"] = 48.29, ["Neon"] = 20.94, ["Neon|Ride"] = 41.11, ["Neon|Fly|Ride"] = 80.76, ["Mega"] = 168, ["Mega|Ride"] = 274.17}},
    ["rbxassetid://9475753090"] = {name = "Albatross", prices = {["default"] = 15.47, ["Fly"] = 22.31, ["Ride"] = 17.07, ["Fly|Ride"] = 39.38, ["Neon"] = 28.06, ["Neon|Fly"] = 157.5, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 415.44, ["Mega|Ride"] = 692.73, ["Mega|Fly|Ride"] = 286.13}},
    ["rbxassetid://96894173636082"] = {name = "Clementine Owl", prices = {["default"] = 3.86, ["Ride"] = 22.32, ["Neon"] = 18.8, ["Neon|Fly"] = 94.49, ["Neon|Ride"] = 47.79, ["Neon|Fly|Ride"] = 90.21, ["Mega"] = 397.79, ["Mega|Ride"] = 267.96, ["Mega|Fly|Ride"] = 180.72}},
    ["rbxassetid://10318105683"] = {name = "Orange Butterfly", prices = {["default"] = 45.99, ["Fly"] = 65.44, ["Ride"] = 52.5, ["Fly|Ride"] = 81.02, ["Neon"] = 138.27, ["Neon|Ride"] = 77.44, ["Neon|Fly|Ride"] = 210, ["Mega|Ride"] = 829.82, ["Mega|Fly|Ride"] = 643.13}},
    ["rbxassetid://15937689999"] = {name = "Rattlesnake", prices = {["default"] = 2.1, ["Fly"] = 31.43, ["Ride"] = 40.68, ["Fly|Ride"] = 69.6, ["Neon"] = 11.45, ["Neon|Ride"] = 35.33, ["Mega"] = 139.18, ["Mega|Ride"] = 398.83, ["Mega|Fly|Ride"] = 755.35}},
    ["rbxassetid://10971808447"] = {name = "Evil Basilisk", prices = {["default"] = 5.25, ["Fly"] = 103.87, ["Ride"] = 31.18, ["Fly|Ride"] = 85.31, ["Neon"] = 93.19, ["Neon|Ride"] = 155.38, ["Neon|Fly|Ride"] = 207.73, ["Mega|Fly|Ride"] = 725.95}},
    ["rbxassetid://99104623628550"] = {name = "Snorgle", prices = {["default"] = 2.1, ["Ride"] = 19.17, ["Neon"] = 3.94, ["Neon|Ride"] = 41.56, ["Mega"] = 41.56, ["Mega|Ride"] = 130.78, ["Mega|Fly|Ride"] = 285.55}},
    ["rbxassetid://136705425555561"] = {name = "Emperor Shrimp", prices = {["default"] = 13.1, ["Ride"] = 135.19, ["Neon"] = 83.1, ["Neon|Ride"] = 204.35, ["Mega"] = 415.44, ["Mega|Ride"] = 276.27}},
    ["rbxassetid://14398819258"] = {name = "Longhorn Cow", prices = {["default"] = 10.5, ["Ride"] = 78.06, ["Fly|Ride"] = 70.47, ["Neon"] = 68.61, ["Neon|Ride"] = 102.38, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 306.38, ["Mega|Ride"] = 554.6, ["Mega|Fly|Ride"] = 489.17}},
    ["rbxassetid://4708551284"] = {name = "Koala", prices = {["default"] = 7.88, ["Fly"] = 39.38, ["Ride"] = 26.17, ["Fly|Ride"] = 57.87, ["Neon"] = 45.93, ["Neon|Fly"] = 65.63, ["Neon|Ride"] = 75.33, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 583.68, ["Mega|Ride"] = 346.98, ["Mega|Fly|Ride"] = 403.87}},
    ["rbxassetid://4115249264"] = {name = "Zombie Buffalo", prices = {["default"] = 223.13, ["Fly"] = 216.57, ["Ride"] = 267.9, ["Fly|Ride"] = 363.57, ["Neon"] = 1037.53, ["Neon|Ride"] = 1045.84, ["Neon|Fly|Ride"] = 958.13, ["Mega|Fly|Ride"] = 4154.22}},
    ["rbxassetid://8939633862"] = {name = "Salamander", prices = {["default"] = 2.1, ["Fly"] = 32.82, ["Ride"] = 15.57, ["Fly|Ride"] = 56.79, ["Neon"] = 17.62, ["Neon|Fly"] = 78.69, ["Neon|Ride"] = 34.08, ["Neon|Fly|Ride"] = 145.04, ["Mega"] = 220.5, ["Mega|Ride"] = 165.15, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://7734902431"] = {name = "Halloween White Mummy Cat", prices = {["default"] = 3.94, ["Ride"] = 45.94, ["Fly|Ride"] = 108.12, ["Neon"] = 35.42, ["Neon|Ride"] = 35.24, ["Neon|Fly|Ride"] = 164.07, ["Mega"] = 282.92, ["Mega|Ride"] = 271.87, ["Mega|Fly|Ride"] = 410.82}},
    ["rbxassetid://115869632070663"] = {name = "Snowball Pug", prices = {["default"] = 46.99, ["Neon"] = 95.82, ["Neon|Ride"] = 262.5, ["Neon|Fly|Ride"] = 600.29, ["Mega"] = 520.41, ["Mega|Ride"] = 654.94, ["Mega|Fly|Ride"] = 1383.37}},
    ["rbxassetid://8077189379"] = {name = "Husky", prices = {["default"] = 103.87, ["Fly"] = 393.75, ["Ride"] = 154.43, ["Fly|Ride"] = 257.8, ["Neon"] = 548.37, ["Neon|Ride"] = 581.44, ["Neon|Fly|Ride"] = 970.02, ["Mega"] = 2077.11, ["Mega|Ride"] = 1791.57, ["Mega|Fly|Ride"] = 2146.7}},
    ["rbxassetid://98003529163435"] = {name = "Maine Coon", prices = {["default"] = 20.69, ["Ride"] = 91.87, ["Fly|Ride"] = 137.82, ["Neon"] = 82.32, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 398.83, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 418.69}},
    ["rbxassetid://12488273089"] = {name = "Yellow-lipped Sea Krait", prices = {["default"] = 2.1, ["Ride"] = 16.49, ["Fly|Ride"] = 58.47, ["Neon"] = 9.4, ["Neon|Fly|Ride"] = 59.07, ["Mega"] = 51.02, ["Mega|Ride"] = 189.04, ["Mega|Fly|Ride"] = 192.94}},
    ["rbxassetid://96760582519875"] = {name = "Cozy Mistletroll", prices = {["default"] = 20.79, ["Ride"] = 48.56, ["Neon"] = 77.18, ["Neon|Ride"] = 87.94, ["Mega"] = 341.36, ["Mega|Ride"] = 334.43, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://85229142142232"] = {name = "Bunny Swirl", prices = {["default"] = 88.09, ["Fly"] = 190.32, ["Ride"] = 135.19, ["Fly|Ride"] = 216.57, ["Neon"] = 262.5, ["Neon|Ride"] = 219.87, ["Neon|Fly|Ride"] = 303.19, ["Mega"] = 409.5, ["Mega|Ride"] = 446.24, ["Mega|Fly|Ride"] = 511.88}},
    ["rbxassetid://121192022038625"] = {name = "Stygian Owl", prices = {["default"] = 2.1, ["Ride"] = 102.18, ["Neon"] = 8.71, ["Neon|Ride"] = 205.65, ["Neon|Fly|Ride"] = 105, ["Mega"] = 61.03, ["Mega|Fly"] = 166.19, ["Mega|Ride"] = 125.99, ["Mega|Fly|Ride"] = 143.07}},
    ["rbxassetid://83732262844708"] = {name = "Pain au Chat", prices = {["default"] = 11.45, ["Ride"] = 365.58, ["Neon"] = 85.32, ["Neon|Ride"] = 626.45, ["Mega"] = 366.19, ["Mega|Ride"] = 454.13, ["Mega|Fly|Ride"] = 762.32}},
    ["rbxassetid://12792506715"] = {name = "Goose", prices = {["default"] = 969.94, ["Fly"] = 1194.38, ["Ride"] = 1001.32, ["Fly|Ride"] = 1056.57, ["Neon"] = 3531.09, ["Neon|Ride"] = 3916.11, ["Neon|Fly|Ride"] = 2743.12, ["Mega|Fly|Ride"] = 10935.96}},
    ["rbxassetid://12779257292"] = {name = "Pudding Cat", prices = {["default"] = 98.68, ["Fly"] = 115.11, ["Ride"] = 108.84, ["Fly|Ride"] = 187.69, ["Neon"] = 173.8, ["Neon|Fly"] = 892.5, ["Neon|Ride"] = 567, ["Mega"] = 966.91, ["Mega|Fly|Ride"] = 689.9}},
    ["rbxassetid://83376259738301"] = {name = "Mrs. Whiskerpips", prices = {["default"] = 2.1, ["Fly"] = 49.24, ["Ride"] = 21.48, ["Fly|Ride"] = 80.89, ["Neon"] = 12.83, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 82.57, ["Mega"] = 88.36, ["Mega|Ride"] = 97.13, ["Mega|Fly|Ride"] = 155.91}},
    ["rbxassetid://110894046614323"] = {name = "Partridge", prices = {["default"] = 23.6, ["Ride"] = 131.22, ["Neon"] = 83.1, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 255.5, ["Mega|Ride"] = 378.06, ["Mega|Fly|Ride"] = 289.77}},
    ["rbxassetid://114034119324343"] = {name = "Muskrat", prices = {["default"] = 2.1, ["Ride"] = 23.9, ["Fly|Ride"] = 52.5, ["Neon"] = 3.75, ["Neon|Ride"] = 26.11, ["Neon|Fly|Ride"] = 89.14, ["Mega"] = 23.9, ["Mega|Fly"] = 124.65, ["Mega|Ride"] = 45.85, ["Mega|Fly|Ride"] = 165.09}},
    ["rbxassetid://15547904644"] = {name = "Harp Seal", prices = {["default"] = 97.13, ["Ride"] = 120.95, ["Fly|Ride"] = 241.5, ["Neon"] = 292.69, ["Neon|Ride"] = 490.21, ["Neon|Fly|Ride"] = 464.5, ["Mega"] = 1100.15, ["Mega|Ride"] = 1089.38, ["Mega|Fly|Ride"] = 1076.25}},
    ["rbxassetid://14978702254"] = {name = "Scarecrow Cat", prices = {["default"] = 5.25, ["Fly"] = 174.57, ["Ride"] = 37.58, ["Fly|Ride"] = 67.74, ["Neon"] = 45.84, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 262.5, ["Mega|Ride"] = 272.12, ["Mega|Fly|Ride"] = 401.63}},
    ["rbxassetid://95871612352029"] = {name = "Cold Cube", prices = {["default"] = 3.84, ["Fly"] = 97.69, ["Ride"] = 20.56, ["Neon"] = 10.5, ["Neon|Ride"] = 55.49, ["Mega"] = 180.72, ["Mega|Ride"] = 207.73, ["Mega|Fly|Ride"] = 367.66}},
    ["rbxassetid://114456035353449"] = {name = "Bauble Buddies", prices = {["default"] = 50.16, ["Ride"] = 61.67, ["Fly|Ride"] = 196.88, ["Neon"] = 200.82, ["Neon|Fly"] = 277.31, ["Neon|Ride"] = 525, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 669.33, ["Mega|Ride"] = 574.88, ["Mega|Fly|Ride"] = 1037.53}},
    ["rbxassetid://15383967605"] = {name = "Gingerbread Mouse", prices = {["default"] = 40.69, ["Ride"] = 86.21, ["Fly|Ride"] = 190.32, ["Neon"] = 311.53, ["Neon|Ride"] = 174.6, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 3131.71, ["Mega|Ride"] = 415.44, ["Mega|Fly|Ride"] = 887.73}},
    ["rbxassetid://11767069383"] = {name = "Woolly Rhino", prices = {["default"] = 53.82, ["Ride"] = 78.75, ["Neon"] = 787.5, ["Neon|Ride"] = 523.69, ["Neon|Fly|Ride"] = 436.21, ["Mega"] = 1246.28, ["Mega|Ride"] = 1661.7, ["Mega|Fly|Ride"] = 1579.03}},
    ["rbxassetid://95133623103638"] = {name = "Samoyed", prices = {["default"] = 3.83, ["Ride"] = 65.63, ["Neon"] = 26.07, ["Neon|Ride"] = 80.89, ["Neon|Fly|Ride"] = 236.25, ["Mega"] = 97.12, ["Mega|Ride"] = 249.27, ["Mega|Fly|Ride"] = 267.75}},
    ["rbxassetid://8071236757"] = {name = "St Bernard", prices = {["default"] = 7.26, ["Fly"] = 31.71, ["Ride"] = 23.16, ["Fly|Ride"] = 52.49, ["Neon"] = 89.33, ["Neon|Ride"] = 84.57, ["Neon|Fly|Ride"] = 126.36, ["Mega"] = 399, ["Mega|Ride"] = 381.94, ["Mega|Fly|Ride"] = 590.63}},
    ["rbxassetid://14276930615"] = {name = "Alley Cat", prices = {["default"] = 126, ["Ride"] = 137.81, ["Fly|Ride"] = 267.64, ["Neon"] = 498.75, ["Neon|Ride"] = 572.25, ["Neon|Fly|Ride"] = 536.68, ["Mega"] = 2214.2, ["Mega|Ride"] = 2335.15, ["Mega|Fly|Ride"] = 2124.08}},
    ["rbxassetid://6498256417"] = {name = "Dolphin", prices = {["default"] = 2.1, ["Fly"] = 17.03, ["Ride"] = 18.27, ["Fly|Ride"] = 105000, ["Neon"] = 11.04, ["Neon|Fly"] = 64.31, ["Neon|Ride"] = 31.71, ["Neon|Fly|Ride"] = 78.75, ["Mega"] = 124.37, ["Mega|Ride"] = 140.55, ["Mega|Fly|Ride"] = 153.72}},
    ["rbxassetid://7734900468"] = {name = "Halloween White Skeleton Dog", prices = {["default"] = 5.23, ["Fly"] = 40.66, ["Ride"] = 28.29, ["Fly|Ride"] = 78.75, ["Neon"] = 52.49, ["Neon|Fly"] = 140.94, ["Neon|Ride"] = 65.44, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 369.73, ["Mega|Ride"] = 273.16, ["Mega|Fly|Ride"] = 326.55}},
    ["rbxassetid://9982202041"] = {name = "Poodle", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 14.15, ["Fly|Ride"] = 39.38, ["Neon"] = 2.1, ["Neon|Fly"] = 24.34, ["Neon|Ride"] = 14.15, ["Neon|Fly|Ride"] = 44.51, ["Mega"] = 15.75, ["Mega|Fly"] = 36.37, ["Mega|Ride"] = 30.19, ["Mega|Fly|Ride"] = 83.1}},
    ["rbxassetid://73671766703168"] = {name = "Pilot Gull", prices = {["default"] = 2.1, ["Ride"] = 54.02, ["Neon"] = 3.93, ["Neon|Ride"] = 39.48, ["Mega"] = 23.12, ["Mega|Fly"] = 118.12, ["Mega|Ride"] = 38.98, ["Mega|Fly|Ride"] = 156.85}},
    ["rbxassetid://14146127209"] = {name = "Indian Leopard", prices = {["default"] = 2.5, ["Fly"] = 48.83, ["Ride"] = 19.59, ["Fly|Ride"] = 45.94, ["Neon"] = 41.56, ["Neon|Ride"] = 58.42, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 76.08}},
    ["rbxassetid://113558592714438"] = {name = "Seabed Creeper", prices = {["default"] = 41.76, ["Ride"] = 84, ["Neon"] = 310.54, ["Neon|Ride"] = 368.69, ["Neon|Fly|Ride"] = 630, ["Mega"] = 414.21, ["Mega|Ride"] = 392.44, ["Mega|Fly|Ride"] = 627.05}},
    ["rbxassetid://4281674713"] = {name = "Bee", prices = {["default"] = 2.1, ["Fly"] = 15.12, ["Ride"] = 20.79, ["Fly|Ride"] = 39.38, ["Neon"] = 14.32, ["Neon|Fly"] = 28.06, ["Neon|Ride"] = 29.1, ["Neon|Fly|Ride"] = 68.25, ["Mega"] = 114.19, ["Mega|Fly"] = 170.6, ["Mega|Ride"] = 116.29, ["Mega|Fly|Ride"] = 169.97}},
    ["rbxassetid://5862774392"] = {name = "Bat", prices = {["default"] = 3.47, ["Fly"] = 51.35, ["Ride"] = 23.63, ["Fly|Ride"] = 41.16, ["Neon"] = 17.49, ["Neon|Fly"] = 46.49, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 118.13, ["Mega"] = 165.38, ["Mega|Fly"] = 303.28, ["Mega|Ride"] = 157.5, ["Mega|Fly|Ride"] = 208.69}},
    ["rbxassetid://18223359092"] = {name = "Birthday Butterfly 2024", prices = {["default"] = 3.14, ["Fly"] = 19.69, ["Ride"] = 17.62, ["Fly|Ride"] = 72.6, ["Neon"] = 8.86, ["Neon|Fly"] = 98.43, ["Neon|Ride"] = 24.94, ["Neon|Fly|Ride"] = 65.62, ["Mega"] = 40.69, ["Mega|Fly"] = 97.13, ["Mega|Ride"] = 91.88, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://17822765706"] = {name = "Pink Betta Fish", prices = {["default"] = 11.46, ["Fly"] = 169.32, ["Ride"] = 21, ["Neon"] = 49.65, ["Neon|Ride"] = 59.06, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 207.73, ["Mega|Fly"] = 400.32, ["Mega|Ride"] = 260.86, ["Mega|Fly|Ride"] = 635.61}},
    ["rbxassetid://14146174264"] = {name = "Rock Pigeon", prices = {["default"] = 4.72, ["Fly"] = 160.99, ["Ride"] = 122.72, ["Fly|Ride"] = 220.34, ["Neon"] = 87.17, ["Neon|Ride"] = 252.03, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 548.63, ["Mega|Fly|Ride"] = 692.73}},
    ["rbxassetid://11758575946"] = {name = "Water Moon Bear", prices = {["default"] = 3.84, ["Fly"] = 91.88, ["Ride"] = 17.64, ["Fly|Ride"] = 45.94, ["Neon"] = 27.18, ["Neon|Fly"] = 196.66, ["Neon|Ride"] = 40.69, ["Neon|Fly|Ride"] = 105, ["Mega"] = 307.42, ["Mega|Ride"] = 203.44, ["Mega|Fly|Ride"] = 596.51}},
    ["rbxassetid://6498256132"] = {name = "Seahorse", prices = {["default"] = 2.1, ["Fly"] = 20.9, ["Ride"] = 18.38, ["Fly|Ride"] = 52.5, ["Neon"] = 15.73, ["Neon|Fly"] = 66.95, ["Neon|Ride"] = 27.74, ["Neon|Fly|Ride"] = 62.33, ["Mega"] = 177.61, ["Mega|Ride"] = 234.86, ["Mega|Fly|Ride"] = 203.41}},
    ["rbxassetid://13664973582"] = {name = "Many Mackerel", prices = {["default"] = 177.19, ["Fly"] = 393.75, ["Ride"] = 244.13, ["Fly|Ride"] = 183.75, ["Neon"] = 1021.6, ["Neon|Ride"] = 1127.28, ["Neon|Fly|Ride"] = 1179.94, ["Mega|Fly|Ride"] = 4016.1}},
    ["rbxassetid://114806716799554"] = {name = "Ringmaster Gibbon", prices = {["default"] = 5.86, ["Ride"] = 61.76, ["Neon"] = 32.03, ["Neon|Fly|Ride"] = 277.31, ["Mega"] = 116.94, ["Mega|Ride"] = 262.5}},
    ["rbxassetid://14360917588"] = {name = "Magma Moose", prices = {["default"] = 2.1, ["Ride"] = 20.5, ["Fly|Ride"] = 76.01, ["Neon"] = 22.09, ["Neon|Fly"] = 207.73, ["Neon|Ride"] = 44.62, ["Neon|Fly|Ride"] = 201.79, ["Mega"] = 187.11, ["Mega|Ride"] = 276.27, ["Mega|Fly|Ride"] = 221.82}},
    ["rbxassetid://18957942216"] = {name = "Starhopper", prices = {["default"] = 11.82, ["Ride"] = 28.06, ["Neon"] = 49.87, ["Neon|Ride"] = 213.44, ["Neon|Fly|Ride"] = 623.15, ["Mega"] = 461.77, ["Mega|Ride"] = 656.25, ["Mega|Fly|Ride"] = 431.02}},
    ["rbxassetid://3181727071"] = {name = "Puma", prices = {["default"] = 2.1, ["Fly"] = 16.05, ["Ride"] = 14.44, ["Fly|Ride"] = 31.18, ["Neon"] = 2.37, ["Neon|Fly"] = 19.69, ["Neon|Ride"] = 16.64, ["Neon|Fly|Ride"] = 42, ["Mega"] = 16.49, ["Mega|Fly"] = 162.75, ["Mega|Ride"] = 41.56, ["Mega|Fly|Ride"] = 91.88}},
    ["rbxassetid://4841039508"] = {name = "Rock", prices = {["default"] = 2.1, ["Fly"] = 41.1, ["Ride"] = 22.86, ["Fly|Ride"] = 58.69, ["Neon"] = 15.59, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 94.4, ["Mega"] = 187.89, ["Mega|Ride"] = 123.8, ["Mega|Fly|Ride"] = 388.44}},
    ["rbxassetid://94235745630523"] = {name = "Rainbow Trout", prices = {["default"] = 2.51, ["Ride"] = 56.1, ["Fly|Ride"] = 98.67, ["Neon"] = 17.61, ["Neon|Ride"] = 131.25, ["Neon|Fly|Ride"] = 393.75, ["Mega"] = 63.58, ["Mega|Ride"] = 206.07, ["Mega|Fly|Ride"] = 308.95}},
    ["rbxassetid://4440867249"] = {name = "Llama", prices = {["default"] = 76.09, ["Fly"] = 105, ["Ride"] = 97.7, ["Fly|Ride"] = 166.76, ["Neon"] = 301.88, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 471.63, ["Mega|Ride"] = 3463.59, ["Mega|Fly|Ride"] = 1706.25}},
    ["rbxassetid://11571113805"] = {name = "Bloodhound", prices = {["default"] = 3.83, ["Fly"] = 85.32, ["Ride"] = 32.86, ["Fly|Ride"] = 65.62, ["Neon"] = 26.25, ["Neon|Ride"] = 55.2, ["Neon|Fly|Ride"] = 111.14, ["Mega"] = 183.75, ["Mega|Ride"] = 262.49, ["Mega|Fly|Ride"] = 430.96}},
    ["rbxassetid://78423968285099"] = {name = "Wren", prices = {["default"] = 2.1, ["Fly"] = 31.18, ["Ride"] = 47.39, ["Fly|Ride"] = 118.13, ["Neon"] = 5.25, ["Neon|Ride"] = 177.06, ["Neon|Fly|Ride"] = 519.53, ["Mega"] = 59.07, ["Mega|Fly"] = 313.69, ["Mega|Ride"] = 126, ["Mega|Fly|Ride"] = 262.5}},
    ["rbxassetid://110871792705214"] = {name = "Burger Bear", prices = {["default"] = 57.75, ["Fly"] = 105, ["Ride"] = 85.32, ["Fly|Ride"] = 191.02, ["Neon"] = 131.24, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 554.6, ["Mega"] = 451.5, ["Mega|Ride"] = 498.75, ["Mega|Fly|Ride"] = 691.69}},
    ["rbxassetid://3181727637"] = {name = "Fennec Fox", prices = {["default"] = 2.1, ["Fly"] = 17.06, ["Ride"] = 15.28, ["Fly|Ride"] = 32.22, ["Neon"] = 2.24, ["Neon|Fly"] = 23.9, ["Neon|Ride"] = 15.2, ["Neon|Fly|Ride"] = 40.69, ["Mega"] = 18.37, ["Mega|Fly"] = 45.97, ["Mega|Ride"] = 35.33, ["Mega|Fly|Ride"] = 82.2}},
    ["rbxassetid://115530716039589"] = {name = "Milk Choccybunny", prices = {["default"] = 2.1, ["Neon"] = 3.82, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 84.52, ["Mega"] = 73.5, ["Mega|Ride"] = 79.56, ["Mega|Fly|Ride"] = 159.17}},
    ["rbxassetid://83001092186817"] = {name = "White Choccybunny", prices = {["default"] = 5.21, ["Ride"] = 107.63, ["Fly|Ride"] = 137.82, ["Neon"] = 15.6, ["Neon|Ride"] = 125.66, ["Neon|Fly|Ride"] = 182.8, ["Mega"] = 81.37, ["Mega|Fly"] = 182.8, ["Mega|Ride"] = 116.15, ["Mega|Fly|Ride"] = 222.26}},
    ["rbxassetid://103795616446776"] = {name = "Waffle Wyrm", prices = {["default"] = 9.09, ["Fly"] = 111.14, ["Ride"] = 49.52, ["Fly|Ride"] = 129.94, ["Neon"] = 105, ["Neon|Fly"] = 136.5, ["Neon|Ride"] = 70.03, ["Neon|Fly|Ride"] = 222.73, ["Mega"] = 101.03, ["Mega|Fly"] = 220.5, ["Mega|Ride"] = 199.84, ["Mega|Fly|Ride"] = 249.36}},
    ["rbxassetid://9982358951"] = {name = "Orangutan", prices = {["default"] = 2.1, ["Fly"] = 15.6, ["Ride"] = 13.49, ["Fly|Ride"] = 35.44, ["Neon"] = 2.1, ["Neon|Fly"] = 21, ["Neon|Ride"] = 28.88, ["Neon|Fly|Ride"] = 70.47, ["Mega"] = 26.25, ["Mega|Ride"] = 32.69, ["Mega|Fly|Ride"] = 153.72}},
    ["rbxassetid://129021417712364"] = {name = "Kage Crow", prices = {["default"] = 22.32, ["Fly"] = 72.19, ["Ride"] = 117.07, ["Fly|Ride"] = 102.18, ["Neon"] = 118.13, ["Neon|Ride"] = 183.74, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 398.09, ["Mega|Ride"] = 360.39, ["Mega|Fly|Ride"] = 689.61}},
    ["rbxassetid://4849941238"] = {name = "Hedgehog", prices = {["default"] = 2626.32, ["Fly"] = 2957.8, ["Ride"] = 2231.25, ["Fly|Ride"] = 2732.63, ["Neon|Fly|Ride"] = 9592.87, ["Mega|Fly|Ride"] = 43099.9}},
    ["rbxassetid://4800190144"] = {name = "Ginger Cat", prices = {["default"] = 2.1, ["Fly"] = 23.9, ["Ride"] = 15.74, ["Fly|Ride"] = 38.48, ["Neon"] = 5.24, ["Neon|Fly"] = 55.55, ["Neon|Ride"] = 24.15, ["Neon|Fly|Ride"] = 74.79, ["Mega"] = 122.56, ["Mega|Fly"] = 105, ["Mega|Ride"] = 110.25, ["Mega|Fly|Ride"] = 157.36}},
    ["rbxassetid://18119333909"] = {name = "Rodeo Bull", prices = {["default"] = 3.94, ["Neon"] = 11.02, ["Mega"] = 126, ["Mega|Fly"] = 441, ["Mega|Ride"] = 437.07, ["Mega|Fly|Ride"] = 623.15}},
    ["rbxassetid://11837080223"] = {name = "Highland Cow", prices = {["default"] = 14.36, ["Fly"] = 41.56, ["Ride"] = 27.57, ["Fly|Ride"] = 69.57, ["Neon"] = 69.51, ["Neon|Ride"] = 111.14, ["Neon|Fly|Ride"] = 275.62, ["Mega"] = 328.02, ["Mega|Ride"] = 383.24, ["Mega|Fly|Ride"] = 462}},
    ["rbxassetid://14398816006"] = {name = "Rooster", prices = {["default"] = 35.43, ["Ride"] = 98.44, ["Neon"] = 155.07, ["Mega"] = 540.75, ["Mega|Ride"] = 683.39, ["Mega|Fly|Ride"] = 814.92}},
    ["rbxassetid://3409444089"] = {name = "Hyena", prices = {["default"] = 153.7, ["Fly"] = 1385.45, ["Ride"] = 200.18, ["Fly|Ride"] = 236.25, ["Neon"] = 762.32, ["Neon|Ride"] = 724.92, ["Neon|Fly|Ride"] = 683.16, ["Mega"] = 6231.32, ["Mega|Fly|Ride"] = 3014.55}},
    ["rbxassetid://127067345833475"] = {name = "Hummingbird", prices = {["default"] = 5.24, ["Fly"] = 28.06, ["Ride"] = 28.88, ["Fly|Ride"] = 675.94, ["Neon"] = 21.15, ["Neon|Ride"] = 125.85, ["Mega"] = 194.22, ["Mega|Fly"] = 1382.33, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://130497948875084"] = {name = "Marabou Stork", prices = {["default"] = 2.1, ["Ride"] = 52.5, ["Neon"] = 15.59, ["Neon|Fly"] = 97.63, ["Neon|Fly|Ride"] = 519.29, ["Mega"] = 112.46, ["Mega|Ride"] = 320.25, ["Mega|Fly|Ride"] = 834.89}},
    ["rbxassetid://127017727552531"] = {name = "Angus Calf", prices = {["default"] = 3.82, ["Fly"] = 101.98, ["Ride"] = 44.55, ["Fly|Ride"] = 196.87, ["Neon"] = 10.42, ["Neon|Ride"] = 49.88, ["Mega"] = 75.79, ["Mega|Ride"] = 126.73, ["Mega|Fly|Ride"] = 287.7}},
    ["rbxassetid://12779130089"] = {name = "Sprout Snail", prices = {["default"] = 13.02, ["Ride"] = 98.43, ["Neon"] = 131.24, ["Neon|Ride"] = 1165.82, ["Mega"] = 374.06, ["Mega|Ride"] = 514.11, ["Mega|Fly|Ride"] = 689.61}},
    ["rbxassetid://117824155556510"] = {name = "Princess Mare", prices = {["default"] = 2.1, ["Neon"] = 2.1, ["Neon|Ride"] = 80.93, ["Mega"] = 18.39, ["Mega|Fly"] = 117.34, ["Mega|Ride"] = 156.18}},
    ["rbxassetid://122766274014139"] = {name = "Gaelic Fae", prices = {["default"] = 83.87, ["Fly"] = 139.18, ["Ride"] = 78.75, ["Fly|Ride"] = 139.18, ["Neon"] = 518.25, ["Neon|Fly"] = 313.57, ["Neon|Ride"] = 406.88, ["Neon|Fly|Ride"] = 517.85, ["Mega"] = 1252.93, ["Mega|Fly|Ride"] = 1724.14}},
    ["rbxassetid://17255807019"] = {name = "Weevil", prices = {["default"] = 2.1, ["Ride"] = 91.81, ["Neon"] = 6.57, ["Neon|Ride"] = 137.67, ["Mega"] = 61.69, ["Mega|Ride"] = 124.65}},
    ["rbxassetid://3743720235"] = {name = "Capybara", prices = {["default"] = 44.24, ["Fly"] = 219.59, ["Ride"] = 74.81, ["Fly|Ride"] = 131.24, ["Neon"] = 289.4, ["Neon|Ride"] = 326.12, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 2625, ["Mega|Ride"] = 2769.83, ["Mega|Fly|Ride"] = 1443.75}},
    ["rbxassetid://106815320234576"] = {name = "Ehecatl", prices = {["default"] = 2.1, ["Fly"] = 52.5, ["Ride"] = 23.9, ["Fly|Ride"] = 49.77, ["Neon"] = 4.64, ["Neon|Fly"] = 87.44, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 83.99, ["Mega"] = 98.44, ["Mega|Ride"] = 118.13, ["Mega|Fly|Ride"] = 154.76}},
    ["rbxassetid://110449571836616"] = {name = "Irish Setter", prices = {["default"] = 5.25, ["Ride"] = 41.56, ["Neon"] = 18.38, ["Neon|Ride"] = 118.13, ["Mega"] = 131.15, ["Mega|Fly|Ride"] = 603.75}},
    ["rbxassetid://93751644677101"] = {name = "Winter Doe", prices = {["default"] = 11.57, ["Fly|Ride"] = 204.44, ["Neon"] = 79.97, ["Neon|Ride"] = 157.37, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 234.87, ["Mega|Ride"] = 345.19, ["Mega|Fly|Ride"] = 892.5}},
    ["rbxassetid://90667836208550"] = {name = "Munchkin Cat", prices = {["default"] = 393.75, ["Fly"] = 554.6, ["Ride"] = 440.24, ["Fly|Ride"] = 459.38, ["Neon"] = 1049.99, ["Neon|Ride"] = 1227.18, ["Neon|Fly|Ride"] = 1299.38, ["Mega|Ride"] = 3674.99, ["Mega|Fly|Ride"] = 3799.69}},
    ["rbxassetid://3743734696"] = {name = "Rhino", prices = {["default"] = 35.21, ["Fly"] = 65.77, ["Ride"] = 38.98, ["Fly|Ride"] = 128.8, ["Neon"] = 237.57, ["Neon|Ride"] = 205.89, ["Neon|Fly|Ride"] = 299.12, ["Mega|Ride"] = 1225.5, ["Mega|Fly|Ride"] = 783.22}},
    ["rbxassetid://7734928397"] = {name = "Halloween Blue Scorpion", prices = {["default"] = 2.1, ["Fly"] = 40.61, ["Ride"] = 17.49, ["Fly|Ride"] = 91.88, ["Neon"] = 9.17, ["Neon|Fly"] = 85.32, ["Neon|Ride"] = 13.13, ["Neon|Fly|Ride"] = 97.63, ["Mega"] = 49.41, ["Mega|Ride"] = 85.32, ["Mega|Fly|Ride"] = 183.74}},
    ["rbxassetid://116859365721104"] = {name = "Shadow Dragon Ducky", prices = {["default"] = 18.18, ["Fly"] = 363.5, ["Ride"] = 57.75, ["Fly|Ride"] = 69.6, ["Neon"] = 39.11, ["Neon|Fly"] = 187.91, ["Neon|Ride"] = 97.63, ["Neon|Fly|Ride"] = 180.72, ["Mega"] = 234.94, ["Mega|Fly"] = 386.36, ["Mega|Ride"] = 241.92, ["Mega|Fly|Ride"] = 333.81}},
    ["rbxassetid://6060991084"] = {name = "Musk Ox", prices = {["default"] = 7.74, ["Ride"] = 23.12, ["Fly|Ride"] = 264.85, ["Neon"] = 135.86, ["Neon|Ride"] = 68.25, ["Neon|Fly|Ride"] = 313.53, ["Mega|Ride"] = 483.97, ["Mega|Fly|Ride"] = 384.76}},
    ["rbxassetid://119284351481681"] = {name = "Violet Friend", prices = {["default"] = 3.82, ["Neon"] = 15.74, ["Mega"] = 68.25, ["Mega|Ride"] = 122.07, ["Mega|Fly|Ride"] = 406.88}},
    ["rbxassetid://10971808356"] = {name = "Basilisk", prices = {["default"] = 2.1, ["Fly"] = 39.38, ["Ride"] = 15.75, ["Fly|Ride"] = 56.1, ["Neon"] = 26.25, ["Neon|Ride"] = 32.79, ["Neon|Fly|Ride"] = 210.08, ["Mega"] = 548.39, ["Mega|Ride"] = 486.94, ["Mega|Fly|Ride"] = 966.91}},
    ["rbxassetid://3744706727"] = {name = "Platypus", prices = {["default"] = 98.43, ["Ride"] = 118.13, ["Fly|Ride"] = 190.11, ["Neon"] = 576.19, ["Neon|Ride"] = 615.57, ["Neon|Fly|Ride"] = 853.13, ["Mega|Ride"] = 3185.25, ["Mega|Fly|Ride"] = 3463.59}},
    ["rbxassetid://12480556316"] = {name = "Black Macaque", prices = {["default"] = 19.77, ["Fly"] = 95.82, ["Ride"] = 94.49, ["Fly|Ride"] = 231.91, ["Neon"] = 170.63, ["Neon|Ride"] = 192.14, ["Mega"] = 459.38, ["Mega|Ride"] = 664.69, ["Mega|Fly|Ride"] = 695.63}},
    ["rbxassetid://4849941000"] = {name = "Dalmatian", prices = {["default"] = 2270.63, ["Fly"] = 2349.37, ["Ride"] = 2229.93, ["Fly|Ride"] = 2387.44, ["Neon"] = 11078.24, ["Neon|Fly|Ride"] = 7743.75, ["Mega|Fly|Ride"] = 26250}},
    ["rbxassetid://139319822015938"] = {name = "Sea Skeleton Panda", prices = {["default"] = 2.81, ["Fly"] = 65625, ["Ride"] = 110.25, ["Fly|Ride"] = 170.63, ["Neon"] = 12.5, ["Neon|Ride"] = 132.83, ["Neon|Fly|Ride"] = 194.22, ["Mega"] = 118.12, ["Mega|Ride"] = 163.96, ["Mega|Fly|Ride"] = 580.56}},
    ["rbxassetid://104838807480936"] = {name = "Winter Fawn", prices = {["default"] = 15.6, ["Ride"] = 115.29, ["Neon"] = 815.07, ["Neon|Ride"] = 207.73, ["Mega"] = 311.58, ["Mega|Ride"] = 300.72, ["Mega|Fly|Ride"] = 506.83}},
    ["rbxassetid://100705885132301"] = {name = "Cabbit", prices = {["default"] = 862.68, ["Fly"] = 1440.49, ["Ride"] = 891.19, ["Fly|Ride"] = 975.19, ["Neon"] = 2546.78, ["Neon|Ride"] = 2887.5, ["Neon|Fly|Ride"] = 2231.25, ["Mega|Fly|Ride"] = 11493.66}},
    ["rbxassetid://12480406935"] = {name = "Binturong", prices = {["default"] = 27.57, ["Ride"] = 56.44, ["Fly|Ride"] = 91.88, ["Neon"] = 235.76, ["Neon|Ride"] = 291.72, ["Mega"] = 525, ["Mega|Ride"] = 705.39, ["Mega|Fly|Ride"] = 737.65}},
    ["rbxassetid://73245262062822"] = {name = "Prism Snake", prices = {["default"] = 3.94, ["Ride"] = 22.91, ["Fly|Ride"] = 128.15, ["Neon"] = 15.37, ["Neon|Ride"] = 139.18, ["Neon|Fly|Ride"] = 196.88, ["Mega"] = 196.88, ["Mega|Ride"] = 123.24, ["Mega|Fly|Ride"] = 362.25}},
    ["rbxassetid://113717425344888"] = {name = "Magpie", prices = {["default"] = 2.1, ["Fly"] = 111.57, ["Ride"] = 139.12, ["Neon"] = 6.23, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 78.69, ["Mega"] = 27.57, ["Mega|Ride"] = 106.31, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://10318105900"] = {name = "Purple Butterfly", prices = {["default"] = 75.36, ["Ride"] = 126, ["Fly|Ride"] = 139.18, ["Neon"] = 414.4, ["Neon|Fly"] = 399.28, ["Neon|Ride"] = 352.31, ["Neon|Fly|Ride"] = 545.74, ["Mega"] = 2769.83, ["Mega|Fly|Ride"] = 2661.96}},
    ["rbxassetid://95049698731940"] = {name = "Throwback Egg", prices = {["default"] = 2.1}},
    ["rbxassetid://15503941919"] = {name = "Arctic Hare", prices = {["default"] = 4.66, ["Neon"] = 24.91, ["Neon|Ride"] = 111.14, ["Mega"] = 142.97, ["Mega|Ride"] = 185.92, ["Mega|Fly|Ride"] = 305.82}},
    ["rbxassetid://10274421272"] = {name = "Royal Corgi", prices = {["default"] = 84, ["Ride"] = 97.64, ["Fly|Ride"] = 85.32, ["Neon"] = 341.25, ["Neon|Ride"] = 463.32, ["Neon|Fly|Ride"] = 341.25, ["Mega|Fly|Ride"] = 2036.99}},
    ["rbxassetid://13978968837"] = {name = "Bird of Paradise", prices = {["default"] = 6.82, ["Fly"] = 105, ["Fly|Ride"] = 111.14, ["Neon"] = 39.36, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 105, ["Mega|Ride"] = 105, ["Mega|Fly|Ride"] = 315}},
    ["rbxassetid://3261465850"] = {name = "Pink Cat", prices = {["default"] = 249.38, ["Ride"] = 286.13, ["Fly|Ride"] = 322.88, ["Neon"] = 1070.18, ["Neon|Ride"] = 905.63, ["Neon|Fly|Ride"] = 879.38, ["Mega|Fly|Ride"] = 4258.08}},
    ["rbxassetid://8969010905"] = {name = "Red Fox", prices = {["default"] = 2.62, ["Fly"] = 87.92, ["Ride"] = 25.03, ["Fly|Ride"] = 49.33, ["Neon"] = 41.56, ["Neon|Ride"] = 64.89, ["Neon|Fly|Ride"] = 114.15, ["Mega|Ride"] = 183.75, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://3181728128"] = {name = "Red Panda", prices = {["default"] = 2.1, ["Fly"] = 18.52, ["Ride"] = 15.24, ["Fly|Ride"] = 39.37, ["Neon"] = 3.94, ["Neon|Fly"] = 15.6, ["Neon|Ride"] = 27.57, ["Neon|Fly|Ride"] = 45.71, ["Mega"] = 53.82, ["Mega|Fly"] = 101.22, ["Mega|Ride"] = 60.37, ["Mega|Fly|Ride"] = 154.88}},
    ["rbxassetid://13077769577"] = {name = "Pelican", prices = {["default"] = 866.25, ["Ride"] = 970.02, ["Fly|Ride"] = 1027.3, ["Neon|Ride"] = 7616.75, ["Neon|Fly|Ride"] = 4708.81, ["Mega|Fly|Ride"] = 27695.08}},
    ["rbxassetid://115281603518501"] = {name = "DJ Snooze", prices = {["default"] = 13.2, ["Fly"] = 970.02, ["Ride"] = 210, ["Neon"] = 55.2, ["Neon|Ride"] = 78.75, ["Mega"] = 211.03, ["Mega|Ride"] = 266.57, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://111847888001946"] = {name = "Choco Penguin", prices = {["default"] = 11.82, ["Ride"] = 35.32, ["Fly|Ride"] = 110.1, ["Neon"] = 32.82, ["Neon|Fly"] = 77.68, ["Neon|Ride"] = 52.48, ["Neon|Fly|Ride"] = 166.19, ["Mega"] = 175.14, ["Mega|Ride"] = 165.13, ["Mega|Fly|Ride"] = 313.69}},
    ["rbxassetid://4621220487"] = {name = "Panda", prices = {["default"] = 45.01, ["Fly"] = 40.09, ["Ride"] = 41.99, ["Fly|Ride"] = 59.07, ["Neon"] = 173.45, ["Neon|Ride"] = 157.49, ["Neon|Fly|Ride"] = 201.49, ["Mega"] = 2077.11, ["Mega|Fly|Ride"] = 799.32}},
    ["rbxassetid://12917347184"] = {name = "Flower Power Duckling", prices = {["default"] = 14.87, ["Fly"] = 77.9, ["Ride"] = 42, ["Fly|Ride"] = 87.94, ["Neon"] = 58.73, ["Neon|Fly"] = 78.75, ["Neon|Ride"] = 81.02, ["Neon|Fly|Ride"] = 145.69, ["Mega"] = 367.5, ["Mega|Fly"] = 367.5, ["Mega|Ride"] = 376.69, ["Mega|Fly|Ride"] = 444.51}},
    ["rbxassetid://93775555430694"] = {name = "Pumpkin Friend", prices = {["default"] = 27.54, ["Ride"] = 66.94, ["Fly|Ride"] = 122.56, ["Neon"] = 99.04, ["Neon|Ride"] = 183.75, ["Neon|Fly|Ride"] = 262.5, ["Mega"] = 484.32, ["Mega|Ride"] = 573.57, ["Mega|Fly|Ride"] = 826.7}},
    ["rbxassetid://83317902236850"] = {name = "Kakapo", prices = {["default"] = 2.08, ["Fly"] = 52.5, ["Ride"] = 116.6, ["Fly|Ride"] = 234.87, ["Neon"] = 2.1, ["Neon|Fly"] = 55.6, ["Neon|Ride"] = 41.56, ["Neon|Fly|Ride"] = 69.12, ["Mega"] = 17.07, ["Mega|Fly"] = 88.09, ["Mega|Ride"] = 60.92, ["Mega|Fly|Ride"] = 93.71}},
    ["rbxassetid://5862774043"] = {name = "Ghost Bunny", prices = {["default"] = 41.56, ["Fly"] = 89.24, ["Ride"] = 66.75, ["Fly|Ride"] = 104.9, ["Neon"] = 277.31, ["Neon|Fly"] = 310.54, ["Neon|Ride"] = 267.02, ["Neon|Fly|Ride"] = 346.89, ["Mega"] = 1409.1, ["Mega|Ride"] = 1096.73, ["Mega|Fly|Ride"] = 918.65}},
    ["rbxassetid://10639131895"] = {name = "Spider Crab", prices = {["default"] = 2.1, ["Fly"] = 86.87, ["Ride"] = 17.07, ["Fly|Ride"] = 111.14, ["Neon"] = 15.6, ["Neon|Ride"] = 39.38, ["Mega"] = 773.07, ["Mega|Ride"] = 236.25, ["Mega|Fly|Ride"] = 524.99}},
    ["rbxassetid://10193736072"] = {name = "Red Crowned Crane", prices = {["default"] = 2.63, ["Fly"] = 19.69, ["Ride"] = 20.55, ["Fly|Ride"] = 38.04, ["Neon"] = 15.75, ["Neon|Ride"] = 52.98, ["Neon|Fly|Ride"] = 131.25, ["Mega|Ride"] = 263.23, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://13804047294"] = {name = "Arctic Tern", prices = {["default"] = 5.06, ["Ride"] = 173.45, ["Neon"] = 105, ["Neon|Fly"] = 52.5, ["Neon|Ride"] = 830.86, ["Neon|Fly|Ride"] = 184.33, ["Mega"] = 249.27, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://14883937353"] = {name = "Ghost Dog", prices = {["default"] = 36.63, ["Fly"] = 262.4, ["Ride"] = 88.1, ["Fly|Ride"] = 183.75, ["Neon"] = 118.13, ["Neon|Ride"] = 243.6, ["Neon|Fly|Ride"] = 318.85, ["Mega"] = 813.2, ["Mega|Ride"] = 931.75, ["Mega|Fly|Ride"] = 729.75}},
    ["rbxassetid://103241919688695"] = {name = "2025 Birthday Butterfly", prices = {["default"] = 8.7, ["Ride"] = 692.73, ["Neon"] = 20.56, ["Neon|Fly"] = 41.56, ["Neon|Ride"] = 77.05, ["Neon|Fly|Ride"] = 139.18, ["Mega"] = 74.73, ["Mega|Fly"] = 306.38, ["Mega|Fly|Ride"] = 313.53}},
    ["rbxassetid://86594144838863"] = {name = "Tree Frog", prices = {["default"] = 2.1, ["Ride"] = 27.85, ["Neon"] = 2.61, ["Neon|Ride"] = 20.6, ["Mega"] = 21.15, ["Mega|Ride"] = 54.79, ["Mega|Fly|Ride"] = 181.76}},
    ["rbxassetid://99048375832409"] = {name = "Shih Tzu", prices = {["default"] = 2.1, ["Fly"] = 69.6, ["Ride"] = 24.86, ["Fly|Ride"] = 82.52, ["Neon"] = 2.63, ["Neon|Ride"] = 27.36, ["Mega"] = 28.2, ["Mega|Ride"] = 40.29, ["Mega|Fly|Ride"] = 87.93}},
    ["rbxassetid://6998403122"] = {name = "Kirin", prices = {["default"] = 2.1, ["Fly"] = 27.25, ["Ride"] = 72.18, ["Fly|Ride"] = 51.35, ["Neon"] = 7.87, ["Neon|Fly"] = 123.38, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 55.71, ["Mega"] = 61.69, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 139.13}},
    ["rbxassetid://15930472964"] = {name = "Gila Monster", prices = {["default"] = 2.1, ["Ride"] = 27.74, ["Fly|Ride"] = 111.14, ["Neon"] = 13.97, ["Neon|Ride"] = 1312.5, ["Mega"] = 98.44, ["Mega|Ride"] = 106.3, ["Mega|Fly|Ride"] = 249.38}},
    ["rbxassetid://5721843144"] = {name = "Dilophosaurus", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 15.12, ["Fly|Ride"] = 47.25, ["Neon"] = 14.13, ["Neon|Ride"] = 30.14, ["Neon|Fly|Ride"] = 77.58, ["Mega"] = 307.79, ["Mega|Ride"] = 272.35, ["Mega|Fly|Ride"] = 314.99}},
    ["rbxassetid://109520235810036"] = {name = "Mini Schnauzer", prices = {["default"] = 82.57, ["Ride"] = 150.94, ["Neon"] = 196.87, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 1038.57, ["Mega"] = 829.82, ["Mega|Ride"] = 821.97, ["Mega|Fly|Ride"] = 914.99}},
    ["rbxassetid://3181728229"] = {name = "Snow Cat", prices = {["default"] = 2.1, ["Fly"] = 25.98, ["Ride"] = 18.8, ["Fly|Ride"] = 28.88, ["Neon"] = 2.61, ["Neon|Fly"] = 17.07, ["Neon|Ride"] = 19.74, ["Neon|Fly|Ride"] = 51.95, ["Mega"] = 39.48, ["Mega|Ride"] = 69.62, ["Mega|Fly|Ride"] = 98.51}},
    ["rbxassetid://4506925747"] = {name = "Wolf", prices = {["default"] = 9, ["Fly"] = 17.26, ["Ride"] = 41.56, ["Fly|Ride"] = 83.57, ["Neon"] = 35.33, ["Neon|Fly"] = 76.13, ["Neon|Ride"] = 72.05, ["Neon|Fly|Ride"] = 116.82, ["Mega"] = 236.25, ["Mega|Ride"] = 238.98, ["Mega|Fly|Ride"] = 290.54}},
    ["rbxassetid://5862774473"] = {name = "Albino Bat", prices = {["default"] = 14.19, ["Fly"] = 36.37, ["Ride"] = 28.47, ["Fly|Ride"] = 76.86, ["Neon"] = 82.11, ["Neon|Ride"] = 93.97, ["Neon|Fly|Ride"] = 227.07, ["Mega"] = 1173.58, ["Mega|Ride"] = 459.38, ["Mega|Fly|Ride"] = 515.76}},
    ["rbxassetid://14978701751"] = {name = "Scarecrow", prices = {["default"] = 2.52, ["Fly"] = 140.44, ["Ride"] = 276.27, ["Neon"] = 51.93, ["Neon|Ride"] = 83.1, ["Mega"] = 131.25, ["Mega|Ride"] = 246.88, ["Mega|Fly|Ride"] = 410.25}},
    ["rbxassetid://10235589000"] = {name = "Corgi", prices = {["default"] = 2.1, ["Fly"] = 19.69, ["Ride"] = 18.37, ["Fly|Ride"] = 39.38, ["Neon"] = 4.27, ["Neon|Fly"] = 40.52, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 52.94, ["Mega"] = 51.18, ["Mega|Fly"] = 131.25, ["Mega|Ride"] = 61.69, ["Mega|Fly|Ride"] = 131.25}},
    ["rbxassetid://103710623311342"] = {name = "Ghost Chick", prices = {["default"] = 3.94, ["Fly"] = 69.38, ["Ride"] = 28.06, ["Neon"] = 13.13, ["Neon|Fly"] = 118.13, ["Neon|Ride"] = 96.52, ["Mega"] = 127.32, ["Mega|Fly"] = 735, ["Mega|Ride"] = 196.88, ["Mega|Fly|Ride"] = 277.31}},
    ["rbxassetid://4440866423"] = {name = "Cow", prices = {["default"] = 1003.66, ["Fly"] = 1229.66, ["Ride"] = 984.38, ["Fly|Ride"] = 1097.25, ["Neon"] = 2296.88, ["Neon|Ride"] = 2191.85, ["Neon|Fly|Ride"] = 2625, ["Mega|Fly|Ride"] = 7609.88}},
    ["rbxassetid://15093139154"] = {name = "Slime", prices = {["default"] = 80.87, ["Fly"] = 157.37, ["Ride"] = 125.25, ["Fly|Ride"] = 196.88, ["Neon"] = 318.85, ["Neon|Ride"] = 446.25, ["Neon|Fly|Ride"] = 589.91, ["Mega"] = 2812.69, ["Mega|Ride"] = 1940.03, ["Mega|Fly|Ride"] = 1717.26}},
    ["rbxassetid://82170828935980"] = {name = "Dracula Fish", prices = {["default"] = 2.62, ["Ride"] = 20.79, ["Neon"] = 6.57, ["Neon|Ride"] = 52.5, ["Neon|Fly|Ride"] = 207.73, ["Mega"] = 72.1, ["Mega|Fly|Ride"] = 180.72}},
    ["rbxassetid://11109302289"] = {name = "Zombie Wolf", prices = {["default"] = 45.93, ["Fly"] = 144.38, ["Ride"] = 78.51, ["Fly|Ride"] = 258.57, ["Neon"] = 236.25, ["Neon|Ride"] = 274.2, ["Neon|Fly|Ride"] = 372.86, ["Mega"] = 1023.75, ["Mega|Ride"] = 1080.11, ["Mega|Fly|Ride"] = 1089.88}},
    ["rbxassetid://15369729071"] = {name = "Nutcracker Squirrel", prices = {["default"] = 2.63, ["Ride"] = 24.94, ["Fly|Ride"] = 65.63, ["Neon"] = 74.79, ["Neon|Ride"] = 49.45, ["Neon|Fly|Ride"] = 276.27, ["Mega"] = 183.75, ["Mega|Ride"] = 346.41, ["Mega|Fly|Ride"] = 290.81}},
    ["rbxassetid://9800792849"] = {name = "Goat", prices = {["default"] = 252, ["Fly"] = 415.44, ["Ride"] = 277.35, ["Fly|Ride"] = 336.41, ["Neon"] = 1246.28, ["Neon|Ride"] = 1218.24, ["Neon|Fly|Ride"] = 1181.25, ["Mega|Fly|Ride"] = 7269.87}},
    ["rbxassetid://12509687499"] = {name = "Banded Palm Civet", prices = {["default"] = 2.1, ["Fly"] = 71.17, ["Ride"] = 26.23, ["Fly|Ride"] = 202.64, ["Neon"] = 27.87, ["Neon|Ride"] = 54, ["Mega"] = 406.81, ["Mega|Fly"] = 277.31}},
    ["rbxassetid://10381386150"] = {name = "Rhino Beetle", prices = {["default"] = 2.1, ["Neon"] = 20.33, ["Neon|Ride"] = 83.1, ["Mega"] = 332.35, ["Mega|Ride"] = 330.27}},
    ["rbxassetid://130734656883878"] = {name = "Merry Mistletroll", prices = {["default"] = 56.44, ["Ride"] = 93.95, ["Fly|Ride"] = 525, ["Neon"] = 139.18, ["Neon|Ride"] = 392.24, ["Mega"] = 542, ["Mega|Ride"] = 664.69, ["Mega|Fly|Ride"] = 830.86}},
    ["rbxassetid://15923337068"] = {name = "Oryx", prices = {["default"] = 2.1, ["Ride"] = 49.54, ["Neon"] = 19.69, ["Mega"] = 78.75, ["Mega|Ride"] = 250.74, ["Mega|Fly|Ride"] = 458.8}},
    ["rbxassetid://6245080365"] = {name = "Ox", prices = {["default"] = 2.1, ["Fly"] = 18.38, ["Ride"] = 14.44, ["Fly|Ride"] = 27.45, ["Neon"] = 3.63, ["Neon|Fly"] = 17.62, ["Neon|Ride"] = 137.82, ["Neon|Fly|Ride"] = 41.56, ["Mega"] = 24.78, ["Mega|Ride"] = 39.38, ["Mega|Fly|Ride"] = 103.35}},
    ["rbxassetid://13810870050"] = {name = "African Wild Dog", prices = {["default"] = 4331.24, ["Ride"] = 3937.5, ["Fly|Ride"] = 4418.43, ["Neon"] = 31156.55, ["Neon|Fly|Ride"] = 23328.58, ["Mega|Fly|Ride"] = 85853.95}},
    ["rbxassetid://12596400214"] = {name = "Goldfish", prices = {["default"] = 9.64, ["Fly"] = 39.38, ["Ride"] = 56.43, ["Neon"] = 107.63, ["Neon|Ride"] = 103.14, ["Mega"] = 270.04, ["Mega|Ride"] = 213.29, ["Mega|Fly|Ride"] = 341.25}},
    ["rbxassetid://4736656915"] = {name = "Australian Kelpie", prices = {["default"] = 2.1, ["Fly"] = 20.09, ["Ride"] = 16.36, ["Fly|Ride"] = 46.96, ["Neon"] = 13.11, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 31.11, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 131.25, ["Mega|Ride"] = 166.19, ["Mega|Fly|Ride"] = 181.23}},
    ["rbxassetid://3743711305"] = {name = "Crocodile", prices = {["default"] = 459.37, ["Fly"] = 840, ["Ride"] = 509.4, ["Fly|Ride"] = 544.69, ["Neon"] = 1372.81, ["Neon|Ride"] = 1564.07, ["Neon|Fly|Ride"] = 1284.94, ["Mega|Fly|Ride"] = 4899.57}},
    ["rbxassetid://74373220330198"] = {name = "Officer Gibbon", prices = {["default"] = 9.91, ["Ride"] = 23, ["Neon"] = 15.6, ["Neon|Ride"] = 145.69, ["Mega"] = 128.63, ["Mega|Fly|Ride"] = 690.38}},
    ["rbxassetid://18508184138"] = {name = "Peregrine Falcon", prices = {["default"] = 7.13, ["Fly"] = 139.18, ["Ride"] = 997.49, ["Neon"] = 139.18, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 13848.07, ["Mega"] = 413.36, ["Mega|Ride"] = 360.5}},
    ["rbxassetid://92389214029179"] = {name = "Kaijunior", prices = {["default"] = 2.1, ["Fly"] = 52.36, ["Ride"] = 23.55, ["Neon"] = 4.31, ["Neon|Fly"] = 124.68, ["Neon|Ride"] = 78.75, ["Neon|Fly|Ride"] = 98.44, ["Mega"] = 44.63, ["Mega|Ride"] = 74.46, ["Mega|Fly|Ride"] = 255.28}},
    ["rbxassetid://3409443986"] = {name = "Flamingo", prices = {["default"] = 692.73, ["Fly"] = 775.82, ["Ride"] = 639.77, ["Fly|Ride"] = 693.18, ["Neon"] = 2100, ["Neon|Ride"] = 1937.74, ["Neon|Fly|Ride"] = 1910.27}},
    ["rbxassetid://126933432685319"] = {name = "Cattuccino", prices = {["default"] = 6.57, ["Ride"] = 78.74, ["Neon"] = 28.06, ["Neon|Ride"] = 78.69, ["Neon|Fly|Ride"] = 210.2, ["Mega"] = 131.25, ["Mega|Ride"] = 170.29, ["Mega|Fly|Ride"] = 255.93}},
    ["rbxassetid://11631390464"] = {name = "Ermine", prices = {["default"] = 7.88, ["Fly"] = 236.15, ["Ride"] = 63.13, ["Fly|Ride"] = 157.36, ["Neon"] = 66.94, ["Neon|Fly"] = 166.19, ["Neon|Ride"] = 70.41, ["Neon|Fly|Ride"] = 154.22, ["Mega"] = 203.42, ["Mega|Ride"] = 210, ["Mega|Fly|Ride"] = 357.28}},
    ["rbxassetid://4708551221"] = {name = "Emu", prices = {["default"] = 2.1, ["Fly"] = 34.1, ["Ride"] = 19.84, ["Fly|Ride"] = 47.25, ["Neon"] = 13.19, ["Neon|Fly"] = 43.63, ["Neon|Ride"] = 32.51, ["Neon|Fly|Ride"] = 70.88, ["Mega"] = 207.73, ["Mega|Fly"] = 139.18, ["Mega|Fly|Ride"] = 208.85}},
    ["rbxassetid://16088266364"] = {name = "Burning Bunny", prices = {["default"] = 17.06, ["Ride"] = 19.69, ["Neon"] = 117.59, ["Neon|Fly"] = 170.63, ["Neon|Ride"] = 137.11, ["Mega"] = 554.6, ["Mega|Ride"] = 452.82, ["Mega|Fly|Ride"] = 616.88}},
    ["rbxassetid://80832101513100"] = {name = "2026 Birthday Butterfly", prices = {["default"] = 2.1, ["Fly"] = 28.06, ["Neon"] = 4.71, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 39.13, ["Neon|Fly|Ride"] = 208.69, ["Mega"] = 39.38, ["Mega|Ride"] = 65.63, ["Mega|Fly|Ride"] = 274.19}},
    ["rbxassetid://14639007389"] = {name = "Caterpillar", prices = {["default"] = 555.19, ["Ride"] = 525, ["Fly|Ride"] = 677.15, ["Neon"] = 2589.57, ["Neon|Ride"] = 2490.47, ["Neon|Fly|Ride"] = 2700.25, ["Mega|Fly|Ride"] = 7861.88}},
    ["rbxassetid://82920146813845"] = {name = "Little Lamb", prices = {["default"] = 2.1, ["Ride"] = 54.04, ["Fly|Ride"] = 328.19, ["Neon"] = 10.39, ["Neon|Ride"] = 64.32, ["Neon|Fly|Ride"] = 328.13, ["Mega"] = 72.19, ["Mega|Ride"] = 155.96, ["Mega|Fly|Ride"] = 398.02}},
    ["rbxassetid://96424154406922"] = {name = "Crimson Cape", prices = {["default"] = 2.1, ["Ride"] = 41.21, ["Neon"] = 4.47, ["Neon|Fly"] = 139.18, ["Neon|Ride"] = 39.38, ["Neon|Fly|Ride"] = 131.24, ["Mega"] = 45.94, ["Mega|Fly"] = 97.63, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 261.74}},
    ["rbxassetid://109008428989602"] = {name = "Pangolin", prices = {["default"] = 2.1, ["Ride"] = 23.93, ["Neon"] = 5.09, ["Neon|Ride"] = 31.5, ["Neon|Fly|Ride"] = 131.25, ["Mega"] = 44.61, ["Mega|Fly"] = 153.72, ["Mega|Ride"] = 78.74, ["Mega|Fly|Ride"] = 194.22}},
    ["rbxassetid://16722909218"] = {name = "Floral Eggy", prices = {["default"] = 3.83, ["Ride"] = 131.25, ["Neon"] = 18.48, ["Neon|Ride"] = 153.72, ["Mega"] = 227.46, ["Mega|Ride"] = 328.13}},
    ["rbxassetid://76735046136809"] = {name = "Frostbite Cub", prices = {["default"] = 190.98, ["Fly|Ride"] = 157.37, ["Neon"] = 415.44, ["Neon|Ride"] = 1557.84, ["Neon|Fly|Ride"] = 415.44, ["Mega"] = 1523.58, ["Mega|Ride"] = 967.32, ["Mega|Fly|Ride"] = 2348.45}},
    ["rbxassetid://15684947715"] = {name = "Quokka", prices = {["default"] = 18.37, ["Ride"] = 60.47, ["Fly|Ride"] = 116.59, ["Neon"] = 115.4, ["Neon|Ride"] = 131.14, ["Mega"] = 463.74, ["Mega|Ride"] = 367.5, ["Mega|Fly|Ride"] = 525}},
    ["rbxassetid://5721843001"] = {name = "Deinonychus", prices = {["default"] = 3.68, ["Fly"] = 32.81, ["Ride"] = 15.56, ["Fly|Ride"] = 36, ["Neon"] = 23.63, ["Neon|Ride"] = 31.19, ["Neon|Fly|Ride"] = 77.44, ["Mega"] = 118.13, ["Mega|Ride"] = 139.18, ["Mega|Fly|Ride"] = 193.91}},
    ["rbxassetid://16999461770"] = {name = "Inmate Capuchin Monkey", prices = {["default"] = 14.09, ["Ride"] = 64.32, ["Fly|Ride"] = 98.67, ["Neon"] = 89.25, ["Neon|Ride"] = 69.6, ["Mega"] = 157.5, ["Mega|Ride"] = 218.11, ["Mega|Fly|Ride"] = 970.02}},
    ["rbxassetid://119664699815373"] = {name = "Frozen Penguin", prices = {["default"] = 2.1, ["Fly"] = 131.25, ["Ride"] = 20.71, ["Fly|Ride"] = 60.61, ["Neon"] = 23.9, ["Neon|Ride"] = 39.95, ["Neon|Fly|Ride"] = 209.03, ["Mega"] = 164.41, ["Mega|Ride"] = 131.25, ["Mega|Fly|Ride"] = 360.39}},
    ["rbxassetid://5067924307"] = {name = "Business Monkey", prices = {["default"] = 19.69, ["Fly"] = 68.56, ["Ride"] = 30.17, ["Fly|Ride"] = 154.88, ["Neon"] = 228.74, ["Neon|Ride"] = 150.94, ["Neon|Fly|Ride"] = 238.23, ["Mega"] = 986.39, ["Mega|Ride"] = 939.39, ["Mega|Fly|Ride"] = 614.83}},
    ["rbxassetid://126192643157832"] = {name = "Manta Ray", prices = {["default"] = 33.44, ["Fly"] = 874.13, ["Neon"] = 106.32, ["Mega|Ride"] = 590.63}},
    ["rbxassetid://4440866911"] = {name = "Silly Duck", prices = {["default"] = 44.01, ["Fly"] = 115.5, ["Ride"] = 61.74, ["Fly|Ride"] = 159.06, ["Neon"] = 242.82, ["Neon|Fly"] = 436.21, ["Neon|Ride"] = 277.31, ["Neon|Fly|Ride"] = 367.5, ["Mega|Ride"] = 1659.46, ["Mega|Fly|Ride"] = 1141.88}},
    ["rbxassetid://110544962124445"] = {name = "Cake Friend", prices = {["default"] = 52.49, ["Fly"] = 75.18, ["Ride"] = 63, ["Fly|Ride"] = 157.5, ["Neon"] = 153.57, ["Neon|Ride"] = 272.12, ["Neon|Fly|Ride"] = 412.18, ["Mega"] = 537.92, ["Mega|Ride"] = 726.99, ["Mega|Fly|Ride"] = 620.82}},
    ["rbxassetid://16127157068"] = {name = "Rice Cake Rabbit", prices = {["default"] = 19.47, ["Ride"] = 77.9, ["Neon"] = 127.32, ["Mega"] = 821.63, ["Mega|Fly|Ride"] = 663.65}},
    ["rbxassetid://7734900613"] = {name = "Halloween Evil Dachshund", prices = {["default"] = 7.22, ["Fly"] = 410.46, ["Ride"] = 27.57, ["Fly|Ride"] = 76.86, ["Neon"] = 81.5, ["Neon|Ride"] = 65.63, ["Neon|Fly|Ride"] = 165.05, ["Mega"] = 457.46, ["Mega|Ride"] = 366.19, ["Mega|Fly|Ride"] = 459.38}},
    ["rbxassetid://9664282145"] = {name = "Robot", prices = {["default"] = 2.1, ["Fly"] = 17.73, ["Ride"] = 15.41, ["Fly|Ride"] = 33.25, ["Neon"] = 3.84, ["Neon|Fly"] = 32.82, ["Neon|Ride"] = 22.32, ["Neon|Fly|Ride"] = 85.32, ["Mega|Fly"] = 207.73, ["Mega|Ride"] = 57.74, ["Mega|Fly|Ride"] = 203.44}},
    ["rbxassetid://3261465791"] = {name = "Pink Egg", prices = {["default"] = 1732.33}},
    ["rbxassetid://126725051633301"] = {name = "Headless Horse", prices = {["default"] = 33.99, ["Ride"] = 68.56, ["Fly|Ride"] = 118.13, ["Neon"] = 178.65, ["Neon|Ride"] = 223.13, ["Neon|Fly|Ride"] = 554.6, ["Mega"] = 610.67, ["Mega|Ride"] = 590.63, ["Mega|Fly|Ride"] = 684.93}},
    ["rbxassetid://88554799028713"] = {name = "Sneak Weasel", prices = {["default"] = 2.1, ["Ride"] = 54.88, ["Neon"] = 3.91, ["Neon|Ride"] = 42, ["Neon|Fly|Ride"] = 290.81, ["Mega"] = 24.99, ["Mega|Ride"] = 52.5}},
    ["rbxassetid://14639008203"] = {name = "English Sheepdog", prices = {["default"] = 39.38, ["Ride"] = 72.82, ["Neon"] = 128.37, ["Neon|Ride"] = 157.5, ["Neon|Fly|Ride"] = 525, ["Mega"] = 711.38, ["Mega|Ride"] = 720.85, ["Mega|Fly|Ride"] = 861.89}},
    ["rbxassetid://133131190079833"] = {name = "Oakee", prices = {["default"] = 2.1, ["Neon"] = 3.93, ["Neon|Ride"] = 105, ["Mega"] = 28.2}},
    ["rbxassetid://79856043024325"] = {name = "Chestnut Glyptodon", prices = {["default"] = 2.1, ["Neon"] = 6.19, ["Neon|Ride"] = 46.99, ["Mega"] = 23.75, ["Mega|Ride"] = 137.23, ["Mega|Fly|Ride"] = 273}},
    ["rbxassetid://12720028898"] = {name = "Hare", prices = {["default"] = 113.93, ["Fly"] = 153.72, ["Ride"] = 136.5, ["Neon"] = 460.09, ["Neon|Ride"] = 472.49, ["Neon|Fly|Ride"] = 589.99, ["Mega|Ride"] = 2223.98, ["Mega|Fly|Ride"] = 2098.69}},
    ["rbxassetid://16897788024"] = {name = "Capuchin Monkey", prices = {["default"] = 2.1, ["Fly"] = 26.25, ["Ride"] = 19.69, ["Fly|Ride"] = 52.5, ["Neon"] = 14.44, ["Neon|Ride"] = 28.06, ["Neon|Fly|Ride"] = 65.63, ["Mega"] = 90.15, ["Mega|Ride"] = 102.38, ["Mega|Fly|Ride"] = 205.43}},
    ["rbxassetid://121639546210522"] = {name = "Amber Butterfly", prices = {["default"] = 2.1, ["Fly"] = 38.07, ["Ride"] = 64.13, ["Fly|Ride"] = 86.63, ["Neon"] = 6.45, ["Neon|Fly"] = 62.33, ["Neon|Ride"] = 34.13, ["Neon|Fly|Ride"] = 99.49, ["Mega"] = 31.5, ["Mega|Ride"] = 122.78, ["Mega|Fly|Ride"] = 196.88}},
    ["rbxassetid://79005166120532"] = {name = "Jumping Spider", prices = {["default"] = 2.1, ["Neon"] = 4.51, ["Neon|Ride"] = 43.28, ["Mega"] = 25.79, ["Mega|Ride"] = 183.74}},
    ["rbxassetid://138741319376538"] = {name = "Tarantula", prices = {["default"] = 2.1, ["Ride"] = 26.25, ["Neon"] = 4.34, ["Neon|Ride"] = 131.23, ["Mega"] = 52.5, ["Mega|Ride"] = 96.56, ["Mega|Fly|Ride"] = 210}},
    ["rbxassetid://133558151150234"] = {name = "Black Widow", prices = {["default"] = 38.06, ["Ride"] = 103.69, ["Fly|Ride"] = 449.61, ["Neon"] = 415.44, ["Neon|Ride"] = 479.25, ["Neon|Fly|Ride"] = 692.73, ["Mega|Fly|Ride"] = 1786.33}},
    ["rbxassetid://122945704087152"] = {name = "Chilling Spider", prices = {["default"] = 3.29, ["Ride"] = 46.98, ["Fly|Ride"] = 131.25, ["Neon"] = 35.33, ["Neon|Ride"] = 153.25, ["Mega"] = 364.58, ["Mega|Ride"] = 840.67}},
    ["rbxassetid://1373237029"] = {name = "Big Head Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://2657668946"] = {name = "Cure All Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://1373237971"] = {name = "Grow Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4315743582"] = {name = "Honey Badger", prices = {["default"] = 311.07, ["Ride"] = 422.7, ["Fly|Ride"] = 616.88, ["Neon"] = 1659.62, ["Neon|Ride"] = 1523.58, ["Neon|Fly|Ride"] = 1312.5, ["Mega|Fly|Ride"] = 3601.33}},
    ["rbxassetid://1373208271"] = {name = "Hyperspeed Potion", prices = {["default"] = 2.1}},
    ["rbxassetid://4047157976"] = {name = "Fly Potion", prices = {["default"] = 74.82}},
    ["rbxassetid://3342628435"] = {name = "Ride Potion", prices = {["default"] = 44.63}},
    ["rbxassetid://1509389697"] = {name = "Adopt Me Boy Scooter", prices = {["default"] = 18.38}},
    ["rbxassetid://1509384540"] = {name = "Adopt Me Girl Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1256627798"] = {name = "Adopt Me Snowboard 1", prices = {["default"] = 55.61}},
    ["rbxassetid://1256627585"] = {name = "Adopt Me Snowboard 2", prices = {["default"] = 48.47}},
    ["rbxassetid://2782643682"] = {name = "Axel", prices = {["default"] = 10.31}},
    ["rbxassetid://3009779146"] = {name = "Banana Car", prices = {["default"] = 4.45}},
    ["rbxassetid://1306904296"] = {name = "Bathtub", prices = {["default"] = 240.53}},
    ["rbxassetid://1307341557"] = {name = "Bethink Skateboard", prices = {["default"] = 40.27}},
    ["rbxassetid://908269395"] = {name = "Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://1509319125"] = {name = "Black Scooter", prices = {["default"] = 108.84}},
    ["rbxassetid://1306898658"] = {name = "Black Skateboard", prices = {["default"] = 157.34}},
    ["rbxassetid://1256625297"] = {name = "Black Snowboard", prices = {["default"] = 16.64}},
    ["rbxassetid://1266478264"] = {name = "Blue Neon Snowboard", prices = {["default"] = 918.74}},
    ["rbxassetid://4800244517"] = {name = "Blue Rider", prices = {["default"] = 2.1}},
    ["rbxassetid://1509318734"] = {name = "Blue Scooter", prices = {["default"] = 6.33}},
    ["rbxassetid://1306898360"] = {name = "Blue Skateboard", prices = {["default"] = 17.62}},
    ["rbxassetid://1256625905"] = {name = "Blue Snowboard", prices = {["default"] = 12.29}},
    ["rbxassetid://7165481985"] = {name = "Bubble Car", prices = {["default"] = 5.25}},
    ["rbxassetid://12115176522"] = {name = "Toxic Barrel", prices = {["default"] = 9.09}},
    ["rbxassetid://2657667116"] = {name = "Bunny Carriage", prices = {["default"] = 507.68}},
    ["rbxassetid://6475610034"] = {name = "Butterfly Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264167"] = {name = "Camper Van", prices = {["default"] = 2.1}},
    ["rbxassetid://2758237053"] = {name = "Car", prices = {["default"] = 2.1}},
    ["rbxassetid://14465252948"] = {name = "Super Jetpack", prices = {["default"] = 799.43}},
    ["rbxassetid://4754697599"] = {name = "Choo Choo Train", prices = {["default"] = 7.55}},
    ["rbxassetid://2408035766"] = {name = "Cloud", prices = {["default"] = 1704.94}},
    ["rbxassetid://5057099424"] = {name = "Clown Car", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099515"] = {name = "Clown Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750671"] = {name = "Cookie Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8203695278"] = {name = "Snowmobile", prices = {["default"] = 7.87}},
    ["rbxassetid://8243269978"] = {name = "Zamboni", prices = {["default"] = 2.1}},
    ["rbxassetid://1509385561"] = {name = "Cupcake Scooter", prices = {["default"] = 14.44}},
    ["rbxassetid://4822522305"] = {name = "Daisy Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8517689681"] = {name = "Landsailer", prices = {["default"] = 2.1}},
    ["rbxassetid://8566306089"] = {name = "Trireme", prices = {["default"] = 2.1}},
    ["rbxassetid://6504033614"] = {name = "Dino Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://1512774745"] = {name = "Doge Scooter", prices = {["default"] = 28.88}},
    ["rbxassetid://1307341942"] = {name = "Doge Skateboard", prices = {["default"] = 24.94}},
    ["rbxassetid://3486906742"] = {name = "Dogmobile", prices = {["default"] = 53.82}},
    ["rbxassetid://2880427418"] = {name = "Donut Cycle", prices = {["default"] = 18.38}},
    ["rbxassetid://3486907843"] = {name = "Donut Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2782643731"] = {name = "Douglas", prices = {["default"] = 9.17}},
    ["rbxassetid://1509391407"] = {name = "Duck Scooter", prices = {["default"] = 13.02}},
    ["rbxassetid://9291032374"] = {name = "Egg Delivery Machine", prices = {["default"] = 5.88}},
    ["rbxassetid://1509377123"] = {name = "Emoji Scooter", prices = {["default"] = 16.37}},
    ["rbxassetid://9973767611"] = {name = "Harvest Truck", prices = {["default"] = 2.63}},
    ["rbxassetid://9973768669"] = {name = "Tractor", prices = {["default"] = 2.52}},
    ["rbxassetid://1307341332"] = {name = "Fidget Skateboard", prices = {["default"] = 14.44}},
    ["rbxassetid://1306904101"] = {name = "Fissy Skateboard", prices = {["default"] = 14.25}},
    ["rbxassetid://4823285384"] = {name = "Flower Wagon", prices = {["default"] = 4.85}},
    ["rbxassetid://7475653998"] = {name = "Fossil Paw Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://9406027381"] = {name = "Starter Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://6475609765"] = {name = "Futuristic Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291832"] = {name = "Ghost Vehicle", prices = {["default"] = 1824.38}},
    ["rbxassetid://10905638416"] = {name = "Ancient Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760422"] = {name = "Bat Face Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://10919870588"] = {name = "Dapper Friend Carrier", prices = {["default"] = 2.1}},
    ["rbxassetid://8978760559"] = {name = "Dirt Bike Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10967588257"] = {name = "Hot Tub Muscle Car", prices = {["default"] = 44.01}},
    ["rbxassetid://10905207734"] = {name = "Soapy Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9037078630"] = {name = "Horse And Carriage", prices = {["default"] = 298.75}},
    ["rbxassetid://10913434990"] = {name = "Unstable Triangle Car", prices = {["default"] = 8.1}},
    ["rbxassetid://8979306571"] = {name = "Wizard Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1512770654"] = {name = "Glass Scooter", prices = {["default"] = 6.56}},
    ["rbxassetid://1306903971"] = {name = "Glass Skateboard", prices = {["default"] = 926.1}},
    ["rbxassetid://1256627375"] = {name = "Glass Snowboard", prices = {["default"] = 34.55}},
    ["rbxassetid://1064481531"] = {name = "GoKart", prices = {["default"] = 183.75}},
    ["rbxassetid://1509326491"] = {name = "Gold Scooter", prices = {["default"] = 8.91}},
    ["rbxassetid://1306902802"] = {name = "Gold Skateboard", prices = {["default"] = 31.71}},
    ["rbxassetid://1265129435"] = {name = "Gold Snowboard", prices = {["default"] = 166.19}},
    ["rbxassetid://12519249137"] = {name = "Bumper Car", prices = {["default"] = 2.1}},
    ["rbxassetid://12519249424"] = {name = "Circus Ball Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265134428"] = {name = "Green Neon Snowboard", prices = {["default"] = 2072.96}},
    ["rbxassetid://7839195952"] = {name = "Halloween Black Ponycycle", prices = {["default"] = 22.32}},
    ["rbxassetid://11119263404"] = {name = "Headless Horseman's Biplane", prices = {["default"] = 8.6}},
    ["rbxassetid://10920073281"] = {name = "Throwing Knife Target", prices = {["default"] = 2.1}},
    ["rbxassetid://10920073157"] = {name = "Shadow Rider", prices = {["default"] = 15.75}},
    ["rbxassetid://11125166616"] = {name = "Unicorn Zombie Ponycycle", prices = {["default"] = 13.11}},
    ["rbxassetid://2848331544"] = {name = "Heart Hoverboard", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670919"] = {name = "Horse Cycle", prices = {["default"] = 156.19}},
    ["rbxassetid://3163531592"] = {name = "Traveling House", prices = {["default"] = 27.44}},
    ["rbxassetid://4382798606"] = {name = "Hoverboard", prices = {["default"] = 9.7}},
    ["rbxassetid://6475613264"] = {name = "Hovercar", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807001"] = {name = "Human Bubble", prices = {["default"] = 2.1}},
    ["rbxassetid://4588192578"] = {name = "Ice Cream Truck", prices = {["default"] = 23.44}},
    ["rbxassetid://4470749585"] = {name = "Ice Queen Sleigh", prices = {["default"] = 2.1}},
    ["rbxassetid://1509333762"] = {name = "Ice Scooter", prices = {["default"] = 10.41}},
    ["rbxassetid://6504033516"] = {name = "Imagination Box", prices = {["default"] = 3.67}},
    ["rbxassetid://10619155042"] = {name = "Street Racer", prices = {["default"] = 102.38}},
    ["rbxassetid://2749267159"] = {name = "Limo", prices = {["default"] = 2.1}},
    ["rbxassetid://8665606953"] = {name = "Dragon Train", prices = {["default"] = 139.18}},
    ["rbxassetid://11758583286"] = {name = "Crescent Moon Car", prices = {["default"] = 194.22}},
    ["rbxassetid://6276452323"] = {name = "Lunar Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482478"] = {name = "Magical Girl Car", prices = {["default"] = 157.34}},
    ["rbxassetid://7368045552"] = {name = "Magical Princess Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1306902978"] = {name = "Melon Skateboard", prices = {["default"] = 27.57}},
    ["rbxassetid://3009779540"] = {name = "Monocycle", prices = {["default"] = 24.93}},
    ["rbxassetid://1512742703"] = {name = "Mono-Moped", prices = {["default"] = 72.19}},
    ["rbxassetid://2758236960"] = {name = "Moped", prices = {["default"] = 16.59}},
    ["rbxassetid://2758237011"] = {name = "Motorcycle", prices = {["default"] = 2.1}},
    ["rbxassetid://3206264226"] = {name = "Muscle Car", prices = {["default"] = 2.1}},
    ["rbxassetid://1509342852"] = {name = "Neon Black Scooter", prices = {["default"] = 22362.95}},
    ["rbxassetid://1306911569"] = {name = "Neon Black Skateboard", prices = {["default"] = 517.47}},
    ["rbxassetid://1509338320"] = {name = "Neon Blue Scooter", prices = {["default"] = 36.72}},
    ["rbxassetid://1306907175"] = {name = "Neon Blue Skateboard", prices = {["default"] = 78.75}},
    ["rbxassetid://1509342200"] = {name = "Neon Green Scooter", prices = {["default"] = 39.38}},
    ["rbxassetid://1306907671"] = {name = "Neon Green Skateboard", prices = {["default"] = 257.33}},
    ["rbxassetid://1509338451"] = {name = "Neon Orange Scooter", prices = {["default"] = 59.07}},
    ["rbxassetid://1306907450"] = {name = "Neon Orange Skateboard", prices = {["default"] = 60.25}},
    ["rbxassetid://1509339156"] = {name = "Neon Pink Scooter", prices = {["default"] = 66.64}},
    ["rbxassetid://1306911771"] = {name = "Neon Pink Skateboard", prices = {["default"] = 63.56}},
    ["rbxassetid://1509341495"] = {name = "Neon Red Scooter", prices = {["default"] = 30.19}},
    ["rbxassetid://1306907886"] = {name = "Neon Red Skateboard", prices = {["default"] = 103.87}},
    ["rbxassetid://1256625563"] = {name = "Orange Neon Snowboard", prices = {["default"] = 41.95}},
    ["rbxassetid://1509340494"] = {name = "Neon White Scooter", prices = {["default"] = 39.35}},
    ["rbxassetid://1309919907"] = {name = "Neon White Skateboard", prices = {["default"] = 82.06}},
    ["rbxassetid://2860616613"] = {name = "Offroader", prices = {["default"] = 2.1}},
    ["rbxassetid://1265130049"] = {name = "Pink Neon Snowboard", prices = {["default"] = 328.21}},
    ["rbxassetid://1509329807"] = {name = "Pink Scooter", prices = {["default"] = 5.6}},
    ["rbxassetid://1306898507"] = {name = "Pink Skateboard", prices = {["default"] = 17.52}},
    ["rbxassetid://4361545125"] = {name = "Pizza Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://7368040075"] = {name = "Plant Powered Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://9837424665"] = {name = "Rainbow Trail Magic Carpet", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601262"] = {name = "Prince Carriage", prices = {["default"] = 5.25}},
    ["rbxassetid://2854601314"] = {name = "Princess Carriage", prices = {["default"] = 24.94}},
    ["rbxassetid://4115248893"] = {name = "Pumpkin Carriage", prices = {["default"] = 82.67}},
    ["rbxassetid://7475654312"] = {name = "Racing Monoplane", prices = {["default"] = 3.93}},
    ["rbxassetid://10967874847"] = {name = "Galleon", prices = {["default"] = 4.17}},
    ["rbxassetid://10967808228"] = {name = "Old Sail Boat", prices = {["default"] = 2.1}},
    ["rbxassetid://8481992442"] = {name = "RGB Monster Truck", prices = {["default"] = 2.62}},
    ["rbxassetid://8481992324"] = {name = "RGB UFO", prices = {["default"] = 4.62}},
    ["rbxassetid://5882026006"] = {name = "Ribcage Carriage", prices = {["default"] = 8.95}},
    ["rbxassetid://1265128894"] = {name = "Roblox Snowboard", prices = {["default"] = 262.97}},
    ["rbxassetid://4797807111"] = {name = "Rocket Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://7368052482"] = {name = "Rocket Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://1257419042"] = {name = "Rocket Sled", prices = {["default"] = 745.5}},
    ["rbxassetid://4564588042"] = {name = "Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://2854601162"] = {name = "Royal Carriage", prices = {["default"] = 7.88}},
    ["rbxassetid://13741294258"] = {name = "Giant Cheetah Mount", prices = {["default"] = 525}},
    ["rbxassetid://4470749525"] = {name = "Santa's Sleigh", prices = {["default"] = 32.11}},
    ["rbxassetid://4470749209"] = {name = "Sled", prices = {["default"] = 2.1}},
    ["rbxassetid://9342853829"] = {name = "Snow Plow", prices = {["default"] = 2.1}},
    ["rbxassetid://9343367876"] = {name = "Tundra Exploration Machine", prices = {["default"] = 2.1}},
    ["rbxassetid://7165482648"] = {name = "Speedboat", prices = {["default"] = 2.1}},
    ["rbxassetid://12719600101"] = {name = "Daisymobile", prices = {["default"] = 56.07}},
    ["rbxassetid://12792507038"] = {name = "Flower Truck", prices = {["default"] = 69.45}},
    ["rbxassetid://12996592162"] = {name = "Lavender Teapot Carriage", prices = {["default"] = 48.56}},
    ["rbxassetid://12917527253"] = {name = "Rabbit Helicopter", prices = {["default"] = 45.02}},
    ["rbxassetid://12996592079"] = {name = "Rose Petal Carriage", prices = {["default"] = 65.63}},
    ["rbxassetid://12996592010"] = {name = "Royal Crown Carriage", prices = {["default"] = 27.01}},
    ["rbxassetid://6504033423"] = {name = "Squirrel Car", prices = {["default"] = 3.87}},
    ["rbxassetid://6798176757"] = {name = "Standard Roller Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://6797010981"] = {name = "Standard Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://10224002323"] = {name = "Emperor's Chariot", prices = {["default"] = 15.73}},
    ["rbxassetid://10202931873"] = {name = "Orchid Racer", prices = {["default"] = 2.1}},
    ["rbxassetid://10202932215"] = {name = "Hovercraft", prices = {["default"] = 2.1}},
    ["rbxassetid://10224209770"] = {name = "Planetary Core Car", prices = {["default"] = 2.1}},
    ["rbxassetid://10203332627"] = {name = "Medieval Wagon", prices = {["default"] = 3.8}},
    ["rbxassetid://13607580379"] = {name = "Beach Buggy", prices = {["default"] = 4.59}},
    ["rbxassetid://13683681091"] = {name = "Beachgoer", prices = {["default"] = 14.43}},
    ["rbxassetid://13683679951"] = {name = "Crabby Cruiser", prices = {["default"] = 22.32}},
    ["rbxassetid://3579315827"] = {name = "Surfboard", prices = {["default"] = 2.1}},
    ["rbxassetid://3186425945"] = {name = "SUV", prices = {["default"] = 7.88}},
    ["rbxassetid://1614139188"] = {name = "Multi-Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8727492188"] = {name = "Black Cab", prices = {["default"] = 2.63}},
    ["rbxassetid://8727477150"] = {name = "Yellow Taxi Cab", prices = {["default"] = 5.12}},
    ["rbxassetid://2783002443"] = {name = "Tiffany", prices = {["default"] = 16.95}},
    ["rbxassetid://3206264796"] = {name = "Tiny Convertible", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671636"] = {name = "Unicorn Cycle", prices = {["default"] = 174.15}},
    ["rbxassetid://3142180107"] = {name = "Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231299"] = {name = "Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506670"] = {name = "Family Car", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231666"] = {name = "Classic Helicopter", prices = {["default"] = 2.1}},
    ["rbxassetid://8860682054"] = {name = "Classic Boat", prices = {["default"] = 2.63}},
    ["rbxassetid://8859231811"] = {name = "Motorbike", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506795"] = {name = "Off-Road Car", prices = {["default"] = 2.1}},
    ["rbxassetid://9108506884"] = {name = "Open Top Speeder", prices = {["default"] = 2.1}},
    ["rbxassetid://8859231943"] = {name = "Classic Airplane", prices = {["default"] = 2.1}},
    ["rbxassetid://9108507006"] = {name = "Sports Bike", prices = {["default"] = 2.1}},
    ["rbxassetid://8859232022"] = {name = "Tandem Bicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://1265135075"] = {name = "White Neon Snowboard", prices = {["default"] = 1037.53}},
    ["rbxassetid://1509328859"] = {name = "White Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306898856"] = {name = "White Skateboard", prices = {["default"] = 30.13}},
    ["rbxassetid://1256624956"] = {name = "White Snowboard", prices = {["default"] = 157.34}},
    ["rbxassetid://7165482807"] = {name = "Wing Trunk Car", prices = {["default"] = 17.07}},
    ["rbxassetid://8080952782"] = {name = "Festive Deliveries Present Truck", prices = {["default"] = 95.81}},
    ["rbxassetid://8190703270"] = {name = "Festive Deliveries Sleigh", prices = {["default"] = 13.02}},
    ["rbxassetid://7975097837"] = {name = "Festive Ice Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11697121962"] = {name = "Candy Snowmobile", prices = {["default"] = 22.32}},
    ["rbxassetid://11574949668"] = {name = "Giant Snowball", prices = {["default"] = 157.34}},
    ["rbxassetid://11764928443"] = {name = "Gingerbread Sleigh", prices = {["default"] = 288.74}},
    ["rbxassetid://11706055135"] = {name = "Husky Sled", prices = {["default"] = 38.72}},
    ["rbxassetid://11466900358"] = {name = "Icebreaker Ship", prices = {["default"] = 2.1}},
    ["rbxassetid://11768005537"] = {name = "Ice Plane", prices = {["default"] = 7.88}},
    ["rbxassetid://11706157454"] = {name = "Snowblower Toboggan", prices = {["default"] = 24.93}},
    ["rbxassetid://11582939967"] = {name = "Strawberry Shortcake Skates", prices = {["default"] = 2.1}},
    ["rbxassetid://11582928541"] = {name = "Strawberry Shortcake Unicycle", prices = {["default"] = 2.1}},
    ["rbxassetid://4797807321"] = {name = "Witch's Caravan", prices = {["default"] = 2.1}},
    ["rbxassetid://1509321524"] = {name = "Wood Scooter", prices = {["default"] = 7.87}},
    ["rbxassetid://1306899055"] = {name = "Wood Skateboard", prices = {["default"] = 10.41}},
    ["rbxassetid://4361544852"] = {name = "Airplane Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4797806115"] = {name = "Angelic Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671618"] = {name = "Anna Rattle", prices = {["default"] = 7.88}},
    ["rbxassetid://4712355837"] = {name = "Astro Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4115251996"] = {name = "Axe Rattle", prices = {["default"] = 3.87}},
    ["rbxassetid://2657667102"] = {name = "Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779116"] = {name = "Balloons", prices = {["default"] = 2.63}},
    ["rbxassetid://3009779170"] = {name = "Banana Plush", prices = {["default"] = 3.68}},
    ["rbxassetid://3009779233"] = {name = "Banana Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248143"] = {name = "Banjo", prices = {["default"] = 8.33}},
    ["rbxassetid://4470749845"] = {name = "Bauble Balloon", prices = {["default"] = 2.4}},
    ["rbxassetid://5061468615"] = {name = "Briefcase Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://3486907018"] = {name = "Bubblegum Machine Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046064"] = {name = "Bunny Plush", prices = {["default"] = 3.29}},
    ["rbxassetid://4470749083"] = {name = "Candle", prices = {["default"] = 2.62}},
    ["rbxassetid://6710107927"] = {name = "Candy Cannon", prices = {["default"] = 5730.24}},
    ["rbxassetid://3082046250"] = {name = "Carrot Rattle", prices = {["default"] = 2.5}},
    ["rbxassetid://2408035756"] = {name = "Cat Plush", prices = {["default"] = 35.4}},
    ["rbxassetid://3009779289"] = {name = "Caticorn Rattle", prices = {["default"] = 3.73}},
    ["rbxassetid://3082047003"] = {name = "Chick Plush", prices = {["default"] = 7.87}},
    ["rbxassetid://3082046215"] = {name = "Chocolate Bunny Balloon", prices = {["default"] = 3.94}},
    ["rbxassetid://1257271764"] = {name = "Christmas Cat Rattle", prices = {["default"] = 3.65}},
    ["rbxassetid://4470749153"] = {name = "Cookie Dough Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://10979219546"] = {name = "Cotton Candy Stand", prices = {["default"] = 7.76}},
    ["rbxassetid://4115248463"] = {name = "Creepy Balloon", prices = {["default"] = 6.43}},
    ["rbxassetid://2408035767"] = {name = "Croc Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://4115248599"] = {name = "Crossbow Grappling Hook", prices = {["default"] = 6.25}},
    ["rbxassetid://5061468734"] = {name = "Cymbal Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://4822522594"] = {name = "Dandelion Propeller", prices = {["default"] = 9.55}},
    ["rbxassetid://4797806584"] = {name = "Didgeridoo", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779323"] = {name = "Donut Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3454109877"] = {name = "Donut Throw Toy", prices = {["default"] = 136.5}},
    ["rbxassetid://3486907555"] = {name = "Dragon Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779349"] = {name = "Duck Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046102"] = {name = "Easter Bunny Plush", prices = {["default"] = 23.63}},
    ["rbxassetid://1555803323"] = {name = "Egg Rattle", prices = {["default"] = 2.82}},
    ["rbxassetid://2408051109"] = {name = "Elephant Plush", prices = {["default"] = 10.32}},
    ["rbxassetid://4470750254"] = {name = "Elf Plush", prices = {["default"] = 3.84}},
    ["rbxassetid://2657668953"] = {name = "Elf Rattle", prices = {["default"] = 7.66}},
    ["rbxassetid://5882028408"] = {name = "Eyeball Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408035763"] = {name = "Fancy Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052395"] = {name = "Fancy Umbrella", prices = {["default"] = 5.25}},
    ["rbxassetid://3009779377"] = {name = "Flower Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2466291815"] = {name = "Flying Broomstick", prices = {["default"] = 3753.35}},
    ["rbxassetid://3454109803"] = {name = "Football Throw Toy", prices = {["default"] = 5.24}},
    ["rbxassetid://7368042855"] = {name = "Galaxy Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749638"] = {name = "Gift Throw Toy", prices = {["default"] = 2.1}},
    ["rbxassetid://1310513344"] = {name = "Glider", prices = {["default"] = 41.91}},
    ["rbxassetid://6936627177"] = {name = "Golden Maned Unicorn Rattle", prices = {["default"] = 2.63}},
    ["rbxassetid://3142180004"] = {name = "Grappling Hook", prices = {["default"] = 2.46}},
    ["rbxassetid://3486907282"] = {name = "Griffin Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://1419098937"] = {name = "Heart Balloon", prices = {["default"] = 2.24}},
    ["rbxassetid://1419099271"] = {name = "Heart Plushie", prices = {["default"] = 22.32}},
    ["rbxassetid://2848331436"] = {name = "Heart Rattle", prices = {["default"] = 81.37}},
    ["rbxassetid://2657670910"] = {name = "Horse Plush", prices = {["default"] = 3.42}},
    ["rbxassetid://3818347838"] = {name = "Hotdog Stand", prices = {["default"] = 8.33}},
    ["rbxassetid://1555807694"] = {name = "Hugging Egg", prices = {["default"] = 90.03}},
    ["rbxassetid://4470749277"] = {name = "Ice Club Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779419"] = {name = "Ice Cream Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4361546643"] = {name = "Ice Cream Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749342"] = {name = "Ice Pick Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408052390"] = {name = "Inflatable Sword", prices = {["default"] = 2.63}},
    ["rbxassetid://2408051119"] = {name = "Jackhammer", prices = {["default"] = 2.1}},
    ["rbxassetid://3486908136"] = {name = "Kangaroo Pogo", prices = {["default"] = 3.92}},
    ["rbxassetid://4822522509"] = {name = "Lavender Bundle", prices = {["default"] = 3.4}},
    ["rbxassetid://3523677453"] = {name = "Lemonade Stand", prices = {["default"] = 5.24}},
    ["rbxassetid://6475613071"] = {name = "Lime Slice Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051107"] = {name = "Llama Plush", prices = {["default"] = 8.99}},
    ["rbxassetid://4661940658"] = {name = "Magic House Door", prices = {["default"] = 25.91}},
    ["rbxassetid://3009779472"] = {name = "Marsh Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://3009779496"] = {name = "Marsh Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://5057099190"] = {name = "Monkey Pogo", prices = {["default"] = 2.63}},
    ["rbxassetid://5057099046"] = {name = "Monkey Propeller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670913"] = {name = "Noob Balloon", prices = {["default"] = 3.54}},
    ["rbxassetid://3009779607"] = {name = "Octopus Plush", prices = {["default"] = 2.5}},
    ["rbxassetid://4470749788"] = {name = "Ornament Throw Toy", prices = {["default"] = 2.63}},
    ["rbxassetid://2657670921"] = {name = "Phoenix Plush", prices = {["default"] = 14.1}},
    ["rbxassetid://7368034465"] = {name = "Pink Cat Balloon", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544972"] = {name = "Plunger Grappling Hook", prices = {["default"] = 2.1}},
    ["rbxassetid://2408051114"] = {name = "Puppy Plush", prices = {["default"] = 11.82}},
    ["rbxassetid://3082046011"] = {name = "Rabbit Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://2408055079"] = {name = "Rainbow Wand", prices = {["default"] = 6.53}},
    ["rbxassetid://4470749750"] = {name = "Reindeer Leash", prices = {["default"] = 6.24}},
    ["rbxassetid://3009779583"] = {name = "Rocket Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749474"] = {name = "Santa Leash", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750189"] = {name = "Santa Rattle", prices = {["default"] = 4.61}},
    ["rbxassetid://5061468835"] = {name = "Scroll Ingredient", prices = {["default"] = 2.1}},
    ["rbxassetid://6475612857"] = {name = "Shuttle Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://5882028350"] = {name = "Skull Drum", prices = {["default"] = 3.84}},
    ["rbxassetid://4470749413"] = {name = "Sleigh Bells Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://6059308940"] = {name = "Snowball Launcher", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671626"] = {name = "Snowman Plush", prices = {["default"] = 2.1}},
    ["rbxassetid://4470749691"] = {name = "Snowman Rattle", prices = {["default"] = 2.1}},
    ["rbxassetid://4470750120"] = {name = "Sock Chew Toy", prices = {["default"] = 3.62}},
    ["rbxassetid://2408052387"] = {name = "Squid Plush", prices = {["default"] = 6.55}},
    ["rbxassetid://5061468930"] = {name = "Staff Ingredient", prices = {["default"] = 22.3}},
    ["rbxassetid://6768659222"] = {name = "Standard Grappling Hook", prices = {["default"] = 2.62}},
    ["rbxassetid://2408055085"] = {name = "Starpower Wand", prices = {["default"] = 692.73}},
    ["rbxassetid://3009779638"] = {name = "Telescope Pogo", prices = {["default"] = 2.1}},
    ["rbxassetid://4710374217"] = {name = "Tennis Ball", prices = {["default"] = 2.1}},
    ["rbxassetid://4464390422"] = {name = "Turkey Plush", prices = {["default"] = 2.63}},
    ["rbxassetid://3977264097"] = {name = "Unicorn Leash", prices = {["default"] = 12.46}},
    ["rbxassetid://3570154347"] = {name = "Unicorn Plush", prices = {["default"] = 99.53}},
    ["rbxassetid://2408055086"] = {name = "Wooden Pogo", prices = {["default"] = 3.47}},
    ["rbxassetid://4155284126"] = {name = "Zombie Buffalo Plush", prices = {["default"] = 49.11}},
    ["rbxassetid://4880426741"] = {name = "Adventurer's Hood", prices = {["default"] = 3.8}},
    ["rbxassetid://4880426585"] = {name = "Adventurer's Sword", prices = {["default"] = 8.33}},
    ["rbxassetid://5726048254"] = {name = "Amber Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973461"] = {name = "Angel Wings", prices = {["default"] = 984.37}},
    ["rbxassetid://6380734633"] = {name = "Antenna", prices = {["default"] = 2.24}},
    ["rbxassetid://4849972567"] = {name = "Aviators", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973554"] = {name = "Bat Wings", prices = {["default"] = 26.98}},
    ["rbxassetid://6380843886"] = {name = "Bee Hive", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734557"] = {name = "Bee Wings", prices = {["default"] = 4.73}},
    ["rbxassetid://4849973352"] = {name = "Beret", prices = {["default"] = 2.1}},
    ["rbxassetid://5881347869"] = {name = "Bewitched Hat", prices = {["default"] = 3.62}},
    ["rbxassetid://5415514537"] = {name = "Black 5 Panel Cap", prices = {["default"] = 2.1}},
    ["rbxassetid://5415514707"] = {name = "Black Boots", prices = {["default"] = 19.69}},
    ["rbxassetid://5415514845"] = {name = "Black Cozy Hood", prices = {["default"] = 2.1}},
    ["rbxassetid://5415515017"] = {name = "Black Designer Backpack", prices = {["default"] = 55.1}},
    ["rbxassetid://4849975075"] = {name = "Black Fedora", prices = {["default"] = 3.93}},
    ["rbxassetid://5415515284"] = {name = "Black Hightops", prices = {["default"] = 24.93}},
    ["rbxassetid://5415515507"] = {name = "Black Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426690"] = {name = "Black Scarf", prices = {["default"] = 11.11}},
    ["rbxassetid://5415515653"] = {name = "Black Sneakers", prices = {["default"] = 9.4}},
    ["rbxassetid://5444594385"] = {name = "Blue Butterfly Wings", prices = {["default"] = 13.13}},
    ["rbxassetid://4849980085"] = {name = "Blue Cat Ear Headphones", prices = {["default"] = 21.2}},
    ["rbxassetid://5415515800"] = {name = "Blue Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048365"] = {name = "Bone Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4880426624"] = {name = "Briefcase", prices = {["default"] = 2.1}},
    ["rbxassetid://6706595341"] = {name = "Bunny Ear Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975457"] = {name = "Buttoned Ushanka", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978837"] = {name = "Buzz Off! Skateboard", prices = {["default"] = 3.83}},
    ["rbxassetid://5415516304"] = {name = "Cassette", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975557"] = {name = "Chef Hat", prices = {["default"] = 10.5}},
    ["rbxassetid://6380734302"] = {name = "Cherry Earrings", prices = {["default"] = 16.43}},
    ["rbxassetid://6706591422"] = {name = "Chick Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6706592723"] = {name = "Chick Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849975633"] = {name = "Chicken Hat", prices = {["default"] = 11.82}},
    ["rbxassetid://4849972658"] = {name = "Clout Goggles", prices = {["default"] = 3.68}},
    ["rbxassetid://4849975702"] = {name = "Conductor Hat", prices = {["default"] = 7.23}},
    ["rbxassetid://4936545219"] = {name = "Cutlass", prices = {["default"] = 2.1}},
    ["rbxassetid://4849972740"] = {name = "Cyborg Shades", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037745"] = {name = "Daisy Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7601648534"] = {name = "Eco Blue Reusable Bottle Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542826699"] = {name = "Eco Blue Solar Panel Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810947"] = {name = "Eco Brown Branch Headphones", prices = {["default"] = 15.6}},
    ["rbxassetid://7542815049"] = {name = "Eco Brown Hiking Backpack", prices = {["default"] = 51.95}},
    ["rbxassetid://7542816175"] = {name = "Eco Green Leaf Afro", prices = {["default"] = 2.1}},
    ["rbxassetid://7542816369"] = {name = "Eco Green Leaf Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://7542810810"] = {name = "Eco Orange Leaf Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://7542820583"] = {name = "Eco Orange Maple Cape", prices = {["default"] = 4.76}},
    ["rbxassetid://7542810709"] = {name = "Eco Orange Maple Earrings", prices = {["default"] = 6.57}},
    ["rbxassetid://7542817978"] = {name = "Eco Orange Maple Leaf Scarf", prices = {["default"] = 3.84}},
    ["rbxassetid://7542823324"] = {name = "Eco Orange Pumpkin Eyepatch", prices = {["default"] = 10.49}},
    ["rbxassetid://7542824283"] = {name = "Eco Orange Pumpkin Pie Wings", prices = {["default"] = 37.91}},
    ["rbxassetid://7542813412"] = {name = "Eco Red Cranberry Branch Wings", prices = {["default"] = 23.55}},
    ["rbxassetid://7542821672"] = {name = "Eco Red Mushroom Hood", prices = {["default"] = 5.25}},
    ["rbxassetid://6706593596"] = {name = "Egg Barrette", prices = {["default"] = 2.1}},
    ["rbxassetid://6706594347"] = {name = "Egg Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://4850383048"] = {name = "Elf Hat", prices = {["default"] = 82.46}},
    ["rbxassetid://4849976006"] = {name = "Explorer Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://4933495463"] = {name = "Eyepatch", prices = {["default"] = 24.41}},
    ["rbxassetid://6060998776"] = {name = "Festive Tree Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278462"] = {name = "Firey Aura", prices = {["default"] = 7.05}},
    ["rbxassetid://4849979365"] = {name = "First Aid Bag", prices = {["default"] = 2.63}},
    ["rbxassetid://4849976218"] = {name = "Flamenco Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6437127230"] = {name = "Flower Collar", prices = {["default"] = 2.12}},
    ["rbxassetid://6380734218"] = {name = "Flower Crown", prices = {["default"] = 7.86}},
    ["rbxassetid://5415517076"] = {name = "Flowery Hair Bow", prices = {["default"] = 3.84}},
    ["rbxassetid://5726048455"] = {name = "Forgotten Flower", prices = {["default"] = 2.1}},
    ["rbxassetid://6380734014"] = {name = "Froggy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://6060998635"] = {name = "Fur Boots", prices = {["default"] = 6.57}},
    ["rbxassetid://5415517473"] = {name = "Gold Chain", prices = {["default"] = 91.88}},
    ["rbxassetid://5415517604"] = {name = "Gold Circle Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://5415517745"] = {name = "Gold Tiara", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979471"] = {name = "Golden Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730894"] = {name = "Goth Shoes", prices = {["default"] = 129.97}},
    ["rbxassetid://4849976420"] = {name = "Green Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://7368039312"] = {name = "Growing Flower Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4489907389"] = {name = "Halo", prices = {["default"] = 984.27}},
    ["rbxassetid://5444594659"] = {name = "Handheld", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976512"] = {name = "Head Chef", prices = {["default"] = 194.22}},
    ["rbxassetid://5067924536"] = {name = "Head Tie", prices = {["default"] = 6.57}},
    ["rbxassetid://6404037642"] = {name = "Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979572"] = {name = "Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521592"] = {name = "Hoop Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991420"] = {name = "Ice Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991330"] = {name = "Ice Earrings", prices = {["default"] = 2.1}},
    ["rbxassetid://6060991245"] = {name = "Ice Wings", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973617"] = {name = "Jade Moth Wings", prices = {["default"] = 21.17}},
    ["rbxassetid://4849979214"] = {name = "Jeff's Nametag", prices = {["default"] = 45.94}},
    ["rbxassetid://5415517859"] = {name = "Jetpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924626"] = {name = "Kitsune Mask", prices = {["default"] = 3.63}},
    ["rbxassetid://4849973992"] = {name = "Lavender Scarf", prices = {["default"] = 2.1}},
    ["rbxassetid://6380730364"] = {name = "Leaf Wings", prices = {["default"] = 7.87}},
    ["rbxassetid://6380730271"] = {name = "Leprechaun Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4853278902"] = {name = "Luggage", prices = {["default"] = 2.1}},
    ["rbxassetid://5067924890"] = {name = "Monkey King Crown", prices = {["default"] = 51.95}},
    ["rbxassetid://4849977086"] = {name = "Monocle", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979887"] = {name = "Moon Tome", prices = {["default"] = 3.56}},
    ["rbxassetid://4849976759"] = {name = "Morion", prices = {["default"] = 2.1}},
    ["rbxassetid://5726048545"] = {name = "Nautilus Shell Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://4849976912"] = {name = "Ninja Headband", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037449"] = {name = "Orange Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727237"] = {name = "Orange Glasses", prices = {["default"] = 2.63}},
    ["rbxassetid://4849977244"] = {name = "Party Crown", prices = {["default"] = 2.1}},
    ["rbxassetid://5415523249"] = {name = "Pearl Necklace", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727177"] = {name = "Picnic Basket", prices = {["default"] = 2.62}},
    ["rbxassetid://5415518324"] = {name = "Pink 5 Panel Cap", prices = {["default"] = 2.63}},
    ["rbxassetid://5415518474"] = {name = "Pink Boots", prices = {["default"] = 6.71}},
    ["rbxassetid://5444594884"] = {name = "Pink Butterfly Wings", prices = {["default"] = 3.94}},
    ["rbxassetid://4849979637"] = {name = "Pink Cat Ear Headphones", prices = {["default"] = 41.26}},
    ["rbxassetid://5415518613"] = {name = "Pink Designer Backpack", prices = {["default"] = 19.29}},
    ["rbxassetid://4849972826"] = {name = "Pink Heart Glasses", prices = {["default"] = 56.87}},
    ["rbxassetid://5457768184"] = {name = "Pink Hightops", prices = {["default"] = 3.84}},
    ["rbxassetid://5415518811"] = {name = "Pink Instant Camera", prices = {["default"] = 6.86}},
    ["rbxassetid://4849977427"] = {name = "Pink Lotus", prices = {["default"] = 2.1}},
    ["rbxassetid://5415520296"] = {name = "Pink Sneakers", prices = {["default"] = 3.87}},
    ["rbxassetid://4849977514"] = {name = "Pirate Hat", prices = {["default"] = 3.42}},
    ["rbxassetid://5444711861"] = {name = "Platinum Tiara", prices = {["default"] = 26.25}},
    ["rbxassetid://4849977607"] = {name = "Propeller Hat", prices = {["default"] = 101.07}},
    ["rbxassetid://4849972928"] = {name = "Purple Heart Glasses", prices = {["default"] = 2.1}},
    ["rbxassetid://6380727007"] = {name = "Purple Masquerade Mask", prices = {["default"] = 3.93}},
    ["rbxassetid://4849977695"] = {name = "Purple Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://6404037362"] = {name = "Rain Boots", prices = {["default"] = 69.57}},
    ["rbxassetid://5415520831"] = {name = "Rain Hat", prices = {["default"] = 2.63}},
    ["rbxassetid://7498079214"] = {name = "RB Battles Trophy Hat", prices = {["default"] = 2.1}},
    ["rbxassetid://4849977830"] = {name = "Red Beanie", prices = {["default"] = 2.1}},
    ["rbxassetid://6380847814"] = {name = "Red Masquerade Mask", prices = {["default"] = 7.87}},
    ["rbxassetid://5415520972"] = {name = "Red Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521183"] = {name = "Red Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973276"] = {name = "Reindeer Antlers", prices = {["default"] = 3.72}},
    ["rbxassetid://4933495361"] = {name = "Respectful Mustache", prices = {["default"] = 82.57}},
    ["rbxassetid://8151013513"] = {name = "RGB Headset", prices = {["default"] = 2.1}},
    ["rbxassetid://4849978102"] = {name = "Rose", prices = {["default"] = 2.1}},
    ["rbxassetid://4933495425"] = {name = "Ruff", prices = {["default"] = 68.56}},
    ["rbxassetid://4850382817"] = {name = "Santa Hat", prices = {["default"] = 406.88}},
    ["rbxassetid://5881348094"] = {name = "Scythe", prices = {["default"] = 3.78}},
    ["rbxassetid://4853278537"] = {name = "Shadow Aura", prices = {["default"] = 126.87}},
    ["rbxassetid://4849980009"] = {name = "Shadow Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://4849973681"] = {name = "Shadow Wings", prices = {["default"] = 131.14}},
    ["rbxassetid://4849972466"] = {name = "Shark Fin", prices = {["default"] = 3.92}},
    ["rbxassetid://4849973100"] = {name = "Shuriken", prices = {["default"] = 2.1}},
    ["rbxassetid://5415521379"] = {name = "Silver Chain", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974099"] = {name = "Skeleton Shell", prices = {["default"] = 2.1}},
    ["rbxassetid://4849974434"] = {name = "Spike Collar", prices = {["default"] = 34.55}},
    ["rbxassetid://6380723429"] = {name = "Strawberry Hat", prices = {["default"] = 59.16}},
    ["rbxassetid://4849975162"] = {name = "Sun Tome", prices = {["default"] = 2.62}},
    ["rbxassetid://4849976090"] = {name = "Sushi Skateboard", prices = {["default"] = 41.91}},
    ["rbxassetid://4849976985"] = {name = "Turtle Shell", prices = {["default"] = 3.81}},
    ["rbxassetid://4849978035"] = {name = "Watermelon Backpack", prices = {["default"] = 18.37}},
    ["rbxassetid://5415522308"] = {name = "White Designer Backpack", prices = {["default"] = 10.28}},
    ["rbxassetid://5415522533"] = {name = "White Purse", prices = {["default"] = 2.1}},
    ["rbxassetid://4849979019"] = {name = "Windup Key", prices = {["default"] = 28.88}},
    ["rbxassetid://4849977314"] = {name = "Witch Hat", prices = {["default"] = 22.68}},
    ["rbxassetid://4849978608"] = {name = "Wizard Hat", prices = {["default"] = 5.25}},
    ["rbxassetid://5415522859"] = {name = "Yellow Designer Backpack", prices = {["default"] = 2.1}},
    ["rbxassetid://5415522973"] = {name = "Yellow Instant Camera", prices = {["default"] = 16.21}},
    ["rbxassetid://5415523115"] = {name = "Yellow Sneakers", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277758"] = {name = "Airplane Stroller", prices = {["default"] = 155.8}},
    ["rbxassetid://2657667120"] = {name = "Baby Basket Stroller", prices = {["default"] = 66.85}},
    ["rbxassetid://2761277454"] = {name = "Balloon Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://3009779202"] = {name = "Banana Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3082046286"] = {name = "Bunny Stroller", prices = {["default"] = 43.32}},
    ["rbxassetid://3009779260"] = {name = "Cannon Stroller", prices = {["default"] = 3.93}},
    ["rbxassetid://3269748269"] = {name = "Car Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6475616233"] = {name = "Catapult Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4115248341"] = {name = "Cauldron Stroller", prices = {["default"] = 7.76}},
    ["rbxassetid://2408051111"] = {name = "Cradle Stroller", prices = {["default"] = 82.85}},
    ["rbxassetid://4361544460"] = {name = "Crate Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://3486905775"] = {name = "Dog House Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1408016951"] = {name = "Double Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://1406692267"] = {name = "Droplet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277656"] = {name = "Duck Stroller", prices = {["default"] = 36.75}},
    ["rbxassetid://3082046174"] = {name = "Easter Egg Stroller", prices = {["default"] = 47.25}},
    ["rbxassetid://2761277703"] = {name = "Egg Stroller", prices = {["default"] = 1976.38}},
    ["rbxassetid://4822522123"] = {name = "Flower Stroller", prices = {["default"] = 6.54}},
    ["rbxassetid://3009779395"] = {name = "French Fries Stroller", prices = {["default"] = 11.02}},
    ["rbxassetid://3082046130"] = {name = "Half Egg Stroller", prices = {["default"] = 35.44}},
    ["rbxassetid://3486906113"] = {name = "Hatched Egg Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2848462165"] = {name = "Heart Stroller", prices = {["default"] = 436.21}},
    ["rbxassetid://6475613319"] = {name = "High Heel Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6967530077"] = {name = "Hover Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670917"] = {name = "Ice Cream Stroller", prices = {["default"] = 18.37}},
    ["rbxassetid://3486906383"] = {name = "Kangaroo Stroller", prices = {["default"] = 7.87}},
    ["rbxassetid://7368046225"] = {name = "Lunar Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936630605"] = {name = "Magic Carpet Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936629525"] = {name = "Magic Moon Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6309085791"] = {name = "Palanquin Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936631399"] = {name = "Pelican Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657670918"] = {name = "Pizza Stroller", prices = {["default"] = 18.37}},
    ["rbxassetid://3009779443"] = {name = "Popsicle Stroller", prices = {["default"] = 14.04}},
    ["rbxassetid://6936628317"] = {name = "Princess Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://5882036757"] = {name = "Pumpkin Stroller", prices = {["default"] = 3.94}},
    ["rbxassetid://2408052388"] = {name = "Quad Stroller", prices = {["default"] = 257.25}},
    ["rbxassetid://2408035750"] = {name = "Race Car Stroller", prices = {["default"] = 49.86}},
    ["rbxassetid://6710108407"] = {name = "Rainbow Stroller", prices = {["default"] = 42.78}},
    ["rbxassetid://4470748252"] = {name = "Reindeer Stroller", prices = {["default"] = 102.69}},
    ["rbxassetid://8526099597"] = {name = "RGB Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2981204560"] = {name = "Rocket Ship Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://13986982302"] = {name = "Shopping Cart Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://6936628967"] = {name = "Teacup Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2982964426"] = {name = "Throne Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2657671637"] = {name = "Trike Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://4361544584"] = {name = "Triple Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://2761277803"] = {name = "Unicorn Stroller", prices = {["default"] = 67.48}},
    ["rbxassetid://2466291803"] = {name = "Vampire Stroller", prices = {["default"] = 117.36}},
    ["rbxassetid://3066606234"] = {name = "Wheelbarrow Stroller", prices = {["default"] = 2.1}},
    ["rbxassetid://113061955717247"] = {name = "Admin Abuse Box", prices = {["default"] = 2.1}},
    ["rbxassetid://5888839551"] = {name = "Bat Box", prices = {["default"] = 95.55}},
    ["rbxassetid://4510471983"] = {name = "Golden Gift", prices = {["default"] = 1155}},
    ["rbxassetid://5057100696"] = {name = "Monkey Box", prices = {["default"] = 157.25}},
    ["rbxassetid://6240246974"] = {name = "Ox Box", prices = {["default"] = 8.33}},
    ["rbxassetid://5067925110"] = {name = "Premium Monkey Box", prices = {["default"] = 2756.25}},
    ["rbxassetid://4621220017"] = {name = "Rat Box", prices = {["default"] = 393.75}},
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